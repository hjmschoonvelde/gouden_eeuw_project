# Data Dictionary

## `data/derived/ge_final_45_24.csv`

Final analytic dataset used by the default reproduction scripts. It contains 447 speeches coded as "Gouden Eeuw" trope uses.

Key columns:

- `speech_id`: unique speech identifier.
- `speaker`: speaker name.
- `function.`: speaker function as recorded in source metadata.
- `role`: parliamentary role category.
- `party_ref`: party identifier.
- `member_ref`: member identifier where available.
- `text`: full speech text.
- `source_file`: source document URL or file reference.
- `date`: speech date.
- `year`: speech year.
- `gouden_eeuw_unique_raw`: count of unique dictionary hits.
- `gouden_eeuw_raw`: raw dictionary-hit count.
- `gouden_eeuw`: dictionary-hit density.
- `gouden_eeuw_unique`: unique-hit density.
- `gouden_eeuw_unique_std`: standardised unique-hit density.
- `include_for_coding`: final inclusion decision.
- `inclusion_rationale`: model rationale for inclusion.
- `temporal_grammar_code`: TG code.
- `temporal_grammar_label`: TG label.
- `temporal_grammar_rationale`: rationale for TG code.
- `temporal_grammar_evidence`: short evidence excerpt.
- `symbolic_work_code`: SW code.
- `symbolic_work_label`: SW label.
- `symbolic_work_rationale`: rationale for SW code.
- `symbolic_work_evidence`: short evidence excerpt.
- `notes`: additional notes.

## `data/candidate/df_ge_high.csv`

Candidate speeches retrieved by dictionary/embedding-assisted search before final inclusion filtering. It contains 572 speeches.

This file is useful for inspecting retrieval coverage and understanding the candidate pool from which the final analytic dataset was produced.

## `data/validation/human_o3_validation_44.csv`

Validation set comparing adjudicated human labels with final o3 labels.

Key columns:

- `speech_id`: unique speech identifier.
- `excerpt_text`: speech excerpt used for validation.
- `include_for_coding`: adjudicated human inclusion label.
- `temporal_grammar_code`: adjudicated human TG code.
- `symbolic_work_code`: adjudicated human SW code.
- `include_for_coding_final`: final model inclusion label.
- `temporal_grammar_code_final`: final model TG code.
- `symbolic_work_code_final`: final model SW code.

## `data/validation/model_comparison_human_o3_gpt52.csv`

Supplementary model-comparison file from the model selection stage. It contains human-coded labels and model outputs for multiple OpenAI models. Use it for auditing model-selection comparisons; use `human_o3_validation_44.csv` for the default validation metrics.

## `data/validation/df_ge_high_sample.csv`

Stratified sample drawn from the candidate set for qualitative coding and prompt/model development.

## `prompts/annotation_prompt.txt`

Exact system prompt and codebook used to instruct the LLM coding workflow.

## Files Not Included

The raw full parliamentary corpus and large intermediate objects such as tokenised corpora and document-feature matrices are not included. See `data/raw/README.md` for how to provide raw files to the optional retrieval script.
