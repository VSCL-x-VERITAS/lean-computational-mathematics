import Mathlib.Algebra.BigOperators.Field
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Data.Real.Basic
import Mathlib.Data.Real.Sqrt
import Mathlib.LinearAlgebra.Matrix.Block
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.LinearAlgebra.Matrix.Rank
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import ComputationalMathematics.Algorithms.Cholesky.CholeskySpec
import ComputationalMathematics.Algorithms.LU.GaussianElimination
import ComputationalMathematics.Algorithms.LinearSystems.Cholesky.PositiveSemidefinite.Basic
import ComputationalMathematics.Algorithms.LinearSystems.Cholesky.PositiveSemidefinite.PivotedFactorization.Existence
import ComputationalMathematics.Analysis.Rounding
import ComputationalMathematics.FloatingPoint.Model
import ComputationalMathematics.Source.Higham.Chapter10.Lemma13.KahanSharpness.CompletePivotingBound
import ComputationalMathematics.Source.Higham.Chapter10.Problem01.PositiveSemidefiniteEntries.EntryBounds.Results
import ComputationalMathematics.Source.Higham.Chapter10.Section03.PositiveSemidefinite.ConstructiveFactorization.Existence
import ComputationalMathematics.Source.Higham.Chapter10.Section03.PositiveSemidefinite.Existence
import ComputationalMathematics.Source.Higham.Chapter10.Section03.PositiveSemidefinite.QuadraticFormBounds.WeightedNorm
import ComputationalMathematics.Source.Higham.Chapter10.Section03.PositiveSemidefinite.SchurComplement
import ComputationalMathematics.Source.Higham.Chapter10.Section03.PositiveSemidefinite.Termination
import ComputationalMathematics.Source.Higham.Chapter10.Section03.PositiveSemidefinite.TrailingTermination.Bound
import ComputationalMathematics.Source.Higham.Chapter10.Section03.PositiveSemidefinite.WNormBound
import ComputationalMathematics.Source.Higham.Chapter10.Theorem14.CompletePivotedPSD.PsdErrorAnalysis
import ComputationalMathematics.Source.Higham.Chapter10.Theorem14.CompletePivotedPSD.RoundedErrorAnalysis.Bounds

/-!
# CholeskyPSD (compatibility module)

Import-only module retained so existing imports of `NumStability.Algorithms.Cholesky.CholeskyPSD` keep
resolving. Every declaration moved unchanged to the routed canonical
destination(s). The module's own original imports are re-stated so
consumers reaching an identifier transitively through this path still
see the same surface.
-/
