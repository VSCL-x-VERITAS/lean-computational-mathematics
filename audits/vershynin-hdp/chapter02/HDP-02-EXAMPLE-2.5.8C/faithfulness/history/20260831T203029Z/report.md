# Faithfulness audit: HDP-02-EXAMPLE-2.5.8C

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `2620b401c7f6619b349ba32385454afe4ba21c35b08f21ec2098b46126c187a3`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The verified source passage states that every bounded real random variable is subgaussian and has ψ₂ norm at most its L∞ norm divided by sqrt(ln 2). The Lean proposition represents boundedness by an arbitrary positive almost-sure bound B and represents the ψ₂ norm by the ENNReal infimum of finite positive scales satisfying the same exponential-square expectation threshold 2. The auxiliary-bound formulation and implicit subgaussian conclusion are mathematically equivalent to the source formulation, including the zero-bound case. Every dependency and every core semantic check is resolved, both implication directions hold, and no adjudication trigger remains.

## Implications

- **Lean implies source:** `yes`. Let X be a bounded real random variable and let M = ||X||∞. If M > 0, instantiate the universally quantified Lean proposition with B = M; if M = 0, instantiate it with every B > 0 and use nonnegativity and arbitrarily small bounds. This yields PsiTwoGauge μ X ≤ M/sqrt(log 2). The bound is finite, so the admissible-scale set cannot be empty because its ENNReal empty infimum is top; hence X has a finite positive scale satisfying E exp(X²/t²) ≤ 2 and is subgaussian in the source sense.
- **Source implies lean:** `yes`. Given the Lean hypotheses, X is a random variable and |X| ≤ B almost everywhere, so ||X||∞ ≤ B. The source result gives ||X||ψ₂ ≤ ||X||∞/sqrt(ln 2) ≤ B/sqrt(ln 2). Under D001-D002 this ψ₂ norm is PsiTwoGauge, and positivity of B and log 2 makes ENNReal.ofReal preserve the exact right side.

## Findings

- **note / equivalent-bound-formulation:** These are harmless equivalent reformulations: universal B recovers the exact L∞ bound, and finite gauge entails existence of an admissible scale and thus subgaussianity.
- **note / parameterized-boundedness-reformulation:** This is logically equivalent because the reconstructed proposition is universal in B: the source implies every such B-bound, and taking positive bounds down to ‖X‖∞ recovers the exact source estimate.
- **note / implicit-subgaussianity-conclusion:** There is no loss of conclusion: a finite bound on the defining infimum forces a finite admissible exponential-square scale and therefore entails sub-gaussianity under Definition 2.5.6.

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

- Blind translator covered `81` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `81` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/agent_outputs/agent_runs.json` (`9fe0670d741d461e8e3814939a97d33ee245078ee02ed8a6c1ff28d22b487d44`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/agent_outputs/batch_source_contract.json` (`494c6f312e574aa6f514d15c6f5cccfd33a38ac45eeaedf5b1a4021def672747`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/agent_outputs/blind_translation.json` (`869f307e735f549d37f3f2d94201b0e203591f7acbe2a86a8f818367f8ae83e3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/agent_outputs/direct_judge.json` (`964fd14a5d8391b04b099a74b18bcf3618b777023252c025e48129890bdbe00e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/agent_outputs/roundtrip_judge.json` (`3fd0982fd5f7ccb43017ece000d063756abf655db4a9e1d8b06a3fede8eaafb2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/agent_outputs/source_contract.json` (`11441e3aadffbb4fc87c461c34a5987c5963d148a574c3e6122c2e573a6fd43e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/decision.json` (`3e6595709ad514d1ac6ee194e4853562866d66a7c87ce6a5ab7ff0caa7df48a1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T085229Z/agent_outputs/agent_runs.json` (`c27b8793dcc8136a0ef0605229524a9a76ad5d1fae49c3159b6887ae7969dafd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T085229Z/agent_outputs/batch_source_contract.json` (`494c6f312e574aa6f514d15c6f5cccfd33a38ac45eeaedf5b1a4021def672747`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T085229Z/agent_outputs/blind_translation.json` (`869f307e735f549d37f3f2d94201b0e203591f7acbe2a86a8f818367f8ae83e3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T085229Z/agent_outputs/direct_judge.json` (`964fd14a5d8391b04b099a74b18bcf3618b777023252c025e48129890bdbe00e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T085229Z/agent_outputs/roundtrip_judge.json` (`3fd0982fd5f7ccb43017ece000d063756abf655db4a9e1d8b06a3fede8eaafb2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T085229Z/agent_outputs/source_contract.json` (`11441e3aadffbb4fc87c461c34a5987c5963d148a574c3e6122c2e573a6fd43e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T085229Z/decision.json` (`4530dd6c65e05c79d2b9d1e8671030526406fff328be5f5c4f63a1c6547127ad`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T085229Z/inputs/batch_source_locator.json` (`59d0c30087c4101335676c811234504bee892a89bef1c027bac4c02006913d37`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T085229Z/inputs/blind_dependency_inventory.json` (`48c234976f2a2d7345d4fd5ee7955ce2cdeb80091294dac56d9526c348203556`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T085229Z/inputs/blind_dossier.md` (`e657454add7b19b6928695cb8d593c37ffb61fabfb6ecd9651afc0a69a241a82`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T085229Z/inputs/blind_review_packet.md` (`e657454add7b19b6928695cb8d593c37ffb61fabfb6ecd9651afc0a69a241a82`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T085229Z/inputs/declaration_dossier.md` (`13f9f138c6ef4f8ee6e243d4f322c6f1e5e0d7e784602c7da5dc9713b53a1d8e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T085229Z/inputs/dependency_inventory.json` (`5566a1927903f5fadd86e12f700ad940e5a5f0910396e1752fa15de0771f2465`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T085229Z/inputs/direct_review_packet.md` (`e8a8d84a512b5bc928872d09bc20e75732b876f87a3749f731772f8deacf2176`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T085229Z/inputs/source_locator.json` (`5d01cf6c859156689274e5636ec341f2f85bd5e684c7a4422ece73f1fd284d57`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T101727Z/agent_outputs/agent_runs.json` (`9fe0670d741d461e8e3814939a97d33ee245078ee02ed8a6c1ff28d22b487d44`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T101727Z/agent_outputs/batch_source_contract.json` (`494c6f312e574aa6f514d15c6f5cccfd33a38ac45eeaedf5b1a4021def672747`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T101727Z/agent_outputs/blind_translation.json` (`869f307e735f549d37f3f2d94201b0e203591f7acbe2a86a8f818367f8ae83e3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T101727Z/agent_outputs/direct_judge.json` (`964fd14a5d8391b04b099a74b18bcf3618b777023252c025e48129890bdbe00e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T101727Z/agent_outputs/roundtrip_judge.json` (`3fd0982fd5f7ccb43017ece000d063756abf655db4a9e1d8b06a3fede8eaafb2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T101727Z/agent_outputs/source_contract.json` (`11441e3aadffbb4fc87c461c34a5987c5963d148a574c3e6122c2e573a6fd43e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T101727Z/decision.json` (`3d1879974cc923f0e4e2396a4ce50e0af15b6e6da23e3f55a263ee5a7e1941a5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T101727Z/inputs/blind_dependency_inventory.json` (`48c234976f2a2d7345d4fd5ee7955ce2cdeb80091294dac56d9526c348203556`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T101727Z/inputs/blind_dossier.md` (`e657454add7b19b6928695cb8d593c37ffb61fabfb6ecd9651afc0a69a241a82`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T101727Z/inputs/blind_review_packet.md` (`e657454add7b19b6928695cb8d593c37ffb61fabfb6ecd9651afc0a69a241a82`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T101727Z/inputs/declaration_dossier.md` (`13f9f138c6ef4f8ee6e243d4f322c6f1e5e0d7e784602c7da5dc9713b53a1d8e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T101727Z/inputs/dependency_inventory.json` (`5566a1927903f5fadd86e12f700ad940e5a5f0910396e1752fa15de0771f2465`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T101727Z/inputs/direct_review_packet.md` (`e8a8d84a512b5bc928872d09bc20e75732b876f87a3749f731772f8deacf2176`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/history/20260831T101727Z/inputs/source_locator.json` (`5d01cf6c859156689274e5636ec341f2f85bd5e684c7a4422ece73f1fd284d57`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/inputs/blind_dependency_inventory.json` (`48c234976f2a2d7345d4fd5ee7955ce2cdeb80091294dac56d9526c348203556`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/inputs/blind_dossier.md` (`e657454add7b19b6928695cb8d593c37ffb61fabfb6ecd9651afc0a69a241a82`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/inputs/blind_review_packet.md` (`e657454add7b19b6928695cb8d593c37ffb61fabfb6ecd9651afc0a69a241a82`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/inputs/declaration_dossier.md` (`482e7fac376a8c2e720334ab5b08f2db104eb03578f27579407fd61b5dd6cc80`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/inputs/dependency_inventory.json` (`5566a1927903f5fadd86e12f700ad940e5a5f0910396e1752fa15de0771f2465`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/inputs/direct_review_packet.md` (`e8a8d84a512b5bc928872d09bc20e75732b876f87a3749f731772f8deacf2176`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8C/faithfulness/inputs/source_locator.json` (`5d01cf6c859156689274e5636ec341f2f85bd5e684c7a4422ece73f1fd284d57`)
