/-
SPDX-License-Identifier: MIT
Bhatia, Matrix Analysis (1997), Chapter I.2.
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.NumericalRangeConvexity
import ComputationalMathematics.Source.Bhatia.Chapter01.NumericalRangeTarget

/-!
# Toeplitz–Hausdorff theorem

Source correspondence for convexity of the unit-vector numerical range of a
complex matrix. The frozen finite-matrix formulation includes size zero,
where the unit-vector range is empty.
-/

namespace NumStability.Bhatia.Chapter01

/-- The numerical range in the frozen source formulation is real convex. -/
theorem toeplitzHausdorff : NumStability.bhatia01_toeplitzHausdorffTarget := by
  intro n A
  exact NumStability.convex_numerical_range (Matrix.toEuclideanLin A)

end NumStability.Bhatia.Chapter01
