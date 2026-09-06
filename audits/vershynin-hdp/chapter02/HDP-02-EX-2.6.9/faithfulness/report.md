# Faithfulness audit: HDP-02-EX-2.6.9

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `165ff0c68194afc78dd553f497c33b2f098d1dc5fe76e5d9a6bb8d60614d4070`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The authorized source says to exhibit a sub-gaussian random variable for which centering strictly increases the psi-two norm, with that norm defined by the positive-threshold exponential-moment infimum. The Lean target gives such a closed, satisfiable witness: the two ENNReal Dirac weights form a probability measure; the identity is integrable and has mean -199/200; centering produces atoms -1/200 and 999/200; and the two nonempty, lower-bounded finite-law threshold sets are compared in the required strict direction. D002-D007 and D075-D076 are only scalar/numeral elaboration infrastructure, while D030 and D035 have the exact probability and ordinary expectation meanings needed by the source. Consequently Lean implies the source. The reverse implication fails only because the Lean proposition fixes substantially more witness data than the source requires. That is genuine nonvacuous explicit-witness strength rather than a narrower premise or reduced applicability, so the consistent accepted classification is faithful-stronger.

## Implications

- **Lean implies source:** `yes`. The Lean proposition supplies a concrete Borel probability law with masses 999/1000 at -1 and 1/1000 at 4, the identity real random variable, its genuine expectation -199/200, and a strict inequality from the original psi-two defining infimum to the centered defining infimum. Finite support makes the witness sub-gaussian, so this is an actual counterexample to the coefficient-one centering inequality requested by Exercise 2.6.9.
- **Source implies lean:** `no`. The source asserts only that some sub-gaussian counterexample exists. It neither selects nor entails this particular two-point law, the identity realization on Real, its exact mean, or this fixed pair of infimum formulas.

## Findings

- **note / genuine-explicit-witness-strengthening:** This is genuine nonvacuous strength, not reduced applicability: the closed explicit witness implies the source existence claim, while the source claim does not determine this witness.
- **note / totalized-operator-branches-checked:** Neither the totalized integral nor totalized real sInf supplies an exceptional value; expectation and both infima have their ordinary source meanings.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `unclear` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `82` dependencies (`0` hash-reused); unclear: `D002, D003, D004, D005, D006, D007, D030, D035, D075, D076`.
- Direct judge covered `82` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/agent_outputs/adjudicator.json` (`42f03743568ec4450eb911f3f4ce5a5bcd829b85f7b905abca7f1c7a2d0a8890`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/agent_outputs/agent_runs.json` (`71d6253b589e2d40d8e7747e229194f346411ea708253af40d1048ddf5506a8f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/agent_outputs/batch_source_contract.json` (`79b66a2add0ef827aa4b81883e613f58b1c2d27f6149b59266fdf1eb895fce76`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/agent_outputs/blind_translation.json` (`5547edfa7497af8102e42b29618c1c9ac8e19630f1dbf79b9cd2c4b75569208d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/agent_outputs/direct_judge.json` (`2f872f0c9fbe7f01abcf06752bd19bff90fde9e90440df9ad996323284b1e0c6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/agent_outputs/roundtrip_judge.json` (`c59a067010f4ab1c9dc01192dc2c38bf421f935d965c5191b257fdc1b0336025`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/agent_outputs/source_contract.json` (`f5a7e04db8a0108db1e11cfd9bc548e06a0ac4247c7f1f6b54b747ff630e7d7c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/decision.json` (`47daf024cf633b2b2de55a60be5c6c7ec747dd128941bb29382f905491cffa49`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/history/20260831T204132Z/agent_outputs/adjudicator.json` (`42f03743568ec4450eb911f3f4ce5a5bcd829b85f7b905abca7f1c7a2d0a8890`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/history/20260831T204132Z/agent_outputs/agent_runs.json` (`822a4e5dd719a04d5a459b7030d19f6b4b05633a47d6d07ff291bf2a4429020d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/history/20260831T204132Z/agent_outputs/batch_source_contract.json` (`79b66a2add0ef827aa4b81883e613f58b1c2d27f6149b59266fdf1eb895fce76`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/history/20260831T204132Z/agent_outputs/blind_translation.json` (`5547edfa7497af8102e42b29618c1c9ac8e19630f1dbf79b9cd2c4b75569208d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/history/20260831T204132Z/agent_outputs/direct_judge.json` (`2f872f0c9fbe7f01abcf06752bd19bff90fde9e90440df9ad996323284b1e0c6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/history/20260831T204132Z/agent_outputs/roundtrip_judge.json` (`c59a067010f4ab1c9dc01192dc2c38bf421f935d965c5191b257fdc1b0336025`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/history/20260831T204132Z/agent_outputs/source_contract.json` (`f5a7e04db8a0108db1e11cfd9bc548e06a0ac4247c7f1f6b54b747ff630e7d7c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/history/20260831T204132Z/decision.json` (`cc32e763a954de5acaf5e9f41f2e11689fa5e6bce6cba222d2c866e104c599b0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/history/20260831T204132Z/inputs/batch_source_locator.json` (`a7847f6a89eff39ca15af3e6e3f8db9ee345b736410a12ca6543e3a6005d6607`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/history/20260831T204132Z/inputs/blind_dependency_inventory.json` (`b2eb4368a29d12662e927e5dcd071540849309e396306a697a857db9b93c1898`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/history/20260831T204132Z/inputs/blind_dossier.md` (`898bf41737c9e80cdbd2910759e7af826b7e4c790bb980d29509a3e81fb1d51a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/history/20260831T204132Z/inputs/blind_review_packet.md` (`898bf41737c9e80cdbd2910759e7af826b7e4c790bb980d29509a3e81fb1d51a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/history/20260831T204132Z/inputs/declaration_dossier.md` (`9d55f3c1a6c05cdd69e846db2583ffe7aceb028ac301d5ace4190e1bea473518`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/history/20260831T204132Z/inputs/dependency_inventory.json` (`6deb71d2d84224a1a75a19953d2769e774bbfe6c36980e47a4cc8c4ef8cdbed5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/history/20260831T204132Z/inputs/direct_review_packet.md` (`64180521356e231322e7489115530d639054d2e874288027bdd61181ec360738`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/history/20260831T204132Z/inputs/source_locator.json` (`f2297a20f8fd7c636c7d416aa5ab728c7fd4fbb64f40f6675050669101760944`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/inputs/blind_dependency_inventory.json` (`b2eb4368a29d12662e927e5dcd071540849309e396306a697a857db9b93c1898`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/inputs/blind_dossier.md` (`898bf41737c9e80cdbd2910759e7af826b7e4c790bb980d29509a3e81fb1d51a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/inputs/blind_review_packet.md` (`898bf41737c9e80cdbd2910759e7af826b7e4c790bb980d29509a3e81fb1d51a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/inputs/declaration_dossier.md` (`41a78c833fc8355cf28fa29a42c7bb502bbbf943968e77bc4a32bed4a6f76d7c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/inputs/dependency_inventory.json` (`6deb71d2d84224a1a75a19953d2769e774bbfe6c36980e47a4cc8c4ef8cdbed5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/inputs/direct_review_packet.md` (`64180521356e231322e7489115530d639054d2e874288027bdd61181ec360738`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.9/faithfulness/inputs/source_locator.json` (`f2297a20f8fd7c636c7d416aa5ab728c7fd4fbb64f40f6675050669101760944`)
