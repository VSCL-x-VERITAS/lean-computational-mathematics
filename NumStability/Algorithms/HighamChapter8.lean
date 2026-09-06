-- NumStability/Algorithms/HighamChapter8.lean
--
-- Import-only compatibility wrapper retained by reorganization wave R03
-- (phase branch B0005, projection P0005). This historical path is preserved,
-- not deleted and not Git-renamed, so every existing `import` keeps resolving.
-- All of its declarations moved unchanged to the canonical module(s) below.

import Mathlib.Data.Finset.Max
import Mathlib.Data.Matrix.Basis
import Mathlib.Data.Sign.Basic
import Mathlib.LinearAlgebra.Matrix.ToLinearEquiv
import Mathlib.Order.Interval.Finset.Fin
import ComputationalMathematics.Algorithms.LU.GrowthFactor
import ComputationalMathematics.Algorithms.LinearSystems.Triangular
import ComputationalMathematics.Algorithms.MMatrix
import ComputationalMathematics.Algorithms.MatMul
import ComputationalMathematics.Algorithms.TestMatrices.UpperTriangularStress
import ComputationalMathematics.Source.Higham.Chapter07.LinearSystemsConditioning.ConditionNumbers
import ComputationalMathematics.Source.Higham.Chapter07.LinearSystemsConditioning.ForwardErrorKernels
import ComputationalMathematics.Source.Higham.Chapter07.LinearSystemsConditioning.Problem05
import ComputationalMathematics.Source.Higham.Chapter07.LinearSystemsConditioning.Problem09Exact
import ComputationalMathematics.Source.Higham.Chapter07.LinearSystemsConditioning.Theorem04
import ComputationalMathematics.Source.Higham.Chapter08.Equation02.TriangularSubstitution.RelativeInfinityNormBounds.Theorems
import ComputationalMathematics.Source.Higham.Chapter08.Equation14.FanInExecutor.Executor
import ComputationalMathematics.Source.Higham.Chapter08.Equation15.GlobalEnvelopeCounterexample.All
import ComputationalMathematics.Source.Higham.Chapter08.Equation15.GlobalEnvelopeCounterexample.LocalCancellationResults.Theorems
import ComputationalMathematics.Source.Higham.Chapter08.Lemma08.CorrectedCondition.RowDominance
import ComputationalMathematics.Source.Higham.Chapter08.Lemma08.Entrywise.Basic
import ComputationalMathematics.Source.Higham.Chapter08.Problem01.NoGuardSubstitution.Aliases
import ComputationalMathematics.Source.Higham.Chapter08.Problem02.ComparisonMatrixWitness.ArbitraryRatios.Theorems
import ComputationalMathematics.Source.Higham.Chapter08.Problem02.ComparisonMatrixWitness.RatioWitness
import ComputationalMathematics.Source.Higham.Chapter08.Problem03.UnitTriangularSubstitution.Bound
import ComputationalMathematics.Source.Higham.Chapter08.Problem04.MMatrixSubstitution.Comparison
import ComputationalMathematics.Source.Higham.Chapter08.Problem05.InverseNormBounds.ZInverse
import ComputationalMathematics.Source.Higham.Chapter08.Problem06.ComparisonInverseBounds.VectorBounds
import ComputationalMathematics.Source.Higham.Chapter08.Problem07.DiagonalScaling.Bounds
import ComputationalMathematics.Source.Higham.Chapter08.Problem07.DiagonalScaling.Results.Theorems
import ComputationalMathematics.Source.Higham.Chapter08.Problem08.SingleEntrySingularity.RankOne
import ComputationalMathematics.Source.Higham.Chapter08.Problem08.SingleEntrySingularity.Results.Theorems
import ComputationalMathematics.Source.Higham.Chapter08.Problem09.KahanSingularValues.KahanMatrix
import ComputationalMathematics.Source.Higham.Chapter08.Problem09.KahanSingularValues.Results.Theorems
import ComputationalMathematics.Source.Higham.Chapter08.Section01.BackwardErrorAnalysis.Core
import ComputationalMathematics.Source.Higham.Chapter08.Section02.ForwardErrorAnalysis.ComparisonBounds
import ComputationalMathematics.Source.Higham.Chapter08.Section02.ForwardErrorAnalysis.ComparisonBoundsPrelude
import ComputationalMathematics.Source.Higham.Chapter08.Section02.ForwardErrorAnalysis.NormBounds
import ComputationalMathematics.Source.Higham.Chapter08.Section03.TriangularSystems.ArbitraryOrder
import ComputationalMathematics.Source.Higham.Chapter08.Section03.TriangularSystems.ComparisonConditioningResults.Theorems
import ComputationalMathematics.Source.Higham.Chapter08.Section03.TriangularSystems.InverseBoundsLower
import ComputationalMathematics.Source.Higham.Chapter08.Section03.TriangularSystems.InverseBoundsPrelude
import ComputationalMathematics.Source.Higham.Chapter08.Section03.TriangularSystems.InverseBoundsUpper
import ComputationalMathematics.Source.Higham.Chapter08.Section03.TriangularSystems.InverseNormResults.Theorems
import ComputationalMathematics.Source.Higham.Chapter08.Section04.FanInCore.AllOrdersEnvelope
import ComputationalMathematics.Source.Higham.Chapter08.Section04.FanInCore.Factors
import ComputationalMathematics.Source.Higham.Chapter08.Section04.FanInCore.ResidualForwardBounds

/-!
# HighamChapter8 (compatibility wrapper)

Declaration-free import-only wrapper. Canonical module(s):

* `NumStability.Source.Higham.Chapter08.Equation02.TriangularSubstitution.RelativeInfinityNormBounds.Theorems`
* `NumStability.Source.Higham.Chapter08.Equation15.GlobalEnvelopeCounterexample.LocalCancellationResults.Theorems`
* `NumStability.Source.Higham.Chapter08.Problem02.ComparisonMatrixWitness.ArbitraryRatios.Theorems`
* `NumStability.Source.Higham.Chapter08.Problem07.DiagonalScaling.Results.Theorems`
* `NumStability.Source.Higham.Chapter08.Problem08.SingleEntrySingularity.Results.Theorems`
* `NumStability.Source.Higham.Chapter08.Problem09.KahanSingularValues.Results.Theorems`
* `NumStability.Source.Higham.Chapter08.Section03.TriangularSystems.ComparisonConditioningResults.Theorems`
* `NumStability.Source.Higham.Chapter08.Section03.TriangularSystems.InverseNormResults.Theorems`

Retained by wave R03 so historical imports continue to resolve unchanged.
-/
