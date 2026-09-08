# Faithfulness audit: LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `48d8f6dd76189f6e7c385b05ef469ca1d2c79b47a23ba542dc7ea912e2a4188d`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Direct inspection of the attached primary-source pages confirms the scalar constant-coefficient equations and their explicit mathematical-identity comparison. The proof-free header, readable type, explicit type, and dependency inventory show that the target compares precisely those equations under correspondence of field and positive coefficient names. Both predicates require the same genuine partial derivatives and the same exact balance. Shared arguments encode renaming rather than physical identification; universal pointwise scope captures the equation comparison without boundary or initial conditions. All configured checks and all dependencies are resolved, the setting is nonvacuous, and both semantic implication directions hold. Source-byte and rendering provenance are accepted as supplied, not independently recomputed.

## Implications

- **Lean implies source:** `yes`. Under the displayed source context c > 0, identify the unknown and coefficient names by field and speed. D001 expands the advection side to actual time and space derivatives satisfying qt + speed * qx = 0; D002 expands the wave side to exactly the same condition. The universally quantified equivalence therefore establishes matching equation satisfaction at every point, and the inspected definitions confirm the asserted identity of differential form. This concerns equation identity, not equality of independently chosen physical fields. The source's accompanying suggestion about similar techniques contains no additional specified mathematical guarantee.
- **Source implies lean:** `yes`. The displayed formulas and explicit identity sentence support the same equation under renaming q to w and ū to c in the positive-speed wave context. Giving both formulas the same actual-partial-derivative interpretation yields D003 on either side for every real field and point. Any witnesses for one predicate serve unchanged for the other; if a required derivative does not exist, neither predicate holds. Thus the source identity supports the target's entire universal equivalence, with its inherited positive-speed condition.

## Findings

- **note / solution-concept-explication:** This is a precise classical interpretation of the displayed equations. It adds no external smoothness hypothesis and makes no claim about weak solutions; the identity remains valid for every quantified field.
- **note / coefficient-scope:** The theorem preserves the selected right-going wave comparison. It does not claim the unrestricted signed-coefficient generalization and is not classified as stronger.
- **note / classical-predicate-formalization:** This is a compatible precise formulation of the displayed equation comparison. Acceptance concerns equation identity in the positive-speed context, not a theorem about weak solutions, solution existence, or numerical methods.

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

- Blind translator covered `67` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `67` dependencies (`35` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`9d9feccd17dcec55c1c964a01fe06630d5ed63c945a7332ae4fd543490631a8e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`0bacc30e724ca6b8c3b67744ee22c96fb9f1b220b7f65626ca047fb212386364`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`4cdf729c341567e7f28969e3cf8c3d8447a9901b9e0e86e3106e3bc1e7dd139f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`40f85a057fe22ebf880e86b38d58001254258157d788a9df86b59328b80a7f3f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`45df8b1618a485d5709edcdd2aa821d5d23ccd7ac7bbdea9401db77c31f498a4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/decision.json` (`b00d232310ac792258f5027d41bcc194eecd14b274be878acdcc85e2a30aca8a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`d4f65adb9e656f0ae055d02a06223dff8456596d84be6a51f0767c523277783b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`5bfde5685f91eb0365e4a6aa84b59564a8300282276676d3e27899bee4606b52`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`5bfde5685f91eb0365e4a6aa84b59564a8300282276676d3e27899bee4606b52`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`55d3d2a369d233d4cc01910ba8e7f69384b131886c3feebbbb88d5c6a51a01f0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`57e6430b735fdabee71345f3ee5bddc8c6ff5a9e88b64a4f1eb2b8784beaf19b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`12834123e39a38c118674dccf79d34ef8b1a703fa7569dfcc9f1e3f6f1441c7e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`d4ca08032ffd05b464dc619adeb48d9c168a026b5f4fd3e80a1bbedfbdca6ada`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`97a67bc3b4e54e66318d422fbde9a0e5f1978c06c4147ade90ce3bb1fc8049c8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`bcff94b927bf19212a2c61eb47c784e0ca439391211d08305b68dfa479f0d095`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`0bacc30e724ca6b8c3b67744ee22c96fb9f1b220b7f65626ca047fb212386364`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`3e0153d7a9fef78b857b4cfa310f62cc05c3e7672c2769e9fe6372092c999f98`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`5b2b4dcfc0af680d4f947c6a3b20c32e950af338e439aaa868275ea25a5ad3f3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`51c0e51d8c050130ca4047a64e24daf3a710a1c83be59b7eff2e27ff95e4940b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`bbdda8f7fa28fa69d574d5e243ac5197df5f17d62ce17a011ea9979ae1fd9c15`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`8f9306787284f1a189cfc0399a29efd124b228ea3da713db0bddacc0d6843d7f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`4cdf729c341567e7f28969e3cf8c3d8447a9901b9e0e86e3106e3bc1e7dd139f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`2023aff82ef5ce54e1112f9dcfc586e3b7aabf3574b48655f77fac29ef96cb35`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`88336ccb539b56ba52a92ac3e6da701ea14c9a0f78c54a5521ae4cb6025806dc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`e499892e94c0ad9e84b53df6cc9940188c37e5ba3c18925a2e44707d00968234`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`9dade6c292dc78649da2127aa1d0be39cd8c60c0b5803f5b15c725614b655867`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/page-024.png` (`9374c58069ddf2cc64e5aa888141ee9aa41977be7af9f29fd0cff786a5df3b02`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`43b487f447f0a26bc357576c6545d9f7a5e53b308e6060b8041c5823bf7eb395`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`40f85a057fe22ebf880e86b38d58001254258157d788a9df86b59328b80a7f3f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`a5073e53c7d9952ac4d26696dfe2c726b327c30be9f1443188655f25a7646986`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`f144cd88b116add488c3c740d696f2434b288afb02437a5fe76625a80aaf2d3f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`68c6b14702adce5d813538a9094837e2268135ee60602fe1a9a923454b711b51`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`2c36a741a5ee93120da02861acbe1132345a4e66c5c127353aa94a13c77f318e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`8670406e50cf58fa1391d072df0f21604027735cf06c622f281204059f8b9093`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`45df8b1618a485d5709edcdd2aa821d5d23ccd7ac7bbdea9401db77c31f498a4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`eb961ac6b4eae74d5153ff83f422742276416f887f3d767d563dadf292a06ef7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`3ce1e3451c13a41f4dc66b5ba6b35014a657682904a4507f4ffc8dd88b0a27b9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`4449f26b2362e5d4157e4d04a83e40330f4b725f611070980d191127a17ff591`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`dfea37ea842f4800583751358a2336dccfebd22dd1f4e99ab1dae0dc683d0423`)
