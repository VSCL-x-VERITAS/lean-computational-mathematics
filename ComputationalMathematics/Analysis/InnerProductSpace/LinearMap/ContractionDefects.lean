/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.Polar
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Commute
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Order
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NoncommRing

/-!
# Intertwining the defect roots of a contraction

The adjoint of a finite-dimensional contraction intertwines the positive square
roots of its two defect operators. A full polar unitary transports one root to
the other; functional calculus supplies the required commutation with the
positive polar factor. No positive dimension, invertibility, normality or
strict norm bound is needed. Completeness is obtained from finite dimension.
-/

set_option autoImplicit false

namespace NumStability

set_option maxHeartbeats 0 in
/-- The adjoint intertwines the actual functional-calculus defect roots of a
contraction, including singular operators and the zero-dimensional space. -/
theorem adjoint_mul_sqrt_defect_eq
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (A : H →L[ℂ] H) (hA : ‖A‖ ≤ 1) :
    letI : CompleteSpace H := FiniteDimensional.complete ℂ H
    A.adjoint * CFC.sqrt (1 - A * A.adjoint) =
      CFC.sqrt (1 - A.adjoint * A) * A.adjoint := by
  letI : CompleteSpace H := FiniteDimensional.complete ℂ H
  obtain ⟨U, hU, hpolar⟩ := exists_unitary_comp_linearMapAbs A.toLinearMap
  let u : H →L[ℂ] H := U.toContinuousLinearMap
  let p : H →L[ℂ] H := (linearMapAbs A.toLinearMap).toContinuousLinearMap
  have hUl : star u * u = 1 := by
    have h := congrArg (fun T : H →ₗ[ℂ] H => T.toContinuousLinearMap)
      (Unitary.mem_iff.mp hU).1
    simpa only [LinearMap.adjoint_toContinuousLinearMap] using h
  have hUr : u * star u = 1 := by
    have h := congrArg (fun T : H →ₗ[ℂ] H => T.toContinuousLinearMap)
      (Unitary.mem_iff.mp hU).2
    simpa only [LinearMap.adjoint_toContinuousLinearMap] using h
  have hp : star p = p := by
    have h := congrArg (fun T : H →ₗ[ℂ] H => T.toContinuousLinearMap)
      (linearMapAbs_isPositive A.toLinearMap).1.adjoint_eq
    simpa only [LinearMap.adjoint_toContinuousLinearMap] using h
  have hpolar' : A = u * p :=
    congrArg (fun T : H →ₗ[ℂ] H => T.toContinuousLinearMap) hpolar
  have hgram : star A * A = p * p := by
    rw [hpolar', star_mul, hp]
    calc
      (p * star u) * (u * p) = p * (star u * u) * p := by noncomm_ring
      _ = p * p := by rw [hUl]; simp
  have hnorm : ‖star A * A‖ ≤ 1 := by
    rw [CStarRing.norm_star_mul_self]
    nlinarith [norm_nonneg A]
  have hb : 0 ≤ (1 : H →L[ℂ] H) - p * p := by
    rw [← hgram]
    exact sub_nonneg.mpr
      ((CStarAlgebra.norm_le_one_iff_of_nonneg _ (star_mul_self_nonneg A)).mp hnorm)
  let r := CFC.sqrt ((1 : H →L[ℂ] H) - p * p)
  have hsqr : r * r = 1 - p * p := CFC.sqrt_mul_sqrt_self _ hb
  have hcomm : Commute r p := by
    have h : Commute ((1 : H →L[ℂ] H) - p * p) p := by
      change (1 - p * p) * p = p * (1 - p * p)
      noncomm_ring
    exact h.cfcₙ_nnreal NNReal.sqrt
  have hroot : CFC.sqrt (1 - A * star A) = u * r * star u := by
    apply CFC.sqrt_unique ?_ (star_right_conjugate_nonneg (CFC.sqrt_nonneg _) u)
    calc
      (u * r * star u) * (u * r * star u) =
          u * r * (star u * u) * r * star u := by noncomm_ring
      _ = u * (r * r) * star u := by rw [hUl]; simp only [mul_one, mul_assoc]
      _ = u * (1 - p * p) * star u := by rw [hsqr]
      _ = 1 - A * star A := by
        rw [hpolar', star_mul, hp, mul_sub, sub_mul, mul_one, hUr]
        noncomm_ring
  change star A * CFC.sqrt (1 - A * star A) =
    CFC.sqrt (1 - star A * A) * star A
  rw [hgram]
  change star A * CFC.sqrt (1 - A * star A) = r * star A
  rw [hroot, hpolar', star_mul, hp]
  calc
    (p * star u) * (u * r * star u) = p * (star u * u) * r * star u := by
      noncomm_ring
    _ = p * r * star u := by rw [hUl]; simp
    _ = r * (p * star u) := by rw [← hcomm.eq]; simp only [mul_assoc]

end NumStability
