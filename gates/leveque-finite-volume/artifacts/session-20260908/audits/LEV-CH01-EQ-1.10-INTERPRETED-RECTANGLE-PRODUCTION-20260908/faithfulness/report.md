# Faithfulness audit: LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `b714622cdbb1ba1b36a8f64b7dc96199a82805043f8256728a4b1298257593e2`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the attached source pages and inline declaration evidence resolves the disagreement without majority vote. The native supplement supplies the precise measure identity missing from the blind translation, including the exact selected instance and normalization. The remaining operators preserve spatial mass, temporal differentiation, vector components, endpoint signs, integrability, and interval-dependent exceptional times. Unfolding the local predicate confirms both implication directions under the recorded user-adopted interpretation, and positive-dimensional examples establish nonvacuity. Faithful-equivalent is therefore accepted within that interpretation, with the original printed-source ambiguity preserved.

## Implications

- **Lean implies source:** `yes`. Under the recorded user-adopted interpretation only, conservation solutionhood is D001's spatial integrability, temporal endpoint-flux integrability, and rectangle balance. The target's forward implication then supplies the actual derivative of spatial vector mass equal to first-endpoint flux minus second-endpoint flux for almost every time separately for each fixed interval. The supplement identifies its measure as ordinary real length measure. This recovers the selected equation's componentwise conservation meaning under that interpretation; it does not establish an everywhere-classical reading of the printed display.
- **Source implies lean:** `yes`. Under the recorded user-adopted interpretation only, the selected claim says that rectangle conservation with the explicit integrability conditions has the intervalwise almost-everywhere mass-rate property. Writing the rectangle conditions as R and the rate property as D, this is R → D. The exact Lean proposition unfolds to R ↔ (R ∧ D), equivalent to that conditional assertion. Its reverse half is projection, and its forward half imposes no extra state smoothness or common exceptional-time set. The zero-dimensional case is independently trivial. This implication is not asserted from the printed source without the recorded interpretation.

## Findings

- **note / resolved-measure-semantics:** The D065 evidence gap and its dependent conclusion, operator, coefficient, exceptional-set, and implication uncertainties are resolved.
- **note / interpretation-qualified-acceptance:** Acceptance applies only to the selected equation under the recorded rectangle and intervalwise almost-everywhere interpretation.
- **note / logical-form-and-applicability:** The theorem establishes a nonvacuous mass-rate consequence of the adopted conservation property. It neither asserts conservation for arbitrary functions nor reconstructs rectangle conservation from an almost-everywhere derivative alone.

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
| `C09` | `pass` | `unclear` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `unclear` |
| `C12` | `pass` | `pass` |
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `pass` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `90` dependencies (`0` hash-reused); unclear: `D065`.
- Direct judge covered `90` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

- The printed source alone leaves the temporal derivative sense, regularity class, endpoint representatives or traces, and explicit orientation conventions unspecified. This acceptance does not resolve those source-only ambiguities or attribute the adopted conventions to the book.
- The runtime provenance and hashes were inspected as supplied evidence; no source, rendering, dossier, binary, or compiled-module hashes were independently recomputed in this tool-free adjudication.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`b1bb20b68eed886af736de45af424646995f6b7ab218e84cc3c5ba5135690656`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`51e76afd52be13a3c31dfb600dccbb745b1c65ea9a616852e09c3c6d7f61f6bd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`490d79809b30f42df8a42380d70f33480e8efe897b4ad254ea2d8f9640458eab`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`8e878242fb15f241b76374bedab4371f1113050a35c2078d1cc8b88c27328c8e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`730463e5aa291865370bcd3cfa875debd3b2310fdb5b42cd3be86d0556e43bec`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`fc0a8ec7337c10e732885700216e937f06c56e4e0db5d067846e66e296be8d9a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/decision.json` (`eb47998419d4a3ffed864a3df8abe133d9865083b808df11d0c28d0171ccf9cf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`ca3d63455575692470059526603d852be4cea1d7980752ee1342abb2284be9c5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`9d433c06ff5f2d107ae6026a7b2c84c46a12d40884377f2b345d9c233445b71e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`9d433c06ff5f2d107ae6026a7b2c84c46a12d40884377f2b345d9c233445b71e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`b4b2667febc7e15797773e30143d67968fdc267cb8c17415ab716a117de971bd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`4bfa6e804d32af92c89d14d372d13feda05d167c62da1a17e7b4ac061e350638`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`568c1c323c817e3383f6580b1a72819055c60c2af45c098f25ae3100dc8ecd3d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`4c45121f343af600d8ca4fa793b09bff2e4b6e63b281f1c45c9e445eb4b81e6f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`221eba30cf2859cd436e032c8b9a1a3975501ed019bee1baf3b7c15e6cdd7ec4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`b1bb20b68eed886af736de45af424646995f6b7ab218e84cc3c5ba5135690656`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`095f1c98f421335d36a980fdb04765d87e631a15575429043f5fc45c264a13ac`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`3d7efa2c33ee0f554d7918f6dd19436f8e08cf38a7034173fcb667c201e7c225`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`f95c45d1ff226f093f2a890349f14d76de58a49ec8a988577fcef5b66554bdfd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`48f6fd340d782b47131b16211a3a721725774e2d9694f34db8602f46627e8e78`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`55d8c0e30bf3b2290c25e2ce71552ca6579a0d90f50770d0d116231a93bcf1fe`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`66a4dfcaa738857ca0fd3eb34565b3f8322da7af18ab65fb54bead545ce65755`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`490d79809b30f42df8a42380d70f33480e8efe897b4ad254ea2d8f9640458eab`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`518bbf2a1ef99db61b625ba7fb217f7ce7232011a19376ea85e07ae2249d2526`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`8595cc8f50688f1e9740bbb13a27edc97b3d2b436d83ca91938eb98a20a13be2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`e8d2fc09eeb8ba0e4af60a2c1ff4b905801f87e8008190eece4cc8c1ba7c5eab`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`b3f52dbc926b660f9945e5320cdff2805ee4315e213523e022ca6c24e0128871`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/c.py` (`a0ded728590832fc8e7fa7d42a0778e44a38aa4076e079a2cb95fa123222aa79`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`84a5ad6d677b1862c225ad5899a0d0ad65cbba3cc65d8eb69668dc21c69a73dd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`8e878242fb15f241b76374bedab4371f1113050a35c2078d1cc8b88c27328c8e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`17c3c419aee4ac94846436776ad861d448b9fed259214a20e387f1f39c66258b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`77dd51c6a0e7368818c8fc77ab91fff60df480e8e95df43f32e60f2721641346`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`d068d7c54d8a957e376e71dafa9825c062cf37268b9766977244b0140beef5c7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`a01af7aedd178a393d71ea8df353429d98bc509308d1f76e3cd3f7c944bac28c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/page-026.png` (`c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/q.py` (`7e88d2d552ee61343f6af09610c9433de5fb5f4abd0d98649acbdfda5c58efaf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/r.py` (`8bfa824dc9995b69c679c46bf9df3f7e3c0b3d29f2b70bac6b75dab9aa86bb58`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`960373cdd28f04355fc9ec5b8281563ab8b6d72de234ffb5a45cba3bd038a1ed`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`730463e5aa291865370bcd3cfa875debd3b2310fdb5b42cd3be86d0556e43bec`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`0ac5b16cb7243ad4b694274229628822ef7a330f61785ea13855eeccf1702d5a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`9d23eb0e306fe6de877514d14311998e38dc44d35c356bc4841c46dd1b253b28`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`29064334af602fa1393cd3b6e64c96ee3939472d8725b41cfc5547d79803336c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`ffe1e1999536c3dd2ed6e87eb57ba6d2a3516671f37a2d2d02921bd4444a4672`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`0b528e004196315592cade33d68b0f7d39a21a4281c06c5820d57c4445af7042`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`fc0a8ec7337c10e732885700216e937f06c56e4e0db5d067846e66e296be8d9a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`14bb1e92cff45ec43ab9145369df37dd0e2fdf83f26bc8f107d1a8a4055e7a6f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`f8a29cadd84f7c1383e81ebf34618eb195820d8dc40cbda028c7206fa28fc432`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`e03fd15f8e7495b5b980983672a26e7c3ba23bac41bc0fa11e7c5dbcd7625c18`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`eaf35a8cc06b85efd004f29c3159212e2826b66ca2740bcb82f8e7dca6786295`)
