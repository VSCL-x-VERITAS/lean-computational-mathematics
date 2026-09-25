/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Complex.Basic

/-!
# LeVeque Chapter 2: ParabolicPrincipalSymbolModel

Definitions of the scalar diffusion principal symbol.
-/

namespace NumStability.Leveque02Tracer

/-- Coefficients of a one-dimensional evolution operator. -/
structure OneSpaceEvolutionOperator where
  /-- Transport coefficient of the evolution operator. -/
  velocity : ℝ
  /-- Diffusion coefficient of the evolution operator. -/
  diffusivity : ℝ

/-- The coefficient record acts on the local time, space, and second-space
derivative values of a scalar field. -/
def residual (op : OneSpaceEvolutionOperator) (qt qx qxx : ℝ) : ℝ :=
  qt + op.velocity * qx - op.diffusivity * qxx

/-- Weighted principal symbol: time has weight two and space weight one. -/
def principalSymbol (op : OneSpaceEvolutionOperator) (τ ξ : ℝ) : ℂ :=
  ⟨op.diffusivity * ξ ^ 2, τ⟩

/-- Positive spatial principal part and nonvanishing principal symbol away from zero frequency. -/
def IsForwardParabolic (op : OneSpaceEvolutionOperator) : Prop :=
  (∀ ξ : ℝ, ξ ≠ 0 → 0 < op.diffusivity * ξ ^ 2) ∧
    ∀ τ ξ : ℝ, τ ≠ 0 ∨ ξ ≠ 0 → principalSymbol op τ ξ ≠ 0

/-- Evolution operator with pure diffusion. -/
def diffusionOperator (β : ℝ) : OneSpaceEvolutionOperator :=
  ⟨0, β⟩

/-- Evolution operator with transport and diffusion coefficients. -/
def advectionDiffusionOperator (u β : ℝ) : OneSpaceEvolutionOperator :=
  ⟨u, β⟩

/-- At a point where `β` has derivative `β'`, the divergence-form operator
`q_t - (β q_x)_x` has local drift coefficient `-β'`. -/
def variableDiffusionOperator (β β' : ℝ) : OneSpaceEvolutionOperator :=
  ⟨-β', β⟩

end NumStability.Leveque02Tracer
