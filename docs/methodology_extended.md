# Extended Methodology

## Corpus

The analysis uses Dutch Tweede Kamer parliamentary speeches from 1945 to 2024. The historical part of the corpus was based on the parliamentary speech dataset assembled by Marx et al. for 1945-2012. The recent part was constructed from official parliamentary proceedings available through `zoek.officielebekendmakingen.nl` for 2013-2024. The combined corpus contains approximately 3 million speeches after harmonising the metadata fields used in the analysis.

The raw full corpus is not included in this GitHub-ready folder. The final analytic and validation files needed for the default reproduction scripts are included under `data/`.

## Retrieval

The retrieval workflow identifies speeches that reference the "Gouden Eeuw" cluster. The original workflow:

1. Tokenised speeches in R after lowercasing text and removing punctuation, symbols, URL material, and separators.
2. Removed Dutch stopwords.
3. Compounded relevant collocations and Golden Age-related phrases, including VOC, Michiel de Ruyter, and Synode van Dordrecht variants.
4. Built an initial seed list from literature-informed direct signifiers such as "gouden eeuw", "zeventiende eeuw", "17de eeuw", and "voc".
5. Trained a word2vec model on the parliamentary corpus.
6. Used the centroid of seed-term embeddings to identify near-neighbour variants.
7. Applied the expanded dictionary to the full corpus.

This produced 572 candidate speeches in `data/candidate/df_ge_high.csv`.

## Inclusion Rule

Candidate speeches were not automatically treated as trope uses. A speech was included for interpretive coding only when a "Gouden Eeuw" reference did argumentative or evaluative work in parliamentary interaction. Purely factual or informational historical references were excluded.

The final analytic dataset included here, `data/derived/ge_final_45_24.csv`, contains 447 speeches that passed the inclusion rule and were assigned temporal-grammar and symbolic-work codes.

## Coding

The coding scheme has two main tiers:

- **Temporal grammar**: how the speech links the Golden Age past to present or future politics.
- **Symbolic work**: what the invocation does in parliamentary interaction.

The codebook distinguishes four main temporal grammars: continuity, return, break, and struggle. It also allows a residual TG5 category for threshold cases. TG5 cases are excluded from the final analytic dataset.

The symbolic-work layer distinguishes governing legitimation, competitive positioning, identity and boundary making, moral memory, and a residual SW5 category.

See `docs/codebook.md` and `prompts/annotation_prompt.txt` for the operational definitions used in LLM-assisted coding.

## Human Validation And Model Selection

Both authors independently coded a validation subsample and resolved disagreements into adjudicated human labels. OpenAI model outputs were then compared against this benchmark. The local materials include:

- `data/validation/human_o3_validation_44.csv`: a 44-row validation set comparing adjudicated human labels with final o3 labels.
- `data/validation/model_comparison_human_o3_gpt52.csv`: a supplementary comparison file from the model selection stage.

Run:

```sh
Rscript scripts/02_validate_llm_coding.R
```

to regenerate validation metrics from the included files.

## Software

The workflow was implemented in R with packages including `data.table`, `dplyr`, `ellmer`, `ggplot2`, `lubridate`, `quanteda`, `readr`, `tidyr`, and `word2vec`. The default reproduction scripts require only a subset of those packages.

## Reproducibility Note

The default scripts reproduce analyses from the included derived data and do not require local path edits. Full-corpus retrieval requires access to the raw parliamentary corpus files. The optional LLM annotation script requires an OpenAI API key supplied through the `OPENAI_API_KEY` environment variable.
