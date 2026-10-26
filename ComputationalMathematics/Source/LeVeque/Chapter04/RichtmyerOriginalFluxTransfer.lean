/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.LocalDerivativeVariation
import ComputationalMathematics.Analysis.Calculus.LocalFirstOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSecondOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSmoothFluxExtension
import ComputationalMathematics.Analysis.Calculus.LocalSymmetricTaylor
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.C2RectangleReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.ClosedTimePartialRegularity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalStateRectangle
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLipschitzTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalEndpointMeanQuadrature
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRectangleCellAverage
import ComputationalMathematics.Source.LeVeque.Chapter04.MidpointAverage
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerUniformFaceDerivativeBudget
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerUniformPredictorStateBuffer
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
# RichtmyerOriginalFluxTransfer

Source correspondence for LeVeque section4.7, printed72/PDF94. Smooth formal local accuracy is separate from accumulated global accuracy and behavior at discontinuities.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

theorem leveque04_richtmyer_uniform_auxiliary_to_original_faceDerivative_budget
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
      fderiv ℝ extension state = fderiv ℝ flux state)
    (hphysical : ∀ x ∈ Ioo L R, ∀ τ ∈ Icc 0 finish,
      deriv (fun z => extension (q z τ)) x = deriv (fun z => flux (q z τ)) x) :
    ∃ δ C : ℝ, 0 < δ ∧ δ ≤ finish ∧ δ ≤ 1 ∧ 0 ≤ C ∧
      ∀ face dt width : ℝ, |face-anchor| ≤ δ → 0 < dt → dt ≤ δ →
        0 < width → width ≤ δ →
      let profile := fun x => q x 0
      let leftAverage := oneDimensionalCellAverage profile (face-width) face
      let rightAverage := oneDimensionalCellAverage profile face (face+width)
      let leftSlope := width⁻¹ • (profile face-profile (face-width))
      let rightSlope := width⁻¹ • (profile (face+width)-profile face)
      let predicted := (1/2 : ℝ) • (leftAverage+rightAverage) -
        (dt/2) • (width⁻¹ • (flux rightAverage-flux leftAverage))
      let predictedSlope := (1/2 : ℝ) • (leftSlope+rightSlope) -
        (dt/2) • (width⁻¹ •
          (fderiv ℝ flux rightAverage rightSlope-fderiv ℝ flux leftAverage leftSlope))
      ‖fderiv ℝ flux predicted predictedSlope -
        oneDimensionalCellAverage (fun τ => deriv (fun z => flux (q z τ)) face) 0 dt‖ ≤
        C*(width^2+dt^2) := by
  obtain ⟨δstate,hδstate,hδfinish,hδone,hstate⟩ :=
    leveque04_richtmyer_uniform_automatic_closedTime_predictor_ball_transfer
      q extension flux L R finish anchor spatialRadius stateRadius hfinish hanchor
      hspatial hradius hspace hq hext hcompact hpde hvalues hagree hjac
  obtain ⟨threshold,C,hthreshold,hC,hbudget⟩ :=
    leveque04_richtmyer_uniform_automatic_closedTime_faceTimeAverageDerivative_error
      q extension L R finish anchor hfinish hanchor hq hext hcompact hpde
  let δ := min threshold (min δstate (spatialRadius/2))
  have hδ : 0 < δ := lt_min hthreshold (lt_min hδstate (half_pos hspatial))
  have hδt : δ ≤ threshold := min_le_left _ _
  have hδs : δ ≤ δstate := (min_le_right _ _).trans (min_le_left _ _)
  have hδr : δ ≤ spatialRadius/2 := (min_le_right _ _).trans (min_le_right _ _)
  refine ⟨δ,C,hδ,hδs.trans hδfinish,hδs.trans hδone,hC,?_⟩
  intro face dt width hface hdt hdtSmall hwidth hwidthSmall
    profile leftAverage rightAverage leftSlope rightSlope predicted predictedSlope
  obtain ⟨hleft,hright,hpred,heq,hjacLeft,hjacRight,hjacPred⟩ :=
    hstate face dt width (hface.trans hδs) hdt (hdtSmall.trans hδs)
      hwidth (hwidthSmall.trans hδs)
  have hfaceMem : face ∈ Ioo L R := by
    apply hspace
    have hh := abs_le.mp (hface.trans hδr)
    constructor <;> linarith [hh.1,hh.2]
  have haverage :
      oneDimensionalCellAverage (fun τ => deriv (fun z => extension (q z τ)) face) 0 dt =
      oneDimensionalCellAverage (fun τ => deriv (fun z => flux (q z τ)) face) 0 dt := by
    unfold oneDimensionalCellAverage
    congr 1
    apply intervalIntegral.integral_congr
    intro τ hτ
    rw [uIcc_of_le hdt.le] at hτ
    exact hphysical face hfaceMem τ ⟨hτ.1,hτ.2.trans (hdtSmall.trans (hδs.trans hδfinish))⟩
  have hb := hbudget face dt width (hface.trans hδt) hdt
    (hdtSmall.trans (hδs.trans hδfinish)) (hdtSmall.trans (hδs.trans hδone))
    hwidth (hwidthSmall.trans hδt) (hwidthSmall.trans (hδs.trans hδone))
  dsimp only at hb
  rw [haverage] at hb
  rw [hjacRight,hjacLeft,heq] at hb
  rw [heq] at hjacPred
  rw [hjacPred] at hb
  exact hb

theorem leveque04_richtmyer_local_flux_physical_halfRectangle_transfer
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
    (q : ℝ → ℝ → E) (flux : E → E) (domain : Set E)
    (L R finish face : ℝ) (hfinish : 0 < finish) (hface : face ∈ Ioo L R)
    (hq : ContDiffOn ℝ 3 (Function.uncurry q) (Ioo L R ×ˢ Icc 0 finish))
    (hopen : IsOpen domain) (hstate : q face 0 ∈ domain)
    (hflux : ContDiffOn ℝ 3 flux domain)
    (hpde : ∀ x ∈ Ioo L R,
      derivWithin (q x) (Icc 0 finish) 0 + deriv (fun z => flux (q z 0)) x = 0) :
    ∃ radius spatialRadius horizon : ℝ, 0 < radius ∧ 0 < spatialRadius ∧
      0 < horizon ∧ horizon ≤ finish ∧
      Icc (face-spatialRadius) (face+spatialRadius) ⊆ Ioo L R ∧
    ∃ extension : E → E, ContDiff ℝ 3 extension ∧ HasCompactSupport extension ∧
      (∀ state ∈ ball (q face 0) radius, extension state = flux state) ∧
      (∀ state ∈ ball (q face 0) radius,
        fderiv ℝ extension state = fderiv ℝ flux state) ∧
      (∀ x ∈ Icc (face-spatialRadius) (face+spatialRadius), ∀ τ ∈ Icc 0 horizon,
        q x τ ∈ ball (q face 0) (radius/2)) ∧
      ContDiffOn ℝ 3 (Function.uncurry q)
        (Ioo (face-spatialRadius) (face+spatialRadius) ×ˢ Icc 0 horizon) ∧
      (∀ x ∈ Ioo (face-spatialRadius) (face+spatialRadius), ∀ τ ∈ Icc 0 horizon,
        deriv (fun z => extension (q z τ)) x = deriv (fun z => flux (q z τ)) x) ∧
      (∀ x ∈ Ioo (face-spatialRadius) (face+spatialRadius),
        derivWithin (q x) (Icc 0 horizon) 0 + deriv (fun z => extension (q z 0)) x = 0) := by
  obtain ⟨radius,hradius,extension,hext,hcompact,hagree⟩ :=
    local_contDiff_extension hopen hstate hflux
  obtain ⟨rs,horizon,hrs,hht,hmax,hspace,hstates⟩ :=
    continuous_closedTime_exists_local_state_rectangle
      q L R finish face (radius/2) hfinish hface (half_pos hradius) hq.continuousOn
  have hsmallspace : Ioo (face-rs) (face+rs) ⊆ Ioo L R :=
    Ioo_subset_Icc_self.trans hspace
  have hspatial (x : ℝ) (hx : x ∈ Ioo (face-rs) (face+rs))
      (τ : ℝ) (hτ : τ ∈ Icc 0 horizon) :
      deriv (fun z => extension (q z τ)) x = deriv (fun z => flux (q z τ)) x := by
    apply Filter.EventuallyEq.deriv_eq
    filter_upwards [isOpen_Ioo.mem_nhds hx] with z hz
    exact hagree _ (ball_subset_ball (half_le_self hradius.le)
      (hstates z ⟨hz.1.le,hz.2.le⟩ τ hτ))
  refine ⟨radius,rs,horizon,hradius,hrs,hht,hmax,hspace,extension,hext,hcompact,
    hagree,?_,hstates,hq.mono (prod_mono hsmallspace (Icc_subset_Icc le_rfl hmax)),
    hspatial,?_⟩
  · intro state hs
    apply Filter.EventuallyEq.fderiv_eq
    filter_upwards [isOpen_ball.mem_nhds hs] with y hy
    exact hagree y hy
  · intro x hx
    have hslice : ContDiffOn ℝ 3 (q x) (Icc 0 finish) :=
      hq.comp (contDiffOn_const.prodMk contDiffOn_id) (fun τ hτ => ⟨hsmallspace hx,hτ⟩)
    have hderiv : derivWithin (q x) (Icc 0 horizon) 0 =
        derivWithin (q x) (Icc 0 finish) 0 :=
      derivWithin_subset (Icc_subset_Icc le_rfl hmax)
        (uniqueDiffOn_Icc hht 0 ⟨le_rfl,hht.le⟩)
        ((hslice.of_le (m := 1) (by norm_num)).differentiableOn_one 0 ⟨le_rfl,hfinish.le⟩)
    rw [hderiv,hspatial x hx 0 ⟨le_rfl,hht.le⟩]
    exact hpde x (hsmallspace hx)

end NumStability
