/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.SimpleSpectrumDenseTarget
import ComputationalMathematics.Analysis.LinearOperators.Schur.Complex.SimpleSpectrumDensity

/-!
# Bhatia Chapter I: matrices with distinct eigenvalues are dense

Exercise I.2.5, printed page 7, following the printed hint. Schur
triangularisation `A = U T U*` reduces the claim to perturbing the diagonal of `T`
to an injective tuple; this is the library theorem
`NumStability.dense_matrices_simple_spectrum`. Its statement uses the
`L2` operator norm, whose topology is the entrywise product topology.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

namespace NumStability.Bhatia.Chapter01

/-- Exercise I.2.5: matrices with distinct eigenvalues are dense. -/
theorem distinctEigenvalueMatricesDense : Targets.distinctEigenvalueMatricesDense :=
  fun n => NumStability.dense_matrices_simple_spectrum n

end NumStability.Bhatia.Chapter01
