# Faithfulness audit: HDP-02-EX-2.8.6

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `75f95d4891e3ba80a9ff155b4501f1e08172d525dd278570ec40a7c39c3fe3c5`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

Primary source and proof-free Lean declaration evidence resolve the blind dependency questions and show that the formal target accurately reconstructs the intended Bernstein deduction in every substantive respect: finite independent centered bounded real random variables, the Exercise 2.8.5 MGF input, every nonnegative threshold, the two-sided event, the sum of second moments, and the exact constants 2, 1/2, and 1/3. Arbitrary finite indexing, explicit analytic side conditions, and the external library frontier do not create a consequential mismatch. The remaining issue is intrinsic to the printed source: it includes t = 0 but leaves the displayed quotient undefined when the variance sum is also zero. Lean makes a definite totalized choice. Because the source passage does not authorize that choice, neither exact implication direction can be certified at the boundary, so the evidence-bound classification is undetermined.

## Implications

- **Lean implies source:** `unclear`. All hypotheses, operators, constants, quantifiers, and the displayed conclusion match after resolving the prepared external dependency frontier. However, the source claims every t >= 0 while leaving its exponent undefined at t = 0 and sum_i E[X_i^2] = 0. Lean defines 0/0 = 0. Without a source convention, exact Lean-to-source implication cannot be certified at that allowed boundary.
- **Source implies lean:** `unclear`. Exercise 2.8.5 supplies D001, and Exercise 2.8.6 yields the identical Lean inequality throughout the nondegenerate domain. The pinned source nevertheless supplies no value for its 0/0 boundary, so it cannot by itself determine the totalized Lean assertion there.

## Findings

- **major / source-boundary-convention:** Both exact implication directions remain unclear, forcing classification undetermined despite agreement on every nondegenerate case.
- **note / displayed-core-match:** No missing conclusion, altered constant, reversed relation, or changed second-moment quantity was found.
- **note / explicit-deduction-input:** The hEx premise is faithful to the exercise's prescribed input and is nonvacuous; it is not the cause of the undetermined result.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `unclear` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `unclear` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `unclear` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `unclear` |
| `C11` | `pass` | `unclear` |
| `C12` | `pass` | `unclear` |

## Dependency coverage

- Blind translator covered `80` dependencies (`0` hash-reused); unclear: `D010, D020, D022, D023, D028, D030, D042, D079`.
- Direct judge covered `80` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

- The pinned source gives no interpretation of the quotient 0/0 when t = 0 and the sum of second moments is zero, whereas Lean's total real division assigns the quotient the value zero.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/agent_outputs/adjudicator.json` (`f9e9bc984a579d4fd46a9f1e177d76b936e196c73cd9f0559f3becd588d5f8d0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/agent_outputs/agent_runs.json` (`8860ed90cc841732dd381478412780ce659446255fcd83b3808374bbed29f8e3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/agent_outputs/blind_translation.json` (`5d49e59652f192f2797783128689bb8864f2e2c19bb583a67ef5161a3398e16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/agent_outputs/direct_judge.json` (`0a3448d5dddc6ab0a1f2ace9cdbe2f922897a10df090b41c3be6a3b4404b3196`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/agent_outputs/roundtrip_judge.json` (`73280f0e18835eff3ebace6fcd60feb29727ca57e171fa083723d18a315c44b6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/agent_outputs/source_contract.json` (`0b31a47c74841e4cbdadaefed7cacf5762b7644d0cc76038caf7c7990c30cd67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/decision.json` (`f6a4514163c531164c8e4a0fb9427181b7192af8f4ac79ae674eb46af8a1e69d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T024636Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T024636Z/inputs/blind_dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T024636Z/inputs/blind_dossier.md` (`e8db84614e12de9753fd80016ff1e464846e5505b998662af2fc00d8e0e1653f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T024636Z/inputs/blind_review_packet.md` (`e8db84614e12de9753fd80016ff1e464846e5505b998662af2fc00d8e0e1653f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T024636Z/inputs/declaration_dossier.md` (`c07453aff2ac0404e8d4da06400c5ea6505672c05a6d3b2273531e231b676900`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T024636Z/inputs/dependency_inventory.json` (`1aff3c66ae31f92e70ff3597718740bfa616a8efffc978336cc1cd1154de2ef2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T024636Z/inputs/direct_review_packet.md` (`46d7719a843a215f6124a41a6193a808c7339e3f21c6104d5760c85d32e90135`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T024636Z/inputs/source_locator.json` (`0ee69034be9afa66c2e3f5734c9acdefbc9266dc2235ae5e677db76857df5713`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T030220Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T030220Z/inputs/blind_dependency_inventory.json` (`b0a53b872d2391e3a8dcf37e7cb4934e369ef542ee060d75f7729f9d2957e755`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T030220Z/inputs/blind_dossier.md` (`b4bf950f828aeb16fd816673d844e481ceb737d4890fb2fb8ed59eb331c0fa94`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T030220Z/inputs/blind_review_packet.md` (`b4bf950f828aeb16fd816673d844e481ceb737d4890fb2fb8ed59eb331c0fa94`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T030220Z/inputs/declaration_dossier.md` (`2a241bce54f419b761826b4e188e1c6ce461f3fe5293a62b2810129c5f2648a7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T030220Z/inputs/dependency_inventory.json` (`4f5597bd03c82debf8b3a384860c1d14d4273c358948ef067aa7f0c43270202e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T030220Z/inputs/direct_review_packet.md` (`b625965acab9f52d927c03990c2da00a7738179f455187fc2e2c7956cc4cb0c5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T030220Z/inputs/source_locator.json` (`0ee69034be9afa66c2e3f5734c9acdefbc9266dc2235ae5e677db76857df5713`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T221507Z/agent_outputs/agent_runs.json` (`4ef5dd0a4f7b7e72bd1dd8c2f19a1a0db313ad1d2d754e2709bdb1a811f84f93`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T221507Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T221507Z/agent_outputs/source_contract.json` (`0b31a47c74841e4cbdadaefed7cacf5762b7644d0cc76038caf7c7990c30cd67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T221507Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T221507Z/inputs/blind_dependency_inventory.json` (`b0a53b872d2391e3a8dcf37e7cb4934e369ef542ee060d75f7729f9d2957e755`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T221507Z/inputs/blind_dossier.md` (`b4bf950f828aeb16fd816673d844e481ceb737d4890fb2fb8ed59eb331c0fa94`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T221507Z/inputs/blind_review_packet.md` (`b4bf950f828aeb16fd816673d844e481ceb737d4890fb2fb8ed59eb331c0fa94`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T221507Z/inputs/declaration_dossier.md` (`2a241bce54f419b761826b4e188e1c6ce461f3fe5293a62b2810129c5f2648a7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T221507Z/inputs/dependency_inventory.json` (`4f5597bd03c82debf8b3a384860c1d14d4273c358948ef067aa7f0c43270202e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T221507Z/inputs/direct_review_packet.md` (`b625965acab9f52d927c03990c2da00a7738179f455187fc2e2c7956cc4cb0c5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T221507Z/inputs/source_locator.json` (`0ee69034be9afa66c2e3f5734c9acdefbc9266dc2235ae5e677db76857df5713`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T230029Z/agent_outputs/agent_runs.json` (`b0b763ca9b045dda3beae897fd6fcfff9e1e1e4f68a03f6ec36638350ad30c60`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T230029Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T230029Z/agent_outputs/source_contract.json` (`0b31a47c74841e4cbdadaefed7cacf5762b7644d0cc76038caf7c7990c30cd67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T230029Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T230029Z/inputs/blind_dependency_inventory.json` (`b0a53b872d2391e3a8dcf37e7cb4934e369ef542ee060d75f7729f9d2957e755`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T230029Z/inputs/blind_dossier.md` (`b4bf950f828aeb16fd816673d844e481ceb737d4890fb2fb8ed59eb331c0fa94`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T230029Z/inputs/blind_review_packet.md` (`b4bf950f828aeb16fd816673d844e481ceb737d4890fb2fb8ed59eb331c0fa94`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T230029Z/inputs/declaration_dossier.md` (`592769f158e23c64908a48d7b46067774f78755f7a0973c1e2faf6a239773418`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T230029Z/inputs/dependency_inventory.json` (`4f5597bd03c82debf8b3a384860c1d14d4273c358948ef067aa7f0c43270202e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T230029Z/inputs/direct_review_packet.md` (`b625965acab9f52d927c03990c2da00a7738179f455187fc2e2c7956cc4cb0c5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260828T230029Z/inputs/source_locator.json` (`0ee69034be9afa66c2e3f5734c9acdefbc9266dc2235ae5e677db76857df5713`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T002848Z/agent_outputs/adjudicator.json` (`f9e9bc984a579d4fd46a9f1e177d76b936e196c73cd9f0559f3becd588d5f8d0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T002848Z/agent_outputs/agent_runs.json` (`e50a6d5c13e3f061c85e17847b3ca1d3579a32be894cec32256e2c61d5cfcbfa`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T002848Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T002848Z/agent_outputs/blind_translation.json` (`5d49e59652f192f2797783128689bb8864f2e2c19bb583a67ef5161a3398e16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T002848Z/agent_outputs/direct_judge.json` (`0a3448d5dddc6ab0a1f2ace9cdbe2f922897a10df090b41c3be6a3b4404b3196`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T002848Z/agent_outputs/roundtrip_judge.json` (`73280f0e18835eff3ebace6fcd60feb29727ca57e171fa083723d18a315c44b6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T002848Z/agent_outputs/source_contract.json` (`0b31a47c74841e4cbdadaefed7cacf5762b7644d0cc76038caf7c7990c30cd67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T002848Z/decision.json` (`b86378bc9d0cbc34189e09baaf9ba83c8453e52fb7e23e02eef468704d176773`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T002848Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T002848Z/inputs/blind_dependency_inventory.json` (`b0a53b872d2391e3a8dcf37e7cb4934e369ef542ee060d75f7729f9d2957e755`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T002848Z/inputs/blind_dossier.md` (`fdd8ee8cf87c2a5ae4c3db4b420558a0d5988ac36049e8788145266ecf439dd8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T002848Z/inputs/blind_review_packet.md` (`fdd8ee8cf87c2a5ae4c3db4b420558a0d5988ac36049e8788145266ecf439dd8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T002848Z/inputs/declaration_dossier.md` (`e4fcab16b918b0ac6f36e314f620676955b72169f89ed50b437d09c3b12285a4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T002848Z/inputs/dependency_inventory.json` (`4f5597bd03c82debf8b3a384860c1d14d4273c358948ef067aa7f0c43270202e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T002848Z/inputs/direct_review_packet.md` (`3ba4ec1f25adb8535b8d3971c64d75998dbe09e3adcb843b8e69d42a686a5f73`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T002848Z/inputs/source_locator.json` (`0ee69034be9afa66c2e3f5734c9acdefbc9266dc2235ae5e677db76857df5713`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T014629Z/agent_outputs/adjudicator.json` (`f9e9bc984a579d4fd46a9f1e177d76b936e196c73cd9f0559f3becd588d5f8d0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T014629Z/agent_outputs/agent_runs.json` (`7c6f3e18ced953f2bd95ce4d106e2ab6f9b6e6a1c1d28f510d0dd43e88f7cb55`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T014629Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T014629Z/agent_outputs/blind_translation.json` (`5d49e59652f192f2797783128689bb8864f2e2c19bb583a67ef5161a3398e16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T014629Z/agent_outputs/direct_judge.json` (`0a3448d5dddc6ab0a1f2ace9cdbe2f922897a10df090b41c3be6a3b4404b3196`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T014629Z/agent_outputs/roundtrip_judge.json` (`73280f0e18835eff3ebace6fcd60feb29727ca57e171fa083723d18a315c44b6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T014629Z/agent_outputs/source_contract.json` (`0b31a47c74841e4cbdadaefed7cacf5762b7644d0cc76038caf7c7990c30cd67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T014629Z/decision.json` (`6f5d49a8facb8d1320ea1f037455a5ec1a8c80628c3a4680bb6be92a46d1e920`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T014629Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T014629Z/inputs/blind_dependency_inventory.json` (`b0a53b872d2391e3a8dcf37e7cb4934e369ef542ee060d75f7729f9d2957e755`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T014629Z/inputs/blind_dossier.md` (`fdd8ee8cf87c2a5ae4c3db4b420558a0d5988ac36049e8788145266ecf439dd8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T014629Z/inputs/blind_review_packet.md` (`fdd8ee8cf87c2a5ae4c3db4b420558a0d5988ac36049e8788145266ecf439dd8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T014629Z/inputs/declaration_dossier.md` (`e4fcab16b918b0ac6f36e314f620676955b72169f89ed50b437d09c3b12285a4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T014629Z/inputs/dependency_inventory.json` (`4f5597bd03c82debf8b3a384860c1d14d4273c358948ef067aa7f0c43270202e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T014629Z/inputs/direct_review_packet.md` (`3ba4ec1f25adb8535b8d3971c64d75998dbe09e3adcb843b8e69d42a686a5f73`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T014629Z/inputs/source_locator.json` (`0ee69034be9afa66c2e3f5734c9acdefbc9266dc2235ae5e677db76857df5713`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T021246Z/agent_outputs/adjudicator.json` (`f9e9bc984a579d4fd46a9f1e177d76b936e196c73cd9f0559f3becd588d5f8d0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T021246Z/agent_outputs/agent_runs.json` (`7c6f3e18ced953f2bd95ce4d106e2ab6f9b6e6a1c1d28f510d0dd43e88f7cb55`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T021246Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T021246Z/agent_outputs/blind_translation.json` (`5d49e59652f192f2797783128689bb8864f2e2c19bb583a67ef5161a3398e16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T021246Z/agent_outputs/direct_judge.json` (`0a3448d5dddc6ab0a1f2ace9cdbe2f922897a10df090b41c3be6a3b4404b3196`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T021246Z/agent_outputs/roundtrip_judge.json` (`73280f0e18835eff3ebace6fcd60feb29727ca57e171fa083723d18a315c44b6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T021246Z/agent_outputs/source_contract.json` (`0b31a47c74841e4cbdadaefed7cacf5762b7644d0cc76038caf7c7990c30cd67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T021246Z/decision.json` (`41da71a0323302f3f004b0f59377c845ac82dc114f2f8732700f3a77b0dce94a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T021246Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T021246Z/inputs/blind_dependency_inventory.json` (`b0a53b872d2391e3a8dcf37e7cb4934e369ef542ee060d75f7729f9d2957e755`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T021246Z/inputs/blind_dossier.md` (`fdd8ee8cf87c2a5ae4c3db4b420558a0d5988ac36049e8788145266ecf439dd8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T021246Z/inputs/blind_review_packet.md` (`fdd8ee8cf87c2a5ae4c3db4b420558a0d5988ac36049e8788145266ecf439dd8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T021246Z/inputs/declaration_dossier.md` (`e4fcab16b918b0ac6f36e314f620676955b72169f89ed50b437d09c3b12285a4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T021246Z/inputs/dependency_inventory.json` (`4f5597bd03c82debf8b3a384860c1d14d4273c358948ef067aa7f0c43270202e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T021246Z/inputs/direct_review_packet.md` (`3ba4ec1f25adb8535b8d3971c64d75998dbe09e3adcb843b8e69d42a686a5f73`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T021246Z/inputs/source_locator.json` (`0ee69034be9afa66c2e3f5734c9acdefbc9266dc2235ae5e677db76857df5713`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T023453Z/agent_outputs/adjudicator.json` (`f9e9bc984a579d4fd46a9f1e177d76b936e196c73cd9f0559f3becd588d5f8d0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T023453Z/agent_outputs/agent_runs.json` (`7c6f3e18ced953f2bd95ce4d106e2ab6f9b6e6a1c1d28f510d0dd43e88f7cb55`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T023453Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T023453Z/agent_outputs/blind_translation.json` (`5d49e59652f192f2797783128689bb8864f2e2c19bb583a67ef5161a3398e16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T023453Z/agent_outputs/direct_judge.json` (`0a3448d5dddc6ab0a1f2ace9cdbe2f922897a10df090b41c3be6a3b4404b3196`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T023453Z/agent_outputs/roundtrip_judge.json` (`73280f0e18835eff3ebace6fcd60feb29727ca57e171fa083723d18a315c44b6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T023453Z/agent_outputs/source_contract.json` (`0b31a47c74841e4cbdadaefed7cacf5762b7644d0cc76038caf7c7990c30cd67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T023453Z/decision.json` (`81c62bd92105b47b3a91560bcdc75e7702be50304b61efa782337ec0476a1115`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T023453Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T023453Z/inputs/blind_dependency_inventory.json` (`b0a53b872d2391e3a8dcf37e7cb4934e369ef542ee060d75f7729f9d2957e755`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T023453Z/inputs/blind_dossier.md` (`fdd8ee8cf87c2a5ae4c3db4b420558a0d5988ac36049e8788145266ecf439dd8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T023453Z/inputs/blind_review_packet.md` (`fdd8ee8cf87c2a5ae4c3db4b420558a0d5988ac36049e8788145266ecf439dd8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T023453Z/inputs/declaration_dossier.md` (`e4fcab16b918b0ac6f36e314f620676955b72169f89ed50b437d09c3b12285a4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T023453Z/inputs/dependency_inventory.json` (`4f5597bd03c82debf8b3a384860c1d14d4273c358948ef067aa7f0c43270202e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T023453Z/inputs/direct_review_packet.md` (`3ba4ec1f25adb8535b8d3971c64d75998dbe09e3adcb843b8e69d42a686a5f73`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T023453Z/inputs/source_locator.json` (`0ee69034be9afa66c2e3f5734c9acdefbc9266dc2235ae5e677db76857df5713`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T031613Z/agent_outputs/adjudicator.json` (`f9e9bc984a579d4fd46a9f1e177d76b936e196c73cd9f0559f3becd588d5f8d0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T031613Z/agent_outputs/agent_runs.json` (`7c6f3e18ced953f2bd95ce4d106e2ab6f9b6e6a1c1d28f510d0dd43e88f7cb55`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T031613Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T031613Z/agent_outputs/blind_translation.json` (`5d49e59652f192f2797783128689bb8864f2e2c19bb583a67ef5161a3398e16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T031613Z/agent_outputs/direct_judge.json` (`0a3448d5dddc6ab0a1f2ace9cdbe2f922897a10df090b41c3be6a3b4404b3196`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T031613Z/agent_outputs/roundtrip_judge.json` (`73280f0e18835eff3ebace6fcd60feb29727ca57e171fa083723d18a315c44b6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T031613Z/agent_outputs/source_contract.json` (`0b31a47c74841e4cbdadaefed7cacf5762b7644d0cc76038caf7c7990c30cd67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T031613Z/decision.json` (`59d7777faf8e5349d6c61c0c5bf268fdf5370e332bb81d271b2f1280c1fcb4af`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T031613Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T031613Z/inputs/blind_dependency_inventory.json` (`b0a53b872d2391e3a8dcf37e7cb4934e369ef542ee060d75f7729f9d2957e755`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T031613Z/inputs/blind_dossier.md` (`fdd8ee8cf87c2a5ae4c3db4b420558a0d5988ac36049e8788145266ecf439dd8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T031613Z/inputs/blind_review_packet.md` (`fdd8ee8cf87c2a5ae4c3db4b420558a0d5988ac36049e8788145266ecf439dd8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T031613Z/inputs/declaration_dossier.md` (`e4fcab16b918b0ac6f36e314f620676955b72169f89ed50b437d09c3b12285a4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T031613Z/inputs/dependency_inventory.json` (`4f5597bd03c82debf8b3a384860c1d14d4273c358948ef067aa7f0c43270202e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T031613Z/inputs/direct_review_packet.md` (`3ba4ec1f25adb8535b8d3971c64d75998dbe09e3adcb843b8e69d42a686a5f73`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260829T031613Z/inputs/source_locator.json` (`0ee69034be9afa66c2e3f5734c9acdefbc9266dc2235ae5e677db76857df5713`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T084828Z/agent_outputs/adjudicator.json` (`f9e9bc984a579d4fd46a9f1e177d76b936e196c73cd9f0559f3becd588d5f8d0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T084828Z/agent_outputs/agent_runs.json` (`7c6f3e18ced953f2bd95ce4d106e2ab6f9b6e6a1c1d28f510d0dd43e88f7cb55`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T084828Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T084828Z/agent_outputs/blind_translation.json` (`5d49e59652f192f2797783128689bb8864f2e2c19bb583a67ef5161a3398e16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T084828Z/agent_outputs/direct_judge.json` (`0a3448d5dddc6ab0a1f2ace9cdbe2f922897a10df090b41c3be6a3b4404b3196`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T084828Z/agent_outputs/roundtrip_judge.json` (`73280f0e18835eff3ebace6fcd60feb29727ca57e171fa083723d18a315c44b6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T084828Z/agent_outputs/source_contract.json` (`0b31a47c74841e4cbdadaefed7cacf5762b7644d0cc76038caf7c7990c30cd67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T084828Z/decision.json` (`971a9a39f34e63dea93c2ccc1a968cb6c3dfc9ae5eee8cc871086a7790a5cbfb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T084828Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T084828Z/inputs/blind_dependency_inventory.json` (`b0a53b872d2391e3a8dcf37e7cb4934e369ef542ee060d75f7729f9d2957e755`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T084828Z/inputs/blind_dossier.md` (`fdd8ee8cf87c2a5ae4c3db4b420558a0d5988ac36049e8788145266ecf439dd8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T084828Z/inputs/blind_review_packet.md` (`fdd8ee8cf87c2a5ae4c3db4b420558a0d5988ac36049e8788145266ecf439dd8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T084828Z/inputs/declaration_dossier.md` (`4518d27b81a3040302c8a67a81d860c14bde2c1dd6c0c349f8c4da8cfbda6017`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T084828Z/inputs/dependency_inventory.json` (`4f5597bd03c82debf8b3a384860c1d14d4273c358948ef067aa7f0c43270202e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T084828Z/inputs/direct_review_packet.md` (`3ba4ec1f25adb8535b8d3971c64d75998dbe09e3adcb843b8e69d42a686a5f73`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T084828Z/inputs/source_locator.json` (`0ee69034be9afa66c2e3f5734c9acdefbc9266dc2235ae5e677db76857df5713`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T101719Z/agent_outputs/adjudicator.json` (`f9e9bc984a579d4fd46a9f1e177d76b936e196c73cd9f0559f3becd588d5f8d0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T101719Z/agent_outputs/agent_runs.json` (`8860ed90cc841732dd381478412780ce659446255fcd83b3808374bbed29f8e3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T101719Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T101719Z/agent_outputs/blind_translation.json` (`5d49e59652f192f2797783128689bb8864f2e2c19bb583a67ef5161a3398e16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T101719Z/agent_outputs/direct_judge.json` (`0a3448d5dddc6ab0a1f2ace9cdbe2f922897a10df090b41c3be6a3b4404b3196`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T101719Z/agent_outputs/roundtrip_judge.json` (`73280f0e18835eff3ebace6fcd60feb29727ca57e171fa083723d18a315c44b6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T101719Z/agent_outputs/source_contract.json` (`0b31a47c74841e4cbdadaefed7cacf5762b7644d0cc76038caf7c7990c30cd67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T101719Z/decision.json` (`528058fcf0f9603dff1957675f2e568511d8340b005cc87c009908f7b7f856ce`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T101719Z/inputs/blind_dependency_inventory.json` (`b0a53b872d2391e3a8dcf37e7cb4934e369ef542ee060d75f7729f9d2957e755`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T101719Z/inputs/blind_dossier.md` (`fdd8ee8cf87c2a5ae4c3db4b420558a0d5988ac36049e8788145266ecf439dd8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T101719Z/inputs/blind_review_packet.md` (`fdd8ee8cf87c2a5ae4c3db4b420558a0d5988ac36049e8788145266ecf439dd8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T101719Z/inputs/declaration_dossier.md` (`72cdd1a156b2e3cc2297559e79b52a9e05af99a3ed4e7dda4723543b0fc9ea24`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T101719Z/inputs/dependency_inventory.json` (`4f5597bd03c82debf8b3a384860c1d14d4273c358948ef067aa7f0c43270202e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T101719Z/inputs/direct_review_packet.md` (`3ba4ec1f25adb8535b8d3971c64d75998dbe09e3adcb843b8e69d42a686a5f73`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T101719Z/inputs/source_locator.json` (`0ee69034be9afa66c2e3f5734c9acdefbc9266dc2235ae5e677db76857df5713`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T203100Z/agent_outputs/adjudicator.json` (`f9e9bc984a579d4fd46a9f1e177d76b936e196c73cd9f0559f3becd588d5f8d0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T203100Z/agent_outputs/agent_runs.json` (`8860ed90cc841732dd381478412780ce659446255fcd83b3808374bbed29f8e3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T203100Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T203100Z/agent_outputs/blind_translation.json` (`5d49e59652f192f2797783128689bb8864f2e2c19bb583a67ef5161a3398e16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T203100Z/agent_outputs/direct_judge.json` (`0a3448d5dddc6ab0a1f2ace9cdbe2f922897a10df090b41c3be6a3b4404b3196`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T203100Z/agent_outputs/roundtrip_judge.json` (`73280f0e18835eff3ebace6fcd60feb29727ca57e171fa083723d18a315c44b6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T203100Z/agent_outputs/source_contract.json` (`0b31a47c74841e4cbdadaefed7cacf5762b7644d0cc76038caf7c7990c30cd67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T203100Z/decision.json` (`42b0df943c77092180805892ef75d3ca717b38ac4fe751a0da86581920827607`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T203100Z/inputs/blind_dependency_inventory.json` (`b0a53b872d2391e3a8dcf37e7cb4934e369ef542ee060d75f7729f9d2957e755`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T203100Z/inputs/blind_dossier.md` (`fdd8ee8cf87c2a5ae4c3db4b420558a0d5988ac36049e8788145266ecf439dd8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T203100Z/inputs/blind_review_packet.md` (`fdd8ee8cf87c2a5ae4c3db4b420558a0d5988ac36049e8788145266ecf439dd8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T203100Z/inputs/declaration_dossier.md` (`5da0a2358143517666412d12e4cbceaab746af21edf2166cdcf3d5dfc508ca04`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T203100Z/inputs/dependency_inventory.json` (`4f5597bd03c82debf8b3a384860c1d14d4273c358948ef067aa7f0c43270202e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T203100Z/inputs/direct_review_packet.md` (`3ba4ec1f25adb8535b8d3971c64d75998dbe09e3adcb843b8e69d42a686a5f73`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/history/20260831T203100Z/inputs/source_locator.json` (`0ee69034be9afa66c2e3f5734c9acdefbc9266dc2235ae5e677db76857df5713`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/inputs/blind_dependency_inventory.json` (`b0a53b872d2391e3a8dcf37e7cb4934e369ef542ee060d75f7729f9d2957e755`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/inputs/blind_dossier.md` (`fdd8ee8cf87c2a5ae4c3db4b420558a0d5988ac36049e8788145266ecf439dd8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/inputs/blind_review_packet.md` (`fdd8ee8cf87c2a5ae4c3db4b420558a0d5988ac36049e8788145266ecf439dd8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/inputs/declaration_dossier.md` (`f872d71653c81756788b998a4333c21d769a65f9b80bdb776d51a4d9ba202669`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/inputs/dependency_inventory.json` (`4f5597bd03c82debf8b3a384860c1d14d4273c358948ef067aa7f0c43270202e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/inputs/direct_review_packet.md` (`3ba4ec1f25adb8535b8d3971c64d75998dbe09e3adcb843b8e69d42a686a5f73`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.6/faithfulness/inputs/source_locator.json` (`0ee69034be9afa66c2e3f5734c9acdefbc9266dc2235ae5e677db76857df5713`)
