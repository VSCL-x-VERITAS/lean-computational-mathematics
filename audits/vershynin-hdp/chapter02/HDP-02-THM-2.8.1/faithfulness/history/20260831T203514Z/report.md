# Faithfulness audit: HDP-02-THM-2.8.1

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `75f95d4891e3ba80a9ff155b4501f1e08172d525dd278570ec40a7c39c3fe3c5`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

Primary source and proof-free Lean evidence establish substantive equivalence on every nondegenerate family and establish nonvacuity. They do not establish a meaning for the source's displayed quotients when all psi_1 norms vanish. The direct judge's affirmative verdicts depend on an unstated intended convention, while the round-trip judge preserves the source silence. The adjudication therefore retains both implications as unclear, classifies the task as undetermined, and does not accept it.

## Implications

- **Lean implies source:** `unclear`. For every nonempty family with at least one positive psi_1 gauge, the Lean proposition matches the source result and implies it. For the all-zero family, Lean has definite totalized-division semantics while the source formula has no specified denominator-zero meaning, so the unrestricted implication cannot be certified.
- **Source implies lean:** `unclear`. On the positive-maximum-gauge domain, the source and Lean statements coincide. On the all-zero family, deriving Lean's specific totalized statement would require a source convention or exclusion absent from the pinned passage, so the unrestricted implication remains unclear.

## Findings

- **major / source-silent-zero-denominator-boundary:** Both implication directions and therefore exact statement faithfulness remain undetermined on the complete stated domain.
- **note / nondegenerate-equivalence:** The unresolved issue is confined to the degenerate all-zero boundary and does not indicate a mismatch on ordinary nondegenerate instances.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `unclear` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `unclear` | `unclear` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `93` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `93` dependencies (`0` hash-reused); failing or unclear: `D005, D017, D050, D073`.

## Remaining uncertainties

- The pinned source does not say whether the all-zero family is excluded or how t squared divided by zero and t divided by zero are to be interpreted when every psi_1 norm vanishes.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/agent_outputs/adjudicator.json` (`29e5009f2f573b595ab73ad086da7227ad83b802124c2520a5bedbf92c15f357`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/agent_outputs/agent_runs.json` (`7ded8918a0b77370b5f610bd8449121956f251a8099207e97a8bea0b3159bd8e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/agent_outputs/blind_translation.json` (`cf6337d9a86b900f4af95638e02acad76a19dc616b102610ba8e9de0a130b87f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/agent_outputs/direct_judge.json` (`578a7960e0711935f86707ed7aa40b5774c1229ba21ec48ef21021b472b2de6d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/agent_outputs/roundtrip_judge.json` (`6ae77d3342995250f16b6ec1c73b19a769a248708fa635e1b13cb4bd44c3c3c2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/agent_outputs/source_contract.json` (`7c41caa614ffcce62ea24ffe335aa1ff2854f7e176dcc3f1c9fa52be2f723e87`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/decision.json` (`86daf55d23282a47fad2d8b0a7430e19b943208c9e354f20bde7ad56bd66102a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T024634Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T024634Z/inputs/blind_dependency_inventory.json` (`ab63f33840d0b35e0cbf8e51c60e8aae33f18e057af289a123aeaaa4f1d33f7b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T024634Z/inputs/blind_dossier.md` (`58abf17f1eb0124a5f0bd21f456223643d15465b2f573b5ac26384f69be46e76`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T024634Z/inputs/blind_review_packet.md` (`58abf17f1eb0124a5f0bd21f456223643d15465b2f573b5ac26384f69be46e76`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T024634Z/inputs/declaration_dossier.md` (`f048122b77154529d594513335a5fc97884b4f86f982fadca74724f3f6d60eab`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T024634Z/inputs/dependency_inventory.json` (`b583e6d5bf4932bb1008521943479076f41ef67a20084985256337b68cedcf2a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T024634Z/inputs/direct_review_packet.md` (`19b0ba158c9b4319cd6482097a31b27413d3ab257978bd1149e6535358e4354b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T024634Z/inputs/source_locator.json` (`1b6139c819261803757065d9b1e4943c0bcc65e67ed2397c91f8a87cc5cdda67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T030220Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T030220Z/inputs/blind_dependency_inventory.json` (`ab63f33840d0b35e0cbf8e51c60e8aae33f18e057af289a123aeaaa4f1d33f7b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T030220Z/inputs/blind_dossier.md` (`58abf17f1eb0124a5f0bd21f456223643d15465b2f573b5ac26384f69be46e76`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T030220Z/inputs/blind_review_packet.md` (`58abf17f1eb0124a5f0bd21f456223643d15465b2f573b5ac26384f69be46e76`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T030220Z/inputs/declaration_dossier.md` (`f048122b77154529d594513335a5fc97884b4f86f982fadca74724f3f6d60eab`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T030220Z/inputs/dependency_inventory.json` (`b583e6d5bf4932bb1008521943479076f41ef67a20084985256337b68cedcf2a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T030220Z/inputs/direct_review_packet.md` (`19b0ba158c9b4319cd6482097a31b27413d3ab257978bd1149e6535358e4354b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T030220Z/inputs/source_locator.json` (`1b6139c819261803757065d9b1e4943c0bcc65e67ed2397c91f8a87cc5cdda67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T221507Z/agent_outputs/agent_runs.json` (`30332003d5129fcee868cd8f060e85c4391a2e7ec4f7635ccc13861344b2a308`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T221507Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T221507Z/agent_outputs/source_contract.json` (`7c41caa614ffcce62ea24ffe335aa1ff2854f7e176dcc3f1c9fa52be2f723e87`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T221507Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T221507Z/inputs/blind_dependency_inventory.json` (`b6ffe38ec88fd9bfa0526d7c65a79f369321f463d7c0272def583bed5a98fd96`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T221507Z/inputs/blind_dossier.md` (`5e91428a5d6db76d8c040d05336b330c4ce07a5b107e35cf1cb43e2cb76a7d61`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T221507Z/inputs/blind_review_packet.md` (`5e91428a5d6db76d8c040d05336b330c4ce07a5b107e35cf1cb43e2cb76a7d61`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T221507Z/inputs/declaration_dossier.md` (`8fb521172cc90d0e06261f31c873ecae8cd7cae33020483f4b0e0da5f046d8c2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T221507Z/inputs/dependency_inventory.json` (`1cd5e067c00db599d48cc4e89ae9021007f24bb2e130684c64377ef2a3dff7b6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T221507Z/inputs/direct_review_packet.md` (`4c97638a6eaad99c78ec0ba5b75b5280b2cb476a4055a486c33cf82827a09012`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T221507Z/inputs/source_locator.json` (`1b6139c819261803757065d9b1e4943c0bcc65e67ed2397c91f8a87cc5cdda67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T230029Z/agent_outputs/agent_runs.json` (`f2fd187b6578ec79d97f3f7cf16b0ac5c6d3dd81cb0d31df9c8c491492f98650`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T230029Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T230029Z/agent_outputs/source_contract.json` (`7c41caa614ffcce62ea24ffe335aa1ff2854f7e176dcc3f1c9fa52be2f723e87`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T230029Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T230029Z/inputs/blind_dependency_inventory.json` (`141260d71d7115be877186e835ebfbba1166ae5a2d9e199731866f6dacbe6bbf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T230029Z/inputs/blind_dossier.md` (`81959cf97635cb3dd843acb0c9334f97338e9234e99367a94a7d395c4042a63c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T230029Z/inputs/blind_review_packet.md` (`81959cf97635cb3dd843acb0c9334f97338e9234e99367a94a7d395c4042a63c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T230029Z/inputs/declaration_dossier.md` (`855e50ad85726172c8fbc83b46133ee5d9d6339999d972e27b804383e7e96d46`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T230029Z/inputs/dependency_inventory.json` (`cfa711f675f5fb9559b8e2bd280e5300d49197a1abb53e63c5c2b9d7c127bb5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T230029Z/inputs/direct_review_packet.md` (`ffc8af6f5d5e86ea5c9ebe31c62e8ad23ecabc8eb87ba7c78ab84f87a669e532`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260828T230029Z/inputs/source_locator.json` (`1b6139c819261803757065d9b1e4943c0bcc65e67ed2397c91f8a87cc5cdda67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T002848Z/agent_outputs/agent_runs.json` (`f2fd187b6578ec79d97f3f7cf16b0ac5c6d3dd81cb0d31df9c8c491492f98650`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T002848Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T002848Z/agent_outputs/source_contract.json` (`7c41caa614ffcce62ea24ffe335aa1ff2854f7e176dcc3f1c9fa52be2f723e87`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T002848Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T002848Z/inputs/blind_dependency_inventory.json` (`141260d71d7115be877186e835ebfbba1166ae5a2d9e199731866f6dacbe6bbf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T002848Z/inputs/blind_dossier.md` (`81959cf97635cb3dd843acb0c9334f97338e9234e99367a94a7d395c4042a63c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T002848Z/inputs/blind_review_packet.md` (`81959cf97635cb3dd843acb0c9334f97338e9234e99367a94a7d395c4042a63c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T002848Z/inputs/declaration_dossier.md` (`855e50ad85726172c8fbc83b46133ee5d9d6339999d972e27b804383e7e96d46`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T002848Z/inputs/dependency_inventory.json` (`cfa711f675f5fb9559b8e2bd280e5300d49197a1abb53e63c5c2b9d7c127bb5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T002848Z/inputs/direct_review_packet.md` (`ffc8af6f5d5e86ea5c9ebe31c62e8ad23ecabc8eb87ba7c78ab84f87a669e532`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T002848Z/inputs/source_locator.json` (`1b6139c819261803757065d9b1e4943c0bcc65e67ed2397c91f8a87cc5cdda67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T014629Z/agent_outputs/adjudicator.json` (`29e5009f2f573b595ab73ad086da7227ad83b802124c2520a5bedbf92c15f357`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T014629Z/agent_outputs/agent_runs.json` (`f027d4d50a69036e3c72ed1967b4c8c230e204f3f0706aede85573a0a6628c21`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T014629Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T014629Z/agent_outputs/blind_translation.json` (`cf6337d9a86b900f4af95638e02acad76a19dc616b102610ba8e9de0a130b87f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T014629Z/agent_outputs/direct_judge.json` (`578a7960e0711935f86707ed7aa40b5774c1229ba21ec48ef21021b472b2de6d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T014629Z/agent_outputs/roundtrip_judge.json` (`6ae77d3342995250f16b6ec1c73b19a769a248708fa635e1b13cb4bd44c3c3c2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T014629Z/agent_outputs/source_contract.json` (`7c41caa614ffcce62ea24ffe335aa1ff2854f7e176dcc3f1c9fa52be2f723e87`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T014629Z/decision.json` (`f57474dcfed826cd90500214faca3be92c770ad5d9d93a8f084ab54ab97527e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T014629Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T014629Z/inputs/blind_dependency_inventory.json` (`141260d71d7115be877186e835ebfbba1166ae5a2d9e199731866f6dacbe6bbf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T014629Z/inputs/blind_dossier.md` (`ef29da9e1a96481aeac787ba3a8acd1b54967e299c77f75b267b5503703b74e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T014629Z/inputs/blind_review_packet.md` (`ef29da9e1a96481aeac787ba3a8acd1b54967e299c77f75b267b5503703b74e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T014629Z/inputs/declaration_dossier.md` (`db73ec7b5ec6bbc8a7cea9c864908b37e76d276e5da1c6bb5f51dbd2418c4e9c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T014629Z/inputs/dependency_inventory.json` (`cfa711f675f5fb9559b8e2bd280e5300d49197a1abb53e63c5c2b9d7c127bb5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T014629Z/inputs/direct_review_packet.md` (`c782883471578407f88907dc428265d4fd961060874c3c906a965217892826b8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T014629Z/inputs/source_locator.json` (`1b6139c819261803757065d9b1e4943c0bcc65e67ed2397c91f8a87cc5cdda67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T021246Z/agent_outputs/adjudicator.json` (`29e5009f2f573b595ab73ad086da7227ad83b802124c2520a5bedbf92c15f357`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T021246Z/agent_outputs/agent_runs.json` (`f027d4d50a69036e3c72ed1967b4c8c230e204f3f0706aede85573a0a6628c21`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T021246Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T021246Z/agent_outputs/blind_translation.json` (`cf6337d9a86b900f4af95638e02acad76a19dc616b102610ba8e9de0a130b87f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T021246Z/agent_outputs/direct_judge.json` (`578a7960e0711935f86707ed7aa40b5774c1229ba21ec48ef21021b472b2de6d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T021246Z/agent_outputs/roundtrip_judge.json` (`6ae77d3342995250f16b6ec1c73b19a769a248708fa635e1b13cb4bd44c3c3c2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T021246Z/agent_outputs/source_contract.json` (`7c41caa614ffcce62ea24ffe335aa1ff2854f7e176dcc3f1c9fa52be2f723e87`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T021246Z/decision.json` (`6fd8f0738c4dbc2828a5da21b1b274b8b3012bb390e03e2a83d5791fb8f5ddf5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T021246Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T021246Z/inputs/blind_dependency_inventory.json` (`141260d71d7115be877186e835ebfbba1166ae5a2d9e199731866f6dacbe6bbf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T021246Z/inputs/blind_dossier.md` (`ef29da9e1a96481aeac787ba3a8acd1b54967e299c77f75b267b5503703b74e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T021246Z/inputs/blind_review_packet.md` (`ef29da9e1a96481aeac787ba3a8acd1b54967e299c77f75b267b5503703b74e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T021246Z/inputs/declaration_dossier.md` (`db73ec7b5ec6bbc8a7cea9c864908b37e76d276e5da1c6bb5f51dbd2418c4e9c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T021246Z/inputs/dependency_inventory.json` (`cfa711f675f5fb9559b8e2bd280e5300d49197a1abb53e63c5c2b9d7c127bb5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T021246Z/inputs/direct_review_packet.md` (`c782883471578407f88907dc428265d4fd961060874c3c906a965217892826b8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T021246Z/inputs/source_locator.json` (`1b6139c819261803757065d9b1e4943c0bcc65e67ed2397c91f8a87cc5cdda67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T023453Z/agent_outputs/adjudicator.json` (`29e5009f2f573b595ab73ad086da7227ad83b802124c2520a5bedbf92c15f357`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T023453Z/agent_outputs/agent_runs.json` (`f027d4d50a69036e3c72ed1967b4c8c230e204f3f0706aede85573a0a6628c21`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T023453Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T023453Z/agent_outputs/blind_translation.json` (`cf6337d9a86b900f4af95638e02acad76a19dc616b102610ba8e9de0a130b87f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T023453Z/agent_outputs/direct_judge.json` (`578a7960e0711935f86707ed7aa40b5774c1229ba21ec48ef21021b472b2de6d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T023453Z/agent_outputs/roundtrip_judge.json` (`6ae77d3342995250f16b6ec1c73b19a769a248708fa635e1b13cb4bd44c3c3c2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T023453Z/agent_outputs/source_contract.json` (`7c41caa614ffcce62ea24ffe335aa1ff2854f7e176dcc3f1c9fa52be2f723e87`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T023453Z/decision.json` (`12603b86f5eaf946c24aa8dc2162c7297eb64883b0c0d09afe1e5a4988902025`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T023453Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T023453Z/inputs/blind_dependency_inventory.json` (`141260d71d7115be877186e835ebfbba1166ae5a2d9e199731866f6dacbe6bbf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T023453Z/inputs/blind_dossier.md` (`ef29da9e1a96481aeac787ba3a8acd1b54967e299c77f75b267b5503703b74e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T023453Z/inputs/blind_review_packet.md` (`ef29da9e1a96481aeac787ba3a8acd1b54967e299c77f75b267b5503703b74e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T023453Z/inputs/declaration_dossier.md` (`db73ec7b5ec6bbc8a7cea9c864908b37e76d276e5da1c6bb5f51dbd2418c4e9c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T023453Z/inputs/dependency_inventory.json` (`cfa711f675f5fb9559b8e2bd280e5300d49197a1abb53e63c5c2b9d7c127bb5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T023453Z/inputs/direct_review_packet.md` (`c782883471578407f88907dc428265d4fd961060874c3c906a965217892826b8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T023453Z/inputs/source_locator.json` (`1b6139c819261803757065d9b1e4943c0bcc65e67ed2397c91f8a87cc5cdda67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T031613Z/agent_outputs/adjudicator.json` (`29e5009f2f573b595ab73ad086da7227ad83b802124c2520a5bedbf92c15f357`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T031613Z/agent_outputs/agent_runs.json` (`f027d4d50a69036e3c72ed1967b4c8c230e204f3f0706aede85573a0a6628c21`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T031613Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T031613Z/agent_outputs/blind_translation.json` (`cf6337d9a86b900f4af95638e02acad76a19dc616b102610ba8e9de0a130b87f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T031613Z/agent_outputs/direct_judge.json` (`578a7960e0711935f86707ed7aa40b5774c1229ba21ec48ef21021b472b2de6d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T031613Z/agent_outputs/roundtrip_judge.json` (`6ae77d3342995250f16b6ec1c73b19a769a248708fa635e1b13cb4bd44c3c3c2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T031613Z/agent_outputs/source_contract.json` (`7c41caa614ffcce62ea24ffe335aa1ff2854f7e176dcc3f1c9fa52be2f723e87`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T031613Z/decision.json` (`22eb54ebc819645eb879cb5d2091636a5d181f3daf41fc51231d508495a19eee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T031613Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T031613Z/inputs/blind_dependency_inventory.json` (`141260d71d7115be877186e835ebfbba1166ae5a2d9e199731866f6dacbe6bbf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T031613Z/inputs/blind_dossier.md` (`ef29da9e1a96481aeac787ba3a8acd1b54967e299c77f75b267b5503703b74e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T031613Z/inputs/blind_review_packet.md` (`ef29da9e1a96481aeac787ba3a8acd1b54967e299c77f75b267b5503703b74e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T031613Z/inputs/declaration_dossier.md` (`db73ec7b5ec6bbc8a7cea9c864908b37e76d276e5da1c6bb5f51dbd2418c4e9c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T031613Z/inputs/dependency_inventory.json` (`cfa711f675f5fb9559b8e2bd280e5300d49197a1abb53e63c5c2b9d7c127bb5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T031613Z/inputs/direct_review_packet.md` (`c782883471578407f88907dc428265d4fd961060874c3c906a965217892826b8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260829T031613Z/inputs/source_locator.json` (`1b6139c819261803757065d9b1e4943c0bcc65e67ed2397c91f8a87cc5cdda67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T085538Z/agent_outputs/adjudicator.json` (`29e5009f2f573b595ab73ad086da7227ad83b802124c2520a5bedbf92c15f357`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T085538Z/agent_outputs/agent_runs.json` (`f027d4d50a69036e3c72ed1967b4c8c230e204f3f0706aede85573a0a6628c21`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T085538Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T085538Z/agent_outputs/blind_translation.json` (`cf6337d9a86b900f4af95638e02acad76a19dc616b102610ba8e9de0a130b87f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T085538Z/agent_outputs/direct_judge.json` (`578a7960e0711935f86707ed7aa40b5774c1229ba21ec48ef21021b472b2de6d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T085538Z/agent_outputs/roundtrip_judge.json` (`6ae77d3342995250f16b6ec1c73b19a769a248708fa635e1b13cb4bd44c3c3c2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T085538Z/agent_outputs/source_contract.json` (`7c41caa614ffcce62ea24ffe335aa1ff2854f7e176dcc3f1c9fa52be2f723e87`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T085538Z/decision.json` (`e0a669e725b870b66825a6d0a8fcb5b3ddd9bdb54557d8e0bf16d986677bfc60`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T085538Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T085538Z/inputs/blind_dependency_inventory.json` (`141260d71d7115be877186e835ebfbba1166ae5a2d9e199731866f6dacbe6bbf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T085538Z/inputs/blind_dossier.md` (`ef29da9e1a96481aeac787ba3a8acd1b54967e299c77f75b267b5503703b74e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T085538Z/inputs/blind_review_packet.md` (`ef29da9e1a96481aeac787ba3a8acd1b54967e299c77f75b267b5503703b74e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T085538Z/inputs/declaration_dossier.md` (`ac1d51258943da07d448b7c75d24d675329145c8a0f4425bff56c83fe3f85584`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T085538Z/inputs/dependency_inventory.json` (`cfa711f675f5fb9559b8e2bd280e5300d49197a1abb53e63c5c2b9d7c127bb5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T085538Z/inputs/direct_review_packet.md` (`c782883471578407f88907dc428265d4fd961060874c3c906a965217892826b8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T085538Z/inputs/source_locator.json` (`1b6139c819261803757065d9b1e4943c0bcc65e67ed2397c91f8a87cc5cdda67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T101945Z/agent_outputs/adjudicator.json` (`29e5009f2f573b595ab73ad086da7227ad83b802124c2520a5bedbf92c15f357`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T101945Z/agent_outputs/agent_runs.json` (`7ded8918a0b77370b5f610bd8449121956f251a8099207e97a8bea0b3159bd8e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T101945Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T101945Z/agent_outputs/blind_translation.json` (`cf6337d9a86b900f4af95638e02acad76a19dc616b102610ba8e9de0a130b87f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T101945Z/agent_outputs/direct_judge.json` (`578a7960e0711935f86707ed7aa40b5774c1229ba21ec48ef21021b472b2de6d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T101945Z/agent_outputs/roundtrip_judge.json` (`6ae77d3342995250f16b6ec1c73b19a769a248708fa635e1b13cb4bd44c3c3c2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T101945Z/agent_outputs/source_contract.json` (`7c41caa614ffcce62ea24ffe335aa1ff2854f7e176dcc3f1c9fa52be2f723e87`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T101945Z/decision.json` (`4b47eaf92f93f43cb3b90184fc6dc924eb53aec14e3ebef640516db097cc462f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T101945Z/inputs/blind_dependency_inventory.json` (`141260d71d7115be877186e835ebfbba1166ae5a2d9e199731866f6dacbe6bbf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T101945Z/inputs/blind_dossier.md` (`ef29da9e1a96481aeac787ba3a8acd1b54967e299c77f75b267b5503703b74e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T101945Z/inputs/blind_review_packet.md` (`ef29da9e1a96481aeac787ba3a8acd1b54967e299c77f75b267b5503703b74e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T101945Z/inputs/declaration_dossier.md` (`628c0fd220a67619b73d620e643883927092bc5598443f09813dedc883a80405`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T101945Z/inputs/dependency_inventory.json` (`cfa711f675f5fb9559b8e2bd280e5300d49197a1abb53e63c5c2b9d7c127bb5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T101945Z/inputs/direct_review_packet.md` (`c782883471578407f88907dc428265d4fd961060874c3c906a965217892826b8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/history/20260831T101945Z/inputs/source_locator.json` (`1b6139c819261803757065d9b1e4943c0bcc65e67ed2397c91f8a87cc5cdda67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/inputs/blind_dependency_inventory.json` (`141260d71d7115be877186e835ebfbba1166ae5a2d9e199731866f6dacbe6bbf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/inputs/blind_dossier.md` (`ef29da9e1a96481aeac787ba3a8acd1b54967e299c77f75b267b5503703b74e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/inputs/blind_review_packet.md` (`ef29da9e1a96481aeac787ba3a8acd1b54967e299c77f75b267b5503703b74e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/inputs/declaration_dossier.md` (`158f2cbba6624adc26780c90a735ae8921ad7189b8b95a2103b6c26cbf3bff24`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/inputs/dependency_inventory.json` (`cfa711f675f5fb9559b8e2bd280e5300d49197a1abb53e63c5c2b9d7c127bb5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/inputs/direct_review_packet.md` (`c782883471578407f88907dc428265d4fd961060874c3c906a965217892826b8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1/faithfulness/inputs/source_locator.json` (`1b6139c819261803757065d9b1e4943c0bcc65e67ed2397c91f8a87cc5cdda67`)
