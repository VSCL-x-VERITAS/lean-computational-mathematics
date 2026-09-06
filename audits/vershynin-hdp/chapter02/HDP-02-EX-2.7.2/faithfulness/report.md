# Faithfulness audit: HDP-02-EX-2.7.2

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `0285edcc05ef826f9af7d2c276e2157804db0e62bec54514374ebc90e53ae135`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The Lean theorem is the footnote-7 quantitative reading of the equivalence of exactly properties (a)--(d): one absolute real factor C works for every probability space, random variable, ordered property pair, and positive input scale, producing a positive output scale bounded by C times the input. The four local predicates reproduce the source formulas, domains, constants, and finiteness conditions. The explicit C >= 1 normalization, predicate-level measurability, and elaboration infrastructure do not alter either implication direction.

## Implications

- **Lean implies source:** `yes`. Instantiate the Lean target on the probability space of any source random variable. The four kind constructors expand to source properties (a)--(d), and the outer witness C is uniform; each supplied property i at positive Ki yields a positive Kj <= C Ki satisfying property j. Thus the source's quantitative mutual equivalence follows.
- **Source implies lean:** `yes`. The source's absolute comparison constant gives the Lean outer witness (enlarged to max(1,C) if necessary). For measurable X, each Lean predicate is the corresponding source property with finiteness made explicit by its finite expectation bound, so every i-to-j conversion supplies the required Kj. For a nonmeasurable raw function, no Lean SubExponentialProperty antecedent can hold because every case includes Measurable X, making the implication vacuous rather than adding a case beyond the source.

## Findings

- **note / proof-method scope:** The pedagogical proof-route instruction cannot be assessed from a statement-only dossier and does not change the proposition-level equivalence classification.
- **note / random-variable encoding:** This is a faithful predicate-level encoding; nonmeasurable functions have false antecedents and do not create a substantive extra case.
- **note / equivalent-moment-representation:** These forms are equivalent because p is positive and Kp is positive, so monotonic positive p-th powers and p-th roots convert them in both directions; there is no implication loss.
- **note / procedural-proof-instruction:** This audit compares propositions and excludes proof text, so omission of a pedagogical proof-route instruction does not affect either semantic implication.

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

- Blind translator covered `81` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `81` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/agent_outputs/agent_runs.json` (`8a555c31e268ba777efc18c3c791d7c55ffe8848fd973a23672261c659e60ec3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/agent_outputs/batch_source_contract.json` (`36372245064ba3cc7642f4c749587a6860c0e922eb5d03d8bba77e8ce09946f7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/agent_outputs/blind_translation.json` (`f2926c8fc1ad74a3e24d01c477dc4d3a72adbed0f447155cbe0f0629025e8418`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/agent_outputs/direct_judge.json` (`c9e4ab23ebcb1aef11895addf8294b6f8c0f178454d1f71796376472069bba80`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/agent_outputs/roundtrip_judge.json` (`2ebc020f21eb74358a919cd04de889aab306fb5f74e578204718f5ba9207a77a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/agent_outputs/source_contract.json` (`5fe154acf6644c58b98065f21cfa4deb63dbacb39ee63865e7814321450216c0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/decision.json` (`30e28828829f3eb75f7aa81e2faedc874c0de82354792a8929fe0561bdd6834a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/history/20260831T204247Z/agent_outputs/agent_runs.json` (`f4f63413c8a2cbd6278c05130faf41afa50c5821db7b608024f564cdcb434bb8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/history/20260831T204247Z/agent_outputs/batch_source_contract.json` (`36372245064ba3cc7642f4c749587a6860c0e922eb5d03d8bba77e8ce09946f7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/history/20260831T204247Z/agent_outputs/blind_translation.json` (`f2926c8fc1ad74a3e24d01c477dc4d3a72adbed0f447155cbe0f0629025e8418`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/history/20260831T204247Z/agent_outputs/direct_judge.json` (`c9e4ab23ebcb1aef11895addf8294b6f8c0f178454d1f71796376472069bba80`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/history/20260831T204247Z/agent_outputs/roundtrip_judge.json` (`2ebc020f21eb74358a919cd04de889aab306fb5f74e578204718f5ba9207a77a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/history/20260831T204247Z/agent_outputs/source_contract.json` (`5fe154acf6644c58b98065f21cfa4deb63dbacb39ee63865e7814321450216c0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/history/20260831T204247Z/decision.json` (`8b3806cbbf1b822c947228610d35acf5278b41f8d6ccece135609e3433f80526`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/history/20260831T204247Z/inputs/batch_source_locator.json` (`f82dd66915fc2ccf9bddcb807180ce1536f1ae5495b9d66de89a7df3a105cbc0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/history/20260831T204247Z/inputs/blind_dependency_inventory.json` (`dd2992123d3d76907107ca3f8588049e8c2fc99720ce8bbaa4c6c7ccf24aac8a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/history/20260831T204247Z/inputs/blind_dossier.md` (`d6912239332b947b0aa490e26abd6e539784e59a6cb87086791bccab243f51e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/history/20260831T204247Z/inputs/blind_review_packet.md` (`d6912239332b947b0aa490e26abd6e539784e59a6cb87086791bccab243f51e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/history/20260831T204247Z/inputs/declaration_dossier.md` (`0d10df598eebcb5d233ef0cbee3fec5db466654bc18d6fa3d2caba6ffaf3faf5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/history/20260831T204247Z/inputs/dependency_inventory.json` (`8c2bbf90726f31c8439c18b640bc8c76bd2b6a5b4e4aa4168c7e8c2f5b193bda`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/history/20260831T204247Z/inputs/direct_review_packet.md` (`6da938d56252a25ed11c1ebb0ce39f8e3636fea207201fa66d65f9890e544905`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/history/20260831T204247Z/inputs/source_locator.json` (`9d3cdea7af07207e457eecfa2f3f9197faaa8c389c632a5823009a8218270f23`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/inputs/blind_dependency_inventory.json` (`dd2992123d3d76907107ca3f8588049e8c2fc99720ce8bbaa4c6c7ccf24aac8a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/inputs/blind_dossier.md` (`d6912239332b947b0aa490e26abd6e539784e59a6cb87086791bccab243f51e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/inputs/blind_review_packet.md` (`d6912239332b947b0aa490e26abd6e539784e59a6cb87086791bccab243f51e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/inputs/declaration_dossier.md` (`0e223be58615ab397df38ec067341e5d2837015aeb60394bec7dc21145ab20e8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/inputs/dependency_inventory.json` (`8c2bbf90726f31c8439c18b640bc8c76bd2b6a5b4e4aa4168c7e8c2f5b193bda`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/inputs/direct_review_packet.md` (`6da938d56252a25ed11c1ebb0ce39f8e3636fea207201fa66d65f9890e544905`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.2/faithfulness/inputs/source_locator.json` (`9d3cdea7af07207e457eecfa2f3f9197faaa8c389c632a5823009a8218270f23`)
