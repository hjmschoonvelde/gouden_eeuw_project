# Golden Age Politics

Reproduction and transparency materials for:

**Golden Age Politics: A Computational-Interpretive Analysis of the "Gouden Eeuw" as a Trope in Dutch Parliamentary Speech, 1945-2024**  
Stefan Couperus and Martijn Schoonvelde

## What This Project Does

The chapter analyses how speakers in Dutch parliamentary debate invoke the "Gouden Eeuw" as a mnemonic trope. It combines computational retrieval with interpretive coding to identify:

- how the trope links past, present, and future politics;
- what symbolic work the trope performs in parliamentary interaction;
- how these patterns vary across time and parties.

## Main Materials

- [README](README.md)
- [Extended methodology](docs/methodology_extended.md)
- [Codebook summary](docs/codebook.md)
- [Data dictionary](docs/data_dictionary.md)
- [Metadata corrections](docs/metadata_corrections.md)
- [LLM-use disclosure](docs/llm_use_disclosure.md)
- [Verification notes](docs/verification.md)
- [Annotation prompt](Prompts/annotation_prompt.txt)

## Reproduce Included Outputs

```sh
Rscript scripts/run_all.R
```

The default reproduction uses included derived data only. It does not require API access or local machine-specific file paths.
