# Golden Age Politics reproduction materials

This repository contains reproduction and documentation materials for:

**Golden Age Politics: A Computational-Interpretive Analysis of the "Gouden Eeuw" as a Trope in Dutch Parliamentary Speech, 1945-2024**  
Stefan Couperus and Martijn Schoonvelde

The chapter studies how Dutch MPs use "Gouden Eeuw" language as a mnemonic trope in parliamentary speech. The workflow combines dictionary and embedding-assisted retrieval with human validation and LLM-assisted interpretive coding.

## Quick start

From the repository root:

```sh
Rscript scripts/run_all.R
```

This default command uses only the included derived data. It regenerates:

- `outputs/tables/analysis_summary.csv`
- `outputs/tables/tg_sw_matrix_long.csv`
- `outputs/tables/tg_sw_matrix_wide.csv`
- `outputs/tables/top3_tg_sw_by_period.csv`
- `outputs/tables/validation_metrics_all.csv`
- `outputs/figures/tg_sw_matrix.png`
- `outputs/figures/top3_tg_sw_by_period.png`
- `outputs/figures/annual_temporal_grammar_counts.png`
- `outputs/figures/party_temporal_grammar_counts.png`

## Repository structure

- `data/derived/ge_final_45_24.csv`: final analytic dataset used by the default reproduction scripts.
- `data/candidate/df_ge_high.csv`: 572 candidate speeches retrieved before final inclusion filtering.
- `data/validation/human_o3_validation_44.csv`: human-vs-o3 validation set used by `scripts/02_validate_llm_coding.R`.
- `data/validation/model_comparison_human_o3_gpt52.csv`: supplementary human/model comparison file from the model selection stage.
- `prompts/annotation_prompt.txt`: exact annotation prompt/codebook used for LLM-assisted coding.
- `scripts/`: path-independent R scripts.
- `R/`: shared helper functions.
- `docs/`: methodology, data dictionary, codebook, and LLM-use disclosure.
- `docs/verification.md`: local verification notes for the GitHub-ready folder.
- `outputs/`: regenerated figures and tables.

## Reproduction scope

The included materials support direct reproduction of the chapter's derived-data summaries and validation checks without any local path edits. The original full parliamentary corpus and large intermediate objects are not committed here because they are too large for a normal GitHub repository and partly derive from external data sources.

To rerun full-corpus retrieval, place raw corpus CSVs in:

```text
data/raw/df_speeches_1945_2012_non_semanticized.csv
data/raw/df_speeches_2013_2024_non_semanticized.csv
```

or set:

```sh
GE_RAW_1945_2012=/path/to/file.csv
GE_RAW_2013_2024=/path/to/file.csv
Rscript scripts/04_full_corpus_retrieval_optional.R
```

The optional API annotation workflow is off by default. To run it:

```sh
RUN_OPENAI_ANNOTATION=true OPENAI_API_KEY=... Rscript scripts/03_run_llm_annotation_optional.R
```

Do not store API keys in this repository.

## Software

The default scripts require R and these packages: `dplyr`, `ggplot2`, `readr`, and `tidyr`. Optional workflows additionally use `data.table`, `ellmer`, `jsonlite`, `quanteda`, `quanteda.textstats`, `stringr`, and `word2vec`.

Run:

```sh
Rscript scripts/00_check_environment.R
```

to check the local R environment.

## LLM-use reporting

The file `docs/llm_use_disclosure.md` documents LLM use following the GUIDE-LLM reporting framework from Feuerriegel et al. (2026), DOI: `10.1038/s41562-026-02492-7`.

## Data note

The final analytic file included here contains 447 speeches with a coded "Gouden Eeuw" trope. The candidate file contains 572 retrieved speeches before final inclusion filtering.
