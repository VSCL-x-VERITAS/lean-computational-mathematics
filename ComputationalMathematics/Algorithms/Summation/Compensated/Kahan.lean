import ComputationalMathematics.Algorithms.Summation.Compensated.Kahan.Coefficients
import ComputationalMathematics.Algorithms.Summation.Compensated.Kahan.Core
import ComputationalMathematics.Algorithms.Summation.Compensated.Kahan.ErrorBounds
import ComputationalMathematics.Algorithms.Summation.Compensated.Kahan.Exactness
import ComputationalMathematics.Algorithms.Summation.Compensated.Kahan.Finite
import ComputationalMathematics.Algorithms.Summation.Compensated.Kahan.FiniteErrorBounds
import ComputationalMathematics.Algorithms.Summation.Compensated.Kahan.FiniteFormat
import ComputationalMathematics.Algorithms.Summation.Compensated.Kahan.LocalCoefficients
import ComputationalMathematics.Algorithms.Summation.Compensated.Kahan.Majorants

/-!
# Kahan compensated summation

Declaration-free reusable entry point for Kahan execution, finite-format
certificates, coefficient engines, exactness, and conditional error bounds.
Source-specific counterexamples and corrected Higham statements live under
`NumStability.Source.Higham.Chapter04`.
-/
