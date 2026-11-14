/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.Convex.Hull

/-!
# Bhatia Chapter I: numerical ranges of normal and Hermitian operators

Exercise I.2.9, printed page 8. `W(A) = {⟨x, A x⟩ : ‖x‖ = 1}` is written out
explicitly. An eigenvalue `λ` of `A` is a scalar with `A v = λ v` for some
`v ≠ 0`. Normal means `A A* = A* A`, Hermitian means `A = A*`, with `A*` the
Hilbert adjoint. Convex hulls are real convex hulls in `ℂ`.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Exercise I.2.9(i): for normal `A`, `W(A)` is the convex hull of the
eigenvalues of `A`. -/
def numericalRangeNormalEqConvexHull : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      (A : H →ₗ[ℂ] H),
    A.comp (LinearMap.adjoint A) = (LinearMap.adjoint A).comp A →
      {z : ℂ | ∃ x : H, ‖x‖ = 1 ∧ z = inner ℂ x (A x)} =
        convexHull ℝ {lam : ℂ | ∃ v : H, v ≠ 0 ∧ A v = lam • v}

/-- Exercise I.2.9(i): for some nonnormal matrix, viewed as an operator on `ℂⁿ`,
`W(A)` is strictly bigger than the convex hull of its eigenvalues. -/
def numericalRangeNonnormalStrict : Prop :=
  ∃ (n : ℕ) (A : EuclideanSpace ℂ (Fin n) →ₗ[ℂ] EuclideanSpace ℂ (Fin n)),
    A.comp (LinearMap.adjoint A) ≠ (LinearMap.adjoint A).comp A ∧
      convexHull ℝ {lam : ℂ | ∃ v : EuclideanSpace ℂ (Fin n), v ≠ 0 ∧ A v = lam • v} ⊂
        {z : ℂ | ∃ x : EuclideanSpace ℂ (Fin n), ‖x‖ = 1 ∧ z = inner ℂ x (A x)}

/-- Exercise I.2.9(i): for Hermitian `A` with smallest eigenvalue `a` and largest
eigenvalue `b`, `W(A)` is the closed real interval `[a, b]` embedded in `ℂ`. The
hypotheses say that `a` and `b` are eigenvalues and that every eigenvalue is a
real number between them. -/
def numericalRangeHermitianInterval : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      (A : H →ₗ[ℂ] H) (a b : ℝ),
    A = LinearMap.adjoint A →
    (∃ v : H, v ≠ 0 ∧ A v = (a : ℂ) • v) →
    (∃ v : H, v ≠ 0 ∧ A v = (b : ℂ) • v) →
    (∀ lam : ℂ, (∃ v : H, v ≠ 0 ∧ A v = lam • v) → ∃ t : ℝ, lam = t ∧ a ≤ t ∧ t ≤ b) →
      {z : ℂ | ∃ x : H, ‖x‖ = 1 ∧ z = inner ℂ x (A x)} =
        (fun t : ℝ => (t : ℂ)) '' Set.Icc a b

/-- Exercise I.2.9(ii): if a unit vector `x` lies in the span of the eigenspaces
of a normal operator `A` for eigenvalues `λ₁, …, λₖ`, then `⟨x, A x⟩` lies in the
convex hull of `λ₁, …, λₖ`. -/
def normalEigenspanInnerMemConvexHull : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      (A : H →ₗ[ℂ] H) (k : ℕ) (lam : Fin k → ℂ) (x : H),
    A.comp (LinearMap.adjoint A) = (LinearMap.adjoint A).comp A →
    (∀ j, ∃ v : H, v ≠ 0 ∧ A v = lam j • v) →
    ‖x‖ = 1 →
    x ∈ (⨆ j, LinearMap.ker (A - lam j • LinearMap.id)) →
      inner ℂ x (A x) ∈ convexHull ℝ (Set.range lam)

end NumStability.Bhatia.Chapter01.Targets
