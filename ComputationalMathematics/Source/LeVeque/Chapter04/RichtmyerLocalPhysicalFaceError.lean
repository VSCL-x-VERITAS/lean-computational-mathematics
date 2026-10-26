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
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLipschitzTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalEndpointMeanQuadrature
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRectangleCellAverage
import ComputationalMathematics.Source.LeVeque.Chapter04.MidpointAverage
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerClosedTimePhysicalFluxDerivative
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerExactAverageFaceDerivative
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerOriginalFluxDerivativeBudget
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerOriginalFluxTransfer
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
# RichtmyerLocalPhysicalFaceError

Source correspondence for LeVeque section4.7, printed72/PDF94. Smooth formal local accuracy is separate from accumulated global accuracy and behavior at discontinuities.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

theorem leveque04_richtmyer_uniform_original_localFlux_actualFaceError_derivative
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ) (domain : Set (Fin m → ℝ))
    (L R finish anchor : ℝ) (hfinish : 0 < finish) (hanchor : anchor ∈ Ioo L R)
    (hq : ContDiffOn ℝ 3 (Function.uncurry q) (Ioo L R ×ˢ Icc 0 finish))
    (hopen : IsOpen domain) (hstate : q anchor 0 ∈ domain)
    (hflux : ContDiffOn ℝ 3 flux domain)
    (hpde : ∀ x ∈ Ioo L R,
      derivWithin (q x) (Icc 0 finish) 0 + deriv (fun z => flux (q z 0)) x = 0) :
    ∃ δ C : ℝ, 0 < δ ∧ δ ≤ finish ∧ δ ≤ 1 ∧ 0 ≤ C ∧
      ∀ face dt width : ℝ, |face-anchor| ≤ δ → 0 < dt → dt ≤ δ →
        0 < width → width ≤ δ →
      let error := fun x => leveque04_richtmyerFlux dt width flux
        (oneDimensionalCellAverage (fun z => q z 0) (x-width) x)
        (oneDimensionalCellAverage (fun z => q z 0) x (x+width)) -
        oneDimensionalCellAverage (fun τ => flux (q x τ)) 0 dt
      HasDerivAt error (deriv error face) face ∧
        ‖deriv error face‖ ≤ C*(width^2+dt^2) := by
  obtain ⟨radius,rs,T,hradius,hrs,hT,hmax,hspace,extension,hext,hcompact,
      hagree,hjac,hstates,hqsmall,hphysical,hPDE⟩ :=
    leveque04_richtmyer_local_flux_physical_halfRectangle_transfer
      q flux domain L R finish anchor hfinish hanchor hq hopen hstate hflux hpde
  have hanchorSmall : anchor ∈ Ioo (anchor-rs) (anchor+rs) := by
    constructor <;> linarith
  have hhalfSpace : Icc (anchor-rs/2) (anchor+rs/2) ⊆ Ioo (anchor-rs) (anchor+rs) := by
    intro x hx; constructor <;> linarith [hx.1,hx.2]
  have hhalfStates : ∀ x ∈ Icc (anchor-rs/2) (anchor+rs/2),
      ∀ τ ∈ Icc 0 T, q x τ ∈ ball (q anchor 0) (radius/2) := by
    intro x hx τ hτ
    apply hstates x _ τ hτ
    constructor <;> linarith [hx.1,hx.2]
  obtain ⟨db,hdb,hdbT,_hdbOne,hball⟩ :=
    leveque04_richtmyer_uniform_automatic_closedTime_predictor_ball_transfer
      q extension flux (anchor-rs) (anchor+rs) T anchor (rs/2) radius
      hT hanchorSmall (half_pos hrs) hradius hhalfSpace hqsmall hext hcompact
      hPDE hhalfStates hagree hjac
  obtain ⟨de,C,hde,hdeFinish,hdeOne,hC,hbudget⟩ :=
    leveque04_richtmyer_uniform_original_localFlux_faceDerivative_chainBudget
      q flux domain L R finish anchor hfinish hanchor hq hopen hstate hflux hpde
  let δ := min db (min de (rs/4))
  have hδ : 0 < δ := lt_min hdb (lt_min hde (by positivity))
  have hδb : δ ≤ db := min_le_left _ _
  have hδe : δ ≤ de := (min_le_right _ _).trans (min_le_left _ _)
  have hδr : δ ≤ rs/4 := (min_le_right _ _).trans (min_le_right _ _)
  have hc : ContinuousOn (fun z => q z 0) (Ioo (anchor-rs) (anchor+rs)) :=
    hqsmall.continuousOn.comp (continuousOn_id.prodMk continuousOn_const)
      (fun z hz => ⟨hz,le_rfl,hT.le⟩)
  refine ⟨δ,C,hδ,hδe.trans hdeFinish,hδe.trans hdeOne,hC,?_⟩
  intro face dt width hface hdt hdtδ hw hwδ error
  have hdtT := hdtδ.trans (hδb.trans hdbT)
  have hfaceMem : face ∈ Ioo (anchor-rs) (anchor+rs) := by
    have hf := abs_le.mp (hface.trans hδr)
    constructor <;> linarith [hf.1,hf.2]
  have hl : face-width ∈ Ioo (anchor-rs) (anchor+rs) := by
    have hf := abs_le.mp (hface.trans hδr)
    have hh := hwδ.trans hδr
    constructor <;> linarith [hf.1,hf.2]
  have hr : face+width ∈ Ioo (anchor-rs) (anchor+rs) := by
    have hf := abs_le.mp (hface.trans hδr)
    have hh := hwδ.trans hδr
    constructor <;> linarith [hf.1,hf.2]
  obtain ⟨hleft,hright,hpred,heq,_hjLeft,_hjRight,_hjPred⟩ :=
    hball face dt width (hface.trans hδb) hdt (hdtδ.trans hδb) hw (hwδ.trans hδb)
  have hcoef : dt/(2*width) = (dt/2)*width⁻¹ := by field_simp
  have hpredOriginal : leveque04_richtmyerPredictor dt width flux
      (oneDimensionalCellAverage (fun z => q z 0) (face-width) face)
      (oneDimensionalCellAverage (fun z => q z 0) face (face+width)) ∈
      ball (q anchor 0) radius := by
    rw [heq] at hpred
    simpa only [leveque04_richtmyerPredictor,hcoef,smul_smul] using hpred
  have hfd (state : Fin m → ℝ) (hs : state ∈ ball (q anchor 0) radius) :=
    local_extension_hasFDerivAt_original extension flux (q anchor 0) radius
      (hext.of_le (by norm_num)) hagree state hs
  have hn := leveque04_richtmyer_local_exactAverageFace_hasDerivAt
    (fun z => q z 0) flux (anchor-rs) (anchor+rs) face dt width hw hc hfaceMem hl hr
    (hfd _ hleft) (hfd _ hright) (hfd _ hpredOriginal)
  have hpAux := leveque04_richtmyer_closedTime_physicalFluxTimeAverage_hasDerivAt
    q extension (anchor-rs) (anchor+rs) T face hT hfaceMem hqsmall hext dt hdt hdtT
  have hgerm : (fun x => oneDimensionalCellAverage (fun τ => flux (q x τ)) 0 dt) =ᶠ[nhds face]
      (fun x => oneDimensionalCellAverage (fun τ => extension (q x τ)) 0 dt) := by
    filter_upwards [isOpen_Ioo.mem_nhds hfaceMem] with x hx
    unfold oneDimensionalCellAverage
    congr 1
    apply intervalIntegral.integral_congr
    intro τ hτ
    rw [uIcc_of_le hdt.le] at hτ
    exact (hagree _ (ball_subset_ball (half_le_self hradius.le)
      (hstates x ⟨hx.1.le,hx.2.le⟩ τ ⟨hτ.1,hτ.2.trans hdtT⟩))).symm
  have hphysicalAverage :
      oneDimensionalCellAverage (fun τ => deriv (fun z => extension (q z τ)) face) 0 dt =
      oneDimensionalCellAverage (fun τ => deriv (fun z => flux (q z τ)) face) 0 dt := by
    unfold oneDimensionalCellAverage
    congr 1
    apply intervalIntegral.integral_congr
    intro τ hτ
    rw [uIcc_of_le hdt.le] at hτ
    exact hphysical face hfaceMem τ ⟨hτ.1,hτ.2.trans hdtT⟩
  have hp := hpAux.congr_of_eventuallyEq hgerm
  rw [hphysicalAverage] at hp
  have hd := hn.sub hp
  have hb := hbudget face dt width (hface.trans hδe) hdt (hdtδ.trans hδe)
    hw (hwδ.trans hδe)
  dsimp only at hb hd
  have he : deriv error face = _ := hd.deriv
  refine ⟨?_,?_⟩
  · rw [he]; exact hd
  · rw [he]
    simpa only [leveque04_richtmyerPredictor,hcoef,smul_smul] using hb

theorem leveque04_richtmyer_uniform_original_localFlux_actualFaceError_divergence
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ) (domain : Set (Fin m → ℝ))
    (L R finish anchor : ℝ) (hfinish : 0 < finish) (hanchor : anchor ∈ Ioo L R)
    (hq : ContDiffOn ℝ 3 (Function.uncurry q) (Ioo L R ×ˢ Icc 0 finish))
    (hopen : IsOpen domain) (hstate : q anchor 0 ∈ domain)
    (hflux : ContDiffOn ℝ 3 flux domain)
    (hpde : ∀ x ∈ Ioo L R,
      derivWithin (q x) (Icc 0 finish) 0 + deriv (fun z => flux (q z 0)) x = 0) :
    ∃ δ C : ℝ, 0 < δ ∧ δ ≤ finish ∧ δ ≤ 1 ∧ 0 ≤ C ∧
      ∀ face dt width : ℝ, |face-anchor| ≤ δ → 0 < dt → dt ≤ δ →
        0 < width → width ≤ δ →
      let error := fun x => leveque04_richtmyerFlux dt width flux
        (oneDimensionalCellAverage (fun z => q z 0) (x-width) x)
        (oneDimensionalCellAverage (fun z => q z 0) x (x+width)) -
        oneDimensionalCellAverage (fun τ => flux (q x τ)) 0 dt
      ‖width⁻¹ • (error (face+width)-error face)‖ ≤ C*(width^2+dt^2) := by
  obtain ⟨threshold,C,hthreshold,htFinish,htOne,hC,hderivative⟩ :=
    leveque04_richtmyer_uniform_original_localFlux_actualFaceError_derivative
      q flux domain L R finish anchor hfinish hanchor hq hopen hstate hflux hpde
  have hhalf : threshold/2 ≤ threshold := half_le_self hthreshold.le
  refine ⟨threshold/2,C,half_pos hthreshold,hhalf.trans htFinish,hhalf.trans htOne,hC,?_⟩
  intro face dt width hface hdt hdtSmall hw hwSmall error
  have hall (x : ℝ) (hx : x ∈ Icc face (face+width)) :
      HasDerivAt error (deriv error x) x ∧
        ‖deriv error x‖ ≤ C*(width^2+dt^2) := by
    have hf := abs_le.mp hface
    have hnear : |x-anchor| ≤ threshold := abs_le.mpr ⟨by linarith [hx.1],by linarith [hx.2]⟩
    exact hderivative x dt width hnear hdt (hdtSmall.trans hhalf) hw (hwSmall.trans hhalf)
  have hm := norm_image_sub_le_of_norm_deriv_le_segment'
    (a:=face) (b:=face+width) (f:=error) (f':=deriv error)
    (C:=C*(width^2+dt^2))
    (fun x hx => (hall x hx).1.hasDerivWithinAt)
    (fun x hx => (hall x ⟨hx.1,hx.2.le⟩).2)
    (face+width) ⟨by linarith,le_rfl⟩
  rw [add_sub_cancel_left] at hm
  rw [norm_smul,Real.norm_eq_abs,abs_of_pos (inv_pos.mpr hw)]
  calc
    _ ≤ width⁻¹ * (C*(width^2+dt^2)*width) :=
      mul_le_mul_of_nonneg_left hm (inv_nonneg.mpr hw.le)
    _ = C*(width^2+dt^2) := by field_simp

end NumStability
