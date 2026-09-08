# Faithfulness audit: LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908

## Decision

- Classification: `not-faithful-weaker`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `d0046ef59b73c0ce56320217cfa6fea7623c6f95aad19f7e39fce4208983fa39`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Inspection of the attached primary-source pages and the supplied statement evidence confirms the blind translation and all dependency meanings. The target correctly preserves coordinatewise equalities, side orientation, the common origin, separate material/state roles, and free interface values. It nevertheless equates predicates that do not characterize both discontinuities required by the selected prose. Source-to-Lean holds as an elementary logical consequence; the reverse semantic coverage fails. The resulting classification is not-faithful-weaker, independently of the remaining ambiguity about the medium's global profile. No tools were used and no provenance hashes were independently recomputed.

## Implications

- **Lean implies source:** `no`. The target proves that paired half-line constancy is equivalent to separate half-line constancy. Even assuming these predicates hold, neither a material jump nor a state jump follows: constant real-valued functions with equal prescribed side values satisfy them. A constant medium paired with a jumping state also satisfies them. Thus the proposed characterization does not recover the selected configuration involving both discontinuities. This is a semantic insufficiency of the represented predicates, not an objection to equivalences as a form of definition or a demand for the subsequent wave-dynamics theorem.
- **Source implies lean:** `yes`. In the ordinary mathematical background, the target follows independently of the source assumptions: equality of two ordered pairs is equivalent to the two component equalities, and the universal half-line conditions regroup by conjunction. Consequently the source also entails this identity. This does not imply that every source medium satisfies the half-line constancy predicate, nor that the source supplies a global piecewise constant medium model.

## Findings

- **major / incomplete-discontinuity-characterization:** The target does not recover the selected two-discontinuity configuration and is not accepted as a complete faithful formalization.
- **minor / unresolved-medium-model-scope:** The proposed representation may cover only a piecewise homogeneous specialization. This uncertainty remains, but resolving it favorably would not repair the independent discontinuity-coverage defect.
- **note / nonvacuity-and-scope-correction:** The theorem is a valid, nonvacuous representation lemma. Its elementary nature, unrestricted zero values, and omission of subsequent solution dynamics are not defects by themselves.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `unclear` | `fail` |
| `C03` | `pass` | `pass` |
| `C04` | `unclear` | `fail` |
| `C05` | `unclear` | `fail` |
| `C06` | `pass` | `pass` |
| `C07` | `unclear` | `fail` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `unclear` | `fail` |
| `C11` | `unclear` | `fail` |
| `C12` | `pass` | `fail` |
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `not-applicable` | `not-applicable` |

## Dependency coverage

- Blind translator covered `12` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `12` dependencies (`7` hash-reused); failing or unclear: `D001, D003`.

## Remaining uncertainties

- The selected passage does not settle whether its extended Riemann medium is globally constant on each half-line or may vary away from the material interface. The cell-based motivation supports a piecewise homogeneous interpretation but does not explicitly prescribe it.
- Equation (1.11) omits explicit inequality of the initial side states. The source does not specify a formal convention for including degenerate equal-state configurations. This uncertainty does not supply the missing characterization of both discontinuities in the selected sentence.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`69cd5c4aec2ab526789251b4123dfe4afefba2a80648b01a36c356b584f55e3c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`245b23eda5b7aa04760f79a0894dee0c5b6e2f761e59639af83b0264629b4dc8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`b66977475ec5c11e03732f8efb897fc7e68888e11d5229b0fc4eec39ddb42388`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`5c0c9cf44b856aec9d9bc91abf4068299a5ed08cbd6b532dd2fd5659b1a1959c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`27e078b23c78ea42d05c351858552e8c4d5990018264330fe2d7ebf26b724497`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`0b8f439fe0095666f6edc34ec542b1e9d2e5b476bc59965e830641beb6401d1d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/decision.json` (`d39e5f7d682275ebe7333695c0249c6e4ccffd7b81e0bc4bfa3c4930659e1216`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`c202a395bce892fcfddd48c46b0b5018500dde27d39f34e70666ef9316b36c14`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`86afccc2d1f62321ccf0ce12693b12f99a1d32d78b17d01afde55e8bd86745ac`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`86afccc2d1f62321ccf0ce12693b12f99a1d32d78b17d01afde55e8bd86745ac`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`42658f4a12a9f2c86321ee776a9520961118a32d416989b6fdb9bc220860f1ec`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`c10b9547604c8a45a92098c580cd43d3597e53816c24d92adb4399afc04fbece`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`55ebfaf4d4959db43842afeb4b5d931ef79e3127c57dea804364fbd5071f9e9a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`daa04586961ee34da6b50e6c351089cc7901b2e3d7eeb5a8ec7586cd562e6931`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`1e295c40724e86dab517e4079ebb7cfe51ab04bd1c6f6153a8c1fd485902d200`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`46a7179b3f899fc1a191dbb950e6e79215129b5eaf505e97567ad1a31772102c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`69cd5c4aec2ab526789251b4123dfe4afefba2a80648b01a36c356b584f55e3c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`8337c31758ff6e4d871774d05349c4c1c1e84b378b0d0ff9b5c5e21caafd6536`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`1e556b1e8d982bd5be63561970365033e495bc127d0ecd8f9ae022c0cff47a09`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`0563ddd91fe6ddf6a80ae0a1c1f2f0c6aeb891bafb9f3ecf0e6ae63379119d75`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`83fb26b3c35392bb089a0bbd7fe4f09ec83decba223730c38b306f4bedb1efb4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`295be029108b55f6818ea4d5206b18fe7463c739e1c1a02fbc5e48f3190a1ebd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`8051d2ea9da0b3139342b9a96e46b0b67ca1f23b95290ab318705ef1ed1ed38c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`b0bdeefebb5acb867ae7cdc2b22c7f5bb2b07c7dd5c266b2a40e0f36eecb7bf0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`b66977475ec5c11e03732f8efb897fc7e68888e11d5229b0fc4eec39ddb42388`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`2f0c8e3427a3c61dad125d7dcf8e49fb1a034af9c95aee167542a764cdfaa495`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`ab50048553bb51b53d54032cf8f0e71c25395d5af835bf6c028baabe9c1c6136`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`64aeb46b6c0d081ce2dbbc25e7707eaa113ad7b8a80a043cd747cbe7640526fb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`11627cc0262ad6dfd03ea9064724dff2622304b83ffd91c8b0d78a57088878cc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`dc0a9100c6478968fb66ee795039308a92cc16418577eb1640e14ba7929038cd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`5c0c9cf44b856aec9d9bc91abf4068299a5ed08cbd6b532dd2fd5659b1a1959c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`ec2aecb31e14eb2b06db4b621ddaf7796ea8024b71ee0fccbdf08f50ca8560a0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`45c7774f1f8c7886a165c1863451431395e7dc78aa4ae6c76566f40b06c0779c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`22ba8d9c481032ee8be18368aa1a4a16e9870a19afc65ebf9913fec144ede6e8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`1fd9cc07378308ead78cd47db87660d74c472a16515faf942005e6d4139cd6f5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_prepared_validation.txt` (`7a40cf97cef12a9eecbc5dfc9a7627851dd5586323a08ca12fe2436508fe9e02`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_route_exact_task.txt` (`e2d43a78fc4dd6d6f5f0595e7306e0d55d02fd5648faf57a337e2050e61a0989`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/page-028.png` (`ac871ae8d940867a19f2e470aabfa9e4c1e3d1c1f6e48a116920b0623a9b3984`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/page-029.png` (`38ddcc8e4f9afb72079edd7484088dea7c2d299b72df4e78113ca972fa2c816b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/page-030.png` (`ae7d4dfee2a41e3a9c4d65b47cf17f0bffe1704f5cd9b67675d85ba70a190931`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/primary_pages.json` (`098a05f005a26fd2b3874bec55c1d7656752c4a07516f73f4a4292ab1b276634`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`9d1ed6e3b4a3160807b28471d4c7a8f84a7c80990510c42707bc8af4610857af`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`27e078b23c78ea42d05c351858552e8c4d5990018264330fe2d7ebf26b724497`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`473c050a29ba7335593db588871d4815192e43d900b19b91834355e46837e78f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`4f4bafa3013858bde8d80c75ce1ca873677284135c3145e6a7be5d7995dd5715`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`b462c42a7473c88b5d59871206a5d3b9b4c762721227f0478ca4f85deddebc5e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`77d4d855f989e585f28be9de326d0231e16d2f6e4344cfa5a805f9772d8dea96`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`29bc88979091fa8b3711fddb699947e2c5387b42a36488d6967d35c826535047`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`0b8f439fe0095666f6edc34ec542b1e9d2e5b476bc59965e830641beb6401d1d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`726d66e8c0f5c88fd6fb2718349b950d7f555196b463fe92bf5872fdf263f6d3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`4f36f5aa9a26ca2f4f4fe174fbec7e439d2936e8b370497b2b44a4346239a2be`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`f144c51e0e28cd0de302a1f453e69cf6b52cf200f999dbb286e1f39ed769b367`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`01289a04dc0752276cf81e311642d6de362ebfd4fdbd3354d176e6e6163917e0`)
