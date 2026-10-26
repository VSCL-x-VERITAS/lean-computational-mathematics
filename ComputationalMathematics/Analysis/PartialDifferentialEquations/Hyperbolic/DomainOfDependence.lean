/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.MovingRiemannJump
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.StationaryJump
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalLinearAdvection
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.VariableCoefficient
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLipschitzTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageNeighborTaylor
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.TravelingJumpAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FirstOrderEquation
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolic.ClassicalFinitePropagation
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolic.ForcedFinitePropagation
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.MaterialDerivative
import ComputationalMathematics.Analysis.PartialDifferentialEquations.VariableLinearFlux
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.Order.Ring.Abs
import Mathlib.Analysis.Calculus.ContDiff.Operations
import Mathlib.Analysis.Calculus.Deriv.Pow
import Mathlib.Analysis.Calculus.Deriv.Prod
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Analysis.Normed.Module.FiniteDimension
import Mathlib.Analysis.ODE.Gronwall
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import Mathlib.Analysis.SpecialFunctions.Log.Deriv
import Mathlib.Data.Matrix.Mul
import Mathlib.Data.Real.Basic
import Mathlib.MeasureTheory.Function.JacobianOneDim
import Mathlib.MeasureTheory.Integral.IntervalIntegral.AbsolutelyContinuousFun
import Mathlib.MeasureTheory.Measure.Lebesgue.EqHaar
import Mathlib.MeasureTheory.Measure.OpenPos
import Mathlib.Tactic.Abel
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.FunProp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
import Mathlib.Topology.MetricSpace.Lipschitz
import Mathlib.Topology.Order.Compact

/-!
# DomainOfDependence

Source-independent mathematics. Actual derivatives, integrability and displayed analytic hypotheses are retained.
-/

namespace NumStability

open Set Filter MeasureTheory Topology
open scoped BigOperators Topology NNReal

/-- The actual difference equation for two fields of one original
quasilinear equation. Its coefficient is the actual first-field matrix;
the source retains the coefficient difference acting on the actual second
field spatial derivative. -/
noncomputable def actualDifferenceEquation
    {ι : Type*} [Fintype ι] (equation : FirstOrderEquation ι)
    (q r : ℝ → ℝ → ι → ℝ) : FirstOrderEquation ι where
  admissibleStates := Set.univ
  principal := fun x t _ => equation.principal x t (q x t)
  forcing := fun x t _ =>
    equation.forcing x t (q x t)-equation.forcing x t (r x t) +
      (equation.principal x t (r x t)-equation.principal x t (q x t)).mulVec
        (deriv (fun ξ => r ξ t) x)

/-- Two actual original classical solutions yield the exact forced
difference PDE. No difference residual or linearized evolution is assumed. -/
theorem firstOrderEquation_actual_difference_classical
    {ι : Type*} [Fintype ι]
    (equation : FirstOrderEquation ι) (q r : ℝ → ℝ → ι → ℝ) (x t : ℝ)
    (hq : equation.IsClassicalSolutionAt q x t)
    (hr : equation.IsClassicalSolutionAt r x t) :
    (actualDifferenceEquation equation q r).IsClassicalSolutionAt
      (fun ξ τ => q ξ τ-r ξ τ) x t := by
  obtain ⟨_,qt,qx,hqt,hqx,hqe⟩ := hq
  obtain ⟨_,rt,rx,hrt,hrx,hre⟩ := hr
  refine ⟨Set.mem_univ _,qt-rt,qx-rx,hqt.sub hrt,hqx.sub hrx,?_⟩
  apply (FirstOrderEquation.residual_eq_zero_iff _ _ _ _ _ _).mpr
  have hq0 := (FirstOrderEquation.residual_eq_zero_iff _ _ _ _ _ _).mp hqe
  have hr0 := (FirstOrderEquation.residual_eq_zero_iff _ _ _ _ _ _).mp hre
  change qt-rt+(equation.principal x t (q x t)).mulVec (qx-rx) =
    equation.forcing x t (q x t)-equation.forcing x t (r x t) +
      (equation.principal x t (r x t)-equation.principal x t (q x t)).mulVec
        (deriv (fun ξ => r ξ t) x)
  rw [hrx.deriv,Matrix.mulVec_sub,Matrix.sub_mulVec]
  rw [←hq0,←hr0]
  abel

/-- Two actual local C1 solutions of one original quasilinear equation have finite domain of dependence when the actual coefficient-difference source is bounded by their coordinate difference. -/
theorem firstOrderEquation_actual_c1_domain_of_dependence
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (equation : FirstOrderEquation ι) (q r : ℝ → ℝ → ι → ℝ)
    (L R : ℝ → ℝ → Matrix ι ι ℝ)
    (speed : ℝ → ℝ → ι → ℝ)

    (a b C T G δ lo hi : ℝ) (X U : Set ℝ)
    (hX : IsOpen X) (hU : IsOpen U)
    (hbox : Icc lo hi ×ˢ Icc (-δ) (T+δ) ⊆ X ×ˢ U)
    (hqC : ∀ i, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => q p.1 p.2 i) (X ×ˢ U))
    (hrC : ∀ i, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => r p.1 p.2 i) (X ×ˢ U))
    (hL : ∀ i j, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => L p.1 p.2 i j) (X ×ˢ U))
    (hR : ∀ i j, ContinuousOn (fun p : ℝ × ℝ => R p.1 p.2 i j) (X ×ˢ U))
    (hs : ∀ i, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => speed p.1 p.2 i) (X ×ˢ U))
    (hC : 0 ≤ C) (hT : 0 ≤ T) (hwidth : 0 < b-a-2*C*T) (hδ : 0 < δ)
    (hposition : ∀ τ ∈ Icc (-δ) (T+δ), ∀ y ∈ Icc (0:ℝ) 1,
      a+C*τ+(b-a-2*C*τ)*y ∈ Icc lo hi)
    (hqclass : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), equation.IsClassicalSolutionAt q x τ)
    (hrclass : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), equation.IsClassicalSolutionAt r x τ)
    (hforcing : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), finiteVecNorm2 ((L x τ).mulVec (equation.forcing x τ (q x τ)-equation.forcing x τ (r x τ)+(equation.principal x τ (r x τ)-equation.principal x τ (q x τ)).mulVec (deriv (fun ξ => r ξ τ) x))) ≤ G*finiteVecNorm2 ((L x τ).mulVec (q x τ-r x τ)))
    (hdiag : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), L x τ * equation.principal x τ (q x τ) = Matrix.diagonal (speed x τ) * L x τ)
    (hinverse : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), R x τ * L x τ = 1)
    (hbound : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ p, |speed x τ p| ≤ C)
    (hinit : ∀ x ∈ Icc a b, q x 0 = r x 0) :
    ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), q x τ = r x τ := by
  have hzero := firstOrderEquation_actual_forced_c1_finite_propagation
    (actualDifferenceEquation equation q r) (fun x τ => q x τ-r x τ) L R speed
    a b C T G δ lo hi X U hX hU hbox (fun i => (hqC i).sub (hrC i)) hL hR hs
    hC hT hwidth hδ hposition
    (fun τ hτ x hx => firstOrderEquation_actual_difference_classical equation q r x τ (hqclass τ hτ x hx) (hrclass τ hτ x hx))
    hforcing hdiag hinverse hbound (fun x hx => sub_eq_zero.mpr (hinit x hx))
  intro τ hτ x hx
  exact sub_eq_zero.mp (hzero τ hτ x hx)

/-- Actual coefficient and forcing differences controlled by state
differences yield the coordinate forcing bound required for domain of
dependence. Canonical finite norms and matrix actions are reused. -/
theorem actualDifferenceCoordinateForcing_bound
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (left right forcingLeft forcingRight spatialRight : ι → ℝ)
    (Aleft Aright L R : Matrix ι ι ℝ) (Lbound Rbound ALip bLip Dx : ℝ)
    (hLnonneg : 0 ≤ Lbound)
    (hALip : 0 ≤ ALip) (hbLip : 0 ≤ bLip) (hDx : 0 ≤ Dx)
    (hL : finiteOpNorm2Le L Lbound) (hR : finiteOpNorm2Le R Rbound)
    (hinverse : R*L=1)
    (hA : finiteOpNorm2Le (Aright-Aleft) (ALip*finiteVecNorm2 (left-right)))
    (hb : finiteVecNorm2 (forcingLeft-forcingRight) ≤ bLip*finiteVecNorm2 (left-right))
    (hspace : finiteVecNorm2 spatialRight ≤ Dx) :
    finiteVecNorm2 (L.mulVec (forcingLeft-forcingRight+(Aright-Aleft).mulVec spatialRight)) ≤
      (Lbound*(bLip+ALip*Dx)*Rbound)*finiteVecNorm2 (L.mulVec (left-right)) := by
  have hmatrix : finiteVecNorm2 ((Aright-Aleft).mulVec spatialRight) ≤
      (ALip*finiteVecNorm2 (left-right))*finiteVecNorm2 spatialRight := by
    simpa only [finiteMatVec,Matrix.mulVec,dotProduct] using hA spatialRight
  have hmatrix' := hmatrix.trans (mul_le_mul_of_nonneg_left hspace
    (mul_nonneg hALip (finiteVecNorm2_nonneg (left-right))))
  have hsource : finiteVecNorm2 (forcingLeft-forcingRight+(Aright-Aleft).mulVec spatialRight) ≤
      (bLip+ALip*Dx)*finiteVecNorm2 (left-right) := by
    calc
      _ ≤ finiteVecNorm2 (forcingLeft-forcingRight)+finiteVecNorm2 ((Aright-Aleft).mulVec spatialRight) := finiteVecNorm2_add_le _ _
      _ ≤ bLip*finiteVecNorm2 (left-right)+(ALip*finiteVecNorm2 (left-right))*Dx := add_le_add hb hmatrix'
      _ = _ := by ring
  have hreconstruct : R.mulVec (L.mulVec (left-right))=left-right := by rw [Matrix.mulVec_mulVec,hinverse,Matrix.one_mulVec]
  have hstate : finiteVecNorm2 (left-right) ≤ Rbound*finiteVecNorm2 (L.mulVec (left-right)) := by
    have h : finiteVecNorm2 (R.mulVec (L.mulVec (left-right))) ≤ Rbound*finiteVecNorm2 (L.mulVec (left-right)) := by
      simpa only [finiteMatVec,Matrix.mulVec,dotProduct] using hR (L.mulVec (left-right))
    rwa [hreconstruct] at h
  have hout : finiteVecNorm2 (L.mulVec (forcingLeft-forcingRight+(Aright-Aleft).mulVec spatialRight)) ≤
      Lbound*finiteVecNorm2 (forcingLeft-forcingRight+(Aright-Aleft).mulVec spatialRight) := by
    simpa only [finiteMatVec,Matrix.mulVec,dotProduct] using hL (forcingLeft-forcingRight+(Aright-Aleft).mulVec spatialRight)
  calc
    _ ≤ Lbound*((bLip+ALip*Dx)*finiteVecNorm2 (left-right)) := hout.trans (mul_le_mul_of_nonneg_left hsource hLnonneg)
    _ = (Lbound*(bLip+ALip*Dx))*finiteVecNorm2 (left-right) := by ring
    _ ≤ (Lbound*(bLip+ALip*Dx))*(Rbound*finiteVecNorm2 (L.mulVec (left-right))) :=
      mul_le_mul_of_nonneg_left hstate (mul_nonneg hLnonneg (add_nonneg hbLip (mul_nonneg hALip hDx)))
    _ = _ := by ring

/-- A compact actual finite-vector field has a uniform canonical Euclidean
norm bound, by the existing bounded continuous-image API. -/
theorem compact_finite_vector_exists_uniform_norm2_bound
    {α ι : Type*} [TopologicalSpace α] [Fintype ι]
    (S : Set α) (hS : IsCompact S) (v : α → ι → ℝ)
    (hc : ∀ i, ContinuousOn (fun p => v p i) S) :
    ∃ M : ℝ, 0 ≤ M ∧ ∀ p ∈ S, finiteVecNorm2 (v p) ≤ M := by
  classical
  have hn : ContinuousOn (fun p => finiteVecNorm2 (v p)) S := by
    unfold finiteVecNorm2 finiteVecNorm2Sq
    exact Real.continuous_sqrt.comp_continuousOn (continuousOn_finset_sum _ (fun i _ => (hc i).pow 2))
  obtain ⟨M,hM⟩ := hS.bddAbove_image hn
  exact ⟨max M 0,le_max_right _ _,fun p hp => (hM ⟨p,hp,rfl⟩).trans (le_max_left _ _)⟩

/-- The actual spatial derivative of a local C1 original field is uniformly
bounded on a finite enclosed rectangle. No derivative bound is assumed. -/
theorem contDiffOn_one_exists_compact_actual_spatial_norm_bound
    {ι : Type*} [Fintype ι]
    (r : ℝ → ℝ → ι → ℝ) (X U : Set ℝ) (hX : IsOpen X) (hU : IsOpen U)
    (lo hi start finish : ℝ) (hbox : Icc lo hi ×ˢ Icc start finish ⊆ X ×ˢ U)
    (hr : ∀ i, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => r p.1 p.2 i) (X ×ˢ U)) :
    ∃ Dx : ℝ, 0 ≤ Dx ∧ ∀ p ∈ Icc lo hi ×ˢ Icc start finish,
      finiteVecNorm2 (deriv (fun ξ => r ξ p.2) p.1) ≤ Dx := by
  have hc : ContDiffOn ℝ 1 (Function.uncurry r) (X ×ˢ U) := contDiffOn_pi.mpr hr
  obtain ⟨_ht,hx,hd⟩ := contDiffOn_one_actual_coordinate_partials r X U hX hU hc
  obtain ⟨Dx,hDx,hbound⟩ := compact_finite_vector_exists_uniform_norm2_bound
    (Icc lo hi ×ˢ Icc start finish) (isCompact_Icc.prod isCompact_Icc)
    (fun p => LocalLinearAdvection.qx r p.1 p.2)
    (fun i => (continuous_apply i).comp_continuousOn (hx.mono hbox))
  refine ⟨Dx,hDx,?_⟩
  intro p hp
  rw [(hd p.1 (hbox hp).1 p.2 (hbox hp).2).2.2.deriv]
  exact hbound p hp

/-- The actual original quasilinear equation has local finite domain of dependence under explicit coefficient and forcing Lipschitz bounds; C1 compactness derives all basis and spatial derivative constants. -/
theorem firstOrderEquation_actual_c1_lipschitz_domain_of_dependence
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (equation : FirstOrderEquation ι) (q r : ℝ → ℝ → ι → ℝ)
    (L R : ℝ → ℝ → Matrix ι ι ℝ)
    (speed : ℝ → ℝ → ι → ℝ)

    (a b C T ALip bLip δ lo hi : ℝ) (X U : Set ℝ)
    (hX : IsOpen X) (hU : IsOpen U)
    (hbox : Icc lo hi ×ˢ Icc (-δ) (T+δ) ⊆ X ×ˢ U)
    (hqC : ∀ i, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => q p.1 p.2 i) (X ×ˢ U))
    (hrC : ∀ i, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => r p.1 p.2 i) (X ×ˢ U))
    (hL : ∀ i j, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => L p.1 p.2 i j) (X ×ˢ U))
    (hR : ∀ i j, ContinuousOn (fun p : ℝ × ℝ => R p.1 p.2 i j) (X ×ˢ U))
    (hs : ∀ i, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => speed p.1 p.2 i) (X ×ˢ U))
    (hC : 0 ≤ C) (hT : 0 ≤ T) (hwidth : 0 < b-a-2*C*T) (hδ : 0 < δ)
    (hposition : ∀ τ ∈ Icc (-δ) (T+δ), ∀ y ∈ Icc (0:ℝ) 1,
      a+C*τ+(b-a-2*C*τ)*y ∈ Icc lo hi)
    (hqclass : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), equation.IsClassicalSolutionAt q x τ)
    (hrclass : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), equation.IsClassicalSolutionAt r x τ)

    (hALip : 0 ≤ ALip) (hbLip : 0 ≤ bLip)
    (hA : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ),
      finiteOpNorm2Le (equation.principal x τ (r x τ)-equation.principal x τ (q x τ))
        (ALip*finiteVecNorm2 (q x τ-r x τ)))
    (hb : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ),
      finiteVecNorm2 (equation.forcing x τ (q x τ)-equation.forcing x τ (r x τ)) ≤ bLip*finiteVecNorm2 (q x τ-r x τ))
    (hdiag : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), L x τ * equation.principal x τ (q x τ) = Matrix.diagonal (speed x τ) * L x τ)
    (hinverse : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), R x τ * L x τ = 1)
    (hbound : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ p, |speed x τ p| ≤ C)
    (hinit : ∀ x ∈ Icc a b, q x 0 = r x 0) :
    ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), q x τ = r x τ := by
  obtain ⟨Lbound,hLbound,hLB⟩ := compact_finite_matrix_exists_uniform_operator_bound
    (Icc lo hi ×ˢ Icc (-δ) (T+δ)) (isCompact_Icc.prod isCompact_Icc)
    (fun p => L p.1 p.2) (fun i j => (hL i j).continuousOn.mono hbox)
  obtain ⟨Rbound,_hRbound,hRB⟩ := compact_finite_matrix_exists_uniform_operator_bound
    (Icc lo hi ×ˢ Icc (-δ) (T+δ)) (isCompact_Icc.prod isCompact_Icc)
    (fun p => R p.1 p.2) (fun i j => (hR i j).mono hbox)
  obtain ⟨Dx,hDx,hDB⟩ := contDiffOn_one_exists_compact_actual_spatial_norm_bound
    r X U hX hU lo hi (-δ) (T+δ) hbox hrC
  have htimebox (τ : ℝ) (hτ : τ ∈ Icc 0 T) : τ ∈ Icc (-δ) (T+δ) := by constructor <;> linarith [hτ.1,hτ.2]
  have hconebox (τ x : ℝ) (hτ : τ ∈ Icc 0 T) (hx : x ∈ Icc (a+C*τ) (b-C*τ)) : x ∈ Icc lo hi := by
    have hl := hposition τ (htimebox τ hτ) 0 ⟨le_rfl,by norm_num⟩
    have hr := hposition τ (htimebox τ hτ) 1 ⟨by norm_num,le_rfl⟩
    simp only [mul_zero,add_zero] at hl
    have hr' : b-C*τ ∈ Icc lo hi := by convert hr using 1; ring
    exact ⟨hl.1.trans hx.1,hx.2.trans hr'.2⟩
  apply firstOrderEquation_actual_c1_domain_of_dependence equation q r L R speed
    a b C T (Lbound*(bLip+ALip*Dx)*Rbound) δ lo hi X U hX hU hbox hqC hrC hL hR hs
    hC hT hwidth hδ hposition hqclass hrclass _ hdiag hinverse hbound hinit
  intro τ hτ x hx
  exact actualDifferenceCoordinateForcing_bound (q x τ) (r x τ)
    (equation.forcing x τ (q x τ)) (equation.forcing x τ (r x τ))
    (deriv (fun ξ => r ξ τ) x) (equation.principal x τ (q x τ)) (equation.principal x τ (r x τ))
    (L x τ) (R x τ) Lbound Rbound ALip bLip Dx hLbound hALip hbLip hDx
    (hLB (x,τ) ⟨hconebox τ x hτ hx,htimebox τ hτ⟩) (hRB (x,τ) ⟨hconebox τ x hτ hx,htimebox τ hτ⟩)
    (hinverse τ hτ x hx) (hA τ hτ x hx) (hb τ hτ x hx) (hDB (x,τ) ⟨hconebox τ x hτ hx,htimebox τ hτ⟩)

end NumStability
