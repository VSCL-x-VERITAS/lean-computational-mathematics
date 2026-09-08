# Faithfulness audit: LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `c96e7dc43d76bc4226e0039d012f3a560ebb40dedd3c40e98f0ec442ef0f82e1`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the attached primary-source images and the complete inline declaration evidence establishes an exact coefficient and sound-speed match for the specifically located second-order classification assertion. The source separates this assertion from the preceding derivation; the contract's broader extraction explains the judges' disagreement but does not make that derivation part of the locator's classification claim. On the ordinary physical acoustic domain, both implication directions hold, the discriminant convention is consistent, and the hypotheses are nonvacuous. All dependency effects were reassessed from the supplied evidence rather than inferred from reuse provenance. No tools, target proof, external source, or prior audit files were consulted, and no source or rendering hashes were independently recomputed.

## Implications

- **Lean implies source:** `yes`. For the locator's classification assertion in the inherited physical acoustic context, the principal coefficients of (1.7) are (1, 0, -c^2), where c = sqrt(K/rho). The Lean conclusion states that their discriminant is positive, exactly expressing second-order hyperbolicity for this equation. Positive physical material parameters give the target's premises. This implication is not an assertion that discriminant positivity entails the separate acoustic-system derivation.
- **Source implies lean:** `yes`. Apply the source's classification to positive bulk modulus and density, substitute its definition c = sqrt(K/rho), and normalize (1.7) to p_tt - c^2*p_xx = 0. Under the supplied full mixed-coefficient convention, its hyperbolicity is 0 < 0^2 - 4*1*(-c^2), precisely D001 applied to D002. The discriminant is 4*K/rho > 0.

## Findings

- **minor / source-contract-scope:** The target is accepted for the located classification assertion only. It cannot certify coverage of the broader conjunction extracted in the contract.
- **note / implicit-physical-domain:** These premises are accepted as making inherited physical context precise, not as verbatim source hypotheses or as theorem strengthening.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `fail` |
| `C03` | `pass` | `pass` |
| `C04` | `unclear` | `unclear` |
| `C05` | `unclear` | `fail` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `fail` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `unclear` | `unclear` |
| `C11` | `unclear` | `unclear` |
| `C12` | `pass` | `pass` |
| `N01` | `not-applicable` | `fail` |
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `unclear` | `fail` |

## Dependency coverage

- Blind translator covered `30` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `30` dependencies (`6` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

- The selected pages do not explicitly axiomatize the admissible material parameters. Acceptance uses their ordinary physical acoustic interpretation; it does not establish agreement with an unrestricted or generalized-material parameter domain.
- The supplied source contract includes the neighboring derivation as an additional conclusion, whereas the locator specifically anchors the classification assertion. This decision follows the locator. If the benchmark instead requires the combined derivation-and-classification result, this target is not-faithful-weaker and must not inherit this acceptance.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`b54f3c51aa7669e51c72303d1369245e3e63171c2506c25c6c299cca33951c1c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`d30b7f5e680c317899daa27d65d9fc02b30f1eb135dabe43f561251e173b7ae4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`958d8a3717405e65d9ed3d2df348ea0b0d0bb20035297d27bd6bbb70392cfbb6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`80a18960d5da07038c49d15fcc717c5a24cbb3b3ca034babfaafc8e337d2860a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`51fa8c7d784d601f1861abaa6f5b08e2671c6293c6a8a2353e0122b29bddc3a2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`d226eed74a63211672f1046b713ab936ea0ff08bef79d271e1a4717c4b80ecb5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/decision.json` (`ec1f5ba91a50a7a6f18e3ff7065a9354ca62d628b572560ccadedb307423b439`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`7755f7860f59571bf0e475c562e2cff0c872f0b14c0dba46935a7cbc0add2423`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`bea90ece7e23ccbc8d00cbcc153a31969fba817dddfd5331195fef938c7950d7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`bea90ece7e23ccbc8d00cbcc153a31969fba817dddfd5331195fef938c7950d7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`02493140912e15b3156ce5486fad989b13b7e6140439f1d0835040a851600c12`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`af11bb5cf22fa7365aa710a484e4566c55258a5586e681f2d2dbfd0bcc5a8b1f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`386c05d03678942e2ab47331cefbc6891c47addc62cc973cd2ef6ede9563a9ab`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`47f27e22ef1990123ae1ac9429e236df4cc1866200bc4756883f38cbaf8518a7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`62445013fdd0ddecb0e37563377defe50648753e33c4c7217a6f1185cbd9729c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`bc8b2f0859fe218e6fd87710ee06a503323f1c26725550792f4a1c20cab4129d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`b54f3c51aa7669e51c72303d1369245e3e63171c2506c25c6c299cca33951c1c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`65b995fe29cc15a88b345d0547e4fbff3c03a11706a059ad468e055f084942ef`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`6fd8422659dd77d7adad6969fc6760be0c4ab7e2331f67040623c427bf64e049`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`c51cfcec1f2483602661b727eebfbb753a927f4980df0a64eb2af327c044c460`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`b8aeb744cf323d6b2d8498029d30c6b6cc45c5d9742117711bab9ddbcb380291`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`2528f39d1715e02a870d22848ebf7c5059433ba52f78ebd59e9a45afcdbfe95e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`8173b41d3415f67001e596c5ba960ae12585b631ac8323f6e8b169d5bed586fd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`6c3679b95575fde5cc7251378fda5a0686e42aa477c5233a0f9334999c41d7cd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`958d8a3717405e65d9ed3d2df348ea0b0d0bb20035297d27bd6bbb70392cfbb6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`8631ce6679e4844028dd5eb24f3b02a49bd74c230cc3806ed4d923c551784ff8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`3c3f92bb9bc1a6c0097052cedab2dc91edd6bb918c0c98cde1098f0557db2f27`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`34a7ac0aea461c857847830f7c0de149d4102b5dc9c3ac71aa24bc0ccfb547e9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`866fe1788c8eceb8deabd1451fb4dc7368017b0af81a161d58a142afdc49d162`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`988d6f97df060f8a84fc91994f835bdac54dbdc6ba8918728ad09265f6f7b4c9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`80a18960d5da07038c49d15fcc717c5a24cbb3b3ca034babfaafc8e337d2860a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`85be115ea066a1d180451471d36fb1f7b4eb80d6c11dace630ca67c1ec07a549`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`46dad38286b0d0ada509d6d9989acf56ef281b0a7b30a1acfb14aeb8a3c1252f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`4debd99bfb61324c33db203d0f696f44171b7ce0ad65545abec00780db00f873`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`af6a26529c8f429160ce1f41367ffa708d0170a6f9cc212eeda80ddf49e9cf3a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_prepared_validation.txt` (`b73dc06960b00b6a721824e86c01a31134a1d311ea092cc070e886173fde46cf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_route_exact_task.txt` (`d5bf6b17c10ba27d3f2e7d355b79ff3b02f4fe31902b922ac930c39f301d0a88`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/page-024.png` (`9374c58069ddf2cc64e5aa888141ee9aa41977be7af9f29fd0cff786a5df3b02`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/primary_pages.json` (`f1982bd20dd822197776367b9d0e4defcad4fa4bb8093a3ad0af22dfa93ef213`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`ce663e6b7bb64dab213f7a1dfce489d7644cbbe24e0bb77581f16b936fd27c4a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`51fa8c7d784d601f1861abaa6f5b08e2671c6293c6a8a2353e0122b29bddc3a2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`0775977e9d6cd5710c4f7838e7ef0c1804a380a7667408c45c6c2e4595ec967c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`8bcfc1328feab544bcd60675eccfaceeea53a6a1f067d6ab965679698080238d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`057114422b7db6c70e5563a9c6cfb68f0be9eb3eab4dfdd4b67cce947f489d0e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`7dbfb88cfdab779fd67dcf21e5ff1a401fc3b45da531090ba35da8c2566abd7c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`c0f12b812cd7a5c87d0756a224073b3da5d7509ced6eca4ca1326d096a04370f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`d226eed74a63211672f1046b713ab936ea0ff08bef79d271e1a4717c4b80ecb5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`deb62b8e8acdd450f8b20a99a003be1c4ecf695fab4e80f5aeac43a37308c3d4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`092df8b79e166cd13ef15d0e1d7ddd76acf45cd3c53ce19c27866d7afbf5a151`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`a989fb2460ecbba0433da3d3f5b25571391b322fa9d5a0f048844a2f3dc73ef0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`d8526bd4e4a5963fbe77a412f4b44235fe42f5eacbff5f3477fa8d72a2f41375`)
