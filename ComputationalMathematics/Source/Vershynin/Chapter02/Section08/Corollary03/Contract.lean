import ComputationalMathematics.HDP.Scalar.IndependentSums.Bernstein
import ComputationalMathematics.Source.Vershynin.Chapter02.Section08.Corollary03.Signature

/-! Source-facing effective-domain form of Corollary 2.8.3. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubExponential
open NumStability.HDP.Scalar.IndependentSums.Bernstein

/-- Corollary 2.8.3 on the domain where its printed rates are defined, with
the exact null tail supplied separately at zero maximal `ψ₁` gauge. -/
theorem hdp_02_hcor_h2_d8_d3_effectiveDomain :
    hdp_02_hcor_h2_d8_d3_effectiveDomain__contract_type := by
  classical
  rcases bernsteinAverageTailPsiOne with ⟨c, hc, htail⟩
  refine ⟨c, hc, ?_⟩
  intro ι Ω _ _ μ _ X hne hMeas hCenter hSubExp hIndep
  dsimp only
  set κ : ι → ℝ := fun i => (PsiOneGauge μ (X i)).toReal with hκ
  set K : ℝ := Finset.univ.sup' hne κ with hK
  refine ⟨?_, ?_⟩
  · intro _ t ht
    have h := htail hne hMeas hCenter hSubExp hIndep ht
    simpa [κ, K] using h
  · intro hKzero t ht
    by_cases htzero : t = 0
    · rw [if_pos htzero]
      have hprob :
          μ.real {ω | |∑ i, (Fintype.card ι : ℝ)⁻¹ * X i ω| ≥ t} ≤ 1 := by
        rw [Measure.real_def]
        exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one
      linarith
    · rw [if_neg htzero]
      have htpos : 0 < t := lt_of_le_of_ne ht (Ne.symm htzero)
      have hXzero : ∀ i, X i =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) := by
        intro i
        have hκnonneg : 0 ≤ κ i := ENNReal.toReal_nonneg
        have hκle : κ i ≤ K := by
          rw [hK]
          exact Finset.le_sup' κ (Finset.mem_univ i)
        have hκzero : κ i = 0 := by linarith
        apply (psiOneGauge_eq_zero_iff_ae_eq_zero (hMeas i)).mp
        have hToReal : (PsiOneGauge μ (X i)).toReal = 0 := by
          simpa [κ] using hκzero
        exact ((ENNReal.toReal_eq_zero_iff _).mp hToReal).resolve_right
          (hSubExp i).ne
      have hAllZero : ∀ᵐ ω ∂μ,
          ∀ i ∈ (Finset.univ : Finset ι), X i ω = 0 := by
        rw [Filter.eventually_all_finset]
        intro i _
        exact hXzero i
      have hSumZero : ∀ᵐ ω ∂μ,
          (∑ i, (Fintype.card ι : ℝ)⁻¹ * X i ω) = 0 := by
        filter_upwards [hAllZero] with ω hω
        simp [hω]
      have hEventNull :
          μ {ω | |∑ i, (Fintype.card ι : ℝ)⁻¹ * X i ω| ≥ t} = 0 := by
        have hEventAE :
            {ω | |∑ i, (Fintype.card ι : ℝ)⁻¹ * X i ω| ≥ t} =ᵐ[μ]
              (∅ : Set Ω) := by
          filter_upwards [hSumZero] with ω hω
          apply propext
          change (t ≤ |∑ i, (Fintype.card ι : ℝ)⁻¹ * X i ω|) ↔ False
          rw [hω, abs_zero]
          exact iff_false_intro (not_le_of_gt htpos)
        simpa using measure_congr hEventAE
      rw [Measure.real_def, hEventNull, ENNReal.toReal_zero]

end NumStability.HDP.Contract
