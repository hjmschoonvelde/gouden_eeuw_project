# Golden Age Politics

Reproduction and transparency materials for:

**Golden Age Politics: A Computational-Interpretive Analysis of the "Gouden Eeuw" as a Trope in Dutch Parliamentary Speech, 1945-2024**  
Stefan Couperus and Martijn Schoonvelde

## What This Project Does

The chapter analyses how Dutch MPs invoke the "Gouden Eeuw" as a mnemonic trope in parliamentary debate. It combines computational retrieval with interpretive coding to identify:

- how the trope links past, present, and future politics;
- what symbolic work the trope performs in parliamentary interaction;
- how these patterns vary across time and parties.

## Main Materials

- [README](README.md)
- [Extended methodology](docs/methodology_extended.md)
- [Codebook summary](docs/codebook.md)
- [Data dictionary](docs/data_dictionary.md)
- [LLM-use disclosure](docs/llm_use_disclosure.md)
- [Verification notes](docs/verification.md)
- [Annotation prompt](prompts/annotation_prompt.txt)

## Reproduce Included Outputs

```sh
Rscript scripts/run_all.R
```

The default reproduction uses included derived data only. It does not require API access or local machine-specific file paths.
