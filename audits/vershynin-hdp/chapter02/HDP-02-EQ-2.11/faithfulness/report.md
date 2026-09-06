# Faithfulness audit: HDP-02-EQ-2.11

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `a349af15a85f93cd9b9e459f90e8ce97e63ef5fa9caf31c4baed85a8839e8d08`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

Primary dependency evidence resolves the round-trip judge's only operator ambiguity: Mathlib's gaussianReal is parameterized by mean and variance, so gaussianReal 0 1 is exactly the standard normal law. The source's Gamma formula supports real exponents p >= 1, and the target's integral, absolute value, real powers, reciprocal, and square root express the same L^p quantity. Lean requires a single positive constant for every real p >= 1, whereas the selected numbered equation states only an eventual big-O upper bound. This is genuine nonvacuous strength, not reduced applicability. Therefore Lean implies the source, the source does not imply Lean, the classification is faithful-stronger, and the task is accepted.

## Implications

- **Lean implies source:** `yes`. The target gives one positive constant for the standard-normal L^p norm for every real p >= 1, so the same constant proves the eventual O(sqrt(p)) statement in (2.11).
- **Source implies lean:** `no`. The selected numbered source statement is only eventual and does not assert that one constant works on every real p in the additional finite range from 1 up to an unspecified asymptotic threshold.

## Findings

- **note / global-versus-eventual-bound:** The target is an accepted, nonvacuous strengthening: it implies the source and adds finite-range obligations without adding hypotheses or narrowing applicability.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `unclear` |
| `C03` | `fail` | `fail` |
| `C04` | `pass` | `unclear` |
| `C05` | `pass` | `unclear` |
| `C06` | `pass` | `unclear` |
| `C07` | `fail` | `fail` |
| `C08` | `pass` | `unclear` |
| `C09` | `pass` | `fail` |
| `C10` | `pass` | `unclear` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `36` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `36` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/agent_outputs/adjudicator.json` (`b341190025772987875804673bb02ea49d1d71349ca0a40cff6da10adcfdd9bd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/agent_outputs/agent_runs.json` (`7c098b84a3b9e11a416c46b32bbad57ed173b032f1ea68ccd22fe50b62fe1574`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/agent_outputs/blind_translation.json` (`5f838c4c31bc69a31bf1847c53d2ccf3bf398d574497e5d431d48fadb48e9c47`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/agent_outputs/direct_judge.json` (`8bdb0be40ca33f876cf27651feaed36de1c95a3e15d5f681e22e20798425b071`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/agent_outputs/roundtrip_judge.json` (`550c4c5028a05829e0f83bc343fd4b3a554f2f9b3f1d1cc7a7e6945afc2eb6c2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/agent_outputs/source_contract.json` (`e65fc982e9335b90d02c32d423f16e80c3882243a0905083399e3faf8c8e8635`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/decision.json` (`f354068af810f529ed093db9122fea098f9d9b6f428cda0717969a6644c2f71c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T124437Z/agent_outputs/adjudicator.json` (`b341190025772987875804673bb02ea49d1d71349ca0a40cff6da10adcfdd9bd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T124437Z/agent_outputs/agent_runs.json` (`1d00fa86a742222dc6ef88b2eb62f41c83af1fd7a425d3e40c45467dba59c001`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T124437Z/agent_outputs/blind_translation.json` (`5f838c4c31bc69a31bf1847c53d2ccf3bf398d574497e5d431d48fadb48e9c47`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T124437Z/agent_outputs/direct_judge.json` (`8bdb0be40ca33f876cf27651feaed36de1c95a3e15d5f681e22e20798425b071`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T124437Z/agent_outputs/roundtrip_judge.json` (`550c4c5028a05829e0f83bc343fd4b3a554f2f9b3f1d1cc7a7e6945afc2eb6c2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T124437Z/agent_outputs/source_contract.json` (`e65fc982e9335b90d02c32d423f16e80c3882243a0905083399e3faf8c8e8635`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T124437Z/decision.json` (`8ee17fb5dfa043ed6ab982c196dcce76a8a82e4a547260dac42dae42242dd2d0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T124437Z/inputs/blind_dependency_inventory.json` (`5a478146206a74efcd7f4255078082ecb7c079dd657722eff7d2b5d3ad81983b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T124437Z/inputs/blind_dossier.md` (`760e86b526f9b8a306a366e5d8b2ba84c676c172632fb8056b62f953708b1214`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T124437Z/inputs/blind_review_packet.md` (`760e86b526f9b8a306a366e5d8b2ba84c676c172632fb8056b62f953708b1214`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T124437Z/inputs/declaration_dossier.md` (`256df8ed5d82e61ef920c53a5e17aeff2b01735ef25796676f8bf04a7258bf5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T124437Z/inputs/dependency_inventory.json` (`5a478146206a74efcd7f4255078082ecb7c079dd657722eff7d2b5d3ad81983b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T124437Z/inputs/direct_review_packet.md` (`906eff8ed996b82953c23f335e68e5458c771689b63b8a4735b81a09115b16f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T124437Z/inputs/source_locator.json` (`4244aefdb4adc43e14fe4a7be5a2ad7682de5a0b4e94b0c39a61b11745c0738f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T132015Z/agent_outputs/adjudicator.json` (`b341190025772987875804673bb02ea49d1d71349ca0a40cff6da10adcfdd9bd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T132015Z/agent_outputs/agent_runs.json` (`1d00fa86a742222dc6ef88b2eb62f41c83af1fd7a425d3e40c45467dba59c001`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T132015Z/agent_outputs/blind_translation.json` (`5f838c4c31bc69a31bf1847c53d2ccf3bf398d574497e5d431d48fadb48e9c47`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T132015Z/agent_outputs/direct_judge.json` (`8bdb0be40ca33f876cf27651feaed36de1c95a3e15d5f681e22e20798425b071`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T132015Z/agent_outputs/roundtrip_judge.json` (`550c4c5028a05829e0f83bc343fd4b3a554f2f9b3f1d1cc7a7e6945afc2eb6c2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T132015Z/agent_outputs/source_contract.json` (`e65fc982e9335b90d02c32d423f16e80c3882243a0905083399e3faf8c8e8635`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T132015Z/decision.json` (`a5bf7b0e11278b822fdf257b656be00c647dc95e3dbced7fbdc066e2e693e613`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T132015Z/inputs/blind_dependency_inventory.json` (`5a478146206a74efcd7f4255078082ecb7c079dd657722eff7d2b5d3ad81983b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T132015Z/inputs/blind_dossier.md` (`760e86b526f9b8a306a366e5d8b2ba84c676c172632fb8056b62f953708b1214`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T132015Z/inputs/blind_review_packet.md` (`760e86b526f9b8a306a366e5d8b2ba84c676c172632fb8056b62f953708b1214`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T132015Z/inputs/declaration_dossier.md` (`256df8ed5d82e61ef920c53a5e17aeff2b01735ef25796676f8bf04a7258bf5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T132015Z/inputs/dependency_inventory.json` (`5a478146206a74efcd7f4255078082ecb7c079dd657722eff7d2b5d3ad81983b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T132015Z/inputs/direct_review_packet.md` (`906eff8ed996b82953c23f335e68e5458c771689b63b8a4735b81a09115b16f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T132015Z/inputs/source_locator.json` (`4244aefdb4adc43e14fe4a7be5a2ad7682de5a0b4e94b0c39a61b11745c0738f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T145344Z/agent_outputs/adjudicator.json` (`b341190025772987875804673bb02ea49d1d71349ca0a40cff6da10adcfdd9bd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T145344Z/agent_outputs/agent_runs.json` (`1d00fa86a742222dc6ef88b2eb62f41c83af1fd7a425d3e40c45467dba59c001`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T145344Z/agent_outputs/blind_translation.json` (`5f838c4c31bc69a31bf1847c53d2ccf3bf398d574497e5d431d48fadb48e9c47`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T145344Z/agent_outputs/direct_judge.json` (`8bdb0be40ca33f876cf27651feaed36de1c95a3e15d5f681e22e20798425b071`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T145344Z/agent_outputs/roundtrip_judge.json` (`550c4c5028a05829e0f83bc343fd4b3a554f2f9b3f1d1cc7a7e6945afc2eb6c2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T145344Z/agent_outputs/source_contract.json` (`e65fc982e9335b90d02c32d423f16e80c3882243a0905083399e3faf8c8e8635`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T145344Z/decision.json` (`d5c35c9f78e556198883e57e1bcc41fcb1b197c333027655c565b46a6b38a14d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T145344Z/inputs/blind_dependency_inventory.json` (`5a478146206a74efcd7f4255078082ecb7c079dd657722eff7d2b5d3ad81983b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T145344Z/inputs/blind_dossier.md` (`760e86b526f9b8a306a366e5d8b2ba84c676c172632fb8056b62f953708b1214`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T145344Z/inputs/blind_review_packet.md` (`760e86b526f9b8a306a366e5d8b2ba84c676c172632fb8056b62f953708b1214`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T145344Z/inputs/declaration_dossier.md` (`256df8ed5d82e61ef920c53a5e17aeff2b01735ef25796676f8bf04a7258bf5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T145344Z/inputs/dependency_inventory.json` (`5a478146206a74efcd7f4255078082ecb7c079dd657722eff7d2b5d3ad81983b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T145344Z/inputs/direct_review_packet.md` (`906eff8ed996b82953c23f335e68e5458c771689b63b8a4735b81a09115b16f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T145344Z/inputs/source_locator.json` (`4244aefdb4adc43e14fe4a7be5a2ad7682de5a0b4e94b0c39a61b11745c0738f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T153008Z/agent_outputs/adjudicator.json` (`b341190025772987875804673bb02ea49d1d71349ca0a40cff6da10adcfdd9bd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T153008Z/agent_outputs/agent_runs.json` (`1d00fa86a742222dc6ef88b2eb62f41c83af1fd7a425d3e40c45467dba59c001`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T153008Z/agent_outputs/blind_translation.json` (`5f838c4c31bc69a31bf1847c53d2ccf3bf398d574497e5d431d48fadb48e9c47`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T153008Z/agent_outputs/direct_judge.json` (`8bdb0be40ca33f876cf27651feaed36de1c95a3e15d5f681e22e20798425b071`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T153008Z/agent_outputs/roundtrip_judge.json` (`550c4c5028a05829e0f83bc343fd4b3a554f2f9b3f1d1cc7a7e6945afc2eb6c2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T153008Z/agent_outputs/source_contract.json` (`e65fc982e9335b90d02c32d423f16e80c3882243a0905083399e3faf8c8e8635`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T153008Z/decision.json` (`66acefa967c49cabdcf739c384156289cfb692cf9867b41add0959ad7030a4c0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T153008Z/inputs/blind_dependency_inventory.json` (`5a478146206a74efcd7f4255078082ecb7c079dd657722eff7d2b5d3ad81983b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T153008Z/inputs/blind_dossier.md` (`760e86b526f9b8a306a366e5d8b2ba84c676c172632fb8056b62f953708b1214`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T153008Z/inputs/blind_review_packet.md` (`760e86b526f9b8a306a366e5d8b2ba84c676c172632fb8056b62f953708b1214`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T153008Z/inputs/declaration_dossier.md` (`256df8ed5d82e61ef920c53a5e17aeff2b01735ef25796676f8bf04a7258bf5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T153008Z/inputs/dependency_inventory.json` (`5a478146206a74efcd7f4255078082ecb7c079dd657722eff7d2b5d3ad81983b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T153008Z/inputs/direct_review_packet.md` (`906eff8ed996b82953c23f335e68e5458c771689b63b8a4735b81a09115b16f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260830T153008Z/inputs/source_locator.json` (`4244aefdb4adc43e14fe4a7be5a2ad7682de5a0b4e94b0c39a61b11745c0738f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T083249Z/agent_outputs/adjudicator.json` (`b341190025772987875804673bb02ea49d1d71349ca0a40cff6da10adcfdd9bd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T083249Z/agent_outputs/agent_runs.json` (`1d00fa86a742222dc6ef88b2eb62f41c83af1fd7a425d3e40c45467dba59c001`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T083249Z/agent_outputs/blind_translation.json` (`5f838c4c31bc69a31bf1847c53d2ccf3bf398d574497e5d431d48fadb48e9c47`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T083249Z/agent_outputs/direct_judge.json` (`8bdb0be40ca33f876cf27651feaed36de1c95a3e15d5f681e22e20798425b071`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T083249Z/agent_outputs/roundtrip_judge.json` (`550c4c5028a05829e0f83bc343fd4b3a554f2f9b3f1d1cc7a7e6945afc2eb6c2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T083249Z/agent_outputs/source_contract.json` (`e65fc982e9335b90d02c32d423f16e80c3882243a0905083399e3faf8c8e8635`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T083249Z/decision.json` (`3ce0c60f8468bda21fc1096980508e5555c12bac436dc8e085dad8b6f9bc4d9f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T083249Z/inputs/blind_dependency_inventory.json` (`5a478146206a74efcd7f4255078082ecb7c079dd657722eff7d2b5d3ad81983b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T083249Z/inputs/blind_dossier.md` (`760e86b526f9b8a306a366e5d8b2ba84c676c172632fb8056b62f953708b1214`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T083249Z/inputs/blind_review_packet.md` (`760e86b526f9b8a306a366e5d8b2ba84c676c172632fb8056b62f953708b1214`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T083249Z/inputs/declaration_dossier.md` (`256df8ed5d82e61ef920c53a5e17aeff2b01735ef25796676f8bf04a7258bf5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T083249Z/inputs/dependency_inventory.json` (`5a478146206a74efcd7f4255078082ecb7c079dd657722eff7d2b5d3ad81983b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T083249Z/inputs/direct_review_packet.md` (`906eff8ed996b82953c23f335e68e5458c771689b63b8a4735b81a09115b16f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T083249Z/inputs/source_locator.json` (`4244aefdb4adc43e14fe4a7be5a2ad7682de5a0b4e94b0c39a61b11745c0738f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T101033Z/agent_outputs/adjudicator.json` (`b341190025772987875804673bb02ea49d1d71349ca0a40cff6da10adcfdd9bd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T101033Z/agent_outputs/agent_runs.json` (`7c098b84a3b9e11a416c46b32bbad57ed173b032f1ea68ccd22fe50b62fe1574`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T101033Z/agent_outputs/blind_translation.json` (`5f838c4c31bc69a31bf1847c53d2ccf3bf398d574497e5d431d48fadb48e9c47`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T101033Z/agent_outputs/direct_judge.json` (`8bdb0be40ca33f876cf27651feaed36de1c95a3e15d5f681e22e20798425b071`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T101033Z/agent_outputs/roundtrip_judge.json` (`550c4c5028a05829e0f83bc343fd4b3a554f2f9b3f1d1cc7a7e6945afc2eb6c2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T101033Z/agent_outputs/source_contract.json` (`e65fc982e9335b90d02c32d423f16e80c3882243a0905083399e3faf8c8e8635`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T101033Z/decision.json` (`e9e4a1084b0035d042af45543d9212184940f94bebd39eb96c6eedd1d78e84b9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T101033Z/inputs/blind_dependency_inventory.json` (`5a478146206a74efcd7f4255078082ecb7c079dd657722eff7d2b5d3ad81983b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T101033Z/inputs/blind_dossier.md` (`760e86b526f9b8a306a366e5d8b2ba84c676c172632fb8056b62f953708b1214`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T101033Z/inputs/blind_review_packet.md` (`760e86b526f9b8a306a366e5d8b2ba84c676c172632fb8056b62f953708b1214`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T101033Z/inputs/declaration_dossier.md` (`256df8ed5d82e61ef920c53a5e17aeff2b01735ef25796676f8bf04a7258bf5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T101033Z/inputs/dependency_inventory.json` (`5a478146206a74efcd7f4255078082ecb7c079dd657722eff7d2b5d3ad81983b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T101033Z/inputs/direct_review_packet.md` (`906eff8ed996b82953c23f335e68e5458c771689b63b8a4735b81a09115b16f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T101033Z/inputs/source_locator.json` (`4244aefdb4adc43e14fe4a7be5a2ad7682de5a0b4e94b0c39a61b11745c0738f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T203448Z/agent_outputs/adjudicator.json` (`b341190025772987875804673bb02ea49d1d71349ca0a40cff6da10adcfdd9bd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T203448Z/agent_outputs/agent_runs.json` (`7c098b84a3b9e11a416c46b32bbad57ed173b032f1ea68ccd22fe50b62fe1574`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T203448Z/agent_outputs/blind_translation.json` (`5f838c4c31bc69a31bf1847c53d2ccf3bf398d574497e5d431d48fadb48e9c47`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T203448Z/agent_outputs/direct_judge.json` (`8bdb0be40ca33f876cf27651feaed36de1c95a3e15d5f681e22e20798425b071`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T203448Z/agent_outputs/roundtrip_judge.json` (`550c4c5028a05829e0f83bc343fd4b3a554f2f9b3f1d1cc7a7e6945afc2eb6c2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T203448Z/agent_outputs/source_contract.json` (`e65fc982e9335b90d02c32d423f16e80c3882243a0905083399e3faf8c8e8635`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T203448Z/decision.json` (`4b61cef442cd0f2454874eb11d6942b8b2d3f9d1b90e032d472715ab22f83880`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T203448Z/inputs/blind_dependency_inventory.json` (`5a478146206a74efcd7f4255078082ecb7c079dd657722eff7d2b5d3ad81983b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T203448Z/inputs/blind_dossier.md` (`760e86b526f9b8a306a366e5d8b2ba84c676c172632fb8056b62f953708b1214`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T203448Z/inputs/blind_review_packet.md` (`760e86b526f9b8a306a366e5d8b2ba84c676c172632fb8056b62f953708b1214`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T203448Z/inputs/declaration_dossier.md` (`d6ba721279adf65d261ead9024cd9f2abe86074b437591d88b6f749dad34fa01`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T203448Z/inputs/dependency_inventory.json` (`5a478146206a74efcd7f4255078082ecb7c079dd657722eff7d2b5d3ad81983b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T203448Z/inputs/direct_review_packet.md` (`906eff8ed996b82953c23f335e68e5458c771689b63b8a4735b81a09115b16f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/history/20260831T203448Z/inputs/source_locator.json` (`4244aefdb4adc43e14fe4a7be5a2ad7682de5a0b4e94b0c39a61b11745c0738f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/inputs/blind_dependency_inventory.json` (`5a478146206a74efcd7f4255078082ecb7c079dd657722eff7d2b5d3ad81983b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/inputs/blind_dossier.md` (`760e86b526f9b8a306a366e5d8b2ba84c676c172632fb8056b62f953708b1214`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/inputs/blind_review_packet.md` (`760e86b526f9b8a306a366e5d8b2ba84c676c172632fb8056b62f953708b1214`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/inputs/declaration_dossier.md` (`d6ba721279adf65d261ead9024cd9f2abe86074b437591d88b6f749dad34fa01`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/inputs/dependency_inventory.json` (`5a478146206a74efcd7f4255078082ecb7c079dd657722eff7d2b5d3ad81983b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/inputs/direct_review_packet.md` (`906eff8ed996b82953c23f335e68e5458c771689b63b8a4735b81a09115b16f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.11/faithfulness/inputs/source_locator.json` (`4244aefdb4adc43e14fe4a7be5a2ad7682de5a0b4e94b0c39a61b11745c0738f`)
