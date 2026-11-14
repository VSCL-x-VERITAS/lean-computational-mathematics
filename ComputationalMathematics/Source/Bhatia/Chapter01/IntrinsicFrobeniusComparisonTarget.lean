/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.SingularValues.Basic
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.LinearAlgebra.Trace

/-!
# Intrinsic Frobenius comparison and coordinate correspondence

Proof-free propositions for Bhatia, Matrix Analysis (1997), Section I.2,
printed page 7 / PDF page 19. The comparison uses the printed operator-trace
expression. The coordinate proposition records unconditional correspondence
for every orthonormal basis, including the zero-dimensional case.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- The printed comparison with the Frobenius expression defined by operator
trace. No positivity or coordinate identity is supplied as an assumption. -/
noncomputable def operatorTraceFrobeniusComparison : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    let t := LinearMap.trace ℂ H ((LinearMap.adjoint A).comp A)
    ‖A.toContinuousLinearMap‖ ≤ Real.sqrt t.re ∧
      Real.sqrt t.re ≤ Real.sqrt (Module.finrank ℂ H : ℝ) * ‖A.toContinuousLinearMap‖

/-- The real, nonnegative trace and the entry formula in every actual
orthonormal basis. All identities are conclusions. This proposition does not
assert the separate complete singular-value correspondence. -/
noncomputable def operatorFrobeniusTraceCoordinates : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H)
      (b : OrthonormalBasis (Fin (Module.finrank ℂ H)) ℂ H),
    let t := LinearMap.trace ℂ H ((LinearMap.adjoint A).comp A)
    let M := LinearMap.toMatrix b.toBasis b.toBasis A
    t.im = 0 ∧ 0 ≤ t.re ∧
      t.re = ∑ i, ∑ j, ‖M i j‖ ^ 2 ∧
      (∀ i j, M i j = inner ℂ (b i) (A (b j))) ∧
      Real.sqrt t.re = NumStability.complexMatrixFrobenius M

end NumStability.Bhatia.Chapter01.Targets
