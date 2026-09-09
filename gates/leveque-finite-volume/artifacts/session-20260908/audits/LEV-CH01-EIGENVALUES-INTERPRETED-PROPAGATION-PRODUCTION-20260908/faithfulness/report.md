# Faithfulness audit: LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `821c64b87ffe22018abdbc1fff01f846f4067ff5feb6911e4bb0e4add39990d7`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The attached source renderings and supplied proof-free target agree on the constant real homogeneous system, complete eigenbasis, corresponding signed speeds, and all component waves. The target additionally makes the source's propagation meaning explicit through time-zero translation and exact reconstruction, while its basis structure retains unique coefficients. All 140 dependencies and all 18 configured checks have been covered. The proposition is faithful-equivalent under the recorded coordinator-selected global jointly differentiable classical interpretation only; the book's unstated solution-class ambiguity remains a documented limitation of any unqualified source-only reading.

## Implications

- **Lean implies source:** `yes`. Under the recorded coordinator-selected global jointly differentiable classical interpretation, the target gives a complete real eigenbasis with the corresponding eigenvalues, makes every characteristic amplitude satisfy scalar advection at its eigenvalue, and states that each amplitude at (x,t) equals its initial profile at x − λ_i t. The reconstruction sum makes these all the waves of q, and the basis gives unique coefficients. Thus it yields the selected signed eigenvalue-speed assertion with propagation and reconstruction. This implication is not an assertion that the target covers every nonsmooth or weak interpretation of the book's unqualified prose.
- **Source implies lean:** `yes`. Under the recorded coordinator-selected interpretation, the source's complete real eigenvector family supplies the basis and eigenvalues. In that basis, A is diagonal: applying the invertible coordinate map to actual partial derivatives turns q_t + A q_x = 0 into w_i,t + λ_i w_i,x = 0 for every i, and the inverse map gives the converse. This pointwise equivalence requires only the derivatives already included in the predicates, so its broader q binder causes no unsupported differentiability assertion. For the selected global jointly differentiable solutions, signed unchanged-profile propagation means w_i(x,t) = w_i(x − λ_i t,0); equivalently it follows by differentiating along each full characteristic line. Unique basis expansion then gives exactly the reconstruction sum. The regularity convention is supplied by the recorded interpretation, not explicitly by the printed passage.

## Findings

- **note / interpretation-qualified-acceptance:** Acceptance and both implications are qualified by the recorded coordinator-selected interpretation. They do not resolve the original source-only ambiguity or certify coverage of arbitrary weak or nonsmooth profiles.
- **note / pointwise-decoupling-scope:** This is compatible with the selected result because both sides require actual partial derivatives and an invertible finite-dimensional linear change of coordinates preserves their existence. It supplies no vacuous default-derivative shortcut.
- **note / interpretation-qualified-acceptance:** Acceptance applies only under the separately recorded coordinator-selected interpretation. It does not establish equivalence to every possible reading of the original unqualified prose or attribute the selected regularity convention to LeVeque.

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
| `N01` | `pass` | `pass` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `140` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `140` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`501d527d3fb23412e8a712d9d51c5f20fd4e1d0cb5ab5348f98a18acbd9fcb8f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`5ef9afe194039dc2d1b2ad59b60619fd7a52701bc99a28fc7b7d8b54d1cc5191`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`00ddab3988b5e2045ef02f571b5d82287f55cc71094771aac6b38d840d67c130`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`107f897ded5d44a2229a0e456c25a4a9619447b4dd9d34e7169364db1af3f745`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`b9c99b2d74424419e841d56946aad718a5bab1683b2e7895a9952e976cf5ccce`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/decision.json` (`6df1aad1b35d0ae178bb2796f82a72779c7af4958dfea85de99d3732585fdcb3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`facc0e30a134411f6431467363fa14bb5400c9147f6810421ad039cda7558c5d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`4e7e2daa30c8e9295f4576d64a68cd37bd0126e46a0b695fdbd83e2a984fea31`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`4e7e2daa30c8e9295f4576d64a68cd37bd0126e46a0b695fdbd83e2a984fea31`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`6348d2f9a6d583c9f612c2763994d0126d2725275fabf998002c0ce2ee566f3d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`334b7eadc25c5632dbfababeecc6a33209bc2e0ca89e8e23bd432bd3549e4edb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`8e1060c52616d30aaf3ac3dc809cbd7049e644c8efd8f44fafe2816f619ff396`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`a64e5ca63663fced1da1070f53741d601d319bc704daa038e09aad20df4b1747`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`29604ca9366d58c28fc8a2592059739d7bf2ef19878d1b9507c201d47818fcd1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`5ef9afe194039dc2d1b2ad59b60619fd7a52701bc99a28fc7b7d8b54d1cc5191`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`e0468dfe73d42bd275ca3a2b5d9ab1266bc54566e98b1720b9e1ceab4814a2e0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`e9b338e5fbdc6e80e257dcf96e9a8b2c13176b3ca787b2c001b921af4bc1e036`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`ecc57a73bb24393c3cc0fc6410a9854905a2dd5449442ccb7fef005fcce89555`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`9a446312f18b5b3d1d94d9b285ca62b9c69e8b98568e3adba04a8fd653d14213`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/c.py` (`139e0378ff91ce72b1c650c0dc548da797a6f7d91f272e69bac7c6e7a00efc9d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`01c4b20cd2cd864d3228993064e4918fbd032b2119534c7a881630d46364721a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`00ddab3988b5e2045ef02f571b5d82287f55cc71094771aac6b38d840d67c130`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`ac921a16309d27865c7637e546135fe5dbc7493cb79619f743ad519c5e5c7aab`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`d471cd83ee93217e40f8ba723d9a83e6f05f69976bfb344c23c3a3afc141bc72`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`5f7e897a0467ab2a7da8642accbca1a996a392052967535c13e9696dbca8b769`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`c06b2b5b6e1a59e678714538f5b87e5662356c1f6fcf3927f54958cbf539cbaf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/page-024.png` (`6a95398093b6adf8fbfd948f95a69c83e6f3175bbb05465e922c595311ee7f92`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/q.py` (`3a5101c5479bb554da5f993b40a5b41a0e822777170589625c8c3b819c97b8fe`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/r.py` (`6c1436076bc0e1c8838d86aa36fba525af21ee1d4dbc2df76c6a5876cf0f44b2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`15579964da6a02578d053a6681bf784bf2e22155819568551e823fe7cd4f00c9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`107f897ded5d44a2229a0e456c25a4a9619447b4dd9d34e7169364db1af3f745`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`de76fe457d4c32cb8820697cd08838d45ad4e1ecf5b33f864181564956e3ff45`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`654bff3e99978fd28034f7ae23a5f8f167eaaf45cdc731e627af5897a74d1c30`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`2c459416324ef398b56fb696d9cc5df88ee5ece715a4e0af5c614e433d50adfe`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`4d7ff66882b864a94de7896a848e257dcba3099c8c6cfff2b6acbbc360177517`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`8a8c006a6115f33fb6beb4ef36f3fcdff3bb0dc60954134438e2098033303ebe`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`b9c99b2d74424419e841d56946aad718a5bab1683b2e7895a9952e976cf5ccce`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`582cc54613263086ffb8d25735b67d66d7de0fab484617ccbd177f0a319739dd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`cae653cb7c37dd230e1cb4684b49820c192026c6f886d7099d941f64178442da`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`0d1cb11983e3f777dc01e66ca5c0da9a8cc581f1b716d68e575e8f5131ede9e1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-INTERPRETED-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`b34ecbb836e0d47ad7f086c18ddc56658e93bd377bb626495c9dcbfd07e50508`)
