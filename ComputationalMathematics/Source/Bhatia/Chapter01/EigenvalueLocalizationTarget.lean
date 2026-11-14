/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.Complex.Norm
import Mathlib.LinearAlgebra.Eigenspace.Matrix
import Mathlib.LinearAlgebra.Matrix.Trace
import ComputationalMathematics.Analysis.SingularValues.Basic

set_option autoImplicit false

noncomputable section
namespace NumStability.Bhatia.Chapter01.Targets

/-- B45 / I.6.16 main matrix inequality only. The hint is a separate row. -/
def eigenvalueLocalization : Prop :=
  ∀ (n : ℕ) (A : Matrix (Fin n) (Fin n) ℂ) (μ : ℂ),
    Module.End.HasEigenvalue (Matrix.toLin' A) μ →
      ‖μ - Matrix.trace A / (n : ℂ)‖ ≤
        Real.sqrt
          ((((n : ℝ) - 1) / (n : ℝ)) *
            (complexMatrixFrobeniusSq A - ‖Matrix.trace A‖ ^ 2 / (n : ℝ)))

end NumStability.Bhatia.Chapter01.Targets
