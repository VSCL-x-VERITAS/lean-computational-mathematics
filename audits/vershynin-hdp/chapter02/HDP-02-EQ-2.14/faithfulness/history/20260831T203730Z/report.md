# Faithfulness audit: HDP-02-EQ-2.14

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `2620b401c7f6619b349ba32385454afe4ba21c35b08f21ec2098b46126c187a3`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The pinned PDF, exact locator, complete prepared dossiers, primary Lean definitions, and compiling target agree on the substantive theorem: every measurable real random variable with finite exponential-square psi_2 gauge and every t >= 0 satisfy the same two-sided tail bound with prefactor 2 and quadratic scale. The external dependency uncertainties are fully resolvable: mu is normalized to total mass one and the admissibility integral is the ordinary Bochner expectation because integrability is assumed. Lean fixes the source's unspecified positive absolute constant to c = 1/4. This does not restrict the domain and has positive-gauge examples, so it is genuine nonvacuous conclusion strength. The source's only defect is its unstated norm-zero convention. Lean's totalized value yields the conservative bound by 2, while gauge zero forces X = 0 almost everywhere; thus the completion is valid for t = 0 and t > 0 and does not obstruct Lean-to-source implication. Consequently Lean implies the source, the source does not imply the fixed coefficient, and the correct accepted classification is faithful-stronger.

## Implications

- **Lean implies source:** `yes`. For every positive finite psi_2 gauge, the Lean bound is Equation (2.14) with the uniform positive absolute witness c = 1/4. The source's zero-gauge formula is undefined although it includes the zero random variable; Lean closes that boundary conservatively with a bound by 2, and gauge zero forces X = 0 almost everywhere, so the intended tail assertion is valid there as well.
- **Source implies lean:** `no`. Equation (2.14) states only that some positive absolute constant c exists. That existential assertion does not entail the target's particular uniform coefficient c = 1/4. The zero-gauge completion is conservative in the source-to-Lean direction and is not the reason this implication fails.

## Findings

- **note / fixed-absolute-constant:** This is genuine nonvacuous quantitative strength. Lean implies the source, but the source proposition does not imply the fixed coefficient, so the classification is faithful-stronger rather than faithful-equivalent.
- **note / zero-gauge-boundary-completion:** The formal case is a valid conservative completion: it changes no positive-gauge instance, excludes no source case, and remains true at the reachable degenerate boundary.
- **note / resolved-external-frontier:** The probability and expectation operators match the source; the blind dependency uncertainties do not survive adjudication.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `unclear` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `fail` |
| `C04` | `pass` | `unclear` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `unclear` |
| `C07` | `unclear` | `fail` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `fail` |
| `C10` | `pass` | `fail` |
| `C11` | `unclear` | `unclear` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `80` dependencies (`0` hash-reused); unclear: `D016, D060`.
- Direct judge covered `80` dependencies (`0` hash-reused); failing or unclear: `D001, D007, D009, D030`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/agent_outputs/adjudicator.json` (`c35e0d2e1258dbd640c2c7d4e65b2f4ca560dab83b5362a56130a699670540f4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/agent_outputs/agent_runs.json` (`ca387226ce1c95ee1109ece233e3bdd985678e5bdfbd0ba24f686ae0366809b5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/agent_outputs/batch_source_contract.json` (`833755c2d32f498a67ee7f4fe02fdb5d0d0b22d7cd59402d3b347607f4636ceb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/agent_outputs/blind_translation.json` (`3e39c4d8e1b7fab0b9ca9a2bd103a41e28b66f19ea4925d181e09ea14f2258e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/agent_outputs/direct_judge.json` (`14549df81a395d049664cd479e1e766e9b1a744b4b6e2a3b594e6e090bf543c1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/agent_outputs/roundtrip_judge.json` (`428ea68d435c47ed0e9942fe9f8adeba06db9dcbd3ecf2cbd733d82ebb168224`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/agent_outputs/source_contract.json` (`9dc5d88414a5aa7dbbc0745f5ecdf60c88955d072a281c972e961f66eb7b0fee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/decision.json` (`d7c1397ec423c04b9030ac8b1d77ad6e79f86a0d6ebcd6e072d1d22f418ec75d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T051318Z/agent_outputs/adjudicator.json` (`c35e0d2e1258dbd640c2c7d4e65b2f4ca560dab83b5362a56130a699670540f4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T051318Z/agent_outputs/agent_runs.json` (`d17d679277574df83ed70742f03738f6b9f1a0e9412b50c822256fdf17851c56`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T051318Z/agent_outputs/batch_source_contract.json` (`833755c2d32f498a67ee7f4fe02fdb5d0d0b22d7cd59402d3b347607f4636ceb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T051318Z/agent_outputs/blind_translation.json` (`3e39c4d8e1b7fab0b9ca9a2bd103a41e28b66f19ea4925d181e09ea14f2258e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T051318Z/agent_outputs/direct_judge.json` (`14549df81a395d049664cd479e1e766e9b1a744b4b6e2a3b594e6e090bf543c1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T051318Z/agent_outputs/roundtrip_judge.json` (`428ea68d435c47ed0e9942fe9f8adeba06db9dcbd3ecf2cbd733d82ebb168224`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T051318Z/agent_outputs/source_contract.json` (`9dc5d88414a5aa7dbbc0745f5ecdf60c88955d072a281c972e961f66eb7b0fee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T051318Z/decision.json` (`e7edadf366bbb672b4fe2a0edff5001dbd64e3242ae717ea6daabb4e2bff7591`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T051318Z/inputs/batch_source_locator.json` (`6a576a1a0adf957e20ef78c90b140e6a2a526e6c1e9ee89f23d168ab05af96df`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T051318Z/inputs/blind_dependency_inventory.json` (`e3af34bac3336f06078f99680f08ca5716a194cea66c8c867e9bebbc50c57e47`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T051318Z/inputs/blind_dossier.md` (`984b6d7bee74a05ec105864f51a26e3c2922017a2a594d2e5070d70943d10c58`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T051318Z/inputs/blind_review_packet.md` (`984b6d7bee74a05ec105864f51a26e3c2922017a2a594d2e5070d70943d10c58`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T051318Z/inputs/declaration_dossier.md` (`6ba2fefc18816e9784d996b12eb6baf65cd337d60cf1724ad35f813c89c8701b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T051318Z/inputs/dependency_inventory.json` (`e1298dae2aa22291640213c7e68875ae52896916901ffd6a82f845587a29ca7f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T051318Z/inputs/direct_review_packet.md` (`9eda3f8632a61897109eaf08736a082b3dac2ae11eaf28886dbf2aecef222b04`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T051318Z/inputs/source_locator.json` (`78252e8f023524986d9da30d4aee78ea87f82f6384a413fbec068fec93e9c3a5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T083444Z/agent_outputs/adjudicator.json` (`c35e0d2e1258dbd640c2c7d4e65b2f4ca560dab83b5362a56130a699670540f4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T083444Z/agent_outputs/agent_runs.json` (`d17d679277574df83ed70742f03738f6b9f1a0e9412b50c822256fdf17851c56`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T083444Z/agent_outputs/batch_source_contract.json` (`833755c2d32f498a67ee7f4fe02fdb5d0d0b22d7cd59402d3b347607f4636ceb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T083444Z/agent_outputs/blind_translation.json` (`3e39c4d8e1b7fab0b9ca9a2bd103a41e28b66f19ea4925d181e09ea14f2258e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T083444Z/agent_outputs/direct_judge.json` (`14549df81a395d049664cd479e1e766e9b1a744b4b6e2a3b594e6e090bf543c1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T083444Z/agent_outputs/roundtrip_judge.json` (`428ea68d435c47ed0e9942fe9f8adeba06db9dcbd3ecf2cbd733d82ebb168224`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T083444Z/agent_outputs/source_contract.json` (`9dc5d88414a5aa7dbbc0745f5ecdf60c88955d072a281c972e961f66eb7b0fee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T083444Z/decision.json` (`ffcf9233073327d06b375e90a21fb5dbd0ae6b3697dd5c67292675f3abd4e1fb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T083444Z/inputs/batch_source_locator.json` (`6a576a1a0adf957e20ef78c90b140e6a2a526e6c1e9ee89f23d168ab05af96df`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T083444Z/inputs/blind_dependency_inventory.json` (`e3af34bac3336f06078f99680f08ca5716a194cea66c8c867e9bebbc50c57e47`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T083444Z/inputs/blind_dossier.md` (`984b6d7bee74a05ec105864f51a26e3c2922017a2a594d2e5070d70943d10c58`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T083444Z/inputs/blind_review_packet.md` (`984b6d7bee74a05ec105864f51a26e3c2922017a2a594d2e5070d70943d10c58`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T083444Z/inputs/declaration_dossier.md` (`6ba2fefc18816e9784d996b12eb6baf65cd337d60cf1724ad35f813c89c8701b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T083444Z/inputs/dependency_inventory.json` (`e1298dae2aa22291640213c7e68875ae52896916901ffd6a82f845587a29ca7f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T083444Z/inputs/direct_review_packet.md` (`9eda3f8632a61897109eaf08736a082b3dac2ae11eaf28886dbf2aecef222b04`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T083444Z/inputs/source_locator.json` (`78252e8f023524986d9da30d4aee78ea87f82f6384a413fbec068fec93e9c3a5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T101055Z/agent_outputs/adjudicator.json` (`c35e0d2e1258dbd640c2c7d4e65b2f4ca560dab83b5362a56130a699670540f4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T101055Z/agent_outputs/agent_runs.json` (`ca387226ce1c95ee1109ece233e3bdd985678e5bdfbd0ba24f686ae0366809b5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T101055Z/agent_outputs/batch_source_contract.json` (`833755c2d32f498a67ee7f4fe02fdb5d0d0b22d7cd59402d3b347607f4636ceb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T101055Z/agent_outputs/blind_translation.json` (`3e39c4d8e1b7fab0b9ca9a2bd103a41e28b66f19ea4925d181e09ea14f2258e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T101055Z/agent_outputs/direct_judge.json` (`14549df81a395d049664cd479e1e766e9b1a744b4b6e2a3b594e6e090bf543c1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T101055Z/agent_outputs/roundtrip_judge.json` (`428ea68d435c47ed0e9942fe9f8adeba06db9dcbd3ecf2cbd733d82ebb168224`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T101055Z/agent_outputs/source_contract.json` (`9dc5d88414a5aa7dbbc0745f5ecdf60c88955d072a281c972e961f66eb7b0fee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T101055Z/decision.json` (`bb4f53a7a93446ab9a59c312ec93686169ca89f5688ca885f4bf6ac059c3425d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T101055Z/inputs/blind_dependency_inventory.json` (`e3af34bac3336f06078f99680f08ca5716a194cea66c8c867e9bebbc50c57e47`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T101055Z/inputs/blind_dossier.md` (`984b6d7bee74a05ec105864f51a26e3c2922017a2a594d2e5070d70943d10c58`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T101055Z/inputs/blind_review_packet.md` (`984b6d7bee74a05ec105864f51a26e3c2922017a2a594d2e5070d70943d10c58`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T101055Z/inputs/declaration_dossier.md` (`6ba2fefc18816e9784d996b12eb6baf65cd337d60cf1724ad35f813c89c8701b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T101055Z/inputs/dependency_inventory.json` (`e1298dae2aa22291640213c7e68875ae52896916901ffd6a82f845587a29ca7f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T101055Z/inputs/direct_review_packet.md` (`9eda3f8632a61897109eaf08736a082b3dac2ae11eaf28886dbf2aecef222b04`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/history/20260831T101055Z/inputs/source_locator.json` (`78252e8f023524986d9da30d4aee78ea87f82f6384a413fbec068fec93e9c3a5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/inputs/blind_dependency_inventory.json` (`e3af34bac3336f06078f99680f08ca5716a194cea66c8c867e9bebbc50c57e47`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/inputs/blind_dossier.md` (`984b6d7bee74a05ec105864f51a26e3c2922017a2a594d2e5070d70943d10c58`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/inputs/blind_review_packet.md` (`984b6d7bee74a05ec105864f51a26e3c2922017a2a594d2e5070d70943d10c58`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/inputs/declaration_dossier.md` (`ee5eba33106781dea44fe8c503b4e0befed1da1240114f4a64b1145158dd5647`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/inputs/dependency_inventory.json` (`e1298dae2aa22291640213c7e68875ae52896916901ffd6a82f845587a29ca7f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/inputs/direct_review_packet.md` (`9eda3f8632a61897109eaf08736a082b3dac2ae11eaf28886dbf2aecef222b04`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.14/faithfulness/inputs/source_locator.json` (`78252e8f023524986d9da30d4aee78ea87f82f6384a413fbec068fec93e9c3a5`)
