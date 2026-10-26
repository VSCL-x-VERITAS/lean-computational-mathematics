/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Analysis.Calculus.Deriv.Prod
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# A first-order Taylor bound from Lipschitz derivative

The mean value inequality gives a quadratic error around any center
when the derivative has a uniform Lipschitz bound. The estimate uses a
simple coefficient rather than the optimal factor of one half.
-/

namespace NumStability

open Set

/-- A globally Lipschitz first derivative bounds the first-order
Taylor remainder quadratically at every center and target point. -/
theorem firstOrderTaylorError_le_of_lipschitzDeriv
    (f f' : ℝ → ℝ) (K center x : ℝ) (hK : 0 ≤ K)
    (hf : ∀ y, HasDerivAt f (f' y) y)
    (hLip : ∀ y z, |f' y - f' z| ≤ K * |y - z|) :
    |f x - (f center + f' center * (x - center))| ≤ K * (x - center) ^ 2 := by
  let e : ℝ → ℝ := fun y => f y - (f center + f' center * (y - center))
  have he : ∀ y, HasDerivAt e (f' y - f' center) y := by
    intro y
    have hlin : HasDerivAt
        (fun z : ℝ => f center + f' center * (z - center)) (f' center) y := by
      convert (hasDerivAt_const y (f center)).add
        ((hasDerivAt_const y (f' center)).mul
          ((hasDerivAt_id y).sub (hasDerivAt_const y center))) using 1
      all_goals simp
    exact (hf y).sub hlin
  have hec : e center = 0 := by simp [e]
  rcases le_total center x with hcx | hxc
  · have hb : ∀ y ∈ Ico center x, ‖f' y - f' center‖ ≤ K * |x - center| := by
      intro y hy
      rw [Real.norm_eq_abs]
      calc
        |f' y - f' center| ≤ K * |y - center| := hLip y center
        _ ≤ K * |x - center| := by
          apply mul_le_mul_of_nonneg_left _ hK
          rw [abs_of_nonneg (sub_nonneg.mpr hy.1),
            abs_of_nonneg (sub_nonneg.mpr hcx)]
          exact sub_le_sub_right hy.2.le center
    have hm := norm_image_sub_le_of_norm_deriv_le_segment'
      (f := e) (a := center) (b := x)
      (fun y _ => (he y).hasDerivWithinAt) hb x ⟨hcx, le_refl x⟩
    simpa [hec, e, Real.norm_eq_abs, abs_of_nonneg (sub_nonneg.mpr hcx),
      ← mul_assoc, pow_two] using hm
  · have hb : ∀ y ∈ Ico x center, ‖f' y - f' center‖ ≤ K * |x - center| := by
      intro y hy
      rw [Real.norm_eq_abs]
      calc
        |f' y - f' center| ≤ K * |y - center| := hLip y center
        _ ≤ K * |x - center| := by
          apply mul_le_mul_of_nonneg_left _ hK
          rw [abs_of_nonpos (sub_nonpos.mpr hy.2.le),
            abs_of_nonpos (sub_nonpos.mpr hxc)]
          linarith [hy.1]
    have hm := norm_image_sub_le_of_norm_deriv_le_segment'
      (f := e) (a := x) (b := center)
      (fun y _ => (he y).hasDerivWithinAt) hb center ⟨hxc, le_refl center⟩
    have hh : ‖e x - e center‖ ≤ K * |x - center| * (center - x) := by
      simpa [hec, norm_sub_rev] using hm
    have habs : |x - center| = center - x := by
      rw [abs_of_nonpos (sub_nonpos.mpr hxc)]
      ring
    calc
      |f x - (f center + f' center * (x - center))| = ‖e x - e center‖ := by
        simp [hec, e, Real.norm_eq_abs]
      _ ≤ K * |x - center| * (center - x) := hh
      _ = K * (x - center) ^ 2 := by rw [habs]; ring

/-- Componentwise transfer of the scalar bound to a finite real vector
with its supremum norm; the coefficient is independent of dimension. -/
theorem vectorFirstOrderTaylorError_le_of_lipschitzDeriv
    {m : ℕ} (f f' : ℝ → Fin m → ℝ)
    (K center x : ℝ) (hK : 0 ≤ K)
    (hf : ∀ y, HasDerivAt f (f' y) y)
    (hLip : ∀ y z, ‖f' y - f' z‖ ≤ K * |y - z|) :
    ‖f x - (f center + (x - center) • f' center)‖ ≤
      K * (x - center) ^ 2 := by
  rw [pi_norm_le_iff_of_nonneg (mul_nonneg hK (sq_nonneg _))]
  intro p
  have hpDeriv (y : ℝ) :
      HasDerivAt (fun z => f z p) (f' y p) y :=
    (hasDerivAt_pi.mp (hf y)) p
  have hpLip (y z : ℝ) :
      |f' y p - f' z p| ≤ K * |y - z| := by
    have hcoord := norm_le_pi_norm (f' y - f' z) p
    simpa only [Pi.sub_apply, Real.norm_eq_abs] using hcoord.trans (hLip y z)
  have h := firstOrderTaylorError_le_of_lipschitzDeriv
    (fun y => f y p) (fun y => f' y p) K center x hK hpDeriv hpLip
  simpa only [Pi.sub_apply, Pi.add_apply, Pi.smul_apply, smul_eq_mul,
    mul_comm (x - center) (f' center p)] using h

end NumStability
