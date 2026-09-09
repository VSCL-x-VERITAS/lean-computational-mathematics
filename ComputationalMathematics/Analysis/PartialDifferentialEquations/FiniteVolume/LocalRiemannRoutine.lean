/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRiemannInformation

/-!
# Riemann information routines without mandatory consistency

Execution returns problem-indexed information on an explicit domain. Neither
exact equal-state consistency nor the existence of physical solutions is part
of a routine. Physical comparison is conditional at the selected finite-time
problem. A left-state flux with arbitrary additive bias is available for every
law without a physical-reference assumption.
-/

open MeasureTheory

namespace NumStability.LocalRiemannInformation

/-- Pure numerical execution. Physical accuracy and exact consistency are
separate properties, not prerequisites for constructing or using a routine. -/
structure Routine {m : ℕ} (law : Law m)
    (Result : Problem law → Type*) (Information : Type*) where
  /-- The problems the routine accepts; `solve` is only defined on them. -/
  domain : Problem law → Prop
  /-- Run the routine on an accepted problem, producing its problem-indexed result. -/
  solve : (problem : Problem law) → domain problem → Result problem
  /-- Extract the routine-specific information from a result of the routine. -/
  extract : {problem : Problem law} → Result problem → Information
  /-- Convert extracted information into a numerical interface flux vector. -/
  numericalFlux : Information → Fin m → ℝ

/-- The numerical flux the routine assigns to an accepted problem: solve it, extract the
routine's information from the result, and convert that information into a flux vector.
Unlike `Method.flux`, no accuracy or consistency certificate is attached. -/
def Routine.flux {m : ℕ} {law : Law m}
    {Result : Problem law → Type*} {Information : Type*}
    (routine : Routine law Result Information) (problem : Problem law)
    (admitted : routine.domain problem) : Fin m → ℝ :=
  routine.numericalFlux (routine.extract (routine.solve problem admitted))

/-- Optional exact equal-state consistency. A biased routine need not satisfy it. -/
def Routine.Consistent {m : ℕ} {law : Law m}
    {Result : Problem law → Type*} {Information : Type*}
    (routine : Routine law Result Information) : Prop :=
  ∀ problem admitted, problem.left = problem.right →
    routine.flux problem admitted = law.flux problem.left

/-- Forget the stronger old method's accuracy and consistency certificates,
preserving its domain, selected result, extraction and flux exactly. -/
def Method.toRoutine {m : ℕ} {law : Law m}
    {Result : Problem law → Type*} {Information : Type*}
    (method : Method law Result Information) : Routine law Result Information where
  domain := method.domain
  solve := method.solve
  extract := method.extract
  numericalFlux := method.numericalFlux

theorem Method.toRoutine_flux {m : ℕ} {law : Law m}
    {Result : Problem law → Type*} {Information : Type*}
    (method : Method law Result Information) (problem : Problem law)
    (admitted : method.domain problem) :
    method.toRoutine.flux problem admitted = method.flux problem admitted := rfl

theorem Method.toRoutine_consistent {m : ℕ} {law : Law m}
    {Result : Problem law → Type*} {Information : Type*}
    (method : Method law Result Information) : method.toRoutine.Consistent :=
  method.consistent

/-- Available on every ordered admissible input, without requiring any
Riemann reference. The returned information is just the two ordered vectors. -/
def biasedRoutine {m : ℕ} (law : Law m) (bias : Fin m → ℝ) :
    Routine law (fun _ => (Fin m → ℝ) × (Fin m → ℝ))
      ((Fin m → ℝ) × (Fin m → ℝ)) where
  domain := fun _ => True
  solve := fun problem _ => (problem.left, problem.right)
  extract := fun result => result
  numericalFlux := fun information => law.flux information.1 + bias

theorem biasedRoutine_selected {m : ℕ} (law : Law m) (bias : Fin m → ℝ)
    (problem : Problem law) :
    (biasedRoutine law bias).extract (problem := problem) ((biasedRoutine law bias).solve problem trivial) =
      (problem.left, problem.right) ∧
    (biasedRoutine law bias).flux problem trivial = law.flux problem.left + bias := ⟨rfl, rfl⟩

/-- Unconditional routine availability does not assert existence of a physical
solution, an accuracy tolerance, or convergence for any problem. -/
theorem exists_biasedRoutine {m : ℕ} (law : Law m) (bias : Fin m → ℝ) :
    ∃ (routine : Routine law (fun _ => (Fin m → ℝ) × (Fin m → ℝ))
        ((Fin m → ℝ) × (Fin m → ℝ))) (admitted : ∀ problem, routine.domain problem),
      ∀ problem, routine.extract (problem := problem) (routine.solve problem (admitted problem)) =
        (problem.left, problem.right) ∧
        routine.flux problem (admitted problem) = law.flux problem.left + bias :=
  ⟨biasedRoutine law bias, fun _ => trivial, biasedRoutine_selected law bias⟩

/-- A supplied physical reference has the same ordered initial data and time
slab. Its flux-error bound composes with an independent physical-flux bound.
This does not require such a reference for any other input. -/
theorem Routine.reference_comparison {m : ℕ} {law : Law m}
    {Result : Problem law → Type*} {Information : Type*}
    (routine : Routine law Result Information) (problem : Problem law)
    (admitted : routine.domain problem) (reference : Reference problem)
    {solverBound : ℝ}
    (hsolver : ‖routine.flux problem admitted - reference.meanFlux‖ ≤ solverBound) :
    IsRiemannData (fun x => reference.field x 0) problem.left problem.right ∧
    IsOneDimensionalCellAverage (fun τ => law.flux (reference.field 0 τ)) 0 problem.duration
      reference.meanFlux ∧
    ∀ (physicalMean : Fin m → ℝ) (comparisonBound : ℝ),
      ‖reference.meanFlux - physicalMean‖ ≤ comparisonBound →
      ‖routine.flux problem admitted - physicalMean‖ ≤ solverBound + comparisonBound := by
  refine ⟨reference.initial, oneDimensionalCellAverage_isCellAverage _ problem.duration_pos
    (reference.face_integrable 0 0 problem.duration le_rfl problem.duration_pos.le le_rfl), ?_⟩
  intro physicalMean comparisonBound hcomparison
  calc
    ‖routine.flux problem admitted - physicalMean‖ =
        ‖(routine.flux problem admitted - reference.meanFlux) +
          (reference.meanFlux - physicalMean)‖ := by congr 1; module
    _ ≤ ‖routine.flux problem admitted - reference.meanFlux‖ +
        ‖reference.meanFlux - physicalMean‖ := norm_add_le _ _
    _ ≤ solverBound + comparisonBound := add_le_add hsolver hcomparison

end NumStability.LocalRiemannInformation
