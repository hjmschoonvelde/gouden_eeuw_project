# Source-verified metadata corrections

Reviewed and incorporated into the published CSV files on 11 September 2026.

This page documents the initial identity and role repairs. The subsequent
[government metadata review](government_metadata.md) supplies dated positions
for all 70 government contributions and fills the 69 affiliations that remained
missing after these repairs. The original correction ledger is retained as the
record of the first review; the government ledger records the later enrichment.

The initial ten contributions received corrections to speaker, role, party, member or
function metadata. The review began with nine records whose missing party
values caused the earlier dashboard to display them as government speakers.
These were six MP contributions, two ministerial contributions and one visiting
MEP contribution. A consistency check also found Asscher incorrectly recorded
as government in June 2018, when he was an MP.

## Corrected records

The [machine-readable ledger](../data/metadata/metadata_corrections.json) contains
exact speech IDs, original values, replacements, reasons and source locations.
It is the same verified ledger used for the dashboard's metadata repair. Its
biography information documents identity checks. The additional
[speaker registry](../data/metadata/speaker_profiles.json) supplies reviewed
names and Parlement.com links for all 447 analytic contributions; see the
[complete speaker-link audit](speaker_links.md).

| Date | Original speaker label | Corrected identification and capacity | Party information | Parliamentary source |
|---|---|---|---|---|
| 1949-05-17 | Welter zet zijn rede voort en | Charles Welter, MP; remove a continuation instruction from the name | KNP | [Proceedings](https://resolver.kb.nl/resolve?urn=sgd:mpeg21:19481949:0000487:pdf); same sitting's correctly identified Welter turn |
| 1950-11-10 | Holtrop | Charles Welter, MP; the parser mistook his quotation of Holtrop for a speaker change | KNP | [Scan](https://resolver.kb.nl/resolve?urn=sgd:mpeg21:19501951:0000563:pdf), printed p. 426, PDF p. 14, and continuing page headers |
| 1960-02-18 | Schüüuiis | Tineke Schilthuis, MP; repair OCR-damaged name | PvdA | [Scan](https://resolver.kb.nl/resolve?urn=sgd:mpeg21:19591960:0002136:pdf), printed p. 3690, PDF p. 28 |
| 1965-02-23 | Scholten, Minister van Justitie | Ynso Scholten, Minister of Justice; change role to government and replace the incorrectly matched Willem Scholten biography | Source party field stays missing; personal CHU affiliation is separate | [Proceedings](https://resolver.kb.nl/resolve?urn=sgd:mpeg21:19641965:0000782:pdf); another ministerial reply in the debate supplies the member reference |
| 1968-09-24 | Polak, Minister van Justitie | Carel Polak, Minister of Justice; change role to government and replace the incorrectly matched Henri Polak biography | Source party field stays missing; personal VVD affiliation is separate | [Proceedings](https://resolver.kb.nl/resolve?urn=sgd:mpeg21:19681969:0000711:pdf); adjacent ministerial replies supply the member reference |
| 1974-02-12 | Van Veenen | Fia van Veenendaal-van Meggelen, MP; repair a split, OCR-damaged surname | DS'70 | [Scan](https://resolver.kb.nl/resolve?urn=sgd:mpeg21:19731974:0000729:pdf), printed p. 2436, PDF p. 34 |
| 1984-05-01 | Verbeek | Jan Verbeek, VVD senator; change role to `senator`. This is an Eerste Kamer sitting | VVD, already recorded | [Scan](https://resolver.kb.nl/resolve?urn=sgd:mpeg21:19831984:0000028:pdf), printed p. 896, PDF p. 34; [biography](https://www.parlement.com/biografie/jw-jan-verbeek) |
| 1996-10-10 | Van Middelkoop | Eimert van Middelkoop, MP, speaking for the parliamentary climate committee | GPV affiliation; this does not make the committee's argument a party position | [Proceedings](https://zoek.officielebekendmakingen.nl/h-tk-19961997-637-661.html) |
| 2000-09-28 | Van Middelkoop | Eimert van Middelkoop, MP | GPV component-party affiliation; retain the source's joint group label **RPF/GPV** separately | [Proceedings](https://zoek.officielebekendmakingen.nl/h-tk-20002001-338-357.html) |
| 2012-02-09 | Gerbrandy (EP/D66) | Gerben-Jan Gerbrandy, visiting MEP; separate role `mep` and replace the incorrectly matched Pieter Sjoerds Gerbrandy biography | D66 | [Proceedings](https://zoek.officielebekendmakingen.nl/h-tk-20112012-52-9.html), including the chair's introduction of visiting MEPs |
| 2018-06-13 | Asscher | Lodewijk Asscher, MP; change role from government to MP | PvdA, already recorded | [Proceedings](https://zoek.officielebekendmakingen.nl/h-tk-20172018-93-4.html) |

The subsequent review of every speaker biography identified Verbeek's 1984
contribution as an Eerste Kamer speech. The scan confirms both his VVD
maiden speech and the chamber. This eleventh correction adds `senator` as a
distinct speaking role. The original `mp` count above reflects the source label,
which did not correctly distinguish this contribution.

The older XML references in the ledger identify the research corpus files in
the parent project's `Data/` directory; they are not bundled in this repository.
The official scan URLs and printed-page references provide public source access.

Jan Verbeek's 1 May 1984 speech is outside the intended Tweede Kamer scope.
The original text itself retains Eerste Kamer page footers, independently of
the biography match. It is retained provisionally in the 447-contribution
sample at the researcher's request, pending a separate scope decision. This
does not expand the intended scope of the study. The row-level
`sample_scope_note` makes the exception visible without changing the original
inclusion decision, coding or speech text.

## Published data and analytical consequences

- `data/derived/ge_final_45_24.csv`: all eleven corrections are written directly into
  the 447-row analytic dataset.
- `data/candidate/df_ge_high.csv`: the same eleven corrections are written into the
  572-row candidate pool. Its `function` field corresponds to `function.` in the
  analytic dataset.
- `data/validation/df_ge_high_sample.csv`: the two overlapping records, Welter
  (1949) and van Veenendaal-van Meggelen (1974), receive the same name, party and
  member corrections. The later name review also supplies the verified names
  and links for all 45 overlaps with the analytic sample. All 58 sampled records
  and their ordering are preserved.
- The human/model validation labels and model-comparison files are unchanged.

The subsequent biography review writes the same full names into `speaker` in
both repositories. It updates 422 labels in the analytic dataset and the same
422 in the candidate pool, plus 41 labels in the validation sample. Most are
surname expansions; the ten incorrect-person biography matches are documented
separately in the speaker-link audit. All 447 analytic contributions carry a
`speaker_person_id` and a `speaker_profile_url`. Matching records in the candidate
and validation-sample files receive the same values. Unreviewed records retain
their existing names and have blank identity/link fields.

`speaker_original` preserves the original corpus name; `speaker_source_label`
preserves the name after the earlier OCR/attribution corrections. The
`sample_scope_note` documents Verbeek's provisional retention separately from
the original model-generated notes and inclusion decision.

The initial analytic and candidate repairs add two metadata columns: `speaking_capacity`
and `parliamentary_group_as_recorded`. These preserve Van Middelkoop's committee
role in 1996, the joint RPF/GPV group label in 2000, the two ministers' speaking
capacity, Gerbrandy's participation as a visiting MEP, and Verbeek's
Eerste Kamer contribution. Blank cells mean that
this review added no further context, not that the speaker had no such capacity.

| Speaking role | Before | After |
|---|---:|---:|
| MP / Tweede Kamer (`mp`) | 378 | 375 |
| Eerste Kamer senator | 0 | 1 |
| Government speaker | 69 | 70 |
| Visiting MEP | 0 | 1 |
| **Total contributions** | **447** | **447** |

The initial review filled seven missing party affiliations. All non-government
contributions then had party metadata. Of the 70 government contributions, one
already recorded CHU affiliation (Willem Scholten in 1973), while 69 still had no
party. Those 69 are filled in the subsequent government review. Government role
must be determined from `role`, independently of party affiliation.

The party table and figure are regenerated using the existing aggregation and
minimum-five-contributions rule. Party metadata describes affiliation at the
time of a contribution. It does not imply that a minister, committee
representative or visiting MEP speaks on behalf of that party's Tweede Kamer
group. The committee capacity and joint-group label must be considered when
interpreting the GPV counts.

Recorded-affiliation totals change from 20 to 21 for D66, 27 to 29 for GPV,
39 to 40 for PvdA, 4 to 6 for KNP and 4 to 5 for DS'70. KNP and DS'70 therefore
now meet the existing minimum-five-contributions threshold for the party figure.

All original speech IDs, dates, texts, retrieval scores, inclusion decisions,
rationales and TG/SW assignments are retained. The annual counts, joint coding
matrix, period summaries and validation metrics are consequently unchanged.
The residual SW5 category remains included. Gerbrandy's MEP contribution and Verbeek's Eerste Kamer speech both
remain included; removing either would be a separate change to the analytical
sample, not a metadata correction.

## Source and reproduction notes

The 1950 Welter record begins partway through the original contribution because
the corpus parser treated an earlier portion as a stage direction and then
mistook a quotation of Holtrop for a change of speaker. The attribution is
corrected; the coded text has not been expanded. Consult the official scan for
the complete contribution. Existing `source_file` values are retained; verified
source URLs are supplied in the ledger.

The original CSV files are retained in Git history at commit `05c5f4e`, before
these repairs. To check the published corrections and compare every original
cell against that baseline in a clone with Git history:

```sh
python3 tests/test_metadata_corrections.py --baseline 05c5f4e
Rscript --vanilla scripts/run_all.R
```

Omit `--baseline` to check corrected values, record counts and coding
distributions without Git history. The preservation comparison verifies that
only the reviewed metadata cells and documented context columns differ, and
that the separate human/model validation files are byte-for-byte unchanged.

The default reproduction requires no additional dependencies for these data
repairs. The annotation-prompt link and optional script use the tracked `Prompts/`
directory name, including on case-sensitive systems.
