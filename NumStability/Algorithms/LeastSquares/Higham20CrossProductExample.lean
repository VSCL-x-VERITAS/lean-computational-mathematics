import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
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
import ComputationalMathematics.Source.Higham.Chapter20.Examples.CrossProduct

/-!
# Higham20CrossProductExample (historical compatibility wrapper)

Import-only wrapper retained so historical imports of
`NumStability.Algorithms.LeastSquares.Higham20CrossProductExample`
keep resolving. Its declarations moved unchanged to the canonical
modules imported above. Its own historical imports are re-stated so
consumers that reached an identifier transitively through this module
still see the same surface.
-/
