# Faithfulness audit: HDP-02-EX-2.5.5B

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `2620b401c7f6619b349ba32385454afe4ba21c35b08f21ec2098b46126c187a3`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The source and Lean hypotheses have the same substantive content: one fixed real K controls E exp(lambda^2 X^2) by exp(K lambda^2) for every real lambda on a probability space. Lean's explicit measurability, integrability, probability-measure, and K-nonnegativity assumptions formalize conditions implicit in a satisfiable reading of the source and do not reduce intended applicability. Its conclusion is stronger than the printed qualitative boundedness statement: it supplies the K-dependent almost-sure cutoff at every t with t^2 > K. This strengthening is meaningful and nonvacuous, entails finite essential supremum, and leaves no unresolved semantic issue requiring adjudication.

## Implications

- **Lean implies source:** `yes`. Under the exact global square-MGF premise, Lean proves that every threshold t with t^2 > K has zero tail probability. Taking any finite nonnegative t above sqrt(K) gives an almost-sure bound and hence finite L-infinity norm, which is the source conclusion.
- **Source implies lean:** `no`. The printed source conclusion says only that some finite essential bound exists. That qualitative conclusion does not state the sharper dependence on the displayed MGF constant K required by Lean, namely zero tail probability at every threshold with t^2 > K.

## Findings

- **note / quantitative-conclusion-strengthening:** The target is a genuine, nonvacuous strengthening that still entails the full source claim; it is accepted as faithful-stronger rather than faithful-equivalent.
- **major / quantitative-strengthening:** The translated proposition entails the source result but is not a restatement of its qualitative conclusion; it is a genuine, nonvacuous strengthening.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `fail` |
| `C03` | `pass` | `fail` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `fail` | `fail` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `48` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `48` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/agent_outputs/agent_runs.json` (`194195927dc28d337ed4e98455dac95f057bd56090c43691359baa0f18bcb4f2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/agent_outputs/blind_translation.json` (`8e1df3802114a619d39394d545a90c385f9c22a52aa09fabc415fc5b70c667df`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/agent_outputs/direct_judge.json` (`a21b998792f7f918f6a9f2c61ba12f6b0644f95fd285e4c7b4ca9ad3e41c4a85`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/agent_outputs/roundtrip_judge.json` (`bf2ac19d86dfaef76bdab9272052bb8f43dd699d99de14bb836b6423629b92e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/agent_outputs/source_contract.json` (`211571b11f85dd35b4ce6595cc194ed3289c61b75c71c7fbdfe4fde57f7b74f8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/decision.json` (`8dfb29988375fafb96a5662aadf5cd1c50069be45a7971319dfc830393fae1db`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T135650Z/inputs/blind_dependency_inventory.json` (`e7825c6d7c03f92bbd224cc50afbd8a6b3dcced0e2b83e91cb92cd490c24a020`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T135650Z/inputs/blind_dossier.md` (`7adfe76cd4ea5b35cf27dbf1b8b90e5797fe20dc73227e44486f2a87543e1a7a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T135650Z/inputs/blind_review_packet.md` (`7adfe76cd4ea5b35cf27dbf1b8b90e5797fe20dc73227e44486f2a87543e1a7a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T135650Z/inputs/declaration_dossier.md` (`8f2c75b5a09383e66be66eb8b65079017e567e91dc636ff1aa1d26339d23575e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T135650Z/inputs/dependency_inventory.json` (`e7825c6d7c03f92bbd224cc50afbd8a6b3dcced0e2b83e91cb92cd490c24a020`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T135650Z/inputs/direct_review_packet.md` (`fcf032f0421ccc3bd14b9cfe34ee730825beae82839b6bf4c29af5198e6e8290`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T135650Z/inputs/source_locator.json` (`402ee204fd898dd8315aeceea40b69cb89b44ebed8ddd2e9345729a6005a5e5e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T145455Z/agent_outputs/agent_runs.json` (`09b51139f8e02c8df779bfaaa6622440db329e124bf5017a760f0f51d1b6608e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T145455Z/agent_outputs/blind_translation.json` (`8e1df3802114a619d39394d545a90c385f9c22a52aa09fabc415fc5b70c667df`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T145455Z/agent_outputs/direct_judge.json` (`a21b998792f7f918f6a9f2c61ba12f6b0644f95fd285e4c7b4ca9ad3e41c4a85`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T145455Z/agent_outputs/roundtrip_judge.json` (`bf2ac19d86dfaef76bdab9272052bb8f43dd699d99de14bb836b6423629b92e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T145455Z/agent_outputs/source_contract.json` (`211571b11f85dd35b4ce6595cc194ed3289c61b75c71c7fbdfe4fde57f7b74f8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T145455Z/decision.json` (`5268dbd16f857ea0c13819314544a9305a696aea84e58e0a5eb282bed5cc40c7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T145455Z/inputs/blind_dependency_inventory.json` (`e7825c6d7c03f92bbd224cc50afbd8a6b3dcced0e2b83e91cb92cd490c24a020`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T145455Z/inputs/blind_dossier.md` (`7adfe76cd4ea5b35cf27dbf1b8b90e5797fe20dc73227e44486f2a87543e1a7a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T145455Z/inputs/blind_review_packet.md` (`7adfe76cd4ea5b35cf27dbf1b8b90e5797fe20dc73227e44486f2a87543e1a7a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T145455Z/inputs/declaration_dossier.md` (`8f2c75b5a09383e66be66eb8b65079017e567e91dc636ff1aa1d26339d23575e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T145455Z/inputs/dependency_inventory.json` (`e7825c6d7c03f92bbd224cc50afbd8a6b3dcced0e2b83e91cb92cd490c24a020`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T145455Z/inputs/direct_review_packet.md` (`fcf032f0421ccc3bd14b9cfe34ee730825beae82839b6bf4c29af5198e6e8290`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T145455Z/inputs/source_locator.json` (`402ee204fd898dd8315aeceea40b69cb89b44ebed8ddd2e9345729a6005a5e5e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T153304Z/agent_outputs/agent_runs.json` (`09b51139f8e02c8df779bfaaa6622440db329e124bf5017a760f0f51d1b6608e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T153304Z/agent_outputs/blind_translation.json` (`8e1df3802114a619d39394d545a90c385f9c22a52aa09fabc415fc5b70c667df`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T153304Z/agent_outputs/direct_judge.json` (`a21b998792f7f918f6a9f2c61ba12f6b0644f95fd285e4c7b4ca9ad3e41c4a85`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T153304Z/agent_outputs/roundtrip_judge.json` (`bf2ac19d86dfaef76bdab9272052bb8f43dd699d99de14bb836b6423629b92e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T153304Z/agent_outputs/source_contract.json` (`211571b11f85dd35b4ce6595cc194ed3289c61b75c71c7fbdfe4fde57f7b74f8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T153304Z/decision.json` (`c392cbddcde3295e41c9beea416dec949b36a9a94956430c6e5ef798de3594d6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T153304Z/inputs/blind_dependency_inventory.json` (`e7825c6d7c03f92bbd224cc50afbd8a6b3dcced0e2b83e91cb92cd490c24a020`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T153304Z/inputs/blind_dossier.md` (`7adfe76cd4ea5b35cf27dbf1b8b90e5797fe20dc73227e44486f2a87543e1a7a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T153304Z/inputs/blind_review_packet.md` (`7adfe76cd4ea5b35cf27dbf1b8b90e5797fe20dc73227e44486f2a87543e1a7a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T153304Z/inputs/declaration_dossier.md` (`8f2c75b5a09383e66be66eb8b65079017e567e91dc636ff1aa1d26339d23575e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T153304Z/inputs/dependency_inventory.json` (`e7825c6d7c03f92bbd224cc50afbd8a6b3dcced0e2b83e91cb92cd490c24a020`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T153304Z/inputs/direct_review_packet.md` (`fcf032f0421ccc3bd14b9cfe34ee730825beae82839b6bf4c29af5198e6e8290`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260830T153304Z/inputs/source_locator.json` (`402ee204fd898dd8315aeceea40b69cb89b44ebed8ddd2e9345729a6005a5e5e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T084351Z/agent_outputs/agent_runs.json` (`09b51139f8e02c8df779bfaaa6622440db329e124bf5017a760f0f51d1b6608e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T084351Z/agent_outputs/blind_translation.json` (`8e1df3802114a619d39394d545a90c385f9c22a52aa09fabc415fc5b70c667df`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T084351Z/agent_outputs/direct_judge.json` (`a21b998792f7f918f6a9f2c61ba12f6b0644f95fd285e4c7b4ca9ad3e41c4a85`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T084351Z/agent_outputs/roundtrip_judge.json` (`bf2ac19d86dfaef76bdab9272052bb8f43dd699d99de14bb836b6423629b92e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T084351Z/agent_outputs/source_contract.json` (`211571b11f85dd35b4ce6595cc194ed3289c61b75c71c7fbdfe4fde57f7b74f8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T084351Z/decision.json` (`5325e1b94d1d3f4d344c22e989a3105bacb182b27000e84b1f3e8feea6cf6bfb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T084351Z/inputs/blind_dependency_inventory.json` (`e7825c6d7c03f92bbd224cc50afbd8a6b3dcced0e2b83e91cb92cd490c24a020`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T084351Z/inputs/blind_dossier.md` (`7adfe76cd4ea5b35cf27dbf1b8b90e5797fe20dc73227e44486f2a87543e1a7a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T084351Z/inputs/blind_review_packet.md` (`7adfe76cd4ea5b35cf27dbf1b8b90e5797fe20dc73227e44486f2a87543e1a7a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T084351Z/inputs/declaration_dossier.md` (`8f2c75b5a09383e66be66eb8b65079017e567e91dc636ff1aa1d26339d23575e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T084351Z/inputs/dependency_inventory.json` (`e7825c6d7c03f92bbd224cc50afbd8a6b3dcced0e2b83e91cb92cd490c24a020`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T084351Z/inputs/direct_review_packet.md` (`fcf032f0421ccc3bd14b9cfe34ee730825beae82839b6bf4c29af5198e6e8290`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T084351Z/inputs/source_locator.json` (`402ee204fd898dd8315aeceea40b69cb89b44ebed8ddd2e9345729a6005a5e5e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T101558Z/agent_outputs/agent_runs.json` (`194195927dc28d337ed4e98455dac95f057bd56090c43691359baa0f18bcb4f2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T101558Z/agent_outputs/blind_translation.json` (`8e1df3802114a619d39394d545a90c385f9c22a52aa09fabc415fc5b70c667df`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T101558Z/agent_outputs/direct_judge.json` (`a21b998792f7f918f6a9f2c61ba12f6b0644f95fd285e4c7b4ca9ad3e41c4a85`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T101558Z/agent_outputs/roundtrip_judge.json` (`bf2ac19d86dfaef76bdab9272052bb8f43dd699d99de14bb836b6423629b92e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T101558Z/agent_outputs/source_contract.json` (`211571b11f85dd35b4ce6595cc194ed3289c61b75c71c7fbdfe4fde57f7b74f8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T101558Z/decision.json` (`f39c1519d69d656b954a2e4681d173a8175e69b419eabcafb8bb312336e7d061`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T101558Z/inputs/blind_dependency_inventory.json` (`e7825c6d7c03f92bbd224cc50afbd8a6b3dcced0e2b83e91cb92cd490c24a020`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T101558Z/inputs/blind_dossier.md` (`7adfe76cd4ea5b35cf27dbf1b8b90e5797fe20dc73227e44486f2a87543e1a7a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T101558Z/inputs/blind_review_packet.md` (`7adfe76cd4ea5b35cf27dbf1b8b90e5797fe20dc73227e44486f2a87543e1a7a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T101558Z/inputs/declaration_dossier.md` (`8f2c75b5a09383e66be66eb8b65079017e567e91dc636ff1aa1d26339d23575e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T101558Z/inputs/dependency_inventory.json` (`e7825c6d7c03f92bbd224cc50afbd8a6b3dcced0e2b83e91cb92cd490c24a020`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T101558Z/inputs/direct_review_packet.md` (`fcf032f0421ccc3bd14b9cfe34ee730825beae82839b6bf4c29af5198e6e8290`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/history/20260831T101558Z/inputs/source_locator.json` (`402ee204fd898dd8315aeceea40b69cb89b44ebed8ddd2e9345729a6005a5e5e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/inputs/blind_dependency_inventory.json` (`e7825c6d7c03f92bbd224cc50afbd8a6b3dcced0e2b83e91cb92cd490c24a020`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/inputs/blind_dossier.md` (`7adfe76cd4ea5b35cf27dbf1b8b90e5797fe20dc73227e44486f2a87543e1a7a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/inputs/blind_review_packet.md` (`7adfe76cd4ea5b35cf27dbf1b8b90e5797fe20dc73227e44486f2a87543e1a7a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/inputs/declaration_dossier.md` (`a59bea9dc8c13478964d6f061e989cafc2d2d82fe48cc147d16da7274be917e8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/inputs/dependency_inventory.json` (`e7825c6d7c03f92bbd224cc50afbd8a6b3dcced0e2b83e91cb92cd490c24a020`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/inputs/direct_review_packet.md` (`fcf032f0421ccc3bd14b9cfe34ee730825beae82839b6bf4c29af5198e6e8290`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.5B/faithfulness/inputs/source_locator.json` (`402ee204fd898dd8315aeceea40b69cb89b44ebed8ddd2e9345729a6005a5e5e`)
