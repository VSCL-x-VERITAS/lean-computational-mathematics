/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolic.ContractingEnergy
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolic.VaryingCoordinates

/-!
# Forced coordinate energy and finite cones

Actual coordinate regularity, compact coefficient bounds, and forced energy/cone
producers. Homogeneous finite propagation specializes these producers at G = 0.
-/

namespace NumStability

open Set Filter MeasureTheory Topology
open scoped BigOperators Topology NNReal

/-- C1 actual fields on an open spacetime domain supply the existing
canonical coordinate partials and their continuous local regularity. -/
theorem contDiffOn_one_actual_coordinate_partials
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (X U : Set ℝ) (hX : IsOpen X) (hU : IsOpen U)
    (hq : ContDiffOn ℝ 1 (Function.uncurry q) (X ×ˢ U)) :
    ContinuousOn (Function.uncurry (LocalLinearAdvection.qt q)) (X ×ˢ U) ∧
    ContinuousOn (Function.uncurry (LocalLinearAdvection.qx q)) (X ×ˢ U) ∧
    ∀ x ∈ X, ∀ t ∈ U,
      DifferentiableAt ℝ (Function.uncurry q) (x,t) ∧
      HasDerivAt (fun τ => q x τ) (LocalLinearAdvection.qt q x t) t ∧
      HasDerivAt (fun ξ => q ξ t) (LocalLinearAdvection.qx q x t) x := by
  have hc := hq.continuousOn_fderiv_of_isOpen (hX.prod hU) (by norm_num)
  refine ⟨hc.clm_apply continuousOn_const,hc.clm_apply continuousOn_const,?_⟩
  intro x hx t ht
  have hd : DifferentiableAt ℝ (Function.uncurry q) (x,t) :=
    (hq.differentiableOn (by norm_num) (x,t) ⟨hx,ht⟩).differentiableAt ((hX.prod hU).mem_nhds ⟨hx,ht⟩)
  exact ⟨hd,LocalLinearAdvection.partial_time hd,LocalLinearAdvection.partial_space hd⟩


/-- C1 actual original fields and the actual varying left basis give C1
coordinate energy and physical diagonal flux. This is finite algebraic
composition of the supplied original fields, not an assumed energy law. -/
theorem contDiffOn_one_actual_coordinate_energy_flux
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → ι → ℝ) (L : ℝ → ℝ → Matrix ι ι ℝ)
    (speed : ℝ → ℝ → ι → ℝ) (S : Set (ℝ × ℝ))
    (hq : ∀ i, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => q p.1 p.2 i) S)
    (hL : ∀ i j, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => L p.1 p.2 i j) S)
    (hs : ∀ i, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => speed p.1 p.2 i) S) :
    ContDiffOn ℝ 1 (fun p : ℝ × ℝ => ∑ i : ι, ((L p.1 p.2).mulVec (q p.1 p.2) i)^2) S ∧
    ContDiffOn ℝ 1 (fun p : ℝ × ℝ => ∑ i : ι, speed p.1 p.2 i * ((L p.1 p.2).mulVec (q p.1 p.2) i)^2) S := by
  classical
  have hw (i : ι) : ContDiffOn ℝ 1 (fun p : ℝ × ℝ => (L p.1 p.2).mulVec (q p.1 p.2) i) S := by
    change ContDiffOn ℝ 1 (fun p : ℝ × ℝ => ∑ j : ι, L p.1 p.2 i j * q p.1 p.2 j) S
    exact ContDiffOn.sum (fun j _ => (hL i j).mul (hq j))
  exact ⟨ContDiffOn.sum (fun i _ => (hw i).pow 2),
    ContDiffOn.sum (fun i _ => (hs i).mul ((hw i).pow 2))⟩


/-- A continuous finite matrix on a compact actual domain has one uniform
canonical finite operator-2 bound. No new norm is defined. -/
theorem compact_finite_matrix_exists_uniform_operator_bound
    {α ι : Type*} [TopologicalSpace α] [Fintype ι]
    (S : Set α) (hS : IsCompact S) (B : α → Matrix ι ι ℝ)
    (hc : ∀ i j, ContinuousOn (fun p => B p i j) S) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ p ∈ S, finiteOpNorm2Le (B p) K := by
  classical
  have hf : ContinuousOn (fun p => finiteFrobNormSq (B p)) S := by
    unfold finiteFrobNormSq
    apply continuousOn_finset_sum
    intro i _
    apply continuousOn_finset_sum
    intro j _
    exact (hc i j).pow 2
  obtain ⟨M,hM⟩ := hS.bddAbove_image hf
  refine ⟨max M 0+1,by positivity,?_⟩
  intro p hp
  apply finiteOpNorm2Le_of_finiteFrobNormSq_le_sq _ (by positivity)
  have h := hM ⟨p,hp,rfl⟩
  have hm : M ≤ max M 0 := le_max_left _ _
  have hn : 0 ≤ max M 0 := le_max_right _ _
  nlinarith [sq_nonneg (max M 0)]


/-- One compact-domain bound controls every component of a continuous
finite scalar family, including empty domains and empty index types. -/
theorem compact_finite_family_exists_uniform_abs_bound
    {α ι : Type*} [TopologicalSpace α] [Fintype ι]
    (S : Set α) (hS : IsCompact S) (f : α → ι → ℝ)
    (hc : ∀ i, ContinuousOn (fun p => f p i) S) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ p ∈ S, ∀ i, |f p i| ≤ C := by
  classical
  have hf : ContinuousOn (fun p => ∑ i : ι, |f p i|) S := by
    apply continuousOn_finset_sum
    intro i _; exact (hc i).abs
  obtain ⟨M,hM⟩ := hS.bddAbove_image hf
  refine ⟨max M 0,le_max_right _ _,?_⟩
  intro p hp i
  exact (Finset.single_le_sum (fun j _ => abs_nonneg (f p j)) (Finset.mem_univ i)).trans
    ((hM ⟨p,hp,rfl⟩).trans (le_max_left _ _))


/-- The actual C1 left basis, continuous inverse, and actual speed field
give finite local uniform bounds for the real original coordinate coupling,
speed derivative and propagation speeds. -/
theorem actual_c1_coordinates_exist_compact_coefficient_bounds
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (L R Lt Lx : ℝ → ℝ → Matrix ι ι ℝ)
    (speed speedDerivative : ℝ → ℝ → ι → ℝ)
    (X U : Set ℝ) (hX : IsOpen X) (hU : IsOpen U)
    (lo hi start finish : ℝ) (hbox : Icc lo hi ×ˢ Icc start finish ⊆ X ×ˢ U)
    (hL : ∀ i j, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => L p.1 p.2 i j) (X ×ˢ U))
    (hR : ∀ i j, ContinuousOn (fun p : ℝ × ℝ => R p.1 p.2 i j) (X ×ˢ U))
    (hs : ∀ i, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => speed p.1 p.2 i) (X ×ˢ U))
    (hactualLt : ∀ x t i j, Lt x t i j = LocalLinearAdvection.qt (fun ξ τ => L ξ τ i j) x t)
    (hactualLx : ∀ x t i j, Lx x t i j = LocalLinearAdvection.qx (fun ξ τ => L ξ τ i j) x t)
    (hactualSpeedDerivative : ∀ x t i, speedDerivative x t i = LocalLinearAdvection.qx (fun ξ τ => speed ξ τ i) x t) :
    ∃ K H C : ℝ, 0 ≤ K ∧ 0 ≤ H ∧ 0 ≤ C ∧
      ∀ p ∈ Icc lo hi ×ˢ Icc start finish,
        finiteOpNorm2Le ((Lt p.1 p.2+Matrix.diagonal (speed p.1 p.2)*Lx p.1 p.2)*R p.1 p.2) K ∧
        (∀ i, speedDerivative p.1 p.2 i ≤ H) ∧ (∀ i, |speed p.1 p.2 i| ≤ C) := by
  classical
  have hLtC (i j : ι) : ContinuousOn (fun p : ℝ × ℝ => Lt p.1 p.2 i j) (X ×ˢ U) := by
    have h := (contDiffOn_one_actual_coordinate_partials (fun x t => L x t i j) X U hX hU (hL i j)).1
    have heq : (fun p : ℝ × ℝ => Lt p.1 p.2 i j) = Function.uncurry (LocalLinearAdvection.qt (fun x t => L x t i j)) := funext (fun p => hactualLt p.1 p.2 i j)
    rw [heq]; exact h
  have hLxC (i j : ι) : ContinuousOn (fun p : ℝ × ℝ => Lx p.1 p.2 i j) (X ×ˢ U) := by
    have h := (contDiffOn_one_actual_coordinate_partials (fun x t => L x t i j) X U hX hU (hL i j)).2.1
    have heq : (fun p : ℝ × ℝ => Lx p.1 p.2 i j) = Function.uncurry (LocalLinearAdvection.qx (fun x t => L x t i j)) := funext (fun p => hactualLx p.1 p.2 i j)
    rw [heq]; exact h
  have hB (i j : ι) : ContinuousOn (fun p : ℝ × ℝ => ((Lt p.1 p.2+Matrix.diagonal (speed p.1 p.2)*Lx p.1 p.2)*R p.1 p.2) i j) (X ×ˢ U) := by
    have heq : (fun p : ℝ × ℝ => ((Lt p.1 p.2+Matrix.diagonal (speed p.1 p.2)*Lx p.1 p.2)*R p.1 p.2) i j) =
        (fun p : ℝ × ℝ => ∑ k : ι, (Lt p.1 p.2 i k + speed p.1 p.2 i * Lx p.1 p.2 i k) * R p.1 p.2 k j) := by
      funext p
      rw [Matrix.mul_apply]
      simp only [Matrix.add_apply,Matrix.diagonal_mul]
    rw [heq]
    exact continuousOn_finset_sum _ (fun k _ => ((hLtC i k).add ((hs i).continuousOn.mul (hLxC i k))).mul (hR k j))
  have hd (i : ι) : ContinuousOn (fun p : ℝ × ℝ => speedDerivative p.1 p.2 i) (X ×ˢ U) := by
    have h := (contDiffOn_one_actual_coordinate_partials (fun x t => speed x t i) X U hX hU (hs i)).2.1
    have heq : (fun p : ℝ × ℝ => speedDerivative p.1 p.2 i) = Function.uncurry (LocalLinearAdvection.qx (fun x t => speed x t i)) := funext (fun p => hactualSpeedDerivative p.1 p.2 i)
    rw [heq]; exact h
  obtain ⟨K,hK,hKB⟩ := compact_finite_matrix_exists_uniform_operator_bound
    (Icc lo hi ×ˢ Icc start finish) (isCompact_Icc.prod isCompact_Icc)
    (fun p => (Lt p.1 p.2+Matrix.diagonal (speed p.1 p.2)*Lx p.1 p.2)*R p.1 p.2)
    (fun i j => (hB i j).mono hbox)
  obtain ⟨H,hH,hHD⟩ := compact_finite_family_exists_uniform_abs_bound
    (Icc lo hi ×ˢ Icc start finish) (isCompact_Icc.prod isCompact_Icc)
    (fun p => speedDerivative p.1 p.2) (fun i => (hd i).mono hbox)
  obtain ⟨C,hC,hCS⟩ := compact_finite_family_exists_uniform_abs_bound
    (Icc lo hi ×ˢ Icc start finish) (isCompact_Icc.prod isCompact_Icc)
    (fun p => speed p.1 p.2) (fun i => (hs i).continuousOn.mono hbox)
  exact ⟨K,H,C,hK,hH,hC,fun p hp => ⟨hKB p hp,fun i => (le_abs_self _).trans (hHD p hp i),hCS p hp⟩⟩


/-- The actual original varying-coordinate residual retains the forcing
term as well as basis-derivative coupling. -/
theorem firstOrderEquation_actual_forced_coupled_coordinates
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (equation : FirstOrderEquation ι) (q : ℝ → ℝ → ι → ℝ)
    (L : ℝ → ℝ → Matrix ι ι ℝ) (R Lt Lx : Matrix ι ι ℝ)
    (speed : ι → ℝ) (x t : ℝ)
    (hclass : equation.IsClassicalSolutionAt q x t)
    (hLt : ∀ i j, HasDerivAt (fun τ => L x τ i j) (Lt i j) t)
    (hLx : ∀ i j, HasDerivAt (fun ξ => L ξ t i j) (Lx i j) x)
    (hdiag : L x t * equation.principal x t (q x t) = Matrix.diagonal speed * L x t)
    (hinverse : R * L x t = 1) :
    ∃ wt wx : ι → ℝ,
      HasDerivAt (fun τ => (L x τ).mulVec (q x τ)) wt t ∧
      HasDerivAt (fun ξ => (L ξ t).mulVec (q ξ t)) wx x ∧
      wt + (Matrix.diagonal speed).mulVec wx =
        ((Lt+Matrix.diagonal speed*Lx)*R).mulVec ((L x t).mulVec (q x t)) +
          (L x t).mulVec (equation.forcing x t (q x t)) := by
  obtain ⟨wt,wx,hwt,hwx,hres⟩ := firstOrderEquation_varying_coordinates_residual
    equation q L Lt Lx (Matrix.diagonal speed) x t hclass hLt hLx hdiag
  refine ⟨wt,wx,hwt,hwx,?_⟩
  rw [hres,Matrix.mulVec_mulVec,Matrix.mul_assoc,hinverse,Matrix.mul_one]


/-- Actual coordinate forcing bounded by coordinate size contributes a
derived 2G energy-growth term. Canonical Euclidean pairing is reused. -/
theorem varyingCoordinate_forced_energy_growth_bound
    {ι : Type*} [Fintype ι] (w d force : ι → ℝ) (B : Matrix ι ι ℝ) (K H G : ℝ)
    (hB : finiteOpNorm2Le B K) (hd : ∀ i, d i ≤ H)
    (hf : finiteVecNorm2 force ≤ G*finiteVecNorm2 w) :
    (∑ i : ι, (2*w i*((B.mulVec w) i+force i)+d i*(w i)^2)) ≤
      (2*K+H+2*G)*(∑ i : ι, (w i)^2) := by
  classical
  have hinner : (∑ i : ι, w i * force i) ≤ G*(∑ i : ι, (w i)^2) := by
    have h := (le_abs_self (∑ i : ι, w i * force i)).trans
      (abs_finiteVecInnerProduct_le_finiteVecNorm2_mul w force)
    have hb := mul_le_mul_of_nonneg_left hf (finiteVecNorm2_nonneg w)
    have heq : finiteVecNorm2 w * (G*finiteVecNorm2 w) = G*(∑ i : ι, (w i)^2) := by
      rw [mul_left_comm,←pow_two,finiteVecNorm2_sq,finiteVecNorm2Sq]
    exact h.trans (heq ▸ hb)
  have hsplit : (∑ i : ι, (2*w i*((B.mulVec w) i+force i)+d i*(w i)^2)) =
      (∑ i : ι, (2*w i*(B.mulVec w) i+d i*(w i)^2)) + 2*(∑ i : ι, w i*force i) := by
    rw [Finset.mul_sum,←Finset.sum_add_distrib];apply Finset.sum_congr rfl;intro i _;ring
  rw [hsplit,add_mul]
  exact add_le_add (varyingCoordinate_energy_growth_bound w d B K H hB hd)
    (by simpa only [mul_assoc] using mul_le_mul_of_nonneg_left hinner (by norm_num : (0:ℝ) ≤ 2))


/-- Derive the actual energy inequality from the original forced PDE,
without assuming an energy residual or a propagation conclusion. -/
theorem firstOrderEquation_actual_forced_coordinate_energy
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (equation : FirstOrderEquation ι) (q : ℝ → ℝ → ι → ℝ)
    (L : ℝ → ℝ → Matrix ι ι ℝ) (R Lt Lx : Matrix ι ι ℝ)
    (speed : ℝ → ℝ → ι → ℝ) (speedDerivative : ι → ℝ)
    (x t C K H G : ℝ)
    (hclass : equation.IsClassicalSolutionAt q x t)
    (hLt : ∀ i j, HasDerivAt (fun τ => L x τ i j) (Lt i j) t)
    (hLx : ∀ i j, HasDerivAt (fun ξ => L ξ t i j) (Lx i j) x)
    (hdiag : L x t * equation.principal x t (q x t) = Matrix.diagonal (speed x t) * L x t)
    (hinverse : R * L x t = 1)
    (hspeed : ∀ p, HasDerivAt (fun ξ => speed ξ t p) (speedDerivative p) x)
    (hB : finiteOpNorm2Le ((Lt+Matrix.diagonal (speed x t)*Lx)*R) K)
    (hH : ∀ p, speedDerivative p ≤ H)
    (hC : ∀ p, |speed x t p| ≤ C)
    (hforcing : finiteVecNorm2 ((L x t).mulVec (equation.forcing x t (q x t))) ≤
      G*finiteVecNorm2 ((L x t).mulVec (q x t))) :
    ∃ energyTime fluxSpace : ℝ,
      HasDerivAt (fun τ => ∑ p : ι, ((L x τ).mulVec (q x τ) p)^2) energyTime t ∧
      HasDerivAt (fun ξ => ∑ p : ι, speed ξ t p * ((L ξ t).mulVec (q ξ t) p)^2) fluxSpace x ∧
      energyTime+fluxSpace ≤ (2*K+H+2*G)*(∑ p : ι, ((L x t).mulVec (q x t) p)^2) ∧
      |∑ p : ι, speed x t p * ((L x t).mulVec (q x t) p)^2| ≤ C*(∑ p : ι, ((L x t).mulVec (q x t) p)^2) := by
  obtain ⟨wt,wx,hwt,hwx,hres⟩ := firstOrderEquation_actual_forced_coupled_coordinates
    equation q L R Lt Lx (speed x t) x t hclass hLt hLx hdiag hinverse
  have hpoint (p : ι) : wt p+speed x t p*wx p =
      (((Lt+Matrix.diagonal (speed x t)*Lx)*R).mulVec ((L x t).mulVec (q x t))) p +
        ((L x t).mulVec (equation.forcing x t (q x t))) p := by
    simpa only [Pi.add_apply,Matrix.mulVec_diagonal] using congrFun hres p
  obtain ⟨Et,Fx,hEt,hFx,henergy⟩ := varyingCoordinate_local_energy_identity
    (fun ξ τ => (L ξ τ).mulVec (q ξ τ)) (fun ξ => speed ξ t) wt wx speedDerivative
    (((Lt+Matrix.diagonal (speed x t)*Lx)*R).mulVec ((L x t).mulVec (q x t)) +
      (L x t).mulVec (equation.forcing x t (q x t))) x t
    (hasDerivAt_pi.mp hwt) (hasDerivAt_pi.mp hwx) hspeed hpoint
  refine ⟨Et,Fx,hEt,hFx,?_,diagonalEnergyFlux_boundary_bound _ _ C hC⟩
  rw [henergy]
  exact varyingCoordinate_forced_energy_growth_bound _ speedDerivative _ _ K H G hB hH hforcing


theorem firstOrderEquation_actual_forced_local_cone_zero
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (equation : FirstOrderEquation ι) (q : ℝ → ℝ → ι → ℝ)
    (L R Lt Lx : ℝ → ℝ → Matrix ι ι ℝ)
    (speed speedDerivative : ℝ → ℝ → ι → ℝ)
    (E Et Ex F Fx : ℝ → ℝ → ℝ) (a b C T K H G δ lo hi : ℝ)
    (hC : 0 ≤ C) (hT : 0 ≤ T) (hwidth : 0 < b-a-2*C*T) (hδ : 0 < δ)
    (hposition : ∀ τ ∈ Icc (-δ) (T+δ), ∀ y ∈ Icc (0:ℝ) 1,
      a+C*τ+(b-a-2*C*τ)*y ∈ Icc lo hi)
    (henergy : ∀ x τ, E x τ = ∑ p : ι, ((L x τ).mulVec (q x τ) p)^2)
    (hphysicalflux : ∀ x τ, F x τ = ∑ p : ι, speed x τ p * ((L x τ).mulVec (q x τ) p)^2)
    (hE : ContinuousOn (Function.uncurry (fun τ x => E x τ)) (Icc (-δ) (T+δ) ×ˢ Icc lo hi))
    (hEt : ContinuousOn (Function.uncurry (fun τ x => Et x τ)) (Icc (-δ) (T+δ) ×ˢ Icc lo hi))
    (hEx : ContinuousOn (Function.uncurry (fun τ x => Ex x τ)) (Icc (-δ) (T+δ) ×ˢ Icc lo hi))
    (hFx : ContinuousOn (Function.uncurry (fun τ x => Fx x τ)) (Icc (-δ) (T+δ) ×ˢ Icc lo hi))
    (hjoint : ∀ x τ, x ∈ Icc lo hi → τ ∈ Icc (-δ) (T+δ) → DifferentiableAt ℝ (Function.uncurry E) (x,τ))
    (htime : ∀ x τ, x ∈ Icc lo hi → τ ∈ Icc (-δ) (T+δ) → HasDerivAt (fun s => E x s) (Et x τ) τ)
    (hspace : ∀ x τ, x ∈ Icc lo hi → τ ∈ Icc (-δ) (T+δ) → HasDerivAt (fun ξ => E ξ τ) (Ex x τ) x)
    (hflux : ∀ x τ, x ∈ Icc lo hi → τ ∈ Icc (-δ) (T+δ) → HasDerivAt (fun ξ => F ξ τ) (Fx x τ) x)
    (hclass : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), equation.IsClassicalSolutionAt q x τ)
    (hforcing : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), finiteVecNorm2 ((L x τ).mulVec (equation.forcing x τ (q x τ))) ≤ G*finiteVecNorm2 ((L x τ).mulVec (q x τ)))
    (hLt : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ i j, HasDerivAt (fun s => L x s i j) (Lt x τ i j) τ)
    (hLx : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ i j, HasDerivAt (fun ξ => L ξ τ i j) (Lx x τ i j) x)
    (hdiag : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), L x τ * equation.principal x τ (q x τ) = Matrix.diagonal (speed x τ) * L x τ)
    (hinverse : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), R x τ * L x τ = 1)
    (hspeed : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ p, HasDerivAt (fun ξ => speed ξ τ p) (speedDerivative x τ p) x)
    (hB : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), finiteOpNorm2Le ((Lt x τ+Matrix.diagonal (speed x τ)*Lx x τ)*R x τ) K)
    (hH : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ p, speedDerivative x τ p ≤ H)
    (hbound : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ p, |speed x τ p| ≤ C)
    (hinit : ∀ x ∈ Icc a b, q x 0 = 0) :
    ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), q x τ = 0 := by
  have htimebox (τ : ℝ) (hτ : τ ∈ Icc 0 T) : τ ∈ Icc (-δ) (T+δ) := by constructor <;> linarith [hτ.1,hτ.2]
  have hconebox (τ x : ℝ) (hτ : τ ∈ Icc 0 T) (hx : x ∈ Icc (a+C*τ) (b-C*τ)) : x ∈ Icc lo hi := by
    have hl := hposition τ (htimebox τ hτ) 0 ⟨le_rfl,by norm_num⟩
    have hr := hposition τ (htimebox τ hτ) 1 ⟨by norm_num,le_rfl⟩
    simp only [mul_zero,add_zero] at hl
    have hr' : b-C*τ ∈ Icc lo hi := by convert hr using 1; ring
    exact ⟨hl.1.trans hx.1,hx.2.trans hr'.2⟩
  have hpoint (τ : ℝ) (hτ : τ ∈ Icc 0 T) (x : ℝ) (hx : x ∈ Icc (a+C*τ) (b-C*τ)) :
      Et x τ+Fx x τ ≤ (2*K+H+2*G)*E x τ ∧ |F x τ| ≤ C*E x τ := by
    obtain ⟨et,fx,het,hfx,hgrowth,hf⟩ := firstOrderEquation_actual_forced_coordinate_energy
      equation q L (R x τ) (Lt x τ) (Lx x τ) speed (speedDerivative x τ) x τ C K H G
      (hclass τ hτ x hx) (hLt τ hτ x hx) (hLx τ hτ x hx)
      (hdiag τ hτ x hx) (hinverse τ hτ x hx) (hspeed τ hτ x hx) (hB τ hτ x hx) (hH τ hτ x hx) (hbound τ hτ x hx) (hforcing τ hτ x hx)
    have het' : HasDerivAt (fun s => E x s) et τ := by
      have heq : (fun s => E x s) = (fun s => ∑ p : ι, ((L x s).mulVec (q x s) p)^2) := funext (henergy x)
      rw [heq]; exact het
    have hfx' : HasDerivAt (fun ξ => F ξ τ) fx x := by
      have heq : (fun ξ => F ξ τ) = (fun ξ => ∑ p : ι, speed ξ τ p * ((L ξ τ).mulVec (q ξ τ) p)^2) := funext (fun ξ => hphysicalflux ξ τ)
      rw [heq]; exact hfx
    have hetval := het'.unique (htime x τ (hconebox τ x hτ hx) (htimebox τ hτ))
    have hfxval := hfx'.unique (hflux x τ (hconebox τ x hτ hx) (htimebox τ hτ))
    rw [hetval,hfxval,←henergy x τ] at hgrowth
    rw [←henergy x τ,←hphysicalflux x τ] at hf
    exact ⟨hgrowth,hf⟩
  have hzero := actualEnergy_local_contracting_cone_zero E Et Ex F Fx a b C T (2*K+H+2*G) δ lo hi
    hC hT hwidth hδ hposition hE hEt hEx hFx hjoint htime hspace hflux
    (fun τ _ x _ => by rw [henergy]; exact Finset.sum_nonneg (fun p _ => sq_nonneg _))
    (fun τ hτ x hx => (hpoint τ hτ x hx).1) (fun τ hτ x hx => (hpoint τ hτ x hx).2)
    (fun x hx => by rw [henergy,hinit x hx,Matrix.mulVec_zero]; simp)
  intro τ hτ x hx
  have he := hzero τ hτ x hx; rw [henergy x τ] at he
  have hw := actualCoordinate_zero_of_zero_energy ((L x τ).mulVec (q x τ)) he
  have hq := congrArg (fun w => (R x τ).mulVec w) hw
  dsimp only at hq
  rw [Matrix.mulVec_mulVec,hinverse τ hτ x hx,Matrix.one_mulVec,Matrix.mulVec_zero] at hq
  exact hq


theorem firstOrderEquation_actual_forced_c1_cone_zero
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (equation : FirstOrderEquation ι) (q : ℝ → ℝ → ι → ℝ)
    (L R Lt Lx : ℝ → ℝ → Matrix ι ι ℝ)
    (speed speedDerivative : ℝ → ℝ → ι → ℝ)

    (a b C T K H G δ lo hi : ℝ) (X U : Set ℝ)
    (hX : IsOpen X) (hU : IsOpen U)
    (hbox : Icc lo hi ×ˢ Icc (-δ) (T+δ) ⊆ X ×ˢ U)
    (hq : ∀ i, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => q p.1 p.2 i) (X ×ˢ U))
    (hL : ∀ i j, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => L p.1 p.2 i j) (X ×ˢ U))
    (hs : ∀ i, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => speed p.1 p.2 i) (X ×ˢ U))
    (hC : 0 ≤ C) (hT : 0 ≤ T) (hwidth : 0 < b-a-2*C*T) (hδ : 0 < δ)
    (hposition : ∀ τ ∈ Icc (-δ) (T+δ), ∀ y ∈ Icc (0:ℝ) 1,
      a+C*τ+(b-a-2*C*τ)*y ∈ Icc lo hi)
    (hclass : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), equation.IsClassicalSolutionAt q x τ)
    (hforcing : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), finiteVecNorm2 ((L x τ).mulVec (equation.forcing x τ (q x τ))) ≤ G*finiteVecNorm2 ((L x τ).mulVec (q x τ)))
    (hLt : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ i j, HasDerivAt (fun s => L x s i j) (Lt x τ i j) τ)
    (hLx : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ i j, HasDerivAt (fun ξ => L ξ τ i j) (Lx x τ i j) x)
    (hdiag : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), L x τ * equation.principal x τ (q x τ) = Matrix.diagonal (speed x τ) * L x τ)
    (hinverse : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), R x τ * L x τ = 1)
    (hspeed : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ p, HasDerivAt (fun ξ => speed ξ τ p) (speedDerivative x τ p) x)
    (hB : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), finiteOpNorm2Le ((Lt x τ+Matrix.diagonal (speed x τ)*Lx x τ)*R x τ) K)
    (hH : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ p, speedDerivative x τ p ≤ H)
    (hbound : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ p, |speed x τ p| ≤ C)
    (hinit : ∀ x ∈ Icc a b, q x 0 = 0) :
    ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), q x τ = 0 := by
  let E : ℝ → ℝ → ℝ := fun x τ => ∑ p : ι, ((L x τ).mulVec (q x τ) p)^2
  let F : ℝ → ℝ → ℝ := fun x τ => ∑ p : ι, speed x τ p * ((L x τ).mulVec (q x τ) p)^2
  obtain ⟨hEc,hFc⟩ := contDiffOn_one_actual_coordinate_energy_flux q L speed (X ×ˢ U) hq hL hs
  have hEc' : ContDiffOn ℝ 1 (Function.uncurry E) (X ×ˢ U) := hEc
  have hFc' : ContDiffOn ℝ 1 (Function.uncurry F) (X ×ˢ U) := hFc
  obtain ⟨hEt,hEx,hEd⟩ := contDiffOn_one_actual_coordinate_partials E X U hX hU hEc'
  obtain ⟨_hFt,hFx,hFd⟩ := contDiffOn_one_actual_coordinate_partials F X U hX hU hFc'
  have hswap (G : ℝ → ℝ → ℝ) (hc : ContinuousOn (Function.uncurry G) (X ×ˢ U)) :
      ContinuousOn (Function.uncurry (fun τ x => G x τ)) (Icc (-δ) (T+δ) ×ˢ Icc lo hi) :=
    hc.comp continuous_swap.continuousOn (fun p hp => hbox ⟨hp.2,hp.1⟩)
  apply firstOrderEquation_actual_forced_local_cone_zero equation q L R Lt Lx speed speedDerivative
    E (LocalLinearAdvection.qt E) (LocalLinearAdvection.qx E) F (LocalLinearAdvection.qx F)
    a b C T K H G δ lo hi hC hT hwidth hδ hposition
    (fun _ _ => rfl) (fun _ _ => rfl)
    (hswap E hEc'.continuousOn) (hswap _ hEt) (hswap _ hEx) (hswap _ hFx)
    (fun x τ hx ht => (hEd x (hbox (show (x,τ) ∈ Icc lo hi ×ˢ Icc (-δ) (T+δ) from ⟨hx,ht⟩)).1 τ (hbox (show (x,τ) ∈ Icc lo hi ×ˢ Icc (-δ) (T+δ) from ⟨hx,ht⟩)).2).1)
    (fun x τ hx ht => (hEd x (hbox (show (x,τ) ∈ Icc lo hi ×ˢ Icc (-δ) (T+δ) from ⟨hx,ht⟩)).1 τ (hbox (show (x,τ) ∈ Icc lo hi ×ˢ Icc (-δ) (T+δ) from ⟨hx,ht⟩)).2).2.1)
    (fun x τ hx ht => (hEd x (hbox (show (x,τ) ∈ Icc lo hi ×ˢ Icc (-δ) (T+δ) from ⟨hx,ht⟩)).1 τ (hbox (show (x,τ) ∈ Icc lo hi ×ˢ Icc (-δ) (T+δ) from ⟨hx,ht⟩)).2).2.2)
    (fun x τ hx ht => (hFd x (hbox (show (x,τ) ∈ Icc lo hi ×ˢ Icc (-δ) (T+δ) from ⟨hx,ht⟩)).1 τ (hbox (show (x,τ) ∈ Icc lo hi ×ˢ Icc (-δ) (T+δ) from ⟨hx,ht⟩)).2).2.2)
    hclass hforcing hLt hLx hdiag hinverse hspeed hB hH hbound hinit


theorem firstOrderEquation_actual_forced_c1_finite_propagation
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (equation : FirstOrderEquation ι) (q : ℝ → ℝ → ι → ℝ)
    (L R : ℝ → ℝ → Matrix ι ι ℝ)
    (speed : ℝ → ℝ → ι → ℝ)

    (a b C T G δ lo hi : ℝ) (X U : Set ℝ)
    (hX : IsOpen X) (hU : IsOpen U)
    (hbox : Icc lo hi ×ˢ Icc (-δ) (T+δ) ⊆ X ×ˢ U)
    (hq : ∀ i, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => q p.1 p.2 i) (X ×ˢ U))
    (hL : ∀ i j, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => L p.1 p.2 i j) (X ×ˢ U))
    (hR : ∀ i j, ContinuousOn (fun p : ℝ × ℝ => R p.1 p.2 i j) (X ×ˢ U))
    (hs : ∀ i, ContDiffOn ℝ 1 (fun p : ℝ × ℝ => speed p.1 p.2 i) (X ×ˢ U))
    (hC : 0 ≤ C) (hT : 0 ≤ T) (hwidth : 0 < b-a-2*C*T) (hδ : 0 < δ)
    (hposition : ∀ τ ∈ Icc (-δ) (T+δ), ∀ y ∈ Icc (0:ℝ) 1,
      a+C*τ+(b-a-2*C*τ)*y ∈ Icc lo hi)
    (hclass : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), equation.IsClassicalSolutionAt q x τ)
    (hforcing : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), finiteVecNorm2 ((L x τ).mulVec (equation.forcing x τ (q x τ))) ≤ G*finiteVecNorm2 ((L x τ).mulVec (q x τ)))
    (hdiag : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), L x τ * equation.principal x τ (q x τ) = Matrix.diagonal (speed x τ) * L x τ)
    (hinverse : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), R x τ * L x τ = 1)
    (hbound : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), ∀ p, |speed x τ p| ≤ C)
    (hinit : ∀ x ∈ Icc a b, q x 0 = 0) :
    ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), q x τ = 0 := by
  let Lt : ℝ → ℝ → Matrix ι ι ℝ := fun x t i j => LocalLinearAdvection.qt (fun ξ τ => L ξ τ i j) x t
  let Lx : ℝ → ℝ → Matrix ι ι ℝ := fun x t i j => LocalLinearAdvection.qx (fun ξ τ => L ξ τ i j) x t
  let speedDerivative : ℝ → ℝ → ι → ℝ := fun x t i => LocalLinearAdvection.qx (fun ξ τ => speed ξ τ i) x t
  obtain ⟨K,H,_C0,_hK,_hH,_hC0,hcoeff⟩ := actual_c1_coordinates_exist_compact_coefficient_bounds
    L R Lt Lx speed speedDerivative X U hX hU lo hi (-δ) (T+δ) hbox hL hR hs
    (fun _ _ _ _ => rfl) (fun _ _ _ _ => rfl) (fun _ _ _ => rfl)
  have htimebox (τ : ℝ) (hτ : τ ∈ Icc 0 T) : τ ∈ Icc (-δ) (T+δ) := by constructor <;> linarith [hτ.1,hτ.2]
  have hconebox (τ x : ℝ) (hτ : τ ∈ Icc 0 T) (hx : x ∈ Icc (a+C*τ) (b-C*τ)) : x ∈ Icc lo hi := by
    have hl := hposition τ (htimebox τ hτ) 0 ⟨le_rfl,by norm_num⟩
    have hr := hposition τ (htimebox τ hτ) 1 ⟨by norm_num,le_rfl⟩
    simp only [mul_zero,add_zero] at hl
    have hr' : b-C*τ ∈ Icc lo hi := by convert hr using 1; ring
    exact ⟨hl.1.trans hx.1,hx.2.trans hr'.2⟩
  have hmem (τ x : ℝ) (hτ : τ ∈ Icc 0 T) (hx : x ∈ Icc (a+C*τ) (b-C*τ)) : (x,τ) ∈ X ×ˢ U := hbox ⟨hconebox τ x hτ hx,htimebox τ hτ⟩
  have hLt (τ : ℝ) (hτ : τ ∈ Icc 0 T) (x : ℝ) (hx : x ∈ Icc (a+C*τ) (b-C*τ)) (i j : ι) :
      HasDerivAt (fun t => L x t i j) (Lt x τ i j) τ :=
    ((contDiffOn_one_actual_coordinate_partials (fun ξ t => L ξ t i j) X U hX hU (hL i j)).2.2 x (hmem τ x hτ hx).1 τ (hmem τ x hτ hx).2).2.1
  have hLx (τ : ℝ) (hτ : τ ∈ Icc 0 T) (x : ℝ) (hx : x ∈ Icc (a+C*τ) (b-C*τ)) (i j : ι) :
      HasDerivAt (fun ξ => L ξ τ i j) (Lx x τ i j) x :=
    ((contDiffOn_one_actual_coordinate_partials (fun ξ t => L ξ t i j) X U hX hU (hL i j)).2.2 x (hmem τ x hτ hx).1 τ (hmem τ x hτ hx).2).2.2
  have hspeed (τ : ℝ) (hτ : τ ∈ Icc 0 T) (x : ℝ) (hx : x ∈ Icc (a+C*τ) (b-C*τ)) (i : ι) :
      HasDerivAt (fun ξ => speed ξ τ i) (speedDerivative x τ i) x :=
    ((contDiffOn_one_actual_coordinate_partials (fun ξ t => speed ξ t i) X U hX hU (hs i)).2.2 x (hmem τ x hτ hx).1 τ (hmem τ x hτ hx).2).2.2
  exact firstOrderEquation_actual_forced_c1_cone_zero equation q L R Lt Lx speed speedDerivative
    a b C T K H G δ lo hi X U hX hU hbox hq hL hs hC hT hwidth hδ hposition
    hclass hforcing hLt hLx hdiag hinverse hspeed
    (fun τ hτ x hx => (hcoeff (x,τ) ⟨hconebox τ x hτ hx,htimebox τ hτ⟩).1)
    (fun τ hτ x hx => (hcoeff (x,τ) ⟨hconebox τ x hτ hx,htimebox τ hτ⟩).2.1)
    hbound hinit


end NumStability
