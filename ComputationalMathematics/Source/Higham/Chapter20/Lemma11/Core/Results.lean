import ComputationalMathematics.Analysis.SingularValues.PseudoinverseNorm
import ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.MinimumNorm.Solvers.UnderdeterminedSpec
import ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.MinimumNorm.Specifications.UnderdeterminedSpec
import ComputationalMathematics.Source.Higham.Chapter21.Equation04.UnderdeterminedSpec
import ComputationalMathematics.Source.Higham.Chapter21.Equation05.UnderdeterminedSpec
import ComputationalMathematics.Source.Higham.Chapter21.Lemma02.Symmetrization.UnderdeterminedSpec
import ComputationalMathematics.Source.Higham.Chapter21.Theorem01.ComponentwisePerturbation.UnderdeterminedSpec
import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.Analysis.MatrixNorms.Basic
import ComputationalMathematics.Analysis.Perturbation.LeastSquares.Wedin
import ComputationalMathematics.Analysis.SingularValues.Basic
import ComputationalMathematics.Analysis.SingularValues.Realification
import ComputationalMathematics.Analysis.SingularValues.WeylMirsky

namespace NumStability

open ComplexOrder
open scoped BigOperators

/-!
# Higham Chapter 20 — Lemma11

Canonical source correspondence module extracted without change from Higham20Lemma20_11.
-/

private theorem realRect_diff_euclideanLin_bound
    {m n : ℕ} (A B : Fin m → Fin n → ℝ)
    (x : EuclideanSpace ℂ (Fin n)) :
    ‖complexMatrixEuclideanLin (realRectToCMatrix B) x -
        complexMatrixEuclideanLin (realRectToCMatrix A) x‖ ≤
      complexMatrixOp2 (realRectToCMatrix (fun r c => B r c - A r c)) * ‖x‖ := by
  have heq :
      complexMatrixEuclideanLin (realRectToCMatrix B) x -
          complexMatrixEuclideanLin (realRectToCMatrix A) x =
        complexMatrixEuclideanLin
          (realRectToCMatrix (fun r c => B r c - A r c)) x := by
    apply WithLp.ofLp_injective
    ext r
    change (∑ c : Fin n, (B r c : ℂ) * WithLp.ofLp x c) -
        (∑ c : Fin n, (A r c : ℂ) * WithLp.ofLp x c) =
      ∑ c : Fin n, ((B r c - A r c : ℝ) : ℂ) * WithLp.ofLp x c
    rw [← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl
    intro c _
    push_cast
    ring
  rw [heq, complexMatrixOp2_eq_norm_euclideanLin]
  exact ContinuousLinearMap.le_opNorm
    (complexMatrixEuclideanLin
      (realRectToCMatrix (fun r c => B r c - A r c))).toContinuousLinearMap x
/-- Higham, 2nd ed., Lemma 20.11 for arbitrary real rectangular matrices of
the same positive rank: if `η = ||A⁺||₂ ||B-A||₂ < 1`, then
`||B⁺||₂ ≤ ||A⁺||₂ / (1-η)`. -/
theorem higham20_lemma20_11_equalPositiveRank_pseudoinverse_op2_le
    {m n : ℕ} (A B : Fin m → Fin n → ℝ)
    (Aplus Bplus : Fin n → Fin m → ℝ) (i : Fin n) {eta : ℝ}
    (hAmp : RectMoorePenrosePseudoinverse m n A Aplus)
    (hBmp : RectMoorePenrosePseudoinverse m n B Bplus)
    (hArank : complexMatrixRank (realRectToCMatrix A) = i.1 + 1)
    (hBrank : complexMatrixRank (realRectToCMatrix B) = i.1 + 1)
    (heta : eta = complexMatrixOp2 (realRectToCMatrix Aplus) *
      complexMatrixOp2 (realRectToCMatrix (fun r c => B r c - A r c)))
    (hsmall : eta < 1) :
    complexMatrixOp2 (realRectToCMatrix Bplus) ≤
      complexMatrixOp2 (realRectToCMatrix Aplus) / (1 - eta) := by
  let CA := realRectToCMatrix A
  let CB := realRectToCMatrix B
  let CAp := realRectToCMatrix Aplus
  let CBp := realRectToCMatrix Bplus
  let delta := complexMatrixOp2
    (realRectToCMatrix (fun r c => B r c - A r c))
  let sigmaA := complexMatrixSingularValue CA i
  let sigmaB := complexMatrixSingularValue CB i
  have hsigmaA_ne : sigmaA ≠ 0 :=
    Pseudoinverse.singularValue_ne_zero_iff_le_rankIndex CA i hArank i |>.2 le_rfl
  have hsigmaA_pos : 0 < sigmaA :=
    lt_of_le_of_ne' (complexMatrixSingularValue_nonneg CA i) hsigmaA_ne
  have hAnorm : complexMatrixOp2 CAp = 1 / sigmaA :=
    higham20_lemma20_11_pseudoinverse_op2_eq_recip_rankSingular
      A Aplus i hAmp hArank
  have hBnorm : complexMatrixOp2 CBp = 1 / sigmaB :=
    higham20_lemma20_11_pseudoinverse_op2_eq_recip_rankSingular
      B Bplus i hBmp hBrank
  have hgap : sigmaA - delta ≤ sigmaB := by
    have habs :=
      Ch14Ext.ch14ext_singularValue_abs_sub_le_of_euclideanLin_diff_bound
        CA CB (M := delta) (fun x => realRect_diff_euclideanLin_bound A B x) i
    rw [abs_le] at habs
    linarith
  have hApos : 0 < complexMatrixOp2 CAp := by
    rw [hAnorm]
    exact one_div_pos.mpr hsigmaA_pos
  have hsigmaA_recip : sigmaA = 1 / complexMatrixOp2 CAp := by
    rw [hAnorm]
    field_simp [hsigmaA_ne]
  exact wedinLemma20_11_pinvNorm_le_of_singularValue_gap
    (Aplus_norm := complexMatrixOp2 CAp)
    (Bplus_norm := complexMatrixOp2 CBp)
    (delta := delta) (eta := eta) (sigmaA := sigmaA) (sigmaB := sigmaB)
    hApos (by simpa [CAp, delta] using heta) hsmall hsigmaA_recip hBnorm hgap
private theorem realRect_eq_zero_of_complexMatrixRank_eq_zero
    {m n : ℕ} (A : Fin m → Fin n → ℝ)
    (hrank : complexMatrixRank (realRectToCMatrix A) = 0) :
    A = 0 := by
  let C := realRectToCMatrix A
  let L := complexMatrixEuclideanLin C
  have hrange : Module.finrank ℂ (LinearMap.range L) = 0 := by
    rw [← complexMatrixRank_eq_finrank_range_euclideanLin]
    exact hrank
  have hsub : Subsingleton (LinearMap.range L) :=
    Module.finrank_zero_iff.mp hrange
  have hLzero : L = 0 := by
    apply LinearMap.ext
    intro x
    let y : LinearMap.range L := ⟨L x, ⟨x, rfl⟩⟩
    have hy : y = 0 := @Subsingleton.elim _ hsub y 0
    exact congrArg Subtype.val hy
  have hCzero : C = 0 := by
    calc
      C = LinearMap.toMatrix (complexEuclideanBasisFin n)
          (complexEuclideanBasisFin m) L := by
            exact (complexMatrixEuclideanLin_toMatrix C).symm
      _ = 0 := by rw [hLzero]; simp
  ext r c
  have hentry := congrFun (congrFun hCzero r) c
  change (A r c : ℂ) = 0 at hentry
  exact_mod_cast hentry
private theorem pseudoinverse_eq_zero_of_complexMatrixRank_eq_zero
    {m n : ℕ} (A : Fin m → Fin n → ℝ) (Aplus : Fin n → Fin m → ℝ)
    (hMP : RectMoorePenrosePseudoinverse m n A Aplus)
    (hrank : complexMatrixRank (realRectToCMatrix A) = 0) :
    Aplus = 0 := by
  have hAzero := realRect_eq_zero_of_complexMatrixRank_eq_zero A hrank
  have hrep := hMP.reproduces_pseudoinverse
  rw [hAzero] at hrep
  have hinner :
      rectMatMul Aplus (0 : Fin m → Fin n → ℝ) =
        (0 : Fin n → Fin n → ℝ) := by
    ext i j
    simp [rectMatMul]
  have houter :
      rectMatMul (0 : Fin n → Fin n → ℝ) Aplus =
        (0 : Fin n → Fin m → ℝ) := by
    ext i j
    simp [rectMatMul]
  rw [hinner, houter] at hrep
  exact hrep.symm
/-- Higham, 2nd ed., Lemma 20.11 at full rectangular generality.  Equal rank
may be zero; otherwise the common rank selects the last positive singular
value and the positive-rank theorem applies.  Thus, for arbitrary real
`m × n` matrices and supplied Moore--Penrose inverses,
`η = ||A⁺||₂ ||B-A||₂ < 1` implies
`||B⁺||₂ ≤ ||A⁺||₂ / (1-η)`. -/
theorem higham20_lemma20_11_equalRank_pseudoinverse_op2_le
    {m n : ℕ} (A B : Fin m → Fin n → ℝ)
    (Aplus Bplus : Fin n → Fin m → ℝ) {eta : ℝ}
    (hAmp : RectMoorePenrosePseudoinverse m n A Aplus)
    (hBmp : RectMoorePenrosePseudoinverse m n B Bplus)
    (hrank : complexMatrixRank (realRectToCMatrix A) =
      complexMatrixRank (realRectToCMatrix B))
    (heta : eta = complexMatrixOp2 (realRectToCMatrix Aplus) *
      complexMatrixOp2 (realRectToCMatrix (fun r c => B r c - A r c)))
    (hsmall : eta < 1) :
    complexMatrixOp2 (realRectToCMatrix Bplus) ≤
      complexMatrixOp2 (realRectToCMatrix Aplus) / (1 - eta) := by
  let CA := realRectToCMatrix A
  let CB := realRectToCMatrix B
  by_cases hrank_zero : complexMatrixRank CA = 0
  · have hBrank_zero : complexMatrixRank CB = 0 := by
      rw [← hrank]
      exact hrank_zero
    have hAplus_zero : Aplus = 0 :=
      pseudoinverse_eq_zero_of_complexMatrixRank_eq_zero A Aplus hAmp hrank_zero
    have hBplus_zero : Bplus = 0 :=
      pseudoinverse_eq_zero_of_complexMatrixRank_eq_zero B Bplus hBmp hBrank_zero
    have hAplusC_zero :
        realRectToCMatrix (0 : Fin n → Fin m → ℝ) = 0 := by
      ext i j
      simp [realRectToCMatrix]
    have hBplusC_zero :
        realRectToCMatrix (0 : Fin n → Fin m → ℝ) = 0 := hAplusC_zero
    have hAplusOp_zero :
        complexMatrixOp2 (realRectToCMatrix Aplus) = 0 := by
      rw [hAplus_zero, hAplusC_zero]
      simp [complexMatrixOp2]
      rfl
    have hBplusOp_zero :
        complexMatrixOp2 (realRectToCMatrix Bplus) = 0 := by
      rw [hBplus_zero, hBplusC_zero]
      simp [complexMatrixOp2]
      rfl
    have heta_zero : eta = 0 := by
      rw [heta, hAplusOp_zero]
      exact zero_mul _
    rw [hAplusOp_zero, hBplusOp_zero, heta_zero]
    norm_num
  · have hrank_pos : 0 < complexMatrixRank CA := Nat.pos_of_ne_zero hrank_zero
    have hrank_le : complexMatrixRank CA ≤ n := by
      exact Matrix.rank_le_width (CA : Matrix (Fin m) (Fin n) ℂ)
    let i : Fin n :=
      ⟨complexMatrixRank CA - 1,
        lt_of_lt_of_le (Nat.sub_lt hrank_pos Nat.zero_lt_one) hrank_le⟩
    have hArank_i : complexMatrixRank (realRectToCMatrix A) = i.1 + 1 := by
      change complexMatrixRank CA = (complexMatrixRank CA - 1) + 1
      exact (Nat.sub_add_cancel (Nat.one_le_iff_ne_zero.mpr hrank_zero)).symm
    have hBrank_i : complexMatrixRank (realRectToCMatrix B) = i.1 + 1 := by
      rw [← hrank]
      exact hArank_i
    exact higham20_lemma20_11_equalPositiveRank_pseudoinverse_op2_le
      A B Aplus Bplus i hAmp hBmp hArank_i hBrank_i heta hsmall

end NumStability
