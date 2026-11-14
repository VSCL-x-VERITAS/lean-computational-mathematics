/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.Normed.Module.FiniteDimension
import Mathlib.Analysis.Normed.Operator.NNNorm

/-!
# Operator-norm supremum formulas

Proof-free correspondence candidates for Bhatia, Matrix Analysis (1997),
Chapter I.2, printed page 7 / PDF page 19. Both use the prescribed operator
norm and keep the full finite-dimensional domain. The real `sSup` operation
is totalized; the source's empty-sphere convention remains an explicit issue
in the claim packets before target sealing.
-/

set_option autoImplicit false
universe u
noncomputable section

namespace NumStability.Bhatia.Chapter01.Targets

/-- The operator norm and the unit-sphere formula. -/
def operatorNormSphereCorrespondence : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    ‖A.toContinuousLinearMap‖ =
      sSup {r : ℝ | ∃ x : H, ‖x‖ = 1 ∧ r = ‖A x‖}

/-- The bilinear formula, with independently varying unit vectors. -/
def normBilinearSphereCorrespondence : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    ‖A.toContinuousLinearMap‖ =
      sSup {r : ℝ | ∃ x y : H,
        ‖x‖ = 1 ∧ ‖y‖ = 1 ∧ r = ‖inner ℂ y (A x)‖}

end NumStability.Bhatia.Chapter01.Targets
