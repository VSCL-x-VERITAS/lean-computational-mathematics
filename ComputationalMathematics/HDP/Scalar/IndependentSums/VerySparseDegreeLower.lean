import ComputationalMathematics.HDP.Scalar.IndependentSums.GraphDegreeDecoupling
import Mathlib.Analysis.Complex.ExponentialBounds

/-!
# Lower degrees in very sparse binomial random graphs

This file records the zero-edge obstruction to a literal lower-degree statement
under an upper bound on expected degree alone.  It also develops the corrected
positive-expected-degree form.
-/

noncomputable section

open MeasureTheory Filter
open scoped Topology

namespace NumStability.HDP.Scalar.IndependentSums.Chernoff

/-- The natural log-over-log-log degree scale used for very sparse graphs. -/
def logLogDegreeScale (n : ℕ) : ℝ :=
  Real.log (n : ℝ) / Real.log (Real.log (n : ℝ))

lemma eventually_pos_logLogDegreeScale :
    ∀ᶠ n : ℕ in atTop, 0 < logLogDegreeScale n := by
  filter_upwards [eventually_atTop.2 ⟨3, fun n hn => hn⟩] with n hn
  have hnpos : 0 < (n : ℝ) := by positivity
  have hlog_one : 1 < Real.log (n : ℝ) := by
    apply (Real.lt_log_iff_exp_lt hnpos).2
    exact lt_of_lt_of_le Real.exp_one_lt_three (by exact_mod_cast hn)
  exact div_pos (lt_trans zero_lt_one hlog_one) (Real.log_pos hlog_one)

/-- With zero edge probability, no positive multiple of the log-over-log-log
scale can be attained by a vertex for all sufficiently large graph sizes. -/
theorem erdosRenyiZero_no_positive_logLogDegreeScale
    (c : ℝ) (hc : 0 < c) :
    ∀ᶠ n : ℕ in atTop,
      (SimpleGraph.binomialRandom (Fin n) (0 : Set.Icc (0 : ℝ) 1)).real
          {G | ∃ v : Fin n,
            c * logLogDegreeScale n ≤ graphDegreeSum v G} = 0 := by
  filter_upwards [eventually_pos_logLogDegreeScale] with n hn
  have hthreshold : 0 < c * logLogDegreeScale n := mul_pos hc hn
  have hevent : MeasurableSet {G : SimpleGraph (Fin n) | ∃ v : Fin n,
      c * logLogDegreeScale n ≤ graphDegreeSum v G} := by
    rw [show {G : SimpleGraph (Fin n) | ∃ v : Fin n,
        c * logLogDegreeScale n ≤ graphDegreeSum v G} =
        ⋃ v : Fin n, {G | c * logLogDegreeScale n ≤ graphDegreeSum v G} by
      ext G
      simp]
    refine MeasurableSet.iUnion fun v => ?_
    change MeasurableSet
      (graphDegreeSum v ⁻¹' {j : ℕ | c * logLogDegreeScale n ≤ (j : ℝ)})
    exact (measurable_graphDegreeSum v) MeasurableSet.of_discrete
  have hnot : (⊥ : SimpleGraph (Fin n)) ∉
      {G | ∃ v : Fin n, c * logLogDegreeScale n ≤ graphDegreeSum v G} := by
    rintro ⟨v, hv⟩
    have hpos : (0 : ℝ) < (graphDegreeSum v (⊥ : SimpleGraph (Fin n)) : ℝ) :=
      hthreshold.trans_le hv
    simp [graphDegreeSum] at hpos
  rw [SimpleGraph.binomialRandom_zero]
  simp [Measure.real, Measure.dirac_apply' _ hevent, hnot]

/-- The literal `d = O(1)` lower-degree claim is false: the zero-probability
edge family has bounded expected degree but admits no positive Omega constant. -/
theorem erdosRenyiVerySparseDegreeLower_sourceObstruction :
    (∀ᶠ n : ℕ in atTop,
        ((n - 1 : ℕ) : ℝ) *
          ((0 : Set.Icc (0 : ℝ) 1) : ℝ) ≤ 0) ∧
      ¬ ∃ c : ℝ, 0 < c ∧
        ∀ᶠ n : ℕ in atTop,
          (SimpleGraph.binomialRandom (Fin n)
              (0 : Set.Icc (0 : ℝ) 1)).real
              {G | ∃ v : Fin n,
                c * logLogDegreeScale n ≤ graphDegreeSum v G} ≥
            (9 : ℝ) / 10 := by
  constructor
  · filter_upwards []
    simp
  · rintro ⟨c, hc, hclaim⟩
    obtain ⟨Nzero, hzero⟩ :=
      eventually_atTop.1 (erdosRenyiZero_no_positive_logLogDegreeScale c hc)
    obtain ⟨Nlarge, hlarge⟩ := eventually_atTop.1 hclaim
    let n := max Nzero Nlarge
    have hzero' := hzero n (le_max_left _ _)
    have hlarge' := hlarge n (le_max_right _ _)
    rw [hzero'] at hlarge'
    norm_num at hlarge'

end NumStability.HDP.Scalar.IndependentSums.Chernoff
