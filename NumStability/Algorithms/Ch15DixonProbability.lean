import Mathlib.Analysis.Real.Pi.Bounds
import Mathlib.MeasureTheory.Integral.MeanInequalities
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Data.Real.Basic
import Mathlib.LinearAlgebra.Matrix.Block
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import ComputationalMathematics.Algorithms.CondEstimation
import ComputationalMathematics.Algorithms.NormEstimation.OneNorm.LINPACK.Basic
import ComputationalMathematics.Algorithms.NormEstimation.TwoNorm.Dixon.Algebra.CondEstimators
import ComputationalMathematics.Algorithms.NormEstimation.TwoNorm.Dixon.PowerBounds.CondEstimators
import ComputationalMathematics.Analysis.ConditionEstimatorLowerBound
import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.Source.Higham.Chapter15.Algorithm05.LINPACKConditionEstimator.Basic
import ComputationalMathematics.Source.Higham.Chapter15.Algorithm05.LINPACKConditionEstimator.InverseNormBound.TriangularSolve
import ComputationalMathematics.Source.Higham.Chapter15.Equation07.DixonBound.Basic
import ComputationalMathematics.Algorithms.NormEstimation.TwoNorm.Dixon.Probability.DixonProbability
import Mathlib.Analysis.InnerProductSpace.Projection.Reflection
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.UnitaryGroup
import Mathlib.MeasureTheory.Constructions.Pi
import Mathlib.Probability.Distributions.Gaussian.CharFun
import Mathlib.Probability.Distributions.Gaussian.HasGaussianLaw.Independence
import Mathlib.Probability.Distributions.Gaussian.Real
import ComputationalMathematics.Analysis.TestMatrices.Gaussian.GaussianOrthogonal
import ComputationalMathematics.Analysis.Probability.Haar.HomogeneousSpaceUniqueness
import ComputationalMathematics.Analysis.TestMatrices.Orthogonal.OrthogonalSphere
import ComputationalMathematics.Analysis.TestMatrices.Gaussian.GaussianDirection
import Mathlib.MeasureTheory.Measure.Haar.Basic
import Mathlib.MeasureTheory.Measure.Haar.Unique
import Mathlib.Topology.Bases
import Mathlib.Topology.Instances.Matrix
import ComputationalMathematics.Analysis.TestMatrices.Orthogonal.OrthogonalHaar
import ComputationalMathematics.Analysis.TestMatrices.Orthogonal.OrthogonalCoordinates

/-!
# Ch15DixonProbability (compatibility wrapper)

Declaration-free reviewed owner. Its imports are normalized to the exact
canonical and source targets that now hold the material it used to reach
through historical paths, and the historical path itself is retained so
existing imports of `NumStability.Algorithms.Ch15DixonProbability` keep resolving. This module declares nothing.
-/
