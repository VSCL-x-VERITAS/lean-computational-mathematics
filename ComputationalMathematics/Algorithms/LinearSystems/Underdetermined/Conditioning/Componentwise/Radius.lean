import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.Order.GroupWithZero.Finset
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.InnerProductSpace.Subspace
import Mathlib.Analysis.Matrix.PosDef
import Mathlib.Analysis.Matrix.Spectrum
import Mathlib.Data.Real.Basic
import Mathlib.LinearAlgebra.Basis.VectorSpace
import Mathlib.LinearAlgebra.Charpoly.ToMatrix
import Mathlib.LinearAlgebra.Eigenspace.Charpoly
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
import Mathlib.LinearAlgebra.Finsupp.Pi
import Mathlib.LinearAlgebra.Matrix.FiniteDimensional
import Mathlib.LinearAlgebra.Matrix.Irreducible.Defs
import Mathlib.LinearAlgebra.Matrix.Orthogonal
import Mathlib.LinearAlgebra.Matrix.Rank
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import ComputationalMathematics.Algorithms.CondEstimation
import ComputationalMathematics.Algorithms.DotProduct
import ComputationalMathematics.Algorithms.LU.GaussianElimination
import ComputationalMathematics.Algorithms.LU.GrowthFactor
import ComputationalMathematics.Algorithms.LU.LUSolve
import ComputationalMathematics.Algorithms.LinearSystems.Cholesky.Factorization.Spec
import ComputationalMathematics.Algorithms.LinearSystems.Cholesky.Solve.Basic
import ComputationalMathematics.Algorithms.LinearSystems.LU.Doolittle.Assembly.Core
import ComputationalMathematics.Algorithms.LinearSystems.LU.Doolittle.Basic
import ComputationalMathematics.Algorithms.LinearSystems.LU.Doolittle.Certificates
import ComputationalMathematics.Algorithms.LinearSystems.LeastSquares.AugmentedSystem
import ComputationalMathematics.Algorithms.LinearSystems.LeastSquares.Basic
import ComputationalMathematics.Algorithms.LinearSystems.LeastSquares.NormalEquations
import ComputationalMathematics.Algorithms.LinearSystems.LeastSquares.QRSolve
import ComputationalMathematics.Algorithms.LinearSystems.LeastSquares.RankGeometry
import ComputationalMathematics.Algorithms.LinearSystems.LeastSquares.StoredQR
import ComputationalMathematics.Algorithms.LinearSystems.QR.GivensQR
import ComputationalMathematics.Algorithms.LinearSystems.QR.GramSchmidt
import ComputationalMathematics.Algorithms.LinearSystems.QR.Householder.PanelApplication
import ComputationalMathematics.Algorithms.LinearSystems.QR.Householder.StoredQR
import ComputationalMathematics.Algorithms.LinearSystems.QR.Householder.TrailingPanels
import ComputationalMathematics.Algorithms.LinearSystems.QR.HouseholderQR
import ComputationalMathematics.Algorithms.LinearSystems.QR.HouseholderSpec
import ComputationalMathematics.Algorithms.LinearSystems.QR.QRSolve
import ComputationalMathematics.Algorithms.LinearSystems.Triangular.BackSubstitution
import ComputationalMathematics.Algorithms.LinearSystems.Triangular.DiagonalDominance
import ComputationalMathematics.Algorithms.LinearSystems.Triangular.ForwardSubstitution
import ComputationalMathematics.Algorithms.LinearSystems.Triangular.InverseBounds
import ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.Perturbation.FixedRadius.Radius
import ComputationalMathematics.Algorithms.MatMul
import ComputationalMathematics.Algorithms.MatVec
import ComputationalMathematics.Algorithms.TestMatrices.UpperTriangularStress
import ComputationalMathematics.Analysis.Asymptotics.Bounds
import ComputationalMathematics.Analysis.Conditioning.DistanceToSingularity
import ComputationalMathematics.Analysis.Conditioning.LinearSystems.InversePerturbation
import ComputationalMathematics.Analysis.Conditioning.LinearSystems.PerronFrobenius
import ComputationalMathematics.Analysis.Error.RoundingProducts.Core
import ComputationalMathematics.Analysis.ForwardError
import ComputationalMathematics.Analysis.LinearOperators.Basic
import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.Analysis.MatrixNorms.Basic
import ComputationalMathematics.Analysis.MatrixNorms.Comparisons
import ComputationalMathematics.Analysis.MatrixNorms.HadamardDeterminant
import ComputationalMathematics.Analysis.MatrixNorms.Lp
import ComputationalMathematics.Analysis.MatrixNorms.SpectralRadius
import ComputationalMathematics.Analysis.MatrixNorms.UnitarilyInvariant
import ComputationalMathematics.Analysis.MatrixSpectral
import ComputationalMathematics.Analysis.OperatorNorms.Basic
import ComputationalMathematics.Analysis.Perturbation.LeastSquares.AugmentedSystem
import ComputationalMathematics.Analysis.Perturbation.LeastSquares.BackwardError
import ComputationalMathematics.Analysis.Perturbation.LeastSquares.Basic
import ComputationalMathematics.Analysis.Perturbation.LeastSquares.Normwise
import ComputationalMathematics.Analysis.PerturbationTheory
import ComputationalMathematics.Analysis.Rounding
import ComputationalMathematics.Analysis.SingularValues.Basic
import ComputationalMathematics.Analysis.SingularValues.Realification
import ComputationalMathematics.Analysis.Summation.Signs
import ComputationalMathematics.Analysis.VectorNorms.Basic
import ComputationalMathematics.FloatingPoint.Model

/-!
# Algorithms.LinearSystems.Underdetermined.Conditioning.Componentwise.Radius

W04 semantic leaf; declaration commands are preserved byte-for-byte from C0006.
-/

-- Higham, Accuracy and Stability of Numerical Algorithms, 2nd ed., Chapter 21.
-- A derived fixed-radius neighborhood for Theorem 21.1 and equation (21.6).



namespace NumStability

open scoped BigOperators Matrix.Norms.Frobenius














/-- The exact rectangular condition-number product associated with a supplied
    pseudoinverse.  For the Moore--Penrose inverse this is Higham's
    `kappa_2(A) = ||A||_2 ||A^+||_2`. -/
noncomputable def higham21RectKappa2With {m n : Nat}
    (A : Fin m -> Fin n -> Real)
    (Aplus : Fin n -> Fin m -> Real) : Real :=
  higham21RectOpNorm2 A * higham21RectOpNorm2 Aplus

theorem higham21RectKappa2With_nonneg {m n : Nat}
    (A : Fin m -> Fin n -> Real)
    (Aplus : Fin n -> Fin m -> Real) :
    0 <= higham21RectKappa2With A Aplus := by
  exact mul_nonneg (higham21RectOpNorm2_nonneg A)
    (higham21RectOpNorm2_nonneg Aplus)




























































































































































































































































































































































































































































































































































































































































































































































































































































































end NumStability
