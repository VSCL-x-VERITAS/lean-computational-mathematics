# Faithfulness audit: LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908

## Decision

- Classification: `not-faithful-weaker`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `dd802ea4bfd8374675080aee981a3c054957eccf47ac1190b65034bd9dfbfd45`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The attached primary-source renderings and exact inline declarations resolve the disagreements without majority voting. The selected claim is the cell-averaging sentence on printed page 8; neighboring reflection and transmission claims are context, not additional required conclusions. The blind reconstruction matches the declaration. The target excludes equal-average cases and does not certify appropriate averaging, while its complete conditional follows directly from the supplied structures and premises. Accordingly the consistent classification is not-faithful-weaker. No tools were used, no target proof was inspected, and no source or rendering hashes were independently recomputed.

## Implications

- **Lean implies source:** `no`. As a representation of the selected source capability, the target only supplies assignments after assuming unequal averages and an abstract rule. Heterogeneous fields can have equal averages on all cells, so heterogeneity does not discharge that premise. The theorem gives no assignment conclusion in those source-permitted cases. Its two rule laws also do not establish appropriate material averaging. Deriving an independent unrestricted packaging lemma from the definitions would not restore the missing applicability of this fixed target.
- **Source implies lean:** `yes`. The entire Lean conditional follows from its own quantified structures and explicit hypotheses: wrap each output, apply the supplied locality and constant-preservation laws, and transport the supplied inequality through the record projection. Consequently it holds under the source context as well. This logical implication does not mean the source asserts the added premises or validates every admitted operator as appropriate averaging.

## Findings

- **major / reduced-applicability:** Equal-average configurations are omitted, including heterogeneous fields whose variation averages out within each cell. The restriction is not genuine theorem strength.
- **major / insufficient-averaging-semantics:** The declared laws do not establish appropriateness for material averaging; the measure and model arguments alone supply no such guarantee.
- **note / conditional-packaging:** The proposition is nonvacuously satisfiable but its conclusions follow independently of the source capability. This establishes the reverse logical implication without establishing semantic equivalence.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `fail` | `unclear` |
| `C03` | `fail` | `fail` |
| `C04` | `fail` | `fail` |
| `C05` | `fail` | `fail` |
| `C06` | `fail` | `unclear` |
| `C07` | `fail` | `fail` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `fail` | `fail` |
| `C11` | `fail` | `fail` |
| `C12` | `fail` | `pass` |
| `N01` | `fail` | `unclear` |
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `fail` | `unclear` |

## Dependency coverage

- Blind translator covered `40` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `40` dependencies (`2` hash-reused); failing or unclear: `D003, D004, D008, D014, D018`.

## Remaining uncertainties

- The selected source passage does not characterize appropriate averaging. It therefore does not settle which additional operator laws or model-specific admissibility conditions would suffice for a faithful abstraction. This uncertainty does not change the established applicability defect or the reverse logical implication.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/agent_outputs/adjudicator.json` (`8d040d961e3ad07249bbcd62b3ad4425a450cbbd12574aa4c004e728cfd23717`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`c7240db2798a9e2edf78f344eb107462aef97088524e3cfad47066ae83640782`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`4e5a17bec6084f74cd8eccfdf328432179d2f87087c9a0577abf3efe48db87fb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`8c6d38a0a690117a9005d9c2a4e90f31a5db0eeb24390e55f1f8a83f37cc2464`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`53cd9de6154f0391a8bfb1041a43b9959dd2f443b9d6c29a5bacbd0604cd0dc0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`3fbb39eb8c3c2aa1157f7bee06229d2698ef62352f1b854f7fa37a4e3dba2772`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/decision.json` (`6ee86257e622a3577b5e722e2def8d439ff3844d859c25ae6aea3831c9ed808e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`7b9cd66ecae451811d28ddd72b8eda511d994161f2d98fbc47a4dd5e44ae3ffd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`c30afb7f80c0ca9be9e9acb16a55472ffe917a07b801cd522acc174650161f12`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`c30afb7f80c0ca9be9e9acb16a55472ffe917a07b801cd522acc174650161f12`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`46c0da2419fe8a7580412213124f35009a8ac17b2ab2be614db791a28e71f0f4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`5ff83a5daad09f66b4fec95bf5a440393e9414fec222e84c07a7fcbb7da053cc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`530ff2178e5d808ba810e2dfcdc0cac0634b0b12d8c22ff425f9327923a02c13`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`4a80eb0f2e70a257db7c9c71dad27e23b7e830872522a02a2d19221c54420cac`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`6aaa14516c9c49f0f20b92e5e9188553fee0e8f73f784fcb094298b028dec229`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/a_events.jsonl` (`d5cc9ef497ef9d84786a4260fd36dc7a4d5607c1fb368664d6511dc80f139b7f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/a_final.json` (`8d040d961e3ad07249bbcd62b3ad4425a450cbbd12574aa4c004e728cfd23717`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/a_input.txt` (`998aa17a31bd3df7b1e3ed1bd275836aa6a18dacf57fcf4231fd0a13891efdf0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/a_runtime.json` (`def37f79eeaa44afba1e2432729c98ffb32fa008ee6667602344f9f3794a3f1c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/a_stderr.txt` (`07cb8910cf2c6cda9cb8b2c5b35c4c680263b6f094b8dfed33410797e2eb226d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/a_transport.json` (`aa5febdd59807e233ab684a105dcda961e4de662f24930e7e196f61a4956fadb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`dce91a307ed88a28565db79310216c45b05856fc67a5851fb4aa43edbc5c65e4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/adjudication_triggers.json` (`f44262073b968cbbc0052034b6e5b6eb9ca9f0a022a54bbe4ddbbd4f21d18e86`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`373099c312f5d769cd6423d0279e7262ae0db336d6ab37e5de96cc6659dc5c09`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`4e5a17bec6084f74cd8eccfdf328432179d2f87087c9a0577abf3efe48db87fb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`c8da322e9162b2b2b805ca6e289e3a7cef0f5fb0f672dd6c68d58eb68fe9b258`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`1761ee5457a99cb3da7a236b2e6cc609b4aef6a506a17382987021d1d49f0c1b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`436dfaffe9089e8aad0f55de06d7423dd3bbbb95371d8b481823db8a2f1dd6cc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`14d1a790a6c318cf2efd9c87a259c6c53ba87657c31684d394b1665e30a2119f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`99559b35d69d5117b0443983aa07630f6c0cad8238e9f1ec85d0e67083f9e3c0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`8c6d38a0a690117a9005d9c2a4e90f31a5db0eeb24390e55f1f8a83f37cc2464`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`0887ba471465f93e0f4d4e6fbb652490774941e9fbf1a4518f19df27e4a4b0a8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`a848cc950fd1f15699f1111c5340c09584dc8b91a46fad7f0f3847686e5d008c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`c1ff5696b1be6a1556f67272c1b9155751bab23444c931e9b555033c0bd3fd16`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`1047cccce908a386cad497ec748fadbbeb4169bb85eb6790da693598f0e4fdf0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/direct_reuse_preparation_20260908.json` (`9ebc54d4318c8d2af5c0e8998a01f89ff1677259297143ebf95f29f995581579`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/page-029.png` (`38ddcc8e4f9afb72079edd7484088dea7c2d299b72df4e78113ca972fa2c816b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/page-030.png` (`ae7d4dfee2a41e3a9c4d65b47cf17f0bffe1704f5cd9b67675d85ba70a190931`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`eded46c163e32eb4a112d4254ce92d15300c18f43b647b68472e90dd15eadcdb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`53cd9de6154f0391a8bfb1041a43b9959dd2f443b9d6c29a5bacbd0604cd0dc0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`62e4bedbfd5f74069185545a28bd03ce8d13dc32c8caeca0bfce70be29d91943`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`3e673be0622691081c08405463d8e45514539bb3dc30192bc1939b0f7200ffea`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`e48071e83f9ab992014df511d8903efba3c76314defaee21f56c28ac1c6f3bb5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`61c49c4da1448c4933b2e1a9def0de8c02ee079c1a5126ccd65e033529091ea4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-apply_dependency_reuse.stderr.txt` (`e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-apply_dependency_reuse.stdout.txt` (`9ca9583847f6ff19f068fd0b189e917087a7a2d89f0e79350307cca62825246e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-validate_audit.stderr.txt` (`e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-validate_audit.stdout.txt` (`a51e6f55581d5a136d27aecc668e0ba1ac765ceafd78870f66db30b3b4a6a7d9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`1f7b069624dfb9a9dbbd04745d520e0d2d3471b1bb1d4960f4a6b95ff39e1e4e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`3fbb39eb8c3c2aa1157f7bee06229d2698ef62352f1b854f7fa37a4e3dba2772`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`f3ce2076d1d38bd434165da8ce1ccd162df743a1f3c4a0d49e7e550a51616042`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`a4950bd99d6621820ecebedb612bcafaa4258112a9c6b8f221dddd14eb368611`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`ee0ad8f7492f443f6a37b727b283e36434cda85a7d5902bee13681ce43984680`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`1a89fbf6111db7f8c6abe44b1950fcbec602cf3abcb866523d1cfc92bfbf00b5`)
