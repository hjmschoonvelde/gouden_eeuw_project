# LLM-Use Disclosure

This disclosure follows the spirit of the GUIDE-LLM reporting framework in Feuerriegel et al. (2026), DOI: `10.1038/s41562-026-02492-7`. It is written as a project-specific transparency statement rather than a verbatim reproduction of the checklist.

## Scope

| Reporting area | Project disclosure |
|---|---|
| Role of LLMs | LLMs were used for interpretive annotation of candidate "Gouden Eeuw" speeches: inclusion/exclusion, temporal grammar, symbolic work, rationales, and evidence snippets. |
| Automation level | Human-in-the-loop. The authors designed the codebook, coded validation material, adjudicated disagreements, compared model outputs, refined prompts, and interpreted results. The final full candidate set was coded with the selected LLM workflow. |

## Model And System Details

| Reporting area | Project disclosure |
|---|---|
| Provider and model labels | OpenAI models were compared during development. Local materials identify GPT-4.1, GPT-5.2, mini-o4, and o3, with o3 selected for final coding. |
| Exact model identifier and access date | The exact date-stamped model snapshot IDs and API access dates are not encoded in the local scripts or output files. File timestamps and project materials indicate that the coding workflow was developed and run in January-February 2026. |
| Access mode | API access from R using the `ellmer` package. |
| Context mode | The preserved batching script creates one chat object per batch and sends multiple speeches sequentially to that object. Depending on `ellmer` chat semantics, this may have allowed within-batch conversation context. No cross-batch or platform-level persistent memory was intended. |
| Configuration | The preserved script sets `temperature = 0`, uses a batch size of 50, and allows retries/backoff for transient API errors. No random seed or maximum output-token value is recorded in the preserved script. |
| Customisation | No fine-tuning. The model was customised only through the system prompt/codebook in `prompts/annotation_prompt.txt`. |
| Persistent memory | No persistent memory feature was requested. See the context-mode note above for possible within-batch chat history. |

## Prompts

| Reporting area | Project disclosure |
|---|---|
| Exact prompt | The exact prompt is included at `prompts/annotation_prompt.txt`. |
| System-wide instructions | The prompt was supplied as the API system prompt through `ellmer::chat_openai(system_prompt = ...)`. No additional hidden project-level instructions are present in the repository. |

## Data Inputs And Privacy

| Reporting area | Project disclosure |
|---|---|
| Input data | Public Dutch parliamentary speech text and public metadata such as date, party, speaker, and source identifier. |
| Sensitive data handling | The project did not use private participant data. The speeches include names of public political actors and public parliamentary content. API keys are not committed and must be supplied through environment variables. |

## Validation And Interpretation

| Reporting area | Project disclosure |
|---|---|
| Human validation | Both authors independently coded validation material and resolved disagreements into adjudicated labels. The 44-row validation file is included at `data/validation/human_o3_validation_44.csv`. |
| Model comparison | A supplementary comparison file is included at `data/validation/model_comparison_human_o3_gpt52.csv`. |
| Validation script | `scripts/02_validate_llm_coding.R` regenerates inclusion, temporal-grammar, and symbolic-work metrics from the included validation file. |
| Post-processing | JSON-like model outputs were parsed into structured columns; code labels were standardised; TG5 residual cases were excluded from the final analytic dataset; SW5 residual cases were retained as a symbolic-work residual. |
| Interpretation | Aggregate trends and party patterns were interpreted by the authors using the theoretical framework described in the chapter and methodology. |

## Reproducibility

| Reporting area | Project disclosure |
|---|---|
| Shared code | Reproduction scripts are in `scripts/`; shared helper functions are in `R/`. |
| Shared prompt | The prompt/codebook is in `prompts/annotation_prompt.txt`. |
| Shared outputs | The final analytic dataset and validation files are included under `data/`. |
| API reruns | API reruns require `OPENAI_API_KEY` and may not reproduce labels exactly because provider-side model versions and infrastructure can change. |
| Default reproducibility | `Rscript scripts/run_all.R` reproduces derived-data tables, figures, and validation metrics without API calls or raw corpus files. |

## Competing Interests

The chapter states that the authors have no conflicts of interest relevant to the chapter. The local materials do not indicate sponsored model access or in-kind compute support.

## Reporting Gaps

The local materials do not preserve exact OpenAI model snapshot identifiers, exact API access dates, maximum output-token settings, or complete conversation transcripts for every API call. The repository therefore includes the final derived labels and validation files so readers can reproduce the published summaries even if future API reruns differ.
