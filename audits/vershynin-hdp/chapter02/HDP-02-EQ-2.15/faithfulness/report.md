# Faithfulness audit: HDP-02-EQ-2.15

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `a349af15a85f93cd9b9e459f90e8ce97e63ef5fa9caf31c4baed85a8839e8d08`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The direct packet faithfully represents the source's real-valued probability-space setting, Definition (2.13) psi-two norm, and all-p>=1 Lp moment growth. Every one of the 81 prepared dependencies has been interpreted and matches its role. The only directional asymmetry is deliberate quantitative specificity: the source leaves its universal absolute constant unspecified, whereas Lean proves the bound with 16e. Hence the target is accepted as faithful-stronger, with no unresolved dependency, checklist item, implication, vacuity concern, or need for adjudication.

## Implications

- **Lean implies source:** `yes`. D001 gives E|X|^p <= (16 e ||X||_psi2 sqrt(p))^p for every p>=1. Because p is positive and the base is nonnegative, taking the p-th root yields Equation (2.15) with the absolute constant C=16e; D002-D003 identify the Lean gauge with the source psi-two norm.
- **Source implies lean:** `no`. Equation (2.15) asserts existence/use of an unspecified absolute constant C and does not, as a statement, bound that C by 16e. Thus its qualitative universal-constant claim alone does not entail the target's particular coefficient 16e, even though it entails the same moment form for whichever source constant witnesses the bound.

## Findings

- **note / explicit-absolute-constant:** This is genuine nonvacuous quantitative strength: Lean implies the source using C=16e, while the source statement by itself does not force that particular numerical bound.
- **major / fixed-constant-strengthening:** This is genuine nonvacuous quantitative strengthening: the translation implies the source, while the existential source statement alone does not imply that specific coefficient. It changes the classification from equivalent to faithful-stronger but remains accepted.

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
| `C09` | `pass` | `fail` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `81` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `81` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/agent_outputs/agent_runs.json` (`5bb5b13f11ebb00e53809e72394509b2446cc9245d859c949c03a28ea70c305b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/agent_outputs/batch_source_contract.json` (`941033b94d4edcfd5a9ea42fdf0abe2a54d3a1d57a28f812a846762718114eee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/agent_outputs/blind_translation.json` (`992447599be60aefdf75f08c50d5a8a3bb23e97d4e813deb1a142e654fa3a02c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/agent_outputs/direct_judge.json` (`932ec9c312c1b2a28a02195e8471c8eb8c87b5f83dbc70a9b60ec36d7a433378`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/agent_outputs/roundtrip_judge.json` (`a4667e4ecf2b5ee74fe6954f125302da67eef36006fd9f21d157a434755cef8a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/agent_outputs/source_contract.json` (`6d8853ee75df275a5d7ae8109f791c4ba8bf4f55d38f3b84f996018392ff9bf8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/decision.json` (`ed55ae0ad6b241700679e29c0684fb8e35ce587e1c25d624584a12c05c731c0e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T051318Z/agent_outputs/agent_runs.json` (`98dd5205fc676258c63b87cb39a99d05550a54da19094824900c6b41cfa6f198`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T051318Z/agent_outputs/batch_source_contract.json` (`941033b94d4edcfd5a9ea42fdf0abe2a54d3a1d57a28f812a846762718114eee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T051318Z/agent_outputs/blind_translation.json` (`992447599be60aefdf75f08c50d5a8a3bb23e97d4e813deb1a142e654fa3a02c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T051318Z/agent_outputs/direct_judge.json` (`932ec9c312c1b2a28a02195e8471c8eb8c87b5f83dbc70a9b60ec36d7a433378`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T051318Z/agent_outputs/roundtrip_judge.json` (`a4667e4ecf2b5ee74fe6954f125302da67eef36006fd9f21d157a434755cef8a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T051318Z/agent_outputs/source_contract.json` (`6d8853ee75df275a5d7ae8109f791c4ba8bf4f55d38f3b84f996018392ff9bf8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T051318Z/decision.json` (`4fc4d173981059294a22cad4b3be8f5cef6bf0eec96fdbbfc73e63dfd385d145`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T051318Z/inputs/batch_source_locator.json` (`9405f0035dbf82d88a8727e77c8be0db654610058409721fa3dc3d03d0cb49b7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T051318Z/inputs/blind_dependency_inventory.json` (`07320088d030e6cc4aedcaa9c056da0528ffae9dc7a7c3f8d3470f64d7b91581`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T051318Z/inputs/blind_dossier.md` (`75a3510875a964c30fd4005bb12c7bcc8f1b4710295fa256f130a38d79a74f8f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T051318Z/inputs/blind_review_packet.md` (`75a3510875a964c30fd4005bb12c7bcc8f1b4710295fa256f130a38d79a74f8f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T051318Z/inputs/declaration_dossier.md` (`b4c864a27c8000b3e6ac440580f96837a854761b9d6f1907a8a0c4e5188fa782`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T051318Z/inputs/dependency_inventory.json` (`86e86a6c6d961e86d3db120adf5b8a563d8f9bbe9bcd73f9eef5d3914eb0593f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T051318Z/inputs/direct_review_packet.md` (`080d1d793122181edefad494d14b04606b9017e10117be78ab66f07581f02be5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T051318Z/inputs/source_locator.json` (`55ea0585409b07c67b73fe95281eef526709b877a200c7aab52ea35eec33ab91`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T083445Z/agent_outputs/agent_runs.json` (`98dd5205fc676258c63b87cb39a99d05550a54da19094824900c6b41cfa6f198`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T083445Z/agent_outputs/batch_source_contract.json` (`941033b94d4edcfd5a9ea42fdf0abe2a54d3a1d57a28f812a846762718114eee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T083445Z/agent_outputs/blind_translation.json` (`992447599be60aefdf75f08c50d5a8a3bb23e97d4e813deb1a142e654fa3a02c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T083445Z/agent_outputs/direct_judge.json` (`932ec9c312c1b2a28a02195e8471c8eb8c87b5f83dbc70a9b60ec36d7a433378`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T083445Z/agent_outputs/roundtrip_judge.json` (`a4667e4ecf2b5ee74fe6954f125302da67eef36006fd9f21d157a434755cef8a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T083445Z/agent_outputs/source_contract.json` (`6d8853ee75df275a5d7ae8109f791c4ba8bf4f55d38f3b84f996018392ff9bf8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T083445Z/decision.json` (`9cea2d79315e1611c0a35c5ac255dc64cf5e2be5954c1b5b335c561885da22a3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T083445Z/inputs/batch_source_locator.json` (`9405f0035dbf82d88a8727e77c8be0db654610058409721fa3dc3d03d0cb49b7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T083445Z/inputs/blind_dependency_inventory.json` (`07320088d030e6cc4aedcaa9c056da0528ffae9dc7a7c3f8d3470f64d7b91581`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T083445Z/inputs/blind_dossier.md` (`75a3510875a964c30fd4005bb12c7bcc8f1b4710295fa256f130a38d79a74f8f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T083445Z/inputs/blind_review_packet.md` (`75a3510875a964c30fd4005bb12c7bcc8f1b4710295fa256f130a38d79a74f8f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T083445Z/inputs/declaration_dossier.md` (`b4c864a27c8000b3e6ac440580f96837a854761b9d6f1907a8a0c4e5188fa782`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T083445Z/inputs/dependency_inventory.json` (`86e86a6c6d961e86d3db120adf5b8a563d8f9bbe9bcd73f9eef5d3914eb0593f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T083445Z/inputs/direct_review_packet.md` (`080d1d793122181edefad494d14b04606b9017e10117be78ab66f07581f02be5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T083445Z/inputs/source_locator.json` (`55ea0585409b07c67b73fe95281eef526709b877a200c7aab52ea35eec33ab91`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T101115Z/agent_outputs/agent_runs.json` (`5bb5b13f11ebb00e53809e72394509b2446cc9245d859c949c03a28ea70c305b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T101115Z/agent_outputs/batch_source_contract.json` (`941033b94d4edcfd5a9ea42fdf0abe2a54d3a1d57a28f812a846762718114eee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T101115Z/agent_outputs/blind_translation.json` (`992447599be60aefdf75f08c50d5a8a3bb23e97d4e813deb1a142e654fa3a02c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T101115Z/agent_outputs/direct_judge.json` (`932ec9c312c1b2a28a02195e8471c8eb8c87b5f83dbc70a9b60ec36d7a433378`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T101115Z/agent_outputs/roundtrip_judge.json` (`a4667e4ecf2b5ee74fe6954f125302da67eef36006fd9f21d157a434755cef8a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T101115Z/agent_outputs/source_contract.json` (`6d8853ee75df275a5d7ae8109f791c4ba8bf4f55d38f3b84f996018392ff9bf8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T101115Z/decision.json` (`73273374b22d9da41e3a9a600ce2679734cc8eaefdc70713dcf1d0f7d766c849`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T101115Z/inputs/blind_dependency_inventory.json` (`07320088d030e6cc4aedcaa9c056da0528ffae9dc7a7c3f8d3470f64d7b91581`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T101115Z/inputs/blind_dossier.md` (`75a3510875a964c30fd4005bb12c7bcc8f1b4710295fa256f130a38d79a74f8f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T101115Z/inputs/blind_review_packet.md` (`75a3510875a964c30fd4005bb12c7bcc8f1b4710295fa256f130a38d79a74f8f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T101115Z/inputs/declaration_dossier.md` (`b4c864a27c8000b3e6ac440580f96837a854761b9d6f1907a8a0c4e5188fa782`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T101115Z/inputs/dependency_inventory.json` (`86e86a6c6d961e86d3db120adf5b8a563d8f9bbe9bcd73f9eef5d3914eb0593f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T101115Z/inputs/direct_review_packet.md` (`080d1d793122181edefad494d14b04606b9017e10117be78ab66f07581f02be5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T101115Z/inputs/source_locator.json` (`55ea0585409b07c67b73fe95281eef526709b877a200c7aab52ea35eec33ab91`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T203815Z/agent_outputs/agent_runs.json` (`5bb5b13f11ebb00e53809e72394509b2446cc9245d859c949c03a28ea70c305b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T203815Z/agent_outputs/batch_source_contract.json` (`941033b94d4edcfd5a9ea42fdf0abe2a54d3a1d57a28f812a846762718114eee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T203815Z/agent_outputs/blind_translation.json` (`992447599be60aefdf75f08c50d5a8a3bb23e97d4e813deb1a142e654fa3a02c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T203815Z/agent_outputs/direct_judge.json` (`932ec9c312c1b2a28a02195e8471c8eb8c87b5f83dbc70a9b60ec36d7a433378`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T203815Z/agent_outputs/roundtrip_judge.json` (`a4667e4ecf2b5ee74fe6954f125302da67eef36006fd9f21d157a434755cef8a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T203815Z/agent_outputs/source_contract.json` (`6d8853ee75df275a5d7ae8109f791c4ba8bf4f55d38f3b84f996018392ff9bf8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T203815Z/decision.json` (`e18fc9e0a34e6c88047a168d8e87cbb4704c56f5547d877c62c92ce883ca66f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T203815Z/inputs/blind_dependency_inventory.json` (`07320088d030e6cc4aedcaa9c056da0528ffae9dc7a7c3f8d3470f64d7b91581`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T203815Z/inputs/blind_dossier.md` (`75a3510875a964c30fd4005bb12c7bcc8f1b4710295fa256f130a38d79a74f8f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T203815Z/inputs/blind_review_packet.md` (`75a3510875a964c30fd4005bb12c7bcc8f1b4710295fa256f130a38d79a74f8f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T203815Z/inputs/declaration_dossier.md` (`91fac5b9ae45eada180f4522884aa86fa92f435383f34443326dd2c99b6941d4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T203815Z/inputs/dependency_inventory.json` (`86e86a6c6d961e86d3db120adf5b8a563d8f9bbe9bcd73f9eef5d3914eb0593f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T203815Z/inputs/direct_review_packet.md` (`080d1d793122181edefad494d14b04606b9017e10117be78ab66f07581f02be5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/history/20260831T203815Z/inputs/source_locator.json` (`55ea0585409b07c67b73fe95281eef526709b877a200c7aab52ea35eec33ab91`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/inputs/blind_dependency_inventory.json` (`07320088d030e6cc4aedcaa9c056da0528ffae9dc7a7c3f8d3470f64d7b91581`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/inputs/blind_dossier.md` (`75a3510875a964c30fd4005bb12c7bcc8f1b4710295fa256f130a38d79a74f8f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/inputs/blind_review_packet.md` (`75a3510875a964c30fd4005bb12c7bcc8f1b4710295fa256f130a38d79a74f8f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/inputs/declaration_dossier.md` (`91fac5b9ae45eada180f4522884aa86fa92f435383f34443326dd2c99b6941d4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/inputs/dependency_inventory.json` (`86e86a6c6d961e86d3db120adf5b8a563d8f9bbe9bcd73f9eef5d3914eb0593f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/inputs/direct_review_packet.md` (`080d1d793122181edefad494d14b04606b9017e10117be78ab66f07581f02be5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.15/faithfulness/inputs/source_locator.json` (`55ea0585409b07c67b73fe95281eef526709b877a200c7aab52ea35eec33ab91`)
