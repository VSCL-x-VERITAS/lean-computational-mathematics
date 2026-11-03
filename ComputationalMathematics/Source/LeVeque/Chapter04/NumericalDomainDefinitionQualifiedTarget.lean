/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.NumericalDomainDefinition

/-!
# Owner-qualified numerical-domain definition: proof-free primary target

The actual user-selected convention fixes the admitted class and complete
initialized observation before testing every-neighborhood functional influence.
The four concluding consequences/examples explain that fixed-observation
definition. Auxiliary set-limit notions are retained outside this primary claim.
This transparent proposition is supplied without a proof. Its source-qualified
meaning remains subject to independent statement review and proof checking.
-/

namespace NumStability

def Leveque04NumericalDomainDefinitionQualifiedTarget : Prop :=
  (∀ (State : Type) (admissible : (ℝ → ℝ) → Prop)
    (initialization : (ℝ → ℝ) → State) (update : State → State)
    (steps : ℕ) (observe : State → ℝ) (point : ℝ),
    point ∈ leveque04_scalarNumericalDomain admissible
      (leveque04_initializedNumericalObservation initialization update steps observe) ↔
    ∀ radius : ℝ, 0 < radius → ∃ f g : ℝ → ℝ,
      admissible f ∧ admissible g ∧
      (∀ y, y ∉ Metric.ball point radius → f y = g y) ∧
      observe (update^[steps] (initialization f)) ≠ observe (update^[steps] (initialization g))) ∧
  (∀ (m : ℕ) [NeZero m] (State : Type)
    (admissible : (ℝ → Fin m → ℝ) → Prop)
    (initialization : (ℝ → Fin m → ℝ) → State) (update : State → State)
    (steps : ℕ) (observe : State → Fin m → ℝ) (point : ℝ),
    point ∈ leveque04_vectorNumericalDomain admissible
      (leveque04_initializedNumericalObservation initialization update steps observe) ↔
    ∀ radius : ℝ, 0 < radius → ∃ f g : ℝ → Fin m → ℝ,
      admissible f ∧ admissible g ∧
      (∀ y, y ∉ Metric.ball point radius → f y = g y) ∧
      observe (update^[steps] (initialization f)) ≠ observe (update^[steps] (initialization g))) ∧
  (∀ (E V : Type) (admissible : (ℝ → E) → Prop)
    (left right : (ℝ → E) → V),
    (∀ f, admissible f → left f = right f) →
    leveque04_numericalDomainOnClass admissible left =
      leveque04_numericalDomainOnClass admissible right) ∧
  (∀ (E V : Type) (admissible : (ℝ → E) → Prop) (value : V),
    leveque04_numericalDomainOnClass admissible (fun _ => value) = ∅) ∧
  (∀ point : ℝ,
    leveque04_scalarNumericalDomain Continuous (fun f => f point) = {point}) ∧
  (∀ (m : ℕ) [NeZero m] (point : ℝ),
    leveque04_vectorNumericalDomain (m := m) Continuous (fun f => f point) = {point})

end NumStability
