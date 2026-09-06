import ComputationalMathematics.Source.Higham.Chapter21.Theorem04.GivensQMethod.Closure
import ComputationalMathematics.Source.Higham.Chapter21.Theorem04.GivensQMethod.Core
import ComputationalMathematics.Source.Higham.Chapter21.Theorem04.GivensQMethod.RoundedReplay
import ComputationalMathematics.Source.Higham.Chapter21.Theorem04.ModifiedGramSchmidtQMethod.Core
import ComputationalMathematics.Source.Higham.Chapter21.Theorem04.ModifiedGramSchmidtQMethod.RoundedReplay
import ComputationalMathematics.Source.Higham.Chapter21.Theorem04.RowwiseBackwardError
import ComputationalMathematics.Source.Higham.Chapter21.Theorem04.SeminormalEquations.ActualOutput
import ComputationalMathematics.Source.Higham.Chapter21.Theorem04.SeminormalEquations.Closure
import ComputationalMathematics.Source.Higham.Chapter21.Theorem04.SeminormalEquations.EnvelopeTransfer
import ComputationalMathematics.Source.Higham.Chapter21.Theorem04.SeminormalEquations.Forward
import ComputationalMathematics.Source.Higham.Chapter21.Theorem04.SeminormalEquations.QRMajorant
import ComputationalMathematics.Source.Higham.Chapter21.Theorem04.SeminormalEquations.RemainderBounds
import ComputationalMathematics.Source.Higham.Chapter21.Theorem04.SeminormalEquations.Signed
import ComputationalMathematics.Source.Higham.Chapter21.Theorem04.SeminormalEquations.Uniform
import ComputationalMathematics.Source.Higham.Chapter21.Theorem04.SourceClosure.SourceClosure
import ComputationalMathematics.Source.Higham.Chapter21.Theorem04.SourceClosure.Supplement.Core

/-!
# Higham Chapter 21, Theorem 21.4

Complete canonical entry point for the currently migrated Theorem 21.4
row-wise backward-error measure and its concrete Householder Q-method bound.
The remaining Givens and source-closure developments stay on their historical
paths while the Chapter 21 migration continues.
-/
