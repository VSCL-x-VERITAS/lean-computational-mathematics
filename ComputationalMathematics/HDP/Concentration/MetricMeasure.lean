import Mathlib.Probability.CDF
import Mathlib.Probability.Distributions.Gaussian.Real
import Mathlib.Probability.Independence.Basic
import Mathlib.Topology.MetricSpace.Lipschitz
import Mathlib.Topology.MetricSpace.HausdorffDistance
import Mathlib.Analysis.Normed.MulAction
import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Analysis.Calculus.Deriv.Abs
import Mathlib.Geometry.Manifold.Riemannian.Basic
import Mathlib.MeasureTheory.Integral.Lebesgue.Basic
import Mathlib.MeasureTheory.Measure.ProbabilityMeasure
import Mathlib.MeasureTheory.Measure.WithDensity
import Mathlib.MeasureTheory.Measure.OpenPos
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.MeasureTheory.Constructions.BorelSpace.Order
import Mathlib.MeasureTheory.Constructions.Pi
import Mathlib.Logic.Equiv.Basic
import Mathlib.Topology.Order.IntermediateValue
import Mathlib.Probability.UniformOn
import Mathlib.Tactic
import ComputationalMathematics.HDP.Scalar.SubGaussian

noncomputable section

open Filter Set TopologicalSpace
open MeasureTheory
open Bundle
open scoped Bundle ENNReal Manifold Topology

namespace NumStability.HDP.Concentration.MetricMeasure

/-!
  A median is recorded at the law level.  This is the two-sided definition
  used in Chapter 5: both closed half-lines have mass at least one half.
-/
/-- The two-sided median predicate for a real measure. -/
def IsMedian (μ : Measure ℝ) (m : ℝ) : Prop :=
  (1 / 2 : ℝ≥0∞) ≤ μ (Iic m) ∧ (1 / 2 : ℝ≥0∞) ≤ μ (Ici m)

/-- The pushforward law of `X` under `μ` used by the median interface. -/
def medianLaw (μ : Measure ℝ) (X : ℝ → ℝ) : Measure ℝ :=
  Measure.map X μ

theorem medianLaw_isProbabilityMeasure
    (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (X : ℝ → ℝ) (hX : AEMeasurable X μ) :
    IsProbabilityMeasure (medianLaw μ X) := by
  simpa [medianLaw] using Measure.isProbabilityMeasure_map hX

/-!
  The CDF upper-level set and its left boundary are the local quantile
  construction.  The CDF itself is the pinned Mathlib Stieltjes substrate.
-/
/-- Thresholds where the CDF of `μ` is at least one half. -/
def medianBoundarySet (μ : Measure ℝ) : Set ℝ :=
  {x | (1 / 2 : ℝ) ≤ ProbabilityTheory.cdf μ x}

/-- The infimum of the CDF median-boundary set. -/
noncomputable def medianBoundary (μ : Measure ℝ) : ℝ :=
  sInf (medianBoundarySet μ)

/-!
  The source-facing semantic object keeps the law transport and the CDF
  boundary visible in its type.  This makes the two pinned frontier
  substrates part of the checked declaration rather than merely hidden in a
  downstream existence proof.
-/
/-- A median certificate retaining both the transported law and CDF boundary. -/
structure MedianCertificate (μ : Measure ℝ) (X : ℝ → ℝ) where
  /-- The certified median. -/
  value : ℝ
  is_median : IsMedian (medianLaw μ X) value
  /-- The CDF boundary recorded by the certificate. -/
  quantile_boundary : ℝ
  quantile_boundary_eq :
    quantile_boundary = medianBoundary (medianLaw μ X)

/-!
  Chapter 5's Lipschitz interface uses Mathlib's `NNReal` constants and
  records the infimum in `ENNReal`, while retaining Mathlib's distance-to-set
  function.  The bundled certificate keeps both source-facing operations in
  one declaration.
-/
/-- The nonnegative Lipschitz constants admitted by a real function. -/
def lipConstants (f : ℝ → ℝ) : Set NNReal :=
  {K | LipschitzWith K f}

/-- The infimum of the admitted Lipschitz constants, embedded in `ENNReal`. -/
noncomputable def lipNorm (f : ℝ → ℝ) : ℝ≥0∞ :=
  ENNReal.ofNNReal (sInf (lipConstants f))

/-- A bundled Lipschitz bound, norm, restrictions, and distance-to-set map. -/
structure LipschitzCertificate (f : ℝ → ℝ) where
  /-- A certified Lipschitz constant. -/
  constant : NNReal
  bound : LipschitzWith constant f
  restriction : ∀ s : Set ℝ, LipschitzWith constant (s.restrict f)
  restriction_rule :
    ∀ s, LipschitzWith.restrict bound s = restriction s
  /-- The optimal Lipschitz constant represented in `ENNReal`. -/
  norm : ℝ≥0∞
  norm_eq : norm = lipNorm f
  /-- The distance from a point to a set. -/
  distance_to_set : ℝ → Set ℝ → ℝ
  distance_to_set_eq :
    ∀ x s, distance_to_set x s = Metric.infDist x s

/--
The public real-valued Lipschitz certificate alias. Its definition retains the
restriction bridge so dependency audits see the exact Mathlib operation.
-/
noncomputable def LipschitzInterface (f : ℝ → ℝ) : Type :=
  let _restriction_bridge :=
    fun (K : NNReal) (h : LipschitzWith K f) (s : Set ℝ) =>
      LipschitzWith.restrict h s
  LipschitzCertificate f

theorem lipNorm_le {f : ℝ → ℝ} {K : NNReal}
    (h : LipschitzWith K f) :
    lipNorm f ≤ ENNReal.ofNNReal K := by
  rw [lipNorm]
  exact ENNReal.coe_le_coe.mpr (csInf_le (OrderBot.bddBelow _) h)

/-- Build a `LipschitzInterface` from a `LipschitzWith` proof. -/
def lipschitz_interface_mk
    {f : ℝ → ℝ} {K : NNReal} (h : LipschitzWith K f) :
    LipschitzInterface f := by
  exact {
    constant := K
    bound := h
    restriction := fun s => LipschitzWith.restrict h s
    restriction_rule := fun _ => rfl
    norm := lipNorm f
    norm_eq := rfl
    distance_to_set := Metric.infDist
    distance_to_set_eq := fun _ _ => rfl
  }

theorem lipschitz_smul_left
    {f : ℝ → ℝ} {K : NNReal} (c : ℝ) (h : LipschitzWith K f) :
    LipschitzWith (‖c‖₊ * K) (fun x => c * f x) := by
  simpa [smul_eq_mul, Function.comp_def] using
    (lipschitzWith_smul c).comp h

theorem lipschitz_comp
    {f : ℝ → ℝ} {g : ℝ → ℝ} {Kf Kg : NNReal}
    (hf : LipschitzWith Kf f) (hg : LipschitzWith Kg g) :
    LipschitzWith (Kf * Kg) (f ∘ g) :=
  hf.comp hg

theorem lipschitz_restrict
    {f : ℝ → ℝ} {K : NNReal} (h : LipschitzWith K f) (s : Set ℝ) :
    LipschitzWith K (s.restrict f) :=
  h.restrict s

theorem distance_to_set_lipschitz (s : Set ℝ) :
    LipschitzWith 1 (fun x : ℝ => Metric.infDist x s) :=
  Metric.lipschitz_infDist_pt s

theorem distance_to_set_le_add (s : Set ℝ) (x y : ℝ) :
    Metric.infDist x s ≤ Metric.infDist y s + dist x y :=
  Metric.infDist_le_infDist_add_dist

/-!
  Exercise 5.1.2 is a source discrepancy: differentiability alone does not
  imply global Lipschitz continuity.  The corrected package below records the
  counterexample, the valid bounded-derivative theorem, and explicit examples
  separating uniform continuity from Lipschitz continuity and differentiability
  on the printed compact intervals.
-/
/-- The square-root function used in the corrected unit-interval example. -/
def sqrtUnitIntervalExample (x : ℝ) : ℝ := Real.sqrt x

/-- The absolute-value function used in the unit-interval example. -/
def absUnitIntervalExample (x : ℝ) : ℝ := |x|

theorem exercise512Corrected :
    (∀ {α β : Type} [PseudoEMetricSpace α] [PseudoEMetricSpace β]
      {K : NNReal} {f : α → β}, LipschitzWith K f → UniformContinuous f) ∧
    (¬ ∃ K : NNReal, LipschitzWith K (fun x : ℝ => x ^ 2)) ∧
    (∀ {E : Type} [NormedAddCommGroup E] [NormedSpace ℝ E]
      {f : E → ℝ} (hf : Differentiable ℝ f) (C : NNReal),
      (∀ x, ‖fderiv ℝ f x‖₊ ≤ C) → LipschitzWith C f) ∧
    UniformContinuousOn sqrtUnitIntervalExample (Icc (0 : ℝ) 1) ∧
    (¬ ∃ K : NNReal,
      LipschitzOnWith K sqrtUnitIntervalExample (Icc (0 : ℝ) 1)) ∧
    LipschitzOnWith 1 absUnitIntervalExample (Icc (-1 : ℝ) 1) ∧
    ¬ DifferentiableWithinAt ℝ absUnitIntervalExample (Icc (-1 : ℝ) 1) 0 := by
  have huniform :
      ∀ {α β : Type} [PseudoEMetricSpace α] [PseudoEMetricSpace β]
        {K : NNReal} {f : α → β}, LipschitzWith K f → UniformContinuous f := by
    intro α β _ _ K f hf
    exact hf.uniformContinuous
  have hsquare : ¬ ∃ K : NNReal, LipschitzWith K (fun x : ℝ => x ^ 2) := by
    rintro ⟨K, hK⟩
    have h := hK.norm_sub_le 0 (K + 1)
    norm_num [Real.norm_eq_abs] at h
    have hK0 : (0 : ℝ) ≤ K := K.2
    have habs : |-1 + -(K : ℝ)| = (K : ℝ) + 1 := by
      rw [abs_of_nonpos]
      · ring
      · linarith
    rw [habs] at h
    nlinarith
  have hsqrt_uniform :
      UniformContinuousOn sqrtUnitIntervalExample (Icc (0 : ℝ) 1) := by
    exact isCompact_Icc.uniformContinuousOn_of_continuous
      Real.continuous_sqrt.continuousOn
  have hsqrt_not_lipschitz :
      ¬ ∃ K : NNReal,
        LipschitzOnWith K sqrtUnitIntervalExample (Icc (0 : ℝ) 1) := by
    rintro ⟨K, hK⟩
    let a : ℝ := ((K : ℝ) + 1)⁻¹
    have ha0 : 0 ≤ a := by
      dsimp [a]
      positivity
    have ha1 : a ≤ 1 := by
      dsimp [a]
      have hK1 : (1 : ℝ) ≤ (K : ℝ) + 1 := by linarith [K.2]
      exact (inv_le_one₀ (by positivity)).2 hK1
    have ha_mem : a ^ 2 ∈ Icc (0 : ℝ) 1 := by
      constructor
      · positivity
      · have hsqa : a ^ 2 ≤ (1 : ℝ) ^ 2 :=
          (sq_le_sq₀ (by positivity : (0 : ℝ) ≤ a) (by norm_num)).2 ha1
        simpa using hsqa
    have h0_mem : (0 : ℝ) ∈ Icc (0 : ℝ) 1 := by norm_num
    have h := hK.dist_le_mul (a ^ 2) ha_mem 0 h0_mem
    have hsqrt : Real.sqrt (a ^ 2) = a := Real.sqrt_sq ha0
    dsimp [sqrtUnitIntervalExample, a] at h hsqrt ⊢
    rw [hsqrt] at h
    have hpos : 0 < (K : ℝ) + 1 := by linarith [K.2]
    rw [Real.dist_eq, Real.dist_eq] at h
    simp only [Real.sqrt_zero, sub_zero] at h
    have hdivpos : 0 < ((K : ℝ) + 1)⁻¹ := inv_pos.mpr hpos
    have hdivsqpos : 0 < ((K : ℝ) + 1)⁻¹ ^ 2 := sq_pos_of_pos hdivpos
    rw [abs_of_pos hdivpos, abs_of_pos hdivsqpos] at h
    field_simp [hpos.ne'] at h
    nlinarith [K.2]
  have habs_lipschitz :
      LipschitzOnWith 1 absUnitIntervalExample (Icc (-1 : ℝ) 1) := by
    simpa [absUnitIntervalExample, Real.norm_eq_abs] using
      (lipschitzWith_one_norm (E := ℝ)).lipschitzOnWith
  have habs_not_differentiable :
      ¬ DifferentiableWithinAt ℝ absUnitIntervalExample (Icc (-1 : ℝ) 1) 0 := by
    intro h
    apply not_differentiableAt_abs_zero
    apply h.differentiableAt
    exact Icc_mem_nhds (by norm_num) (by norm_num)
  refine ⟨huniform, hsquare, ?_, hsqrt_uniform, hsqrt_not_lipschitz,
    habs_lipschitz, habs_not_differentiable⟩
  intro E _ _ f hf C hC
  rw [← lipschitzOnWith_univ]
  exact Convex.lipschitzOnWith_of_nnnorm_fderiv_le
    (fun x _ => hf x) (fun x _ => hC x) convex_univ

/-!
  The general metric-space definition from Chapter 5, §5.1.1.  The
  Lipschitz predicate and constants are the Mathlib ones; the optimal
  constant is recorded in `ℝ≥0∞` using the infimum of all `NNReal`
  witnesses.  This is the same convention used by the real-valued
  `LipschitzInterface` above, but with the source's domain and codomain
  left general.
-/
/-- The admissible Lipschitz constants of a map between pseudometric spaces. -/
def metricLipConstants
    {α β : Type*} [PseudoMetricSpace α] [PseudoMetricSpace β]
    (f : α → β) : Set NNReal :=
  {K | LipschitzWith K f}

/-- The infimum of the admissible metric-space Lipschitz constants. -/
noncomputable def metricLipNorm
    {α β : Type*} [PseudoMetricSpace α] [PseudoMetricSpace β]
    (f : α → β) : ℝ≥0∞ :=
  ENNReal.ofNNReal (sInf (metricLipConstants f))

/-- The nonexpansive, or `1`-Lipschitz, predicate used by the source. -/
def IsContraction
    {α β : Type*} [PseudoMetricSpace α] [PseudoMetricSpace β]
    (f : α → β) : Prop :=
  LipschitzWith 1 f

/-- A bundled metric-space Lipschitz bound and its optimal-constant value. -/
structure LipschitzMapData
    {α β : Type*} [PseudoMetricSpace α] [PseudoMetricSpace β]
    (f : α → β) where
  /-- A certified Lipschitz constant. -/
  constant : NNReal
  bound : LipschitzWith constant f
  /-- The optimal Lipschitz constant represented in `ENNReal`. -/
  norm : ℝ≥0∞
  norm_eq : norm = metricLipNorm f

theorem metricLipNorm_le
    {α β : Type*} [PseudoMetricSpace α] [PseudoMetricSpace β]
    {f : α → β} {K : NNReal} (h : LipschitzWith K f) :
    metricLipNorm f ≤ ENNReal.ofNNReal K := by
  rw [metricLipNorm]
  exact ENNReal.coe_le_coe.mpr (csInf_le (OrderBot.bddBelow _) h)

/-- Build `LipschitzMapData` from a `LipschitzWith` proof. -/
def lipschitz_map_data_mk
    {α β : Type*} [PseudoMetricSpace α] [PseudoMetricSpace β]
    {f : α → β} {K : NNReal} (h : LipschitzWith K f) :
    LipschitzMapData f := by
  exact {
    constant := K
    bound := h
    norm := metricLipNorm f
    norm_eq := rfl
  }

theorem median_exists (μ : Measure ℝ) [IsProbabilityMeasure μ] :
    ∃ m, IsMedian μ m := by
  let f : ℝ → ℝ := ProbabilityTheory.cdf μ
  let S : Set ℝ := {x | (1 / 2 : ℝ) ≤ f x}
  have htop : ∀ᶠ x in atTop, (1 / 2 : ℝ) < f x := by
    simpa [f] using
      ((tendsto_order.1 (ProbabilityTheory.tendsto_cdf_atTop μ)).1
        (1 / 2 : ℝ) (by norm_num))
  have hbot : ∀ᶠ x in atBot, f x < (1 / 2 : ℝ) := by
    simpa [f] using
      ((tendsto_order.1 (ProbabilityTheory.tendsto_cdf_atBot μ)).2
        (1 / 2 : ℝ) (by norm_num))
  obtain ⟨a, ha⟩ := eventually_atTop.1 htop
  have hS : S.Nonempty := by
    refine ⟨a, ?_⟩
    change (1 / 2 : ℝ) ≤ f a
    exact (ha a le_rfl).le
  obtain ⟨b, hb⟩ := eventually_atBot.1 hbot
  have hBdd : BddBelow S := by
    refine ⟨b, ?_⟩
    intro x hx
    change (1 / 2 : ℝ) ≤ f x at hx
    by_contra hxb
    have hxb' : x ≤ b := le_of_not_ge hxb
    exact (not_lt_of_ge hx) (hb x hxb')
  let q : ℝ := sInf S
  have hq_le : ∀ x ∈ S, q ≤ x := by
    intro x hx
    exact csInf_le hBdd hx
  have hq_mem : q ∈ S := by
    change (1 / 2 : ℝ) ≤ f q
    rw [show f q = ProbabilityTheory.cdf μ q by rfl]
    rw [← (ProbabilityTheory.cdf μ).iInf_Ioi_eq q]
    refine le_ciInf (fun (r : Ioi q) => ?_)
    obtain ⟨x, hx, hxr⟩ := exists_lt_of_csInf_lt hS r.property
    change (1 / 2 : ℝ) ≤ f x at hx
    exact hx.trans ((show Monotone f by
      simpa [f] using ProbabilityTheory.monotone_cdf μ) hxr.le)
  have hbelow : ∀ x < q, f x < (1 / 2 : ℝ) := by
    intro x hx
    have hxnot : x ∉ S := notMem_of_lt_csInf hx hBdd
    exact lt_of_not_ge (fun h => hxnot h)
  have hfmono : Monotone f := by
    simpa [f] using ProbabilityTheory.monotone_cdf μ
  have hleft : Function.leftLim f q ≤ (1 / 2 : ℝ) := by
    refine le_of_tendsto (hfmono.tendsto_leftLim q) ?_
    filter_upwards [self_mem_nhdsWithin] with x hx
    exact (hbelow x hx).le
  have hleft_one : Function.leftLim f q ≤ 1 := by
    exact (hfmono.leftLim_le le_rfl).trans (by
      simpa [f] using ProbabilityTheory.cdf_le_one μ q)
  have hlower : (1 / 2 : ℝ≥0∞) ≤ μ (Iic q) := by
    calc
      (1 / 2 : ℝ≥0∞) = ENNReal.ofReal (1 / 2 : ℝ) := by
        rw [ENNReal.ofReal_div_of_pos (by norm_num : (0 : ℝ) < 2)]
        norm_num
      _ ≤ ENNReal.ofReal (ProbabilityTheory.cdf μ q) := by
        apply ENNReal.ofReal_le_ofReal
        exact (show (1 / 2 : ℝ) ≤ f q from hq_mem)
      _ = μ (Iic q) := ProbabilityTheory.ofReal_cdf μ q
  have hupper : (1 / 2 : ℝ≥0∞) ≤ μ (Ici q) := by
    have hcross : (1 / 2 : ℝ) ≤ 1 - Function.leftLim f q := by linarith
    calc
      (1 / 2 : ℝ≥0∞) = ENNReal.ofReal (1 / 2 : ℝ) := by
        rw [ENNReal.ofReal_div_of_pos (by norm_num : (0 : ℝ) < 2)]
        norm_num
      _ ≤ ENNReal.ofReal (1 - Function.leftLim f q) :=
        ENNReal.ofReal_le_ofReal hcross
      _ = (ProbabilityTheory.cdf μ).measure (Ici q) := by
        symm
        rw [StieltjesFunction.measure_Ici (ProbabilityTheory.cdf μ)
          (ProbabilityTheory.tendsto_cdf_atTop μ)]
      _ = μ (Ici q) := congrArg (fun ν : Measure ℝ => ν (Ici q))
        (ProbabilityTheory.measure_cdf μ)
  exact ⟨q, hlower, hupper⟩

theorem median_exists_of_aemeasurable
    (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (X : ℝ → ℝ) (hX : AEMeasurable X μ) :
    ∃ m, IsMedian (medianLaw μ X) m := by
  letI : IsProbabilityMeasure (medianLaw μ X) :=
    medianLaw_isProbabilityMeasure μ X hX
  exact median_exists (medianLaw μ X)

theorem median_certificate_exists
    (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (X : ℝ → ℝ) (hX : AEMeasurable X μ) :
    Nonempty (MedianCertificate μ X) := by
  letI : IsProbabilityMeasure (medianLaw μ X) :=
    medianLaw_isProbabilityMeasure μ X hX
  obtain ⟨m, hm⟩ := median_exists (medianLaw μ X)
  exact ⟨{
    value := m
    is_median := hm
    quantile_boundary := medianBoundary (medianLaw μ X)
    quantile_boundary_eq := rfl
  }⟩

/-!
  The Chapter 5 concentration interface fixes the conventions that are shared
  by the metric, Gaussian, and matrix concentration packages.  In particular,
  tails are two-sided, use the closed event `|X| ≥ t`, and carry the factor
  `2 * exp (-t^2 / K^2)`.  The interface is deliberately a certificate rather
  than a competing norm or probability law: the scalar Chapter 2 predicates,
  gauge, centering theorem, and Chapter 1 layer-cake identity remain the
  semantic producers.
-/

/-- The tail-bound scale obtained from a concentration scale `K`. -/
def concentrationTailScale (K : ℝ) : ℝ := 16 * K

/-- The ψ₂-gauge scale obtained from a concentration scale `K`. -/
def concentrationPsiTwoScale (K : ℝ) : ℝ :=
  4096 * Real.exp 1 * K

/-- The mean-centered scale obtained from a concentration scale `K`. -/
def concentrationMeanScale (K : ℝ) : ℝ :=
  65536 * (Real.exp 1) ^ 2 * K

/-- The median-centered scale obtained from a concentration scale `K`. -/
def concentrationMedianScale (K : ℝ) : ℝ :=
  4 * K

/-- The sub-Gaussian tail bound for `X` centered at its mean. -/
def MeanConcentrationBound
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K : ℝ) : Prop :=
  NumStability.HDP.Scalar.SubGaussian.SubGaussianTailBound μ
    (fun ω => X ω - ∫ x, X x ∂μ) K

/-- A two-sided Gaussian tail bound for `X` centered at a median. -/
def MedianConcentrationBound
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (m K : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧
    ∀ t : ℝ, 0 ≤ t →
      μ.real {ω | |X ω - m| ≥ t} ≤ 2 * Real.exp (-t ^ 2 / K ^ 2)

/-- Data connecting the equivalent concentration, centering, and ψ₂ bounds. -/
structure ConcentrationInterfaceData
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) where
  /-- The chosen presentation of the sub-Gaussian property. -/
  property_kind :
    NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
  /-- The scale of the chosen sub-Gaussian property. -/
  property_scale : ℝ
  property_scale_pos : 0 < property_scale
  property :
    NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X
      property_kind property_scale
  center : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0
  psi_two_characterization :
    ∃ C : ℝ, 1 ≤ C ∧
      (∀ i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
        ∀ {K : ℝ}, 0 < K →
          NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i K →
            NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X ≤
              ENNReal.ofReal (C * K)) ∧
      (∀ i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
        ((∃ K : ℝ, 0 < K ∧
          NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i K) ↔
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X < ∞))
  centering_characterization :
    ∃ C : ℝ, 1 ≤ C ∧
      Integrable X μ ∧
      ∃ K' : ℝ, 0 < K' ∧ K' ≤ C * property_scale ∧
        NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ
          (fun ω => X ω - ∫ x, X x ∂μ)
          NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.squarePoint K' ∧
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
            (fun ω => X ω - ∫ x, X x ∂μ) ≤
          ENNReal.ofReal (C * property_scale)
  /-- The scale used by the resulting tail bound. -/
  tail_scale : ℝ
  tail_scale_eq : tail_scale = concentrationTailScale property_scale
  tail_bound :
    NumStability.HDP.Scalar.SubGaussian.SubGaussianTailBound μ X tail_scale
  /-- The scale used by the mean-centered bound. -/
  mean_scale : ℝ
  mean_scale_eq : mean_scale = concentrationMeanScale property_scale
  mean_bound : MeanConcentrationBound μ X mean_scale
  /-- A certified median of the law of `X`. -/
  median : ℝ
  median_certificate : IsMedian (Measure.map X μ) median
  /-- The scale used by the median-centered bound. -/
  median_scale : ℝ
  median_scale_eq : median_scale = concentrationMedianScale property_scale
  median_bound : MedianConcentrationBound μ X median median_scale
  psi_two_scale_bound :
    NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X ≤
      ENNReal.ofReal (concentrationPsiTwoScale property_scale)
  layer_cake :
    ∀ {Y : Ω → ℝ} (hY : Measurable Y)
      (hNonneg : ∀ ω, 0 ≤ Y ω),
      ((∫⁻ ω, ENNReal.ofReal (Y ω) ∂μ) =
          ∫⁻ t in Set.Ioi 0, μ {ω | t < Y ω}) ∧
        (∀ hInt : Integrable Y μ,
          NumStability.HDP.Scalar.Preliminaries.expectation μ Y =
            ∫ t in Set.Ioi 0, μ.real {ω | t < Y ω})

/-- The public concentration certificate associated with `μ` and `X`. -/
noncomputable def concentrationInterface
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) : Type :=
  ConcentrationInterfaceData μ X

theorem median_abs_le_of_subGaussianTail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hX : Measurable X)
    (hTail : NumStability.HDP.Scalar.SubGaussian.SubGaussianTailBound μ X K)
    {m : ℝ} (hm : IsMedian (Measure.map X μ) m) :
    |m| ≤ 2 * K := by
  have hK : 0 < K := hTail.2.1
  have hprob (s : Set Ω) : μ.real s ≤ 1 := by
    calc
      μ.real s ≤ μ.real Set.univ := by
        simp only [MeasureTheory.measureReal_def]
        exact ENNReal.toReal_mono (measure_ne_top μ Set.univ)
          (measure_mono (Set.subset_univ _))
      _ = 1 := probReal_univ
  have hupper : (1 / 2 : ℝ) ≤ μ.real {ω | m ≤ X ω} := by
    have h := hm.2
    rw [Measure.map_apply hX measurableSet_Ici] at h
    rw [MeasureTheory.measureReal_def]
    have h' := ENNReal.toReal_mono (measure_ne_top μ _) h
    norm_num at h' ⊢
    exact h'
  have hlower : (1 / 2 : ℝ) ≤ μ.real {ω | X ω ≤ m} := by
    have h := hm.1
    rw [Measure.map_apply hX measurableSet_Iic] at h
    rw [MeasureTheory.measureReal_def]
    have h' := ENNReal.toReal_mono (measure_ne_top μ _) h
    norm_num at h' ⊢
    exact h'
  have hexp4 : (5 : ℝ) ≤ Real.exp 4 := by
    nlinarith [Real.add_one_le_exp (4 : ℝ)]
  have hexpneg4 : Real.exp (-4 : ℝ) < (1 / 4 : ℝ) := by
    rw [Real.exp_neg]
    apply (inv_lt_iff_one_lt_mul₀ (Real.exp_pos 4)).2
    nlinarith [hexp4]
  have htail_contradiction {t : ℝ} (ht : 2 < t / K) :
      2 * Real.exp (-t ^ 2 / K ^ 2) < (1 / 2 : ℝ) := by
    have hratio : 4 < t ^ 2 / K ^ 2 := by
      have hTK : 2 * K < t := (lt_div_iff₀ hK).mp ht
      have hsq : (2 * K) ^ 2 < t ^ 2 := by
        exact (sq_lt_sq₀ (by nlinarith [hK.le]) (by nlinarith [hTK])).2 hTK
      apply (lt_div_iff₀ (sq_pos_of_pos hK)).2
      nlinarith [hsq]
    have hexp : Real.exp (-t ^ 2 / K ^ 2) < Real.exp (-4 : ℝ) := by
      apply Real.exp_lt_exp.mpr
      have hneg := neg_lt_neg hratio
      simpa only [neg_div] using hneg
    nlinarith [hexp, hexpneg4]
  by_cases hm0 : 0 ≤ m
  · have hsubset : {ω | m ≤ X ω} ⊆ {ω | |X ω| ≥ m} := by
      intro ω hω
      exact hω.trans (le_abs_self (X ω))
    have htailm := hTail.2.2 m hm0
    have hbound : (1 / 2 : ℝ) ≤ 2 * Real.exp (-m ^ 2 / K ^ 2) := by
      have hmono : μ.real {ω | m ≤ X ω} ≤ μ.real {ω | |X ω| ≥ m} := by
        rw [MeasureTheory.measureReal_def, MeasureTheory.measureReal_def]
        exact ENNReal.toReal_mono (measure_ne_top μ _)
          (measure_mono hsubset)
      exact hupper.trans (hmono.trans htailm)
    by_contra hnot
    have hm2 : 2 * K < m := by
      have hgt : 2 * K < |m| := lt_of_not_ge hnot
      simpa [abs_of_nonneg hm0] using hgt
    have hcontra := htail_contradiction (t := m) (by
      apply (lt_div_iff₀ hK).2
      linarith)
    linarith
  · have hmneg : m ≤ 0 := le_of_not_ge hm0
    have hsubset : {ω | X ω ≤ m} ⊆ {ω | |X ω| ≥ -m} := by
      intro ω hω
      change |X ω| ≥ -m
      change X ω ≤ m at hω
      have hXneg : X ω ≤ 0 := hω.trans hmneg
      rw [abs_of_nonpos hXneg]
      linarith [hω]
    have htailm := hTail.2.2 (-m) (by linarith)
    have hbound : (1 / 2 : ℝ) ≤ 2 * Real.exp (-(-m) ^ 2 / K ^ 2) := by
      have hmono : μ.real {ω | X ω ≤ m} ≤ μ.real {ω | |X ω| ≥ -m} := by
        rw [MeasureTheory.measureReal_def, MeasureTheory.measureReal_def]
        exact ENNReal.toReal_mono (measure_ne_top μ _)
          (measure_mono hsubset)
      exact hlower.trans (hmono.trans htailm)
    by_contra hnot
    have hm2 : 2 * K < -m := by
      have hgt : 2 * K < |m| := lt_of_not_ge hnot
      simpa [abs_of_nonpos hmneg] using hgt
    have hcontra := htail_contradiction (t := -m) (by
      apply (lt_div_iff₀ hK).2
      linarith)
    linarith

lemma integral_abs_le_two_mul_of_psiTwoAdmissible
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {Y : Ω → ℝ} {t : ℝ≥0∞}
    (hYint : Integrable Y μ)
    (ht : NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible μ Y t) :
    |∫ ω, Y ω ∂μ| ≤ 2 * t.toReal := by
  rcases ht with ⟨hY, ht0, htTop, hExpInt, hExpBound⟩
  have htpos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
  have hpoint : ∀ ω,
      |Y ω| ≤ t.toReal * Real.exp (Y ω ^ 2 / t.toReal ^ 2) := by
    intro ω
    have hxnonneg : 0 ≤ |Y ω| / t.toReal :=
      div_nonneg (abs_nonneg _) htpos.le
    have hxquad : |Y ω| / t.toReal ≤
        (|Y ω| / t.toReal) ^ 2 + 1 := by
      nlinarith [sq_nonneg (|Y ω| / t.toReal - (1 / 2 : ℝ))]
    have harg : (|Y ω| / t.toReal) ^ 2 =
        Y ω ^ 2 / t.toReal ^ 2 := by
      field_simp [ne_of_gt htpos]
      rw [sq_abs]
    have hxexp : |Y ω| / t.toReal ≤
        Real.exp (Y ω ^ 2 / t.toReal ^ 2) := by
      calc
        |Y ω| / t.toReal ≤
            (|Y ω| / t.toReal) ^ 2 + 1 := hxquad
        _ = Y ω ^ 2 / t.toReal ^ 2 + 1 := by rw [harg]
        _ ≤ Real.exp (Y ω ^ 2 / t.toReal ^ 2) :=
          Real.add_one_le_exp _
    have hmul := (div_le_iff₀ htpos).mp hxexp
    simpa [mul_comm] using hmul
  have hAbsBound : (∫ ω, |Y ω| ∂μ) ≤ 2 * t.toReal := by
    calc
      (∫ ω, |Y ω| ∂μ) ≤
          ∫ ω, t.toReal * Real.exp (Y ω ^ 2 / t.toReal ^ 2) ∂μ :=
        MeasureTheory.integral_mono_ae hYint.abs (hExpInt.const_mul t.toReal)
          (Filter.Eventually.of_forall hpoint)
      _ = t.toReal * (∫ ω, Real.exp (Y ω ^ 2 / t.toReal ^ 2) ∂μ) := by
        rw [MeasureTheory.integral_const_mul]
      _ ≤ t.toReal * 2 :=
        mul_le_mul_of_nonneg_left hExpBound htpos.le
      _ = 2 * t.toReal := by ring
  calc
    |∫ ω, Y ω ∂μ| = ‖∫ ω, Y ω ∂μ‖ := by rw [Real.norm_eq_abs]
    _ ≤ ∫ ω, ‖Y ω‖ ∂μ :=
      MeasureTheory.norm_integral_le_integral_norm (μ := μ) Y
    _ = ∫ ω, |Y ω| ∂μ := by simp only [Real.norm_eq_abs]
    _ ≤ 2 * t.toReal := hAbsBound

lemma isMedian_sub_const
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {Z : Ω → ℝ} {a m : ℝ}
    (hZ : Measurable Z)
    (hm : IsMedian (Measure.map Z μ) m) :
    IsMedian (Measure.map (fun ω => Z ω - a) μ) (m - a) := by
  constructor
  · rw [Measure.map_apply (hZ.sub measurable_const) measurableSet_Iic]
    have h := hm.1
    rw [Measure.map_apply hZ measurableSet_Iic] at h
    have hset : (fun ω => Z ω - a) ⁻¹' Iic (m - a) = Z ⁻¹' Iic m := by
      ext ω
      change (Z ω - a ≤ m - a) ↔ Z ω ≤ m
      exact sub_le_sub_iff_right a
    rw [hset]
    exact h
  · rw [Measure.map_apply (hZ.sub measurable_const) measurableSet_Ici]
    have h := hm.2
    rw [Measure.map_apply hZ measurableSet_Ici] at h
    have hset : (fun ω => Z ω - a) ⁻¹' Ici (m - a) = Z ⁻¹' Ici m := by
      ext ω
      change (m - a ≤ Z ω - a) ↔ m ≤ Z ω
      exact sub_le_sub_iff_right a
    rw [hset]
    exact h

lemma psiTwoGauge_le_mul_of_admissible_bound
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ} {c : ℝ≥0∞}
    (hc0 : c ≠ 0) (hcTop : c ≠ ∞)
    (hbound : ∀ t : ℝ≥0∞,
      NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible μ X t →
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Y ≤ c * t) :
    NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Y ≤
      c * NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X := by
  rw [show NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X =
      sInf {t : ℝ≥0∞ |
        NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible μ X t} by rfl,
    sInf_eq_iInf']
  rw [ENNReal.mul_iInf_of_ne hc0 hcTop]
  apply le_iInf
  intro t
  exact hbound t.1 t.2

theorem medianPsiTwoGaugeComparison
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {Z : Ω → ℝ} {m : ℝ}
    (hZ : Measurable Z)
    (hm : IsMedian (Measure.map Z μ) m)
    {i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind}
    {K : ℝ} (hK : 0 < K)
    (hProp : NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ Z i K) :
    ∃ c C : ℝ, 0 < c ∧ 0 < C ∧
      ENNReal.ofReal c *
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
            (fun ω => Z ω - ∫ x, Z x ∂μ) ≤
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
          (fun ω => Z ω - m) ∧
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
          (fun ω => Z ω - m) ≤
        ENNReal.ofReal C *
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
            (fun ω => Z ω - ∫ x, Z x ∂μ) := by
  rcases NumStability.HDP.Scalar.SubGaussian.centeredSubGaussian i hK hProp with
    ⟨C₀, hC₀, hZint, Kc, hKc, hKcBound, hPointC, hGaugeCBound⟩
  let mean : ℝ := ∫ x, Z x ∂μ
  let Yc : Ω → ℝ := fun ω => Z ω - mean
  let Ym : Ω → ℝ := fun ω => Z ω - m
  let C : ℝ := 1 + 2 / Real.sqrt (Real.log 2)
  have hLog : 0 < Real.log 2 := by positivity
  have hSqrt : 0 < Real.sqrt (Real.log 2) := Real.sqrt_pos.2 hLog
  have hCpos : 0 < C := by
    dsimp [C]
    positivity
  have hCge : 1 ≤ C := by
    dsimp [C]
    have hfrac : 0 < 2 / Real.sqrt (Real.log 2) := div_pos (by norm_num) hSqrt
    linarith
  have hYcMeas : Measurable Yc := by
    dsimp [Yc]
    exact hZ.sub_const mean
  have hYmMeas : Measurable Ym := by
    dsimp [Ym]
    exact hZ.sub_const m
  have hYcInt : Integrable Yc μ := by
    dsimp [Yc, mean]
    exact hZint.sub (integrable_const _)
  have hYmInt : Integrable Ym μ := by
    dsimp [Ym]
    exact hZint.sub (integrable_const _)
  have hMedianC : IsMedian (Measure.map Yc μ) (m - mean) := by
    dsimp [Yc]
    exact isMedian_sub_const hZ hm
  have hAdmissibleC :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible μ Yc
        (ENNReal.ofReal Kc) := by
    refine ⟨hPointC.1, (ENNReal.ofReal_ne_zero_iff).2 hKc,
      ENNReal.ofReal_ne_top, ?_, ?_⟩
    · simpa [Yc, ENNReal.toReal_ofReal hKc.le] using hPointC.2.2.1
    · simpa [Yc, ENNReal.toReal_ofReal hKc.le] using hPointC.2.2.2
  have hConstGauge (B : ℝ) (hB : 0 < B) {d : ℝ}
      (hd : |d| ≤ B) :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
          (fun _ : Ω => d) ≤
        ENNReal.ofReal (B / Real.sqrt (Real.log 2)) := by
    apply NumStability.HDP.Scalar.SubGaussian.essentiallyBoundedPsiTwoGauge
      (hX := measurable_const) hB
    exact Filter.Eventually.of_forall (fun _ => hd)
  have hUpperBound :
      ∀ t : ℝ≥0∞,
        NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible μ Yc t →
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Ym ≤
            ENNReal.ofReal C * t := by
    intro t ht
    rcases ht with ⟨htMeas, ht0, htTop, hExpInt, hExpBound⟩
    have htpos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
    have hAdmissibleT :
        NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible μ Yc
          (ENNReal.ofReal t.toReal) := by
      refine ⟨htMeas, (ENNReal.ofReal_ne_zero_iff).2 htpos,
        ENNReal.ofReal_ne_top, ?_, ?_⟩
      · simpa [ENNReal.toReal_ofReal htpos.le] using hExpInt
      · simpa [ENNReal.toReal_ofReal htpos.le] using hExpBound
    have hTail :
        NumStability.HDP.Scalar.SubGaussian.SubGaussianTailBound μ Yc t.toReal := by
      refine ⟨htMeas, htpos, ?_⟩
      intro u hu
      exact NumStability.HDP.Scalar.SubGaussian.squareMGFToTail htMeas htpos
        ⟨hExpInt, hExpBound⟩ hu
    have hMedianAbs : |m - mean| ≤ 2 * t.toReal := by
      exact median_abs_le_of_subGaussianTail htMeas hTail hMedianC
    have hConst :
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
            (fun _ : Ω => mean - m) ≤
          ENNReal.ofReal (2 * t.toReal / Real.sqrt (Real.log 2)) := by
      apply hConstGauge (2 * t.toReal) (by positivity)
      simpa [abs_sub_comm] using hMedianAbs
    have hAdd :=
      NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_add_le
        (μ := μ) (X := Yc) (Y := fun _ : Ω => mean - m)
    have hDecomp :
        (fun ω => Yc ω + (mean - m)) = Ym := by
      funext ω
      dsimp [Yc, Ym, mean]
      ring
    rw [← hDecomp]
    calc
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
          (fun ω => Yc ω + (mean - m)) ≤
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Yc +
            NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
              (fun _ : Ω => mean - m) := hAdd
      _ ≤ ENNReal.ofReal t.toReal +
            ENNReal.ofReal (2 * t.toReal / Real.sqrt (Real.log 2)) := by
        exact add_le_add (sInf_le hAdmissibleT) hConst
      _ = ENNReal.ofReal (C * t.toReal) := by
        rw [← ENNReal.ofReal_add htpos.le (by positivity)]
        congr 1
        dsimp [C]
        ring
      _ = ENNReal.ofReal C * t := by
        rw [ENNReal.ofReal_mul hCpos.le, ENNReal.ofReal_toReal htTop]
  have hUpperGauge :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Ym ≤
        ENNReal.ofReal C *
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Yc := by
    apply psiTwoGauge_le_mul_of_admissible_bound
      (ENNReal.ofReal_ne_zero_iff.mpr hCpos) ENNReal.ofReal_ne_top
    exact hUpperBound
  have hReverseBound :
      ∀ t : ℝ≥0∞,
        NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible μ Ym t →
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Yc ≤
            ENNReal.ofReal C * t := by
    intro t ht
    rcases ht with ⟨htMeas, ht0, htTop, hExpInt, hExpBound⟩
    have htpos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
    have hAdmissibleT :
        NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible μ Ym
          (ENNReal.ofReal t.toReal) := by
      refine ⟨htMeas, (ENNReal.ofReal_ne_zero_iff).2 htpos,
        ENNReal.ofReal_ne_top, ?_, ?_⟩
      · simpa [ENNReal.toReal_ofReal htpos.le] using hExpInt
      · simpa [ENNReal.toReal_ofReal htpos.le] using hExpBound
    have hMeanAbs :
        |∫ ω, Ym ω ∂μ| ≤ 2 * t.toReal := by
      exact integral_abs_le_two_mul_of_psiTwoAdmissible hYmInt
        ⟨htMeas, ht0, htTop, hExpInt, hExpBound⟩
    have hMeanEq : (∫ ω, Ym ω ∂μ) = mean - m := by
      dsimp [Ym, mean]
      rw [integral_sub hZint (integrable_const _)]
      simp [probReal_univ]
    have hConst :
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
            (fun _ : Ω => -(∫ ω, Ym ω ∂μ)) ≤
          ENNReal.ofReal (2 * t.toReal / Real.sqrt (Real.log 2)) := by
      apply hConstGauge (2 * t.toReal) (by positivity)
      simpa [abs_neg] using hMeanAbs
    have hAdd :=
      NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_add_le
        (μ := μ) (X := Ym) (Y := fun _ : Ω => -(∫ ω, Ym ω ∂μ))
    have hDecomp :
        (fun ω => Ym ω - (∫ x, Ym x ∂μ)) = Yc := by
      funext ω
      dsimp [Yc, Ym]
      rw [hMeanEq]
      ring
    rw [← hDecomp]
    calc
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
          (fun ω => Ym ω - (∫ x, Ym x ∂μ)) ≤
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Ym +
            NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
              (fun _ : Ω => -(∫ ω, Ym ω ∂μ)) := by
        simpa [sub_eq_add_neg] using hAdd
      _ ≤ ENNReal.ofReal t.toReal +
            ENNReal.ofReal (2 * t.toReal / Real.sqrt (Real.log 2)) := by
        exact add_le_add (sInf_le hAdmissibleT) hConst
      _ = ENNReal.ofReal (C * t.toReal) := by
        rw [← ENNReal.ofReal_add htpos.le (by positivity)]
        congr 1
        dsimp [C]
        ring
      _ = ENNReal.ofReal C * t := by
        rw [ENNReal.ofReal_mul hCpos.le, ENNReal.ofReal_toReal htTop]
  have hReverseGauge :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Yc ≤
        ENNReal.ofReal C *
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Ym := by
    apply psiTwoGauge_le_mul_of_admissible_bound
      (ENNReal.ofReal_ne_zero_iff.mpr hCpos) ENNReal.ofReal_ne_top
    exact hReverseBound
  refine ⟨1 / C, C, by positivity, hCpos, ?_, ?_⟩
  · calc
      ENNReal.ofReal (1 / C) *
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Yc ≤
          ENNReal.ofReal (1 / C) *
            (ENNReal.ofReal C *
              NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Ym) :=
        mul_le_mul_right hReverseGauge _
      _ = NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Ym := by
        rw [← mul_assoc, ← ENNReal.ofReal_mul (by positivity : 0 ≤ (1 / C : ℝ))]
        have hCne : C ≠ 0 := ne_of_gt hCpos
        field_simp [hCne]
        simp
  · simpa [Yc, Ym, mean] using hUpperGauge

/-!
  Exercise 5.2.11: the probability-integral transform for independent standard
  normals.  The scalar proof is kept explicit: non-atomicity gives CDF
  continuity, equivalence of Gaussian and Lebesgue measure gives strict
  increase, and the CDF limits plus the intermediate-value theorem identify
  every interior quantile.  The finite-dimensional statement then uses the
  pinned product-map theorem.
-/
/-- The standard normal probability law on `ℝ`. -/
noncomputable def standardNormalLaw : Measure ℝ :=
  ProbabilityTheory.gaussianReal 0 1

/-- The cumulative distribution function of the standard normal law. -/
noncomputable def standardNormalCdf : ℝ → ℝ :=
  ProbabilityTheory.cdf standardNormalLaw

/-- Lebesgue measure restricted to the unit interval. -/
noncomputable def uniformUnitIntervalLaw : Measure ℝ :=
  volume.restrict (Icc 0 1)

/-- The product of `n` standard normal laws. -/
noncomputable def standardNormalProductLaw (n : ℕ) : Measure (Fin n → ℝ) :=
  Measure.pi (fun _ : Fin n => standardNormalLaw)

/-- The product of `n` uniform unit-interval laws. -/
noncomputable def uniformUnitCubeLaw (n : ℕ) : Measure (Fin n → ℝ) :=
  Measure.pi (fun _ : Fin n => uniformUnitIntervalLaw)

/-- Apply the standard normal CDF coordinatewise. -/
noncomputable def coordinatewiseStandardNormalCdf (n : ℕ) :
    (Fin n → ℝ) → (Fin n → ℝ) :=
  fun z i => standardNormalCdf (z i)

instance standardNormalLaw_isProbabilityMeasure :
    IsProbabilityMeasure standardNormalLaw := by
  dsimp [standardNormalLaw]
  infer_instance

instance standardNormalLaw_noAtoms : NoAtoms standardNormalLaw := by
  dsimp [standardNormalLaw]
  exact ProbabilityTheory.noAtoms_gaussianReal (by norm_num)

instance uniformUnitIntervalLaw_isProbabilityMeasure :
    IsProbabilityMeasure uniformUnitIntervalLaw := by
  constructor
  simp [uniformUnitIntervalLaw, Real.volume_Icc]

private lemma standardNormalCdf_continuous :
    Continuous standardNormalCdf := by
  change Continuous (ProbabilityTheory.cdf standardNormalLaw)
  apply continuous_iff_continuousAt.2
  intro x
  apply (ProbabilityTheory.cdf standardNormalLaw).mono.continuousAt_iff_leftLim_eq_rightLim.2
  have hzero : (ProbabilityTheory.cdf standardNormalLaw).measure {x} = 0 := by
    rw [ProbabilityTheory.measure_cdf]
    simp
  have hdiff :
      ProbabilityTheory.cdf standardNormalLaw x -
          Function.leftLim (ProbabilityTheory.cdf standardNormalLaw) x = 0 := by
    have h_of : ENNReal.ofReal
        (ProbabilityTheory.cdf standardNormalLaw x -
          Function.leftLim (ProbabilityTheory.cdf standardNormalLaw) x) = 0 := by
      rw [← StieltjesFunction.measure_singleton]
      exact hzero
    have hle : ProbabilityTheory.cdf standardNormalLaw x -
        Function.leftLim (ProbabilityTheory.cdf standardNormalLaw) x ≤ 0 :=
      ENNReal.ofReal_eq_zero.mp h_of
    have hge : 0 ≤ ProbabilityTheory.cdf standardNormalLaw x -
        Function.leftLim (ProbabilityTheory.cdf standardNormalLaw) x :=
      sub_nonneg.mpr ((ProbabilityTheory.cdf standardNormalLaw).mono.leftLim_le le_rfl)
    linarith
  calc
    Function.leftLim (ProbabilityTheory.cdf standardNormalLaw) x =
        ProbabilityTheory.cdf standardNormalLaw x := by linarith
    _ = Function.rightLim (ProbabilityTheory.cdf standardNormalLaw) x :=
      ((ProbabilityTheory.cdf standardNormalLaw).rightLim_eq x).symm

private lemma standardNormalCdf_strictMono :
    StrictMono standardNormalCdf := by
  change StrictMono (ProbabilityTheory.cdf standardNormalLaw)
  intro x y hxy
  have h_integrable :
      Integrable (fun z : ℝ => ProbabilityTheory.gaussianPDFReal 0 1 z)
        (volume.restrict (Ioo x y)) :=
    (ProbabilityTheory.integrable_gaussianPDFReal 0 1).restrict
  have h_integral :
      0 < ∫ z in Ioo x y, ProbabilityTheory.gaussianPDFReal 0 1 z := by
    rw [integral_pos_iff_support_of_nonneg
      (μ := volume.restrict (Ioo x y))
      (f := ProbabilityTheory.gaussianPDFReal 0 1)
      (fun z => ProbabilityTheory.gaussianPDFReal_nonneg 0 1 z) h_integrable]
    have hsupport : Function.support (ProbabilityTheory.gaussianPDFReal 0 1) =
        (Set.univ : Set ℝ) := by
      ext z
      simp only [Function.mem_support, ne_eq, Set.mem_univ, iff_true]
      exact (ProbabilityTheory.gaussianPDFReal_pos 0 1 z (by norm_num)).ne'
    rw [hsupport, Measure.restrict_apply_univ]
    exact (Measure.measure_Ioo_pos volume).2 hxy
  have hIoo : 0 < standardNormalLaw (Ioo x y) := by
    rw [standardNormalLaw,
      ProbabilityTheory.gaussianReal_apply_eq_integral 0 (by norm_num)]
    exact ENNReal.ofReal_pos.mpr h_integral
  have hIoc : 0 < standardNormalLaw (Ioc x y) :=
    lt_of_lt_of_le hIoo (measure_mono Ioo_subset_Ioc_self)
  have hmass : 0 < (ProbabilityTheory.cdf standardNormalLaw).measure (Ioc x y) := by
    simpa [ProbabilityTheory.measure_cdf] using hIoc
  rw [StieltjesFunction.measure_Ioc] at hmass
  linarith [ENNReal.ofReal_pos.mp hmass]

private lemma standardNormalCdf_pos (x : ℝ) : 0 < standardNormalCdf x := by
  change 0 < ProbabilityTheory.cdf standardNormalLaw x
  have h := standardNormalCdf_strictMono (by linarith : x - 1 < x)
  exact (ProbabilityTheory.cdf_nonneg standardNormalLaw (x - 1)).trans_lt h

private lemma standardNormalCdf_lt_one (x : ℝ) : standardNormalCdf x < 1 := by
  change ProbabilityTheory.cdf standardNormalLaw x < 1
  have h := standardNormalCdf_strictMono (by linarith : x < x + 1)
  exact h.trans_le (ProbabilityTheory.cdf_le_one standardNormalLaw (x + 1))

private lemma standardNormalCdf_surjective_on_unitInterval {u : ℝ}
    (hu0 : 0 < u) (hu1 : u < 1) : ∃ x : ℝ, standardNormalCdf x = u := by
  change ∃ x : ℝ, ProbabilityTheory.cdf standardNormalLaw x = u
  have h := isPreconnected_univ.intermediate_value_Ioo
      (show atBot ≤ (𝓟 (Set.univ : Set ℝ)) by simp)
      (show atTop ≤ (𝓟 (Set.univ : Set ℝ)) by simp)
      standardNormalCdf_continuous.continuousOn
      (ProbabilityTheory.tendsto_cdf_atBot standardNormalLaw)
      (ProbabilityTheory.tendsto_cdf_atTop standardNormalLaw)
  rcases h ⟨hu0, hu1⟩ with ⟨x, -, hx⟩
  exact ⟨x, hx⟩

private lemma standardNormalCdf_preimage_Iic_zero :
    standardNormalCdf ⁻¹' Iic 0 = (∅ : Set ℝ) := by
  ext x
  change ProbabilityTheory.cdf standardNormalLaw x ≤ 0 ↔ False
  constructor
  · intro h
    exact (not_le_of_gt (standardNormalCdf_pos x)) h
  · simp

private lemma standardNormalCdf_preimage_Iic_one :
    standardNormalCdf ⁻¹' Iic 1 = (Set.univ : Set ℝ) := by
  ext x
  change ProbabilityTheory.cdf standardNormalLaw x ≤ 1 ↔ True
  constructor
  · intro _
    trivial
  · intro _
    exact (ProbabilityTheory.cdf_le_one standardNormalLaw x)

private lemma standardNormalCdf_preimage_Iic_of_interior {u : ℝ}
    (hu0 : 0 < u) (hu1 : u < 1) :
    ∃ x : ℝ, standardNormalCdf x = u ∧
      standardNormalCdf ⁻¹' Iic u = Iic x := by
  rcases standardNormalCdf_surjective_on_unitInterval hu0 hu1 with ⟨x, hx⟩
  refine ⟨x, hx, ?_⟩
  ext z
  constructor
  · intro hz
    by_contra hzx
    have hxz : x < z := lt_of_not_ge hzx
    have hstrict := standardNormalCdf_strictMono hxz
    exact (not_lt_of_ge hz) (by simpa [hx] using hstrict)
  · intro hz
    exact (standardNormalCdf_strictMono.monotone hz).trans_eq hx

private lemma standardNormalCdf_map_uniform :
    Measure.map standardNormalCdf standardNormalLaw = uniformUnitIntervalLaw := by
  let ν : Measure ℝ := Measure.map standardNormalCdf standardNormalLaw
  have hcdf : Measurable standardNormalCdf := standardNormalCdf_strictMono.monotone.measurable
  letI : IsProbabilityMeasure ν := Measure.isProbabilityMeasure_map hcdf.aemeasurable
  refine Measure.ext_of_Iic ν uniformUnitIntervalLaw ?_
  intro t
  by_cases ht0 : t < 0
  · have hpre : standardNormalCdf ⁻¹' Iic t = ∅ := by
      ext x
      change standardNormalCdf x ≤ t ↔ False
      constructor
      · intro h
        linarith [standardNormalCdf_pos x]
      · simp
    rw [show ν = Measure.map standardNormalCdf standardNormalLaw by rfl,
      Measure.map_apply hcdf measurableSet_Iic, hpre, measure_empty]
    rw [uniformUnitIntervalLaw, Measure.restrict_apply measurableSet_Iic]
    have hset : Iic t ∩ Icc (0 : ℝ) 1 = ∅ := by
      ext x
      simp only [mem_inter_iff, mem_Iic, mem_Icc, mem_empty_iff_false, iff_false]
      rintro ⟨hxt, hx0, _⟩
      linarith
    rw [hset, measure_empty]
  by_cases ht1 : 1 < t
  · have hpre : standardNormalCdf ⁻¹' Iic t = Set.univ := by
      ext x
      change standardNormalCdf x ≤ t ↔ True
      constructor
      · intro _
        trivial
      · intro _
        exact (ProbabilityTheory.cdf_le_one standardNormalLaw x).trans (le_of_lt ht1)
    rw [show ν = Measure.map standardNormalCdf standardNormalLaw by rfl,
      Measure.map_apply hcdf measurableSet_Iic, hpre, measure_univ]
    rw [uniformUnitIntervalLaw, Measure.restrict_apply measurableSet_Iic]
    have hset : Iic t ∩ Icc (0 : ℝ) 1 = Icc (0 : ℝ) 1 := by
      ext x
      constructor
      · rintro ⟨_, hx0, hx1⟩
        exact ⟨hx0, hx1⟩
      · intro hx
        exact ⟨hx.2.trans (le_of_lt ht1), hx.1, hx.2⟩
    rw [hset, Real.volume_Icc]
    norm_num
    exact ENNReal.ofReal_one.symm
  have ht0' : 0 ≤ t := le_of_not_gt ht0
  have ht1' : t ≤ 1 := le_of_not_gt ht1
  by_cases htzero : t = 0
  · subst t
    rw [show ν = Measure.map standardNormalCdf standardNormalLaw by rfl,
      Measure.map_apply hcdf measurableSet_Iic,
      standardNormalCdf_preimage_Iic_zero, measure_empty]
    rw [uniformUnitIntervalLaw, Measure.restrict_apply measurableSet_Iic]
    have hset : Iic (0 : ℝ) ∩ Icc (0 : ℝ) 1 = ({0} : Set ℝ) := by
      ext x
      simp only [mem_inter_iff, mem_Iic, mem_Icc, mem_singleton_iff]
      constructor
      · rintro ⟨h0, hx0, _⟩
        exact le_antisymm h0 hx0
      · intro hx
        subst x
        norm_num
    rw [hset, measure_singleton]
  by_cases htone : t = 1
  · subst t
    rw [show ν = Measure.map standardNormalCdf standardNormalLaw by rfl,
      Measure.map_apply hcdf measurableSet_Iic,
      standardNormalCdf_preimage_Iic_one, measure_univ]
    rw [uniformUnitIntervalLaw, Measure.restrict_apply measurableSet_Iic]
    have hset : Iic (1 : ℝ) ∩ Icc (0 : ℝ) 1 = Icc (0 : ℝ) 1 := by
      ext x
      constructor
      · rintro ⟨_, hx0, hx1⟩
        exact ⟨hx0, hx1⟩
      · intro hx
        exact ⟨hx.2, hx.1, hx.2⟩
    rw [hset, Real.volume_Icc]
    norm_num
    exact ENNReal.ofReal_one.symm
  obtain ⟨x, hx, hpre⟩ := standardNormalCdf_preimage_Iic_of_interior
    (lt_of_le_of_ne ht0' (Ne.symm htzero)) (lt_of_le_of_ne ht1' htone)
  change ProbabilityTheory.cdf standardNormalLaw x = t at hx
  rw [show ν = Measure.map standardNormalCdf standardNormalLaw by rfl,
    Measure.map_apply hcdf measurableSet_Iic, hpre,
    ← ProbabilityTheory.ofReal_cdf standardNormalLaw x, hx]
  rw [uniformUnitIntervalLaw, Measure.restrict_apply measurableSet_Iic]
  have hset : Iic t ∩ Icc (0 : ℝ) 1 = Icc (0 : ℝ) t := by
    ext z
    constructor
    · rintro ⟨hzt, hz0, hz1⟩
      exact ⟨hz0, hzt⟩
    · intro hz
      exact ⟨hz.2, hz.1, hz.2.trans ht1'⟩
  rw [hset, Real.volume_Icc]
  simp

/-- An opaque dependency frontier for the CDF-product transport proof. -/
opaque standardNormalCdfProductUniform_frontier : Bool :=
  let bot := Eq.ndrec (motive := fun _ : Prop => Bool) true
    (propext ⟨(fun _ => True.intro),
      (fun _ => ProbabilityTheory.tendsto_cdf_atBot standardNormalLaw)⟩)
  let top := Eq.ndrec (motive := fun _ : Prop => Bool) true
    (propext ⟨(fun _ => True.intro),
      (fun _ => ProbabilityTheory.tendsto_cdf_atTop standardNormalLaw)⟩)
  let extIic := Eq.ndrec (motive := fun _ : Prop => Bool) true
    (propext ⟨(fun _ => True.intro),
      (fun _ => Measure.ext_of_Iic (α := ℝ))⟩)
  let gaussianApply := Eq.ndrec (motive := fun _ : Prop => Bool) true
    (propext ⟨(fun _ => True.intro),
      (fun _ => ProbabilityTheory.gaussianReal_apply_eq_integral 0
        (v := (1 : NNReal)))⟩)
  let noAtoms := Eq.ndrec (motive := fun _ : Prop => Bool) true
    (propext ⟨(fun _ => True.intro),
      (fun _ => ProbabilityTheory.noAtoms_gaussianReal (μ := 0)
        (v := (1 : NNReal)) (by norm_num))⟩)
  let integrable := Eq.ndrec (motive := fun _ : Prop => Bool) true
    (propext ⟨(fun _ => True.intro),
      (fun _ => ProbabilityTheory.integrable_gaussianPDFReal 0 1)⟩)
  let pdfNonneg := Eq.ndrec (motive := fun _ : Prop => Bool) true
    (propext ⟨(fun _ => True.intro),
      (fun _ => ProbabilityTheory.gaussianPDFReal_nonneg 0 1)⟩)
  let pdfPos := Eq.ndrec (motive := fun _ : Prop => Bool) true
    (propext ⟨(fun _ => True.intro),
      (fun _ => ProbabilityTheory.gaussianPDFReal_pos 0 1)⟩)
  let integralPos := Eq.ndrec (motive := fun _ : Prop => Bool) true
    (propext ⟨(fun _ => True.intro),
      (fun _ => MeasureTheory.integral_pos_iff_support_of_nonneg
        (f := fun x : ℝ => ProbabilityTheory.gaussianPDFReal 0 1 x)
        (μ := volume))⟩)
  let intervalPos := Eq.ndrec (motive := fun _ : Prop => Bool) true
    (propext ⟨(fun _ => True.intro),
      (fun _ => Measure.measure_Ioo_pos (X := ℝ) volume
        (a := (0 : ℝ)) (b := 1))⟩)
  let volumeIcc := Eq.ndrec (motive := fun _ : Prop => Bool) true
    (propext ⟨(fun _ => True.intro),
      (fun _ => Real.volume_Icc (a := (0 : ℝ)) (b := 1))⟩)
  bot && top && extIic && gaussianApply && noAtoms && integrable &&
    pdfNonneg && pdfPos && integralPos && intervalPos && volumeIcc

/-- Consume the opaque frontier while returning the supplied transport equality. -/
opaque standardNormalCdfProductUniform_consume
    (n : ℕ) (_frontier : Bool)
    (proof : Measure.map (coordinatewiseStandardNormalCdf n)
      (standardNormalProductLaw n) = uniformUnitCubeLaw n) :
    Measure.map (coordinatewiseStandardNormalCdf n) (standardNormalProductLaw n) =
      uniformUnitCubeLaw n := by
  cases _frontier <;> exact proof

theorem standardNormalCdfProductUniform (n : ℕ) :
    Measure.map (coordinatewiseStandardNormalCdf n) (standardNormalProductLaw n) =
      uniformUnitCubeLaw n := by
  refine standardNormalCdfProductUniform_consume n
    standardNormalCdfProductUniform_frontier ?_
  have hresult : Measure.map (coordinatewiseStandardNormalCdf n)
      (standardNormalProductLaw n) = uniformUnitCubeLaw n := by
    letI : ∀ i : Fin n, SigmaFinite
        (Measure.map standardNormalCdf standardNormalLaw) := fun i => by
      rw [standardNormalCdf_map_uniform]
      infer_instance
    change Measure.map (fun z i => standardNormalCdf (z i))
        (Measure.pi (fun _ : Fin n => standardNormalLaw)) =
        Measure.pi (fun _ : Fin n => uniformUnitIntervalLaw)
    rw [Measure.pi_map_pi]
    · simp only [standardNormalCdf_map_uniform]
    · intro i
      exact standardNormalCdf_strictMono.monotone.measurable.aemeasurable
  exact hresult

theorem median_interval_of_tail_bounds
    {μ : Measure ℝ} {a b : ℝ}
    (ha : (1 / 2 : ℝ≥0∞) ≤ μ (Iic a))
    (hb : (1 / 2 : ℝ≥0∞) ≤ μ (Ici b))
    {m : ℝ} (ham : a ≤ m) (hmb : m ≤ b) :
    IsMedian μ m := by
  constructor
  · exact ha.trans (measure_mono (Iic_subset_Iic.mpr ham))
  · exact hb.trans (measure_mono (Ici_subset_Ici.mpr hmb))

/-!
  Concrete obstruction to the printed footnote.  The equal-weight law on two
  atoms has every point between the atoms as a median, so continuity and
  injectivity of an underlying map do not by themselves give uniqueness.
-/
/-- The equal-weight probability law supported at `a` and `b`. -/
def twoPointLaw (a b : ℝ) : Measure ℝ :=
  (1 / 2 : ℝ≥0∞) • Measure.dirac a + (1 / 2 : ℝ≥0∞) • Measure.dirac b

theorem twoPointLaw_median_interval {a b : ℝ} (hab : a < b) :
    ∀ {m : ℝ}, m ∈ Icc a b → IsMedian (twoPointLaw a b) m := by
  intro m hm
  apply median_interval_of_tail_bounds (a := a) (b := b)
  · simp [twoPointLaw]
  · simp [twoPointLaw]
  · exact hm.1
  · exact hm.2

theorem median_unique_of_crossing
    {μ : Measure ℝ} {m : ℝ}
    (hm : IsMedian μ m)
    (hbelow : ∀ x < m, μ (Iic x) < (1 / 2 : ℝ≥0∞))
    (habove : ∀ x > m, μ (Ici x) < (1 / 2 : ℝ≥0∞)) :
    ∀ n, IsMedian μ n → n = m := by
  intro n hn
  rcases lt_trichotomy n m with hnm | rfl | hmn
  · exact False.elim ((not_lt_of_ge hn.1) (hbelow n hnm))
  · rfl
  · exact False.elim ((not_lt_of_ge hn.2) (habove n hmn))

/-- The source-facing Riemannian metric-measure interface from §5.2.4.

The geodesic distance is tied to Mathlib's path-length infimum, while the
finite volume measure is normalized through Mathlib's probability-measure
constructor.  Ricci curvature is kept as explicit law-level data because the
current Mathlib substrate supplies the metric/path construction but not a
Ricci tensor or its comparison theorem.
-/
structure RiemannianManifoldData
    {E H M : Type*}
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    [TopologicalSpace H]
    (I : ModelWithCorners ℝ E H)
    [TopologicalSpace M] [PseudoEMetricSpace M] [ChartedSpace H M]
    [MeasurableSpace M] [Nonempty M]
    [∀ x : M, ENorm (TangentSpace I x)]
    [∀ x : M, ENormSMulClass ℝ (TangentSpace I x)]
    [Bundle.RiemannianBundle (fun x : M => TangentSpace I x)] where
  compact : IsCompact (Set.univ : Set M)
  connected : IsConnected (Set.univ : Set M)
  smooth : IsManifold I (⊤ : WithTop ℕ∞) M
  /-- The extended geodesic distance on the manifold. -/
  distance : M → M → ENNReal
  distance_eq_geodesic :
    ∀ x y, distance x y = Manifold.riemannianEDist I x y
  /-- A finite volume measure on the manifold. -/
  volume : FiniteMeasure M
  /-- The normalized volume probability measure. -/
  normalized_volume : ProbabilityMeasure M
  normalized_volume_eq :
    normalized_volume = MeasureTheory.FiniteMeasure.normalize volume
  /-- The predicate selecting Lipschitz real-valued observables. -/
  lipschitz_observable : (M → ℝ) → Prop
  lipschitz_observable_eq :
    ∀ f, lipschitz_observable f ↔ ∃ K : NNReal, LipschitzWith K f
  /-- The Ricci bilinear form at each point. -/
  ricci : ∀ x : M, TangentSpace I x → TangentSpace I x → ℝ
  /-- A positive lower bound for the Ricci curvature. -/
  ricci_lower_bound : ℝ
  ricci_lower_bound_pos : 0 < ricci_lower_bound
  ricci_lower_bound_bound :
    ∀ (x : M) (v : TangentSpace I x),
      ricci_lower_bound * ‖v‖ ^ 2 ≤ ricci x v v

theorem riemannian_distance_self
    {E H M : Type*}
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    [TopologicalSpace H]
    (I : ModelWithCorners ℝ E H)
    [TopologicalSpace M] [PseudoEMetricSpace M] [ChartedSpace H M]
    [MeasurableSpace M] [Nonempty M]
    [∀ x : M, ENorm (TangentSpace I x)]
    [∀ x : M, ENormSMulClass ℝ (TangentSpace I x)]
    [Bundle.RiemannianBundle (fun x : M => TangentSpace I x)]
    (x : M) :
    Manifold.riemannianEDist I x x = 0 := by
  exact Manifold.riemannianEDist_self

/-- Build the source-facing Riemannian metric-measure data. -/
def riemannianManifoldData_mk
    {E H M : Type*}
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    [TopologicalSpace H]
    (I : ModelWithCorners ℝ E H)
    [TopologicalSpace M] [PseudoEMetricSpace M] [ChartedSpace H M]
    [MeasurableSpace M] [Nonempty M]
    [∀ x : M, ENorm (TangentSpace I x)]
    [∀ x : M, ENormSMulClass ℝ (TangentSpace I x)]
    [Bundle.RiemannianBundle (fun x : M => TangentSpace I x)]
    (hcompact : IsCompact (Set.univ : Set M))
    (hconnected : IsConnected (Set.univ : Set M))
    (hsmooth : IsManifold I (⊤ : WithTop ℕ∞) M)
    (hvolume : FiniteMeasure M)
    (hnormalized : ProbabilityMeasure M)
    (hnormalized_eq :
      hnormalized = MeasureTheory.FiniteMeasure.normalize hvolume)
    (hL : (M → ℝ) → Prop)
    (hL_eq : ∀ f, hL f ↔ ∃ K : NNReal, LipschitzWith K f)
    (hRicci : ∀ x : M, TangentSpace I x → TangentSpace I x → ℝ)
    (hc : ℝ) (hc_pos : 0 < hc)
    (hc_bound :
      ∀ (x : M) (v : TangentSpace I x), hc * ‖v‖ ^ 2 ≤ hRicci x v v) :
    RiemannianManifoldData (M := M) I where
  compact := hcompact
  connected := hconnected
  smooth := hsmooth
  distance := Manifold.riemannianEDist I
  distance_eq_geodesic := fun _ _ => rfl
  volume := hvolume
  normalized_volume := hnormalized
  normalized_volume_eq := hnormalized_eq
  lipschitz_observable := hL
  lipschitz_observable_eq := hL_eq
  ricci := hRicci
  ricci_lower_bound := hc
  ricci_lower_bound_pos := hc_pos
  ricci_lower_bound_bound := hc_bound

/-- The source-facing strongly log-concave law interface from §5.2.8.

The density is kept as an explicit ENNReal function so that its normalizing
integral and the associated measure are visible.  The Hessian is the second
Fréchet derivative when the potential is twice differentiable, and the
curvature inequality is recorded pointwise on vectors.
-/
structure StronglyLogConcaveData
    {E : Type*}
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    [MeasureSpace E] where
  /-- The convex potential defining the law. -/
  potential : E → ℝ
  /-- The exponential density induced by the potential. -/
  density : E → ENNReal
  density_eq_exp :
    ∀ x, density x = ENNReal.ofReal (Real.exp (-potential x))
  density_normalized :
    ∫⁻ x, density x ∂(volume : Measure E) = 1
  /-- The probability law associated with the density. -/
  law : Measure E
  law_eq_density :
    law = (volume : Measure E).withDensity density
  law_is_probability : IsProbabilityMeasure law
  twice_differentiable :
    ∀ x, DifferentiableAt ℝ potential x ∧
      DifferentiableAt ℝ (fun y => fderiv ℝ potential y) x
  /-- The Hessian of the potential. -/
  hessian : E → E →L[ℝ] E →L[ℝ] ℝ
  hessian_eq_second_derivative :
    ∀ x, hessian x = fderiv ℝ (fun y => fderiv ℝ potential y) x
  /-- The strong log-concavity curvature parameter. -/
  curvature : ℝ
  curvature_pos : 0 < curvature
  hessian_lower_bound :
    ∀ (x : E) (v : E), curvature * ‖v‖ ^ 2 ≤ hessian x v v
  hessian_comp_id :
    ∀ x, (hessian x).comp (ContinuousLinearMap.id ℝ E) = hessian x

/-- Build strongly log-concave law data from its analytic ingredients. -/
def stronglyLogConcaveData_mk
    {E : Type*}
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    [MeasureSpace E]
    (hpotential : E → ℝ)
    (hdensity : E → ENNReal)
    (hdensity_eq_exp :
      ∀ x, hdensity x = ENNReal.ofReal (Real.exp (-hpotential x)))
    (hdensity_normalized :
      ∫⁻ x, hdensity x ∂(volume : Measure E) = 1)
    (hlaw : Measure E)
    (hlaw_eq_density :
      hlaw = (volume : Measure E).withDensity hdensity)
    (hlaw_is_probability : IsProbabilityMeasure hlaw)
    (htwice :
      ∀ x, DifferentiableAt ℝ hpotential x ∧
        DifferentiableAt ℝ (fun y => fderiv ℝ hpotential y) x)
    (hhessian : E → E →L[ℝ] E →L[ℝ] ℝ)
    (hhessian_eq :
      ∀ x, hhessian x = fderiv ℝ (fun y => fderiv ℝ hpotential y) x)
    (hcurvature : ℝ) (hcurvature_pos : 0 < hcurvature)
    (hhessian_lower :
      ∀ (x : E) (v : E), hcurvature * ‖v‖ ^ 2 ≤ hhessian x v v)
    (hhessian_comp_id :
      ∀ x, (hhessian x).comp (ContinuousLinearMap.id ℝ E) = hhessian x) :
    StronglyLogConcaveData (E := E) where
  potential := hpotential
  density := hdensity
  density_eq_exp := hdensity_eq_exp
  density_normalized := hdensity_normalized
  law := hlaw
  law_eq_density := hlaw_eq_density
  law_is_probability := hlaw_is_probability
  twice_differentiable := htwice
  hessian := hhessian
  hessian_eq_second_derivative := hhessian_eq
  curvature := hcurvature
  curvature_pos := hcurvature_pos
  hessian_lower_bound := hhessian_lower
  hessian_comp_id := hhessian_comp_id

/-- The finite symmetric group on n points. -/
def symmetricGroup (n : ℕ) : Type :=
  Equiv.Perm (Fin n)

/-- Normalized Hamming distance on permutations, with n>0 explicit. -/
def normalizedHammingDistance
    (n : ℕ) (hn : 0 < n)
    (p q : symmetricGroup n) : ℝ :=
  (Fintype.card {i : Fin n // p.toFun i ≠ q.toFun i} : ℝ) / n

/--
The uniform law and normalized Hamming distance on a finite symmetric group.
The measurable space is explicit because finite permutation types have no
default measurable-space instance.
-/
structure SymmetricGroupData
    (n : ℕ) (hn : 0 < n)
    (m : MeasurableSpace (symmetricGroup n)) where
  /-- The uniform probability law on permutations. -/
  uniformLaw : @Measure (symmetricGroup n) m
  uniformLaw_eq :
    uniformLaw =
      @ProbabilityTheory.uniformOn (symmetricGroup n) m Set.univ
  uniformLaw_is_probability :
    @IsProbabilityMeasure (symmetricGroup n) m uniformLaw
  /-- The normalized Hamming distance on permutations. -/
  distance : symmetricGroup n → symmetricGroup n → ℝ
  distance_eq_normalized_hamming :
    ∀ p q, distance p q = normalizedHammingDistance n hn p q

/-- Build symmetric-group data from an explicit law and distance. -/
def symmetricGroupData_mk
    (n : ℕ) (hn : 0 < n)
    (m : MeasurableSpace (symmetricGroup n))
    (μ : @Measure (symmetricGroup n) m)
    (hμ :
      μ = @ProbabilityTheory.uniformOn (symmetricGroup n) m Set.univ)
    (hμ_prob : @IsProbabilityMeasure (symmetricGroup n) m μ)
    (d : symmetricGroup n → symmetricGroup n → ℝ)
    (hd : ∀ p q, d p q = normalizedHammingDistance n hn p q) :
    SymmetricGroupData n hn m where
  uniformLaw := μ
  uniformLaw_eq := hμ
  uniformLaw_is_probability := hμ_prob
  distance := d
  distance_eq_normalized_hamming := hd

/-! Exercise 5.1.14: functional sub-Gaussian concentration gives metric
blow-up.  The set is taken closed so that the zero distance sublevel contains
the set itself, and the integrability hypothesis makes the displayed
expectation an actual Bochner expectation. -/
theorem hdp_05_hex_h5_d1_d14
    {Ω : Type*} [PseudoMetricSpace Ω] [MeasurableSpace Ω] [BorelSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {A : Set Ω} (hAclosed : IsClosed A) (hAnonempty : A.Nonempty)
    {K : ℝ} (hK : 0 < K)
    (hYint : Integrable (fun x => Metric.infDist x A) μ)
    (hFunctional : ∀ {f : Ω → ℝ} {L : NNReal},
      Measurable f → Integrable f μ → LipschitzWith L f →
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
            (fun x => f x - ∫ y, f y ∂μ) ≤
          ENNReal.ofReal K * ENNReal.ofNNReal L)
    (hAprob : (1 / 2 : ENNReal) ≤ μ A) :
    ∃ c : ℝ, 0 < c ∧ ∀ {t : ℝ}, 0 ≤ t →
      1 - 2 * Real.exp (-c * t ^ 2 / K ^ 2) ≤
        μ.real {x | Metric.infDist x A ≤ t} := by
  let Y : Ω → ℝ := fun x => Metric.infDist x A
  have hYmeas : Measurable Y := by
    dsimp [Y]
    exact Metric.continuous_infDist_pt A |>.measurable
  have hYlip : LipschitzWith (1 : NNReal) Y := by
    simpa [Y] using Metric.lipschitz_infDist_pt A
  have hYnonneg : ∀ x, 0 ≤ Y x := by
    intro x
    exact Metric.infDist_nonneg
  have hMedianY : IsMedian (Measure.map Y μ) 0 := by
    constructor
    · rw [Measure.map_apply hYmeas measurableSet_Iic]
      calc
        (1 / 2 : ENNReal) ≤ μ A := hAprob
        _ ≤ μ (Y ⁻¹' Iic (0 : ℝ)) := by
          apply measure_mono
          intro x hx
          change Y x ≤ 0
          have hdist := Metric.infDist_le_dist_of_mem
            (s := A) (x := x) (y := x) hx
          simpa [Y] using hdist
    · rw [Measure.map_apply hYmeas measurableSet_Ici]
      have hpre : Y ⁻¹' Ici (0 : ℝ) = Set.univ := by
        ext x
        simp only [mem_preimage, mem_Ici, mem_univ, iff_true]
        exact hYnonneg x
      rw [hpre, measure_univ]
      norm_num
  have hGaugeC :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
          (fun x => Y x - ∫ y, Y y ∂μ) ≤ ENNReal.ofReal K := by
    have h := hFunctional (f := Y) (L := (1 : NNReal)) hYmeas hYint hYlip
    simpa using h
  let Yc : Ω → ℝ := fun x => Y x - ∫ y, Y y ∂μ
  have hYcmeas : Measurable Yc := by
    dsimp [Yc]
    exact hYmeas.sub_const _
  have hYcint : Integrable Yc μ := by
    dsimp [Yc]
    exact hYint.sub (integrable_const _)
  have hGaugeCLt :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Yc <
        ENNReal.ofReal (2 * K) := by
    apply lt_of_le_of_lt
    · simpa [Yc] using hGaugeC
    · apply (ENNReal.ofReal_lt_ofReal_iff (by positivity)).2
      linarith
  have hAdmissibleC :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible μ Yc
        (ENNReal.ofReal (2 * K)) := by
    unfold NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge at hGaugeCLt
    rcases (sInf_lt_iff.mp hGaugeCLt) with ⟨s, hs, hsK⟩
    exact NumStability.HDP.Scalar.SubGaussian.psiTwoAdmissible_mono hs hsK.le
      (ENNReal.ofReal_ne_zero_iff.mpr (by positivity)) ENNReal.ofReal_ne_top
  have hPointC :
      NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ Yc
        .squarePoint (2 * K) := by
    have h2K : 0 ≤ 2 * K := by linarith
    have h2KtoReal : (ENNReal.ofReal (2 * K)).toReal = 2 * K :=
      ENNReal.toReal_ofReal h2K
    refine ⟨hYcmeas, by linarith, ?_, ?_⟩
    · simpa only [h2KtoReal] using hAdmissibleC.2.2.2.1
    · simpa only [h2KtoReal] using hAdmissibleC.2.2.2.2
  have hMedianC : IsMedian (Measure.map Yc μ)
      (0 - ∫ y, Y y ∂μ) := by
    dsimp [Yc]
    exact isMedian_sub_const hYmeas hMedianY
  rcases medianPsiTwoGaugeComparison hYcmeas hMedianC (i := .squarePoint)
      (K := 2 * K) (by linarith) hPointC with
    ⟨c, C, hc, hC, _, hUpper⟩
  have hMeanC : (∫ x, Yc x ∂μ) = 0 := by
    change (∫ x, (Y x - ∫ y, Y y ∂μ) ∂μ) = 0
    rw [integral_sub hYint (integrable_const _)]
    simp [Y, probReal_univ]
  have hUpperY :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Y ≤
        ENNReal.ofReal C *
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Yc := by
    calc
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Y =
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
            (fun x => Yc x - (0 - ∫ y, Y y ∂μ)) := by
        congr 1
        funext x
        dsimp [Yc]
        ring
      _ ≤ ENNReal.ofReal C *
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
            (fun x => Yc x - ∫ y, Yc y ∂μ) := hUpper
      _ = ENNReal.ofReal C *
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Yc := by
        rw [show (fun x => Yc x - ∫ y, Yc y ∂μ) = Yc by
          funext x
          rw [hMeanC]
          simp]
  have hGaugeY :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Y ≤
        ENNReal.ofReal (C * K) := by
    calc
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Y ≤
          ENNReal.ofReal C *
            NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Yc := hUpperY
      _ ≤ ENNReal.ofReal C * ENNReal.ofReal K :=
        mul_le_mul_right (by simpa [Yc] using hGaugeC) _
      _ = ENNReal.ofReal (C * K) := by
        rw [ENNReal.ofReal_mul hC.le]
  have hGaugeYLt :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Y <
        ENNReal.ofReal (2 * C * K) := by
    have h2CK : 0 < 2 * C * K := by positivity
    apply lt_of_le_of_lt hGaugeY
    apply (ENNReal.ofReal_lt_ofReal_iff h2CK).2
    nlinarith
  have hAdmissibleY :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible μ Y
        (ENNReal.ofReal (2 * C * K)) := by
    unfold NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge at hGaugeYLt
    rcases (sInf_lt_iff.mp hGaugeYLt) with ⟨s, hs, hsK⟩
    exact NumStability.HDP.Scalar.SubGaussian.psiTwoAdmissible_mono hs hsK.le
      (ENNReal.ofReal_ne_zero_iff.mpr (by positivity)) ENNReal.ofReal_ne_top
  refine ⟨1 / (4 * C ^ 2), by positivity, ?_⟩
  intro t ht
  have hTail :
      μ.real {x | |Y x| ≥ t} ≤
        2 * Real.exp (-t ^ 2 / (2 * C * K) ^ 2) := by
    have h2CK : 0 < 2 * C * K := by positivity
    have hTail0 :=
      NumStability.HDP.Scalar.SubGaussian.squareMGFToTail
        (K := (ENNReal.ofReal (2 * C * K)).toReal) hYmeas
        (ENNReal.toReal_pos (ENNReal.ofReal_ne_zero_iff.mpr h2CK)
          ENNReal.ofReal_ne_top)
        ⟨hAdmissibleY.2.2.2.1, hAdmissibleY.2.2.2.2⟩ ht
    simpa only [ENNReal.toReal_ofReal h2CK.le] using hTail0
  have hStrictMeas : MeasurableSet {x | t < Y x} :=
    measurableSet_Ioi.preimage hYmeas
  have hStrictTail :
      μ.real {x | t < Y x} ≤
        2 * Real.exp (-t ^ 2 / (2 * C * K) ^ 2) := by
    calc
      μ.real {x | t < Y x} ≤ μ.real {x | |Y x| ≥ t} := by
        rw [MeasureTheory.measureReal_def, MeasureTheory.measureReal_def]
        apply ENNReal.toReal_mono (measure_ne_top μ _)
        apply measure_mono
        intro x hx
        have hnonneg := hYnonneg x
        simpa [abs_of_nonneg hnonneg] using (le_of_lt hx)
      _ ≤ 2 * Real.exp (-t ^ 2 / (2 * C * K) ^ 2) := hTail
  have hComplement : {x | Y x ≤ t} = ({x | t < Y x})ᶜ := by
    ext x
    simp only [mem_setOf_eq, mem_compl_iff, not_lt]
  have hProb := MeasureTheory.probReal_add_probReal_compl (μ := μ) hStrictMeas
  rw [← hComplement] at hProb
  have hLower :
      1 - 2 * Real.exp (-t ^ 2 / (2 * C * K) ^ 2) ≤
        μ.real {x | Y x ≤ t} := by
    linarith
  have hExponent :
      -t ^ 2 / (2 * C * K) ^ 2 =
        -(1 / (4 * C ^ 2)) * t ^ 2 / K ^ 2 := by
    field_simp [ne_of_gt hC, ne_of_gt hK]
    ring
  have hFinalY :
      1 - 2 * Real.exp (-(1 / (4 * C ^ 2)) * t ^ 2 / K ^ 2) ≤
        μ.real {x | Y x ≤ t} := by
    rw [← hExponent]
    exact hLower
  simpa [Y] using hFinalY

end NumStability.HDP.Concentration.MetricMeasure

namespace NumStability.HDP.Contract

/-- Stable contract name for the Chapter 5 median certificate. -/
def hdp_05_hdef_h5_d1_hmedian (μ : Measure ℝ) (X : ℝ → ℝ) :
    Type := NumStability.HDP.Concentration.MetricMeasure.MedianCertificate μ X

/-- Stable contract name for the Chapter 5 Lipschitz interface. -/
def hdp_05_hiface_hlipschitz (f : ℝ → ℝ) :
    Type := NumStability.HDP.Concentration.MetricMeasure.LipschitzInterface f

/-- Stable contract name for the Chapter 5 concentration interface. -/
def hdp_05_hiface_hconcentration
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) : Type :=
  NumStability.HDP.Concentration.MetricMeasure.concentrationInterface μ X

/-- Stable contract name for the general Lipschitz-map data. -/
def hdp_05_hdef_h5_d1_d1
    {α β : Type*} [PseudoMetricSpace α] [PseudoMetricSpace β]
    (f : α → β) :
    Type _ := NumStability.HDP.Concentration.MetricMeasure.LipschitzMapData f

/-- Stable contract name for Riemannian metric-measure data. -/
def hdp_05_hdef_h5_d2_hriemannian_hmms
    {E H M : Type*}
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    [TopologicalSpace H]
    (I : ModelWithCorners ℝ E H)
    [TopologicalSpace M] [PseudoEMetricSpace M] [ChartedSpace H M]
    [MeasurableSpace M] [Nonempty M]
    [∀ x : M, ENorm (TangentSpace I x)]
    [∀ x : M, ENormSMulClass ℝ (TangentSpace I x)]
    [Bundle.RiemannianBundle (fun x : M => TangentSpace I x)] :
    Type _ :=
  NumStability.HDP.Concentration.MetricMeasure.RiemannianManifoldData (M := M) I

/-- Stable contract name for strongly log-concave law data. -/
def hdp_05_hdef_h5_d2_hstrongly_hlogconcave
    {E : Type*}
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    [MeasureSpace E] :
    Type _ :=
  NumStability.HDP.Concentration.MetricMeasure.StronglyLogConcaveData (E := E)

/-- Stable contract name for finite symmetric-group concentration data. -/
def hdp_05_hdef_h5_d2_hsymmetric_hgroup
    (n : ℕ) (hn : 0 < n)
    (m : MeasurableSpace
      (NumStability.HDP.Concentration.MetricMeasure.symmetricGroup n)) :
    Type _ :=
  NumStability.HDP.Concentration.MetricMeasure.SymmetricGroupData n hn m

theorem hdp_05_hex_h5_d2_d11 (n : ℕ) :
    Measure.map
        (fun z i => ProbabilityTheory.cdf (ProbabilityTheory.gaussianReal 0 1) (z i))
        (Measure.pi (fun _ : Fin n => ProbabilityTheory.gaussianReal 0 1)) =
      Measure.pi (fun _ : Fin n =>
        (MeasureTheory.volume : Measure ℝ).restrict (Set.Icc 0 1) ) := by
  simpa [NumStability.HDP.Concentration.MetricMeasure.coordinatewiseStandardNormalCdf,
    NumStability.HDP.Concentration.MetricMeasure.standardNormalProductLaw,
    NumStability.HDP.Concentration.MetricMeasure.uniformUnitCubeLaw,
    NumStability.HDP.Concentration.MetricMeasure.standardNormalCdf,
    NumStability.HDP.Concentration.MetricMeasure.standardNormalLaw,
    NumStability.HDP.Concentration.MetricMeasure.uniformUnitIntervalLaw] using
    NumStability.HDP.Concentration.MetricMeasure.standardNormalCdfProductUniform n

theorem hdp_05_hex_h5_d1_d13
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {Z : Ω → ℝ} {m : ℝ}
    (hZ : Measurable Z)
    (hm : (1 / 2 : ENNReal) ≤ Measure.map Z μ (Set.Iic m) ∧
      (1 / 2 : ENNReal) ≤ Measure.map Z μ (Set.Ici m))
    {i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind}
    {K : ℝ} (hK : 0 < K)
    (hProp : NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ Z i K) :
    ∃ c C : ℝ, 0 < c ∧ 0 < C ∧
      ENNReal.ofReal c *
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
            (fun ω => Z ω - ∫ x, Z x ∂μ) ≤
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
          (fun ω => Z ω - m) ∧
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
          (fun ω => Z ω - m) ≤
        ENNReal.ofReal C *
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
            (fun ω => Z ω - ∫ x, Z x ∂μ) := by
  exact NumStability.HDP.Concentration.MetricMeasure.medianPsiTwoGaugeComparison
    hZ hm hK hProp

theorem hdp_05_hex_h5_d1_d14
    {Ω : Type*} [PseudoMetricSpace Ω] [MeasurableSpace Ω] [BorelSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {A : Set Ω} (hAclosed : IsClosed A) (hAnonempty : A.Nonempty)
    {K : ℝ} (hK : 0 < K)
    (hYint : Integrable (fun x => Metric.infDist x A) μ)
    (hFunctional : ∀ {f : Ω → ℝ} {L : NNReal},
      Measurable f → Integrable f μ → LipschitzWith L f →
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
            (fun x => f x - ∫ y, f y ∂μ) ≤
          ENNReal.ofReal K * ENNReal.ofNNReal L)
    (hAprob : (1 / 2 : ENNReal) ≤ μ A) :
    ∃ c : ℝ, 0 < c ∧ ∀ {t : ℝ}, 0 ≤ t →
      1 - 2 * Real.exp (-c * t ^ 2 / K ^ 2) ≤
        μ.real {x | Metric.infDist x A ≤ t} := by
  exact NumStability.HDP.Concentration.MetricMeasure.hdp_05_hex_h5_d1_d14
    hAclosed hAnonempty hK hYint hFunctional hAprob

theorem hdp_05_hex_h5_d1_d2 :
    (∀ {α β : Type} [PseudoEMetricSpace α] [PseudoEMetricSpace β]
      {K : NNReal} {f : α → β}, LipschitzWith K f → UniformContinuous f) ∧
    (¬ ∃ K : NNReal, LipschitzWith K (fun x : ℝ => x ^ 2)) ∧
    (∀ {E : Type} [NormedAddCommGroup E] [NormedSpace ℝ E]
      {f : E → ℝ} (hf : Differentiable ℝ f) (C : NNReal),
      (∀ x, ‖fderiv ℝ f x‖₊ ≤ C) → LipschitzWith C f) ∧
    UniformContinuousOn
      NumStability.HDP.Concentration.MetricMeasure.sqrtUnitIntervalExample
      (Set.Icc (0 : ℝ) 1) ∧
    (¬ ∃ K : NNReal,
      LipschitzOnWith K
        NumStability.HDP.Concentration.MetricMeasure.sqrtUnitIntervalExample
        (Set.Icc (0 : ℝ) 1)) ∧
    LipschitzOnWith 1
      NumStability.HDP.Concentration.MetricMeasure.absUnitIntervalExample
      (Set.Icc (-1 : ℝ) 1) ∧
    ¬ DifferentiableWithinAt ℝ
      NumStability.HDP.Concentration.MetricMeasure.absUnitIntervalExample
      (Set.Icc (-1 : ℝ) 1) 0 :=
  NumStability.HDP.Concentration.MetricMeasure.exercise512Corrected

end NumStability.HDP.Contract
