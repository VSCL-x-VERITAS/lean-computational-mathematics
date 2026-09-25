/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FirstOrderEquation

/-!
# LeVeque Chapter 2, Equation (2.81): quasilinear system

Proof-free representation of the displayed first-order system and its
pointwise hyperbolicity criterion.
-/

namespace NumStability.Leveque02Tracer

/-- The homogeneous first-order equation with the source's principal matrix
`A(q,x,t)`. -/
def equation81System {ι : Type*} [Fintype ι]
    (coefficient : (ι → ℝ) → ℝ → ℝ → Matrix ι ι ℝ) :
    FirstOrderEquation ι where
  admissibleStates := Set.univ
  principal := fun x t state => coefficient state x t
  forcing := fun _ _ _ => 0

/-- Hyperbolicity of Equation (2.81) at one state-space-time point, using the
actual principal matrix of that equation. -/
def equation81HyperbolicAt {ι : Type*} [Fintype ι]
    (coefficient : (ι → ℝ) → ℝ → ℝ → Matrix ι ι ℝ)
    (state : ι → ℝ) (x t : ℝ) : Prop :=
  IsRealHyperbolicMatrix ((equation81System coefficient).principal x t state)

/-- Classical solutionhood is `qₜ + A(q,x,t)qₓ = 0` with actual derivatives;
at a point, hyperbolicity means a complete real eigenbasis of that same
principal matrix. -/
def equation81QuasilinearTarget : Prop :=
  ∀ {ι : Type*} [Fintype ι]
      (coefficient : (ι → ℝ) → ℝ → ℝ → Matrix ι ι ℝ)
      (state : ι → ℝ) (x t : ℝ),
    (equation81HyperbolicAt coefficient state x t ↔
      IsRealHyperbolicMatrix (coefficient state x t)) ∧
      ∀ (q : ℝ → ℝ → (ι → ℝ)),
        ((equation81System coefficient).IsClassicalSolutionAt q x t ↔
          ∃ timeDerivative spaceDerivative : ι → ℝ,
            HasDerivAt (fun τ => q x τ) timeDerivative t ∧
              HasDerivAt (fun ξ => q ξ t) spaceDerivative x ∧
                timeDerivative +
                  (coefficient (q x t) x t).mulVec spaceDerivative = 0)

end NumStability.Leveque02Tracer
