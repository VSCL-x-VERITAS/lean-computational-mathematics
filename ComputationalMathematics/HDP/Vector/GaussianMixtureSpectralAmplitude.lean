import ComputationalMathematics.HDP.Vector.GaussianMixturePopulationTop
import ComputationalMathematics.HDP.Matrix.Weyl
import ComputationalMathematics.Analysis.Heron
import Mathlib.Algebra.Order.Group.MinMax

/-!
# Estimated signal amplitude from an ordered eigenvalue

Clipping the perturbed top eigenvalue minus one at zero gives a nonnegative
signal amplitude. Weyl and the existing normalized square-root bound control
its error by the operator perturbation divided by the positive mean norm.
-/

namespace NumStability.HDP.Vector.GaussianMixture

theorem spectralAmplitude_sub_meanNorm_abs_le {n : ℕ}
    (hn : 0 < n) (mean : Fin n → ℝ)
    (hmean : 0 < NumStability.vecNorm2 mean)
    (T : Matrix (Fin n) (Fin n) ℝ) (hT : T.IsHermitian) :
    |Real.sqrt (max (NumStability.hermitianOrderedEigenvalue hT ⟨0, hn⟩ - 1) 0) -
        NumStability.vecNorm2 mean| ≤
      NumStability.realMatrixOperatorNorm (populationSecondMoment mean - T) /
        NumStability.vecNorm2 mean := by
  let r := NumStability.vecNorm2 mean
  let a := NumStability.hermitianOrderedEigenvalue hT ⟨0, hn⟩ - 1
  let x := max a 0
  have hr : 0 < r := hmean
  have hx : 0 ≤ x := le_max_right a 0
  have hnormalized : 1 + (x - r ^ 2) / r ^ 2 = x / r ^ 2 := by
    field_simp [hr.ne']
    ring
  have hθ : 0 ≤ 1 + (x - r ^ 2) / r ^ 2 := by
    rw [hnormalized]
    exact div_nonneg hx (sq_nonneg r)
  have hscalar := NumStability.sqrt_one_add_sub_one_abs_le_abs hθ
  rw [hnormalized, Real.sqrt_div hx, Real.sqrt_sq hr.le] at hscalar
  have hleft : |Real.sqrt x / r - 1| = |Real.sqrt x - r| / r := by
    rw [show Real.sqrt x / r - 1 = (Real.sqrt x - r) / r by
      field_simp [hr.ne']]
    rw [abs_div, abs_of_pos hr]
  rw [hleft, abs_div, abs_of_pos (sq_pos_of_pos hr)] at hscalar
  have hroot : |Real.sqrt x - r| ≤ |x - r ^ 2| / r := by
    calc
      |Real.sqrt x - r| = (|Real.sqrt x - r| / r) * r := by
        field_simp [hr.ne']
      _ ≤ (|x - r ^ 2| / r ^ 2) * r :=
        mul_le_mul_of_nonneg_right hscalar hr.le
      _ = |x - r ^ 2| / r := by
        field_simp [hr.ne']
  have hclip : |x - r ^ 2| ≤ |a - r ^ 2| := by
    have hmax : max (r ^ 2) 0 = r ^ 2 := max_eq_left (sq_nonneg r)
    have h := abs_max_sub_max_le_abs a (r ^ 2) 0
    rw [hmax] at h
    exact h
  have hvalue := (populationOrderedTopEigenbasis_eq_sign_direction hn mean hmean).1
  have hweyl := NumStability.HDP.Matrix.abs_hermitianOrderedEigenvalue_sub_le_operatorNorm
    (populationSecondMoment mean) T (populationSecondMoment_isHermitian mean) hT ⟨0, hn⟩
  rw [hvalue] at hweyl
  have herror : |a - r ^ 2| ≤
      NumStability.realMatrixOperatorNorm (populationSecondMoment mean - T) := by
    rw [show a - r ^ 2 = -(1 + NumStability.vecNorm2 mean ^ 2 -
      NumStability.hermitianOrderedEigenvalue hT ⟨0, hn⟩) by dsimp [a, r]; ring,
      abs_neg]
    exact hweyl
  exact hroot.trans (div_le_div_of_nonneg_right (hclip.trans herror) hr.le)

end NumStability.HDP.Vector.GaussianMixture
