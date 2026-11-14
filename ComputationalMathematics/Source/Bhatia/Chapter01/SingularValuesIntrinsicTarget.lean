/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.AbsoluteValue

/-!
# The full decreasing singular-value tuple

Proof-free correspondence proposal for Bhatia, *Matrix Analysis* (1997),
Chapter I.2, printed page 5 (PDF page 17). The prescribed singular values
are the eigenvalues of the actual positive absolute value, enumerated in
nonincreasing order with every zero and multiplicity retained.

The multiplicity is expressed as eigenspace dimension. For the Hermitian
absolute value, the operative spectral theorem identifies geometric and
algebraic multiplicities. Dimension zero gives the empty tuple.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- The actual dimension-length singular tuple is nonnegative, decreasing,
and enumerates each eigenvalue of the actual absolute value with its full
multiplicity. -/
noncomputable def singularValuesIntrinsic : Prop := by
  classical
  exact ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    (∀ i : Fin (Module.finrank ℂ H), 0 ≤ linearMapSingularValue A i) ∧
      Antitone (linearMapSingularValue A) ∧
      ∀ μ : ℂ,
        (Finset.univ.filter (fun i : Fin (Module.finrank ℂ H) =>
          (linearMapSingularValue A i : ℂ) = μ)).card =
            Module.finrank ℂ (Module.End.eigenspace (linearMapAbs A) μ)

end NumStability.Bhatia.Chapter01.Targets
