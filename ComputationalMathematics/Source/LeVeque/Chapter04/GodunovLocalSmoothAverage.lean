/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovOrderWitness
import ComputationalMathematics.Source.LeVeque.Chapter04.UpwindWavePropagation
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalEndpointMeanQuadrature

/-!
# LeVeque: local smooth accuracy on exact Godunov cell averages

The actual signed upwind step has a first-order normalized residual
on the exact translated solution under the unit Courant condition.
Local derivative variation on the stencil region suffices. Local C2
smoothness at the evaluated cell center derives one positive mesh
threshold and one error constant for every smaller positive width.
The cell averages and exact translated average are the actual integrals,
and no global derivative or Lipschitz budget is assumed.
-/

namespace NumStability

theorem leveque04_signedGodunov_localCellAverageResidual
    (f f' : ℝ → ℝ) (center speed ratio width K : ℝ)
    (hratio : 0 < ratio) (hw : 0 < width) (hK : 0 ≤ K)
    (hcfl : |speed * ratio| ≤ 1)
    (hf : ∀ x ∈ Set.Icc (center - 2 * width) (center + 2 * width), HasDerivAt f (f' x) x)
    (hvar : ∀ x ∈ Set.Icc (center - 2 * width) (center + 2 * width),
      |f' x - f' center| ≤ K * |x - center|)
    (old : ℤ → ℝ) (i : ℤ)
    (hcurrent : old i = oneDimensionalCellAverage f (center - width / 2) (center + width / 2))
    (hleft : old (i - 1) = oneDimensionalCellAverage f
      (center - width - width / 2) (center - width + width / 2))
    (hright : old (i + 1) = oneDimensionalCellAverage f
      (center + width - width / 2) (center + width + width / 2)) :
    |(leveque04_signedUpwindStep (ratio * width) width speed old i -
      oneDimensionalCellAverage (fun x => f (x - speed * ratio * width))
        (center - width / 2) (center + width / 2)) / (ratio * width)| ≤
      (8 * K / ratio) * width := by
  let p : ℝ → ℝ := fun x => f' center * x + (f center - center * f' center)
  have hp : Continuous p := (continuous_const.mul continuous_id).add continuous_const
  have hfc : ContinuousOn f (Set.Icc (center - 2 * width) (center + 2 * width)) :=
    fun x hx => (hf x hx).continuousAt.continuousWithinAt
  have havg (d : ℝ) (hd : |d| ≤ width) :
      |oneDimensionalCellAverage f (center + d - width / 2) (center + d + width / 2) -
        (f center + d * f' center)| ≤ (4 * K) * width ^ 2 := by
    have hab : center + d - width / 2 < center + d + width / 2 := by linarith
    have hsub : Set.Icc (center + d - width / 2) (center + d + width / 2) ⊆
        Set.Icc (center - 2 * width) (center + 2 * width) := by
      intro x hx
      have hd' := abs_le.mp hd
      exact ⟨by linarith [hx.1], by linarith [hx.2]⟩
    have hb : ‖oneDimensionalCellAverage f (center + d - width / 2) (center + d + width / 2) -
        oneDimensionalCellAverage p (center + d - width / 2) (center + d + width / 2)‖ ≤
        (4 * K) * width ^ 2 := by
      apply norm_oneDimensionalCellAverage_sub_le hab
      · exact (hfc.mono hsub).intervalIntegrable_of_Icc hab.le
      · exact hp.intervalIntegrable _ _
      · intro x hx
        rw [Set.uIoc_of_le hab.le] at hx
        have hxbox := hsub ⟨hx.1.le, hx.2⟩
        have hcenter : center ∈ Set.Icc (center - 2 * width) (center + 2 * width) :=
          ⟨by linarith, by linarith⟩
        have hs := Set.uIcc_subset_Icc hcenter hxbox
        have h := norm_firstOrderTaylorError_le_of_local_deriv_variation
          f f' K center x hK (fun y hy => hf y (hs hy))
          (fun y hy => by simpa only [Real.norm_eq_abs] using hvar y (hs hy))
        have hid : f center + (x - center) * f' center = p x := by ring
        rw [smul_eq_mul, hid] at h
        have hdistance : |x - center| ≤ 2 * width :=
          abs_le.mpr ⟨by linarith [hxbox.1], by linarith [hxbox.2]⟩
        have hmul := mul_le_mul_of_nonneg_left
          (pow_le_pow_left₀ (abs_nonneg _) hdistance 2) hK
        have h' : ‖f x - p x‖ ≤ K * |x - center| ^ 2 := by
          simpa only [sq_abs] using h
        exact h'.trans (hmul.trans_eq (by ring))
    have hpa : oneDimensionalCellAverage p (center + d - width / 2) (center + d + width / 2) =
        f center + d * f' center := by
      rw [oneDimensionalCellAverage_affine_eq_endpointMean _ _ _ _ hab]
      ring
    rw [hpa] at hb
    exact hb
  have hcur : |old i - f center| ≤ (4 * K) * width ^ 2 := by
    simpa only [hcurrent, add_zero, zero_mul] using havg 0 (by simpa using hw.le)
  have hleft' : |old (i - 1) - (f center - width * f' center)| ≤ (4 * K) * width ^ 2 := by
    have h := havg (-width) (by simp [abs_of_pos hw])
    rw [hleft]
    convert h using 1 <;> ring
  have hright' : |old (i + 1) - (f center + width * f' center)| ≤ (4 * K) * width ^ 2 := by
    simpa only [hright] using havg width (by simp [abs_of_pos hw])
  have hd : |-speed * ratio * width| ≤ width := by
    rw [abs_mul, abs_mul, abs_neg, abs_of_pos hw, ← abs_mul]
    simpa only [one_mul] using mul_le_mul_of_nonneg_right hcfl hw.le
  have hshift := havg (-speed * ratio * width) hd
  have hstep := leveque04_signedGodunov_taylorError
    speed ratio width (f center) (f' center) (old i) (old (i - 1)) (old (i + 1))
    (oneDimensionalCellAverage f (center - speed * ratio * width - width / 2)
      (center - speed * ratio * width + width / 2)) (4 * K)
    hratio.le hcfl hcur hleft' hright' (by convert hshift using 1 <;> ring)
  rw [leveque04_equation35, oneDimensionalCellAverage_comp_sub_right,
    abs_div, abs_of_pos (mul_pos hratio hw)]
  apply (div_le_iff₀ (mul_pos hratio hw)).mpr
  have hratioCancel : (ratio * width) / width = ratio := by field_simp
  simp only [hratioCancel, leveque04_leftWaveJump, leveque04_rightWaveJump]
  convert hstep using 1 <;> field_simp [ne_of_gt hratio] <;> ring

theorem leveque04_signedGodunov_localSmoothCellAverageResidual
    (f : ℝ → ℝ) (center speed ratio : ℝ)
    (hratio : 0 < ratio) (hcfl : |speed * ratio| ≤ 1)
    (hsmooth : ContDiffAt ℝ 2 f center) :
    ∃ threshold C : ℝ, 0 < threshold ∧ 0 ≤ C ∧
      ∀ width : ℝ, 0 < width → width < threshold →
      ∀ (old : ℤ → ℝ) (i : ℤ),
        old i = oneDimensionalCellAverage f (center - width / 2) (center + width / 2) →
        old (i - 1) = oneDimensionalCellAverage f
          (center - width - width / 2) (center - width + width / 2) →
        old (i + 1) = oneDimensionalCellAverage f
          (center + width - width / 2) (center + width + width / 2) →
        |(leveque04_signedUpwindStep (ratio * width) width speed old i -
          oneDimensionalCellAverage (fun x => f (x - speed * ratio * width))
            (center - width / 2) (center + width / 2)) / (ratio * width)| ≤ C * width := by
  obtain ⟨radius, K, hr, hK, hb⟩ := contDiffAt_two_exists_local_deriv_variation f center hsmooth
  refine ⟨radius / 2, 8 * K / ratio, by positivity, by positivity, ?_⟩
  intro width hw hsmall old i hcurrent hleft hright
  have hsub (x : ℝ) (hx : x ∈ Set.Icc (center - 2 * width) (center + 2 * width)) :
      x ∈ Set.Icc (center - radius) (center + radius) :=
    ⟨by linarith [hx.1], by linarith [hx.2]⟩
  exact leveque04_signedGodunov_localCellAverageResidual f (deriv f)
    center speed ratio width K hratio hw hK hcfl
    (fun x hx => (hb x (hsub x hx)).1)
    (fun x hx => by simpa only [Real.norm_eq_abs] using (hb x (hsub x hx)).2)
    old i hcurrent hleft hright

end NumStability
