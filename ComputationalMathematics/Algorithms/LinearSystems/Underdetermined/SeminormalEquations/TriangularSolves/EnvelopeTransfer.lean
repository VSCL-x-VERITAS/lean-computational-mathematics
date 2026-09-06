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
# Algorithms.LinearSystems.Underdetermined.SeminormalEquations.TriangularSolves.EnvelopeTransfer

W04 semantic leaf; declaration commands are preserved byte-for-byte from C0006.
-/

-- Higham, Accuracy and Stability of Numerical Algorithms, 2nd ed., Chapter 21.
-- Transfer of the SNE factor envelope through a QR factorization of A^T.



namespace NumStability

open scoped BigOperators

/-!
# SNE envelope transfer

The aggregate SNE theorem bounds its Gram perturbation by

  `eta * |R_hat^T| |R_hat|`.

The declarations below transport this quantity through the componentwise
Householder-QR certificate for `A^T`.  They deliberately stop at an explicit
source-data majorant.  Demmel--Higham's sharper first-order argument
(equations (3.17)--(3.20) of their 1993 paper) keeps the two triangular
perturbations separate and cancels QR factors before taking absolute values.
That cancellation is no longer present in `higham21SNEForwardEnvelope`, which
already contains `|(A A^T)^-1|`.

`Higham21SNEAggregateQRMajorantCond2Bridge` names the stronger aggregate
estimate that would be needed to fill the existing `hTransferred` premise by
this route.  It is intentionally an explicit proposition, not a claimed
consequence of the QR certificate.  The split triangular-solve certificate
retaining `DeltaR1` and `DeltaR2` is recovered below.  The genuinely missing
upstream input for the printed coefficient is the factorwise QR-cancellation
estimate consuming that certificate, corresponding to Demmel--Higham (3.18)
and (3.20).
-/

/-- Keep the two triangular-solve perturbations separate instead of collapsing
    them into the aggregate `DeltaC` returned by `sne_backward_error`.

    The equation is

    `(R_hat + DeltaR1)^T (R_hat + DeltaR2) y_hat = b`,

    with a componentwise `gamma_m` bound on each factor perturbation.  Thus the
    split certificate needed by the source proof is already available under
    the concrete SNE triangular-solve domain. -/
theorem higham21_sne_split_triangular_solve_backward_error
    (fp : FPModel) (m : Nat)
    (R_hat : Fin m -> Fin m -> Real) (b : Fin m -> Real)
    (hR_diag : forall i : Fin m, R_hat i i ≠ 0)
    (hR_upper : forall i j : Fin m, j.val < i.val -> R_hat i j = 0)
    (hm : gammaValid fp m) :
    let y_hat := higham21SNEComputedNormalSolution fp m R_hat b
    exists DeltaR1 DeltaR2 : Fin m -> Fin m -> Real,
      (forall i j, |DeltaR1 i j| <= gamma fp m * |R_hat i j|) /\
      (forall i j, |DeltaR2 i j| <= gamma fp m * |R_hat i j|) /\
      forall i,
        (∑ k : Fin m, (R_hat k i + DeltaR1 k i) *
          (∑ j : Fin m, (R_hat k j + DeltaR2 k j) * y_hat j)) = b i := by
  dsimp only [higham21SNEComputedNormalSolution]
  have hRT_diag : forall i : Fin m, R_hat i i ≠ 0 := hR_diag
  have hRT_lower : forall i j : Fin m, i.val < j.val -> R_hat j i = 0 := by
    intro i j hij
    exact hR_upper j i hij
  obtain ⟨DeltaRT1, hDeltaRT1, hForward⟩ :=
    forwardSub_backward_error fp m (fun i j : Fin m => R_hat j i) b
      hRT_diag hRT_lower hm
  obtain ⟨DeltaR2, hDeltaR2, hBackward⟩ :=
    backSub_backward_error fp m R_hat
      (fl_forwardSub fp m (fun i j : Fin m => R_hat j i) b)
      hR_diag hR_upper hm
  let DeltaR1 : Fin m -> Fin m -> Real := fun i j => DeltaRT1 j i
  refine ⟨DeltaR1, DeltaR2, ?_, hDeltaR2, ?_⟩
  · intro i j
    simpa [DeltaR1] using hDeltaRT1 j i
  · intro i
    rw [← hForward i]
    apply Finset.sum_congr rfl
    intro k hk
    rw [hBackward k]











































































































































































































































































































































































































































































































































































































































































end NumStability
