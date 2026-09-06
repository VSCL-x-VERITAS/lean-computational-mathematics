# Faithfulness audit: HDP-02-EQ-2.17

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `2620b401c7f6619b349ba32385454afe4ba21c35b08f21ec2098b46126c187a3`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The pinned source says every bounded real random variable is sub-gaussian and satisfies ‖X‖ψ₂ ≤ ‖X‖∞/sqrt(ln 2). The target's D001-D002 definitions reproduce the source's scale infimum, exponential-square integrand, positive-scale domain, expectation threshold 2, and exact constant. IsProbabilityMeasure is exactly μ univ = 1, the guarded Bochner integral is source expectation, and Nat.AtLeastTwo is closed numeral infrastructure. The auxiliary almost-everywhere bound B is equivalent to the infinity-norm formulation at the universally quantified theorem level. Consequently C02, C06, C10, and C12 pass, both implications hold, and the theorem is faithfully equivalent to Equation (2.17).

## Implications

- **Lean implies source:** `yes`. For an essentially bounded random variable, let M be its infinity norm. If M > 0, the universally quantified Lean theorem applies with B = M; if M = 0, applying it for every B > 0 forces the ENNReal gauge to zero. Thus the exact Equation (2.17) bound follows. The resulting finite gauge also rules out an empty admissible-scale set because sInf ∅ = top in ENNReal, yielding the source's sub-gaussianity conclusion.
- **Source implies lean:** `yes`. Given the Lean hypotheses, |X| ≤ B almost everywhere implies ‖X‖∞ ≤ B. The source estimate therefore gives ‖X‖ψ₂ ≤ B/sqrt(ln 2), which is the Lean conclusion under the D001-D002 representation of Equation (2.13). D014 supplies the same probability normalization, D055 is expectation on the explicitly integrable branch, and ENNReal.ofReal preserves the positive finite right-hand side.

## Findings

- **note / auxiliary-bound-reformulation:** This changes presentation but not content: the source estimate implies every B-instance, and the family of Lean instances recovers the exact infinity-norm estimate, including the zero case.
- **note / implicit-subgaussian-conclusion:** No conclusion is lost because a finite upper bound excludes the empty admissible-scale set and hence supplies an admissible exponential-square scale.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `unclear` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `unclear` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `unclear` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `unclear` |

## Dependency coverage

- Blind translator covered `81` dependencies (`0` hash-reused); unclear: `D014, D055, D079`.
- Direct judge covered `81` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/agent_outputs/adjudicator.json` (`ac74c556758b93237f895ec015bf87c43ca3508c84ae92aa8d85964899b993b5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/agent_outputs/agent_runs.json` (`df7bb3904fe28ea00f7bf7179c519dab92cb45ec929e0ced26ba3fdb628cc32b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/agent_outputs/batch_source_contract.json` (`2ca05f4aa8244ab5aa9f42522611c955146f2c905f8be90f878e801b59ad337a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/agent_outputs/blind_translation.json` (`366a5e74f6ac29ad71c41b1827bed606702e6dec9ab1800d6f9d3d1662539aad`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/agent_outputs/direct_judge.json` (`a9540555b637fcb815efcd497910aab8269cc724bedc1f6bdb3acdb7b7c37b8e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/agent_outputs/roundtrip_judge.json` (`ae2db0a64170f84f63f0e49a2b375982f15ff519abb90c3be1bfadb653ab941e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/agent_outputs/source_contract.json` (`a9ee3c795e23928c39961404a1b888cdc069995450505412110ae54e20cc1dad`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/decision.json` (`666b70add8ca896e263f72fbc3bc173c546e31985034b603bf9778914707adfb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T002743Z/inputs/blind_dependency_inventory.json` (`48c234976f2a2d7345d4fd5ee7955ce2cdeb80091294dac56d9526c348203556`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T002743Z/inputs/blind_dossier.md` (`e657454add7b19b6928695cb8d593c37ffb61fabfb6ecd9651afc0a69a241a82`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T002743Z/inputs/blind_review_packet.md` (`e657454add7b19b6928695cb8d593c37ffb61fabfb6ecd9651afc0a69a241a82`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T002743Z/inputs/declaration_dossier.md` (`ff28f4d6133b030ce1f2bebf806bd2f74719822c9d927749e3234c7eaa45eef0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T002743Z/inputs/dependency_inventory.json` (`5566a1927903f5fadd86e12f700ad940e5a5f0910396e1752fa15de0771f2465`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T002743Z/inputs/direct_review_packet.md` (`8701256678780855ebbfbf8b3f152e12623f93edb36fd278533ec76b1c2f1203`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T002743Z/inputs/source_locator.json` (`cabcecacc1c30b719081bfb0c072900d49d44644b1834035291fb69783fce0d0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T083636Z/agent_outputs/adjudicator.json` (`ac74c556758b93237f895ec015bf87c43ca3508c84ae92aa8d85964899b993b5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T083636Z/agent_outputs/agent_runs.json` (`e62319c84aff04ea16fb7a8cfcc94901fb477404b90a12398469aa900211bd13`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T083636Z/agent_outputs/batch_source_contract.json` (`2ca05f4aa8244ab5aa9f42522611c955146f2c905f8be90f878e801b59ad337a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T083636Z/agent_outputs/blind_translation.json` (`366a5e74f6ac29ad71c41b1827bed606702e6dec9ab1800d6f9d3d1662539aad`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T083636Z/agent_outputs/direct_judge.json` (`a9540555b637fcb815efcd497910aab8269cc724bedc1f6bdb3acdb7b7c37b8e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T083636Z/agent_outputs/roundtrip_judge.json` (`ae2db0a64170f84f63f0e49a2b375982f15ff519abb90c3be1bfadb653ab941e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T083636Z/agent_outputs/source_contract.json` (`a9ee3c795e23928c39961404a1b888cdc069995450505412110ae54e20cc1dad`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T083636Z/decision.json` (`0a5cf22f991d9f8c3978468a7e55d196cb2f7130b9f1d0173f6cd809ff8e6094`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T083636Z/inputs/batch_source_locator.json` (`48d232a23e9792a23f07b4776151cdfef97d18e3a52ecba88ae9c9b08335fd61`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T083636Z/inputs/blind_dependency_inventory.json` (`48c234976f2a2d7345d4fd5ee7955ce2cdeb80091294dac56d9526c348203556`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T083636Z/inputs/blind_dossier.md` (`e657454add7b19b6928695cb8d593c37ffb61fabfb6ecd9651afc0a69a241a82`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T083636Z/inputs/blind_review_packet.md` (`e657454add7b19b6928695cb8d593c37ffb61fabfb6ecd9651afc0a69a241a82`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T083636Z/inputs/declaration_dossier.md` (`ff28f4d6133b030ce1f2bebf806bd2f74719822c9d927749e3234c7eaa45eef0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T083636Z/inputs/dependency_inventory.json` (`5566a1927903f5fadd86e12f700ad940e5a5f0910396e1752fa15de0771f2465`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T083636Z/inputs/direct_review_packet.md` (`8701256678780855ebbfbf8b3f152e12623f93edb36fd278533ec76b1c2f1203`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T083636Z/inputs/source_locator.json` (`cabcecacc1c30b719081bfb0c072900d49d44644b1834035291fb69783fce0d0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T101135Z/agent_outputs/adjudicator.json` (`ac74c556758b93237f895ec015bf87c43ca3508c84ae92aa8d85964899b993b5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T101135Z/agent_outputs/agent_runs.json` (`df7bb3904fe28ea00f7bf7179c519dab92cb45ec929e0ced26ba3fdb628cc32b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T101135Z/agent_outputs/batch_source_contract.json` (`2ca05f4aa8244ab5aa9f42522611c955146f2c905f8be90f878e801b59ad337a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T101135Z/agent_outputs/blind_translation.json` (`366a5e74f6ac29ad71c41b1827bed606702e6dec9ab1800d6f9d3d1662539aad`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T101135Z/agent_outputs/direct_judge.json` (`a9540555b637fcb815efcd497910aab8269cc724bedc1f6bdb3acdb7b7c37b8e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T101135Z/agent_outputs/roundtrip_judge.json` (`ae2db0a64170f84f63f0e49a2b375982f15ff519abb90c3be1bfadb653ab941e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T101135Z/agent_outputs/source_contract.json` (`a9ee3c795e23928c39961404a1b888cdc069995450505412110ae54e20cc1dad`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T101135Z/decision.json` (`73a13488f53f4f09c99a541a7bd78e0e09efcfc9d569afe4b96903f9b46f5d15`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T101135Z/inputs/blind_dependency_inventory.json` (`48c234976f2a2d7345d4fd5ee7955ce2cdeb80091294dac56d9526c348203556`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T101135Z/inputs/blind_dossier.md` (`e657454add7b19b6928695cb8d593c37ffb61fabfb6ecd9651afc0a69a241a82`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T101135Z/inputs/blind_review_packet.md` (`e657454add7b19b6928695cb8d593c37ffb61fabfb6ecd9651afc0a69a241a82`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T101135Z/inputs/declaration_dossier.md` (`ff28f4d6133b030ce1f2bebf806bd2f74719822c9d927749e3234c7eaa45eef0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T101135Z/inputs/dependency_inventory.json` (`5566a1927903f5fadd86e12f700ad940e5a5f0910396e1752fa15de0771f2465`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T101135Z/inputs/direct_review_packet.md` (`8701256678780855ebbfbf8b3f152e12623f93edb36fd278533ec76b1c2f1203`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/history/20260831T101135Z/inputs/source_locator.json` (`cabcecacc1c30b719081bfb0c072900d49d44644b1834035291fb69783fce0d0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/inputs/blind_dependency_inventory.json` (`48c234976f2a2d7345d4fd5ee7955ce2cdeb80091294dac56d9526c348203556`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/inputs/blind_dossier.md` (`e657454add7b19b6928695cb8d593c37ffb61fabfb6ecd9651afc0a69a241a82`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/inputs/blind_review_packet.md` (`e657454add7b19b6928695cb8d593c37ffb61fabfb6ecd9651afc0a69a241a82`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/inputs/declaration_dossier.md` (`7dce08956f4f1ee4c313caf8690a72b7fe5f79ee17f445cd35d06fcc406fab9f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/inputs/dependency_inventory.json` (`5566a1927903f5fadd86e12f700ad940e5a5f0910396e1752fa15de0771f2465`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/inputs/direct_review_packet.md` (`8701256678780855ebbfbf8b3f152e12623f93edb36fd278533ec76b1c2f1203`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.17/faithfulness/inputs/source_locator.json` (`cabcecacc1c30b719081bfb0c072900d49d44644b1834035291fb69783fce0d0`)
