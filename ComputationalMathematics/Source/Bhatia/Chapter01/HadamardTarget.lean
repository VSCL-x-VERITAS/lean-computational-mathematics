/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

/-! Proof-free source targets for Bhatia, *Matrix Analysis* (1997),
Exercise I.1.3, printed page 3 (PDF page 15): Hadamard's determinant bound
and its full equality characterization. -/

set_option autoImplicit false

namespace NumStability.Bhatia.Chapter01.Targets

/-- Hadamard's inequality for every square complex matrix, including singular
matrices and matrices with zero columns. The column norm is the Hilbert norm. -/
def hadamardBound : Prop :=
  ∀ (n : ℕ) (A : Matrix (Fin n) (Fin n) ℂ),
    let X : Fin n → EuclideanSpace ℂ (Fin n) :=
      fun j => WithLp.toLp 2 (fun i => A i j)
    ‖A.det‖ ≤ ∏ j, ‖X j‖

/-- Equality in Hadamard's inequality holds exactly for pairwise orthogonal
columns or when at least one column is zero. -/
def hadamardEquality : Prop :=
  ∀ (n : ℕ) (A : Matrix (Fin n) (Fin n) ℂ),
    let X : Fin n → EuclideanSpace ℂ (Fin n) :=
      fun j => WithLp.toLp 2 (fun i => A i j)
    (‖A.det‖ = ∏ j, ‖X j‖) ↔
      (Pairwise fun i j => inner ℂ (X i) (X j) = 0) ∨ ∃ j, X j = 0

end NumStability.Bhatia.Chapter01.Targets
