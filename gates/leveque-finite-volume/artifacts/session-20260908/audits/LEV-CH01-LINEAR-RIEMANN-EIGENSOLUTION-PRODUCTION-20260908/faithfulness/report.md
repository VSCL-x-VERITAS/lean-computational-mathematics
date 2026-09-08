# Faithfulness audit: LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `9057f66a6ca85e9a164fcf8dbde7d12e251b264fd55cbf642323e48de1d6d8d8`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the attached primary-source images and the inline declaration evidence confirms the intended spectral construction and resolves the substantive boundary and applicability concerns. The blind translation accurately reflects the target. The remaining measure-identification gap cannot be closed by declaration names, module provenance, a reuse hash, or agreement between judges. Because the permitted evidence does not settle both implication directions, undetermined with acceptance withheld is the consistent outcome. No tools, target proof, external context, or independent hash recomputation were used.

## Implications

- **Lean implies source:** `unclear`. The real hyperbolicity assumption, arbitrary source states, complete eigenvector decomposition, finite eigenvalue-speed waves, initial half-line assignments, and positive-time similarity match. With ordinary Lebesgue measure, D002 supplies the required integral conservation, including at discontinuities, and the explicit function is locally constant away from characteristic lines. However, D080 is presented only as inferInstance; neither its expanded instance nor a measure-identification theorem is supplied. The direct judge's unconditional analytic identification therefore exceeds the available declaration evidence. This is an unresolved evidentiary condition, not proof that the implementation uses an incorrect measure.
- **Source implies lean:** `unclear`. The source supports spectral solvability and the accompanying wave structure, but the selected pages defer the construction and do not explicitly formulate the target's representative choices or conservation for every pair of real times. Those choices are compatible with the intended linear problem and do not reduce applicability. Their absence from the printed formulation does not establish nonimplication, while their plausibility does not establish equivalence or strict strength. Together with the unresolved actual measure instance, this prevents a definitive reverse implication.

## Findings

- **major / dependency-evidence-gap:** The central conservation predicate cannot be unconditionally identified with the source's ordinary integral conservation from the permitted evidence. This is a limitation of the audit evidence, not a demonstrated defect in the Lean theorem.
- **note / boundary-convention-resolved-conditionally:** Arbitrary origin values do not obstruct rectangle conservation under ordinary Lebesgue semantics, including rectangles whose boundary coincides with a stationary front.
- **note / applicability-and-strength:** No purported strength arises from reduced applicability. Additional precision alone nevertheless does not establish a strict implication difference.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `unclear` |
| `C06` | `pass` | `unclear` |
| `C07` | `unclear` | `unclear` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `unclear` | `pass` |
| `C11` | `pass` | `unclear` |
| `C12` | `pass` | `unclear` |
| `N01` | `pass` | `pass` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `unclear` |

## Dependency coverage

- Blind translator covered `94` dependencies (`0` hash-reused); unclear: `D080`.
- Direct judge covered `94` dependencies (`27` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

- The permitted inline evidence does not identify the instance selected by D080 sufficiently to establish ordinary nondegenerate Lebesgue integration. Its exact normalization is not essential when both sides use the same positive finite scaling.
- The reverse implication has not been established for the complete target, including its specified spectral representative and all-real-time conservation assertion. No counterexample establishing strict nonimplication has been supplied or derived.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`ebbc9cf9dbb6b5381e3af3d35b933d57995ba0e6c770551eb9172d4badb718fb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`d72d9c98de16c94eb37919401d7204abebe370fc532fd27756301c76ecce2271`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`0b68519de75a49ec1b06842eb074195a563bc055700cff5a4860c64019252fb0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`a45868276bbc223aac69def0073ae6c19b362a47aeccf8420f3b985783a8657b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`9f17435ca5b242e500618f8fa0de47e38465b2ffa95c39d9639c101b6a056630`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`e9c9439c92ae246cdcc28280dbf5d231165e8e50d8e2f85f1d46681130d4c183`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/decision.json` (`b525d59b4604c818a66ed4c9453e4a1cb26c42eda6862f2cdc09b7b7f6cd8094`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`0356802407445bdf34f74ca2461b499e30e1f64556589450a7e6c2a989190d47`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`19d6d4c66a055c16434af0e59f125f93de57bcfd5c3cfd4d63c8b38bf8004174`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`19d6d4c66a055c16434af0e59f125f93de57bcfd5c3cfd4d63c8b38bf8004174`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`3885d758d84d34eb9cc5bd7c888c9c18fbe256b09b96e88e8ee3dfdd613c82d6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`91e911b0b941ea6c676cef596bb5f271962999362e85b0029244c772c50a5beb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`ea012feb0b90fc30cd727d5c77b01e9131327182ce69de9a9b225e6bd21a98ef`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`91970fba800c046b48b3d6f7107ef6cfdaad44e8fb57f51b385682bc715b6d39`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`dc373f0d254ea1863326e8c0560f3ef4d58118449374ac3d037ece994cea3ede`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`7270bd2e3187f0d4f6cf6cfcf15ecef1c72eb6fc6dbb8044e151d487ab6f6fc4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`ebbc9cf9dbb6b5381e3af3d35b933d57995ba0e6c770551eb9172d4badb718fb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`dadc50a27b6936633db262ebd2a4e34c88b733d8e0f9563f33a8380c4bd10c03`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`02b188ed72a099470ed7bcb38f169376cffe308da02fdc22ae8271be411d42a1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`9e708c21c3992ad6a1fffda917729da6c1a088834fa306276c42b496cd56a529`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`df569b2a79ca854031672d73f9d7ae38ddecb302dfdda12ea5f3810028c656c5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`d5037fab4323bab910798b0b95cdd07325e14cc4422417157572962ed9e321b1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`192150e006c7ce6c390f0f4ee3ce13e710fb97298252e78beee849fe22fbc3d7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`3c8eeb4e7b2cf04029f11911f404f00ad3da70ffad06da5b2aee23ce896ce54c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`0b68519de75a49ec1b06842eb074195a563bc055700cff5a4860c64019252fb0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`23cac76532b7ba6e077c8b624f714ecc92f898bb09c61223235da550622f2d71`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`94ab2d9ea6f0f89ed147057fde8cab4ad44982a7aa90179d77977a41207768c0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`3985506c5bcd2ffaac49331b7eb1b3197e302c091b7f27f56966d92c8d806cab`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`735c56a44e6c6aa731d1fc8e61bcd532f5b6ca4d8ab09950573ba65288d6983c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`557ccd2c3e52a1fb541bcb84543a46a49c98ec87b33985586fc1ee249f9ef8a9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`a45868276bbc223aac69def0073ae6c19b362a47aeccf8420f3b985783a8657b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`33627477c6c6ae60fe90f74a96d0ae9353e899e8f4bd7692739ce8857882f3eb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`73d779758603c500388998dc3a472b472301a68ff7d7626da198fcb6361fcf32`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`96925825f62f2c8df1c2384dd3659938daad6682141c0bb853376f18334af154`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`9a0d663e26f8ce2956c41c1b06cffd90aef9195bc36db5f6606f17b76ba5362f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_prepared_validation.txt` (`34e5158bf9b81591e98ed3758df699b7348c835976a6088e132825a6852c8331`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_route_exact_task.txt` (`5b86b6a13c4f77be14eef74fd55dbdfc590581fd41a66d4995a9fbe9edb065ed`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/page-028.png` (`ac871ae8d940867a19f2e470aabfa9e4c1e3d1c1f6e48a116920b0623a9b3984`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/primary_pages.json` (`151cd79516c6ff64ca90d95040402041ba93994c834603058a874de7f352106e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`39a6ae35333a67d2a00f264fdc23acc9968edf91981e85750ab65f5d9d0080a6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`9f17435ca5b242e500618f8fa0de47e38465b2ffa95c39d9639c101b6a056630`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`d94130179a3f037c1b4f09c0bec77b2d43ae551e6285b408a0278b7e0d4e109b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`ec2fa2f99e39e87a6b9501a52da5e273488040f512fffea5d285021c23d16b93`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`9dc70260867719af4bf7203962e42dc6a6e2cef23a2988e627724b14d6bd77e3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`f17d3307e6d744fe5f22ec0528e83d01e8712728c03357ea763bc27365b704b1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`a1f1dc3cc7553c5956d608a7f38411f813b4dfb65aaa3bf69d07e854abfb26d1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`e9c9439c92ae246cdcc28280dbf5d231165e8e50d8e2f85f1d46681130d4c183`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`2f1c4095fd88f336bec895aa874961238508e902280352b12388f60da6834030`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`b338a3970e7c9338c44fcac811045d89456b90b7ce866a8b3d7eda3d32c08fe3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`3a29dbe43300f3a751f8cc6e7f8cac602caab45b0f88a08ea41b557aa3a9b7be`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`8e583eb9a8d5a7a60732c1afdbc7c651a396f159f58545a2cad2da9ffb379b84`)
