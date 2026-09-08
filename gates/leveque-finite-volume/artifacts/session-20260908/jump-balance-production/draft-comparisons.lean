import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BalanceLaw
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.LinearProduction
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RectangleBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RectangleBalanceTemporalDerivative
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannDataJump
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannDataRegularity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Examples.LocalMaterialInterface
import ComputationalMathematics.MeasureTheory.Integral.IntervalIntegral.LebesgueDifferentiation
import ComputationalMathematics.Topology.Order.Jump
import Mathlib.Topology.Constructions.SumProd

/-
SPDX-License-Identifier: MIT
-/


/-!
# Draft: distinct material and state traces at an interface

Generic foundations only. The final specialization retains globally constant
initial Riemann states, but imposes only one-sided limits on the medium.
This file does not settle whether the selected source prescribes globally
constant material parameters, and does not assert wave dynamics.
-/

open Filter Set
open scoped Topology

namespace NumStability.MaterialInterfaceDraft

/-- A jump has existing, distinct left and right traces. The point value is free. -/
def HasJumpAt {E : Type*} [TopologicalSpace E]
    (data : ℝ → E) (a : ℝ) (left right : E) : Prop :=
  Tendsto data (𝓝[<] a) (𝓝 left) ∧
    Tendsto data (𝓝[>] a) (𝓝 right) ∧ left ≠ right

theorem HasJumpAt.not_continuousAt {E : Type*} [TopologicalSpace E] [T2Space E]
    {data : ℝ → E} {a : ℝ} {left right : E}
    (h : HasJumpAt data a left right) : ¬ ContinuousAt data a := by
  intro hc
  have hl := tendsto_nhds_unique h.1 hc.continuousWithinAt.tendsto
  have hr := tendsto_nhds_unique h.2.1 hc.continuousWithinAt.tendsto
  exact h.2.2 (hl.trans hr.symm)

/-- Only the two punctured one-sided germs matter. -/
theorem HasJumpAt.congr {E : Type*} [TopologicalSpace E]
    {data other : ℝ → E} {a : ℝ} {left right : E}
    (h : HasJumpAt data a left right)
    (hl : data =ᶠ[𝓝[<] a] other) (hr : data =ᶠ[𝓝[>] a] other) :
    HasJumpAt other a left right :=
  ⟨h.1.congr' hl, h.2.1.congr' hr, h.2.2⟩

theorem hasJumpAt_of_isRiemannData {E : Type*} [TopologicalSpace E]
    {data : ℝ → E} {left right : E}
    (h : IsRiemannData data left right) (hne : left ≠ right) :
    HasJumpAt data 0 left right :=
  ⟨h.tendsto_left, h.tendsto_right, hne⟩

/-- Both components jump at the same point; pair inequality alone would allow
one component to remain constant. -/
def HasMaterialStateInterfaceAt {Material State : Type*}
    [TopologicalSpace Material] [TopologicalSpace State]
    (medium : ℝ → Material) (initialState : ℝ → State) (a : ℝ)
    (leftMaterial rightMaterial : Material) (leftState rightState : State) : Prop :=
  HasJumpAt medium a leftMaterial rightMaterial ∧
    HasJumpAt initialState a leftState rightState

theorem materialStateInterface_iff_product_traces {Material State : Type*}
    [TopologicalSpace Material] [TopologicalSpace State]
    (medium : ℝ → Material) (initialState : ℝ → State) (a : ℝ)
    (leftMaterial rightMaterial : Material) (leftState rightState : State) :
    HasMaterialStateInterfaceAt medium initialState a
        leftMaterial rightMaterial leftState rightState ↔
      Tendsto (fun x => (medium x, initialState x)) (𝓝[<] a)
        (𝓝 (leftMaterial, leftState)) ∧
      Tendsto (fun x => (medium x, initialState x)) (𝓝[>] a)
        (𝓝 (rightMaterial, rightState)) ∧
      leftMaterial ≠ rightMaterial ∧ leftState ≠ rightState := by
  constructor
  · rintro ⟨hm, hq⟩
    exact ⟨hm.1.prodMk_nhds hq.1, hm.2.1.prodMk_nhds hq.2.1, hm.2.2, hq.2.2⟩
  · rintro ⟨hl, hr, hm, hq⟩
    exact ⟨⟨hl.fst_nhds, hr.fst_nhds, hm⟩, ⟨hl.snd_nhds, hr.snd_nhds, hq⟩⟩

theorem HasMaterialStateInterfaceAt.discontinuous {Material State : Type*}
    [TopologicalSpace Material] [TopologicalSpace State]
    [T2Space Material] [T2Space State]
    {medium : ℝ → Material} {initialState : ℝ → State} {a : ℝ}
    {leftMaterial rightMaterial : Material} {leftState rightState : State}
    (h : HasMaterialStateInterfaceAt medium initialState a
      leftMaterial rightMaterial leftState rightState) :
    ¬ ContinuousAt medium a ∧ ¬ ContinuousAt initialState a :=
  ⟨h.1.not_continuousAt, h.2.not_continuousAt⟩

/-- Conditional source-contract draft: initial states retain Eq. (1.11)'s
global half-line values; the material has distinct traces at zero.
No full source-faithfulness assertion is made by this draft. -/
theorem materialInterface_of_local_medium_and_riemann_state
    {Material State : Type*} [TopologicalSpace Material] [TopologicalSpace State]
    [T2Space Material] [T2Space State]
    {medium : ℝ → Material} {initialState : ℝ → State}
    {leftMaterial rightMaterial : Material} {leftState rightState : State}
    (hmLeft : Tendsto medium (𝓝[<] 0) (𝓝 leftMaterial))
    (hmRight : Tendsto medium (𝓝[>] 0) (𝓝 rightMaterial))
    (hmNe : leftMaterial ≠ rightMaterial)
    (hq : IsRiemannData initialState leftState rightState)
    (hqNe : leftState ≠ rightState) :
    HasMaterialStateInterfaceAt medium initialState 0
        leftMaterial rightMaterial leftState rightState ∧
      IsRiemannData initialState leftState rightState ∧
      ¬ ContinuousAt medium 0 ∧ ¬ ContinuousAt initialState 0 := by
  have h : HasMaterialStateInterfaceAt medium initialState 0
      leftMaterial rightMaterial leftState rightState :=
    ⟨⟨hmLeft, hmRight, hmNe⟩, hasJumpAt_of_isRiemannData hq hqNe⟩
  exact ⟨h, hq, h.discontinuous⟩

/-- A nontrivial globally constant-side specialization with free origin values. -/
theorem riemann_pair_hasMaterialStateInterface
    {Material State : Type*} [TopologicalSpace Material] [TopologicalSpace State]
    (leftMaterial originMaterial rightMaterial : Material)
    (leftState originState rightState : State)
    (hm : leftMaterial ≠ rightMaterial) (hq : leftState ≠ rightState) :
    HasMaterialStateInterfaceAt
      (riemannData leftMaterial originMaterial rightMaterial)
      (riemannData leftState originState rightState) 0
      leftMaterial rightMaterial leftState rightState :=
  ⟨hasJumpAt_of_isRiemannData (riemannData_isRiemannData _ _ _) hm,
    hasJumpAt_of_isRiemannData (riemannData_isRiemannData _ _ _) hq⟩

/-- A varying medium, not a source-imposed material law. -/
noncomputable def varyingMedium (origin : ℝ) (x : ℝ) : ℝ :=
  riemannData 0 origin 1 x + x

theorem varyingMedium_hasJumpAt (origin : ℝ) :
    HasJumpAt (varyingMedium origin) 0 0 1 := by
  have h := riemannData_isRiemannData (0 : ℝ) origin 1
  have hl : Tendsto (fun x : ℝ => x) (𝓝[<] 0) (𝓝 0) :=
    continuousAt_id.continuousWithinAt.tendsto
  have hr : Tendsto (fun x : ℝ => x) (𝓝[>] 0) (𝓝 0) :=
    continuousAt_id.continuousWithinAt.tendsto
  refine ⟨?_, ?_, zero_ne_one⟩
  · simpa only [varyingMedium, add_zero] using h.tendsto_left.add hl
  · simpa only [varyingMedium, add_zero] using h.tendsto_right.add hr

/-- The broader material model does not secretly impose constant half-lines. -/
theorem varyingMedium_not_isRiemannData (origin : ℝ) :
    ¬ ∃ left right : ℝ, IsRiemannData (varyingMedium origin) left right := by
  rintro ⟨left, right, hl, hr⟩
  have h1 := hl (-1) (by norm_num)
  have h2 := hl (-2) (by norm_num)
  norm_num [varyingMedium, riemannData] at h1 h2
  linarith

/-- Substantive instance with both jumps, a nonconstant medium, Riemann initial
states, and independently free values at the interface. -/
theorem varyingMedium_interface_witness (originMaterial originState : ℝ) :
    HasMaterialStateInterfaceAt (varyingMedium originMaterial)
        (riemannData (2 : ℝ) originState 3) 0 0 1 2 3 ∧
      IsRiemannData (riemannData (2 : ℝ) originState 3) 2 3 ∧
      ¬ ContinuousAt (varyingMedium originMaterial) 0 ∧
      ¬ ContinuousAt (riemannData (2 : ℝ) originState 3) 0 ∧
      (¬ ∃ left right, IsRiemannData (varyingMedium originMaterial) left right) ∧
      varyingMedium originMaterial 0 = originMaterial ∧
      riemannData (2 : ℝ) originState 3 0 = originState := by
  have hm := varyingMedium_hasJumpAt originMaterial
  have h := materialInterface_of_local_medium_and_riemann_state hm.1 hm.2.1 hm.2.2
    (riemannData_isRiemannData (2 : ℝ) originState 3) (by norm_num)
  exact ⟨h.1, h.2.1, h.2.2.1, h.2.2.2,
    varyingMedium_not_isRiemannData originMaterial,
    by simp [varyingMedium], by simp⟩

/-- A jump of the pair alone cannot certify that both components jump. -/
theorem product_jump_with_constant_medium (originState : ℝ) :
    HasJumpAt (fun x => ((0 : ℝ), riemannData (0 : ℝ) originState 1 x))
        0 (0, 0) (0, 1) ∧
      ¬ HasMaterialStateInterfaceAt (fun _ => (0 : ℝ))
        (riemannData (0 : ℝ) originState 1) 0 0 0 0 1 := by
  have h := riemannData_isRiemannData (0 : ℝ) originState 1
  refine ⟨⟨tendsto_const_nhds.prodMk_nhds h.tendsto_left,
    tendsto_const_nhds.prodMk_nhds h.tendsto_right, ?_⟩, ?_⟩
  · intro heq
    have := congrArg Prod.snd heq
    norm_num at this
  · intro hi
    exact hi.1.2.2 rfl

end NumStability.MaterialInterfaceDraft

/-
SPDX-License-Identifier: MIT
-/


/-!+# Scratch: rectangle balance with internal production

Only bounded-interval integrability is required. No spatial derivative, source
sign, constitutive rate law, or pointwise-in-time mass derivative is assumed.
-/

open MeasureTheory

namespace NumStability.IntegralSourceDraft

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- Finite mass and boundary exchange, together with spatially integrated
production and its time integral, on all oriented bounded rectangles. -/
def IsRectangleBalanceLawSolution
    (q : ℝ → ℝ → E) (flux : E → E) (production : ℝ → ℝ → E) : Prop :=
  (∀ a b t, IntervalIntegrable (fun x => q x t) volume a b) ∧
  (∀ x s t, IntervalIntegrable (fun τ => flux (q x τ)) volume s t) ∧
  (∀ a b t, IntervalIntegrable (fun x => production x t) volume a b) ∧
  (∀ a b s t, IntervalIntegrable (fun τ => ∫ x in a..b, production x τ) volume s t) ∧
  ∀ a b s t,
    (∫ x in a..b, q x t) - (∫ x in a..b, q x s) =
      (∫ τ in s..t, flux (q a τ) - flux (q b τ)) +
        ∫ τ in s..t, ∫ x in a..b, production x τ

namespace IsRectangleBalanceLawSolution

variable {q : ℝ → ℝ → E} {flux : E → E} {production : ℝ → ℝ → E}

/-- The source contribution is the mass change after boundary inflow is removed. -/
theorem integrated_source_eq_mass_defect
    (h : IsRectangleBalanceLawSolution q flux production) (a b s t : ℝ) :
    (∫ τ in s..t, ∫ x in a..b, production x τ) =
      ((∫ x in a..b, q x t) - (∫ x in a..b, q x s)) -
        ∫ τ in s..t, flux (q a τ) - flux (q b τ) := by
  rw [h.2.2.2.2 a b s t]
  abel

theorem rectangle_conservation_iff_source_integral_zero
    (h : IsRectangleBalanceLawSolution q flux production) (a b s t : ℝ) :
    ((∫ x in a..b, q x t) - (∫ x in a..b, q x s) =
      ∫ τ in s..t, flux (q a τ) - flux (q b τ)) ↔
        (∫ τ in s..t, ∫ x in a..b, production x τ) = 0 := by
  rw [h.2.2.2.2 a b s t, add_eq_left]

/-- Homogeneous conservation is exactly zero net production on every rectangle,
provided the supplied fields satisfy the actual balance law. -/
theorem conservation_iff_source_integrals_zero
    (h : IsRectangleBalanceLawSolution q flux production) :
    IsRectangleConservationLawSolution q flux ↔
      ∀ a b s t, (∫ τ in s..t, ∫ x in a..b, production x τ) = 0 := by
  constructor
  · intro hc a b s t
    exact (h.rectangle_conservation_iff_source_integral_zero a b s t).mp (hc.2.2 a b s t)
  · intro hz
    exact ⟨h.1, h.2.1, fun a b s t =>
      (h.rectangle_conservation_iff_source_integral_zero a b s t).mpr (hz a b s t)⟩

/-- Failure of homogeneous conservation forces an actual nonzero rectangle
source integral, rather than only a source value at an isolated point. -/
theorem not_conservation_iff_exists_nonzero_source_integral
    (h : IsRectangleBalanceLawSolution q flux production) :
    ¬ IsRectangleConservationLawSolution q flux ↔
      ∃ a b s t, (∫ τ in s..t, ∫ x in a..b, production x τ) ≠ 0 := by
  rw [h.conservation_iff_source_integrals_zero]
  push_neg
  rfl

/-- Every source field realizing these same mass and flux fields has the same
integrated contribution on each rectangle; no pointwise uniqueness is claimed. -/
theorem integrated_source_unique {other : ℝ → ℝ → E}
    (h : IsRectangleBalanceLawSolution q flux production)
    (hother : IsRectangleBalanceLawSolution q flux other) (a b s t : ℝ) :
    (∫ τ in s..t, ∫ x in a..b, production x τ) =
      ∫ τ in s..t, ∫ x in a..b, other x τ := by
  rw [h.integrated_source_eq_mass_defect, hother.integrated_source_eq_mass_defect]

end IsRectangleBalanceLawSolution

theorem zero_source_iff_conservation (q : ℝ → ℝ → E) (flux : E → E) :
    IsRectangleBalanceLawSolution q flux (fun _ _ => 0) ↔
      IsRectangleConservationLawSolution q flux := by
  constructor
  · intro h
    exact h.conservation_iff_source_integrals_zero.mpr (by simp)
  · rintro ⟨hq, hf, hb⟩
    refine ⟨hq, hf, ?_, ?_, ?_⟩
    · intros
      exact intervalIntegrable_const
    · intros
      simp only [intervalIntegral.integral_zero]
      exact intervalIntegrable_const
    · simpa using hb

/-- The a.e. mass-rate statement follows from the integral balance. Its null
exceptional set can depend on the fixed spatial interval. -/
theorem IsRectangleBalanceLawSolution.hasDerivAt_mass_ae
    {ι : Type*} [Fintype ι] {q : ℝ → ℝ → ι → ℝ}
    {flux : (ι → ℝ) → ι → ℝ} {production : ℝ → ℝ → ι → ℝ}
    (h : IsRectangleBalanceLawSolution q flux production) (a b : ℝ) :
    ∀ᵐ t, HasDerivAt (fun s => ∫ x in a..b, q x s)
      (flux (q a t) - flux (q b t) + ∫ x in a..b, production x t) t := by
  have hint (s t : ℝ) : IntervalIntegrable
      (fun r => flux (q a r) - flux (q b r) + ∫ x in a..b, production x r)
      volume s t :=
    ((h.2.1 a s t).sub (h.2.1 b s t)).add (h.2.2.2.1 a b s t)
  filter_upwards [ae_hasDerivAt_intervalIntegral_pi _ hint] with t ht
  have heq : (fun s => ∫ x in a..b, q x s) =
      (fun s => (∫ r in (0 : ℝ)..s,
        flux (q a r) - flux (q b r) + ∫ x in a..b, production x r) +
          ∫ x in a..b, q x 0) := by
    funext s
    rw [intervalIntegral.integral_add
      ((h.2.1 a 0 s).sub (h.2.1 b 0 s)) (h.2.2.2.1 a b 0 s)]
    exact sub_eq_iff_eq_add.mp (h.2.2.2.2 a b 0 s)
  rw [heq]
  exact (ht 0).add_const _

section Examples

variable [CompleteSpace E]

/-- Arbitrary locally integrable profiles can grow or deplete at any real rate
with zero transport. The construction does not require spatial smoothness. -/
theorem linear_amplitude_balance (profile : ℝ → E)
    (hprofile : ∀ a b, IntervalIntegrable profile volume a b) (rate : ℝ) :
    IsRectangleBalanceLawSolution
      (fun x t => (rate * t) • profile x) (fun _ => 0)
      (fun x _ => rate • profile x) := by
  refine ⟨fun a b t => (hprofile a b).smul (rate * t),
    fun _ _ _ => intervalIntegrable_const,
    fun a b _ => (hprofile a b).smul rate,
    fun _ _ _ _ => intervalIntegrable_const, ?_⟩
  intro a b s t
  simp only [intervalIntegral.integral_smul, sub_self, intervalIntegral.integral_zero,
    zero_add, intervalIntegral.integral_const, ← sub_smul, smul_smul]
  congr 1
  ring

omit [CompleteSpace E] in
theorem linear_amplitude_mass_derivative (profile : ℝ → E) (rate a b t : ℝ) :
    HasDerivAt (fun τ => ∫ x in a..b, (rate * τ) • profile x)
      (rate • ∫ x in a..b, profile x) t := by
  simpa only [intervalIntegral.integral_smul, mul_one] using
    ((hasDerivAt_id t).const_mul rate).smul_const (∫ x in a..b, profile x)

end Examples

/-- The same constructed source has the existing conservative differential
meaning wherever that relation is used. A spatial state derivative is not
needed here, since the flux is the actual constant zero function. -/
theorem linear_amplitude_classical_balance {m : ℕ}
    (profile : ℝ → Fin m → ℝ) (rate x t : ℝ) :
    IsBalanceLawSolutionAt (fun ξ τ => (rate * τ) • profile ξ)
      (fun _ => 0) (rate • profile x) x t := by
  refine ⟨rate • profile x, 0, ?_, hasDerivAt_const x 0, by simp⟩
  simpa only [mul_one] using ((hasDerivAt_id t).const_mul rate).smul_const (profile x)

noncomputable def stationaryStep : ℝ → ℝ := riemannData 0 0 1

theorem stationaryStep_integrable (a b : ℝ) :
    IntervalIntegrable stationaryStep volume a b :=
  riemannData_intervalIntegrable 0 0 1 a b

theorem stationaryStep_unitCell : (∫ x in (1 : ℝ)..2, stationaryStep x) = 1 := by
  have heq : (∫ x in (1 : ℝ)..2, stationaryStep x) = ∫ _x in (1 : ℝ)..2, (1 : ℝ) := by
    apply intervalIntegral.integral_congr
    intro x hx
    have hx' : 1 ≤ x := by
      rcases Set.mem_uIcc.mp hx with h | h
      · exact h.1
      · linarith [h.1, h.2]
    exact (riemannData_isRiemannData 0 0 1).2 x (by linarith)
  rw [heq]
  norm_num
  rfl

/-- Signed production is retained: the unit rectangle contribution is exactly
the supplied real rate, so a negative rate models depletion equally well. -/
theorem stationaryStep_signed_source_integral (rate : ℝ) :
    (∫ _τ in (1 : ℝ)..2, ∫ x in (1 : ℝ)..2, rate * stationaryStep x) = rate := by
  simp only [intervalIntegral.integral_const_mul, stationaryStep_unitCell, mul_one,
    intervalIntegral.integral_const, smul_eq_mul]
  ring

/-- A real, spatially discontinuous source-bearing solution with nonzero net
production in a genuine rectangle and ordinary continuous-time mass rates. -/
theorem stationaryStep_source_nonvacuity :
    IsRectangleBalanceLawSolution (fun x t => t * stationaryStep x) (fun _ => 0)
      (fun x _ => stationaryStep x) ∧
    ¬ ContinuousAt (fun x => (1 : ℝ) * stationaryStep x) 0 ∧
    (∀ a b t, HasDerivAt (fun τ => ∫ x in a..b, τ * stationaryStep x)
      (∫ x in a..b, stationaryStep x) t) ∧
    (∫ _τ in (1 : ℝ)..2, ∫ x in (1 : ℝ)..2, stationaryStep x) = 1 ∧
    ¬ IsRectangleConservationLawSolution
      (fun x t => t * stationaryStep x) (fun _ => 0) := by
  have hb : IsRectangleBalanceLawSolution (fun x t => t * stationaryStep x)
      (fun _ => 0) (fun x _ => stationaryStep x) := by
    simpa using linear_amplitude_balance stationaryStep stationaryStep_integrable 1
  have hnonzero : (∫ _τ in (1 : ℝ)..2, ∫ x in (1 : ℝ)..2, stationaryStep x) = 1 := by
    rw [stationaryStep_unitCell]
    norm_num
    rfl
  refine ⟨hb, ?_, ?_, hnonzero, ?_⟩
  · simpa only [one_mul, stationaryStep] using
      (riemannData_isRiemannData (0 : ℝ) 0 1).not_continuousAt_zero zero_ne_one
  · intro a b t
    simpa using linear_amplitude_mass_derivative stationaryStep 1 a b t
  · exact hb.not_conservation_iff_exists_nonzero_source_integral.mpr
      ⟨1, 2, 1, 2, by rw [hnonzero]; exact one_ne_zero⟩

end NumStability.IntegralSourceDraft

namespace NumStability.JumpBalancePlacementCheck

/-- Draft-to-canonical identity 1: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_01 : @NumStability.MaterialInterfaceDraft.HasJumpAt = @NumStability.HasJumpAt := rfl
#print axioms identity_01

/-- Draft-to-canonical identity 2: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_02 : @NumStability.MaterialInterfaceDraft.HasJumpAt.not_continuousAt = @NumStability.HasJumpAt.not_continuousAt := rfl
#print axioms identity_02

/-- Draft-to-canonical identity 3: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_03 : @NumStability.MaterialInterfaceDraft.HasJumpAt.congr = @NumStability.HasJumpAt.congr := rfl
#print axioms identity_03

/-- Draft-to-canonical identity 4: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_04 : @NumStability.MaterialInterfaceDraft.hasJumpAt_of_isRiemannData = @NumStability.IsRiemannData.hasJumpAt := rfl
#print axioms identity_04

/-- Draft-to-canonical identity 5: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_05 : @NumStability.MaterialInterfaceDraft.materialStateInterface_iff_product_traces = @NumStability.hasJumpAt_and_iff_product_traces := rfl
#print axioms identity_05

/-- Draft-to-canonical identity 6: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_06 : @NumStability.MaterialInterfaceDraft.varyingMedium = @NumStability.LocalMaterialInterface.varyingMedium := rfl
#print axioms identity_06

/-- Draft-to-canonical identity 7: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_07 : @NumStability.MaterialInterfaceDraft.varyingMedium_hasJumpAt = @NumStability.LocalMaterialInterface.varyingMedium_hasJumpAt := rfl
#print axioms identity_07

/-- Draft-to-canonical identity 8: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_08 : @NumStability.MaterialInterfaceDraft.varyingMedium_not_isRiemannData = @NumStability.LocalMaterialInterface.varyingMedium_not_isRiemannData := rfl
#print axioms identity_08

/-- Draft-to-canonical identity 9: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_09 : @NumStability.MaterialInterfaceDraft.varyingMedium_interface_witness = @NumStability.LocalMaterialInterface.varyingMedium_interface_witness := rfl
#print axioms identity_09

/-- Draft-to-canonical identity 10: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_10 : @NumStability.MaterialInterfaceDraft.product_jump_with_constant_medium = @NumStability.LocalMaterialInterface.product_jump_with_constant_medium := rfl
#print axioms identity_10

/-- Draft-to-canonical identity 11: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_11 : @NumStability.IntegralSourceDraft.IsRectangleBalanceLawSolution = @NumStability.IsRectangleBalanceLawSolution := rfl
#print axioms identity_11

/-- Draft-to-canonical identity 12: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_12 : @NumStability.IntegralSourceDraft.IsRectangleBalanceLawSolution.integrated_source_eq_mass_defect = @NumStability.IsRectangleBalanceLawSolution.integrated_source_eq_mass_defect := rfl
#print axioms identity_12

/-- Draft-to-canonical identity 13: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_13 : @NumStability.IntegralSourceDraft.IsRectangleBalanceLawSolution.rectangle_conservation_iff_source_integral_zero = @NumStability.IsRectangleBalanceLawSolution.rectangle_conservation_iff_source_integral_zero := rfl
#print axioms identity_13

/-- Draft-to-canonical identity 14: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_14 : @NumStability.IntegralSourceDraft.IsRectangleBalanceLawSolution.conservation_iff_source_integrals_zero = @NumStability.IsRectangleBalanceLawSolution.conservation_iff_source_integrals_zero := rfl
#print axioms identity_14

/-- Draft-to-canonical identity 15: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_15 : @NumStability.IntegralSourceDraft.IsRectangleBalanceLawSolution.not_conservation_iff_exists_nonzero_source_integral = @NumStability.IsRectangleBalanceLawSolution.not_conservation_iff_exists_nonzero_source_integral := rfl
#print axioms identity_15

/-- Draft-to-canonical identity 16: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_16 : @NumStability.IntegralSourceDraft.IsRectangleBalanceLawSolution.integrated_source_unique = @NumStability.IsRectangleBalanceLawSolution.integrated_source_unique := rfl
#print axioms identity_16

/-- Draft-to-canonical identity 17: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_17 : @NumStability.IntegralSourceDraft.IsRectangleBalanceLawSolution.hasDerivAt_mass_ae = @NumStability.IsRectangleBalanceLawSolution.hasDerivAt_mass_ae := rfl
#print axioms identity_17

/-- Draft-to-canonical identity 18: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_18 : @NumStability.IntegralSourceDraft.zero_source_iff_conservation = @NumStability.isRectangleBalanceLawSolution_zero_iff := rfl
#print axioms identity_18

/-- Draft-to-canonical identity 19: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_19 : @NumStability.IntegralSourceDraft.linear_amplitude_balance = @NumStability.linearAmplitude_isRectangleBalanceLawSolution := rfl
#print axioms identity_19

/-- Draft-to-canonical identity 20: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_20 : @NumStability.IntegralSourceDraft.linear_amplitude_mass_derivative = @NumStability.linearAmplitude_hasDerivAt_mass := rfl
#print axioms identity_20

/-- Draft-to-canonical identity 21: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_21 : @NumStability.IntegralSourceDraft.linear_amplitude_classical_balance = @NumStability.linearAmplitude_isBalanceLawSolutionAt := rfl
#print axioms identity_21

/-- Draft-to-canonical identity 22: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_22 : @NumStability.IntegralSourceDraft.stationaryStep_unitCell = @NumStability.riemannStep_unitCell := rfl
#print axioms identity_22

/-- Draft-to-canonical identity 23: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_23 : @NumStability.IntegralSourceDraft.stationaryStep_signed_source_integral = @NumStability.riemannStep_signed_source_integral := rfl
#print axioms identity_23

/-- Draft-to-canonical identity 24: definitions unfold identically; proof equality uses proof irrelevance. -/
theorem identity_24 : @NumStability.IntegralSourceDraft.stationaryStep_source_nonvacuity = @NumStability.riemannStep_source_nonvacuity := rfl
#print axioms identity_24

open MeasureTheory Filter Set
open scoped Topology

/-- The omitted interface alias unfolds to the two canonical jumps. -/
theorem interface_alias {M Q : Type*} [TopologicalSpace M] [TopologicalSpace Q]
    (medium : ℝ → M) (state : ℝ → Q) (a : ℝ) (ml mr : M) (ql qr : Q) :
    MaterialInterfaceDraft.HasMaterialStateInterfaceAt medium state a ml mr ql qr ↔
      HasJumpAt medium a ml mr ∧ HasJumpAt state a ql qr := Iff.rfl

/-- The omitted discontinuity wrapper is reconstructed from the canonical jump API. -/
theorem interface_discontinuity {M Q : Type*} [TopologicalSpace M] [TopologicalSpace Q]
    [T2Space M] [T2Space Q]
    {medium : ℝ → M} {state : ℝ → Q} {a : ℝ} {ml mr : M} {ql qr : Q}
    (h : MaterialInterfaceDraft.HasMaterialStateInterfaceAt medium state a ml mr ql qr) :
    ¬ ContinuousAt medium a ∧ ¬ ContinuousAt state a :=
  ⟨(show HasJumpAt medium a ml mr from h.1).not_continuousAt,
    (show HasJumpAt state a ql qr from h.2).not_continuousAt⟩

/-- The omitted Riemann-pair wrapper is two applications of the canonical bridge. -/
theorem riemann_pair {M Q : Type*} [TopologicalSpace M] [TopologicalSpace Q]
    (ml m0 mr : M) (ql q0 qr : Q) (hm : ml ≠ mr) (hq : ql ≠ qr) :
    MaterialInterfaceDraft.HasMaterialStateInterfaceAt
      (riemannData ml m0 mr) (riemannData ql q0 qr) 0 ml mr ql qr :=
  ⟨(riemannData_isRiemannData ml m0 mr).hasJumpAt hm,
    (riemannData_isRiemannData ql q0 qr).hasJumpAt hq⟩

/-- The pending source-shaped bundle can be reconstructed without promoting it. -/
theorem local_medium_bundle {M Q : Type*} [TopologicalSpace M] [TopologicalSpace Q]
    [T2Space M] [T2Space Q]
    {medium : ℝ → M} {state : ℝ → Q} {ml mr : M} {ql qr : Q}
    (hl : Tendsto medium (𝓝[<] 0) (𝓝 ml)) (hr : Tendsto medium (𝓝[>] 0) (𝓝 mr))
    (hm : ml ≠ mr) (hs : IsRiemannData state ql qr) (hq : ql ≠ qr) :
    MaterialInterfaceDraft.HasMaterialStateInterfaceAt medium state 0 ml mr ql qr ∧
      IsRiemannData state ql qr ∧ ¬ ContinuousAt medium 0 ∧ ¬ ContinuousAt state 0 := by
  have hjm : HasJumpAt medium 0 ml mr := ⟨hl, hr, hm⟩
  have hjq := hs.hasJumpAt hq
  exact ⟨⟨hjm, hjq⟩, hs, hjm.not_continuousAt, hjq.not_continuousAt⟩

theorem stationary_step_alias : IntegralSourceDraft.stationaryStep = riemannData 0 0 1 := rfl

theorem stationary_step_integrability (a b : ℝ) :
    IntervalIntegrable IntegralSourceDraft.stationaryStep volume a b :=
  riemannData_intervalIntegrable 0 0 1 a b

#print axioms interface_alias
#print axioms interface_discontinuity
#print axioms riemann_pair
#print axioms local_medium_bundle
#print axioms stationary_step_alias
#print axioms stationary_step_integrability
end NumStability.JumpBalancePlacementCheck
