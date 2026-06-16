# Verification Notes

Last checked in this workspace on 2026-06-16.

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
