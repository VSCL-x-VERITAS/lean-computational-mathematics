import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import ComputationalMathematics.Algorithms.Cholesky.CholeskySpec
import ComputationalMathematics.Algorithms.LU.GaussianElimination
import ComputationalMathematics.Algorithms.LU.GrowthFactor
import ComputationalMathematics.Algorithms.LinearSystems.Cholesky.Perturbation.Basic
import ComputationalMathematics.Analysis.Rounding
import ComputationalMathematics.FloatingPoint.Model

/-!
# CholeskyPerturbation (compatibility module)

Import-only module retained so existing imports of `NumStability.Algorithms.Cholesky.CholeskyPerturbation`
keep resolving. Every declaration moved unchanged to the canonical
modules imported above. The module's own original imports are
re-stated so consumers reaching an identifier transitively through
this path still see the same surface.
-/

