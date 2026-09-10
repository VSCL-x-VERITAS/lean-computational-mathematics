# Faithfulness audit: HDP-02-EX-2.3.8

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `e84b786454f172358d48252db8b981945ae67cb4a552074d1f9ed1e56887e5f9`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The round-trip uncertainty resulted solely from its restricted semantic boundary. The full pinned declaration evidence resolves the topology as weak convergence, poissonMeasure as the Poisson law, gaussianReal 0 1 as N(0,1), and Measure.map as pushforward. The NNReal domain covers the full real nonnegative tail, and totalization at zero is asymptotically irrelevant. Both implications therefore hold.

## Implications

- **Lean implies source:** `yes`. The target asserts weak convergence, over all nonnegative real rates tending to infinity, of exactly the standardized Poisson laws to the standard normal law; this is the source's convergence-in-distribution statement.
- **Source implies lean:** `yes`. The source statement is law-invariant, so instantiating it with the canonical Poisson measures and their exact pushforwards gives the target Tendsto proposition.

## Findings

No findings were recorded.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `unclear` |
| `C05` | `pass` | `unclear` |
| `C06` | `pass` | `unclear` |
| `C07` | `pass` | `unclear` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `51` dependencies (`0` hash-reused); unclear: `D012, D015, D035, D036, D046, D051`.
- Direct judge covered `51` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.3.8/faithfulness-current-v5/agent_outputs/adjudicator.json` (`fab09624fc337efcf7b17cb08182473f8fa84b8060e0aefd2a3eeefe54e1b085`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.3.8/faithfulness-current-v5/agent_outputs/agent_runs.json` (`894fca1cbd0d80b897a071ef1ce61c4018eae4cf316247b84fe45fd57916d36d`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.3.8/faithfulness-current-v5/agent_outputs/blind_translation.json` (`17e0b13b2a7220cf5b2342124e8e2a4e5327b42ccfb3c6e05c1aaa137ed2041c`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.3.8/faithfulness-current-v5/agent_outputs/direct_judge.json` (`32c96424769bbd8d1e371410bb4db0cdaa8a61ae85536d3feb04515b3ffae017`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.3.8/faithfulness-current-v5/agent_outputs/roundtrip_judge.json` (`79156815deb89e5d2397de88c3edd3d6c86379b52feeebfec16f70539c78b214`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.3.8/faithfulness-current-v5/agent_outputs/source_contract.json` (`9f92ebd7891498b0d6b8a2f1e63230834c22c4665da4e8b23ab7e18323f7801c`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.3.8/faithfulness-current-v5/decision.json` (`9f103243d470c9ec697bae48c71876f4929f30cd97dc8911026f7e597f440ee9`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.3.8/faithfulness-current-v5/inputs/blind_dependency_inventory.json` (`7c60099c447de340c868f4e7cf491616233d866e6e13177e40cb67ba573e1ee5`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.3.8/faithfulness-current-v5/inputs/blind_dossier.md` (`9b42372eca4a68b1d01f1bae18835e02fd1f357af30e41dc3952b962efee4e77`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.3.8/faithfulness-current-v5/inputs/blind_review_packet.md` (`9b42372eca4a68b1d01f1bae18835e02fd1f357af30e41dc3952b962efee4e77`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.3.8/faithfulness-current-v5/inputs/declaration_dossier.md` (`d2400f323a23af736fcf55b1320537352da55ba376e5d9d0970a1c235ab37e5d`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.3.8/faithfulness-current-v5/inputs/dependency_inventory.json` (`df17a7fff59da41078be82c4fd5b3d5fa388281935e79568d7e0948747f2923f`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.3.8/faithfulness-current-v5/inputs/direct_review_packet.md` (`c6ffcd4eca52adcf73f7223a55d85885ae7825aeda474782ee7ae6dd2e30be5e`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.3.8/faithfulness-current-v5/inputs/source_locator.json` (`dba8839d088a1afdd35f999b25d29e4ef0f49176372f7b23e37cdbef1ec25c11`)
