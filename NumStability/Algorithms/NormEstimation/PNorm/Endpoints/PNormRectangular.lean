import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Analysis.Calculus.Deriv.Add
import Mathlib.Analysis.Calculus.LocalExtr.Basic
import Mathlib.Analysis.InnerProductSpace.NormPow
import Mathlib.Analysis.SpecialFunctions.Sqrt
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import ComputationalMathematics.Algorithms.LU.GrowthFactor
import ComputationalMathematics.Algorithms.NormEstimation.OneNorm.PowerMethod.CondEstimation
import ComputationalMathematics.Algorithms.NormEstimation.OneNorm.PowerMethod.PNormPowerMethod
import ComputationalMathematics.Algorithms.NormEstimation.PNorm.OneAndInfinityNorms.Rectangular
import ComputationalMathematics.Algorithms.NormEstimation.PNorm.Rectangular.PNormRectangular
import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.Analysis.MatrixNorms.Lp
import ComputationalMathematics.Analysis.SingularValues.Realification

/-!
# PNormRectangular (compatibility wrapper)

Import-only historical path, retained so existing imports of `NumStability.Algorithms.NormEstimation.PNorm.Endpoints.PNormRectangular`
keep resolving. Its whole declaration block moved unchanged to
`NumStability.Algorithms.NormEstimation.PNorm.OneAndInfinityNorms.Rectangular`, which is imported above. The module's own original imports are
re-stated so consumers that reached an identifier transitively through this
path still see the same surface. This module declares nothing.
-/
