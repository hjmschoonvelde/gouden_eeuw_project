# Government affiliations and dated positions

Reviewed on 11 September 2026 using Parlement.com.

All 70 government contributions by 47 people now have verified party affiliation and a primary ministerial or state-secretary position at the speech date. The review fills 69 missing affiliations, confirms the one already recorded affiliation, and supplies 68 previously blank capacities while confirming the two existing Minister of Justice entries. The sample contains 51 ministerial contributions and 19 state-secretary contributions.

The [review ledger](../data/metadata/government_metadata.json) records 49 dated primary offices, the party-history source for each person, every affected speech ID, and the previous and enriched values. The baseline is commit `4a977ca124d3f9e2fdfa4391e4443c04f2bb569c`. Earlier missing values are written as `NA` in the analytic CSV and may be empty in the matching candidate/validation files.

## Interpretation

Affiliation describes the person at the contribution date. A minister or state secretary speaks in a government capacity; this enrichment does not turn government arguments into statements on behalf of a Tweede Kamer party group. The `role` and original `function`/`function.` fields remain unchanged.

Dutch position names identify the historic primary portfolio; `speaking_capacity` supplies an English rendering for the dashboard. These fields do not exhaustively list delegated responsibilities or additional deputy-premier offices. Prime ministers are identified together with their General Affairs portfolio. For detailed responsibilities, consult the linked biography.

Office dates are recorded as ISO dates: start inclusive, departure exclusive. None of the reviewed contributions falls exactly on a departure date. Continuous tenure in the same portfolio may span several cabinets. Eric Wiebes and Jo Ritzen each require two different office entries for their included speeches. Earlier or later party memberships are not assigned to these contributions.

## Data and reproduction

- The analytic CSV receives all 70 assignments; the candidate pool receives the same 70 by speech ID.
- The validation-sample CSV receives the same metadata for its five overlapping government contributions. Other candidate/sample records retain their existing cells.
- New fields are `government_position_nl`, `government_position_start`, `government_position_end` and `government_metadata_source`; the existing `party_ref` and `speaking_capacity` fields are enriched.
- Speech IDs, dates, texts, evidence, names, role, retrieval scores, inclusion decisions, coding and ordering are unchanged. The human/model validation datasets are unchanged.
- The existing party summary and party figure are regenerated from the enriched affiliations, with the existing aggregation and minimum-five-contributions rule. Annual counts, the TG/SW matrix, period summaries and validation metrics are unchanged.

```sh
python3 scripts/apply_government_metadata.py
python3 tests/test_metadata_corrections.py --baseline 05c5f4e
Rscript --vanilla scripts/run_all.R
```

The application uses the reviewed ledger and is safe to repeat. It performs no live biography matching. The dashboard takes a versioned copy of the updated research CSV directly.

## Verified offices

The dates below describe the recorded office term; counts describe only contributions in the analytic sample. Party assignments apply to those contributions, not necessarily every day of the full term.

| Speaker and source | Party at speech date | Primary position | Office dates | Contributions |
|---|---|---|---|---:|
| [Henk Mulderije](https://www.parlement.com/biografie/mr-h-henk-mulderije#p3) | CHU | Minister van Justitie | 1951-03-15 – 1952-09-02 | 1 |
| [Ko Suurhoff](https://www.parlement.com/biografie/jg-ko-suurhoff#p3) | PvdA | Minister van Sociale Zaken en Volksgezondheid | 1952-09-02 – 1958-12-22 | 3 |
| [Piet de Jong](https://www.parlement.com/biografie/pjs-piet-de-jong#p3) | KVP | Staatssecretaris van Defensie | 1959-06-25 – 1963-07-24 | 1 |
| [Victor Marijnen](https://www.parlement.com/biografie/mr-vgm-victor-marijnen#p3) | KVP | Minister van Landbouw en Visserij | 1959-05-19 – 1963-07-24 | 1 |
| [Ynso Scholten](https://www.parlement.com/biografie/mr-y-ynso-scholten#p3) | CHU | Minister van Justitie | 1963-07-24 – 1965-04-14 | 1 |
| [Isaäc Diepenhorst](https://www.parlement.com/biografie/dr-ia-isaac-diepenhorst#p3) | ARP | Minister van Onderwijs en Wetenschappen | 1965-04-14 – 1967-04-05 | 1 |
| [Pierre Lardinois](https://www.parlement.com/biografie/ir-pj-pierre-lardinois#p3) | KVP | Minister van Landbouw en Visserij | 1967-04-05 – 1973-01-01 | 1 |
| [Carel Polak](https://www.parlement.com/biografie/mr-chf-carel-polak#p3) | VVD | Minister van Justitie | 1967-04-05 – 1971-07-06 | 1 |
| [Henk Beernink](https://www.parlement.com/biografie/mr-hkj-henk-beernink#p3) | CHU | Minister van Binnenlandse Zaken | 1967-04-05 – 1971-07-06 | 1 |
| [Willem Scholten](https://www.parlement.com/biografie/mr-w-willem-scholten#p3) | CHU | Staatssecretaris van Financiën | 1971-07-14 – 1973-03-19 | 1 |
| [Jan Schaefer](https://www.parlement.com/biografie/jln-jan-schaefer#p3) | PvdA | Staatssecretaris van Volkshuisvesting en Ruimtelijke Ordening | 1973-05-11 – 1977-09-08 | 1 |
| [Harry van Doorn](https://www.parlement.com/biografie/mr-hw-harry-van-doorn#p3) | PPR | Minister van Cultuur, Recreatie en Maatschappelijk Werk | 1973-05-11 – 1977-12-19 | 4 |
| [Michel van Hulten](https://www.parlement.com/biografie/dr-mhm-michel-van-hulten#p3) | PPR | Staatssecretaris van Verkeer en Waterstaat | 1973-05-11 – 1977-12-19 | 1 |
| [Chris van der Klaauw](https://www.parlement.com/biografie/dr-cha-chris-van-der-klaauw#p3) | VVD | Minister van Buitenlandse Zaken | 1977-12-19 – 1981-09-11 | 1 |
| [Annelien Kappeyne van de Coppello](https://www.parlement.com/biografie/mr-annelien-kappeyne-van-de-coppello#p3) | VVD | Staatssecretaris van Sociale Zaken en Werkgelegenheid | 1982-11-08 – 1986-07-14 | 1 |
| [Gijs van Aardenne](https://www.parlement.com/biografie/drs-gmv-gijs-van-aardenne#p3) | VVD | Minister van Economische Zaken | 1982-11-04 – 1986-07-14 | 4 |
| [Gerrit Brokx](https://www.parlement.com/biografie/mr-gph-gerrit-brokx#p3) | CDA | Staatssecretaris van Volkshuisvesting, Ruimtelijke Ordening en Milieubeheer | 1982-11-05 – 1986-10-23 | 1 |
| [Wim van Eekelen](https://www.parlement.com/biografie/dr-wf-wim-van-eekelen#p3) | VVD | Staatssecretaris van Buitenlandse Zaken | 1982-11-05 – 1986-07-14 | 1 |
| [Elco Brinkman](https://www.parlement.com/biografie/mrdrs-lc-elco-brinkman#p3) | CDA | Minister van Welzijn, Volksgezondheid en Cultuur | 1982-11-04 – 1989-11-07 | 2 |
| [Dick Dees](https://www.parlement.com/biografie/drs-djd-dick-dees#p3) | VVD | Staatssecretaris van Welzijn, Volksgezondheid en Cultuur | 1986-07-14 – 1989-11-07 | 1 |
| [Ed Nijpels](https://www.parlement.com/biografie/drs-ehthm-ed-nijpels#p3) | VVD | Minister van Volkshuisvesting, Ruimtelijke Ordening en Milieubeheer | 1986-07-14 – 1989-11-07 | 1 |
| [Henk Koning](https://www.parlement.com/biografie/mr-he-henk-koning#p3) | VVD | Staatssecretaris van Financiën | 1982-11-05 – 1989-11-07 | 1 |
| [Frits Korthals Altes](https://www.parlement.com/biografie/mr-f-frits-korthals-altes#p3) | VVD | Minister van Justitie | 1982-11-04 – 1989-11-07 | 1 |
| [Ien Dales](https://www.parlement.com/biografie/drs-ci-ien-dales#p3) | PvdA | Minister van Binnenlandse Zaken | 1989-11-07 – 1994-01-10 | 1 |
| [Hanja Maij-Weggen](https://www.parlement.com/biografie/jrh-hanja-maij-weggen#p3) | CDA | Minister van Verkeer en Waterstaat | 1989-11-07 – 1994-07-16 | 1 |
| [Koos Andriessen](https://www.parlement.com/biografie/dr-je-koos-andriessen#p3) | CDA | Minister van Economische Zaken | 1989-11-07 – 1994-08-22 | 1 |
| [Elske ter Veld](https://www.parlement.com/biografie/e-elske-ter-veld#p3) | PvdA | Staatssecretaris van Sociale Zaken en Werkgelegenheid | 1989-11-07 – 1993-06-04 | 2 |
| [Jo Ritzen](https://www.parlement.com/biografie/drir-jmm-jo-ritzen#p3) | PvdA | Minister van Onderwijs en Wetenschappen | 1989-11-07 – 1994-08-22 | 1 |
| [Jo Ritzen](https://www.parlement.com/biografie/drir-jmm-jo-ritzen#p3) | PvdA | Minister van Onderwijs, Cultuur en Wetenschappen | 1994-08-22 – 1998-08-03 | 1 |
| [Michiel Patijn](https://www.parlement.com/biografie/mr-m-michiel-patijn#p3) | VVD | Staatssecretaris van Buitenlandse Zaken | 1994-08-22 – 1998-08-03 | 1 |
| [Elizabeth Schmitz](https://www.parlement.com/biografie/mr-ema-elizabeth-schmitz#p3) | PvdA | Staatssecretaris van Justitie | 1994-08-22 – 1998-08-03 | 1 |
| [Aad Nuis](https://www.parlement.com/biografie/drs-aad-nuis#p3) | D66 | Staatssecretaris van Onderwijs, Cultuur en Wetenschappen | 1994-08-22 – 1998-08-03 | 2 |
| [Els Borst-Eilers](https://www.parlement.com/biografie/dr-e-els-borst-eilers#p3) | D66 | Minister van Volksgezondheid, Welzijn en Sport | 1994-08-22 – 2002-07-22 | 1 |
| [Dick Benschop](https://www.parlement.com/biografie/drs-da-dick-benschop#p3) | PvdA | Staatssecretaris van Buitenlandse Zaken | 1998-08-03 – 2002-07-22 | 1 |
| [Wim Kok](https://www.parlement.com/biografie/dr-w-wim-kok#p3) | PvdA | Minister-president en minister van Algemene Zaken | 1994-08-22 – 2002-07-22 | 1 |
| [Tineke Netelenbos](https://www.parlement.com/biografie/t-tineke-netelenbos#p3) | PvdA | Minister van Verkeer en Waterstaat | 1998-08-03 – 2002-07-22 | 1 |
| [Piet Hein Donner](https://www.parlement.com/biografie/mr-jph-piet-hein-donner#p3) | CDA | Minister van Justitie | 2002-07-22 – 2006-09-21 | 1 |
| [Jan Peter Balkenende](https://www.parlement.com/biografie/profdr-jp-jan-peter-balkenende#p3) | CDA | Minister-president en minister van Algemene Zaken | 2002-07-22 – 2010-10-14 | 1 |
| [Henk Kamp](https://www.parlement.com/biografie/hgj-henk-kamp#p3) | VVD | Minister van Defensie | 2002-12-12 – 2007-02-22 | 2 |
| [Karien van Gennip](https://www.parlement.com/biografie/ir-ceg-karien-van-gennip#p3) | CDA | Staatssecretaris van Economische Zaken | 2003-05-27 – 2007-02-22 | 1 |
| [Gerrit Zalm](https://www.parlement.com/biografie/dr-g-gerrit-zalm#p3) | VVD | Minister van Financiën | 2003-05-27 – 2007-02-22 | 1 |
| [Cees Veerman](https://www.parlement.com/biografie/dr-cp-cees-veerman#p3) | CDA | Minister van Landbouw, Natuur en Voedselkwaliteit | 2003-07-01 – 2007-02-22 | 1 |
| [Mark Rutte](https://www.parlement.com/biografie/drs-m-mark-rutte#p3) | VVD | Minister-president en minister van Algemene Zaken | 2010-10-14 – 2024-07-02 | 4 |
| [Jeanine Hennis-Plasschaert](https://www.parlement.com/biografie/ja-jeanine-hennis-plasschaert#p3) | VVD | Minister van Defensie | 2012-11-05 – 2017-10-04 | 5 |
| [Eric Wiebes](https://www.parlement.com/biografie/ir-ed-eric-wiebes#p3) | VVD | Staatssecretaris van Financiën | 2014-02-04 – 2017-10-26 | 2 |
| [Eric Wiebes](https://www.parlement.com/biografie/ir-ed-eric-wiebes#p3) | VVD | Minister van Economische Zaken en Klimaat | 2017-10-26 – 2021-01-15 | 1 |
| [Jet Bussemaker](https://www.parlement.com/biografie/profdr-m-jet-bussemaker#p3) | PvdA | Minister van Onderwijs, Cultuur en Wetenschap | 2012-11-05 – 2017-10-26 | 2 |
| [Stef Blok](https://www.parlement.com/biografie/drs-sa-stef-blok#p3) | VVD | Minister voor Wonen en Rijksdienst | 2012-11-05 – 2017-01-27 | 1 |
| [Wopke Hoekstra](https://www.parlement.com/biografie/mr-wb-wopke-hoekstra#p3) | CDA | Minister van Buitenlandse Zaken | 2022-01-10 – 2023-08-31 | 1 |

For Piet de Jong, the biography dates KVP membership to 1959 without an exact joining day; the [De Quay cabinet roster](https://www.parlement.com/kabinet-de-quay-1959-1963) also identifies his 1959–1963 state-secretary appointment as KVP. His included speech is dated 10 December 1959.
