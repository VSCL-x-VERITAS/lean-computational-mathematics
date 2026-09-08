# Faithfulness audit: LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `3a11addfd88714c7e3756b1675e199df23e472e43f7b738af996cff5656b8384`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

I inspected the attached primary-source renderings and the supplied statement, dependency, reuse, translation, and judgment evidence without tools or independent hash recomputation. The complete declarations resolve the principal technical disagreement: the governing record has an explicit PDE meaning and uses the same matrix for its residual and spectral test. The initial-data branches, witness scopes, real linear algebra, free origin, and distinction between problem data and solutions are preserved. Acceptance nevertheless remains undetermined because the source does not settle the broad equal-state convention or the full unrestricted equation-domain extension. This decision preserves specific remaining uncertainty rather than treating judge agreement, reused hashes, or definitional provability as evidence of source equivalence.

## Implications

- **Lean implies source:** `unclear`. The complete declarations establish a concrete governing PDE, the correct real-eigenbasis criterion, and both strict initial-data branches. For represented equations with distinct side states, these recover the selected definition's explicit components. However, IsRiemann also admits equal sides, and the source does not explicitly identify its unqualified jump-based definition with that broader predicate. Coverage of every unrestricted coefficient, forcing, and state-domain tuple is also not established. The separate jump equivalence does not remove these uncertainties from the complete characterization.
- **Source implies lean:** `unclear`. In the common represented setting, the printed spectral criterion gives the required real basis and equation (1.11) gives both half-line equalities; intended domain membership supplies the remaining state conditions. The full target additionally characterizes the broad equal-state family over every admitted record and every natural dimension. The supplied source does not settle that complete identification. Although the two equivalences are definitional consequences of the Lean predicates, their provability alone does not establish semantic implication from the source definition.

## Findings

- **note / governing-equation interpretation resolved:** The judges' missing-equation-interpretation objection is discharged. No solution-existence premise is needed to classify problem data.
- **minor / degenerate-state source ambiguity:** The target distinguishes the two families correctly, but their pair of characterizations does not determine which family the source names without qualification.
- **major / unresolved governing-equation scope:** The equation representation is concrete, yet its full source correspondence remains unverified. Neither equivalence nor genuine stronger-source coverage can be certified.
- **note / boundary and nonvacuity checks:** Interface handling is faithful, ordinary intended instances exist, and empty domains do not make nonhyperbolic data count as Riemann problems.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `unclear` | `unclear` |
| `C03` | `pass` | `pass` |
| `C04` | `unclear` | `unclear` |
| `C05` | `pass` | `unclear` |
| `C06` | `unclear` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `unclear` |
| `C09` | `pass` | `pass` |
| `C10` | `unclear` | `unclear` |
| `C11` | `unclear` | `unclear` |
| `C12` | `pass` | `pass` |
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `pass` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `64` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `64` dependencies (`28` hash-reused); failing or unclear: `D001, D002, D005, D006, D009, D010, D013`.

## Remaining uncertainties

- Whether the source's unqualified Riemann problem includes equal-side data, given the tension between its jump description and the absence of inequality in equation (1.11).
- Whether the selected definition covers the entire unrestricted class of position-, time-, and state-dependent principal matrices, forcing functions, and arbitrary declared state domains admitted by FirstOrderEquation.
- Whether the source correspondence should include the zero-dimensional degenerate extension; this is not an independent failure of positive-dimensional coverage.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`fa1c6e9a2bfce9ea574d239364c7ae4ce59411fd47cda457ee7690395c84cdea`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`e7363406f030ab2cface77dd27946bd1c1f54c606c501e43826293b5ab5ba43f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`af65e5ba630e94f131cf8ad199261e24e63021e974b87b7d558d92692c7af7f9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`b2a0a63a365e8d0f1339897e4e0769b28c56369f40547ea87229a6ab6aeaef09`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`bd020f1ef698b90966320c2a68e771a7be290f57c9a9ac1a3b47242279b7f231`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`ec4a4375250373a0d7edb21634dcdcb4d1f871acade33035a2354b83d5d30e69`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/decision.json` (`4a99d9c61f874c30b7c2c8748faca51327d3066d81ed15c96d9d59fe93a12c9a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`1b3bb9fd76dad1b1c956416e15fc384b8ba05650a814c682a0699dd569d17530`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`81433993e24664a226b030202786f804c276548654cf7af93223a35fbe8f57f2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`81433993e24664a226b030202786f804c276548654cf7af93223a35fbe8f57f2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`9f29bb2bf46773badcb0c5213779b8d40c62e2702bbff5f61e2c80c46b3a3016`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`2065a79c5002682ab4b6a3836cc1a5974ba1082a1e497e23a34c20118ed90f3f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`2f1f46a71c6060b143497b8d5a323716579578d605c1f7adfadf6468f579635e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`6e0c12097bb824935cf222882c5218d5a63c3b30533ad93102a7348c37d669fb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`5138ebf55521db78a275562f9f116c8465ced4a9bcdfed09682ad39a37e7ad1f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`03fb31f5175c02cf87ecce451aeecbc88e70ea0dd22cf661a77a992e0b7259a7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`fa1c6e9a2bfce9ea574d239364c7ae4ce59411fd47cda457ee7690395c84cdea`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`f50e0350dc08d3f5ed23d5e19cfc4208c0353bc7e2b60f651945dd2e9c24157e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`631f947e3d0ac0e926351d300dafa7319628729e340cc88168a50ede73651b46`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`28cb7582a6d8eb2583944bd63bfa2cd9f4a36f141d93b6adcb21e0806b0b0677`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`baebfe21c67505aca77b1a91c2fa11c7f2b51f2be79315932dacf3f0719da7de`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`c7356d7eaabab882119d2b6998e78dab9c88a37b0947161ba3ca6a0cfdbbbf0e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`60cf092d412dc9ef9588a7540a4184254cb7d34fb55ea16f63737ecb2ab7c1b6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`af65e5ba630e94f131cf8ad199261e24e63021e974b87b7d558d92692c7af7f9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`48ffafc86e2d29efb9855b06661cdd92948bbf05f50fb35efffca9a9895ede02`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`a4d13f30aa12f82c9971b89531a4853332955d1c070f46cb7ec4ba19d3da7dc1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`c62a08d15d9c18db882edc904ea7abd27ba4696458ca36ff8d5271fc9626d3fb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`55a53c24aa37bce697dd9df3ec1d5b5f378f803c0715d80e725d2a89b57e3d34`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`f39a4aba4d947da405e704df1f63b19abef27b803b2ab8cc65edb25bba6bb9f0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`b2a0a63a365e8d0f1339897e4e0769b28c56369f40547ea87229a6ab6aeaef09`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`de0920f8386e2479dd81e3a17f92a716c8ab359c07bc4b5aa9301970971f5f0f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`2880e1b1bc6207713679f4b4ff792c69ae4614a5846c97d04183656bece14924`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`aa6469ddf55c2669fe20803469733e21d1a19fae9c3e5c32b0b9f2278606f0bf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`79ec3dcd02fc47a4e33d8d6edd02337b3fa0af924952ddd0a4c3616c4d0a41e8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/page-026.png` (`de53be1aae881a448dd2718b09830eadd7387124ea339f874ee5f55d49fa2257`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`b23d80176b69db0cebf8fee1fcb4c64ace36777dae21a61097a3090ec29e2ac6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/page-028.png` (`c084d0939e0eda2cf2ef753bd0031bf50130032fdc8079bdf2d55cab16c2a831`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`da8992513178ca7d9c56fdea9cfe69b55a7992a76d813aaf0bad38a48f98cd02`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`bd020f1ef698b90966320c2a68e771a7be290f57c9a9ac1a3b47242279b7f231`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`fa6ce6fbf05f3ba69ecf3af51077b131c740df90107030969778df843c4c1de7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`f7c34129935929276c19f6aa7826c4160ccfb0dbe5e5d597b71b2ecc8d002619`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`e6fb1ff28a17f72431c307ee73bff401f52cf796ff2fe5f039f520e8c5f4b299`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`d3115d6a4211f706747b0d158be66ad3a978ad7c25f6e8be85bc79de07172d53`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`3f56cb6cc9b8bd203fd40fbb16c3ccbecc2f2ed81845fb0fb2b9b9c73251415e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`ec4a4375250373a0d7edb21634dcdcb4d1f871acade33035a2354b83d5d30e69`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`5814615d239654a52ff5f64f32df235b469a21ecbe844628450e3e435c20a9a9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`44f38f4c879262caa73ef2c615222ca1de5f1ae49e3c3998611e19712e1cef29`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`9e22980770c0b03abf6d1de75cbdd7f13f7d944cb606b0d1a5314d4a1b426297`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`dbeecbeac18ef0c7f561942a238c53c00ff39da6e65bdbd92f36c5b0ad699cbf`)
