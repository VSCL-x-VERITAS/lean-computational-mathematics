# Faithfulness audit: LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `1fe9d1340518ffff0a656708d97b4a9ce4377fd51804fe9e047c3262addf10ee`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the attached primary-source renderings and inline declaration evidence confirms the transport construction and resolves the meanings and effective domains of the disputed solution predicates. The transported-step example rules out treating nonsmooth integral conservation as an everywhere-classical mass derivative identity. It does not authorize choosing a unique weak interpretation absent from the source. The supplied measure declaration also does not resolve the specific dependency dispute. Consequently, undetermined with acceptance withheld is consistent with both implication assessments; no majority vote or claim of genuine strengthening is used. No tools were used, and source-byte or rendering hashes were not independently recomputed.

## Implications

- **Lean implies source:** `unclear`. The exact real scalar translation, constant speed, unchanged shape and classical advection for differentiable profiles are preserved. The rectangle clause gives a substantive conservation statement on its explicit integrability domain. Under ordinary length measure it implies an almost-everywhere mass derivative identity for each fixed interval, but not an everywhere identity. Neither the source's full nonsmooth admissibility class nor its precise temporal interpretation is fixed by the selected pages. The disputed identification of D055 with ordinary length measure also remains unverified from the supplied declarations.
- **Source implies lean:** `unclear`. Equation (1.3) supplies initial data, characteristic constancy and its zero derivative; differentiation supplies the classical PDE clause. With ordinary length measure and the target's interval-integrability antecedent, affine change of variables and interval additivity justify the rectangle clause, including its slice and flux integrability requirements. This conditional mathematical derivation does not resolve the exact measure dependency or establish equivalence of the source's unspecified nonsmooth solution meaning with the chosen rectangle formulation.

## Findings

- **major / unresolved-measure-evidence:** The exact integration measure cannot be conclusively matched to the source's dx and dt under the requested evidence-bound dependency review.
- **major / unresolved-source-solution-semantics:** The target is a mathematically justified precise formulation under ordinary length measure, but exact equivalence to the selected source assertion remains unestablished.
- **note / effective-domain-and-strength:** These conditions are necessary for the selected predicates rather than gratuitous restrictions within them. They still cannot be credited as stronger applicability relative to an unspecified source domain.
- **note / nonvacuity-and-characteristic-derivative:** No impossible classical premise, totalized-derivative shortcut or confusion between characteristic and coordinate derivatives was found. Substantive integral nonvacuity is established conditionally on the measure identification.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `unclear` | `unclear` |
| `C05` | `unclear` | `unclear` |
| `C06` | `pass` | `unclear` |
| `C07` | `unclear` | `unclear` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `unclear` | `unclear` |
| `C11` | `unclear` | `unclear` |
| `C12` | `pass` | `pass` |
| `N01` | `pass` | `pass` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `unclear` | `unclear` |

## Dependency coverage

- Blind translator covered `100` dependencies (`0` hash-reused); unclear: `D055`.
- Direct judge covered `100` dependencies (`43` hash-reused); failing or unclear: `D002, D024`.

## Remaining uncertainties

- D055 does not expose the instance selected by inferInstance or establish its identification with normalized ordinary length measure. No incorrect measure has been demonstrated.
- The selected source pages do not determine whether locally absolutely integrable profiles exhaust the intended admissible nonsmooth profiles.
- The source retains equation (1.10) at discontinuities without specifying a time-integrated, distributional or appropriately qualified derivative interpretation. An everywhere-classical interpretation is ruled out by the transported-step example.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`7b032d4b30c02b376420d192691514f762cc08dc0faf49b120e553dbb4f03f88`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`773987d76f22dd28949debd01612d1197d2a577b7ea1e5f462227c6e8c52c90d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`f4c4f5fa14034ddf3a2b2ef8a8a592498550213ceb64e7931457a9b327ec437e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`72906575499dc5339c36387a1608e72b0e9bdcbb5fb93e3d779cce8bd956a81b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`f3a1ac6619ca65fbc83535ce58aa1633f3f65ff3876f7687ee4cd0009110a891`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`59e2cabcafda215cb671f0994cf48dd09aabceca306e1097846ed8342d0a9cca`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/decision.json` (`b2047373180d8d4fd572bdfc2a24a9905b7d4c750b228f4888da15a2727ba843`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`7683906aabfa1342e43700bc7cc5f12283c507f43a96669fbad8447ceed9a636`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`69cbeb67c82f24226fdbf3df9959f3e127b28272b7f7094d9e2c935db3586c54`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`69cbeb67c82f24226fdbf3df9959f3e127b28272b7f7094d9e2c935db3586c54`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`b4f7ffeb06fcf460677616f960434a0639e49c2f11a00a3f5fe745ef4013f092`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`33e6926619de35d2b514fd878b548ded59c2321e88b303a479b54e2084708dea`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`7d3b5c5d6e97f728f26142d14ac4780715dad724e2617e75508c7d00c394940e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`2ef93710a328ee831babf54021e63e22495fc760b60a68e50e9a4b2aafe441ec`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`2bd987d6983ac8cf44c5dbd75ff09c175322bec411b5db66fd2d420b27c14d82`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`6d314898f935448f4f8df49061dd6fb83cb9834766400e8d20efe95850e33795`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`7b032d4b30c02b376420d192691514f762cc08dc0faf49b120e553dbb4f03f88`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`71d37c1ee4aa6818c767e572c715bfaeff65bbb3ff7dff2ce016ba1cfd32e631`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`5dcda2199baa5ac9bd47b570607eae03a8b8ed4370794265fcd642c06cacd63c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`0b3212bf0e558ff210ca305847ceea320bace0c74eaaa7f1bcbfd7f7aae37de1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`07e99d97792da5fc89bc6b97e9e079699321c54669bc314cf9f46c100ee42534`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`9b9de9206e8583e9e39667a2fdc4abdede39205b38f99502d07b37502f55f442`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`a081f37a14f8c7603f212d438035cb4b76fcc155001d44fad5e451e1c515846b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`f4c4f5fa14034ddf3a2b2ef8a8a592498550213ceb64e7931457a9b327ec437e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`bd7dbd82668360087c8bccb2a5c1b270635e32391b434767800b2745cf1e7de4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`a48d24c4c10422a3576bcb9d868f918c34d7b5f3405dccb5b92e8823803242b4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`0098cf06061374bbc0644355f3067f5c68e02e10c9a785f87ec69e087e85c75c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`97e37b5420c8cb73e99718db0a2e055b0c7628bc1a9ad951824d5ede531762ed`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`8c0bddc7394d2047d123d9788b0492f4a7a96ea8da12c0ef111eebe13dd697e9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`72906575499dc5339c36387a1608e72b0e9bdcbb5fb93e3d779cce8bd956a81b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`003a32a3987623696fd29200648d63ee0f91326e2a27675ff64be0f4539c5e16`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`1cf58251a5d4fa01748ba0cab2959ad18ea08e0c3b5e9524da9933957858ca8b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`d2376f77f487bbd668f9cea74dc387e45a2d16417b7a33c88fed2d0d5610d908`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`aa308825d7ea3703643789b6b400b1d9214aabef25553c5f03244ef4829fb309`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_prepared_validation.txt` (`2862c1ed3bcc12f448f78f9176af83e571347dfe1ff7bbd9e02849b8a733a7f7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_route_exact_task.txt` (`64b4ab0ebaabcd1a42233a63f1997b054c2bd59da8716e0009c180c29c4c5190`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/page-026.png` (`c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/primary_pages.json` (`e76d713a352c1933cfd2dc33d1a11a34bb9b17009a0d25069d9abd8a1b9751a7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`4803297561d69978b2b2476aae59eaafae266eb1414f5e967e1e5c8f4e6fa33e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`f3a1ac6619ca65fbc83535ce58aa1633f3f65ff3876f7687ee4cd0009110a891`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`f2fdfc1c6c2d9bfd21fcd05401fb2b43485a60561eb8b477c6df188e2f209b8a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`f21b52461a3a5a9071638a5df0c268d5485178a5e868c3d0c0863149b0aa847b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`7f34df47f05eb7bfc0d9b87404fc03a8a10b2cbc4d3971995156739c8de94c60`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`997ebd42e6a3a6350af0b6f3d95e8a582c651825f50f23af0ebce8685d05adaf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`9a4de2c453a3dfe9260db086ab1eec63ed49cfa2c64b7334750f3b2701718a79`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`59e2cabcafda215cb671f0994cf48dd09aabceca306e1097846ed8342d0a9cca`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`f92e15d7955fda9223f36e2f4352e1aa304b8209722d1ecd5490fe0788942dab`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`069e87ea2f8f076a54669d728e703fb9f5216da0793109f3dd0f77a5321bef91`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`9b7129bb64786f6fa635a7eec4f552627fa241cfbc1e42dd443acb61e83494d5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`365365238f867fae5360caefe162eaa3e169326f4b3a6f11f222c6a3d47d0e14`)
