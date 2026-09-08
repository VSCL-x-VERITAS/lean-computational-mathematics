# Faithfulness audit: LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `6b5e8fba077a2241005ec6ebdc3fadc06bcec8d181a83c7138a5a8e8724ff2bf`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The attached primary-source pages and the exact proof-free target agree on the selected comparison under the recorded user-adopted interpretation. The target retains arbitrary finite real state dimension and flux, assumes the stipulated conservation solution class, preserves the mass integral and flux signs, places almost-everywhere quantification inside each interval choice, and excludes classical solutionhood through actual spatial nondifferentiability. An independent moving-step example confirms nonvacuity. Every supplied dependency has been interpreted, including the native evidence identifying real volume as Lebesgue measure. The printed-source ambiguities remain explicit qualifications rather than claims about what the book specifies. No unresolved dependency, semantic check, or implication remains within this interpreted scope.

## Implications

- **Lean implies source:** `yes`. Under the recorded user-adopted interpretation, the source's conservation solutions are represented by D002, and classical solutionhood requires spatial state differentiability. For every such solution and spatial discontinuity, the target supplies precisely (1.10)'s mass derivative with first-endpoint minus second-endpoint flux almost everywhere in time for each fixed interval, and excludes spatial differentiability and hence classical solutionhood. Its scalar existential conjunct confirms that this comparison has discontinuous instances. This implication concerns the selected classical-versus-integral paragraph, not the neighboring smooth-data formation or smooth integral-to-differential derivation claims.
- **Source implies lean:** `yes`. Under the recorded user-adopted interpretation and ordinary finite-dimensional real analysis, the selected source comparison yields the intervalwise almost-everywhere mass-rate assertion for the rectangle-conservation solution class. A spatial discontinuity excludes every spatial derivative and Fréchet differentiability; expanding D001 then excludes it for every candidate coefficient field, independently of whether that field is an actual flux Jacobian. The existential scalar case is consistent with the source's scalar transport context and can be realized directly by the moving unit step with identity flux at positive time. Fin m coordinates, currying, and oriented intervals preserve the source objects. This is not an assertion that the printed pages alone specify the adopted temporal or classical-regularity conventions.

## Findings

- **note / interpretation-qualified-acceptance:** Acceptance and both implications are qualified by the recorded user-adopted interpretation with receipt SHA256 b27e7d260e93edcd5408daa8c5d291ba8bfefd9e66a079480ae6b940aa869030. These conventions must not be attributed to the printed source.
- **note / selected-result-scope:** The target represents the selected classical-versus-integral claim. It does not certify either neighboring claim, and its existential conjunct must not be described as a smooth-data shock-formation theorem.
- **note / classical-predicate-distinction:** The negative conclusion is valid for every candidate because no spatial derivative exists. It must not be recast as failure of a weaker predicate that differentiates only temporal state and spatial composed flux.
- **note / interpretation-qualified acceptance:** Acceptance is qualified by the supplied user-adopted interpretation. It does not establish that the printed source itself explicitly specifies these conventions.
- **note / selected-claim scope:** Equivalence applies to the located classical-versus-integral discontinuity claim. The translation would not constitute a complete formalization of every assertion in Section 1.1.2.

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
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `115` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `115` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`5e9ef74d5364700dc489c27215bbf443ba65554a9f751c3d46b9d1f1642faee8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`996148b66f1e5cc4a75ca3776353594372d245624b30803e5ab934a4fc26c150`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`ab78e2ff467797f061621efc4e8e9c2633113e2cebe8cdd1069caa8962bffe23`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`71d47450897f37e3fcbf4c68c7e6ecb89df52c98b1976db4b91c5f8af5b877df`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`2c88b351c531baff65242b876064168d4e45b673ce46619058a1d3bf6dec0ddd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/decision.json` (`42e6f5a80be35b8c8723905f19066fcd31b315323debf4477525b8fa160f0b56`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`5a838d96455b0bb2fe509fa26a9c5487f509881e0add373fad08bdbd8a4caddd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`cb097e412318caf35d38bfb0e15763dd38ef9d9083f99e167726ecd19c13698a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`cb097e412318caf35d38bfb0e15763dd38ef9d9083f99e167726ecd19c13698a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`c1a1e15e79733b0767bf714fc8c4c67125308067b7cdcadbff37f8692dfa8635`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`29a2f31f72612294deae194e6e0db42089bd5c07fc53dfe74167619bcfb7ce94`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`c4659cd94261a6f0bab3438c4eaf6bca55e991d171e8bad552c237a48030338e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`27a41aae2b59eef1f211662cc689def1e4c4ed2bf5a005863d99308fa471a0db`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`466de0bd9ec335aa1ef628433ab7d95f1563e7e83cae73dfda60815e68f56363`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`996148b66f1e5cc4a75ca3776353594372d245624b30803e5ab934a4fc26c150`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`cdeb080213f842cbf4bf171eb42d590213c3fc8379cb918660ba6f7e9db56b54`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`e68a3f84dff56b698cf9d00adeb812397e5329e4e03902ccdd31577db2747ff8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`578a5dac4354853da354f70959d6b4f9c5a339c862a4927e19ae13c4c3e3c85f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`a73fb84069435860404a7cab4a1763d9dd8dead8f9239133530683d5e65cf96a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/blind-preflight.json` (`2fc121ad0b8331665a16116300c62e70783c8ccc6654fb286b54f5c6edabfc65`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/c.py` (`a45b3653a4683e12f4620759c86a586967fcc6d136691473e67b9c02ba9f9344`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`668ed5b674075edaa4190a34ee4b559610925e75c7976eba4a832522a2b5fb9b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`ab78e2ff467797f061621efc4e8e9c2633113e2cebe8cdd1069caa8962bffe23`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`01a1249656746ada0d1955fa11a1c7f3eaec28f152ef447daa9091636ed57cbf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`6250bf8deb8beb9fea38b85e26ac94a9022ee1ac0baa97e89796015347e19015`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`d05ac139a1b51d959b73e53caf87651b59850d92a20f807b05171547d348da90`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`a54ed2b7255d8a2efe84db402e6cb7b7ea1e5b01f4c38a0914c981a17563f099`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/page-026.png` (`de53be1aae881a448dd2718b09830eadd7387124ea339f874ee5f55d49fa2257`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`b23d80176b69db0cebf8fee1fcb4c64ace36777dae21a61097a3090ec29e2ac6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/primary-pages.json` (`0dceb496e84adcbdb23cce4f66c631265ca42856f521fd651115e4ac55515e27`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/q.py` (`902bd45dcaaa7262e23de6f63f1bd7407f0372c82b05e10d45d78d965f98863d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/r.py` (`a1733ffb068317d8748a807a153e6de19e721ca75ccd2773d61e8f4556b56d9d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`209e7c503e136f7f574810655e7d311fd1ac5c08b3ac7017e49725dd36476bdd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`71d47450897f37e3fcbf4c68c7e6ecb89df52c98b1976db4b91c5f8af5b877df`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`5fb606c382eef7a7a0c9eebcc28eb4c47a8faa77357b0aa7497f2a1965d75734`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`66b4423df9f317b2759e55ef099057d52c7b3e370391d55f579b84733361b11f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`d7bfacd35878b4f1ba7f83a9f67c5c833f82db570a5e15105f405b19c3f71ce5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`926c5c475b0c8ad24d84eae39e85fdcf1e172e9fb9b1139102fdd8884d06c473`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`2b273a85673a0ad5d41ad896202f4f04b538d586021316212e4a29489f51763d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`2c88b351c531baff65242b876064168d4e45b673ce46619058a1d3bf6dec0ddd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`aa27b0a5e63750074d0c80c72d97368f7f4096bd900a5c0596ee6d44e6c7a561`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`bd0617ea90a218305d65def12b62e75b6dce76927577563bad2798177a9ba498`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`024efaf03c4a6f00a5c1ae9d6de3acd8407a478227584657f5339f574b1b1eba`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`0eb8aa7aa95361b0c67e4ede014eebc45c850b727707c533bf3525ebf24e9910`)
