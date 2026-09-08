# Faithfulness audit: LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `314da48d06992924535db624d9872074d95ad6d44320e8b42682ee9f3c708e37`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Inspection of the attached source renderings and exact inline declarations confirms the algebra, signs, object roles, derivative semantics, reused dependency effects, and nonvacuity. The blind translation accurately describes the target. The direct judge's equivalence verdict depends on an exhaustive physical classical reading that the selected source does not fully specify, especially for profiles. The round-trip judge correctly retains a coverage uncertainty but unnecessarily leaves the reverse implication unclear: the target's local classical assertions follow by specialization and elementary differentiation. The resulting unclear/yes implication pair consistently yields undetermined with acceptance withheld. No source or rendering hashes were independently recomputed.

## Implications

- **Lean implies source:** `unclear`. The target recovers the entire positive-parameter classical claim, including acoustic linkage, the exact minus mode, positive sound-speed magnitude, negative transport coefficient, and differentiable traveling profiles. The physical context supports positive material parameters, but the source does not explicitly delimit its solution concept and inherits unrestricted profile wording. If nonsmooth solutions are included, the target does not supply that coverage. The evidence therefore supports conditional equivalence but not an unconditional coverage verdict.
- **Source implies lean:** `yes`. Every target system supplies the source acoustic equations with existing classical partial derivatives and positive physical parameters. The displayed mode assertion gives its scalar PDE. Positive K/ρ gives the positive principal sound speed. For the profile branch, the source formula f(x+ct), together with the supplied derivative a at x+ct, gives local slice derivatives ca and a by elementary one-variable differentiation, so the required residual is zero. D006 supplies the exact value identity. No global profile regularity, uniqueness, or identification with the given acoustic mode is required.

## Findings

- **major / unresolved-source-solution-domain:** Acceptance as an unqualified faithful representation remains unsupported. The target is faithful on the classical differentiable interpretation; any broader intended profile class would require additional coverage.
- **note / material-domain-interpretation:** The physical convention should be distinguished from an explicitly printed hypothesis. This distinction does not by itself establish a substantive omitted source case.
- **note / local-profile-assertion:** The round-trip judge's local-versus-global concern does not block source-to-Lean implication for classical profiles.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `unclear` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `unclear` |
| `C11` | `pass` | `unclear` |
| `C12` | `pass` | `pass` |
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `unclear` |

## Dependency coverage

- Blind translator covered `109` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `109` dependencies (`8` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

- The source does not specify whether its unrestricted profile wording is shorthand for classical differentiable profiles or includes a nonsmooth solution concept. This affects Lean-to-source coverage.
- Separate material positivity is supported by the physical interpretation, but the selected pages do not explicitly delimit the coefficient domain. Both-negative pairs establish an algebraic distinction, not proof that intended physical cases were omitted.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/agent_outputs/adjudicator.json` (`e50c9bf19309a6c82797e570162fa04159ef04271e3d508e9c9b698364337501`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`6defef0ee19f6468d6c82afcfb811ad987f4977aafc03cb9a586be76dfe38146`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`d6ce566e9d2a7290a159b07a1209eb7d1798c80f1f9daac7517881cdf91df787`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`d936f15ef74db154a151f1821c2622a777b7a78504cfa6d8244fd446a1bfb770`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`4bbc4a4001fbcb1fa50bed15a36cb4df0e10402d8021f02358dc2db91b2e9622`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`2fac7eee6464c9be701e3aeaa9191faee72663c829eccef8f43c1510c59c50d0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/decision.json` (`ea7b43ef78d9ee144b4095446c6a7c801f7d08dfebfc59f2069b9e19b94b36eb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`762570be135c522aaca0a66460006d7f1a1c14b9e06ee6526a078fc485536bca`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`f61d10d84b8eec32f8e371e980eab1ab430ba827f77f9dbae17b794ae01839d8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`f61d10d84b8eec32f8e371e980eab1ab430ba827f77f9dbae17b794ae01839d8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`139122c907e227564216bfa58ab8a61e58d2e9f696d0b29f95f6b25b419ecc22`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`4dd604e65cd0b3f71e697689b54fee0f3d15319e78caac1fd300d7c51802de50`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`ffb4a8cc791db96b77b5c852a0c8e407a371cdc9f485c2c0f76436617fb18cd4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`40b2a75a9f524428d810a4134ee5300bf85a87d29eb3bc34f9527ebeb84cac5d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`4a799c8d2ea57ab7fc6fb5e92409b809b093fb57e67d91176f27c171fcdf284e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/a_events.jsonl` (`34dd77c60a9e39018a1756f2df2d219e35b0b325605151b42e656cb399674832`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/a_final.json` (`e50c9bf19309a6c82797e570162fa04159ef04271e3d508e9c9b698364337501`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/a_input.txt` (`6a365e3ca3869114e95c56ceba71e63ce0bb9a4516ecee2f486a6255e3efa6c6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/a_runtime.json` (`34a391be4d8f7bf69e842b01e8e10115a33e7f2baceeabb511779c1234405993`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/a_stderr.txt` (`1fd3f36d62e3a6f481d119f98ec932241e9fc4493415110c2df1244902cdbd6b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/a_transport.json` (`544d6b27ead9d4d316df238179b8be7914dd497288de55d4e354a4c9a1627650`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/adjudication_triggers.json` (`d8d558c8e98fcaf7b48298aec9263d53b64c70c9f11dba56d5d6501229831219`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`faf005d6eaf23d99fbd2f16fe0138af2af287042d347bba7c9e90e3b5bfafe07`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`d6ce566e9d2a7290a159b07a1209eb7d1798c80f1f9daac7517881cdf91df787`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`b4a60f4fbf8e994f507fba00cf8b47b3d2401f1227055dcd5af90a3b169ec862`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`2ab5aaf46e165619db07d4e938f9ab11e33b29e89dc3a01b561f63c470f04500`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`0255bc9120f86f3735a5be54644e4e1b00a88c4e89e7b156b495c1d6045c20e1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`ab120dc7833d1713b01c0eb81693299dc7c332e48b009308c6f6a9fab0e77e8e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`74336edd272902257c0b3fb0c24df5ecfb0425b23b6c8b506e859e2cabb8629b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`d936f15ef74db154a151f1821c2622a777b7a78504cfa6d8244fd446a1bfb770`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`fa5c9311474886ab883aa4babda53abf23e1f04481b02a4c69eee1dafb8fa576`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`3d93209cee65a3e5c33d22fee93939468e29f12f8e83d22fb495e9ee088f3e14`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`880e82f5fdd37bd6f12473cc4461607962dfa2f700592a9793060809b5e28de7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`781cbef9e943e3363b59bdacfdbc6ba1341468280f7d0e20e72859df557ffceb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/page-024.png` (`9374c58069ddf2cc64e5aa888141ee9aa41977be7af9f29fd0cff786a5df3b02`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`bfc7dd88286219a90fe99f463beb4e57b6953cb964747abb7322f51527292393`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`4bbc4a4001fbcb1fa50bed15a36cb4df0e10402d8021f02358dc2db91b2e9622`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`c155f15509dd1e5f7de8801ceea00b48bdd1cc581f37aea04ac69932955baf27`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`f3b662f2c5285867281cd601ea728b214487aaf9bfa9daf1b28efcb795020f91`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`78d200f0b6b7155e0c0446adaa43f2f1c518659714c9a408e80690fa491fc81d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`8cb00ecf696ffed2e8d48ad4abf4dc9794d576485f41bb725031e42a8f0962af`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`33e5091233e444565b4decee34af1d7b636b5bb637abf6166cbab6b7be7b84b2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`2fac7eee6464c9be701e3aeaa9191faee72663c829eccef8f43c1510c59c50d0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`f8c085d77ccc5f230edec4cd2120d6a92e3a0c8c5d27c3e71f2a25483b3d5ce3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`c4fb900804ed656db74948ed8de5ed2d0adaac7a4139b7a51d9db818d933c430`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`cde3f7c25dd7903da02d445c5b0588832dac9979526aff6137816588935a5377`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`98276214cf520806427e2453ce8464964f2587eda2dcf626bdde2fc4f1fdf1f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908/faithfulness/orchestration/v1_supplementary_dependency_evidence_route_20260908.json` (`afbc0a8fd4d11685ba9526b152c3e84910b979f63f184d882347e5c7ae96efdc`)
