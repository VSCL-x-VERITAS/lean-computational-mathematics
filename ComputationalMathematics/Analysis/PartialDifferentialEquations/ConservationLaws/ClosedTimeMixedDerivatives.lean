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
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalEndpointMeanQuadrature
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRectangleCellAverage
import Mathlib.Analysis.Calculus.BumpFunction.FiniteDimension
import Mathlib.Analysis.Calculus.ContDiff.Bounds
import Mathlib.Analysis.Calculus.ContDiff.Operations
import Mathlib.Analysis.Calculus.FDeriv.Symmetric
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Tactic

/-!
# ClosedTimeMixedDerivatives

Source-independent local calculus and actual physical cell-average mathematics. Closed forward-time endpoints and explicit quantitative domains are preserved.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

theorem closedTime_mixed_spatial_temporal_derivatives
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (L R start finish x t : ℝ)
    (htime : start < finish) (hx : x ∈ Ioo L R) (ht : t ∈ Icc start finish)
    (hq : ContDiffOn ℝ 2 (Function.uncurry q) (Ioo L R ×ˢ Icc start finish)) :
    derivWithin (fun τ => deriv (fun ξ => q ξ τ) x) (Icc start finish) t =
      deriv (fun ξ => derivWithin (q ξ) (Icc start finish) t) x := by
  let strip := Ioo L R ×ˢ Icc start finish
  let D := fderivWithin ℝ (Function.uncurry q) strip
  let DD := fderivWithin ℝ D strip
  have hU : UniqueDiffOn ℝ strip := isOpen_Ioo.uniqueDiffOn.prod (uniqueDiffOn_Icc htime)
  have hp : (x,t) ∈ strip := ⟨hx,ht⟩
  have hD : ContDiffOn ℝ 1 D strip := hq.fderivWithin hU (by norm_num)
  have hq1 : ContDiffOn ℝ 1 (Function.uncurry q) strip := hq.of_le (by norm_num)
  have hspace (ξ τ : ℝ) (hξ : ξ ∈ Ioo L R) (hτ : τ ∈ Icc start finish) :
      deriv (fun z => q z τ) ξ = D (ξ,τ) (1,0) := by
    have hcurve : HasDerivWithinAt (fun z : ℝ => (z,τ)) (1,0) (Ioo L R) ξ :=
      ((hasDerivAt_id ξ).prodMk (hasDerivAt_const ξ τ)).hasDerivWithinAt
    have hd := (hq1.differentiableOn_one (ξ,τ) ⟨hξ,hτ⟩).hasFDerivWithinAt
    have hmaps : MapsTo (fun z : ℝ => (z,τ)) (Ioo L R) strip := fun z hz => ⟨hz,hτ⟩
    exact ((hd.comp_hasDerivWithinAt ξ hcurve hmaps).hasDerivAt
      (isOpen_Ioo.mem_nhds hξ)).deriv
  have htimeId (ξ τ : ℝ) (hξ : ξ ∈ Ioo L R) (hτ : τ ∈ Icc start finish) :
      derivWithin (q ξ) (Icc start finish) τ = D (ξ,τ) (0,1) := by
    have hcurve : HasDerivWithinAt (fun z : ℝ => (ξ,z)) (0,1) (Icc start finish) τ :=
      ((hasDerivAt_const τ ξ).prodMk (hasDerivAt_id τ)).hasDerivWithinAt
    exact ((hq1.differentiableOn_one (ξ,τ) ⟨hξ,hτ⟩).hasFDerivWithinAt.comp_hasDerivWithinAt
      τ hcurve (fun z hz => ⟨hξ,hz⟩)).derivWithin (uniqueDiffOn_Icc htime τ hτ)
  have hd := (hD.differentiableOn_one (x,t) hp).hasFDerivWithinAt
  have hcurveT : HasDerivWithinAt (fun τ : ℝ => (x,τ)) (0,1) (Icc start finish) t :=
    ((hasDerivAt_const t x).prodMk (hasDerivAt_id t)).hasDerivWithinAt
  have hdt := hd.comp_hasDerivWithinAt t hcurveT (fun τ hτ => ⟨hx,hτ⟩)
  have hdtApply : HasDerivWithinAt (fun τ => D (x,τ) (1,0))
      (DD (x,t) (0,1) (1,0)) (Icc start finish) t := by
    simpa using hdt.clm_apply (hasDerivWithinAt_const t (Icc start finish) (1,0))
  have hleft : derivWithin (fun τ => deriv (fun ξ => q ξ τ) x) (Icc start finish) t =
      DD (x,t) (0,1) (1,0) :=
    (hdtApply.congr_of_mem (fun τ hτ => hspace x τ hx hτ) ht).derivWithin
      (uniqueDiffOn_Icc htime t ht)
  have hcurveX : HasDerivWithinAt (fun ξ : ℝ => (ξ,t)) (1,0) (Ioo L R) x :=
    ((hasDerivAt_id x).prodMk (hasDerivAt_const x t)).hasDerivWithinAt
  have hmapsX : MapsTo (fun ξ : ℝ => (ξ,t)) (Ioo L R) strip := fun ξ hξ => ⟨hξ,ht⟩
  have hdx := hd.comp_hasDerivWithinAt x hcurveX hmapsX
  have hdxApply : HasDerivWithinAt (fun ξ => D (ξ,t) (0,1))
      (DD (x,t) (1,0) (0,1)) (Ioo L R) x := by
    simpa using hdx.clm_apply (hasDerivWithinAt_const x (Ioo L R) (0,1))
  have hright : deriv (fun ξ => derivWithin (q ξ) (Icc start finish) t) x =
      DD (x,t) (1,0) (0,1) :=
    ((hdxApply.congr_of_mem (fun ξ hξ => htimeId ξ t hξ ht) hx).hasDerivAt
      (isOpen_Ioo.mem_nhds hx)).deriv
  have hclosure : (x,t) ∈ closure (interior strip) := by
    dsimp only [strip]
    rw [interior_prod_eq, isOpen_Ioo.interior_eq, interior_Icc, closure_prod_eq,
      closure_Ioo (lt_trans hx.1 hx.2).ne, closure_Ioo htime.ne]
    exact ⟨Ioo_subset_Icc_self hx,ht⟩
  have hsymm := (hq (x,t) hp).isSymmSndFDerivWithinAt (by norm_num) hU hclosure hp
  rw [hleft,hright]
  exact hsymm (0,1) (1,0)

theorem closedTime_differentiated_conservationPDE
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (flux : E → E) (L R start finish x t : ℝ)
    (htime : start < finish) (hx : x ∈ Ioo L R) (ht : t ∈ Icc start finish)
    (hq : ContDiffOn ℝ 2 (Function.uncurry q) (Ioo L R ×ˢ Icc start finish))
    (hpde : ∀ ξ ∈ Ioo L R,
      derivWithin (q ξ) (Icc start finish) t + deriv (fun z => flux (q z t)) ξ = 0) :
    derivWithin (fun τ => deriv (fun ξ => q ξ τ) x) (Icc start finish) t +
      deriv (fun ξ => deriv (fun z => flux (q z t)) ξ) x = 0 := by
  have heq : (fun ξ => derivWithin (q ξ) (Icc start finish) t) =ᶠ[𝓝 x]
      (fun ξ => -deriv (fun z => flux (q z t)) ξ) := by
    filter_upwards [isOpen_Ioo.mem_nhds hx] with ξ hξ
    exact eq_neg_of_add_eq_zero_left (hpde ξ hξ)
  rw [closedTime_mixed_spatial_temporal_derivatives
    q L R start finish x t htime hx ht hq, heq.deriv_eq]
  change deriv (-(fun ξ => deriv (fun z => flux (q z t)) ξ)) x +
    deriv (fun ξ => deriv (fun z => flux (q z t)) ξ) x = 0
  rw [deriv.neg]
  exact neg_add_cancel _

end NumStability
