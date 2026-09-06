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
# Algorithms.LinearSystems.Underdetermined.QR.Givens.BackwardError.Core

W04 semantic leaf; declaration commands are preserved byte-for-byte from C0006.
-/

-- Higham, Accuracy and Stability of Numerical Algorithms, 2nd ed., Chapter 21.
-- Theorem 21.4 through the concrete staged Givens QR factorization of A^T.



namespace NumStability












































































/-- Exact orthogonal witness attached to the concrete staged Givens QR
    backward-error certificate for `A^T`.

    This is a proof-selected exact factor, not a rounded formed-`Q` matrix. -/
noncomputable def higham21GivensQMethodQ
    (fp : FPModel) (m k : Nat)
    (A : Fin m -> Fin (m + k) -> Real)
    (hvalidGivens : gammaValid fp 8) :
    Fin (m + k) -> Fin (m + k) -> Real :=
  Classical.choose
    (fl_givensQRStageFold_sequence_columnFrob_backward_error_uniform
      fp (m + k) m (finiteTranspose A)
      (givensQRStageCount (m + k) m) hvalidGivens)

/-- Concrete upper-trapezoidal output of staged Givens QR applied to `A^T`. -/
noncomputable def higham21GivensQMethodRTall
    (fp : FPModel) (m k : Nat)
    (A : Fin m -> Fin (m + k) -> Real) :
    Fin (m + k) -> Fin m -> Real :=
  fl_givensQRStageFold fp (m + k) m
    (givensQRStageCount (m + k) m) (finiteTranspose A)

/-- Q-method vector obtained from the computed staged Givens `R_hat`, the
    rounded triangular solve, and the exact orthogonal certificate witness.

    A future fully rounded Givens endpoint should replace the final exact
    matrix-vector action by a stored-rotation application and prove its own
    action-error certificate. -/
noncomputable def higham21GivensQMethodOutput
    (fp : FPModel) (m k : Nat)
    (A : Fin m -> Fin (m + k) -> Real)
    (b : Fin m -> Real)
    (hvalidGivens : gammaValid fp 8) :
    Fin (m + k) -> Real :=
  let R_top : Fin m -> Fin m -> Real := fun i j =>
    higham21GivensQMethodRTall fp m k A (Fin.castAdd k i) j
  matMulVec (m + k)
    (higham21GivensQMethodQ fp m k A hvalidGivens)
    (Fin.append
      (fl_forwardSub fp m (matTranspose R_top) b)
      (0 : Fin k -> Real))
































































































end NumStability
