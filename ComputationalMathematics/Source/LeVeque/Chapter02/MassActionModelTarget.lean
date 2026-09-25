/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BalanceLaw
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity
import Mathlib.Data.Matrix.Mul

/-!
# LeVeque Chapter 2: MassActionModelTarget

Target for the transported mass-action species model.
-/

open scoped BigOperators

namespace NumStability.Leveque02Tracer

/-- The rate of one irreversible reaction channel. A reversible reaction can be
represented by two channels with exchanged input and output stoichiometries. -/
def massActionRate {m n : ℕ} (input : Fin n → Fin m → ℕ)
    (rateConstant : Fin n → ℝ) (state : Fin m → ℝ) (r : Fin n) : ℝ :=
  rateConstant r * ∏ i : Fin m, state i ^ input r i

/-- Net species production from finitely many reaction channels. -/
def massActionSource {m n : ℕ} (input output : Fin n → Fin m → ℕ)
    (rateConstant : Fin n → ℝ) (state : Fin m → ℝ) : Fin m → ℝ :=
  fun i => ∑ r : Fin n,
    ((output r i : ℝ) - (input r i : ℝ)) *
      massActionRate input rateConstant state r

/-- Model-form statement for LeVeque Chapter 2, C2.U.019.
The coefficient is the common-velocity scalar matrix, and the source is the
stoichiometric mass-action production vector. -/
def massActionModelTarget : Prop :=
  ∀ (m n : ℕ) (velocity : ℝ)
    (input output : Fin n → Fin m → ℕ) (rateConstant : Fin n → ℝ),
    0 < m → 0 < n → (∀ r, 0 ≤ rateConstant r) →
    let coefficient : Matrix (Fin m) (Fin m) ℝ :=
      Matrix.diagonal (fun _ => velocity)
    IsRealHyperbolicMatrix coefficient ∧
      ∀ (q : ℝ → ℝ → (Fin m → ℝ))
        (spatialDerivative : Fin m → ℝ) (x t : ℝ),
        (∀ ξ τ i, 0 ≤ q ξ τ i) →
        HasDerivAt (fun ξ => q ξ t) spatialDerivative x →
        (IsBalanceLawSolutionAt q (fun state => velocity • state)
            (massActionSource input output rateConstant (q x t)) x t ↔
          ∃ timeDerivative : Fin m → ℝ,
            HasDerivAt (fun τ => q x τ) timeDerivative t ∧
            timeDerivative + coefficient.mulVec spatialDerivative =
              massActionSource input output rateConstant (q x t))

end NumStability.Leveque02Tracer
