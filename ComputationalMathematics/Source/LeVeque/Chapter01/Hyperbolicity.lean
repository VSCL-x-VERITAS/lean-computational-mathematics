/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation01

/-!
# LeVeque Chapter 1, hyperbolic constant-coefficient systems

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 3 (raw PDF page 25).  A constant-coefficient system is called
hyperbolic when its real coefficient matrix has `m` linearly independent real
eigenvectors; these eigenvectors form a basis and hence give every state a
unique decomposition.
-/

open scoped BigOperators

namespace NumStability

/-- LeVeque's Chapter 1 hyperbolicity condition for the coefficient matrix in
equation (1.1). -/
abbrev leveque01IsHyperbolicMatrix {m : ℕ}
    (coefficient : Matrix (Fin m) (Fin m) ℝ) : Prop :=
  IsRealHyperbolicMatrix coefficient

/-- LeVeque's hyperbolicity definition is exactly the existence of `m`
linearly independent corresponding real eigenvectors. -/
theorem leveque01_hyperbolicMatrixDefinition {m : ℕ}
    (coefficient : Matrix (Fin m) (Fin m) ℝ) :
    leveque01IsHyperbolicMatrix coefficient ↔
      ∃ (eigenvalues : Fin m → ℝ)
          (eigenvectors : Fin m → (Fin m → ℝ)),
        LinearIndependent ℝ eigenvectors ∧
          ∀ p, coefficient.mulVec (eigenvectors p) =
            eigenvalues p • eigenvectors p :=
  isRealHyperbolicMatrix_iff_independent_real_eigenvectors coefficient

/-- For a hyperbolic coefficient matrix, every state has one and only one
linear decomposition in a corresponding real eigenbasis. -/
theorem leveque01_hyperbolicMatrix_uniqueEigenbasisDecomposition
    {m : ℕ} {coefficient : Matrix (Fin m) (Fin m) ℝ}
    (hcoefficient : leveque01IsHyperbolicMatrix coefficient) :
    ∃ (eigenvalues : Fin m → ℝ)
        (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ)),
      (∀ p, coefficient.mulVec (eigenbasis p) =
        eigenvalues p • eigenbasis p) ∧
      ∀ q : Fin m → ℝ,
        ∃! amplitudes : Fin m → ℝ,
          ∑ p, amplitudes p • eigenbasis p = q :=
  hcoefficient.exists_unique_eigenbasis_decomposition

end NumStability
