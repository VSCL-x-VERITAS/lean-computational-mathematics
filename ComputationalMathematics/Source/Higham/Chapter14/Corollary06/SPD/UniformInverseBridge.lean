import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Algebra.Order.AbsoluteValue.Basic
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Analysis.Asymptotics.Lemmas
import Mathlib.Data.Finset.Max
import Mathlib.Data.Real.Basic
import Mathlib.GroupTheory.Perm.Basic
import Mathlib.LinearAlgebra.Matrix.Orthogonal
import Mathlib.Logic.Equiv.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import ComputationalMathematics.Algorithms.LU.GaussianElimination
import ComputationalMathematics.Algorithms.LU.GrowthFactor
import ComputationalMathematics.Algorithms.LU.LUSolve
import ComputationalMathematics.Algorithms.LinearSystems.Triangular.BackSubstitution
import ComputationalMathematics.Algorithms.LinearSystems.Triangular.ForwardSubstitution
import ComputationalMathematics.Algorithms.MatMul
import ComputationalMathematics.Algorithms.MatVec
import ComputationalMathematics.Algorithms.TestMatrices.UpperTriangularStress
import ComputationalMathematics.Analysis.Error.RoundingProducts.Core
import ComputationalMathematics.Analysis.FirstOrder.MatrixFamilies.AsymptoticFamilies
import ComputationalMathematics.Analysis.ForwardError
import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.Analysis.MatrixNorms.EntrywiseAbsolute.Basic
import ComputationalMathematics.Analysis.MatrixNorms.HadamardDeterminant
import ComputationalMathematics.Analysis.Perturbation.LeastSquares.Wedin
import ComputationalMathematics.Analysis.Rounding
import ComputationalMathematics.FloatingPoint.Model
import ComputationalMathematics.Source.Higham.Chapter07.Corollary06.LinearSystemsConditioning.Results
import ComputationalMathematics.Source.Higham.Chapter08.Section03.TriangularSystems.InverseBoundsPrelude
import ComputationalMathematics.Source.Higham.Chapter09.Problems
import ComputationalMathematics.Source.Higham.Chapter09.Section01
import ComputationalMathematics.Source.Higham.Chapter09.Section02
import ComputationalMathematics.Source.Higham.Chapter09.Section03
import ComputationalMathematics.Source.Higham.Chapter09.Section04
import ComputationalMathematics.Source.Higham.Chapter09.Section05
import ComputationalMathematics.Source.Higham.Chapter09.Section06
import ComputationalMathematics.Source.Higham.Chapter09.Section08
import ComputationalMathematics.Source.Higham.Chapter09.Section10
import ComputationalMathematics.Source.Higham.Chapter09.Section11
import ComputationalMathematics.Source.Higham.Chapter10.Equation07.AbsoluteFactorNorm.Endpoints
import ComputationalMathematics.Source.Higham.Chapter14.Problem15

/-!
# Chapter14 Corollary06 SPD UniformInverseBridge

Canonical destination for material split out of
`NumStability.Algorithms.Ch14Cor146UniformInverseBridge` by wave W08 of the August 2026 repository reorganization.
Declaration names, statements and proofs are unchanged; only the
module they live in has changed. The historical module still
resolves and re-exports this one.
-/

open Filter Asymptotics
open scoped BigOperators Topology
open NumStability

namespace NumStability

namespace Ch14Ext

/-- Continuity of the finite-dimensional matrix inverse turns convergence to
a nonsingular fixed matrix into entrywise `O(1)` control of the repository's
canonical inverse. -/
theorem ch14ext_nonsingInv_family_isBigOOne_of_tendsto
    {I : Type*} {l : Filter I} {n : Nat}
    {A : Fin n -> Fin n -> Real}
    {B : I -> Fin n -> Fin n -> Real}
    (hB : Tendsto B l (nhds A))
    (hdet : Matrix.det (Matrix.of A : Matrix (Fin n) (Fin n) Real) ≠ 0) :
    MatrixFamilyIsBigOOne l (fun t => nonsingInv n (B t)) := by
  have hBmat : Tendsto
      (fun t => (B t : Matrix (Fin n) (Fin n) Real)) l
      (nhds (A : Matrix (Fin n) (Fin n) Real)) := hB
  have hinvMat :=
    (continuousAt_matrix_inv (A : Matrix (Fin n) (Fin n) Real)
      (by
        simpa using
          (NormedRing.inverse_continuousAt
            (Units.mk0
              (Matrix.det (A : Matrix (Fin n) (Fin n) Real)) hdet)))).tendsto.comp hBmat
  have hinv : Tendsto (fun t => nonsingInv n (B t)) l
      (nhds (nonsingInv n A)) := by
    simpa only [nonsingInv] using hinvMat
  intro i j
  exact ((tendsto_pi_nhds.mp ((tendsto_pi_nhds.mp hinv) i)) j).isBigO_one Real

end Ch14Ext
end NumStability
