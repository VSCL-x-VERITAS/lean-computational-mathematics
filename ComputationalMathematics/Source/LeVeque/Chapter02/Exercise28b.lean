/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Exercise28bTarget
import Mathlib.Tactic

/-!
# Exercise 2.8(b): isothermal p-system linearization and speeds
-/

namespace NumStability.Leveque02Tracer

private theorem reciprocalPressureResidual_firstVariation
    (a volumeBackground label volumeSpace : ℝ)
    (volumeVariation : ℝ → ℝ) (hvolume : 0 < volumeBackground)
    (hspace : HasDerivAt volumeVariation volumeSpace label) :
    HasDerivAt
      (fun amplitude : ℝ =>
        deriv (fun ξ =>
          a ^ 2 / (volumeBackground + amplitude * volumeVariation ξ)) label)
      (-(a ^ 2 / volumeBackground ^ 2) * volumeSpace) 0 := by
  let state : ℝ → ℝ :=
    fun amplitude => volumeBackground + amplitude * volumeVariation label
  let slope : ℝ → ℝ :=
    fun amplitude => -(a ^ 2 / state amplitude ^ 2) * volumeSpace
  have hstate : HasDerivAt state (volumeVariation label) 0 := by
    simpa [state] using
      ((hasDerivAt_id (x := (0 : ℝ))).mul_const
        (volumeVariation label)).const_add volumeBackground
  have hstateNe : ∀ᶠ amplitude : ℝ in nhds (0 : ℝ),
      state amplitude ≠ 0 := by
    have hzero : state 0 ≠ 0 := by
      simpa [state] using (ne_of_gt hvolume)
    exact hstate.continuousAt.eventually_ne hzero
  have hslopeDiff : DifferentiableAt ℝ slope 0 := by
    have hpow : DifferentiableAt ℝ (fun amplitude => state amplitude ^ 2) 0 :=
      hstate.differentiableAt.pow 2
    have hdiv : DifferentiableAt ℝ
        (fun amplitude => a ^ 2 / state amplitude ^ 2) 0 :=
      (differentiableAt_const (a ^ 2)).div hpow
        (by simpa [state] using pow_ne_zero 2 (ne_of_gt hvolume))
    exact hdiv.neg.mul_const volumeSpace
  have hproduct : HasDerivAt (fun amplitude : ℝ => amplitude * slope amplitude)
      (slope 0) 0 := by
    simpa using (hasDerivAt_id (0 : ℝ)).mul hslopeDiff.hasDerivAt
  have hevent :
      (fun amplitude : ℝ =>
        deriv (fun ξ =>
          a ^ 2 / (volumeBackground + amplitude * volumeVariation ξ)) label)
        =ᶠ[nhds 0] (fun amplitude => amplitude * slope amplitude) := by
    filter_upwards [hstateNe] with amplitude hnonzero
    have hspaceAmplitude : HasDerivAt
        (fun ξ => volumeBackground + amplitude * volumeVariation ξ)
        (amplitude * volumeSpace) label := by
      simpa using (hspace.const_mul amplitude).const_add volumeBackground
    have hpressureAmplitude : HasDerivAt
        (fun ξ =>
          a ^ 2 / (volumeBackground + amplitude * volumeVariation ξ))
        (amplitude * slope amplitude) label := by
      have hinv := hspaceAmplitude.inv (by simpa [state] using hnonzero)
      convert hinv.const_mul (a ^ 2) using 1 <;>
        simp [slope, state, div_eq_mul_inv] <;> ring
    exact hpressureAmplitude.deriv
  have hresult := hproduct.congr_of_eventuallyEq hevent
  simpa [slope, state] using hresult

/-- The actual first variation of both isothermal p-system residuals gives
the Lagrangian linearized equations; its roots convert to Eulerian speeds. -/
theorem exercise28b : exercise28bTarget := by
  intro a volumeBackground velocityBackground hvolume
  let pressureLaw : ℝ → ℝ := fun volume => a ^ 2 / volume
  let pressureSlope : ℝ := -(a ^ 2 / volumeBackground ^ 2)
  let coefficient : Matrix (Fin 2) (Fin 2) ℝ :=
    !![0, -1; pressureSlope, 0]
  have hpressure : HasDerivAt pressureLaw pressureSlope volumeBackground := by
    have hinv := (hasDerivAt_id (x := volumeBackground)).inv
      (ne_of_gt hvolume)
    convert hinv.const_mul (a ^ 2) using 1 <;>
      simp [pressureLaw, pressureSlope, div_eq_mul_inv] <;> ring
  refine ⟨hpressure, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro volumeVariation velocityVariation
    have hvolumeAmplitude : HasDerivAt
        (fun amplitude : ℝ => volumeBackground + amplitude * volumeVariation)
        volumeVariation 0 := by
      simpa using ((hasDerivAt_id (x := (0 : ℝ))).mul_const
        volumeVariation).const_add volumeBackground
    constructor
    · have hvelocityAmplitude : HasDerivAt
          (fun amplitude : ℝ =>
            velocityBackground + amplitude * velocityVariation)
          velocityVariation 0 := by
        simpa using ((hasDerivAt_id (x := (0 : ℝ))).mul_const
          velocityVariation).const_add velocityBackground
      convert hvelocityAmplitude.neg using 1 <;> simp
    · have hpressureAt :
          HasDerivAt pressureLaw pressureSlope
            (volumeBackground + 0 * volumeVariation) := by
        simpa using hpressure
      convert hpressureAt.comp 0 hvolumeAmplitude using 1 <;>
        simp [pressureLaw, pressureSlope]
  · intro volumeVariation velocityVariation label time
      volumeTime volumeSpace velocityTime velocitySpace
      hvolumeTime hvolumeSpace hvelocityTime hvelocitySpace
    have hmass : HasDerivAt
        (fun amplitude : ℝ =>
          deriv (fun τ =>
            volumeBackground + amplitude * volumeVariation label τ) time -
          deriv (fun ξ =>
            velocityBackground + amplitude * velocityVariation ξ time) label)
        (volumeTime - velocitySpace) 0 := by
      have hfun :
          (fun amplitude : ℝ =>
            deriv (fun τ =>
              volumeBackground + amplitude * volumeVariation label τ) time -
            deriv (fun ξ =>
              velocityBackground + amplitude * velocityVariation ξ time) label) =
            (fun amplitude => amplitude * (volumeTime - velocitySpace)) := by
        funext amplitude
        rw [((hvolumeTime.const_mul amplitude).const_add
          volumeBackground).deriv,
          ((hvelocitySpace.const_mul amplitude).const_add
            velocityBackground).deriv]
        ring
      rw [hfun]
      simpa using (hasDerivAt_id (0 : ℝ)).mul_const
        (volumeTime - velocitySpace)
    have hpressureVariation :=
      reciprocalPressureResidual_firstVariation a volumeBackground label
        volumeSpace (fun ξ => volumeVariation ξ time) hvolume hvolumeSpace
    have hvelocityVariation : HasDerivAt
        (fun amplitude : ℝ =>
          deriv (fun τ =>
            velocityBackground + amplitude * velocityVariation label τ) time)
        velocityTime 0 := by
      have hfun :
          (fun amplitude : ℝ =>
            deriv (fun τ =>
              velocityBackground + amplitude * velocityVariation label τ) time) =
            (fun amplitude => amplitude * velocityTime) := by
        funext amplitude
        exact ((hvelocityTime.const_mul amplitude).const_add
          velocityBackground).deriv
      rw [hfun]
      simpa using (hasDerivAt_id (0 : ℝ)).mul_const velocityTime
    refine ⟨hmass, ?_⟩
    simpa [pressureLaw, pressureSlope] using
      hvelocityVariation.add hpressureVariation
  · intro variationTime variationSpace
    constructor
    · intro hmatrix
      have hfirst := congrFun hmatrix (0 : Fin 2)
      have hsecond := congrFun hmatrix (1 : Fin 2)
      simp [coefficient, Matrix.mulVec, dotProduct, Fin.sum_univ_two,
        pressureSlope] at hfirst hsecond
      constructor <;> linarith
    · rintro ⟨hfirst, hsecond⟩
      funext i
      fin_cases i <;>
        simp [coefficient, Matrix.mulVec, dotProduct, Fin.sum_univ_two,
          pressureSlope] <;> linarith
  · intro eigenvalue
    have hdet :
        Matrix.det (coefficient - eigenvalue •
          (1 : Matrix (Fin 2) (Fin 2) ℝ)) =
        eigenvalue ^ 2 - a ^ 2 / volumeBackground ^ 2 := by
      simp [coefficient, pressureSlope, Matrix.det_fin_two,
        Matrix.sub_apply, Matrix.smul_apply, Matrix.cons_val_zero,
        Matrix.cons_val_one]
      ring
    rw [hdet]
    have hfactor :
        eigenvalue ^ 2 - a ^ 2 / volumeBackground ^ 2 =
          (eigenvalue + a / volumeBackground) *
            (eigenvalue - a / volumeBackground) := by
      field_simp [ne_of_gt hvolume]
      ring
    rw [hfactor]
    constructor
    · intro h
      rcases mul_eq_zero.mp h with h | h
      · left
        calc
          eigenvalue = -(a / volumeBackground) :=
            eq_neg_of_add_eq_zero_left h
          _ = -a / volumeBackground := by ring
      · right
        exact sub_eq_zero.mp h
    · rintro (h | h)
      · rw [h]
        ring
      · rw [h]
        ring
  · intro referenceLocation label labelSpeed
    have hfun :
        (fun time : ℝ => referenceLocation +
          volumeBackground * (label + labelSpeed * time) +
            velocityBackground * time) =
          (fun time =>
            (volumeBackground * labelSpeed + velocityBackground) * time +
              (referenceLocation + volumeBackground * label)) := by
      funext time
      ring
    rw [hfun]
    convert ((hasDerivAt_id (x := (0 : ℝ))).const_mul
      (volumeBackground * labelSpeed + velocityBackground)).add_const
      (referenceLocation + volumeBackground * label) using 1 <;> ring
  · constructor <;> field_simp [ne_of_gt hvolume] <;> ring

end NumStability.Leveque02Tracer
