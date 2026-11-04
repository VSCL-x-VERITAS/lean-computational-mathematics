/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.LocalSecondOrderTaylor
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalEndpointMeanQuadrature
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.QuadraticCellAverage
import Mathlib.Tactic.FunProp
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Centered slopes from local cell-average regularity

The difference of the two actual neighboring cell averages, divided by their
common width, approximates the derivative at their shared face to quadratic
order. Derivative and variation hypotheses are confined to the two cells.
-/

open MeasureTheory

namespace NumStability

private theorem local_quadratic_average
    (c a b face center width : ℝ) (hw : 0 < width) :
    oneDimensionalCellAverage
        (fun x : ℝ => c + (x - face) * a + b / 2 * (x - face) ^ 2)
        (center - width / 2) (center + width / 2) =
      c + (center - face) * a + b / 2 * ((center - face) ^ 2 + width ^ 2 / 12) := by
  have hl : Continuous (fun x : ℝ => c + (x - face) * a) := by fun_prop
  have hq : Continuous (fun x : ℝ => b / 2 * (x - face) ^ 2) := by fun_prop
  have hadd : oneDimensionalCellAverage
      (fun x : ℝ => c + (x - face) * a + b / 2 * (x - face) ^ 2)
      (center - width / 2) (center + width / 2) =
    oneDimensionalCellAverage (fun x : ℝ => c + (x - face) * a)
      (center - width / 2) (center + width / 2) +
    b / 2 * oneDimensionalCellAverage (fun x : ℝ => (x - face) ^ 2)
      (center - width / 2) (center + width / 2) := by
    simp only [oneDimensionalCellAverage, smul_eq_mul]
    rw [intervalIntegral.integral_add (hl.intervalIntegrable _ _) (hq.intervalIntegrable _ _),
      intervalIntegral.integral_const_mul]
    ring
  rw [hadd, oneDimensionalCellAverage_translated_quadratic center width face hw]
  have hlin := oneDimensionalCellAverage_affine_eq_endpointMean
    a (c - face * a) (center - width / 2) (center + width / 2) (by linarith)
  have heq : (fun x : ℝ => c + (x - face) * a) =
      (fun x : ℝ => a * x + (c - face * a)) := by funext x; ring
  rw [heq, hlin]
  ring

/-- Local spatial regularity on the two neighboring cells suffices for a
quadratic centered slope estimate on their actual cell integrals. -/
theorem local_oneDimensionalCellAverage_centeredSlope_error
    (f f' f'' : ℝ → ℝ) (K face width : ℝ)
    (hK : 0 ≤ K) (hw : 0 < width)
    (hf : ∀ y ∈ Set.Icc (face - width) (face + width), HasDerivAt f (f' y) y)
    (hf' : ∀ y ∈ Set.Icc (face - width) (face + width), HasDerivAt f' (f'' y) y)
    (hvariation : ∀ y ∈ Set.Icc (face - width) (face + width),
      |f'' y - f'' face| ≤ K * |y - face|) :
    |(oneDimensionalCellAverage f face (face + width) -
      oneDimensionalCellAverage f (face - width) face) / width - f' face| ≤
      2 * K * width ^ 2 := by
  let p : ℝ → ℝ := fun x => f face + (x - face) * f' face +
    f'' face / 2 * (x - face) ^ 2
  have hp : Continuous p := by dsimp [p]; fun_prop
  have hc : ContinuousOn f (Set.Icc (face - width) (face + width)) :=
    fun x hx => (hf x hx).continuousAt.continuousWithinAt
  have hm : face ∈ Set.Icc (face - width) (face + width) := ⟨by linarith, by linarith⟩
  have herr (x : ℝ) (hx : x ∈ Set.Icc (face - width) (face + width)) :
      ‖f x - p x‖ ≤ K * width ^ 3 := by
    have hs := Set.uIcc_subset_Icc hm hx
    have ht := norm_secondOrderTaylorError_le_of_local_second_deriv_variation
      f f' f'' K face x hK (fun y hy => hf y (hs hy))
      (fun y hy => hf' y (hs hy))
      (fun y hy => by simpa only [Real.norm_eq_abs] using hvariation y (hs hy))
    have hd : |x - face| ≤ width := abs_le.mpr ⟨by linarith [hx.1], by linarith [hx.2]⟩
    have hb := mul_le_mul_of_nonneg_left
      (pow_le_pow_left₀ (abs_nonneg _) hd 3) hK
    have hid : f face + (x - face) • f' face + ((x - face) ^ 2 / 2) • f'' face = p x := by
      simp only [smul_eq_mul, p]
      ring
    rw [hid] at ht
    exact ht.trans hb
  have hright : ‖oneDimensionalCellAverage f face (face + width) -
      oneDimensionalCellAverage p face (face + width)‖ ≤ K * width ^ 3 := by
    apply norm_oneDimensionalCellAverage_sub_le (by linarith : face < face + width)
    · exact (hc.mono (by intro x hx; exact ⟨by linarith [hx.1], hx.2⟩)).intervalIntegrable_of_Icc (by linarith)
    · exact hp.intervalIntegrable _ _
    · intro x hx
      rw [Set.uIoc_of_le (by linarith : face ≤ face + width)] at hx
      exact herr x ⟨by linarith [hx.1], hx.2⟩
  have hleft : ‖oneDimensionalCellAverage f (face - width) face -
      oneDimensionalCellAverage p (face - width) face‖ ≤ K * width ^ 3 := by
    apply norm_oneDimensionalCellAverage_sub_le (by linarith : face - width < face)
    · exact (hc.mono (by intro x hx; exact ⟨hx.1, by linarith [hx.2]⟩)).intervalIntegrable_of_Icc (by linarith)
    · exact hp.intervalIntegrable _ _
    · intro x hx
      rw [Set.uIoc_of_le (by linarith : face - width ≤ face)] at hx
      exact herr x ⟨hx.1.le, by linarith [hx.2]⟩
  have pr := local_quadratic_average (f face) (f' face) (f'' face) face
    (face + width / 2) width hw
  have pl := local_quadratic_average (f face) (f' face) (f'' face) face
    (face - width / 2) width hw
  have heqr : face + width / 2 - width / 2 = face := by ring
  have heqrr : face + width / 2 + width / 2 = face + width := by ring
  have heql : face - width / 2 - width / 2 = face - width := by ring
  have heqll : face - width / 2 + width / 2 = face := by ring
  simp only [heqr, heqrr] at pr
  simp only [heql, heqll] at pl
  have hpoly : (oneDimensionalCellAverage p face (face + width) -
      oneDimensionalCellAverage p (face - width) face) / width = f' face := by
    dsimp only [p]
    rw [pr, pl]
    field_simp [hw.ne']
    ring
  have hid : (oneDimensionalCellAverage f face (face + width) -
      oneDimensionalCellAverage f (face - width) face) / width - f' face =
    ((oneDimensionalCellAverage f face (face + width) -
      oneDimensionalCellAverage p face (face + width)) -
     (oneDimensionalCellAverage f (face - width) face -
      oneDimensionalCellAverage p (face - width) face)) / width := by
    rw [← hpoly]
    ring
  rw [hid, abs_div, abs_of_pos hw]
  apply (div_le_iff₀ hw).mpr
  have ht := abs_sub
    (oneDimensionalCellAverage f face (face + width) - oneDimensionalCellAverage p face (face + width))
    (oneDimensionalCellAverage f (face - width) face - oneDimensionalCellAverage p (face - width) face)
  simp only [Real.norm_eq_abs] at hright hleft
  nlinarith

/-- A numerical face coefficient contributes its own explicit error term to
the local diffusion flux. Centering alone does not control that coefficient. -/
theorem local_oneDimensionalCellAverage_diffusionFlux_error
    (f f' f'' : ℝ → ℝ) (K B physicalCoefficient numericalCoefficient face width : ℝ)
    (hK : 0 ≤ K) (hw : 0 < width)
    (hf : ∀ y ∈ Set.Icc (face - width) (face + width), HasDerivAt f (f' y) y)
    (hf' : ∀ y ∈ Set.Icc (face - width) (face + width), HasDerivAt f' (f'' y) y)
    (hvariation : ∀ y ∈ Set.Icc (face - width) (face + width),
      |f'' y - f'' face| ≤ K * |y - face|)
    (hgradient : |f' face| ≤ B) :
    let slope := (oneDimensionalCellAverage f face (face + width) -
      oneDimensionalCellAverage f (face - width) face) / width
    |-(numericalCoefficient * slope) - -(physicalCoefficient * f' face)| ≤
      2 * |numericalCoefficient| * K * width ^ 2 +
        |numericalCoefficient - physicalCoefficient| * B := by
  intro slope
  have hs := local_oneDimensionalCellAverage_centeredSlope_error
    f f' f'' K face width hK hw hf hf' hvariation
  have hid : -(numericalCoefficient * slope) - -(physicalCoefficient * f' face) =
      -(numericalCoefficient * (slope - f' face)) -
        (numericalCoefficient - physicalCoefficient) * f' face := by ring
  rw [hid]
  calc
    _ ≤ |-(numericalCoefficient * (slope - f' face))| +
        |(numericalCoefficient - physicalCoefficient) * f' face| := abs_sub _ _
    _ = |numericalCoefficient| * |slope - f' face| +
        |numericalCoefficient - physicalCoefficient| * |f' face| := by
      rw [abs_neg, abs_mul, abs_mul]
    _ ≤ |numericalCoefficient| * (2 * K * width ^ 2) +
        |numericalCoefficient - physicalCoefficient| * B :=
      add_le_add (mul_le_mul_of_nonneg_left hs (abs_nonneg _))
        (mul_le_mul_of_nonneg_left hgradient (abs_nonneg _))
    _ = _ := by ring

end NumStability
