# Faithfulness audit: HDP-02-EX-2.6.6

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `1a82a3facbf3bb47c19bfdb8ca31b71e83c82f335660dc43e69a89f55b3898cf`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The target faithfully preserves the inherited nonempty finite family, joint independence, centered unit-variance subgaussian assumptions, arbitrary real coefficients, K=max_i ||X_i||_psi2, the L1 weighted sum, the exact upper constant one, and the zero-coefficient case. Its explicit integrability hypothesis is redundant under its own exponential-square definition of subgaussianity. The universal factor (C(1+K))^(-3) is strictly positive because C>=1 and K is a maximum of nonnegative psi-two norms, and it depends only on K up to the absolute C. That explicit inverse-cubic rate is not entailed by the source's qualitative phrase 'c(K)>0 ... may depend only on K,' although it is consistent with the interpolation hint and is nonvacuously stronger. Hence Lean implies the source, the bare source proposition does not imply the exact Lean target, and the appropriate accepted classification is faithful-stronger without unresolved evidence requiring adjudication.

## Implications

- **Lean implies source:** `yes`. Choose the source's c(K) to be (C(1+K))^(-3). The target asserts this factor is strictly positive, depends only on K because C is absolute and outside all family quantifiers, and gives both required inequalities under the same setting.
- **Source implies lean:** `no`. The source conclusion only requires some positive quantity c(K) depending on K and gives no quantitative lower envelope for that dependence. As a bare proposition it does not entail the existence of one universal C for which c(K) can be taken exactly as (C(1+K))^(-3), even though the supplied hint motivates such an inverse-cubic bound.

## Findings

- **note / explicit-quantitative-strengthening:** The Lean proposition implies the printed claim and supplies a useful polynomial dependence, but the printed conclusion alone does not imply this exact uniform form; this is genuine accepted strength rather than reduced applicability.
- **note / redundant-integrability-premise:** The conjunct is mathematically automatic and therefore does not reduce the source domain.
- **note / explicit quantitative strengthening:** The target is not logically equivalent to the literal source wording, but it entails the full source claim and preserves all of its objects, hypotheses, both inequalities, and uniformity requirements.

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

- Blind translator covered `96` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `96` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.6/faithfulness-current-v1/agent_outputs/agent_runs.json` (`ab502c0027fd92bed672489681d98713e14329d2811adda9869f9813176bfcfa`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.6/faithfulness-current-v1/agent_outputs/blind_translation.json` (`884fa1fbb50245d325a5de455a18d8e157fd360c34c17da2b86e4415a92a3744`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.6/faithfulness-current-v1/agent_outputs/direct_judge.json` (`f1390735d40778d28aa2db302c91aaff34d26aebcbe7f79afa6e0a6c6facc4e9`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.6/faithfulness-current-v1/agent_outputs/roundtrip_judge.json` (`4cdc4d151160572d64e06367def91b950d29fb62801e0612596f3d850a49af05`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.6/faithfulness-current-v1/agent_outputs/source_contract.json` (`819a5bf3a5358c4040ee320beb174341e9eb66742c3fc730881d7c248ec56ec7`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.6/faithfulness-current-v1/decision.json` (`f71c2fe7afe459ca05762678acc4eb7a1f907b5ec2ee0df01a6ab1fc598366f2`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.6/faithfulness-current-v1/inputs/blind_dependency_inventory.json` (`ce6375d638b07aa416e97772f5cc6e9c8fe6ea2723e22d8b8560d84ae7211513`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.6/faithfulness-current-v1/inputs/blind_dossier.md` (`a7e82ba53ab9d823581853a2bffafe35d8c9c0f8f8f754a77bdc0663848f544b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.6/faithfulness-current-v1/inputs/blind_review_packet.md` (`a7e82ba53ab9d823581853a2bffafe35d8c9c0f8f8f754a77bdc0663848f544b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.6/faithfulness-current-v1/inputs/declaration_dossier.md` (`24aecf78eb24659a3e35d5a2e2cd171a6efb8e2ac2c415cf85c4ffcdbdf9da1e`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.6/faithfulness-current-v1/inputs/dependency_inventory.json` (`715809f1549a96cf0a4852db34e9e2801972e386c87d01a8efd1e9c387912f86`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.6/faithfulness-current-v1/inputs/direct_review_packet.md` (`d32d3cda16d0307572aaa70bf60695ebecf1fea2edf6974d8d080245350ffd46`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.6/faithfulness-current-v1/inputs/source_locator.json` (`241e91c89e19007697ed75cab205b8de714c10efcd83ff5679e6daa533011f88`)
