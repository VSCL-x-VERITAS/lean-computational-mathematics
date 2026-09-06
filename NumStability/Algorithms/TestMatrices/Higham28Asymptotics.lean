import Mathlib.Analysis.SpecialFunctions.Stirling
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Data.Nat.Choose.Cast
import Mathlib.Data.Nat.Choose.Sum
import Mathlib.Data.Nat.Choose.Vandermonde
import Mathlib.LinearAlgebra.Matrix.Block
import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.Analysis.TestMatrices.Cauchy.Basic
import ComputationalMathematics.Analysis.TestMatrices.Companion.Basic
import ComputationalMathematics.Analysis.TestMatrices.Hilbert.Basic
import ComputationalMathematics.Analysis.TestMatrices.Orthogonal.Basic
import ComputationalMathematics.Analysis.TestMatrices.Pascal.Basic
import ComputationalMathematics.Analysis.TestMatrices.RandomSVD.Basic
import ComputationalMathematics.Analysis.TestMatrices.Toeplitz.Basic
import ComputationalMathematics.Source.Higham.Chapter28.Equation01.HilbertInverse.Basic
import ComputationalMathematics.Source.Higham.Chapter28.Equation02.ExactHilbertDeterminant.Basic
import ComputationalMathematics.Source.Higham.Chapter28.Equation03.HilbertCholeskyFactor.Basic
import ComputationalMathematics.Source.Higham.Chapter28.Equation04.HilbertCholeskyInverse.Basic
import ComputationalMathematics.Analysis.TestMatrices.Hilbert.Exact
import ComputationalMathematics.Analysis.TestMatrices.Pascal.Exact
import ComputationalMathematics.Source.Higham.Chapter28.Equation01.HilbertInverse.Exact
import ComputationalMathematics.Source.Higham.Chapter28.Equation02.ExactHilbertDeterminant.Exact
import ComputationalMathematics.Source.Higham.Chapter28.Equation03.HilbertCholeskyFactor.Exact
import ComputationalMathematics.Analysis.TestMatrices.Hilbert.Asymptotics
import ComputationalMathematics.Source.Higham.Chapter28.Section02.RealGinibre.Asymptotics.Asymptotics

/-!
# Higham28Asymptotics (compatibility module)

Import-only module retained so existing imports of `NumStability.Algorithms.TestMatrices.Higham28Asymptotics`
keep resolving. Every declaration moved unchanged to the canonical
modules imported above. The module's own original imports are
re-stated so consumers reaching an identifier transitively through
this path still see the same surface.
-/
