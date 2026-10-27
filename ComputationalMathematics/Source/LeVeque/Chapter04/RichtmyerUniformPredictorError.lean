/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.LocalDerivativeVariation
import ComputationalMathematics.Analysis.Calculus.LocalFirstOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSecondOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSymmetricTaylor
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.C2RectangleReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.ClosedTimeMixedDerivatives
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.ClosedTimePartialRegularity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.ClosedTimeVectorDerivativeBudgets
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLipschitzTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalEndpointMeanQuadrature
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRectangleCellAverage
import ComputationalMathematics.Source.LeVeque.Chapter04.MidpointAverage
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerForwardPredictorGradient
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerUniformSpatialBudgets
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
# RichtmyerUniformPredictorError

Source correspondence for LeVeque section4.7, printed72/PDF94. Smooth formal local accuracy is separate from accumulated global accuracy and behavior at discontinuities.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

theorem leveque04_richtmyer_uniform_closedTime_PDE_predictorGradient_transfer
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (flux : E → E) (L R finish a b : ℝ)
    (hfinish : 0 < finish) (hspace : Icc a b ⊆ Ioo L R)
    (hq : ContDiffOn ℝ 3 (Function.uncurry q) (Ioo L R ×ˢ Icc 0 finish))
    (hpde : ∀ x ∈ Ioo L R,
      derivWithin (q x) (Icc 0 finish) 0 + deriv (fun z => flux (q z 0)) x = 0) :
    ∃ T : ℝ, 0 ≤ T ∧ ∀ face ∈ Icc a b, ∀ timeStep width S F : ℝ,
      0 < timeStep → timeStep ≤ finish → 0 < width → 0 ≤ S → 0 ≤ F →
      ∀ centeredSlope fluxGradient : E,
      ‖centeredSlope - deriv (fun x => q x 0) face‖ ≤ S * width ^ 2 →
      ‖fluxGradient - deriv (fun x => deriv (fun z => flux (q z 0)) x) face‖ ≤ F * width →
      ‖(centeredSlope - (timeStep / 2) • fluxGradient) -
        deriv (fun x => q x (timeStep / 2)) face‖ ≤
          (S + F / 4 + T / 4) * (width ^ 2 + timeStep ^ 2) := by
  let qX : ℝ → ℝ → E := fun x τ => deriv (fun ξ => q ξ τ) x
  let qXT : ℝ → ℝ → E := fun x τ => derivWithin (qX x) (Icc 0 finish) τ
  obtain ⟨K, hderiv, hLip⟩ := closedTime_vector_temporalSlope_budget
    q L R 0 finish a b hfinish hspace hq
  refine ⟨K, K.coe_nonneg, ?_⟩
  intro face hfaceMem timeStep width S F htime htimeMax hwidth hS hF centeredSlope fluxGradient hstate hflux
  have hhalf : 0 ≤ timeStep / 2 := by positivity
  have hsub : uIcc 0 (timeStep / 2) ⊆ Icc 0 finish := by
    rw [uIcc_of_le hhalf]
    intro τ hτ
    exact ⟨hτ.1, by linarith [hτ.2]⟩
  have hpdeGradient := closedTime_differentiated_conservationPDE
    q flux L R 0 finish face 0 hfinish (hspace hfaceMem) ⟨le_rfl,hfinish.le⟩
    (hq.of_le (by norm_num)) hpde
  have htraceDeriv (τ : ℝ) (hτ : τ ∈ uIcc 0 (timeStep / 2)) :
      HasDerivWithinAt (qX face) (qXT face τ) (uIcc 0 (timeStep / 2)) τ :=
    (hderiv face hfaceMem τ (hsub hτ)).mono hsub
  have htraceLip (τ : ℝ) (hτ : τ ∈ uIcc 0 (timeStep / 2)) :
      ‖qXT face τ - qXT face 0‖ ≤ (K : ℝ) * |τ| := by
    simpa only [sub_zero] using hLip face hfaceMem τ (hsub hτ) 0 ⟨le_rfl,hfinish.le⟩
  exact leveque04_richtmyer_independent_forward_predictorGradient_error
    centeredSlope fluxGradient (qX face 0)
    (deriv (fun x => deriv (fun z => flux (q z 0)) x) face)
    (qX face) (qXT face) timeStep width S F K htime hwidth hS hF K.coe_nonneg
    hstate hflux htraceDeriv htraceLip rfl hpdeGradient

theorem leveque04_richtmyer_uniform_automatic_closedTime_statePredictor_error
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (L R finish anchor : ℝ) (hfinish : 0 < finish) (hanchor : anchor ∈ Ioo L R)
    (hq : ContDiffOn ℝ 3 (Function.uncurry q) (Ioo L R ×ˢ Icc 0 finish))
    (hflux : ContDiff ℝ 3 flux) (hcompact : HasCompactSupport flux)
    (hpde : ∀ x ∈ Ioo L R,
      derivWithin (q x) (Icc 0 finish) 0 + deriv (fun z => flux (q z 0)) x = 0) :
    ∃ threshold C : ℝ, 0 < threshold ∧ 0 ≤ C ∧
      ∀ face timeStep width : ℝ, |face-anchor| ≤ threshold → 0 < timeStep → timeStep ≤ finish →
        0 < width → width ≤ threshold → width ≤ 1 →
      let profile := fun x => q x 0
      let leftAverage := oneDimensionalCellAverage profile (face - width) face
      let rightAverage := oneDimensionalCellAverage profile face (face + width)
      let centeredState := (1 / 2 : ℝ) • (leftAverage + rightAverage)
      let fluxSlope := width⁻¹ • (flux rightAverage - flux leftAverage)
      ‖(centeredState - (timeStep / 2) • fluxSlope) - q face (timeStep / 2)‖ ≤
        C * (width ^ 2 + timeStep ^ 2) := by
  have hslice : ContDiffOn ℝ 3 (fun x => q x 0) (Ioo L R) :=
    hq.comp (contDiffOn_id.prodMk contDiffOn_const)
      (fun x hx => ⟨hx,le_rfl,hfinish.le⟩)
  have hprofile : ContDiffAt ℝ 3 (fun x => q x 0) anchor :=
    (hslice anchor hanchor).contDiffAt (isOpen_Ioo.mem_nhds hanchor)
  obtain ⟨threshold,S,F,hthreshold,hS,hF,hspatial⟩ :=
    leveque04_richtmyer_uniform_automatic_local_state_spatial_budget (fun x => q x 0) flux anchor
      hprofile hflux hcompact
  let radius := min (anchor-L) (R-anchor)/2
  have hradius : 0 < radius := half_pos (lt_min (sub_pos.mpr hanchor.1) (sub_pos.mpr hanchor.2))
  have hspace : Icc (anchor-radius) (anchor+radius) ⊆ Ioo L R := by
    intro x hx
    have hl : 2*radius ≤ anchor-L := by dsimp [radius]; linarith [min_le_left (anchor-L) (R-anchor)]
    have hr : 2*radius ≤ R-anchor := by dsimp [radius]; linarith [min_le_right (anchor-L) (R-anchor)]
    constructor <;> linarith [hx.1,hx.2]
  obtain ⟨T,hderiv,hLip⟩ := closedTime_field_temporalDerivative_budget
    q L R 0 finish (anchor-radius) (anchor+radius) hfinish hspace (hq.of_le (by norm_num))
  refine ⟨min threshold radius,S + F / 4 + (T : ℝ) / 4,lt_min hthreshold hradius,by positivity,?_⟩
  intro face timeStep width hface htime htimeMax hwidth hsmall hwidthOne
    profile leftAverage rightAverage centeredState fluxSlope
  have hfaceMem : face ∈ Icc (anchor-radius) (anchor+radius) := by
    have hf := abs_le.mp (hface.trans (min_le_right threshold radius))
    constructor <;> linarith [hf.1,hf.2]
  have hsmall' : width ≤ threshold := hsmall.trans (min_le_left threshold radius)
  have hface' : |face-anchor| ≤ threshold := hface.trans (min_le_left threshold radius)
  obtain ⟨hs,hf⟩ := hspatial face width hface' hwidth hsmall' hwidthOne
  have hsub : uIcc 0 (timeStep / 2) ⊆ Icc 0 finish := by
    rw [uIcc_of_le (by positivity : 0 ≤ timeStep / 2)]
    intro τ hτ
    exact ⟨hτ.1,by linarith [hτ.2]⟩
  exact leveque04_richtmyer_independent_forward_predictorGradient_error
    centeredState fluxSlope (q face 0) (deriv (fun z => flux (q z 0)) face)
    (q face) (derivWithin (q face) (Icc 0 finish)) timeStep width S F T
    htime hwidth hS hF T.coe_nonneg hs hf
    (fun τ hτ => (hderiv face hfaceMem τ (hsub hτ)).mono hsub)
    (fun τ hτ => by
      simpa only [sub_zero] using hLip face hfaceMem τ (hsub hτ) 0 ⟨le_rfl,hfinish.le⟩)
    rfl (hpde face (hspace hfaceMem))

theorem leveque04_richtmyer_uniform_automatic_closedTime_predictorGradient_error
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (L R finish anchor : ℝ) (hfinish : 0 < finish) (hanchor : anchor ∈ Ioo L R)
    (hq : ContDiffOn ℝ 3 (Function.uncurry q) (Ioo L R ×ˢ Icc 0 finish))
    (hflux : ContDiff ℝ 3 flux) (hcompact : HasCompactSupport flux)
    (hpde : ∀ x ∈ Ioo L R,
      derivWithin (q x) (Icc 0 finish) 0 + deriv (fun z => flux (q z 0)) x = 0) :
    ∃ threshold C : ℝ, 0 < threshold ∧ 0 ≤ C ∧
      ∀ face timeStep width : ℝ, |face-anchor| ≤ threshold → 0 < timeStep → timeStep ≤ finish →
        0 < width → width ≤ threshold → width ≤ 1 →
      let profile := fun x => q x 0
      let leftAverage := oneDimensionalCellAverage profile (face - width) face
      let rightAverage := oneDimensionalCellAverage profile face (face + width)
      let leftSlope := width⁻¹ • (profile face - profile (face - width))
      let rightSlope := width⁻¹ • (profile (face + width) - profile face)
      let centeredSlope := (1 / 2 : ℝ) • (leftSlope + rightSlope)
      let fluxGradient := width⁻¹ •
        (fderiv ℝ flux rightAverage rightSlope - fderiv ℝ flux leftAverage leftSlope)
      ‖(centeredSlope - (timeStep / 2) • fluxGradient) -
          deriv (fun x => q x (timeStep / 2)) face‖ ≤ C * (width ^ 2 + timeStep ^ 2) := by
  have hslice : ContDiffOn ℝ 3 (fun x => q x 0) (Ioo L R) :=
    hq.comp (contDiffOn_id.prodMk contDiffOn_const)
      (fun x hx => ⟨hx,le_rfl,hfinish.le⟩)
  have hprofile : ContDiffAt ℝ 3 (fun x => q x 0) anchor :=
    (hslice anchor hanchor).contDiffAt (isOpen_Ioo.mem_nhds hanchor)
  obtain ⟨threshold,S,F,hthreshold,hS,hF,hspatial⟩ :=
    leveque04_richtmyer_uniform_automatic_local_fluxGradient_budget (fun x => q x 0) flux anchor
      hprofile hflux hcompact
  let radius := min (anchor-L) (R-anchor)/2
  have hradius : 0 < radius := half_pos (lt_min (sub_pos.mpr hanchor.1) (sub_pos.mpr hanchor.2))
  have hspace : Icc (anchor-radius) (anchor+radius) ⊆ Ioo L R := by
    intro x hx
    have hl : 2*radius ≤ anchor-L := by dsimp [radius]; linarith [min_le_left (anchor-L) (R-anchor)]
    have hr : 2*radius ≤ R-anchor := by dsimp [radius]; linarith [min_le_right (anchor-L) (R-anchor)]
    constructor <;> linarith [hx.1,hx.2]
  obtain ⟨T,hT,htransfer⟩ := leveque04_richtmyer_uniform_closedTime_PDE_predictorGradient_transfer
    q flux L R finish (anchor-radius) (anchor+radius) hfinish hspace hq hpde
  refine ⟨min threshold radius,S + F / 4 + T / 4,lt_min hthreshold hradius,by positivity,?_⟩
  intro face timeStep width hface htime htimeMax hwidth hsmall hwidthOne
    profile leftAverage rightAverage leftSlope rightSlope centeredSlope fluxGradient
  have hfaceMem : face ∈ Icc (anchor-radius) (anchor+radius) := by
    have hf := abs_le.mp (hface.trans (min_le_right threshold radius))
    constructor <;> linarith [hf.1,hf.2]
  have hsmall' : width ≤ threshold := hsmall.trans (min_le_left threshold radius)
  have hface' : |face-anchor| ≤ threshold := hface.trans (min_le_left threshold radius)
  obtain ⟨hs,hf⟩ := hspatial face width hface' hwidth hsmall' hwidthOne
  exact htransfer face hfaceMem timeStep width S F htime htimeMax hwidth hS hF centeredSlope fluxGradient hs hf

end NumStability
