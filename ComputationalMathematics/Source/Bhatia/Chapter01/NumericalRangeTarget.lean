/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Matrix.ConjTranspose
import Mathlib.Analysis.Convex.Basic
import Mathlib.LinearAlgebra.Eigenspace.Basic

/-!
# Bhatia Chapter I: numerical range assertions

Transparent propositions for independent source review. Each local set is the
field of values defined on the Euclidean unit sphere. These declarations supply
no source theorem proofs or statement-acceptance authorizations.
-/

set_option autoImplicit false

noncomputable section
namespace NumStability

/-- I.2.numerical-range; printed page 8 (PDF20). -/
def bhatia01_numericalRangeTarget : Prop :=
  ∀ (n : ℕ) (A : Matrix (Fin n) (Fin n) ℂ) (z : ℂ),
    let W : Matrix (Fin n) (Fin n) ℂ → Set ℂ := fun B =>
      {w : ℂ | ∃ x : EuclideanSpace ℂ (Fin n), ‖x‖ = 1 ∧
        w = inner ℂ x (Matrix.toEuclideanLin B x)}
    z ∈ W A ↔
      ∃ x : EuclideanSpace ℂ (Fin n), ‖x‖ = 1 ∧
        z = inner ℂ x (Matrix.toEuclideanLin A x)

/-- I.2.range-affine; printed page 8 (PDF20). -/
def bhatia01_rangeAffineTarget : Prop :=
  ∀ (n : ℕ) (A : Matrix (Fin n) (Fin n) ℂ) (a b : ℂ),
    let W : Matrix (Fin n) (Fin n) ℂ → Set ℂ := fun B =>
      {w : ℂ | ∃ x : EuclideanSpace ℂ (Fin n), ‖x‖ = 1 ∧
        w = inner ℂ x (Matrix.toEuclideanLin B x)}
    W (a • A + b • (1 : Matrix (Fin n) (Fin n) ℂ)) =
      {z : ℂ | ∃ u : ℂ, u ∈ W A ∧
        ∃ v : ℂ, v ∈ W (1 : Matrix (Fin n) (Fin n) ℂ) ∧
          z = a * u + b * v}

/-- I.2.range-closed; printed page 8 (PDF20). -/
def bhatia01_rangeClosedTarget : Prop :=
  ∀ (n : ℕ) (A : Matrix (Fin n) (Fin n) ℂ),
    let W : Matrix (Fin n) (Fin n) ℂ → Set ℂ := fun B =>
      {w : ℂ | ∃ x : EuclideanSpace ℂ (Fin n), ‖x‖ = 1 ∧
        w = inner ℂ x (Matrix.toEuclideanLin B x)}
    IsClosed (W A)

/-- I.2.range-spectrum; printed page 8 (PDF20). -/
def bhatia01_rangeSpectrumTarget : Prop :=
  ∀ (n : ℕ) (A : Matrix (Fin n) (Fin n) ℂ) (μ : ℂ),
    let W : Matrix (Fin n) (Fin n) ℂ → Set ℂ := fun B =>
      {w : ℂ | ∃ x : EuclideanSpace ℂ (Fin n), ‖x‖ = 1 ∧
        w = inner ℂ x (Matrix.toEuclideanLin B x)}
    Module.End.HasEigenvalue (Matrix.toEuclideanLin A) μ →
      μ ∈ W A

/-- I.2.range-unitary; printed page 8 (PDF20). -/
def bhatia01_rangeUnitaryTarget : Prop :=
  ∀ (n : ℕ) (A U : Matrix (Fin n) (Fin n) ℂ),
    let W : Matrix (Fin n) (Fin n) ℂ → Set ℂ := fun B =>
      {w : ℂ | ∃ x : EuclideanSpace ℂ (Fin n), ‖x‖ = 1 ∧
        w = inner ℂ x (Matrix.toEuclideanLin B x)}
    U * U.conjTranspose = 1 → U.conjTranspose * U = 1 →
      W (U * A * U.conjTranspose) =
        W A

/-- I.2.toeplitz-hausdorff; printed page 8 (PDF20). -/
def bhatia01_toeplitzHausdorffTarget : Prop :=
  ∀ (n : ℕ) (A : Matrix (Fin n) (Fin n) ℂ),
    let W : Matrix (Fin n) (Fin n) ℂ → Set ℂ := fun B =>
      {w : ℂ | ∃ x : EuclideanSpace ℂ (Fin n), ‖x‖ = 1 ∧
        w = inner ℂ x (Matrix.toEuclideanLin B x)}
    Convex ℝ (W A)

end NumStability
