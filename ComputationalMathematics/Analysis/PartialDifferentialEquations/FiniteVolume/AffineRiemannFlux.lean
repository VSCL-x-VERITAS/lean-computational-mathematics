/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannFluxAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ConstantTraceAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RectangleFluxShift

/-!
# Physical flux of actual affine Riemann fields

The existing traveling-step and eigenbasis constructions solve conservation
laws with an added constant physical flux. Their actual zero-ray flux is
independent of the origin representative and its normalized time average is
exact for every positive duration. Stationary modes can jump in state, while
the actual physical flux is continuous at the interface.

These are source-independent affine extensions of the linear constructions.
No mesh, CFL, strict hyperbolicity, or assumed solver correctness is used.
-/

open MeasureTheory Filter
open scoped BigOperators Topology

namespace NumStability

private theorem riemannData_continuousAt_of_ne_zero
    {E : Type*} [TopologicalSpace E] (left atOrigin right : E)
    {x : ℝ} (hx : x ≠ 0) : ContinuousAt (riemannData left atOrigin right) x := by
  rcases lt_or_gt_of_ne hx with hneg | hpos
  · apply (continuousAt_const : ContinuousAt (fun _ : ℝ => left) x).congr_of_eventuallyEq
    filter_upwards [Iio_mem_nhds hneg] with y hy
    change y < 0 at hy
    simp [riemannData, hy]
  · apply (continuousAt_const : ContinuousAt (fun _ : ℝ => right) x).congr_of_eventuallyEq
    filter_upwards [Ioi_mem_nhds hpos] with y hy
    change 0 < y at hy
    simp [riemannData, hy, not_lt_of_ge hy.le]

section Transport

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- The actual moving Riemann step solves the affine physical flux law. -/
theorem travelingRiemann_isRectangleSolution_affineFlux
    (speed : ℝ) (offset left atOrigin right : E) :
    IsRectangleConservationLawSolution
      (travelingWave (riemannData left atOrigin right) speed)
      (fun q => speed • q + offset) := by
  apply IsRectangleConservationLawSolution.of_flux_eq_add_const
    _ (fun q => speed • q) _ offset
    (travelingWave_isRectangleConservationLawSolution _
      (riemannData_intervalIntegrable left atOrigin right) speed)
  intro x t
  rfl

/-- Its physical zero-ray flux uses the upwind state; zero speed leaves only
the physical offset, regardless of the chosen point value. -/
theorem travelingRiemann_affineFlux_zeroRay
    (speed : ℝ) (offset left atOrigin right : E) {time : ℝ} (htime : 0 < time) :
    speed • travelingWave (riemannData left atOrigin right) speed 0 time + offset =
      if speed < 0 then speed • right + offset else speed • left + offset := by
  rcases lt_trichotomy speed 0 with hs | hs | hs
  · have harg : 0 < 0 - speed * time := by nlinarith
    simp only [travelingWave, riemannData, if_neg (not_lt_of_ge harg.le),
      if_pos harg, if_pos hs]
  · subst speed
    simp
  · have harg : 0 - speed * time < 0 := by nlinarith
    simp only [travelingWave, riemannData, if_pos harg, if_neg (not_lt_of_ge hs.le)]

/-- The actual physical flux is continuous through a stationary state jump. -/
theorem travelingRiemann_affineFlux_continuousAt_zero
    (speed : ℝ) (offset left atOrigin right : E) {time : ℝ} (htime : 0 < time) :
    ContinuousAt (fun x =>
      speed • travelingWave (riemannData left atOrigin right) speed x time + offset) 0 := by
  by_cases hs : speed = 0
  · simp only [hs, zero_smul, zero_add]
    exact continuousAt_const
  · have harg : (0 : ℝ) - speed * time ≠ 0 := by
      simpa only [zero_sub, neg_ne_zero] using mul_ne_zero hs htime.ne'
    have hc := (riemannData_continuousAt_of_ne_zero left atOrigin right harg).comp (x := 0)
      (show ContinuousAt (fun x : ℝ => x - speed * time) 0 from
        continuousAt_id.sub continuousAt_const)
    simpa only [travelingWave] using (hc.const_smul speed).add_const offset

/-- The true normalized physical time average includes the affine offset. -/
theorem travelingRiemann_affineFlux_timeAverage [CompleteSpace E]
    (speed : ℝ) (offset left atOrigin right : E)
    {duration : ℝ} (hduration : 0 < duration) :
    IntervalIntegrable (fun time =>
      speed • travelingWave (riemannData left atOrigin right) speed 0 time + offset)
      volume 0 duration ∧
    oneDimensionalCellAverage (fun time =>
      speed • travelingWave (riemannData left atOrigin right) speed 0 time + offset)
      0 duration =
        if speed < 0 then speed • right + offset else speed • left + offset := by
  simpa only [id_eq] using oneDimensionalCellAverage_map_of_constantTraceOn id
    (fun time => speed • travelingWave (riemannData left atOrigin right) speed 0 time + offset)
    (if speed < 0 then speed • right + offset else speed • left + offset)
    0 duration hduration (fun time htime =>
      travelingRiemann_affineFlux_zeroRay speed offset left atOrigin right htime.1)

/-- In particular this is the scalar physical flux `a*q+b`, for all real
speeds, offsets, states and origin representatives. -/
theorem scalarAffineRiemann_flux_timeAverage
    (a b left atOrigin right : ℝ) {duration : ℝ} (hduration : 0 < duration) :
    IntervalIntegrable (fun time =>
      a * travelingWave (riemannData left atOrigin right) a 0 time + b) volume 0 duration ∧
    (∫ time in (0 : ℝ)..duration,
      a * travelingWave (riemannData left atOrigin right) a 0 time + b) / duration =
        if a < 0 then a * right + b else a * left + b := by
  simpa only [smul_eq_mul, oneDimensionalCellAverage, sub_zero, div_eq_inv_mul] using
    travelingRiemann_affineFlux_timeAverage a b left atOrigin right hduration

end Transport

section Matrix

variable {ι : Type*} [Fintype ι]

/-- The physical affine matrix flux, including its constant offset. -/
def affineMatrixFlux (A : Matrix ι ι ℝ) (offset q : ι → ℝ) : ι → ℝ :=
  A.mulVec q + offset

/-- An affine physical offset cancels from the actual flux difference. -/
theorem affineMatrixFlux_sub (A : Matrix ι ι ℝ) (offset left right : ι → ℝ) :
    affineMatrixFlux A offset left - affineMatrixFlux A offset right =
      A.mulVec (left - right) := by
  simp [affineMatrixFlux, Matrix.mulVec_sub]

/-- Physical flux of the actual left-selected linear Riemann interface state. -/
noncomputable def affineRiemannInterfaceFlux (A : Matrix ι ι ℝ) (offset : ι → ℝ)
    (basis : Module.Basis ι ℝ (ι → ℝ)) (speeds : ι → ℝ) (left right : ι → ℝ) : ι → ℝ :=
  affineMatrixFlux A offset
    (selectedLinearRiemannRayZeroValue basis speeds left left right)

/-- The existing actual eigenbasis Riemann field solves the affine law. -/
theorem linearRiemannSolution_isRectangleSolution_affineFlux
    (A : Matrix ι ι ℝ) (offset : ι → ℝ)
    (basis : Module.Basis ι ℝ (ι → ℝ)) (speeds : ι → ℝ)
    (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (left atOrigin right : ι → ℝ) :
    IsRectangleConservationLawSolution
      (linearRiemannSolution basis speeds left atOrigin right) (affineMatrixFlux A offset) := by
  apply IsRectangleConservationLawSolution.of_flux_eq_add_const
    _ A.mulVec _ offset
    (linearRiemannSolution_isRectangleSolution A basis speeds heigen left atOrigin right)
  intro x t
  rfl

/-- A stationary mode changes no physical flux, so every origin representative
gives the same positive-time interface flux. -/
theorem linearRiemannSolution_affineFlux_origin_independent
    (A : Matrix ι ι ℝ) (offset : ι → ℝ)
    (basis : Module.Basis ι ℝ (ι → ℝ)) (speeds : ι → ℝ)
    (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (left origin₁ origin₂ right : ι → ℝ) {time : ℝ} (htime : 0 < time) :
    affineMatrixFlux A offset (linearRiemannSolution basis speeds left origin₁ right 0 time) =
      affineMatrixFlux A offset (linearRiemannSolution basis speeds left origin₂ right 0 time) := by
  classical
  simp only [affineMatrixFlux, linearRiemannSolution, Matrix.mulVec_sum]
  congr 1
  apply Finset.sum_congr rfl
  intro p _
  simp only [eigenmodeTravelingWave, travelingWave, Matrix.mulVec_smul, heigen]
  by_cases hs : speeds p = 0
  · simp [hs]
  · have harg : (0 : ℝ) - speeds p * time ≠ 0 := by
      simpa only [zero_sub, neg_ne_zero] using mul_ne_zero hs htime.ne'
    rcases lt_or_gt_of_ne harg with hneg | hpos
    · simp only [riemannData, if_pos hneg]
    · simp only [riemannData, if_neg (not_lt_of_ge hpos.le), if_pos hpos]

/-- Every positive-time physical zero-ray value equals the constructed common
interface flux, without a CFL or nonstationary-mode hypothesis. -/
theorem linearRiemannSolution_affineFlux_zeroRay
    (A : Matrix ι ι ℝ) (offset : ι → ℝ)
    (basis : Module.Basis ι ℝ (ι → ℝ)) (speeds : ι → ℝ)
    (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (left atOrigin right : ι → ℝ) {time : ℝ} (htime : 0 < time) :
    affineMatrixFlux A offset (linearRiemannSolution basis speeds left atOrigin right 0 time) =
      affineRiemannInterfaceFlux A offset basis speeds left right := by
  calc
    _ = affineMatrixFlux A offset (linearRiemannSolution basis speeds left left right 0 time) :=
      linearRiemannSolution_affineFlux_origin_independent A offset basis speeds heigen
        left atOrigin left right htime
    _ = _ := congrArg (affineMatrixFlux A offset)
      (linearRiemannSolution_rayZero basis speeds left left right htime)

/-- The actual affine physical flux has the same normalized time average over
every positive duration. Values at time zero need not match this trace. -/
theorem linearRiemannSolution_affineFlux_timeAverage
    (A : Matrix ι ι ℝ) (offset : ι → ℝ)
    (basis : Module.Basis ι ℝ (ι → ℝ)) (speeds : ι → ℝ)
    (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (left atOrigin right : ι → ℝ) {duration : ℝ} (hduration : 0 < duration) :
    IntervalIntegrable (fun time => affineMatrixFlux A offset
      (linearRiemannSolution basis speeds left atOrigin right 0 time)) volume 0 duration ∧
    oneDimensionalCellAverage (fun time => affineMatrixFlux A offset
      (linearRiemannSolution basis speeds left atOrigin right 0 time)) 0 duration =
        affineRiemannInterfaceFlux A offset basis speeds left right := by
  simpa only [id_eq] using oneDimensionalCellAverage_map_of_constantTraceOn id
    (fun time => affineMatrixFlux A offset
      (linearRiemannSolution basis speeds left atOrigin right 0 time))
    (affineRiemannInterfaceFlux A offset basis speeds left right) 0 duration hduration
    (fun time htime => linearRiemannSolution_affineFlux_zeroRay
      A offset basis speeds heigen left atOrigin right htime.1)

/-- At the interface every nonstationary mode is locally constant, while the
physical flux of every stationary mode vanishes. Thus the actual physical flux
is continuous, even when the state has a stationary jump. -/
theorem linearRiemannSolution_affineFlux_continuousAt_zero
    (A : Matrix ι ι ℝ) (offset : ι → ℝ)
    (basis : Module.Basis ι ℝ (ι → ℝ)) (speeds : ι → ℝ)
    (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (left atOrigin right : ι → ℝ) {time : ℝ} (htime : 0 < time) :
    ContinuousAt (fun x => affineMatrixFlux A offset
      (linearRiemannSolution basis speeds left atOrigin right x time)) 0 := by
  classical
  have hmode (p : ι) : ContinuousAt (fun x => A.mulVec (eigenmodeTravelingWave
      (riemannData (basis.equivFun left p) (basis.equivFun atOrigin p)
        (basis.equivFun right p)) (speeds p) (basis p) x time)) 0 := by
    by_cases hs : speeds p = 0
    · simp only [eigenmodeTravelingWave, Matrix.mulVec_smul, heigen, hs, zero_smul, smul_zero]
      exact continuousAt_const
    · have harg : (0 : ℝ) - speeds p * time ≠ 0 := by
        simpa only [zero_sub, neg_ne_zero] using mul_ne_zero hs htime.ne'
      have hc := (riemannData_continuousAt_of_ne_zero
        (basis.equivFun left p) (basis.equivFun atOrigin p) (basis.equivFun right p) harg).comp
          (x := 0) (show ContinuousAt (fun x : ℝ => x - speeds p * time) 0 from
            continuousAt_id.sub continuousAt_const)
      simpa only [eigenmodeTravelingWave, travelingWave, Matrix.mulVec_smul] using
        hc.smul_const (A.mulVec (basis p))
  have hsum : ContinuousAt (fun x => ∑ p, A.mulVec (eigenmodeTravelingWave
      (riemannData (basis.equivFun left p) (basis.equivFun atOrigin p)
        (basis.equivFun right p)) (speeds p) (basis p) x time)) 0 :=
    tendsto_finset_sum Finset.univ (fun p _ => hmode p)
  simpa only [affineMatrixFlux, linearRiemannSolution, Matrix.mulVec_sum] using
    hsum.add_const offset

/-- Both genuine one-sided physical traces have the constructed common flux;
the state itself need not be continuous at a stationary characteristic. -/
theorem linearRiemannSolution_affineFlux_tendsto_zero
    (A : Matrix ι ι ℝ) (offset : ι → ℝ)
    (basis : Module.Basis ι ℝ (ι → ℝ)) (speeds : ι → ℝ)
    (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (left atOrigin right : ι → ℝ) {time : ℝ} (htime : 0 < time) :
    Tendsto (fun x => affineMatrixFlux A offset
      (linearRiemannSolution basis speeds left atOrigin right x time))
      (𝓝[<] 0) (𝓝 (affineRiemannInterfaceFlux A offset basis speeds left right)) ∧
    Tendsto (fun x => affineMatrixFlux A offset
      (linearRiemannSolution basis speeds left atOrigin right x time))
      (𝓝[>] 0) (𝓝 (affineRiemannInterfaceFlux A offset basis speeds left right)) := by
  have hc := linearRiemannSolution_affineFlux_continuousAt_zero
    A offset basis speeds heigen left atOrigin right htime
  have hv := linearRiemannSolution_affineFlux_zeroRay
    A offset basis speeds heigen left atOrigin right htime
  constructor
  · simpa only [hv] using hc.continuousWithinAt.tendsto (s := Set.Iio (0 : ℝ))
  · simpa only [hv] using hc.continuousWithinAt.tendsto (s := Set.Ioi (0 : ℝ))

end Matrix

end NumStability
