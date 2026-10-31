import ComputationalMathematics.Analysis.Perturbation.LeastSquares.Wedin
import ComputationalMathematics.Analysis.SingularValues.ExtremeValues

/-!
# Full column rank through the real kernel

The least singular value is positive exactly when the real matrix action has
trivial kernel. The positivity and lower-action bounds are supplied by the
existing Wedin API; this module exposes their real-kernel interpretation.
-/

namespace NumStability

/-- A nonempty-column real matrix has trivial kernel exactly when its last
zero-padded singular value is positive. -/
theorem trivial_rectMatMulVec_kernel_iff_last_singularValue_pos {m k : ℕ}
    (A : Matrix (Fin m) (Fin (k + 1)) ℝ) :
    (∀ x : Fin (k + 1) → ℝ, rectMatMulVec A x = 0 → x = 0) ↔
      0 < rectCourantFischerSingularValue A (Fin.last k) := by
  constructor
  · intro hker
    have hinj : Function.Injective (rectMatMulVec A) := by
      intro x y hxy
      have hsub : rectMatMulVec A (fun j => x j - y j) = 0 := by
        rw [rectMatMulVec_sub, hxy]
        ext i
        simp
      exact sub_eq_zero.mp (hker (fun j => x j - y j) hsub)
    have hpos := wedinLemma20_11_sigmaMinCol_pos_of_rectMatMulVec_injective A hinj
    simpa [wedinLemma20_11_sigmaMinCol,
      realRectToCMatrix_last_singularValue_eq_rectCourantFischer] using hpos
  · intro hs x hAx
    have hscomplex : 0 < wedinLemma20_11_sigmaMinCol A := by
      simpa [wedinLemma20_11_sigmaMinCol,
        realRectToCMatrix_last_singularValue_eq_rectCourantFischer] using hs
    have hbound := wedinLemma20_11_sigmaMinCol_mul_vecNorm2_le_rectMatMulVec A x
    rw [hAx] at hbound
    have hnormzero : vecNorm2 x = 0 := by
      have hz : vecNorm2 (0 : Fin m → ℝ) = 0 := by
        simpa using (vecNorm2_zero (n := m))
      rw [hz] at hbound
      nlinarith [vecNorm2_nonneg x]
    exact funext ((vecNorm2_eq_zero_iff x).mp hnormzero)

end NumStability
