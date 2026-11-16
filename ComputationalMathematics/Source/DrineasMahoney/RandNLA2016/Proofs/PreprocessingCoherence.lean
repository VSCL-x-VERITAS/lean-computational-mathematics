import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.PreprocessingCoherence
import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Proofs.PreprocessingGeometry

/-!
# Joint Walsh sampling and actual projector coherence

These wrappers establish the admitted real-Walsh joint-law contracts, including
sampled-space leverage and the stated regime for the rank-logarithmic sample
scale. They assert neither a complex Fourier realization nor execution cost.
-/

namespace NumStability.Source.DrineasMahoney.RandNLA2016.Proofs

open Targets

theorem signedWalshJointEmbedding : Targets.signedWalshJointEmbedding := by
  refine ⟨1000, by norm_num, ?_⟩
  intro p d s U hU hd _ hs ε δ hε hε1 hδ hδ1 hbudget
  have hm : 0 < 2 ^ p := pow_pos (by norm_num) p
  have hp := signedHadamardUniformRowTraceProbability_joint_geometry_of_sample_count
    (walshRotation p) U (isOrthogonal_sqrt_inv_nat_mul_sylvesterSignPattern p)
    (hadamardFlat_sqrt_inv_nat_mul_sylvesterSignPattern p) hU hm hd
    (by exact_mod_cast hs) hε hε1 hδ hδ1 hbudget
  apply hp.trans
  apply FiniteProbability.eventProb_mono
  intro z hz
  refine ⟨hz.1, hz.2.2.2, ?_⟩
  intro x
  have hQ : HasOrthonormalColumns (signedHadamardBasis (walshRotation p) U z.1) :=
    signedOrthogonalPreconditionRows_hasOrthonormalColumns
      (walshRotation p) (rademacherSignVector z.1) U
      (isOrthogonal_sqrt_inv_nat_mul_sylvesterSignPattern p) (rademacherSignVector_sq z.1) hU
  have hvec := uniformScaledRowSketch_preserves_subspace_of_two_sided
    (signedHadamardBasis (walshRotation p) U z.1) hQ z.2 hz.2.1 hz.2.2.1 x
  have hnorm : vecNorm2Sq (rectMatMulVec (signedHadamardBasis (walshRotation p) U z.1) x) =
      vecNorm2Sq (rectMatMulVec U x) := by
    change vecNorm2Sq (fun i => ∑ j, signedHadamardBasis (walshRotation p) U z.1 i j * x j) =
      vecNorm2Sq (fun i => ∑ j, U i j * x j)
    rw [hasOrthonormalColumns_vecNorm2Sq_mul_vec_eq _ hQ,
      hasOrthonormalColumns_vecNorm2Sq_mul_vec_eq _ hU]
  simpa only [hnorm] using hvec

theorem sampledWalshProjectorCoherence : Targets.sampledWalshProjectorCoherence := by
  intro p d s U _ hd hs δ _ _ ω samples
  dsimp only
  intro hrow hop
  let Q := signedHadamardBasis (walshRotation p) U ω
  let W := uniformScaledRowSketch Q samples
  let L := (Real.sqrt (d : ℝ) + Real.sqrt (8 * Real.log (((2 ^ p : ℕ) : ℝ) / δ))) ^ 2
  have hmR : (0 : ℝ) < ((2 ^ p : ℕ) : ℝ) := by positivity
  have hcap : ∀ i, ((2 ^ p : ℕ) : ℝ) * rowNormSq Q i ≤ L := by
    intro i
    have hi := (le_div_iff₀ hmR).mp (hrow i)
    simpa only [mul_comm] using hi
  have hlow := uniformScaledRowSketch_lower_of_spectral_error Q samples hop
  have hgram := uniformScaledRowSketch_gram_lower_half Q samples hlow
  have hrank := uniformScaledRowSketch_rank_and_leverage_of_row_cap Q samples
    (by exact_mod_cast hs) hcap hlow
  refine ⟨hrank.1, ?_, ?_, hrank.2⟩
  · exact fullRankLeverageProb_nonneg_of_gram_lower W (by norm_num) hgram
  · exact fullRankLeverageProb_sum_eq_one_of_gram_lower W hd (by norm_num) hgram

theorem signedWalshCoherenceSampleScale : Targets.signedWalshCoherenceSampleScale := by
  refine ⟨20000, 1 / 2, by norm_num, by norm_num, by norm_num, ?_⟩
  intro p d s U hU hd _ hs
  dsimp only
  have hm : 0 < 2 ^ p := pow_pos (by norm_num) p
  have hmain :
      20000 * ((d : ℝ) + Real.log (2 * ((2 ^ p : ℕ) : ℝ))) * Real.log (2 * (d : ℝ)) ≤ (s : ℝ) →
      (1 / 2 : ℝ) ≤
        (signedHadamardUniformRowTraceProbability (m := 2 ^ p) (s := s) hm).eventProb
          {z | let Q := signedHadamardBasis (walshRotation p) U z.1
               let W := uniformScaledRowSketch Q z.2
               let L := hadamardJointRowRadius (2 ^ p) d (1 / 2)
               (∀ i, rowNormSq Q i ≤ L / ((2 ^ p : ℕ) : ℝ)) ∧
               opNorm2 (fun j k => finiteIdMatrix j k - rowGram W j k) ≤ (1 / 2 : ℝ) ∧
               Matrix.rank (W : Matrix (Fin s) (Fin d) ℝ) = d ∧
               ∀ t, fullRankLeverageProb W t ≤ 2 * L / ((s : ℝ) * (d : ℝ))} := by
    intro hbudget
    have hbudget' := (signedHadamard_fixed_budget_le hm hd).trans hbudget
    have hp := signedHadamardUniformRowTraceProbability_joint_geometry_of_sample_count
      (walshRotation p) U (isOrthogonal_sqrt_inv_nat_mul_sylvesterSignPattern p)
      (hadamardFlat_sqrt_inv_nat_mul_sylvesterSignPattern p) hU hm hd
      (by exact_mod_cast hs) (by norm_num : (0 : ℝ) < 1 / 2) (by norm_num)
      (by norm_num : (0 : ℝ) < 1 / 2) (by norm_num) hbudget'
    have hp' := (show (1 / 2 : ℝ) ≤ 1 - (1 / 2 : ℝ) by norm_num).trans hp
    apply hp'.trans
    apply FiniteProbability.eventProb_mono
    intro z hz
    have hcap : ∀ i, ((2 ^ p : ℕ) : ℝ) *
        rowNormSq (signedHadamardBasis (walshRotation p) U z.1) i ≤
          hadamardJointRowRadius (2 ^ p) d (1 / 2) := by
      intro i
      have hi := (le_div_iff₀ (by positivity : (0 : ℝ) < ((2 ^ p : ℕ) : ℝ))).mp (hz.1 i)
      simpa only [mul_comm] using hi
    have hrank := uniformScaledRowSketch_rank_and_leverage_of_row_cap
      (signedHadamardBasis (walshRotation p) U z.1) z.2 (by exact_mod_cast hs) hcap hz.2.2.1
    exact ⟨hz.1, hz.2.2.2, hrank.1, hrank.2⟩
  refine ⟨hmain, ?_⟩
  intro hregime hbudget
  apply hmain
  have hdR : (1 : ℝ) ≤ (d : ℝ) := by exact_mod_cast hd
  have hlog : 0 ≤ Real.log (2 * (d : ℝ)) := Real.log_nonneg (by linarith)
  have hsum : (d : ℝ) + Real.log (2 * ((2 ^ p : ℕ) : ℝ)) ≤ 2 * (d : ℝ) := by linarith
  have hscaled := mul_le_mul_of_nonneg_right hsum hlog
  nlinarith

theorem signedWalshCoherenceGuarantees : Targets.signedWalshCoherenceGuarantees :=
  ⟨signedWalshExactGeometry, signedWalshMassSpreading,
    sampledWalshProjectorCoherence, signedWalshCoherenceSampleScale⟩

end NumStability.Source.DrineasMahoney.RandNLA2016.Proofs
