import ComputationalMathematics.HDP.Scalar.LimitTheorems

/-!
Cross-split stable API for `HDP-01-DEF-BERNOULLI-BINOMIAL`.

This is a real forwarding definition.  The semantic producer owns the
canonical laws and their proofs; this leaf owns only the stable contract name
used by Chapters 2 and 3.
-/

namespace NumStability.HDP.Contract

open MeasureTheory
open scoped NNReal

/-- Stable source-facing bundle of the Bernoulli and binomial laws. -/
noncomputable def hdp_01_hdef_hbernoulli_hbinomial
    (p : ℝ≥0) (hp : p ≤ 1) (N : ℕ) :
    NumStability.HDP.Scalar.LimitTheorems.BernoulliBinomialModelData p hp N :=
  NumStability.HDP.Scalar.LimitTheorems.bernoulliBinomialModel p hp N

/--
The Bernoulli component of the Chapter 1 model: support and point masses,
together with the printed mean and variance identities.
-/
theorem hdp_01_hdef_hbernoulli (p : ℝ≥0) (hp0 : 0 < p) (hp1 : p < 1) :
    NumStability.HDP.Scalar.LimitTheorems.bernoulliNatPMF p (le_of_lt hp1) 1 = p ∧
      NumStability.HDP.Scalar.LimitTheorems.bernoulliNatPMF p (le_of_lt hp1) 0 = 1 - p ∧
      (∀ k : ℕ, k ≠ 0 → k ≠ 1 →
        NumStability.HDP.Scalar.LimitTheorems.bernoulliNatPMF p (le_of_lt hp1) k = 0) ∧
      (∫ x : ℝ, x ∂
          (NumStability.HDP.Scalar.LimitTheorems.bernoulliRealPMF p
            (le_of_lt hp1)).toMeasure) =
        p.toReal ∧
      (∫ x : ℝ, (x - p.toReal) ^ 2 ∂
          (NumStability.HDP.Scalar.LimitTheorems.bernoulliRealPMF p
            (le_of_lt hp1)).toMeasure) =
        p.toReal * (1 - p.toReal) := by
  have hp : p ≤ 1 := le_of_lt hp1
  exact
    ⟨NumStability.HDP.Scalar.LimitTheorems.bernoulliNatPMF_apply_one,
      NumStability.HDP.Scalar.LimitTheorems.bernoulliNatPMF_apply_zero,
      fun _ hk0 hk1 =>
        NumStability.HDP.Scalar.LimitTheorems.bernoulliNatPMF_apply_of_ne_zero_one
          hk0 hk1,
      NumStability.HDP.Scalar.LimitTheorems.bernoulliRealPMF_mean p hp,
      NumStability.HDP.Scalar.LimitTheorems.bernoulliRealPMF_variance p hp⟩

/--
The binomial component of the Chapter 1 model: the success count of the
canonical vector of `N` Bernoulli trials has the binomial law.
-/
theorem hdp_01_hdef_hbinomial
    (p : ℝ≥0) (hp0 : 0 < p) (hp1 : p < 1) (N : ℕ) (hN : 0 < N) :
    (NumStability.HDP.Scalar.LimitTheorems.bernoulliTrialVectorPMF p
      (le_of_lt hp1) N).map
        (NumStability.HDP.Scalar.LimitTheorems.bernoulliSuccessCount N) =
      NumStability.HDP.Scalar.LimitTheorems.binomialNatPMF p (le_of_lt hp1) N := by
  exact
    NumStability.HDP.Scalar.LimitTheorems.bernoulliSumPMF_eq_binomialNatPMF
      p (le_of_lt hp1) N

end NumStability.HDP.Contract
