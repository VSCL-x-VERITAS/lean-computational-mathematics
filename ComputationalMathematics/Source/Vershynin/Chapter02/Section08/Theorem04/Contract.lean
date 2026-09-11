import ComputationalMathematics.HDP.Scalar.IndependentSums.Bernstein
import ComputationalMathematics.Source.Vershynin.Chapter02.Section08.Theorem04.Signature

/-! Source-facing effective-domain form of Theorem 2.8.4. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.IndependentSums.Bernstein

/-- Theorem 2.8.4 on the domain where its printed quotient is defined, with
the exact null tail supplied separately when the denominator vanishes. -/
theorem hdp_02_hthm_h2_d8_d4_effectiveDomain :
    hdp_02_hthm_h2_d8_d4_effectiveDomain__contract_type := by
  classical
  intro ι Ω _ _ μ _ X K hne hMeas hCenter hBound hIndep
  dsimp only
  set σ2 : ℝ := ∑ i, ∫ ω, X i ω ^ 2 ∂μ with hσ2
  have hKnonneg : 0 ≤ K := by
    obtain ⟨i, _⟩ := hne
    obtain ⟨ω, hω⟩ := (hBound i).exists
    exact (abs_nonneg (X i ω)).trans hω
  have hσ2nonneg : 0 ≤ σ2 := by
    rw [hσ2]
    exact Finset.sum_nonneg fun i _ => integral_nonneg fun ω => sq_nonneg (X i ω)
  have hσ2zero_of_K_zero (hKzero : K = 0) : σ2 = 0 := by
    have hXzero_ae : ∀ i, X i =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) := by
      intro i
      filter_upwards [hBound i] with ω hω
      have habs : |X i ω| = 0 := by
        apply le_antisymm
        · simpa [hKzero] using hω
        · exact abs_nonneg _
      exact abs_eq_zero.mp habs
    rw [hσ2]
    apply Finset.sum_eq_zero
    intro i _
    calc
      (∫ ω, X i ω ^ 2 ∂μ) = ∫ _ω, (0 : ℝ) ∂μ := by
        apply integral_congr_ae
        filter_upwards [hXzero_ae i] with ω hω
        simp [hω]
      _ = 0 := by simp
  have hnull_of_σ2_zero (hσ2zero : σ2 = 0) {t : ℝ} (ht : 0 < t) :
      μ.real {ω | |∑ i, X i ω| ≥ t} ≤ 0 := by
    have hSqInt : ∀ i, Integrable (fun ω => X i ω ^ 2) μ := by
      intro i
      have hStrong : AEStronglyMeasurable (fun ω => X i ω ^ 2) μ :=
        ((hMeas i).pow_const 2).aestronglyMeasurable
      refine Integrable.mono' (g := fun _ => K ^ 2) (integrable_const _) hStrong ?_
      filter_upwards [hBound i] with ω hω
      rw [Real.norm_eq_abs, abs_of_nonneg (sq_nonneg _), ← sq_abs]
      nlinarith [abs_nonneg (X i ω), hω]
    have hEachZero : ∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 0 := by
      have hAll := (Finset.sum_eq_zero_iff_of_nonneg
        (fun i _ => integral_nonneg fun ω => sq_nonneg (X i ω))).1 (by
          simpa [hσ2] using hσ2zero)
      intro i
      exact hAll i (Finset.mem_univ i)
    have hXzero : ∀ i, X i =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) := by
      intro i
      have hSqZero : (fun ω => X i ω ^ 2) =ᵐ[μ] (fun _ => (0 : ℝ)) :=
        (integral_eq_zero_iff_of_nonneg
          (fun ω => sq_nonneg (X i ω)) (hSqInt i)).1 (hEachZero i)
      filter_upwards [hSqZero] with ω hω
      nlinarith [sq_nonneg (X i ω)]
    have hAllZero : ∀ᵐ ω ∂μ,
        ∀ i ∈ (Finset.univ : Finset ι), X i ω = 0 := by
      rw [Filter.eventually_all_finset]
      intro i _
      exact hXzero i
    have hSumZero : ∀ᵐ ω ∂μ, (∑ i, X i ω) = 0 := by
      filter_upwards [hAllZero] with ω hω
      simp [hω]
    have hEventNull : μ {ω | |∑ i, X i ω| ≥ t} = 0 := by
      have hEventAE : {ω | |∑ i, X i ω| ≥ t} =ᵐ[μ] (∅ : Set Ω) := by
        filter_upwards [hSumZero] with ω hω
        apply propext
        change (t ≤ |∑ i, X i ω|) ↔ False
        rw [hω, abs_zero]
        exact iff_false_intro (not_le_of_gt ht)
      simpa using measure_congr hEventAE
    rw [Measure.real_def, hEventNull, ENNReal.toReal_zero]
  intro t ht
  set D : ℝ := σ2 + K * t / 3 with hD
  refine ⟨?_, ?_⟩
  · intro hDpos
    by_cases hKzero : K = 0
    · have hσ2zero := hσ2zero_of_K_zero hKzero
      have hDzero : D = 0 := by simp [hD, hσ2zero, hKzero]
      rw [hDzero] at hDpos
      exact (lt_irrefl (0 : ℝ) hDpos).elim
    · have hKpos : 0 < K := lt_of_le_of_ne hKnonneg (Ne.symm hKzero)
      have htail := bernsteinBoundedTail hKpos hMeas hCenter hBound hIndep ht
      simpa [σ2, D] using htail
  · intro hDzero
    by_cases htzero : t = 0
    · rw [if_pos htzero]
      have hprob : μ.real {ω | |∑ i, X i ω| ≥ t} ≤ 1 := by
        rw [Measure.real_def]
        exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one
      linarith
    · rw [if_neg htzero]
      have htpos : 0 < t := lt_of_le_of_ne ht (Ne.symm htzero)
      have hKtNonneg : 0 ≤ K * t / 3 := by positivity
      have hσ2zero : σ2 = 0 := by
        rw [hD] at hDzero
        linarith
      exact hnull_of_σ2_zero hσ2zero htpos

end NumStability.HDP.Contract
