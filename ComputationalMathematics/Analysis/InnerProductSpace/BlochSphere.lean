/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Bloch coordinates of a complex unit pair

The complex pair `(α, β)` has Bloch coordinates
`(2 Re(conj α * β), 2 Im(conj α * β), |α|² - |β|²)` in the genuine real
Euclidean three-space. Unit pairs map onto its entire unit sphere. The inverse
uses a real square root away from the south pole and treats that pole separately.
The imaginary coordinate follows the conjugate-first inner-product convention.
-/

set_option autoImplicit false

namespace NumStability

/-- Explicit Bloch coordinates, with the positive imaginary cross-term. -/
noncomputable def blochVector (α β : ℂ) : EuclideanSpace ℝ (Fin 3) :=
  !₂[2 * (star α * β).re, 2 * (star α * β).im,
    Complex.normSq α - Complex.normSq β]

/-- A complex unit pair has a unit Bloch vector in real Euclidean space. -/
theorem norm_blochVector_eq_one (α β : ℂ)
    (hunit : Complex.normSq α + Complex.normSq β = 1) :
    ‖blochVector α β‖ = 1 := by
  have hsq : ‖blochVector α β‖ ^ 2 =
      (Complex.normSq α + Complex.normSq β) ^ 2 := by
    rw [EuclideanSpace.norm_sq_eq]
    simp [blochVector, Fin.sum_univ_succ, Real.norm_eq_abs, sq_abs,
      Complex.normSq_apply, Complex.mul_re, Complex.mul_im]
    ring
  rw [hunit] at hsq
  nlinarith [norm_nonneg (blochVector α β)]

/-- Every unit Bloch vector comes from a complex unit pair, including the
south pole, where the usual quotient formula has zero denominator. -/
theorem exists_unit_pair_blochVector (r : EuclideanSpace ℝ (Fin 3))
    (hr : ‖r‖ = 1) :
    ∃ α β : ℂ, Complex.normSq α + Complex.normSq β = 1 ∧ blochVector α β = r := by
  have hcoords : r 0 ^ 2 + r 1 ^ 2 + r 2 ^ 2 = 1 := by
    have h := EuclideanSpace.norm_sq_eq r
    rw [hr] at h
    simpa [Fin.sum_univ_succ, Real.norm_eq_abs, sq_abs, add_assoc] using h.symm
  have hzlow : -1 ≤ r 2 := by nlinarith [sq_nonneg (r 0), sq_nonneg (r 1)]
  have hzhigh : r 2 ≤ 1 := by nlinarith [sq_nonneg (r 0), sq_nonneg (r 1)]
  by_cases hpole : r 2 = -1
  · have hx : r 0 = 0 := by nlinarith [sq_nonneg (r 1)]
    have hy : r 1 = 0 := by nlinarith [sq_nonneg (r 0)]
    refine ⟨0, 1, by norm_num [Complex.normSq_apply], ?_⟩
    ext i
    fin_cases i <;> simp [blochVector, hx, hy, hpole, Complex.normSq_apply]
  · let a : ℝ := Real.sqrt ((1 + r 2) / 2)
    have hzp : -1 < r 2 := lt_of_le_of_ne hzlow (Ne.symm hpole)
    have ha : 0 < a := Real.sqrt_pos.mpr (by linarith [hzp])
    have ha0 : a ≠ 0 := ha.ne'
    have ha2 : a ^ 2 = (1 + r 2) / 2 := Real.sq_sqrt (by linarith)
    let β : ℂ := ((r 0 : ℂ) + Complex.I * (r 1 : ℂ)) / (2 * a : ℝ)
    have hbRe : β.re = r 0 / (2 * a) := by
      dsimp only [β]
      rw [Complex.div_ofReal_re]
      simp
    have hbIm : β.im = r 1 / (2 * a) := by
      dsimp only [β]
      rw [Complex.div_ofReal_im]
      simp
    have hbSq : Complex.normSq β = (1 - r 2) / 2 := by
      rw [Complex.normSq_apply, hbRe, hbIm]
      field_simp
      nlinarith
    have hαSq : Complex.normSq (a : ℂ) = (1 + r 2) / 2 := by
      simpa only [Complex.normSq_ofReal, pow_two] using ha2
    refine ⟨(a : ℂ), β, by rw [hαSq, hbSq]; ring, ?_⟩
    ext i
    fin_cases i
    · simp [blochVector, hbRe, hbIm]
      field_simp
    · simp [blochVector, hbRe, hbIm]
      field_simp
    · simp [blochVector, hαSq, hbSq]
      ring

end NumStability
