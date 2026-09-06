# Faithfulness audit: HDP-02-PROP-2.7.1

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `4105def5b41b1a4190828c75f9fffb661d5ed85e80ca38c52b9486d310570664`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

Direct comparison with the cited immutable PDF establishes an exact quantitative correspondence. The tagged Lean family reproduces (a)--(d), including their formulas and universal constant-factor conversions, and the separate centered clauses reproduce both directions between (b) and (e). Those clauses compose with the four-way equivalence to give the source's full centered equivalence. Conversely, the finitely many absolute source conversion constants can be absorbed into the single Lean witness C. Explicit Lean measurability and integrability obligations are faithful formalizations of the source's random-variable and expectation conventions. Both implications therefore hold, the judgment is faithful-equivalent and accepted, and no evidence, dependency, checklist item, or implication remains unresolved.

## Implications

- **Lean implies source:** `yes`. The first Lean conjunct directly supplies all source conversions among (a)--(d) with one absolute C. Under centering, the second conjunct supplies (b) iff (e). Composing either centered conversion with an (a)--(d) conversion gives every additional (a)--(d)/(e) implication with factor at most C^2, still an absolute constant. D001, D005, D007, D012, and D013 match the five source formulas, so the complete source proposition follows.
- **Source implies lean:** `yes`. The source footnote supplies absolute-factor conversions for every ordered pair among (a)--(d), and the printed proof supplies absolute numerical conversions between (b) and (e) under centering. There are finitely many such universal constants, so replacing them by a single maximum also at least 1 yields the Lean witness C. The Lean measurability and integrability clauses merely make the source's random-variable and finite-expectation conventions explicit.

## Findings

- **note / explicit analytic well-formedness:** These clauses formalize implicit source conventions and do not change either implication direction.
- **note / scope of absolute-factor statement for property (e):** A common C can be obtained by taking the maximum of the finitely many absolute constants, so this presentational difference is semantically equivalent and needs no adjudication.
- **note / parameter-comparison wording:** No implication changes: finitely many universal factors can be enlarged to one common C, so the wording difference is a harmless consolidation rather than an unresolved semantic discrepancy.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `85` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `85` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/agent_outputs/agent_runs.json` (`9b39c9b6fdde603335a7c12dde512056fcac68457e2dec25cc3812f8622b5b90`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/agent_outputs/batch_source_contract.json` (`9d0655f04288de45e2916b33bcfbedeb6858b7d99006c4049519714aac058ed1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/agent_outputs/blind_translation.json` (`f2484beccdbae9e12b41bf75e65abf61a8bcdf416390b2c13a1d26f6278e830a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/agent_outputs/direct_judge.json` (`24969487fa021f6aa34d7873920c8737ce6188ad844750c404bf05ee7eaea12a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/agent_outputs/roundtrip_judge.json` (`4c673c1cbb5da6b98cd4c342ceca74f994fa05bd2836114c001c8c27134c6952`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/agent_outputs/source_contract.json` (`d36386247fa8190d772c7c05d72213f6ffea1a3c237094170e93c83ee3c3dc0d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/decision.json` (`aba5fe6548f9c9f67c592a6c170c2195574995bfdba3aa60eaf867015305f953`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/history/20260831T203330Z/agent_outputs/agent_runs.json` (`0ddf47a4ef8afc3b623c3bbe1cbee09bf4623613c754c6ef181c7e8a71d9af19`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/history/20260831T203330Z/agent_outputs/batch_source_contract.json` (`9d0655f04288de45e2916b33bcfbedeb6858b7d99006c4049519714aac058ed1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/history/20260831T203330Z/agent_outputs/blind_translation.json` (`f2484beccdbae9e12b41bf75e65abf61a8bcdf416390b2c13a1d26f6278e830a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/history/20260831T203330Z/agent_outputs/direct_judge.json` (`24969487fa021f6aa34d7873920c8737ce6188ad844750c404bf05ee7eaea12a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/history/20260831T203330Z/agent_outputs/roundtrip_judge.json` (`4c673c1cbb5da6b98cd4c342ceca74f994fa05bd2836114c001c8c27134c6952`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/history/20260831T203330Z/agent_outputs/source_contract.json` (`d36386247fa8190d772c7c05d72213f6ffea1a3c237094170e93c83ee3c3dc0d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/history/20260831T203330Z/decision.json` (`abdeb051b8fb7c32ca61cb5290523f2af4c08a773113002efc6d3ced6f0b3a8a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/history/20260831T203330Z/inputs/batch_source_locator.json` (`9b7526b6e8a9649f200ebd3c18670681337bf0c32212b542a6c858af33f9400c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/history/20260831T203330Z/inputs/blind_dependency_inventory.json` (`506fc708361d4f583d2317f6e726bd8240b4fa9e4f62ee79157b7bb951442d55`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/history/20260831T203330Z/inputs/blind_dossier.md` (`e4c5730f2e37d1bf65dfea8d6dda6e1acf15f36c9394d7fbe08a68c78a436beb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/history/20260831T203330Z/inputs/blind_review_packet.md` (`e4c5730f2e37d1bf65dfea8d6dda6e1acf15f36c9394d7fbe08a68c78a436beb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/history/20260831T203330Z/inputs/declaration_dossier.md` (`3b72a05e07752fd25874b17a59e880546e2cb545d2e770f01b9cef11b2e2030b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/history/20260831T203330Z/inputs/dependency_inventory.json` (`44bd6fd162e98587775b9cd82197d4ebb2554c39801054eb175c21fd5894239b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/history/20260831T203330Z/inputs/direct_review_packet.md` (`09b082c636787f971aa1c79bdb0fa65a140e2821d24b3c9e71532c57539c41fc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/history/20260831T203330Z/inputs/source_locator.json` (`8e55087c0ab136fc8b47d1d8403cb81fd012764443b1e55c2e2b63fd8107804d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/inputs/blind_dependency_inventory.json` (`506fc708361d4f583d2317f6e726bd8240b4fa9e4f62ee79157b7bb951442d55`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/inputs/blind_dossier.md` (`e4c5730f2e37d1bf65dfea8d6dda6e1acf15f36c9394d7fbe08a68c78a436beb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/inputs/blind_review_packet.md` (`e4c5730f2e37d1bf65dfea8d6dda6e1acf15f36c9394d7fbe08a68c78a436beb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/inputs/declaration_dossier.md` (`b2841f8eb0ddbe1849b6a5a432b2c68e748f73543a85544bb4f3e029dd3ecdfd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/inputs/dependency_inventory.json` (`44bd6fd162e98587775b9cd82197d4ebb2554c39801054eb175c21fd5894239b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/inputs/direct_review_packet.md` (`09b082c636787f971aa1c79bdb0fa65a140e2821d24b3c9e71532c57539c41fc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.7.1/faithfulness/inputs/source_locator.json` (`8e55087c0ab136fc8b47d1d8403cb81fd012764443b1e55c2e2b63fd8107804d`)
