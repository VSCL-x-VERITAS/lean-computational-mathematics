import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
import ComputationalMathematics.Algorithms.LinearSystems.Cholesky.Solve.Basic
import ComputationalMathematics.Algorithms.Cholesky.CholeskySpec
import ComputationalMathematics.Algorithms.LinearSystems.LeastSquares.NormalEquations
import ComputationalMathematics.Algorithms.MatMul
import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.Analysis.Perturbation.LeastSquares.NormalEquations
import ComputationalMathematics.Analysis.PerturbationTheory
import ComputationalMathematics.Analysis.Rounding
import ComputationalMathematics.FloatingPoint.Model

/-!
# LSNormalEquations (historical compatibility wrapper)

Import-only wrapper retained so historical imports of
`NumStability.Algorithms.LeastSquares.LSNormalEquations`
keep resolving. Its declarations moved unchanged to the canonical
modules imported above. Its own historical imports are re-stated so
consumers that reached an identifier transitively through this module
still see the same surface.
-/
