"""Apply the reviewed government metadata to matching published speech IDs.

Uses the checked-in review ledger, never a live biography lookup. Re-running is
safe: existing metadata must match either the reviewed baseline or the updates.
All other cells, row order, and analytical decisions are retained.
"""
import csv
import io
import json
from pathlib import Path

csv.field_size_limit(10_000_000)
ROOT = Path(__file__).resolve().parents[1]
LEDGER = json.loads((ROOT / 'data/metadata/government_metadata.json').read_text())
REVIEW = {entry['speech_id']: entry for entry in LEDGER['speeches']}
ADDED = (
    'government_position_nl', 'government_position_start',
    'government_position_end', 'government_metadata_source',
)
TARGETS = {
    'data/derived/ge_final_45_24.csv': (447, 70),
    'data/candidate/df_ge_high.csv': (572, 70),
    'data/validation/df_ge_high_sample.csv': (58, 5),
}

def prepare(relative, expected_rows, expected_matches):
    path = ROOT / relative
    reader = csv.DictReader(io.StringIO(path.read_text(), newline=''))
    original_header = reader.fieldnames
    rows = list(reader)
    assert len(rows) == expected_rows
    assert len({row['speech_id'] for row in rows}) == expected_rows
    header = original_header + [key for key in ('speaking_capacity', *ADDED) if key not in original_header]
    matches = 0
    for row in rows:
        entry = REVIEW.get(row['speech_id'])
        if entry:
            matches += 1
            assert row['speaker_person_id'] == entry['person_id']
            for key, before in entry['expected'].items():
                if key in original_header:
                    missing_party = key == 'party_ref' and row[key] in ('', 'NA') and before in ('', 'NA')
                    assert missing_party or row[key] in (before, entry['updates'].get(key, before)), (relative, row['speech_id'], key)
            for key in ADDED:
                assert row.get(key, '') in ('', entry['updates'][key]), (relative, row['speech_id'], key)
            row.update(entry['updates'])
        for key in header:
            row.setdefault(key, '')
    assert matches == expected_matches
    output = io.StringIO(newline='')
    writer = csv.DictWriter(output, fieldnames=header, lineterminator='\n')
    writer.writeheader()
    writer.writerows(rows)
    # Serialization must preserve every logical cell, including multiline text.
    assert list(csv.DictReader(io.StringIO(output.getvalue(), newline=''))) == rows
    return path, output.getvalue(), matches

if __name__ == '__main__':
    outputs = [prepare(relative, *counts) for relative, counts in TARGETS.items()]
    for path, text, matches in outputs:
        path.write_text(text, newline='')
        print(f'Updated {matches} reviewed government contributions in {path.relative_to(ROOT)}')
