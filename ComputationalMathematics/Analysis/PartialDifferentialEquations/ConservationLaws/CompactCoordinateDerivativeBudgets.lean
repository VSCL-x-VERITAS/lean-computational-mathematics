/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalLinearAdvection
import Mathlib.Analysis.Calculus.ContDiff.RCLike

open Set
/-!
# Uniform coordinate derivative budgets on compact rectangles

Joint C2 regularity on an open space-time region yields common
Lipschitz constants for the existing actual spatial and temporal
partial derivatives on each enclosed compact rectangle. The proof
reuses Mathlib's compact convex C1 Lipschitz theorem.
-/

namespace NumStability

theorem contDiffOn_two_exists_compact_coordinate_derivative_budgets
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (spaceRegion timeRegion : Set ℝ)
    (left right start finish : ℝ)
    (hspaceOpen : IsOpen spaceRegion) (htimeOpen : IsOpen timeRegion)
    (hsmooth : ContDiffOn ℝ 2 (Function.uncurry q) (spaceRegion ×ˢ timeRegion))
    (hbox : Icc left right ×ˢ Icc start finish ⊆ spaceRegion ×ˢ timeRegion) :
    ∃ Kspace Ktime : NNReal,
      LipschitzOnWith Kspace (Function.uncurry (LocalLinearAdvection.qx q))
        (Icc left right ×ˢ Icc start finish) ∧
      LipschitzOnWith Ktime (Function.uncurry (LocalLinearAdvection.qt q))
        (Icc left right ×ˢ Icc start finish) := by
  have hX : ContDiffOn ℝ 1 (Function.uncurry (LocalLinearAdvection.qx q))
      (Icc left right ×ˢ Icc start finish) := by
    intro p hp
    rcases p with ⟨x,t⟩
    have h := (hsmooth.contDiffAt ((hspaceOpen.prod htimeOpen).mem_nhds (hbox hp)))
    have hd := (h.fderiv_right (m := 1) (by norm_num)).clm_apply (contDiffAt_const (c := ((1,0) : ℝ × ℝ)))
    exact (show ContDiffAt ℝ 1 (Function.uncurry (LocalLinearAdvection.qx q)) (x,t) from by
      simpa only [LocalLinearAdvection.qx, Function.uncurry_apply_pair] using hd).contDiffWithinAt
  have hT : ContDiffOn ℝ 1 (Function.uncurry (LocalLinearAdvection.qt q))
      (Icc left right ×ˢ Icc start finish) := by
    intro p hp
    rcases p with ⟨x,t⟩
    have h := (hsmooth.contDiffAt ((hspaceOpen.prod htimeOpen).mem_nhds (hbox hp)))
    have hd := (h.fderiv_right (m := 1) (by norm_num)).clm_apply (contDiffAt_const (c := ((0,1) : ℝ × ℝ)))
    exact (show ContDiffAt ℝ 1 (Function.uncurry (LocalLinearAdvection.qt q)) (x,t) from by
      simpa only [LocalLinearAdvection.qt, Function.uncurry_apply_pair] using hd).contDiffWithinAt
  obtain ⟨Kspace,hKs⟩ := hX.exists_lipschitzOnWith (by norm_num)
    ((convex_Icc left right).prod (convex_Icc start finish)) (isCompact_Icc.prod isCompact_Icc)
  obtain ⟨Ktime,hKt⟩ := hT.exists_lipschitzOnWith (by norm_num)
    ((convex_Icc left right).prod (convex_Icc start finish)) (isCompact_Icc.prod isCompact_Icc)
  exact ⟨Kspace,Ktime,hKs,hKt⟩

end NumStability
