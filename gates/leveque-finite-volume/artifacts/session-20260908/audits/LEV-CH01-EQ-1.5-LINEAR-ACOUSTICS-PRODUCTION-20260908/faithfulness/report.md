# Faithfulness audit: LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `91ff1e2a3f46e8abacbca01de26119f1b70cc90cc782046e5318f25edd6dc196`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the three attached source-page renderings confirms the real one-dimensional setting, derivative conventions, physical roles, and exact two-equation display. The proof-free header, readable type, explicit type, and supplied dependency bodies preserve that classical pointwise model specification. Genuine derivative witnesses avoid spurious satisfaction through undefined derivatives, and nonzero density matches the ordinary reciprocal domain. All configured checks and all 50 dependencies are accounted for; neither implication remains unresolved. Supplied hashes and rendering provenance were accepted as provided and were not independently recomputed.

## Implications

- **Lean implies source:** `yes`. Under the source's classical model-specification reading, expanding D001 through the supplied inventory body to D002 yields actual values of p_t, p_x, u_t, and u_x at the arbitrary point, together with both equations of (1.5). Nonzero density identifies density⁻¹ with 1/ρ. The named predicate therefore has precisely the selected governing-equation meaning. This implication concerns the specification; the characterization theorem does not by itself assert that an arbitrary field pair is a solution or derive the model from physical laws.
- **Source implies lean:** `yes`. Reading (1.5) classically at any real point with its reciprocal defined supplies the four actual partial derivatives as witnesses and both required residual equalities. Conversely those witnesses express exactly the source equations, and D001/D002 introduce no further conditions. Thus the source's pointwise satisfaction criterion gives the stated equivalence for arbitrary fields and points, with no stronger regularity requirement.

## Findings

- **note / model-specification-scope:** Faithfulness applies to the equation specification. The declaration does not establish physical derivation, global solution existence, characteristic decomposition, or hyperbolicity, none of which is a conclusion of the selected display.
- **note / reuse-identifier-resolution:** The task-local identifier reference is resolved by the exact inline declaration inventory and ledger. It produces no unresolved dependency meaning or target mismatch.
- **note / model-specification-scope:** Acceptance concerns faithful representation of the model specification, not a derivation of acoustics or a theorem establishing solutions.
- **note / material-parameter-scope:** This matches the displayed algebraic model with meaningful reciprocal density. It does not establish that every permitted parameter pair describes physical bidirectional sound propagation.

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

- Blind translator covered `50` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `50` dependencies (`9` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`b43710de46a62fba56b187de2e9b72ca5c859e07ee93f519cfa92605c072c744`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`20c3da7cf793dece7310a9059f081dad61d94f53d547fc444dd1ce147ed2084d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`6382274e7553add2521c3d6ac52434956407dbe5f37b1557c80936bf2c6efaf6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`4ed36e4f4e947d1dc8d543222ca60c9400e5f9efe71b481162aa62f9e76affb6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`7e3bfc5404aa64aacd67f1678c22c621a2678a2a517e0b18079d0df766ae11af`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/decision.json` (`31ba8b6bef7b1ac587951f42738099305dd6e4a3249c5e1594a65c6152e73635`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`7a4a418e84198f0f3f597fb9e72f66032b47a5bef44856b393a5df8de18741e3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`b99ddec3ab16f30095ad62ce18242f1369fc2bc6e0fbd9b8b3e58e7ed8fb2dd0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`b99ddec3ab16f30095ad62ce18242f1369fc2bc6e0fbd9b8b3e58e7ed8fb2dd0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`09b79b898520ed1be2ee329178f19ec8bbad7639f266e25e74a43716fda4f7a3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`0bde20ff2735ef1380763af8957dde26db0eff723b0a52c95edd23c525176b98`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`d58e3fa651f8ad79527ef683f933c330b1998c8480d0e4061e832fa389ae8f07`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`3132dc8ab0a22dc89fcbb79e196ce108ab67814a5950cead51548e82d7e15348`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`90a9ba3f9599d7fd6f59082642de09b8d56af6b2d8f7190c79bf5016a5694bfa`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`512051ebbf47576e38ae645220494a24b5781cb8051c8a2671d419623ca2e931`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`eb4bbae1bed9baa503c9e9e76ff5bd2a85e9ccbada3b8133a09abe0d89a23433`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`20c3da7cf793dece7310a9059f081dad61d94f53d547fc444dd1ce147ed2084d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`b1b5551306c0915d8ce46db490b5658f6d25efd942def9423978adfdb0e219f5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`b4783f5fd94749b6a503aa4db09b804ec47697e31b366eb32993095c61815890`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`d70fe8287f3f4e91a295dc75115e4abefa277c55539b34980631952300a4cdd1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`308dc5440095e4668638f843122bce4af69f3f37f897a47f6b2389da6006807e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`a4518158e44e92ee72f29b987d25249bc1726045ecd7e736175c6c75afd1a966`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`6382274e7553add2521c3d6ac52434956407dbe5f37b1557c80936bf2c6efaf6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`d76c103513f9b891a9f808362256def3e3191adc06f131adc950fc7a2e34387a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`ae4f8ce176f746bc6b5ef50b08bd6e2def4a89c51fff6f954082850a48f78de9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`1cce47a3283d02675f87693e636392d1a90be51ec9862d93e89a9831f0a239c9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`b9fc560006f094fafe0c2f2632d3d2c4cb88335d21845b9d431898b6c2c03c60`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_prepared_validation.txt` (`205202ed20c1f19983cc89289f433bac20512eced3b3c750cc619ed0b88621f2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_route_exact_task.txt` (`f6880a4f73542a00675bf7046c61d7f63d69dc750a7f69b247a6266689842bd8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/page-024.png` (`9374c58069ddf2cc64e5aa888141ee9aa41977be7af9f29fd0cff786a5df3b02`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/primary_pages.json` (`b746b31c821e4cdc6c3034794942af1b2a0189872bf67000aaa45fa1780d5003`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`b68d6de337d9636ec7e9413375247de9aedca1ab43f3fdf5981c1dd61bb6f3cc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`4ed36e4f4e947d1dc8d543222ca60c9400e5f9efe71b481162aa62f9e76affb6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`88c9db35726c5a6708ad9e3c0d8184b4b2b4dcaab3ed1c2bd81b4b9b3d707357`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`3a734135c72c97f34ba4fd765e2bb825331e8c30248685f8af4c89a4a2fae189`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`2f4a96ed025c4a9182582ae1c1b5d769c1f403f3a0e63aea706e0ab7b9552edd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`5a7dbae40de76b4a501d8ea6956528746044c21b9b4d0973a73d0419da798dbf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`8e66ed3714bbbf0b2f682bb7c7208cd337173eca6d4ced9458cbdc9ec08cbde2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`7e3bfc5404aa64aacd67f1678c22c621a2678a2a517e0b18079d0df766ae11af`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`b806b09c66ff747f074b30318648ab55a99e723f0e4d8d60eb10adde8fbf6700`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`eb84201ec91c256950526036db7dae5ea75021b231d1e1d2107bd681c0f7477a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`0f5f16ef10ffc5531a092081d776f3d073543a23acfb38d5dceba36ecad65119`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`e034f05b80926f6dcfc7ce9ad7490cc05d73299c7d01199b89e2e167ee473ba0`)
