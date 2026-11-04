import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LowRankApproximation.ColumnSketches.RealSVD
import Mathlib.LinearAlgebra.Matrix.DotProduct

/-!
# Complete real singular families and Gram eigenbases

The existing rank-length real SVD extends to full orthonormal bases with its
original rank block first. Reconstruction and Gram-kernel equivalences supply
zero eigenvalues on both completed tails, including rank zero and empty spaces.
The two Gram matrices use their own finite index sets.
-/

noncomputable section
open scoped BigOperators InnerProductSpace
namespace NumStability

/-- A finite orthonormal family extends to a full real Euclidean orthonormal
basis while preserving its original order in the initial coordinate block. -/
theorem exists_orthonormalBasis_extending_fin_head
    {r d : ℕ} (hrd : r ≤ d)
    (u : Fin r → EuclideanSpace ℝ (Fin d)) (hu : Orthonormal ℝ u) :
    ∃ U : OrthonormalBasis (Fin d) ℝ (EuclideanSpace ℝ (Fin d)),
      ∀ k : Fin r, U (Fin.castLE hrd k) = u k := by
  classical
  let s : Set (Fin d) := {i | i.val < r}
  let seed : Fin d → EuclideanSpace ℝ (Fin d) :=
    fun i ↦ if hi : i.val < r then u ⟨i.val, hi⟩ else 0
  let e : s → Fin r := fun i ↦ ⟨i.val.val, i.property⟩
  have he : Function.Injective e := by
    intro i j hij
    apply Subtype.ext
    apply Fin.ext
    exact congrArg (fun k : Fin r ↦ k.val) hij
  have hSeed : s.restrict seed = u ∘ e := by
    funext i
    change (if hi : i.val.val < r then u ⟨i.val.val, hi⟩ else 0) =
      u ⟨i.val.val, i.property⟩
    have hi : i.val.val < r := i.property
    rw [dif_pos hi]
  have hOrtho : Orthonormal ℝ (s.restrict seed) := by
    rw [hSeed]
    exact hu.comp e he
  have hCard : Module.finrank ℝ (EuclideanSpace ℝ (Fin d)) = Fintype.card (Fin d) := by
    simp
  obtain ⟨U, hU⟩ := hOrtho.exists_orthonormalBasis_extension_of_card_eq hCard
  refine ⟨U, ?_⟩
  intro k
  have hMem : Fin.castLE hrd k ∈ s := k.isLt
  simpa only [seed, Fin.val_castLE, dif_pos k.isLt] using hU (Fin.castLE hrd k) hMem

/-- A real rectangular matrix has an SVD whose rank-length singular families
are the initial blocks of full orthonormal bases. The construction extends the
canonical rank-length certificate, retaining its rank, order, zero-tail,
reconstruction and positive-Gram relations without another SVD construction. -/
theorem exists_realMatrixSVD_full_orthonormal_bases
    {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ) :
    ∃ r : ℕ, ∃ hm : r ≤ m, ∃ hn : r ≤ n,
      ∃ (s : Fin n → ℝ)
        (U : OrthonormalBasis (Fin m) ℝ (EuclideanSpace ℝ (Fin m)))
        (V : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n))),
        IsRealMatrixSVDWithGramEigenrelations A r s
          (fun k ↦ U (Fin.castLE hm k)) (fun k ↦ V (Fin.castLE hn k)) := by
  obtain ⟨r, s, u, v, hSVD⟩ := exists_isRealMatrixSVDWithGramEigenrelations A
  have hm : r ≤ m := by
    rw [hSVD.rank_eq]
    exact Matrix.rank_le_height A
  have hn : r ≤ n := hSVD.rank_le_width
  obtain ⟨U, hU⟩ := exists_orthonormalBasis_extending_fin_head hm u
    hSVD.leftSingularVectors_orthonormal
  obtain ⟨V, hV⟩ := exists_orthonormalBasis_extending_fin_head hn v
    hSVD.rightSingularVectors_orthonormal
  refine ⟨r, hm, hn, s, U, V, ?_⟩
  have hUeq : (fun k ↦ U (Fin.castLE hm k)) = u := funext hU
  have hVeq : (fun k ↦ V (Fin.castLE hn k)) = v := funext hV
  simpa only [hUeq, hVeq] using hSVD

/-- Reconstruction annihilates a vector orthogonal to the left rank family
under the transposed matrix. -/
theorem realMatrixSVD_left_orthonormal_complement_transpose_mulVec_zero
    {m n r : ℕ} {A : Matrix (Fin m) (Fin n) ℝ} {s : Fin n → ℝ}
    {u : Fin r → EuclideanSpace ℝ (Fin m)}
    {v : Fin r → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A r s u v)
    (x : EuclideanSpace ℝ (Fin m)) (hx : ∀ k, ⟪u k, x⟫_ℝ = 0) :
    A.transpose.mulVec (fun i ↦ x i) = 0 := by
  funext j
  change (∑ i : Fin m, A i j * x i) = 0
  simp_rw [h.reconstruction, Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_eq_zero
  intro k _
  have hd : (∑ i : Fin m, u k i * x i) = 0 := by
    simpa [PiLp.inner_apply, RCLike.inner_apply, real_inner_eq_re_inner, mul_comm]
      using hx k
  calc
    (∑ i : Fin m, s (Fin.castLE h.rank_le_width k) * u k i * v k j * x i) =
        s (Fin.castLE h.rank_le_width k) * v k j * ∑ i : Fin m, u k i * x i := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro i _
      ring
    _ = 0 := by rw [hd, mul_zero]

/-- Reconstruction annihilates a vector orthogonal to the right rank family
under the original matrix. -/
theorem realMatrixSVD_right_orthonormal_complement_mulVec_zero
    {m n r : ℕ} {A : Matrix (Fin m) (Fin n) ℝ} {s : Fin n → ℝ}
    {u : Fin r → EuclideanSpace ℝ (Fin m)}
    {v : Fin r → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A r s u v)
    (x : EuclideanSpace ℝ (Fin n)) (hx : ∀ k, ⟪v k, x⟫_ℝ = 0) :
    A.mulVec (fun j ↦ x j) = 0 := by
  funext i
  change (∑ j : Fin n, A i j * x j) = 0
  simp_rw [h.reconstruction, Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_eq_zero
  intro k _
  have hd : (∑ j : Fin n, v k j * x j) = 0 := by
    simpa [PiLp.inner_apply, RCLike.inner_apply, real_inner_eq_re_inner, mul_comm]
      using hx k
  calc
    (∑ j : Fin n, s (Fin.castLE h.rank_le_width k) * u k i * v k j * x j) =
        s (Fin.castLE h.rank_le_width k) * u k i * ∑ j : Fin n, v k j * x j := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro j _
      ring
    _ = 0 := by rw [hd, mul_zero]

/-- The existing real SVD has complete orthonormal Gram eigenbases: active
positions retain the original squared singular values and every remaining
position has eigenvalue zero, on each Gram matrix's own finite index set. -/
theorem exists_realMatrixSVD_full_orthonormal_bases_all_gram_relations
    {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ) :
    ∃ r : ℕ, ∃ hm : r ≤ m, ∃ hn : r ≤ n,
      ∃ (s : Fin n → ℝ)
        (U : OrthonormalBasis (Fin m) ℝ (EuclideanSpace ℝ (Fin m)))
        (V : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n))),
        IsRealMatrixSVDWithGramEigenrelations A r s
          (fun k ↦ U (Fin.castLE hm k)) (fun k ↦ V (Fin.castLE hn k)) ∧
        (∀ p i, (∑ l : Fin m, (∑ j : Fin n, A i j * A l j) * U p l) =
          (if hp : p.val < r then (s ⟨p.val, lt_of_lt_of_le hp hn⟩) ^ 2 else 0) * U p i) ∧
        (∀ q j, (∑ l : Fin n, (∑ i : Fin m, A i j * A i l) * V q l) =
          (s q) ^ 2 * V q j) := by
  classical
  obtain ⟨r, hm, hn, s, U, V, h⟩ := exists_realMatrixSVD_full_orthonormal_bases A
  refine ⟨r, hm, hn, s, U, V, h, ?_, ?_⟩
  · intro p i
    by_cases hp : p.val < r
    · let k : Fin r := ⟨p.val, hp⟩
      have hk : Fin.castLE hm k = p := Fin.ext rfl
      simpa only [dif_pos hp, hk] using h.leftGram_eigenvector k i
    · have hortho : ∀ k : Fin r, ⟪U (Fin.castLE hm k), U p⟫_ℝ = 0 := by
        intro k
        have hne : Fin.castLE hm k ≠ p := by
          intro he
          have hv : k.val = p.val := congrArg (fun t : Fin m ↦ t.val) he
          exact hp (hv ▸ k.isLt)
        simpa only [hne, if_false] using U.inner_eq_ite (Fin.castLE hm k) p
      have hker := realMatrixSVD_left_orthonormal_complement_transpose_mulVec_zero
        h.toIsRealMatrixSVD (U p) hortho
      have hgram : (A * A.transpose).mulVec (fun l ↦ U p l) = 0 := by
        simpa only [Matrix.conjTranspose_eq_transpose_of_trivial] using
          (Matrix.self_mul_conjTranspose_mulVec_eq_zero A (fun l ↦ U p l)).mpr
            (by simpa only [Matrix.conjTranspose_eq_transpose_of_trivial] using hker)
      have hi := congrFun hgram i
      simpa only [Matrix.mulVec, dotProduct, Matrix.mul_apply, Matrix.transpose_apply,
        dif_neg hp, zero_mul, Pi.zero_apply] using hi
  · intro q j
    by_cases hq : q.val < r
    · let k : Fin r := ⟨q.val, hq⟩
      have hk : Fin.castLE hn k = q := Fin.ext rfl
      simpa only [hk] using h.rightGram_eigenvector k j
    · have hortho : ∀ k : Fin r, ⟪V (Fin.castLE hn k), V q⟫_ℝ = 0 := by
        intro k
        have hne : Fin.castLE hn k ≠ q := by
          intro he
          have hv : k.val = q.val := congrArg (fun t : Fin n ↦ t.val) he
          exact hq (hv ▸ k.isLt)
        simpa only [hne, if_false] using V.inner_eq_ite (Fin.castLE hn k) q
      have hker := realMatrixSVD_right_orthonormal_complement_mulVec_zero
        h.toIsRealMatrixSVD (V q) hortho
      have hgram : (A.transpose * A).mulVec (fun l ↦ V q l) = 0 := by
        simpa only [Matrix.conjTranspose_eq_transpose_of_trivial] using
          (Matrix.conjTranspose_mul_self_mulVec_eq_zero A (fun l ↦ V q l)).mpr hker
      have hj := congrFun hgram j
      have hs : s q = 0 := h.singularValues_zero_of_rank_le q (Nat.le_of_not_gt hq)
      simpa only [Matrix.mulVec, dotProduct, Matrix.mul_apply, Matrix.transpose_apply,
        hs, zero_pow (by decide : 2 ≠ 0), zero_mul, Pi.zero_apply] using hj

/-- Squared singular values, extended by zero after the rank, retain their
descending order on the full left Gram index set. The squared comparisons
use Mathlib's `pow_le_pow_left₀`. -/
theorem realMatrixSVD_leftGramSpectrum_antitone {m n r : ℕ} (hn : r ≤ n)
    (s : Fin n → ℝ) (hs : Antitone s) (hnon : ∀ i, 0 ≤ s i) :
    Antitone (fun p : Fin m =>
      if hp : p.val < r then (s ⟨p.val, lt_of_lt_of_le hp hn⟩) ^ 2 else 0) := by
  intro p q hpq
  by_cases hq : q.val < r
  · have hp : p.val < r := lt_of_le_of_lt hpq hq
    simp only [dif_pos hp, dif_pos hq]
    have hpq' : (⟨p.val, lt_of_lt_of_le hp hn⟩ : Fin n) ≤
        ⟨q.val, lt_of_lt_of_le hq hn⟩ := hpq
    exact pow_le_pow_left₀ (hnon _) (hs hpq') 2
  · by_cases hp : p.val < r
    · simp only [dif_pos hp, dif_neg hq]
      positivity
    · simp only [dif_neg hp, dif_neg hq]
      exact le_refl _

/-- Ordering, nonnegativity and rank-zero tails for the two full Gram lists
provided by a real rectangular SVD certificate. The ambient lists keep their
separate `Fin m` and `Fin n` domains. -/
theorem IsRealMatrixSVD.fullGramSpectrum_order_and_tail
    {m n r : ℕ} {A : Matrix (Fin m) (Fin n) ℝ} {s : Fin n → ℝ}
    {u : Fin r → EuclideanSpace ℝ (Fin m)}
    {v : Fin r → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A r s u v) :
    let leftEigenvalue : Fin m → ℝ := fun p =>
      if hp : p.val < r then (s ⟨p.val, lt_of_lt_of_le hp h.rank_le_width⟩) ^ 2 else 0
    let rightEigenvalue : Fin n → ℝ := fun q => (s q) ^ 2
    Antitone leftEigenvalue ∧ Antitone rightEigenvalue ∧
      (∀ p, 0 ≤ leftEigenvalue p) ∧ (∀ q, 0 ≤ rightEigenvalue q) ∧
      (∀ p, r ≤ p.val → leftEigenvalue p = 0) ∧
      (∀ q, r ≤ q.val → rightEigenvalue q = 0) := by
  dsimp
  refine ⟨realMatrixSVD_leftGramSpectrum_antitone h.rank_le_width s
      h.singularValues_antitone h.singularValues_nonnegative,
    (by
      intro i j hij
      exact pow_le_pow_left₀ (h.singularValues_nonnegative j)
        (h.singularValues_antitone hij) 2),
    ?_, ?_, ?_, ?_⟩
  · intro p
    by_cases hp : p.val < r
    · simp only [dif_pos hp]
      exact sq_nonneg _
    · simp only [dif_neg hp]
      exact le_refl _
  · intro q
    exact sq_nonneg _
  · intro p hp
    simp only [dif_neg (Nat.not_lt.mpr hp)]
  · intro q hq
    rw [h.singularValues_zero_of_rank_le q hq]
    norm_num

end NumStability
