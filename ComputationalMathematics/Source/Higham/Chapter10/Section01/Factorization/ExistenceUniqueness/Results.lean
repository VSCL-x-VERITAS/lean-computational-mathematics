import Mathlib.Algebra.BigOperators.Field
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Real.Sqrt
import Mathlib.LinearAlgebra.Matrix.Block
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.LinearAlgebra.Matrix.Rank
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import ComputationalMathematics.Algorithms.Cholesky.CholeskyDemmel
import ComputationalMathematics.Algorithms.Cholesky.CholeskyFl
import ComputationalMathematics.Algorithms.Cholesky.CholeskyNonsym
import ComputationalMathematics.Algorithms.Cholesky.CholeskySpec
import ComputationalMathematics.Algorithms.LU.GaussianElimination
import ComputationalMathematics.Algorithms.LinearSystems.Cholesky.ErrorAnalysis.Certificates
import ComputationalMathematics.Algorithms.LinearSystems.Cholesky.Perturbation.Basic
import ComputationalMathematics.Algorithms.LinearSystems.Cholesky.PositiveSemidefinite.Basic
import ComputationalMathematics.Algorithms.LinearSystems.Cholesky.PositiveSemidefinite.KahanMatrix
import ComputationalMathematics.Algorithms.LinearSystems.Cholesky.PositiveSemidefinite.ScaledStage
import ComputationalMathematics.Analysis.MatrixNorms.EntrywiseAbsolute.Basic
import ComputationalMathematics.Analysis.MatrixNorms.SpectralExtrema.Basic
import ComputationalMathematics.Analysis.MatrixSpectral
import ComputationalMathematics.Analysis.Rounding
import ComputationalMathematics.FloatingPoint.Model
import ComputationalMathematics.Source.Higham.Chapter09.Problems
import ComputationalMathematics.Source.Higham.Chapter09.Section01
import ComputationalMathematics.Source.Higham.Chapter09.Section02
import ComputationalMathematics.Source.Higham.Chapter09.Section03
import ComputationalMathematics.Source.Higham.Chapter09.Section04
import ComputationalMathematics.Source.Higham.Chapter09.Section05
import ComputationalMathematics.Source.Higham.Chapter09.Section06
import ComputationalMathematics.Source.Higham.Chapter09.Section08
import ComputationalMathematics.Source.Higham.Chapter09.Section10
import ComputationalMathematics.Source.Higham.Chapter09.Section11
import ComputationalMathematics.Source.Higham.Chapter10.Equation07.AbsoluteFactorNorm.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Equation29.Mathias.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Equation30.ComplexPositiveDefinite.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Lemma11.PivotSequenceStability.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Lemma13.KahanSharpness.CompletePivotingBound
import ComputationalMathematics.Source.Higham.Chapter10.Lemma13.KahanSharpness.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Problem01.PositiveSemidefiniteEntries.Basic
import ComputationalMathematics.Source.Higham.Chapter10.Problem04.UnpivotedGrowth.Basic
import ComputationalMathematics.Source.Higham.Chapter10.Problem08.LeadingMinorsCounterexample.Basic
import ComputationalMathematics.Source.Higham.Chapter10.Section01.Factorization.Basic
import ComputationalMathematics.Source.Higham.Chapter10.Section02.ErrorAnalysis.Basic
import ComputationalMathematics.Source.Higham.Chapter10.Section03.PositiveSemidefinite.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Section03.PositiveSemidefinite.Existence
import ComputationalMathematics.Source.Higham.Chapter10.Section03.PositiveSemidefinite.SchurComplement
import ComputationalMathematics.Source.Higham.Chapter10.Section03.PositiveSemidefinite.Termination
import ComputationalMathematics.Source.Higham.Chapter10.Section03.PositiveSemidefinite.WNormBound
import ComputationalMathematics.Source.Higham.Chapter10.Section04.PositiveDefiniteSymmetricPart.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Theorem06.RoundedCholesky.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Theorem07.FailureVacuity.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Theorem08.ComponentwisePerturbation.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Theorem08.NormwiseDiscrepancy.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Theorem14.CompletePivotedPSD.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Theorem14.CompletePivotedPSD.PsdErrorAnalysis

/-!
# Results

Canonical destination for 2 declaration(s) relocated from
`NumStability.Algorithms.HighamChapter10` during wave R04. Declaration names, kinds, signatures and
visibilities are unchanged; authored-private declarations keep their
names and change only their mangled module owner, per the reviewed
B0008 private-normalization map.
-/

open scoped BigOperators

namespace NumStability

/-- **Theorem 10.1**, existence of the Cholesky factorization for real SPD
matrices. -/
theorem higham10_1_cholesky_existence (n : ℕ)
    (A : Fin n → Fin n → ℝ) (hSPD : IsSymPosDef n A) :
    ∃ R : Fin n → Fin n → ℝ, higham10_1_CholeskyFactSpec n A R :=
  cholesky_existence n A hSPD

/-- **Theorem 10.1**, uniqueness of the Cholesky factorization with positive
diagonal. -/
theorem higham10_1_cholesky_uniqueness (n : ℕ)
    (A R₁ R₂ : Fin n → Fin n → ℝ)
    (h₁ : higham10_1_CholeskyFactSpec n A R₁)
    (h₂ : higham10_1_CholeskyFactSpec n A R₂) :
    ∀ i j : Fin n, R₁ i j = R₂ i j :=
  cholesky_uniqueness n A R₁ R₂ h₁ h₂

end NumStability
