import ComputationalMathematics.HDP.Scalar.GaussianMaxima

/-!
# Frozen contract signature for Exercise 2.5.11

The source indices `1, …, N` are represented by the first `N` zero-based
coordinates of a sequence.  The signed maximum is totalized only at the empty
prefix, which is excluded by the source's positive-cardinality hypothesis.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.GaussianMaxima
open NumStability.HDP.Scalar.LimitTheorems

def hdp_02_hex_h2_d5_d11__contract_type : Prop :=
  ∃ c : ℝ, 0 < c ∧
    ∀ (Ω : Type*) [MeasurableSpace Ω]
      (μ : Measure Ω) [IsProbabilityMeasure μ]
      (X : ℕ → Ω → ℝ) (N : ℕ),
      0 < N →
      (∀ i : Fin N, Measurable (X i)) →
      (∀ i : Fin N, HasLaw (X i) standardNormalLaw μ) →
      iIndepFun (fun i : Fin N => X i) μ →
      Integrable (prefixMaximum X N) μ ∧
        c * Real.sqrt (Real.log (N : ℝ)) ≤
          ∫ ω, prefixMaximum X N ω ∂μ

end NumStability.HDP.Contract
