# Faithfulness audit: LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `dd21cfb1191e0d2459c61ce981da525c00e5c13c7ba1455fa096ebe6675864c1`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The attached primary-source renderings and the proof-free header, readable type, explicit type, dependency inventory, and native environment supplement agree on the selected scalar transport structure. The theorem preserves all real speeds, real-valued profiles, scalar dimension, characteristic sign, genuine partial derivatives, linear flux, and conservation orientation. Its transport premise is equivalent to the full translated-profile family, not an extra regularity restriction. Both analytic domains match the explicitly adopted convention, including zero speed and nonsmooth profiles. The supplied native measure declarations resolve the exact selected volume as ordinary real length measure. Every listed dependency and configured semantic check has been accounted for, with no unresolved comparison requiring adjudication. No tools, target proof, prior judgments, or independent hash recomputation were used.

## Implications

- **Lean implies source:** `yes`. Under the recorded user-adopted interpretation, the target supplies the real scalar hyperbolicity claim, identifies the scalar differential equation with the m=1 system, and gives exactly the two adopted analytic domains. For an arbitrary real profile φ, define q(x,t)=φ(x-speed*t); direct substitution satisfies D004 and q(x,0)=φ(x). The target then yields classical solutionhood exactly when φ is everywhere differentiable and finite-rectangle conservation exactly when φ is locally interval-integrable. D004 itself expresses unchanged-shape transport, and D003 preserves the source's flux ūq and conservation orientation. This implication is qualified by the adopted convention; it is not a claim that the PDF explicitly states these complete analytic classes.
- **Source implies lean:** `yes`. Under the recorded user-adopted interpretation, the real scalar specialization supplies a one-dimensional real eigenbasis and identifies (1.1) with (1.2). For any q satisfying D004, substituting x-speed*t for the characteristic starting point gives q(x,t)=q(x-speed*t,0). It is therefore precisely a translated profile to which the adopted exact classical and rectangle characterizations apply. The rectangle predicate's spatial and temporal flux integrability clauses introduce no extra profile restriction: translations preserve local interval integrability; nonzero-speed temporal traces are affine reparameterizations, while zero-speed flux is identically zero. Its integrability requirement at t=0 supplies the reverse direction. The source alone leaves the complete analytic profile class unspecified; this implication uses the explicitly recorded convention rather than attributing it to the book.

## Findings

- **note / interpretation-qualified-equivalence:** Acceptance and both implication verdicts are explicitly qualified by the recorded user-adopted interpretation. They do not establish source-only equivalence with an explicitly printed minimal analytic-domain theorem.
- **note / interpretation-qualified-equivalence:** Acceptance is qualified by the explicitly recorded user-adopted interpretation. It is not an unqualified finding that the printed source alone states these exact analytic characterizations.

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
| `N01` | `pass` | `pass` |
| `N02` | `pass` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `141` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `141` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`eabc0a8ce35b16be0d1f2294a8148b8ff669d854b986e6c8a9852d12efe8a08e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`272c12dfcd273fbcdd156b1283e1427430a1a5f71a90a29663cd0ae2945984c3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`c2e20157c261077fc16253e8de7961ad59f6936cfa5d691bcf70702e13db0c1d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`cda6429ef4da1db00eb103b0551ffda1e8057d5f288739b35310d24cf483a383`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`f7aa63da29448e074f35e4eeb6372b31c4ccc9f481a023ab2dfc8f72c7936902`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/decision.json` (`32fe876cf53c15ab936bec9f89ceff49214a9eb48628b0e310d51f2910a37815`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`753422286aed61eb4ef0625557c9956014e5c6d0c70a88255b8ebd15ec3ee434`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`8dcc710198847a969f4cb0434352cddfd1cd10613cae5bb844c19ad8118c14c5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`8dcc710198847a969f4cb0434352cddfd1cd10613cae5bb844c19ad8118c14c5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`f2b689dbc1e4c74ace3d357d5a304ae734e9246a937e1f042018c1b6de65abd8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`eb9cf84b2474369190e1b68d7b80a2c9d9874662156213e702830c89339b8803`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`a955f78329b35a0069fd5c9364c2147379d8f10f02b5311477db7eec71ccbfc8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`86e1781214e60f66f4971a653d91d0213947b0332c07e5196f40f9a6223a3850`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`72e03fba64d5a9cf4777357a3a05829136092e5e1ca635b33c9ad91b28fef9eb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`272c12dfcd273fbcdd156b1283e1427430a1a5f71a90a29663cd0ae2945984c3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`71066c8d1d7ece20d5c1fd389fc3c6fe86816c80fcf1187338f1b3d492b75755`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`b70e26b272172e099cb69778f6ed0cccb73f46729ad1c04264301d004d76b639`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`31709dd78a6ce6d9605fbe520d59227fb13add1e773b3fcabfa45eb6a8aeedb2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`2cdc6e68537eaae5d6dbe4d9e6583104e1f46b5d6e614535bf75e2f50116f7b1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/blind-isolation-preflight.json` (`ddb3e95258e0a8b9c9d52911a3ae9b62333da25734cc335fbe03acaa14499995`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/c.py` (`83d7158a4723761337c9d5fa16c8007acf901d08ee19b495b1f42c346331996c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`92fd549f793d3a5178d713cd5224861ba02fa32dba256322d94af3b35cfd060a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`c2e20157c261077fc16253e8de7961ad59f6936cfa5d691bcf70702e13db0c1d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`4b9281cf53f4a1aa0735608bbf7dd758f4d290ab994a5e2014cb93bff9c095d1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`4e3ae9bcf45b9d93b724b0c3dfe79a16e81421a8169908cda8ca07f774a2aab1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`594bbe739039634928e8eea8014e97388b52d1a91db333ab784d8703c749e971`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`07e8cc572d0322c81b9d19facba760fa7a280dd3fddbb012185c6d1ceeda7ee1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/helper-provenance.json` (`66dd027bd7c0c310a1dc5f5118dac6abe6335b8b88821c78560dbf6510c3e089`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/page-026.png` (`de53be1aae881a448dd2718b09830eadd7387124ea339f874ee5f55d49fa2257`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`b23d80176b69db0cebf8fee1fcb4c64ace36777dae21a61097a3090ec29e2ac6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/page-037.png` (`0a2a379fb9d46ef6936d10cecfb859960b7186a3ba4866aef447df66bb162b68`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/page-038.png` (`76c82896ba204f4c8f62daa84cb1e99f7a906c698055898847d90bf82543b5e6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/page-039.png` (`c556c94c84c0058913f8984ca0be339f9653be1bc2e3f294da0e99f7e547996a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/page-040.png` (`cd168bd5fa9cea8fdc99a115df7b1061c62d8b01ed24314cf3cb4322c45211b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/primary_pages.json` (`528f42fd7cb880e495adb1a3c2ac97f7356550c01c15f039e17e8757b656dad9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/q.py` (`0377f3a4ef89c50ac09e2f729d86f8ab1d0f2934b3cb01134845adbe3fa394b5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/r.py` (`dff42b4ded965563d20419a1a2842a6e07036dc505dd3dfd44c81cdfc4df736e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`baa27f769ef23d6b067d0d5f2b3392a7bfddc3d56ed4c87a1fc5814381f3c11a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`cda6429ef4da1db00eb103b0551ffda1e8057d5f288739b35310d24cf483a383`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`aa727a3917881bbd3df5c4474b4f138ca1ac089cf63ae516dd53033756d67188`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`1f012aafc8e5a254900b9709bb86c269abd4d269f1b730c376cdd10ff1829e7d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`2fae27d91694ed51b56d5df85a03f95f6d44c341db1434b031b1c58376ec94c2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`7a9070716702fc82006bc16dbee9fc3c9b10bf730201efafc6c7ed79e7d0f18f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`aac4cb4acb5fb044ac9284092e3339430099c42e0d720436a2fe213e506678c7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`f7aa63da29448e074f35e4eeb6372b31c4ccc9f481a023ab2dfc8f72c7936902`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`4f7bd8d2c8a989d7baff84529ee0c5a970f9d93cf1ecd64b922fc00b30b4350b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`2f74d6a05f53d0697de372cf39ec36f1f095454d90d101945b148387b893aeb4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`cd47bb9eb1f46a08f37c365c6985757e48ea2c6f5850d64c15c130fff6506e16`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`df66fc92b60709c913d4e35358c3b62f5a48e6ccbf7ced2af0d506ac51397e38`)
