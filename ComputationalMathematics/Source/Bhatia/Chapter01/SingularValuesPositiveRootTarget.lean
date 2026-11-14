/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.PositiveSquareRoot

/-!
# The prescribed full decreasing singular-value tuple

Proof-free correspondence proposal for Bhatia, *Matrix Analysis* (1997),
Section I.2, printed page 5 (PDF page 17). The absolute value is the positive
square root of the actual Gram operator. Its full dimension-length eigenvalue
tuple gives the singular values, in nonincreasing order, with every zero and
multiplicity retained.

Eigenspace dimension expresses multiplicity; the Hermitian spectral context
identifies geometric and algebraic multiplicities. Dimension zero gives the
empty tuple. The root and tuple are fixed from the input operator.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- The prescribed singular tuple is nonnegative and decreasing and counts
every scalar with its full multiplicity in the actual positive absolute value. -/
noncomputable def singularValuesPositiveRootChoice : Prop := by
  classical
  exact ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    let G := (LinearMap.adjoint A).comp A
    let P := NumStability.positiveSquareRoot G
      (LinearMap.isPositive_adjoint_comp_self A)
    let hs : P.IsPositive := NumStability.positiveSquareRoot_isPositive G
      (LinearMap.isPositive_adjoint_comp_self A)
    let s : Fin (Module.finrank ℂ H) → ℝ := hs.isSymmetric.eigenvalues rfl
    (∀ i : Fin (Module.finrank ℂ H), 0 ≤ s i) ∧
      Antitone s ∧
      ∀ μ : ℂ,
        (Finset.univ.filter (fun i : Fin (Module.finrank ℂ H) =>
          (s i : ℂ) = μ)).card =
            Module.finrank ℂ (Module.End.eigenspace P μ)

end NumStability.Bhatia.Chapter01.Targets
