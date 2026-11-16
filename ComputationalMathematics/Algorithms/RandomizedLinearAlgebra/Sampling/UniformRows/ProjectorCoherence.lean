import ComputationalMathematics.Analysis.MatrixSpectralBounds
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.LeverageScore.FullRankProjector
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.UniformRows.Core

/-!
# Actual column-space leverage after uniform row sampling

The scaled row table below is the literal with-replacement Algorithm2 sketch.
A half-identity lower Gram bound converts its row cap into a bound on the
normalized diagonal of the actual column-space projector.
-/
namespace NumStability
open scoped BigOperators

/-- Common `sqrt(m/s)` scaling of an actual uniform row trace. -/
noncomputable def uniformScaledRowSketch {m d s : ℕ}
    (U : Fin m → Fin d → ℝ) (samples : RowTrace m s) : Fin s → Fin d → ℝ :=
  fun t j => Real.sqrt ((m : ℝ) / (s : ℝ)) * U (samples t) j

/-- The explicit scaled table agrees with Algorithm2's supplied uniform law. -/
theorem uniformScaledRowSketch_eq_rowSampleSketchWithProb {m d s : ℕ}
    (U : Fin m → Fin d → ℝ) (samples : RowTrace m s) :
    uniformScaledRowSketch U samples = rowSampleSketchWithProb s U uniformRowProb samples := by
  ext t j
  simp only [uniformScaledRowSketch, rowSampleSketchWithProb, rowSampleIncrementWithProb,
    rowSampleScaleDenWithProb, uniformRowProb]
  have hscale : Real.sqrt ((m : ℝ) / (s : ℝ)) =
      (Real.sqrt ((s : ℝ) * (m : ℝ)⁻¹))⁻¹ := by
    rw [← Real.sqrt_inv, mul_inv_rev, inv_inv]
    rfl
  rw [hscale]
  ring

/-- Squared row norm of the literal scaled uniform sketch. -/
theorem rowNormSq_uniformScaledRowSketch {m d s : ℕ}
    (U : Fin m → Fin d → ℝ) (samples : RowTrace m s) (t : Fin s) :
    rowNormSq (uniformScaledRowSketch U samples) t =
      (m : ℝ) / (s : ℝ) * rowNormSq U (samples t) := by
  unfold rowNormSq uniformScaledRowSketch
  simp_rw [mul_pow, Real.sq_sqrt (div_nonneg (Nat.cast_nonneg m) (Nat.cast_nonneg s))]
  rw [Finset.mul_sum]

/-- The actual scaled sketch has the sampled Gram used in the iid tail API. -/
theorem rowGram_uniformScaledRowSketch {m d s : ℕ}
    (U : Fin m → Fin d → ℝ) (samples : RowTrace m s) :
    rowGram (uniformScaledRowSketch U samples) = uniformRowSampleGram U samples := by
  ext j k
  unfold rowGram uniformScaledRowSketch uniformRowSampleGram uniformRowOuterGramSample
  have hsqrt := Real.sq_sqrt (div_nonneg (Nat.cast_nonneg m) (Nat.cast_nonneg s))
  simp_rw [show ∀ a b : ℝ, Real.sqrt ((m : ℝ) / (s : ℝ)) * a *
      (Real.sqrt ((m : ℝ) / (s : ℝ)) * b) =
        ((m : ℝ) / (s : ℝ)) * (a * b) by
        intro a b
        calc
          _ = Real.sqrt ((m : ℝ) / (s : ℝ)) ^ 2 * (a * b) := by ring
          _ = _ := by rw [hsqrt]]
  simp only [Finset.sum_div]
  apply Finset.sum_congr rfl
  intro t _
  ring

/-- The lower half of a centered Gram event is a positive lower Gram bound. -/
theorem uniformScaledRowSketch_gram_lower_half {m d s : ℕ}
    (U : Fin m → Fin d → ℝ) (samples : RowTrace m s)
    (hlower : finiteLoewnerLe
      (fun j k : Fin d => -(uniformRowSampleGram U samples j k - finiteIdMatrix j k))
      (fun j k : Fin d => (1 / 2 : ℝ) * finiteIdMatrix j k)) :
    ∀ x : Fin d → ℝ, (1 / 2 : ℝ) * (∑ j, x j ^ 2) ≤
      finiteQuadraticForm (rowGram (uniformScaledRowSketch U samples)) x := by
  intro x
  have h := hlower x
  rw [rowGram_uniformScaledRowSketch]
  rw [finiteQuadraticForm_neg, finiteQuadraticForm_sub,
    finiteQuadraticForm_finiteIdMatrix, finiteQuadraticForm_smul,
    finiteQuadraticForm_finiteIdMatrix] at h
  change (1 / 2 : ℝ) * (∑ j, x j ^ 2) ≤ _
  simpa [finiteVecNorm2Sq, sq] using (by linarith :
    (1 / 2 : ℝ) * finiteVecNorm2Sq x ≤ finiteQuadraticForm (uniformRowSampleGram U samples) x)

/-- An actual successful uniform sketch has rank d and actual normalized
column-space leverage at most `2L/(sd)`. No raw row norm is substituted for
that projector quantity. -/
theorem uniformScaledRowSketch_rank_and_leverage_of_row_cap {m d s : ℕ}
    (U : Fin m → Fin d → ℝ) (samples : RowTrace m s) (hs : 0 < (s : ℝ)) {L : ℝ}
    (hrow : ∀ i, (m : ℝ) * rowNormSq U i ≤ L)
    (hlower : finiteLoewnerLe
      (fun j k : Fin d => -(uniformRowSampleGram U samples j k - finiteIdMatrix j k))
      (fun j k : Fin d => (1 / 2 : ℝ) * finiteIdMatrix j k)) :
    Matrix.rank (uniformScaledRowSketch U samples : Matrix (Fin s) (Fin d) ℝ) = d ∧
    ∀ t, fullRankLeverageProb (uniformScaledRowSketch U samples) t ≤
      2 * L / ((s : ℝ) * (d : ℝ)) := by
  have hlow := uniformScaledRowSketch_gram_lower_half U samples hlower
  refine ⟨matrix_rank_eq_of_rowGram_lower _ (by norm_num) hlow, ?_⟩
  intro t
  have hcap : ∀ t, rowNormSq (uniformScaledRowSketch U samples) t ≤ L / (s : ℝ) := by
    intro t
    rw [rowNormSq_uniformScaledRowSketch, div_mul_eq_mul_div]
    exact (div_le_div_iff_of_pos_right hs).mpr (hrow (samples t))
  have h := fullRankLeverageProb_le_of_gram_lower
    (uniformScaledRowSketch U samples) (by norm_num : (0 : ℝ) < 1 / 2) hlow hcap t
  calc
    fullRankLeverageProb (uniformScaledRowSketch U samples) t ≤
      (L / (s : ℝ)) / ((1 / 2 : ℝ) * (d : ℝ)) := h
    _ = 2 * L / ((s : ℝ) * (d : ℝ)) := by ring

/-- Two centered Gram inequalities imply the literal spectral error bound. -/
theorem opNorm2_uniformScaledRowSketch_gram_error_le_of_two_sided {m d s : ℕ}
    (U : Fin m → Fin d → ℝ) (samples : RowTrace m s) {ε : ℝ} (hε : 0 ≤ ε)
    (hupper : finiteLoewnerLe
      (fun j k : Fin d => uniformRowSampleGram U samples j k - finiteIdMatrix j k)
      (fun j k : Fin d => ε * finiteIdMatrix j k))
    (hlower : finiteLoewnerLe
      (fun j k : Fin d => -(uniformRowSampleGram U samples j k - finiteIdMatrix j k))
      (fun j k : Fin d => ε * finiteIdMatrix j k)) :
    opNorm2 (fun j k => finiteIdMatrix j k -
      rowGram (uniformScaledRowSketch U samples) j k) ≤ ε := by
  rw [rowGram_uniformScaledRowSketch]
  have hsym : IsSymmetricFiniteMatrix
      (fun j k : Fin d => finiteIdMatrix j k - uniformRowSampleGram U samples j k) := by
    intro j k
    have hi : finiteIdMatrix j k = finiteIdMatrix k j := by
      simp only [finiteIdMatrix, eq_comm]
    have hg : uniformRowSampleGram U samples j k = uniformRowSampleGram U samples k j := by
      unfold uniformRowSampleGram uniformRowOuterGramSample
      congr 1
      apply Finset.sum_congr rfl
      intro t _
      ring
    dsimp only
    rw [hi, hg]
  apply opNorm2_le_of_symmetric_two_sided_loewner _ hsym hε
  · simpa only [neg_sub] using hlower
  · simpa only [neg_sub, sub_sub_cancel] using hupper


/-- Both centered Gram bounds preserve every vector of the fixed represented
subspace simultaneously in squared Euclidean norm. -/
theorem uniformScaledRowSketch_preserves_subspace_of_two_sided {m d s : ℕ}
    (U : Fin m → Fin d → ℝ) (hU : HasOrthonormalColumns U)
    (samples : RowTrace m s) {ε : ℝ}
    (hupper : finiteLoewnerLe
      (fun j k : Fin d => uniformRowSampleGram U samples j k - finiteIdMatrix j k)
      (fun j k : Fin d => ε * finiteIdMatrix j k))
    (hlower : finiteLoewnerLe
      (fun j k : Fin d => -(uniformRowSampleGram U samples j k - finiteIdMatrix j k))
      (fun j k : Fin d => ε * finiteIdMatrix j k)) (x : Fin d → ℝ) :
    (1 - ε) * vecNorm2Sq (rectMatMulVec U x) ≤
        vecNorm2Sq (rectMatMulVec (uniformScaledRowSketch U samples) x) ∧
    vecNorm2Sq (rectMatMulVec (uniformScaledRowSketch U samples) x) ≤
        (1 + ε) * vecNorm2Sq (rectMatMulVec U x) := by
  have hq : vecNorm2Sq (rectMatMulVec (uniformScaledRowSketch U samples) x) =
      finiteQuadraticForm (uniformRowSampleGram U samples) x := by
    rw [← rowGram_uniformScaledRowSketch]
    exact vecNorm2Sq_rowSketch_linearCombination_eq_quadratic_rowSketchGram _ x
  have hn : vecNorm2Sq (rectMatMulVec U x) = finiteVecNorm2Sq x :=
    hasOrthonormalColumns_vecNorm2Sq_mul_vec_eq U hU x
  have hu := hupper x
  have hl := hlower x
  rw [finiteQuadraticForm_sub, finiteQuadraticForm_smul_finiteIdMatrix,
    finiteQuadraticForm_finiteIdMatrix] at hu
  rw [finiteQuadraticForm_neg, finiteQuadraticForm_sub,
    finiteQuadraticForm_smul_finiteIdMatrix, finiteQuadraticForm_finiteIdMatrix] at hl
  rw [hq, hn]
  constructor <;> linarith


/-- A literal spectral Gram error gives the lower half bound needed for
projector leverage. -/
theorem uniformScaledRowSketch_lower_of_spectral_error {m d s : ℕ}
    (U : Fin m → Fin d → ℝ) (samples : RowTrace m s)
    (hop : opNorm2 (fun j k => finiteIdMatrix j k -
      rowGram (uniformScaledRowSketch U samples) j k) ≤ (1 / 2 : ℝ)) :
    finiteLoewnerLe
      (fun j k : Fin d => -(uniformRowSampleGram U samples j k - finiteIdMatrix j k))
      (fun j k : Fin d => (1 / 2 : ℝ) * finiteIdMatrix j k) := by
  let M : Fin d → Fin d → ℝ := fun j k => finiteIdMatrix j k -
    rowGram (uniformScaledRowSketch U samples) j k
  have hnorm : finiteOpNorm2Le M (1 / 2 : ℝ) := by
    have h := finiteOpNorm2Le_of_opNorm2Le M (opNorm2Le_opNorm2 M)
    intro x
    exact (h x).trans (mul_le_mul_of_nonneg_right hop (finiteVecNorm2_nonneg x))
  have hle := finiteLoewnerLe_smul_id_of_finiteOpNorm2Le M hnorm
  simpa only [M, rowGram_uniformScaledRowSketch, neg_sub] using hle

end NumStability
