/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CrankNicolsonFluxAccuracyTarget
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalCellAverageSlope
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalTrapezoidalAverage

/-!
# Local accuracy of the actual Crank–Nicolson face flux

The spatial estimate uses only the two cells at each endpoint time. The
temporal estimate compares the physical endpoint mean with its actual time
average. Finite real components commute with these integrable averages.
-/

open MeasureTheory
open scoped Interval

namespace NumStability

private theorem cnFluxAccuracy_scalar : Leveque04CNFluxAccuracyScalarTarget := by
  intro q qX qXX diffusivity coefficient K B curvatureBound origin width oldTime
    timeStep i hK hB hcurvature hw ht
  dsimp only
  intro hregularity
  rcases hregularity with ⟨_hface, hq, hqX, hvariation, hgradient, hsmooth, hcurv⟩
  let face := origin + (i : ℝ) * width - width / 2
  let averages := fun time => leveque04_cnAccuracyReferenceAverages q origin width time
  let physical := fun time => -(diffusivity face * qX face time)
  let numerical := leveque04_crankNicolsonInterfaceFlux coefficient width
    (averages oldTime) (averages (oldTime + timeStep)) i
  let spatial := 2 * |coefficient i| * K * width ^ 2 +
    |coefficient i - diffusivity face| * B
  have hright : origin + (i : ℝ) * width + width / 2 = face + width := by
    dsimp [face]; ring
  have hleft : origin + ((i - 1 : ℤ) : ℝ) * width - width / 2 = face - width := by
    push_cast; dsimp [face]; ring
  have hleftRight : origin + ((i - 1 : ℤ) : ℝ) * width + width / 2 = face := by
    push_cast; dsimp [face]; ring
  have hcell (time : ℝ) (hend : time = oldTime ∨ time = oldTime + timeStep) :
      IntervalIntegrable (fun x => q x time) volume (face - width) face ∧
        IntervalIntegrable (fun x => q x time) volume face (face + width) := by
    have hc : ContinuousOn (fun x => q x time) (Set.Icc (face - width) (face + width)) :=
      fun x hx => (hq time hend x hx).continuousAt.continuousWithinAt
    constructor
    · apply ContinuousOn.intervalIntegrable_of_Icc (by linarith : face - width ≤ face)
      exact hc.mono (by intro x hx; exact ⟨hx.1, by linarith [hx.2]⟩)
    · apply ContinuousOn.intervalIntegrable_of_Icc (by linarith : face ≤ face + width)
      exact hc.mono (by intro x hx; exact ⟨by linarith [hx.1], hx.2⟩)
  have hphysical : IntervalIntegrable physical volume oldTime (oldTime + timeStep) :=
    hsmooth.continuousOn.intervalIntegrable
  have hsingle (time : ℝ) (hend : time = oldTime ∨ time = oldTime + timeStep) :
      |leveque04_diffusionInterfaceFlux coefficient (averages time) width i - physical time| ≤ spatial := by
    have h := local_oneDimensionalCellAverage_diffusionFlux_error
      (fun x => q x time) (fun x => qX x time) (fun x => qXX x time)
      K B (diffusivity face) (coefficient i) face width hK hw
      (hq time hend) (hqX time hend) (hvariation time hend) (hgradient time hend)
    simpa only [leveque04_diffusionInterfaceFlux, Leveque02Tracer.fickFlux,
      averages, leveque04_cnAccuracyReferenceAverages, hright, hleft, hleftRight,
      physical, spatial] using h
  have hmean : |numerical - (physical oldTime + physical (oldTime + timeStep)) / 2| ≤ spatial := by
    have hold := hsingle oldTime (Or.inl rfl)
    have hnew := hsingle (oldTime + timeStep) (Or.inr rfl)
    have htriangle := abs_add_le
      (leveque04_diffusionInterfaceFlux coefficient (averages oldTime) width i - physical oldTime)
      (leveque04_diffusionInterfaceFlux coefficient (averages (oldTime + timeStep)) width i - physical (oldTime + timeStep))
    have heq : numerical - (physical oldTime + physical (oldTime + timeStep)) / 2 =
        ((leveque04_diffusionInterfaceFlux coefficient (averages oldTime) width i - physical oldTime) +
          (leveque04_diffusionInterfaceFlux coefficient (averages (oldTime + timeStep)) width i - physical (oldTime + timeStep))) / 2 := by
      dsimp [numerical, leveque04_crankNicolsonInterfaceFlux]; ring
    rw [heq, abs_div, show |(2 : ℝ)| = 2 by norm_num]
    linarith
  have hquadrature := endpointMean_physicalAverage_error_le_of_local_c2
    physical oldTime timeStep curvatureBound ht hcurvature hsmooth hcurv
  have hbound : |numerical - oneDimensionalCellAverage physical oldTime (oldTime + timeStep)| ≤
      spatial + curvatureBound * timeStep ^ 2 / 12 := by
    exact (abs_sub_le numerical ((physical oldTime + physical (oldTime + timeStep)) / 2)
      (oneDimensionalCellAverage physical oldTime (oldTime + timeStep))).trans
      (add_le_add hmean hquadrature)
  refine ⟨hcell, hphysical, hbound, ?_⟩
  intro D E _hD _hE hcoefficient herr
  have hscale := mul_le_mul_of_nonneg_right hcoefficient
    (mul_nonneg (by linarith : 0 ≤ 2 * K) (sq_nonneg width))
  have herror := mul_le_mul_of_nonneg_right herr hB
  change |numerical - oneDimensionalCellAverage physical oldTime (oldTime + timeStep)| ≤ _
  calc
    _ ≤ spatial + curvatureBound * timeStep ^ 2 / 12 := hbound
    _ ≤ (2 * D * K + E * B) * width ^ 2 + curvatureBound * timeStep ^ 2 / 12 := by
      dsimp [spatial]
      nlinarith

private theorem cnFluxAccuracy_vector : Leveque04CNFluxAccuracyVectorTarget := by
  intro m _hm q qX qXX diffusivity coefficient K B curvatureBound origin width
    oldTime timeStep i hK hB hcurvature hw ht
  dsimp only
  intro hregularity
  let face := origin + (i : ℝ) * width - width / 2
  let numerical := leveque04_cnAccuracyComponentFlux coefficient width
    (leveque04_cnAccuracyReferenceAverages q origin width oldTime)
    (leveque04_cnAccuracyReferenceAverages q origin width (oldTime + timeStep)) i
  let physical := fun time => (-diffusivity face) • qX face time
  let reference := oneDimensionalCellAverage physical oldTime (oldTime + timeStep)
  have hp (p : Fin m) := cnFluxAccuracy_scalar
    (fun x time => q x time p) (fun x time => qX x time p) (fun x time => qXX x time p)
    diffusivity coefficient K B curvatureBound origin width oldTime timeStep i
    hK hB hcurvature hw ht (hregularity p)
  have hcell (time : ℝ) (hend : time = oldTime ∨ time = oldTime + timeStep) :
      IntervalIntegrable (fun x => q x time) volume (face - width) face ∧
        IntervalIntegrable (fun x => q x time) volume face (face + width) := by
    constructor
    · apply (intervalIntegrable_pi_iff _ _ _).mpr
      intro p
      exact ((hp p).1 time hend).1
    · apply (intervalIntegrable_pi_iff _ _ _).mpr
      intro p
      exact ((hp p).1 time hend).2
  have hphysical : IntervalIntegrable physical volume oldTime (oldTime + timeStep) := by
    apply (intervalIntegrable_pi_iff _ _ _).mpr
    intro p
    simpa only [physical, Pi.smul_apply, smul_eq_mul, neg_mul] using (hp p).2.1
  have hright : origin + (i : ℝ) * width + width / 2 = face + width := by
    dsimp [face]; ring
  have hleft : origin + ((i - 1 : ℤ) : ℝ) * width - width / 2 = face - width := by
    push_cast; dsimp [face]; ring
  have hleftRight : origin + ((i - 1 : ℤ) : ℝ) * width + width / 2 = face := by
    push_cast; dsimp [face]; ring
  have hcellj (time : ℝ) (hend : time = oldTime ∨ time = oldTime + timeStep)
      (j : ℤ) (hj : j = i ∨ j = i - 1) :
      IntervalIntegrable (fun x => q x time) volume
        (origin + (j : ℝ) * width - width / 2) (origin + (j : ℝ) * width + width / 2) := by
    rcases hj with rfl | rfl
    · simpa only [hright] using (hcell time hend).2
    · simpa only [hleft, hleftRight] using (hcell time hend).1
  have hcoordinate (time : ℝ) (hend : time = oldTime ∨ time = oldTime + timeStep)
      (j : ℤ) (hj : j = i ∨ j = i - 1) (p : Fin m) :
      leveque04_cnAccuracyReferenceAverages q origin width time j p =
        leveque04_cnAccuracyReferenceAverages (fun x t => q x t p) origin width time j := by
    exact oneDimensionalCellAverage_apply _ _ _ (hcellj time hend j hj) p
  have hreference (p : Fin m) : reference p =
      oneDimensionalCellAverage (fun time => -(diffusivity face * qX face time p))
        oldTime (oldTime + timeStep) := by
    simpa only [physical, Pi.smul_apply, smul_eq_mul, neg_mul] using
      oneDimensionalCellAverage_apply physical oldTime (oldTime + timeStep) hphysical p
  have hnumerical (p : Fin m) : numerical p =
      leveque04_crankNicolsonInterfaceFlux coefficient width
        (leveque04_cnAccuracyReferenceAverages (fun x t => q x t p) origin width oldTime)
        (leveque04_cnAccuracyReferenceAverages (fun x t => q x t p) origin width (oldTime + timeStep)) i := by
    dsimp only [numerical, leveque04_cnAccuracyComponentFlux,
      leveque04_crankNicolsonInterfaceFlux, leveque04_diffusionInterfaceFlux]
    rw [hcoordinate oldTime (Or.inl rfl) i (Or.inl rfl) p,
      hcoordinate oldTime (Or.inl rfl) (i - 1) (Or.inr rfl) p,
      hcoordinate (oldTime + timeStep) (Or.inr rfl) i (Or.inl rfl) p,
      hcoordinate (oldTime + timeStep) (Or.inr rfl) (i - 1) (Or.inr rfl) p]
  have hbound : ‖numerical - reference‖ ≤
      2 * |coefficient i| * K * width ^ 2 + |coefficient i - diffusivity face| * B +
        curvatureBound * timeStep ^ 2 / 12 := by
    apply (pi_norm_le_iff_of_nonneg (by positivity)).mpr
    intro p
    simp only [Pi.sub_apply, Real.norm_eq_abs]
    rw [hnumerical, hreference]
    exact (hp p).2.2.1
  refine ⟨hcell, hphysical, hcoordinate, hreference, hbound, ?_⟩
  intro D E hD hE hcoefficient herr
  change ‖numerical - reference‖ ≤ _
  apply (pi_norm_le_iff_of_nonneg (by positivity)).mpr
  intro p
  simp only [Pi.sub_apply, Real.norm_eq_abs]
  rw [hnumerical, hreference]
  exact (hp p).2.2.2 D E hD hE hcoefficient herr

/-- The frozen local scalar CN flux estimate and its finite-component
extension hold for the actual integrable space and time averages. -/
theorem leveque04_crankNicolsonFluxAccuracy : Leveque04CNFluxAccuracyTarget :=
  ⟨cnFluxAccuracy_scalar, cnFluxAccuracy_vector⟩

end NumStability
