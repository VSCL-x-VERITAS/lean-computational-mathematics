# Faithfulness audit: HDP-02-REM-2.5.3

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `2620b401c7f6619b349ba32385454afe4ba21c35b08f21ec2098b46126c187a3`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The target is a faithful formal expansion of the remark in its Proposition 2.5.2 context. It changes exactly the tail prefactor and the one-point exponential-square threshold from 2 to an arbitrary fixed A > 1, preserves all other constants and quantifiers, states parameter comparison with a universal factor independent of the random variable, and includes the linear-MGF property only in the centered integrable regime. The apparent strengthening to a single C and a common A is already supported by the source's absolute-factor equivalence for each fixed replacement value and the finite family of property directions.

## Implications

- **Lean implies source:** `yes`. For every fixed A > 1 the Lean statement supplies one universal comparison factor and every ordered implication among properties (i)-(iv), plus property (v) under centering. Since A is inserted only into the tail prefactor and exponential-square threshold, this directly entails that replacing the source's two plain occurrences of 2 by any absolute constant above 1 preserves the sub-gaussian characterization.
- **Source implies lean:** `yes`. Remark 2.5.3, read in Proposition 2.5.2's stated equivalence-and-absolute-factor context, permits each fixed threshold A > 1. The comparison factor may depend on that fixed numerical A, exactly as the Lean quantifier order allows; finitely many property directions can share a maximum factor C >= 1. The same A in the two affected positions is an instance of replacing each occurrence by that allowed constant, while the centered extension retains its original hypothesis.

## Findings

- **note / source-wording-ambiguity:** This is not a faithfulness defect: applying the stated replacement permission to both occurrences gives the shared-A form, and finitely many comparison factors can be combined into one C(A).

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

- Blind translator covered `81` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `81` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/agent_outputs/agent_runs.json` (`36335c73c1390840fad4fc5721d1aad41542ff4ef6a1b6e9add0f2db05ce8fff`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/agent_outputs/blind_translation.json` (`dd5ea5375e7d42e0855e1fc1c11ad47b2f4749a62ad19d30cf7afb658c318245`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/agent_outputs/direct_judge.json` (`eb909b5fd09efe5a5b516703c0ec6c20edeca211d1745f340c0bae7412e89234`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/agent_outputs/roundtrip_judge.json` (`baa912f53d3d1af724fb7508d2ccf7cb425ce07125bc315bf542e854dc63d3f5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/agent_outputs/source_contract.json` (`7ec7b4216ba4a7efb84eb1fb9c9b4bd0b224913c0553a1851feb407f1caa357b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/decision.json` (`c6ce4262ace90b9d261f5f5027df3edbec8335545434675e068943415ae6c168`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T125810Z/inputs/blind_dependency_inventory.json` (`e9a4d4dc00713f7fb3ab87e89b5ca0a8583a6455b9a410347eeb74d37ea57cc5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T125810Z/inputs/blind_dossier.md` (`646e5bc6b8b019008dceacde9ed85d8d77e0974c5461fc1ae3dcbcb569cb8d61`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T125810Z/inputs/blind_review_packet.md` (`646e5bc6b8b019008dceacde9ed85d8d77e0974c5461fc1ae3dcbcb569cb8d61`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T125810Z/inputs/declaration_dossier.md` (`baa903e8c8498fd57a7fdeb379b2a947dc9a7a01ed73f01bae18e376cda2a16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T125810Z/inputs/dependency_inventory.json` (`70eeaecfee49a3c5c68905e6f651d70a0daa498803bc8620e4891a2ea3f92efd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T125810Z/inputs/direct_review_packet.md` (`8af58b3ba75671297798e7f3e3537e3bf27c37133cdf1fa41fdd080ef614e21f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T125810Z/inputs/source_locator.json` (`d1287714f86cfdd1df593cf2b4a1553e1d971105e71adc82f9b21a84dcab42e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T131800Z/agent_outputs/agent_runs.json` (`44d4fd62f4c33a8aacedef9e72b1e07983437ddab270d433f5d556004c29844d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T131800Z/agent_outputs/blind_translation.json` (`12101114e4943868cd74fadf5546da8d83a18e99602c5e982deb1dd66ae176ae`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T131800Z/agent_outputs/direct_judge.json` (`35533ebd5ab9ae81f754e3f9ee90586355b6ee42341e106c4b25b58acbb2a2d9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T131800Z/agent_outputs/roundtrip_judge.json` (`126a687e989afef86f768c4cd0b3156aa9a17180c54e743a189a8b2812a8221a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T131800Z/agent_outputs/source_contract.json` (`7af013d2536177f6d2f050c34f1a83db5f1e666d140decdf9a68380fea1bf74a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T131800Z/decision.json` (`65532b4655aeab32aefa7ea9e577228ddf31e3823ba4b26aa9271254e7e94ad2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T131800Z/inputs/blind_dependency_inventory.json` (`e9a4d4dc00713f7fb3ab87e89b5ca0a8583a6455b9a410347eeb74d37ea57cc5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T131800Z/inputs/blind_dossier.md` (`646e5bc6b8b019008dceacde9ed85d8d77e0974c5461fc1ae3dcbcb569cb8d61`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T131800Z/inputs/blind_review_packet.md` (`646e5bc6b8b019008dceacde9ed85d8d77e0974c5461fc1ae3dcbcb569cb8d61`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T131800Z/inputs/declaration_dossier.md` (`baa903e8c8498fd57a7fdeb379b2a947dc9a7a01ed73f01bae18e376cda2a16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T131800Z/inputs/dependency_inventory.json` (`70eeaecfee49a3c5c68905e6f651d70a0daa498803bc8620e4891a2ea3f92efd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T131800Z/inputs/direct_review_packet.md` (`8af58b3ba75671297798e7f3e3537e3bf27c37133cdf1fa41fdd080ef614e21f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T131800Z/inputs/source_locator.json` (`d1287714f86cfdd1df593cf2b4a1553e1d971105e71adc82f9b21a84dcab42e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T145455Z/agent_outputs/agent_runs.json` (`3011f89eaa85d3b733383826a072fe91564e939991b4db0579ee12541545d2f9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T145455Z/agent_outputs/blind_translation.json` (`dd5ea5375e7d42e0855e1fc1c11ad47b2f4749a62ad19d30cf7afb658c318245`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T145455Z/agent_outputs/direct_judge.json` (`eb909b5fd09efe5a5b516703c0ec6c20edeca211d1745f340c0bae7412e89234`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T145455Z/agent_outputs/roundtrip_judge.json` (`baa912f53d3d1af724fb7508d2ccf7cb425ce07125bc315bf542e854dc63d3f5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T145455Z/agent_outputs/source_contract.json` (`7ec7b4216ba4a7efb84eb1fb9c9b4bd0b224913c0553a1851feb407f1caa357b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T145455Z/decision.json` (`2540c9e4aab2db7a0d50b35f11d688bf95f4548486782bcfad07d51549fc2903`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T145455Z/inputs/blind_dependency_inventory.json` (`d1ad16286dab6e7995c3f419e1437518995f2aa7dd369419a4cc3c5a8e08d2e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T145455Z/inputs/blind_dossier.md` (`06574ea3fef958891b772aadfd627ca939dfca9584d812d31890467eb23791df`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T145455Z/inputs/blind_review_packet.md` (`06574ea3fef958891b772aadfd627ca939dfca9584d812d31890467eb23791df`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T145455Z/inputs/declaration_dossier.md` (`11da649fcc3cace9b9b354e47c65cbf8126c60ec4397073bb2e404a92cbf3729`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T145455Z/inputs/dependency_inventory.json` (`5e40181651a329fafb13eab9e70d0a26969851777a43f48cda18f88d2a0db97a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T145455Z/inputs/direct_review_packet.md` (`edfa86a9292b9eb4fa96e79accaef5d5ca426fe4ce7ea0d538b722f4086511a1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T145455Z/inputs/source_locator.json` (`d1287714f86cfdd1df593cf2b4a1553e1d971105e71adc82f9b21a84dcab42e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T153414Z/agent_outputs/agent_runs.json` (`3011f89eaa85d3b733383826a072fe91564e939991b4db0579ee12541545d2f9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T153414Z/agent_outputs/blind_translation.json` (`dd5ea5375e7d42e0855e1fc1c11ad47b2f4749a62ad19d30cf7afb658c318245`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T153414Z/agent_outputs/direct_judge.json` (`eb909b5fd09efe5a5b516703c0ec6c20edeca211d1745f340c0bae7412e89234`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T153414Z/agent_outputs/roundtrip_judge.json` (`baa912f53d3d1af724fb7508d2ccf7cb425ce07125bc315bf542e854dc63d3f5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T153414Z/agent_outputs/source_contract.json` (`7ec7b4216ba4a7efb84eb1fb9c9b4bd0b224913c0553a1851feb407f1caa357b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T153414Z/decision.json` (`5dd42fba0a972db000d6705a6df7a8b181900152d2725d4c129c5d0b37ce9c89`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T153414Z/inputs/blind_dependency_inventory.json` (`d1ad16286dab6e7995c3f419e1437518995f2aa7dd369419a4cc3c5a8e08d2e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T153414Z/inputs/blind_dossier.md` (`06574ea3fef958891b772aadfd627ca939dfca9584d812d31890467eb23791df`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T153414Z/inputs/blind_review_packet.md` (`06574ea3fef958891b772aadfd627ca939dfca9584d812d31890467eb23791df`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T153414Z/inputs/declaration_dossier.md` (`11da649fcc3cace9b9b354e47c65cbf8126c60ec4397073bb2e404a92cbf3729`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T153414Z/inputs/dependency_inventory.json` (`5e40181651a329fafb13eab9e70d0a26969851777a43f48cda18f88d2a0db97a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T153414Z/inputs/direct_review_packet.md` (`edfa86a9292b9eb4fa96e79accaef5d5ca426fe4ce7ea0d538b722f4086511a1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260830T153414Z/inputs/source_locator.json` (`d1287714f86cfdd1df593cf2b4a1553e1d971105e71adc82f9b21a84dcab42e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T085514Z/agent_outputs/agent_runs.json` (`3011f89eaa85d3b733383826a072fe91564e939991b4db0579ee12541545d2f9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T085514Z/agent_outputs/blind_translation.json` (`dd5ea5375e7d42e0855e1fc1c11ad47b2f4749a62ad19d30cf7afb658c318245`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T085514Z/agent_outputs/direct_judge.json` (`eb909b5fd09efe5a5b516703c0ec6c20edeca211d1745f340c0bae7412e89234`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T085514Z/agent_outputs/roundtrip_judge.json` (`baa912f53d3d1af724fb7508d2ccf7cb425ce07125bc315bf542e854dc63d3f5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T085514Z/agent_outputs/source_contract.json` (`7ec7b4216ba4a7efb84eb1fb9c9b4bd0b224913c0553a1851feb407f1caa357b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T085514Z/decision.json` (`62c69441c82500cad9774a299d8c61f448afe07ba84cebb9d9f7c43f9b5d277f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T085514Z/inputs/blind_dependency_inventory.json` (`d1ad16286dab6e7995c3f419e1437518995f2aa7dd369419a4cc3c5a8e08d2e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T085514Z/inputs/blind_dossier.md` (`06574ea3fef958891b772aadfd627ca939dfca9584d812d31890467eb23791df`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T085514Z/inputs/blind_review_packet.md` (`06574ea3fef958891b772aadfd627ca939dfca9584d812d31890467eb23791df`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T085514Z/inputs/declaration_dossier.md` (`11da649fcc3cace9b9b354e47c65cbf8126c60ec4397073bb2e404a92cbf3729`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T085514Z/inputs/dependency_inventory.json` (`5e40181651a329fafb13eab9e70d0a26969851777a43f48cda18f88d2a0db97a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T085514Z/inputs/direct_review_packet.md` (`edfa86a9292b9eb4fa96e79accaef5d5ca426fe4ce7ea0d538b722f4086511a1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T085514Z/inputs/source_locator.json` (`d1287714f86cfdd1df593cf2b4a1553e1d971105e71adc82f9b21a84dcab42e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T101840Z/agent_outputs/agent_runs.json` (`36335c73c1390840fad4fc5721d1aad41542ff4ef6a1b6e9add0f2db05ce8fff`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T101840Z/agent_outputs/blind_translation.json` (`dd5ea5375e7d42e0855e1fc1c11ad47b2f4749a62ad19d30cf7afb658c318245`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T101840Z/agent_outputs/direct_judge.json` (`eb909b5fd09efe5a5b516703c0ec6c20edeca211d1745f340c0bae7412e89234`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T101840Z/agent_outputs/roundtrip_judge.json` (`baa912f53d3d1af724fb7508d2ccf7cb425ce07125bc315bf542e854dc63d3f5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T101840Z/agent_outputs/source_contract.json` (`7ec7b4216ba4a7efb84eb1fb9c9b4bd0b224913c0553a1851feb407f1caa357b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T101840Z/decision.json` (`38e661eec5724e1a400806e184a14fbdc64d4005792776da500c7e1612590313`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T101840Z/inputs/blind_dependency_inventory.json` (`d1ad16286dab6e7995c3f419e1437518995f2aa7dd369419a4cc3c5a8e08d2e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T101840Z/inputs/blind_dossier.md` (`06574ea3fef958891b772aadfd627ca939dfca9584d812d31890467eb23791df`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T101840Z/inputs/blind_review_packet.md` (`06574ea3fef958891b772aadfd627ca939dfca9584d812d31890467eb23791df`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T101840Z/inputs/declaration_dossier.md` (`11da649fcc3cace9b9b354e47c65cbf8126c60ec4397073bb2e404a92cbf3729`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T101840Z/inputs/dependency_inventory.json` (`5e40181651a329fafb13eab9e70d0a26969851777a43f48cda18f88d2a0db97a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T101840Z/inputs/direct_review_packet.md` (`edfa86a9292b9eb4fa96e79accaef5d5ca426fe4ce7ea0d538b722f4086511a1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/history/20260831T101840Z/inputs/source_locator.json` (`d1287714f86cfdd1df593cf2b4a1553e1d971105e71adc82f9b21a84dcab42e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/inputs/blind_dependency_inventory.json` (`d1ad16286dab6e7995c3f419e1437518995f2aa7dd369419a4cc3c5a8e08d2e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/inputs/blind_dossier.md` (`06574ea3fef958891b772aadfd627ca939dfca9584d812d31890467eb23791df`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/inputs/blind_review_packet.md` (`06574ea3fef958891b772aadfd627ca939dfca9584d812d31890467eb23791df`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/inputs/declaration_dossier.md` (`4f54fadb652902f0e211419a88258bf5e63e3b32c2863ac9259ddf58178b3b70`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/inputs/dependency_inventory.json` (`5e40181651a329fafb13eab9e70d0a26969851777a43f48cda18f88d2a0db97a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/inputs/direct_review_packet.md` (`edfa86a9292b9eb4fa96e79accaef5d5ca426fe4ce7ea0d538b722f4086511a1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-REM-2.5.3/faithfulness/inputs/source_locator.json` (`d1287714f86cfdd1df593cf2b4a1553e1d971105e71adc82f9b21a84dcab42e4`)
