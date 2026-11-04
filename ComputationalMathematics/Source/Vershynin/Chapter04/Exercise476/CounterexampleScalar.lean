import ComputationalMathematics.Source.Vershynin.Chapter04.Exercise476.Contract
import ComputationalMathematics.HDP.Probability.GaussianOverlap

/-!
# Scalar parameters of the Chapter 4 recovery counterexample

Source-specific tolerance, signal-radius, and dimension sequences for the
printed Gaussian-mixture recovery claim. This module proves their eventual
arithmetic bounds; the canonical counterexample supplies the sampling model.
-/

noncomputable section

open Filter

namespace NumStability.HDP.Contract.Exercise476CounterexampleScalar

/-- The error tolerance in the counterexample family. -/
def epsilon (k : ℕ) : ℝ := 1 / (2 * (k : ℝ))

/-- The signal radius in the counterexample family. -/
def radius (A : ℝ) (k : ℕ) : ℝ :=
  A * Real.sqrt (Real.log (2 * (k : ℝ)))

/-- The ambient dimension in the counterexample family. -/
def dimension (A c : ℝ) (k : ℕ) : ℕ :=
  Nat.floor ((radius A k / 2) * Real.rpow (k : ℝ) (1 / c))

lemma two_mul_natCast_gt_one {k : ℕ} (hk : 1 ≤ k) :
    (1 : ℝ) < 2 * (k : ℝ) := by
  exact_mod_cast (show 1 < 2 * k by omega)

lemma log_two_mul_natCast_pos {k : ℕ} (hk : 1 ≤ k) :
    0 < Real.log (2 * (k : ℝ)) :=
  Real.log_pos (two_mul_natCast_gt_one hk)

lemma radius_pos {A : ℝ} (hA : 0 < A) {k : ℕ} (hk : 1 ≤ k) :
    0 < radius A k := by
  exact mul_pos hA (Real.sqrt_pos.2 (log_two_mul_natCast_pos hk))

lemma epsilon_pos {k : ℕ} (hk : 1 ≤ k) : 0 < epsilon k := by
  unfold epsilon
  positivity

lemma one_div_epsilon {k : ℕ} (hk : 1 ≤ k) :
    1 / epsilon k = 2 * (k : ℝ) := by
  unfold epsilon
  field_simp

/-- The chosen radius meets the printed separation condition exactly. -/
theorem printed_separation (A : ℝ) {k : ℕ} (hk : 1 ≤ k) :
    A * Real.sqrt (Real.log (1 / epsilon k)) = radius A k := by
  rw [one_div_epsilon hk]
  rfl

/-- The floor construction meets the printed polynomial sample-size condition. -/
theorem printed_sample_size {A c : ℝ} (hA : 0 < A) (hc : 0 < c)
    {k : ℕ} (hk : 1 ≤ k) :
    Real.rpow (((dimension A c k : ℕ) : ℝ) / radius A k) c ≤ (k : ℝ) := by
  have hr : 0 < radius A k := radius_pos hA hk
  have hkR : 0 < (k : ℝ) := by exact_mod_cast (lt_of_lt_of_le Nat.zero_lt_one hk)
  have hpow : 0 < Real.rpow (k : ℝ) (1 / c) :=
    Real.rpow_pos_of_pos hkR _
  have hfloor : ((dimension A c k : ℕ) : ℝ) ≤
      (radius A k / 2) * Real.rpow (k : ℝ) (1 / c) := by
    apply Nat.floor_le
    positivity
  have hhalf :
      (radius A k / 2) * Real.rpow (k : ℝ) (1 / c) ≤
        radius A k * Real.rpow (k : ℝ) (1 / c) := by
    nlinarith
  have hratio : ((dimension A c k : ℕ) : ℝ) / radius A k ≤
      Real.rpow (k : ℝ) (1 / c) := by
    apply (div_le_iff₀ hr).2
    simpa [mul_comm] using hfloor.trans hhalf
  calc
    Real.rpow (((dimension A c k : ℕ) : ℝ) / radius A k) c ≤
        Real.rpow (Real.rpow (k : ℝ) (1 / c)) c := by
          apply Real.rpow_le_rpow
          · positivity
          · exact hratio
          · exact hc.le
    _ = Real.rpow (k : ℝ) ((1 / c) * c) := by
      exact (Real.rpow_mul hkR.le (1 / c) c).symm
    _ = (k : ℝ) := by
      rw [one_div_mul_cancel hc.ne']
      exact Real.rpow_one _

lemma radius_sq {A : ℝ} {k : ℕ} (hk : 1 ≤ k) :
    radius A k ^ 2 = A ^ 2 * Real.log (2 * (k : ℝ)) := by
  rw [radius, mul_pow, Real.sq_sqrt (log_two_mul_natCast_pos hk).le]

lemma tendsto_radius (A : ℝ) (hA : 0 < A) :
    Tendsto (radius A) atTop atTop := by
  have hcast : Tendsto (fun k : ℕ ↦ 2 * (k : ℝ)) atTop atTop :=
    tendsto_natCast_atTop_atTop.const_mul_atTop (by norm_num)
  have hlog : Tendsto (fun k : ℕ ↦ Real.log (2 * (k : ℝ))) atTop atTop :=
    Real.tendsto_log_atTop.comp hcast
  have hsqrt : Tendsto (fun k : ℕ ↦ Real.sqrt (Real.log (2 * (k : ℝ))))
      atTop atTop := Real.tendsto_sqrt_atTop.comp hlog
  simpa only [radius] using hsqrt.const_mul_atTop hA

lemma tendsto_dimension (A c : ℝ) (hA : 0 < A) (hc : 0 < c) :
    Tendsto (dimension A c) atTop atTop := by
  have hrhalf : Tendsto (fun k : ℕ ↦ radius A k / 2) atTop atTop := by
    have h := (tendsto_radius A hA).const_mul_atTop (by norm_num : (0 : ℝ) < 1 / 2)
    simpa only [div_eq_mul_inv, one_div, mul_comm, one_mul] using h
  have hp : 0 < 1 / c := by positivity
  have hpow : Tendsto (fun k : ℕ ↦ Real.rpow (k : ℝ) (1 / c)) atTop atTop :=
    (tendsto_rpow_atTop hp).comp (tendsto_natCast_atTop_atTop (R := ℝ))
  have harg : Tendsto
      (fun k : ℕ ↦ (radius A k / 2) * Real.rpow (k : ℝ) (1 / c))
      atTop atTop := hrhalf.atTop_mul_atTop₀ hpow
  simpa only [dimension] using tendsto_nat_floor_atTop.comp harg

/-- The floor dimension eventually dominates the logarithmic exponent appearing
in the elementary overlap scale `exp (-2 r²)`. -/
theorem eventually_log_four_add_two_radius_sq_lt_dimension
    {A c : ℝ} (hA : 0 < A) (hc : 0 < c) :
    ∀ᶠ k : ℕ in atTop,
      Real.log 4 + 2 * radius A k ^ 2 < ((dimension A c k : ℕ) : ℝ) := by
  let p : ℝ := 1 / c
  have hp : 0 < p := by dsimp [p]; positivity
  let d : ℝ := A / (8 * (A ^ 2 + 1))
  have hd : 0 < d := by dsimp [d]; positivity
  have hlogSmall : ∀ᶠ k : ℕ in atTop,
      |Real.log (k : ℝ)| ≤ d * Real.rpow (k : ℝ) p := by
    have h := ((isLittleO_log_rpow_atTop hp).comp_tendsto
      (tendsto_natCast_atTop_atTop (R := ℝ))).def hd
    simpa only [Function.comp_apply, Real.norm_eq_abs,
      abs_of_nonneg (Real.rpow_nonneg (Nat.cast_nonneg _) _)] using h
  have hpowTop : Tendsto (fun k : ℕ ↦ Real.rpow (k : ℝ) p) atTop atTop :=
    (tendsto_rpow_atTop hp).comp (tendsto_natCast_atTop_atTop (R := ℝ))
  let B : ℝ := Real.log 4 + 2 * A ^ 2 * Real.log 2 + 1
  have hconstant : ∀ᶠ k : ℕ in atTop,
      B < A / 4 * Real.rpow (k : ℝ) p :=
    (hpowTop.const_mul_atTop (by positivity : 0 < A / 4)).eventually_gt_atTop B
  have hradius : ∀ᶠ k : ℕ in atTop, A < radius A k :=
    (tendsto_radius A hA).eventually_gt_atTop A
  filter_upwards [eventually_ge_atTop 1, hlogSmall, hconstant, hradius] with k hk hsmall hconst hr
  have hkR : 0 < (k : ℝ) := by
    exact_mod_cast (lt_of_lt_of_le Nat.zero_lt_one hk)
  have hlogk : 0 ≤ Real.log (k : ℝ) := Real.log_nonneg (by exact_mod_cast hk)
  have hsmall' : Real.log (k : ℝ) ≤ d * Real.rpow (k : ℝ) p := by
    simpa [abs_of_nonneg hlogk] using hsmall
  have hcoef : 2 * A ^ 2 * d ≤ A / 4 := by
    dsimp [d]
    calc
      2 * A ^ 2 * (A / (8 * (A ^ 2 + 1))) =
          (2 * A ^ 2 * A) / (8 * (A ^ 2 + 1)) := by ring
      _ ≤ A / 4 := by
        apply (div_le_iff₀ (by positivity : 0 < 8 * (A ^ 2 + 1))).2
        nlinarith [sq_nonneg A]
  have hlogterm :
      2 * A ^ 2 * Real.log (k : ℝ) ≤
        A / 4 * Real.rpow (k : ℝ) p := by
    calc
      2 * A ^ 2 * Real.log (k : ℝ) ≤
          2 * A ^ 2 * (d * Real.rpow (k : ℝ) p) := by
            gcongr
      _ = (2 * A ^ 2 * d) * Real.rpow (k : ℝ) p := by ring
      _ ≤ A / 4 * Real.rpow (k : ℝ) p := by
        gcongr
        exact Real.rpow_nonneg hkR.le _
  have hlogmul : Real.log (2 * (k : ℝ)) = Real.log 2 + Real.log (k : ℝ) :=
    Real.log_mul (by norm_num) hkR.ne'
  have hexponent :
      Real.log 4 + 2 * radius A k ^ 2 + 1 <
        A / 2 * Real.rpow (k : ℝ) p := by
    rw [radius_sq hk, hlogmul]
    calc
      Real.log 4 + 2 * (A ^ 2 * (Real.log 2 + Real.log (k : ℝ))) + 1 =
          B + 2 * A ^ 2 * Real.log (k : ℝ) := by dsimp [B]; ring
      _ < A / 4 * Real.rpow (k : ℝ) p +
          A / 4 * Real.rpow (k : ℝ) p := add_lt_add_of_lt_of_le hconst hlogterm
      _ = A / 2 * Real.rpow (k : ℝ) p := by ring
  have harg :
      A / 2 * Real.rpow (k : ℝ) p <
        radius A k / 2 * Real.rpow (k : ℝ) p := by
    gcongr
    exact Real.rpow_pos_of_pos hkR p
  have hfloor := Nat.lt_floor_add_one
    ((radius A k / 2) * Real.rpow (k : ℝ) (1 / c))
  change (radius A k / 2) * Real.rpow (k : ℝ) (1 / c) <
    ((dimension A c k : ℕ) : ℝ) + 1 at hfloor
  dsimp [p] at hexponent harg
  have hchain := hexponent.trans (harg.trans hfloor)
  linarith

/-- The target `4 exp (-n)` scale is eventually strictly below the elementary
overlap scale `exp (-2 r²)`. -/
theorem eventually_four_exp_neg_dimension_lt_exp_neg_two_radius_sq
    {A c : ℝ} (hA : 0 < A) (hc : 0 < c) :
    ∀ᶠ k : ℕ in atTop,
      4 * Real.exp (-((dimension A c k : ℕ) : ℝ)) <
        Real.exp (-2 * radius A k ^ 2) := by
  filter_upwards [eventually_log_four_add_two_radius_sq_lt_dimension hA hc] with k hk
  rw [← Real.exp_log (by norm_num : (0 : ℝ) < 4), ← Real.exp_add]
  apply Real.exp_lt_exp.mpr
  linarith

/-- The one-sided Mills-ratio expression used as a concrete Gaussian overlap
lower bound. -/
def millsOverlapLower (r : ℝ) : ℝ :=
  (Real.sqrt (2 * Real.pi))⁻¹ *
    ((1 / r - 1 / r ^ 3) * Real.exp (-(r ^ 2) / 2))

lemma half_inv_le_mills_factor {r : ℝ} (hr : 2 ≤ r) :
    1 / (2 * r) ≤ 1 / r - 1 / r ^ 3 := by
  have hrpos : 0 < r := by linarith
  field_simp
  nlinarith

/-- `exp (-2r²)` is eventually below the explicit one-sided Mills lower
bound.  This is the only asymptotic comparison needed after the dimension
gap. -/
theorem eventually_exp_neg_two_sq_lt_millsOverlapLower :
    ∀ᶠ r : ℝ in atTop, Real.exp (-2 * r ^ 2) < millsOverlapLower r := by
  let S : ℝ := Real.sqrt (2 * Real.pi)
  have hS : 0 < S := by dsimp [S]; positivity
  have hsquare : Tendsto (fun r : ℝ ↦ r ^ 2) atTop atTop :=
    tendsto_pow_atTop (by norm_num)
  have hdecay0 : Tendsto
      (fun r : ℝ ↦ (2 * S) *
        (r ^ 2 * Real.exp (-(3 / 2 : ℝ) * r ^ 2))) atTop (nhds 0) := by
    have hbase :=
      (tendsto_rpow_mul_exp_neg_mul_atTop_nhds_zero 1 (3 / 2) (by norm_num)).comp
        hsquare
    have hmul := (tendsto_const_nhds (x := 2 * S)).mul hbase
    simpa only [Function.comp_apply, Real.rpow_one, mul_zero] using hmul
  have hsmall : ∀ᶠ r : ℝ in atTop,
      (2 * S) * (r ^ 2 * Real.exp (-(3 / 2 : ℝ) * r ^ 2)) < 1 :=
    hdecay0.eventually (Iio_mem_nhds zero_lt_one)
  filter_upwards [eventually_ge_atTop 2, hsmall] with r hr hsmallr
  have hrpos : 0 < r := by linarith
  have hr_le_sq : r ≤ r ^ 2 := by nlinarith
  have hq :
      2 * S * r * Real.exp (-(3 / 2 : ℝ) * r ^ 2) < 1 := by
    calc
      2 * S * r * Real.exp (-(3 / 2 : ℝ) * r ^ 2) ≤
          (2 * S) * (r ^ 2 * Real.exp (-(3 / 2 : ℝ) * r ^ 2)) := by
            have hright :
                r * Real.exp (-(3 / 2 : ℝ) * r ^ 2) ≤
                  r ^ 2 * Real.exp (-(3 / 2 : ℝ) * r ^ 2) :=
              mul_le_mul_of_nonneg_right hr_le_sq (Real.exp_pos _).le
            have h := mul_le_mul_of_nonneg_left
              hright (show 0 ≤ 2 * S by positivity)
            simpa only [mul_assoc] using h
      _ < 1 := hsmallr
  have hcancel :
      (2 * S * r) *
          (S⁻¹ * ((1 / (2 * r)) * Real.exp (-(r ^ 2) / 2))) =
        Real.exp (-(r ^ 2) / 2) := by
    field_simp
  have hscaled :
      (2 * S * r) * Real.exp (-2 * r ^ 2) <
        (2 * S * r) *
          (S⁻¹ * ((1 / (2 * r)) * Real.exp (-(r ^ 2) / 2))) := by
    rw [hcancel]
    calc
      (2 * S * r) * Real.exp (-2 * r ^ 2) =
          (2 * S * r) *
            (Real.exp (-(3 / 2 : ℝ) * r ^ 2) *
              Real.exp (-(r ^ 2) / 2)) := by
            congr 1
            rw [← Real.exp_add]
            congr 1
            ring
      _ = (2 * S * r * Real.exp (-(3 / 2 : ℝ) * r ^ 2)) *
            Real.exp (-(r ^ 2) / 2) := by ring
      _ < 1 * Real.exp (-(r ^ 2) / 2) :=
        mul_lt_mul_of_pos_right hq (Real.exp_pos _)
      _ = Real.exp (-(r ^ 2) / 2) := one_mul _
  have helementary :
      Real.exp (-2 * r ^ 2) <
        S⁻¹ * ((1 / (2 * r)) * Real.exp (-(r ^ 2) / 2)) :=
    lt_of_mul_lt_mul_left hscaled (mul_pos (mul_pos two_pos hS) hrpos).le
  calc
    Real.exp (-2 * r ^ 2) <
        S⁻¹ * ((1 / (2 * r)) * Real.exp (-(r ^ 2) / 2)) := helementary
    _ ≤ S⁻¹ *
        ((1 / r - 1 / r ^ 3) * Real.exp (-(r ^ 2) / 2)) := by
          gcongr
          · exact half_inv_le_mills_factor hr
    _ = millsOverlapLower r := by rfl

/-- The Mills expression really is a lower bound on one side of the standard
normal overlap. -/
theorem millsOverlapLower_le_standardNormalTail {r : ℝ} (hr : 0 < r) :
    millsOverlapLower r ≤
      NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw.real (Set.Ici r) := by
  exact
    (NumStability.HDP.Scalar.GaussianTails.standardNormalTail_bounds r hr).1

/-- Fully assembled scalar asymptotic: the explicit Gaussian overlap lower
bound eventually exceeds the theorem's printed failure scale. -/
theorem eventually_four_exp_neg_dimension_lt_millsOverlapLower
    {A c : ℝ} (hA : 0 < A) (hc : 0 < c) :
    ∀ᶠ k : ℕ in atTop,
      4 * Real.exp (-((dimension A c k : ℕ) : ℝ)) <
        millsOverlapLower (radius A k) := by
  have hoverlap : ∀ᶠ k : ℕ in atTop,
      Real.exp (-2 * radius A k ^ 2) < millsOverlapLower (radius A k) :=
    eventually_exp_neg_two_sq_lt_millsOverlapLower.filter_mono
      (tendsto_radius A hA)
  filter_upwards
      [eventually_four_exp_neg_dimension_lt_exp_neg_two_radius_sq hA hc, hoverlap] with
      k hdim hoverlap
  exact hdim.trans hoverlap

/-- Consequently, the actual standard-normal overlap on the ambiguous side
eventually exceeds `4 exp (-n)`. -/
theorem eventually_four_exp_neg_dimension_lt_standardNormalTail
    {A c : ℝ} (hA : 0 < A) (hc : 0 < c) :
    ∀ᶠ k : ℕ in atTop,
      4 * Real.exp (-((dimension A c k : ℕ) : ℝ)) <
        NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw.real
          (Set.Ici (radius A k)) := by
  filter_upwards [eventually_ge_atTop 1,
      eventually_four_exp_neg_dimension_lt_millsOverlapLower hA hc] with k hk hoverlap
  exact hoverlap.trans_le (millsOverlapLower_le_standardNormalTail (radius_pos hA hk))

/-- A single eventual package matching the counterexample parameters
`m = k`, `ε = 1/(2k)`, `r = A√log(2k)`, and
`n = ⌊(r/2) k^(1/c)⌋`: both natural parameters and `ε` are positive,
the two printed scalar hypotheses hold, and the one-sided Gaussian overlap is
strictly larger than `4 exp (-n)`. -/
theorem eventually_counterexample_scalar_foundation
    {A c : ℝ} (hA : 0 < A) (hc : 0 < c) :
    ∀ᶠ k : ℕ in atTop,
      0 < k ∧ 0 < dimension A c k ∧ 0 < epsilon k ∧
      A * Real.sqrt (Real.log (1 / epsilon k)) ≤ radius A k ∧
      Real.rpow (((dimension A c k : ℕ) : ℝ) / radius A k) c ≤ (k : ℝ) ∧
      4 * Real.exp (-((dimension A c k : ℕ) : ℝ)) <
        NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw.real
          (Set.Ici (radius A k)) := by
  have hn : ∀ᶠ k : ℕ in atTop, 0 < dimension A c k :=
    (tendsto_dimension A c hA hc).eventually_gt_atTop 0
  filter_upwards [eventually_ge_atTop 1, hn,
      eventually_four_exp_neg_dimension_lt_standardNormalTail hA hc] with k hk hn hoverlap
  exact ⟨lt_of_lt_of_le Nat.zero_lt_one hk, hn, epsilon_pos hk,
    (printed_separation A hk).le, printed_sample_size hA hc hk, hoverlap⟩

open NumStability.HDP.Probability

/-- A coarse explicit lower bound on the normalizing constant used by the
Gaussian interval-overlap measure. -/
lemma quarter_le_gaussianIntervalPrefactor :
    (1 : ℝ) / 4 ≤ (Real.sqrt Real.pi)⁻¹ * (Real.sqrt (2 : ℝ))⁻¹ := by
  have hp : Real.sqrt Real.pi ≤ 2 := by
    have hs := Real.sq_sqrt Real.pi_pos.le
    nlinarith [Real.pi_le_four]
  have htwo : Real.sqrt (2 : ℝ) ≤ 2 := by
    have hs := Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2)
    nlinarith [Real.sqrt_nonneg (2 : ℝ)]
  have hprod : Real.sqrt Real.pi * Real.sqrt (2 : ℝ) ≤ 4 := by
    nlinarith [mul_nonneg (Real.sqrt_nonneg Real.pi) (Real.sqrt_nonneg 2),
      mul_le_mul hp htwo (Real.sqrt_nonneg 2) (by norm_num : (0 : ℝ) ≤ 2)]
  have hpos : 0 < Real.sqrt Real.pi * Real.sqrt (2 : ℝ) := by positivity
  calc
    (1 : ℝ) / 4 ≤ 1 / (Real.sqrt Real.pi * Real.sqrt (2 : ℝ)) :=
      one_div_le_one_div_of_le hpos hprod
    _ = (Real.sqrt Real.pi)⁻¹ * (Real.sqrt (2 : ℝ))⁻¹ := by
      rw [one_div, mul_inv_rev, mul_comm]

/-- The elementary interval-overlap density eventually dominates the auxiliary
`exp (-2r²)` scale used by the counterexample family. -/
lemma exp_neg_two_sq_lt_gaussianIntervalFloorReal {r : ℝ} (hr : 3 ≤ r) :
    Real.exp (-2 * r ^ 2) < gaussianIntervalFloorReal r := by
  have hexponent : (r + 1) ^ 2 / 2 ≤ r ^ 2 := by nlinarith
  have hfour : (4 : ℝ) < Real.exp (r ^ 2) := by
    have hone : (2 : ℝ) < Real.exp 1 := by
      have h := Real.add_one_lt_exp (by norm_num : (1 : ℝ) ≠ 0)
      norm_num at h ⊢
      exact h
    have htwo : (4 : ℝ) < Real.exp 2 := by
      rw [show (2 : ℝ) = 1 + 1 by norm_num, Real.exp_add]
      nlinarith [Real.exp_pos 1]
    calc
      (4 : ℝ) < Real.exp 2 := htwo
      _ ≤ Real.exp (r ^ 2) := Real.exp_le_exp.mpr (by nlinarith)
  have hmul : 4 * Real.exp (-2 * r ^ 2) < Real.exp (-r ^ 2) := by
    calc
      4 * Real.exp (-2 * r ^ 2) <
          Real.exp (r ^ 2) * Real.exp (-2 * r ^ 2) :=
        mul_lt_mul_of_pos_right hfour (Real.exp_pos (-2 * r ^ 2))
      _ = Real.exp (-r ^ 2) := by
        rw [← Real.exp_add]
        congr 1
        ring
  calc
    Real.exp (-2 * r ^ 2) < (1 / 4 : ℝ) * Real.exp (-r ^ 2) := by
      nlinarith
    _ ≤ (1 / 4 : ℝ) * Real.exp (-((r + 1) ^ 2) / 2) := by
      apply mul_le_mul_of_nonneg_left _ (by norm_num)
      exact Real.exp_le_exp.mpr (by linarith)
    _ ≤ (Real.sqrt Real.pi)⁻¹ * (Real.sqrt (2 : ℝ))⁻¹ *
        Real.exp (-((r + 1) ^ 2) / 2) := by
      gcongr
      exact quarter_le_gaussianIntervalPrefactor
    _ = gaussianIntervalFloorReal r := by rfl

/-- The actual interval-overlap floor eventually exceeds the failure scale
claimed in the printed theorem. -/
theorem eventually_four_exp_neg_dimension_lt_gaussianIntervalFloorReal
    {A c : ℝ} (hA : 0 < A) (hc : 0 < c) :
    ∀ᶠ k : ℕ in atTop,
      4 * Real.exp (-((dimension A c k : ℕ) : ℝ)) <
        gaussianIntervalFloorReal (radius A k) := by
  have hr : ∀ᶠ k : ℕ in atTop, 3 ≤ radius A k :=
    (tendsto_radius A hA).eventually_ge_atTop 3
  filter_upwards
      [eventually_four_exp_neg_dimension_lt_exp_neg_two_radius_sq hA hc, hr] with
      k hdim hradius
  exact hdim.trans (exp_neg_two_sq_lt_gaussianIntervalFloorReal hradius)

end NumStability.HDP.Contract.Exercise476CounterexampleScalar
