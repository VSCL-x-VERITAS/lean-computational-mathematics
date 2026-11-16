import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.PreprocessingGeometry
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Preconditioning.CountSketch.OrthonormalEmbedding
import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Algorithm03.RandomProjectionPreconditioning.Preconditioning

/-! # Sparse signed-hash subspace embedding -/

namespace NumStability.Source.DrineasMahoney.RandNLA2016.Proofs

open Targets

theorem signedWalshExactGeometry : Targets.signedWalshExactGeometry := by
  intro p d U hU ω
  exact signedOrthogonalPreconditionRows_hasOrthonormalColumns
    (walshRotation p) (rademacherSignVector ω) U
    (isOrthogonal_sqrt_inv_nat_mul_sylvesterSignPattern p)
    (rademacherSignVector_sq ω) hU

private theorem radius_eq {m d : ℕ} (δ : ℝ) (hδ : 0 < δ) (hδm : δ < (m : ℝ)) :
    (Real.sqrt ((d : ℝ) * (m : ℝ)⁻¹) +
      Real.sqrt (8 * Real.log ((m : ℝ) / δ) / (m : ℝ))) ^ 2 =
    (Real.sqrt (d : ℝ) + Real.sqrt (8 * Real.log ((m : ℝ) / δ))) ^ 2 / (m : ℝ) := by
  have hlog : 0 ≤ 8 * Real.log ((m : ℝ) / δ) :=
    mul_nonneg (by norm_num) (Real.log_nonneg ((one_le_div hδ).mpr (le_of_lt hδm)))
  rw [← div_eq_mul_inv, Real.sqrt_div (Nat.cast_nonneg d),
    Real.sqrt_div hlog, ← add_div, div_pow, Real.sq_sqrt (Nat.cast_nonneg m)]

theorem signedWalshMassSpreading : Targets.signedWalshMassSpreading := by
  intro p d U hU hd δ hδ hδ1
  have hm : 0 < 2 ^ p := pow_pos (by norm_num) p
  have hδm : δ < ((2 ^ p : ℕ) : ℝ) :=
    lt_of_lt_of_le hδ1 (by exact_mod_cast (Nat.one_le_iff_ne_zero.mpr (ne_of_gt hm)))
  have hrow :=
    rademacherTraceProbability_eventProb_forall_rowNormSq_signedHadamard_le_log_delta_ge_one_sub_delta
      (walshRotation p) U hm
      (hadamardFlat_sqrt_inv_nat_mul_sylvesterSignPattern p) hU hδ hδm
  apply hrow.trans
  apply FiniteProbability.eventProb_mono
  intro ω hω i
  dsimp only
  have hQ := signedOrthogonalPreconditionRows_hasOrthonormalColumns
    (walshRotation p) (rademacherSignVector ω) U
    (isOrthogonal_sqrt_inv_nat_mul_sylvesterSignPattern p)
    (rademacherSignVector_sq ω) hU
  have hi := hω i
  rw [radius_eq δ hδ hδm] at hi
  refine ⟨hi, ?_⟩
  rw [leverageScoreProb_eq_rowNormSq_div_nat _ hQ i]
  calc
    _ ≤ ((Real.sqrt (d : ℝ) + Real.sqrt (8 * Real.log (((2 ^ p : ℕ) : ℝ) / δ))) ^ 2 /
      ((2 ^ p : ℕ) : ℝ)) / (d : ℝ) :=
      div_le_div_of_nonneg_right hi (Nat.cast_nonneg d)
    _ = _ := by rw [div_div]

theorem sparseSignedHashSubspaceGeometry : Targets.sparseSignedHashSubspaceGeometry := by
  intro m d t ht U _hm hU ε δ hε _hε1 hδ _hδ1 hbudget
  exact countSketchProbability_eventProb_subspace_geometry_of_dimension ht U hU hε hδ hbudget

theorem preprocessingGeometry : Targets.preprocessingGeometry := by
  exact ⟨signedWalshExactGeometry, signedWalshMassSpreading, sparseSignedHashSubspaceGeometry⟩

end NumStability.Source.DrineasMahoney.RandNLA2016.Proofs
