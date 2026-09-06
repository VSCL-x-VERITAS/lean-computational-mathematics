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
import ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.MinimumNorm.Pseudoinverse.UnderdeterminedSpec
import ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.SeminormalEquations.ForwardError.Forward
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
# Algorithms.LinearSystems.Underdetermined.SeminormalEquations.ForwardError.ActualOutput

W04 semantic leaf; declaration commands are preserved byte-for-byte from C0006.
-/

-- Higham, Accuracy and Stability of Numerical Algorithms, 2nd ed., Chapter 21.
-- The final transpose action and forward-error composition for the SNE method.




namespace NumStability

open scoped BigOperators

/-- The exact final `A^T` action applied to the normal-equation vector returned
    by the two rounded triangular solves. -/
noncomputable def higham21SNEExactFormedOutput
    (fp : FPModel) (m n : Nat)
    (A : Fin m -> Fin n -> Real) (R_hat : Fin m -> Fin m -> Real)
    (b : Fin m -> Real) : Fin n -> Real :=
  rectTransposeMulVec A (higham21SNEComputedNormalSolution fp m R_hat b)

/-- The algorithmic final SNE output, including the rounded matrix-vector
    product used to form `fl(A^T y_hat)`. -/
noncomputable def higham21SNEActualOutput
    (fp : FPModel) (m n : Nat)
    (A : Fin m -> Fin n -> Real) (R_hat : Fin m -> Fin m -> Real)
    (b : Fin m -> Real) : Fin n -> Real :=
  fl_matVec fp n m (finiteTranspose A)
    (higham21SNEComputedNormalSolution fp m R_hat b)

/-- Transfer the proved componentwise normal-solve envelope through `|A|^T`.
    This is the finite Euclidean envelope available before any additional
    relation between the computed `R_hat` and the rectangular input is used. -/
noncomputable def higham21SNETransferredForwardEnvelope
    (fp : FPModel) (m n : Nat)
    (A : Fin m -> Fin n -> Real)
    (AAT_inv R_hat : Fin m -> Fin m -> Real)
    (y_hat : Fin m -> Real) : Fin n -> Real :=
  rectTransposeMulVec (absMatrixRect A)
    (higham21SNEForwardEnvelope fp m AAT_inv R_hat y_hat)

theorem Higham21SNEBackwardCoefficient_nonneg_of_gammaValid
    (fp : FPModel) (m : Nat) (hm1 : gammaValid fp (m + 1)) :
    0 <= Higham21SNEBackwardCoefficient fp m := by
  have hm : gammaValid fp m := gammaValid_mono fp (by omega) hm1
  have hgm : 0 <= gamma fp m := gamma_nonneg fp hm
  have hgm1 : 0 <= gamma fp (m + 1) := gamma_nonneg fp hm1
  dsimp [Higham21SNEBackwardCoefficient]
  nlinarith [sq_nonneg (gamma fp m)]

theorem gamma_le_Higham21SNEBackwardCoefficient
    (fp : FPModel) (m : Nat) (hm1 : gammaValid fp (m + 1)) :
    gamma fp m <= Higham21SNEBackwardCoefficient fp m := by
  have hm : gammaValid fp m := gammaValid_mono fp (by omega) hm1
  have hgm : 0 <= gamma fp m := gamma_nonneg fp hm
  have hgm1 : 0 <= gamma fp (m + 1) := gamma_nonneg fp hm1
  dsimp [Higham21SNEBackwardCoefficient]
  nlinarith [sq_nonneg (gamma fp m)]

/-- The rounded formation step has the standard componentwise matrix
    backward-error representation

    `x_hat = (A + DeltaA)^T y_hat`, `|DeltaA| <= gamma_m |A|`.

    Unlike the exact-formation definition, this theorem concerns the actual
    `fl_matVec` action in `higham21SNEActualOutput`. -/
theorem higham21_sne_actual_output_formation_backward_error
    (fp : FPModel) (m n : Nat)
    (A : Fin m -> Fin n -> Real) (R_hat : Fin m -> Fin m -> Real)
    (b : Fin m -> Real) (hm : gammaValid fp m) :
    let y_hat := higham21SNEComputedNormalSolution fp m R_hat b
    ∃ DeltaA : Fin m -> Fin n -> Real,
      (forall i j, |DeltaA i j| <= gamma fp m * |A i j|) /\
      higham21SNEActualOutput fp m n A R_hat b =
        rectTransposeMulVec (fun i j => A i j + DeltaA i j) y_hat := by
  dsimp only
  obtain ⟨DeltaAT, hDeltaAT, hAction⟩ :=
    matVec_backward_error fp n m (finiteTranspose A)
      (higham21SNEComputedNormalSolution fp m R_hat b) hm
  let DeltaA : Fin m -> Fin n -> Real := fun i j => DeltaAT j i
  refine ⟨DeltaA, ?_, ?_⟩
  · intro i j
    simpa [DeltaA, finiteTranspose] using hDeltaAT j i
  · ext j
    have hj := hAction j
    simpa [higham21SNEActualOutput, DeltaA, rectTransposeMulVec,
      finiteTranspose] using hj






















































































































































































































































































































































































































































































































































































end NumStability
