# Faithfulness audit: LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `669f818bde8cc0e616ad63a9bcc5d05791da132d4edcdb2d6286a769193fde7b`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

I inspected the attached primary-source pages and exact inline declarations without tools, proofs, or independent hash recomputation. The numerical construction matches the recorded interpretation at the algebraic and object-role levels. Native declarations resolve the disputed real measure, and positive intervals and explicit integrability address the relevant exceptional cases. The norm's unexpanded coordinate formula is unnecessary for this norm-generic claim. The remaining integral-identification gap is material because every physical reference quantity depends on it; provenance and integrability do not supply its missing analytic characterization. Accordingly, uncertainty is preserved rather than converting the direct judge's standard-library interpretation into independently established declaration evidence.

## Implications

- **Lean implies source:** `unclear`. Under the recorded coordinator-selected Q7 interpretation and the inherited user's rectangle convention only within its applicable conservation scope, the target has the required local data flow, signs, normalization factors, and conditional error propagation. It neither requires global solutionhood nor claims unconditional accuracy. However, the supplied declaration evidence does not independently characterize D101 on integrable fields, so the exact reference quantities cannot yet be fully identified with physical cell and face-flux integrals. The normalized real measure itself is resolved.
- **Source implies lean:** `unclear`. Under those same recorded interpretations, the ordinary physical balance gives h(A_t-A_s)=k(F_L-F_R). Combining it with the selected conservative update gives h(U_new-A_t)=h(U_old-A_s)+k((G_L-F_L)-(G_R-F_R)); positivity and norm inequalities give the stated bound. Average certificates and region normalizations follow from integrability and interval volume. This derivation establishes the intended mathematical proposition, but its identification with the exact opaque integral remains unresolved. The printed paragraph alone does not prescribe this recurrence or quantitative theorem.

## Findings

- **major / unresolved-integral-identification:** Both implication directions remain unclear. This is an evidence gap, not a demonstrated incorrect formalization.
- **note / measure-objection-resolved:** Arbitrary measure scaling and zero/infinite interval-volume concerns do not remain blockers.
- **note / interpretation-and-strength:** Any later acceptance must be interpretation-qualified. Neither extra certificates nor assumed conservation justify a faithful-stronger classification; no genuine strict strengthening has been established.

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
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `unclear` |
| `C12` | `pass` | `unclear` |
| `N01` | `pass` | `pass` |
| `N02` | `pass` | `unclear` |
| `N03` | `pass` | `pass` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `114` dependencies (`0` hash-reused); unclear: `D061, D101`.
- Direct judge covered `114` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

- D101 needs a proof-free defining expansion or sufficient native characterization identifying its values on integrable finite real-vector fields with the standard Bochner integral. Its exceptional nonintegrable behavior is not needed for this target.
- The displayed Pi-instance bodies do not establish a maximum-coordinate formula. This is a nonblocking descriptive limitation because the selected interpretation prescribes no particular coordinate norm and the estimate is norm-generic.
- The printed source leaves temporal flux normalization, quantitative accuracy, and discontinuity trace conventions implicit. Q7 and the inherited receipt remain separate, scoped interpretations rather than printed-source assertions.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`5c38b4e1663c86295b146fe7749e92acddafd9e60ce53f8080224986a4c1c744`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`8009c6f7eb80cd5bd16b4c3d71f1db671256271aede81f32a343e3f78b90fdd7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`e2be40a12c00d21ca226c2c950bf978b6dc3cc0d4528d4ac812c616550a1d034`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`5d4ea62095ff514d237974eb532b5258daea53cd49879697929610b49b519e41`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`320b16e00c629e15c1078acfa5ec002cb52fd8037e7b439b7b794152210326bc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`11dd47a5b057b9589ba73a8999d096d17789a84a6d1f90c8d30be8d9b633f8a6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/decision.json` (`7f05c038afd7d1bf13c969e6db6f5c4f7735a0aabd04fe856fd7e35585cdda54`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`3456c3287f3c47300c796cd3683df2c22332f77d511e3d8d18057ece59778ddc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`afc52ab91691739eb8f946a0dc4b9573cf709b7c2cad22a019f98be15a323af6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`afc52ab91691739eb8f946a0dc4b9573cf709b7c2cad22a019f98be15a323af6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`a39fb8091cc1549453b1407a03efc4f12fc2a23055a6a0433492d0a6f4a45387`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`aab526877182f13419712e0cc9143c6bb6a4d22443d1f73c7fe87232fa1fd150`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`3686925e2d5448b60a8b8be6dc36e13bd8237b2796523d40987c2aad2ea3f9e0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`56e4a214689ef5c17c6f725f7739c2ac3d2c6ea46e3e9210666dc9584f212d90`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`dacc205f16917775a6bac4aae08d50fa9af50a0015926b7d2ccc3335c4f610cb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`5c38b4e1663c86295b146fe7749e92acddafd9e60ce53f8080224986a4c1c744`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`ac14963b2caa89516c0e802b0347f15fbf65178cfba5a1eb9e885c1782f44493`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`e26131827562e05d6688daa2b5cbe88d3aae197e3dc40f0d5e278c6e015dfbdf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`d0ef5a2f1329a334e0f61d191b10fa020322b433d78fe4b76f57fe1caa689bab`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`ca784c99f7c79adf1a158f94d105aba7fb2f9aa9572e0caf9b9536424f79c61e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`d5ab2c096f0bad4165f97c3cbcf81d26a6b62e4db3feb13bad2fa2a3af86265e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`f09b455eefa562d918bf17738c3001a7fceb97f811a6284e9485712976528fee`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`e2be40a12c00d21ca226c2c950bf978b6dc3cc0d4528d4ac812c616550a1d034`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`825d485bdea430655eaa7eb201f671a41ce4ae3bb6c0d544c4fe74b9fc7f46f3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`9bbc4333e2f8a09fecef6a4e541b4e5d60bf7ff7b5671b4492372f64056c68eb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`d8d829939613bac0bee0c944500de0d4191f64054e95bab736684a073ed1d42d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`f81ebe89b90dccb009006879ec61a45137f3d1bdca76d4b7fd71f5beb2f6ab3a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/c.py` (`5c2f6cc905214bba0ab95db527eaa86db15a8e9c5a6195cad40f489649365b2e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`83d5edac2d5fc57f09eb2be1c89fa32759633e262905ab2a8ff778914a14bd7b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`5d4ea62095ff514d237974eb532b5258daea53cd49879697929610b49b519e41`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`c18c8387b3e5a54c119119681aab39c9bb69e352e56ac99637765a7c152304f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`8a230a82cfaeb5517364ac2a1fbcab81f191e844c0b76c07ec1a36c645178dc1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`f704477a8491d2ad4d26c14ffd245d47eb83b54e8f8117e66f7b301c05faf3d8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`eac6db124f2e03a0608e3bb98f769a9552927bc8597d7b72b462f4a7bf8db6ef`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/page-026.png` (`de53be1aae881a448dd2718b09830eadd7387124ea339f874ee5f55d49fa2257`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`b23d80176b69db0cebf8fee1fcb4c64ace36777dae21a61097a3090ec29e2ac6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/q.py` (`6c9416dd233bb49c65f53caa53a9184640b9511c53e9e6df73b98c19b5d7bf43`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/r.py` (`a3686cb705f3a9d9691b9fb421cf1640bec1e35f5fc155058e79dba5b3d38833`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`9564201364dd8f3f4129bf67954c967f4721fb7bc4aaf248017ebc00833e7bfa`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`320b16e00c629e15c1078acfa5ec002cb52fd8037e7b439b7b794152210326bc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`6b88cc1907df356a604909b503ab1bbf869431f8d700c9eb24226f14ea0cf75c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`7e7777ec67a7ea6ed91a9cc77f61a4c25144407fb63b1f4fb215529f819e29e7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`57fb41d81473c99c3c17fed39727ccba009f33a322e098133e0d5db7d1954008`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`8ad3e87e64a19dcb914aa282305c76682b1abc77364a53af7836d35fc96fb3a1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`82f18d7d700937fae9bffd69362e963f4c5cf4e9add7349d2b5471c4f18dde76`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`11dd47a5b057b9589ba73a8999d096d17789a84a6d1f90c8d30be8d9b633f8a6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`343d499609b646978820fc87cd9250672a84220cbf0b4bf641a095c4bcc19078`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`6f08c61b5cc272b8427eac773693395464452ab1ab4952fb5659ba71574f04df`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`67ce4f02315d82d5c2bebdfc29a2ea08a3aa2de8e4f3c76dcb702bda48507053`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`74dd7f5e046e28371cedb064c82cb4c8dd6ed3f192ea6613c98492241845bcc1`)
