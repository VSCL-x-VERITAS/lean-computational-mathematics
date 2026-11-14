/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Positive
import Mathlib.Analysis.Normed.Module.FiniteDimension
import Mathlib.Analysis.Normed.Operator.NNNorm

/-!
# Positive contraction criterion

Proof-free correspondence target for Bhatia, Matrix Analysis (1997),
Chapter I.2, printed page 7 / PDF page 19. Positivity is Hermitian
positive semidefiniteness, the norm is the actual operator norm, and
the comparison with the identity uses the Loewner order. The complete
finite-dimensional complex domain includes dimension zero.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- A positive operator is contractive exactly when it is below the identity
in the actual Loewner order. Dimension zero is included. -/
def positiveContraction : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    A.IsPositive →
      (‖A.toContinuousLinearMap‖ ≤ 1 ↔ A ≤ (LinearMap.id : H →ₗ[ℂ] H))

end NumStability.Bhatia.Chapter01.Targets
