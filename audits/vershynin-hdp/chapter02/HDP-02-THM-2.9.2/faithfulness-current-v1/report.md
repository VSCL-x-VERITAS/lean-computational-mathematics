# Faithfulness audit: HDP-02-THM-2.9.2

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `ff84dc4b9df246b1ad185cbd0b0fed2fa9c319098bbd68a895ecb6c949004a13`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The target preserves the finite independent real family, common almost-sure bound, centered upper-tail event, summed variance, exact Bennett transform and every constant in the printed positive-variance formula. Its separate σ² = 0 conclusion is mathematically valid and nonvacuous but not printed, so the accepted classification is faithful-stronger.

## Implications

- **Lean implies source:** `yes`. On σ² > 0, the target gives exactly the source upper-tail inequality with the same family, centering, summed variances, common bound, threshold, exponential and Bennett transform. The extra σ² = 0 conjunct does not weaken that claim.
- **Source implies lean:** `no`. The printed source expression divides by σ² and supplies no defined assertion when σ² = 0, whereas Lean additionally proves that the positive-threshold centered-sum event has probability zero in that case.

## Findings

- **note / zero-variance strengthening:** The target validly extends the theorem to a genuine degenerate case, so source-to-Lean implication fails while Lean-to-source holds.
- **note / explicit well-definedness assumptions:** These clauses clarify the meaningful source domain and do not reduce applicability.
- **note / zero-variance-domain-extension:** This is a valid, nonvacuous extension, making the translated proposition genuinely stronger.
- **note / explicit-source-conventions:** These clauses expose conventional well-definedness conditions and do not consequentially restrict the meaningful theorem.

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

## Dependency coverage

- Blind translator covered `74` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `74` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.9.2/faithfulness-current-v1/agent_outputs/agent_runs.json` (`d535d4c9fc8e5ac4f75a07a8eb1f2a7a97d66ff92263485d1f4c5911ad25a3b9`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.9.2/faithfulness-current-v1/agent_outputs/blind_translation.json` (`1275a3fa17f9bac374e2668fe0ca7edf19b978c34096219d0243c26b62d62f7e`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.9.2/faithfulness-current-v1/agent_outputs/direct_judge.json` (`aae466f057d7df699c1b9220078677f835dd9d3c3d04cdd94dfb7ed331f76388`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.9.2/faithfulness-current-v1/agent_outputs/roundtrip_judge.json` (`c94bb60b0712fa71fbc3bae60d0f418c99ff223f2b83a0dc2c8ed8885309f6b8`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.9.2/faithfulness-current-v1/agent_outputs/source_contract.json` (`f51de80ef7d2773fea1299bc0f6918ee13b3e807a33ace2a4dffc05c72939a6a`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.9.2/faithfulness-current-v1/decision.json` (`743be0f1b9ba1e5146bc7ebd0034289b78fc879f90947dac3565f0503fc505aa`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.9.2/faithfulness-current-v1/history/20260910T221630Z/agent_outputs/source_contract.json` (`2a942886788fa07e5bca58e0154372fe0a11df16312e9e9d0e10bc95b3f2e95e`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.9.2/faithfulness-current-v1/history/20260910T221630Z/inputs/blind_dependency_inventory.json` (`cff82479380a61a4217e3b5c3f451c57972402ee0d73068a05df0d55fa6f1540`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.9.2/faithfulness-current-v1/history/20260910T221630Z/inputs/blind_dossier.md` (`0fc6fe7d412bfe844e85f07c8e7a4c2a122cb6715d1fa53be3d1f730439a6308`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.9.2/faithfulness-current-v1/history/20260910T221630Z/inputs/blind_review_packet.md` (`0fc6fe7d412bfe844e85f07c8e7a4c2a122cb6715d1fa53be3d1f730439a6308`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.9.2/faithfulness-current-v1/history/20260910T221630Z/inputs/declaration_dossier.md` (`0c736ce344c53f4a81d90b03b7693a79374d625214d0f323fa55d062252fac0b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.9.2/faithfulness-current-v1/history/20260910T221630Z/inputs/dependency_inventory.json` (`0aa50accccac612f90f58fe514d7e3d760dd590ff20ab79a319d62754ff4f613`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.9.2/faithfulness-current-v1/history/20260910T221630Z/inputs/direct_review_packet.md` (`6a9a2ffff924a82d3e6bab0a5d7e420d3a648f596f637edf3a1fe67a7d4d45f9`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.9.2/faithfulness-current-v1/history/20260910T221630Z/inputs/source_locator.json` (`a381d8425411ac96eec822122e247896d7d2c57da1ccbe08d8cc3712c5d9a420`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.9.2/faithfulness-current-v1/inputs/blind_dependency_inventory.json` (`1a1a68999db8dd56228d9a7ad8e83b5e33dff4610c39d9ee3f38eee7238bf06e`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.9.2/faithfulness-current-v1/inputs/blind_dossier.md` (`ff323685838127d3ba2fe6971bcc2861da931de790258ac2da62c25e7695d169`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.9.2/faithfulness-current-v1/inputs/blind_review_packet.md` (`ff323685838127d3ba2fe6971bcc2861da931de790258ac2da62c25e7695d169`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.9.2/faithfulness-current-v1/inputs/declaration_dossier.md` (`155e3c456c09c1ff9b0b89b3c02f57da2657d0d843b44482d6eefb1541339a85`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.9.2/faithfulness-current-v1/inputs/dependency_inventory.json` (`f325d8069598bdea763e12d6400b3278a58aaeb6fe8a82ccbb842e77b7d29750`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.9.2/faithfulness-current-v1/inputs/direct_review_packet.md` (`d14c986f07a459b48b43be6c339f7c0bd0d51962e81b09694be8a3bd303d33af`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.9.2/faithfulness-current-v1/inputs/source_locator.json` (`a381d8425411ac96eec822122e247896d7d2c57da1ccbe08d8cc3712c5d9a420`)
