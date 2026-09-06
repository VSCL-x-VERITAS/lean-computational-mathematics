import Mathlib.LinearAlgebra.UnitaryGroup
import Mathlib.MeasureTheory.Constructions.Pi
import Mathlib.MeasureTheory.Measure.Haar.Basic
import Mathlib.Probability.Distributions.Gaussian.Real
import ComputationalMathematics.Algorithms.LinearSystems.QR.Householder.TrailingPanels
import ComputationalMathematics.Algorithms.LinearSystems.QR.HouseholderReflector
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
import ComputationalMathematics.Analysis.TestMatrices.RandomSVD.Stewart
import ComputationalMathematics.Analysis.TestMatrices.RandomSVD.StewartMeasurability
import ComputationalMathematics.Source.Higham.Chapter28.Section03.RandomSVD.SingleHouseholderRankTwo
import ComputationalMathematics.Source.Higham.Chapter28.Section03.Theorem01.StewartHaar.HaarConclusion
import ComputationalMathematics.Source.Higham.Chapter28.Section03.Theorem01.StewartHaar.Stewart
import ComputationalMathematics.Source.Higham.Chapter28.Section03.RandomSVD.RandsvdNorm

/-!
# Higham28RandsvdNorm (compatibility module)

Import-only module retained so existing imports of `NumStability.Algorithms.TestMatrices.Higham28RandsvdNorm`
keep resolving. Every declaration moved unchanged to the canonical
modules imported above. The module's own original imports are
re-stated so consumers reaching an identifier transitively through
this path still see the same surface.
-/
