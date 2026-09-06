# Faithfulness audit: LEV-CH01-EQ-1.7-WAVE-EQUATION

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `15fc6399cbbba0ace0367afc1cccfeaccc73bd4b954917323a3cb5ebdd77e201`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The formal theorem has the same forward-only scope, pressure object, coefficient, sign, and elimination semantics as equation (1.7). Its explicit derivative and mixed-partial premises faithfully expose the source regularity assumptions rather than changing the claim.

## Implications

- **Lean implies source:** `yes`. The solution bundle supplies both first-order acoustics equations, the four HasDerivAt premises identify the needed second and mixed derivatives, and hmixed permits the source elimination. The resulting Lean equality is literally p_tt=c^2*p_xx for c=sqrt(K/rho).
- **Source implies lean:** `yes`. Under the source phrase sufficiently smooth, differentiating the two equations supplies the Lean derivative witnesses and u_xt=u_tx; the printed elimination yields the Lean conclusion. Lean adds only explicit technical hypotheses required to express that source derivation.

## Findings

- **note / regularity-explicitness:** These are the exact technical conditions needed for the printed elimination and do not add a converse or narrower intended physical case.

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
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `not-applicable` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `68` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `68` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/agent_outputs/agent_runs.json` (`66024a51c7d39ada50a3e5f7225d7a678f554261e83350d353a49fbced092bb2`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/agent_outputs/batch_source_contract.json` (`d0fd4bc8d51f4e43a915edd501472b75abc7eb59c4c22ba8049da4ed8c452133`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/agent_outputs/blind_translation.json` (`ca82207ff9a9d584d74d764f5dda19705c9cf0f77489c5f8f4036168923c9222`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/agent_outputs/direct_judge.json` (`719ed0f75631c45d20f303012ca98e8dcfec91c2e3dd43f9f5191991b143ae37`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/agent_outputs/roundtrip_judge.json` (`2de77c7f895aabdedc8e745d787113e70a8bdd423a773b8d3f6957ff05a27c8e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/agent_outputs/source_contract.json` (`13a58ea4196536acf8447cd73adc46067ea8f0c503bfc49be76c8ad6fc45cc93`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/decision.json` (`ed517310c6dcb356264943e0e9c7673879dbd9fb4d734499bc9f9ca736ee2536`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/history/20260901T053012Z/agent_outputs/agent_runs.json` (`668ee882d57ea45dead879db5bef7079961bacdd3441f65d6ed76a8a86165bd5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/history/20260901T053012Z/agent_outputs/batch_source_contract.json` (`d8fdc23104f3a4ce44add59aa66515c36255136ffeac295b5f757fb7be5f1438`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/history/20260901T053012Z/agent_outputs/blind_translation.json` (`f3843053d3ffde9ff4b4c3fb41454e77f7937525367917a2bef974967eaa241f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/history/20260901T053012Z/agent_outputs/direct_judge.json` (`aaa9502f32e82e4f496ccdf9d6a48b77c7b5c2ad6efbe9d880566ce37b099c8e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/history/20260901T053012Z/agent_outputs/source_contract.json` (`75b67f7119bba85f20f9a279948bb5b1b6f0bb54df04cc22a72dafa83ad5314f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/history/20260901T053012Z/inputs/batch_source_locator.json` (`c4ec2035a85a5a30a2333db6a44ef5e187a130ebcd7f86c4c718de479f693893`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/history/20260901T053012Z/inputs/blind_dependency_inventory.json` (`0b714b257becb300b6f0037f90f39032076dfea791b4a9b36d4cde2a049f2707`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/history/20260901T053012Z/inputs/blind_dossier.md` (`ac89db52e6cba8e75f1765d42291ae9817be7cfd6e0f38247fcad23e16cd6e74`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/history/20260901T053012Z/inputs/blind_review_packet.md` (`ac89db52e6cba8e75f1765d42291ae9817be7cfd6e0f38247fcad23e16cd6e74`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/history/20260901T053012Z/inputs/declaration_dossier.md` (`75bfee240ef40c1b01d7518d9c23407d623aebaee97d4e58d8e30d26c99bff24`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/history/20260901T053012Z/inputs/dependency_inventory.json` (`b558bfc2faf6bd15c4fb82143c8f3c23288fe2e51f579f77802ea5b9f5abe9ef`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/history/20260901T053012Z/inputs/direct_review_packet.md` (`313252e04b78a09bb5e2de391ccfa64c47c97123dbcf65d95a5990bd34200128`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/history/20260901T053012Z/inputs/source_locator.json` (`ee7054d2d2bdee640501b3f7f6a03325f08961b1d78b39f9e28eb3dfd3439d91`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/inputs/batch_source_locator.json` (`c4ec2035a85a5a30a2333db6a44ef5e187a130ebcd7f86c4c718de479f693893`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/inputs/blind_dependency_inventory.json` (`0b714b257becb300b6f0037f90f39032076dfea791b4a9b36d4cde2a049f2707`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/inputs/blind_dossier.md` (`ac89db52e6cba8e75f1765d42291ae9817be7cfd6e0f38247fcad23e16cd6e74`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/inputs/blind_review_packet.md` (`ac89db52e6cba8e75f1765d42291ae9817be7cfd6e0f38247fcad23e16cd6e74`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/inputs/declaration_dossier.md` (`75bfee240ef40c1b01d7518d9c23407d623aebaee97d4e58d8e30d26c99bff24`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/inputs/dependency_inventory.json` (`b558bfc2faf6bd15c4fb82143c8f3c23288fe2e51f579f77802ea5b9f5abe9ef`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/inputs/direct_review_packet.md` (`313252e04b78a09bb5e2de391ccfa64c47c97123dbcf65d95a5990bd34200128`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.7-WAVE-EQUATION/faithfulness/inputs/source_locator.json` (`ee7054d2d2bdee640501b3f7f6a03325f08961b1d78b39f9e28eb3dfd3439d91`)
