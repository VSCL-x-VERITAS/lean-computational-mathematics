/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Exercise26Target

/-!
# Exercise 2.6: the particle-position Jacobian and mixed partials

The moving-interval mass identity gives the derivative of particle position
with respect to the mass label by the fundamental theorem of calculus.
-/

open MeasureTheory

namespace NumStability.Leveque02Tracer

/-- The moving-interval identity yields `X_ξ=V`; with `X_t=U`, the
Lagrangian mass equation (2.105) says exactly that the two mixed partials
of `X` coincide. -/
theorem exercise26 : exercise26Target := by
  intro particlePosition eulerianVelocity eulerianDensity
    referenceLabel label time volumeTime velocityLabel
    labelThenTime timeThenLabel hcontinuous _hpositive hintegral htime
    hvolumeTime hvelocityLabel hlabelThenTime htimeThenLabel
  let V := lagrangianSpecificVolume eulerianDensity particlePosition
  let U := lagrangianParticleVelocity eulerianVelocity particlePosition
  have hlabel (η τ : ℝ) :
      HasDerivAt (fun ζ => particlePosition ζ τ) (V η τ) η := by
    have hftc :
        HasDerivAt (fun z => ∫ ζ in referenceLabel..z, V ζ τ)
          (V η τ) η :=
      intervalIntegral.integral_hasDerivAt_right
        ((hcontinuous τ).intervalIntegrable referenceLabel η)
        ((hcontinuous τ).aestronglyMeasurable.stronglyMeasurableAtFilter)
        ((hcontinuous τ).continuousAt)
    have hfunctions :
        (fun z => ∫ ζ in referenceLabel..z, V ζ τ) =
          (fun z => particlePosition z τ -
            particlePosition referenceLabel τ) := by
      funext z
      exact hintegral z τ
    rw [hfunctions] at hftc
    simpa only [sub_add_cancel] using
      hftc.add_const (particlePosition referenceLabel τ)
  have hlabelDeriv :
      (fun τ => deriv (fun η => particlePosition η τ) label) =
        (fun τ => V label τ) := by
    funext τ
    exact (hlabel label τ).deriv
  have htimeDeriv :
      (fun η => deriv (fun τ => particlePosition η τ) time) =
        (fun η => U η time) := by
    funext η
    exact (htime η time).deriv
  rw [hlabelDeriv] at hlabelThenTime
  rw [htimeDeriv] at htimeThenLabel
  have hfirst : labelThenTime = volumeTime :=
    hlabelThenTime.unique hvolumeTime
  have hsecond : timeThenLabel = velocityLabel :=
    htimeThenLabel.unique hvelocityLabel
  refine ⟨?_, hfirst, hsecond, ?_⟩
  · intro η τ
    exact hlabel η τ
  · rw [hfirst, hsecond]
    constructor <;> intro h <;> linarith

end NumStability.Leveque02Tracer
