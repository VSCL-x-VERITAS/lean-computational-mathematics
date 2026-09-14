import ComputationalMathematics.HDP.Scalar.IndependentSums.McDiarmidProduct

/-!
# Frozen contract signature for Theorem 2.9.1

This proof-free signature records McDiarmid's bounded-differences inequality.
Independent random variables are represented by their marginal laws on the
canonical product trajectory.  The single count `N` resolves the source's
printed `N`/`n` notational mismatch.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Contract

def hdp_02_hthm_h2_d9_d1__contract_type : Prop :=
  ∀ {X : ℕ → Type*} [∀ n, MeasurableSpace (X n)] [∀ n, StandardBorelSpace (X n)]
    (μ : (n : ℕ) → Measure (X n)) [∀ n, IsProbabilityMeasure (μ n)]
    {f : ((n : ℕ) → X n) → ℝ} {c : ℕ → ℝ} {N : ℕ} {t : ℝ},
    0 < N →
      Measurable f →
      DependsOn f (Set.Iio N) →
      NumStability.HDP.Scalar.IndependentSums.McDiarmid.SeqBoundedDifferences f c N →
      (∀ i < N, 0 < c i) →
      0 < t →
      (NumStability.HDP.Scalar.IndependentSums.McDiarmid.shiftedIndependentTraj
          (X := X) μ).real
          {z | t ≤ f (NumStability.HDP.Scalar.IndependentSums.McDiarmid.shiftedTail z) -
            ∫ w, f (NumStability.HDP.Scalar.IndependentSums.McDiarmid.shiftedTail w)
              ∂(NumStability.HDP.Scalar.IndependentSums.McDiarmid.shiftedIndependentTraj
                (X := X) μ)}
        ≤ Real.exp (-2 * t ^ 2 / ∑ i ∈ Finset.range N, c i ^ 2)

end NumStability.HDP.Contract
