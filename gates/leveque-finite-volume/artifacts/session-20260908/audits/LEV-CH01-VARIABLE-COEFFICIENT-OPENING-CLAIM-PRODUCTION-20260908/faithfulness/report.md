# Faithfulness audit: LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `0ed24b66922e4f719a2e3fadddd3125e3b6ecdbf3c286fc9f36f3d295d76ac46`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Inspection of the attached authoritative-source renderings and all supplied statement dependencies supports acceptance as faithful-stronger. The theorem supplies a smooth positive scalar witness to the source's possibility claim. Its no-flux predicate has a direct operator-level connection to the source's differential conservation form and the associated smooth interval balance. Nonconstancy follows from the final conjunct, and smooth-profile tests establish nonvacuity without appealing to discontinuities or the excluded target proof. The added existential witness properties prevent equivalence with the bare source assertion but do not weaken applicability. No dependency, semantic check, or implication remains unresolved.

## Implications

- **Lean implies source:** `yes`. A target witness determines the first-order scalar equation q_t + a(x)q_x = 0. Its one-by-one coefficient matrix is real-hyperbolic at every point. The coefficient cannot be constant, since a constant c admits the representing flux F(x,q) = cq. If the equation had the source's same-state conservation form q_t + ∂_x f(q) = 0, its spatial operator would agree with a(x)q_x on differentiable profiles, giving a D002 flux F(x,q) = f(q), contrary to the final conjunct. The obstruction already follows from smooth constant and affine profiles and therefore does not confuse shocks or failed differentiability with failure of conservation. This establishes the selected possibility claim.
- **Source implies lean:** `no`. The selected source assertion supplies an unspecified nonconservative member of the variable-coefficient hyperbolic class. It does not assert that such a member can be chosen scalar, globally C-infinity, and everywhere positive on the real line, nor explicitly exclude the broader family F(x,q). Those additional witness properties require mathematical construction beyond extracting the source's possibility claim. Thus the target is a nonvacuous strengthening rather than an equivalent restatement.

## Findings

- **note / existential-strengthening:** These properties strengthen what is proved to exist. They are not extra premises on a universally quantified equation and do not constitute reduced applicability. The appropriate classification is faithful-stronger.
- **note / implicit-variable-coefficient-qualifier:** There is no missing qualifier: every constant coefficient c has the representing flux F(x,q) = cq, so the target's witness must be nonconstant.
- **note / conservation-representation-scope:** The conclusion establishes nonconservation in the original dependent variable. It does not exclude transformed conserved densities, integrating factors, or nonlocal representations, and acceptance does not attribute those stronger claims to the source.
- **note / existential-strengthening:** This gives a stronger existential result within an admissible subclass; it does not reduce the applicability of a universal source assertion.
- **note / conservation-representation-scope:** Excluding this larger flux class implies exclusion of the displayed source form. Neither the translation nor this judgment asserts impossibility after changing the conserved dependent variable.

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

- Blind translator covered `71` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `71` dependencies (`38` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`554fe635f18bcc2822614916141599b393b4dcf65e5a5108e9303e306679890f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`26e95416e7aebbde51b223d72f4d5cb845991833992e563a7a851b1d625fe188`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`0db1e0a539a33b246514971dbf32fcbb3c0cadd536cdbe41c1b09b15f657d122`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`b65e35f3e73a0c28fbc96abe643a7752b7fb8d8fbcb7bc1c9bb2ba7a26f592a0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`2246ab1feafaefff83129b24f3ffd64189a39c46e95bc4bce7c4a3637c76e7bd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/decision.json` (`df1b25f522c381164a7945df4b19660e7e03dc972bc419f19abb97d11ce7943e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`d0c5ca4d128a452da8281d53211946a943a26851b4fc7638b0785feec38f975d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`f7d452baf610bee2366aca746ae6bde9ac08af488b14d3749e132b79acef5709`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`f7d452baf610bee2366aca746ae6bde9ac08af488b14d3749e132b79acef5709`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`db261d77bdb8de2a98f282c30f591cd0d22e6d35c2d48cfd3ee46a63a1f3819d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`6cf2f56e08d278c1707652d66456aae15710c511eedb41d3e11b08a54fec0fb3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`a077754bc6ce7721010eed6fe6d1b223942fa7d1509078f8034ba55d54948358`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`e1621b36f4f2a35b3a27243b74d8b8f75be276c378ffcb32a9eaeccbb7287f4c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`5efe012f60dd6ccb571b686d42469565ade6c6b1db88c60d96a4367168aeb785`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`d49c2d3fc2af133edc21a7fb4f2e8b6432c01d29d897de2c6d4a57dd52aff5a7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`26e95416e7aebbde51b223d72f4d5cb845991833992e563a7a851b1d625fe188`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`d1b05f921dd24bdf5fc537577bbb9f60d9e3f6f432a3d46f36ac171171f446c9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`d5fee6a99f517347564177051f3641443e382c9864acf5b69a6972bce1825cd7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`56452c7fe010f5d6fe932cefbf54cbc5c9ae856df447f87b71f053096727d87a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`203abfb0ac0eba3565a2128c952c4ee3d135bd07cbb144b58d439f8fca25fc87`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`3ff7316077e46241a6937deb027460e2cf3e066805b8da7304b2f8c48a52b71a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`0db1e0a539a33b246514971dbf32fcbb3c0cadd536cdbe41c1b09b15f657d122`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`5ad8126cb1da3e3724fc16f29026467708e6e15a795609a8dcddde6ad8c06e12`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`f249f42ca78426bf7dafca85e9c40096029e18a0b8467032013153aca5fcca5b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`30f936c6c0254ed3909aa1ee47fb2c0e0fb94caabd8594de3964582f7b4b262f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`13f25c4c6d0ffe55eba93376530b61e115028d04b2d702c6ea04d8436b798beb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/page-026.png` (`de53be1aae881a448dd2718b09830eadd7387124ea339f874ee5f55d49fa2257`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`b23d80176b69db0cebf8fee1fcb4c64ace36777dae21a61097a3090ec29e2ac6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/page-030.png` (`da658725af4b8a2b539d19ce5201c239a181999fd1cd4161e1cabb5a54c2288a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`1fb65537e4c37e872d2093db09163710863b6ea4beff9ca2ad980f03c140387b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`b65e35f3e73a0c28fbc96abe643a7752b7fb8d8fbcb7bc1c9bb2ba7a26f592a0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`b2ea34974531e0e4cb1ff854cd590cf5ff03b04d73e68d9801872eb807982477`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`499a56b4a13b87b8dbe120fc5442ad992f92e8ffa401883bc8107adf8f08cc6a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`be2bfdf9a6ac5a3b3e2c157ded6dfb25a6d7fbb83388a2d04a6acc6d707e68db`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`c587812221c1f6e4cb0f5f8fbc67dd52b8d1408a7b796dde4e340280a4fe56fc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`2b7f7b59dd90fa5c3a935f91dd121815f0bc1fe5d0cb79794c6cc4c37aaf5268`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`2246ab1feafaefff83129b24f3ffd64189a39c46e95bc4bce7c4a3637c76e7bd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`30364892eecbd0fddaa34acf58b84f4b2ce2ee23340801e073ba302304494f3f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`0e881129bc6f3327616cd53f07bad77cb583b219c57182af177410c1c376ad4e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`58670cce919499e48d122c6591de7e6c3e6790b389451a01ee53d444b3cb1570`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`bf883292476c77c32dec793fd96bcaea5218a17f3f24510a6b4c327dc75ca378`)
