/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellMeanStabilityConvergence
import ComputationalMathematics.Analysis.Normed.Module.LinearPowerErrorBounds
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.SmoothCompactEssentialLocalization

/-!
# Actual represented errors, stability, observation and limiting dependence

The numerical arrays execute an actual update from an actual initializer. Errors
and defects represent its literal differences from prescribed reference arrays
through injective real-linear maps. The error recurrence is derived from those
identities. Either an all-pairs one-step bound or an actual autonomous linear
power bound yields convergence of the same physically weighted error norm.

Uniformly controlled compatible observations then converge. On each concrete
localizable data class covered by these hypotheses, actual fixed-mesh essential
domains have the required lower-limit containment. This is generic functional
mathematics, not a PDE solution theory or an unqualified stability converse.
-/

noncomputable section

open Filter Set
open scoped Topology

namespace NumStability

/-- Actual nonautonomous execution from the supplied initial state. -/
def representedGridEvolution {G : Type*} (update : ℕ → G → G) (initial : G) : ℕ → G
  | 0 => initial
  | k + 1 => update k (representedGridEvolution update initial k)

section Errors

variable {G H : ℕ → Type*}
variable [∀ n, AddCommGroup (G n)] [∀ n, Module ℝ (G n)]
variable [∀ n, NormedAddCommGroup (H n)] [∀ n, NormedSpace ℝ (H n)]

/-- Actual represented errors and executed defects, their normalized consistency
budget, and correct initialization. There is no convergence conclusion or assumed
error recurrence in this predicate. Full grid states need not have finite norm. -/
def HasConsistentInitializedErrors
    (J : ∀ n, H n →ₗ[ℝ] G n) (update : ∀ n, ℕ → G n → G n)
    (initial : ∀ n, G n) (reference : ∀ n, ℕ → G n)
    (error defect : ∀ n, ℕ → H n) (steps : ℕ → ℕ)
    (dt weight rate : ℕ → ℝ) : Prop :=
  (∀ n k, k ≤ steps n → J n (error n k) =
    representedGridEvolution (update n) (initial n) k - reference n k) ∧
  (∀ n k, k < steps n → J n (defect n k) =
    update n k (reference n k) - reference n (k + 1)) ∧
  (∀ n, 0 ≤ rate n) ∧
  (∀ n k, k < steps n → weight n * ‖defect n k‖ ≤ dt n * rate n) ∧
  Tendsto (fun n => weight n * ‖error n 0‖) atTop (𝓝 0) ∧
  Tendsto rate atTop (𝓝 0)

/-- The literal pair bound controls every represented state difference, not only
one selected error trajectory. -/
def IsRepresentedPairStable
    (J : ∀ n, H n →ₗ[ℝ] G n) (update : ∀ n, ℕ → G n → G n)
    (steps : ℕ → ℕ) (dt : ℕ → ℝ) (growth : ℝ) : Prop :=
  ∀ n k, k < steps n → ∀ (P Q : G n) (e : H n), J n e = P - Q →
    ∃ v : H n, J n v = update n k P - update n k Q ∧
      ‖v‖ ≤ (1 + growth * dt n) * ‖e‖

/-- An actual full-array autonomous linear map and its coupled error map have
uniform bounds on every executed power. This does not require a one-step bound. -/
def HasRepresentedLinearPowerBound
    (J : ∀ n, H n →ₗ[ℝ] G n) (update : ∀ n, ℕ → G n → G n)
    (steps : ℕ → ℕ) : Prop :=
  ∃ (L : ∀ n, G n →ₗ[ℝ] G n) (P : ∀ n, H n →ₗ[ℝ] H n) (C : ℝ),
    0 ≤ C ∧
    (∀ n k, k < steps n → ∀ x, update n k x = L n x) ∧
    (∀ n e, J n (P n e) = L n (J n e)) ∧
    ∀ n k, k ≤ steps n → ∀ e, ‖(P n ^ k) e‖ ≤ C * ‖e‖

/-- Literal pair stability and actual consistency derive the weighted norm
convergence through the actual executed numerical/reference error identity. -/
theorem pairStable_representedEvolution_error_tendsto_zero
    (J : ∀ n, H n →ₗ[ℝ] G n) (hJ : ∀ n, Function.Injective (J n))
    (update : ∀ n, ℕ → G n → G n) (initial : ∀ n, G n)
    (reference : ∀ n, ℕ → G n) (error defect : ∀ n, ℕ → H n)
    (steps : ℕ → ℕ) (dt weight rate : ℕ → ℝ) (growth horizon : ℝ)
    (hdt : ∀ n, 0 ≤ dt n) (hweight : ∀ n, 0 < weight n) (hgrowth : 0 ≤ growth)
    (hclock : ∀ n, (steps n : ℝ) * dt n ≤ horizon)
    (hconsistent : HasConsistentInitializedErrors J update initial reference error defect
      steps dt weight rate)
    (hstable : IsRepresentedPairStable J update steps dt growth) :
    Tendsto (fun n => weight n * ‖error n (steps n)‖) atTop (𝓝 0) := by
  obtain ⟨herror, hdefect, hrate, hbudget, hinitial, hratelimit⟩ := hconsistent
  let values : ℕ → ℕ → ℝ := fun n k => weight n * ‖error n k‖
  have hstep (n k : ℕ) (hk : k < steps n) :
      values n (k + 1) ≤ (1 + growth * dt n) * values n k + dt n * rate n := by
    obtain ⟨v, hv, hvbound⟩ := hstable n k hk
      (representedGridEvolution (update n) (initial n) k) (reference n k)
      (error n k) (herror n k (Nat.le_of_lt hk))
    have heq : error n (k + 1) = v + defect n k := by
      apply hJ n
      rw [map_add, herror n (k + 1) (by omega), hv, hdefect n k hk]
      simp only [representedGridEvolution]
      abel
    have htriangle : ‖error n (k + 1)‖ ≤
        (1 + growth * dt n) * ‖error n k‖ + ‖defect n k‖ := by
      rw [heq]
      exact (norm_add_le _ _).trans (add_le_add hvbound le_rfl)
    calc
      values n (k + 1) ≤ weight n *
          ((1 + growth * dt n) * ‖error n k‖ + ‖defect n k‖) :=
        mul_le_mul_of_nonneg_left htriangle (hweight n).le
      _ = (1 + growth * dt n) * values n k + weight n * ‖defect n k‖ := by
        dsimp [values]
        ring
      _ ≤ (1 + growth * dt n) * values n k + dt n * rate n :=
        add_le_add le_rfl (hbudget n k hk)
  exact finiteHorizon_error_tendsto_zero values steps dt rate growth horizon hdt hgrowth
    (fun n k => mul_nonneg (hweight n).le (norm_nonneg _)) hrate hstep hclock hinitial hratelimit

/-- Actual autonomous full-array linear coupling derives the error recurrence.
The power-bound estimate is applied to physically scaled real-linear errors. -/
theorem powerStable_representedEvolution_error_tendsto_zero
    (J : ∀ n, H n →ₗ[ℝ] G n) (hJ : ∀ n, Function.Injective (J n))
    (update : ∀ n, ℕ → G n → G n) (initial : ∀ n, G n)
    (reference : ∀ n, ℕ → G n) (error defect : ∀ n, ℕ → H n)
    (steps : ℕ → ℕ) (dt weight rate : ℕ → ℝ) (horizon : ℝ)
    (hdt : ∀ n, 0 ≤ dt n) (hweight : ∀ n, 0 < weight n)
    (hclock : ∀ n, (steps n : ℝ) * dt n ≤ horizon)
    (hconsistent : HasConsistentInitializedErrors J update initial reference error defect
      steps dt weight rate)
    (hstable : HasRepresentedLinearPowerBound J update steps) :
    Tendsto (fun n => weight n * ‖error n (steps n)‖) atTop (𝓝 0) := by
  obtain ⟨herror, hdefect, hrate, hbudget, hinitial, hratelimit⟩ := hconsistent
  obtain ⟨L, P, C, hC, hupdate, hcouple, hpower⟩ := hstable
  have hstep (n k : ℕ) (hk : k < steps n) :
      error n (k + 1) = P n (error n k) + defect n k := by
    apply hJ n
    calc
      J n (error n (k + 1)) =
          representedGridEvolution (update n) (initial n) (k + 1) - reference n (k + 1) :=
        herror n (k + 1) (by omega)
      _ = L n (representedGridEvolution (update n) (initial n) k) - reference n (k + 1) := by
        simp only [representedGridEvolution, hupdate n k hk]
      _ = L n (J n (error n k)) + J n (defect n k) := by
        rw [herror n k (Nat.le_of_lt hk), hdefect n k hk, hupdate n k hk, map_sub]
        abel
      _ = J n (P n (error n k) + defect n k) := by rw [map_add, hcouple]
  let scaledError : ∀ n, ℕ → H n := fun n k => weight n • error n k
  let scaledDefect : ∀ n, ℕ → H n := fun n k => weight n • defect n k
  have hscaled (n k : ℕ) : ‖weight n • error n k‖ = weight n * ‖error n k‖ := by
    rw [norm_smul, Real.norm_eq_abs, abs_of_pos (hweight n)]
  have hfinal := linearError_norm_tendsto_zero_of_uniform_power_bound P scaledError scaledDefect
    steps dt rate C horizon hdt hC hrate
    (by
      intro n k hk
      dsimp [scaledError, scaledDefect]
      rw [hstep n k hk, map_smul, smul_add])
    hpower
    (by
      intro n k hk
      dsimp [scaledDefect]
      simpa only [norm_smul, Real.norm_eq_abs, abs_of_pos (hweight n)] using hbudget n k hk)
    hclock
    (by simpa only [scaledError, hscaled] using hinitial)
    hratelimit
  simpa only [scaledError, hscaled] using hfinal

/-- Either explicit actual stability route gives the same weighted norm limit.
The disjunction names actual inequalities and coupling; it is no convergence oracle. -/
theorem representedStableEvolution_error_tendsto_zero
    (J : ∀ n, H n →ₗ[ℝ] G n) (hJ : ∀ n, Function.Injective (J n))
    (update : ∀ n, ℕ → G n → G n) (initial : ∀ n, G n)
    (reference : ∀ n, ℕ → G n) (error defect : ∀ n, ℕ → H n)
    (steps : ℕ → ℕ) (dt weight rate : ℕ → ℝ) (horizon : ℝ)
    (hdt : ∀ n, 0 ≤ dt n) (hweight : ∀ n, 0 < weight n)
    (hclock : ∀ n, (steps n : ℝ) * dt n ≤ horizon)
    (hconsistent : HasConsistentInitializedErrors J update initial reference error defect
      steps dt weight rate)
    (hstable : (∃ growth, 0 ≤ growth ∧ IsRepresentedPairStable J update steps dt growth) ∨
      HasRepresentedLinearPowerBound J update steps) :
    Tendsto (fun n => weight n * ‖error n (steps n)‖) atTop (𝓝 0) := by
  rcases hstable with ⟨growth, hgrowth, hpair⟩ | hpower
  · exact pairStable_representedEvolution_error_tendsto_zero J hJ update initial reference
      error defect steps dt weight rate growth horizon hdt hweight hgrowth hclock hconsistent hpair
  · exact powerStable_representedEvolution_error_tendsto_zero J hJ update initial reference
      error defect steps dt weight rate horizon hdt hweight hclock hconsistent hpower

end Errors

/-- Actual stability/consistency estimates give all-data SAME-observable
convergence, then actual fixed-mesh essential-set lower limits on each concrete
class covered by the admitted data. No transfer of essential sets between classes
is made: both sides of each conclusion use that same concrete class. -/
theorem representedStableEvolution_observation_and_essential_lowerLimits
    {E V : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [NormedAddCommGroup V] [NormedSpace ℝ V]
    {G H : ℕ → Type*}
    [∀ n, AddCommGroup (G n)] [∀ n, Module ℝ (G n)]
    [∀ n, NormedAddCommGroup (H n)] [∀ n, NormedSpace ℝ (H n)]
    (admissible : (ℝ → E) → Prop)
    (J : ∀ n, H n →ₗ[ℝ] G n) (hJ : ∀ n, Function.Injective (J n))
    (update : ∀ n, ℕ → G n → G n)
    (initial : ∀ n, (ℝ → E) → G n) (reference : ∀ n, (ℝ → E) → ℕ → G n)
    (error defect : ∀ n, (ℝ → E) → ℕ → H n)
    (steps : ℕ → ℕ) (dt weight : ℕ → ℝ) (rate : (ℝ → E) → ℕ → ℝ)
    (horizon : ℝ) (hdt : ∀ n, 0 ≤ dt n) (hweight : ∀ n, 0 < weight n)
    (hclock : ∀ n, (steps n : ℝ) * dt n ≤ horizon)
    (hconsistent : ∀ f, admissible f →
      HasConsistentInitializedErrors J update (fun n => initial n f)
        (fun n => reference n f) (fun n => error n f) (fun n => defect n f)
        steps dt weight (rate f))
    (hstable : (∃ growth, 0 ≤ growth ∧ IsRepresentedPairStable J update steps dt growth) ∨
      HasRepresentedLinearPowerBound J update steps)
    (observe : ∀ n, G n → V) (exactValue : (ℝ → E) → V)
    (B : ∀ n, H n →L[ℝ] V) (amplification : ℝ)
    (hobserve : ∀ n (P Q : G n) (e : H n), J n e = P - Q →
      observe n P - observe n Q = B n e)
    (hbound : ∀ n e, ‖B n e‖ ≤ amplification * (weight n * ‖e‖))
    (hreference : ∀ f, admissible f →
      Tendsto (fun n => observe n (reference n f (steps n))) atTop (𝓝 (exactValue f))) :
    let approximation := fun n f =>
      observe n (representedGridEvolution (update n) (initial n f) (steps n))
    (∀ f, admissible f →
      Tendsto (fun n => approximation n f) atTop (𝓝 (exactValue f))) ∧
    ((∀ f, IsBoundedContinuousField f → admissible f) →
      {x | IsEssentialPointOnClass IsBoundedContinuousField exactValue x} ⊆
        numericalLimitingDomain
          (fun n => {x | IsEssentialPointOnClass IsBoundedContinuousField (approximation n) x})) ∧
    ((∀ f, IsSmoothCompactField f → admissible f) →
      {x | IsEssentialPointOnClass IsSmoothCompactField exactValue x} ⊆
        numericalLimitingDomain
          (fun n => {x | IsEssentialPointOnClass IsSmoothCompactField (approximation n) x})) := by
  let approximation := fun n f =>
    observe n (representedGridEvolution (update n) (initial n f) (steps n))
  have hconverges (f : ℝ → E) (hf : admissible f) :
      Tendsto (fun n => approximation n f) atTop (𝓝 (exactValue f)) := by
    have hdata := hconsistent f hf
    have hnorm := representedStableEvolution_error_tendsto_zero J hJ update
      (fun n => initial n f) (fun n => reference n f) (fun n => error n f)
      (fun n => defect n f) steps dt weight (rate f) horizon hdt hweight hclock hdata hstable
    apply observable_tendsto_of_norm_error (fun n => approximation n f)
      (fun n => observe n (reference n f (steps n))) (exactValue f)
      (fun n => weight n * ‖error n f (steps n)‖) amplification
    · intro n
      rw [hobserve n _ _ _ (hdata.1 n (steps n) le_rfl)]
      exact hbound n _
    · exact hnorm
    · exact hreference f hf
  refine ⟨hconverges, ?_, ?_⟩
  · intro hclass
    exact boundedContinuous_convergence_essential_lowerLimit exactValue approximation
      (fun f hf => hconverges f (hclass f hf))
  · intro hclass
    exact smoothCompact_convergence_essential_lowerLimit exactValue approximation
      (fun f hf => hconverges f (hclass f hf))

end NumStability
