/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AdmissibleDomainNecessity
import Mathlib.Logic.Function.Iterate

/-!
# Numerical dependence of a fixed initialized observation

The functional reading of printed69 is made explicit relative to an admitted
initial-data class. Every neighborhood of an influential point admits some
change that affects the fixed numerical observation. This is a topological
convention for the source's informal definition, not a claim that the book
uniquely prescribes this convention or an equality with a structural read graph.

Initialization, the solved update, its iteration count and the observation are
fixed before any influence-point or perturbation quantifier. Supplying an update
here defines a dependence question; it asserts no solvability or PDE property.
-/

namespace NumStability

/-- The entire initialized observation: initialize, iterate a fixed update,
then observe the resulting state. A solved implicit method can supply its
actual update; this definition does not manufacture such a solver. -/
def leveque04_initializedNumericalObservation {E State V : Type*}
    (initialization : (ℝ → E) → State) (update : State → State)
    (steps : ℕ) (observe : State → V) : (ℝ → E) → V :=
  fun initial => observe (update^[steps] (initialization initial))

/-- Every-neighborhood functional influence for one prescribed complete map
and one fixed admissible class, specialized from the generic dependence API. -/
def leveque04_numericalDomainOnClass {E V : Type*}
    (admissible : (ℝ → E) → Prop) (observation : (ℝ → E) → V) : Set ℝ :=
  {point | IsEssentialPointOnClass admissible observation point}

/-- Scalar source-facing numerical domain for a fixed complete observation. -/
def leveque04_scalarNumericalDomain
    (admissible : (ℝ → ℝ) → Prop) (observation : (ℝ → ℝ) → ℝ) : Set ℝ :=
  leveque04_numericalDomainOnClass admissible observation

/-- Positive finite-component source-facing numerical domain. A change in
any component of the observed vector counts as a changed observation. -/
def leveque04_vectorNumericalDomain {m : ℕ} [NeZero m]
    (admissible : (ℝ → Fin m → ℝ) → Prop)
    (observation : (ℝ → Fin m → ℝ) → Fin m → ℝ) : Set ℝ :=
  leveque04_numericalDomainOnClass admissible observation

/-- Eventual influence in each neighborhood along prescribed observations.
The refinement threshold may depend on the neighborhood. This separate
definition does not identify functional influence with a stencil envelope. -/
def leveque04_eventualNumericalInfluenceDomain {E V : Type*}
    (admissible : (ℝ → E) → Prop) (observation : ℕ → (ℝ → E) → V) : Set ℝ :=
  {point | ∀ radius : ℝ, 0 < radius → ∀ᶠ n in Filter.atTop,
    ∃ f g : ℝ → E, admissible f ∧ admissible g ∧
      (∀ y, y ∉ Metric.ball point radius → f y = g y) ∧ observation n f ≠ observation n g}

/-- Arbitrarily refined influence in each neighborhood. Its quantifiers
are weaker than eventual influence; no equivalence is asserted. -/
def leveque04_arbitrarilyRefinedNumericalInfluenceDomain {E V : Type*}
    (admissible : (ℝ → E) → Prop) (observation : ℕ → (ℝ → E) → V) : Set ℝ :=
  {point | ∀ radius : ℝ, 0 < radius → ∀ start : ℕ,
    ∃ n : ℕ, start ≤ n ∧ ∃ f g : ℝ → E, admissible f ∧ admissible g ∧
      (∀ y, y ∉ Metric.ball point radius → f y = g y) ∧ observation n f ≠ observation n g}

end NumStability
