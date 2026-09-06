# Faithfulness audit: HDP-02-EXAMPLE-2.5.8A

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `a349af15a85f93cd9b9e459f90e8ce97e63ef5fa9caf31c4baed85a8839e8d08`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The repaired declaration faithfully formalizes Example 2.5.8(a). The source asserts one absolute positive constant C such that a standard normal has psi_2 norm at most C and, uniformly for sigma>=0, N(0,sigma^2) has psi_2 norm at most C*sigma, with sub-Gaussianity included. The Lean declaration states exactly those two bounds for the identity random variable under canonical Gaussian laws. Imported Mathlib evidence fixes gaussianReal's second parameter as variance and confirms sigma^2 scaling. The local PsiTwoGauge is the source infimum in ENNReal; bounding it by a finite ofReal value both rules out an empty admissible set and entails sub-Gaussianity. Finally, replacing an arbitrary random variable by id on its law preserves all exponential-square integrals. Thus each formulation implies the other, with no unresolved semantic uncertainty or faithfulness defect.

## Implications

- **Lean implies source:** `yes`. The Lean bounds are the source's norm inequalities under the canonical Gaussian laws. Their finite right-hand sides force finite PsiTwoGauge, which is equivalent to IsSubGaussian on a probability measure. Equality in law transports the exponential-square integrals from id under gaussianReal to any random variable with that Gaussian law, so the source formulation follows.
- **Source implies lean:** `yes`. Instantiate the source statement with id on the canonical measures gaussianReal 0 1 and gaussianReal 0 <sigma^2>. The verified variance parameter, the exact PsiTwoGauge definition, the shared positive C, and the nonnegative real-to-ENNReal embedding yield the Lean statement verbatim up to representation.

## Findings

- **note / gaussian-parameter-semantics:** This resolves the blind dependency-frontier ambiguity and confirms the source's N(0,sigma^2) law.
- **note / canonical-law-representation:** This is distributionally equivalent because every term in the psi_2 definition is determined by the pushforward law.
- **note / sub-gaussian-nonvacuity:** The quantitative Lean inequalities already include the source's qualitative sub-Gaussian assertion and are not vacuous.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `unclear` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `unclear` |
| `C06` | `pass` | `unclear` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `unclear` |
| `C09` | `pass` | `unclear` |
| `C10` | `pass` | `unclear` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `unclear` |

## Dependency coverage

- Blind translator covered `98` dependencies (`0` hash-reused); unclear: `D027`.
- Direct judge covered `98` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/agent_outputs/adjudicator.json` (`325bdd0186d85ad084a2a92eae71612d05d940cca09aa2dbc1a107eebe8d7fb4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/agent_outputs/agent_runs.json` (`d0f1d9f77aea958d514eb9097fe6d25fdf1bdb38d9c0ce95b65ff3792dc50bfe`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/agent_outputs/blind_translation.json` (`2ff3b54d5060fbb19bff2009fb6fa8c4961d7580b8e8d285d436ef520caf3245`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/agent_outputs/direct_judge.json` (`f1beaed861da8088b50f99c76ebcadcac205c9c6f3a43620309c7ba77e170f10`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/agent_outputs/roundtrip_judge.json` (`f551ad4cec58ea59a2239ed383c7e3684c1b3ebcc399180a7bbad38f52380dac`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/agent_outputs/source_contract.json` (`de36de7142ab5beaba2636e11da54e738294b5fafde72001a51e674958d42046`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/decision.json` (`ce04eacfeb06f2c143884b387617139fab52f664839629887fab4dee32bbb171`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T025004Z/agent_outputs/adjudicator.json` (`49dfa5fdb895d96ffe4244aa2b7533212844d00446c0a70162825b3cf737a1e5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T025004Z/agent_outputs/agent_runs.json` (`7021489e448e75356d0f853619d42d98f89053a9c1045cc82828797d7252058f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T025004Z/agent_outputs/batch_source_contract.json` (`494c6f312e574aa6f514d15c6f5cccfd33a38ac45eeaedf5b1a4021def672747`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T025004Z/agent_outputs/blind_translation.json` (`aec9cdc059660bbeada71533220ccf020b91d675cbe114c99b11c19d0585ff1f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T025004Z/agent_outputs/direct_judge.json` (`009155d586e838a9dea37750a0032ecb322bc03d78c088a1894bbe4ae1cf3cfc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T025004Z/agent_outputs/roundtrip_judge.json` (`807e0f0b3853d7945b965caf37a6bb10066f2543139f1951dfdf59b08fb318c7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T025004Z/agent_outputs/source_contract.json` (`de36de7142ab5beaba2636e11da54e738294b5fafde72001a51e674958d42046`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T025004Z/decision.json` (`561aa482de7518732e40d11916bf1b70202b699dc5a9b9dba8f282a03d825cd9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T025004Z/inputs/batch_source_locator.json` (`59d0c30087c4101335676c811234504bee892a89bef1c027bac4c02006913d37`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T025004Z/inputs/blind_dependency_inventory.json` (`6c76449706c23848ed0545f040dab4bd5038c5d8ffc6db23334edc9085a839eb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T025004Z/inputs/blind_dossier.md` (`4c7fe5a02042c15df877f897df859d75c353746cb0679c1cf3ab86f7379cc151`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T025004Z/inputs/blind_review_packet.md` (`4c7fe5a02042c15df877f897df859d75c353746cb0679c1cf3ab86f7379cc151`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T025004Z/inputs/declaration_dossier.md` (`78b5650fd93d2345e2dabed97d8111a65200915cbb427626ebe245249289a53c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T025004Z/inputs/dependency_inventory.json` (`12a7022e1e789d89aceeb01036be86ff87ab75183387dd4d6f7b640b3bde0b52`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T025004Z/inputs/direct_review_packet.md` (`5b79dd4d634c540473a940b095b7584649d10a2e5de2f2d1e78c966c934fbc67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T025004Z/inputs/source_locator.json` (`1c3c6686d45c0da656ab946f10f2b508a6d3606a34cf5b74a050010d330e5305`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T084759Z/agent_outputs/adjudicator.json` (`325bdd0186d85ad084a2a92eae71612d05d940cca09aa2dbc1a107eebe8d7fb4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T084759Z/agent_outputs/agent_runs.json` (`fa8853146a02874b6947f2be062d2021b04e4f18d4508440ec0a8f3ce3c99174`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T084759Z/agent_outputs/blind_translation.json` (`2ff3b54d5060fbb19bff2009fb6fa8c4961d7580b8e8d285d436ef520caf3245`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T084759Z/agent_outputs/direct_judge.json` (`f1beaed861da8088b50f99c76ebcadcac205c9c6f3a43620309c7ba77e170f10`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T084759Z/agent_outputs/roundtrip_judge.json` (`f551ad4cec58ea59a2239ed383c7e3684c1b3ebcc399180a7bbad38f52380dac`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T084759Z/agent_outputs/source_contract.json` (`de36de7142ab5beaba2636e11da54e738294b5fafde72001a51e674958d42046`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T084759Z/decision.json` (`07a2d0e2021ba92dfafbdba8890fa69c94dae37260d0274d39cb31beafef856a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T084759Z/inputs/blind_dependency_inventory.json` (`8517719701b7f2dd5d39b118109884ca9ed9c59fe1af7c807879e705493e41f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T084759Z/inputs/blind_dossier.md` (`2215fcb19278704dc962ea347c82fa34cdfe55fa5affeb4f64dad43dcdc4654a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T084759Z/inputs/blind_review_packet.md` (`2215fcb19278704dc962ea347c82fa34cdfe55fa5affeb4f64dad43dcdc4654a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T084759Z/inputs/declaration_dossier.md` (`109d63217f094130bffd7a4930981ff859415690f103d1f1f26b9738621a84d4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T084759Z/inputs/dependency_inventory.json` (`8ad5f0c11723a154725d4bda655a72a3ccfaaa0bad5f7b8f1ad587bdca597579`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T084759Z/inputs/direct_review_packet.md` (`825e6eae18d07b848d4f3cf9cb63dfe7d2b70a49cec0f5b455245fe9c2883878`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T084759Z/inputs/source_locator.json` (`1c3c6686d45c0da656ab946f10f2b508a6d3606a34cf5b74a050010d330e5305`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T101622Z/agent_outputs/adjudicator.json` (`325bdd0186d85ad084a2a92eae71612d05d940cca09aa2dbc1a107eebe8d7fb4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T101622Z/agent_outputs/agent_runs.json` (`d0f1d9f77aea958d514eb9097fe6d25fdf1bdb38d9c0ce95b65ff3792dc50bfe`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T101622Z/agent_outputs/blind_translation.json` (`2ff3b54d5060fbb19bff2009fb6fa8c4961d7580b8e8d285d436ef520caf3245`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T101622Z/agent_outputs/direct_judge.json` (`f1beaed861da8088b50f99c76ebcadcac205c9c6f3a43620309c7ba77e170f10`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T101622Z/agent_outputs/roundtrip_judge.json` (`f551ad4cec58ea59a2239ed383c7e3684c1b3ebcc399180a7bbad38f52380dac`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T101622Z/agent_outputs/source_contract.json` (`de36de7142ab5beaba2636e11da54e738294b5fafde72001a51e674958d42046`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T101622Z/decision.json` (`a8a79c67fd91087f866c669f9fa9c89a3e7e23592bca8e53f7116992e14d9133`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T101622Z/inputs/blind_dependency_inventory.json` (`8517719701b7f2dd5d39b118109884ca9ed9c59fe1af7c807879e705493e41f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T101622Z/inputs/blind_dossier.md` (`2215fcb19278704dc962ea347c82fa34cdfe55fa5affeb4f64dad43dcdc4654a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T101622Z/inputs/blind_review_packet.md` (`2215fcb19278704dc962ea347c82fa34cdfe55fa5affeb4f64dad43dcdc4654a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T101622Z/inputs/declaration_dossier.md` (`109d63217f094130bffd7a4930981ff859415690f103d1f1f26b9738621a84d4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T101622Z/inputs/dependency_inventory.json` (`8ad5f0c11723a154725d4bda655a72a3ccfaaa0bad5f7b8f1ad587bdca597579`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T101622Z/inputs/direct_review_packet.md` (`825e6eae18d07b848d4f3cf9cb63dfe7d2b70a49cec0f5b455245fe9c2883878`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T101622Z/inputs/source_locator.json` (`1c3c6686d45c0da656ab946f10f2b508a6d3606a34cf5b74a050010d330e5305`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T203028Z/agent_outputs/adjudicator.json` (`325bdd0186d85ad084a2a92eae71612d05d940cca09aa2dbc1a107eebe8d7fb4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T203028Z/agent_outputs/agent_runs.json` (`d0f1d9f77aea958d514eb9097fe6d25fdf1bdb38d9c0ce95b65ff3792dc50bfe`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T203028Z/agent_outputs/blind_translation.json` (`2ff3b54d5060fbb19bff2009fb6fa8c4961d7580b8e8d285d436ef520caf3245`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T203028Z/agent_outputs/direct_judge.json` (`f1beaed861da8088b50f99c76ebcadcac205c9c6f3a43620309c7ba77e170f10`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T203028Z/agent_outputs/roundtrip_judge.json` (`f551ad4cec58ea59a2239ed383c7e3684c1b3ebcc399180a7bbad38f52380dac`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T203028Z/agent_outputs/source_contract.json` (`de36de7142ab5beaba2636e11da54e738294b5fafde72001a51e674958d42046`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T203028Z/decision.json` (`617ff98167f03fd8a0dade373eb485e2f1d59baaa1cb358575c7f65aa4211ae0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T203028Z/inputs/blind_dependency_inventory.json` (`8517719701b7f2dd5d39b118109884ca9ed9c59fe1af7c807879e705493e41f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T203028Z/inputs/blind_dossier.md` (`2215fcb19278704dc962ea347c82fa34cdfe55fa5affeb4f64dad43dcdc4654a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T203028Z/inputs/blind_review_packet.md` (`2215fcb19278704dc962ea347c82fa34cdfe55fa5affeb4f64dad43dcdc4654a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T203028Z/inputs/declaration_dossier.md` (`34753f64fc8565fd5389386adbddafc65286103636ee8882575054206e31e954`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T203028Z/inputs/dependency_inventory.json` (`8ad5f0c11723a154725d4bda655a72a3ccfaaa0bad5f7b8f1ad587bdca597579`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T203028Z/inputs/direct_review_packet.md` (`825e6eae18d07b848d4f3cf9cb63dfe7d2b70a49cec0f5b455245fe9c2883878`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/history/20260831T203028Z/inputs/source_locator.json` (`1c3c6686d45c0da656ab946f10f2b508a6d3606a34cf5b74a050010d330e5305`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/inputs/blind_dependency_inventory.json` (`8517719701b7f2dd5d39b118109884ca9ed9c59fe1af7c807879e705493e41f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/inputs/blind_dossier.md` (`2215fcb19278704dc962ea347c82fa34cdfe55fa5affeb4f64dad43dcdc4654a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/inputs/blind_review_packet.md` (`2215fcb19278704dc962ea347c82fa34cdfe55fa5affeb4f64dad43dcdc4654a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/inputs/declaration_dossier.md` (`34753f64fc8565fd5389386adbddafc65286103636ee8882575054206e31e954`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/inputs/dependency_inventory.json` (`8ad5f0c11723a154725d4bda655a72a3ccfaaa0bad5f7b8f1ad587bdca597579`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/inputs/direct_review_packet.md` (`825e6eae18d07b848d4f3cf9cb63dfe7d2b70a49cec0f5b455245fe9c2883878`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8A/faithfulness/inputs/source_locator.json` (`1c3c6686d45c0da656ab946f10f2b508a6d3606a34cf5b74a050010d330e5305`)
