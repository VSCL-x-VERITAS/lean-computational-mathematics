/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Complex.Basic

/-!
# LeVeque Chapter 2: ParabolicPrincipalSymbolModel

Definitions of the scalar diffusion principal symbol.
-/

namespace NumStability.Leveque02Tracer

structure OneSpaceEvolutionOperator where
  velocity : ℝ
  diffusivity : ℝ

/-- The coefficient record acts on the local time, space, and second-space
derivative values of a scalar field. -/
def residual (op : OneSpaceEvolutionOperator) (qt qx qxx : ℝ) : ℝ :=
  qt + op.velocity * qx - op.diffusivity * qxx

/-- Weighted principal symbol: time has weight two and space weight one. -/
def principalSymbol (op : OneSpaceEvolutionOperator) (τ ξ : ℝ) : ℂ :=
  ⟨op.diffusivity * ξ ^ 2, τ⟩

def IsForwardParabolic (op : OneSpaceEvolutionOperator) : Prop :=
  (∀ ξ : ℝ, ξ ≠ 0 → 0 < op.diffusivity * ξ ^ 2) ∧
    ∀ τ ξ : ℝ, τ ≠ 0 ∨ ξ ≠ 0 → principalSymbol op τ ξ ≠ 0

def diffusionOperator (β : ℝ) : OneSpaceEvolutionOperator :=
  ⟨0, β⟩

def advectionDiffusionOperator (u β : ℝ) : OneSpaceEvolutionOperator :=
  ⟨u, β⟩

/-- At a point where `β` has derivative `β'`, the divergence-form operator
`q_t - (β q_x)_x` has local drift coefficient `-β'`. -/
def variableDiffusionOperator (β β' : ℝ) : OneSpaceEvolutionOperator :=
  ⟨-β', β⟩

end NumStability.Leveque02Tracer
