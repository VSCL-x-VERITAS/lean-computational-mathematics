/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FirstOrderEquation
import ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann

/-!
# Riemann initial data for a first-order equation

A problem consists of its governing equation and initial field. The Riemann
data predicates require spectral hyperbolicity of the actual principal matrix
and admissible constant states on strict half-lines. The origin is free.
The broad two-state family and the distinct-jump family are separate predicates.
Problem classification does not assert existence or select a solution theory.
-/

namespace NumStability

variable {ι : Type*} [Fintype ι]

/-- An initial-value problem consists of an actual governing equation and its initial field. -/
structure FirstOrderInitialValueProblem (ι : Type*) [Fintype ι] where
  governing : FirstOrderEquation ι
  initialState : ℝ → (ι → ℝ)

namespace FirstOrderInitialValueProblem

/-- The broad two-state family. No inequality between the side states is hidden. -/
def IsRiemannWithStates (problem : FirstOrderInitialValueProblem ι)
    (leftState rightState : ι → ℝ) : Prop :=
  problem.governing.IsHyperbolic ∧
  leftState ∈ problem.governing.admissibleStates ∧
  rightState ∈ problem.governing.admissibleStates ∧
  IsRiemannData problem.initialState leftState rightState

def IsRiemann (problem : FirstOrderInitialValueProblem ι) : Prop :=
  ∃ leftState rightState, problem.IsRiemannWithStates leftState rightState

/-- The nondegenerate jump family is explicit rather than silently selected. -/
def IsJumpRiemann (problem : FirstOrderInitialValueProblem ι) : Prop :=
  ∃ leftState rightState,
    problem.IsRiemannWithStates leftState rightState ∧ leftState ≠ rightState

/-- Exact problem-data characterization: real spectral hyperbolicity and strict half-lines. -/
theorem isRiemann_iff (problem : FirstOrderInitialValueProblem ι) :
    problem.IsRiemann ↔
      ∃ leftState rightState,
        (∀ x t state, state ∈ problem.governing.admissibleStates →
          ∃ (eigenvalues : ι → ℝ) (eigenbasis : Module.Basis ι ℝ (ι → ℝ)),
            ∀ p, (problem.governing.principal x t state).mulVec (eigenbasis p) =
              eigenvalues p • eigenbasis p) ∧
        leftState ∈ problem.governing.admissibleStates ∧
        rightState ∈ problem.governing.admissibleStates ∧
        (∀ x, x < 0 → problem.initialState x = leftState) ∧
        (∀ x, 0 < x → problem.initialState x = rightState) := Iff.rfl

/-- The governing coefficient is the one in the equation expression, not an independent tag. -/
theorem isRiemann_characterization (problem : FirstOrderInitialValueProblem ι) :
    problem.IsRiemann ↔
      (∃ leftState rightState,
        problem.governing.IsHyperbolic ∧
        leftState ∈ problem.governing.admissibleStates ∧
        rightState ∈ problem.governing.admissibleStates ∧
        (∀ x, x < 0 → problem.initialState x = leftState) ∧
        (∀ x, 0 < x → problem.initialState x = rightState)) ∧
      (∀ x t state qt qx,
        problem.governing.residual x t state qt qx = 0 ↔
          qt + (problem.governing.principal x t state).mulVec qx =
            problem.governing.forcing x t state) := by
  constructor
  · intro h
    exact ⟨h, problem.governing.residual_eq_zero_iff⟩
  · exact fun h => h.1

/-- The origin remains a free parameter even when the governing equation is fixed. -/
theorem isRiemannWithStates_iff_origin (problem : FirstOrderInitialValueProblem ι)
    (leftState rightState : ι → ℝ) :
    problem.IsRiemannWithStates leftState rightState ↔
      problem.governing.IsHyperbolic ∧
      leftState ∈ problem.governing.admissibleStates ∧
      rightState ∈ problem.governing.admissibleStates ∧
      ∃ origin, problem.initialState = riemannData leftState origin rightState := by
  exact and_congr_right' (and_congr_right' (and_congr_right'
    (isRiemannData_iff_exists_valueAtOrigin problem.initialState leftState rightState)))

theorem jump_implies_riemann (problem : FirstOrderInitialValueProblem ι)
    (h : problem.IsJumpRiemann) : problem.IsRiemann := by
  obtain ⟨left, right, hproblem, _⟩ := h
  exact ⟨left, right, hproblem⟩

/-- Data can be prescribed without asserting that any PDE solution exists. -/
noncomputable def fromStates (equation : FirstOrderEquation ι)
    (leftState origin rightState : ι → ℝ) : FirstOrderInitialValueProblem ι where
  governing := equation
  initialState := riemannData leftState origin rightState

theorem fromStates_isRiemannWithStates (equation : FirstOrderEquation ι)
    (hhyperbolic : equation.IsHyperbolic)
    (leftState origin rightState : ι → ℝ)
    (hleft : leftState ∈ equation.admissibleStates)
    (hright : rightState ∈ equation.admissibleStates) :
    (fromStates equation leftState origin rightState).IsRiemannWithStates
      leftState rightState :=
  ⟨hhyperbolic, hleft, hright, riemannData_isRiemannData leftState origin rightState⟩

theorem fromStates_isJumpRiemann (equation : FirstOrderEquation ι)
    (hhyperbolic : equation.IsHyperbolic)
    (leftState origin rightState : ι → ℝ)
    (hleft : leftState ∈ equation.admissibleStates)
    (hright : rightState ∈ equation.admissibleStates) (hdistinct : leftState ≠ rightState) :
    (fromStates equation leftState origin rightState).IsJumpRiemann :=
  ⟨leftState, rightState,
    fromStates_isRiemannWithStates equation hhyperbolic leftState origin rightState hleft hright,
    hdistinct⟩

/-- Equal sides belong to the broad family, with the origin still free. -/
theorem fromEqualStates_isRiemann (equation : FirstOrderEquation ι)
    (hhyperbolic : equation.IsHyperbolic) (state origin : ι → ℝ)
    (hstate : state ∈ equation.admissibleStates) :
    (fromStates equation state origin state).IsRiemann :=
  ⟨state, state,
    fromStates_isRiemannWithStates equation hhyperbolic state origin state hstate hstate⟩

/-- Equal-side data cannot be relabeled as a distinct-side jump problem. -/
theorem fromEqualStates_not_isJumpRiemann (equation : FirstOrderEquation ι)
    (state origin : ι → ℝ) :
    ¬ (fromStates equation state origin state).IsJumpRiemann := by
  rintro ⟨left, right, hproblem, hdistinct⟩
  have hleft : state = left := by
    simpa [fromStates, riemannData] using hproblem.2.2.2.1 (-1) neg_one_lt_zero
  have hright : state = right := by
    simpa [fromStates, riemannData] using hproblem.2.2.2.2 1 zero_lt_one
  exact hdistinct (hleft.symm.trans hright)

/-- This is an optional explicitly classical relation, not part of problem classification. -/
def IsClassicalSolutionOn (problem : FirstOrderInitialValueProblem ι) (times : Set ℝ)
    (q : ℝ → ℝ → (ι → ℝ)) : Prop :=
  (∀ x, q x 0 = problem.initialState x) ∧
  ∀ x t, t ∈ times → problem.governing.IsClassicalSolutionAt q x t

/-- The separately chosen classical relation uses the very same governing PDE. -/
theorem classical_solution_has_strict_initial_data
    (problem : FirstOrderInitialValueProblem ι) (times : Set ℝ)
    (q : ℝ → ℝ → (ι → ℝ)) (leftState rightState : ι → ℝ)
    (hproblem : problem.IsRiemannWithStates leftState rightState)
    (hsolution : problem.IsClassicalSolutionOn times q) :
    (∀ x, x < 0 → q x 0 = leftState) ∧
    (∀ x, 0 < x → q x 0 = rightState) ∧
    ∀ x t, t ∈ times → problem.governing.IsClassicalSolutionAt q x t := by
  exact ⟨fun x hx => (hsolution.1 x).trans (hproblem.2.2.2.1 x hx),
    fun x hx => (hsolution.1 x).trans (hproblem.2.2.2.2 x hx), hsolution.2⟩

end FirstOrderInitialValueProblem

end NumStability
