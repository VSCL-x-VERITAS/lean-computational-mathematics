# Faithfulness audit: LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `d7ec02f1e3bce373793b96b136f82ada0aaf3037cf09a033675b0120663170a8`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the three attached source renderings confirms the inherited real vector state, the conservative spatial derivative of the flux composition, and the distinction between the classical display and subsequent integral/discontinuous formulations. The proof-free header and both elaborated types match those semantics after unfolding the two local definitions. All 72 dependencies have been assessed for their current effect, with exact supplied reuse hashes where required, and all configured checks have been completed in order. Actual derivative witnesses prevent spurious satisfaction from undefined derivatives. Both implication directions hold for the selected definitional PDE form. No tools, target proof, prior judgments, or external evidence were used; supplied provenance hashes were not independently recomputed.

## Implications

- **Lean implies source:** `yes`. For the selected claim introducing the classical pointwise PDE form, unfolding D001 and D002 identifies satisfaction exactly with existing time and spatial-composite-flux derivatives whose vector sum is zero. Reading Fin m → Real as ℝ^m and undoing currying yields q_t(x,t) + ∂_x[f(q(x,t))] = 0 with the correct flux role. The theorem characterizes this form; it does not by itself assert that a supplied q solves it, nor that the integral formulation follows.
- **Source implies lean:** `yes`. Under the source's classical reading of the selected differential equation at a point, take qt to be the time derivative of q with x fixed and fluxx to be the spatial derivative of f composed with q with t fixed. Their existence gives the two HasDerivAt assertions in the ordinary finite-dimensional real setting, and (1.8) gives qt + fluxx = 0. Conversely these witnesses are precisely satisfaction of that display. Thus the source's defining form supports the target's definitional equivalence; the harmless empty-vector case follows directly from the supplied definitions.

## Findings

- **note / scope-of-definitional-equivalence:** Acceptance concerns a faithful definition of classical satisfaction at a point. This target does not establish existence of solutions, satisfaction everywhere by a particular q, hyperbolicity, or equivalence with integral or weak formulations.
- **note / empty-state-dimension:** The empty system is trivially satisfied, but every positive dimension remains included and the satisfaction predicate is nontrivial already at m = 1. This harmless definitional extension does not justify a stronger-theorem classification.
- **note / representation-conventions:** These conventions are harmless for this local PDE-form characterization. Acceptance does not establish an extension theorem for fluxes originally defined on proper state domains.
- **note / scope-of-definition:** Acceptance concerns the selected differential definition. It does not establish global satisfaction, integral conservation, a weak formulation, or solution existence.

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
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `72` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `72` dependencies (`69` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`cdd4bc2fd04c892d231f74393025a609180f34ba973de3999b175d02ff6b1098`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`4602c2f2b77000d7c59009321edb13ba7b0226a35c0ef7c5da7db2394fe096e6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`18a92346caef0fa4d5d57606d8982f2faf35be8b6480b27ac5b8d2e43dead2d0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`13151111ed9c2879d52b47d3f40e8e28a081b12b340e60ffaa486029c8e9a60d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`1abfa2179b4376b71e30c0d06aed05f8e1d840ae8efb758f3d7c2868b010193f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/decision.json` (`90d71c804f3b2b728262e9c5fbe0398537658a593559523f48fb620c2fa53ed4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`94676e7f965ffb82aa981bd4d45954bb8c81e16766b750d8a8ef71cd84dee511`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`8731b79ee5c1e2592fc843e7fedbd9d71a25279ef407bfe388e832b823efed5e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`8731b79ee5c1e2592fc843e7fedbd9d71a25279ef407bfe388e832b823efed5e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`4f9d5887b778710235efc2028ed167e5123c0e1b1c3f6c2ebd1732b4b00ae0db`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`615a587035e390ff7fdd73208f47b87ee5d0de65bd54ec82b442ee8af67cf913`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`57110f406bfd68c0d4c0469ffe6d0ca886d49963667b2dc1f004cf2fa69fc7b3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`f6b2f6d322be3fda027af58baeb55030cb4e8e579439e878a30a6c44d16bc987`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`18b0a2bbdf130c9094f0b9ea4e89e0cc91b0890cdc2e7b0d6eba44410a505388`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`44196a64cf2c2bfafc5d3401e3d63c18dd5c66a639b572ef71030ab8ba01b321`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`4602c2f2b77000d7c59009321edb13ba7b0226a35c0ef7c5da7db2394fe096e6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`5bb57164dfc25865f18e1eabc1a8a0e135e4f8311ee35ee80fd565c857564675`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`7d3919ab005810a86adf8a8909fc0a0c6d3d1833d7e280a6624495bf93434767`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`1f376ae17d7cf073a6a7971a9a7440f7bb46cf631fa48664f3777be63cc594d1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`fc99f9478c876059ca434bbbcb4c3da13871a91bfaef833c64d229e3beae0594`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`7d2f813cf221585752a8c8120628124a28e4a0bf896b56e0a4880740cd76bc32`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`18a92346caef0fa4d5d57606d8982f2faf35be8b6480b27ac5b8d2e43dead2d0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`f3eb795e42f8e78250f46ad6dc3911281d6661a5cd8f4d2428e810f8528a58e8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`e5b826f4a0cbe5a5bd9986c2f80889d3f8241a322b845adb9c93cf0edf30affe`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`4e11d5ad03741d15934e38af5626509b8ae619fd5fd52a6261ec2a60ffc6736f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`607bff8ca2e237c1594fa7dd0885015aa4b87e8e42e78e86f3d800c4131a5861`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/page-026.png` (`c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`095c905a680c61ce04711296862a8a80bb51276326e62040061d00aa343aa225`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`13151111ed9c2879d52b47d3f40e8e28a081b12b340e60ffaa486029c8e9a60d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`232061b5d676e8d2bed89f55b07e48d72fc15a65b53e60974fb0e3c9ad534afc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`184008af3da7bd2d1a55d165a0f35fc1ae702610a2d158c922a756b68e9829a8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`e8404ac7f4e2b4e31ed91a9d6f1063b3d87a29e98f69f391d8a182610c2536fa`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`23edb58b75061124c4cd74420ab8cc8cab6e3526cbd386276b234210dd01dfc8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`6c84064ed6fcb5f0f940f9767863886ce26330735706d596e30fc71dfad665c4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`1abfa2179b4376b71e30c0d06aed05f8e1d840ae8efb758f3d7c2868b010193f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`3b587dc3f8f131e0d2887db49099ee93c71d5b86b5453e1b8d484ed0aef666b6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`740de2aec3762678fbfbdc50f755a39280b2531319abf6b8a73fdb1b1c4ddb68`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`3d2df564b0551a06098c4cb922d1cb190a651c63254262fe7a8001da2b092a76`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`0061550f3cf88a9b926d24e82399f3261c8d56a8a0537c3da9a44741d1f4ce9e`)
