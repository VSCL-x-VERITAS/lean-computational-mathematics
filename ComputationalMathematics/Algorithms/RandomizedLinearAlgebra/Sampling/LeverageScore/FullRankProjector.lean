import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.LeverageScore.Core
import Mathlib.LinearAlgebra.Matrix.Rank
import Mathlib.LinearAlgebra.Matrix.Trace

/-!
# Leverage of a full-column-rank table

A positive lower bound for the Gram quadratic form controls the diagonal of
its actual column-space projector `W (WᵀW)⁻¹ Wᵀ`.
-/
namespace NumStability
open scoped BigOperators

/-- The actual inverse-Gram column projector of a full-column-rank table.
The formula is total; its projector interpretation requires nonsingular Gram. -/
noncomputable def fullRankColumnProjector {m n : ℕ}
    (W : Fin m → Fin n → ℝ) : Fin m → Fin m → ℝ :=
  fun i j => ∑ a : Fin n, ∑ b : Fin n,
    W i a * nonsingInv n (rowGram W) a b * W j b

/-- Positive Gram lower bounds imply the Gram is positive definite. -/
theorem rowGram_posDef_of_lower {m n : ℕ}
    (W : Fin m → Fin n → ℝ) {c : ℝ} (hc : 0 < c)
    (hlower : ∀ x : Fin n → ℝ,
      c * (∑ j, x j ^ 2) ≤ finiteQuadraticForm (rowGram W) x) :
    Matrix.PosDef (rowGram W : Matrix (Fin n) (Fin n) ℝ) := by
  apply Matrix.PosDef.of_dotProduct_mulVec_pos
  · apply Matrix.IsHermitian.ext
    intro i j
    simp only [star_trivial]
    unfold rowGram
    apply Finset.sum_congr rfl
    intro k _
    ring
  · intro x hx
    have hsum : 0 < ∑ j : Fin n, x j ^ 2 := by
      obtain ⟨i, hi⟩ := Function.ne_iff.mp hx
      exact Finset.sum_pos' (fun j _ => sq_nonneg (x j))
        ⟨i, Finset.mem_univ _, sq_pos_of_ne_zero hi⟩
    have hpos := (mul_pos hc hsum).trans_le (hlower x)
    simpa [finiteQuadraticForm, finiteMatVec, dotProduct, Matrix.mulVec] using hpos

/-- Reciprocal-Gram lower-bound estimate for the actual projector diagonal. -/
theorem fullRankColumnProjector_diag_le_of_gram_lower {m n : ℕ}
    (W : Fin m → Fin n → ℝ) {c : ℝ} (hc : 0 < c)
    (hlower : ∀ x : Fin n → ℝ,
      c * (∑ j, x j ^ 2) ≤ finiteQuadraticForm (rowGram W) x)
    (i : Fin m) :
    fullRankColumnProjector W i i ≤ rowNormSq W i / c := by
  classical
  let G : Matrix (Fin n) (Fin n) ℝ := rowGram W
  let B : Matrix (Fin n) (Fin n) ℝ := nonsingInv n (rowGram W)
  let r : Fin n → ℝ := W i
  let x : Fin n → ℝ := B.mulVec r
  have hpd := rowGram_posDef_of_lower W hc hlower
  have hdet : IsUnit G.det := (Matrix.isUnit_iff_isUnit_det G).mp hpd.isUnit
  have hGB : G * B = 1 := by
    exact Matrix.mul_nonsing_inv G hdet
  have hGx : G.mulVec x = r := by
    change G.mulVec (B.mulVec r) = r
    rw [Matrix.mulVec_mulVec, hGB, Matrix.one_mulVec]
  have hq : finiteQuadraticForm (rowGram W) x = ∑ j, x j * r j := by
    change (∑ j, x j * G.mulVec x j) = _
    rw [hGx]
  have hlow := hlower x
  rw [hq] at hlow
  have hsquares : 0 ≤ ∑ j : Fin n, (x j - r j / c) ^ 2 :=
    Finset.sum_nonneg (fun _ _ => sq_nonneg _)
  have hexpand : (∑ j : Fin n, (x j - r j / c) ^ 2) =
      (∑ j, x j ^ 2) - (2 / c) * (∑ j, x j * r j) +
        (∑ j, r j ^ 2) / c ^ 2 := by
    simp_rw [sub_sq, div_pow]
    simp only [Finset.sum_add_distrib, Finset.sum_sub_distrib,
      ← Finset.sum_div]
    congr 1
    congr 1
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro j _
    ring
  rw [hexpand] at hsquares
  have hc2 : 0 < c ^ 2 := sq_pos_of_pos hc
  have hbound : (∑ j, x j * r j) ≤ (∑ j, r j ^ 2) / c := by
    have hscaled := mul_nonneg (le_of_lt hc2) hsquares
    have hscaledlow := mul_le_mul_of_nonneg_left hlow (le_of_lt hc)
    field_simp at hscaled ⊢
    nlinarith
  have hprojector : fullRankColumnProjector W i i = ∑ j, x j * r j := by
    unfold fullRankColumnProjector
    change (∑ a : Fin n, ∑ b : Fin n, r a * B a b * r b) = _
    simp only [x, Matrix.mulVec, dotProduct, Finset.sum_mul]
    apply Finset.sum_congr rfl
    intro a _
    apply Finset.sum_congr rfl
    intro b _
    ring
  rw [hprojector]
  exact hbound

/-- The inverse-Gram formula is the literal rectangular matrix product. -/
theorem fullRankColumnProjector_eq_matrix_mul {m n : ℕ}
    (W : Fin m → Fin n → ℝ) :
    let A : Matrix (Fin m) (Fin n) ℝ := W
    let B : Matrix (Fin n) (Fin n) ℝ := nonsingInv n (rowGram W)
    (fullRankColumnProjector W : Matrix (Fin m) (Fin m) ℝ) = A * B * A.transpose := by
  ext i j
  simp only [fullRankColumnProjector, Matrix.mul_apply, Matrix.transpose_apply,
    Finset.sum_mul]
  rw [Finset.sum_comm]

/-- A strictly positive Gram lower bound gives the actual column rank. -/
theorem matrix_rank_eq_of_rowGram_lower {m n : ℕ}
    (W : Fin m → Fin n → ℝ) {c : ℝ} (hc : 0 < c)
    (hlower : ∀ x : Fin n → ℝ,
      c * (∑ j, x j ^ 2) ≤ finiteQuadraticForm (rowGram W) x) :
    Matrix.rank (W : Matrix (Fin m) (Fin n) ℝ) = n := by
  let A : Matrix (Fin m) (Fin n) ℝ := W
  have hgram : (rowGram W : Matrix (Fin n) (Fin n) ℝ) = A.transpose * A := by
    ext i j
    rfl
  have hpd := rowGram_posDef_of_lower W hc hlower
  have hrank := Matrix.rank_mul_le_right A.transpose A
  rw [← hgram, Matrix.rank_of_isUnit _ hpd.isUnit, Fintype.card_fin] at hrank
  exact Nat.le_antisymm (Matrix.rank_le_width A) hrank

/-- The inverse-Gram product is symmetric and projects onto every input column.
Together with its displayed factorization through W, these properties identify
it as the orthogonal projector onto the actual column space. -/
theorem fullRankColumnProjector_certificate_of_gram_lower {m n : ℕ}
    (W : Fin m → Fin n → ℝ) {c : ℝ} (hc : 0 < c)
    (hlower : ∀ x : Fin n → ℝ,
      c * (∑ j, x j ^ 2) ≤ finiteQuadraticForm (rowGram W) x) :
    let P : Matrix (Fin m) (Fin m) ℝ := fullRankColumnProjector W
    let A : Matrix (Fin m) (Fin n) ℝ := W
    P.transpose = P ∧ P * P = P ∧ P * A = A := by
  let A : Matrix (Fin m) (Fin n) ℝ := W
  let G : Matrix (Fin n) (Fin n) ℝ := rowGram W
  let B : Matrix (Fin n) (Fin n) ℝ := nonsingInv n (rowGram W)
  have hgram : G = A.transpose * A := by ext i j; rfl
  have hpd := rowGram_posDef_of_lower W hc hlower
  have hdet := (Matrix.isUnit_iff_isUnit_det G).mp hpd.isUnit
  have hBG : B * G = 1 := Matrix.nonsing_inv_mul G hdet
  have hGsym : G.transpose = G := by rw [hgram]; simp
  have hBsym : B.transpose = B := by
    change (G⁻¹).transpose = G⁻¹
    rw [Matrix.transpose_nonsing_inv, hGsym]
  change Matrix.transpose (fullRankColumnProjector W : Matrix (Fin m) (Fin m) ℝ) = _ ∧ _
  rw [fullRankColumnProjector_eq_matrix_mul]
  change (A * B * A.transpose).transpose = A * B * A.transpose ∧
    (A * B * A.transpose) * (A * B * A.transpose) = A * B * A.transpose ∧
    (A * B * A.transpose) * A = A
  have hPA : (A * B * A.transpose) * A = A := by
    calc
      (A * B * A.transpose) * A = A * (B * (A.transpose * A)) := by
        simp only [Matrix.mul_assoc]
      _ = A := by rw [← hgram, hBG, Matrix.mul_one]
  refine ⟨?_, ?_, hPA⟩
  · simp only [Matrix.transpose_mul, Matrix.transpose_transpose, hBsym]
    exact (Matrix.mul_assoc A B A.transpose).symm
  · calc
      (A * B * A.transpose) * (A * B * A.transpose) =
          ((A * B * A.transpose) * A) * B * A.transpose := by
            simp only [Matrix.mul_assoc]
      _ = A * B * A.transpose := by rw [hPA]

/-- Normalized leverage probabilities of the actual full-rank column space. -/
noncomputable def fullRankLeverageProb {m n : ℕ}
    (W : Fin m → Fin n → ℝ) (i : Fin m) : ℝ :=
  fullRankColumnProjector W i i / (n : ℝ)

/-- A Gram lower bound transfers a squared row bound to actual normalized
column-space leverage. -/
theorem fullRankLeverageProb_le_of_gram_lower {m n : ℕ}
    (W : Fin m → Fin n → ℝ) {c B : ℝ} (hc : 0 < c)
    (hlower : ∀ x : Fin n → ℝ,
      c * (∑ j, x j ^ 2) ≤ finiteQuadraticForm (rowGram W) x)
    (hrow : ∀ i, rowNormSq W i ≤ B) (i : Fin m) :
    fullRankLeverageProb W i ≤ B / (c * (n : ℝ)) := by
  unfold fullRankLeverageProb
  calc
    fullRankColumnProjector W i i / (n : ℝ) ≤
        (rowNormSq W i / c) / (n : ℝ) :=
      div_le_div_of_nonneg_right
        (fullRankColumnProjector_diag_le_of_gram_lower W hc hlower i)
        (Nat.cast_nonneg n)
    _ ≤ (B / c) / (n : ℝ) :=
      div_le_div_of_nonneg_right (div_le_div_of_nonneg_right (hrow i) (le_of_lt hc))
        (Nat.cast_nonneg n)
    _ = B / (c * (n : ℝ)) := by rw [div_div]


/-- On the full-rank domain, the normalized projector diagonal is nonnegative. -/
theorem fullRankLeverageProb_nonneg_of_gram_lower {m n : ℕ}
    (W : Fin m → Fin n → ℝ) {c : ℝ} (hc : 0 < c)
    (hlower : ∀ x : Fin n → ℝ,
      c * (∑ j, x j ^ 2) ≤ finiteQuadraticForm (rowGram W) x) (i : Fin m) :
    0 ≤ fullRankLeverageProb W i := by
  let P : Matrix (Fin m) (Fin m) ℝ := fullRankColumnProjector W
  obtain ⟨hsym, hid, _⟩ := fullRankColumnProjector_certificate_of_gram_lower W hc hlower
  have hdiag := congrFun (congrFun hid i) i
  change (P * P) i i = P i i at hdiag
  have hnonneg : 0 ≤ P i i := by
    rw [← hdiag]
    change 0 ≤ ∑ j, P i j * P j i
    apply Finset.sum_nonneg
    intro j _
    have hji := congrFun (congrFun hsym i) j
    change P j i = P i j at hji
    rw [hji]
    exact mul_self_nonneg _
  exact div_nonneg hnonneg (Nat.cast_nonneg n)

/-- The actual full-rank projector diagonal, normalized by its actual rank,
sums to one. -/
theorem fullRankLeverageProb_sum_eq_one_of_gram_lower {m n : ℕ}
    (W : Fin m → Fin n → ℝ) (hn : 0 < n) {c : ℝ} (hc : 0 < c)
    (hlower : ∀ x : Fin n → ℝ,
      c * (∑ j, x j ^ 2) ≤ finiteQuadraticForm (rowGram W) x) :
    ∑ i : Fin m, fullRankLeverageProb W i = 1 := by
  let A : Matrix (Fin m) (Fin n) ℝ := W
  let G : Matrix (Fin n) (Fin n) ℝ := rowGram W
  let B : Matrix (Fin n) (Fin n) ℝ := nonsingInv n (rowGram W)
  have hgram : G = A.transpose * A := by ext i j; rfl
  have hpd := rowGram_posDef_of_lower W hc hlower
  have hdet := (Matrix.isUnit_iff_isUnit_det G).mp hpd.isUnit
  have hBG : B * G = 1 := Matrix.nonsing_inv_mul G hdet
  have htrace : Matrix.trace (fullRankColumnProjector W : Matrix (Fin m) (Fin m) ℝ) =
      (n : ℝ) := by
    rw [fullRankColumnProjector_eq_matrix_mul]
    change Matrix.trace (A * B * A.transpose) = _
    rw [Matrix.trace_mul_cycle, ← hgram, Matrix.trace_mul_comm, hBG]
    simp
  simp only [fullRankLeverageProb, ← Finset.sum_div]
  change Matrix.trace (fullRankColumnProjector W : Matrix (Fin m) (Fin m) ℝ) / (n : ℝ) = 1
  rw [htrace, div_self (by exact_mod_cast (ne_of_gt hn))]


/-- The inverse-Gram projector has exactly the actual column space as its range. -/
theorem fullRankColumnProjector_range_eq_of_gram_lower {m n : ℕ}
    (W : Fin m → Fin n → ℝ) {c : ℝ} (hc : 0 < c)
    (hlower : ∀ x : Fin n → ℝ,
      c * (∑ j, x j ^ 2) ≤ finiteQuadraticForm (rowGram W) x) :
    LinearMap.range (Matrix.mulVecLin
      (fullRankColumnProjector W : Matrix (Fin m) (Fin m) ℝ)) =
      LinearMap.range (Matrix.mulVecLin (W : Matrix (Fin m) (Fin n) ℝ)) := by
  let A : Matrix (Fin m) (Fin n) ℝ := W
  let B : Matrix (Fin n) (Fin n) ℝ := nonsingInv n (rowGram W)
  let P : Matrix (Fin m) (Fin m) ℝ := fullRankColumnProjector W
  have hfactor : P = A * B * A.transpose := fullRankColumnProjector_eq_matrix_mul W
  have hfix : P * A = A :=
    (fullRankColumnProjector_certificate_of_gram_lower W hc hlower).2.2
  apply Submodule.ext
  intro v
  constructor
  · rintro ⟨x, rfl⟩
    refine ⟨B.mulVec (A.transpose.mulVec x), ?_⟩
    change A.mulVec (B.mulVec (A.transpose.mulVec x)) = P.mulVec x
    rw [hfactor, ← Matrix.mulVec_mulVec, ← Matrix.mulVec_mulVec]
  · rintro ⟨x, rfl⟩
    refine ⟨A.mulVec x, ?_⟩
    change P.mulVec (A.mulVec x) = A.mulVec x
    rw [Matrix.mulVec_mulVec, hfix]

end NumStability
