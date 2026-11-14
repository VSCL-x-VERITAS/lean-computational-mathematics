/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.MatrixExponentialTarget

/-!
# Bhatia Chapter I: the matrix exponential

Exercise I.2.8, printed page 8. With the `L∞` operator norm opened as a scoped
instance in the proof, the matrices form a complete normed algebra whose topology
is the entrywise product topology, so the exponential series is summable and its
ordered partial sums converge to `exp A`. Invertibility and
`(exp A)⁻¹ = exp (-A)` are the library facts `Matrix.isUnit_exp` and
`Matrix.exp_neg`.

As in `Mathlib.Analysis.Normed.Algebra.MatrixExponential`, unifying the
operator-norm instances with the product-topology instances needs
`backward.isDefEq.respectTransparency false`.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

open Filter Topology

namespace NumStability.Bhatia.Chapter01

/-- Exercise I.2.8: the exponential series of every complex square matrix converges
to `exp A`. -/
theorem matrixExpSeriesConverges : Targets.matrixExpSeriesConverges := by
  intro n A
  open scoped Matrix.Norms.Operator in
  exact (NormedSpace.exp_series_hasSum_exp' (𝕂 := ℂ) A).tendsto_sum_nat

/-- Exercise I.2.8: every matrix exponential is invertible, with inverse `exp (-A)`. -/
theorem matrixExpInverse : Targets.matrixExpInverse := by
  intro n A
  exact ⟨Matrix.isUnit_exp A, (Matrix.exp_neg A).symm⟩

end NumStability.Bhatia.Chapter01
