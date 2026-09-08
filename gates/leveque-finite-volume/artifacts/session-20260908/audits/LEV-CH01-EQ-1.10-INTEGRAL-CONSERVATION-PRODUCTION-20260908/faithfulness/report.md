# Faithfulness audit: LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `5dcc799b4e236870500f1c0d38dbe8ce5ae1a5a10be12e65a7e7320b1a3b4d13`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The attached primary-source renderings and inline declarations support exact agreement of the displayed conservation structure and establish the target's precise logical and analytic meaning. Rechecking the disputed dependencies confirms the ordinary derivative restriction and definitional equivalence, while leaving D060's measure normalization unverified. The moving-step calculation resolves the applicability concern concretely under ordinary spatial measure, but the selected source does not specify its rigorous discontinuous interpretation. A definitional presentation is not automatically unfaithful, and additional derivative requirements are not genuine theorem strength. Accordingly, the literal reverse implication is yes, the substantive forward correspondence remains unclear, and the consistent classification is undetermined with acceptance withheld. No tools were used, and no supplied hashes were independently recomputed.

## Implications

- **Lean implies source:** `unclear`. The source introduces a conservation formulation, for which a definitional presentation is not intrinsically inappropriate. However, the exact theorem only unfolds P and establishes no independent correspondence between P and source-admissible conserved states. Assuming P and ordinary spatial measure yields the printed pointwise balance with correct components and signs. Full correspondence remains unsupported because the measure normalization is unexpanded and the source expressly includes discontinuous solutions while leaving their analytic interpretation unspecified. Under dx, an elementary transported step definitively fails P at endpoint-crossing times.
- **Source implies lean:** `yes`. For the exact audited theorem, D001 and D002 unfold its type to ∀ m q flux, P(q,flux) ↔ P(q,flux). That equivalence holds independently of the source. This verdict concerns the theorem, not membership in P: it does not assert that source-admissible discontinuous states satisfy the everywhere ordinary derivative condition.

## Findings

- **major / restricted-discontinuous-solution-applicability:** The predicate excludes a conservative moving discontinuity under the usual weak or time-integrated interpretation. This restriction is reduced applicability, not genuine stronger-theorem content. The source's unspecified analytic convention prevents a complete equivalence adjudication.
- **major / unresolved-measure-evidence:** The audit cannot independently confirm that the integrated quantity is the source's spatial amount. This is an evidence limitation, not proof of an incorrect installed measure.
- **note / definitional-theorem-role:** The theorem is a valid unfolding characterization and can present a definition. Its logical truth neither establishes conservation for arbitrary inputs nor validates the source faithfulness of P.
- **note / preserved-structure-and-nonvacuity:** No sign error, averaging substitution, source-term insertion, scalar-only restriction, impossible premise, or global smoothness assumption on q was found.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `unclear` | `pass` |
| `C04` | `unclear` | `unclear` |
| `C05` | `unclear` | `unclear` |
| `C06` | `pass` | `unclear` |
| `C07` | `unclear` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `unclear` | `unclear` |
| `C11` | `fail` | `unclear` |
| `C12` | `unclear` | `unclear` |
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `unclear` | `unclear` |

## Dependency coverage

- Blind translator covered `81` dependencies (`0` hash-reused); unclear: `D060`.
- Direct judge covered `81` dependencies (`55` hash-reused); failing or unclear: `D001, D002, D015, D016`.

## Remaining uncertainties

- D060's supplied inferInstance body does not expose the selected real measure's construction or normalization. Identification with ordinary spatial dx remains unverified within the allowed evidence.
- The selected source pages do not specify the derivative, exceptional-time, or trace interpretation that makes integral conservation applicable to discontinuous solutions.
- The supplied evidence does not establish that the pointwise predicate P adequately represents the full source formulation. Its correct definitional equivalence cannot settle that correspondence.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`7eee53473d40beed2469711eb02fb22e836648e3d09dbe89b32e6b2355532b92`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`db31e51112f87512ef8aaee8bd7ec8dae430aef5b80d02ae14956fb37b716899`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`3cbee26af466616f7b766ceeb5df72fc9817465f5263bd2008be1c37b12599ec`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`9174d815fa8b7a0bc59b8f8a0c7cd2ef86f325a5990db75ab370a0ca83390846`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`3f508d2a8845b1f3e6f5f943f55533703c336a7db6a1a8f49b9fcf123607f743`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`17d6b4840a064b9487258efae0647faee15af2cb432cf2c96b65b66d83facd9c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/decision.json` (`be89b5bf7e066c64e3b24292d96d997d879ddb5c5342de79936263cf9ce9a052`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`fb2542060321912b86e508ace339286f3704096a798b6aebce87855dfbe21972`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`f3f9a1d0ed3ccc811a0270e0099083c9b9258aa6d3bcdca151d40ca861a28cfb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`f3f9a1d0ed3ccc811a0270e0099083c9b9258aa6d3bcdca151d40ca861a28cfb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`93a494cd3d3e008086d77f4caa66ea97cd3f5af5f3011e4ae7547b4edb581964`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`be17d89963ca92b5e7beb100e1bbc9cb345db0ab1d680023e8e66c976b27a84c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`56deedd8d28383d351eb20d44ee83c44753868f6f291b740b7eaed444626d6f2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`8debdf803448f0ab01576dcd6dffd7c2bbe2adb94a531d5504d0961b38743b6d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`7f23c0ae8536b7ef0219ca9d600b4996e25f2dd6e94c074cde0ebe1fd1011228`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`9bb4cc9c11ca2af8060bcbad1d604a0c3e181c2d20064f695eee1a85eda75d74`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`7eee53473d40beed2469711eb02fb22e836648e3d09dbe89b32e6b2355532b92`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`2b03f22908d7e5df66593b7886c4e4272323c2a75c72d7f988e617f011d84e04`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`03d62210fb66106af105ce4b6c021604e2e15d868e0d51e2e9c01e3702b1cf67`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`cda4e3f184f1480d7161fd023fd180f8c9e0538f72b84657565e3760bf2de7b4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`855495d3154d9a49618b202d1c75cc6b8ebfdcd7aee108b21621aef1ca17a0ae`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`38caa1d4bd0a225712647249871d992346f6108bccebb8cd2686e8c2920c04ea`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`6d0c01a0a9f713c6eb10789396e9e5a8de3cdb243666433868006dea2ac5247b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/agent_runs-before-direct-recovery.json` (`3f213f82126368d1f4709a22497e9bafc9230f6128a2890150eb159c1cd17074`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`c3fd730527eb24184672464046b70672ef15883f124dcb0469f3cb8c796042f4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`3cbee26af466616f7b766ceeb5df72fc9817465f5263bd2008be1c37b12599ec`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`795e415b29a3b2fc9e82373019b7105e30d01ff245a635e63b36479603677a32`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`e03eb75dafe44a1f7fad116dc66a7ff81d93e3627d8fe89b14d52cc53114cf77`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`25c62742a3f27b38dc1fc7f0b8f9ff5c8981098a1c31618406de7066578be4ca`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`07bd86c52b5f6a83b2a88fae9391b5cf6ce23df3e4a37188c5929716f965d275`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`f69feb671a76958be80d44d37e835c18c194ff16b7026d6454c99db83521eb4a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`26353a3d122942972a24d37672f6e8f988a371ada0dade1562511e84a58fc6d3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`2dc519c75c2d5d1f441fd2decd2d5b0e1d092f4956246b2cd48704168abfd830`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/d_retry1_events.jsonl` (`c127553d44dfb100cce29c8e1bc80e31efe97ce4769e3d0876f7c54ff70b8320`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/d_retry1_final.json` (`9174d815fa8b7a0bc59b8f8a0c7cd2ef86f325a5990db75ab370a0ca83390846`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/d_retry1_input.txt` (`2dc519c75c2d5d1f441fd2decd2d5b0e1d092f4956246b2cd48704168abfd830`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/d_retry1_runtime.json` (`80174363fddff4daf59a8ae2cad98129e135af3ebd70accebfafa6b7b6ebb232`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/d_retry1_stderr.txt` (`fd75d6775133e189ff5f1b81fe98d42c6072a05245866b39c9aeb25f66254a0b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/d_retry1_transport.json` (`3c4c325e0fac8aee0b51ec84887124679c4d46614b5337a2ba6e7c55e2cb1600`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`3d6097772127951bf7abb88d76c0ebddc255f4d5603083fdafde1cf8e3d3d38e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`a25863db63568eb64d2c36fece9c0082406bac059fcb8f7acd809ab2fbdf1e69`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`b8f9e6be864063d598e5d6b4cd5c014be54b6f35cf8beb15956fc951fccaaf53`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/failed-direct_judge-26353a3d12294297.json` (`26353a3d122942972a24d37672f6e8f988a371ada0dade1562511e84a58fc6d3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_prepared_validation.txt` (`87523b0d942f85f7dabe6065cae043dc6ed8bc9d62c70721946d0ccf152a8986`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_route_exact_task.txt` (`5220c4deaf9df301428029ee895150071cca63c664bf4161404375800bb7293d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/page-026.png` (`c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/primary_pages.json` (`37ffc3b02239e7c8ccc9a356243d4a7ab5d3ca885af0db5e21bbced2685d867a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`4715b719cd17b9d2a88e4aea09b8d074fc189893b8135923ba67b9b43b94cc31`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`3f508d2a8845b1f3e6f5f943f55533703c336a7db6a1a8f49b9fcf123607f743`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`9fced045f6f960684cc196a37ba50e092c557bef71da42191fac65ec1c3137ec`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`c5e1f481282ef290c238b439c5966e5432feb2562b0a3871dee2199d51f5ac8b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`b79ebc59655e74ba3d1845ecfe6dfc622de5bb32b529d50557b802e3a786e374`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`8c38f820a744649075ffaafb908c521dd93ec0695a22fbfea295f30f0390e699`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`c27648b57ea35b5cd16ea74e6e2d2a2fbca6e3813c9549739fb1c730f95b34ad`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`17d6b4840a064b9487258efae0647faee15af2cb432cf2c96b65b66d83facd9c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`ba0b4b0a9b9b983607db3d2609157038fca77ade52c13eafb6f0c6bcc9f24133`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`01ff4177b4391b4b1cc97409654c4a9e383bc50844ca1521b08ac79e04104511`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`b13c11abd338309f45471cc2f1ac7971281ba71635b9f00edc31508d6a22adf3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`91c03893870532fe4f0874f7ce19ade3e7505ff13e4e2acd3c264155ab1960fa`)
