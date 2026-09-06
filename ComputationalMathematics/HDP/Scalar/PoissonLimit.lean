import ComputationalMathematics.HDP.Scalar.CentralLimit
import ComputationalMathematics.HDP.Scalar.Preliminaries
import Mathlib.Analysis.SpecialFunctions.Complex.LogBounds

/-!
# Poisson-limit foundations

Reusable deterministic estimates for triangular arrays of rare-event
parameters.  These isolate the first analytic reduction in the Poisson limit
theorem: the maximum-probability and total-mean hypotheses force the sum of
squared probabilities to vanish.
-/

noncomputable section

open Filter
open scoped Topology BigOperators NNReal

namespace NumStability.HDP.Scalar.LimitTheorems

/-- The characteristic function of the canonical real Bernoulli law. -/
theorem bernoulliRealPMF_charFun
    (p : ℝ≥0) (hp : p ≤ 1) (t : ℝ) :
    MeasureTheory.charFun (bernoulliRealPMF p hp).toMeasure t =
      1 + (p : ℂ) * (Complex.exp ((t : ℂ) * Complex.I) - 1) := by
  rw [MeasureTheory.charFun_apply_real, bernoulliRealPMF,
    ← PMF.toMeasure_map (cond · (1 : ℝ) 0) (PMF.bernoulli p hp) (by fun_prop)]
  rw [MeasureTheory.integral_map (measurable_of_countable _).aemeasurable (by fun_prop)]
  rw [PMF.integral_eq_sum]
  simp [PMF.bernoulli_apply, NNReal.coe_sub hp]
  have hmod :
      (instInnerProductSpaceRealComplex.toNormedSpace.toModule : Module ℝ ℂ) =
        Module.complexToReal ℂ := by
    apply Module.ext
    funext r z
    apply Complex.ext <;> rfl
  rw [hmod]
  rw [← Complex.coe_smul, ← Complex.coe_smul]
  simp [smul_eq_mul]
  ring

/-- The Poisson law, transported from the natural numbers to the real line. -/
noncomputable def poissonRealLaw (rate : ℝ≥0) : MeasureTheory.Measure ℝ :=
  (poissonLaw rate).map (fun k : ℕ => (k : ℝ))

instance poissonRealLaw.isProbabilityMeasure (rate : ℝ≥0) :
    MeasureTheory.IsProbabilityMeasure (poissonRealLaw rate) := by
  unfold poissonRealLaw
  exact MeasureTheory.Measure.isProbabilityMeasure_map
    (measurable_of_countable _).aemeasurable

/-- The real Poisson law bundled as a probability measure. -/
noncomputable def poissonRealProbabilityMeasure
    (rate : ℝ≥0) : MeasureTheory.ProbabilityMeasure ℝ :=
  ⟨poissonRealLaw rate, inferInstance⟩

/-- The characteristic function of the real Poisson law is
`exp (rate * (exp (t * I) - 1))`. -/
theorem poissonRealLaw_charFun (rate : ℝ≥0) (t : ℝ) :
    MeasureTheory.charFun (poissonRealLaw rate) t =
      Complex.exp ((rate : ℂ) * (Complex.exp ((t : ℂ) * Complex.I) - 1)) := by
  rw [MeasureTheory.charFun_apply_real, poissonRealLaw,
    MeasureTheory.integral_map (measurable_of_countable _).aemeasurable (by fun_prop)]
  rw [poissonLaw, ProbabilityTheory.poissonMeasure]
  have hInt :
      MeasureTheory.Integrable
        (fun k : ℕ => Complex.exp ((t : ℂ) * (k : ℝ) * Complex.I))
        (ProbabilityTheory.poissonPMF rate).toMeasure := by
    apply
      (MeasureTheory.integrable_const
        (μ := (ProbabilityTheory.poissonPMF rate).toMeasure) (1 : ℂ)).mono
    · fun_prop
    · filter_upwards
      intro k
      rw [Complex.norm_exp]
      simp [Complex.mul_re]
  rw [PMF.integral_eq_tsum _ _ hInt]
  have hmod :
      (instInnerProductSpaceRealComplex.toNormedSpace.toModule : Module ℝ ℂ) =
        Module.complexToReal ℂ := by
    apply Module.ext
    funext r z
    apply Complex.ext <;> rfl
  rw [hmod]
  simp_rw [← Complex.coe_smul, smul_eq_mul]
  have hpmf (a : ℕ) :
      ((ProbabilityTheory.poissonPMF rate) a).toReal =
        ProbabilityTheory.poissonPMFReal rate a := by
    rw [ProbabilityTheory.poissonPMF]
    exact ENNReal.toReal_ofReal ProbabilityTheory.poissonPMFReal_nonneg
  simp_rw [hpmf]
  have hterm (a : ℕ) :
      (ProbabilityTheory.poissonPMFReal rate a : ℂ) *
          Complex.exp ((t : ℂ) * (a : ℝ) * Complex.I) =
        Complex.exp (-(rate : ℂ)) *
          (((rate : ℂ) * Complex.exp ((t : ℂ) * Complex.I)) ^ a /
            (Nat.factorial a : ℂ)) := by
    rw [ProbabilityTheory.poissonPMFReal]
    push_cast
    have hexp :
        Complex.exp ((t : ℂ) * (a : ℂ) * Complex.I) =
          Complex.exp ((t : ℂ) * Complex.I) ^ a := by
      rw [← Complex.exp_nat_mul]
      congr 1
      ring

    rw [hexp, mul_pow]
    ring
  calc
    (∑' a : ℕ, (ProbabilityTheory.poissonPMFReal rate a : ℂ) *
        Complex.exp ((t : ℂ) * (a : ℝ) * Complex.I)) =
      ∑' a : ℕ, Complex.exp (-(rate : ℂ)) *
        (((rate : ℂ) * Complex.exp ((t : ℂ) * Complex.I)) ^ a /
          (Nat.factorial a : ℂ)) := tsum_congr hterm
    _ = Complex.exp (-(rate : ℂ)) *
        ∑' a : ℕ, (((rate : ℂ) * Complex.exp ((t : ℂ) * Complex.I)) ^ a /
          (Nat.factorial a : ℂ)) := tsum_mul_left
    _ = Complex.exp (-(rate : ℂ)) *
        Complex.exp ((rate : ℂ) * Complex.exp ((t : ℂ) * Complex.I)) := by
      congr 1
      exact
        (NormedSpace.expSeries_div_hasSum_exp
          ((rate : ℂ) * Complex.exp ((t : ℂ) * Complex.I))).tsum_eq.trans
          (congr_fun Complex.exp_eq_exp_ℂ
            ((rate : ℂ) * Complex.exp ((t : ℂ) * Complex.I))).symm
    _ = Complex.exp ((rate : ℂ) * (Complex.exp ((t : ℂ) * Complex.I) - 1)) := by
      rw [← Complex.exp_add]
      congr 1
      ring

/-! ## Heterogeneous Bernoulli rows -/

/-- The product weight of a Boolean realization of one heterogeneous
Bernoulli row. -/
private def poissonBernoulliRowWeight
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (N : ℕ)
    (f : Fin (N + 1) → Bool) : ENNReal :=
  ∏ i, if f i then (p N i : ENNReal)
    else ((1 : ENNReal) - (p N i : ENNReal))

theorem poissonBernoulliRowWeight_sum_eq_one
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0)
    (hp : ∀ N i, p N i ≤ 1) (N : ℕ) :
    (∑ f : Fin (N + 1) → Bool, poissonBernoulliRowWeight p N f) = 1 := by
  classical
  calc
    (∑ f : Fin (N + 1) → Bool, poissonBernoulliRowWeight p N f) =
        ∏ i : Fin (N + 1), ∑ b : Bool,
          (if b then (p N i : ENNReal)
            else ((1 : ENNReal) - (p N i : ENNReal))) := by
      exact (Fintype.prod_sum fun i (b : Bool) =>
        if b then (p N i : ENNReal)
        else ((1 : ENNReal) - (p N i : ENNReal))).symm
    _ = 1 := by
      apply Finset.prod_eq_one
      intro i hi
      have hsub : (p N i : ENNReal) +
          ((1 : ENNReal) - (p N i : ENNReal)) = 1 := by
        norm_cast
        exact add_tsub_cancel_of_le (hp N i)
      simp [hsub]

/-- The product probability mass function of one heterogeneous Bernoulli
row. -/
def poissonBernoulliRowVectorPMF
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0)
    (hp : ∀ N i, p N i ≤ 1) (N : ℕ) : PMF (Fin (N + 1) → Bool) :=
  PMF.ofFintype (poissonBernoulliRowWeight p N)
    (poissonBernoulliRowWeight_sum_eq_one p hp N)

/-- The real-valued number of successes in a Boolean Bernoulli row. -/
def poissonBernoulliRowCount
    (N : ℕ) (f : Fin (N + 1) → Bool) : ℝ :=
  ∑ i, if f i then 1 else 0

/-- The law of the sum of a heterogeneous row of independent Bernoulli
variables. -/
def poissonBernoulliRowPMF
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0)
    (hp : ∀ N i, p N i ≤ 1) (N : ℕ) : PMF ℝ :=
  (poissonBernoulliRowVectorPMF p hp N).map
    (poissonBernoulliRowCount N)

/-- A canonical heterogeneous Bernoulli row-sum law bundled as a probability
measure. -/
noncomputable def poissonBernoulliRowProbabilityMeasure
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0)
    (hp : ∀ N i, p N i ≤ 1) (N : ℕ) :
    MeasureTheory.ProbabilityMeasure ℝ :=
  ⟨(poissonBernoulliRowPMF p hp N).toMeasure, inferInstance⟩

/-- The mean of one coordinate of the canonical heterogeneous Bernoulli row
is its success parameter. -/
theorem poissonBernoulliRow_coordinate_mean
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0)
    (hp : ∀ N i, p N i ≤ 1) (N : ℕ) (i : Fin (N + 1)) :
    ∫ f, (if f i then 1 else 0 : ℝ)
      ∂(poissonBernoulliRowVectorPMF p hp N).toMeasure = (p N i : ℝ) := by
  classical
  let q : Fin (N + 1) → Bool → ℝ := fun j b =>
    if b then (p N j : ℝ) else 1 - (p N j : ℝ)
  have hw (f : Fin (N + 1) → Bool) :
      ((poissonBernoulliRowVectorPMF p hp N) f).toReal =
        ∏ j, q j (f j) := by
    rw [poissonBernoulliRowVectorPMF, PMF.ofFintype_apply,
      poissonBernoulliRowWeight, ENNReal.toReal_prod]
    apply Finset.prod_congr rfl
    intro j hj
    by_cases hfj : f j
    · simp [q, hfj]
    · simp [q, hfj]
      rw [ENNReal.toReal_sub_of_le]
      · simp
      · exact_mod_cast hp N j
      · simp
  rw [PMF.integral_eq_sum]
  simp_rw [hw]
  simp only [smul_eq_mul]
  let r : Fin (N + 1) → Bool → ℝ := fun j b =>
    if j = i then q j b * (if b then 1 else 0) else q j b
  have hterm (f : Fin (N + 1) → Bool) :
      (∏ j, q j (f j)) * (if f i then 1 else 0) =
        ∏ j, r j (f j) := by
    by_cases hfi : f i
    · rw [if_pos hfi, mul_one]
      apply Finset.prod_congr rfl
      intro j hj
      by_cases hji : j = i
      · subst j
        simp [r, hfi]
      · simp [r, hji]
    · rw [if_neg hfi, mul_zero]
      symm
      apply Finset.prod_eq_zero (Finset.mem_univ i)
      simp [r, hfi]
  calc
    (∑ f : Fin (N + 1) → Bool,
        (∏ j, q j (f j)) * (if f i then 1 else 0)) =
        ∑ f : Fin (N + 1) → Bool, ∏ j, r j (f j) := by
          exact Finset.sum_congr rfl fun f _ => hterm f
    _ = ∏ j : Fin (N + 1), ∑ b : Bool, r j b :=
      (Fintype.prod_sum r).symm
    _ = p N i := by
      have hq (j : Fin (N + 1)) : q j true + q j false = 1 := by
        simp [q]
      calc
        (∏ j : Fin (N + 1), ∑ b : Bool, r j b) =
            ∑ b : Bool, r i b := by
          exact Finset.prod_eq_single i
            (fun j _ hji => by
              rw [Fintype.sum_bool]
              simp [r, hji, hq]) (by simp)
        _ = p N i := by
          rw [Fintype.sum_bool]
          simp [r, q]

/-- The characteristic function of the heterogeneous Bernoulli row sum is
the product of its Bernoulli characteristic-function factors. -/
theorem poissonBernoulliRowPMF_charFun
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0)
    (hp : ∀ N i, p N i ≤ 1) (N : ℕ) (t : ℝ) :
    MeasureTheory.charFun (poissonBernoulliRowPMF p hp N).toMeasure t =
      ∏ i : Fin (N + 1), (1 + (p N i : ℂ) *
        (Complex.exp ((t : ℂ) * Complex.I) - 1)) := by
  classical
  rw [MeasureTheory.charFun_apply_real, poissonBernoulliRowPMF,
    ← PMF.toMeasure_map (poissonBernoulliRowCount N)
      (poissonBernoulliRowVectorPMF p hp N) (measurable_of_countable _)]
  rw [MeasureTheory.integral_map (measurable_of_countable _).aemeasurable
    (by fun_prop)]
  rw [PMF.integral_eq_sum]
  have hterm (f : Fin (N + 1) → Bool) :
      ((poissonBernoulliRowVectorPMF p hp N) f).toReal •
          Complex.exp ((t : ℂ) * (poissonBernoulliRowCount N f : ℂ) *
            Complex.I) =
        ∏ i : Fin (N + 1),
          ((((if f i then (p N i : ENNReal)
              else ((1 : ENNReal) - (p N i : ENNReal))).toReal : ℂ) *
            Complex.exp ((t : ℂ) *
              ((if f i then 1 else 0 : ℝ) : ℂ) * Complex.I))) := by
    rw [poissonBernoulliRowVectorPMF, PMF.ofFintype_apply]
    have hw : (poissonBernoulliRowWeight p N f).toReal =
        ∏ i : Fin (N + 1),
          ((if f i then (p N i : ENNReal)
            else ((1 : ENNReal) - (p N i : ENNReal))).toReal) :=
      ENNReal.toReal_prod
    rw [hw]
    have hexp :
        Complex.exp ((t : ℂ) * (poissonBernoulliRowCount N f : ℂ) *
          Complex.I) =
          ∏ i : Fin (N + 1),
            (Complex.exp ((t : ℂ) *
              ((if f i then 1 else 0 : ℝ) : ℂ) * Complex.I)) := by
      rw [show (t : ℂ) * (poissonBernoulliRowCount N f : ℂ) * Complex.I =
          ∑ i : Fin (N + 1),
            ((t : ℂ) * ((if f i then 1 else 0 : ℝ) : ℂ) * Complex.I) by
        unfold poissonBernoulliRowCount
        push_cast
        rw [Finset.mul_sum, Finset.sum_mul]]
      exact Complex.exp_sum _ _
    rw [hexp]
    simp only [Complex.real_smul]
    push_cast
    rw [Finset.prod_mul_distrib]
  calc
    (∑ a : Fin (N + 1) → Bool,
        ((poissonBernoulliRowVectorPMF p hp N) a).toReal •
          Complex.exp ((t : ℂ) *
            (poissonBernoulliRowCount N a : ℂ) * Complex.I)) =
        ∑ f : Fin (N + 1) → Bool, ∏ i : Fin (N + 1),
          ((((if f i then (p N i : ENNReal)
              else ((1 : ENNReal) - (p N i : ENNReal))).toReal : ℂ) *
            Complex.exp ((t : ℂ) *
              ((if f i then 1 else 0 : ℝ) : ℂ) * Complex.I))) := by
          exact Finset.sum_congr rfl fun f _ => hterm f
    _ = ∏ i : Fin (N + 1), ∑ b : Bool,
          ((((if b then (p N i : ENNReal)
              else ((1 : ENNReal) - (p N i : ENNReal))).toReal : ℂ) *
            Complex.exp ((t : ℂ) *
              ((if b then 1 else 0 : ℝ) : ℂ) * Complex.I))) := by
      exact (Fintype.prod_sum fun i (b : Bool) =>
        (((if b then (p N i : ENNReal)
          else ((1 : ENNReal) - (p N i : ENNReal))).toReal : ℂ) *
        Complex.exp ((t : ℂ) *
          ((if b then 1 else 0 : ℝ) : ℂ) * Complex.I))).symm
    _ = ∏ i : Fin (N + 1), (1 + (p N i : ℂ) *
          (Complex.exp ((t : ℂ) * Complex.I) - 1)) := by
      apply Finset.prod_congr rfl
      intro i hi
      have hsub : ((1 : ENNReal) - (p N i : ENNReal)).toReal =
          1 - (p N i : ℝ) := by
        rw [ENNReal.toReal_sub_of_le]
        · simp
        · exact_mod_cast hp N i
        · simp
      rw [Fintype.sum_bool]
      simp [hsub]
      ring

/-- Uniformly integrable nonnegative laws with bounded first moments form a
tight sequence. -/
theorem isTight_probabilityMeasure_range_of_nonneg_expectation_le
    (P : ℕ → MeasureTheory.ProbabilityMeasure ℝ)
    (hInt : ∀ n, MeasureTheory.Integrable (fun x : ℝ => x)
      (P n : MeasureTheory.Measure ℝ))
    (hNonneg : ∀ n,
      0 ≤ᵐ[(P n : MeasureTheory.Measure ℝ)] (fun x : ℝ => x))
    (C : ℝ) (hC : 0 ≤ C)
    (hMean : ∀ n, ∫ x : ℝ, x ∂(P n : MeasureTheory.Measure ℝ) ≤ C) :
    MeasureTheory.IsTightMeasureSet
      {((q : MeasureTheory.ProbabilityMeasure ℝ) : MeasureTheory.Measure ℝ) |
        q ∈ Set.range P} := by
  rw [MeasureTheory.isTightMeasureSet_iff_exists_isCompact_measure_compl_le]
  intro ε hε
  obtain ⟨n, hn⟩ := ENNReal.exists_inv_nat_lt hε.ne'
  have hn0 : n ≠ 0 := by
    intro hnz
    subst n
    simp at hn
  have hnR : (0 : ℝ) < n := by
    exact_mod_cast Nat.pos_of_ne_zero hn0
  have hnE0 : (n : ENNReal) ≠ 0 := by
    exact_mod_cast hn0
  have hnET : (n : ENNReal) ≠ ⊤ := by simp
  have hCp : 0 < C + 1 := by linarith
  let R : ℝ := (n : ℝ) * (C + 1)
  have hR : 0 < R := mul_pos hnR hCp
  refine ⟨Set.Icc (-R) R, isCompact_Icc, ?_⟩
  intro ν hν
  rcases hν with ⟨q, ⟨k, rfl⟩, rfl⟩
  have hmono : (P k : MeasureTheory.Measure ℝ) (Set.Icc (-R) R)ᶜ ≤
      (P k : MeasureTheory.Measure ℝ)
        ((fun x : ℝ => x) ⁻¹' Set.Ici R) := by
    apply MeasureTheory.measure_mono_ae
    filter_upwards [hNonneg k] with x hx
    change (0 : ℝ) ≤ x at hx
    intro hxc
    change R ≤ x
    by_contra hnot
    apply hxc
    exact ⟨by linarith, by linarith⟩
  refine hmono.trans ?_
  have hmarkov :=
    NumStability.HDP.Scalar.Preliminaries.markovInequalityExtended
      (μ := (P k : MeasureTheory.Measure ℝ)) (X := fun x : ℝ => x)
      measurable_id (hNonneg k) hR
  refine hmarkov.trans ?_
  have hlin :
      (∫⁻ x : ℝ, ENNReal.ofReal x ∂(P k : MeasureTheory.Measure ℝ)) =
        ENNReal.ofReal
          (∫ x : ℝ, x ∂(P k : MeasureTheory.Measure ℝ)) := by
    exact (MeasureTheory.ofReal_integral_eq_lintegral_ofReal
      (hInt k) (hNonneg k)).symm
  rw [hlin]
  calc
    ENNReal.ofReal (∫ x : ℝ, x ∂(P k : MeasureTheory.Measure ℝ)) /
          ENNReal.ofReal R ≤ ENNReal.ofReal C / ENNReal.ofReal R := by
      gcongr
      exact hMean k
    _ ≤ (n : ENNReal)⁻¹ := by
      rw [show ENNReal.ofReal R =
          (n : ENNReal) * ENNReal.ofReal (C + 1) by
        simp [R, ENNReal.ofReal_mul hnR.le]]
      rw [ENNReal.div_eq_inv_mul,
        ENNReal.mul_inv (Or.inl hnE0) (Or.inl hnET)]
      calc
        (n : ENNReal)⁻¹ * (ENNReal.ofReal (C + 1))⁻¹ *
            ENNReal.ofReal C =
          (n : ENNReal)⁻¹ *
            ((ENNReal.ofReal (C + 1))⁻¹ * ENNReal.ofReal C) := by ac_rfl
        _ ≤ (n : ENNReal)⁻¹ * 1 := by
          gcongr
          exact (mul_le_mul_right
            (ENNReal.ofReal_le_ofReal (by linarith : C ≤ C + 1))
            (ENNReal.ofReal (C + 1))⁻¹).trans
              (ENNReal.inv_mul_le_one (ENNReal.ofReal (C + 1)))
        _ = (n : ENNReal)⁻¹ := mul_one _
    _ ≤ ε := hn.le

/-- The largest rare-event probability in row `N`, using `N + 1` entries so
the row is nonempty at every natural index. -/
def poissonRowMax
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (N : ℕ) : ℝ≥0 :=
  Finset.univ.sup (p N)

/-- The total mean of a row of Bernoulli parameters. -/
def poissonRowSum
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (N : ℕ) : ℝ :=
  ∑ i, (p N i : ℝ)

/-- The identity is integrable under every canonical Bernoulli row-sum law. -/
theorem integrable_id_poissonBernoulliRowPMF
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0)
    (hp : ∀ N i, p N i ≤ 1) (N : ℕ) :
    MeasureTheory.Integrable (fun x : ℝ => x)
      (poissonBernoulliRowPMF p hp N).toMeasure := by
  rw [poissonBernoulliRowPMF,
    ← PMF.toMeasure_map (poissonBernoulliRowCount N)
      (poissonBernoulliRowVectorPMF p hp N) (measurable_of_countable _)]
  have hcount : AEMeasurable (poissonBernoulliRowCount N)
      (poissonBernoulliRowVectorPMF p hp N).toMeasure :=
    (show Measurable (poissonBernoulliRowCount N) from
      measurable_of_countable _).aemeasurable
  refine (MeasureTheory.integrable_map_measure
    (f := poissonBernoulliRowCount N) (g := fun x : ℝ => x)
    continuous_id.aestronglyMeasurable hcount).2 ?_
  change MeasureTheory.Integrable (poissonBernoulliRowCount N)
    (poissonBernoulliRowVectorPMF p hp N).toMeasure
  rw [← MeasureTheory.integrableOn_univ]
  exact MeasureTheory.IntegrableOn.of_finite Set.finite_univ

/-- Every canonical Bernoulli row-sum law is supported on the nonnegative
real line. -/
theorem ae_nonneg_poissonBernoulliRowPMF
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0)
    (hp : ∀ N i, p N i ≤ 1) (N : ℕ) :
    0 ≤ᵐ[(poissonBernoulliRowPMF p hp N).toMeasure]
      (fun x : ℝ => x) := by
  rw [poissonBernoulliRowPMF,
    ← PMF.toMeasure_map (poissonBernoulliRowCount N)
      (poissonBernoulliRowVectorPMF p hp N) (measurable_of_countable _)]
  have hcount : AEMeasurable (poissonBernoulliRowCount N)
      (poissonBernoulliRowVectorPMF p hp N).toMeasure :=
    (show Measurable (poissonBernoulliRowCount N) from
      measurable_of_countable _).aemeasurable
  apply (MeasureTheory.ae_map_iff hcount measurableSet_Ici).2
  filter_upwards with f
  change 0 ≤ poissonBernoulliRowCount N f
  exact Finset.sum_nonneg fun _ _ => by positivity

/-- The mean of a canonical heterogeneous Bernoulli row sum is the sum of
its success parameters. -/
theorem poissonBernoulliRowPMF_mean
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0)
    (hp : ∀ N i, p N i ≤ 1) (N : ℕ) :
    ∫ x : ℝ, x ∂(poissonBernoulliRowPMF p hp N).toMeasure =
      poissonRowSum p N := by
  rw [poissonBernoulliRowPMF,
    ← PMF.toMeasure_map (poissonBernoulliRowCount N)
      (poissonBernoulliRowVectorPMF p hp N) (measurable_of_countable _)]
  have hiMap := MeasureTheory.integral_map
    (μ := (poissonBernoulliRowVectorPMF p hp N).toMeasure)
    (φ := poissonBernoulliRowCount N) (f := fun x : ℝ => x)
    (measurable_of_countable _).aemeasurable
    continuous_id.aestronglyMeasurable
  rw [hiMap]
  unfold poissonBernoulliRowCount poissonRowSum
  rw [MeasureTheory.integral_finset_sum Finset.univ]
  · exact Finset.sum_congr rfl fun i _ =>
      poissonBernoulliRow_coordinate_mean p hp N i
  · intro i hi
    rw [← MeasureTheory.integrableOn_univ]
    exact MeasureTheory.IntegrableOn.of_finite Set.finite_univ

/-- The sum of squared probabilities in a row. -/
def poissonRowSqSum
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (N : ℕ) : ℝ :=
  ∑ i, (p N i : ℝ) ^ 2

/-- The elementary estimate `Σ pᵢ² ≤ (max pᵢ) Σ pᵢ`. -/
theorem poissonRowSqSum_le_max_mul_sum
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (N : ℕ) :
    poissonRowSqSum p N ≤ (poissonRowMax p N : ℝ) * poissonRowSum p N := by
  unfold poissonRowSqSum poissonRowMax poissonRowSum
  rw [Finset.mul_sum]
  apply Finset.sum_le_sum
  intro i hi
  rw [pow_two]
  apply mul_le_mul_of_nonneg_right _ (NNReal.coe_nonneg _)
  exact_mod_cast (Finset.le_sup (f := p N) (Finset.mem_univ i))

/-- If the maximum row probability tends to zero while the row sums converge
to a finite limit, then the sum of squared row probabilities tends to zero. -/
theorem tendsto_poissonRowSqSum_zero
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (rate : ℝ)
    (hmax : Tendsto (fun N => (poissonRowMax p N : ℝ)) atTop (𝓝 0))
    (hsum : Tendsto (poissonRowSum p) atTop (𝓝 rate)) :
    Tendsto (poissonRowSqSum p) atTop (𝓝 0) := by
  apply squeeze_zero
  · intro N
    exact Finset.sum_nonneg fun _ _ => sq_nonneg _
  · exact poissonRowSqSum_le_max_mul_sum p
  · simpa using hmax.mul hsum

/-- A convenient quadratic form of the complex logarithm remainder estimate on
the closed half ball. -/
theorem norm_log_one_add_sub_self_le_sq
    {z : ℂ} (hz : ‖z‖ ≤ (1 : ℝ) / 2) :
    ‖Complex.log (1 + z) - z‖ ≤ ‖z‖ ^ 2 := by
  have hzlt : ‖z‖ < (1 : ℝ) := lt_of_le_of_lt hz (by norm_num)
  refine (Complex.norm_log_one_add_sub_self_le hzlt).trans ?_
  have hden : (1 - ‖z‖)⁻¹ ≤ (2 : ℝ) := by
    rw [inv_le_comm₀ (sub_pos.mpr hzlt) (by norm_num)]
    linarith
  calc
    ‖z‖ ^ 2 * (1 - ‖z‖)⁻¹ / 2
        ≤ ‖z‖ ^ 2 * 2 / 2 := by gcongr
    _ = ‖z‖ ^ 2 := by ring

/-- The accumulated logarithm remainder for finitely many rare-event
probabilities is controlled by their squared sum. -/
theorem norm_sum_log_one_add_sub_le
    {ι : Type*} [Fintype ι] (q : ι → ℝ≥0) (z : ℂ)
    (hsmall : ∀ i, ‖(q i : ℂ) * z‖ ≤ (1 : ℝ) / 2) :
    ‖∑ i, (Complex.log (1 + (q i : ℂ) * z) - (q i : ℂ) * z)‖
      ≤ ‖z‖ ^ 2 * ∑ i, (q i : ℝ) ^ 2 := by
  calc
    ‖∑ i, (Complex.log (1 + (q i : ℂ) * z) - (q i : ℂ) * z)‖
        ≤ ∑ i, ‖Complex.log (1 + (q i : ℂ) * z) - (q i : ℂ) * z‖ :=
      norm_sum_le _ _
    _ ≤ ∑ i, ‖(q i : ℂ) * z‖ ^ 2 := by
      apply Finset.sum_le_sum
      intro i hi
      exact norm_log_one_add_sub_self_le_sq (hsmall i)
    _ = ‖z‖ ^ 2 * ∑ i, (q i : ℝ) ^ 2 := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro i hi
      have hqnorm : ‖(q i : ℂ)‖ = (q i : ℝ) := by
        exact Complex.norm_of_nonneg (NNReal.coe_nonneg _)
      rw [norm_mul, hqnorm, mul_pow]
      ring

/-- The logarithm remainder after subtracting the linearized rare-event
contribution in a triangular-array row. -/
def poissonLogRemainder
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (z : ℂ) (N : ℕ) : ℂ :=
  (∑ i, Complex.log (1 + (p N i : ℂ) * z)) -
    (poissonRowSum p N : ℂ) * z

theorem norm_poissonLogRemainder_le
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (z : ℂ) (N : ℕ)
    (hsmall : ∀ i, ‖(p N i : ℂ) * z‖ ≤ (1 : ℝ) / 2) :
    ‖poissonLogRemainder p z N‖ ≤ ‖z‖ ^ 2 * poissonRowSqSum p N := by
  unfold poissonLogRemainder poissonRowSum poissonRowSqSum
  have hlinear :
      ((∑ i, (p N i : ℝ) : ℝ) : ℂ) * z = ∑ i, (p N i : ℂ) * z := by
    push_cast
    rw [Finset.sum_mul]
  rw [hlinear, ← Finset.sum_sub_distrib]
  exact norm_sum_log_one_add_sub_le (p N) z hsmall

/-- Vanishing squared probabilities make the accumulated logarithm remainder
vanish, once every row factor is eventually in the logarithm's half ball. -/
theorem tendsto_poissonLogRemainder_zero
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (z : ℂ)
    (hsq : Tendsto (poissonRowSqSum p) atTop (𝓝 0))
    (hsmall : ∀ᶠ N in atTop, ∀ i, ‖(p N i : ℂ) * z‖ ≤ (1 : ℝ) / 2) :
    Tendsto (poissonLogRemainder p z) atTop (𝓝 0) := by
  apply squeeze_zero_norm'
  · filter_upwards [hsmall] with N hN
    exact norm_poissonLogRemainder_le p z N hN
  · simpa using (tendsto_const_nhds.mul hsq)

theorem eventually_norm_poissonFactor_le_half
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (z : ℂ)
    (hmax : Tendsto (fun N => (poissonRowMax p N : ℝ)) atTop (𝓝 0)) :
    ∀ᶠ N in atTop, ∀ i, ‖(p N i : ℂ) * z‖ ≤ (1 : ℝ) / 2 := by
  have hbound :
      ∀ᶠ N in atTop,
        (poissonRowMax p N : ℝ) * ‖z‖ ≤ (1 : ℝ) / 2 :=
    (hmax.mul_const ‖z‖).eventually_le_const (by norm_num)
  filter_upwards [hbound] with N hN
  intro i
  have hpmax : (p N i : ℝ) ≤ (poissonRowMax p N : ℝ) := by
    exact_mod_cast (Finset.le_sup (f := p N) (Finset.mem_univ i))
  have hqnorm : ‖(p N i : ℂ)‖ = (p N i : ℝ) :=
    Complex.norm_of_nonneg (NNReal.coe_nonneg _)
  rw [norm_mul, hqnorm]
  exact (mul_le_mul_of_nonneg_right hpmax (norm_nonneg z)).trans hN

theorem tendsto_poissonLogRemainder_zero_of_row_limits
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (z : ℂ) (rate : ℝ)
    (hmax : Tendsto (fun N => (poissonRowMax p N : ℝ)) atTop (𝓝 0))
    (hsum : Tendsto (poissonRowSum p) atTop (𝓝 rate)) :
    Tendsto (poissonLogRemainder p z) atTop (𝓝 0) := by
  exact tendsto_poissonLogRemainder_zero p z
    (tendsto_poissonRowSqSum_zero p rate hmax hsum)
    (eventually_norm_poissonFactor_le_half p z hmax)

/-- The sum of logarithms of the Bernoulli characteristic-function factors. -/
def poissonLogSum
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (z : ℂ) (N : ℕ) : ℂ :=
  ∑ i, Complex.log (1 + (p N i : ℂ) * z)

/-- The rowwise logarithms converge to the linear Poisson exponent. -/
theorem tendsto_poissonLogSum
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (z : ℂ) (rate : ℝ)
    (hmax : Tendsto (fun N => (poissonRowMax p N : ℝ)) atTop (𝓝 0))
    (hsum : Tendsto (poissonRowSum p) atTop (𝓝 rate)) :
    Tendsto (poissonLogSum p z) atTop (𝓝 ((rate : ℂ) * z)) := by
  have hrem := tendsto_poissonLogRemainder_zero_of_row_limits p z rate hmax hsum
  have hlin :
      Tendsto (fun N => (poissonRowSum p N : ℂ) * z) atTop
        (𝓝 ((rate : ℂ) * z)) :=
    hsum.ofReal.mul_const z
  convert hrem.add hlin using 1
  · funext N
    simp only [poissonLogRemainder, poissonLogSum]
    ring
  · ring

/-- The product of the rowwise Bernoulli characteristic-function factors. -/
def poissonFactorProduct
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (z : ℂ) (N : ℕ) : ℂ :=
  ∏ i, (1 + (p N i : ℂ) * z)

theorem poissonFactorProduct_eq_exp_logSum
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (z : ℂ) (N : ℕ)
    (hsmall : ∀ i, ‖(p N i : ℂ) * z‖ ≤ (1 : ℝ) / 2) :
    poissonFactorProduct p z N = Complex.exp (poissonLogSum p z N) := by
  unfold poissonFactorProduct poissonLogSum
  calc
    (∏ i, (1 + (p N i : ℂ) * z))
        = ∏ i, Complex.exp (Complex.log (1 + (p N i : ℂ) * z)) := by
      apply Finset.prod_congr rfl
      intro i hi
      symm
      apply Complex.exp_log
      intro hzero
      have ha : (p N i : ℂ) * z = -1 := by
        calc
          (p N i : ℂ) * z = (1 + (p N i : ℂ) * z) - 1 := by ring
          _ = -1 := by rw [hzero]; ring
      have hnorm : ‖(p N i : ℂ) * z‖ = (1 : ℝ) := by rw [ha]; simp
      linarith [hsmall i]
    _ = Complex.exp (∑ i, Complex.log (1 + (p N i : ℂ) * z)) := by
      simpa using
        (Complex.exp_sum (Finset.univ : Finset (Fin (N + 1)))
          (fun i => Complex.log (1 + (p N i : ℂ) * z))).symm

/-- The Bernoulli factor products converge to the exponential of the Poisson
linear exponent under the two source row-limit assumptions. -/
theorem tendsto_poissonFactorProduct
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (z : ℂ) (rate : ℝ)
    (hmax : Tendsto (fun N => (poissonRowMax p N : ℝ)) atTop (𝓝 0))
    (hsum : Tendsto (poissonRowSum p) atTop (𝓝 rate)) :
    Tendsto (poissonFactorProduct p z) atTop
      (𝓝 (Complex.exp ((rate : ℂ) * z))) := by
  have hlog := tendsto_poissonLogSum p z rate hmax hsum
  have hexp := (Complex.continuous_exp.tendsto ((rate : ℂ) * z)).comp hlog
  apply hexp.congr'
  filter_upwards [eventually_norm_poissonFactor_le_half p z hmax] with N hN
  exact (poissonFactorProduct_eq_exp_logSum p z N hN).symm

/-- **Poisson limit theorem.** If the largest success probability in each
heterogeneous Bernoulli row tends to zero and the total row mean tends to a
finite nonnegative rate, then the row-sum laws converge weakly to the Poisson
law with that rate. -/
theorem tendsto_poissonBernoulliRowProbabilityMeasure
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0)
    (hp : ∀ N i, p N i ≤ 1) (rate : ℝ≥0)
    (hmax : Tendsto (fun N => (poissonRowMax p N : ℝ)) atTop (𝓝 0))
    (hsum : Tendsto (poissonRowSum p) atTop (𝓝 (rate : ℝ))) :
    Tendsto (poissonBernoulliRowProbabilityMeasure p hp) atTop
      (𝓝 (poissonRealProbabilityMeasure rate)) := by
  let P : ℕ → MeasureTheory.ProbabilityMeasure ℝ :=
    poissonBernoulliRowProbabilityMeasure p hp
  let Q : MeasureTheory.ProbabilityMeasure ℝ :=
    poissonRealProbabilityMeasure rate
  change Tendsto P atTop (𝓝 Q)
  apply tendsto_probabilityMeasure_of_charFun_tendsto_of_tight P Q
  · rcases hsum.bddAbove_range with ⟨C, hC⟩
    have hbound : ∀ N, poissonRowSum p N ≤ C :=
      fun N => hC ⟨N, rfl⟩
    have hC0 : 0 ≤ C :=
      (Finset.sum_nonneg fun _ _ => NNReal.coe_nonneg (p 0 _)).trans
        (hbound 0)
    apply isTight_probabilityMeasure_range_of_nonneg_expectation_le P
      (fun N => integrable_id_poissonBernoulliRowPMF p hp N)
      (fun N => ae_nonneg_poissonBernoulliRowPMF p hp N) C hC0
    intro N
    rw [show (P N : MeasureTheory.Measure ℝ) =
        (poissonBernoulliRowPMF p hp N).toMeasure by rfl,
      poissonBernoulliRowPMF_mean]
    exact hbound N
  · intro t
    have hlim := tendsto_poissonFactorProduct p
      (Complex.exp ((t : ℂ) * Complex.I) - 1) (rate : ℝ) hmax hsum
    change Tendsto
      (fun N => MeasureTheory.charFun
        (poissonBernoulliRowPMF p hp N).toMeasure t)
      atTop (𝓝 (MeasureTheory.charFun (poissonRealLaw rate) t))
    rw [poissonRealLaw_charFun]
    apply hlim.congr'
    filter_upwards with N
    exact (poissonBernoulliRowPMF_charFun p hp N t).symm

end NumStability.HDP.Scalar.LimitTheorems
