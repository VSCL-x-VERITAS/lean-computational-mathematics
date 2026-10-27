/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.LocalDerivativeVariation
import ComputationalMathematics.Analysis.Calculus.LocalFirstOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSecondOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSymmetricTaylor
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.C2RectangleReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.ClosedTimePartialRegularity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.ClosedTimeVectorDerivativeBudgets
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLipschitzTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalEndpointMeanQuadrature
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRectangleCellAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalWithinVectorCellMidpoint
import ComputationalMathematics.Source.LeVeque.Chapter04.MidpointAverage
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerUniformPredictorError
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerVectorCenteredSecant
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerVectorFaceDerivativeBudget
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerVectorPhysicalFluxAverageDerivative
import Mathlib.Analysis.Calculus.BumpFunction.FiniteDimension
import Mathlib.Analysis.Calculus.ContDiff.Bounds
import Mathlib.Analysis.Calculus.ContDiff.Operations
import Mathlib.Analysis.Calculus.FDeriv.Symmetric
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Tactic

/-!
# RichtmyerUniformFaceDerivativeBudget

Source correspondence for LeVeque section4.7, printed72/PDF94. Smooth formal local accuracy is separate from accumulated global accuracy and behavior at discontinuities.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

set_option maxHeartbeats 800000 in
theorem leveque04_richtmyer_uniform_automatic_closedTime_nonlinearFaceDerivative_error
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (L R finish anchor : ℝ) (hfinish : 0 < finish) (hanchor : anchor ∈ Ioo L R)
    (hq : ContDiffOn ℝ 3 (Function.uncurry q) (Ioo L R ×ˢ Icc 0 finish))
    (hflux : ContDiff ℝ 3 flux) (hcompact : HasCompactSupport flux)
    (hpde : ∀ x ∈ Ioo L R,
      derivWithin (q x) (Icc 0 finish) 0 + deriv (fun z => flux (q z 0)) x = 0) :
    ∃ threshold C : ℝ, 0 < threshold ∧ 0 ≤ C ∧
      ∀ face timeStep width : ℝ, |face-anchor| ≤ threshold → 0 < timeStep → timeStep ≤ finish → timeStep ≤ 1 →
        0 < width → width ≤ threshold → width ≤ 1 →
      let profile := fun x => q x 0
      let leftAverage := oneDimensionalCellAverage profile (face - width) face
      let rightAverage := oneDimensionalCellAverage profile face (face + width)
      let leftSlope := width⁻¹ • (profile face - profile (face - width))
      let rightSlope := width⁻¹ • (profile (face + width) - profile face)
      let predicted := (1 / 2 : ℝ) • (leftAverage + rightAverage) -
        (timeStep / 2) • (width⁻¹ • (flux rightAverage - flux leftAverage))
      let predictedSlope := (1 / 2 : ℝ) • (leftSlope + rightSlope) -
        (timeStep / 2) • (width⁻¹ •
          (fderiv ℝ flux rightAverage rightSlope - fderiv ℝ flux leftAverage leftSlope))
      ‖fderiv ℝ flux predicted predictedSlope -
          deriv (fun x => flux (q x (timeStep / 2))) face‖ ≤
        C * (width ^ 2 + timeStep ^ 2) := by
  obtain ⟨rs,Cs,hrs,hCs,hs⟩ := leveque04_richtmyer_uniform_automatic_closedTime_statePredictor_error
    q flux L R finish anchor hfinish hanchor hq hflux hcompact hpde
  obtain ⟨rg,Cg,hrg,hCg,hg⟩ := leveque04_richtmyer_uniform_automatic_closedTime_predictorGradient_error
    q flux L R finish anchor hfinish hanchor hq hflux hcompact hpde
  let qX : ℝ → ℝ → Fin m → ℝ := fun x τ => deriv (fun ξ => q ξ τ) x
  have hX : ContDiffOn ℝ 2 (Function.uncurry qX) (Ioo L R ×ˢ Icc 0 finish) := by
    simpa only [qX,Function.uncurry_apply_pair] using
      contDiffOn_closedTimeStrip_spatial_derivative 2 q L R 0 finish hfinish hq
  let radius := min (anchor-L) (R-anchor)/2
  have hradius : 0 < radius := half_pos (lt_min (sub_pos.mpr hanchor.1) (sub_pos.mpr hanchor.2))
  have hspace : Icc (anchor-radius) (anchor+radius) ⊆ Ioo L R := by
    intro x hx
    have hl : 2*radius ≤ anchor-L := by dsimp [radius]; linarith [min_le_left (anchor-L) (R-anchor)]
    have hr : 2*radius ≤ R-anchor := by dsimp [radius]; linarith [min_le_right (anchor-L) (R-anchor)]
    constructor <;> linarith [hx.1,hx.2]
  let box := Icc (anchor-radius) (anchor+radius) ×ˢ Icc 0 finish
  have hsub : box ⊆ Ioo L R ×ˢ Icc 0 finish := prod_mono hspace (Subset.refl _)
  obtain ⟨M0,hM0⟩ := (isCompact_Icc.prod isCompact_Icc).bddAbove_image
    ((hX.mono hsub).continuousOn.norm)
  let M : ℝ := max M0 0
  have hM : 0 ≤ M := le_max_right _ _
  have hbound (face τ : ℝ) (hf : face ∈ Icc (anchor-radius) (anchor+radius))
      (hτ : τ ∈ Icc 0 finish) : ‖qX face τ‖ ≤ M := by
    have hx : (face,τ) ∈ box := ⟨hf,hτ⟩
    exact (hM0 (mem_image_of_mem _ hx)).trans (le_max_left _ _)
  have htwo : ContDiff ℝ 2 flux := hflux.of_le (by norm_num)
  have hj : ContDiff ℝ 1 (fderiv ℝ flux) := htwo.fderiv_right (by decide)
  obtain ⟨J,hJ⟩ := ContDiff.lipschitzWith_of_hasCompactSupport (hcompact.fderiv ℝ) hj (by decide)
  obtain ⟨N0,hN0⟩ := hJ.continuous.bounded_above_of_compact_support (hcompact.fderiv ℝ)
  let N : ℝ := max N0 0
  have hN : 0 ≤ N := le_max_right _ _
  have hnorm (state : Fin m → ℝ) : ‖fderiv ℝ flux state‖ ≤ N :=
    (hN0 state).trans (le_max_left _ _)
  refine ⟨min rs (min rg radius),(J : ℝ) * Cs * (M + 2 * Cg) + N * Cg,
    lt_min hrs (lt_min hrg hradius),by positivity,?_⟩
  intro face timeStep width hface htime htimeMax htimeOne hwidth hsmall hwidthOne
    profile leftAverage rightAverage leftSlope rightSlope predicted predictedSlope
  have hfaceMem : face ∈ Icc (anchor-radius) (anchor+radius) := by
    have hf := abs_le.mp (hface.trans ((min_le_right rs (min rg radius)).trans (min_le_right rg radius)))
    constructor <;> linarith [hf.1,hf.2]
  have hfaceOpen := hspace hfaceMem
  have hstate := hs face timeStep width (hface.trans (min_le_left _ _)) htime htimeMax hwidth
    (hsmall.trans (min_le_left _ _)) hwidthOne
  have hgradient := hg face timeStep width
    (hface.trans ((min_le_right _ _).trans (min_le_left _ _))) htime htimeMax hwidth
    (hsmall.trans ((min_le_right _ _).trans (min_le_left _ _))) hwidthOne
  have hhalf : timeStep / 2 ∈ Icc 0 finish := ⟨by positivity,by linarith⟩
  have hsum : width ^ 2 + timeStep ^ 2 ≤ 2 := by
    nlinarith [sq_nonneg (1-width),sq_nonneg (1-timeStep)]
  have hpredBound : ‖predictedSlope‖ ≤ M + 2 * Cg := by
    calc
      _ ≤ ‖predictedSlope - qX face (timeStep / 2)‖ + ‖qX face (timeStep / 2)‖ :=
        norm_le_norm_sub_add _ _
      _ ≤ Cg * (width ^ 2 + timeStep ^ 2) + M := add_le_add hgradient (hbound face _ hfaceMem hhalf)
      _ ≤ M + 2 * Cg := by nlinarith [mul_le_mul_of_nonneg_left hsum hCg]
  have hslice : ContDiffOn ℝ 3 (fun x => q x (timeStep / 2)) (Ioo L R) :=
    hq.comp (contDiffOn_id.prodMk contDiffOn_const) (fun x hx => ⟨hx,hhalf⟩)
  have hqd : HasDerivAt (fun x => q x (timeStep / 2))
      (qX face (timeStep / 2)) face :=
    ((hslice face hfaceOpen).contDiffAt (isOpen_Ioo.mem_nhds hfaceOpen)).differentiableAt
      (by decide) |>.hasDerivAt
  have hchain : fderiv ℝ flux (q face (timeStep / 2)) (qX face (timeStep / 2)) =
      deriv (fun x => flux (q x (timeStep / 2))) face :=
    ((hflux.differentiable (by decide) (q face (timeStep / 2))).hasFDerivAt.comp_hasDerivAt
      face hqd).deriv.symm
  let scale := Real.sqrt (width ^ 2 + timeStep ^ 2)
  have hscale : scale ^ 2 = width ^ 2 + timeStep ^ 2 :=
    Real.sq_sqrt (by positivity)
  have herror := leveque04_richtmyer_vectorFaceDerivative_errorBudget
    (fderiv ℝ flux) predicted predictedSlope (q face (timeStep / 2))
    (qX face (timeStep / 2)) (deriv (fun x => flux (q x (timeStep / 2))) face)
    scale J Cs Cg (M + 2 * Cg) N 0 J.coe_nonneg hCs hN
    (by simpa only [hscale] using hstate)
    (by simpa only [hscale] using hgradient)
    hpredBound (hnorm _) (hJ.norm_sub_le _ _) (by rw [hchain]; simp)
  simpa only [add_zero,hscale] using herror

theorem leveque04_richtmyer_uniform_closedTime_physicalFluxDerivative_midpointAverage_error
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (L R finish a b : ℝ) (hfinish : 0 < finish) (hspace : Icc a b ⊆ Ioo L R)
    (hq : ContDiffOn ℝ 3 (Function.uncurry q) (Ioo L R ×ˢ Icc 0 finish))
    (hflux : ContDiff ℝ 3 flux) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ face ∈ Icc a b, ∀ timeStep : ℝ,
      0 < timeStep → timeStep ≤ finish →
      ‖oneDimensionalCellAverage
          (fun τ => deriv (fun x => flux (q x τ)) face) 0 timeStep -
        deriv (fun x => flux (q x (timeStep / 2))) face‖ ≤ C * timeStep ^ 2 := by
  let physical : ℝ → ℝ → Fin m → ℝ := fun x τ => flux (q x τ)
  have hphysical : ContDiffOn ℝ 3 (Function.uncurry physical) (Ioo L R ×ˢ Icc 0 finish) :=
    hflux.comp_contDiffOn hq
  obtain ⟨K,hderiv,hLip⟩ := closedTime_vector_temporalSlope_budget
    physical L R 0 finish a b hfinish hspace hphysical
  refine ⟨(K : ℝ)/4,by positivity,?_⟩
  intro face hfaceMem timeStep htime htimeMax
  let trace : ℝ → Fin m → ℝ := fun τ => deriv (fun x => physical x τ) face
  let traceSlope : ℝ → Fin m → ℝ := derivWithin trace (Icc 0 finish)
  have hhalf : timeStep / 2 ∈ Icc 0 finish := ⟨by positivity,by linarith⟩
  have hsub : Icc 0 timeStep ⊆ Icc 0 finish :=
    Icc_subset_Icc le_rfl htimeMax
  have hinterval : Icc (timeStep / 2 - timeStep / 2) (timeStep / 2 + timeStep / 2) =
      Icc 0 timeStep := by
    rw [sub_self,show timeStep / 2 + timeStep / 2 = timeStep by ring]
  have ht (τ : ℝ) (hτ : τ ∈ Icc 0 timeStep) :
      HasDerivWithinAt trace (traceSlope τ) (Icc 0 timeStep) τ :=
    (hderiv face hfaceMem τ (hsub hτ)).mono hsub
  have hm := local_vector_within_cellMidpoint_error
    trace traceSlope K (timeStep / 2) (timeStep / 2) K.coe_nonneg (by positivity)
    (fun τ hτ => by simpa only [hinterval] using ht τ (by simpa only [hinterval] using hτ))
    (fun τ hτ => hLip face hfaceMem τ (hsub (by simpa only [hinterval] using hτ))
      (timeStep / 2) hhalf)
  dsimp only [trace,physical] at hm
  rw [sub_self,show timeStep / 2 + timeStep / 2 = timeStep by ring] at hm
  have hcoef : (K : ℝ) * (timeStep / 2) ^ 2 = (K : ℝ) / 4 * timeStep ^ 2 := by ring
  rw [hcoef] at hm
  exact hm

theorem leveque04_richtmyer_uniform_automatic_closedTime_faceTimeAverageDerivative_error
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (L R finish anchor : ℝ) (hfinish : 0 < finish) (hanchor : anchor ∈ Ioo L R)
    (hq : ContDiffOn ℝ 3 (Function.uncurry q) (Ioo L R ×ˢ Icc 0 finish))
    (hflux : ContDiff ℝ 3 flux) (hcompact : HasCompactSupport flux)
    (hpde : ∀ x ∈ Ioo L R,
      derivWithin (q x) (Icc 0 finish) 0 + deriv (fun z => flux (q z 0)) x = 0) :
    ∃ threshold C : ℝ, 0 < threshold ∧ 0 ≤ C ∧
      ∀ face timeStep width : ℝ, |face-anchor| ≤ threshold → 0 < timeStep → timeStep ≤ finish → timeStep ≤ 1 →
        0 < width → width ≤ threshold → width ≤ 1 →
      let profile := fun x => q x 0
      let leftAverage := oneDimensionalCellAverage profile (face - width) face
      let rightAverage := oneDimensionalCellAverage profile face (face + width)
      let leftSlope := width⁻¹ • (profile face - profile (face - width))
      let rightSlope := width⁻¹ • (profile (face + width) - profile face)
      let predicted := (1 / 2 : ℝ) • (leftAverage + rightAverage) -
        (timeStep / 2) • (width⁻¹ • (flux rightAverage - flux leftAverage))
      let predictedSlope := (1 / 2 : ℝ) • (leftSlope + rightSlope) -
        (timeStep / 2) • (width⁻¹ •
          (fderiv ℝ flux rightAverage rightSlope - fderiv ℝ flux leftAverage leftSlope))
      ‖fderiv ℝ flux predicted predictedSlope -
          oneDimensionalCellAverage (fun τ => deriv (fun x => flux (q x τ)) face) 0 timeStep‖ ≤
        C * (width ^ 2 + timeStep ^ 2) := by

  obtain ⟨threshold,Cf,hthreshold,hCf,hfaceError⟩ :=
    leveque04_richtmyer_uniform_automatic_closedTime_nonlinearFaceDerivative_error
      q flux L R finish anchor hfinish hanchor hq hflux hcompact hpde
  let radius := min (anchor-L) (R-anchor)/2
  have hradius : 0 < radius := half_pos (lt_min (sub_pos.mpr hanchor.1) (sub_pos.mpr hanchor.2))
  have hspace : Icc (anchor-radius) (anchor+radius) ⊆ Ioo L R := by
    intro x hx
    have hl : 2*radius ≤ anchor-L := by dsimp [radius]; linarith [min_le_left (anchor-L) (R-anchor)]
    have hr : 2*radius ≤ R-anchor := by dsimp [radius]; linarith [min_le_right (anchor-L) (R-anchor)]
    constructor <;> linarith [hx.1,hx.2]
  obtain ⟨Ct,hCt,haverage⟩ := leveque04_richtmyer_uniform_closedTime_physicalFluxDerivative_midpointAverage_error
    q flux L R finish (anchor-radius) (anchor+radius) hfinish hspace hq hflux
  refine ⟨min threshold radius,Cf+Ct,lt_min hthreshold hradius,add_nonneg hCf hCt,?_⟩
  intro face timeStep width hface htime htimeMax htimeOne hwidth hsmall hwidthOne
    profile leftAverage rightAverage leftSlope rightSlope predicted predictedSlope
  have hfaceMem : face ∈ Icc (anchor-radius) (anchor+radius) := by
    have hf := abs_le.mp (hface.trans (min_le_right threshold radius))
    constructor <;> linarith [hf.1,hf.2]
  have hf := hfaceError face timeStep width (hface.trans (min_le_left _ _))
    htime htimeMax htimeOne hwidth (hsmall.trans (min_le_left _ _)) hwidthOne
  have ht := haverage face hfaceMem timeStep htime htimeMax
  have triangle := norm_sub_le_norm_sub_add_norm_sub
    (fderiv ℝ flux predicted predictedSlope)
    (deriv (fun x => flux (q x (timeStep / 2))) face)
    (oneDimensionalCellAverage (fun τ => deriv (fun x => flux (q x τ)) face) 0 timeStep)
  rw [norm_sub_rev (deriv (fun x => flux (q x (timeStep / 2))) face)] at triangle
  apply triangle.trans
  have combined := add_le_add hf ht
  apply combined.trans
  have extra := mul_nonneg hCt (sq_nonneg width)
  nlinarith

end NumStability
