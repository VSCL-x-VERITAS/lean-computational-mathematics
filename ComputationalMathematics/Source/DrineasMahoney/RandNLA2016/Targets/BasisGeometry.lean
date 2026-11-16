import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.LeverageScore.Core
import Mathlib.LinearAlgebra.Matrix.Rank

/-! # Proof-free contracts for subspace invariance and geometry

CACM 59(6), p. 85, Eq. (6) and the prose after Eq. (7). These targets isolate
basis independence and the deterministic consequences of an embedding event;
they do not replace the separate randomized Eq. (7) construction. -/
namespace NumStability.Source.DrineasMahoney.RandNLA2016.Targets

/-- The normalized leverage law is independent of the orthonormal basis
chosen for the same positive-dimensional column space. Frame widths may be
supplied independently; orthonormality and equal ranges force consistency. -/
def leverageBasisInvariance : Prop :=
  ∀ (m n p : ℕ) (U : Matrix (Fin m) (Fin n) ℝ)
    (V : Matrix (Fin m) (Fin p) ℝ),
    0 < n → 0 < p → HasOrthonormalColumns U → HasOrthonormalColumns V →
    Set.range U.mulVec = Set.range V.mulVec →
      (U * U.transpose = V * V.transpose) ∧
      (∀ i, leverageScore U i = leverageScore V i) ∧
      (∀ i, leverageScoreProb U i = leverageScoreProb V i)

/-- Eq. (7), with ε in (0,1), preserves all squared norms in the specified
column space, is injective there, and preserves the rank of the original
matrix. `S` acts on the original vectors and `S*U` is its coordinate sketch. -/
def subspaceEmbeddingGeometry : Prop :=
  ∀ (m n d r : ℕ) (A : Matrix (Fin m) (Fin n) ℝ)
    (U : Matrix (Fin m) (Fin d) ℝ) (S : Matrix (Fin r) (Fin m) ℝ),
    HasOrthonormalColumns U →
    Set.range A.mulVec = Set.range U.mulVec →
    ∀ ε : ℝ, 0 < ε → ε < 1 →
    opNorm2Le (fun j k => idMatrix d j k - rowSketchGram (S * U) j k) ε →
      (∀ y ∈ Set.range A.mulVec,
        (1 - ε) * vecNorm2Sq y ≤ vecNorm2Sq (S.mulVec y) ∧
        vecNorm2Sq (S.mulVec y) ≤ (1 + ε) * vecNorm2Sq y) ∧
      Set.InjOn S.mulVec (Set.range A.mulVec) ∧
      (S * A).rank = A.rank

end NumStability.Source.DrineasMahoney.RandNLA2016.Targets
