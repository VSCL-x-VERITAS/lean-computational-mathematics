# Faithfulness audit: LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `0b116368c3eec80809aabd651e5102632dfc2b854bb506a0ce63efb72bab9b88`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Inspection of the attached primary-source images and inline declarations confirms a nonvacuous classical realization of the source-term requirement with correct flux, signs and witness semantics. Its additional regularity premises reduce applicability. The remaining measure-identification gap prevents certifying the reverse implication from the permitted evidence, so undetermined with acceptance false is the consistent adjudication. No tool, external context, target proof or independent hash recomputation was used.

## Implications

- **Lean implies source:** `no`. The selected source requires source terms for nonconservation in an integral modeling framework without assuming everywhere classical differentiability. The target supplies its conclusion only under global spatial derivative existence at the selected time, classical time derivatives, derivative integrability and an interchange hypothesis. A transported discontinuous profile with time-dependent amplitude can require an integral source while failing hqx at the transported discontinuity. Universally quantifying t does not remove these premises. This applicability failure persists even if the selected measure is confirmed to be dx.
- **Source implies lean:** `unclear`. With the selected measure identified as dx, ordinary calculus under the target's explicit hypotheses yields every conclusion using production(x) = qt(x) + speed • qx(x). The qualitative source does not need to prescribe this residual as a chemical rate law. Nearby-time integrability is not required for that formal calculation because hinterchange directly supplies the needed derivative identity. However, the provided expansion of D070 does not establish the measure's identity and normalization. The supplied local theorem statements support the residual calculation and exact nonvacuity but do not independently establish the missing source-to-measure correspondence.

## Findings

- **major / reduced-applicability:** The target does not recover the full selected source requirement. Its additional conclusions cannot establish faithful-stronger status.
- **major / unresolved-measure-correspondence:** The reverse implication remains uncertified; this is an evidence gap, not a finding that the installed measure is incorrect.
- **minor / physical-mass-domain:** The formal mass derivative need not automatically describe finite physical mass at every nearby time. This does not invalidate the conditional residual identity.
- **note / nonvacuity-and-correct-source-semantics:** The theorem has substantive classical content and preserves transport signs, scalar state identity and unrestricted source sign.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `fail` |
| `C04` | `fail` | `fail` |
| `C05` | `fail` | `fail` |
| `C06` | `pass` | `unclear` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `fail` | `fail` |
| `C11` | `fail` | `unclear` |
| `C12` | `pass` | `unclear` |
| `N01` | `pass` | `pass` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `fail` | `fail` |

## Dependency coverage

- Blind translator covered `98` dependencies (`0` hash-reused); unclear: `D070`.
- Direct judge covered `98` dependencies (`64` hash-reused); failing or unclear: `D001, D021, D023`.

## Remaining uncertainties

- The supplied expansion does not identify Real.measureSpace.volume with ordinary spatial Lebesgue measure on all intervals. Resolving this requires the actual selected instance expansion or equivalent authoritative declaration evidence.
- The source prose does not specify a complete mathematical domain for nonconservative models. This leaves choices for a broader formalization, but does not justify silently imposing the target's everywhere-classical hypotheses.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`35cdc9adef45083eab9aba131c03e11bd80a2c59759679e0e42bd0b23aaf2e05`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`23f28910a0a04bbe1f11a75243475918b84050be57ad1dc433dda19cb236de13`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`9d5f4ef66db29c07987ccef78708edfafd885761fff1ab223606188e2a07fc62`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`f010a37e51b7554519f13ac655572da1acab52f67b9addd29c93d5609492b271`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`1a8f86b1d46a020b50b5ff4310c5324af4e2f1dea5b3f92611d12f5970f858b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`3d7c8c24222326daf8f3f99997292b8c132359a9b3bb1a7a63ec3a0403d14e15`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/decision.json` (`c48f5b9e8e6121f618e8f54292a56c4f7f3daad9df513794a904bdfb2abaefe3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`22efaafbb46b3e53648a1fdce2c59fadd4b53ea6ff753051dca5989cccd28b05`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`6cec0fd809b3ab63342944f00cfa217038f967107a5e98332b13357291b3279f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`6cec0fd809b3ab63342944f00cfa217038f967107a5e98332b13357291b3279f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`73c6ec0cd3f7dd7d848a5db9ab85894948eed9537640ecb991d7ca2379546c0c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`484552639e4bbed2d894db5ed0ea4c8a7b00c5906cfcd0187c2b7ebb0e80749d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`1140a68b1b0430fbfe61c6b4cbcbb0699de96ea8920d958183d860252d740073`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`9956bfd1c25832b363ed68a95d3516f04f64f4e8eeebffc974a8b8a9abdd5e6e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`78c4291d013d2a338bfa9576daecaafe58bfb25e89f72e3085a11123dfbc4e06`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`ec9ed43ee6cbdf8c5636698775fe4c98a5fdd28f6b843212c791f23d402531ee`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`35cdc9adef45083eab9aba131c03e11bd80a2c59759679e0e42bd0b23aaf2e05`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`03423d97668ecdc3cc58b9d88ed4d774280f98d3ea1016ef1047ce48358bb83e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`a81b82102963acf73f846d708577531a68ee88003423152a7c0632de074bc2d4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`23f9c9dedf51a8220bdf83871d41e95c5879cb14b8b2d7bd640e6f46862172f9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`5211c7dc64d4e5abfdf324a424c957a9575096a3cbcb25414e5ac6adb2d09fa7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`aef5826f7a088d4b894f93969d52cdffffa498442893003f1d20ac39fd945da1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`074a638b6e694064bb8e4c048dbd5a5f160616aa7e8ea796511eec934d711406`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`d3cd8383b470e8515a0ee3c011f4a58c2ccd507687394d19e65e1e5a90c41ad4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`9d5f4ef66db29c07987ccef78708edfafd885761fff1ab223606188e2a07fc62`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`8101c38b80b67cdf4e1b8a94b063a5ccdd6bdc68153fa6b7206999e3581ea2d8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`5a40fc87cd09eb1bbf21c13229d34af867629f97d87d615ee0ab3efc511d73df`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`9759e8087b96ab8945bd266834e8d4b2e1a0bbf445a0e050195b4181d55502ca`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`600d7b374944f6d9b0df59bfe566f43a2af6470c4a1b17bb717d8c268a83e0f5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`2dc48668f17faebba84873222db9984237eb3fe1d75b8ce5094cafeda2a59d15`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`f010a37e51b7554519f13ac655572da1acab52f67b9addd29c93d5609492b271`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`74ef978fc3d4e9937787e1d03c8f228770a13d469ecabbedbf8986fa8e79192d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`10deb896a7a14fda356f3232bcf9fa1b18f3d3165f2974bcff20969360a3c014`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`91ff93b30a3c4ad2b4716ee17dca1918f41c226498a30f6e2eec69b6fd5a7374`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`69fd2071a9d48e43d0d46b6351f758981888073f89a50b441394681b8e6dcb7c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_prepared_validation.txt` (`ab0ef42506670f685155382286b6e5abb05d5ddbb5098791e045c69f57dea9cf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_route_exact_task.txt` (`4bf633cf6e81fd1e506752547faaaa5e6530f674cead5520253557e47ec16c39`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/page-026.png` (`c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/primary_pages.json` (`6ed4802a3adc4486d356ff2b6ed7ea77e1c6b6bf5f4bc338b99667d7b7d1c1b1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`2a83adf46a52473ad95d082dbccc8705f104b1e6a68e628e523a13e48a76699d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`1a8f86b1d46a020b50b5ff4310c5324af4e2f1dea5b3f92611d12f5970f858b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`19af373db805924a62b291391eea9eabf39f5e9664561c8b80e5fd47a4d04b32`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`a7985ad21b8d81d4075bf8e7b078e49b1b07ea0d6be27851cd6215c8bcebb284`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`15bdad8fdf564872af78d0bf824d5bf16874066d2a4a9e8ac752bd505ed10385`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`f4cbb6c5f31cd6bee1851cb5769b139e3ee7de5d5b2521e2b58676a35fb60540`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`d88b7c2a9706c39cc79958934eac7caf9ab5236b39ef8e01a749e32e9db65d50`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`3d7c8c24222326daf8f3f99997292b8c132359a9b3bb1a7a63ec3a0403d14e15`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`d41ff297a8bf1299c663ecb764f8cba82e6cf6bbbe9c1ab3f2888c08ab7065cb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`baa588924ce628e3928691c4d879bec92e75f2fd0461f532f6a435ed2abbcc25`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`25d2da0f9eb2186c1d3651973fc53debe7a3d6bd055c1327820b60b58f4fc4e9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`2189bc81028559c7e8caaed99265f1e7c77ded46eabb3737c0168f1d0e26f416`)
