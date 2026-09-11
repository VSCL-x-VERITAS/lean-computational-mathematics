import ComputationalMathematics.HDP.Scalar.IndependentSums.Bernstein
import ComputationalMathematics.Source.Vershynin.Chapter02.Section08.Theorem02.Signature

/-! Source-facing effective-domain form of Theorem 2.8.2. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubExponential
open NumStability.HDP.Scalar.IndependentSums.Bernstein

/-- Theorem 2.8.2 on the domain where its printed quotients are defined, with
the exact null tail supplied separately at zero weighted scale. -/
theorem hdp_02_hthm_h2_d8_d2_effectiveDomain :
    hdp_02_hthm_h2_d8_d2_effectiveDomain__contract_type := by
  classical
  rcases bernsteinWeightedTailPsiOne with ⟨c, hc, htail⟩
  refine ⟨c, hc, ?_⟩
  intro ι Ω _ _ μ _ X a hne hMeas hCenter hSubExp hIndep
  dsimp only
  set κ : ι → ℝ := fun i => (PsiOneGauge μ (X i)).toReal with hκ
  set K : ℝ := Finset.univ.sup' hne κ with hK
  set A : ℝ := K ^ 2 * ∑ i, a i ^ 2 with hA
  set B : ℝ := K * Finset.univ.sup' hne (fun i => |a i|) with hB
  refine ⟨?_, ?_⟩
  · intro _ t ht
    have h := htail (a := a) hne hMeas hCenter hSubExp hIndep ht
    simpa [κ, K, A, B] using h
  · intro hAzero t ht
    by_cases htzero : t = 0
    · rw [if_pos htzero]
      have hprob : μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤ 1 := by
        rw [Measure.real_def]
        exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one
      linarith
    · rw [if_neg htzero]
      have htpos : 0 < t := lt_of_le_of_ne ht (Ne.symm htzero)
      have hScaleSplit : K ^ 2 = 0 ∨ (∑ i, a i ^ 2) = 0 := by
        apply mul_eq_zero.mp
        simpa [A] using hAzero
      have hTermZero : ∀ i, (fun ω => a i * X i ω) =ᵐ[μ]
          (fun _ : Ω => (0 : ℝ)) := by
        intro i
        rcases hScaleSplit with hKsq | haEnergy
        · have hKzero : K = 0 := by nlinarith [sq_nonneg K]
          have hκnonneg : 0 ≤ κ i := ENNReal.toReal_nonneg
          have hκle : κ i ≤ K := by
            rw [hK]
            exact Finset.le_sup' κ (Finset.mem_univ i)
          have hκzero : κ i = 0 := by linarith
          have hGaugeZero : PsiOneGauge μ (X i) = 0 := by
            have hToReal : (PsiOneGauge μ (X i)).toReal = 0 := by
              simpa [κ] using hκzero
            exact ((ENNReal.toReal_eq_zero_iff _).mp hToReal).resolve_right
              (hSubExp i).ne
          have hXiZero :=
            (psiOneGauge_eq_zero_iff_ae_eq_zero (hMeas i)).mp hGaugeZero
          filter_upwards [hXiZero] with ω hω
          simp [hω]
        · have hAll := (Finset.sum_eq_zero_iff_of_nonneg
            (fun j _ => sq_nonneg (a j))).1 haEnergy
          have hai : a i = 0 := by
            nlinarith [hAll i (Finset.mem_univ i)]
          exact Filter.Eventually.of_forall (fun ω => by simp [hai])
      have hAllZero : ∀ᵐ ω ∂μ,
          ∀ i ∈ (Finset.univ : Finset ι), a i * X i ω = 0 := by
        rw [Filter.eventually_all_finset]
        intro i _
        exact hTermZero i
      have hSumZero : ∀ᵐ ω ∂μ, (∑ i, a i * X i ω) = 0 := by
        filter_upwards [hAllZero] with ω hω
        simp [hω]
      have hEventNull : μ {ω | |∑ i, a i * X i ω| ≥ t} = 0 := by
        have hEventAE : {ω | |∑ i, a i * X i ω| ≥ t} =ᵐ[μ]
            (∅ : Set Ω) := by
          filter_upwards [hSumZero] with ω hω
          apply propext
          change (t ≤ |∑ i, a i * X i ω|) ↔ False
          rw [hω, abs_zero]
          exact iff_false_intro (not_le_of_gt htpos)
        simpa using measure_congr hEventAE
      rw [Measure.real_def, hEventNull, ENNReal.toReal_zero]

end NumStability.HDP.Contract
