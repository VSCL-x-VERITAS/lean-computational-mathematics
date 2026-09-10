# Faithfulness audit: HDP-02-EX-2.6.4

## Decision

- Classification: `not-faithful-weaker`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `169928e964d01c9f0ad7a0a89720fdbc643dc38e96e71c7c936d2649b31150df`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

Primary evidence fixes the benchmark as the literal Theorem 2.2.6 conclusion with only the exponent coefficient relaxed. Although the displayed Theorem 2.6.3 is two-sided and carries a leading 2, the exercise's instruction to deduce a named theorem from it does not authorize changing that theorem's prefactor. The target otherwise preserves the universal positive constant, independence, measurability, standard almost-sure interval bounds, termwise centering, one-sided non-strict event, positive threshold, and sum-of-squared-widths scale. Its leading 2 makes the conclusion weaker, so Lean does not imply source while source implies Lean. The total-real-division behavior at zero total width is a separate minor semantic mismatch, not a reason to leave the overall judgment undetermined. The target is nonvacuous on ordinary positive-width families, and the empty/all-singleton cases are merely trivial extensions rather than genuine mathematical strength.

## Implications

- **Lean implies source:** `no`. The target gives only P(A_t) <= 2*exp(-c*t^2/V). The selected source asks for the named Theorem 2.2.6 with only its exponent coefficient relaxed, namely P(A_t) <= exp(-c_0*t^2/V). The leading factor cannot be absorbed into a positive universal exponent coefficient uniformly as t^2/V approaches zero, so the target is a strictly weaker bound on the intended nondegenerate domain.
- **Source implies lean:** `yes`. For V>0, the source's no-prefactor estimate with an absolute c_0 immediately implies the target estimate with c=c_0 because exp(-c_0*t^2/V) <= 2*exp(-c_0*t^2/V). Nonempty finite index types are reindexings of source families. The target's added empty-index and V=0 cases are independently trivial for t>0: the centered event is null, while total real division makes the target right-hand side 2.

## Findings

- **major / retained-leading-prefactor:** The target is strictly weaker on the intended nondegenerate domain and does not imply the selected source result.
- **minor / zero-width-division-totalization:** The target chooses a Lean-specific numerical meaning for a source-unstated boundary case; the inequality remains trivially true there because the centered event is null.
- **note / empty-index-extension:** The extra case is independently trivial for t>0 and is not genuine nonvacuous strength, so it does not alter the classification.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `fail` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `unclear` |
| `C05` | `pass` | `unclear` |
| `C06` | `pass` | `pass` |
| `C07` | `fail` | `unclear` |
| `C08` | `pass` | `pass` |
| `C09` | `fail` | `unclear` |
| `C10` | `pass` | `fail` |
| `C11` | `unclear` | `unclear` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `65` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `65` dependencies (`0` hash-reused); failing or unclear: `D001, D037`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/agent_outputs/adjudicator.json` (`9a7aaf96ed27e218e035dd26db9b3001f117c3d4d18f24b4f82a7f3e71bc9413`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/agent_outputs/agent_runs.json` (`b5d8c3bbdda16b3f215d0a24cbf805bc3fe0f8526bd3e0da461e7c6261ed37a6`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/agent_outputs/blind_translation.json` (`e809d5095655a57ed2b2b2ece5c39db4d63ea6f6eeaf95fbedcf8dce13d5a8e9`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/agent_outputs/direct_judge.json` (`622713abb08a2fb6064b87247b796edb84f879c47700fdc2e939f54fcef93ffc`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/agent_outputs/roundtrip_judge.json` (`de6fd15d8035b5b05979725be91effda15c42a12c7c656234b895577fc44b7d8`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/agent_outputs/source_contract.json` (`86d1ac7462e623de238791291a6328034c2347b2b185ab796803d80f5e15dcdc`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/decision.json` (`ebaff088a7f40c6bd7b9c36d1ef1a92ef67836ccbe3c2ef1a0b07043dea282f0`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T145139Z/agent_outputs/agent_runs.json` (`4c536cd457c2bb15f5a5c096948e90fab5f9bf358fd4062c3b40df0692980678`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T145139Z/agent_outputs/blind_translation.json` (`29a2605fca067a750b4774e1548e446b4b8752947b086c5bd8518b7667bb8ac6`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T145139Z/agent_outputs/source_contract.json` (`86cb78722149692e20ae84fcec0b11c3471d63d3318fbef9d930eacef048d100`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T145139Z/inputs/blind_dependency_inventory.json` (`d72864eb83c7abe5258f1f6b0b0a23edd936fc3fb665ce51c21daa9f05ead096`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T145139Z/inputs/blind_dossier.md` (`083fc488f7992079c6a48f7f558a3d427f545609496508276bcbae6e80c16d32`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T145139Z/inputs/blind_review_packet.md` (`083fc488f7992079c6a48f7f558a3d427f545609496508276bcbae6e80c16d32`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T145139Z/inputs/declaration_dossier.md` (`94a034e00413b33fd50da66dd0f8afa1f5347ca7c7c6ae6355c8cfe437b9579f`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T145139Z/inputs/dependency_inventory.json` (`123a8f38bca610c982e09098fcb9b1ddf83e293af6d22f8186948c54692a82ca`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T145139Z/inputs/direct_review_packet.md` (`0fe03e96febb2477b97a8d5d2851c494bedc94181f6f154d29fff15b4444734b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T145139Z/inputs/source_locator.json` (`516759e1550d45ce34f0d0bfd1b0dd7f7e9daec528b95fb904f7cf1d57c16000`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/inputs/blind_dependency_inventory.json` (`6b22f3ccfdfdbc2d1110eb95718d1de6c2a555ebcc0e61fdde34b3f9ef6c22dc`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/inputs/blind_dossier.md` (`30127f9b0865ee7918f93723081350cafd92407670a09cde40c78c3c4ea2229b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/inputs/blind_review_packet.md` (`30127f9b0865ee7918f93723081350cafd92407670a09cde40c78c3c4ea2229b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/inputs/declaration_dossier.md` (`03963c58f124ae6cbbcb46a31a539051bd62995a055956a72e789506234de200`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/inputs/dependency_inventory.json` (`746119688db2e89edb76f9c62c5f710d47c67b9b6b200ad1f78ff8f04d923f77`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/inputs/direct_review_packet.md` (`25d456f5789363fb98daec18b5275c1f8dc2017718665ea16a80f3906c966403`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/inputs/source_locator.json` (`516759e1550d45ce34f0d0bfd1b0dd7f7e9daec528b95fb904f7cf1d57c16000`)
