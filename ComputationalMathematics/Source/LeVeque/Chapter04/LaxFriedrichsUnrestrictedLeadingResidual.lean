/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsLeadingResidual

/-!
# LeVeque: the local advection expansion without a CFL restriction

The Taylor expansion in Section 8.2.2 applies independently of the
stability condition. An enlarged local interval contains both numerical
neighbors and the exact translated evaluation point for every signed
Courant number. Local C3 smoothness yields a common positive threshold
and quadratic remainder bound for the actual normalized update.
-/

namespace NumStability

theorem leveque04_laxFriedrichs_unrestrictedQuadraticTaylorLeadingError
    (courant width base slope curvature left right shifted bound : ℝ)
    (hleft : |left - (base - width * slope + width ^ 2 * curvature / 2)| ≤ bound * width ^ 3)
    (hright : |right - (base + width * slope + width ^ 2 * curvature / 2)| ≤ bound * width ^ 3)
    (hshift : |shifted - (base - courant * width * slope +
      (courant * width) ^ 2 * curvature / 2)| ≤ bound * width ^ 3) :
    |(left + right) / 2 - courant / 2 * (right - left) - shifted -
      (1 - courant ^ 2) * width ^ 2 * curvature / 2| ≤
      (2 + |courant|) * bound * width ^ 3 := by
  let el := left - (base - width * slope + width ^ 2 * curvature / 2)
  let er := right - (base + width * slope + width ^ 2 * curvature / 2)
  let es := shifted - (base - courant * width * slope + (courant * width) ^ 2 * curvature / 2)
  have hid : (left + right) / 2 - courant / 2 * (right - left) - shifted -
      (1 - courant ^ 2) * width ^ 2 * curvature / 2 =
      (el + er) / 2 + courant / 2 * (el - er) - es := by dsimp [el, er, es]; ring
  rw [hid]
  have hab : |el + er| ≤ 2 * (bound * width ^ 3) :=
    (abs_add_le _ _).trans (by dsimp [el, er]; linarith)
  have hdiff : |el - er| ≤ 2 * (bound * width ^ 3) :=
    (abs_sub _ _).trans (by dsimp [el, er]; linarith)
  have hmul := mul_le_mul_of_nonneg_left hdiff (div_nonneg (abs_nonneg courant) (by norm_num : (0:ℝ) ≤ 2))
  calc
    |(el + er) / 2 + courant / 2 * (el - er) - es| ≤
        |(el + er) / 2| + |courant / 2 * (el - er)| + |es| :=
      (abs_sub _ _).trans (add_le_add (abs_add_le _ _) le_rfl)
    _ ≤ (2 + |courant|) * bound * width ^ 3 := by
      simp only [abs_div, abs_mul, show |(2 : ℝ)| = 2 by norm_num]
      dsimp [es]
      nlinarith


theorem leveque04_laxFriedrichs_unrestrictedLocalAdvectionLeadingResidual
    (g g' g'' : ℝ → ℝ) (speed ratio width K center : ℝ)
    (old : ℤ → ℝ) (i : ℤ)
    (hratio : 0 < ratio) (hwidth : 0 < width) (hK : 0 ≤ K)
    (hg : ∀ y ∈ Set.Icc (center - (1 + |speed * ratio|) * width)
      (center + (1 + |speed * ratio|) * width), HasDerivAt g (g' y) y)
    (hg' : ∀ y ∈ Set.Icc (center - (1 + |speed * ratio|) * width)
      (center + (1 + |speed * ratio|) * width), HasDerivAt g' (g'' y) y)
    (hvariation : ∀ y ∈ Set.Icc (center - (1 + |speed * ratio|) * width)
      (center + (1 + |speed * ratio|) * width),
      |g'' y - g'' center| ≤ K * |y - center|)
    (hleft : old (i - 1) = g (center - width))
    (hright : old (i + 1) = g (center + width)) :
    |(leveque04_scalarLaxFriedrichsStep (speed * ratio) old i -
      g (center - speed * ratio * width)) / (ratio * width) -
      (1 - (speed * ratio) ^ 2) / (2 * ratio) * width * g'' center| ≤
      ((2 + |speed * ratio|) * K * (1 + |speed * ratio|) ^ 3 / ratio) * width ^ 2 := by
  let reach := (1 + |speed * ratio|) * width
  have hreach : width ≤ reach := by dsimp [reach]; nlinarith [abs_nonneg (speed * ratio)]
  have hrpos : 0 < reach := hwidth.trans_le hreach
  have hcenter : center ∈ Set.Icc (center - reach) (center + reach) := by
    constructor <;> linarith
  have ht (x : ℝ) (hx : x ∈ Set.Icc (center - reach) (center + reach)) :
      |g x - (g center + (x - center) * g' center +
        (x - center) ^ 2 / 2 * g'' center)| ≤ K * reach ^ 3 := by
    have hsub := Set.uIcc_subset_Icc hcenter hx
    have h := norm_secondOrderTaylorError_le_of_local_second_deriv_variation
      g g' g'' K center x hK (fun y hy => hg y (hsub hy))
      (fun y hy => hg' y (hsub hy)) (fun y hy => by
        simpa only [Real.norm_eq_abs] using hvariation y (hsub hy))
    have hd : |x - center| ≤ reach := abs_le.mpr ⟨by linarith [hx.1], by linarith [hx.2]⟩
    have hb := mul_le_mul_of_nonneg_left (pow_le_pow_left₀ (abs_nonneg _) hd 3) hK
    have h' : |g x - (g center + (x - center) * g' center +
        (x - center) ^ 2 / 2 * g'' center)| ≤ K * |x - center| ^ 3 := by
      simpa only [Real.norm_eq_abs, smul_eq_mul] using h
    exact h'.trans hb
  have hl := ht (center - width) ⟨by linarith, by linarith⟩
  have hr := ht (center + width) ⟨by linarith, by linarith⟩
  have hs : center - speed * ratio * width ∈ Set.Icc (center - reach) (center + reach) := by
    have hcw : |speed * ratio * width| ≤ reach := by
      rw [abs_mul, abs_of_pos hwidth]; dsimp [reach]; nlinarith
    have hb := abs_le.mp hcw
    constructor <;> linarith
  have he := ht (center - speed * ratio * width) hs
  have hlt : |old (i - 1) - (g center - width * g' center + width ^ 2 * g'' center / 2)| ≤
      (K * (1 + |speed * ratio|) ^ 3) * width ^ 3 := by
    rw [hleft]; convert hl using 1 <;> dsimp [reach] <;> ring
  have hrt : |old (i + 1) - (g center + width * g' center + width ^ 2 * g'' center / 2)| ≤
      (K * (1 + |speed * ratio|) ^ 3) * width ^ 3 := by
    rw [hright]; convert hr using 1 <;> dsimp [reach] <;> ring
  have hst : |g (center - speed * ratio * width) -
      (g center - (speed * ratio) * width * g' center +
        ((speed * ratio) * width) ^ 2 * g'' center / 2)| ≤
      (K * (1 + |speed * ratio|) ^ 3) * width ^ 3 := by
    convert he using 1 <;> dsimp [reach] <;> ring
  have hb := leveque04_laxFriedrichs_unrestrictedQuadraticTaylorLeadingError
    (speed * ratio) width (g center) (g' center) (g'' center)
    (old (i - 1)) (old (i + 1)) (g (center - speed * ratio * width))
    (K * (1 + |speed * ratio|) ^ 3) hlt hrt hst
  have hb' : |leveque04_scalarLaxFriedrichsStep (speed * ratio) old i -
      g (center - speed * ratio * width) -
      (1 - (speed * ratio) ^ 2) * width ^ 2 * g'' center / 2| ≤
      (2 + |speed * ratio|) * (K * (1 + |speed * ratio|) ^ 3) * width ^ 3 := by
    convert hb using 1 <;> simp only [leveque04_scalarLaxFriedrichsStep] <;> ring
  have hid : (leveque04_scalarLaxFriedrichsStep (speed * ratio) old i -
      g (center - speed * ratio * width)) / (ratio * width) -
      (1 - (speed * ratio) ^ 2) / (2 * ratio) * width * g'' center =
      (leveque04_scalarLaxFriedrichsStep (speed * ratio) old i -
        g (center - speed * ratio * width) -
        (1 - (speed * ratio) ^ 2) * width ^ 2 * g'' center / 2) / (ratio * width) := by
    field_simp <;> ring
  rw [hid, abs_div, abs_of_pos (mul_pos hratio hwidth)]
  apply (div_le_iff₀ (mul_pos hratio hwidth)).mpr
  convert hb' using 1
  field_simp <;> ring


theorem leveque04_laxFriedrichs_unrestrictedSmoothAdvectionLeadingResidual
    (g : ℝ → ℝ) (speed ratio center : ℝ) (hratio : 0 < ratio)
    (hsmooth : ContDiffAt ℝ 3 g center) :
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
  let extent := 1 + |speed * ratio|
  have he : 0 < extent := by dsimp [extent]; positivity
  refine ⟨min rs rd / extent,
    (2 + |speed * ratio|) * K * extent ^ 3 / ratio,
    div_pos (lt_min hrs hrd) he, div_nonneg (by positivity) hratio.le, ?_⟩
  intro width hw hsmall old i hl hr
  have hreach : extent * width < min rs rd := by
    have h := (lt_div_iff₀ he).mp hsmall
    simpa only [mul_comm] using h
  have hsub (y : ℝ) (hy : y ∈ Set.Icc (center - extent * width) (center + extent * width)) :
      y ∈ Set.Icc (center - rs) (center + rs) ∧
      y ∈ Set.Icc (center - rd) (center + rd) := by
    have hs := hreach.trans_le (min_le_left rs rd)
    have hd := hreach.trans_le (min_le_right rs rd)
    constructor <;> constructor <;> linarith [hy.1, hy.2]
  have h := leveque04_laxFriedrichs_unrestrictedLocalAdvectionLeadingResidual
    g (deriv g) (deriv (deriv g)) speed ratio width K center old i hratio hw hK
    (fun y hy => (hBs y (hsub y hy).1).1)
    (fun y hy => (hBd y (hsub y hy).2).1)
    (fun y hy => by simpa only [Real.norm_eq_abs] using (hBd y (hsub y hy).2).2) hl hr
  rw [leveque04_scalarLaxFriedrichsStep_eq_equation20 speed (ratio * width) width
    (mul_pos hratio hw) hw old i]
  have hcoeff : speed * (ratio * width) / width = speed * ratio := by field_simp
  rw [hcoeff]
  exact h

end NumStability
