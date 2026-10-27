/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.LocalSecondOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalDerivativeVariation
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsOrderWitness

/-!
# LeVeque: the leading advection truncation coefficient

The local expansion from Section 8.2.2 is proved for general smooth
advection profiles. At a fixed positive time-to-width ratio under CFL,
the actual update has the stated first-order normalized residual term
and a quadratic remainder. Local C3 smoothness supplies one threshold
and one remainder constant for every smaller positive width.
-/

namespace NumStability

theorem leveque04_laxFriedrichs_quadraticTaylorLeadingError
    (courant width base slope curvature left right shifted bound : ℝ)
    (hwidth : 0 ≤ width) (hbound : 0 ≤ bound) (hcfl : |courant| ≤ 1)
    (hleft : |left - (base - width * slope + width ^ 2 * curvature / 2)| ≤ bound * width ^ 3)
    (hright : |right - (base + width * slope + width ^ 2 * curvature / 2)| ≤ bound * width ^ 3)
    (hshift : |shifted - (base - courant * width * slope +
      (courant * width) ^ 2 * curvature / 2)| ≤ bound * width ^ 3) :
    |(left + right) / 2 - courant / 2 * (right - left) - shifted -
      (1 - courant ^ 2) * width ^ 2 * curvature / 2| ≤ 2 * bound * width ^ 3 := by
  have hl : |(left - width ^ 2 * curvature / 2) - (base - width * slope)| ≤
      (bound * width) * width ^ 2 := by convert hleft using 1 <;> ring
  have hr : |(right - width ^ 2 * curvature / 2) - (base + width * slope)| ≤
      (bound * width) * width ^ 2 := by convert hright using 1 <;> ring
  have hs : |(shifted - (courant * width) ^ 2 * curvature / 2) -
      (base - courant * width * slope)| ≤ (bound * width) * width ^ 2 := by
    convert hshift using 1 <;> ring
  have h := leveque04_laxFriedrichs_taylorError courant width base slope
    (left - width ^ 2 * curvature / 2) (right - width ^ 2 * curvature / 2)
    (shifted - (courant * width) ^ 2 * curvature / 2) (bound * width)
    hwidth (mul_nonneg hbound hwidth) hcfl hl hr hs
  convert h using 1 <;> ring

theorem leveque04_laxFriedrichs_localAdvectionLeadingResidual
    (g g' g'' : ℝ → ℝ) (speed ratio width K center : ℝ)
    (old : ℤ → ℝ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width) (hK : 0 ≤ K)
    (hcfl : |speed * ratio| ≤ 1)
    (hg : ∀ y ∈ Set.Icc (center - width) (center + width), HasDerivAt g (g' y) y)
    (hg' : ∀ y ∈ Set.Icc (center - width) (center + width), HasDerivAt g' (g'' y) y)
    (hvariation : ∀ y ∈ Set.Icc (center - width) (center + width),
      |g'' y - g'' center| ≤ K * |y - center|)
    (hleft : old (i - 1) = g (center - width))
    (hright : old (i + 1) = g (center + width)) :
    |(leveque04_scalarLaxFriedrichsStep (speed * ratio) old i -
      g (center - speed * ratio * width)) / (ratio * width) -
      (1 - (speed * ratio) ^ 2) / (2 * ratio) * width * g'' center| ≤
      (2 * K / ratio) * width ^ 2 := by
  have hcenter : center ∈ Set.Icc (center - width) (center + width) := by
    constructor <;> linarith
  have hshift : center - speed * ratio * width ∈ Set.Icc (center - width) (center + width) := by
    have hs := abs_le.mp hcfl
    constructor <;> nlinarith [mul_nonneg (sub_nonneg.mpr hs.2) hwidth.le,
      mul_nonneg (by linarith [hs.1] : 0 ≤ 1 + speed * ratio) hwidth.le]
  have ht (x : ℝ) (hx : x ∈ Set.Icc (center - width) (center + width)) :
      |g x - (g center + (x - center) * g' center +
        (x - center) ^ 2 / 2 * g'' center)| ≤ K * |x - center| ^ 3 := by
    have hsub := Set.uIcc_subset_Icc hcenter hx
    have h := norm_secondOrderTaylorError_le_of_local_second_deriv_variation
      g g' g'' K center x hK (fun y hy => hg y (hsub hy))
      (fun y hy => hg' y (hsub hy)) (fun y hy => by
        simpa only [Real.norm_eq_abs] using hvariation y (hsub hy))
    simpa only [Real.norm_eq_abs, smul_eq_mul] using h
  have hl := ht (center - width) ⟨le_rfl, by linarith⟩
  have hr := ht (center + width) ⟨by linarith, le_rfl⟩
  have hs := ht (center - speed * ratio * width) hshift
  have hleftTaylor : |old (i - 1) - (g center - width * g' center +
      width ^ 2 * g'' center / 2)| ≤ K * width ^ 3 := by
    rw [hleft]
    have hd : center - width - center = -width := by ring
    rw [hd, abs_neg, abs_of_pos hwidth] at hl
    convert hl using 1 <;> ring
  have hrightTaylor : |old (i + 1) - (g center + width * g' center +
      width ^ 2 * g'' center / 2)| ≤ K * width ^ 3 := by
    rw [hright]
    have hd : center + width - center = width := by ring
    rw [hd, abs_of_pos hwidth] at hr
    convert hr using 1 <;> ring
  have hshiftTaylor : |g (center - speed * ratio * width) -
      (g center - (speed * ratio) * width * g' center +
        ((speed * ratio) * width) ^ 2 * g'' center / 2)| ≤ K * width ^ 3 := by
    have hd : center - speed * ratio * width - center = -(speed * ratio * width) := by ring
    rw [hd, abs_neg] at hs
    have hw : |speed * ratio * width| ≤ width := by
      rw [abs_mul, abs_of_pos hwidth]
      exact (mul_le_mul_of_nonneg_right hcfl hwidth.le).trans_eq (one_mul width)
    have hb := mul_le_mul_of_nonneg_left (pow_le_pow_left₀ (abs_nonneg _) hw 3) hK
    have hs' := hs.trans hb
    convert hs' using 1 <;> ring
  have he := leveque04_laxFriedrichs_quadraticTaylorLeadingError (speed * ratio) width
    (g center) (g' center) (g'' center) (old (i - 1)) (old (i + 1))
    (g (center - speed * ratio * width)) K hwidth.le hK hcfl
    hleftTaylor hrightTaylor hshiftTaylor
  have he' : |leveque04_scalarLaxFriedrichsStep (speed * ratio) old i -
      g (center - speed * ratio * width) -
      (1 - (speed * ratio) ^ 2) * width ^ 2 * g'' center / 2| ≤ 2 * K * width ^ 3 := by
    convert he using 1 <;> simp only [leveque04_scalarLaxFriedrichsStep] <;> ring
  have htime := mul_pos hratio hwidth
  have hid : (leveque04_scalarLaxFriedrichsStep (speed * ratio) old i -
      g (center - speed * ratio * width)) / (ratio * width) -
      (1 - (speed * ratio) ^ 2) / (2 * ratio) * width * g'' center =
      (leveque04_scalarLaxFriedrichsStep (speed * ratio) old i -
        g (center - speed * ratio * width) -
        (1 - (speed * ratio) ^ 2) * width ^ 2 * g'' center / 2) / (ratio * width) := by
    field_simp
    <;> ring
  rw [hid, abs_div, abs_of_pos htime]
  apply (div_le_iff₀ htime).mpr
  convert he' using 1
  field_simp
  <;> ring

theorem leveque04_laxFriedrichs_smoothAdvectionLeadingResidual
    (g : ℝ → ℝ) (speed ratio center : ℝ) (hratio : 0 < ratio)
    (hcfl : |speed * ratio| ≤ 1) (hsmooth : ContDiffAt ℝ 3 g center) :
    ∃ threshold C : ℝ, 0 < threshold ∧ 0 ≤ C ∧
      ∀ width : ℝ, 0 < width → width < threshold →
      ∀ (old : ℤ → ℝ) (i : ℤ), old (i - 1) = g (center - width) →
        old (i + 1) = g (center + width) →
        |(leveque04_finiteVolumeUpdate (ratio * width) width
          (fun (j : ℤ) (_ : Fin 1) => old j)
          (leveque04_localInterfaceFlux
            (leveque04_laxFriedrichsFlux (ratio * width) width
              (fun (state : Fin 1 → ℝ) (_ : Fin 1) => speed * state 0))
            (fun (j : ℤ) (_ : Fin 1) => old j)) i 0 -
          g (center - speed * ratio * width)) / (ratio * width) -
          (1 - (speed * ratio) ^ 2) / (2 * ratio) * width * deriv (deriv g) center| ≤
          C * width ^ 2 := by
  have htwo : ContDiffAt ℝ 2 g center := hsmooth.of_le (by norm_num)
  have hderiv : ContDiffAt ℝ 2 (deriv g) center := hsmooth.derivWithin (by norm_num)
  obtain ⟨rs, Ks, hrs, hKs, hBs⟩ := contDiffAt_two_exists_local_deriv_variation g center htwo
  obtain ⟨rd, K, hrd, hK, hBd⟩ := contDiffAt_two_exists_local_deriv_variation (deriv g) center hderiv
  refine ⟨min rs rd, 2 * K / ratio, lt_min hrs hrd, div_nonneg (by positivity) hratio.le, ?_⟩
  intro width hw hsmall old i hl hr
  have hsub (y : ℝ) (hy : y ∈ Set.Icc (center - width) (center + width)) :
      y ∈ Set.Icc (center - rs) (center + rs) ∧
      y ∈ Set.Icc (center - rd) (center + rd) := by
    have hs := hsmall.trans_le (min_le_left rs rd)
    have hd := hsmall.trans_le (min_le_right rs rd)
    constructor <;> constructor <;> linarith [hy.1, hy.2]
  have h := leveque04_laxFriedrichs_localAdvectionLeadingResidual g (deriv g) (deriv (deriv g))
    speed ratio width K center old i hratio hw hK hcfl
    (fun y hy => (hBs y (hsub y hy).1).1)
    (fun y hy => (hBd y (hsub y hy).2).1)
    (fun y hy => by simpa only [Real.norm_eq_abs] using (hBd y (hsub y hy).2).2) hl hr
  rw [leveque04_scalarLaxFriedrichsStep_eq_equation20 speed (ratio * width) width
    (mul_pos hratio hw) hw old i]
  have hcoeff : speed * (ratio * width) / width = speed * ratio := by
    field_simp
  rw [hcoeff]
  exact h

end NumStability
