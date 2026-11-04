import ComputationalMathematics.Source.Vershynin.Chapter04.Theorem456.OwnerQualifiedAllUnitTarget

/-! Source-facing proof of the owner-qualified all-unit spectral-clustering target. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem theorem456_owner_qualified_all_unit_proved :
    hdp_04_theorem_4_5_6_owner_qualified_all_unit := by
  obtain ⟨C, hC, hSuccess⟩ :=
    BalancedFinSBMRecovery.exists_equal_fiber_unit_binary_classification_success
  refine ⟨C, hC, ?_⟩
  intro k hn θ community hBalanced hpq
  dsimp only
  intro hμ
  have hq : 0 < θ.q := by
    exact_mod_cast (lt_of_lt_of_le hμ (min_le_left _ _))
  exact hSuccess (2 * k) hn θ community
    ((hBalanced 0).trans (hBalanced 1).symm) hq hpq

end NumStability.HDP.Contract
