# Faithfulness audit: LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `1d611322709c0eba7333cea1af15c9238204a1ccd839487b45f295b88bcdde6b`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The target faithfully characterizes the selected passage's notation: the state at zero similarity coordinate is exactly the common positive-time value q(0,t). The equation and ordered initial data remain explicit contextual premises, vector states are supported, and no solver existence or uniqueness claim is introduced. The general state type and abstract equation predicate are harmless abstractions for this definition. All dependencies and configured checks have been assessed from the supplied evidence.

## Implications

- **Lean implies source:** `yes`. Under the source context, supply the equation predicate, ordered Riemann data, and selected similarity solution q. D001 expresses its similarity dependence. D003 and D005 designate q(0,1), and the target identifies this state with q(0,t) for every positive t. Since x/t = 0 at positive time exactly when x = 0, this is the value designated in the source. No additional existence, uniqueness, flux identity, or initial-interface convention is required by the selected passage.
- **Source implies lean:** `yes`. The source's similarity dependence gives a profile Q with q(x,t) = Q(x/t) for positive time. Thus q(0,1) = Q(0) = q(0,t) for every positive t. Equality of q(0,1) to any value implies all the ray equalities, and their converse follows at t = 1. Abstract State and equation-predicate parameters do not enter this reasoning; they express the same characterization without requiring unused state operations or equation structure.

## Findings

- **note / explicit-selected-solution:** This represents the definition relative to a supplied solution. It does not construct a data-to-solution selection function or establish uniqueness, neither of which is proved by the selected passage.
- **note / representative-and-domain:** The formalization consistently uses a selected self-similar representative and the forward-time ray. It chooses no left or right trace and makes no claim about q(0,0).

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
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `21` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `21` dependencies (`7` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`1c4f8974ce39c40b842570036452bd9814dee6511430d8ecae6b51e5b855ab17`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`d382ff3cedd1ca7f7686c589d2d2b06bca718135d93d1ae55cce607c2f68aa70`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`d36beea1640c62be99378cb50549f1e1e5b0e64076695c5ec35b244098b78b56`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`e9f12f98dcf78e9ed2bf7011570a5b216abba7bf53cb7b569f9b927695224480`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`cad8fdf62b2a41367b8d77954ab19cea2de6ab9cb383f6787a75eb4becfaf72a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/decision.json` (`57ecf95fd583c87cef2572a1d46a89d11adf370897d705a539edfe1e88c8d44a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`26bc7f27d38ed2cb24ecdd3bc7af3fdc4a08604d4e286f7b2dd7da5ecac498e5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`8fb4722129a3ae268986955b3e780aa25fcd8623eaade35494d610f49dd8dc19`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`8fb4722129a3ae268986955b3e780aa25fcd8623eaade35494d610f49dd8dc19`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`d9003f8859a49176bde1b425aadbd621161ee87df31c709ab6b6f4f916d74a79`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`5d692fc50600d91b8ce5d6aab0ab0e2182d60836cbd2a32f946f622af83d4828`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`8e6b665c7eca335e09696cf3671f4f49bee7541b87988f66be2fcad301cddb61`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`cf106daf9c31acf4b9d9d16c01d3474833f87e5d9eac9fc110baf424c36c993d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`9745a5025a337ca583d12dd9cf01cbfa0932e50568e58b48795fcd98c40b35ff`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`946a111f0172e54330105f2d319273a86c486b8bff2d44f17454c4971a436853`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`96150133407c0d26aa5e2820361f288eb1e114539d1f997371fa9ee05e2fe1b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`d382ff3cedd1ca7f7686c589d2d2b06bca718135d93d1ae55cce607c2f68aa70`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`45d7986d9eb8da83fb0833c348ac02f8ee2a6814382fa2cbcee3ed661d725245`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`fd105386e8840e5b322a1735a44b18654174adfdf393f76d70597c63ac1f4290`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`127dd8557352ac624d4ba0cdd5dbbca6ee1541efe84501cacf6b4e8f3dfc33b4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`75cd74d66bb757d1ad59af0b48adb9e3ac3bbb48c414fd47e81ec684b8e07225`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`207be726400179f164328803161b27f2bfa0f9e8adcf86b32494785e966b19e3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`d36beea1640c62be99378cb50549f1e1e5b0e64076695c5ec35b244098b78b56`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`e2f608fdb4f09f6465e29e2de92020b46f2af733c263e2efdcc887903157f765`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`8f1836b3a38fb1a38f70b229f411e685e2449288dc89e2433a4e051bce9666da`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`9091c7907ec32afbf276b8f9b9962ae92ea0daed3f50ee6a9fa88991f8b31d36`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`664ec727ea4acd7cd94e102450c0dd11f32983529c954d850bccf6e1e461cd65`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_prepared_validation.txt` (`1c3d7faac30d37692aa3def693cec499317586dd7d16133efb04ba544e27f5a9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_route_exact_task.txt` (`ff4b523f0bfdd3d8022c888a22de92c08146762febcb27b778adf616f597f126`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/page-028.png` (`ac871ae8d940867a19f2e470aabfa9e4c1e3d1c1f6e48a116920b0623a9b3984`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/page-032.png` (`44ccb24c0606c8c8bc87aade7e5237892ba8cfe998992828d3b52ccae883687b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/page-033.png` (`f0f0b7dae0095be2c5ae386781e13732b458c32a0bc9470aa7541780d621bfbc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/primary_pages.json` (`300a4cb5da733e6ca60edf4863c1e2c18ac20e4f95d1659a06218809e3179059`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`e7aa2029c88e646bf5e4b806ade8c2647d9187895be346430176d145c3c5deb7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`e9f12f98dcf78e9ed2bf7011570a5b216abba7bf53cb7b569f9b927695224480`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`0e406ef488002409173e25f4259552c702859e3a46dd6ef30c49194fb4b42e21`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`0dbaa1a1a182037ff3f4cb7dcd10b610477373f7b0ee2304721a4ff2c2981d64`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`9c39721a121a8c3e6291c01a49ed9cd67c606ff2af0ceb5a1852dcee06d83679`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`f0b2ce12dc057f2426f6c7ccfb8a07894f3cb465c6fdd2c49bdc089602b54c04`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`92fbc0a957df895ec7f1dadf281f094d66cd346556847297211bd374744d6c1f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`cad8fdf62b2a41367b8d77954ab19cea2de6ab9cb383f6787a75eb4becfaf72a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`0a46a59b42ed757ec87075cc0cbb783632ddee42fdebd5060034da597c8e78de`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`6995051ea77c9daf3f4008f8bcf13367848c4a33772c51233a91f7ed2c12d654`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`4d7f33e0c46cd8e66b05e504e14867e5bb4f78793a8ed0310b285a7a16df965c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`0a01333df1d0298faca3460e7cc032c5e742a161abb4ca58fe257eeae8e884d5`)
