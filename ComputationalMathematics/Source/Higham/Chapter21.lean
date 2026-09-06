import ComputationalMathematics.Source.Higham.Chapter21.Attainability.Results
import ComputationalMathematics.Source.Higham.Chapter21.Corrections.CorrectedMGS.RoundedReplay
import ComputationalMathematics.Source.Higham.Chapter21.Equation01.QRFoundations
import ComputationalMathematics.Source.Higham.Chapter21.Equation03.QRFoundations
import ComputationalMathematics.Source.Higham.Chapter21.Equation04.Pseudoinverse
import ComputationalMathematics.Source.Higham.Chapter21.Equation04.QRFoundations
import ComputationalMathematics.Source.Higham.Chapter21.Equation06.Perturbation
import ComputationalMathematics.Source.Higham.Chapter21.Equation07.ConditionTransfer
import ComputationalMathematics.Source.Higham.Chapter21.Equation08.EquationClosure
import ComputationalMathematics.Source.Higham.Chapter21.Equation08.ProjectorNorm
import ComputationalMathematics.Source.Higham.Chapter21.Equation08.Results.Core
import ComputationalMathematics.Source.Higham.Chapter21.Equation09.EquationClosure
import ComputationalMathematics.Source.Higham.Chapter21.Equation09.ProjectorNorm
import ComputationalMathematics.Source.Higham.Chapter21.Equation09.Results.Core
import ComputationalMathematics.Source.Higham.Chapter21.Equation10.Closure
import ComputationalMathematics.Source.Higham.Chapter21.Equation10.RoundedReplay
import ComputationalMathematics.Source.Higham.Chapter21.Equation11.ActualOutput
import ComputationalMathematics.Source.Higham.Chapter21.Equation11.Closure
import ComputationalMathematics.Source.Higham.Chapter21.Equation11.Equation
import ComputationalMathematics.Source.Higham.Chapter21.Equation11.Forward
import ComputationalMathematics.Source.Higham.Chapter21.Equation11.RemainderBounds
import ComputationalMathematics.Source.Higham.Chapter21.Equation11.Results.Core
import ComputationalMathematics.Source.Higham.Chapter21.Equation11.Scalar
import ComputationalMathematics.Source.Higham.Chapter21.Equation11.ScalarCase.Core
import ComputationalMathematics.Source.Higham.Chapter21.Equation11.Uniform
import ComputationalMathematics.Source.Higham.Chapter21.Equation11.UniformClosure
import ComputationalMathematics.Source.Higham.Chapter21.Equation11.UniformEnvelope.Core
import ComputationalMathematics.Source.Higham.Chapter21.RowScalingInvariance
import ComputationalMathematics.Source.Higham.Chapter21.Section03.MethodComparison.Core
import ComputationalMathematics.Source.Higham.Chapter21.Theorem01.Attainability.Attainability
import ComputationalMathematics.Source.Higham.Chapter21.Theorem01.ComponentwisePerturbation.Radius
import ComputationalMathematics.Source.Higham.Chapter21.Theorem01.ComponentwisePerturbation.RankStability
import ComputationalMathematics.Source.Higham.Chapter21.Theorem03
import ComputationalMathematics.Source.Higham.Chapter21.Theorem04
import ComputationalMathematics.Source.Higham.Chapter21.Theorem04.SourceClosure.Supplement.Core

/-!
# Higham Chapter 21

Canonical import-only entry point for the currently migrated row-scaling,
Theorem 21.3, and Theorem 21.4 row-wise backward-error statements from Chapter
21 of Higham's *Accuracy and Stability of Numerical Algorithms*. The broader
historical Chapter 21 surface remains available through
`NumStability.Algorithms.Underdetermined.Higham21` while migration is in
progress.
-/
