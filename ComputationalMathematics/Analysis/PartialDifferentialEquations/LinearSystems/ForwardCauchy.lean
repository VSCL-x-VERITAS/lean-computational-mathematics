/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearSystems.EigenbasisCoordinates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.ForwardCauchy

/-!
# Forward Cauchy uniqueness for diagonalizable linear systems

The PDE is needed only at positive times. Continuity carries each
characteristic identity to its initial-time endpoint.
-/

namespace NumStability

theorem constantCoefficientSystem_forwardCauchy
    {m : ℕ} (A : Matrix (Fin m) (Fin m) ℝ)
    (b : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (heigen : ∀ i, A.mulVec (b i) = speeds i • b i)
    (q : ℝ → ℝ → (Fin m → ℝ))
    (hcont : ContinuousOn (Function.uncurry q)
      (Set.prod Set.univ (Set.Ici 0)))
    (hdiff : DifferentiableOn ℝ (Function.uncurry q)
      (Set.prod Set.univ (Set.Ioi 0)))
    (hpde : ∀ x t, 0 < t → IsConstantCoefficientLinearSystemSolutionAt q A x t)
    (x t : ℝ) (ht : 0 ≤ t) :
    q x t = ∑ i,
      (b.equivFun (q (x - speeds i * t) 0) i) • b i := by
  have hcoord (i : Fin m) (x t : ℝ) (ht : 0 ≤ t) :
      b.equivFun (q x t) i =
        b.equivFun (q (x - speeds i * t) 0) i := by
    let L : (Fin m → ℝ) →L[ℝ] ℝ :=
      (ContinuousLinearMap.proj (R := ℝ) i).comp
        b.equivFun.toContinuousLinearEquiv.toContinuousLinearMap
    have hc : ContinuousOn
        (Function.uncurry (fun ξ τ => b.equivFun (q ξ τ) i))
        (Set.prod Set.univ (Set.Ici 0)) := by
      exact L.continuous.comp_continuousOn hcont
    have hd : DifferentiableOn ℝ
        (Function.uncurry (fun ξ τ => b.equivFun (q ξ τ) i))
        (Set.prod Set.univ (Set.Ioi 0)) := by
      exact L.differentiable.comp_differentiableOn hdiff
    have hpdecoord : ∀ y s, 0 < s →
        IsLinearAdvectionSolutionWithinAt
          (fun ξ τ => b.equivFun (q ξ τ) i)
          (speeds i) y s Set.univ (Set.Ioi 0) := by
      intro y s hs
      obtain ⟨qt, qx, hts, hxs, heq⟩ :=
        (constantCoefficientSystem_iff_eigenbasisAdvection
          A b speeds heigen q y s).mp (hpde y s hs) i
      exact ⟨qt, qx, hts.hasDerivWithinAt, hxs.hasDerivWithinAt, heq⟩
    simpa only [sub_zero] using
      (forward_characteristic_unique hc hd hpdecoord
        (velocity := speeds i) (initialTime := 0) (x := x) (t := t) ht)
  rw [← b.sum_equivFun (q x t)]
  apply Finset.sum_congr rfl
  intro i _
  rw [hcoord i x t ht]

end NumStability
