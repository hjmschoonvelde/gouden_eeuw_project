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
REGISTRY = json.loads((ROOT / "data/metadata/speaker_profiles.json").read_text())
ASSIGNMENTS = {entry["speech_id"]: entry for entry in REGISTRY["speeches"]}
PEOPLE = {entry["person_id"]: entry for entry in REGISTRY["people"]}
TARGETS = {
    "data/derived/ge_final_45_24.csv": (447, 11),
    "data/candidate/df_ge_high.csv": (572, 11),
    "data/validation/df_ge_high_sample.csv": (58, 2),
}
CONTEXT = {"speaking_capacity", "parliamentary_group_as_recorded", "sample_scope_note"}
NAME_FIELDS = {"speaker_original", "speaker_source_label", "speaker_person_id", "speaker_profile_url"}


def read_csv(text):
    reader = csv.DictReader(io.StringIO(text, newline=""))
    return reader.fieldnames, list(reader)


def column_name(key, header):
    return "function" if key == "function." and "function" in header else key


def run(baseline):
    assert len(CORRECTIONS) == len(LEDGER["corrections"]) == 11
    assert len(ASSIGNMENTS) == len(REGISTRY["speeches"]) == 447
    assert len(PEOPLE) == len(REGISTRY["people"]) == 244
    for relative, (expected_rows, expected_matches) in TARGETS.items():
        header, rows = read_csv((ROOT / relative).read_bytes().decode("utf-8"))
        ids = [r["speech_id"] for r in rows]
        assert len(rows) == len(set(ids)) == expected_rows
        assert len(set(ids) & CORRECTIONS.keys()) == expected_matches
        for row in rows:
            entry = CORRECTIONS.get(row["speech_id"])
            assignment = ASSIGNMENTS.get(row["speech_id"])
            person = PEOPLE[assignment["person_id"]] if assignment else None
            if entry:
                for key, value in entry["updates"].items():
                    field = "speaker_source_label" if key == "speaker" else column_name(key, header)
                    assert row[field] == value, (relative, row["speech_id"], key)
                assert row["date"] == entry["expected"]["date"]
            if person:
                assert row["speaker"] == person["display_name"]
                assert row["speaker_person_id"] == person["person_id"]
                assert row["speaker_profile_url"] == person["profile_url"]
                for key, expected in assignment["expected"].items():
                    actual = row["speaker_source_label" if key == "speaker" else key]
                    assert actual == expected or (expected is None and actual in ("", "NA")), (relative, row["speech_id"], key)
            else:
                assert row["speaker_person_id"] == row["speaker_profile_url"] == ""
                assert row["speaker_source_label"] == row["speaker"]
            original_speaker = entry["expected"]["speaker"] if entry else row["speaker_source_label"]
            assert row["speaker_original"] == original_speaker
            for key in CONTEXT & set(header):
                assert row[key] == (entry or {}).get("updates", {}).get(key, "")
        if baseline:
            original = subprocess.check_output(
                ["git", "show", f"{baseline}:{relative}"], cwd=ROOT
            ).decode("utf-8")
            old_header, old_rows = read_csv(original)
            assert [r["speech_id"] for r in old_rows] == ids
            assert header[:len(old_header)] == old_header
            expected_extra = NAME_FIELDS | {"sample_scope_note"}
            if expected_matches == 11:
                expected_extra |= CONTEXT
            assert set(header) - set(old_header) == expected_extra
            for before, after in zip(old_rows, rows):
                updates = CORRECTIONS.get(before["speech_id"], {}).get("updates", {})
                updates = {column_name(k, old_header): v for k, v in updates.items()}
                assignment = ASSIGNMENTS.get(before["speech_id"])
                if assignment:
                    updates["speaker"] = PEOPLE[assignment["person_id"]]["display_name"]
                for key in old_header:
                    assert after[key] == updates.get(key, before[key]), (relative, before["speech_id"], key)
        matches = sum(row["speech_id"] in ASSIGNMENTS for row in rows)
        assert matches == (45 if expected_rows == 58 else 447)
        print(f"PASS: {relative}: {expected_rows} records, {expected_matches} metadata repairs, {matches} verified names")

    _, final = read_csv((ROOT / "data/derived/ge_final_45_24.csv").read_bytes().decode("utf-8"))
    assert Counter(r["role"] for r in final) == {"mp": 375, "government": 70, "mep": 1, "senator": 1}
    assert len({r["speaker_person_id"] for r in final}) == 244
    retained = next(r for r in final if r["role"] == "senator")
    assert retained["speaker"] == "Jan Verbeek" and retained["include_for_coding"] == "TRUE"
    assert "retained provisionally" in retained["sample_scope_note"]
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
