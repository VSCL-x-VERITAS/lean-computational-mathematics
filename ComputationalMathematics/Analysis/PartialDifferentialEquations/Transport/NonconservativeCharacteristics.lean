/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.MaterialDerivative
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Topology.Order.DenselyOrdered

/-!
# Constancy along nonconservative characteristics

A field satisfying the nonconservative transport equation along a particle
curve has equal values at both ends of every closed time segment. Derivatives
are needed only in the interior; continuity supplies the endpoint values.
-/

namespace NumStability

open Set

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- Nonconservative transport preserves the field along each classical characteristic segment. -/
theorem nonconservativeTransport_characteristic_eq
    {q : ℝ → ℝ → E} {velocity curve : ℝ → ℝ}
    {F : ℝ → (ℝ × ℝ) →L[ℝ] E} {qt qx : ℝ → E} {a b : ℝ}
    {spaceDomain timeDomain : Set ℝ}
    (hab : a ≤ b)
    (hcurveDomain : MapsTo (fun τ => (curve τ, τ)) (Icc a b) (spaceDomain ×ˢ timeDomain))
    (hcontinuous : ContinuousOn (fun τ => q (curve τ) τ) (Icc a b))
    (hderivatives : ∀ τ ∈ Ioo a b,
      UniqueDiffWithinAt ℝ spaceDomain (curve τ) ∧
      UniqueDiffWithinAt ℝ timeDomain τ ∧
      HasFDerivWithinAt (Function.uncurry q) (F τ) (spaceDomain ×ˢ timeDomain) (curve τ, τ) ∧
      HasDerivWithinAt (fun r => q (curve τ) r) (qt τ) timeDomain τ ∧
      HasDerivWithinAt (fun x => q x τ) (qx τ) spaceDomain (curve τ) ∧
      HasDerivAt curve (velocity (curve τ)) τ ∧
      qt τ + velocity (curve τ) • qx τ = 0) :
    q (curve b) b = q (curve a) a := by
  rcases eq_or_lt_of_le hab with rfl | hlt
  · rfl
  let f : ℝ → E := fun τ => q (curve τ) τ
  have hd (τ : ℝ) (hτ : τ ∈ Ioo a b) : HasDerivAt f 0 τ := by
    rcases hderivatives τ hτ with ⟨hs, ht, hF, hqt, hqx, hcurve, hzero⟩
    have h := materialDerivative_hasDerivWithinAt hτ
      (fun r hr => hcurveDomain (Ioo_subset_Icc_self hr)) hs ht hF hqt hqx
      hcurve.hasDerivWithinAt
    rw [hzero] at h
    exact h.hasDerivAt (isOpen_Ioo.mem_nhds hτ)
  obtain ⟨c, hc⟩ := isOpen_Ioo.exists_is_const_of_deriv_eq_zero isPreconnected_Ioo
    (fun τ hτ => (hd τ hτ).differentiableAt.differentiableWithinAt)
    (fun τ hτ => (hd τ hτ).deriv)
  have heq : EqOn f (fun _ => c) (Icc a b) :=
    (show EqOn f (fun _ => c) (Ioo a b) from hc).of_subset_closure
      hcontinuous continuousOn_const Ioo_subset_Icc_self (by rw [closure_Ioo hlt.ne])
  exact (heq (right_mem_Icc.mpr hab)).trans (heq (left_mem_Icc.mpr hab)).symm

end NumStability
