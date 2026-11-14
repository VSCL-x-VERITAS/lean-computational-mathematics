/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.AbsoluteValue
import Mathlib.Analysis.Normed.Operator.NNNorm

/-!
# Operator norm and the first defined singular value

Proof-free correspondence candidate for Bhatia, Matrix Analysis (1997),
Chapter I.2, printed page 7 / PDF page 19, with the singular-value definition
on printed page 5 / PDF page 17. The norm square-root identity retains every
finite-dimensional complex space. The first singular value is selected only
by an actual legal first index in the dimension-length tuple of eigenvalues
of the actual positive absolute value. No empty-list value is supplied.

The zero-space norm is a separate source-context consequence. The printed
first-index convention at dimension zero remains an explicit source question
for independent review; this target does not claim to settle it.
-/

set_option autoImplicit false
noncomputable section
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- The universal Gram-norm identity, the first singular-value identity on its
defined index domain, and the source-context zero-space norm conclusion. -/
def normSingularDefinedDomain : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    ‖A.toContinuousLinearMap‖ =
        Real.sqrt ‖((LinearMap.adjoint A).comp A).toContinuousLinearMap‖ ∧
      (∀ i : Fin (Module.finrank ℂ H), i.val = 0 →
        ‖A.toContinuousLinearMap‖ = NumStability.linearMapSingularValue A i) ∧
      (Module.finrank ℂ H = 0 → ‖A.toContinuousLinearMap‖ = 0)

end NumStability.Bhatia.Chapter01.Targets
