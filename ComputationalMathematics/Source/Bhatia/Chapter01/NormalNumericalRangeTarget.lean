/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.Convex.Hull
import Mathlib.LinearAlgebra.Eigenspace.Basic
import Mathlib.LinearAlgebra.Span.Defs

/-!
# Bhatia Exercise I.2.9: numerical ranges and eigenspaces

The universal claims concern arbitrary finite-dimensional complex Hilbert spaces.
Numerical ranges use the entire unit sphere, and convex hulls use real scalars.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- The numerical range of a normal operator is the hull of all its eigenvalues. -/
def normalNumericalRange : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    IsStarNormal A →
      {z : ℂ | ∃ x : H, ‖x‖ = 1 ∧ z = inner ℂ x (A x)} =
        convexHull ℝ {μ : ℂ | Module.End.HasEigenvalue A μ}

/-- The source possibility claim is existential, with no prescribed witness. -/
def nonnormalNumericalRangeLarger : Prop :=
  ∃ (n : ℕ) (A : Matrix (Fin n) (Fin n) ℂ),
    A * A.conjTranspose ≠ A.conjTranspose * A ∧
      convexHull ℝ {μ : ℂ | Module.End.HasEigenvalue (Matrix.toEuclideanLin A) μ} ⊂
        {z : ℂ | ∃ x : EuclideanSpace ℂ (Fin n), ‖x‖ = 1 ∧
          z = inner ℂ x (Matrix.toEuclideanLin A x)}

/-- Only the selected eigenspaces are used; the list may repeat eigenvalues. -/
def selectedEigenspaceNumericalRange : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (k : ℕ) (A : H →ₗ[ℂ] H)
      (μ : Fin k → ℂ) (x : H),
    IsStarNormal A →
    (∀ j : Fin k, Module.End.HasEigenvalue A (μ j)) →
    ‖x‖ = 1 →
    x ∈ Submodule.span ℂ {y : H | ∃ j : Fin k, y ∈ Module.End.eigenspace A (μ j)} →
      inner ℂ x (A x) ∈ convexHull ℝ (Set.range μ)

end NumStability.Bhatia.Chapter01.Targets
