/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.CompactCoordinateDerivativeBudgets
import Mathlib.Analysis.Calculus.TangentCone.Real
import Mathlib.Analysis.Calculus.TangentCone.Prod

/-!
# Interior derivative budgets uniform up to physical endpoints

C2 regularity on a nondegenerate closed rectangle gives a common
Lipschitz budget for the actual interior space and time derivatives.
Mathlib supplies the within-derivative regularity and compact convex
Lipschitz theorem. Unique derivatives identify those within derivatives
with the actual total derivative at every interior point. The common
budget therefore remains valid as interior times approach time zero.
-/

namespace NumStability
open Set

theorem contDiffOn_two_closedRectangle_exists_interior_coordinate_derivative_budgets
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (L R start finish : ℝ)
    (hLR : L < R) (htime : start < finish)
    (hq : ContDiffOn ℝ 2 (Function.uncurry q) (Icc L R ×ˢ Icc start finish)) :
    ∃ K : NNReal,
      LipschitzOnWith K (Function.uncurry (LocalLinearAdvection.qx q))
        (Ioo L R ×ˢ Ioo start finish) ∧
      LipschitzOnWith K (Function.uncurry (LocalLinearAdvection.qt q))
        (Ioo L R ×ˢ Ioo start finish) := by
  let box := Icc L R ×ˢ Icc start finish
  let D := fderivWithin ℝ (Function.uncurry q) box
  have hD : ContDiffOn ℝ 1 D box :=
    hq.fderivWithin ((uniqueDiffOn_Icc hLR).prod (uniqueDiffOn_Icc htime)) (by norm_num)
  obtain ⟨K,hK⟩ := hD.exists_lipschitzOnWith (by norm_num)
    ((convex_Icc L R).prod (convex_Icc start finish)) (isCompact_Icc.prod isCompact_Icc)
  have hEq (p : ℝ × ℝ) (hp : p ∈ Ioo L R ×ˢ Ioo start finish) :
      D p = fderiv ℝ (Function.uncurry q) p :=
    fderivWithin_of_mem_nhds (prod_mem_nhds (Icc_mem_nhds hp.1.1 hp.1.2)
      (Icc_mem_nhds hp.2.1 hp.2.2))
  have hbound (p r : ℝ × ℝ) (hp : p ∈ Ioo L R ×ˢ Ioo start finish)
      (hr : r ∈ Ioo L R ×ˢ Ioo start finish) (v : ℝ × ℝ) (hv : ‖v‖ = 1) :
      ‖D p v - D r v‖ ≤ (K : ℝ)*‖p-r‖ := by
    have h := (D p-D r).le_opNorm v
    rw [hv,mul_one] at h
    exact h.trans (hK.norm_sub_le
      ⟨Ioo_subset_Icc_self hp.1,Ioo_subset_Icc_self hp.2⟩
      ⟨Ioo_subset_Icc_self hr.1,Ioo_subset_Icc_self hr.2⟩)
  refine ⟨K,?_,?_⟩
  · apply LipschitzOnWith.of_dist_le_mul
    intro p hp r hr
    have h := hbound p r hp hr (1,0) (by simp [Prod.norm_def])
    simpa [dist_eq_norm,hEq p hp,hEq r hr,LocalLinearAdvection.qx,
      Function.uncurry] using h
  · apply LipschitzOnWith.of_dist_le_mul
    intro p hp r hr
    have h := hbound p r hp hr (0,1) (by simp [Prod.norm_def])
    simpa [dist_eq_norm,hEq p hp,hEq r hr,LocalLinearAdvection.qt,
      Function.uncurry] using h

end NumStability
