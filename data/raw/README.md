# Raw corpus files

Raw parliamentary corpus files are not committed to this GitHub-ready folder.

To run `scripts/04_full_corpus_retrieval_optional.R`, place the raw corpus files here with these names:

```text
df_speeches_1945_2012_non_semanticized.csv
df_speeches_2013_2024_non_semanticized.csv
```

Alternatively, keep the files elsewhere and set:

```sh
GE_RAW_1945_2012=/path/to/df_speeches_1945_2012_non_semanticized.csv
GE_RAW_2013_2024=/path/to/df_speeches_2013_2024_non_semanticized.csv
```

The default reproduction scripts do not require these raw files.
