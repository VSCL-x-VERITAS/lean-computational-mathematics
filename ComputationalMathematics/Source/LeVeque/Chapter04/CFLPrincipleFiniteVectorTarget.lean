/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RepresentedEvolutionDependence
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AdvectionCellMeanStabilityCFL
import Mathlib.Analysis.Normed.Module.FiniteDimension

noncomputable section
open Set Filter MeasureTheory
open scoped Topology ENNReal
namespace NumStability

/-- One positive-dimensional finite real state space, with its chosen norm,
is used for both physical fields and observed values. Each conclusion fixes one data class. -/
def Leveque04CFLConvergenceNecessityFiniteVector.{uE, uG} : Prop :=
  ∀ {E : Type uE} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [FiniteDimensional ℝ E] [Nontrivial E] {G : ℕ → Type uG}
    (update : ∀ n, ℕ → G n → G n) (initial : ∀ n, (ℝ → E) → G n)
    (observe : ∀ n, G n → E) (steps : ℕ → ℕ)
    (exactValue : (ℝ → E) → E),
    let approximation := fun n f =>
      observe n (representedGridEvolution (update n) (initial n f) (steps n))
    ((∀ f, IsBoundedContinuousField f →
        Tendsto (fun n => approximation n f) atTop (𝓝 (exactValue f))) →
      {x | IsEssentialPointOnClass IsBoundedContinuousField exactValue x} ⊆
        numericalLimitingDomain (fun n =>
          {x | IsEssentialPointOnClass IsBoundedContinuousField (approximation n) x})) ∧
    ((∀ f, IsSmoothCompactField f →
        Tendsto (fun n => approximation n f) atTop (𝓝 (exactValue f))) →
      {x | IsEssentialPointOnClass IsSmoothCompactField exactValue x} ⊆
        numericalLimitingDomain (fun n =>
          {x | IsEssentialPointOnClass IsSmoothCompactField (approximation n) x}))

/-- Qualified stability necessity. All hypotheses are literal identities,
bounds, state-space structures or reference compatibility, never project proof
theorems or an assumed stability-to-convergence implication. -/
def Leveque04CFLQualifiedStabilityNecessityFiniteVector.{uE, uG, uH} : Prop :=
  ∀
    {E : Type uE} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [FiniteDimensional ℝ E] [Nontrivial E]
    {G : ℕ → Type uG} {H : ℕ → Type uH}
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
    (observe : ∀ n, G n → E) (exactValue : (ℝ → E) → E)
    (B : ∀ n, H n →L[ℝ] E) (amplification : ℝ)
    (hobserve : ∀ n (P Q : G n) (e : H n), J n e = P - Q →
      observe n P - observe n Q = B n e)
    (hbound : ∀ n e, ‖B n e‖ ≤ amplification * (weight n * ‖e‖))
    (hreference : ∀ f, admissible f →
      Tendsto (fun n => observe n (reference n f (steps n))) atTop (𝓝 (exactValue f))),
    let approximation := fun n f =>
      observe n (representedGridEvolution (update n) (initial n f) (steps n))
    ((∀ f, IsBoundedContinuousField f → admissible f) →
      {x | IsEssentialPointOnClass IsBoundedContinuousField exactValue x} ⊆
        numericalLimitingDomain
          (fun n => {x | IsEssentialPointOnClass IsBoundedContinuousField (approximation n) x})) ∧
    ((∀ f, IsSmoothCompactField f → admissible f) →
      {x | IsEssentialPointOnClass IsSmoothCompactField exactValue x} ⊆
        numericalLimitingDomain
          (fun n => {x | IsEssentialPointOnClass IsSmoothCompactField (approximation n) x}))

/-- Subordinate genuine all-p physical advection realization, not the parent. -/
def Leveque04CFLAdvectionRealizationFiniteVector : Prop :=
  ∀
    (p : ENNReal) [Fact (1 ≤ p)]
    (speed origin horizon ratio : ℝ) (radius : ℕ)
    (update : ℕ → ℕ → (ℤ → Fin 1 → ℝ) → ℤ → Fin 1 → ℝ)
    (hhorizon : 0 < horizon) (hratio : 0 < ratio)
    (hlocal : ∀ n k (left right : ℤ → Fin 1 → ℝ) (i : ℤ),
      (∀ j ∈ Icc (i - (radius : ℤ)) (i + (radius : ℤ)), left j = right j) →
      update n k left i = update n k right i)
    (hsupport : ∀ (profile : ℝ → ℝ)
      (hprofile : ContDiff ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) profile),
      HasCompactSupport profile → (∀ x, 0 ≤ profile x ∧ profile x ≤ 1) →
      let reference := scalarAdvectionFixedRatioCellReferenceS06
        speed origin horizon ratio hhorizon hratio profile hprofile
      let approx := advectionCellMeanRefinementEvolution update origin horizon ratio profile
      ∃ error : ℕ → ℕ → lp (fun _ : ℤ => Fin 1 → ℝ) p,
        (∀ n k, k ≤ n + 1 → ∀ j,
          error n k j = approx n k j - physicalCellReferenceMeansS06 reference n k j) ∧
        IsCellMeanReferenceErrorConsistentS06 p reference update ∧
        IsCellMeanErrorTrajectoryStableS06 p reference update approx error),
    |speed| * ratio ≤ (radius : ℝ)

/-- Both original necessity obligations are visible. The stability applicability
qualification and physical-instance limits are disclosed in the source proposal. -/
def Leveque04CFLPrincipleTargetFiniteVector.{uE, uG, uH} : Prop :=
  Leveque04CFLConvergenceNecessityFiniteVector.{uE, uG} ∧
    Leveque04CFLQualifiedStabilityNecessityFiniteVector.{uE, uG, uH} ∧
    Leveque04CFLAdvectionRealizationFiniteVector

end NumStability
