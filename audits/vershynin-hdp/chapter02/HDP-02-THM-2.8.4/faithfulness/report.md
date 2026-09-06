# Faithfulness audit: HDP-02-THM-2.8.4

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `75f95d4891e3ba80a9ff155b4501f1e08172d525dd278570ec40a7c39c3fe3c5`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The direct judge correctly identified exact agreement on the intended nondegenerate Bernstein inequality but went beyond the source by treating K positivity, totalized division, almost-everywhere boundedness, and the empty-family case as source-authorized resolutions. The round-trip judge correctly preserved the printed theorem's silence. The decisive issue is not that Lean's boundary statement is false—it is mathematically valid—but that the source does not define its displayed quotient at t = 0 and sigma^2 = 0. Consequently neither full implication can be certified without repairing the source, the classification is undetermined, acceptance is false, and residual source ambiguity remains.

## Implications

- **Lean implies source:** `unclear`. Yes on the exact common nondegenerate core: positive K, nonempty finite family, and nonzero denominator. For the full printed statement, the t = 0 and sigma^2 = 0 instance contains an undefined quotient, so asserting implication would require an unstated source convention.
- **Source implies lean:** `unclear`. The source supports the Lean inequality on its meaningful nondegenerate core, and the additional empty or degenerate Lean cases are mathematically valid. But the printed source does not specify K positivity, almost-everywhere boundedness, N = 0, or a value for 0/0, so it cannot source-faithfully determine the complete totalized Lean proposition.

## Findings

- **critical / source-definedness:** The full printed claim is not semantically determinate at that boundary, preventing certified bidirectional equivalence.
- **major / restricted-applicability:** The restriction must not be reclassified as theorem strength or silently attributed to the source.
- **minor / bound-semantics:** This is conventional and mathematically compatible with probability-level conclusions, but its textual source status remains ambiguous.
- **minor / empty-family-extension:** Lean adds a valid trivial case, but validity alone does not establish that the printed source stated it.
- **note / nondegenerate-core:** There is no substantive mismatch in the intended Bernstein inequality away from the source-silent boundary cases.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `unclear` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `unclear` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `unclear` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `unclear` |
| `C11` | `pass` | `unclear` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `70` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `70` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

- The printed source provides no convention for the quotient when t = 0 and sigma^2 = 0; this is an irreducible source ambiguity unless an external correction or explicit audit policy selects a repair.
- The printed theorem does not explicitly state K > 0.
- The printed theorem does not specify whether |X_i| <= K is pointwise or almost surely.
- The printed theorem does not specify whether N = 0 is admitted.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/agent_outputs/adjudicator.json` (`2fb1be1b00e10b9d6c156f3a83c2fd7509216597280f6a1d0b1f9734fbcdcb9b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/agent_outputs/agent_runs.json` (`d3c0a6bc17ed5c3f537b6f4eaf1bf4d1aa5c71c51344f8cde6f2278a1e8f27f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/agent_outputs/blind_translation.json` (`433bef31eb99791552463c6b34f950fc726e654fe67d9a2d63e25afd4aeb3aab`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/agent_outputs/direct_judge.json` (`469561a7aa132fb8d629112df69be239f583d810afd7a570b2e95d29ac86d55f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/agent_outputs/roundtrip_judge.json` (`8a05e2631caafb05358f73d408362c5f97c0d97dd11549b1cc25af8f7007eb8f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/agent_outputs/source_contract.json` (`adff9aede39da999850448665aad4b7049ff795d8d064e4e80510df456c69c73`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/decision.json` (`ce06c27f93382ff8ca2df69a8768ced394b03d7442b7726a651f64a10db8c058`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T024634Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T024634Z/inputs/blind_dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T024634Z/inputs/blind_dossier.md` (`e8db84614e12de9753fd80016ff1e464846e5505b998662af2fc00d8e0e1653f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T024634Z/inputs/blind_review_packet.md` (`e8db84614e12de9753fd80016ff1e464846e5505b998662af2fc00d8e0e1653f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T024634Z/inputs/declaration_dossier.md` (`4c3aaa0e07d87fabf340a1ba359ebad1c288e1484046aeaaecadd4beb35eb6cd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T024634Z/inputs/dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T024634Z/inputs/direct_review_packet.md` (`bd9c7f110f8f00da91dccd0cf746559df1f0acf4635e83ca3cd93397e5ff7f07`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T024634Z/inputs/source_locator.json` (`dcc765a6cf7238e8da893ac080e4844555f6de6979e26dc210011ddc0c2ca177`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T030220Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T030220Z/inputs/blind_dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T030220Z/inputs/blind_dossier.md` (`e8db84614e12de9753fd80016ff1e464846e5505b998662af2fc00d8e0e1653f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T030220Z/inputs/blind_review_packet.md` (`e8db84614e12de9753fd80016ff1e464846e5505b998662af2fc00d8e0e1653f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T030220Z/inputs/declaration_dossier.md` (`4c3aaa0e07d87fabf340a1ba359ebad1c288e1484046aeaaecadd4beb35eb6cd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T030220Z/inputs/dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T030220Z/inputs/direct_review_packet.md` (`bd9c7f110f8f00da91dccd0cf746559df1f0acf4635e83ca3cd93397e5ff7f07`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T030220Z/inputs/source_locator.json` (`dcc765a6cf7238e8da893ac080e4844555f6de6979e26dc210011ddc0c2ca177`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T221507Z/agent_outputs/agent_runs.json` (`082aced0b1b3d0ca442ee77656986d0488e226843ba8f531955d714c545fb22d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T221507Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T221507Z/agent_outputs/source_contract.json` (`adff9aede39da999850448665aad4b7049ff795d8d064e4e80510df456c69c73`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T221507Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T221507Z/inputs/blind_dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T221507Z/inputs/blind_dossier.md` (`e8db84614e12de9753fd80016ff1e464846e5505b998662af2fc00d8e0e1653f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T221507Z/inputs/blind_review_packet.md` (`e8db84614e12de9753fd80016ff1e464846e5505b998662af2fc00d8e0e1653f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T221507Z/inputs/declaration_dossier.md` (`4c3aaa0e07d87fabf340a1ba359ebad1c288e1484046aeaaecadd4beb35eb6cd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T221507Z/inputs/dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T221507Z/inputs/direct_review_packet.md` (`bd9c7f110f8f00da91dccd0cf746559df1f0acf4635e83ca3cd93397e5ff7f07`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T221507Z/inputs/source_locator.json` (`dcc765a6cf7238e8da893ac080e4844555f6de6979e26dc210011ddc0c2ca177`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T230029Z/agent_outputs/agent_runs.json` (`bc3296b36a59eddc404737f2bbf27bbf6e55082121a0ef9bbfb5d17783c18a7f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T230029Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T230029Z/agent_outputs/source_contract.json` (`adff9aede39da999850448665aad4b7049ff795d8d064e4e80510df456c69c73`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T230029Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T230029Z/inputs/blind_dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T230029Z/inputs/blind_dossier.md` (`e8db84614e12de9753fd80016ff1e464846e5505b998662af2fc00d8e0e1653f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T230029Z/inputs/blind_review_packet.md` (`e8db84614e12de9753fd80016ff1e464846e5505b998662af2fc00d8e0e1653f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T230029Z/inputs/declaration_dossier.md` (`d5dfe7829f7fb88640060bcb2fe4051e1a353d5381353f1b54787a993fb402f3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T230029Z/inputs/dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T230029Z/inputs/direct_review_packet.md` (`bd9c7f110f8f00da91dccd0cf746559df1f0acf4635e83ca3cd93397e5ff7f07`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260828T230029Z/inputs/source_locator.json` (`dcc765a6cf7238e8da893ac080e4844555f6de6979e26dc210011ddc0c2ca177`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T002848Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T002848Z/agent_outputs/source_contract.json` (`adff9aede39da999850448665aad4b7049ff795d8d064e4e80510df456c69c73`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T002848Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T002848Z/inputs/blind_dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T002848Z/inputs/blind_dossier.md` (`82b82265edfc43a3c750398b24f68e2d8e17a95797e9b4f839a2a7a35ced83ec`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T002848Z/inputs/blind_review_packet.md` (`82b82265edfc43a3c750398b24f68e2d8e17a95797e9b4f839a2a7a35ced83ec`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T002848Z/inputs/declaration_dossier.md` (`2f1b49785913e31be9ec1ae36cf46e70900d7c45667685e6a1a3406bd7a65b66`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T002848Z/inputs/dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T002848Z/inputs/direct_review_packet.md` (`4dce1e698f513a92b73194d98d58ef127466f2f24a9475068c97f021fca62fe6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T002848Z/inputs/source_locator.json` (`dcc765a6cf7238e8da893ac080e4844555f6de6979e26dc210011ddc0c2ca177`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T014629Z/agent_outputs/adjudicator.json` (`2fb1be1b00e10b9d6c156f3a83c2fd7509216597280f6a1d0b1f9734fbcdcb9b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T014629Z/agent_outputs/agent_runs.json` (`9928ef85a4b4edb0ff578ed003c321bc7af19bbf91de87a081465f63b623ded2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T014629Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T014629Z/agent_outputs/blind_translation.json` (`433bef31eb99791552463c6b34f950fc726e654fe67d9a2d63e25afd4aeb3aab`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T014629Z/agent_outputs/direct_judge.json` (`469561a7aa132fb8d629112df69be239f583d810afd7a570b2e95d29ac86d55f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T014629Z/agent_outputs/roundtrip_judge.json` (`8a05e2631caafb05358f73d408362c5f97c0d97dd11549b1cc25af8f7007eb8f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T014629Z/agent_outputs/source_contract.json` (`adff9aede39da999850448665aad4b7049ff795d8d064e4e80510df456c69c73`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T014629Z/decision.json` (`c709da536b14343f4ea80bdfe9b0b1a612c2408ced80b737ed43264d16982eb7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T014629Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T014629Z/inputs/blind_dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T014629Z/inputs/blind_dossier.md` (`82b82265edfc43a3c750398b24f68e2d8e17a95797e9b4f839a2a7a35ced83ec`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T014629Z/inputs/blind_review_packet.md` (`82b82265edfc43a3c750398b24f68e2d8e17a95797e9b4f839a2a7a35ced83ec`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T014629Z/inputs/declaration_dossier.md` (`2f1b49785913e31be9ec1ae36cf46e70900d7c45667685e6a1a3406bd7a65b66`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T014629Z/inputs/dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T014629Z/inputs/direct_review_packet.md` (`4dce1e698f513a92b73194d98d58ef127466f2f24a9475068c97f021fca62fe6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T014629Z/inputs/source_locator.json` (`dcc765a6cf7238e8da893ac080e4844555f6de6979e26dc210011ddc0c2ca177`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T021246Z/agent_outputs/adjudicator.json` (`2fb1be1b00e10b9d6c156f3a83c2fd7509216597280f6a1d0b1f9734fbcdcb9b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T021246Z/agent_outputs/agent_runs.json` (`9928ef85a4b4edb0ff578ed003c321bc7af19bbf91de87a081465f63b623ded2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T021246Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T021246Z/agent_outputs/blind_translation.json` (`433bef31eb99791552463c6b34f950fc726e654fe67d9a2d63e25afd4aeb3aab`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T021246Z/agent_outputs/direct_judge.json` (`469561a7aa132fb8d629112df69be239f583d810afd7a570b2e95d29ac86d55f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T021246Z/agent_outputs/roundtrip_judge.json` (`8a05e2631caafb05358f73d408362c5f97c0d97dd11549b1cc25af8f7007eb8f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T021246Z/agent_outputs/source_contract.json` (`adff9aede39da999850448665aad4b7049ff795d8d064e4e80510df456c69c73`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T021246Z/decision.json` (`38033af02f25770a5e937cbfac6ad7190c76bbae256aaee8be6d121626f0cb91`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T021246Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T021246Z/inputs/blind_dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T021246Z/inputs/blind_dossier.md` (`82b82265edfc43a3c750398b24f68e2d8e17a95797e9b4f839a2a7a35ced83ec`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T021246Z/inputs/blind_review_packet.md` (`82b82265edfc43a3c750398b24f68e2d8e17a95797e9b4f839a2a7a35ced83ec`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T021246Z/inputs/declaration_dossier.md` (`2f1b49785913e31be9ec1ae36cf46e70900d7c45667685e6a1a3406bd7a65b66`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T021246Z/inputs/dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T021246Z/inputs/direct_review_packet.md` (`4dce1e698f513a92b73194d98d58ef127466f2f24a9475068c97f021fca62fe6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T021246Z/inputs/source_locator.json` (`dcc765a6cf7238e8da893ac080e4844555f6de6979e26dc210011ddc0c2ca177`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T023453Z/agent_outputs/adjudicator.json` (`2fb1be1b00e10b9d6c156f3a83c2fd7509216597280f6a1d0b1f9734fbcdcb9b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T023453Z/agent_outputs/agent_runs.json` (`9928ef85a4b4edb0ff578ed003c321bc7af19bbf91de87a081465f63b623ded2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T023453Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T023453Z/agent_outputs/blind_translation.json` (`433bef31eb99791552463c6b34f950fc726e654fe67d9a2d63e25afd4aeb3aab`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T023453Z/agent_outputs/direct_judge.json` (`469561a7aa132fb8d629112df69be239f583d810afd7a570b2e95d29ac86d55f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T023453Z/agent_outputs/roundtrip_judge.json` (`8a05e2631caafb05358f73d408362c5f97c0d97dd11549b1cc25af8f7007eb8f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T023453Z/agent_outputs/source_contract.json` (`adff9aede39da999850448665aad4b7049ff795d8d064e4e80510df456c69c73`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T023453Z/decision.json` (`89b91ce0ff6e6f08100baeb78ca11c6f11047f372a155b8f2bb009831edd1b74`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T023453Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T023453Z/inputs/blind_dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T023453Z/inputs/blind_dossier.md` (`82b82265edfc43a3c750398b24f68e2d8e17a95797e9b4f839a2a7a35ced83ec`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T023453Z/inputs/blind_review_packet.md` (`82b82265edfc43a3c750398b24f68e2d8e17a95797e9b4f839a2a7a35ced83ec`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T023453Z/inputs/declaration_dossier.md` (`2f1b49785913e31be9ec1ae36cf46e70900d7c45667685e6a1a3406bd7a65b66`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T023453Z/inputs/dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T023453Z/inputs/direct_review_packet.md` (`4dce1e698f513a92b73194d98d58ef127466f2f24a9475068c97f021fca62fe6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T023453Z/inputs/source_locator.json` (`dcc765a6cf7238e8da893ac080e4844555f6de6979e26dc210011ddc0c2ca177`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T031716Z/agent_outputs/adjudicator.json` (`2fb1be1b00e10b9d6c156f3a83c2fd7509216597280f6a1d0b1f9734fbcdcb9b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T031716Z/agent_outputs/agent_runs.json` (`9928ef85a4b4edb0ff578ed003c321bc7af19bbf91de87a081465f63b623ded2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T031716Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T031716Z/agent_outputs/blind_translation.json` (`433bef31eb99791552463c6b34f950fc726e654fe67d9a2d63e25afd4aeb3aab`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T031716Z/agent_outputs/direct_judge.json` (`469561a7aa132fb8d629112df69be239f583d810afd7a570b2e95d29ac86d55f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T031716Z/agent_outputs/roundtrip_judge.json` (`8a05e2631caafb05358f73d408362c5f97c0d97dd11549b1cc25af8f7007eb8f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T031716Z/agent_outputs/source_contract.json` (`adff9aede39da999850448665aad4b7049ff795d8d064e4e80510df456c69c73`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T031716Z/decision.json` (`ffc6677a93b73d049cf807087b6368b0b95d8417d3aa92b8f194aa4541d18701`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T031716Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T031716Z/inputs/blind_dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T031716Z/inputs/blind_dossier.md` (`82b82265edfc43a3c750398b24f68e2d8e17a95797e9b4f839a2a7a35ced83ec`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T031716Z/inputs/blind_review_packet.md` (`82b82265edfc43a3c750398b24f68e2d8e17a95797e9b4f839a2a7a35ced83ec`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T031716Z/inputs/declaration_dossier.md` (`2f1b49785913e31be9ec1ae36cf46e70900d7c45667685e6a1a3406bd7a65b66`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T031716Z/inputs/dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T031716Z/inputs/direct_review_packet.md` (`4dce1e698f513a92b73194d98d58ef127466f2f24a9475068c97f021fca62fe6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260829T031716Z/inputs/source_locator.json` (`dcc765a6cf7238e8da893ac080e4844555f6de6979e26dc210011ddc0c2ca177`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T085747Z/agent_outputs/adjudicator.json` (`2fb1be1b00e10b9d6c156f3a83c2fd7509216597280f6a1d0b1f9734fbcdcb9b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T085747Z/agent_outputs/agent_runs.json` (`9928ef85a4b4edb0ff578ed003c321bc7af19bbf91de87a081465f63b623ded2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T085747Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T085747Z/agent_outputs/blind_translation.json` (`433bef31eb99791552463c6b34f950fc726e654fe67d9a2d63e25afd4aeb3aab`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T085747Z/agent_outputs/direct_judge.json` (`469561a7aa132fb8d629112df69be239f583d810afd7a570b2e95d29ac86d55f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T085747Z/agent_outputs/roundtrip_judge.json` (`8a05e2631caafb05358f73d408362c5f97c0d97dd11549b1cc25af8f7007eb8f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T085747Z/agent_outputs/source_contract.json` (`adff9aede39da999850448665aad4b7049ff795d8d064e4e80510df456c69c73`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T085747Z/decision.json` (`d02ac59a6e841f1524c4376001ba663b2a58eb6678ebf54a6cd4178702d4e9c7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T085747Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T085747Z/inputs/blind_dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T085747Z/inputs/blind_dossier.md` (`82b82265edfc43a3c750398b24f68e2d8e17a95797e9b4f839a2a7a35ced83ec`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T085747Z/inputs/blind_review_packet.md` (`82b82265edfc43a3c750398b24f68e2d8e17a95797e9b4f839a2a7a35ced83ec`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T085747Z/inputs/declaration_dossier.md` (`4fcdd0f2507a43ccc5768d30d4ae29a95e2d695cbe35c77763a204e88dffb198`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T085747Z/inputs/dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T085747Z/inputs/direct_review_packet.md` (`4dce1e698f513a92b73194d98d58ef127466f2f24a9475068c97f021fca62fe6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T085747Z/inputs/source_locator.json` (`dcc765a6cf7238e8da893ac080e4844555f6de6979e26dc210011ddc0c2ca177`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T101948Z/agent_outputs/adjudicator.json` (`2fb1be1b00e10b9d6c156f3a83c2fd7509216597280f6a1d0b1f9734fbcdcb9b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T101948Z/agent_outputs/agent_runs.json` (`d3c0a6bc17ed5c3f537b6f4eaf1bf4d1aa5c71c51344f8cde6f2278a1e8f27f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T101948Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T101948Z/agent_outputs/blind_translation.json` (`433bef31eb99791552463c6b34f950fc726e654fe67d9a2d63e25afd4aeb3aab`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T101948Z/agent_outputs/direct_judge.json` (`469561a7aa132fb8d629112df69be239f583d810afd7a570b2e95d29ac86d55f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T101948Z/agent_outputs/roundtrip_judge.json` (`8a05e2631caafb05358f73d408362c5f97c0d97dd11549b1cc25af8f7007eb8f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T101948Z/agent_outputs/source_contract.json` (`adff9aede39da999850448665aad4b7049ff795d8d064e4e80510df456c69c73`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T101948Z/decision.json` (`ffe33d4f4363b51f0e5bcd6aeaa2f63b725968155c673ae0a2b96d8a8c3df841`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T101948Z/inputs/blind_dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T101948Z/inputs/blind_dossier.md` (`82b82265edfc43a3c750398b24f68e2d8e17a95797e9b4f839a2a7a35ced83ec`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T101948Z/inputs/blind_review_packet.md` (`82b82265edfc43a3c750398b24f68e2d8e17a95797e9b4f839a2a7a35ced83ec`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T101948Z/inputs/declaration_dossier.md` (`1ba6f0d81a6ce15da8d64508d788d26c8601abeef43ebab20b72f0933e80417d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T101948Z/inputs/dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T101948Z/inputs/direct_review_packet.md` (`4dce1e698f513a92b73194d98d58ef127466f2f24a9475068c97f021fca62fe6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T101948Z/inputs/source_locator.json` (`dcc765a6cf7238e8da893ac080e4844555f6de6979e26dc210011ddc0c2ca177`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T203556Z/agent_outputs/adjudicator.json` (`2fb1be1b00e10b9d6c156f3a83c2fd7509216597280f6a1d0b1f9734fbcdcb9b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T203556Z/agent_outputs/agent_runs.json` (`d3c0a6bc17ed5c3f537b6f4eaf1bf4d1aa5c71c51344f8cde6f2278a1e8f27f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T203556Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T203556Z/agent_outputs/blind_translation.json` (`433bef31eb99791552463c6b34f950fc726e654fe67d9a2d63e25afd4aeb3aab`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T203556Z/agent_outputs/direct_judge.json` (`469561a7aa132fb8d629112df69be239f583d810afd7a570b2e95d29ac86d55f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T203556Z/agent_outputs/roundtrip_judge.json` (`8a05e2631caafb05358f73d408362c5f97c0d97dd11549b1cc25af8f7007eb8f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T203556Z/agent_outputs/source_contract.json` (`adff9aede39da999850448665aad4b7049ff795d8d064e4e80510df456c69c73`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T203556Z/decision.json` (`a6c009c1cbe6014083fbaa2e8fbc11de1b948b37cc56b7d90f8469dbb64fc35d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T203556Z/inputs/blind_dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T203556Z/inputs/blind_dossier.md` (`82b82265edfc43a3c750398b24f68e2d8e17a95797e9b4f839a2a7a35ced83ec`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T203556Z/inputs/blind_review_packet.md` (`82b82265edfc43a3c750398b24f68e2d8e17a95797e9b4f839a2a7a35ced83ec`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T203556Z/inputs/declaration_dossier.md` (`450e25d0d0f7100edf0182bb3976ab4a722922380cc9a28e0806ecf7c5ba7b02`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T203556Z/inputs/dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T203556Z/inputs/direct_review_packet.md` (`4dce1e698f513a92b73194d98d58ef127466f2f24a9475068c97f021fca62fe6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/history/20260831T203556Z/inputs/source_locator.json` (`dcc765a6cf7238e8da893ac080e4844555f6de6979e26dc210011ddc0c2ca177`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/inputs/blind_dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/inputs/blind_dossier.md` (`82b82265edfc43a3c750398b24f68e2d8e17a95797e9b4f839a2a7a35ced83ec`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/inputs/blind_review_packet.md` (`82b82265edfc43a3c750398b24f68e2d8e17a95797e9b4f839a2a7a35ced83ec`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/inputs/declaration_dossier.md` (`97a4ce409c6a1be917084128c9450b06ca18e780e28baa4256577ecfd2d22ca6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/inputs/dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/inputs/direct_review_packet.md` (`4dce1e698f513a92b73194d98d58ef127466f2f24a9475068c97f021fca62fe6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.4/faithfulness/inputs/source_locator.json` (`dcc765a6cf7238e8da893ac080e4844555f6de6979e26dc210011ddc0c2ca177`)
