/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity

/-!
# First-order quasilinear equations

An equation stores its admissible states, principal matrix and forcing.
Its residual expresses `q_t + A(x,t,q) q_x = b(x,t,q)`. Spectral hyperbolicity
uses that same matrix. The optional classical relation uses actual derivatives;
constant and spatially varying linear equations embed as special cases.
-/

namespace NumStability

variable {ι : Type*} [Fintype ι]

/-- A concrete first-order quasilinear equation, with a declared state domain. -/
structure FirstOrderEquation (ι : Type*) [Fintype ι] where
  /-- The set of state vectors `q` on which the equation is posed; hyperbolicity and the
  classical relation are only required at these states. -/
  admissibleStates : Set (ι → ℝ)
  /-- The principal matrix `A(x, t, q)`, evaluated at position `x`, time `t` and state `q`,
  which multiplies the space derivative `q_x` in `q_t + A(x, t, q) q_x = b(x, t, q)`. -/
  principal : ℝ → ℝ → (ι → ℝ) → Matrix ι ι ℝ
  /-- The forcing term `b(x, t, q)`, evaluated at position `x`, time `t` and state `q`, which
  appears on the right-hand side of `q_t + A(x, t, q) q_x = b(x, t, q)`. -/
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

end FirstOrderEquation

end NumStability
