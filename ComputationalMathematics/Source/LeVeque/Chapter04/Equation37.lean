/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Equation37Target
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersPhysicalFluctuations
import ComputationalMathematics.Source.LeVeque.Chapter04.LinearRiemannTraceFlux

/-!
# LeVeque equation (4.37) for the selected concrete applications

The actual Burgers shock/fan, scalar affine traveling step and complete-real-
eigenbasis linear field have the original physical interface flux and its exact
positive-duration time average. Initial data and forward rectangle conservation
are conclusions for those same fields. Stationary modes need not have a unique
state trace; their physical flux has the asserted common trace.
-/

open MeasureTheory Filter
open scoped Topology

namespace NumStability

private theorem equation37_forward_of_rectangle
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {q : ℝ → ℝ → E} {f : E → E}
    (hq : IsRectangleConservationLawSolution q f) :
    Leveque04Equation37ForwardBalance q f := by
  exact ⟨fun time _ a b => hq.1 a b time,
    fun x s t _ _ => hq.2.1 x s t,
    fun a b s t _ _ => hq.2.2 a b s t⟩

private theorem equation37_burgers : Leveque04Equation37BurgersTarget := by
  intro left right
  have hq := leveque04_burgersSelectedField_isRectangleSolution left right
  refine ⟨leveque04_burgersSelectedField_initial left right,
    equation37_forward_of_rectangle hq, ?_, ?_, ?_⟩
  · intro time htime
    have hstate := leveque04_burgersSelectedField_interface left right time htime
    refine ⟨hstate, ?_⟩
    rw [hstate]
    rfl
  · intro duration hduration
    exact ⟨hq.2.1 0 0 duration,
      leveque04_burgersPhysicalInterfaceFlux_timeAverage left right duration hduration⟩
  · intro horder hstationary representative hrep
    exact (leveque04_burgersPhysicalFluctuations_stationary
      left right horder hstationary representative hrep).1

private theorem equation37_scalarAffine : Leveque04Equation37ScalarAffineTarget := by
  intro a b left right representative _hrep
  dsimp only
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro x
    simp only [travelingWave_zero]
  · apply equation37_forward_of_rectangle
    simpa only [smul_eq_mul] using
      travelingRiemann_isRectangleSolution_affineFlux a b left representative right
  · intro time htime
    have hv := travelingRiemann_affineFlux_zeroRay a b left representative right htime
    have hc := travelingRiemann_affineFlux_continuousAt_zero
      a b left representative right htime
    simp only [smul_eq_mul] at hv hc
    refine ⟨hv, hc, ?_, ?_⟩
    · simpa only [hv] using hc.continuousWithinAt.tendsto (s := Set.Iio (0 : ℝ))
    · simpa only [hv] using hc.continuousWithinAt.tendsto (s := Set.Ioi (0 : ℝ))
  · intro duration hduration
    exact scalarAffineRiemann_flux_timeAverage a b left representative right hduration

private theorem equation37_linearCommonFlux
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (left right : Fin m → ℝ) :
    affineRiemannInterfaceFlux coefficient 0 basis speeds left right =
      leveque04_linearGodunovFlux coefficient basis speeds left right := by
  have hbase := (leveque04_linearRiemannTraceFlux
    coefficient basis speeds heigen left right).trans
      (leveque04_equation49 coefficient basis speeds left right).symm
  have hray := linearRiemannSolution_rayZero basis speeds left left right
    (show (0 : ℝ) < 1 from zero_lt_one)
  simpa only [affineRiemannInterfaceFlux, affineMatrixFlux, add_zero, hray] using hbase

private theorem equation37_linear : Leveque04Equation37LinearTarget := by
  intro m _hm coefficient basis speeds heigen left right representative _hrep
  dsimp only
  have hcommon := equation37_linearCommonFlux coefficient basis speeds heigen left right
  refine ⟨linearRiemannSolution_initial basis speeds left representative right,
    linearRiemannSolution_eq_characteristicEvolution basis speeds left representative right,
    equation37_forward_of_rectangle
      (linearRiemannSolution_isRectangleSolution coefficient basis speeds heigen
        left representative right), ?_, ?_⟩
  · intro time htime
    have hflux := linearRiemannSolution_affineFlux_zeroRay
      coefficient 0 basis speeds heigen left representative right htime
    have hc := linearRiemannSolution_affineFlux_continuousAt_zero
      coefficient 0 basis speeds heigen left representative right htime
    have hlimits := linearRiemannSolution_affineFlux_tendsto_zero
      coefficient 0 basis speeds heigen left representative right htime
    simp only [affineMatrixFlux, add_zero, hcommon] at hflux hc hlimits
    exact ⟨linearRiemannSolution_rayZero basis speeds left representative right htime,
      hflux, hc, hlimits.1, hlimits.2⟩
  · intro duration hduration
    simpa only [affineMatrixFlux, add_zero, hcommon] using
      linearRiemannSolution_affineFlux_timeAverage coefficient 0 basis speeds heigen
        left representative right hduration

/-- The exact model-bound original equation (4.37), including every real
Burgers state pair, scalar affine physical offsets, and all positive finite
dimensions with a complete real eigenbasis and zero or repeated speeds. -/
theorem leveque04_equation37 : Leveque04Equation37Target :=
  ⟨equation37_burgers, equation37_scalarAffine, equation37_linear⟩

end NumStability
