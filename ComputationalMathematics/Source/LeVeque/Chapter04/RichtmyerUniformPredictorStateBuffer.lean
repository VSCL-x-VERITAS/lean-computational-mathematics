/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.LocalDerivativeVariation
import ComputationalMathematics.Analysis.Calculus.LocalFirstOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSecondOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSymmetricTaylor
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.C2RectangleReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.ClosedTimePartialRegularity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLipschitzTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageStateBall
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalEndpointMeanQuadrature
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRectangleCellAverage
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
# RichtmyerUniformPredictorStateBuffer

Source correspondence for LeVeque section4.7, printed72/PDF94. Smooth formal local accuracy is separate from accumulated global accuracy and behavior at discontinuities.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

theorem leveque04_richtmyer_uniform_automatic_closedTime_predictor_ball_transfer
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (extension flux : (Fin m → ℝ) → Fin m → ℝ)
    (L R finish anchor spatialRadius stateRadius : ℝ)
    (hfinish : 0 < finish) (hanchor : anchor ∈ Ioo L R)
    (hspatial : 0 < spatialRadius) (hradius : 0 < stateRadius)
    (hspace : Icc (anchor-spatialRadius) (anchor+spatialRadius) ⊆ Ioo L R)
    (hq : ContDiffOn ℝ 3 (Function.uncurry q) (Ioo L R ×ˢ Icc 0 finish))
    (hext : ContDiff ℝ 3 extension) (hcompact : HasCompactSupport extension)
    (hpde : ∀ x ∈ Ioo L R,
      derivWithin (q x) (Icc 0 finish) 0 + deriv (fun z => extension (q z 0)) x = 0)
    (hvalues : ∀ x ∈ Icc (anchor-spatialRadius) (anchor+spatialRadius),
      ∀ τ ∈ Icc 0 finish, q x τ ∈ ball (q anchor 0) (stateRadius/2))
    (hagree : ∀ state ∈ ball (q anchor 0) stateRadius, extension state = flux state)
    (hjac : ∀ state ∈ ball (q anchor 0) stateRadius,
      fderiv ℝ extension state = fderiv ℝ flux state) :
    ∃ δ : ℝ, 0 < δ ∧ δ ≤ finish ∧ δ ≤ 1 ∧
      ∀ face dt width : ℝ, |face-anchor| ≤ δ → 0 < dt → dt ≤ δ →
        0 < width → width ≤ δ →
      let profile := fun x => q x 0
      let leftAverage := oneDimensionalCellAverage profile (face-width) face
      let rightAverage := oneDimensionalCellAverage profile face (face+width)
      let predicted := (1/2 : ℝ) • (leftAverage+rightAverage) -
        (dt/2) • (width⁻¹ • (extension rightAverage-extension leftAverage))
      leftAverage ∈ ball (q anchor 0) stateRadius ∧
      rightAverage ∈ ball (q anchor 0) stateRadius ∧
      predicted ∈ ball (q anchor 0) stateRadius ∧
      predicted = (1/2 : ℝ) • (leftAverage+rightAverage) -
        (dt/2) • (width⁻¹ • (flux rightAverage-flux leftAverage)) ∧
      fderiv ℝ extension leftAverage = fderiv ℝ flux leftAverage ∧
      fderiv ℝ extension rightAverage = fderiv ℝ flux rightAverage ∧
      fderiv ℝ extension predicted = fderiv ℝ flux predicted := by
  obtain ⟨threshold,C,hthreshold,hC,herror⟩ :=
    leveque04_richtmyer_uniform_automatic_closedTime_statePredictor_error
      q extension L R finish anchor hfinish hanchor hq hext hcompact hpde
  obtain ⟨rball,hrball,_hrballOne,hpredBall⟩ :=
    independent_quadratic_predictor_mem_ball (E := Fin m → ℝ)
      C stateRadius hC hradius
  let δ := min threshold (min rball (min (spatialRadius/2) (min finish 1)))
  have hδ : 0 < δ := lt_min hthreshold
    (lt_min hrball (lt_min (half_pos hspatial) (lt_min hfinish (by norm_num))))
  have hδthreshold : δ ≤ threshold := min_le_left _ _
  have hδball : δ ≤ rball := (min_le_right _ _).trans (min_le_left _ _)
  have hδspatial : δ ≤ spatialRadius/2 :=
    (min_le_right _ _).trans ((min_le_right _ _).trans (min_le_left _ _))
  have hδfinish : δ ≤ finish :=
    (min_le_right _ _).trans ((min_le_right _ _).trans ((min_le_right _ _).trans (min_le_left _ _)))
  have hδone : δ ≤ 1 :=
    (min_le_right _ _).trans ((min_le_right _ _).trans ((min_le_right _ _).trans (min_le_right _ _)))
  have hc : ContinuousOn (fun x => q x 0)
      (Icc (anchor-spatialRadius) (anchor+spatialRadius)) :=
    hq.continuousOn.comp (continuousOn_id.prodMk continuousOn_const)
      (fun x hx => ⟨hspace hx,le_rfl,hfinish.le⟩)
  refine ⟨δ,hδ,hδfinish,hδone,?_⟩
  intro face dt width hface hdt hdtSmall hwidth hwidthSmall
    profile leftAverage rightAverage predicted
  obtain ⟨hleft,hright⟩ := uniform_neighboringCellAverage_mem_ball
    profile (q anchor 0) anchor spatialRadius stateRadius hspatial hradius hc
    (fun x hx => hvalues x hx 0 ⟨le_rfl,hfinish.le⟩)
    face width (hface.trans hδspatial) hwidth (hwidthSmall.trans hδspatial)
  have hfaceMem : face ∈ Icc (anchor-spatialRadius) (anchor+spatialRadius) := by
    have hh := abs_le.mp (hface.trans hδspatial)
    constructor <;> linarith [hh.1,hh.2]
  have herr := herror face dt width (hface.trans hδthreshold) hdt
    (hdtSmall.trans hδfinish) hwidth (hwidthSmall.trans hδthreshold)
    (hwidthSmall.trans hδone)
  have hpred := hpredBall predicted (q face (dt/2)) (q anchor 0) dt width
    hdt (hdtSmall.trans hδball) hwidth (hwidthSmall.trans hδball) herr
    (hvalues face hfaceMem (dt/2) ⟨by positivity,by linarith [hdtSmall.trans hδfinish]⟩)
  refine ⟨hleft,hright,hpred,?_,hjac _ hleft,hjac _ hright,hjac _ hpred⟩
  dsimp only [predicted]
  rw [hagree _ hright,hagree _ hleft]

end NumStability
