# Verification Notes

## Metadata update, 2026-09-11

```sh
python3 tests/test_metadata_corrections.py --baseline 05c5f4e
Rscript --vanilla scripts/run_all.R
```

The metadata checks and default reproduction passed. Comparison with the
previous Git version confirmed that all original cells except the reviewed
metadata, plus the documented new context columns, are preserved. Human/model
validation files are unchanged. Only the party table and party figure changed
among the reproduction outputs; the regenerated party figure was inspected.
See the [metadata audit](metadata_corrections.md) for the sources and changes.

The subsequent all-speaker biography review corrected Verbeek's 1984 role to
`senator` in the analytic and candidate CSV files. The same preservation checks
and default reproduction pass with eleven reviewed corrections. No analytical
output changes result from this additional role correction.

The later name synchronization writes reviewed names and profile links into
all 447 analytic records and matching candidate/validation-sample records.
Original labels are preserved in separate columns. The preservation checks
also verify these name assignments and Verbeek's provisional-retention note.
All analytical outputs remain unchanged after this synchronization.

## Earlier verification, 2026-06-16

Checks performed:

```sh
Rscript --vanilla GitHub_ge/scripts/run_all.R
Rscript --vanilla -e 'files <- list.files("GitHub_ge", pattern="[.]R$", recursive=TRUE, full.names=TRUE); for (f in files) parse(f)'
rg -n "(/[U]sers|Desktop/[T]EMPORA|OPENAI_[A]PI_KEY.txt|QTAwith[G]PT|admin[k]ey|api[k]ey|api_[k]ey|setwd\\(|[D]ownloads|GE_[R]eproduction_Materials)" GitHub_ge
find GitHub_ge -type f -size +50M -exec ls -lh {} +
```

Results:

- Default reproduction completed successfully.
- R scripts parsed successfully.
- No local user paths or committed key-file references were found.
- No files larger than 50 MB were found.
- Folder size after regenerated outputs: approximately 10 MB.

Expected optional-script behaviour:

- `scripts/03_run_llm_annotation_optional.R` exits without API calls unless `RUN_OPENAI_ANNOTATION=true` and `OPENAI_API_KEY` are set.
- `scripts/04_full_corpus_retrieval_optional.R` stops with a clear message unless the raw corpus files are supplied under `data/raw/` or through environment variables.
