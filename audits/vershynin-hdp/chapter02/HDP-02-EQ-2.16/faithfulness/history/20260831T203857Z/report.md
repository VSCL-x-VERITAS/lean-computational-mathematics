# Faithfulness audit: HDP-02-EQ-2.16

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `2620b401c7f6619b349ba32385454afe4ba21c35b08f21ec2098b46126c187a3`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The source PDF hash matches both the locator and source contract, and the current direct dossier hash is recorded above. Direct inspection of printed page 27 confirms the threshold-2 infimum definition of the psi_2 norm, the centered MGF inequality for every real lambda, and the statement that C is positive and absolute. D001-D076 collectively elaborate exactly the expected probability-space, measurability, integrability, expectation, exponential, real arithmetic, and ENNReal-infimum semantics. The fixed Lean coefficient (128e)^2 is positive and universal, so it is a valid witness for the source's unspecified C. Because the source's existential absolute-constant claim does not determine that particular value, the converse implication does not follow. The result is therefore faithful-stronger, accepted, with no unresolved dependency, checklist item, or implication requiring adjudication.

## Implications

- **Lean implies source:** `yes`. Choose the source absolute constant C=(128*exp(1))^2, which is positive and independent of the probability space, X, and lambda. The Lean finite-gauge domain is the source sub-gaussian domain, the centering and expectation semantics match, and the Lean conclusion supplies the required bound for every real lambda.
- **Source implies lean:** `no`. The cited source asserts only that some positive absolute C makes the bound hold. That existential statement does not entail the sharper numerical assertion that the particular coefficient (128*exp(1))^2 suffices, although all nonconstant parts of the Lean proposition match and MGF integrability is implicit in the source's finite bound.

## Findings

- **note / explicit-universal-constant:** This is a nonvacuous quantitative strengthening: Lean implies the source by exhibiting a universal C, but the source statement alone does not imply this specific coefficient.
- **note / fixed-absolute-constant:** This is a genuine nonvacuous strengthening: the fixed-value theorem yields the source claim, but the source statement by itself does not yield that exact numerical bound. It does not reduce applicability.

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

- Blind translator covered `76` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `76` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/agent_outputs/agent_runs.json` (`b1495cfae9f539ba7ffa2c0700046869721936d9628c59eb40492732bf5804b7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/agent_outputs/batch_source_contract.json` (`3be12e92a4bbd1a28a7fba9fd2816e85c7c9fd5a40cc34a462d921e5b11926d0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/agent_outputs/blind_translation.json` (`ad43edbc1858e47a77b9d9bfd0b8d9d2f4ebde315256a277930d65f0795e9d3c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/agent_outputs/direct_judge.json` (`b8cd2d8b0e6d94440d83e071ca3620a896cbd88dabcd050c9ac3192160ea4925`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/agent_outputs/roundtrip_judge.json` (`033fa694fac43f53a23494cad54d7fd7598f9ba31826153d5d837b28edb77390`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/agent_outputs/source_contract.json` (`90de1162e85cec790a03e66291ba660a1e1768eb78fa47c6574f5c9246d4dc09`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/decision.json` (`62cb40135b9a7c12d1ad9838e4dbbcc1d07517004067712f01f88b8994470279`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T051515Z/inputs/batch_source_locator.json` (`07fc3a02c35c2804957f0f5974d7bdc02a5b9a42fb251b0fdd8bf3d0e2d758cd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T051515Z/inputs/blind_dependency_inventory.json` (`e855a0f006f27d30fac09b7c10e18014dfd2d0e59574f2a80ee3704772162eae`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T051515Z/inputs/blind_dossier.md` (`a8b9ea7257940cbe66729259b30cc8ec9e981f7e8db212cd626651da56f33809`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T051515Z/inputs/blind_review_packet.md` (`a8b9ea7257940cbe66729259b30cc8ec9e981f7e8db212cd626651da56f33809`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T051515Z/inputs/declaration_dossier.md` (`c2fbf8b317fbc5f0d2bfd8eaf3f8f803fa981cdb3e0c4c3e3080943e427502f0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T051515Z/inputs/dependency_inventory.json` (`dda2dd92a4615c821bd3459277c54918b085671f0fe105c9be2294fda8f11b82`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T051515Z/inputs/direct_review_packet.md` (`17e5c3f6971a1adad03f62f6b41b236f57169c1961d499c69dbd3c4ac1be06f4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T051515Z/inputs/source_locator.json` (`05646fae9d6cae24e3f3f9fec189256b4f9615cc5ee253027ea3a3b0bb4f3ad9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T083636Z/agent_outputs/agent_runs.json` (`282ce3682df456c4ee3eadf16cd664f8b960490feec4a4ed858dea4dd93f67ef`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T083636Z/agent_outputs/batch_source_contract.json` (`3be12e92a4bbd1a28a7fba9fd2816e85c7c9fd5a40cc34a462d921e5b11926d0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T083636Z/agent_outputs/blind_translation.json` (`ad43edbc1858e47a77b9d9bfd0b8d9d2f4ebde315256a277930d65f0795e9d3c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T083636Z/agent_outputs/direct_judge.json` (`b8cd2d8b0e6d94440d83e071ca3620a896cbd88dabcd050c9ac3192160ea4925`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T083636Z/agent_outputs/roundtrip_judge.json` (`033fa694fac43f53a23494cad54d7fd7598f9ba31826153d5d837b28edb77390`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T083636Z/agent_outputs/source_contract.json` (`90de1162e85cec790a03e66291ba660a1e1768eb78fa47c6574f5c9246d4dc09`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T083636Z/decision.json` (`4736979af0f1519143b5dad4f250f4874f2153796a77a5086a4d0ebeb1c7269b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T083636Z/inputs/batch_source_locator.json` (`b133b000a315709864e467b98383ace5d6b3905d582333c5b25e09597734bca1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T083636Z/inputs/blind_dependency_inventory.json` (`e855a0f006f27d30fac09b7c10e18014dfd2d0e59574f2a80ee3704772162eae`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T083636Z/inputs/blind_dossier.md` (`a8b9ea7257940cbe66729259b30cc8ec9e981f7e8db212cd626651da56f33809`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T083636Z/inputs/blind_review_packet.md` (`a8b9ea7257940cbe66729259b30cc8ec9e981f7e8db212cd626651da56f33809`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T083636Z/inputs/declaration_dossier.md` (`c2fbf8b317fbc5f0d2bfd8eaf3f8f803fa981cdb3e0c4c3e3080943e427502f0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T083636Z/inputs/dependency_inventory.json` (`dda2dd92a4615c821bd3459277c54918b085671f0fe105c9be2294fda8f11b82`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T083636Z/inputs/direct_review_packet.md` (`17e5c3f6971a1adad03f62f6b41b236f57169c1961d499c69dbd3c4ac1be06f4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T083636Z/inputs/source_locator.json` (`05646fae9d6cae24e3f3f9fec189256b4f9615cc5ee253027ea3a3b0bb4f3ad9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T101133Z/agent_outputs/agent_runs.json` (`b1495cfae9f539ba7ffa2c0700046869721936d9628c59eb40492732bf5804b7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T101133Z/agent_outputs/batch_source_contract.json` (`3be12e92a4bbd1a28a7fba9fd2816e85c7c9fd5a40cc34a462d921e5b11926d0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T101133Z/agent_outputs/blind_translation.json` (`ad43edbc1858e47a77b9d9bfd0b8d9d2f4ebde315256a277930d65f0795e9d3c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T101133Z/agent_outputs/direct_judge.json` (`b8cd2d8b0e6d94440d83e071ca3620a896cbd88dabcd050c9ac3192160ea4925`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T101133Z/agent_outputs/roundtrip_judge.json` (`033fa694fac43f53a23494cad54d7fd7598f9ba31826153d5d837b28edb77390`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T101133Z/agent_outputs/source_contract.json` (`90de1162e85cec790a03e66291ba660a1e1768eb78fa47c6574f5c9246d4dc09`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T101133Z/decision.json` (`4b9c29fdbf07b99805efe0f2dadbabbacd3b86bf4c421b474db6e9d2519c1e5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T101133Z/inputs/blind_dependency_inventory.json` (`e855a0f006f27d30fac09b7c10e18014dfd2d0e59574f2a80ee3704772162eae`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T101133Z/inputs/blind_dossier.md` (`a8b9ea7257940cbe66729259b30cc8ec9e981f7e8db212cd626651da56f33809`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T101133Z/inputs/blind_review_packet.md` (`a8b9ea7257940cbe66729259b30cc8ec9e981f7e8db212cd626651da56f33809`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T101133Z/inputs/declaration_dossier.md` (`c2fbf8b317fbc5f0d2bfd8eaf3f8f803fa981cdb3e0c4c3e3080943e427502f0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T101133Z/inputs/dependency_inventory.json` (`dda2dd92a4615c821bd3459277c54918b085671f0fe105c9be2294fda8f11b82`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T101133Z/inputs/direct_review_packet.md` (`17e5c3f6971a1adad03f62f6b41b236f57169c1961d499c69dbd3c4ac1be06f4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/history/20260831T101133Z/inputs/source_locator.json` (`05646fae9d6cae24e3f3f9fec189256b4f9615cc5ee253027ea3a3b0bb4f3ad9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/inputs/blind_dependency_inventory.json` (`e855a0f006f27d30fac09b7c10e18014dfd2d0e59574f2a80ee3704772162eae`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/inputs/blind_dossier.md` (`a8b9ea7257940cbe66729259b30cc8ec9e981f7e8db212cd626651da56f33809`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/inputs/blind_review_packet.md` (`a8b9ea7257940cbe66729259b30cc8ec9e981f7e8db212cd626651da56f33809`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/inputs/declaration_dossier.md` (`b96987588749517d55b7e7be192d50c6b49f43172729d1a7e0ec4fa2d2a15be3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/inputs/dependency_inventory.json` (`dda2dd92a4615c821bd3459277c54918b085671f0fe105c9be2294fda8f11b82`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/inputs/direct_review_packet.md` (`17e5c3f6971a1adad03f62f6b41b236f57169c1961d499c69dbd3c4ac1be06f4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.16/faithfulness/inputs/source_locator.json` (`05646fae9d6cae24e3f3f9fec189256b4f9615cc5ee253027ea3a3b0bb4f3ad9`)
