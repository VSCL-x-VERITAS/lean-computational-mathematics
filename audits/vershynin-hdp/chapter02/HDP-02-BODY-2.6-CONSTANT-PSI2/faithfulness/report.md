# Faithfulness audit: HDP-02-BODY-2.6-CONSTANT-PSI2

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `3d6f38713a953df2207431c3e0fd04f3c0173d3395f2b3bf5c40ff7cb0927207`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The selected source passage states that every constant real random variable a has psi-two norm bounded by an absolute constant times |a|. Lean expresses the same claim with a single existential real C outside all probability-space and value binders. Its imported PsiTwoNorm unfolds to the source's infimum over finite positive scales whose exponential-square expectation is at most 2, with measurability and integrability made explicit to avoid totalization artifacts. The condition C >= 1 is a harmless normalization because an absolute upper-bound constant can always be enlarged. Both implication directions therefore hold, including a = 0 and nonvacuity.

## Implications

- **Lean implies source:** `yes`. A Lean witness C >= 1 gives one constant independent of the probability space and a, with ||a||_psi2 <= C|a| for every constant real random variable, which is exactly the source's lesssim assertion.
- **Source implies lean:** `yes`. The source's absolute-constant estimate supplies a uniform positive C0. Enlarging it to max(C0,1) yields the Lean normalization 1 <= C, and the source infimum definition agrees with D001-D003 for constant measurable functions under probability measures.

## Findings

No findings were recorded.

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

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/agent_outputs/agent_runs.json` (`2888f80a640131d1349fb86f9157522cad2e39b0ca208011a776d67496986168`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/agent_outputs/batch_source_contract.json` (`f39337425933b413c25b50ed27a62c61ad4ff30160690d8253beb46cfbbae2d6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/agent_outputs/blind_translation.json` (`834b1b5371bc1dcf628a873f53294290bb42285e328d43f4ab7ad1439fb1969f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/agent_outputs/direct_judge.json` (`c824a1432b87077fc4c1141fb194758e307f50b47c43081ad78145f041ef64ab`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/agent_outputs/roundtrip_judge.json` (`ecdb043aebdc8246e31389ee5b957eafae9bc6763fbee73ddc1bc334be82e041`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/agent_outputs/source_contract.json` (`720baaf23d3d41ee28acb705006455f107ea897e902254829d7e999524e19c69`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/decision.json` (`29587e84b0daa36c429d7c90ff0515810153b12d96a9062ffc76be6cd997d500`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T122129Z/agent_outputs/blind_translation.json` (`285e6df26c7d4e91102254a54e06c39c33429871bc872b7b40c11241c57485b6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T122129Z/agent_outputs/source_contract.json` (`dda9b8df7dbcd07397738a816863fbb59a19f9aad87b0a20bdc9a040fae5ca69`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T122129Z/inputs/batch_source_locator.json` (`7f2db6fa9db963f61f389f38a2325aa2c0deb3b4dd0eb49afb46c30cebed7998`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T122129Z/inputs/blind_dependency_inventory.json` (`9e146646bc4481b588c3360d0791b57d38774bf7ca4164fcc7c7dff466f1b4c0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T122129Z/inputs/blind_dossier.md` (`9c148e0b09d0e43548bd26a5e4714e0884eb5b7bb09c978d6218b8780f8f2dd0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T122129Z/inputs/blind_review_packet.md` (`9c148e0b09d0e43548bd26a5e4714e0884eb5b7bb09c978d6218b8780f8f2dd0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T122129Z/inputs/declaration_dossier.md` (`ba7059a82a6d79f4511c5aa817724df68d17cccd20cae3f910023b1575b7f0c7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T122129Z/inputs/dependency_inventory.json` (`f5eb81598cecb51da6a089cf386f855a2952b7a04bc2ad1192f20c30b305ec55`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T122129Z/inputs/direct_review_packet.md` (`b2cee8ff403a9362a6f6f3d60dc489400c18d82f85a9f90f86107d88a23bab63`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T122129Z/inputs/source_locator.json` (`9adcb3119568c3aeddad8e13c807cda5ebcbd4fea4910b3d3f5b87282604d87b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T203020Z/agent_outputs/agent_runs.json` (`8385f59a9a2799d5a747c340297c485492178a3d19985e785a38593ef007e913`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T203020Z/agent_outputs/batch_source_contract.json` (`f39337425933b413c25b50ed27a62c61ad4ff30160690d8253beb46cfbbae2d6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T203020Z/agent_outputs/blind_translation.json` (`834b1b5371bc1dcf628a873f53294290bb42285e328d43f4ab7ad1439fb1969f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T203020Z/agent_outputs/direct_judge.json` (`c824a1432b87077fc4c1141fb194758e307f50b47c43081ad78145f041ef64ab`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T203020Z/agent_outputs/roundtrip_judge.json` (`ecdb043aebdc8246e31389ee5b957eafae9bc6763fbee73ddc1bc334be82e041`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T203020Z/agent_outputs/source_contract.json` (`720baaf23d3d41ee28acb705006455f107ea897e902254829d7e999524e19c69`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T203020Z/decision.json` (`1f470782be0c2f58062e8894571d5e7dcb20cf57cfc289555baf8399c595c8e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T203020Z/inputs/batch_source_locator.json` (`5481887b165147b610f2d9fc7f1c4b2c3e80d679a81c1ce54462fa6c1d2c500b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T203020Z/inputs/blind_dependency_inventory.json` (`9e146646bc4481b588c3360d0791b57d38774bf7ca4164fcc7c7dff466f1b4c0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T203020Z/inputs/blind_dossier.md` (`9c148e0b09d0e43548bd26a5e4714e0884eb5b7bb09c978d6218b8780f8f2dd0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T203020Z/inputs/blind_review_packet.md` (`9c148e0b09d0e43548bd26a5e4714e0884eb5b7bb09c978d6218b8780f8f2dd0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T203020Z/inputs/declaration_dossier.md` (`ba7059a82a6d79f4511c5aa817724df68d17cccd20cae3f910023b1575b7f0c7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T203020Z/inputs/dependency_inventory.json` (`f5eb81598cecb51da6a089cf386f855a2952b7a04bc2ad1192f20c30b305ec55`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T203020Z/inputs/direct_review_packet.md` (`b2cee8ff403a9362a6f6f3d60dc489400c18d82f85a9f90f86107d88a23bab63`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/history/20260831T203020Z/inputs/source_locator.json` (`93dee4610863f4549ccea24f822f83ff9deee053f45de5e963b439293f0d6452`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/inputs/blind_dependency_inventory.json` (`9e146646bc4481b588c3360d0791b57d38774bf7ca4164fcc7c7dff466f1b4c0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/inputs/blind_dossier.md` (`9c148e0b09d0e43548bd26a5e4714e0884eb5b7bb09c978d6218b8780f8f2dd0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/inputs/blind_review_packet.md` (`9c148e0b09d0e43548bd26a5e4714e0884eb5b7bb09c978d6218b8780f8f2dd0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/inputs/declaration_dossier.md` (`c3e14b95cb59577078dedc9adb0462c8174aae63aba4bc8da6fb44cd96b5335f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/inputs/dependency_inventory.json` (`f5eb81598cecb51da6a089cf386f855a2952b7a04bc2ad1192f20c30b305ec55`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/inputs/direct_review_packet.md` (`b2cee8ff403a9362a6f6f3d60dc489400c18d82f85a9f90f86107d88a23bab63`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.6-CONSTANT-PSI2/faithfulness/inputs/source_locator.json` (`93dee4610863f4549ccea24f822f83ff9deee053f45de5e963b439293f0d6452`)
