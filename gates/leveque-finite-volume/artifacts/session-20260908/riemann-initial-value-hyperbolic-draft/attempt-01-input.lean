/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw
import ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRectangleRiemannInterface

/-!
Scratch problem-data repair. No source-correspondence acceptance is asserted.
The governing object is the actual equation q_t + A(x,t,q) q_x = b(x,t,q),
not a predicate on candidate solutions. Hyperbolicity concerns that same A.
State domains, dependence on x/t/state, and source terms remain explicit.
The Riemann classification imposes no classical or generalized solution theory.
Equal-side and distinct-side data are separate, visibly named families.
-/

namespace NumStability.RiemannInitialDraft

variable {ι : Type*} [Fintype ι]

/-- A concrete first-order quasilinear equation, with a declared state domain. -/
structure FirstOrderEquation (ι : Type*) [Fintype ι] where
  admissibleStates : Set (ι → ℝ)
  principal : ℝ → ℝ → (ι → ℝ) → Matrix ι ι ℝ
  forcing : ℝ → ℝ → (ι → ℝ) → (ι → ℝ)

namespace FirstOrderEquation

/-- The actual equation expression evaluated on state, time and space derivatives. -/
def residual (equation : FirstOrderEquation ι) (x t : ℝ)
    (state timeDerivative spaceDerivative : ι → ℝ) : ι → ℝ :=
  timeDerivative + (equation.principal x t state).mulVec spaceDerivative -
    equation.forcing x t state

theorem residual_eq_zero_iff (equation : FirstOrderEquation ι) (x t : ℝ)
    (state timeDerivative spaceDerivative : ι → ℝ) :
    equation.residual x t state timeDerivative spaceDerivative = 0 ↔
      timeDerivative + (equation.principal x t state).mulVec spaceDerivative =
        equation.forcing x t state := sub_eq_zero

/-- A real eigenbasis for the actual principal matrix at each admissible state. -/
def IsHyperbolic (equation : FirstOrderEquation ι) : Prop :=
  ∀ x t state, state ∈ equation.admissibleStates →
    IsRealHyperbolicMatrix (equation.principal x t state)

/-- An optional classical relation, using actual derivatives of the supplied field. -/
def IsClassicalSolutionAt (equation : FirstOrderEquation ι)
    (q : ℝ → ℝ → (ι → ℝ)) (x t : ℝ) : Prop :=
  q x t ∈ equation.admissibleStates ∧
    ∃ qt qx : ι → ℝ,
      HasDerivAt (fun τ => q x τ) qt t ∧
      HasDerivAt (fun ξ => q ξ t) qx x ∧
      equation.residual x t (q x t) qt qx = 0

/-- A constant linear system is a special case of the concrete equation object. -/
def constantLinear (coefficient : Matrix ι ι ℝ) : FirstOrderEquation ι where
  admissibleStates := Set.univ
  principal := fun _ _ _ => coefficient
  forcing := fun _ _ _ => 0

theorem constantLinear_isHyperbolic (coefficient : Matrix ι ι ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient) :
    (constantLinear coefficient).IsHyperbolic := fun _ _ _ _ => hcoefficient

theorem constantLinear_classical_iff (coefficient : Matrix ι ι ℝ)
    (q : ℝ → ℝ → (ι → ℝ)) (x t : ℝ) :
    (constantLinear coefficient).IsClassicalSolutionAt q x t ↔
      IsConstantCoefficientLinearSystemSolutionAt q coefficient x t := by
  simp only [IsClassicalSolutionAt, constantLinear, Set.mem_univ, true_and,
    residual, sub_zero, IsConstantCoefficientLinearSystemSolutionAt]

/-- The representation includes spatially varying matrices without requiring a flux. -/
def variableLinear (coefficient : ℝ → Matrix ι ι ℝ) : FirstOrderEquation ι where
  admissibleStates := Set.univ
  principal := fun x _ _ => coefficient x
  forcing := fun _ _ _ => 0

theorem variableLinear_isHyperbolic (coefficient : ℝ → Matrix ι ι ℝ)
    (hcoefficient : ∀ x, IsRealHyperbolicMatrix (coefficient x)) :
    (variableLinear coefficient).IsHyperbolic := fun x _ _ _ => hcoefficient x

/-- Existing differentiable conservation laws embed with their actual flux Jacobian. -/
def ofConservationLaw (law : OneDimensionalHyperbolicConservationLaw ι) :
    FirstOrderEquation ι where
  admissibleStates := Set.univ
  principal := fun _ _ state => law.fluxJacobian state
  forcing := fun _ _ _ => 0

theorem ofConservationLaw_isHyperbolic
    (law : OneDimensionalHyperbolicConservationLaw ι) :
    (ofConservationLaw law).IsHyperbolic :=
  fun _ _ state _ => law.jacobian_hyperbolic state

/-- The embedded equation has exactly the existing quasilinear PDE semantics. -/
theorem ofConservationLaw_classical_iff
    (law : OneDimensionalHyperbolicConservationLaw ι)
    (q : ℝ → ℝ → (ι → ℝ)) (x t : ℝ) :
    (ofConservationLaw law).IsClassicalSolutionAt q x t ↔
      IsQuasilinearConservationLawSolutionAt q law.fluxDerivative x t := by
  simp only [IsClassicalSolutionAt, ofConservationLaw, Set.mem_univ, true_and,
    residual, sub_zero, IsQuasilinearConservationLawSolutionAt,
    law.fluxDerivative_eq_jacobian_mulVec]

/-- Its classical relation implies the actual flux conservation PDE by the chain rule. -/
theorem ofConservationLaw_classical_implies_conservation
    (law : OneDimensionalHyperbolicConservationLaw ι)
    (q : ℝ → ℝ → (ι → ℝ)) (x t : ℝ)
    (h : (ofConservationLaw law).IsClassicalSolutionAt q x t) :
    IsConservationLawSolutionAt q law.physicalFlux x t := by
  have hquasi := (ofConservationLaw_classical_iff law q x t).mp h
  obtain ⟨qt, qx, hqt, hqx, heq⟩ := hquasi
  exact (conservationLaw_iff_quasilinearAt q law.physicalFlux law.fluxDerivative x t
    qx hqx (law.hasFDerivAt_physicalFlux (q x t))).mpr ⟨qt, qx, hqt, hqx, heq⟩

end FirstOrderEquation

/-- An initial-value problem consists of an actual governing equation and its initial field. -/
structure InitialValueProblem (ι : Type*) [Fintype ι] where
  governing : FirstOrderEquation ι
  initialState : ℝ → (ι → ℝ)

namespace InitialValueProblem

/-- The broad two-state family. No inequality between the side states is hidden. -/
def IsRiemannWithStates (problem : InitialValueProblem ι)
    (leftState rightState : ι → ℝ) : Prop :=
  problem.governing.IsHyperbolic ∧
  leftState ∈ problem.governing.admissibleStates ∧
  rightState ∈ problem.governing.admissibleStates ∧
  IsRiemannData problem.initialState leftState rightState

def IsRiemann (problem : InitialValueProblem ι) : Prop :=
  ∃ leftState rightState, problem.IsRiemannWithStates leftState rightState

/-- The nondegenerate jump family is explicit rather than silently selected. -/
def IsJumpRiemann (problem : InitialValueProblem ι) : Prop :=
  ∃ leftState rightState,
    problem.IsRiemannWithStates leftState rightState ∧ leftState ≠ rightState

/-- Exact problem-data characterization: real spectral hyperbolicity and strict half-lines. -/
theorem isRiemann_iff (problem : InitialValueProblem ι) :
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
theorem isRiemann_characterization (problem : InitialValueProblem ι) :
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
theorem isRiemannWithStates_iff_origin (problem : InitialValueProblem ι)
    (leftState rightState : ι → ℝ) :
    problem.IsRiemannWithStates leftState rightState ↔
      problem.governing.IsHyperbolic ∧
      leftState ∈ problem.governing.admissibleStates ∧
      rightState ∈ problem.governing.admissibleStates ∧
      ∃ origin, problem.initialState = riemannData leftState origin rightState := by
  exact and_congr_right' (and_congr_right' (and_congr_right'
    (isRiemannData_iff_exists_valueAtOrigin problem.initialState leftState rightState)))

theorem jump_implies_riemann (problem : InitialValueProblem ι)
    (h : problem.IsJumpRiemann) : problem.IsRiemann := by
  obtain ⟨left, right, hproblem, _⟩ := h
  exact ⟨left, right, hproblem⟩

/-- Data can be prescribed without asserting that any PDE solution exists. -/
noncomputable def fromStates (equation : FirstOrderEquation ι)
    (leftState origin rightState : ι → ℝ) : InitialValueProblem ι where
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

/-- This is an optional explicitly classical relation, not part of problem classification. -/
def IsClassicalSolutionOn (problem : InitialValueProblem ι) (times : Set ℝ)
    (q : ℝ → ℝ → (ι → ℝ)) : Prop :=
  (∀ x, q x 0 = problem.initialState x) ∧
  ∀ x t, t ∈ times → problem.governing.IsClassicalSolutionAt q x t

/-- The separately chosen classical relation uses the very same governing PDE. -/
theorem classical_solution_has_strict_initial_data
    (problem : InitialValueProblem ι) (times : Set ℝ)
    (q : ℝ → ℝ → (ι → ℝ)) (leftState rightState : ι → ℝ)
    (hproblem : problem.IsRiemannWithStates leftState rightState)
    (hsolution : problem.IsClassicalSolutionOn times q) :
    (∀ x, x < 0 → q x 0 = leftState) ∧
    (∀ x, 0 < x → q x 0 = rightState) ∧
    ∀ x t, t ∈ times → problem.governing.IsClassicalSolutionAt q x t := by
  exact ⟨fun x hx => (hsolution.1 x).trans (hproblem.2.2.2.1 x hx),
    fun x hx => (hsolution.1 x).trans (hproblem.2.2.2.2 x hx), hsolution.2⟩

end InitialValueProblem

/-- An existing conservation-law problem embeds as data, without changing its equation. -/
noncomputable def fromConservationProblem
    (law : OneDimensionalHyperbolicConservationLaw ι)
    (problem : HyperbolicRiemannProblem law) (origin : ι → ℝ) : InitialValueProblem ι :=
  InitialValueProblem.fromStates (FirstOrderEquation.ofConservationLaw law)
    problem.leftState origin problem.rightState

theorem fromConservationProblem_isRiemann
    (law : OneDimensionalHyperbolicConservationLaw ι)
    (problem : HyperbolicRiemannProblem law) (origin : ι → ℝ) :
    (fromConservationProblem law problem origin).IsRiemann := by
  exact ⟨problem.leftState, problem.rightState,
    InitialValueProblem.fromStates_isRiemannWithStates _
      (FirstOrderEquation.ofConservationLaw_isHyperbolic law) _ _ _
      (Set.mem_univ _) (Set.mem_univ _)⟩

/-- Rectangle solutionhood remains an explicit conservation-law specialization. -/
theorem rectangle_solution_iff
    (law : OneDimensionalHyperbolicConservationLaw ι)
    (problem : HyperbolicRiemannProblem law) (q : ℝ → ℝ → (ι → ℝ)) :
    IsRectangleHyperbolicRiemannSolution law problem q ↔
      (∀ x, x < 0 → q x 0 = problem.leftState) ∧
      (∀ x, 0 < x → q x 0 = problem.rightState) ∧
      IsRectangleConservationLawSolution q law.physicalFlux := by
  exact and_assoc

end NumStability.RiemannInitialDraft

#check NumStability.RiemannInitialDraft.InitialValueProblem.isRiemann_characterization
#print axioms NumStability.RiemannInitialDraft.InitialValueProblem.isRiemann_characterization
#check NumStability.RiemannInitialDraft.InitialValueProblem.isRiemann_iff
#print axioms NumStability.RiemannInitialDraft.InitialValueProblem.isRiemann_iff
#check NumStability.RiemannInitialDraft.FirstOrderEquation.constantLinear_classical_iff
#print axioms NumStability.RiemannInitialDraft.FirstOrderEquation.constantLinear_classical_iff
#check NumStability.RiemannInitialDraft.FirstOrderEquation.ofConservationLaw_classical_iff
#print axioms NumStability.RiemannInitialDraft.FirstOrderEquation.ofConservationLaw_classical_iff
#check NumStability.RiemannInitialDraft.FirstOrderEquation.ofConservationLaw_classical_implies_conservation
#print axioms NumStability.RiemannInitialDraft.FirstOrderEquation.ofConservationLaw_classical_implies_conservation
#check NumStability.RiemannInitialDraft.InitialValueProblem.isRiemannWithStates_iff_origin
#print axioms NumStability.RiemannInitialDraft.InitialValueProblem.isRiemannWithStates_iff_origin
#check NumStability.RiemannInitialDraft.InitialValueProblem.fromStates_isRiemannWithStates
#print axioms NumStability.RiemannInitialDraft.InitialValueProblem.fromStates_isRiemannWithStates
#check NumStability.RiemannInitialDraft.InitialValueProblem.fromStates_isJumpRiemann
#print axioms NumStability.RiemannInitialDraft.InitialValueProblem.fromStates_isJumpRiemann
#check NumStability.RiemannInitialDraft.InitialValueProblem.classical_solution_has_strict_initial_data
#print axioms NumStability.RiemannInitialDraft.InitialValueProblem.classical_solution_has_strict_initial_data
#check NumStability.RiemannInitialDraft.fromConservationProblem_isRiemann
#print axioms NumStability.RiemannInitialDraft.fromConservationProblem_isRiemann
#check NumStability.RiemannInitialDraft.rectangle_solution_iff
#print axioms NumStability.RiemannInitialDraft.rectangle_solution_iff
