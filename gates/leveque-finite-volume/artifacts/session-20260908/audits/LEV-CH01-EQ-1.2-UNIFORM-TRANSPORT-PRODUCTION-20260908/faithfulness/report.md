# Faithfulness audit: LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `749691d8413b8c7ff99b15058012ee283c432372b10ad73373c99e6d91cdc364`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The decision follows independent inspection of the attached primary-source renderings and supplied proof-free declaration evidence, not agreement between judges. The target faithfully preserves the identifiable algebraic structure and gives meaningful classical and integral transport statements. Its precise analytic formulation is mathematically coherent, but the supplied source does not settle the full admissibility and nonsmooth conservation conventions needed for unconditional semantic equivalence. Additional regularity premises cannot be credited as genuine strength, and no definite broader intended source domain has been established to justify rejection as weaker. Both full implications therefore remain unclear, consistently yielding undetermined and accepted=false. No tools were used, and no source or rendering hashes were independently recomputed.

## Implications

- **Lean implies source:** `unclear`. Hyperbolicity and scalar specialization agree. Every differentiable profile constructs a q satisfying D004 and hence the classical PDE; every locally integrable profile similarly obtains rectangle conservation with the correct flux. These implications are nonvacuous and preserve translation. However, the supplied source does not specify whether these analytic domains exhaust 'any function', or how its derivative-of-mass equation is interpreted at exceptional times for discontinuous profiles. An implication to the entire selected source claim is therefore not established.
- **Source implies lean:** `unclear`. The source supports the algebraic and classical assertions, and the rectangle theorem follows mathematically from the translated-profile identity under standard Lebesgue integration using affine substitution and interval additivity, including zero and negative velocities. Nevertheless, mathematical validity under these explicit conventions does not determine whether they preserve the source's exact generalized-solution meaning. The supplied context leaves that meaning unspecified, so full semantic implication remains unclear.

## Findings

- **major / unresolved-source-admissibility:** Full applicability cannot be certified. A definite weaker classification would also require an unsupported choice of a broader source domain.
- **major / unresolved-conservation-interpretation:** Unconditional equivalence with an everywhere classical reading is false. Acceptance requires a source-supported interpretation of the nonsmooth conservation statement that the supplied pages do not make precise.
- **note / transport-parametrization-and-nonvacuity:** The target does not assume its PDE conclusion, omit the family through missing existential syntax, or rely on an empty dimension or impossible premises.
- **note / dependency-reuse-rechecked:** No disputed scalar-system mismatch is supported. Reuse provenance was not treated as evidence of task-specific source correspondence.
- **minor / external-frontier-limitation:** This is an evidence limitation, not a demonstrated alternative measure or operator error. It does not resolve the independent source ambiguities.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `unclear` | `unclear` |
| `C05` | `unclear` | `unclear` |
| `C06` | `pass` | `unclear` |
| `C07` | `unclear` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `unclear` | `unclear` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |
| `N01` | `pass` | `pass` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `unclear` | `unclear` |

## Dependency coverage

- Blind translator covered `141` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `141` dependencies (`68` hash-reused); failing or unclear: `D003, D021`.

## Remaining uncertainties

- The source does not identify the admissible function class intended by 'for any function' in the translated-profile claim.
- The source does not specify whether equation (1.10), for nonsmooth solutions, means an integrated balance, an almost-everywhere derivative identity, or a derivative identity subject to further qualifications.
- The supplied external frontier leaves the construction of Real.measureSpace unexpanded. Conventional Lebesgue semantics support the analysis above, but its construction was not independently verified from the displayed inferInstance body.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`077f2bbbcec3ced3b11fe78a0a00deaa0ca8411da354184c0829e38528931d21`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`663077fa38ce6ed24b31169931c0efe1ae1ae6144a077f61221e886648fd1181`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`d9753323a5c3c7fc1d45adaf349f7e3ca7effdac5d158b85e69843b5838a3248`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`2a883f82eab406fd0707427a2692942aa15f8d0dd4bdbb8d8a1524064c85f85b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`9997b6b12edfe8426e5170ee409f94666e40cce857282f40a610df1ceb9a0326`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`611b3973e90a6738cbe9f8ef551d03c9510ed560eed1ad259d845350a86e0475`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/decision.json` (`01e4efd1c1134ac2ce485180167b5008946be3dda116f50ba9888408a92eb9b9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`753422286aed61eb4ef0625557c9956014e5c6d0c70a88255b8ebd15ec3ee434`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`a06725efe2eb38f9a7f3597eb76999557ad50505a60da422a0eb4f00168efe49`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`a06725efe2eb38f9a7f3597eb76999557ad50505a60da422a0eb4f00168efe49`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`cb0fbee5a7eb9ff7f28c8f9d7a442f077e8f1a44aacd1226dc92403c2c54a328`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`eb9cf84b2474369190e1b68d7b80a2c9d9874662156213e702830c89339b8803`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`64e30d05c66ba3853901215fb0343071e6a1874fd4ed71082e5fb44642a5dd08`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`c4d666cbfe0873898b83101fb20ed7c5223e41f0f330154969b3b6b810f070c1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`cb404802ab8e449b9393f15019e124d78c08772b3802d83768420f488daa7411`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`d36da423ed9ee3efb3d639a2fa8df3a92f36b3dd91a99f13915de87d78b9dc8f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`077f2bbbcec3ced3b11fe78a0a00deaa0ca8411da354184c0829e38528931d21`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`a90ddf27f80dd61bb158ee96bff7dcd010d833ed584abb0b3c897310eae8923e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`5cf72cdc3011ed745b8e50a8d5ef629224f85f3274003e23409f5fb74cb1b2c2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`f80441b9e7cdb71f1e41528df04e820f1e8112287fc7c2e1ff07916e75f02f61`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`270c9db3c589f7d7fd80e09996560178bc97bd2e3eccb406f9b573fccc289e43`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`39eec8f3bce79b2788856a9852d925e45fd6a20e3db2bb364d7690ecfa1ac3b6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`a0ecbb1fc9b781737b0c690bee31b638e9d79d1f1eae9368633d332ffccae2e7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`d9753323a5c3c7fc1d45adaf349f7e3ca7effdac5d158b85e69843b5838a3248`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`dc23274b2aaa3ef328d328ea1f4f8481236dc266edec89ab2b24957fae7d0c6c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`b899ecdd25dc562641143441d1070fa075f826243cc5dcd08926d39ebff09c2f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`9f2b7011abba56430ee0ff71c4358a3900b1d181cee71c03c60d7408c2541b16`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`7134296b94fdfc041d6ba7c95981b0470d0682f84d7bf0ef5f24fb9cb41d4070`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/coordinator_drain_20260908.json` (`cb955b5f040f61fdb49166b3443a359960fb8211a0e80ccc37680601e4b95d66`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/coordinator_drain_complete_20260908.json` (`d927297dc6b7c9a8f01fa8c3fd2795fd3a2800813dde4aaa565d3168f811c850`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`5e4eb5c88230a4c88d0b389483a8c322b060ab4a0cce0c9fd4fbdf3c4780a70a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`2a883f82eab406fd0707427a2692942aa15f8d0dd4bdbb8d8a1524064c85f85b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`310cadc8b889e4e92fcf9d18a50a5cbbc3391b8922c18d8085d7ab347a65ba09`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`de1ae50702ac931ba9a438613ab0329f74e58aadf1a139d0d93b348c8d32ffb6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`c8a23e7cd439d99a7edbbb9c5f102c8914e21d5f0380678c6ead51f7f3fe3022`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`31d55d7118f0d4f22c8c4ae393b6c496110fd16e3f710e846284d686b463bb80`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_prepared_validation.txt` (`cfe963ee9bfeb2e08e21d8e24da6c4c6ef0f2a51752dbd5fc17c90e078c6ef04`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_route_exact_task.txt` (`55e4587454da76f9012644fdac20706029eb0409e2116b1be6c95b7b7509d6c1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/page-026.png` (`c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/primary_pages.json` (`14f4287fa12cb90141b2c1f810e68aca475d6323d036fe434a115ec199420b7c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`a4e820f284113767e81ea399a48e6a76811032a23a998b8be6531fe354d787c3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`9997b6b12edfe8426e5170ee409f94666e40cce857282f40a610df1ceb9a0326`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`6df5dee542050022ec0622771aa7c3d34f3273bae8235f2badfc2a55c08b7d37`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`95831afdf9b97e98b8d640a1565e177507f2fc3b20cb785d0e01fd2fa6dd6a63`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`e271ef9420215d2640b321a57c8e964e655e1d6a95f2988b38802c6e11bd313a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`3492c184c856bf1c62cb747f3bc56221476bbf456a7df57090badb2e8ad7d0ff`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`21c4af5f8fb2dbc1b8e2eb4ea391aad83e0fd95e76f83ea099d8086193f0408c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`611b3973e90a6738cbe9f8ef551d03c9510ed560eed1ad259d845350a86e0475`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`e4b58553a58cd03d7bf95e316f8c66523cbea1800d1b3259fc0d63f2ee670df8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`96d13f239c0d8fe28212ca8abe913ff398d17000a199de12ce751fb2f4643041`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`fc9520302cbfdc492c048fae65271bd31d8eebce755d4286ae450bc1063fe314`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`614fdf57464bde249e28b86d755cbbda3c68a6a644fb37ccbb1511690d9e3df7`)
