/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.LocalDerivativeVariation
import ComputationalMathematics.Analysis.Calculus.LocalFirstOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSecondOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSymmetricTaylor
import ComputationalMathematics.Analysis.Calculus.LocalVectorCenteredSlope
import ComputationalMathematics.Analysis.Calculus.LocalVectorSecant
import ComputationalMathematics.Analysis.Calculus.UniformLocalDerivativeBudget
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.C2RectangleReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.ClosedTimePartialRegularity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLipschitzTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalEndpointMeanQuadrature
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRectangleCellAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalVectorCellMidpoint
import ComputationalMathematics.Source.LeVeque.Chapter04.MidpointAverage
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerLocalFluxGradient
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
# RichtmyerUniformSpatialBudgets

Source correspondence for LeVeque section4.7, printed72/PDF94. Smooth formal local accuracy is separate from accumulated global accuracy and behavior at discontinuities.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

theorem leveque04_richtmyer_uniform_actual_neighboring_cell_spatial_budgets
    {m : ℕ} (profile : ℝ → Fin m → ℝ) (anchor : ℝ)
    (hsmooth : ContDiffAt ℝ 3 profile anchor) :
    ∃ threshold A B M : ℝ,
      0 < threshold ∧ 0 ≤ A ∧ 0 ≤ B ∧ 0 ≤ M ∧
      ∀ face width : ℝ, |face-anchor| ≤ threshold →
        0 < width → width ≤ threshold → width ≤ 1 →
      (∀ cellCenter : ℝ, |cellCenter-face| ≤ width/2 →
        ‖oneDimensionalCellAverage profile (cellCenter-width/2) (cellCenter+width/2)-
            profile cellCenter‖ ≤ A*width^2/4 ∧
        ‖width⁻¹ • (profile (cellCenter+width/2)-profile (cellCenter-width/2))-
            deriv profile cellCenter‖ ≤ B*width^2/4 ∧
        ‖width⁻¹ • (profile (cellCenter+width/2)-profile (cellCenter-width/2))‖ ≤ M) ∧
      ‖(2*width)⁻¹ • (profile (face+width)-profile (face-width))-deriv profile face‖ ≤
        B*width^2 := by
  obtain ⟨ra,A,hra,hA,havg⟩ := uniform_local_vector_cellMidpoint_budget
    profile anchor (hsmooth.of_le (by norm_num))
  obtain ⟨rb,B,hrb,hB,hslope⟩ := uniform_local_centeredSlope_budget profile anchor hsmooth
  obtain ⟨rm,M,hrm,hM,hnorm⟩ := uniform_local_centeredSlope_norm_bound profile anchor hsmooth
  let threshold := min ra (min rb rm)/2
  have hpos : 0 < threshold := half_pos (lt_min hra (lt_min hrb hrm))
  have ha : 2*threshold ≤ ra := by dsimp [threshold]; linarith [min_le_left ra (min rb rm)]
  have hb : 2*threshold ≤ rb := by
    have h := (min_le_right ra (min rb rm)).trans (min_le_left rb rm)
    dsimp [threshold]; linarith
  have hm : 2*threshold ≤ rm := by
    have h := (min_le_right ra (min rb rm)).trans (min_le_right rb rm)
    dsimp [threshold]; linarith
  refine ⟨threshold,A,B,M,hpos,hA,hB,hM,?_⟩
  intro face width hface hwidth hsmall hwidthOne
  have hhalf : 0 < width/2 := by positivity
  constructor
  · intro cellCenter hcenter
    have htriangle := abs_sub_le cellCenter face anchor
    have hca : |cellCenter-anchor|+width/2 ≤ ra := by linarith
    have hcb : |cellCenter-anchor|+width/2 ≤ rb := by linarith
    have hcm : |cellCenter-anchor|+width/2 ≤ rm := by linarith
    have h1 := havg cellCenter (width/2) hhalf hca
    have h2 := hslope cellCenter (width/2) hhalf hcb
    have h3 := hnorm cellCenter (width/2) hhalf (by linarith) hcm
    have hw : 2*(width/2)=width := by ring
    rw [hw] at h2 h3
    refine ⟨?_,?_,h3⟩
    · convert h1 using 1; ring
    · convert h2 using 1; ring
  · exact hslope face width hwidth (by linarith)

theorem leveque04_richtmyer_uniform_automatic_local_state_spatial_budget
    {m : ℕ} (profile : ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ) (anchor : ℝ)
    (hprofile : ContDiffAt ℝ 3 profile anchor) (hflux : ContDiff ℝ 3 flux)
    (hcompact : HasCompactSupport flux) :
    ∃ threshold S F : ℝ, 0 < threshold ∧ 0 ≤ S ∧ 0 ≤ F ∧
      ∀ face width : ℝ, |face-anchor| ≤ threshold → 0 < width → width ≤ threshold → width ≤ 1 →
      let leftAverage := oneDimensionalCellAverage profile (face - width) face
      let rightAverage := oneDimensionalCellAverage profile face (face + width)
      ‖(1 / 2 : ℝ) • (leftAverage + rightAverage) - profile face‖ ≤ S * width ^ 2 ∧
      ‖width⁻¹ • (flux rightAverage - flux leftAverage) -
          deriv (fun z => flux (profile z)) face‖ ≤ F * width := by
  obtain ⟨rn,A,B,M,hrn,hA,hB,hM,hcells⟩ := leveque04_richtmyer_uniform_actual_neighboring_cell_spatial_budgets
    profile anchor hprofile
  obtain ⟨ra,S,hra,hS,havg⟩ := uniform_local_vector_cellMidpoint_budget
    profile anchor (hprofile.of_le (by norm_num))
  obtain ⟨rd,D,hrd,hD,hd,_⟩ := uniform_local_derivative_budget
    profile anchor (hprofile.of_le (by norm_num))
  have hphysical : ContDiffAt ℝ 2 (fun x => flux (profile x)) anchor :=
    (hflux.contDiffAt.of_le (by norm_num)).comp anchor (hprofile.of_le (by norm_num))
  obtain ⟨rp,K,hrp,hK,hpd,hLip⟩ := uniform_local_derivative_budget
    (fun x => flux (profile x)) anchor hphysical
  obtain ⟨L,hL⟩ := ContDiff.lipschitzWith_of_hasCompactSupport hcompact hflux (by decide)
  let threshold := min rn (min ra (min rd rp))/2
  have hpos : 0 < threshold := half_pos (lt_min hrn (lt_min hra (lt_min hrd hrp)))
  have hn : 2*threshold ≤ rn := by dsimp [threshold]; linarith [min_le_left rn (min ra (min rd rp))]
  have ha : 2*threshold ≤ ra := by
    have h := (min_le_right rn (min ra (min rd rp))).trans (min_le_left ra (min rd rp))
    dsimp [threshold]; linarith
  have hdR : 2*threshold ≤ rd := by
    have h := (min_le_right rn (min ra (min rd rp))).trans ((min_le_right ra (min rd rp)).trans (min_le_left rd rp))
    dsimp [threshold]; linarith
  have hp : 2*threshold ≤ rp := by
    have h := (min_le_right rn (min ra (min rd rp))).trans ((min_le_right ra (min rd rp)).trans (min_le_right rd rp))
    dsimp [threshold]; linarith
  refine ⟨threshold,S,2 * ((L : ℝ) * A / 4) + K / 2,
    hpos,hS,by positivity,?_⟩
  intro face width hface hwidth hsmall hwidthOne leftAverage rightAverage
  have hwn : width ≤ rn := by linarith
  have hfn : |face-anchor| ≤ rn := by linarith
  have hwa : |face-anchor|+width ≤ ra := by linarith
  have hwd : |face-anchor|+width ≤ rd := by linarith
  have hwp : |face-anchor|+width ≤ rp := by linarith
  have hsubd (x : ℝ) (hx : x ∈ Icc (face - width) (face + width)) :
      x ∈ Icc (anchor - rd) (anchor + rd) := by
    have hf := abs_le.mp hface
    constructor <;> linarith [hx.1,hx.2,hf.1,hf.2]
  have hc : ContinuousOn profile (Icc (face - width) (face + width)) :=
    fun x hx => (hd x (hsubd x hx)).continuousAt.continuousWithinAt
  have hi : IntervalIntegrable profile volume (face - width) (face + width) :=
    hc.intervalIntegrable_of_Icc (by linarith : face - width ≤ face + width)
  have hil : IntervalIntegrable profile volume (face - width) face :=
    hi.mono_set (by
      rw [uIcc_of_le (by linarith : face - width ≤ face),
        uIcc_of_le (by linarith : face - width ≤ face + width)]
      exact Icc_subset_Icc le_rfl (by linarith))
  have hir : IntervalIntegrable profile volume face (face + width) :=
    hi.mono_set (by
      rw [uIcc_of_le (by linarith : face ≤ face + width),
        uIcc_of_le (by linarith : face - width ≤ face + width)]
      exact Icc_subset_Icc (by linarith) le_rfl)
  constructor
  · rw [adjacent_vector_average_mean profile face width hwidth hil hir]
    exact havg face width hwidth (by simpa using hwa)
  · obtain ⟨hmid,_⟩ := hcells face width hfn hwidth hwn hwidthOne
    have hl := hmid (face - width / 2) (by
      rw [show (face - width / 2) - face = -(width / 2) by ring,abs_neg,
        abs_of_pos (by positivity : 0 < width / 2)])
    have hr := hmid (face + width / 2) (by
      rw [add_sub_cancel_left,abs_of_pos (by positivity : 0 < width / 2)])
    simp only [show face - width / 2 - width / 2 = face - width by ring,
      show face - width / 2 + width / 2 = face by ring] at hl
    simp only [show face + width / 2 - width / 2 = face by ring,
      show face + width / 2 + width / 2 = face + width by ring] at hr
    have hlf : ‖flux leftAverage - flux (profile (face - width / 2))‖ ≤
        ((L : ℝ) * A / 4) * width ^ 2 := by
      calc
        _ ≤ L * ‖leftAverage - profile (face - width / 2)‖ := hL.norm_sub_le _ _
        _ ≤ L * (A * width ^ 2 / 4) := mul_le_mul_of_nonneg_left hl.1 L.coe_nonneg
        _ = _ := by ring
    have hrf : ‖flux rightAverage - flux (profile (face + width / 2))‖ ≤
        ((L : ℝ) * A / 4) * width ^ 2 := by
      calc
        _ ≤ L * ‖rightAverage - profile (face + width / 2)‖ := hL.norm_sub_le _ _
        _ ≤ L * (A * width ^ 2 / 4) := mul_le_mul_of_nonneg_left hr.1 L.coe_nonneg
        _ = _ := by ring
    have hsubp (x : ℝ) (hx : x ∈ Icc (face - width / 2) (face + width / 2)) :
        x ∈ Icc (anchor - rp) (anchor + rp) := by
      have hf := abs_le.mp hface
      constructor <;> linarith [hx.1,hx.2,hf.1,hf.2]
    have hcenter : face ∈ Icc (anchor - rp) (anchor + rp) :=
      hsubp face ⟨by linarith,by linarith⟩
    have hsecant := local_vector_firstOrder_secant
      (fun x => flux (profile x)) (deriv (fun x => flux (profile x))) K face width hK hwidth
      (fun x hx => hpd x (hsubp x hx))
      (fun x hx => hLip x (hsubp x hx) face hcenter)
    exact leveque04_richtmyer_vectorCenteredSecant_endpointError
      (fun x => flux (profile x)) (deriv (fun x => flux (profile x)))
      (flux leftAverage) (flux rightAverage) face width K ((L : ℝ) * A / 4)
      hwidth hlf hrf hsecant

theorem leveque04_richtmyer_uniform_physical_fluxSlope_budget
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (profile : ℝ → E) (flux : E → E) (anchor : ℝ)
    (hprofile : ContDiffAt ℝ 3 profile anchor) (hflux : ContDiff ℝ 3 flux) :
    let physicalFlux := fun x => flux (profile x)
    let physicalSlope := deriv physicalFlux
    let physicalSecond := deriv physicalSlope
    ∃ radius G : ℝ, 0 < radius ∧ 0 ≤ G ∧
      (∀ x ∈ Icc (anchor-radius) (anchor+radius),
        HasDerivAt physicalSlope (physicalSecond x) x ∧
        physicalSlope x = fderiv ℝ flux (profile x) (deriv profile x)) ∧
      (∀ x ∈ Icc (anchor-radius) (anchor+radius),
        ∀ y ∈ Icc (anchor-radius) (anchor+radius),
        ‖physicalSecond x-physicalSecond y‖ ≤ G*|x-y|) := by
  intro physicalFlux physicalSlope physicalSecond
  have hphysical : ContDiffAt ℝ 3 physicalFlux anchor := hflux.contDiffAt.comp anchor hprofile
  have hslope : ContDiffAt ℝ 2 physicalSlope anchor := hphysical.derivWithin (by norm_num)
  obtain ⟨rd,G,hrd,hG,hderiv,hLip⟩ := uniform_local_derivative_budget
    physicalSlope anchor hslope
  obtain ⟨rp,K,hrp,hK,hprof,hprofLip⟩ := uniform_local_derivative_budget
    profile anchor (hprofile.of_le (by norm_num))
  have hsubD : Icc (anchor-min rd rp) (anchor+min rd rp) ⊆ Icc (anchor-rd) (anchor+rd) := by
    intro x hx
    have h := min_le_left rd rp
    constructor <;> linarith [hx.1,hx.2]
  have hsubP : Icc (anchor-min rd rp) (anchor+min rd rp) ⊆ Icc (anchor-rp) (anchor+rp) := by
    intro x hx
    have h := min_le_right rd rp
    constructor <;> linarith [hx.1,hx.2]
  refine ⟨min rd rp,G,lt_min hrd hrp,hG,?_,?_⟩
  · intro x hx
    refine ⟨hderiv x (hsubD hx),?_⟩
    exact ((hflux.differentiable (by decide) (profile x)).hasFDerivAt.comp_hasDerivAt
      x (hprof x (hsubP hx))).deriv
  · intro x hx y hy
    exact hLip x (hsubD hx) y (hsubD hy)

theorem leveque04_richtmyer_uniform_automatic_local_fluxGradient_budget
    {m : ℕ} (profile : ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ) (anchor : ℝ)
    (hprofile : ContDiffAt ℝ 3 profile anchor) (hflux : ContDiff ℝ 3 flux)
    (hcompact : HasCompactSupport flux) :
    ∃ threshold S F : ℝ, 0 < threshold ∧ 0 ≤ S ∧ 0 ≤ F ∧
      ∀ face width : ℝ, |face-anchor| ≤ threshold → 0 < width → width ≤ threshold → width ≤ 1 →
      let leftAverage := oneDimensionalCellAverage profile (face - width) face
      let rightAverage := oneDimensionalCellAverage profile face (face + width)
      let leftSlope := width⁻¹ • (profile face - profile (face - width))
      let rightSlope := width⁻¹ • (profile (face + width) - profile face)
      ‖(1 / 2 : ℝ) • (leftSlope + rightSlope) - deriv profile face‖ ≤ S * width ^ 2 ∧
      ‖width⁻¹ • (fderiv ℝ flux rightAverage rightSlope - fderiv ℝ flux leftAverage leftSlope) -
          deriv (fun x => deriv (fun z => flux (profile z)) x) face‖ ≤ F * width := by
  obtain ⟨rn,A,B,M,hrn,hA,hB,hM,hcells⟩ := leveque04_richtmyer_uniform_actual_neighboring_cell_spatial_budgets
    profile anchor hprofile
  obtain ⟨rp,G,hrp,hG,hphysical,hphysicalLip⟩ := leveque04_richtmyer_uniform_physical_fluxSlope_budget
    profile flux anchor hprofile hflux
  have htwo : ContDiff ℝ 2 flux := hflux.of_le (by norm_num)
  have hj : ContDiff ℝ 1 (fderiv ℝ flux) := htwo.fderiv_right (by decide)
  obtain ⟨L,hL⟩ := ContDiff.lipschitzWith_of_hasCompactSupport (hcompact.fderiv ℝ) hj (by decide)
  obtain ⟨N0,hN0⟩ := hL.continuous.bounded_above_of_compact_support (hcompact.fderiv ℝ)
  let N : ℝ := max N0 0
  have hN : 0 ≤ N := le_max_right _ _
  have hnorm (state : Fin m → ℝ) : ‖fderiv ℝ flux state‖ ≤ N :=
    (hN0 state).trans (le_max_left _ _)
  refine ⟨min rn (rp/2),B,2 * ((L : ℝ) * (A / 4) * M + N * (B / 4)) + G / 2,
    lt_min hrn (half_pos hrp),hB,by positivity,?_⟩
  intro face width hface hwidth hsmall hwidthOne leftAverage rightAverage leftSlope rightSlope
  have hwn : width ≤ rn := hsmall.trans (min_le_left _ _)
  have hwp : width ≤ rp/2 := hsmall.trans (min_le_right _ _)
  have hfp : |face-anchor| ≤ rp/2 := hface.trans (min_le_right _ _)
  have hfn : |face-anchor| ≤ rn := hface.trans (min_le_left _ _)
  obtain ⟨hmid,hcenter⟩ := hcells face width hfn hwidth hwn hwidthOne
  have hcl : |(face - width / 2) - face| ≤ width / 2 := by
    rw [show (face - width / 2) - face = -(width / 2) by ring,
      abs_neg,abs_of_pos (by positivity : 0 < width / 2)]
  have hcr : |(face + width / 2) - face| ≤ width / 2 := by
    rw [add_sub_cancel_left,abs_of_pos (by positivity : 0 < width / 2)]
  have hl := hmid (face - width / 2) hcl
  have hr := hmid (face + width / 2) hcr
  have hll : face - width / 2 - width / 2 = face - width := by ring
  have hlr : face - width / 2 + width / 2 = face := by ring
  have hrl : face + width / 2 - width / 2 = face := by ring
  have hrr : face + width / 2 + width / 2 = face + width := by ring
  simp only [hll,hlr] at hl
  simp only [hrl,hrr] at hr
  have hphysicalSub (x : ℝ) (hx : x ∈ Set.Icc (face - width / 2) (face + width / 2)) :
      x ∈ Set.Icc (anchor - rp) (anchor + rp) := by
    have hfabs := abs_le.mp hfp
    constructor <;> linarith [hx.1,hx.2,hfabs.1,hfabs.2]
  have hpleft := hphysical (face - width / 2) (hphysicalSub _ ⟨le_rfl,by linarith⟩)
  have hpright := hphysical (face + width / 2) (hphysicalSub _ ⟨by linarith,le_rfl⟩)
  have hcenterId : (1 / 2 : ℝ) • (leftSlope + rightSlope) =
      (2 * width)⁻¹ • (profile (face + width) - profile (face - width)) := by
    dsimp only [leftSlope,rightSlope]
    rw [← smul_add,smul_smul,
      show (1 / 2 : ℝ) * width⁻¹ = (2 * width)⁻¹ by field_simp]
    congr 1
    abel
  refine ⟨by rw [hcenterId]; exact hcenter,?_⟩
  apply leveque04_richtmyer_local_vector_fluxGradient_error
    profile (deriv (fun x => flux (profile x)))
    (deriv (deriv (fun x => flux (profile x)))) (fderiv ℝ flux)
    leftAverage rightAverage leftSlope rightSlope face width L (A/4) (B/4) M N G
    hwidth L.coe_nonneg (by positivity) hN hG
    (by convert hl.1 using 1; ring)
    (by convert hr.1 using 1; ring)
    (by convert hl.2.1 using 1; ring)
    (by convert hr.2.1 using 1; ring)
    hl.2.2 hr.2.2 (hnorm _) (hnorm _)
    (hL.norm_sub_le _ _) (hL.norm_sub_le _ _) hpleft.2 hpright.2
    (fun x hx => (hphysical x (hphysicalSub x hx)).1)
    (fun x hx => hphysicalLip x (hphysicalSub x hx) face
      (hphysicalSub face ⟨by linarith,by linarith⟩))

end NumStability
