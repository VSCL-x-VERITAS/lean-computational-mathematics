# Faithfulness audit: HDP-02-EQ-2.13

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `2620b401c7f6619b349ba32385454afe4ba21c35b08f21ec2098b46126c187a3`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

On the source probability-space domain, the local definitions compose to exactly ‖X‖_{ψ₂}=inf{t>0:E exp(X²/t²)≤2}: the ENNReal representation excludes zero and infinity as candidates, explicit integrability correctly protects the real Bochner integral, the threshold is exactly 2, and no centering condition is introduced. Lean additionally quantifies over arbitrary measures. Because this broader domain has satisfiable non-probability instances, Lean implies the source specialization while the source does not entail the full generalized Lean proposition; the result is therefore faithful-stronger.

## Implications

- **Lean implies source:** `yes`. Specializing μ to the source probability measure, IsSubGaussian supplies the source sub-gaussian context. Finite nonzero ENNReal candidates correspond to positive real t, the μ-integral is expectation, and PsiTwoNorm unfolds to the exact infimum with threshold 2.
- **Source implies lean:** `no`. The source definition is confined to random variables in the probability-space setting and does not state the corresponding convention for every arbitrary measure μ. The Lean proposition additionally covers satisfiable non-probability instances, such as a constant-zero function under a measure of total mass 1/2.

## Findings

- **note / measure-domain-generalization:** Lean contains the exact source instance and extends the definitional equality nonvacuously to arbitrary measures; this is genuine broader applicability, not a restriction.
- **note / measure-domain-generalization:** The source case is preserved, while the translated definitional equality additionally applies to satisfiable non-probability-measure cases; therefore the translation is genuinely stronger rather than equivalent.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `fail` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `fail` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `70` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `70` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/agent_outputs/agent_runs.json` (`d5b532553a0f9b794fe822ac209d3e454a06a1be554bb445a990d6cc1fc11e5d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/agent_outputs/blind_translation.json` (`03afcb2489609004449e6644c783c90e8673c2e076c4a1c427761da2726c25c3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/agent_outputs/direct_judge.json` (`7dece2a9107cb5697ccc8db6f15c1001ba290decf9b08b20b2d149897bfa2457`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/agent_outputs/roundtrip_judge.json` (`59f1ef9ba4549f3ac6209e9267e87a6f64fb4f35bec1c04d9824328678fec133`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/agent_outputs/source_contract.json` (`eef71a55510f11ceb4b20ba4a3141ba106723dd54bcc971119df74f37ffc9c48`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/decision.json` (`146e3570bbcb56c5ac68b71a0326ba982510294c65d97acc74ba4c237e4afb34`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260830T153043Z/agent_outputs/agent_runs.json` (`178f2133f3098022ff362fcfb60519a7c5b718d8126b2af702aa39423193f3aa`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260830T153043Z/agent_outputs/blind_translation.json` (`03afcb2489609004449e6644c783c90e8673c2e076c4a1c427761da2726c25c3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260830T153043Z/agent_outputs/direct_judge.json` (`7dece2a9107cb5697ccc8db6f15c1001ba290decf9b08b20b2d149897bfa2457`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260830T153043Z/agent_outputs/roundtrip_judge.json` (`59f1ef9ba4549f3ac6209e9267e87a6f64fb4f35bec1c04d9824328678fec133`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260830T153043Z/agent_outputs/source_contract.json` (`eef71a55510f11ceb4b20ba4a3141ba106723dd54bcc971119df74f37ffc9c48`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260830T153043Z/decision.json` (`09d2866d7216875122f3e95f3db7176962caccc7f0c1be0b00b085b5b771d2c9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260830T153043Z/inputs/blind_dependency_inventory.json` (`5d8ca62a9a0d12cb75eb62faed334c25d33738224f82ed08a6bb679e5e4afd4d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260830T153043Z/inputs/blind_dossier.md` (`88881b71b0833851bf9abd61e0c7a57f823c4c2f192be7053be0375b5016aba9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260830T153043Z/inputs/blind_review_packet.md` (`88881b71b0833851bf9abd61e0c7a57f823c4c2f192be7053be0375b5016aba9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260830T153043Z/inputs/declaration_dossier.md` (`0fe28c4b92f80bb337246baa9c7e97d7fdadfade661d06f2d30e9436385158b3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260830T153043Z/inputs/dependency_inventory.json` (`a2dbcd2e7111fa2dd0bdaecb185f7ffb0906d89d9b7e72ad7fb6cff028990f85`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260830T153043Z/inputs/direct_review_packet.md` (`292f590c7b0a13b06d226b0bc6070ffa1d79045d75b42738e01fc4aece29c27d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260830T153043Z/inputs/source_locator.json` (`c29e238e35dfef734ba7a0edd6f9226951c9fcb1438ba3aa9b0da65c795c1fb4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T083444Z/agent_outputs/agent_runs.json` (`178f2133f3098022ff362fcfb60519a7c5b718d8126b2af702aa39423193f3aa`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T083444Z/agent_outputs/blind_translation.json` (`03afcb2489609004449e6644c783c90e8673c2e076c4a1c427761da2726c25c3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T083444Z/agent_outputs/direct_judge.json` (`7dece2a9107cb5697ccc8db6f15c1001ba290decf9b08b20b2d149897bfa2457`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T083444Z/agent_outputs/roundtrip_judge.json` (`59f1ef9ba4549f3ac6209e9267e87a6f64fb4f35bec1c04d9824328678fec133`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T083444Z/agent_outputs/source_contract.json` (`eef71a55510f11ceb4b20ba4a3141ba106723dd54bcc971119df74f37ffc9c48`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T083444Z/decision.json` (`974e416c29418c72ed29c96a248d79714ab69759b4c9a79f2baf34d7fdc4b20b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T083444Z/inputs/blind_dependency_inventory.json` (`5d8ca62a9a0d12cb75eb62faed334c25d33738224f82ed08a6bb679e5e4afd4d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T083444Z/inputs/blind_dossier.md` (`88881b71b0833851bf9abd61e0c7a57f823c4c2f192be7053be0375b5016aba9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T083444Z/inputs/blind_review_packet.md` (`88881b71b0833851bf9abd61e0c7a57f823c4c2f192be7053be0375b5016aba9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T083444Z/inputs/declaration_dossier.md` (`0fe28c4b92f80bb337246baa9c7e97d7fdadfade661d06f2d30e9436385158b3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T083444Z/inputs/dependency_inventory.json` (`a2dbcd2e7111fa2dd0bdaecb185f7ffb0906d89d9b7e72ad7fb6cff028990f85`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T083444Z/inputs/direct_review_packet.md` (`292f590c7b0a13b06d226b0bc6070ffa1d79045d75b42738e01fc4aece29c27d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T083444Z/inputs/source_locator.json` (`c29e238e35dfef734ba7a0edd6f9226951c9fcb1438ba3aa9b0da65c795c1fb4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T101054Z/agent_outputs/agent_runs.json` (`d5b532553a0f9b794fe822ac209d3e454a06a1be554bb445a990d6cc1fc11e5d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T101054Z/agent_outputs/blind_translation.json` (`03afcb2489609004449e6644c783c90e8673c2e076c4a1c427761da2726c25c3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T101054Z/agent_outputs/direct_judge.json` (`7dece2a9107cb5697ccc8db6f15c1001ba290decf9b08b20b2d149897bfa2457`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T101054Z/agent_outputs/roundtrip_judge.json` (`59f1ef9ba4549f3ac6209e9267e87a6f64fb4f35bec1c04d9824328678fec133`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T101054Z/agent_outputs/source_contract.json` (`eef71a55510f11ceb4b20ba4a3141ba106723dd54bcc971119df74f37ffc9c48`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T101054Z/decision.json` (`a4d0f1c6a88d2d7b720b2a75e4547493de8ae2a04e97e6fbb0b9957743f2e4b0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T101054Z/inputs/blind_dependency_inventory.json` (`5d8ca62a9a0d12cb75eb62faed334c25d33738224f82ed08a6bb679e5e4afd4d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T101054Z/inputs/blind_dossier.md` (`88881b71b0833851bf9abd61e0c7a57f823c4c2f192be7053be0375b5016aba9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T101054Z/inputs/blind_review_packet.md` (`88881b71b0833851bf9abd61e0c7a57f823c4c2f192be7053be0375b5016aba9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T101054Z/inputs/declaration_dossier.md` (`0fe28c4b92f80bb337246baa9c7e97d7fdadfade661d06f2d30e9436385158b3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T101054Z/inputs/dependency_inventory.json` (`a2dbcd2e7111fa2dd0bdaecb185f7ffb0906d89d9b7e72ad7fb6cff028990f85`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T101054Z/inputs/direct_review_packet.md` (`292f590c7b0a13b06d226b0bc6070ffa1d79045d75b42738e01fc4aece29c27d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/history/20260831T101054Z/inputs/source_locator.json` (`c29e238e35dfef734ba7a0edd6f9226951c9fcb1438ba3aa9b0da65c795c1fb4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/inputs/blind_dependency_inventory.json` (`5d8ca62a9a0d12cb75eb62faed334c25d33738224f82ed08a6bb679e5e4afd4d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/inputs/blind_dossier.md` (`88881b71b0833851bf9abd61e0c7a57f823c4c2f192be7053be0375b5016aba9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/inputs/blind_review_packet.md` (`88881b71b0833851bf9abd61e0c7a57f823c4c2f192be7053be0375b5016aba9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/inputs/declaration_dossier.md` (`e3846c06cf083a53f5dc8d9acc8feb5e8d45ca692660223f414935cd63559702`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/inputs/dependency_inventory.json` (`a2dbcd2e7111fa2dd0bdaecb185f7ffb0906d89d9b7e72ad7fb6cff028990f85`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/inputs/direct_review_packet.md` (`292f590c7b0a13b06d226b0bc6070ffa1d79045d75b42738e01fc4aece29c27d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.13/faithfulness/inputs/source_locator.json` (`c29e238e35dfef734ba7a0edd6f9226951c9fcb1438ba3aa9b0da65c795c1fb4`)
