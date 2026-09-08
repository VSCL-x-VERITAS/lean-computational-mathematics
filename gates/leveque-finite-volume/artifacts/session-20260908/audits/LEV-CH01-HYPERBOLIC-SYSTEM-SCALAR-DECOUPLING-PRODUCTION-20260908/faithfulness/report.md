# Faithfulness audit: LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `165e25a43a1407efaafb45823d72461d20d02c6cbd80b46882dc38920afd54ab`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Inspection of the attached primary-source pages and the supplied proof-free elaborated evidence supports equivalence. The real eigenbasis criterion matches the source, basis structure preserves universal unique state decomposition, and the same indexed eigenvalues govern the scalar coordinate equations. Actual slice derivatives, fixed invertible coordinates, and unrestricted repeated or zero eigenvalues preserve the intended classical constant-coefficient scope. The acoustic discussion remains an identifiable specialization. All 125 dependencies and all configured checks are accounted for; no unresolved semantic issue requires adjudication. No tools were used and no source or dossier hashes were independently recomputed.

## Implications

- **Lean implies source:** `yes`. In the inherited classical constant-coefficient setting, the target supplies a complete real eigenbasis and its eigenvalues. The basis gives each state v the unique coefficients b.equivFun v, reconstructing v as their linear combination of b i. For every solution, the forward implication makes each coefficient field solve wt + λi wx = 0, so the associated scalar-wave coefficient is the corresponding eigenvalue. Quantifying the pointwise equivalence over the domain gives decomposition of the whole system. The nondegenerate acoustic matrix is an instance with eigenvalues ±c and eigenvector normalization yielding the displayed p ± ρcu coordinates.
- **Source implies lean:** `yes`. The source's m independent real eigenvectors in R^m form a basis b with real eigenvalues λi. Let T be its coordinate isomorphism. The eigenvector identities give T(A v)i = λi(T v)i. Because T and its inverse are fixed finite-dimensional linear maps, they preserve the time and space slice derivatives. Applying T to qt + A qx gives coordinate expressions (Tq)t,i + λi(Tq)x,i; invertibility makes simultaneous vanishing equivalent to the original vector equation. This supplies precisely the target's derivative-witness equivalence, with one basis and speed family valid for every q, x, and t. No global smoothness assumption is needed, and the empty-dimensional extension is immediate.

## Findings

- **note / explicit-reconstruction-of-announced-decomposition:** The general coordinate formula and reverse implication are mathematical unpacking of the announced invertible decomposition, rather than formulas displayed in the selected paragraph. They preserve its meaning.
- **note / classical-regularity-and-empty-dimension:** The target makes classical derivative existence explicit without adding global regularity. The zero-dimensional instance is an empty extension and does not reduce applicability.
- **note / explicit-classical-reconstruction:** This makes the classical mathematical content explicit through finite-dimensional linear algebra and differentiation. It does not impose an additional regularity class or claim a separate propagation or solution-existence theorem.

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

- Blind translator covered `125` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `125` dependencies (`67` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`dfa996668afb271cd45d8b88d77f0dec258cb7f8fe93683e06bb088653628759`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`dc0f483d5f32355dcb32a51682a62ae6081a663d9f0e540084b49fbbaca78ff9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`dffd59385d30a629b164a6eb85d1a96ca72f61e07cd56f9853b45aab90c6250b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`4f80e82cf94bbc91f88c4a742b8700742b8f7263fcc21ef370cabd93e241ccb0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`bca807cc6e1ba177a173a56aacdae817c8b61939f962c2e9dd5342bed18b6c32`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/decision.json` (`172dc7c4f1ff64b44684cd87b6ac74bce597c6e7aa5eaae6158261a0ace71791`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`20663e832e54ca96f5cbe319d18ba5e6db908b459eff48bcb7f24618cf99ac35`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`d5bbf7e6a45f8785a0a01e519cb339e87c472a31cc2d3c0f7de08cdf4b3f0862`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`d5bbf7e6a45f8785a0a01e519cb339e87c472a31cc2d3c0f7de08cdf4b3f0862`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`6d249708b63d6da22e1c669d044068e0be59e6a1c83b0bc4a8bb71af202da555`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`ea113674f3ddc72ffcc976a338495a930a9c2275c997abf3b10656c56f77cfb5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`7a75f25d41ecc2fc444d834eba9266cd62c11ce419b9fe46ac3d7a8d7ebd46f6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`bb4f07227cec9e28ea3c272ea12264283b8c34192b00815ed992a594e65cf224`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`66ceccb14096b6858865dd20c3b8a4d3e2f8ce37866f4b8c5cbaec288c241ddf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`73f82f28c3ad5a786e1ff31edde4eb60810453d0807c02c6cc89675dea017141`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`4104c127262cd174464c93480a1a88c3d862d5fd8c54e659a469b44a242359da`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`dc0f483d5f32355dcb32a51682a62ae6081a663d9f0e540084b49fbbaca78ff9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`1e7d081f4b8d8003f738c9879ebee44c35bae85b54e6b4df9ac77b0727492cfb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`3907d80a0341df05b7662b5964ab7281badd11ecf2cc388b0aae712cc911ce02`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`a0e1a7c171b91e684e2933719914099024d52d52698a707a1e638ae7b553703b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`41c400661bb20d79b874534651695ef38020a84f9506996d4c6f6c0d040ae8e4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`6dc711e5723546fc598a59f36e7dd5366aaf9265e6ca94b56a024ff774720c6f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`dffd59385d30a629b164a6eb85d1a96ca72f61e07cd56f9853b45aab90c6250b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`0253bdecd4880adf6788364b2b9c31e3c581967d7cccbce114f9d21cb67d4c4b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`7fcba8d9d5b1556c7c971c6ea779d443fdb52c27a6ad2aa5b27caaaf6781a6f6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`ae0bc4230aca8f59febd2541c7f982fceb36e48d29d20e1d781d6ffe010e2607`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`313833ab644470fbb4bbc4dd04dacfe138823aaf23a97b3e330456f87fe155a3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_prepared_validation.txt` (`c8abf41de54fee030106e286d9cfb00a4e5c808b238123607ae99094c1e95294`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_route_exact_task.txt` (`f3bcc8eb9f2c9541920136b422518b5c945ea43416f83455a1b1c05bc137b83e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/page-024.png` (`9374c58069ddf2cc64e5aa888141ee9aa41977be7af9f29fd0cff786a5df3b02`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/primary_pages.json` (`724d1e0595a9620f1ecce982efe5110efb05b534327e1058997ffda5c7b49056`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`62abd2ce28f9fb9f8b32c1a6c729d79c721381a69c1befddf3fc4e03d5606899`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`4f80e82cf94bbc91f88c4a742b8700742b8f7263fcc21ef370cabd93e241ccb0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`19a170060967bc332de79d16ee969897f9390588c09f77db7161eb8eb278d3bc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`0970b47cc74627dc62811b68f1c282a974f6990f208667c63f557c2842d75029`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`11790fd6d868ba9f9c14c927c662859854295ed2e4036c228eafa64bc36e490a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`31695f142b67ccdd860630b590b49f2ebed3fff5ce50b56ae0ba15377fb40583`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`2870b2445455f3f0d136ada4319c049f5a81124ece9dc854746b2e600d901a34`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`bca807cc6e1ba177a173a56aacdae817c8b61939f962c2e9dd5342bed18b6c32`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`28d5dcbb42af720ad9a648d72885aa6188f915de09b6007fac0a819750262095`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`3002403fa8db17e8df06e83d165ce72d6abf1dd8e2ca1aa0d2a7b5b6a5f372eb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`71575e72c8b1b6fa8c4733eaad72ce25b68dcd7bd64943c87078c653c22e6d71`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`7a046265198afef5798079e00a8ad3f32619ee99c782464014ba5c50c3c96e4b`)
