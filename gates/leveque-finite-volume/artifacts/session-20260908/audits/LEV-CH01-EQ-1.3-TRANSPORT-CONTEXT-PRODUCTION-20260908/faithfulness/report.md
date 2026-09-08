# Faithfulness audit: LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `1fe9d1340518ffff0a656708d97b4a9ce4377fd51804fe9e047c3262addf10ee`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The adjudication follows the attached primary-source renderings and the exact inline declaration evidence, without using the target proof or treating judgments as votes. The direct and blind statements agree on the five conjuncts and their quantifier scope. The native supplement resolves D055 and the associated operator and nonvacuity concerns through explicit measure declarations. D002 and D024 have definite meanings; their remaining uncertainty concerns correspondence to the source's unstated admissibility, not their Lean semantics. Formula, velocity, scalar domain, flux signs, negative and zero speeds, oriented endpoints, and the distinction between characteristic and partial derivatives are preserved. The reverse implication is established by substitution, differentiation, and integration of the source formula under the target's premises. The forward implication remains uncertain because the supplied source does not fully specify the scope of solutionhood for arbitrary profiles. Under the supplied classification policy this requires undetermined and nonacceptance, without asserting a demonstrated mathematical mismatch. Source and environment hashes were treated as supplied provenance and were not independently recomputed.

## Implications

- **Lean implies source:** `unclear`. The target contains the exact translated field, preserves its initial profile and its shape at the same constant real velocity, and establishes actual classical solutionhood for differentiable profiles and rectangle conservation for every locally Lebesgue-integrable profile. These conclusions include ordinary discontinuous profiles. However, the selected source's arbitrary-profile solution assertion supplies no complete admissibility class or precise universal solution notion. The contextual distinction between classical and integral solutions does not uniquely settle that omission. For example, p(0)=0 and p(x)=1/|x| otherwise satisfies neither analytic premise, so the target gives only geometric conclusions; this demonstrates the target's boundary, but is not evidence that the source intended this nonintegrable profile as an admissible conservation solution. Thus neither full equivalence nor a definite weakening is established.
- **Source implies lean:** `yes`. The displayed source family q(x,t)=p(x−ct) implies both pointwise identities by substitution, and its characteristic composition is constant and therefore has derivative zero without regularity of p. Under everywhere differentiability, the chain rule gives qx=p′(x−ct) and qt=−c p′(x−ct), fulfilling D001/D004 with actual derivative witnesses. Under local Lebesgue integrability, translations preserve spatial integrability and nonzero affine substitutions preserve temporal trace integrability; multiplication by c gives flux integrability. Writing P(z)=∫_0^z p yields the exact rectangle balance by interval additivity and affine substitution. For c=0 the field is stationary and the flux vanishes. Reversed endpoints are handled by oriented integrals. The native supplement identifies the target's fixed measure with ordinary length measure. This derivation uses consequences of (1.3) under the target's own premises, without importing uniqueness or a general weak/integral equivalence theorem.

## Findings

- **major / unresolved-source-admissibility:** Acceptance as equivalent or stronger would require settling an interpretive choice that the evidence leaves open. A definite weaker classification would likewise require evidence of an intended admissible case excluded by the target.
- **note / measure-and-nonvacuity-resolved:** The round-trip measure concern is resolved. No zero-measure or nonintegrable-default-value artifact undermines the intended conservation branch.
- **note / characteristic-derivative-and-strength:** The target does not assert classical differentiability at jumps. The characteristic derivative and initial identity are consequences of the source formula, not independent strength that could compensate for reduced applicability.
- **note / contextual-weak-formulation-boundary:** No correction of the contextual printed identity or general equivalence with Definition 11.1 is needed for the reverse implication. The selected Chapter 1 claim remains the audit object.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `unclear` | `unclear` |
| `C05` | `unclear` | `unclear` |
| `C06` | `pass` | `unclear` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `unclear` | `unclear` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `unclear` |
| `N01` | `pass` | `pass` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `unclear` | `unclear` |

## Dependency coverage

- Blind translator covered `100` dependencies (`0` hash-reused); unclear: `D055`.
- Direct judge covered `100` dependencies (`0` hash-reused); failing or unclear: `D002, D024`.

## Remaining uncertainties

- The selected source does not specify the complete admissible profile class or solution notion behind its arbitrary-profile solution assertion. The supplied context does not decide whether the target's local Lebesgue-integrability branch exactly captures that intended scope.
- Consequently, completeness of analytic solutionhood and Lean-implies-source remain unclear. Resolving the measure does not resolve this independent source ambiguity.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`188cc54927aa49dae694404d90061a5c4ee497b782bff99033a42b25a35364ea`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`20b3ac98752f490c67ee48452784d006d7a0dcc632a65b68ff50cf3a32939cfe`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`301e4a6db012692067b9199fdb1426765ca4f7c4ed2683939da1aa28603b8df1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`c55579579840766844dfe2f7cc6de98f579f1aa318b78ffe3f2ff7e48ca736cc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`0ef1bc9479b584662673913da7f5c391119c2d0ed4473c981e8be0ab62e6615d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`bf3ed35bde478adf764d2269a3d9963f0e3e80efb9bb0c26548c6f679da6f93c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/decision.json` (`6c248e6e9a3daecce9a6b318a9760a15a18570e3ea57c204f330a4ecfe5930ae`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`7683906aabfa1342e43700bc7cc5f12283c507f43a96669fbad8447ceed9a636`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`69cbeb67c82f24226fdbf3df9959f3e127b28272b7f7094d9e2c935db3586c54`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`69cbeb67c82f24226fdbf3df9959f3e127b28272b7f7094d9e2c935db3586c54`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`d8b1640154cb01cc7c618d3364af1fc1cded2091bf9d6d0439c0e7946ccc22b1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`33e6926619de35d2b514fd878b548ded59c2321e88b303a479b54e2084708dea`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`8db30695a1a3968de465222e653c5e20b633c01d5472220f14c72fcfbac2571c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`9deba2090c5c29e959a0616febeb32e205a66f43bb5ce0b40dcfeb977c0c5f3b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`e9a58e1854075c3192f46f8e5c38603ec9eb1a7ccc0c1b166ebdff40fee22931`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`188cc54927aa49dae694404d90061a5c4ee497b782bff99033a42b25a35364ea`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`313745a2d5f103c372960bebfd65d56b7e9f7549797a0e51aa0ac9f05ccc0ca3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`6ff4be2ac7dc54e2b1bb4596e7865ceb89a9614344fdd7a7834aa06b44de38e6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`f77e60ec85dab45c69f688aa2ad9fbb3560f7f0c626ceee5a67784b004ec9d63`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`acdbbc9272ac53db86c354b89db6fc15fd5aba35ceb56a285961083440d41a9f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`0413994d8b7dcbb2434b3706faf0e42fb846742898db1cd1bd79eb7e845c1519`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`10e8c9ef8e846b0d7fb0734e4a5d707cb12bc518c0aa4c3cddcbd2bacd7ed76a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`301e4a6db012692067b9199fdb1426765ca4f7c4ed2683939da1aa28603b8df1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`bd7dbd82668360087c8bccb2a5c1b270635e32391b434767800b2745cf1e7de4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`d76ab717f23c09365172cf68eb6a8b66a7e021db9e38d090bb058c5725856d61`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`f87a6800e154456ec8cbddbc64cb551c45d31a4994940bc3ea6139d0a0161ed4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`0f5ab7a3a829fc5931d229506c7a4e2021e3bf913b2720d83fbc9345555e2218`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/c.py` (`256a743ee7e693d146323b401e6a0f7316ef22ad345912225177dee03e5140e0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`7ddb49cf93b11db87022f177082225b2451cfbe59f006b41e9d7dbd84c467bae`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`c55579579840766844dfe2f7cc6de98f579f1aa318b78ffe3f2ff7e48ca736cc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`0ccd7acc06e4d394d2b9813b94c351d3d1b3e3768ab9cd859006981f4196c887`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`7b89b95927297b50a3c8a820f748fe0537584b672e096efcc2afa832feb937e0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`eaa1db501418b317c8c38bd372e3b49eb3a5ea697c70bdc67c2d5610fe03739a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`7b1536814f0c39b1d6ab353547e385ebc170036349c5dce4316db7af67782bb7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/helper-construction.json` (`f3b34fb21d343dcf2346324afbc8b94b02540d8a6a05d2756330e5a5dc38d2e4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/page-026.png` (`de53be1aae881a448dd2718b09830eadd7387124ea339f874ee5f55d49fa2257`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`b23d80176b69db0cebf8fee1fcb4c64ace36777dae21a61097a3090ec29e2ac6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/page-237.png` (`e364e7088c5343a5c5b6cf5719cb8a2900d063e67440525ffd8bdf0df1af126f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/page-238.png` (`f21728762f67bbff20b5736cdb7d736c52d69970ca6cda6aa6c323d82210a2b5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/primary_pages.json` (`2060068db179f27c67d7ee6b4e36429f7ec1f3cb9169ae47ea3fe85c43329506`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/q.py` (`4c9d73114aa5932b719679767e2589c0a8feb43bdafdbc2dd06e48bb1c087cb7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/r.py` (`f46124b1d53e7cc45c94860eb991fd12fdf01b7298dc63e91dc500536e3cfbe1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`9acfd1468e0839ff6981d5e4c1b36779d037f9ff0a3c0a5071bc6379dd8d2323`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`0ef1bc9479b584662673913da7f5c391119c2d0ed4473c981e8be0ab62e6615d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`41ca1afeabed7f60c7d60afe99d86c785e85459d75a8c0d1a9690bb387eb368b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`3fe571510b1d7857f2a2d43a9f7bf352a977b9e18d6ef64ba33bb61dc188750d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`f1f8e43873c1f7e6cac07a0a1acbfc18b00dc3342b7223cee1ed9f8c5993ae49`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`6c72f876599e866c816924ad7369179f4e8ec59f22f0300979131026c766a3a7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`ac2c9a295c808255a92d415f0967a0f56f1e4c7eb7a1a46a5ea7a728a42d46ae`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`bf3ed35bde478adf764d2269a3d9963f0e3e80efb9bb0c26548c6f679da6f93c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`7fdc9147fdf450f03415a25067b701b8a4cec7d444274d5059c5ac7c6bc048be`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`841febd13f7ff3baf8c6f0f80f1edb6911a35c187de4ab8a2df85cd2057f6b11`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`0f7a6c59f1de78f2d88fa8b8725ac0bac9d5cec2a875d45dc48e477df09ebcc7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`8b0f83d487703265d21299f2a500648fd26ed8b6d935941ff61956f08dfaabba`)
