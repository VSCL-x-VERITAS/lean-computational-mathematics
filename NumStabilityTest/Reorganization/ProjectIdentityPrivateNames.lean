import Lean

/-!
# Exact owner translation for historical private-name assertions

The reorganization fixtures retain their approved and retired authority spellings.
This test-only table contains exactly their owners that occur in the immutable
implementation-module map, SHA-256
`cbd53b282d8832245bb58b4c0d56958b6f15fb4810fd5da9cf748f24948429d5`.
The source-preservation checker regenerates this table and checks this helper's
fixed template. Compatibility-only owners have no invented canonical counterpart.
-/

namespace NumStabilityTest.Reorganization.ProjectIdentityPrivateNames

open Lean Elab Command

private def appendNameParts (baseName : Name) (parts : List String) : Name :=
  parts.foldl (fun name part => .str name part) baseName

private def exactOwnerMap : List (String × String) := [
  ("NumStability.Algorithms.Cholesky.CholeskyFl", "ComputationalMathematics.Algorithms.Cholesky.CholeskyFl"),
  ("NumStability.Algorithms.Cholesky.CholeskyNonsym", "ComputationalMathematics.Algorithms.Cholesky.CholeskyNonsym"),
  ("NumStability.Algorithms.Cholesky.CholeskySpec", "ComputationalMathematics.Algorithms.Cholesky.CholeskySpec"),
  ("NumStability.Algorithms.LinearSystems.Cholesky.PositiveSemidefinite.KahanTelescope.Identity", "ComputationalMathematics.Algorithms.LinearSystems.Cholesky.PositiveSemidefinite.KahanTelescope.Identity"),
  ("NumStability.Algorithms.LinearSystems.Iterative.Stationary.Semiconvergence.Projectors.FixedRange", "ComputationalMathematics.Algorithms.LinearSystems.Iterative.Stationary.Semiconvergence.Projectors.FixedRange"),
  ("NumStability.Algorithms.LinearSystems.LU.Doolittle.Assembly.Core", "ComputationalMathematics.Algorithms.LinearSystems.LU.Doolittle.Assembly.Core"),
  ("NumStability.Algorithms.LinearSystems.LeastSquares.Equality.Basic", "ComputationalMathematics.Algorithms.LinearSystems.LeastSquares.Equality.Basic"),
  ("NumStability.Algorithms.LinearSystems.QR.Householder.PanelApplication", "ComputationalMathematics.Algorithms.LinearSystems.QR.Householder.PanelApplication"),
  ("NumStability.Algorithms.LinearSystems.QR.Householder.StoredQR", "ComputationalMathematics.Algorithms.LinearSystems.QR.Householder.StoredQR"),
  ("NumStability.Algorithms.LinearSystems.Underdetermined.MinimumNorm.Solvers.Executor.Core", "ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.MinimumNorm.Solvers.Executor.Core"),
  ("NumStability.Algorithms.LinearSystems.Underdetermined.Perturbation.Bounds.Core", "ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.Perturbation.Bounds.Core"),
  ("NumStability.Algorithms.LinearSystems.Underdetermined.Perturbation.Radius.Core", "ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.Perturbation.Radius.Core"),
  ("NumStability.Algorithms.LinearSystems.Underdetermined.QR.ModifiedGramSchmidt.Rounded.Core", "ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.QR.ModifiedGramSchmidt.Rounded.Core"),
  ("NumStability.Algorithms.PolynomialEvaluation.DerivativeEvaluation.ErrorBounds", "ComputationalMathematics.Algorithms.PolynomialEvaluation.DerivativeEvaluation.ErrorBounds"),
  ("NumStability.Algorithms.RandomizedLinearAlgebra.Sampling.UniformRows.GramMoments", "ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.UniformRows.GramMoments"),
  ("NumStability.Analysis.Approximation.SineTaylor.OddDegreeFiveError.Theorems", "ComputationalMathematics.Analysis.Approximation.SineTaylor.OddDegreeFiveError.Theorems"),
  ("NumStability.Analysis.FloatingPointArithmetic.IeeeSpecialValueOperations.Results", "ComputationalMathematics.Analysis.FloatingPointArithmetic.IeeeSpecialValueOperations.Results"),
  ("NumStability.Analysis.LinearOperators.MatrixPowers.ExactNormBounds.NormalMatrices.Powers", "ComputationalMathematics.Analysis.LinearOperators.MatrixPowers.ExactNormBounds.NormalMatrices.Powers"),
  ("NumStability.Analysis.LinearOperators.MatrixPowers.Henrici.SchurBinomialBounds.Estimates", "ComputationalMathematics.Analysis.LinearOperators.MatrixPowers.Henrici.SchurBinomialBounds.Estimates"),
  ("NumStability.Analysis.LinearOperators.MatrixPowers.Semiconvergence.TriangularBlockForm", "ComputationalMathematics.Analysis.LinearOperators.MatrixPowers.Semiconvergence.TriangularBlockForm"),
  ("NumStability.Analysis.LinearOperators.MatrixPowers.Spijker.PlanarArcLength.Variation", "ComputationalMathematics.Analysis.LinearOperators.MatrixPowers.Spijker.PlanarArcLength.Variation"),
  ("NumStability.Analysis.LinearOperators.MatrixPowers.Spijker.PlanarCrossingBounds.Polynomial", "ComputationalMathematics.Analysis.LinearOperators.MatrixPowers.Spijker.PlanarCrossingBounds.Polynomial"),
  ("NumStability.Analysis.LinearOperators.NumericalRadius.Berger.GeneralPowerInequality.Powers", "ComputationalMathematics.Analysis.LinearOperators.NumericalRadius.Berger.GeneralPowerInequality.Powers"),
  ("NumStability.Analysis.LinearOperators.NumericalRadius.Berger.GeneralPowerInequality.PowersOfTwo", "ComputationalMathematics.Analysis.LinearOperators.NumericalRadius.Berger.GeneralPowerInequality.PowersOfTwo"),
  ("NumStability.Analysis.LinearOperators.NumericalRadius.Berger.Internal.HermitianEuclideanSpaceNotation", "ComputationalMathematics.Analysis.LinearOperators.NumericalRadius.Berger.Internal.HermitianEuclideanSpaceNotation"),
  ("NumStability.Analysis.LinearOperators.NumericalRadius.Core.Internal.EuclideanSpaceNotation", "ComputationalMathematics.Analysis.LinearOperators.NumericalRadius.Core.Internal.EuclideanSpaceNotation"),
  ("NumStability.Analysis.LinearOperators.Pseudospectra.Resolvent.Internal.ScalarNotation", "ComputationalMathematics.Analysis.LinearOperators.Pseudospectra.Resolvent.Internal.ScalarNotation"),
  ("NumStability.Analysis.LinearOperators.Schur.Complex.NormalTriangular.Diagonal", "ComputationalMathematics.Analysis.LinearOperators.Schur.Complex.NormalTriangular.Diagonal"),
  ("NumStability.Analysis.MatrixEquations.SylvesterExistence", "ComputationalMathematics.Analysis.MatrixEquations.SylvesterExistence"),
  ("NumStability.Analysis.Perturbation.LeastSquares.Equality.Perturbation", "ComputationalMathematics.Analysis.Perturbation.LeastSquares.Equality.Perturbation"),
  ("NumStability.Analysis.Perturbation.LeastSquares.Equality.RowwiseBackwardError", "ComputationalMathematics.Analysis.Perturbation.LeastSquares.Equality.RowwiseBackwardError"),
  ("NumStability.Analysis.Polynomials.RealRootCounting", "ComputationalMathematics.Analysis.Polynomials.RealRootCounting"),
  ("NumStability.Analysis.Statistics.SampleVariance.RoundingErrorBounds.Theorems", "ComputationalMathematics.Analysis.Statistics.SampleVariance.RoundingErrorBounds.Theorems"),
  ("NumStability.Analysis.TestMatrices.RealGinibre.ProjectiveWeightIntegral", "ComputationalMathematics.Analysis.TestMatrices.RealGinibre.ProjectiveWeightIntegral"),
  ("NumStability.Source.DrineasMahoney.RandNLA2016.Algorithm01.ElementwiseSampling.HitPairEvents", "ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Algorithm01.ElementwiseSampling.HitPairEvents"),
  ("NumStability.Source.DrineasMahoney.RandNLA2016.Equation05.GramApproximation.SampledGramEndpoints", "ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Equation05.GramApproximation.SampledGramEndpoints"),
  ("NumStability.Source.Higham.Chapter01.Problem10.TwoPassSampleVariance.RemainderBound.Theorem", "ComputationalMathematics.Source.Higham.Chapter01.Problem10.TwoPassSampleVariance.RemainderBound.Theorem"),
  ("NumStability.Source.Higham.Chapter01.Section09.SampleVariance.IeeeSingleOnePassCounterexample.Results", "ComputationalMathematics.Source.Higham.Chapter01.Section09.SampleVariance.IeeeSingleOnePassCounterexample.Results"),
  ("NumStability.Source.Higham.Chapter01.Section13.IncreasingPrecision.BinaryStorageExamples", "ComputationalMathematics.Source.Higham.Chapter01.Section13.IncreasingPrecision.BinaryStorageExamples"),
  ("NumStability.Source.Higham.Chapter01.Section14.CancellationOfRoundingErrors.Algorithm02RoundedCore", "ComputationalMathematics.Source.Higham.Chapter01.Section14.CancellationOfRoundingErrors.Algorithm02RoundedCore"),
  ("NumStability.Source.Higham.Chapter02.Problem03.AdjacentPrecisionValues.Results.Theorems", "ComputationalMathematics.Source.Higham.Chapter02.Problem03.AdjacentPrecisionValues.Results.Theorems"),
  ("NumStability.Source.Higham.Chapter02.Problem09.DoubleRounding.Counterexample.Results", "ComputationalMathematics.Source.Higham.Chapter02.Problem09.DoubleRounding.Counterexample.Results"),
  ("NumStability.Source.Higham.Chapter02.Problem10.DivisionRoundTrip.ExhaustiveBinary64.Results", "ComputationalMathematics.Source.Higham.Chapter02.Problem10.DivisionRoundTrip.ExhaustiveBinary64.Results"),
  ("NumStability.Source.Higham.Chapter02.Problem12.ReciprocalProduct.Results.Theorems", "ComputationalMathematics.Source.Higham.Chapter02.Problem12.ReciprocalProduct.Results.Theorems"),
  ("NumStability.Source.Higham.Chapter02.Problem13.ReciprocalProductThreshold.Results.Theorems", "ComputationalMathematics.Source.Higham.Chapter02.Problem13.ReciprocalProductThreshold.Results.Theorems"),
  ("NumStability.Source.Higham.Chapter02.Problem14.UnitRoundoffProbe.IeeeExamples.Results", "ComputationalMathematics.Source.Higham.Chapter02.Problem14.UnitRoundoffProbe.IeeeExamples.Results"),
  ("NumStability.Source.Higham.Chapter02.Problem21.HypotenuseNormalization.StandardModelCounterexample.Results", "ComputationalMathematics.Source.Higham.Chapter02.Problem21.HypotenuseNormalization.StandardModelCounterexample.Results"),
  ("NumStability.Source.Higham.Chapter02.Problem25.NonzeroEvaluation.IeeeFiniteSystems.Results", "ComputationalMathematics.Source.Higham.Chapter02.Problem25.NonzeroEvaluation.IeeeFiniteSystems.Results"),
  ("NumStability.Source.Higham.Chapter02.Problem28.IterativeDivisionTermination.UnderflowAwareConvergence.Results", "ComputationalMathematics.Source.Higham.Chapter02.Problem28.IterativeDivisionTermination.UnderflowAwareConvergence.Results"),
  ("NumStability.Source.Higham.Chapter02.Section06.Discriminant.FusedMultiplyAdd.Counterexample.Results", "ComputationalMathematics.Source.Higham.Chapter02.Section06.Discriminant.FusedMultiplyAdd.Counterexample.Results"),
  ("NumStability.Source.Higham.Chapter02.Section06.Discriminant.StandardModel.Counterexample.Results", "ComputationalMathematics.Source.Higham.Chapter02.Section06.Discriminant.StandardModel.Counterexample.Results"),
  ("NumStability.Source.Higham.Chapter02.Section10.ArctangentRange.Counterexample.Results", "ComputationalMathematics.Source.Higham.Chapter02.Section10.ArctangentRange.Counterexample.Results"),
  ("NumStability.Source.Higham.Chapter02.Section10.Tablemaker.FiniteSeparation.Results.Theorems", "ComputationalMathematics.Source.Higham.Chapter02.Section10.Tablemaker.FiniteSeparation.Results.Theorems"),
  ("NumStability.Source.Higham.Chapter02.Section11.AccuracyTests.CodySineResults.Theorems", "ComputationalMathematics.Source.Higham.Chapter02.Section11.AccuracyTests.CodySineResults.Theorems"),
  ("NumStability.Source.Higham.Chapter03.Problem11.KahanAbsoluteValue.IeeeDoubleTrace.Results", "ComputationalMathematics.Source.Higham.Chapter03.Problem11.KahanAbsoluteValue.IeeeDoubleTrace.Results"),
  ("NumStability.Source.Higham.Chapter04.Problem02.WilkinsonAttainability.IeeeDoubleTrace.Results", "ComputationalMathematics.Source.Higham.Chapter04.Problem02.WilkinsonAttainability.IeeeDoubleTrace.Results"),
  ("NumStability.Source.Higham.Chapter05.Algorithm01.ComplexHorner.ErrorBounds.Theorems", "ComputationalMathematics.Source.Higham.Chapter05.Algorithm01.ComplexHorner.ErrorBounds.Theorems"),
  ("NumStability.Source.Higham.Chapter05.Section02.BidiagonalDerivativeAnalysis.Results.Theorems", "ComputationalMathematics.Source.Higham.Chapter05.Section02.BidiagonalDerivativeAnalysis.Results.Theorems"),
  ("NumStability.Source.Higham.Chapter05.Section04.PatersonStockmeyer.Results.Theorems", "ComputationalMathematics.Source.Higham.Chapter05.Section04.PatersonStockmeyer.Results.Theorems"),
  ("NumStability.Source.Higham.Chapter05.Section05.FastPolynomialEvaluation.Results.Theorems", "ComputationalMathematics.Source.Higham.Chapter05.Section05.FastPolynomialEvaluation.Results.Theorems"),
  ("NumStability.Source.Higham.Chapter07.Equation17.KahanConditioningExample", "ComputationalMathematics.Source.Higham.Chapter07.Equation17.KahanConditioningExample"),
  ("NumStability.Source.Higham.Chapter07.Equation26.RumpCycle.Results.Theorems", "ComputationalMathematics.Source.Higham.Chapter07.Equation26.RumpCycle.Results.Theorems"),
  ("NumStability.Source.Higham.Chapter07.LinearSystemsConditioning.Theorem03.RectangularResults", "ComputationalMathematics.Source.Higham.Chapter07.LinearSystemsConditioning.Theorem03.RectangularResults"),
  ("NumStability.Source.Higham.Chapter07.LinearSystemsConditioning.Theorem05.RowInfinityScaleCounterexample.Theorems", "ComputationalMathematics.Source.Higham.Chapter07.LinearSystemsConditioning.Theorem05.RowInfinityScaleCounterexample.Theorems"),
  ("NumStability.Source.Higham.Chapter08.Equation02.TriangularSubstitution.RelativeInfinityNormBounds.Theorems", "ComputationalMathematics.Source.Higham.Chapter08.Equation02.TriangularSubstitution.RelativeInfinityNormBounds.Theorems"),
  ("NumStability.Source.Higham.Chapter08.Equation15.GlobalEnvelopeCounterexample.LocalCancellationResults.Theorems", "ComputationalMathematics.Source.Higham.Chapter08.Equation15.GlobalEnvelopeCounterexample.LocalCancellationResults.Theorems"),
  ("NumStability.Source.Higham.Chapter08.Equation18.FanInExecutor.FirstOrderForwardError", "ComputationalMathematics.Source.Higham.Chapter08.Equation18.FanInExecutor.FirstOrderForwardError"),
  ("NumStability.Source.Higham.Chapter08.Problem02.ComparisonMatrixWitness.ArbitraryRatios.Theorems", "ComputationalMathematics.Source.Higham.Chapter08.Problem02.ComparisonMatrixWitness.ArbitraryRatios.Theorems"),
  ("NumStability.Source.Higham.Chapter08.Problem07.DiagonalScaling.Results.Theorems", "ComputationalMathematics.Source.Higham.Chapter08.Problem07.DiagonalScaling.Results.Theorems"),
  ("NumStability.Source.Higham.Chapter08.Problem08.SingleEntrySingularity.Results.Theorems", "ComputationalMathematics.Source.Higham.Chapter08.Problem08.SingleEntrySingularity.Results.Theorems"),
  ("NumStability.Source.Higham.Chapter08.Problem09.KahanSingularValues.Results.Theorems", "ComputationalMathematics.Source.Higham.Chapter08.Problem09.KahanSingularValues.Results.Theorems"),
  ("NumStability.Source.Higham.Chapter08.Section03.TriangularSystems.ComparisonConditioningResults.Theorems", "ComputationalMathematics.Source.Higham.Chapter08.Section03.TriangularSystems.ComparisonConditioningResults.Theorems"),
  ("NumStability.Source.Higham.Chapter08.Section03.TriangularSystems.InverseNormResults.Theorems", "ComputationalMathematics.Source.Higham.Chapter08.Section03.TriangularSystems.InverseNormResults.Theorems"),
  ("NumStability.Source.Higham.Chapter09.Problems", "ComputationalMathematics.Source.Higham.Chapter09.Problems"),
  ("NumStability.Source.Higham.Chapter09.Theorem14.Actual", "ComputationalMathematics.Source.Higham.Chapter09.Theorem14.Actual"),
  ("NumStability.Source.Higham.Chapter09.Theorem14.Primitive", "ComputationalMathematics.Source.Higham.Chapter09.Theorem14.Primitive"),
  ("NumStability.Source.Higham.Chapter10.Equation30.ComplexPositiveDefinite.NoPivotLU.SourceBounds", "ComputationalMathematics.Source.Higham.Chapter10.Equation30.ComplexPositiveDefinite.NoPivotLU.SourceBounds"),
  ("NumStability.Source.Higham.Chapter10.Lemma13.KahanSharpness.OperatorNorm.SourceBound", "ComputationalMathematics.Source.Higham.Chapter10.Lemma13.KahanSharpness.OperatorNorm.SourceBound"),
  ("NumStability.Source.Higham.Chapter10.Lemma13.KahanSharpness.UnboundedGrowth.Construction", "ComputationalMathematics.Source.Higham.Chapter10.Lemma13.KahanSharpness.UnboundedGrowth.Construction"),
  ("NumStability.Source.Higham.Chapter10.Problem01.PositiveSemidefiniteEntries.EntryBounds.Results", "ComputationalMathematics.Source.Higham.Chapter10.Problem01.PositiveSemidefiniteEntries.EntryBounds.Results"),
  ("NumStability.Source.Higham.Chapter10.Section03.PositiveSemidefinite.ConstructiveFactorization.Existence", "ComputationalMathematics.Source.Higham.Chapter10.Section03.PositiveSemidefinite.ConstructiveFactorization.Existence"),
  ("NumStability.Source.Higham.Chapter10.Section03.PositiveSemidefinite.PivotingAndScaling.Results", "ComputationalMathematics.Source.Higham.Chapter10.Section03.PositiveSemidefinite.PivotingAndScaling.Results"),
  ("NumStability.Source.Higham.Chapter10.Theorem07", "ComputationalMathematics.Source.Higham.Chapter10.Theorem07"),
  ("NumStability.Source.Higham.Chapter10.Theorem07.Core.Results", "ComputationalMathematics.Source.Higham.Chapter10.Theorem07.Core.Results"),
  ("NumStability.Source.Higham.Chapter10.Theorem08.ComponentwisePerturbation.NormalizedResolvent.SourceBound", "ComputationalMathematics.Source.Higham.Chapter10.Theorem08.ComponentwisePerturbation.NormalizedResolvent.SourceBound"),
  ("NumStability.Source.Higham.Chapter10.Theorem14.CompletePivotedPSD.RankSensitiveError.Bounds", "ComputationalMathematics.Source.Higham.Chapter10.Theorem14.CompletePivotedPSD.RankSensitiveError.Bounds"),
  ("NumStability.Source.Higham.Chapter10.Theorem14.CompletePivotedPSD.SchurPerturbation.Family", "ComputationalMathematics.Source.Higham.Chapter10.Theorem14.CompletePivotedPSD.SchurPerturbation.Family"),
  ("NumStability.Source.Higham.Chapter11.Bunch.ExactTrace", "ComputationalMathematics.Source.Higham.Chapter11.Bunch.ExactTrace"),
  ("NumStability.Source.Higham.Chapter11.Bunch.SharpGrowthBridge", "ComputationalMathematics.Source.Higham.Chapter11.Bunch.SharpGrowthBridge"),
  ("NumStability.Source.Higham.Chapter11.Bunch.TraceHadamard", "ComputationalMathematics.Source.Higham.Chapter11.Bunch.TraceHadamard"),
  ("NumStability.Source.Higham.Chapter11.BunchKaufman.Exact.Growth", "ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Exact.Growth"),
  ("NumStability.Source.Higham.Chapter11.BunchKaufman.Exact.Trace", "ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Exact.Trace"),
  ("NumStability.Source.Higham.Chapter11.BunchKaufman.ExplicitInverse.Solve", "ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.ExplicitInverse.Solve"),
  ("NumStability.Source.Higham.Chapter11.BunchKaufman.ExplicitInverse.TerminalClosedForm", "ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.ExplicitInverse.TerminalClosedForm"),
  ("NumStability.Source.Higham.Chapter11.BunchKaufman.Rounded.Growth", "ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Rounded.Growth"),
  ("NumStability.Source.Higham.Chapter11.BunchKaufman.Rounded.TerminalClosedForm", "ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Rounded.TerminalClosedForm"),
  ("NumStability.Source.Higham.Chapter11.BunchKaufman.SourceCorrection", "ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.SourceCorrection"),
  ("NumStability.Source.Higham.Chapter11.Skew.SourceCorrection", "ComputationalMathematics.Source.Higham.Chapter11.Skew.SourceCorrection"),
  ("NumStability.Source.Higham.Chapter14.Problem02.TriangularInversion.TwoBlockFirstOrder.Derivations", "ComputationalMathematics.Source.Higham.Chapter14.Problem02.TriangularInversion.TwoBlockFirstOrder.Derivations"),
  ("NumStability.Source.Higham.Chapter14.Problem12.ConditionNumberExamples.StressAndPeiMatrices", "ComputationalMathematics.Source.Higham.Chapter14.Problem12.ConditionNumberExamples.StressAndPeiMatrices"),
  ("NumStability.Source.Higham.Chapter14.Problem15", "ComputationalMathematics.Source.Higham.Chapter14.Problem15"),
  ("NumStability.Source.Higham.Chapter14.Problem15.SingularValueGuards.DeterminantSignAndRelativeBounds", "ComputationalMathematics.Source.Higham.Chapter14.Problem15.SingularValueGuards.DeterminantSignAndRelativeBounds"),
  ("NumStability.Source.Higham.Chapter14.Section01.InverseErrorAnalysis.ComposedCoefficientFamilies.RemainderAsymptotics", "ComputationalMathematics.Source.Higham.Chapter14.Section01.InverseErrorAnalysis.ComposedCoefficientFamilies.RemainderAsymptotics"),
  ("NumStability.Source.Higham.Chapter14.Section01.InverseErrorAnalysis.ScaledPerturbationEndpoints.ForwardError", "ComputationalMathematics.Source.Higham.Chapter14.Section01.InverseErrorAnalysis.ScaledPerturbationEndpoints.ForwardError"),
  ("NumStability.Source.Higham.Chapter14.Section02.TriangularInversion.Method1B.BlockResidual.WholeMatrixBounds", "ComputationalMathematics.Source.Higham.Chapter14.Section02.TriangularInversion.Method1B.BlockResidual.WholeMatrixBounds"),
  ("NumStability.Source.Higham.Chapter14.Section02.TriangularInversion.Method2C.BlockResidual.LeftResidualBounds", "ComputationalMathematics.Source.Higham.Chapter14.Section02.TriangularInversion.Method2C.BlockResidual.LeftResidualBounds"),
  ("NumStability.Source.Higham.Chapter14.Theorem05.EliminationFamilies.CoefficientAsymptotics", "ComputationalMathematics.Source.Higham.Chapter14.Theorem05.EliminationFamilies.CoefficientAsymptotics"),
  ("NumStability.Source.Higham.Chapter14.Theorem05.PrintedEnvelopes.CorrectionBounds", "ComputationalMathematics.Source.Higham.Chapter14.Theorem05.PrintedEnvelopes.CorrectionBounds"),
  ("NumStability.Source.Higham.Chapter16.Foundations.Core", "ComputationalMathematics.Source.Higham.Chapter16.Foundations.Core"),
  ("NumStability.Source.Higham.Chapter16.Minimizers.Results", "ComputationalMathematics.Source.Higham.Chapter16.Minimizers.Results"),
  ("NumStability.Source.Higham.Chapter16.Problem02.Results.Core", "ComputationalMathematics.Source.Higham.Chapter16.Problem02.Results.Core"),
  ("NumStability.Source.Higham.Chapter16.QuasiRounded.Solve", "ComputationalMathematics.Source.Higham.Chapter16.QuasiRounded.Solve"),
  ("NumStability.Source.Higham.Chapter16.Spectrum.Results", "ComputationalMathematics.Source.Higham.Chapter16.Spectrum.Results"),
  ("NumStability.Source.Higham.Chapter16.VecPermutation.Notes", "ComputationalMathematics.Source.Higham.Chapter16.VecPermutation.Notes"),
  ("NumStability.Source.Higham.Chapter17.Results.Equation20.DiagonalizableBounds", "ComputationalMathematics.Source.Higham.Chapter17.Results.Equation20.DiagonalizableBounds"),
  ("NumStability.Source.Higham.Chapter17.Results.Equation29.SingularBounds", "ComputationalMathematics.Source.Higham.Chapter17.Results.Equation29.SingularBounds"),
  ("NumStability.Source.Higham.Chapter19.Sensitivity", "ComputationalMathematics.Source.Higham.Chapter19.Sensitivity"),
  ("NumStability.Source.Higham.Chapter19.Sensitivity.Bounds.Results", "ComputationalMathematics.Source.Higham.Chapter19.Sensitivity.Bounds.Results"),
  ("NumStability.Source.Higham.Chapter20.Equations", "ComputationalMathematics.Source.Higham.Chapter20.Equations"),
  ("NumStability.Source.Higham.Chapter20.Equations.Core.Results", "ComputationalMathematics.Source.Higham.Chapter20.Equations.Core.Results"),
  ("NumStability.Source.Higham.Chapter20.Lemma11", "ComputationalMathematics.Source.Higham.Chapter20.Lemma11"),
  ("NumStability.Source.Higham.Chapter20.Lemma11.Core.Results", "ComputationalMathematics.Source.Higham.Chapter20.Lemma11.Core.Results"),
  ("NumStability.Source.Higham.Chapter20.Theorem03.QRSolve", "ComputationalMathematics.Source.Higham.Chapter20.Theorem03.QRSolve"),
  ("NumStability.Source.Higham.Chapter20.Theorem04", "ComputationalMathematics.Source.Higham.Chapter20.Theorem04"),
  ("NumStability.Source.Higham.Chapter20.Theorem04.Core.Results", "ComputationalMathematics.Source.Higham.Chapter20.Theorem04.Core.Results"),
  ("NumStability.Source.Higham.Chapter21.Attainability.Results", "ComputationalMathematics.Source.Higham.Chapter21.Attainability.Results"),
  ("NumStability.Source.Higham.Chapter21.Equation09.Results.Core", "ComputationalMathematics.Source.Higham.Chapter21.Equation09.Results.Core"),
  ("NumStability.Source.Higham.Chapter21.Equation11.UniformEnvelope.Core", "ComputationalMathematics.Source.Higham.Chapter21.Equation11.UniformEnvelope.Core"),
  ("NumStability.Source.Higham.Chapter28.Equation02.DeterminantAsymptotics", "ComputationalMathematics.Source.Higham.Chapter28.Equation02.DeterminantAsymptotics"),
  ("NumStability.Source.Higham.Chapter28.Section01.HilbertConditioning.ConditionLogRate", "ComputationalMathematics.Source.Higham.Chapter28.Section01.HilbertConditioning.ConditionLogRate"),
  ("NumStability.Source.Higham.Chapter28.Section02.RealGinibre.FiniteExpectation.CharacteristicProductMoments", "ComputationalMathematics.Source.Higham.Chapter28.Section02.RealGinibre.FiniteExpectation.CharacteristicProductMoments"),
  ("NumStability.Source.Higham.Chapter28.Section02.RealGinibre.FiniteExpectation.ClosedFormAsymptotics", "ComputationalMathematics.Source.Higham.Chapter28.Section02.RealGinibre.FiniteExpectation.ClosedFormAsymptotics"),
  ("NumStability.Source.Higham.Chapter28.Section02.RealGinibre.Incidence.ExpectedCountTransfer", "ComputationalMathematics.Source.Higham.Chapter28.Section02.RealGinibre.Incidence.ExpectedCountTransfer"),
  ("NumStability.Source.Higham.Chapter28.Section02.RealGinibre.InvariantPlanes.DimensionTwoExact", "ComputationalMathematics.Source.Higham.Chapter28.Section02.RealGinibre.InvariantPlanes.DimensionTwoExact"),
  ("NumStability.Source.Higham.Chapter28.Section02.RealGinibre.InvariantPlanes.PlaneSylvesterJacobian", "ComputationalMathematics.Source.Higham.Chapter28.Section02.RealGinibre.InvariantPlanes.PlaneSylvesterJacobian"),
  ("NumStability.Source.Higham.Chapter28.Section02.RealGinibre.ProbabilityLaw.LebesgueMomentDensities", "ComputationalMathematics.Source.Higham.Chapter28.Section02.RealGinibre.ProbabilityLaw.LebesgueMomentDensities"),
  ("NumStability.Source.Higham.Chapter28.Section02.RealGinibre.RootMeasurability.EigenvalueCounts", "ComputationalMathematics.Source.Higham.Chapter28.Section02.RealGinibre.RootMeasurability.EigenvalueCounts"),
  ("NumStability.Source.Higham.Chapter28.Section02.RealGinibre.SignedIncidence.AlternatingRankSheets", "ComputationalMathematics.Source.Higham.Chapter28.Section02.RealGinibre.SignedIncidence.AlternatingRankSheets"),
  ("NumStability.Source.Higham.Chapter28.Section02.RealGinibre.SignedIncidence.OneRootMomentReduction", "ComputationalMathematics.Source.Higham.Chapter28.Section02.RealGinibre.SignedIncidence.OneRootMomentReduction"),
  ("NumStability.Source.Higham.Chapter28.Section03.RandomSVD.SingleHouseholderRankTwo", "ComputationalMathematics.Source.Higham.Chapter28.Section03.RandomSVD.SingleHouseholderRankTwo"),
  ("NumStability.Source.Higham.Chapter28.Section03.Theorem01.StewartHaar.QRFactorHaar", "ComputationalMathematics.Source.Higham.Chapter28.Section03.Theorem01.StewartHaar.QRFactorHaar"),
  ("NumStability.Source.Higham.Chapter28.Section04.Pascal.IdentityCubeRoot", "ComputationalMathematics.Source.Higham.Chapter28.Section04.Pascal.IdentityCubeRoot"),
  ("NumStability.Source.Higham.Chapter28.Section04.Pascal.MomentMatrix", "ComputationalMathematics.Source.Higham.Chapter28.Section04.Pascal.MomentMatrix"),
  ("NumStability.Source.Higham.Chapter28.Section04.Pascal.SingularizingPerturbation", "ComputationalMathematics.Source.Higham.Chapter28.Section04.Pascal.SingularizingPerturbation"),
  ("NumStability.Source.Higham.Chapter28.Section04.Pascal.TotalPositivity", "ComputationalMathematics.Source.Higham.Chapter28.Section04.Pascal.TotalPositivity"),
  ("NumStability.Source.Higham.Chapter28.Section04.ReciprocalSpectrumSPD.TriangularInvolution", "ComputationalMathematics.Source.Higham.Chapter28.Section04.ReciprocalSpectrumSPD.TriangularInvolution"),
  ("NumStability.Source.Higham.Chapter28.Section05.TridiagonalToeplitz.CharacteristicPolynomial", "ComputationalMathematics.Source.Higham.Chapter28.Section05.TridiagonalToeplitz.CharacteristicPolynomial"),
  ("NumStability.Source.Higham.Chapter28.Section05.TridiagonalToeplitz.SineEigenvectors", "ComputationalMathematics.Source.Higham.Chapter28.Section05.TridiagonalToeplitz.SineEigenvectors"),
  ("NumStability.Source.Higham.Chapter28.Section06.Companion.CharacteristicPolynomial", "ComputationalMathematics.Source.Higham.Chapter28.Section06.Companion.CharacteristicPolynomial"),
  ("NumStability.Source.Higham.Chapter28.Section06.Companion.Nonderogatory", "ComputationalMathematics.Source.Higham.Chapter28.Section06.Companion.Nonderogatory"),
  ("NumStability.Source.Higham.Chapter28.Section06.Companion.Normality", "ComputationalMathematics.Source.Higham.Chapter28.Section06.Companion.Normality"),
  ("NumStability.Source.Higham.Chapter28.Section06.Companion.SingularValues", "ComputationalMathematics.Source.Higham.Chapter28.Section06.Companion.SingularValues")
]

private def mappedOwnerPrefix? (ownerPrefix : Name) : Option Name := do
  let pair ← exactOwnerMap.find? fun pair =>
    appendNameParts `_private (pair.1.splitOn ".") == ownerPrefix
  return appendNameParts `_private (pair.2.splitOn ".")

/-- Translate only an exactly mapped owning-module prefix before its numeric
private component. Every numeric component and authored suffix is retained. -/
def migrate? : Name → Option Name
  | .anonymous => none
  | .str ownerPrefix suffix => (migrate? ownerPrefix).map fun mapped => .str mapped suffix
  | .num ownerPrefix ordinal =>
    match mappedOwnerPrefix? ownerPrefix with
    | some mapped => some (.num mapped ordinal)
    | none => (migrate? ownerPrefix).map fun mapped => .num mapped ordinal

/-- Approved presence checks may not silently fall back to an unmapped name. -/
def requireMapped (historical : Name) : CommandElabM Name := do
  match migrate? historical with
  | some mapped => return mapped
  | none => throwError "approved private owner is absent from the exact module map: {historical}"

end NumStabilityTest.Reorganization.ProjectIdentityPrivateNames
