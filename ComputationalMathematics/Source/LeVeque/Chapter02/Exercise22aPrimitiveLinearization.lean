/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Exercise22aPrimitiveLinearizationTarget
import Mathlib.Tactic

/-!
# First variation of the nonlinear pressure-velocity residual
-/

namespace NumStability.Leveque02Tracer

private theorem amplitude_mul_hasDerivAt
    (g : ℝ → ℝ) (hg : DifferentiableAt ℝ g 0) :
    HasDerivAt (fun amplitude => amplitude * g amplitude) (g 0) 0 := by
  simpa using (hasDerivAt_id (0 : ℝ)).mul hg.hasDerivAt

/-- At a constant positive-density state, the first amplitude variation of
the primitive nonlinear residual is exactly the pressure-velocity acoustic
system. -/
theorem exercise22aPrimitiveLinearization :
    exercise22aPrimitiveLinearizationTarget := by
  intro pressureLaw densityFromPressure slopeFromPressure
    backgroundDensity backgroundVelocity pressureSlope
    pressurePerturbation velocityPerturbation
    x t pressureTime pressureSpace velocityTime velocitySpace
    hpositive hP hinverse hslope hRdiff hSdiff
    hpTime hpSpace huTime huSpace
  have hR0 :
      densityFromPressure (pressureLaw backgroundDensity) =
        backgroundDensity := hinverse backgroundDensity hpositive
  have hS0 :
      slopeFromPressure (pressureLaw backgroundDensity) =
        pressureSlope := by
    have hactual := hslope (pressureLaw backgroundDensity)
      (by simpa [hR0] using hpositive)
    have hactual' : HasDerivAt pressureLaw
        (slopeFromPressure (pressureLaw backgroundDensity))
        backgroundDensity := by simpa [hR0] using hactual
    exact hactual'.unique hP
  let p0 := pressureLaw backgroundDensity
  let pValue := pressurePerturbation x t
  let uValue := velocityPerturbation x t
  have hpAmplitude :
      HasDerivAt (fun amplitude : ℝ => p0 + amplitude * pValue)
        pValue 0 := by
    convert (hasDerivAt_const (0 : ℝ) p0).add
      ((hasDerivAt_id (0 : ℝ)).mul_const pValue) using 1; simp
  have huAmplitude :
      HasDerivAt (fun amplitude : ℝ =>
        backgroundVelocity + amplitude * uValue) uValue 0 := by
    convert (hasDerivAt_const (0 : ℝ) backgroundVelocity).add
      ((hasDerivAt_id (0 : ℝ)).mul_const uValue) using 1; simp
  have hRAmplitude : DifferentiableAt ℝ
      (fun amplitude : ℝ =>
        densityFromPressure (p0 + amplitude * pValue)) 0 := by
    have hRdiff' : DifferentiableAt ℝ densityFromPressure
        (p0 + 0 * pValue) := by simpa [p0] using hRdiff
    exact hRdiff'.comp 0 hpAmplitude.differentiableAt
  have hSAmplitude : DifferentiableAt ℝ
      (fun amplitude : ℝ =>
        slopeFromPressure (p0 + amplitude * pValue)) 0 := by
    have hSdiff' : DifferentiableAt ℝ slopeFromPressure
        (p0 + 0 * pValue) := by simpa [p0] using hSdiff
    exact hSdiff'.comp 0 hpAmplitude.differentiableAt
  have hRAmplitudeInv : DifferentiableAt ℝ
      (fun amplitude : ℝ =>
        (densityFromPressure (p0 + amplitude * pValue))⁻¹) 0 := by
    exact hRAmplitude.inv (by simpa [p0, hR0] using (ne_of_gt hpositive))
  let gPressure : ℝ → ℝ := fun amplitude =>
    pressureTime +
      (backgroundVelocity + amplitude * uValue) * pressureSpace +
      (densityFromPressure (p0 + amplitude * pValue) *
        slopeFromPressure (p0 + amplitude * pValue)) * velocitySpace
  let gVelocity : ℝ → ℝ := fun amplitude =>
    velocityTime +
      (densityFromPressure (p0 + amplitude * pValue))⁻¹ * pressureSpace +
      (backgroundVelocity + amplitude * uValue) * velocitySpace
  have hgPressure : DifferentiableAt ℝ gPressure 0 := by
    dsimp [gPressure]
    exact ((differentiableAt_const _).add
      (huAmplitude.differentiableAt.mul_const pressureSpace)).add
        ((hRAmplitude.mul hSAmplitude).mul_const velocitySpace)
  have hgVelocity : DifferentiableAt ℝ gVelocity 0 := by
    dsimp [gVelocity]
    exact ((differentiableAt_const _).add
      (hRAmplitudeInv.mul_const pressureSpace)).add
        (huAmplitude.differentiableAt.mul_const velocitySpace)
  have hpressureResidual : HasDerivAt
      (fun amplitude =>
        amplitude * pressureTime +
          (backgroundVelocity + amplitude * uValue) *
            (amplitude * pressureSpace) +
          (densityFromPressure (p0 + amplitude * pValue) *
            slopeFromPressure (p0 + amplitude * pValue)) *
            (amplitude * velocitySpace))
      (pressureTime + backgroundVelocity * pressureSpace +
        backgroundDensity * pressureSlope * velocitySpace) 0 := by
    have h := amplitude_mul_hasDerivAt gPressure hgPressure
    convert h using 1
    · funext amplitude
      dsimp [gPressure]
      ring
    · simp [gPressure, p0, hR0, hS0]
  have hvelocityResidual : HasDerivAt
      (fun amplitude =>
        amplitude * velocityTime +
          (densityFromPressure (p0 + amplitude * pValue))⁻¹ *
            (amplitude * pressureSpace) +
          (backgroundVelocity + amplitude * uValue) *
            (amplitude * velocitySpace))
      (velocityTime + backgroundDensity⁻¹ * pressureSpace +
        backgroundVelocity * velocitySpace) 0 := by
    have h := amplitude_mul_hasDerivAt gVelocity hgVelocity
    convert h using 1
    · funext amplitude
      dsimp [gVelocity]
      ring
    · simp [gVelocity, p0, hR0]
  dsimp [exercise22aPrimitiveLinearizationTarget]
  refine ⟨?_, hpressureResidual, hvelocityResidual, ?_⟩
  · intro amplitude
    constructor
    · simpa using (hpTime.const_mul amplitude).const_add p0
    constructor
    · simpa using (hpSpace.const_mul amplitude).const_add p0
    constructor
    · simpa using (huTime.const_mul amplitude).const_add backgroundVelocity
    · simpa using (huSpace.const_mul amplitude).const_add backgroundVelocity
  · constructor
    · rintro ⟨hzeroPressure, hzeroVelocity⟩
      have hfirst := hzeroPressure.unique hpressureResidual
      have hsecond := hzeroVelocity.unique hvelocityResidual
      constructor
      · linarith
      · have hρne : backgroundDensity ≠ 0 := ne_of_gt hpositive
        field_simp [hρne] at hsecond ⊢
        nlinarith [hsecond]
    · rintro ⟨hfirst, hsecond⟩
      constructor
      · convert hpressureResidual using 1
        exact hfirst.symm
      · have hρne : backgroundDensity ≠ 0 := ne_of_gt hpositive
        have hsecond' :
            velocityTime + backgroundDensity⁻¹ * pressureSpace +
              backgroundVelocity * velocitySpace = 0 := by
          field_simp [hρne]
          linear_combination hsecond
        convert hvelocityResidual using 1
        exact hsecond'.symm

end NumStability.Leveque02Tracer
