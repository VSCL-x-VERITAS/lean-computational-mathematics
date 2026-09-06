# Faithfulness audit: HDP-02-LEM-2.7.7

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `3d9e8b591a9466586aeac886c9d6da78746b7f9b54176b531d05a05400f1e576`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The target faithfully represents Lemma 2.7.7. Its only substantive premises are finiteness of the exact psi_2 gauges of X and Y on a common probability space, so it assumes sub-gaussianity without independence, centering, or symmetry. Its two conclusions state finiteness of the exact psi_1 gauge of the pointwise product and the bound by the product of the two psi_2 gauges with no extra constant. The gauge and admissibility definitions reproduce displays (2.13) and (2.21), including positive finite scales, explicit integrability, and threshold 2. Both logical implication directions therefore hold, and the source's harmless cross-reference typo is resolved by its displayed formula.

## Implications

- **Lean implies source:** `yes`. Each psi-two finiteness premise means the corresponding variable has a finite admissible scale and is sub-gaussian. The first conclusion makes the pointwise product sub-exponential, and the second is exactly the source constant-one psi_1 bound with the two original psi_2 gauges.
- **Source implies lean:** `yes`. Under the displayed norm definitions, source sub-gaussianity of X and Y is precisely finiteness of their PsiTwoGauge values. The source's product conclusion gives finiteness of PsiOneGauge(XY), and its stated norm estimate is the identical ENNReal inequality in Lean.

## Findings

- **note / source-cross-reference:** The prose typo does not affect the comparison or require adjudication.

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

- Blind translator covered `83` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `83` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/agent_outputs/agent_runs.json` (`6c9cde064a3162acb1a81917ff47022308ddb90d6bd1b2922781a83656f311c1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/agent_outputs/batch_source_contract.json` (`856d0400f37d309d6e394f4e5d704d0cd26bb8d59f2cdc4932f9f89bb4eb46e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/agent_outputs/blind_translation.json` (`65559403859acfafd9a496c214c4aff8f7b47e8c85f7019dd41ba691189a3ef4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/agent_outputs/direct_judge.json` (`ace5acbf40936934f2d005d85fc4ade9c0f4bc44a71f979850ae05583e881559`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/agent_outputs/roundtrip_judge.json` (`62370df4cc6d0f2ee389f79f4bd3fdc48d71f2e3b634ea1d73b40be0f6a0ebdd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/agent_outputs/source_contract.json` (`ad0c096e2ed0e9b0e6c365322e12e1d5531316b88b62f9b57c52992a7697f0a0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/decision.json` (`52ecf39efff01205ab5b37373ac394e9f2772e20ab54754d4932f2d3bfd0dc1c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/history/20260831T171702Z/agent_outputs/batch_source_contract.json` (`3e39d619b3c4737f1beebc1f4a6d89d80928155a0af9cf2c3a44f3fd92e95975`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/history/20260831T171702Z/agent_outputs/source_contract.json` (`8b2c73162c612622926dad7b4497e0bb544cd34b34cd0d907a26abe5d3d20302`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/history/20260831T171702Z/inputs/batch_source_locator.json` (`96999ab9c93dd8971b343042a9dbb8df6ab0d66f4db2c3e00054f6ef1ac2564e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/history/20260831T171702Z/inputs/blind_dependency_inventory.json` (`dd3f621adc29f58fa4f330f4f74539a25277db04b92e3d15ab4a0bdb273ac78c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/history/20260831T171702Z/inputs/blind_dossier.md` (`8c80b52426aa801aebb70424f9a529dadb0fa5391d1b97a13213241070b808d8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/history/20260831T171702Z/inputs/blind_review_packet.md` (`8c80b52426aa801aebb70424f9a529dadb0fa5391d1b97a13213241070b808d8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/history/20260831T171702Z/inputs/declaration_dossier.md` (`aa723f30256eccd8a47945faaba3e802669a5bf2de06c06c52cbbd7a26dd9819`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/history/20260831T171702Z/inputs/dependency_inventory.json` (`155dd82d9c71d40d8c3e8f1058dfbb9a51f1e6239e45fd978607d763092e1d6e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/history/20260831T171702Z/inputs/direct_review_packet.md` (`3fd4138ab9939d211125e6dea2d5816ae999f5ab00d43bf34b3c57e138f104eb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/history/20260831T171702Z/inputs/source_locator.json` (`ce66c960304f9f48f68581b7f3e431cf9c0311efb4743ce19944aaddaff3ff55`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/history/20260831T204043Z/agent_outputs/agent_runs.json` (`b8a10eb77c135650db4b34f252bd2969b5d9cad139e834bc7754ce248a386eee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/history/20260831T204043Z/agent_outputs/batch_source_contract.json` (`856d0400f37d309d6e394f4e5d704d0cd26bb8d59f2cdc4932f9f89bb4eb46e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/history/20260831T204043Z/agent_outputs/source_contract.json` (`ad0c096e2ed0e9b0e6c365322e12e1d5531316b88b62f9b57c52992a7697f0a0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/history/20260831T204043Z/inputs/batch_source_locator.json` (`344c2f15f875394c1b35c8732c25ff4482a74b2364f89e81c7bee4a9d3ea6fc2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/history/20260831T204043Z/inputs/blind_dependency_inventory.json` (`dd3f621adc29f58fa4f330f4f74539a25277db04b92e3d15ab4a0bdb273ac78c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/history/20260831T204043Z/inputs/blind_dossier.md` (`8c80b52426aa801aebb70424f9a529dadb0fa5391d1b97a13213241070b808d8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/history/20260831T204043Z/inputs/blind_review_packet.md` (`8c80b52426aa801aebb70424f9a529dadb0fa5391d1b97a13213241070b808d8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/history/20260831T204043Z/inputs/declaration_dossier.md` (`aa723f30256eccd8a47945faaba3e802669a5bf2de06c06c52cbbd7a26dd9819`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/history/20260831T204043Z/inputs/dependency_inventory.json` (`155dd82d9c71d40d8c3e8f1058dfbb9a51f1e6239e45fd978607d763092e1d6e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/history/20260831T204043Z/inputs/direct_review_packet.md` (`3fd4138ab9939d211125e6dea2d5816ae999f5ab00d43bf34b3c57e138f104eb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/history/20260831T204043Z/inputs/source_locator.json` (`5809e6fa4fa021855f3d2e56b7f1533c6622e74341cd527e24e97f0c1acbdb4a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/inputs/blind_dependency_inventory.json` (`dd3f621adc29f58fa4f330f4f74539a25277db04b92e3d15ab4a0bdb273ac78c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/inputs/blind_dossier.md` (`8c80b52426aa801aebb70424f9a529dadb0fa5391d1b97a13213241070b808d8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/inputs/blind_review_packet.md` (`8c80b52426aa801aebb70424f9a529dadb0fa5391d1b97a13213241070b808d8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/inputs/declaration_dossier.md` (`b6ff48513eaaf0d775888f441f5a29321377e25b984a66bed7d6ce11f337ed92`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/inputs/dependency_inventory.json` (`155dd82d9c71d40d8c3e8f1058dfbb9a51f1e6239e45fd978607d763092e1d6e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/inputs/direct_review_packet.md` (`3fd4138ab9939d211125e6dea2d5816ae999f5ab00d43bf34b3c57e138f104eb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.7/faithfulness/inputs/source_locator.json` (`5809e6fa4fa021855f3d2e56b7f1533c6622e74341cd527e24e97f0c1acbdb4a`)
