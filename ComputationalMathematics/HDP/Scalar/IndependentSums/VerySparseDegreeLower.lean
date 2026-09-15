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

/-- A uniform upper bound on expected degree makes edges internal to the
quarter-power test-center set negligible. -/
lemma eventually_exact_center_internal_mass_le_of_expectedDegree_upper
    (p : ℕ → Set.Icc (0 : ℝ) 1) (C : ℝ) (hC : 0 ≤ C)
    (hupper : ∀ᶠ n : ℕ in Filter.atTop,
      ((n - 1 : ℕ) : ℝ) * (p n : ℝ) ≤ C) :
    ∀ᶠ n : ℕ in Filter.atTop,
      (graphDegreeExactTestCenterCount n : ℝ) ^ 2 * (p n : ℝ) ≤
        (1 : ℝ) / 20 := by
  have hroot : Filter.Tendsto
      (fun n : ℕ => Real.exp (Real.log (n : ℝ) / 2))
      Filter.atTop Filter.atTop := by
    exact Real.tendsto_exp_atTop.comp
      ((Real.tendsto_log_atTop.comp tendsto_natCast_atTop_atTop).atTop_div_const
        (by norm_num))
  filter_upwards [hupper, hroot.eventually_ge_atTop (40 * C),
    Filter.eventually_atTop.2 ⟨2, fun n hn => hn⟩] with n hdegree hlarge hn
  let s : ℝ := Real.exp (Real.log (n : ℝ) / 2)
  let x : ℝ := Real.exp (Real.log (n : ℝ) / 4)
  have hnpos : 0 < (n : ℝ) := by positivity
  have hspos : 0 < s := by dsimp [s]; positivity
  have hsquare : s ^ 2 = (n : ℝ) := by
    dsimp [s]
    rw [pow_two, ← Real.exp_add]
    have hexponent : Real.log (n : ℝ) / 2 + Real.log (n : ℝ) / 2 =
        Real.log (n : ℝ) := by ring
    rw [hexponent, Real.exp_log hnpos]
  have hxSquare : x ^ 2 = s := by
    dsimp [x, s]
    rw [pow_two, ← Real.exp_add]
    congr 1
    ring
  have hcountFloor : graphDegreeExactTestCenterCount n ≤ ⌊x⌋₊ :=
    min_le_right _ _
  have hfloor : (⌊x⌋₊ : ℝ) ≤ x := Nat.floor_le (by positivity)
  have hcount : (graphDegreeExactTestCenterCount n : ℝ) ≤ x := by
    have hcountCast : (graphDegreeExactTestCenterCount n : ℝ) ≤ (⌊x⌋₊ : ℝ) := by
      exact_mod_cast hcountFloor
    exact hcountCast.trans hfloor
  have hcountSq : (graphDegreeExactTestCenterCount n : ℝ) ^ 2 ≤ s := by
    rw [← hxSquare]
    exact pow_le_pow_left₀ (by positivity) hcount 2
  have hnsubpos : (0 : ℝ) < ((n - 1 : ℕ) : ℝ) := by
    exact_mod_cast (show 0 < n - 1 by omega)
  have hp : (p n : ℝ) ≤ C / ((n - 1 : ℕ) : ℝ) := by
    rw [le_div_iff₀ hnsubpos]
    simpa [mul_comm] using hdegree
  have hratio : s * C / ((n - 1 : ℕ) : ℝ) ≤ (1 : ℝ) / 20 := by
    rw [div_le_iff₀ hnsubpos]
    have hnle : (n : ℝ) ≤ 2 * ((n - 1 : ℕ) : ℝ) := by
      exact_mod_cast (show n ≤ 2 * (n - 1) by omega)
    change 40 * C ≤ s at hlarge
    nlinarith [hsquare]
  calc
    (graphDegreeExactTestCenterCount n : ℝ) ^ 2 * (p n : ℝ) ≤
        s * (p n : ℝ) :=
      mul_le_mul_of_nonneg_right hcountSq (p n).2.1
    _ ≤ s * (C / ((n - 1 : ℕ) : ℝ)) :=
      mul_le_mul_of_nonneg_left hp hspos.le
    _ = s * C / ((n - 1 : ℕ) : ℝ) := by ring
    _ ≤ (1 : ℝ) / 20 := hratio

/-- The logarithmic cost of the chosen binomial point mass occupies only a
small fraction of the quarter-power center-set exponent. -/
lemma eventually_two_threshold_mul_log_le_log_div_32 :
    ∀ᶠ n : ℕ in Filter.atTop,
      2 * (verySparseDegreeThreshold n : ℝ) *
          Real.log (verySparseDegreeThreshold n : ℝ) ≤
        Real.log (n : ℝ) / 32 := by
  have hloglog : Filter.Tendsto
      (fun n : ℕ => Real.log (Real.log (n : ℝ))) Filter.atTop Filter.atTop := by
    exact Real.tendsto_log_atTop.comp
      (Real.tendsto_log_atTop.comp tendsto_natCast_atTop_atTop)
  filter_upwards [tendsto_verySparseDegreeThreshold_atTop.eventually_ge_atTop 1,
    hloglog.eventually_ge_atTop 1,
    Filter.eventually_atTop.2 ⟨3, fun n hn => hn⟩] with n hk1 hll1 hn
  have hnpos : 0 < (n : ℝ) := by positivity
  have hlogOne : 1 < Real.log (n : ℝ) := by
    apply (Real.lt_log_iff_exp_lt hnpos).2
    exact lt_of_lt_of_le Real.exp_one_lt_three (by exact_mod_cast hn)
  have hlogpos : 0 < Real.log (n : ℝ) := lt_trans zero_lt_one hlogOne
  have hllpos : 0 < Real.log (Real.log (n : ℝ)) := lt_of_lt_of_le zero_lt_one hll1
  have hkpos : 0 < (verySparseDegreeThreshold n : ℝ) := by
    exact_mod_cast (show 0 < verySparseDegreeThreshold n by omega)
  have hkUpper : (verySparseDegreeThreshold n : ℝ) ≤
      logLogDegreeScale n / 64 := by
    simpa [verySparseDegreeThreshold] using Nat.floor_le
      (div_nonneg (div_nonneg hlogpos.le hllpos.le) (by norm_num : (0 : ℝ) ≤ 64))
  have hscaleLeLog : logLogDegreeScale n / 64 ≤ Real.log (n : ℝ) := by
    dsimp [logLogDegreeScale]
    rw [div_div, div_le_iff₀ (mul_pos hllpos (by norm_num : (0 : ℝ) < 64))]
    nlinarith
  have hkLog : Real.log (verySparseDegreeThreshold n : ℝ) ≤
      Real.log (Real.log (n : ℝ)) := by
    apply Real.log_le_log hkpos
    exact hkUpper.trans hscaleLeLog
  have hklog_nonneg : 0 ≤ Real.log (verySparseDegreeThreshold n : ℝ) :=
    Real.log_nonneg (by exact_mod_cast hk1)
  have hupper_nonneg : 0 ≤ logLogDegreeScale n / 64 := by
    dsimp [logLogDegreeScale]
    positivity
  have hmul := mul_le_mul hkUpper hkLog hklog_nonneg hupper_nonneg
  dsimp [logLogDegreeScale] at hmul
  have hcancel :
      (Real.log (n : ℝ) / Real.log (Real.log (n : ℝ)) / 64) *
          Real.log (Real.log (n : ℝ)) = Real.log (n : ℝ) / 64 := by
    field_simp
  rw [hcancel] at hmul
  nlinarith

/-- Finite arithmetic for the very-sparse point-mass lower bound.  The
hypotheses are arranged so the asymptotic specialization can supply each one
directly. -/
lemma exact_center_ratio_mass_bound_of_expectedDegree_bounds
    (n k : ℕ) (p : Set.Icc (0 : ℝ) 1) (c C : ℝ)
    (hn : 16 ≤ n) (hkpos : 0 < k) (hc : 0 < c)
    (hksmall : 4 * k ≤ n)
    (hlower : c ≤ ((n - 1 : ℕ) : ℝ) * (p : ℝ))
    (hupper : ((n - 1 : ℕ) : ℝ) * (p : ℝ) ≤ C)
    (hdenlarge : 2 * C ≤ ((n - 1 : ℕ) : ℝ))
    (hthresholdLarge : 4 ≤ c * (k : ℝ))
    (hcenterLarge : 2 ≤ Real.exp (Real.log (n : ℝ) / 4))
    (hlogcost : 2 * (k : ℝ) * Real.log (k : ℝ) ≤ Real.log (n : ℝ) / 32)
    (hgrowth : Real.log 20 ≤
      Real.exp (7 * Real.log (n : ℝ) / 32 - 4 * C) / 2) :
    k ≤ n - graphDegreeExactTestCenterCount n ∧ (p : ℝ) ≤ 1 / 2 ∧
      Real.log 20 ≤ (graphDegreeExactTestCenterCount n : ℝ) *
        ((((((n - graphDegreeExactTestCenterCount n : ℕ) + 1 - k : ℕ) : ℝ) /
              (k : ℝ)) * (unitInterval.toNNReal p : ℝ)) ^ k *
          Real.exp (-(2 * ((n - graphDegreeExactTestCenterCount n : ℕ) : ℝ) *
            (p : ℝ)))) := by
  let m : ℕ := graphDegreeExactTestCenterCount n
  let B : ℕ := n - m
  let q : ℝ := p
  have hmhalf : 2 * m ≤ n := by
    simpa [m] using two_mul_graphDegreeExactTestCenterCount_le n hn
  have hkB : k ≤ B := by dsimp [B]; omega
  have hn1 : 1 ≤ n := by omega
  have hkR : (0 : ℝ) < (k : ℝ) := by positivity
  have hnsubpos : (0 : ℝ) < ((n - 1 : ℕ) : ℝ) := by
    exact_mod_cast (show 0 < n - 1 by omega)
  have hpHalf : q ≤ 1 / 2 := by
    have hq0 : 0 ≤ q := p.2.1
    dsimp [q] at hq0 hupper ⊢
    nlinarith
  refine ⟨by simpa [B, m] using hkB, hpHalf, ?_⟩
  have hnumNat : n ≤ 4 * (B + 1 - k) := by
    dsimp [B]
    omega
  have hnum : (n : ℝ) ≤ 4 * ((B + 1 - k : ℕ) : ℝ) := by
    exact_mod_cast hnumNat
  have hnsub_le : ((n - 1 : ℕ) : ℝ) ≤ (n : ℝ) := by
    exact_mod_cast Nat.sub_le n 1
  have hcnum : c ≤ 4 * ((B + 1 - k : ℕ) : ℝ) * q := by
    have hq0 : 0 ≤ q := p.2.1
    have hfirst : ((n - 1 : ℕ) : ℝ) * q ≤ (n : ℝ) * q :=
      mul_le_mul_of_nonneg_right hnsub_le hq0
    have hsecond : (n : ℝ) * q ≤
        (4 * ((B + 1 - k : ℕ) : ℝ)) * q :=
      mul_le_mul_of_nonneg_right hnum hq0
    have hlower' : c ≤ ((n - 1 : ℕ) : ℝ) * q := by
      simpa [q] using hlower
    exact hlower'.trans (hfirst.trans hsecond)
  have hbaseC : c / (4 * (k : ℝ)) ≤
      (((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q := by
    rw [div_le_iff₀ (mul_pos (by norm_num) hkR)]
    calc
      c ≤ 4 * ((B + 1 - k : ℕ) : ℝ) * q := hcnum
      _ = (((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q *
          (4 * (k : ℝ)) := by field_simp
  have hbaseInv : 1 / (k : ℝ) ^ 2 ≤ c / (4 * (k : ℝ)) := by
    rw [div_le_div_iff₀ (sq_pos_of_pos hkR) (mul_pos (by norm_num) hkR)]
    nlinarith
  have hbase : 1 / (k : ℝ) ^ 2 ≤
      (((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q :=
    hbaseInv.trans hbaseC
  have hbaseNonneg : 0 ≤
      (((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q :=
    (by positivity : 0 ≤ 1 / (k : ℝ) ^ 2).trans hbase
  have hpowIdentity : (1 / (k : ℝ) ^ 2) ^ k =
      Real.exp (-(2 * (k : ℝ) * Real.log (k : ℝ))) := by
    calc
      (1 / (k : ℝ) ^ 2) ^ k =
          (Real.exp (-(2 * Real.log (k : ℝ)))) ^ k := by
        congr 1
        rw [Real.exp_neg]
        have hexpTwo : Real.exp (2 * Real.log (k : ℝ)) = (k : ℝ) ^ 2 := by
          rw [show 2 * Real.log (k : ℝ) =
            Real.log (k : ℝ) + Real.log (k : ℝ) by ring,
            Real.exp_add, Real.exp_log hkR, pow_two]
        rw [hexpTwo]
        ring
      _ = Real.exp ((k : ℝ) * (-(2 * Real.log (k : ℝ)))) :=
        (Real.exp_nat_mul _ k).symm
      _ = Real.exp (-(2 * (k : ℝ) * Real.log (k : ℝ))) := by ring
  have hbasePow : Real.exp (-(2 * (k : ℝ) * Real.log (k : ℝ))) ≤
      ((((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q) ^ k := by
    rw [← hpowIdentity]
    exact pow_le_pow_left₀ (by positivity) hbase k
  have hBLe : (B : ℝ) ≤ (n : ℝ) := by
    exact_mod_cast Nat.sub_le n m
  have hnle : (n : ℝ) ≤ 2 * ((n - 1 : ℕ) : ℝ) := by
    exact_mod_cast (show n ≤ 2 * (n - 1) by omega)
  have hfailureExponent : 2 * (B : ℝ) * q ≤ 4 * C := by
    have hq0 : 0 ≤ q := p.2.1
    have hBq := mul_le_mul_of_nonneg_right hBLe hq0
    have hnq := mul_le_mul_of_nonneg_right hnle hq0
    dsimp [q] at hBq hnq
    nlinarith
  have hfailure : Real.exp (-(4 * C)) ≤
      Real.exp (-(2 * (B : ℝ) * q)) := by
    exact Real.exp_le_exp.mpr (neg_le_neg hfailureExponent)
  let x : ℝ := Real.exp (Real.log (n : ℝ) / 4)
  have hcount : m = ⌊x⌋₊ := by
    simpa [m, x] using graphDegreeExactTestCenterCount_eq_natFloor n hn1
  have hfloorlt : x < (⌊x⌋₊ : ℝ) + 1 := Nat.lt_floor_add_one x
  have hfloorlower : x / 2 ≤ (m : ℝ) := by
    rw [hcount]
    dsimp [x] at hcenterLarge ⊢
    nlinarith
  have hbudget :
      Real.exp (7 * Real.log (n : ℝ) / 32 - 4 * C) / 2 ≤
        ((x / 2) * Real.exp (-(2 * (k : ℝ) * Real.log (k : ℝ)))) *
          Real.exp (-(4 * C)) := by
    calc
      Real.exp (7 * Real.log (n : ℝ) / 32 - 4 * C) / 2 ≤
          Real.exp (Real.log (n : ℝ) / 4 -
            2 * (k : ℝ) * Real.log (k : ℝ) - 4 * C) / 2 := by
        gcongr
        nlinarith
      _ = (x * Real.exp (-(2 * (k : ℝ) * Real.log (k : ℝ))) *
            Real.exp (-(4 * C))) / 2 := by
        dsimp [x]
        rw [← Real.exp_add, ← Real.exp_add]
        congr 2
      _ = ((x / 2) * Real.exp (-(2 * (k : ℝ) * Real.log (k : ℝ)))) *
            Real.exp (-(4 * C)) := by ring
  have hfirst : (x / 2) * Real.exp (-(2 * (k : ℝ) * Real.log (k : ℝ))) ≤
      (m : ℝ) * ((((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q) ^ k := by
    exact mul_le_mul hfloorlower hbasePow (Real.exp_nonneg _) (by positivity)
  have hsecond :
      ((x / 2) * Real.exp (-(2 * (k : ℝ) * Real.log (k : ℝ)))) *
          Real.exp (-(4 * C)) ≤
        ((m : ℝ) * ((((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q) ^ k) *
          Real.exp (-(2 * (B : ℝ) * q)) := by
    exact mul_le_mul hfirst hfailure (Real.exp_nonneg _) (by positivity)
  change Real.log 20 ≤ (m : ℝ) *
    (((((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q) ^ k *
      Real.exp (-(2 * (B : ℝ) * q)))
  calc
    Real.log 20 ≤ Real.exp (7 * Real.log (n : ℝ) / 32 - 4 * C) / 2 := hgrowth
    _ ≤ ((x / 2) * Real.exp (-(2 * (k : ℝ) * Real.log (k : ℝ)))) *
        Real.exp (-(4 * C)) := hbudget
    _ ≤ ((m : ℝ) * ((((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q) ^ k) *
        Real.exp (-(2 * (B : ℝ) * q)) := hsecond
    _ = (m : ℝ) * (((((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q) ^ k *
        Real.exp (-(2 * (B : ℝ) * q))) := by ring

/-- Eventual finite point-mass criterion for the log-over-log-log threshold
under two-sided constant bounds on expected degree. -/
lemma eventually_exact_center_ratio_mass_bound_of_expectedDegree_bounds
    (p : ℕ → Set.Icc (0 : ℝ) 1) (c C : ℝ) (hc : 0 < c)
    (hlower : ∀ᶠ n : ℕ in Filter.atTop,
      c ≤ ((n - 1 : ℕ) : ℝ) * (p n : ℝ))
    (hupper : ∀ᶠ n : ℕ in Filter.atTop,
      ((n - 1 : ℕ) : ℝ) * (p n : ℝ) ≤ C) :
    ∀ᶠ n : ℕ in Filter.atTop,
      verySparseDegreeThreshold n ≤ n - graphDegreeExactTestCenterCount n ∧
        (p n : ℝ) ≤ 1 / 2 ∧
        Real.log 20 ≤ (graphDegreeExactTestCenterCount n : ℝ) *
          ((((((n - graphDegreeExactTestCenterCount n : ℕ) + 1 -
                  verySparseDegreeThreshold n : ℕ) : ℝ) /
                (verySparseDegreeThreshold n : ℝ)) *
              (unitInterval.toNNReal (p n) : ℝ)) ^ verySparseDegreeThreshold n *
            Real.exp (-(2 * ((n - graphDegreeExactTestCenterCount n : ℕ) : ℝ) *
              (p n : ℝ)))) := by
  have hkReal : Filter.Tendsto
      (fun n : ℕ => (verySparseDegreeThreshold n : ℝ))
      Filter.atTop Filter.atTop :=
    tendsto_natCast_atTop_atTop.comp tendsto_verySparseDegreeThreshold_atTop
  have hthresholdLarge : ∀ᶠ n : ℕ in Filter.atTop,
      4 ≤ c * (verySparseDegreeThreshold n : ℝ) :=
    (hkReal.const_mul_atTop hc).eventually_ge_atTop 4
  have hnatLarge : ∀ᶠ n : ℕ in Filter.atTop,
      2 * C + 1 ≤ (n : ℝ) :=
    tendsto_natCast_atTop_atTop.eventually_ge_atTop (2 * C + 1)
  have hcenter : Filter.Tendsto
      (fun n : ℕ => Real.exp (Real.log (n : ℝ) / 4))
      Filter.atTop Filter.atTop := by
    exact Real.tendsto_exp_atTop.comp
      ((Real.tendsto_log_atTop.comp tendsto_natCast_atTop_atTop).atTop_div_const
        (by norm_num))
  have hlogScaled : Filter.Tendsto
      (fun n : ℕ => 7 * Real.log (n : ℝ) / 32 - 4 * C)
      Filter.atTop Filter.atTop := by
    have hlog : Filter.Tendsto (fun n : ℕ => Real.log (n : ℝ))
        Filter.atTop Filter.atTop :=
      Real.tendsto_log_atTop.comp tendsto_natCast_atTop_atTop
    have hmul : Filter.Tendsto
        (fun n : ℕ => Real.log (n : ℝ) * (7 / 32 : ℝ))
        Filter.atTop Filter.atTop :=
      hlog.atTop_mul_const (by norm_num)
    have hadd := hmul.atTop_add (tendsto_const_nhds :
      Filter.Tendsto (fun _ : ℕ => -(4 * C)) Filter.atTop (nhds (-(4 * C))))
    simpa only [sub_eq_add_neg] using hadd.congr'
      (Filter.Eventually.of_forall fun n => by ring)
  have hgrowthLim : Filter.Tendsto
      (fun n : ℕ => Real.exp (7 * Real.log (n : ℝ) / 32 - 4 * C) / 2)
      Filter.atTop Filter.atTop := by
    exact (Real.tendsto_exp_atTop.comp hlogScaled).atTop_div_const (by norm_num)
  filter_upwards [hlower, hupper, hthresholdLarge, hnatLarge,
    hcenter.eventually_ge_atTop 2,
    eventually_two_threshold_mul_log_le_log_div_32,
    hgrowthLim.eventually_ge_atTop (Real.log 20),
    eventually_four_mul_le_of_log_ratio_tendsto_zero
      verySparseDegreeThreshold tendsto_verySparseDegreeThreshold_div_log,
    tendsto_verySparseDegreeThreshold_atTop.eventually_ge_atTop 1,
    Filter.eventually_atTop.2 ⟨16, fun n hn => hn⟩]
    with n hlower_n hupper_n hthreshold_n hnat_n hcenter_n hlogcost_n
      hgrowth_n hfour_n hkone_n hn
  have hdenlarge : 2 * C ≤ ((n - 1 : ℕ) : ℝ) := by
    rw [Nat.cast_sub (by omega : 1 ≤ n)]
    norm_num
    linarith
  exact exact_center_ratio_mass_bound_of_expectedDegree_bounds
    n (verySparseDegreeThreshold n) (p n) c C hn (by omega) hc hfour_n
      hlower_n hupper_n hdenlarge hthreshold_n hcenter_n hlogcost_n hgrowth_n

/-- Corrected form of the very-sparse maximum-degree lower bound: expected
degree is bounded both away from zero and above by constants. -/
theorem erdosRenyiVerySparseExistsDegree_corrected
    (p : ℕ → Set.Icc (0 : ℝ) 1) (c C : ℝ) (hc : 0 < c)
    (hlower : ∀ᶠ n : ℕ in Filter.atTop,
      c ≤ ((n - 1 : ℕ) : ℝ) * (p n : ℝ))
    (hupper : ∀ᶠ n : ℕ in Filter.atTop,
      ((n - 1 : ℕ) : ℝ) * (p n : ℝ) ≤ C) :
    ∀ᶠ n : ℕ in Filter.atTop,
      (SimpleGraph.binomialRandom (Fin n) (p n)).real
          {G | ∃ v : Fin n,
            logLogDegreeScale n / 128 ≤ graphDegreeSum v G} ≥
        (9 : ℝ) / 10 := by
  have hmass := eventually_exact_center_ratio_mass_bound_of_expectedDegree_bounds
    p c C hc hlower hupper
  have hC : 0 ≤ C := by
    obtain ⟨n, hnlow, hnupper⟩ := (hlower.and hupper).exists
    exact hc.le.trans (hnlow.trans hnupper)
  have hinternal := eventually_exact_center_internal_mass_le_of_expectedDegree_upper
    p C hC hupper
  filter_upwards [hmass, hinternal,
    eventually_logLogDegreeScale_div_128_le_threshold]
    with n hmass_n hinternal_n hthreshold_n
  let A : Finset (Fin n) := graphDegreeExactTestCenters n
  let k : ℕ := verySparseDegreeThreshold n
  have hcardB : (Finset.univ \ A).card =
      n - graphDegreeExactTestCenterCount n := by
    dsimp [A]
    rw [Finset.card_sdiff_of_subset (Finset.subset_univ _)]
    simp
  have hk : k ≤ (Finset.univ \ A).card := by
    rw [hcardB]
    exact hmass_n.1
  have hmass' : Real.log 20 ≤ (A.card : ℝ) *
      ((((((Finset.univ \ A).card + 1 - k : ℕ) : ℝ) / (k : ℝ)) *
          (unitInterval.toNNReal (p n) : ℝ)) ^ k *
        Real.exp (-(2 * ((Finset.univ \ A).card : ℝ) * (p n : ℝ)))) := by
    rw [hcardB]
    simpa [A, k] using hmass_n.2.2
  have hinner : (A.card : ℝ) ^ 2 * (p n : ℝ) ≤ (1 : ℝ) / 20 := by
    simpa [A] using hinternal_n
  have hexact :=
    binomialRandom_exists_degree_eq_probability_ge_nine_tenths_of_ratio_pow
      (p n) A k hk hmass_n.2.1 hmass' hinner
  have hsubset :
      {G : SimpleGraph (Fin n) | ∃ v : Fin n, graphDegreeSum v G = k} ⊆
        {G | ∃ v : Fin n,
          logLogDegreeScale n / 128 ≤ graphDegreeSum v G} := by
    rintro G ⟨v, hv⟩
    refine ⟨v, ?_⟩
    rw [hv]
    simpa [k] using hthreshold_n
  exact hexact.trans (measureReal_mono hsubset)

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
