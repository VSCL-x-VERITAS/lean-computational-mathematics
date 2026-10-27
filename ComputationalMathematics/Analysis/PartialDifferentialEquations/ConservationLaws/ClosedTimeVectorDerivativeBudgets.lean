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
# ClosedTimeVectorDerivativeBudgets

Source-independent local calculus and actual physical cell-average mathematics. Closed forward-time endpoints and explicit quantitative domains are preserved.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

theorem closedTime_vector_temporalSlope_budget
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (L R start finish a b : ℝ)
    (htime : start < finish) (hspace : Icc a b ⊆ Ioo L R)
    (hq : ContDiffOn ℝ 3 (Function.uncurry q) (Ioo L R ×ˢ Icc start finish)) :
    let qX : ℝ → ℝ → E := fun x τ => deriv (fun ξ => q ξ τ) x
    let qXT : ℝ → ℝ → E := fun x τ => derivWithin (qX x) (Icc start finish) τ
    ∃ K : NNReal,
      (∀ x ∈ Icc a b, ∀ τ ∈ Icc start finish,
        HasDerivWithinAt (qX x) (qXT x τ) (Icc start finish) τ) ∧
      (∀ x ∈ Icc a b, ∀ τ ∈ Icc start finish, ∀ σ ∈ Icc start finish,
        ‖qXT x τ - qXT x σ‖ ≤ K * |τ - σ|) := by
  intro qX qXT
  let strip := Ioo L R ×ˢ Icc start finish
  let box := Icc a b ×ˢ Icc start finish
  have hX : ContDiffOn ℝ 2 (Function.uncurry qX) strip := by
    simpa only [qX, Function.uncurry_apply_pair] using
      contDiffOn_closedTimeStrip_spatial_derivative 2 q L R start finish htime hq
  have hXT : ContDiffOn ℝ 1 (Function.uncurry qXT) strip := by
    simpa only [qXT, Function.uncurry_apply_pair] using
      contDiffOn_closedTimeStrip_temporal_derivativeWithin 1 qX L R start finish htime hX
  have hsub : box ⊆ strip := prod_mono hspace (Subset.refl _)
  obtain ⟨K, hK⟩ := (hXT.mono hsub).exists_lipschitzOnWith (by norm_num)
    ((convex_Icc a b).prod (convex_Icc start finish)) (isCompact_Icc.prod isCompact_Icc)
  refine ⟨K, ?_, ?_⟩
  · intro x hx τ hτ
    have hslice : ContDiffOn ℝ 2 (qX x) (Icc start finish) :=
      hX.comp (contDiffOn_const.prodMk contDiffOn_id) (fun t ht => ⟨hspace hx, ht⟩)
    exact ((hslice.of_le (m := 1) (by norm_num)).differentiableOn_one τ hτ).hasDerivWithinAt
  · intro x hx τ hτ σ hσ
    have h := hK.norm_sub_le (show (x, τ) ∈ box from ⟨hx, hτ⟩)
      (show (x, σ) ∈ box from ⟨hx, hσ⟩)
    simpa only [Function.uncurry_apply_pair, Prod.norm_def, Prod.fst_sub, Prod.snd_sub,
      sub_self, norm_zero, Real.norm_eq_abs, max_eq_right (abs_nonneg (τ - σ))] using h

theorem closedTime_field_temporalDerivative_budget
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (L R start finish a b : ℝ)
    (htime : start < finish) (hspace : Icc a b ⊆ Ioo L R)
    (hq : ContDiffOn ℝ 2 (Function.uncurry q) (Ioo L R ×ˢ Icc start finish)) :
    ∃ K : NNReal,
      (∀ x ∈ Icc a b, ∀ τ ∈ Icc start finish,
        HasDerivWithinAt (q x) (derivWithin (q x) (Icc start finish) τ)
          (Icc start finish) τ) ∧
      (∀ x ∈ Icc a b, ∀ τ ∈ Icc start finish, ∀ σ ∈ Icc start finish,
        ‖derivWithin (q x) (Icc start finish) τ -
          derivWithin (q x) (Icc start finish) σ‖ ≤ K * |τ - σ|) := by
  let strip := Ioo L R ×ˢ Icc start finish
  let box := Icc a b ×ˢ Icc start finish
  have hT : ContDiffOn ℝ 1
      (fun p : ℝ × ℝ => derivWithin (q p.1) (Icc start finish) p.2) strip :=
    contDiffOn_closedTimeStrip_temporal_derivativeWithin 1 q L R start finish htime hq
  have hsub : box ⊆ strip := prod_mono hspace (Subset.refl _)
  obtain ⟨K,hK⟩ := (hT.mono hsub).exists_lipschitzOnWith (by norm_num)
    ((convex_Icc a b).prod (convex_Icc start finish)) (isCompact_Icc.prod isCompact_Icc)
  refine ⟨K,?_,?_⟩
  · intro x hx τ hτ
    have hslice : ContDiffOn ℝ 2 (q x) (Icc start finish) :=
      hq.comp (contDiffOn_const.prodMk contDiffOn_id) (fun t ht => ⟨hspace hx,ht⟩)
    exact ((hslice.of_le (m := 1) (by norm_num)).differentiableOn_one τ hτ).hasDerivWithinAt
  · intro x hx τ hτ σ hσ
    have h := hK.norm_sub_le (show (x,τ) ∈ box from ⟨hx,hτ⟩)
      (show (x,σ) ∈ box from ⟨hx,hσ⟩)
    simpa only [Prod.norm_def,Prod.fst_sub,Prod.snd_sub,sub_self,norm_zero,
      Real.norm_eq_abs,max_eq_right (abs_nonneg (τ - σ))] using h

end NumStability
