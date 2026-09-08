# Faithfulness audit: LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `bbd2ec6c5b6684545f7a67b94cba5c2805874b51631b0b8d46df11f9fcc47464`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The attached authoritative-source renderings and the supplied proof-free declaration evidence agree on the complete matrix rewriting of (1.5) as (1.6). The target preserves the real two-component state, pressure/velocity order, both constant coupling coefficients, both scalar equations, and the correspondence with qt+A qx=0. Its nonzero-density premise respects the ordinary reciprocal domain, and its actual slice-derivative witnesses make the source's classical derivative convention precise without imposing extra smoothness. All 88 dependencies and all configured semantic checks have been accounted for. Both implication directions hold, with satisfiable and nonconstant examples; no unresolved semantic issue requires adjudication.

## Implications

- **Lean implies source:** `yes`. On the source domain with nonzero density and meaningful partial derivatives, D004 is q=(p,u), and D003 is A=[[0,K],[1/ρ,0]]. The target equivalence says precisely that the two scalar acoustic equations hold if and only if the corresponding vector equation holds. Vector slice derivatives have components (pt,ut) and (px,ux), and row multiplication gives (K ux,(1/ρ)px). Thus the target supplies both definitions and the full rewriting asserted immediately before (1.6). Universal x,t allows this identification throughout any domain on which the source equations are imposed.
- **Source implies lean:** `yes`. The source's specified state and matrix yield the target equivalence by coordinate expansion and assembly: the two scalar partial derivatives for each slice assemble into its Fin 2 vector derivative, and vector derivatives project to the two scalar derivatives. The vector residual is zero exactly when both scalar residuals are zero. HasDerivAt makes the source's meaningful classical derivatives explicit without stronger smoothness assumptions. For arbitrary functions lacking a required slice derivative, both formal predicates fail because finite-product derivative existence is equivalent to coordinate derivative existence; this is a harmless logical completion of the same rewriting. Nonzero density matches the ordinary reciprocal domain, and no additional positivity or initial-data condition is required.

## Findings

No findings were recorded.

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

- Blind translator covered `88` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `88` dependencies (`68` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`150ca2596d9abddb48d1a74a28dfae3274744b9b73bc2706811fe750bb36bcc6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`d8412815d9792506f1f04f2fca4c6850b3c5cf9f5681ad3491032c14f991c7ba`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`807746d772c2904e046586eaf30722a7f930e6227d236e7ef716e620a92d5867`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`322748d9d86277ed96f66af9ca12493aa007947b3ba1180fd32106445d023505`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`ca647c8dcca696eb573dc0dd7085c982d34222f39eb63a3f82714a69877c3b12`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/decision.json` (`c72900a9c8060857db3c85e6ce8df58f9d67c358e21121809e5f582f73a273cf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`554cca0aa212a5c8c9f5d4dc07852a6ccc4e51ecfd2790b627bf26a84b837c8a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`2828382b1598c6eaf7bbca3c951b794dad548c0bd5ccb5f2159e4a0c9ac652b3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`2828382b1598c6eaf7bbca3c951b794dad548c0bd5ccb5f2159e4a0c9ac652b3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`2658e5033b03cbf5ff13e4b2539db6fbff1018be162b93ac57e5c5bc308eb718`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`142d63fdc5fab29581922f579e689f3d8e3f04f85b6d0de9c2c4e3e26720660b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`d21d703d238556a5bd440246f48d9d2d38824077bfc126936836d46eedd86c86`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`2461e8af551d91089175eb7452a808280e88b4840abbfc633ed826a778bfe9f0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`d2f2ce798485dc309166d4f561d075a672c6b18c82c8e289ba65653ddb81bd2e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`b72d251804f15882fdbd79baa622d6a2cf756b554212d3c88cb4f04553cb91ab`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`d8412815d9792506f1f04f2fca4c6850b3c5cf9f5681ad3491032c14f991c7ba`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`34eb1c757cd9e281e21eea3e824792130746d20f7f0b8b65f0e2961732c0002c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`53991a03d26debb47d4479d76aaff3cac0429ff67e6cf05829e3aa6b965806f2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`0f5c66735881cf9c92944b42e8fae4f1ae3ef66cf083a16def1c06f09e06d069`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`c09ec93e74b42d95d6e2997c4a9573a0e3f417c41e1cff40ab6477799be953cb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`ab38e83a06122adef4cb59eadbfb382782ac306a73c3f8540fda9bd61b5688d0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`807746d772c2904e046586eaf30722a7f930e6227d236e7ef716e620a92d5867`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`790eea65d225007ad425b0f3472e6e06517472d86dfdcad7e6403f5b443cebfc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`55934a866dfc8ba893e45e6f8a2b066973b5e933f68dd136436ff3ad5a2d1c4e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`183d6f84235c6689029ba256b06237f1fa153c4a6b1068a5518f525e38d58296`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`f125aa2a8365c24ddc29113ebf0bf5e6c0731f0875575e2a36420d7c2804f09d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/page-024.png` (`9374c58069ddf2cc64e5aa888141ee9aa41977be7af9f29fd0cff786a5df3b02`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/q.py` (`807f6b502ceb72aab0e4c72801813c45339d4ef817c5c9e9187d73248fac63b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`b5af332f2dc96a61997c5f933fd07bf3641a0bf1bea3d02e9cd549b766e0c176`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`322748d9d86277ed96f66af9ca12493aa007947b3ba1180fd32106445d023505`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`89d9628e61cbe67845465b078bd49d5188918cf90096578452e6a2f54110da28`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`c0de65454c872c1c99c79b50ece08638d6519997d51b0fafae909bcfd9aa739b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`d2853faa72a31c0e6fbf8ae2dc8aec787ba4b41c661d353b77cc6306c245b3df`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`07ee0b516fcf96956d4a81ef347c4a0589b1ae913c421f1cf2c30c103b33a2af`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`6186627186d7953108d08af121e9cbc8b7d7cf7e6111d7d6e2ca30391e67eb9b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`ca647c8dcca696eb573dc0dd7085c982d34222f39eb63a3f82714a69877c3b12`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`7b2c43bd84e700b15c66f280d564e907cf1406d2662685701e0381e15476e9e4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`537b958acee96e2f12743be94df40ec44ac65ee449a25afbd08ea811c5b16afa`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`be8a0eee47b62f51c9e1b14e1cb55a6926a3aea731ca29fc3ef8ad5d22c370b1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`c4fc50fc36a77114715890454ee11091dafcdc4687642bd4322678e7c718ce09`)
