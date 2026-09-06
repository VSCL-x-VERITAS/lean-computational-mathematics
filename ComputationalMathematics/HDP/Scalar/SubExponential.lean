import Mathlib.Analysis.Convex.Function
import Mathlib.Analysis.Calculus.Taylor
import Mathlib.Topology.Algebra.Order.Field
import Mathlib.Analysis.SpecialFunctions.Stirling
import Mathlib.Analysis.Complex.ExponentialBounds
import Mathlib.Analysis.SpecialFunctions.ImproperIntegrals
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Trigonometric.DerivHyp
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.MeasureTheory.Integral.Bochner.ContinuousLinearMap
import Mathlib.MeasureTheory.Function.L1Space.Integrable
import Mathlib.Probability.Distributions.Exponential
import Mathlib.Probability.Moments.IntegrableExpMul
import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Remark09.Signature
import ComputationalMathematics.HDP.Scalar.SubGaussian
import Mathlib.Tactic

/-!
# Orlicz functions

This module records the source-level Orlicz-function interface from Chapter 2,
Section 2.7.1.  The domain is represented by `ℝ`, with the defining
properties restricted to the nonnegative half-line.
-/

noncomputable section

open Filter Set TopologicalSpace
open MeasureTheory
open ProbabilityTheory
open scoped Topology ENNReal

namespace NumStability.HDP.Scalar.SubExponential

/-- A convex, nondecreasing function with the defining Orlicz properties. -/
structure OrliczFunction where
  /-- The underlying real function. -/
  toFun : ℝ → ℝ
  nonnegative : ∀ x, 0 ≤ x → 0 ≤ toFun x
  convexOn_nonneg : ConvexOn ℝ (Set.Ici 0) toFun
  monotoneOn_nonneg : MonotoneOn toFun (Set.Ici 0)
  map_zero : toFun 0 = 0
  tendsto_atTop : Tendsto toFun atTop atTop

instance : CoeFun OrliczFunction (fun _ => ℝ → ℝ) :=
  ⟨OrliczFunction.toFun⟩

/-- The Orlicz function separates every positive scale from zero. -/
theorem OrliczFunction.tendsto_scale_separation
    (ψ : OrliczFunction) {δ : ℝ} (hδ : 0 < δ) :
    Tendsto (fun t : ℝ => ψ (δ / t)) (𝓝[>] 0) atTop := by
  have hinv : Tendsto (fun t : ℝ => t⁻¹) (𝓝[>] (0 : ℝ)) atTop :=
    tendsto_inv_nhdsGT_zero
  have hscale : Tendsto (fun t : ℝ => δ / t) (𝓝[>] (0 : ℝ)) atTop := by
    have hmul := hinv.atTop_mul_pos hδ (tendsto_const_nhds :
      Tendsto (fun _ : ℝ => δ) (𝓝[>] (0 : ℝ)) (𝓝 δ))
    simpa [div_eq_mul_inv, mul_comm] using hmul
  exact ψ.tendsto_atTop.comp hscale

/-! The Luxemburg/Orlicz gauge and its a.e. quotient-level space. -/
/-- The Orlicz integral of a representative at scale `t`. -/
def orliczIntegral {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ) (t : ℝ≥0∞) : ENNReal :=
  ∫⁻ ω, ENNReal.ofReal (ψ (|X ω| / t.toReal)) ∂μ

/-- Admissibility of a scale for the Luxemburg gauge. -/
def orliczAdmissible {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ) (t : ℝ≥0∞) : Prop :=
  t ≠ 0 ∧ t ≠ ∞ ∧ orliczIntegral ψ μ X t ≤ 1

/-- The extended Luxemburg gauge associated with `ψ` and `μ`. -/
noncomputable def orliczGauge {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ) : ℝ≥0∞ :=
  sInf {t : ℝ≥0∞ | orliczAdmissible ψ μ X t}

/-- The predicate that a representative has finite Orlicz gauge. -/
def orliczMember {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ) : Prop :=
  orliczGauge ψ μ X < ∞

/-- Strongly measurable representatives with finite Orlicz gauge. -/
def orliczRepresentative {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) :=
  {X : Ω → ℝ // AEStronglyMeasurable X μ ∧ orliczMember ψ μ X}

/-- Almost-everywhere equality on Orlicz representatives. -/
def orliczAESetoid {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) : Setoid (orliczRepresentative ψ μ) where
  r X Y := X.1 =ᵐ[μ] Y.1
  iseqv := ⟨fun _ => Filter.Eventually.of_forall (fun _ => rfl),
    fun h => h.symm, fun h₁ h₂ => h₁.trans h₂⟩

/-- The almost-everywhere quotient of Orlicz representatives. -/
def orliczSpace {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) :=
  Quotient (orliczAESetoid ψ μ)

/-- The representative gauge and quotient carrier of an Orlicz norm space. -/
structure OrliczNormSpaceModelData
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) where
  /-- The Luxemburg gauge on representatives. -/
  representativeGauge : (Ω → ℝ) → ℝ≥0∞
  representativeGauge_eq : ∀ X, representativeGauge X = orliczGauge ψ μ X
  /-- The finite-gauge membership predicate on representatives. -/
  representativeMember : (Ω → ℝ) → Prop
  representativeMember_iff : ∀ X, representativeMember X ↔ orliczMember ψ μ X
  /-- The quotient by almost-everywhere equality. -/
  quotient : Type _
  quotient_eq : quotient = orliczSpace ψ μ
  admissible_smul_iff :
    ∀ (X : Ω → ℝ) {c t : ℝ}, 0 < c → 0 < t →
      (orliczAdmissible ψ μ X (ENNReal.ofReal t) ↔
        orliczAdmissible ψ μ (fun ω => c * X ω) (ENNReal.ofReal (c * t)))
  integral_mono :
    ∀ {X Y : Ω → ℝ} {t : ℝ≥0∞}, (∀ ω, |X ω| ≤ |Y ω|) → t ≠ 0 → t ≠ ∞ →
      orliczIntegral ψ μ X t ≤ orliczIntegral ψ μ Y t

lemma orliczAdmissible_smul_iff
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ)
    {c t : ℝ} (hc : 0 < c) (ht : 0 < t) :
    orliczAdmissible ψ μ X (ENNReal.ofReal t) ↔
      orliczAdmissible ψ μ (fun ω => c * X ω) (ENNReal.ofReal (c * t)) := by
  have ht0 : ENNReal.ofReal t ≠ 0 := (ENNReal.ofReal_ne_zero_iff).2 ht
  have htTop : ENNReal.ofReal t ≠ ∞ := ENNReal.ofReal_ne_top
  have hct0 : ENNReal.ofReal (c * t) ≠ 0 :=
    (ENNReal.ofReal_ne_zero_iff).2 (mul_pos hc ht)
  have hctTop : ENNReal.ofReal (c * t) ≠ ∞ := ENNReal.ofReal_ne_top
  have harg : (fun ω =>
      |c * X ω| / (ENNReal.ofReal (c * t)).toReal) =
      (fun ω => |X ω| / (ENNReal.ofReal t).toReal) := by
    funext ω
    simp only [ENNReal.toReal_ofReal (le_of_lt ht),
      ENNReal.toReal_ofReal (le_of_lt (mul_pos hc ht)), abs_mul, abs_of_pos hc]
    field_simp
  have hInt : orliczIntegral ψ μ (fun ω => c * X ω) (ENNReal.ofReal (c * t)) =
      orliczIntegral ψ μ X (ENNReal.ofReal t) := by
    unfold orliczIntegral
    have hfun : (fun ω => ENNReal.ofReal
        (ψ (|c * X ω| / (ENNReal.ofReal (c * t)).toReal))) =
        (fun ω => ENNReal.ofReal
          (ψ (|X ω| / (ENNReal.ofReal t).toReal))) := by
      funext ω
      rw [congrFun harg ω]
    rw [hfun]
  constructor
  · intro h
    exact ⟨hct0, hctTop, hInt ▸ h.2.2⟩
  · intro h
    exact ⟨ht0, htTop, hInt ▸ h.2.2⟩

lemma orliczIntegral_mono
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) {X Y : Ω → ℝ} {t : ℝ≥0∞}
    (hXY : ∀ ω, |X ω| ≤ |Y ω|) (ht0 : t ≠ 0) (htTop : t ≠ ∞) :
    orliczIntegral ψ μ X t ≤ orliczIntegral ψ μ Y t := by
  have htpos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
  apply lintegral_mono_ae
  exact Filter.Eventually.of_forall (fun ω => by
    apply ENNReal.ofReal_le_ofReal
    apply ψ.monotoneOn_nonneg
    · exact div_nonneg (abs_nonneg _) htpos.le
    · exact div_nonneg (abs_nonneg _) htpos.le
    · exact div_le_div_of_nonneg_right (hXY ω) htpos.le)

/-- Construct the canonical Orlicz norm-space model. -/
def orliczNormSpaceModel
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) : OrliczNormSpaceModelData ψ μ :=
  { representativeGauge := fun X => orliczGauge ψ μ X
    representativeGauge_eq := fun _ => rfl
    representativeMember := fun X => orliczMember ψ μ X
    representativeMember_iff := fun _ => Iff.rfl
    quotient := orliczSpace ψ μ
    quotient_eq := rfl
    admissible_smul_iff := by
      intro X c t
      simpa using (orliczAdmissible_smul_iff ψ μ X (c := c) (t := t))
    integral_mono := fun hXY ht0 htTop => orliczIntegral_mono ψ μ hXY ht0 htTop }

/-! The moment-to-MGF implication from Proposition 2.7.1. -/

/-- The root-free integral form of the source's `‖X‖ₚ ≤ K p` hypothesis.  The
real-parameter formulation keeps the statement faithful to the printed
proposition; the proof below specializes it to the integer moments appearing
in the exponential series. -/
def LpMomentGrowth {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (X : Ω → ℝ) (K : ℝ) : Prop :=
  AEMeasurable X μ ∧
    ∀ p : ℝ, 1 ≤ p →
      Integrable (fun ω => |X ω| ^ p) μ ∧
        (∫ ω, |X ω| ^ p ∂μ) ≤ (K * p) ^ p

/-- The `n`th nonnegative term in the absolute-MGF power series. -/
def absMGFTerm {Ω : Type*} (X : Ω → ℝ) (lam : ℝ) (n : ℕ) (ω : Ω) : ENNReal :=
  ENNReal.ofReal (((|lam| * |X ω|) ^ n) / (n.factorial : ℝ))

lemma absMGFTerm_aemeasurable
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {X : Ω → ℝ}
    (hX : AEMeasurable X μ) (lam : ℝ) (n : ℕ) :
    AEMeasurable (absMGFTerm X lam n) μ := by
  unfold absMGFTerm
  fun_prop

lemma exp_abs_series (x : ℝ) (hx : 0 ≤ x) :
    ENNReal.ofReal (Real.exp x) =
      ∑' n : ℕ, ENNReal.ofReal (x ^ n / (n.factorial : ℝ)) := by
  rw [← ENNReal.ofReal_tsum_of_nonneg (fun n => by positivity)
    (NormedSpace.expSeries_div_summable x)]
  rw [NormedSpace.expSeries_div_hasSum_exp x |>.tsum_eq]
  rw [← Real.exp_eq_exp_ℝ]

lemma linear_factorial_ratio_bound (n : ℕ) (hn : 1 ≤ n) :
    ((n : ℝ) ^ n) / (n.factorial : ℝ) ≤ (Real.exp 1) ^ n := by
  have hfac := Stirling.le_factorial_stirling n
  have hroot : 1 ≤ Real.sqrt (2 * Real.pi * (n : ℝ)) := by
    rw [Real.one_le_sqrt]
    have hpi : (2 : ℝ) ≤ Real.pi := by
      nlinarith [Real.one_le_pi_div_two]
    have hnpos : (0 : ℝ) < (n : ℝ) := by
      exact_mod_cast (show 0 < n by omega)
    have hn1 : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
    have hprod : (1 : ℝ) ≤ Real.pi * n := by
      nlinarith [mul_le_mul_of_nonneg_right hpi (le_of_lt hnpos)]
    nlinarith [hprod]
  have hfac' : (n : ℝ) ^ n / (Real.exp 1) ^ n ≤ (n.factorial : ℝ) := by
    have hfac'' := (le_trans (mul_le_mul_of_nonneg_right hroot
      (by positivity : 0 ≤ ((n : ℝ) / Real.exp 1) ^ n)) hfac)
    simpa [div_pow] using hfac''
  have hmul : (n : ℝ) ^ n ≤ (n.factorial : ℝ) * (Real.exp 1) ^ n := by
    rw [← div_le_iff₀ (by positivity : 0 < (Real.exp 1) ^ n)]
    simpa [div_pow] using hfac'
  exact (div_le_iff₀ (by positivity : (0 : ℝ) < (n.factorial : ℝ))).2
    (by simpa [mul_comm] using hmul)

lemma absMGFTerm_lintegral_le_geom
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {X : Ω → ℝ} {K lam : ℝ}
    (hK : 0 ≤ K) (hMom : LpMomentGrowth μ X K) {n : ℕ} (hn : 1 ≤ n) :
    (∫⁻ ω, absMGFTerm X lam n ω ∂μ) ≤
      ENNReal.ofReal ((Real.exp 1 * (|lam| * K)) ^ n) := by
  have hp := hMom.2 (n : ℝ) (by exact_mod_cast hn)
  have hterm :
      absMGFTerm X lam n = fun ω =>
        ENNReal.ofReal ((|lam| ^ n / (n.factorial : ℝ)) * |X ω| ^ n) := by
    funext ω
    unfold absMGFTerm
    congr 1
    rw [mul_pow]
    ring
  rw [hterm]
  have hscalar : 0 ≤ |lam| ^ n / (n.factorial : ℝ) := by positivity
  have hfactor :
      (fun ω => ENNReal.ofReal ((|lam| ^ n / (n.factorial : ℝ)) * |X ω| ^ n)) =
        (fun ω => ENNReal.ofReal (|lam| ^ n / (n.factorial : ℝ)) *
          ENNReal.ofReal (|X ω| ^ n)) := by
    funext ω
    rw [ENNReal.ofReal_mul hscalar]
  rw [hfactor, lintegral_const_mul' _ _ (by simp)]
  have hXpow : (fun ω => |X ω| ^ n) = (fun ω => |X ω| ^ (n : ℝ)) := by
    funext ω
    rw [Real.rpow_natCast]
  have hXpowENN :
      (fun ω => ENNReal.ofReal (|X ω| ^ n)) =
        (fun ω => ENNReal.ofReal (|X ω| ^ (n : ℝ))) := by
    funext ω
    rw [Real.rpow_natCast]
  rw [hXpowENN]
  rw [← ofReal_integral_eq_lintegral_ofReal hp.1
    (Filter.Eventually.of_forall (fun ω => by positivity))]
  have hbound := mul_le_mul_of_nonneg_left hp.2 hscalar
  rw [← ENNReal.ofReal_mul hscalar]
  apply ENNReal.ofReal_le_ofReal
  calc
    |lam| ^ n / (n.factorial : ℝ) *
          (∫ ω, |X ω| ^ (n : ℝ) ∂μ) ≤
        |lam| ^ n / (n.factorial : ℝ) * (K * (n : ℝ)) ^ (n : ℝ) := hbound
    _ = ((|lam| * K) ^ n * (n : ℝ) ^ n) / (n.factorial : ℝ) := by
      rw [Real.rpow_natCast]
      rw [mul_pow]
      ring
    _ ≤ (Real.exp 1 * (|lam| * K)) ^ n := by
      have hratio := linear_factorial_ratio_bound n hn
      have hnonneg : 0 ≤ (|lam| * K) ^ n := by positivity
      apply (div_le_iff₀ (by positivity : (0 : ℝ) < (n.factorial : ℝ))).2
      have hratio' : (n : ℝ) ^ n ≤ (Real.exp 1) ^ n * (n.factorial : ℝ) :=
        (div_le_iff₀ (by positivity : (0 : ℝ) < (n.factorial : ℝ))).mp hratio
      calc
        (|lam| * K) ^ n * (n : ℝ) ^ n ≤
            (|lam| * K) ^ n * ((Real.exp 1) ^ n * (n.factorial : ℝ)) := by
              gcongr
        _ = (Real.exp 1 * (|lam| * K)) ^ n * (n.factorial : ℝ) := by
          rw [mul_pow]
          ring

lemma absMGFTerm_eq
    {Ω : Type*} (X : Ω → ℝ) (lam : ℝ) (n : ℕ) (ω : Ω) :
    absMGFTerm X lam n ω =
      ENNReal.ofReal ((|lam| ^ n / (n.factorial : ℝ)) * |X ω| ^ n) := by
  unfold absMGFTerm
  congr 1
  rw [mul_pow]
  ring

lemma exp_abs_integrable
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K lam : ℝ} (hMom : LpMomentGrowth μ X K)
    (hK : 0 < K) (hsmall : |lam| * K ≤ (4 * Real.exp 1)⁻¹) :
    Integrable (fun ω => Real.exp (|lam| * |X ω|)) μ ∧
      (∫ ω, Real.exp (|lam| * |X ω|) ∂μ) ≤
        Real.exp (2 * Real.exp 1 * (|lam| * K)) := by
  let q : ℝ := Real.exp 1 * (|lam| * K)
  have hq0 : 0 ≤ q := by positivity
  have hq : q ≤ 1 / 4 := by
    dsimp [q]
    have hepos : 0 < Real.exp 1 := Real.exp_pos _
    have := mul_le_mul_of_nonneg_left hsmall (le_of_lt hepos)
    field_simp at this ⊢
    nlinarith
  have hqsum : Summable (fun n : ℕ => q ^ n) := by
    exact (hasSum_geometric_of_lt_one hq0
      (lt_of_le_of_lt hq (by norm_num))).summable
  have hterm_sum :
      (∑' n : ℕ, ∫⁻ ω, absMGFTerm X lam n ω ∂μ) ≤
        ∑' n : ℕ, ENNReal.ofReal (q ^ n) := by
    apply ENNReal.tsum_le_tsum
    intro n
    cases n with
    | zero => simp [absMGFTerm]
    | succ n =>
        simpa [q] using
          (absMGFTerm_lintegral_le_geom hK.le hMom (n := n + 1) (by omega))
  have hbound :
      (∫⁻ ω, ENNReal.ofReal (Real.exp (|lam| * |X ω|)) ∂μ) ≤
        ENNReal.ofReal (Real.exp (2 * q)) := by
    calc
      (∫⁻ ω, ENNReal.ofReal (Real.exp (|lam| * |X ω|)) ∂μ) =
          ∫⁻ ω, ∑' n : ℕ, absMGFTerm X lam n ω ∂μ := by
            apply lintegral_congr_ae
            filter_upwards [] with ω
            exact exp_abs_series (|lam| * |X ω|) (by positivity)
      _ = ∑' n : ℕ, ∫⁻ ω, absMGFTerm X lam n ω ∂μ := by
            apply lintegral_tsum
            intro n
            exact absMGFTerm_aemeasurable hMom.1 lam n
      _ ≤ ∑' n : ℕ, ENNReal.ofReal (q ^ n) := hterm_sum
      _ = ENNReal.ofReal (∑' n : ℕ, q ^ n) := by
            symm
            exact ENNReal.ofReal_tsum_of_nonneg (fun n => by positivity) hqsum
      _ ≤ ENNReal.ofReal (Real.exp (2 * q)) := by
            have hsum := (hasSum_geometric_of_lt_one hq0
              (lt_of_le_of_lt hq (by norm_num))).tsum_eq
            rw [hsum]
            have hden : 0 < 1 - q := by linarith
            have hrat : (1 - q)⁻¹ ≤ 1 + 2 * q := by
              rw [inv_eq_one_div]
              apply (div_le_iff₀ hden).2
              nlinarith [mul_nonneg hq0 (sub_nonneg.mpr (by linarith : q ≤ 1 / 2))]
            exact ENNReal.ofReal_le_ofReal
              (hrat.trans (by simpa [add_comm] using Real.add_one_le_exp (2 * q)))
  rcases hMom.1 with ⟨g, hg, hXg⟩
  have hAbs : AEMeasurable (fun ω => |X ω|) μ := by
    apply (hg.norm.aemeasurable.congr ?_)
    filter_upwards [hXg] with ω hω
    simp [Real.norm_eq_abs, hω]
  have hmeas : AEMeasurable (fun ω => Real.exp (|lam| * |X ω|)) μ := by
    fun_prop
  have hfinite :
      (∫⁻ ω, ‖Real.exp (|lam| * |X ω|)‖ₑ ∂μ) < (⊤ : ENNReal) := by
    have htop : ENNReal.ofReal (Real.exp (2 * q)) < (⊤ : ENNReal) :=
      ENNReal.ofReal_lt_top
    refine lt_of_le_of_lt ?_ htop
    simpa only [← ofReal_norm_eq_enorm, Real.norm_eq_abs,
      abs_of_pos (Real.exp_pos _)] using hbound
  have hInt : Integrable (fun ω => Real.exp (|lam| * |X ω|)) μ :=
    ⟨hmeas.aestronglyMeasurable, (hasFiniteIntegral_iff_enorm).2 hfinite⟩
  refine ⟨hInt, ?_⟩
  have hEq := ofReal_integral_eq_lintegral_ofReal hInt
    (Filter.Eventually.of_forall (fun ω => (Real.exp_pos _).le))
  rw [← hEq] at hbound
  simpa [q, mul_assoc] using
    (ENNReal.ofReal_le_ofReal_iff (Real.exp_nonneg _)).mp hbound

/-- The `n`th term in the centered absolute-MGF remainder series. -/
def mgfRemainderTerm {Ω : Type*} (X : Ω → ℝ) (lam : ℝ) (n : ℕ) (ω : Ω) : ENNReal :=
  ENNReal.ofReal (((|lam| * |X ω|) ^ (n + 2)) / ((n + 2).factorial : ℝ))

lemma mgfRemainderTerm_aemeasurable
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {X : Ω → ℝ}
    (hX : AEMeasurable X μ) (lam : ℝ) (n : ℕ) :
    AEMeasurable (mgfRemainderTerm X lam n) μ := by
  unfold mgfRemainderTerm
  fun_prop

lemma exp_abs_remainder_series (y : ℝ) :
    ENNReal.ofReal (Real.exp |y| - 1 - |y|) =
      ∑' n : ℕ, ENNReal.ofReal ((|y| ^ (n + 2)) / ((n + 2).factorial : ℝ)) := by
  let f : ℕ → ℝ := fun n => |y| ^ n / (n.factorial : ℝ)
  have hsum : Summable f := by
    dsimp [f]
    exact NormedSpace.expSeries_div_summable |y|
  have hsplit := hsum.sum_add_tsum_nat_add 2
  have hexp : (∑' n : ℕ, f n) = Real.exp |y| := by
    dsimp [f]
    rw [Real.exp_eq_exp_ℝ]
    exact (NormedSpace.expSeries_div_hasSum_exp |y|).tsum_eq
  have htail :
      (∑' n : ℕ, |y| ^ (n + 2) / ((n + 2).factorial : ℝ)) =
        Real.exp |y| - 1 - |y| := by
    have hsplit' :
        f 0 + f 1 + ∑' n : ℕ, f (n + 2) = Real.exp |y| := by
      simpa [Finset.sum_range_succ, f, Nat.factorial] using hsplit.trans hexp
    dsimp [f] at hsplit'
    have hpow : |y| ^ 1 = |y| := by simp
    rw [hpow] at hsplit'
    linarith
  rw [← ENNReal.ofReal_tsum_of_nonneg (fun n => by positivity)]
  · rw [htail]
  · have hinj : Function.Injective (fun n : ℕ => n + 2) := by
      intro a b hab
      change a + 2 = b + 2 at hab
      exact Nat.add_right_cancel hab
    simpa [f] using hsum.comp_injective hinj

lemma mgfRemainderTerm_lintegral_le_geom
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {X : Ω → ℝ} {K lam : ℝ}
    (hK : 0 ≤ K) (hMom : LpMomentGrowth μ X K) (n : ℕ) :
    (∫⁻ ω, mgfRemainderTerm X lam n ω ∂μ) ≤
      ENNReal.ofReal ((Real.exp 1 * (|lam| * K)) ^ (n + 2)) := by
  have h := absMGFTerm_lintegral_le_geom (lam := lam) hK hMom
    (n := n + 2) (by omega)
  simpa [mgfRemainderTerm, absMGFTerm] using h

lemma mgfRemainder_lintegral_le
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K lam : ℝ} (hK : 0 ≤ K)
    (hMom : LpMomentGrowth μ X K)
    (hsmall : |lam| * K ≤ (4 * Real.exp 1)⁻¹) :
    (∫⁻ ω, ENNReal.ofReal (Real.exp (|lam| * |X ω|) - 1 -
      |lam| * |X ω|) ∂μ) ≤
        ENNReal.ofReal (2 * (Real.exp 1 * (|lam| * K)) ^ 2) := by
  let q : ℝ := Real.exp 1 * (|lam| * K)
  have hq0 : 0 ≤ q := by positivity
  have hq : q ≤ 1 / 4 := by
    dsimp [q]
    have hepos : 0 < Real.exp 1 := Real.exp_pos _
    have := mul_le_mul_of_nonneg_left hsmall (le_of_lt hepos)
    field_simp at this ⊢
    nlinarith
  have hqsum : Summable (fun n : ℕ => q ^ (n + 2)) := by
    have hsum := (hasSum_geometric_of_lt_one hq0
      (lt_of_le_of_lt hq (by norm_num))).summable
    have hinj : Function.Injective (fun n : ℕ => n + 2) := by
      intro a b hab
      change a + 2 = b + 2 at hab
      exact Nat.add_right_cancel hab
    simpa using hsum.comp_injective hinj
  have hterm_sum :
      (∑' n : ℕ, ∫⁻ ω, mgfRemainderTerm X lam n ω ∂μ) ≤
        ∑' n : ℕ, ENNReal.ofReal (q ^ (n + 2)) := by
    apply ENNReal.tsum_le_tsum
    intro n
    simpa [q] using mgfRemainderTerm_lintegral_le_geom hK hMom n
  calc
    (∫⁻ ω, ENNReal.ofReal (Real.exp (|lam| * |X ω|) - 1 -
        |lam| * |X ω|) ∂μ) =
        ∫⁻ ω, ∑' n : ℕ, mgfRemainderTerm X lam n ω ∂μ := by
          apply lintegral_congr_ae
          filter_upwards [] with ω
          simpa [abs_mul, mgfRemainderTerm] using exp_abs_remainder_series (lam * X ω)
    _ = ∑' n : ℕ, ∫⁻ ω, mgfRemainderTerm X lam n ω ∂μ := by
          apply lintegral_tsum
          intro n
          exact mgfRemainderTerm_aemeasurable hMom.1 lam n
    _ ≤ ∑' n : ℕ, ENNReal.ofReal (q ^ (n + 2)) := hterm_sum
    _ = ENNReal.ofReal (∑' n : ℕ, q ^ (n + 2)) := by
          symm
          exact ENNReal.ofReal_tsum_of_nonneg (fun n => by positivity) hqsum
    _ = ENNReal.ofReal (q ^ 2 * (1 - q)⁻¹) := by
          congr 1
          have hgeom : Summable (fun n : ℕ => q ^ n) :=
            (hasSum_geometric_of_lt_one hq0
              (lt_of_le_of_lt hq (by norm_num))).summable
          have hsum := (hasSum_geometric_of_lt_one hq0
            (lt_of_le_of_lt hq (by norm_num))).tsum_eq
          have hmul :
              (∑' n : ℕ, q ^ n * q ^ 2) = (∑' n : ℕ, q ^ n) * q ^ 2 := by
            exact hgeom.tsum_mul_right (q ^ 2)
          rw [show (∑' n : ℕ, q ^ (n + 2)) =
              ∑' n : ℕ, q ^ n * q ^ 2 by
                apply tsum_congr
                intro n
                rw [pow_add]]
          rw [hmul, hsum]
          ring
    _ ≤ ENNReal.ofReal (2 * q ^ 2) := by
          apply ENNReal.ofReal_le_ofReal
          have hden : 0 < 1 - q := by linarith
          have hrat : (1 - q)⁻¹ ≤ 2 := by
            rw [inv_eq_one_div]
            apply (div_le_iff₀ hden).2
            linarith
          nlinarith [mul_le_mul_of_nonneg_left hrat (sq_nonneg q)]
    _ = ENNReal.ofReal (2 * (Real.exp 1 * (|lam| * K)) ^ 2) := by
          congr 2

lemma exp_le_centered_remainder (y : ℝ) :
    Real.exp y ≤ 1 + y + (Real.exp |y| - 1 - |y|) := by
  rcases le_total 0 y with hy | hy
  · simp [abs_of_nonneg hy]
  · have hx : 0 ≤ -y := neg_nonneg.mpr hy
    have hs : -y ≤ Real.sinh (-y) := (Real.self_le_sinh_iff).2 hx
    rw [Real.sinh_eq] at hs
    simp only [neg_neg] at hs
    rw [abs_of_nonpos hy]
    linarith

/-- The pointwise remainder after the constant and linear MGF terms. -/
def mgfRemainder {Ω : Type*} (X : Ω → ℝ) (lam : ℝ) (ω : Ω) : ℝ :=
  Real.exp (|lam| * |X ω|) - 1 - |lam| * |X ω|

lemma mgfRemainder_nonneg
    {Ω : Type*} (X : Ω → ℝ) (lam : ℝ) (ω : Ω) :
    0 ≤ mgfRemainder X lam ω := by
  unfold mgfRemainder
  have h := Real.add_one_le_exp (|lam| * |X ω|)
  linarith

lemma mgfRemainder_integrable
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {lam : ℝ} (hX : Integrable X μ)
    (hExp : Integrable (fun ω => Real.exp (|lam| * |X ω|)) μ) :
    Integrable (mgfRemainder X lam) μ := by
  have hlin : Integrable (fun ω => |lam| * |X ω|) μ :=
    hX.norm.const_mul |lam|
  simpa [mgfRemainder] using (hExp.sub (integrable_const 1)).sub hlin

/-! If all moments grow linearly, the centered MGF has a quadratic local
bound.  The proof expands the exponential at order two, bounds the absolute
remainder by the linear moment series, and uses the mean-zero hypothesis to
remove the first-order term. -/
theorem momentToMGF
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (hLp : LpMomentGrowth μ X K) (lam : ℝ)
    (hsmall : |lam| ≤ (4 * Real.exp 1 * K)⁻¹) :
    Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
      (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
        Real.exp (2 * (Real.exp 1 * (lam * K)) ^ 2) := by
  have hsmall' : |lam| * K ≤ (4 * Real.exp 1)⁻¹ := by
    calc
      |lam| * K ≤ (4 * Real.exp 1 * K)⁻¹ * K :=
        mul_le_mul_of_nonneg_right hsmall hK.le
      _ = (4 * Real.exp 1)⁻¹ := by field_simp
  have hAbs := exp_abs_integrable hLp hK hsmall'
  have hIntMgf : Integrable (fun ω => Real.exp (lam * X ω)) μ := by
    have hlin := hCenter.1.const_mul lam
    refine MeasureTheory.Integrable.mono' hAbs.1
      (hlin.aemeasurable.exp).aestronglyMeasurable ?_
    filter_upwards [] with ω
    calc
      ‖Real.exp (lam * X ω)‖ = Real.exp (lam * X ω) := by
        rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
      _ ≤ Real.exp (|lam| * |X ω|) := by
        apply Real.exp_le_exp.mpr
        simpa [abs_mul] using le_abs_self (lam * X ω)
  have hRInt : Integrable (mgfRemainder X lam) μ :=
    mgfRemainder_integrable hCenter.1 hAbs.1
  have hsum : Integrable (fun ω => 1 + lam * X ω + mgfRemainder X lam ω) μ := by
    exact (integrable_const 1).add (hCenter.1.const_mul lam) |>.add hRInt
  have hmono := MeasureTheory.integral_mono_ae hIntMgf hsum
    (Filter.Eventually.of_forall (fun ω => by
      simpa [mgfRemainder, abs_mul] using exp_le_centered_remainder (lam * X ω)))
  have hRnonneg : ∀ᵐ ω ∂μ, 0 ≤ mgfRemainder X lam ω :=
    Filter.Eventually.of_forall (mgfRemainder_nonneg X lam)
  have hRboundENN := mgfRemainder_lintegral_le hK.le hLp hsmall'
  have hRboundENN' :
      (∫⁻ ω, ENNReal.ofReal (mgfRemainder X lam ω) ∂μ) ≤
        ENNReal.ofReal (2 * (Real.exp 1 * (|lam| * K)) ^ 2) := by
    simpa [mgfRemainder] using hRboundENN
  have hReq := ofReal_integral_eq_lintegral_ofReal hRInt hRnonneg
  rw [← hReq] at hRboundENN'
  have hRbound :
      (∫ ω, mgfRemainder X lam ω ∂μ) ≤
        2 * (Real.exp 1 * (|lam| * K)) ^ 2 := by
    exact (ENNReal.ofReal_le_ofReal_iff (by positivity)).mp hRboundENN'
  refine ⟨hIntMgf, ?_⟩
  calc
    (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
        ∫ ω, 1 + lam * X ω + mgfRemainder X lam ω ∂μ := hmono
    _ = 1 + lam * (∫ ω, X ω ∂μ) +
        ∫ ω, mgfRemainder X lam ω ∂μ := by
          calc
            (∫ ω, 1 + lam * X ω + mgfRemainder X lam ω ∂μ) =
                (∫ ω, 1 + lam * X ω ∂μ) +
                  ∫ ω, mgfRemainder X lam ω ∂μ := by
                    exact integral_add ((integrable_const 1).add
                      (hCenter.1.const_mul lam)) hRInt
            _ = 1 + lam * (∫ ω, X ω ∂μ) +
                  ∫ ω, mgfRemainder X lam ω ∂μ := by
                    rw [integral_add (integrable_const 1)
                      (hCenter.1.const_mul lam), integral_const, integral_const_mul]
                    simp
    _ = 1 + ∫ ω, mgfRemainder X lam ω ∂μ := by rw [hCenter.2]; ring
    _ ≤ 1 + 2 * (Real.exp 1 * (|lam| * K)) ^ 2 := by gcongr
    _ ≤ Real.exp (2 * (Real.exp 1 * (lam * K)) ^ 2) := by
      calc
        1 + 2 * (Real.exp 1 * (|lam| * K)) ^ 2 =
            2 * (Real.exp 1 * (|lam| * K)) ^ 2 + 1 := by ring
        _ ≤ Real.exp (2 * (Real.exp 1 * (|lam| * K)) ^ 2) :=
          Real.add_one_le_exp _
        _ = Real.exp (2 * (Real.exp 1 * (lam * K)) ^ 2) := by
          congr 2
          rw [mul_pow, mul_pow, sq_abs]
          ring

/-! The endpoint MGF hypothesis used for the reverse implication. -/
/-- Two endpoint exponential-moment bounds at scale `K`. -/
def TwoSidedMGFBound {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (X : Ω → ℝ) (K C : ℝ) : Prop :=
  AEMeasurable X μ ∧
    (Integrable (fun ω => Real.exp (X ω / K)) μ ∧
      (∫ ω, Real.exp (X ω / K) ∂μ) ≤ Real.exp C) ∧
    (Integrable (fun ω => Real.exp (-X ω / K)) μ ∧
      (∫ ω, Real.exp (-X ω / K) ∂μ) ≤ Real.exp C)

lemma rpow_le_exp_mul
    {y p : ℝ} (hy : 0 ≤ y) (hp : 1 ≤ p) :
    y ^ p ≤ p ^ p * Real.exp y := by
  have hp0 : 0 < p := lt_of_lt_of_le (by norm_num) hp
  rcases eq_or_lt_of_le hy with rfl | hy
  · simp [hp0.ne']
    positivity
  have hlog := Real.log_le_sub_one_of_pos (div_pos hy hp0)
  rw [Real.log_div hy.ne' hp0.ne'] at hlog
  have hmul := mul_le_mul_of_nonneg_left hlog hp0.le
  have hlogbound : Real.log y * p ≤ Real.log p * p + y := by
    calc
      Real.log y * p = p * (Real.log y - Real.log p) + p * Real.log p := by ring
      _ ≤ p * (y / p - 1) + p * Real.log p :=
        by simpa [add_comm] using add_le_add_right hmul (p * Real.log p)
      _ = y - p + Real.log p * p := by field_simp
      _ ≤ Real.log p * p + y := by nlinarith
  calc
    y ^ p = Real.exp (Real.log y * p) := by
      rw [Real.rpow_def_of_pos hy p]
    _ ≤ Real.exp (Real.log p * p + y) := Real.exp_le_exp.mpr hlogbound
    _ = p ^ p * Real.exp y := by
      rw [Real.rpow_def_of_pos hp0 p, Real.exp_add]

/-! The reverse implication in Proposition 2.7.1.  The endpoint MGF bound
controls the exponential of the absolute value, and the elementary estimate
`|x|^p ≤ p^p exp |x|` then gives every real moment. -/
theorem mgfToMoment
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K C : ℝ} (hK : 0 < K) (hC : 0 ≤ C)
    (hMGF : TwoSidedMGFBound μ X K C) :
    LpMomentGrowth μ X (2 * Real.exp C * K) := by
  rcases hMGF with ⟨hX, hPlus, hMinus⟩
  have hPlus' : Integrable (fun ω => Real.exp (K⁻¹ * X ω)) μ := by
    simpa [div_eq_mul_inv, mul_comm] using hPlus.1
  have hMinus' : Integrable (fun ω => Real.exp (-(K⁻¹) * X ω)) μ := by
    simpa [div_eq_mul_inv, mul_comm] using hMinus.1
  have ht : K⁻¹ ≠ 0 := inv_ne_zero hK.ne'
  have hAbsExp : Integrable (fun ω => Real.exp (|X ω| / K)) μ := by
    convert ProbabilityTheory.integrable_exp_abs_mul_abs
      (X := X) (μ := μ) (t := K⁻¹) hPlus' hMinus' using 1
    funext ω
    congr 1
    rw [abs_of_pos (inv_pos.mpr hK)]
    ring
  have hSumExp : Integrable
      (fun ω => Real.exp (X ω / K) + Real.exp (-X ω / K)) μ :=
    hPlus.1.add hMinus.1
  have hAbsExp_le : ∀ ω, Real.exp (|X ω| / K) ≤
      Real.exp (X ω / K) + Real.exp (-X ω / K) := by
    intro ω
    by_cases hω : 0 ≤ X ω
    · rw [abs_of_nonneg hω]
      exact le_add_of_nonneg_right (Real.exp_nonneg _)
    · rw [abs_of_neg (lt_of_not_ge hω)]
      exact le_add_of_nonneg_left (Real.exp_nonneg _)
  refine ⟨hX, ?_⟩
  intro p hp
  have hp0 : 0 < p := lt_of_lt_of_le (by norm_num) hp
  have hIntMoment : Integrable (fun ω => |X ω| ^ p) μ :=
    ProbabilityTheory.integrable_rpow_abs_of_integrable_exp_mul
      (X := X) (μ := μ) ht hPlus' hMinus' hp0.le
  have hPoint : ∀ ω, |X ω| ^ p ≤
      (K * p) ^ p * (Real.exp (X ω / K) + Real.exp (-X ω / K)) := by
    intro ω
    have hscaled : |X ω| = K * (|X ω| / K) := by field_simp
    have hpow := rpow_le_exp_mul (y := |X ω| / K) (by positivity) hp
    have hexp := hAbsExp_le ω
    calc
      |X ω| ^ p = (K * (|X ω| / K)) ^ p := by
        exact congrArg (fun z : ℝ => z ^ p) hscaled
      _ = K ^ p * (|X ω| / K) ^ p := by
        rw [Real.mul_rpow hK.le (by positivity)]
      _ ≤ K ^ p * (p ^ p * Real.exp (|X ω| / K)) := by
        gcongr
      _ ≤ K ^ p * (p ^ p *
          (Real.exp (X ω / K) + Real.exp (-X ω / K))) := by
        gcongr
      _ = (K * p) ^ p *
          (Real.exp (X ω / K) + Real.exp (-X ω / K)) := by
        rw [Real.mul_rpow hK.le hp0.le]
        ring
  have hDom : Integrable
      (fun ω => (K * p) ^ p *
        (Real.exp (X ω / K) + Real.exp (-X ω / K))) μ :=
    hSumExp.const_mul _
  have hIntegral := MeasureTheory.integral_mono_ae hIntMoment hDom
    (Filter.Eventually.of_forall hPoint)
  have hIntegral' :
      (∫ ω, |X ω| ^ p ∂μ) ≤ (K * p) ^ p * (2 * Real.exp C) := by
    calc
      (∫ ω, |X ω| ^ p ∂μ) ≤
          ∫ ω, (K * p) ^ p *
            (Real.exp (X ω / K) + Real.exp (-X ω / K)) ∂μ := hIntegral
      _ = (K * p) ^ p *
          (∫ ω, Real.exp (X ω / K) + Real.exp (-X ω / K) ∂μ) :=
        MeasureTheory.integral_const_mul _ _
      _ = (K * p) ^ p *
          ((∫ ω, Real.exp (X ω / K) ∂μ) +
            (∫ ω, Real.exp (-X ω / K) ∂μ)) := by
        rw [MeasureTheory.integral_add hPlus.1 hMinus.1]
      _ ≤ (K * p) ^ p * (2 * Real.exp C) := by
        gcongr
        exact (add_le_add hPlus.2 hMinus.2).trans
          (by simp [two_mul])
  have hA : 1 ≤ 2 * Real.exp C := by
    have := Real.one_le_exp hC
    nlinarith
  have hA' : 2 * Real.exp C ≤ (2 * Real.exp C) ^ p := by
    simpa [Real.rpow_one] using
      Real.rpow_le_rpow_of_exponent_le hA hp
  refine ⟨hIntMoment, ?_⟩
  calc
    (∫ ω, |X ω| ^ p ∂μ) ≤ (K * p) ^ p * (2 * Real.exp C) := hIntegral'
    _ ≤ (K * p) ^ p * (2 * Real.exp C) ^ p := by
      exact mul_le_mul_of_nonneg_left hA' (by positivity)
    _ = (2 * Real.exp C * K * p) ^ p := by
      rw [← Real.mul_rpow (by positivity) (by positivity)]
      ring

/-! Exercise 2.7.2: the four equivalent absolute-value interfaces. -/

/-- The two-sided sub-exponential tail-bound presentation. -/
def SubExponentialTailBound {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧
    ∀ t : ℝ, 0 ≤ t →
      μ.real {ω | |X ω| ≥ t} ≤ 2 * Real.exp (-t / K)

/-- The moment-growth presentation of a sub-exponential bound. -/
def SubExponentialMomentBound {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧ LpMomentGrowth μ X K

/-- The local absolute-MGF presentation of a sub-exponential bound. -/
def SubExponentialAbsoluteMGFLocal {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧
    ∀ lam : ℝ, 0 ≤ lam → lam ≤ K⁻¹ →
      Integrable (fun ω => Real.exp (lam * |X ω|)) μ ∧
        (∫ ω, Real.exp (lam * |X ω|) ∂μ) ≤ Real.exp (K * lam)

/-- The one-point absolute-MGF presentation of a sub-exponential bound. -/
def SubExponentialOnePointMGF {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧
    Integrable (fun ω => Real.exp (|X ω| / K)) μ ∧
      (∫ ω, Real.exp (|X ω| / K) ∂μ) ≤ 2

/-- The four equivalent presentations of the sub-exponential property. -/
inductive SubExponentialPropertyKind
  | tail
  | moment
  | absoluteMGF
  | onePoint

/-- Interpret a sub-exponential presentation at a specified scale. -/
def SubExponentialProperty {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) :
    SubExponentialPropertyKind → ℝ → Prop
  | .tail => SubExponentialTailBound μ X
  | .moment => SubExponentialMomentBound μ X
  | .absoluteMGF => SubExponentialAbsoluteMGFLocal μ X
  | .onePoint => SubExponentialOnePointMGF μ X

private theorem subExponentialTailToMoment
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hTail : SubExponentialTailBound μ X K) :
    SubExponentialMomentBound μ X (8 * Real.exp 1 * K) := by
  have hTail' : ∀ t : ℝ, 0 ≤ t →
      μ {ω | t < |X ω|} ≤ ENNReal.ofReal (2 * Real.exp (-t / K)) := by
    intro t ht
    let A : Set Ω := {ω | t < |X ω|}
    let B : Set Ω := {ω | |X ω| ≥ t}
    have hAB : A ⊆ B := by
      intro ω hω
      change t < |X ω| at hω
      change t ≤ |X ω|
      exact le_of_lt hω
    have hB : μ B ≤ ENNReal.ofReal (2 * Real.exp (-t / K)) := by
      rw [← ENNReal.ofReal_toReal (measure_ne_top μ B)]
      apply ENNReal.ofReal_le_ofReal
      simpa [B, MeasureTheory.measureReal_def] using hTail.2.2 t ht
    exact (measure_mono hAB).trans hB
  refine ⟨hTail.1,
    mul_pos (mul_pos (by norm_num) (Real.exp_pos 1)) hTail.2.1, ?_⟩
  refine ⟨hTail.1.aemeasurable, ?_⟩
  intro p hp
  have hp0 : 0 < p := lt_of_lt_of_le (by norm_num) hp
  have hformula := NumStability.HDP.Scalar.Preliminaries.momentTailFormula
    (μ := μ) (X := X) hTail.1 hp0
  have hupper :
      (∫⁻ t in Set.Ioi 0,
        μ {ω | t < |X ω|} * ENNReal.ofReal (t ^ (p - 1))) ≤
        ∫⁻ t in Set.Ioi 0,
          ENNReal.ofReal (2 * Real.exp (-t / K)) *
            ENNReal.ofReal (t ^ (p - 1)) := by
    apply MeasureTheory.setLIntegral_mono
    · fun_prop
    · intro t ht
      exact mul_le_mul_left (hTail' t (le_of_lt (Set.mem_Ioi.mp ht))) _
  have hInt : IntegrableOn
      (fun t : ℝ => t ^ (p - 1) * Real.exp (-(K⁻¹) * t)) (Set.Ioi 0) := by
    simpa only [Real.rpow_one] using (integrableOn_rpow_mul_exp_neg_mul_rpow
      (p := (1 : ℝ)) (s := p - 1) (b := K⁻¹)
      (by linarith) (by norm_num) (inv_pos.mpr hTail.2.1))
  have hscale : ∀ t : ℝ,
      ENNReal.ofReal (2 * Real.exp (-t / K)) *
          ENNReal.ofReal (t ^ (p - 1)) =
        ENNReal.ofReal (2 * (t ^ (p - 1) * Real.exp (-(K⁻¹) * t))) := by
    intro t
    calc
      ENNReal.ofReal (2 * Real.exp (-t / K)) *
          ENNReal.ofReal (t ^ (p - 1)) =
        ENNReal.ofReal ((2 * Real.exp (-t / K)) * (t ^ (p - 1))) :=
          (ENNReal.ofReal_mul (by positivity)).symm
      _ = ENNReal.ofReal (2 * (t ^ (p - 1) * Real.exp (-(K⁻¹) * t))) := by
        congr 1
        field_simp [ne_of_gt hTail.2.1]
  have hInt2 : IntegrableOn
      (fun t : ℝ => 2 * (t ^ (p - 1) * Real.exp (-(K⁻¹) * t))) (Set.Ioi 0) :=
    hInt.const_mul _
  have hEq2 := MeasureTheory.ofReal_integral_eq_lintegral_ofReal hInt2
    (by
      filter_upwards [MeasureTheory.ae_restrict_mem measurableSet_Ioi] with t ht
      have ht0 : 0 < t := Set.mem_Ioi.mp ht
      positivity)
  have hGamma := integral_rpow_mul_exp_neg_mul_rpow
    (p := (1 : ℝ)) (q := p - 1) (b := K⁻¹) (by norm_num) (by linarith)
      (inv_pos.mpr hTail.2.1)
  have hIntEval :
      (∫ t in Set.Ioi 0,
        t ^ (p - 1) * Real.exp (-(K⁻¹) * t)) =
        (K⁻¹) ^ (-p) * Real.Gamma p := by
    have hfun :
        (fun t : ℝ => t ^ (p - 1) * Real.exp (-(K⁻¹) * t)) =
          (fun t : ℝ => t ^ (p - 1) * Real.exp (-(K⁻¹) * t ^ (1 : ℝ))) := by
      funext t
      rw [Real.rpow_one]
    rw [hfun]
    have hGamma' := hGamma
    rw [show p - 1 + 1 = p by ring] at hGamma'
    simp only [div_one, mul_one] at hGamma'
    convert hGamma' using 1
  have hGammaBound : Real.Gamma p ≤ 4 * p ^ p :=
    NumStability.HDP.Scalar.SubGaussian.gammaUpperBound (by linarith)
  have hupperEval :
      (∫⁻ t in Set.Ioi 0,
        ENNReal.ofReal (2 * Real.exp (-t / K)) *
          ENNReal.ofReal (t ^ (p - 1))) ≤
        ENNReal.ofReal (2 * (K⁻¹) ^ (-p) * Real.Gamma p) := by
    rw [MeasureTheory.setLIntegral_congr_fun measurableSet_Ioi
      (fun t _ => hscale t)]
    rw [← hEq2, MeasureTheory.integral_const_mul, hIntEval]
    simp [mul_assoc]
  have hcalc :
      ENNReal.ofReal p * ENNReal.ofReal
          (2 * (K⁻¹) ^ (-p) * Real.Gamma p) ≤
        ENNReal.ofReal ((8 * Real.exp 1 * K * p) ^ p) := by
    rw [← ENNReal.ofReal_mul (by positivity : 0 ≤ p)]
    apply ENNReal.ofReal_le_ofReal
    have hKpow : (K⁻¹) ^ (-p) = K ^ p := by
      rw [Real.rpow_neg (inv_nonneg.mpr hTail.2.1.le)]
      rw [Real.inv_rpow hTail.2.1.le]
      simp
    rw [hKpow]
    have hgam : 0 ≤ Real.Gamma p := (Real.Gamma_pos_of_pos hp0).le
    have hKpow_nonneg : 0 ≤ K ^ p := Real.rpow_nonneg hTail.2.1.le _
    have hstep : 2 * p * (K ^ p * Real.Gamma p) ≤
        (8 * Real.exp 1 * K * p) ^ p := by
      calc
        2 * p * (K ^ p * Real.Gamma p) ≤
            8 * p * K ^ p * p ^ p := by
              have hcoef : 0 ≤ 2 * p * K ^ p :=
                mul_nonneg (mul_nonneg (by positivity) (by positivity)) hKpow_nonneg
              calc
                2 * p * (K ^ p * Real.Gamma p) =
                    (2 * p * K ^ p) * Real.Gamma p := by ring
                _ ≤ (2 * p * K ^ p) * (4 * p ^ p) :=
                  mul_le_mul_of_nonneg_left hGammaBound hcoef
                _ = 8 * p * K ^ p * p ^ p := by ring
        _ ≤ 8 * Real.exp p * K ^ p * p ^ p := by
              have hpExp : p ≤ Real.exp p := by
                nlinarith [Real.add_one_le_exp p]
              have hcoef : 0 ≤ 8 * K ^ p * p ^ p := by
                positivity
              calc
                8 * p * K ^ p * p ^ p =
                    (8 * K ^ p * p ^ p) * p := by ring
                _ ≤ (8 * K ^ p * p ^ p) * Real.exp p :=
                  mul_le_mul_of_nonneg_left hpExp hcoef
                _ = 8 * Real.exp p * K ^ p * p ^ p := by ring
        _ ≤ (8 * Real.exp 1 * K * p) ^ p := by
              have h8 : (8 : ℝ) ≤ 8 ^ p := by
                have h := Real.rpow_le_rpow_of_exponent_le
                  (x := (8 : ℝ)) (y := (1 : ℝ)) (z := p) (by norm_num) hp
                simpa using h
              have hexprpow : Real.exp p = (Real.exp 1) ^ p := by
                rw [Real.rpow_def_of_pos (Real.exp_pos 1), Real.log_exp]
                congr 1
                ring
              rw [hexprpow]
              calc
                8 * (Real.exp 1) ^ p * K ^ p * p ^ p ≤
                    8 ^ p * (Real.exp 1) ^ p * K ^ p * p ^ p := by
                      have hpos : 0 ≤ (Real.exp 1) ^ p * K ^ p * p ^ p := by
                        exact mul_nonneg (mul_nonneg (by positivity) hKpow_nonneg)
                          (by positivity)
                      convert mul_le_mul_of_nonneg_right h8 hpos using 1 <;> ring
                _ = (8 * Real.exp 1 * K * p) ^ p := by
                      symm
                      rw [Real.mul_rpow
                        (mul_nonneg (mul_nonneg (by positivity) (Real.exp_pos 1).le)
                          hTail.2.1.le) hp0.le]
                      rw [Real.mul_rpow (mul_nonneg (by positivity) (Real.exp_pos 1).le)
                        hTail.2.1.le]
                      rw [Real.mul_rpow (by norm_num) (Real.exp_pos 1).le]
    simpa [mul_assoc, mul_left_comm, mul_comm] using hstep
  have hmoment : NumStability.HDP.Scalar.Preliminaries.absoluteMoment μ X p ≤
      ENNReal.ofReal ((8 * Real.exp 1 * K * p) ^ p) := by
    calc
      NumStability.HDP.Scalar.Preliminaries.absoluteMoment μ X p =
          ENNReal.ofReal p *
            (∫⁻ t in Set.Ioi 0,
              μ {ω | t < |X ω|} * ENNReal.ofReal (t ^ (p - 1))) := hformula.1
      _ ≤ ENNReal.ofReal p *
          (∫⁻ t in Set.Ioi 0,
            ENNReal.ofReal (2 * Real.exp (-t / K)) *
              ENNReal.ofReal (t ^ (p - 1))) := mul_le_mul_right hupper _
      _ ≤ ENNReal.ofReal p * ENNReal.ofReal
          (2 * (K⁻¹) ^ (-p) * Real.Gamma p) :=
            mul_le_mul_right hupperEval _
      _ ≤ ENNReal.ofReal ((8 * Real.exp 1 * K * p) ^ p) := hcalc
  have hfinite :
      NumStability.HDP.Scalar.Preliminaries.absoluteMoment μ X p < (⊤ : ENNReal) :=
    lt_of_le_of_lt hmoment (by simp)
  have hmeasX : AEMeasurable X μ := hTail.1.aemeasurable
  have hmeas : AEMeasurable (fun ω => |X ω| ^ p) μ := by
    fun_prop
  have hInt : Integrable (fun ω => |X ω| ^ p) μ := by
    refine ⟨hmeas.aestronglyMeasurable, ?_⟩
    rw [hasFiniteIntegral_iff_norm]
    change (∫⁻ ω, ENNReal.ofReal ‖|X ω| ^ p‖ ∂μ) < (⊤ : ENNReal)
    convert hfinite using 1
    apply MeasureTheory.lintegral_congr_ae
    filter_upwards [] with ω
    rw [Real.norm_eq_abs, abs_of_nonneg (Real.rpow_nonneg (abs_nonneg _) _)]
    change ENNReal.ofReal (|X ω|.rpow p) = ENNReal.ofReal (|X ω|.rpow p)
    rfl
  refine ⟨hInt, ?_⟩
  have hEq := MeasureTheory.ofReal_integral_eq_lintegral_ofReal hInt
    (Filter.Eventually.of_forall (fun ω => by positivity))
  have hbound : ENNReal.ofReal (∫ ω, |X ω| ^ p ∂μ) ≤
      ENNReal.ofReal ((8 * Real.exp 1 * K * p) ^ p) := by
    calc
      ENNReal.ofReal (∫ ω, |X ω| ^ p ∂μ) =
          NumStability.HDP.Scalar.Preliminaries.absoluteMoment μ X p := by
            simpa [NumStability.HDP.Scalar.Preliminaries.absoluteMoment,
              Real.norm_eq_abs] using hEq
      _ ≤ _ := hmoment
  have hBase : 0 ≤ 8 * Real.exp 1 * K * p := by
    exact mul_nonneg (mul_nonneg (mul_nonneg (by positivity) (Real.exp_pos 1).le)
      hTail.2.1.le) hp0.le
  have hRhs : 0 ≤ (8 * Real.exp 1 * K * p) ^ p :=
    Real.rpow_nonneg hBase _
  exact (ENNReal.ofReal_le_ofReal_iff hRhs).mp hbound

private theorem subExponentialMomentToAbsoluteMGF
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hMom : SubExponentialMomentBound μ X K) :
    SubExponentialAbsoluteMGFLocal μ X (4 * Real.exp 1 * K) := by
  refine ⟨hMom.1, mul_pos (mul_pos (by norm_num) (Real.exp_pos 1)) hMom.2.1, ?_⟩
  intro lam hlam hLamK
  have hsmall : |lam| * K ≤ (4 * Real.exp 1)⁻¹ := by
    rw [abs_of_nonneg hlam]
    calc
      lam * K ≤ (4 * Real.exp 1 * K)⁻¹ * K := by
        exact mul_le_mul_of_nonneg_right hLamK hMom.2.1.le
      _ = (4 * Real.exp 1)⁻¹ := by field_simp [ne_of_gt hMom.2.1]
  have h := exp_abs_integrable hMom.2.2 hMom.2.1 hsmall
  refine ⟨?_, ?_⟩
  · simpa [abs_of_nonneg hlam] using h.1
  · calc
      (∫ ω, Real.exp (lam * |X ω|) ∂μ) =
          ∫ ω, Real.exp (|lam| * |X ω|) ∂μ := by
            congr 1
            funext ω
            rw [abs_of_nonneg hlam]
      _ ≤ Real.exp (2 * Real.exp 1 * (|lam| * K)) := h.2
      _ ≤ Real.exp (4 * Real.exp 1 * K * lam) := by
        apply Real.exp_le_exp.mpr
        rw [abs_of_nonneg hlam]
        nlinarith [mul_nonneg (Real.exp_pos 1).le
          (mul_nonneg hlam hMom.2.1.le)]

private theorem subExponentialAbsoluteMGFToOnePoint
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hLocal : SubExponentialAbsoluteMGFLocal μ X K) :
    SubExponentialOnePointMGF μ X (2 * K) := by
  have hK : 0 < 2 * K := mul_pos (by norm_num) hLocal.2.1
  have hparam0 : 0 ≤ (2 * K)⁻¹ := (inv_nonneg.mpr hK.le)
  have hparam : (2 * K)⁻¹ ≤ K⁻¹ := by
    have h := one_div_le_one_div_of_le hLocal.2.1 (by nlinarith : K ≤ 2 * K)
    simpa [one_div] using h
  have h := hLocal.2.2 ((2 * K)⁻¹) hparam0 hparam
  refine ⟨hLocal.1, hK, ?_, ?_⟩
  · convert h.1 using 1
    funext ω
    congr 1
    field_simp
  · have hhalf : K * (2 * K)⁻¹ = (1 / 2 : ℝ) := by
      field_simp [ne_of_gt hLocal.2.1]
    calc
      (∫ ω, Real.exp (|X ω| / (2 * K)) ∂μ) =
          ∫ ω, Real.exp ((2 * K)⁻¹ * |X ω|) ∂μ := by
            congr 1
            funext ω
            congr 1
            field_simp
      _ ≤ Real.exp (K * (2 * K)⁻¹) := h.2
      _ = Real.exp (1 / 2) := by rw [hhalf]
      _ ≤ 2 := by
        exact le_trans (Real.exp_bound_div_one_sub_of_interval (by norm_num) (by norm_num))
          (by norm_num)

private theorem subExponentialOnePointToTail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hPoint : SubExponentialOnePointMGF μ X K) :
    SubExponentialTailBound μ X K := by
  refine ⟨hPoint.1, hPoint.2.1, ?_⟩
  intro t ht
  let Y : Ω → ℝ := fun ω => Real.exp (|X ω| / K)
  have hY : Measurable Y := by
    simpa [Y] using (hPoint.1.norm.div_const K).exp
  have hmarkov := NumStability.HDP.Scalar.Preliminaries.markovInequalityFinite
    (μ := μ) hY (Filter.Eventually.of_forall (fun ω => by
      exact le_of_lt (Real.exp_pos _))) hPoint.2.2.1 (Real.exp_pos (t / K))
  have hsubset : {ω | |X ω| ≥ t} ⊆
      Y ⁻¹' Set.Ici (Real.exp (t / K)) := by
    intro ω hω
    change Real.exp (t / K) ≤ Real.exp (|X ω| / K)
    apply Real.exp_le_exp.mpr
    exact div_le_div_of_nonneg_right hω hPoint.2.1.le
  have hmono {A B : Set Ω} (hAB : A ⊆ B) : μ.real A ≤ μ.real B := by
    rw [Measure.real_def, Measure.real_def]
    exact ENNReal.toReal_mono (measure_ne_top μ B) (measure_mono hAB)
  calc
    μ.real {ω | |X ω| ≥ t} ≤ μ.real (Y ⁻¹' Set.Ici (Real.exp (t / K))) :=
      hmono hsubset
    _ ≤ (∫ ω, Y ω ∂μ) / Real.exp (t / K) := by
      simpa [NumStability.HDP.Scalar.Preliminaries.expectation] using hmarkov
    _ ≤ 2 / Real.exp (t / K) := by
      exact div_le_div_of_nonneg_right hPoint.2.2.2
        (le_of_lt (Real.exp_pos _))
    _ = 2 * Real.exp (-t / K) := by
      rw [div_eq_mul_inv, ← Real.exp_neg]
      ring

private theorem subExponentialToTail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (i : SubExponentialPropertyKind) {K : ℝ} (hK : 0 < K)
    (hProp : SubExponentialProperty μ X i K) :
    ∃ T : ℝ, 0 < T ∧ T ≤ 8 * Real.exp 1 * K ∧
      SubExponentialTailBound μ X T := by
  cases i with
  | tail =>
      refine ⟨K, hK, ?_, hProp⟩
      have hscale : (1 : ℝ) ≤ 8 * Real.exp 1 := by
        have he : (1 : ℝ) ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
        nlinarith
      simpa using (mul_le_mul_of_nonneg_right hscale hK.le)
  | moment =>
      have hLocal := subExponentialMomentToAbsoluteMGF hProp
      have hPoint := subExponentialAbsoluteMGFToOnePoint hLocal
      have hTail := subExponentialOnePointToTail hPoint
      refine ⟨8 * Real.exp 1 * K, by positivity, le_rfl, ?_⟩
      convert hTail using 1; ring
  | absoluteMGF =>
      have hPoint := subExponentialAbsoluteMGFToOnePoint hProp
      have hTail := subExponentialOnePointToTail hPoint
      refine ⟨2 * K, by positivity, ?_, ?_⟩
      · have he : (1 : ℝ) ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
        have hscale : (2 : ℝ) ≤ 8 * Real.exp 1 := by nlinarith
        exact mul_le_mul_of_nonneg_right hscale hK.le
      · convert hTail using 1
  | onePoint =>
      have hTail := subExponentialOnePointToTail hProp
      refine ⟨K, hK, ?_, hTail⟩
      have hscale : (1 : ℝ) ≤ 8 * Real.exp 1 := by
        have he : (1 : ℝ) ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
        nlinarith
      simpa using (mul_le_mul_of_nonneg_right hscale hK.le)

private theorem subExponentialFromTail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (i : SubExponentialPropertyKind) {T : ℝ} (hT : 0 < T)
    (hTail : SubExponentialTailBound μ X T) :
    ∃ K : ℝ, 0 < K ∧ K ≤ 64 * (Real.exp 1) ^ 2 * T ∧
      SubExponentialProperty μ X i K := by
  cases i with
  | tail =>
      refine ⟨T, hT, ?_, hTail⟩
      have he : (1 : ℝ) ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
      have he2 : (1 : ℝ) ≤ (Real.exp 1) ^ 2 := by
        nlinarith [mul_nonneg (sub_nonneg.mpr he) (Real.exp_pos 1).le]
      have hscale : (1 : ℝ) ≤ 64 * (Real.exp 1) ^ 2 := by nlinarith
      simpa using (mul_le_mul_of_nonneg_right hscale hT.le)
  | moment =>
      let K := 8 * Real.exp 1 * T
      have hMom := subExponentialTailToMoment hTail
      refine ⟨K, by dsimp [K]; positivity, ?_, ?_⟩
      · have he : (1 : ℝ) ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
        dsimp [K]
        have he2 : (1 : ℝ) ≤ (Real.exp 1) ^ 2 := by
          nlinarith [mul_nonneg (sub_nonneg.mpr he) (Real.exp_pos 1).le]
        have hscale : 8 * Real.exp 1 ≤ 64 * (Real.exp 1) ^ 2 := by
          nlinarith
        exact mul_le_mul_of_nonneg_right hscale hT.le
      · simpa [SubExponentialProperty, K] using hMom
  | absoluteMGF =>
      let K := 32 * (Real.exp 1) ^ 2 * T
      have hMom := subExponentialTailToMoment hTail
      have hLocal := subExponentialMomentToAbsoluteMGF hMom
      refine ⟨K, by dsimp [K]; positivity, ?_, ?_⟩
      · dsimp [K]
        have he : (1 : ℝ) ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
        exact mul_le_mul_of_nonneg_right (by nlinarith [he]) hT.le
      · change SubExponentialAbsoluteMGFLocal μ X K
        convert hLocal using 1
        all_goals dsimp [K]
        all_goals ring
  | onePoint =>
      let K := 64 * (Real.exp 1) ^ 2 * T
      have hMom := subExponentialTailToMoment hTail
      have hLocal := subExponentialMomentToAbsoluteMGF hMom
      have hPoint := subExponentialAbsoluteMGFToOnePoint hLocal
      refine ⟨K, by dsimp [K]; positivity, le_rfl, ?_⟩
      change SubExponentialOnePointMGF μ X K
      convert hPoint using 1
      all_goals dsimp [K]
      all_goals ring

/-! Reusable four-way characterization for Exercise 2.7.2. -/
theorem subExponentialCharacterization
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ i j : SubExponentialPropertyKind, ∀ {Ki : ℝ}, 0 < Ki →
        SubExponentialProperty μ X i Ki →
          ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
            SubExponentialProperty μ X j Kj := by
  let C : ℝ := 4096 * (Real.exp 1) ^ 3
  have he : (1 : ℝ) ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
  have he3 : (1 : ℝ) ≤ (Real.exp 1) ^ 3 := by
    have he2 : (1 : ℝ) ≤ (Real.exp 1) ^ 2 := by
      nlinarith [mul_nonneg (sub_nonneg.mpr he) (Real.exp_pos 1).le]
    have hsq : 0 ≤ (Real.exp 1) ^ 2 := by positivity
    nlinarith [mul_le_mul_of_nonneg_left he hsq]
  refine ⟨C, by dsimp [C]; nlinarith [he3], ?_⟩
  intro i j Ki hKi hProp
  rcases subExponentialToTail i hKi hProp with ⟨T, hT, hTbound, hTail⟩
  rcases subExponentialFromTail j hT hTail with ⟨Kj, hKj, hKjbound, hResult⟩
  refine ⟨Kj, hKj, ?_, hResult⟩
  dsimp [C]
  have hmul := mul_le_mul_of_nonneg_left hTbound
    (by positivity : 0 ≤ 64 * (Real.exp 1) ^ 2)
  calc
    Kj ≤ 64 * (Real.exp 1) ^ 2 * T := hKjbound
    _ ≤ 64 * (Real.exp 1) ^ 2 * (8 * Real.exp 1 * Ki) := hmul
    _ ≤ 4096 * (Real.exp 1) ^ 3 * Ki := by
      have he3nonneg : 0 ≤ (Real.exp 1) ^ 3 := by positivity
      have hcoeff : 512 * (Real.exp 1) ^ 3 ≤ 4096 * (Real.exp 1) ^ 3 := by
        nlinarith
      have hKi0 : 0 ≤ Ki := hKi.le
      calc
        64 * (Real.exp 1) ^ 2 * (8 * Real.exp 1 * Ki) =
            512 * (Real.exp 1) ^ 3 * Ki := by ring
        _ ≤ 4096 * (Real.exp 1) ^ 3 * Ki :=
          mul_le_mul_of_nonneg_right hcoeff hKi0

/-! Exercise 2.7.3: the fixed-`α` power-coordinate interface.

For `α > 0`, the natural common interface is obtained by applying the
sub-exponential characterization to `|X|^α`.  In the tail coordinate this is
the printed bound `2 exp (-(t/K)^α)` after the change of variable
`t ↦ t^α`; in the moment coordinate it records the growth of the moments of
`|X|^α`, hence the usual `p^(1/α)` growth after reparameterizing the moment
order.  This representation deliberately does not assert a linear MGF norm
when `α ≤ 1`.
-/

/-- The presentation index reused for fixed-power sub-Weibull properties. -/
abbrev SubWeibullPropertyKind := SubExponentialPropertyKind

/-- A sub-exponential property of the transformed variable `|X| ^ α`. -/
def SubWeibullProperty {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (α : ℝ) :
    SubWeibullPropertyKind → ℝ → Prop
  | i, K => 0 < α ∧
      SubExponentialProperty μ (fun ω => |X ω| ^ α) i K

theorem subWeibullMomentInterpretation
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {α K : ℝ}
    (hα : 0 < α) (h : SubWeibullProperty μ X α .moment K) :
    ∀ p : ℝ, 1 ≤ p →
      Integrable (fun ω => |X ω| ^ (α * p)) μ ∧
        (∫ ω, |X ω| ^ (α * p) ∂μ) ≤ (K * p) ^ p := by
  rcases h with ⟨_, hMoment⟩
  rcases hMoment with ⟨hMeas, hK, hGrowth⟩
  intro p hp
  rcases hGrowth.2 p hp with ⟨hInt, hBound⟩
  constructor
  · convert hInt using 1
    funext ω
    dsimp
    rw [abs_of_nonneg (Real.rpow_nonneg (abs_nonneg (X ω)) α)]
    rw [← Real.rpow_mul (abs_nonneg (X ω))]
  · convert hBound using 1
    apply integral_congr_ae
    filter_upwards [] with ω
    rw [abs_of_nonneg (Real.rpow_nonneg (abs_nonneg (X ω)) α)]
    rw [← Real.rpow_mul (abs_nonneg (X ω))]

theorem subWeibullCharacterization
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {α : ℝ} (hα : 0 < α) :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ i j : SubWeibullPropertyKind, ∀ {Ki : ℝ}, 0 < Ki →
        SubWeibullProperty μ X α i Ki →
          ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
            SubWeibullProperty μ X α j Kj := by
  let Y : Ω → ℝ := fun ω => |X ω| ^ α
  obtain ⟨C, hC, hCharacterization⟩ :=
    (subExponentialCharacterization (μ := μ) (X := Y))
  refine ⟨C, hC, ?_⟩
  intro i j Ki hKi hProp
  rcases hProp with ⟨_hα', hSub⟩
  rcases hCharacterization i j hKi hSub with ⟨Kj, hKj, hKjbound, hResult⟩
  exact ⟨Kj, hKj, hKjbound, ⟨hα, by simpa [Y] using hResult⟩⟩

/-! Remark 2.7.9: a bounded centered unit-variance witness and the domain of the
rate-one exponential MGF.  The symmetric two-point law makes the local Taylor
calculation exact, while the exponential-law calculation is kept in extended
measure form through its density. -/

/-- The symmetric two-point law used in Remark 2.7.9. -/
def remark279Law : Measure ℝ :=
  (1 / 2 : ENNReal) • Measure.dirac (-1) +
    (1 / 2 : ENNReal) • Measure.dirac 1

lemma remark279Law_probability : IsProbabilityMeasure remark279Law := by
  apply isProbabilityMeasure_iff.mpr
  simp [remark279Law]
  calc
    (2 : ENNReal)⁻¹ + 2⁻¹ = (2 : ENNReal)⁻¹ + (2 : ENNReal)⁻¹ * 1 := by
      ring
    _ = (2 : ENNReal)⁻¹ * (1 + 1) := by ring
    _ = (2 : ENNReal)⁻¹ * 2 := by norm_num
    _ = 1 := by exact ENNReal.inv_mul_cancel (by norm_num) (by norm_num)

lemma remark279Law_integral (f : ℝ → ℝ) :
    ∫ x, f x ∂remark279Law =
      (1 / 2 : ℝ) * f (-1) + (1 / 2 : ℝ) * f 1 := by
  rw [remark279Law, MeasureTheory.integral_add_measure]
  · rw [MeasureTheory.integral_smul_measure, MeasureTheory.integral_smul_measure,
      MeasureTheory.integral_dirac, MeasureTheory.integral_dirac]
    norm_num
  · apply Integrable.smul_measure
    · exact integrable_dirac (by simp)
    · simp
  · apply Integrable.smul_measure
    · exact integrable_dirac (by simp)
    · simp

lemma remark279_mean :
    (∫ x, x ∂remark279Law) = 0 := by
  rw [remark279Law_integral]
  norm_num

lemma remark279_second_moment :
    (∫ x, x ^ 2 ∂remark279Law) = 1 := by
  rw [remark279Law_integral]
  norm_num

set_option maxRecDepth 10000 in
lemma cosh_local_taylor :
    (fun x : ℝ => Real.cosh x - 1 - x ^ 2 / 2) =o[𝓝 (0 : ℝ)]
      (fun x : ℝ => x ^ 2) := by
  have hc0 : iteratedDeriv 0 Real.cosh 0 = 1 := by
    simp [iteratedDeriv]
  have hc1 : iteratedDeriv 1 Real.cosh 0 = 0 := by
    rw [iteratedDeriv_one, Real.deriv_cosh]
    simp
  have hc2 : iteratedDeriv 2 Real.cosh 0 = 1 := by
    rw [show (2 : ℕ) = 1 + 1 by norm_num, iteratedDeriv_succ,
      iteratedDeriv_one, Real.deriv_cosh, Real.deriv_sinh]
    simp
  have h := Real.taylor_tendsto (f := Real.cosh) (n := 2) (s := Set.univ)
    convex_univ (mem_univ (0 : ℝ)) Real.contDiff_cosh.contDiffOn
  rw [Asymptotics.isLittleO_iff_tendsto]
  · convert h using 1
    · funext x
      simp [taylorWithinEval, taylorWithin, taylorCoeffWithin,
        Finset.sum_range_succ, hc0, hc1, hc2,
        div_eq_mul_inv, mul_comm]
      all_goals ring_nf
      all_goals simp
    · rw [nhdsWithin_univ]
  · simp

lemma remark279_local_taylor :
    (fun lam : ℝ =>
      (∫ x, Real.exp (lam * x) ∂remark279Law) - 1 -
        lam * (∫ x, x ∂remark279Law) -
        lam ^ 2 / 2 * (∫ x, x ^ 2 ∂remark279Law)) =o[𝓝 (0 : ℝ)]
      (fun lam : ℝ => lam ^ 2) := by
  have hcosh := cosh_local_taylor
  convert hcosh using 1
  funext lam
  rw [remark279Law_integral, remark279_mean, remark279_second_moment]
  rw [Real.cosh_eq]
  ring

private lemma remark279_exp_pdf_measurable :
    Measurable (ProbabilityTheory.exponentialPDF 1) := by
  unfold ProbabilityTheory.exponentialPDF
  exact (ProbabilityTheory.measurable_exponentialPDFReal 1).ennreal_ofReal

lemma remark279_exp_mgf_lt_one {lam : ℝ} (hl : lam < 1) :
    Integrable (fun x : ℝ => Real.exp (lam * x)) (expMeasure 1) ∧
      (∫ x, Real.exp (lam * x) ∂(expMeasure 1)) = (1 - lam)⁻¹ := by
  have hpdf := remark279_exp_pdf_measurable
  have hIntBase : Integrable
      (fun x : ℝ => Real.exp (lam * x) *
        (ProbabilityTheory.exponentialPDF 1 x).toReal) volume := by
    have heq : (fun x : ℝ => Real.exp (lam * x) *
        (ProbabilityTheory.exponentialPDF 1 x).toReal) =
        (fun x : ℝ => if 0 ≤ x then Real.exp ((lam - 1) * x) else 0) := by
      funext x
      by_cases hx : 0 ≤ x
      · simp [ProbabilityTheory.exponentialPDF,
          ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal,
          hx]
        rw [ENNReal.toReal_ofReal (le_of_lt (Real.exp_pos (-x)))]
        rw [← Real.exp_add]
        congr 1
        ring
      · simp [ProbabilityTheory.exponentialPDF,
          ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal,
          hx]
    rw [heq]
    let g : ℝ → ℝ := fun x => Real.exp ((lam - 1) * x)
    have hIoi : IntegrableOn g (Ioi (0 : ℝ)) volume :=
      integrableOn_exp_mul_Ioi (by linarith) 0
    have hIci : IntegrableOn g (Ici (0 : ℝ)) volume :=
      (integrableOn_Ici_iff_integrableOn_Ioi).2 hIoi
    have hInd : Integrable ((Ici (0 : ℝ)).indicator g) volume :=
      hIci.integrable_indicator measurableSet_Ici
    simpa [g, Set.indicator, mem_setOf_eq] using hInd
  have hInt : Integrable (fun x : ℝ => Real.exp (lam * x)) (expMeasure 1) := by
    change Integrable (fun x : ℝ => Real.exp (lam * x))
      (volume.withDensity (ProbabilityTheory.exponentialPDF 1))
    rw [integrable_withDensity_iff hpdf
      (by filter_upwards [] with x; exact ENNReal.coe_lt_top)]
    simpa [smul_eq_mul] using hIntBase
  refine ⟨hInt, ?_⟩
  change (∫ x, Real.exp (lam * x) ∂volume.withDensity
      (ProbabilityTheory.exponentialPDF 1)) = (1 - lam)⁻¹
  rw [integral_withDensity_eq_integral_toReal_smul hpdf
      (by filter_upwards [] with x; exact ENNReal.coe_lt_top)]
  simp_rw [smul_eq_mul]
  have heq2 : (fun x : ℝ => (ProbabilityTheory.exponentialPDF 1 x).toReal *
      Real.exp (lam * x)) =
      (Ici (0 : ℝ)).indicator (fun x : ℝ => Real.exp ((lam - 1) * x)) := by
    funext x
    by_cases hx : 0 ≤ x
    · simp [ProbabilityTheory.exponentialPDF,
        ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal,
        hx]
      rw [ENNReal.toReal_ofReal (le_of_lt (Real.exp_pos (-x)))]
      rw [← Real.exp_add]
      congr 1
      ring
    · simp [ProbabilityTheory.exponentialPDF,
        ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal,
        hx]
  rw [heq2, integral_indicator measurableSet_Ici, integral_Ici_eq_integral_Ioi]
  rw [integral_exp_mul_Ioi (by linarith) 0]
  simp
  rw [show lam - 1 = -(1 - lam) by ring]
  have hne : 1 - lam ≠ 0 := by linarith
  field_simp [hne]

lemma remark279_exp_mgf_not_integrable {lam : ℝ} (hl : 1 ≤ lam) :
    ¬ Integrable (fun x : ℝ => Real.exp (lam * x)) (expMeasure 1) := by
  intro h
  have hpdf := remark279_exp_pdf_measurable
  have hbase : Integrable
      (fun x : ℝ => Real.exp (lam * x) *
        (ProbabilityTheory.exponentialPDF 1 x).toReal) volume := by
    change Integrable (fun x : ℝ => Real.exp (lam * x))
      (volume.withDensity (ProbabilityTheory.exponentialPDF 1)) at h
    exact (integrable_withDensity_iff hpdf
      (by filter_upwards [] with x; exact ENNReal.coe_lt_top)).1 h
  have hprod : IntegrableOn
      (fun x : ℝ => Real.exp (lam * x) *
        (ProbabilityTheory.exponentialPDF 1 x).toReal) (Ioi (0 : ℝ)) volume :=
    hbase.integrableOn
  have hexp : IntegrableOn (fun x : ℝ => Real.exp ((lam - 1) * x))
      (Ioi (0 : ℝ)) volume := by
    apply hprod.congr_fun
    · intro x hx
      have hx0 : 0 ≤ x := le_of_lt hx
      simp [ProbabilityTheory.exponentialPDF,
        ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal,
        hx0]
      rw [ENNReal.toReal_ofReal (le_of_lt (Real.exp_pos (-x)))]
      rw [← Real.exp_add]
      congr 1
      ring
    · exact measurableSet_Ioi
  have hconst : IntegrableOn (fun _ : ℝ => (1 : ℝ)) (Ioi (0 : ℝ)) volume := by
    apply hexp.integrable.mono'
    · fun_prop
    · filter_upwards [self_mem_ae_restrict measurableSet_Ioi] with x hx
      rw [Real.norm_eq_abs, abs_one]
      exact Real.one_le_exp (mul_nonneg (sub_nonneg.mpr hl) (le_of_lt hx))
  simp at hconst

theorem remark279_contract :
    NumStability.HDP.Contract.hdp_02_hrem_h2_d7_d9__contract_type := by
  refine ⟨remark279Law, (fun x : ℝ => x), remark279Law_probability, ?_⟩
  constructor
  · rfl
  constructor
  · rfl
  constructor
  · simpa using remark279_mean
  constructor
  · simpa using remark279_second_moment
  constructor
  · simpa using remark279_local_taylor
  constructor
  · intro lam
    exact remark279_exp_mgf_lt_one
  · intro lam
    exact remark279_exp_mgf_not_integrable

/-! ## Example 2.7.12: power Orlicz gauges are classical `Lᵖ` gauges -/

lemma powerOrliczIntegral_eq
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ)
    (p : NNReal) (hp : 0 < p)
    (hψ : ∀ x : ℝ, 0 ≤ x → ψ x = x ^ (p : ℝ))
    {t : ℝ≥0∞} (ht0 : t ≠ 0) (htTop : t ≠ ∞) :
    orliczIntegral ψ μ X t =
      (eLpNorm X (p : ℝ≥0∞) μ / t) ^ (p : ℝ) := by
  have hpR : 0 < (p : ℝ) := by exact_mod_cast hp
  have hpR0 : 0 ≤ (p : ℝ) := hpR.le
  have htR : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
  have hpE0 : (p : ℝ≥0∞) ≠ 0 := by exact_mod_cast hp.ne'
  have hpETop : (p : ℝ≥0∞) ≠ ∞ := by simp
  have hpoint : (fun ω => ENNReal.ofReal (ψ (|X ω| / t.toReal))) =
      (fun ω => ‖X ω‖ₑ ^ (p : ℝ) / t ^ (p : ℝ)) := by
    funext ω
    rw [hψ _ (div_nonneg (abs_nonneg _) htR.le)]
    rw [← ENNReal.ofReal_rpow_of_nonneg (div_nonneg (abs_nonneg _) htR.le) hpR0]
    rw [ENNReal.ofReal_div_of_pos htR]
    rw [← ofReal_norm_eq_enorm]
    simp only [Real.norm_eq_abs]
    rw [ENNReal.div_rpow_of_nonneg _ _ hpR0]
    rw [ENNReal.ofReal_toReal htTop]
  unfold orliczIntegral
  rw [hpoint]
  simp_rw [div_eq_mul_inv]
  let c : ℝ≥0∞ := (t ^ (p : ℝ))⁻¹
  have htp0 : t ^ (p : ℝ) ≠ 0 := by simp [ht0, hpR]
  have htpTop : t ^ (p : ℝ) ≠ ∞ :=
    ENNReal.rpow_ne_top_of_nonneg hpR0 htTop
  have hc0 : c ≠ 0 := by simp [c, htpTop]
  have hcTop : c ≠ ∞ := by simp [c, htp0]
  have hscale : (∫⁻ a, ‖X a‖ₑ ^ (p : ℝ) * c ∂μ) =
      (∫⁻ a, ‖X a‖ₑ ^ (p : ℝ) ∂μ) * c := by
    apply le_antisymm
    · have h := lintegral_mul_const_le c⁻¹
        (fun a => ‖X a‖ₑ ^ (p : ℝ) * c) (μ := μ)
      have h' :
          (∫⁻ a, ‖X a‖ₑ ^ (p : ℝ) * c ∂μ) * c⁻¹ ≤
            ∫⁻ a, ‖X a‖ₑ ^ (p : ℝ) ∂μ := by
        simpa [mul_assoc, ENNReal.mul_inv_cancel hc0 hcTop] using h
      have h'' := (ENNReal.mul_le_mul_iff_left hc0 hcTop).2 h'
      simpa [mul_assoc, ENNReal.inv_mul_cancel hc0 hcTop] using h''
    · exact lintegral_mul_const_le c _
  rw [hscale]
  simp only [c]
  rw [mul_comm (eLpNorm X (p : ℝ≥0∞) μ) t⁻¹]
  rw [← ENNReal.div_eq_inv_mul]
  rw [ENNReal.div_rpow_of_nonneg _ _ hpR0]
  have hLp := eLpNorm_eq_lintegral_rpow_enorm_toReal hpE0 hpETop (f := X) (μ := μ)
  have hLp' : eLpNorm X (p : ℝ≥0∞) μ =
      (∫⁻ a, ‖X a‖ₑ ^ (p : ℝ) ∂μ) ^ (p : ℝ)⁻¹ := by
    simpa [one_div] using hLp
  have hLpPow := congrArg (fun z : ℝ≥0∞ => z ^ (p : ℝ)) hLp'
  have hMoment : (∫⁻ a, ‖X a‖ₑ ^ (p : ℝ) ∂μ) =
      eLpNorm X (p : ℝ≥0∞) μ ^ (p : ℝ) := by
    change eLpNorm X (p : ℝ≥0∞) μ ^ (p : ℝ) =
      ((∫⁻ a, ‖X a‖ₑ ^ (p : ℝ) ∂μ) ^ (p : ℝ)⁻¹) ^ (p : ℝ) at hLpPow
    rw [ENNReal.rpow_inv_rpow hpR.ne'
      (∫⁻ a, ‖X a‖ₑ ^ (p : ℝ) ∂μ)] at hLpPow
    exact hLpPow.symm
  rw [hMoment]
  rfl

theorem powerOrliczGauge_eq_eLpNorm
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ)
    (p : NNReal) (hp : 0 < p)
    (hψ : ∀ x : ℝ, 0 ≤ x → ψ x = x ^ (p : ℝ)) :
    orliczGauge ψ μ X = eLpNorm X (p : ℝ≥0∞) μ := by
  have hpR : 0 < (p : ℝ) := by exact_mod_cast hp
  let L : ℝ≥0∞ := eLpNorm X (p : ℝ≥0∞) μ
  have hlower : ∀ {t : ℝ≥0∞},
      orliczAdmissible ψ μ X t → L ≤ t := by
    intro t ht
    rcases ht with ⟨ht0, htTop, hInt⟩
    have hpow : (L / t) ^ (p : ℝ) ≤ 1 := by
      rw [← powerOrliczIntegral_eq ψ μ X p hp hψ ht0 htTop]
      exact hInt
    have hpow' : (L / t) ^ (p : ℝ) ≤ (1 : ℝ≥0∞) ^ (p : ℝ) := by
      simpa using hpow
    have hratio : L / t ≤ 1 := (ENNReal.rpow_le_rpow_iff hpR).mp hpow'
    have hLt : L ≤ 1 * t := (ENNReal.div_le_iff ht0 htTop).mp hratio
    simpa using hLt
  have hupper : eLpNorm X (p : ℝ≥0∞) μ ≤ orliczGauge ψ μ X := by
    apply le_sInf
    intro t ht
    exact hlower ht
  have hLupper : orliczGauge ψ μ X ≤ L := by
    unfold orliczGauge
    by_cases hLtop : L = ∞
    · simp [hLtop]
    by_cases hL0 : L = 0
    · rw [hL0]
      apply le_of_forall_gt_imp_ge_of_dense
      intro t ht
      by_cases htTop : t = ∞
      · simp [htTop]
      have ht0 : t ≠ 0 := ne_of_gt ht
      apply sInf_le
      refine ⟨ht0, htTop, ?_⟩
      rw [powerOrliczIntegral_eq ψ μ X p hp hψ ht0 htTop]
      have hLzero : eLpNorm X (p : ℝ≥0∞) μ = 0 := by simpa [L] using hL0
      simp [hLzero, hpR]
    · have hL0' : L ≠ 0 := hL0
      have hL0'' : eLpNorm X (p : ℝ≥0∞) μ ≠ 0 := by simpa [L] using hL0'
      have hLtop' : eLpNorm X (p : ℝ≥0∞) μ ≠ ∞ := by simpa [L] using hLtop
      have hLmem : orliczAdmissible ψ μ X L := by
        refine ⟨hL0', hLtop, ?_⟩
        rw [powerOrliczIntegral_eq ψ μ X p hp hψ hL0' hLtop]
        rw [ENNReal.div_self hL0'' hLtop']
        simp
      exact sInf_le hLmem
  exact le_antisymm hLupper hupper

theorem powerOrliczMember_iff_memLp
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ)
    (p : NNReal) (hp : 0 < p)
    (hψ : ∀ x : ℝ, 0 ≤ x → ψ x = x ^ (p : ℝ))
    (hX : AEStronglyMeasurable X μ) :
    orliczMember ψ μ X ↔ MemLp X (p : ℝ≥0∞) μ := by
  rw [orliczMember, powerOrliczGauge_eq_eLpNorm ψ μ X p hp hψ]
  simp [MemLp, hX]

theorem powerOrliczCoincidence :
    ∀ {Ω : Type*} [MeasurableSpace Ω]
      (ψ : OrliczFunction) (μ : Measure Ω) (p : NNReal),
      0 < p →
      (∀ x : ℝ, 0 ≤ x → ψ x = x ^ (p : ℝ)) →
      (∀ X : Ω → ℝ, orliczGauge ψ μ X = eLpNorm X (p : ℝ≥0∞) μ) ∧
      (∀ X : Ω → ℝ, AEStronglyMeasurable X μ →
        (orliczMember ψ μ X ↔ MemLp X (p : ℝ≥0∞) μ)) := by
  intro Ω _ ψ μ p hp hψ
  constructor
  · intro X
    exact powerOrliczGauge_eq_eLpNorm ψ μ X p hp hψ
  · intro X hX
    exact powerOrliczMember_iff_memLp ψ μ X p hp hψ hX

/-! Example 2.7.13: the Luxemburg gauge for `exp (x²) - 1` is the
source ψ₂ gauge.  The two admissibility predicates differ only by the
probability-measure contribution of the subtracted constant `1`. -/

/-- The Orlicz function `exp (x²) - 1` underlying the ψ₂ gauge. -/
noncomputable def psiTwoOrliczFunction : OrliczFunction :=
  { toFun := fun x => Real.exp (x ^ 2) - 1
    nonnegative := by
      intro x hx
      have hsq : 0 ≤ x ^ 2 := sq_nonneg x
      linarith [Real.one_le_exp hsq]
    convexOn_nonneg := by
      refine ⟨convex_Ici (0 : ℝ), ?_⟩
      intro x hx y hy a b ha hb hab
      change 0 ≤ x at hx
      change 0 ≤ y at hy
      change Real.exp ((a * x + b * y) ^ 2) - 1 ≤
        a * (Real.exp (x ^ 2) - 1) + b * (Real.exp (y ^ 2) - 1)
      have hsq : (a * x + b * y) ^ 2 ≤ a * x ^ 2 + b * y ^ 2 := by
        nlinarith [sq_nonneg (x - y),
          mul_nonneg (mul_nonneg ha hb) (sq_nonneg (x - y))]
      have hexp := convexOn_exp.2 (show x ^ 2 ∈ Set.univ by trivial)
        (show y ^ 2 ∈ Set.univ by trivial) ha hb hab
      calc
        Real.exp ((a * x + b * y) ^ 2) - 1 ≤
            Real.exp (a * x ^ 2 + b * y ^ 2) - 1 := by
          gcongr
        _ ≤ a * Real.exp (x ^ 2) + b * Real.exp (y ^ 2) - 1 := by
          simpa [smul_eq_mul] using sub_le_sub_right hexp 1
        _ = a * (Real.exp (x ^ 2) - 1) +
            b * (Real.exp (y ^ 2) - 1) := by
          calc
            a * Real.exp (x ^ 2) + b * Real.exp (y ^ 2) - 1 =
                a * Real.exp (x ^ 2) + b * Real.exp (y ^ 2) - (a + b) := by
                  rw [hab]
            _ = a * (Real.exp (x ^ 2) - 1) +
                b * (Real.exp (y ^ 2) - 1) := by ring
    monotoneOn_nonneg := by
      intro x hx y hy hxy
      change 0 ≤ x at hx
      change 0 ≤ y at hy
      dsimp
      apply sub_le_sub_right
      apply Real.exp_le_exp.mpr
      nlinarith [sq_nonneg (y - x)]
    map_zero := by norm_num
    tendsto_atTop := by
      refine tendsto_atTop.mpr ?_
      intro r
      filter_upwards
        [eventually_ge_atTop (max 0 (Real.sqrt (max (r + 1) 0)))] with x hx
      have hx0 : 0 ≤ x := le_trans (le_max_left 0
        (Real.sqrt (max (r + 1) 0))) hx
      have hxroot : Real.sqrt (max (r + 1) 0) ≤ x := le_trans
        (le_max_right 0 (Real.sqrt (max (r + 1) 0))) hx
      have hsqrt0 : 0 ≤ Real.sqrt (max (r + 1) 0) :=
        Real.sqrt_nonneg _
      have hsqrt : (Real.sqrt (max (r + 1) 0)) ^ 2 = max (r + 1) 0 :=
        Real.sq_sqrt (by positivity)
      have hmax : r + 1 ≤ max (r + 1) 0 := le_max_left _ _
      have hsq : r + 1 ≤ x ^ 2 := by
        have hprod : 0 ≤ (x - Real.sqrt (max (r + 1) 0)) *
            (x + Real.sqrt (max (r + 1) 0)) :=
          mul_nonneg (sub_nonneg.mpr hxroot) (add_nonneg hx0 hsqrt0)
        nlinarith [hprod, hsqrt, hmax]
      have hexp : Real.exp (r + 1) ≤ Real.exp (x ^ 2) :=
        Real.exp_le_exp.mpr hsq
      have hlin : r + 1 ≤ Real.exp (r + 1) := by
        nlinarith [Real.add_one_le_exp (r + 1)]
      nlinarith }

lemma psiTwoOrliczFunction_integral_add_one
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {t : ℝ≥0∞}
    (ht0 : t ≠ 0) (htTop : t ≠ ∞) (hX : Measurable X) :
    orliczIntegral psiTwoOrliczFunction μ X t + 1 =
      ∫⁻ ω, ENNReal.ofReal (Real.exp (X ω ^ 2 / t.toReal ^ 2)) ∂μ := by
  have htpos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
  let f : Ω → ℝ := fun ω => Real.exp (X ω ^ 2 / t.toReal ^ 2)
  let g : Ω → ℝ≥0∞ := fun ω => ENNReal.ofReal (f ω - 1)
  have hmeasg : Measurable g := by
    dsimp [g, f]
    fun_prop
  have hnonneg : ∀ ω, 0 ≤ f ω - 1 := by
    intro ω
    dsimp [f]
    have hsq : 0 ≤ X ω ^ 2 / t.toReal ^ 2 := by positivity
    linarith [Real.one_le_exp hsq]
  have hpoint : ∀ ω, ENNReal.ofReal (f ω) = g ω + 1 := by
    intro ω
    dsimp [g]
    calc
      ENNReal.ofReal (f ω) = ENNReal.ofReal ((f ω - 1) + 1) := by
        congr 1
        ring
      _ = ENNReal.ofReal (f ω - 1) + ENNReal.ofReal 1 :=
        ENNReal.ofReal_add (hnonneg ω) (by norm_num)
      _ = ENNReal.ofReal (f ω - 1) + 1 := by norm_num
  calc
    orliczIntegral psiTwoOrliczFunction μ X t + 1 =
        (∫⁻ ω, g ω ∂μ) + 1 := by
          congr 1
          simp only [orliczIntegral, psiTwoOrliczFunction, g, f]
          congr 1
          funext ω
          congr 2
          rw [div_pow, sq_abs]
    _ = ∫⁻ ω, (g ω + 1) ∂μ := by
          symm
          rw [lintegral_add_left hmeasg]
          simp
    _ = ∫⁻ ω, ENNReal.ofReal (f ω) ∂μ := by
          apply lintegral_congr
          intro ω
          exact (hpoint ω).symm

theorem psiTwoOrliczGauge_eq_psiTwoGauge
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) :
    orliczGauge psiTwoOrliczFunction μ X =
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X := by
  unfold orliczGauge NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
  apply congrArg sInf
  ext t
  constructor
  · intro ht
    rcases ht with ⟨ht0, htTop, hbound⟩
    have hbound' :
        ∫⁻ ω, ENNReal.ofReal (Real.exp (X ω ^ 2 / t.toReal ^ 2)) ∂μ ≤ 2 := by
      calc
        (∫⁻ ω, ENNReal.ofReal (Real.exp (X ω ^ 2 / t.toReal ^ 2)) ∂μ) =
            orliczIntegral psiTwoOrliczFunction μ X t + 1 := by
              exact (psiTwoOrliczFunction_integral_add_one ht0 htTop hX).symm
        _ ≤ 1 + 1 := by
          simpa only [add_comm] using (add_le_add_right hbound (1 : ENNReal))
        _ = 2 := by norm_num
    have hInt : Integrable
        (fun ω => Real.exp (X ω ^ 2 / t.toReal ^ 2)) μ := by
      have hmeas : Measurable (fun ω =>
          Real.exp (X ω ^ 2 / t.toReal ^ 2)) := by fun_prop
      have hfinite : HasFiniteIntegral (fun ω =>
          Real.exp (X ω ^ 2 / t.toReal ^ 2)) μ := by
        rw [hasFiniteIntegral_iff_enorm]
        simpa only [← ofReal_norm_eq_enorm, Real.norm_eq_abs,
          abs_of_pos (Real.exp_pos _)] using
          (lt_of_le_of_lt hbound' ENNReal.coe_lt_top)
      exact ⟨hmeas.aestronglyMeasurable, hfinite⟩
    refine ⟨hX, ht0, htTop, hInt, ?_⟩
    have hEq := MeasureTheory.ofReal_integral_eq_lintegral_ofReal hInt
      (Filter.Eventually.of_forall (fun ω => (Real.exp_pos _).le))
    have hOf : ENNReal.ofReal
        (∫ ω, Real.exp (X ω ^ 2 / t.toReal ^ 2) ∂μ) ≤ (2 : ENNReal) := by
      rw [hEq]
      exact hbound'
    have hreal := (ENNReal.ofReal_le_iff_le_toReal (b := (2 : ENNReal))
      (by norm_num)).mp hOf
    simpa using hreal
  · intro ht
    rcases ht with ⟨_, ht0, htTop, hInt, hbound⟩
    refine ⟨ht0, htTop, ?_⟩
    have hEq := MeasureTheory.ofReal_integral_eq_lintegral_ofReal hInt
      (Filter.Eventually.of_forall (fun ω => (Real.exp_pos _).le))
    have h := psiTwoOrliczFunction_integral_add_one (μ := μ) (X := X) (t := t)
      ht0 htTop hX
    have hbound' :
        (∫⁻ ω, ENNReal.ofReal (Real.exp (X ω ^ 2 / t.toReal ^ 2)) ∂μ) ≤
          (2 : ENNReal) := by
      rw [← hEq]
      simpa using ENNReal.ofReal_le_ofReal hbound
    apply ENNReal.le_of_add_le_add_right (a := (1 : ENNReal)) (by norm_num)
    calc
      orliczIntegral psiTwoOrliczFunction μ X t + 1 =
          (∫⁻ ω, ENNReal.ofReal (Real.exp (X ω ^ 2 / t.toReal ^ 2)) ∂μ) := h
      _ ≤ 2 := hbound'
      _ = 1 + 1 := by norm_num

theorem psiTwoOrliczMember_iff_psiTwoMember
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) :
    orliczMember psiTwoOrliczFunction μ X ↔
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X < ∞ := by
  rw [orliczMember, psiTwoOrliczGauge_eq_psiTwoGauge hX]

end NumStability.HDP.Scalar.SubExponential

namespace NumStability.HDP.Contract

/-- Stable source-facing alias for the local Orlicz-function interface. -/
def hdp_02_hdef_horlicz_hfunction : Type :=
  NumStability.HDP.Scalar.SubExponential.OrliczFunction

/-- Stable source-facing alias for the Luxemburg/Orlicz norm-space model. -/
def hdp_02_hdef_horlicz_hnorm_hspace
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
    (μ : Measure Ω) :
    NumStability.HDP.Scalar.SubExponential.OrliczNormSpaceModelData ψ μ :=
  NumStability.HDP.Scalar.SubExponential.orliczNormSpaceModel ψ μ

/-- Stable Chapter 2 alias for the centered moment-to-MGF implication. -/
theorem hdp_02_hlem_hse_hmoment_hto_hmgf
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (hLp : NumStability.HDP.Scalar.SubExponential.LpMomentGrowth μ X K)
    (lam : ℝ) (hsmall : |lam| ≤ (4 * Real.exp 1 * K)⁻¹) :
    Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
      (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
        Real.exp (2 * (Real.exp 1 * (lam * K)) ^ 2) :=
  NumStability.HDP.Scalar.SubExponential.momentToMGF hK hCenter hLp lam hsmall

/-- Stable Chapter 2 alias for the endpoint-MGF-to-moment implication. -/
theorem hdp_02_hlem_hse_hmgf_hto_hmoment
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K C : ℝ} (hK : 0 < K) (hC : 0 ≤ C)
    (hMGF : NumStability.HDP.Scalar.SubExponential.TwoSidedMGFBound μ X K C) :
    NumStability.HDP.Scalar.SubExponential.LpMomentGrowth μ X
      (2 * Real.exp C * K) :=
  NumStability.HDP.Scalar.SubExponential.mgfToMoment hK hC hMGF

/-! Stable Chapter 2 alias for Exercise 2.7.2. -/
theorem hdp_02_hex_h2_d7_d2
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ i j : NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind,
        ∀ {Ki : ℝ}, 0 < Ki →
          NumStability.HDP.Scalar.SubExponential.SubExponentialProperty μ X i Ki →
            ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
              NumStability.HDP.Scalar.SubExponential.SubExponentialProperty μ X j Kj := by
  exact NumStability.HDP.Scalar.SubExponential.subExponentialCharacterization

/-! Stable Chapter 2 alias for Exercise 2.7.3. -/
theorem hdp_02_hex_h2_d7_d3
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {α : ℝ} (hα : 0 < α) :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ i j : NumStability.HDP.Scalar.SubExponential.SubWeibullPropertyKind,
        ∀ {Ki : ℝ}, 0 < Ki →
          NumStability.HDP.Scalar.SubExponential.SubWeibullProperty μ X α i Ki →
            ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
              NumStability.HDP.Scalar.SubExponential.SubWeibullProperty μ X α j Kj := by
  exact NumStability.HDP.Scalar.SubExponential.subWeibullCharacterization hα

/-! Stable Chapter 2 alias for Remark 2.7.9. -/
theorem hdp_02_hrem_h2_d7_d9 : hdp_02_hrem_h2_d7_d9__contract_type := by
  exact NumStability.HDP.Scalar.SubExponential.remark279_contract

/-! Stable Chapter 2 alias for Example 2.7.12. -/
theorem hdp_02_hexample_h2_d7_d12 :
    ∀ {Ω : Type*} [MeasurableSpace Ω]
      (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
      (μ : Measure Ω) (p : NNReal),
      0 < p →
      (∀ x : ℝ, 0 ≤ x → ψ x = x ^ (p : ℝ)) →
      (∀ X : Ω → ℝ,
        NumStability.HDP.Scalar.SubExponential.orliczGauge ψ μ X =
          eLpNorm X (p : ENNReal) μ) ∧
      (∀ X : Ω → ℝ, AEStronglyMeasurable X μ →
        (NumStability.HDP.Scalar.SubExponential.orliczMember ψ μ X ↔
          MemLp X (p : ENNReal) μ)) := by
  exact NumStability.HDP.Scalar.SubExponential.powerOrliczCoincidence

/-! Stable Chapter 2 alias for Example 2.7.13. -/
theorem hdp_02_hexample_h2_d7_d13
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) :
    NumStability.HDP.Scalar.SubExponential.orliczMember
        NumStability.HDP.Scalar.SubExponential.psiTwoOrliczFunction μ X ↔
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X < ∞ := by
  exact NumStability.HDP.Scalar.SubExponential.psiTwoOrliczMember_iff_psiTwoMember hX

end NumStability.HDP.Contract
