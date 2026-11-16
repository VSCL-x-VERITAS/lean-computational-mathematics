import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.LeverageScore.Core
import Mathlib.LinearAlgebra.Matrix.Rank

/-! # Proof-free contract for preservation of represented-subspace rank

The deterministic rank consequence of successful Eq. (7), CACM 59(6), p. 85.
Only the actual represented subspace is claimed to be preserved. -/
namespace NumStability.Source.DrineasMahoney.RandNLA2016.Targets

/-- Successful Eq. (7) preserves the dimension of the represented subspace.
The same linear sketch is injective throughout col(U); its application to U
has rank d; and it preserves the rank of every matrix spanning exactly col(U).
This includes the zero-dimensional case and rank-deficient input matrices. -/
def representedSubspaceRank : Prop :=
  ∀ (m d t : ℕ) (U : Matrix (Fin m) (Fin d) ℝ)
    (T : Matrix (Fin t) (Fin m) ℝ),
    HasOrthonormalColumns U →
    ∀ ε : ℝ, 0 < ε → ε < 1 →
    opNorm2Le (fun j k => idMatrix d j k - rowSketchGram (T * U) j k) ε →
      (T * U).rank = d ∧
      Set.InjOn T.mulVec (Set.range U.mulVec) ∧
      ∀ (n : ℕ) (A : Matrix (Fin m) (Fin n) ℝ),
        Set.range A.mulVec = Set.range U.mulVec → (T * A).rank = A.rank

end NumStability.Source.DrineasMahoney.RandNLA2016.Targets
