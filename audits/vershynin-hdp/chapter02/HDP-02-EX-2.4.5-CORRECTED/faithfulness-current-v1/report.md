# Faithfulness audit: HDP-02-EX-2.4.5-CORRECTED

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `0ee47ebde042126ae2fb487255f0fda34eb7ea16f8bc3d084c49ffc37eafd622`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

Relative to the explicitly corrected task, the target faithfully models a varying-parameter Erdős–Rényi graph, the nondegenerate Θ(1) expected-degree regime, existence of a high-degree vertex, the log n/log log n scale, and an eventual probability of at least 0.9. Its only semantic strengthening is replacing the source's unspecified positive Ω multiplier by the universal fixed value 1/128. All dependencies are resolved, the eventual hypotheses are nonvacuous, and small-n subtraction and logarithm behavior is excluded by atTop eventuality.

## Implications

- **Lean implies source:** `yes`. Under the corrected Θ(1) expected-degree hypotheses, the Lean statement supplies the source's required positive Ω witness explicitly as 1/128 and supplies the eventual probability threshold 0.9.
- **Source implies lean:** `no`. The corrected source conclusion only asserts some positive n-independent Ω multiplier. It does not logically guarantee that this multiplier can be chosen as large as 1/128, so it cannot by itself establish the Lean event at that fixed threshold.

## Findings

- **note / fixed-constant-strengthening:** The Lean statement implies the corrected source claim but the source claim does not imply this particular numerical strengthening.
- **note / fixed-hidden-constant-strengthening:** The translation implies the corrected source claim but is strictly stronger; the source claim alone does not entail this particular numerical multiplier.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `fail` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `fail` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `fail` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `58` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `58` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.5-CORRECTED/faithfulness-current-v1/agent_outputs/agent_runs.json` (`6dd33c235bdb5c024b93e7d071aa24124b852477a0393fef89aad59daa29337b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.5-CORRECTED/faithfulness-current-v1/agent_outputs/batch_source_contract.json` (`8c4e5d7816cb2355fa2809fbecd5daedd344f8bf29e70b10331861011c39af22`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.5-CORRECTED/faithfulness-current-v1/agent_outputs/blind_translation.json` (`2b140745a61e7f3b34b3feeb37af633b1e80cc7b3a1eef9c458dcd46805bc55b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.5-CORRECTED/faithfulness-current-v1/agent_outputs/direct_judge.json` (`67c334e75885d767710981de6af6450884e85d55c395e097635fc479265f080d`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.5-CORRECTED/faithfulness-current-v1/agent_outputs/roundtrip_judge.json` (`33705dfc34d05fd013cd90e96b5a5bdeeea622d228d46fa2e67ad778aa8f8f17`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.5-CORRECTED/faithfulness-current-v1/agent_outputs/source_contract.json` (`8c9cf90bf3eba04903918a2057900c950521b0464dda161d832c5eb0b96530b7`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.5-CORRECTED/faithfulness-current-v1/decision.json` (`cf9838c564b793abb5ed2d1970f670e3acfc93699b8eaf02d0e24687751eeb5c`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.5-CORRECTED/faithfulness-current-v1/inputs/batch_source_locator.json` (`60dfbe6f484e0d7fbdc5159b83e99de20f38bdd32973f82ee1c89d7840994df0`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.5-CORRECTED/faithfulness-current-v1/inputs/blind_dependency_inventory.json` (`ed7763e64959d59d1a4c4e572aab23ed3800db4977970114ca94dfed1787d0ea`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.5-CORRECTED/faithfulness-current-v1/inputs/blind_dossier.md` (`b9d63fc31f614ec3251114c96d0208a4540ce757d0f43f546afcb7e8424c4c6a`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.5-CORRECTED/faithfulness-current-v1/inputs/blind_review_packet.md` (`b9d63fc31f614ec3251114c96d0208a4540ce757d0f43f546afcb7e8424c4c6a`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.5-CORRECTED/faithfulness-current-v1/inputs/declaration_dossier.md` (`fd902816d4a269f38b1d07f222053ca68785640b4ef5c2210cb00e8f497d073c`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.5-CORRECTED/faithfulness-current-v1/inputs/dependency_inventory.json` (`c0ed58ce5ed36e16574ff60d5f0aab96a9ef7d28642dcfa1795a346c8cd8c038`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.5-CORRECTED/faithfulness-current-v1/inputs/direct_review_packet.md` (`5c14597556adaf57b3fd85737f1f456d36ba829b9d1ba42888c1df947d85c833`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.5-CORRECTED/faithfulness-current-v1/inputs/source_locator.json` (`a18cae4cf74468da4f1ce440950b65a68872a8015f247a6dc2c27efc6b149f90`)
