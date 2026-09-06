import Mathlib.Algebra.BigOperators.Field
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Real.Sqrt
import Mathlib.LinearAlgebra.Matrix.Block
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.LinearAlgebra.Matrix.Rank
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import ComputationalMathematics.Algorithms.LU.GaussianElimination
import ComputationalMathematics.Algorithms.LU.GrowthFactor
import ComputationalMathematics.Algorithms.LU.LUSolve
import ComputationalMathematics.Algorithms.LinearSystems.Triangular.BackSubstitution
import ComputationalMathematics.Algorithms.LinearSystems.Triangular.ForwardSubstitution
import ComputationalMathematics.Analysis.MatrixSpectral
import ComputationalMathematics.Analysis.Rounding
import ComputationalMathematics.Analysis.SubtractionFold
import ComputationalMathematics.Analysis.Summation.ErrorBounds
import ComputationalMathematics.FloatingPoint.Model

/-!
# NumStability Algorithms LinearSystems Cholesky PositiveSemidefinite KahanMatrix

Canonical destination for material split out of
`NumStability.Algorithms.HighamChapter10` by wave W03 of the August 2026 repository reorganization.
Declaration names, statements and proofs are unchanged; only the
module they live in has changed. The historical module still
resolves and re-exports this one.
-/

open scoped BigOperators

namespace NumStability

/-- **The display-(10.20) Kahan family** (Higham p. 205):
    `R(θ) = diag(1, s, …, s^{r−1})·U` with `U` unit upper triangular
    and all entries above the diagonal equal to `−c` — stated over
    abstract `c, s` with `c² + s² = 1`. -/
noncomputable def kahanR (r n : ℕ) (c s : ℝ) :
    Fin r → Fin n → ℝ :=
  fun i j =>
    if j.val = i.val then s ^ i.val
    else if i.val < j.val then -c * s ^ i.val else 0

end NumStability
