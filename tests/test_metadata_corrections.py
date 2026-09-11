"""Check the published metadata and, optionally, preservation against Git history.

    python3 tests/test_metadata_corrections.py --baseline 05c5f4e

Uses only the Python standard library. The baseline comparison needs Git history.
"""
import argparse
import csv
import io
import json
import subprocess
from collections import Counter
from pathlib import Path

csv.field_size_limit(10_000_000)
ROOT = Path(__file__).resolve().parents[1]
LEDGER = json.loads((ROOT / "data/metadata/metadata_corrections.json").read_text())
CORRECTIONS = {entry["speech_id"]: entry for entry in LEDGER["corrections"]}
TARGETS = {
    "data/derived/ge_final_45_24.csv": (447, 11),
    "data/candidate/df_ge_high.csv": (572, 11),
    "data/validation/df_ge_high_sample.csv": (58, 2),
}
CONTEXT = {"speaking_capacity", "parliamentary_group_as_recorded"}


def read_csv(text):
    reader = csv.DictReader(io.StringIO(text, newline=""))
    return reader.fieldnames, list(reader)


def column_name(key, header):
    return "function" if key == "function." and "function" in header else key


def run(baseline):
    assert len(CORRECTIONS) == len(LEDGER["corrections"]) == 11
    for relative, (expected_rows, expected_matches) in TARGETS.items():
        header, rows = read_csv((ROOT / relative).read_bytes().decode("utf-8"))
        ids = [r["speech_id"] for r in rows]
        assert len(rows) == len(set(ids)) == expected_rows
        assert len(set(ids) & CORRECTIONS.keys()) == expected_matches
        for row in rows:
            entry = CORRECTIONS.get(row["speech_id"])
            if entry:
                for key, value in entry["updates"].items():
                    assert row[column_name(key, header)] == value, (relative, row["speech_id"], key)
                assert row["date"] == entry["expected"]["date"]
            for key in CONTEXT & set(header):
                assert row[key] == (entry or {}).get("updates", {}).get(key, "")
        if baseline:
            original = subprocess.check_output(
                ["git", "show", f"{baseline}:{relative}"], cwd=ROOT
            ).decode("utf-8")
            old_header, old_rows = read_csv(original)
            assert [r["speech_id"] for r in old_rows] == ids
            assert header[:len(old_header)] == old_header
            expected_extra = CONTEXT if expected_matches == 11 else set()
            assert set(header) - set(old_header) == expected_extra
            for before, after in zip(old_rows, rows):
                updates = CORRECTIONS.get(before["speech_id"], {}).get("updates", {})
                updates = {column_name(k, old_header): v for k, v in updates.items()}
                for key in old_header:
                    assert after[key] == updates.get(key, before[key]), (relative, before["speech_id"], key)
        print(f"PASS: {relative}: {expected_rows} records, {expected_matches} reviewed corrections")

    _, final = read_csv((ROOT / "data/derived/ge_final_45_24.csv").read_bytes().decode("utf-8"))
    assert Counter(r["role"] for r in final) == {"mp": 375, "government": 70, "mep": 1, "senator": 1}
    assert all(r["party_ref"] not in ("", "NA") for r in final if r["role"] != "government")
    assert Counter(r["temporal_grammar_code"] for r in final) == {"TG1": 258, "TG2": 66, "TG3": 68, "TG4": 55}
    assert Counter(r["symbolic_work_code"] for r in final) == {"SW1": 287, "SW2": 88, "SW3": 33, "SW4": 35, "SW5": 4}
    if baseline:
        for relative in (
            "data/validation/human_o3_validation_44.csv",
            "data/validation/model_comparison_human_o3_gpt52.csv",
        ):
            original = subprocess.check_output(["git", "show", f"{baseline}:{relative}"], cwd=ROOT)
            assert (ROOT / relative).read_bytes() == original, relative
        print("PASS: all original cells except reviewed metadata, row order and validation labels preserved")
    print("PASS: corrected role totals, party completeness and unchanged TG/SW distributions")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--baseline", help="Git revision before the metadata repairs")
    run(parser.parse_args().baseline)
