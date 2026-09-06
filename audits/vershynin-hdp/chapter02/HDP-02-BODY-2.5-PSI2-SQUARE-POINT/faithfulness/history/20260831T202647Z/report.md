# Faithfulness audit: HDP-02-BODY-2.5-PSI2-SQUARE-POINT

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `2620b401c7f6619b349ba32385454afe4ba21c35b08f21ec2098b46126c187a3`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The exact source hash matches the task locator. Independent inspection of printed page 27 confirms the threshold-2 infimum definition and the displayed endpoint inequality, but also confirms that no zero-norm exclusion or 0/0 convention is stated. Independent inspection of the Lean declaration evidence resolves every triggered dependency: IsProbabilityMeasure is normalization by mu(univ)=1, ENNReal.toReal sends zero to zero, and the HDiv/DivInvMonoid chain selects total real division with a/0=0. Hence the target's zero-gauge conclusion is the integrable constant-one function with integral 1, while the source boundary remains semantically unspecified. The two propositions agree on every positive-gauge case, the hypotheses are nonvacuous, and the explicit Lean integrability conjunct matches a finite source expectation. Nonetheless, exact full-domain implication in either direction cannot be asserted without choosing a source convention that the primary evidence does not choose. Both verdicts are therefore unclear, making undetermined the only classification consistent with the protocol; the task is not accepted.

## Implications

- **Lean implies source:** `unclear`. When PsiTwoGauge mu X > 0, the target's finite-gauge hypothesis expresses the source sub-gaussian domain and its integrability-plus-integral conclusion is exactly the source expectation bound at the same infimum scale. When the gauge is zero, Lean's total real division makes every numerator divided by the squared zero denominator equal zero, so the integrand is constant one. Printed page 27 neither excludes this case nor defines the displayed 0/0. Because the source proposition is under-specified on a case included by its universal wording, Lean-to-source implication on the full domain is genuinely unclear rather than yes or no.
- **Source implies lean:** `unclear`. For positive psi_2 norm, the source's finite threshold-2 expectation gives the identical Lean integral inequality and the explicit Integrable conjunct, and its sub-gaussian premise provides a finite admissible scale. For zero norm, the source does not specify an exclusion, limiting interpretation, or division convention, so it does not unambiguously entail Lean's particular constant-one totalization. The full-domain implication therefore remains genuinely unclear.

## Findings

- **major / source-zero-gauge-boundary:** Both implication directions are clear on the positive-gauge subdomain but cannot be decided for the source's full stated domain, forcing an undetermined classification.
- **note / dependency-semantics-resolved:** There is no remaining uncertainty about Lean's probability or division semantics; the sole uncertainty belongs to the source convention.
- **note / positive-gauge-equivalence:** No mismatch exists away from the degenerate zero-gauge boundary, and endpoint attainment is asserted by both statements rather than being a statement-level difference.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `unclear` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `unclear` |
| `C05` | `pass` | `pass` |
| `C06` | `unclear` | `unclear` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `unclear` | `unclear` |
| `C12` | `pass` | `unclear` |

## Dependency coverage

- Blind translator covered `69` dependencies (`0` hash-reused); unclear: `D017`.
- Direct judge covered `69` dependencies (`0` hash-reused); failing or unclear: `D005, D008, D009, D035, D049`.

## Remaining uncertainties

- The immutable source does not say whether the normalized-square display excludes psi_2 norm zero, is intended by a limiting convention, or assigns any value to 0/0; therefore its zero-random-variable boundary cannot be compared definitively with Lean's total real division.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/agent_outputs/adjudicator.json` (`2c3f4b63c5c3ce254924738d16c66f87efd4b0423871ebe1f939d39ba1462509`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/agent_outputs/agent_runs.json` (`2d0fb449010833f12f39c3f64dd158de2f5417e291732a639b69883bbea20401`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/agent_outputs/batch_source_contract.json` (`3be12e92a4bbd1a28a7fba9fd2816e85c7c9fd5a40cc34a462d921e5b11926d0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/agent_outputs/blind_translation.json` (`e8d9acb9e290001e64ef68ceed0b3734c106eca7f52de7a891f6e180fcce2f69`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/agent_outputs/direct_judge.json` (`7bcd9976de619f5f784c429962e428a790e5844c4fd8ffe06c1e9202b9351a02`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/agent_outputs/roundtrip_judge.json` (`b4e0df68c3e3dc646b8c3863d4bdaa5530305ded31f086c97e59b0aa54f9d63f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/agent_outputs/source_contract.json` (`37584be0a26a77682047c35f876b9d5df5e8e61f4feea2e4261a8dcf539f0ccb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/decision.json` (`0415d53b1434c180f4cae2124efb3c0f1c3ed3b8042abef9938b93927f2765d9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T051515Z/inputs/batch_source_locator.json` (`ee16d2ae0de617a9f0dda2177e08ae7d448cadff303cc0f1bf0ded0c0b90299b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T051515Z/inputs/blind_dependency_inventory.json` (`c3b41140edc590fe7b1188534188c319d5daf2ae6c4f38bbcb6048e828a25e44`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T051515Z/inputs/blind_dossier.md` (`9864a3687758f9488378b7f9129a6f73660a91bd4626833b471dd5bd4f7ba419`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T051515Z/inputs/blind_review_packet.md` (`9864a3687758f9488378b7f9129a6f73660a91bd4626833b471dd5bd4f7ba419`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T051515Z/inputs/declaration_dossier.md` (`42a90571060592daa1ecc7256b904929ff5f3dc9926c3cfc343b82ab9a41e74b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T051515Z/inputs/dependency_inventory.json` (`b08914ec9961b9072c4f7fbfb5d7ee18a1830dc21d907fad1e8da7c6c7ae8755`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T051515Z/inputs/direct_review_packet.md` (`cb94b637f0e839ea1a07dbbb8f8938e1415181fe142ce8ad83667503255a109f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T051515Z/inputs/source_locator.json` (`0df9045ad2303597eabef20686576bbb58c78f744fab6fbb7b3dd43058914a02`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T083024Z/agent_outputs/adjudicator.json` (`2c3f4b63c5c3ce254924738d16c66f87efd4b0423871ebe1f939d39ba1462509`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T083024Z/agent_outputs/agent_runs.json` (`0ef31ebcc7f4907a598ee84eec67d7cea1bdca37b6518baf728669ce98c2e720`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T083024Z/agent_outputs/batch_source_contract.json` (`3be12e92a4bbd1a28a7fba9fd2816e85c7c9fd5a40cc34a462d921e5b11926d0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T083024Z/agent_outputs/blind_translation.json` (`e8d9acb9e290001e64ef68ceed0b3734c106eca7f52de7a891f6e180fcce2f69`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T083024Z/agent_outputs/direct_judge.json` (`7bcd9976de619f5f784c429962e428a790e5844c4fd8ffe06c1e9202b9351a02`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T083024Z/agent_outputs/roundtrip_judge.json` (`b4e0df68c3e3dc646b8c3863d4bdaa5530305ded31f086c97e59b0aa54f9d63f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T083024Z/agent_outputs/source_contract.json` (`37584be0a26a77682047c35f876b9d5df5e8e61f4feea2e4261a8dcf539f0ccb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T083024Z/decision.json` (`202c59681ec0ae28ca87b5e8618c635305ace47c42573334e338cc30bb83a275`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T083024Z/inputs/batch_source_locator.json` (`b133b000a315709864e467b98383ace5d6b3905d582333c5b25e09597734bca1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T083024Z/inputs/blind_dependency_inventory.json` (`c3b41140edc590fe7b1188534188c319d5daf2ae6c4f38bbcb6048e828a25e44`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T083024Z/inputs/blind_dossier.md` (`9864a3687758f9488378b7f9129a6f73660a91bd4626833b471dd5bd4f7ba419`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T083024Z/inputs/blind_review_packet.md` (`9864a3687758f9488378b7f9129a6f73660a91bd4626833b471dd5bd4f7ba419`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T083024Z/inputs/declaration_dossier.md` (`42a90571060592daa1ecc7256b904929ff5f3dc9926c3cfc343b82ab9a41e74b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T083024Z/inputs/dependency_inventory.json` (`b08914ec9961b9072c4f7fbfb5d7ee18a1830dc21d907fad1e8da7c6c7ae8755`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T083024Z/inputs/direct_review_packet.md` (`cb94b637f0e839ea1a07dbbb8f8938e1415181fe142ce8ad83667503255a109f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T083024Z/inputs/source_locator.json` (`0df9045ad2303597eabef20686576bbb58c78f744fab6fbb7b3dd43058914a02`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T100856Z/agent_outputs/adjudicator.json` (`2c3f4b63c5c3ce254924738d16c66f87efd4b0423871ebe1f939d39ba1462509`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T100856Z/agent_outputs/agent_runs.json` (`2d0fb449010833f12f39c3f64dd158de2f5417e291732a639b69883bbea20401`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T100856Z/agent_outputs/batch_source_contract.json` (`3be12e92a4bbd1a28a7fba9fd2816e85c7c9fd5a40cc34a462d921e5b11926d0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T100856Z/agent_outputs/blind_translation.json` (`e8d9acb9e290001e64ef68ceed0b3734c106eca7f52de7a891f6e180fcce2f69`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T100856Z/agent_outputs/direct_judge.json` (`7bcd9976de619f5f784c429962e428a790e5844c4fd8ffe06c1e9202b9351a02`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T100856Z/agent_outputs/roundtrip_judge.json` (`b4e0df68c3e3dc646b8c3863d4bdaa5530305ded31f086c97e59b0aa54f9d63f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T100856Z/agent_outputs/source_contract.json` (`37584be0a26a77682047c35f876b9d5df5e8e61f4feea2e4261a8dcf539f0ccb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T100856Z/decision.json` (`92064c13d4e336fa396b9862cecfad46ed313d269f3456b918e0cbac396d847d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T100856Z/inputs/blind_dependency_inventory.json` (`c3b41140edc590fe7b1188534188c319d5daf2ae6c4f38bbcb6048e828a25e44`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T100856Z/inputs/blind_dossier.md` (`9864a3687758f9488378b7f9129a6f73660a91bd4626833b471dd5bd4f7ba419`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T100856Z/inputs/blind_review_packet.md` (`9864a3687758f9488378b7f9129a6f73660a91bd4626833b471dd5bd4f7ba419`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T100856Z/inputs/declaration_dossier.md` (`42a90571060592daa1ecc7256b904929ff5f3dc9926c3cfc343b82ab9a41e74b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T100856Z/inputs/dependency_inventory.json` (`b08914ec9961b9072c4f7fbfb5d7ee18a1830dc21d907fad1e8da7c6c7ae8755`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T100856Z/inputs/direct_review_packet.md` (`cb94b637f0e839ea1a07dbbb8f8938e1415181fe142ce8ad83667503255a109f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/history/20260831T100856Z/inputs/source_locator.json` (`0df9045ad2303597eabef20686576bbb58c78f744fab6fbb7b3dd43058914a02`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/inputs/blind_dependency_inventory.json` (`c3b41140edc590fe7b1188534188c319d5daf2ae6c4f38bbcb6048e828a25e44`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/inputs/blind_dossier.md` (`9864a3687758f9488378b7f9129a6f73660a91bd4626833b471dd5bd4f7ba419`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/inputs/blind_review_packet.md` (`9864a3687758f9488378b7f9129a6f73660a91bd4626833b471dd5bd4f7ba419`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/inputs/declaration_dossier.md` (`226346f16337e0a72d130fb6781e2777b7facd7e1d6fb62891fd4fcde2d4613a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/inputs/dependency_inventory.json` (`b08914ec9961b9072c4f7fbfb5d7ee18a1830dc21d907fad1e8da7c6c7ae8755`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/inputs/direct_review_packet.md` (`cb94b637f0e839ea1a07dbbb8f8938e1415181fe142ce8ad83667503255a109f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-SQUARE-POINT/faithfulness/inputs/source_locator.json` (`0df9045ad2303597eabef20686576bbb58c78f744fab6fbb7b3dd43058914a02`)
