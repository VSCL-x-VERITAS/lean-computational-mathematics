/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.ScalarUpwindFlux
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

/-!
# Signed Upwind Update

One explicit step with supplied signed coefficients. This algebraic operation
does not assert that the coefficients are velocity integrals.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

noncomputable section

namespace NumStability.FiniteVolume

open scoped BigOperators

/-- One explicit step with supplied signed coefficients. This algebraic operation
does not assert that the coefficients are velocity integrals. -/
@[nolint unusedArguments] -- Retain the common decidable-face interface used by the trajectory family.
def signedUpwindStep {Cell Face : Type} [DecidableEq Face]
    (faces : Cell → Finset Face) (neighbour : Cell → Face → Cell)
    (mass : Cell → ℝ) (step : ℝ) (coefficient : Cell → Face → ℝ)
    (state : Cell → ℝ) (K : Cell) : ℝ :=
  state K - (step / mass K) *
    ∑ σ ∈ faces K, scalarUpwindFlux (coefficient K σ) (state K) (state (neighbour K σ))

/-- The exact residual coefficient of the current cell value. -/
@[nolint unusedArguments] -- Retain the common decidable-face interface used by the trajectory family.
def upwindSelfWeight {Face : Type} [DecidableEq Face]
    (faces : Finset Face) (coefficient : Face → ℝ) (mass step : ℝ) : ℝ :=
  1 - (step / mass) * ∑ σ ∈ faces, max (coefficient σ) 0

/-- The exact coefficient of the neighbouring state across a face. -/
def upwindInflowWeight (coefficient mass step : ℝ) : ℝ :=
  (step / mass) * max (-coefficient) 0

/-- Explicit time recursion from the supplied actual discrete initial state. -/
def signedUpwindTrajectory {Cell Face : Type} [DecidableEq Face]
    (faces : Cell → Finset Face) (neighbour : Cell → Face → Cell)
    (mass : Cell → ℝ) (step : ℝ) (coefficient : ℕ → Cell → Face → ℝ)
    (initial : Cell → ℝ) : ℕ → Cell → ℝ
  | 0 => initial
  | n + 1 => signedUpwindStep faces neighbour mass step (coefficient n)
      (signedUpwindTrajectory faces neighbour mass step coefficient initial n)

end NumStability.FiniteVolume
