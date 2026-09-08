# Faithfulness audit: LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `ce0e09fda9c8343140174005e540e227f01c7f34888a43911de48a0869761586`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The supplied declaration bodies resolve every disputed dependency's mathematical meaning: global quantification, exact translation, ordinary derivative existence, and everywhere differentiability. The explicit structures preserve real arithmetic, topology, scalar multiplication, and witness dependence; the reuse ledger establishes provenance rather than source equivalence. The blind translation accurately reflects these declarations. The source renderings establish the formula and propagation claim but do not resolve the solution interpretation of arbitrary profiles. Consequently, source-to-Lean follows for the stated differentiable subcase, while Lean-to-source remains unclear for the complete selected claim. Under the supplied classification policy, undetermined with accepted=false preserves that uncertainty without misclassifying a restricted classical formulation as stronger.

## Implications

- **Lean implies source:** `unclear`. Unfolding D002 gives exactly q(x,t)=profile(x-speed*t), and the unconditional first conjunct gives unchanged propagation for every profile. D001–D003 supply the source PDE everywhere when the profile is everywhere differentiable. This covers the full claim under an implicit classical-admissibility reading, since at t=0 the spatial derivative requirement already forces profile differentiability. However, the printed passage permits any function without specifying that restriction or a generalized solution notion. The theorem makes no nonsmooth PDE assertion. The supplied primary context therefore does not establish that its coverage exhausts the selected source claim.
- **Source implies lean:** `yes`. The source formula implies q(x+speed*t,t)=profile x by real arithmetic. On the everywhere differentiable subcase explicitly assumed in Lean, the same formula gives qx=profile'(x-speed*t) and qt=-speed*profile'(x-speed*t) by ordinary differentiation. These are actual derivative witnesses satisfying qt+speed*qx=0 at every real pair, exactly as D001–D003 require. This consequence uses the formula and the added antecedent directly and does not rely on treating an unqualified arbitrary-profile classical assertion as a valid premise.

## Findings

- **major / unresolved-source-solution-scope:** The target is a precise nonvacuous classical formulation, but acceptance as the complete selected source result requires resolving the source interpretation. Restricted applicability cannot justify faithful-stronger.
- **note / classical-regularity-is-exact-for-target:** The antecedent is not excessive relative to the chosen global classical predicate. This resolves the Lean-side regularity question without establishing that the source chose the same solution class.
- **note / unconditional-propagation-preserved:** The geometric propagation claim is fully represented, including nonsmooth profiles and zero or negative velocities.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `unclear` | `unclear` |
| `C05` | `unclear` | `unclear` |
| `C06` | `pass` | `pass` |
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

- Blind translator covered `77` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `77` dependencies (`34` hash-reused); failing or unclear: `D001, D003, D007, D051`.

## Remaining uncertainties

- The supplied primary passage and adjacent page do not determine whether the arbitrary-profile solution assertion implicitly restricts classical admissibility or includes nonsmooth solutions under an unstated generalized interpretation.
- If a generalized interpretation is intended, its admissible profile class and precise solution notion are unspecified. Arbitrary real functions cannot simply be presumed to define ordinary distributional solutions without further conditions.
- Primary-source inspection used the supplied page renderings. The PDF bytes and supplied provenance hashes were not independently recomputed.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/agent_outputs/adjudicator.json` (`5a0dd3182d1e1c57af0a6ae0d5551051687b22cc01ce56587fcd83b6859fe199`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`a2d20cdc3be675f92df77a36f8fa36fa53f87bff906c74efc1c4d91b5081a65f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`5e15e492f5a2d63826960fd800adb73f27d70616a4aed9661bdb373bdfa6f618`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`b1e009cfc912aae11680ad957c39391980bedf97bd16ec19ff907229e83b63e7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`98cb907d9e64c46bac7a8159862509091ec5d8638a9cf8bcc370bf935fcd1a52`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`50fc97ed86be270039fe3acc7f4ded9599362e78ddf94df42970eefde6c1d14a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/decision.json` (`b23abeb6383d5b4aee51da3ab92bcf113798a63ebed6f17390027cd67681b530`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`ab6c5fb3b7c0eb4c7278aa841f463f1959b8e9f86c221a44ed065fa8012a0e13`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`02847180590c8f07a6e744cc4763b19b62e19e7d734451536cb6c6c59661d085`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`02847180590c8f07a6e744cc4763b19b62e19e7d734451536cb6c6c59661d085`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`ffa73ca5495ba0b154e776bc87dfc1d65f5a0a27f5825297e61d1b7bd3fa30d7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`08f02933bfdc373fcd49f4c2c1191db1f24e76fdc5ecb5c08c4a2a81af830b59`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`8a178677245bb130c76d97826a7b89f406cc41e73b131413b6a4511379ce19c8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`6a0529abb5bf82ea215c508df1bf7fe827c1990a2879dfb934b1d368860fcc94`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`245a3ebd0e4c4d8b0e449cdeb3f33c5682368255eb232cb690cd2f14b9694e3a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/a_events.jsonl` (`bd3bab1c4b92ec929a09d242ffb818678bccf43ed4c4b6d2da01b38a7fc3d154`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/a_final.json` (`5a0dd3182d1e1c57af0a6ae0d5551051687b22cc01ce56587fcd83b6859fe199`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/a_input.txt` (`1eecc1ddf20d388c62d29924d74aef3e61ca92e81e61a15ad43becf616a3eef0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/a_runtime.json` (`c2c905e2beb321fe72c745cd5a7da94e45bf99c5f7670cee64a4f759dd5343c8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/a_stderr.txt` (`092aac2d78cba07084e9874674b562aec741576b917139e8c2755623f09d143a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/a_transport.json` (`5951e6b40672b48daaa96ca3efa3d9b5a4c67ddc4c4da592a4cfcdcdc4ee8d30`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/adjudication_triggers.json` (`d2564474e2841620ed2702c0fbdead268ccab04685395e07393cea19ad0af45f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`3c0cb029165b35650f25b655c4473c48e075cbe769096782065faa03da462931`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`5e15e492f5a2d63826960fd800adb73f27d70616a4aed9661bdb373bdfa6f618`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`b5f20ec4e558b2cb311d891634ddac00b8de84fcc35407356b482847c62ff9e0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`8d8f9b3f48a8be40b6602c32053177689e64a38733a7b1e2143d839618679377`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`c735647321c050db0c266ce8a4a7e755c10aa3d7edd981b85be0c609cf672fe0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`b1501dcf64abee1478709770adf2ef36b7f7006b3ff359d1f47b0f35287c2390`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/c.py` (`e15c16a1d8aed2ec9e5efd544b8e5df5711ea0d4d320698616b5b1026081575e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`02f56afcd161d45ba27c04a138ce8d209cbcdbefeef51c87b84f6abdecff940c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`b1e009cfc912aae11680ad957c39391980bedf97bd16ec19ff907229e83b63e7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`394734b65ba9d254c9187b5373c578258ebbf65c31b78292a95fc09c4cfed53f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`15c6e4d2fbd801b3ccdc9939793ddf4307bd8533827876d480e6daf8d2a655fe`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`d11eb3f9ff9821394ac2197d9b7c3ef84bb6f2648d87ea8135721d1908893983`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`84a414f686ff20cae7b106c1a3d17111a0cbc7c177b5d22211279b6ac29e34b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/page-024.png` (`6a95398093b6adf8fbfd948f95a69c83e6f3175bbb05465e922c595311ee7f92`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/r.py` (`9442063d9de35d688cf36bfd133c5ae20b561cef348dfd57348ef1227fac5522`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`9242991e53eb475f1b78bb663ac972f75dc58e8bb023e80c4700701255302bcc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`98cb907d9e64c46bac7a8159862509091ec5d8638a9cf8bcc370bf935fcd1a52`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`11cb10272ad9992fa92c13bbfe49b702cff105a168bc50d00c9d6623927bb9db`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`bd919dc5237ee25d50ac0d39781aebcc1ee34460ba5433a57094e311d07cc9bf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`ebd761295a073b669fc446bf2231a1f72a1dc723455a84f38e61836c52fa054c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`2e0d3ea9a41de99409be835a1fb2b77ad676015cb748b5e1db1ab9a15ddf156c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`b92f248c22b86f60e550408695dda89ceb2501ed15faafb4798d2c0f9eaf0e40`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`50fc97ed86be270039fe3acc7f4ded9599362e78ddf94df42970eefde6c1d14a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`f84cc8e8bbd2de558911cb0fc6c9d710b99d0d6f854be7c0bcf9528ecac111a6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`33e3d5330ad349c106b6254aacea737d1369e2f17a5a78be6790b930520a98dc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`584470fbef163a979f219489318a4a425b9184e251ba26bdd50740f2b28430ad`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`3b353e9919c63d002a573f3966f05c50d34a6210d39a0daf29d991c614c5485d`)
