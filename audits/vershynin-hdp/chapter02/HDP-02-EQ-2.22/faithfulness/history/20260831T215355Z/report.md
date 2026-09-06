# Faithfulness audit: HDP-02-EQ-2.22

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `1ca0daca175045807782550da0ac6dd0381a79e9b52c67fa227dacb7b870da49`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The repaired target faithfully makes the inherited context of display (2.22) explicit and includes both required normalized quadratic exponential-moment bounds. Its local sub-gaussian and psi_2 definitions match the source's positive-scale infimum characterization, while the remaining dependencies supply standard real, measure, order, numeral, and typeclass semantics. Both implication directions hold, the hypotheses are nonvacuous, and no unresolved check requires adjudication.

## Implications

- **Lean implies source:** `yes`. Under the same probability-space, sub-gaussian, and unit-psi_2 context, the Lean conclusion is literally the conjunction of the source's two normalized bounds with the same exponent, variables, measure, and threshold.
- **Source implies lean:** `yes`. The source's arbitrary real sub-gaussian X and Y under simultaneous unit normalization satisfy both displayed expectation bounds; translating expectation as the real integral and the psi_2 norm by D002--D006 yields exactly the universally quantified Lean proposition.

## Findings

- **note / integrability-at-normalized-boundary:** No implication changes: sub-gaussian nonemptiness plus infimum 1 provides admissible scales approaching 1, and the nonnegative exponential integrands pass to scale 1 with integral at most 2; hence the normalized functions are integrable in the setting of the hypotheses.

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

- Blind translator covered `77` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `77` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/agent_outputs/agent_runs.json` (`65ebe7c91df914376aef7fa7193190be7b47f6ab103e4adb231837e7341beb48`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/agent_outputs/blind_translation.json` (`866a09d4968a7389d260a92fe7c6c094d084f3266e2d435f9c273054868f16ff`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/agent_outputs/direct_judge.json` (`7e7644fc2f89480ad6e5f131b239f2a19a8f8058f2c6f8782b716c4d4a6208f4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/agent_outputs/roundtrip_judge.json` (`98a2bbc7c7bd6100f7a5c5bf4d0da6fc91d5335cc22dd6d607ad25ee06bab9ad`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/agent_outputs/source_contract.json` (`d83b7c9157cde54d72bd1c4a4409bd058bf1888d15cbd8128e3164c063159a0c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/decision.json` (`2afc54e9ba98b2c08a11a539d5783c6964464e5711ba4069c92d625fd96b89a9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T171557Z/agent_outputs/batch_source_contract.json` (`3e39d619b3c4737f1beebc1f4a6d89d80928155a0af9cf2c3a44f3fd92e95975`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T171557Z/agent_outputs/source_contract.json` (`681fe3631017ca78976d83c01253905bd56c909bb91543527d26684e9fde6092`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T171557Z/inputs/batch_source_locator.json` (`96999ab9c93dd8971b343042a9dbb8df6ab0d66f4db2c3e00054f6ef1ac2564e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T171557Z/inputs/blind_dependency_inventory.json` (`e79b468cd39ddc8c1a5865aaad481ae5e2c945e758f44e54d3c01088364320dd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T171557Z/inputs/blind_dossier.md` (`860297e2bb0060600fbc79183d6c154382e0b98cd36e26527231abc4269bd846`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T171557Z/inputs/blind_review_packet.md` (`860297e2bb0060600fbc79183d6c154382e0b98cd36e26527231abc4269bd846`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T171557Z/inputs/declaration_dossier.md` (`28cc9d69f4b3193a5e30a0a2ae0ad8b773da051a467fcb329713ac00deeb2a3a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T171557Z/inputs/dependency_inventory.json` (`faa5f74f75ac63a04641756b4cab0d598ebe10fc1ae2625834b3acf25260a70c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T171557Z/inputs/direct_review_packet.md` (`3f81867745a0998617f97c5e3bbaa8bd65c43b2526b9d38cfcd0e7e70bc64d11`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T171557Z/inputs/source_locator.json` (`6a5075db7028d45a6c5d6b182b2e001ceb33ba443fcdf9c65863db243a7f9ad8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T190026Z/agent_outputs/agent_runs.json` (`5088f5f319e007ca4613a5ddc8cc25531753f8aaf6a944cdf213cf4060f0ce34`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T190026Z/agent_outputs/batch_source_contract.json` (`856d0400f37d309d6e394f4e5d704d0cd26bb8d59f2cdc4932f9f89bb4eb46e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T190026Z/agent_outputs/source_contract.json` (`d83b7c9157cde54d72bd1c4a4409bd058bf1888d15cbd8128e3164c063159a0c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T190026Z/inputs/batch_source_locator.json` (`344c2f15f875394c1b35c8732c25ff4482a74b2364f89e81c7bee4a9d3ea6fc2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T190026Z/inputs/blind_dependency_inventory.json` (`e79b468cd39ddc8c1a5865aaad481ae5e2c945e758f44e54d3c01088364320dd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T190026Z/inputs/blind_dossier.md` (`860297e2bb0060600fbc79183d6c154382e0b98cd36e26527231abc4269bd846`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T190026Z/inputs/blind_review_packet.md` (`860297e2bb0060600fbc79183d6c154382e0b98cd36e26527231abc4269bd846`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T190026Z/inputs/declaration_dossier.md` (`28cc9d69f4b3193a5e30a0a2ae0ad8b773da051a467fcb329713ac00deeb2a3a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T190026Z/inputs/dependency_inventory.json` (`faa5f74f75ac63a04641756b4cab0d598ebe10fc1ae2625834b3acf25260a70c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T190026Z/inputs/direct_review_packet.md` (`3f81867745a0998617f97c5e3bbaa8bd65c43b2526b9d38cfcd0e7e70bc64d11`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T190026Z/inputs/source_locator.json` (`6a5075db7028d45a6c5d6b182b2e001ceb33ba443fcdf9c65863db243a7f9ad8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T200455Z/agent_outputs/agent_runs.json` (`695ad4e3e7a1789c9479100c1d72655533fc617bef979fe984d7e00e85d1edf9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T200455Z/agent_outputs/batch_source_contract.json` (`856d0400f37d309d6e394f4e5d704d0cd26bb8d59f2cdc4932f9f89bb4eb46e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T200455Z/agent_outputs/blind_translation.json` (`15f43bf3f263d29be705a701415539022e65159d6d7093f3fce2c045e55b4961`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T200455Z/agent_outputs/direct_judge.json` (`a4e30b3f79a726848838aac76bf864e40b6a3bc6fbbaf9ba18628a6cffc1445a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T200455Z/agent_outputs/roundtrip_judge.json` (`a5687571a070fbda06f02bac9feb4f49d15af924beae6e917183718b2ed1e69f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T200455Z/agent_outputs/source_contract.json` (`d83b7c9157cde54d72bd1c4a4409bd058bf1888d15cbd8128e3164c063159a0c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T200455Z/inputs/blind_dependency_inventory.json` (`e79b468cd39ddc8c1a5865aaad481ae5e2c945e758f44e54d3c01088364320dd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T200455Z/inputs/blind_dossier.md` (`860297e2bb0060600fbc79183d6c154382e0b98cd36e26527231abc4269bd846`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T200455Z/inputs/blind_review_packet.md` (`860297e2bb0060600fbc79183d6c154382e0b98cd36e26527231abc4269bd846`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T200455Z/inputs/declaration_dossier.md` (`7294c481ff339b63b8204b540239c09e954bb542d53d0bb83e913304df9a8015`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T200455Z/inputs/dependency_inventory.json` (`faa5f74f75ac63a04641756b4cab0d598ebe10fc1ae2625834b3acf25260a70c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T200455Z/inputs/direct_review_packet.md` (`3f81867745a0998617f97c5e3bbaa8bd65c43b2526b9d38cfcd0e7e70bc64d11`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/history/20260831T200455Z/inputs/source_locator.json` (`6a5075db7028d45a6c5d6b182b2e001ceb33ba443fcdf9c65863db243a7f9ad8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/inputs/blind_dependency_inventory.json` (`417dc66c9f50ad1a618667718f034291f27141d3b386dc33e05fd4f3e9b60237`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/inputs/blind_dossier.md` (`8cd41a622b29f6c0bb504b98d05c798c222b31b020f855a1abc2b89b2008df67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/inputs/blind_review_packet.md` (`8cd41a622b29f6c0bb504b98d05c798c222b31b020f855a1abc2b89b2008df67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/inputs/declaration_dossier.md` (`85eb1b38a4c40f237b6b72881e2338225bbd7ef8f1b0713b327cee6242010f4f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/inputs/dependency_inventory.json` (`2bf48bf93f8cb3bf651f37c301f260d4fab7b20e06e744d7bb70bd92b2abcd59`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/inputs/direct_review_packet.md` (`2965979e3ae1bda2e150659a6d08d1d9729333f55e63834f8c34b68ac82f5446`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.22/faithfulness/inputs/source_locator.json` (`6a5075db7028d45a6c5d6b182b2e001ceb33ba443fcdf9c65863db243a7f9ad8`)
