# Faithfulness audit: LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `af6663917b1d2008418502e2ffcc9e2c138665acea35067fd9b97cc6187c5f66`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the attached source pages and inline declarations resolves the scope, abstraction, origin-value, and nonvacuity disputes in favor of conditional data-level equivalence under the recorded coordinator-selected interpretation. It does not resolve the explicitly missing neighborhood-filter referent. Both implication verdicts therefore remain unclear and the classification is consistently undetermined. No majority vote, target proof, external lookup, or independently recomputed hash is used.

## Implications

- **Lean implies source:** `unclear`. Under the recorded coordinator-selected interpretation and the standard neighborhood-filter meaning of nhds, the target implies the selected simultaneous-interface data claim. It preserves distinct material and state traces, their common interface, and exact strict-half-line initial states without prescribing origin values or global material constancy. No equation-construction or wave-dynamics conclusion is required for this scoped comparison. However, the supplied declaration evidence does not expose the referent of D026, so the exact limit semantics cannot be independently certified.
- **Source implies lean:** `unclear`. Under the recorded coordinator-selected interpretation and standard topology semantics, constant initial branches provide state limits; pairing provides product limits; Hausdorff limit uniqueness gives both failures of continuity; and choosing initialState(0) supplies the origin witness. These arguments apply to the abstract Hausdorff formulation without requiring an additional physical law. The mathematical direction is supported conditionally, but the unresolved D026 declaration prevents unconditional certification from the permitted evidence.

## Findings

- **major / incomplete-semantic-evidence:** The intended mathematics aligns, but exact declaration-based acceptance remains unsupported. This finding concerns evidence completeness, not a proved false or unfaithful theorem.
- **note / interpretation-qualified-scope:** The missing equation binder does not defeat this scoped data comparison. Any eventual acceptance must retain the recorded interpretation and must not certify a complete interface problem, reflection/transmission dynamics, or well-posedness.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `unclear` |
| `C06` | `pass` | `unclear` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `unclear` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `pass` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `pass` | `pass` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `31` dependencies (`0` hash-reused); unclear: `D026`.
- Direct judge covered `31` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

- D026 exposes only wrapped✝.1. Its referent or a declaration-level neighborhood characterization is needed to close the exact semantic dependency check. No implementation defect has been demonstrated.
- The book alone does not explicitly prescribe the selected distinct-local-trace convention or settle equal-state degeneracy. The conditional alignment established here applies only under the recorded coordinator-selected interpretation and does not resolve those printed-source ambiguities.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`e3d3ed5034796557674f2429c6b70f42acfab9701d989d107f25496e4d82ac26`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`ac66970f6a2fa8be6bacb84bd75ca4475b30cb59a51f580f329809fe88c659c8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`bcaf84c69e97e74fb6c3895c222f9874b68f19ca95a43c950db4d92769589e35`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`1645f24e3eb63e95f6cc9591cecebe5dc7578a9913b57f701eea90c959a8b4b0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`a79ac704221dc6f6e5ce591fe9e0188919d707fbd4af16ddbf8aae97e81f9a84`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`a2a4e9435867ddb1f2f103b1120033cf25df4c0dba96ed0f294d2b88a4c82c67`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/decision.json` (`f433f366be27431df39969cbc45d0c3584baf611929e9c99c34526ff0ab3eead`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`03105274d759138764c41f541a60be2e70062989d15ba4d8a4e9c971d6aa64a4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`3a0c0fa956dea10d97e4178e3297b467f1fad8460a50c9f4da192b878d08a80a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`3a0c0fa956dea10d97e4178e3297b467f1fad8460a50c9f4da192b878d08a80a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`1b7a81dff33dd81ec42bc6a4687413bc590d340c70b3a3a7654c0a07bf71c4e7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`6f4829bf1f56509c6a1ade4b6db037b5a77aad27a0f5aaf8218da95a238f2e78`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`0b83fa1168dcaf7fb38435e7dc29e6facd54e53cf3c21e93f7e873dfdf20e45d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`7f78e81822e049c15359f682c11c7fb528f08f2b62b755250f78b471661accb4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`1763b01e95fd20a9c3a5e02c055eb89997f5d7344315a312d838883115e2c42f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`e3d3ed5034796557674f2429c6b70f42acfab9701d989d107f25496e4d82ac26`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`b2ed50e56ebeac119977514360220648e134bef0915fe11e714a7ddb53668631`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`3a0ca9decdc5b5710b88107e76ec969d5c4a68ddeecaead87acbb06113264f9c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`1d505adaff5163a82f68bf8efab76d7d24e69d151fd1c1b7fb382a2f87fb30af`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`f38015b64f4b53beb0a660748e6a5985e105925870d6156325d3bc26a0f2a477`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`be2f686ff74874ae8c022accd775abde7b8b7baeb45e39d6b8126db7b17c0279`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`2691b168bbfd20fdb4e7015b0e416b223624cc84860cd9b71d0ee80775c69e9c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`bcaf84c69e97e74fb6c3895c222f9874b68f19ca95a43c950db4d92769589e35`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`9bae35118e41e5d741de7a92d3602c872508f14aec7b9d02570128365beb488d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`0cb70b62d49d99cebf777dadefa2d5bd788127b3ec810fd62bc3374004208d69`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`d53f8e48a556e7c54257c52581216db2a0144817313105d9c90ef43dd0ad2398`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`6704078a0e9869c32ec5a073381aca015e60f11a105f93d0979842c4372bb637`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/c.py` (`22e04ce27fb5c0d27ce3a659b41c3ca67a5ce757e4d43f158945f6b90dad531d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`59ae95c22c1465f37dbabd07fda98112296dfddb46d0741385d810e0a34c192e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`1645f24e3eb63e95f6cc9591cecebe5dc7578a9913b57f701eea90c959a8b4b0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`1c12c88e0608318ff05acb0da6feb4ccca9de7a57f25e292dafda367528c1737`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`20398b8040e4e9a8c82195f4848b42cefc7c9fbf12d2a4b238bf2470d8aa62be`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`6bc839e50e78f4a65aeb92aa99ee499869f2af56ea211fa8b27ee74e7b03bd9e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`6d4376acefe503329fc32b71a57c5f2e2e5dd34928a7dc8970af64a8bd8cfc42`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`b23d80176b69db0cebf8fee1fcb4c64ace36777dae21a61097a3090ec29e2ac6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/page-029.png` (`4761f39e0daa52023709eb5180beddc142e1e0aa54112fef39059d81caa737d8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/page-030.png` (`da658725af4b8a2b539d19ce5201c239a181999fd1cd4161e1cabb5a54c2288a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/q.py` (`e8d7a5e703ea393777b9f1dc887b490cd2fadb064dcab96840fc91aa56f38228`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/r.py` (`3e054005793f2724758bc903d77d8f50d8bb06188b2811cb2de9a975630056eb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`5ca218001b03aa784e6e6a6ccdc39c139f3f69845748b74d3ad1e663180f8d4b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`a79ac704221dc6f6e5ce591fe9e0188919d707fbd4af16ddbf8aae97e81f9a84`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`dc627be69ec7259127896f69610b40583f14a2c6807b678f48ded5517e674e56`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`6207ba2d40fa86fa940fbd4005a4edb6e10e2cfe8a57d6fcb1e8d7f2dd62bc76`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`2224493d3532d6016d2a319952647afd07ae6eba6604b52d3cb29f972f17f5c0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`34d99e2e6239162a3ff4b616851fa6ebafac5595c18062bbf24d7b8153a014d0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`f56b8403649e8efe093cee3109fb8482eda7e504fb571068bc003e8b644a2664`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`a2a4e9435867ddb1f2f103b1120033cf25df4c0dba96ed0f294d2b88a4c82c67`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`a722245818934f090f7cc39876e4a0cbf248028ce9ef1505f61ff7ce874cc9bf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`b2c01d6fac4674d7f6706b3e14a4a963d80de5e7ca9aff7e5705c06eea7c9df6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`892d69e748287afbcdc5e588dbb9bf6f63db4606576ed597ddcc8334c3dc9bba`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`9a733bf54285dc69b39ec3bacc94bae55945a08cdac13a63f97b09243a9373d4`)
