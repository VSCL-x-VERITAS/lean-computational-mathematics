# Faithfulness audit: HDP-02-EX-2.5.9

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `57ec4542daa3fa5960cc437b322e9febd86e8a15a586645b030e374926efac0a`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The repaired target directly implements the source's Definition 2.5.6 via the equivalent exponential-square criterion: PsiTwoGauge is the extended infimum of finite positive scales t for which E exp(X²/t²)≤2, with explicit measurability and integrability preventing formal default-value artifacts. Its four conjuncts represent the Poisson, exponential, Pareto, and Cauchy laws correctly and exclude only degenerate/nonconventional endpoints. The printed exercise leaves all family parameters and their quantifier scope implicit. Universally covering every conventional nondegenerate member is therefore stronger than the literal unquantified text, but it is faithful, satisfiable, and nonvacuous. Accordingly Lean implies the source, the source does not imply the full universal Lean target, and the accepted classification is faithful-stronger.

## Implications

- **Lean implies source:** `yes`. The Lean proposition proves non-sub-gaussianity, through the exact criterion-(iv) gauge, for every conventional nondegenerate member of each of the four families. It therefore entails each family-level claim in Exercise 2.5.9 under every ordinary reading of the source's implicit family names.
- **Source implies lean:** `no`. The printed exercise supplies no parameter binders or universal quantifier. Its four bare family names do not by themselves entail the repaired target's simultaneous theorem for every positive intensity/rate, every positive Pareto shape and scale, and every Cauchy location and positive scale. The universal parameter coverage is additional substantive information.

## Findings

- **note / explicit-universal-family-coverage:** This is a nonvacuous strengthening: Lean implies the source, but the unquantified printed claim does not imply the full universal parameterized target.
- **note / nondegenerate-boundary-convention:** The positivity conditions faithfully select conventional nondegenerate family members and prevent a false or boundary-driven universal claim; they do not create reduced applicability relative to that conventional domain.
- **note / explicit universal family coverage:** This is a genuine, satisfiable strengthening that preserves and implies every source conclusion, so it is accepted as faithful-stronger rather than treated as reduced applicability.
- **note / nondegenerate endpoint convention:** The exclusion makes the universal reading mathematically sound; in particular it avoids the sub-gaussian constant law at Poisson intensity zero and does not omit any conventional nondegenerate case.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `fail` |
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

- Blind translator covered `88` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `88` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/agent_outputs/agent_runs.json` (`d774fbd7b3970fce3d05ce54ce468bd28f766bf6f9293ffdb83ebc7d09c3ac31`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/agent_outputs/blind_translation.json` (`209b111a803502d33054507a5e494646e9b43bdeb8ef8ade04b7025d431e5538`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/agent_outputs/direct_judge.json` (`93188b187b49ecf7c44dfad89ea74eb2cb749478d760d904d7dec21d0984aadc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/agent_outputs/roundtrip_judge.json` (`3159163f9522817fdec1295790df484c5c6efe11f2a7d2425faea2552710edb1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/agent_outputs/source_contract.json` (`611a0979e9f7f12e23907397e71a6be28b5bdac9208a417f64c8d7169943fc18`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/decision.json` (`f601b97ad221a53fe979a1f1ed12f6a2fd496391e307e805c938d90ceb05cd02`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T065132Z/agent_outputs/adjudicator.json` (`11df181f4c81c9b6cdad0c85b09236bb7cde9b93b447c54a6feb21ce9173e358`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T065132Z/agent_outputs/agent_runs.json` (`09712b4c5456913866219b2b800ee83d447ff52d9101bc7e0a7cc33637ae3525`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T065132Z/agent_outputs/blind_translation.json` (`8db83c3d7543cab6f7def76c23eba00f1da88bed42f1f58a7ef7dda4f876c4cb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T065132Z/agent_outputs/direct_judge.json` (`87f730fca560833eb3da759079edf461b74d626d8a612addd4a8e742672e7948`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T065132Z/agent_outputs/roundtrip_judge.json` (`de9f7849580b58229cd4f12a26b4ec65d0b2615e1a75085ecdb45bf931e163f2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T065132Z/agent_outputs/source_contract.json` (`611a0979e9f7f12e23907397e71a6be28b5bdac9208a417f64c8d7169943fc18`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T065132Z/decision.json` (`01f23e49dd1eba09d8104975420782f97877da50a74ec6839fc298b7046a318e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T065132Z/inputs/blind_dependency_inventory.json` (`4e971d09dd4c7d47046ab76735c206d26117d5c39906ab2ec3ada120d3faa957`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T065132Z/inputs/blind_dossier.md` (`d2137e4c118e25765158d78fa3b7348bc3a6d25f35933d29a03ed112b34bde7b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T065132Z/inputs/blind_review_packet.md` (`d2137e4c118e25765158d78fa3b7348bc3a6d25f35933d29a03ed112b34bde7b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T065132Z/inputs/declaration_dossier.md` (`3668acdb31c1e1000f054982fe6f3fb2062fd57c648763c1836d17c19d0305d9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T065132Z/inputs/dependency_inventory.json` (`57996185bfdc2b3deb3f58021a51679a4c9438c30e96fa6354077f8645662361`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T065132Z/inputs/direct_review_packet.md` (`4ddebf283989badf02017a637a99c3add4f56028661c740fe9aeb6149945bd27`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T065132Z/inputs/source_locator.json` (`0fe579db92ab43658b8caaa677dfa5cdbf33f25fcd98fc512ad0be19978322c1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T084856Z/agent_outputs/agent_runs.json` (`a79add193588e1fda388772455ef02b9be0e8a2882638591a9b4916d39f9c80a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T084856Z/agent_outputs/blind_translation.json` (`209b111a803502d33054507a5e494646e9b43bdeb8ef8ade04b7025d431e5538`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T084856Z/agent_outputs/direct_judge.json` (`93188b187b49ecf7c44dfad89ea74eb2cb749478d760d904d7dec21d0984aadc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T084856Z/agent_outputs/roundtrip_judge.json` (`3159163f9522817fdec1295790df484c5c6efe11f2a7d2425faea2552710edb1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T084856Z/agent_outputs/source_contract.json` (`611a0979e9f7f12e23907397e71a6be28b5bdac9208a417f64c8d7169943fc18`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T084856Z/decision.json` (`f29634c904aa07c6da1cedeeac6b4679823cc02105a644f7201781fee6c1feb1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T084856Z/inputs/blind_dependency_inventory.json` (`a362ef867a116db250d555cc27237f1a5e9b7253173a18453de755c0f4afca2a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T084856Z/inputs/blind_dossier.md` (`f7e056b3a8c7fcf5e7b3f97e57f06ef5227a80ed10afa9c3b9222f446601ac02`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T084856Z/inputs/blind_review_packet.md` (`f7e056b3a8c7fcf5e7b3f97e57f06ef5227a80ed10afa9c3b9222f446601ac02`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T084856Z/inputs/declaration_dossier.md` (`81566048fef4b9c32576236dc40f09a4be1d1f98418f7c3bd610cfc1f8b67cca`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T084856Z/inputs/dependency_inventory.json` (`90dba2b1b5be0aa045fa7d569f65a2d2b3885cf6709edd7580bed1b643fd98cf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T084856Z/inputs/direct_review_packet.md` (`7a110e573ae1439332ed06021e235db3b646c107dcda81dd4ef7b426a6ae69bb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T084856Z/inputs/source_locator.json` (`0fe579db92ab43658b8caaa677dfa5cdbf33f25fcd98fc512ad0be19978322c1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T101818Z/agent_outputs/agent_runs.json` (`d774fbd7b3970fce3d05ce54ce468bd28f766bf6f9293ffdb83ebc7d09c3ac31`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T101818Z/agent_outputs/blind_translation.json` (`209b111a803502d33054507a5e494646e9b43bdeb8ef8ade04b7025d431e5538`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T101818Z/agent_outputs/direct_judge.json` (`93188b187b49ecf7c44dfad89ea74eb2cb749478d760d904d7dec21d0984aadc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T101818Z/agent_outputs/roundtrip_judge.json` (`3159163f9522817fdec1295790df484c5c6efe11f2a7d2425faea2552710edb1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T101818Z/agent_outputs/source_contract.json` (`611a0979e9f7f12e23907397e71a6be28b5bdac9208a417f64c8d7169943fc18`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T101818Z/decision.json` (`29d3a838aa0707aa825a6dec894182d91105efddf4d967a9fec58878cb5201d8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T101818Z/inputs/blind_dependency_inventory.json` (`a362ef867a116db250d555cc27237f1a5e9b7253173a18453de755c0f4afca2a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T101818Z/inputs/blind_dossier.md` (`f7e056b3a8c7fcf5e7b3f97e57f06ef5227a80ed10afa9c3b9222f446601ac02`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T101818Z/inputs/blind_review_packet.md` (`f7e056b3a8c7fcf5e7b3f97e57f06ef5227a80ed10afa9c3b9222f446601ac02`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T101818Z/inputs/declaration_dossier.md` (`4b25d8493e5f0092b39bce85aa132caa738183cdbf353ce42e3a427c58cd9376`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T101818Z/inputs/dependency_inventory.json` (`90dba2b1b5be0aa045fa7d569f65a2d2b3885cf6709edd7580bed1b643fd98cf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T101818Z/inputs/direct_review_packet.md` (`7a110e573ae1439332ed06021e235db3b646c107dcda81dd4ef7b426a6ae69bb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T101818Z/inputs/source_locator.json` (`0fe579db92ab43658b8caaa677dfa5cdbf33f25fcd98fc512ad0be19978322c1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T204040Z/agent_outputs/agent_runs.json` (`d774fbd7b3970fce3d05ce54ce468bd28f766bf6f9293ffdb83ebc7d09c3ac31`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T204040Z/agent_outputs/blind_translation.json` (`209b111a803502d33054507a5e494646e9b43bdeb8ef8ade04b7025d431e5538`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T204040Z/agent_outputs/direct_judge.json` (`93188b187b49ecf7c44dfad89ea74eb2cb749478d760d904d7dec21d0984aadc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T204040Z/agent_outputs/roundtrip_judge.json` (`3159163f9522817fdec1295790df484c5c6efe11f2a7d2425faea2552710edb1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T204040Z/agent_outputs/source_contract.json` (`611a0979e9f7f12e23907397e71a6be28b5bdac9208a417f64c8d7169943fc18`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T204040Z/decision.json` (`2ba7ff2c0321b858a47374eb17e58df3d3d5726380a5b91ce411c50a2bae3ee3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T204040Z/inputs/blind_dependency_inventory.json` (`a362ef867a116db250d555cc27237f1a5e9b7253173a18453de755c0f4afca2a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T204040Z/inputs/blind_dossier.md` (`f7e056b3a8c7fcf5e7b3f97e57f06ef5227a80ed10afa9c3b9222f446601ac02`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T204040Z/inputs/blind_review_packet.md` (`f7e056b3a8c7fcf5e7b3f97e57f06ef5227a80ed10afa9c3b9222f446601ac02`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T204040Z/inputs/declaration_dossier.md` (`f9b3c5da2de60bf9f18cb18e7859add36067d557fc57a9f3b09c2b63ef7b7211`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T204040Z/inputs/dependency_inventory.json` (`90dba2b1b5be0aa045fa7d569f65a2d2b3885cf6709edd7580bed1b643fd98cf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T204040Z/inputs/direct_review_packet.md` (`7a110e573ae1439332ed06021e235db3b646c107dcda81dd4ef7b426a6ae69bb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/history/20260831T204040Z/inputs/source_locator.json` (`0fe579db92ab43658b8caaa677dfa5cdbf33f25fcd98fc512ad0be19978322c1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/inputs/blind_dependency_inventory.json` (`a362ef867a116db250d555cc27237f1a5e9b7253173a18453de755c0f4afca2a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/inputs/blind_dossier.md` (`f7e056b3a8c7fcf5e7b3f97e57f06ef5227a80ed10afa9c3b9222f446601ac02`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/inputs/blind_review_packet.md` (`f7e056b3a8c7fcf5e7b3f97e57f06ef5227a80ed10afa9c3b9222f446601ac02`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/inputs/declaration_dossier.md` (`18fe5fce33a06b53e66ee62d895ec9c87ebaff8aa4064946a351518929e0ddd4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/inputs/dependency_inventory.json` (`90dba2b1b5be0aa045fa7d569f65a2d2b3885cf6709edd7580bed1b643fd98cf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/inputs/direct_review_packet.md` (`7a110e573ae1439332ed06021e235db3b646c107dcda81dd4ef7b426a6ae69bb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.9/faithfulness/inputs/source_locator.json` (`0fe579db92ab43658b8caaa677dfa5cdbf33f25fcd98fc512ad0be19978322c1`)
