/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerVectorAdjacentAverage
import ComputationalMathematics.Analysis.Calculus.CenteredSecant

/-!
# Centered secant error for a vector physical flux

The scalar centered secant estimate lifts coordinatewise to a finite
vector flux. It controls the physical flux difference at the two
half-cell midpoint states around a Richtmyer face.
-/

namespace NumStability

theorem leveque04_richtmyer_vectorCenteredSecant_deriv_error
    {m : ℕ} (physicalFlux physicalSlope : ℝ → Fin m → ℝ)
    (K face width : ℝ)
    (hK : 0 ≤ K) (hwidth : 0 < width)
    (hderiv : ∀ x, HasDerivAt physicalFlux (physicalSlope x) x)
    (hLip : ∀ x y,
      ‖physicalSlope x - physicalSlope y‖ ≤ K * |x - y|) :
    ‖width⁻¹ •
        (physicalFlux (face + width / 2) -
          physicalFlux (face - width / 2)) -
        physicalSlope face‖ ≤ K * width / 2 := by
  have hnonneg : 0 ≤ K * width / 2 := by positivity
  apply (pi_norm_le_iff_of_nonneg hnonneg).2
  intro p
  have hcoordDeriv (x : ℝ) :
      HasDerivAt (fun y => physicalFlux y p)
        (physicalSlope x p) x :=
    (hasDerivAt_pi.mp (hderiv x)) p
  have hcoordLip (x y : ℝ) :
      |physicalSlope x p - physicalSlope y p| ≤ K * |x - y| := by
    have hcoord := norm_le_pi_norm
      (physicalSlope x - physicalSlope y) p
    have hcoord' : |physicalSlope x p - physicalSlope y p| ≤
        ‖physicalSlope x - physicalSlope y‖ := by
      simpa only [Pi.sub_apply, Real.norm_eq_abs] using hcoord
    exact hcoord'.trans (hLip x y)
  have hscalar := centeredSecant_deriv_error_le_of_lipschitzDeriv
    (fun x => physicalFlux x p) (fun x => physicalSlope x p)
    K face width hK hwidth hcoordDeriv hcoordLip
  simp only [Pi.sub_apply, Pi.smul_apply, smul_eq_mul,
    Real.norm_eq_abs]
  convert hscalar using 1
  ring_nf

/-- Quadratic endpoint perturbations add a linear error to the
centered vector flux secant. -/
theorem leveque04_richtmyer_vectorCenteredSecant_endpointError
    {m : ℕ} (physicalFlux physicalSlope : ℝ → Fin m → ℝ)
    (leftValue rightValue : Fin m → ℝ)
    (face width K E : ℝ)
    (hwidth : 0 < width)
    (hleft : ‖leftValue - physicalFlux (face - width / 2)‖ ≤
      E * width ^ 2)
    (hright : ‖rightValue - physicalFlux (face + width / 2)‖ ≤
      E * width ^ 2)
    (hsecant :
      ‖width⁻¹ •
          (physicalFlux (face + width / 2) -
            physicalFlux (face - width / 2)) -
          physicalSlope face‖ ≤ K * width / 2) :
    ‖width⁻¹ • (rightValue - leftValue) -
        physicalSlope face‖ ≤ (2 * E + K / 2) * width := by
  have hnum : ‖(rightValue - leftValue) -
      (physicalFlux (face + width / 2) -
        physicalFlux (face - width / 2))‖ ≤ 2 * E * width ^ 2 := by
    have hid : (rightValue - leftValue) -
        (physicalFlux (face + width / 2) -
          physicalFlux (face - width / 2)) =
        (rightValue - physicalFlux (face + width / 2)) -
          (leftValue - physicalFlux (face - width / 2)) := by abel
    rw [hid]
    calc
      _ ≤ ‖rightValue - physicalFlux (face + width / 2)‖ +
          ‖leftValue - physicalFlux (face - width / 2)‖ :=
        norm_sub_le _ _
      _ ≤ E * width ^ 2 + E * width ^ 2 := add_le_add hright hleft
      _ = 2 * E * width ^ 2 := by ring
  have hquot :
      ‖width⁻¹ • ((rightValue - leftValue) -
          (physicalFlux (face + width / 2) -
            physicalFlux (face - width / 2)))‖ ≤
        2 * E * width := by
    rw [norm_smul, Real.norm_eq_abs, abs_of_pos (inv_pos.mpr hwidth)]
    calc
      _ ≤ width⁻¹ * (2 * E * width ^ 2) :=
        mul_le_mul_of_nonneg_left hnum (inv_nonneg.mpr hwidth.le)
      _ = 2 * E * width := by field_simp [hwidth.ne']
  have hid : width⁻¹ • (rightValue - leftValue) -
      physicalSlope face =
      width⁻¹ • ((rightValue - leftValue) -
        (physicalFlux (face + width / 2) -
          physicalFlux (face - width / 2))) +
        (width⁻¹ •
          (physicalFlux (face + width / 2) -
            physicalFlux (face - width / 2)) -
          physicalSlope face) := by
    simp only [smul_sub]
    abel
  rw [hid]
  calc
    _ ≤ ‖width⁻¹ • ((rightValue - leftValue) -
          (physicalFlux (face + width / 2) -
            physicalFlux (face - width / 2)))‖ +
        ‖width⁻¹ •
          (physicalFlux (face + width / 2) -
            physicalFlux (face - width / 2)) -
          physicalSlope face‖ := norm_add_le _ _
    _ ≤ 2 * E * width + K * width / 2 := add_le_add hquot hsecant
    _ = (2 * E + K / 2) * width := by ring

end NumStability
