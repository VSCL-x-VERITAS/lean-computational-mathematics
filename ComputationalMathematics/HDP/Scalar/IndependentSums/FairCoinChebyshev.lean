import ComputationalMathematics.HDP.Scalar.IndependentSums.FairCoinMoments
import ComputationalMathematics.HDP.Scalar.Preliminaries

/-!
# Chebyshev's bound for a fair-coin count

The motivating finite-sample estimate at the start of Chapter 2, derived from
the reusable fair-coin moment identities and Chebyshev's inequality.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Scalar.IndependentSums.FairCoinChebyshev

open NumStability.HDP.Scalar.IndependentSums.Hoeffding
open NumStability.HDP.Scalar.IndependentSums.FairCoinMoments

/-- Chebyshev's inequality gives the printed `4 / N` upper bound for at least
`3N/4` heads in `N` independent fair tosses. -/
theorem fairBernoulliSum_chebyshev
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool}
    (hN : 0 < Fintype.card ι)
    (hB : ∀ i, Measurable (B i))
    (hIndep : iIndepFun B μ)
    (hLaw : ∀ i, Measure.map (B i) μ = fairBernoulliPMF.toMeasure) :
    μ.real {ω | ∑ i, bernoulliIndicator (B i ω) ≥
        (3 / 4 : ℝ) * (Fintype.card ι : ℝ)} ≤
      μ.real {ω | |∑ i, bernoulliIndicator (B i ω) -
        (Fintype.card ι : ℝ) / 2| ≥
          (Fintype.card ι : ℝ) / 4} ∧
    μ.real {ω | |∑ i, bernoulliIndicator (B i ω) -
        (Fintype.card ι : ℝ) / 2| ≥
          (Fintype.card ι : ℝ) / 4} ≤
      4 / (Fintype.card ι : ℝ) := by
  let X : ι → Ω → ℝ := fun i ω ↦ bernoulliIndicator (B i ω)
  let S : Ω → ℝ := fun ω ↦ ∑ i, X i ω
  let n : ℝ := Fintype.card ι
  have hn : 0 < n := by
    have hn' : (0 : ℝ) < (Fintype.card ι : ℝ) := by
      exact_mod_cast hN
    simpa [n] using hn'
  have hXmeas : ∀ i, Measurable (X i) := by
    intro i
    exact (measurable_of_countable bernoulliIndicator).comp (hB i)
  have hXmem : ∀ i, MemLp (X i) 2 μ := by
    intro i
    refine MemLp.of_bound (hXmeas i).aestronglyMeasurable 1 ?_
    filter_upwards [] with ω
    cases h : B i ω <;> simp [X, bernoulliIndicator, h]
  have hSmeas : Measurable S := by
    dsimp [S]
    exact Finset.measurable_sum Finset.univ (fun i _ ↦ hXmeas i)
  have hSmem : MemLp S 2 μ := by
    dsimp [S]
    exact memLp_finset_sum Finset.univ (fun i _ ↦ hXmem i)
  have hMom := fairBernoulliSum_mean_variance hB hIndep hLaw
  have hMean : NumStability.HDP.Scalar.Preliminaries.expectation μ S = n / 2 := by
    simpa [NumStability.HDP.Scalar.Preliminaries.expectation, S, X, n] using hMom.1
  have hVar : NumStability.HDP.Scalar.Preliminaries.variance μ S = n / 4 := by
    calc
      NumStability.HDP.Scalar.Preliminaries.variance μ S = Var[S; μ] := by
        exact (variance_eq_integral hSmeas.aemeasurable).symm
      _ = n / 4 := by simpa [S, X, n] using hMom.2
  have hCenteredSq : Integrable
      (fun ω ↦ (S ω - NumStability.HDP.Scalar.Preliminaries.expectation μ S) ^ 2)
      μ :=
    (hSmem.sub (memLp_const _)).integrable_sq
  have hCheb := NumStability.HDP.Scalar.Preliminaries.chebyshevEventBound
    hSmeas (hSmem.integrable (by norm_num)) hCenteredSq
      (t := n / 4) (by positivity)
  constructor
  · rw [show {ω | ∑ i, bernoulliIndicator (B i ω) ≥
        (3 / 4 : ℝ) * (Fintype.card ι : ℝ)} =
      {ω | S ω ≥ (3 / 4 : ℝ) * n} by rfl]
    rw [show {ω | |∑ i, bernoulliIndicator (B i ω) -
        (Fintype.card ι : ℝ) / 2| ≥
          (Fintype.card ι : ℝ) / 4} =
      {ω | |S ω - n / 2| ≥ n / 4} by rfl]
    rw [Measure.real_def, Measure.real_def]
    apply ENNReal.toReal_mono (measure_ne_top μ _)
    apply measure_mono
    intro ω hω
    change (3 / 4 : ℝ) * n ≤ S ω at hω
    change n / 4 ≤ |S ω - n / 2|
    calc
      n / 4 ≤ S ω - n / 2 := by linarith
      _ ≤ |S ω - n / 2| := le_abs_self _
  · rw [hMean, hVar] at hCheb
    have hratio : (n / 4) / (n / 4) ^ 2 = 4 / n := by
      field_simp [ne_of_gt hn]
      <;> ring
    rw [hratio] at hCheb
    simpa [S, X, n] using hCheb

end NumStability.HDP.Scalar.IndependentSums.FairCoinChebyshev
