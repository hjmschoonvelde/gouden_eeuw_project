# Data Dictionary

## `data/derived/ge_final_45_24.csv`

Final analytic dataset used by the default reproduction scripts. It contains 447 speeches coded as "Gouden Eeuw" trope uses.

Key columns:

- `speech_id`: unique speech identifier.
- `speaker`: speaker name, including source-verified metadata corrections.
- `function.`: speaker function, with corrections documented in the metadata ledger.
- `role`: speaking role: `mp` (Tweede Kamer member), `government`, or `mep` (visiting Member of the European Parliament). This describes the contribution at its date, not all offices held by the speaker.
- `party_ref`: party affiliation identifier, where recorded or verified. A missing party does not imply a government role. Affiliation does not necessarily identify the group on whose behalf a contribution is made; see the capacity and group fields.
- `member_ref`: member identifier where available.
- `text`: speech text as extracted from the corpus, retaining the original OCR and segmentation. See the metadata audit for the partially extracted 1950 Welter contribution.
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
- `speaking_capacity`: verified additional context where needed, such as speaking for a parliamentary committee. Blank means no additional context was added in this metadata review.
- `parliamentary_group_as_recorded`: source group label where it needs to be distinguished from component-party affiliation (RPF/GPV for Van Middelkoop in 2000). Blank means no separate group label was added in this review.

The CSV contains the corrected values directly. Original values, corrections and sources are recorded by speech ID in [`data/metadata/metadata_corrections.json`](../data/metadata/metadata_corrections.json), with a [human-readable audit](metadata_corrections.md). The original files remain available in Git history.

## `data/candidate/df_ge_high.csv`

Candidate speeches retrieved by dictionary/embedding-assisted search before final inclusion filtering. It contains 572 speeches.

This file is useful for inspecting retrieval coverage and understanding the candidate pool from which the final analytic dataset was produced.

The same ten metadata corrections and two context columns are applied here. This file uses the column name `function` where the analytic file uses `function.`. Retrieval scores, texts and candidate membership are unchanged.

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

Speaker, party and member metadata for the two overlapping reviewed records are corrected. The 58 sampled records, their texts and decade assignments are unchanged. Human/model labels in the separate validation and comparison files are unchanged.

## `Prompts/annotation_prompt.txt`

Exact system prompt and codebook used to instruct the LLM coding workflow.

## Files Not Included

The raw full parliamentary corpus and large intermediate objects such as tokenised corpora and document-feature matrices are not included. See `data/raw/README.md` for how to provide raw files to the optional retrieval script.
