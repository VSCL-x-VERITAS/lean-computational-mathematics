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

/-- The log-over-log-log scale diverges along the natural numbers. -/
lemma tendsto_logLogDegreeScale_atTop :
    Filter.Tendsto logLogDegreeScale Filter.atTop Filter.atTop := by
  have hlog : Filter.Tendsto (fun n : ℕ => Real.log (n : ℝ))
      Filter.atTop Filter.atTop :=
    Real.tendsto_log_atTop.comp tendsto_natCast_atTop_atTop
  have hratio : Filter.Tendsto
      (fun n : ℕ => Real.log (Real.log (n : ℝ)) / Real.log (n : ℝ))
      Filter.atTop (nhds 0) := by
    have hsmall := Real.isLittleO_log_id_atTop.comp_tendsto hlog
    simpa [Function.comp_def] using hsmall.tendsto_div_nhds_zero
  have hratioPos : ∀ᶠ n : ℕ in Filter.atTop,
      0 < Real.log (Real.log (n : ℝ)) / Real.log (n : ℝ) := by
    filter_upwards [Filter.eventually_atTop.2 ⟨3, fun n hn => hn⟩] with n hn
    have hnpos : 0 < (n : ℝ) := by positivity
    have hlogOne : 1 < Real.log (n : ℝ) := by
      apply (Real.lt_log_iff_exp_lt hnpos).2
      exact lt_of_lt_of_le Real.exp_one_lt_three (by exact_mod_cast hn)
    exact div_pos (Real.log_pos hlogOne) (lt_trans zero_lt_one hlogOne)
  have hratioGT : Filter.Tendsto
      (fun n : ℕ => Real.log (Real.log (n : ℝ)) / Real.log (n : ℝ))
      Filter.atTop (𝓝[>] 0) :=
    tendsto_nhdsWithin_iff.mpr ⟨hratio, hratioPos⟩
  have hinv := hratioGT.inv_tendsto_nhdsGT_zero
  apply hinv.congr'
  filter_upwards [Filter.eventually_atTop.2 ⟨3, fun n hn => hn⟩] with n hn
  have hnpos : 0 < (n : ℝ) := by positivity
  have hlogOne : 1 < Real.log (n : ℝ) := by
    apply (Real.lt_log_iff_exp_lt hnpos).2
    exact lt_of_lt_of_le Real.exp_one_lt_three (by exact_mod_cast hn)
  have hlogne : Real.log (n : ℝ) ≠ 0 := ne_of_gt (lt_trans zero_lt_one hlogOne)
  have hloglogne : Real.log (Real.log (n : ℝ)) ≠ 0 :=
    ne_of_gt (Real.log_pos hlogOne)
  dsimp [logLogDegreeScale]
  field_simp

/-- A concrete integer threshold on the log-over-log-log scale. -/
def verySparseDegreeThreshold (n : ℕ) : ℕ :=
  ⌊logLogDegreeScale n / 64⌋₊

lemma tendsto_verySparseDegreeThreshold_atTop :
    Filter.Tendsto verySparseDegreeThreshold Filter.atTop Filter.atTop := by
  exact tendsto_nat_floor_atTop.comp
    (tendsto_logLogDegreeScale_atTop.atTop_div_const (by norm_num : (0 : ℝ) < 64))

/-- The chosen threshold is still little-oh of `log n`. -/
lemma tendsto_verySparseDegreeThreshold_div_log :
    Filter.Tendsto
      (fun n : ℕ => (verySparseDegreeThreshold n : ℝ) / Real.log (n : ℝ))
      Filter.atTop (nhds 0) := by
  have hloglog : Filter.Tendsto
      (fun n : ℕ => Real.log (Real.log (n : ℝ))) Filter.atTop Filter.atTop := by
    exact Real.tendsto_log_atTop.comp
      (Real.tendsto_log_atTop.comp tendsto_natCast_atTop_atTop)
  have hupperLim : Filter.Tendsto
      (fun n : ℕ => (64 * Real.log (Real.log (n : ℝ)))⁻¹)
      Filter.atTop (nhds 0) := by
    exact tendsto_inv_atTop_zero.comp
      (hloglog.const_mul_atTop (by norm_num : (0 : ℝ) < 64))
  apply tendsto_of_tendsto_of_tendsto_of_le_of_le'
      tendsto_const_nhds hupperLim
  · filter_upwards [Filter.eventually_atTop.2 ⟨2, fun n hn => hn⟩] with n hn
    exact div_nonneg (by positivity)
      (Real.log_nonneg (by exact_mod_cast (show 1 ≤ n by omega)))
  · filter_upwards [Filter.eventually_atTop.2 ⟨3, fun n hn => hn⟩] with n hn
    have hnpos : 0 < (n : ℝ) := by positivity
    have hlogOne : 1 < Real.log (n : ℝ) := by
      apply (Real.lt_log_iff_exp_lt hnpos).2
      exact lt_of_lt_of_le Real.exp_one_lt_three (by exact_mod_cast hn)
    have hlogpos : 0 < Real.log (n : ℝ) := lt_trans zero_lt_one hlogOne
    have hloglogpos : 0 < Real.log (Real.log (n : ℝ)) := Real.log_pos hlogOne
    have hfloor : (verySparseDegreeThreshold n : ℝ) ≤
        logLogDegreeScale n / 64 := by
      simpa [verySparseDegreeThreshold] using Nat.floor_le
        (div_nonneg (div_nonneg hlogpos.le hloglogpos.le) (by norm_num : (0 : ℝ) ≤ 64))
    rw [div_le_iff₀ hlogpos]
    rw [show (64 * Real.log (Real.log (n : ℝ)))⁻¹ * Real.log (n : ℝ) =
        logLogDegreeScale n / 64 by
      dsimp [logLogDegreeScale]
      field_simp]
    exact hfloor

/-- The integer threshold retains a fixed positive fraction of the
log-over-log-log scale. -/
lemma eventually_logLogDegreeScale_div_128_le_threshold :
    ∀ᶠ n : ℕ in Filter.atTop,
      logLogDegreeScale n / 128 ≤ (verySparseDegreeThreshold n : ℝ) := by
  filter_upwards [tendsto_logLogDegreeScale_atTop.eventually_ge_atTop 128]
    with n hn
  have hx : 2 ≤ logLogDegreeScale n / 64 := by linarith
  have hfloorlt : logLogDegreeScale n / 64 <
      (⌊logLogDegreeScale n / 64⌋₊ : ℝ) + 1 :=
    Nat.lt_floor_add_one _
  dsimp [verySparseDegreeThreshold]
  nlinarith

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
