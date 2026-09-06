import Mathlib.Probability.Combinatorics.BinomialRandomGraph.Defs
import Mathlib.Combinatorics.SimpleGraph.Finite
import Mathlib.Probability.ProbabilityMassFunction.Integrals
import Mathlib.Probability.HasLaw
import Mathlib.Probability.Independence.Integration
import Mathlib.Probability.Distributions.Poisson
import Mathlib.MeasureTheory.Integral.Lebesgue.Countable
import Mathlib.Analysis.Asymptotics.AsymptoticEquivalent
import Mathlib.Analysis.SpecialFunctions.Stirling
import Mathlib.Analysis.Complex.ExponentialBounds
import Mathlib.Tactic
import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding
import ComputationalMathematics.HDP.Scalar.IndependentSums.GraphDegreeLaw

/-!
# The Erdős--Rényi random graph interface

This module uses Mathlib's canonical binomial random graph law on finite simple
graphs and exposes the vertex-degree observable used by the Chapter 2
application.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators
open scoped ENNReal
open scoped NNReal
open scoped Asymptotics

namespace NumStability.HDP.Scalar.IndependentSums.Chernoff

theorem bernoulliMgfExact (p : ℝ≥0) (hp : p ≤ 1) (lam : ℝ) :
    (∫ b : Bool, Real.exp (lam * (if b then 1 else 0)) ∂
      (PMF.bernoulli p hp).toMeasure) =
      1 + (Real.exp lam - 1) * (p : ℝ) := by
  rw [PMF.integral_eq_sum]
  simp [PMF.bernoulli_apply]
  rw [NNReal.coe_sub hp]
  norm_num
  ring

theorem bernoulliMgfBound (p : ℝ≥0) (hp : p ≤ 1) (lam : ℝ) :
    ((∫ b : Bool, Real.exp (lam * (if b then 1 else 0)) ∂
        (PMF.bernoulli p hp).toMeasure) =
        1 + (Real.exp lam - 1) * (p : ℝ)) ∧
      (1 + (Real.exp lam - 1) * (p : ℝ) ≤
        Real.exp ((Real.exp lam - 1) * (p : ℝ))) := by
  refine ⟨bernoulliMgfExact p hp lam, ?_⟩
  simpa [add_comm] using Real.add_one_le_exp ((Real.exp lam - 1) * (p : ℝ))

theorem poissonBinomialMgfBound
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {p : ι → ℝ≥0}
    (hp : ∀ i, p i ≤ 1)
    (hB : iIndepFun B μ)
    (hLaw : ∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ)
    (lam : ℝ)
    (hExp : ∀ i, Integrable
      (fun ω => Real.exp (lam * (if B i ω then 1 else 0))) μ) :
    (∫ ω, Real.exp (lam * ∑ i, (if B i ω then 1 else 0)) ∂μ) ≤
      Real.exp ((Real.exp lam - 1) * ∑ i, (p i : ℝ)) := by
  let Y : ι → Ω → ℝ := fun i ω => if B i ω then 1 else 0
  have hY : iIndepFun Y μ := by
    let g : ∀ _ : ι, Bool → ℝ := fun _ b => if b then 1 else 0
    have h := hB.comp g (fun _ => by fun_prop)
    simpa [Y, g, Function.comp_def] using h
  have hExpY : ∀ i, Integrable (fun ω => Real.exp (lam * (1 * Y i ω))) μ := by
    intro i
    simpa [Y, one_mul] using hExp i
  have hFactor : ∀ i, (∫ ω, Real.exp (lam * (1 * Y i ω)) ∂μ) ≤
      Real.exp ((Real.exp lam - 1) * (p i : ℝ)) := by
    intro i
    have hcomp := (hLaw i).integral_comp
      (f := fun b : Bool => Real.exp (lam * (if b then 1 else 0))) (by fun_prop)
    calc
      (∫ ω, Real.exp (lam * (1 * Y i ω)) ∂μ) =
          ∫ b : Bool, Real.exp (lam * (if b then 1 else 0)) ∂
            (PMF.bernoulli (p i) (hp i)).toMeasure := by
        simpa [Y, Function.comp_def] using hcomp
      _ = 1 + (Real.exp lam - 1) * (p i : ℝ) := bernoulliMgfExact (p i) (hp i) lam
      _ ≤ Real.exp ((Real.exp lam - 1) * (p i : ℝ)) :=
        (bernoulliMgfBound (p i) (hp i) lam).2
  calc
    (∫ ω, Real.exp (lam * ∑ i, (if B i ω then 1 else 0)) ∂μ) =
        ∏ i, ∫ ω, Real.exp (lam * (1 * Y i ω)) ∂μ := by
      simpa [Y] using
          (NumStability.HDP.Scalar.IndependentSums.Hoeffding.mgfIndependentSum
          (μ := μ) (X := Y) lam (fun _ => 1) hY hExpY)
    _ ≤ ∏ i, Real.exp ((Real.exp lam - 1) * (p i : ℝ)) := by
      apply Finset.prod_le_prod
      · intro i _
        exact integral_nonneg (fun _ => Real.exp_nonneg _)
      · intro i _
        exact hFactor i
    _ = Real.exp ((Real.exp lam - 1) * ∑ i, (p i : ℝ)) := by
      rw [← Real.exp_sum]
      congr 1
      rw [Finset.mul_sum]

theorem poissonBinomialChernoffBound
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {p : ι → ℝ≥0}
    (hp : ∀ i, p i ≤ 1)
    (hB : iIndepFun B μ)
    (hLaw : ∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ)
    (hMeas : ∀ i, Measurable (B i))
    {t : ℝ}
    (hExp : ∀ i, Integrable
      (fun ω => Real.exp (Real.log (t / (∑ i, (p i : ℝ))) *
        (if B i ω then 1 else 0))) μ)
    (ht : ∑ i, (p i : ℝ) < t)
    (hμ : 0 < ∑ i, (p i : ℝ))
    (hExpS : Integrable
      (fun ω => Real.exp (Real.log (t / (∑ i, (p i : ℝ))) *
        ∑ i, (if B i ω then 1 else 0))) μ) :
    μ.real {ω | t ≤ ∑ i, (if B i ω then 1 else 0)} ≤
      Real.exp (-(∑ i, (p i : ℝ))) *
        ((Real.exp 1 * (∑ i, (p i : ℝ)) / t) ^ t) := by
  let S : Ω → ℝ := fun ω => ∑ i, (if B i ω then 1 else 0)
  have hS : Measurable S := by
    dsimp [S]
    refine Finset.measurable_fun_sum Finset.univ ?_
    intro i hi
    exact Measurable.ite
      (measurableSet_preimage (hMeas i) (measurableSet_singleton (true : Bool)))
      measurable_const measurable_const
  have hlogpos : 0 < Real.log (t / (∑ i, (p i : ℝ))) := by
    apply Real.log_pos
    rw [one_lt_div hμ]
    exact ht
  have hmgf := poissonBinomialMgfBound hp hB hLaw
    (Real.log (t / (∑ i, (p i : ℝ)))) hExp
  have hmarkov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (lam := Real.log (t / (∑ i, (p i : ℝ)))) (t := t) hS hlogpos hExpS
  have hbound :
      (∫ ω, Real.exp (Real.log (t / (∑ i, (p i : ℝ))) * S ω) ∂μ) ≤
        Real.exp ((Real.exp (Real.log (t / (∑ i, (p i : ℝ)))) - 1) *
          (∑ i, (p i : ℝ))) := by
    simpa [S] using hmgf
  have hmul :
      Real.exp (-(Real.log (t / (∑ i, (p i : ℝ))) * t)) *
          (∫ ω, Real.exp (Real.log (t / (∑ i, (p i : ℝ))) * S ω) ∂μ) ≤
        Real.exp (-(Real.log (t / (∑ i, (p i : ℝ))) * t)) *
          Real.exp ((Real.exp (Real.log (t / (∑ i, (p i : ℝ)))) - 1) *
            (∑ i, (p i : ℝ))) :=
    mul_le_mul_of_nonneg_left hbound (Real.exp_nonneg _)
  calc
    μ.real {ω | t ≤ ∑ i, (if B i ω then 1 else 0)} =
        μ.real (S ⁻¹' Set.Ici t) := by
      rfl
    _ ≤ Real.exp (-(Real.log (t / (∑ i, (p i : ℝ))) * t)) *
        (∫ ω, Real.exp (Real.log (t / (∑ i, (p i : ℝ))) * S ω) ∂μ) := by
      simpa [S, mul_comm] using hmarkov
    _ ≤ Real.exp (-(Real.log (t / (∑ i, (p i : ℝ))) * t)) *
        Real.exp ((Real.exp (Real.log (t / (∑ i, (p i : ℝ)))) - 1) *
          (∑ i, (p i : ℝ))) := hmul
    _ = Real.exp (-(∑ i, (p i : ℝ))) *
        ((Real.exp 1 * (∑ i, (p i : ℝ)) / t) ^ t) := by
      have ht0 : 0 < t := lt_trans hμ ht
      have hratio : 0 < t / (∑ i, (p i : ℝ)) := div_pos ht0 hμ
      have hbase : 0 < Real.exp 1 * (∑ i, (p i : ℝ)) / t :=
        div_pos (mul_pos (Real.exp_pos _) hμ) ht0
      rw [Real.exp_log hratio]
      rw [Real.rpow_def_of_pos hbase]
      rw [Real.log_div (mul_ne_zero (ne_of_gt (Real.exp_pos (1 : ℝ)))
        (ne_of_gt hμ)) (ne_of_gt ht0)]
      rw [Real.log_mul (ne_of_gt (Real.exp_pos (1 : ℝ))) (ne_of_gt hμ)]
      rw [Real.log_exp]
      rw [← Real.exp_add]
      rw [← Real.exp_add]
      congr 1
      rw [Real.log_div (ne_of_gt (lt_trans hμ ht)) (ne_of_gt hμ)]
      field_simp
      ring

theorem poissonBinomialLowerChernoffBound
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {p : ι → ℝ≥0}
    (hp : ∀ i, p i ≤ 1)
    (hB : iIndepFun B μ)
    (hLaw : ∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ)
    (hMeas : ∀ i, Measurable (B i))
    {t : ℝ}
    (hExp : ∀ i, Integrable
      (fun ω => Real.exp ((-Real.log ((∑ i, (p i : ℝ)) / t)) *
        (if B i ω then 1 else 0))) μ)
    (ht : 0 < t)
    (htμ : t < ∑ i, (p i : ℝ))
    (hExpS : Integrable
      (fun ω => Real.exp (Real.log ((∑ i, (p i : ℝ)) / t) *
        (-∑ i, (if B i ω then 1 else 0)))) μ) :
    μ.real {ω | ∑ i, (if B i ω then 1 else 0) ≤ t} ≤
      Real.exp (-(∑ i, (p i : ℝ))) *
        ((Real.exp 1 * (∑ i, (p i : ℝ)) / t) ^ t) := by
  let S : Ω → ℝ := fun ω => ∑ i, (if B i ω then 1 else 0)
  have hS : Measurable S := by
    dsimp [S]
    refine Finset.measurable_fun_sum Finset.univ ?_
    intro i hi
    exact Measurable.ite
      (measurableSet_preimage (hMeas i) (measurableSet_singleton (true : Bool)))
      measurable_const measurable_const
  have hμpos : 0 < ∑ i, (p i : ℝ) := lt_trans ht htμ
  have hratio : 0 < (∑ i, (p i : ℝ)) / t := div_pos hμpos ht
  have hlogpos : 0 < Real.log ((∑ i, (p i : ℝ)) / t) := by
    apply Real.log_pos
    rw [one_lt_div ht]
    exact htμ
  have hmgf := poissonBinomialMgfBound hp hB hLaw
    (-Real.log ((∑ i, (p i : ℝ)) / t)) hExp
  have hmarkov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (S := fun ω => -S ω)
      (lam := Real.log ((∑ i, (p i : ℝ)) / t)) (t := -t)
      hS.neg hlogpos hExpS
  have hbound :
      (∫ ω, Real.exp (Real.log ((∑ i, (p i : ℝ)) / t) * (-S ω)) ∂μ) ≤
        Real.exp ((Real.exp (-Real.log ((∑ i, (p i : ℝ)) / t)) - 1) *
          (∑ i, (p i : ℝ))) := by
    simpa [S, mul_neg] using hmgf
  have hmul :
      Real.exp (Real.log ((∑ i, (p i : ℝ)) / t) * t) *
          (∫ ω, Real.exp (Real.log ((∑ i, (p i : ℝ)) / t) * (-S ω)) ∂μ) ≤
        Real.exp (Real.log ((∑ i, (p i : ℝ)) / t) * t) *
          Real.exp ((Real.exp (-Real.log ((∑ i, (p i : ℝ)) / t)) - 1) *
            (∑ i, (p i : ℝ))) :=
    mul_le_mul_of_nonneg_left hbound (Real.exp_nonneg _)
  calc
    μ.real {ω | ∑ i, (if B i ω then 1 else 0) ≤ t} =
        μ.real ((fun ω => -S ω) ⁻¹' Set.Ici (-t)) := by
      congr 1
      ext ω
      simp [S, le_neg]
    _ ≤ Real.exp (Real.log ((∑ i, (p i : ℝ)) / t) * t) *
        (∫ ω, Real.exp (Real.log ((∑ i, (p i : ℝ)) / t) * (-S ω)) ∂μ) := by
      simpa [mul_neg, mul_comm] using hmarkov
    _ ≤ Real.exp (Real.log ((∑ i, (p i : ℝ)) / t) * t) *
        Real.exp ((Real.exp (-Real.log ((∑ i, (p i : ℝ)) / t)) - 1) *
          (∑ i, (p i : ℝ))) := hmul
    _ = Real.exp (-(∑ i, (p i : ℝ))) *
        ((Real.exp 1 * (∑ i, (p i : ℝ)) / t) ^ t) := by
      have hμpos : 0 < ∑ i, (p i : ℝ) := lt_trans ht htμ
      have hbase : 0 < Real.exp 1 * (∑ i, (p i : ℝ)) / t :=
        div_pos (mul_pos (Real.exp_pos _) hμpos) ht
      rw [Real.exp_neg, Real.exp_log hratio]
      rw [Real.rpow_def_of_pos hbase]
      rw [Real.log_div (mul_ne_zero (ne_of_gt (Real.exp_pos (1 : ℝ)))
        (ne_of_gt hμpos)) (ne_of_gt ht)]
      rw [Real.log_mul (ne_of_gt (Real.exp_pos (1 : ℝ))) (ne_of_gt hμpos)]
      rw [Real.log_exp]
      rw [← Real.exp_add]
      rw [← Real.exp_add]
      congr 1
      rw [Real.log_div (ne_of_gt hμpos) (ne_of_gt ht)]
      field_simp
      ring

theorem poissonBinomialChernoffZeroCase
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {t : ℝ}
    (ht : 0 < t)
    (hZero : ∀ ω, ∑ i, (if B i ω then (1 : ℝ) else 0) = 0) :
    μ.real {ω | t ≤ ∑ i, (if B i ω then 1 else 0)} = 0 := by
  have hset : {ω | t ≤ ∑ i, (if B i ω then 1 else 0)} = (∅ : Set Ω) := by
    ext ω
    simp only [Set.mem_setOf_eq, Set.mem_empty_iff_false, iff_false]
    intro hω
    have hω' : t ≤ 0 := by
      calc
        t ≤ ∑ i, (if B i ω then 1 else 0) := hω
        _ = 0 := hZero ω
    exact (not_le_of_gt ht) hω'
  rw [hset]
  simp

private lemma poissonMeasure_mass (rate : ℝ≥0) (k : ℕ) :
    ProbabilityTheory.poissonMeasure rate {k} =
      ENNReal.ofReal (ProbabilityTheory.poissonPMFReal rate k) := by
  rw [ProbabilityTheory.poissonMeasure,
    PMF.toMeasure_apply_singleton _ k (measurableSet_singleton k)]
  rfl

private lemma poisson_add_fiber (n x : ℕ) :
    Prod.mk x ⁻¹' ((fun p : ℕ × ℕ => p.1 + p.2) ⁻¹' ({n} : Set ℕ)) =
      if x ≤ n then ({n - x} : Set ℕ) else ∅ := by
  by_cases h : x ≤ n
  · ext y
    simp only [Set.mem_preimage, Set.mem_singleton_iff]
    rw [if_pos h]
    constructor
    · intro heq
      exact Nat.eq_sub_of_add_eq (by simpa [Nat.add_comm] using heq)
    · intro heq
      rw [heq]
      exact Nat.add_sub_of_le h
  · ext y
    simp only [Set.mem_preimage, Set.mem_singleton_iff]
    rw [if_neg h]
    constructor
    · intro heq
      exact False.elim (h (by rw [← heq]; exact Nat.le_add_right x y))
    · intro heq
      exact False.elim heq

private lemma finite_tsum_of_support_le (n : ℕ) (f : ℕ → ℝ≥0∞)
    (hf : ∀ x, x > n → f x = 0) :
    (∑' x : ℕ, f x) = ∑ x ∈ Finset.range (n + 1), f x := by
  have hsupp : Function.support f ⊆ (↑(Finset.range (n + 1)) : Set ℕ) := by
    intro x hx
    simp only [Finset.mem_coe, Finset.mem_range]
    by_contra hxn
    apply hx
    exact hf x (Nat.le_of_not_gt hxn)
  rw [← tsum_subtype_eq_of_support_subset hsupp]
  exact Finset.tsum_subtype' (Finset.range (n + 1)) f

/-- The convolution of two Poisson measures is Poisson with the summed rate. -/
theorem poissonMeasure_conv_poissonMeasure (r s : ℝ≥0) :
    ProbabilityTheory.poissonMeasure r ∗ ProbabilityTheory.poissonMeasure s =
      ProbabilityTheory.poissonMeasure (r + s) := by
  apply Measure.ext_of_singleton
  intro n
  rw [Measure.conv, Measure.map_apply measurable_add (measurableSet_singleton n)]
  rw [Measure.prod_apply]
  rw [lintegral_countable']
  have hinner (x : ℕ) :
      ProbabilityTheory.poissonMeasure s
          (Prod.mk x ⁻¹' ((fun p : ℕ × ℕ => p.1 + p.2) ⁻¹' ({n} : Set ℕ))) =
        if x ≤ n then ENNReal.ofReal (ProbabilityTheory.poissonPMFReal s (n - x))
        else 0 := by
    rw [poisson_add_fiber]
    split_ifs with h
    · rw [poissonMeasure_mass]
    · simp
  simp_rw [hinner, poissonMeasure_mass]
  let f : ℕ → ℝ≥0∞ := fun x =>
    (if x ≤ n then ENNReal.ofReal (ProbabilityTheory.poissonPMFReal s (n - x)) else 0) *
      ENNReal.ofReal (ProbabilityTheory.poissonPMFReal r x)
  have hfinite : (∑' x : ℕ, f x) = ∑ x ∈ Finset.range (n + 1), f x := by
    apply finite_tsum_of_support_le
    intro x hx
    simp [f, Nat.not_le_of_gt hx]
  change (∑' x : ℕ, f x) = _
  rw [hfinite]
  have hsum_nonneg (x : ℕ) (hx : x ∈ Finset.range (n + 1)) :
      0 ≤ ProbabilityTheory.poissonPMFReal s (n - x) *
        ProbabilityTheory.poissonPMFReal r x :=
    mul_nonneg ProbabilityTheory.poissonPMFReal_nonneg
      ProbabilityTheory.poissonPMFReal_nonneg
  have hsum :
      (∑ x ∈ Finset.range (n + 1), f x) =
        ENNReal.ofReal
          (∑ x ∈ Finset.range (n + 1),
            ProbabilityTheory.poissonPMFReal s (n - x) *
              ProbabilityTheory.poissonPMFReal r x) := by
    rw [ENNReal.ofReal_sum_of_nonneg hsum_nonneg]
    apply Finset.sum_congr rfl
    intro x hx
    have hxn : x ≤ n := Nat.le_of_lt_succ (Finset.mem_range.1 hx)
    simp only [f, if_pos hxn]
    rw [← ENNReal.ofReal_mul ProbabilityTheory.poissonPMFReal_nonneg]
  rw [hsum]
  apply congrArg ENNReal.ofReal
  calc
    (∑ x ∈ Finset.range (n + 1),
        ProbabilityTheory.poissonPMFReal s (n - x) *
          ProbabilityTheory.poissonPMFReal r x) =
      ∑ x ∈ Finset.range (n + 1),
        Real.exp (-(↑r + ↑s)) / (n.factorial : ℝ) *
          (n.choose x : ℝ) * (↑s : ℝ) ^ (n - x) * (↑r : ℝ) ^ x := by
        apply Finset.sum_congr rfl
        intro x hx
        have hxn : x ≤ n := Nat.le_of_lt_succ (Finset.mem_range.1 hx)
        have hfac_nat := Nat.choose_mul_factorial_mul_factorial hxn
        have hfac : (n.choose x : ℝ) * (x.factorial : ℝ) *
            ((n - x).factorial : ℝ) = (n.factorial : ℝ) := by
          exact_mod_cast hfac_nat
        simp only [ProbabilityTheory.poissonPMFReal]
        have hexp : Real.exp (-↑s) * Real.exp (-↑r) =
            Real.exp (-(↑r + ↑s)) := by
          rw [← Real.exp_add]
          congr 1
          ring
        field_simp [Nat.factorial_ne_zero, Real.exp_ne_zero]
        calc
          _ = Real.exp (-↑s) * Real.exp (-↑r) * (↑s : ℝ) ^ (n - x) *
              (↑r : ℝ) ^ x * (n.factorial : ℝ) := by ring
          _ = _ := by
            rw [hexp]
            rw [← hfac]
            ring
    _ = Real.exp (-(↑r + ↑s)) / (n.factorial : ℝ) * (↑r + ↑s) ^ n := by
      calc
        (∑ x ∈ Finset.range (n + 1),
            Real.exp (-(↑r + ↑s)) / (n.factorial : ℝ) *
              (n.choose x : ℝ) * (↑s : ℝ) ^ (n - x) * (↑r : ℝ) ^ x) =
          Real.exp (-(↑r + ↑s)) / (n.factorial : ℝ) *
            ∑ x ∈ Finset.range (n + 1),
              (n.choose x : ℝ) * (↑s : ℝ) ^ (n - x) * (↑r : ℝ) ^ x := by
            rw [Finset.mul_sum]
            apply Finset.sum_congr rfl
            intro x hx
            ring
        _ = Real.exp (-(↑r + ↑s)) / (n.factorial : ℝ) * (↑r + ↑s) ^ n := by
          have hbin := add_pow (↑r : ℝ) (↑s : ℝ) n
          calc
            Real.exp (-(↑r + ↑s)) / (n.factorial : ℝ) *
                ∑ x ∈ Finset.range (n + 1),
                  (n.choose x : ℝ) * (↑s : ℝ) ^ (n - x) * (↑r : ℝ) ^ x =
              Real.exp (-(↑r + ↑s)) / (n.factorial : ℝ) *
                ∑ x ∈ Finset.range (n + 1),
                  (↑r : ℝ) ^ x * (↑s : ℝ) ^ (n - x) * (n.choose x : ℝ) := by
                    apply congrArg (fun z => Real.exp (-(↑r + ↑s)) /
                      (n.factorial : ℝ) * z)
                    apply Finset.sum_congr rfl
                    intro x hx
                    ring
            _ = Real.exp (-(↑r + ↑s)) / (n.factorial : ℝ) * (↑r + ↑s) ^ n := by
              rw [hbin]
    _ = ProbabilityTheory.poissonPMFReal (r + s) n := by
      simp only [ProbabilityTheory.poissonPMFReal, NNReal.coe_add]
      ring
  all_goals exact measurableSet_preimage measurable_add (measurableSet_singleton n)

private lemma exp_add_half_le (δ : ℝ) (hδ0 : 0 ≤ δ) (hδ1 : δ ≤ 1) :
    Real.exp (δ / 2) ≤ 1 + δ / 2 + (δ / 2) ^ 2 := by
  have hrem := Real.abs_exp_sub_one_sub_id_le (x := δ / 2) (by
    calc
      |δ / 2| = δ / 2 := abs_of_nonneg (by positivity)
      _ ≤ 1 := by linarith)
  have hrem' : Real.exp (δ / 2) - 1 - δ / 2 ≤ (δ / 2) ^ 2 :=
    (le_abs_self _).trans hrem
  linarith

private lemma exp_neg_half_le (δ : ℝ) (hδ0 : 0 ≤ δ) (hδ1 : δ ≤ 1) :
    Real.exp (-δ / 2) ≤ 1 - δ / 2 + (δ / 2) ^ 2 := by
  have hrem := Real.abs_exp_sub_one_sub_id_le (x := -δ / 2) (by
    calc
      |-δ / 2| = δ / 2 := by
        rw [abs_of_nonpos (by linarith)]
        ring
      _ ≤ 1 := by linarith)
  have hrem' : Real.exp (-δ / 2) - 1 - (-δ / 2) ≤ (-δ / 2) ^ 2 :=
    (le_abs_self _).trans hrem
  linarith

/-! Exercise 2.3.5: the optimized Poisson-binomial Chernoff bounds imply a
quadratic two-sided estimate.  We use the non-optimized parameter `δ/2`; the
second-order exponential remainder gives the explicit universal constant
`c = 1/4` uniformly for `0 < δ ≤ 1`. -/
theorem poissonBinomialTwoSidedQuadraticBound
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {p : ι → ℝ≥0}
    (hp : ∀ i, p i ≤ 1)
    (hB : iIndepFun B μ)
    (hLaw : ∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ)
    (hMeas : ∀ i, Measurable (B i))
    {δ : ℝ} (hδ0 : 0 < δ) (hδ1 : δ ≤ 1)
    (hExp : ∀ (lam : ℝ) (i : ι),
      Integrable (fun ω => Real.exp (lam * (if B i ω then 1 else 0))) μ)
    (hExpS : ∀ (lam : ℝ),
      Integrable (fun ω => Real.exp (lam * ∑ i, (if B i ω then 1 else 0))) μ) :
    μ.real {ω |
        δ * (∑ i, (p i : ℝ)) ≤
          |(∑ i, (if B i ω then 1 else 0)) - ∑ i, (p i : ℝ)|} ≤
      2 * Real.exp (-(∑ i, (p i : ℝ)) * δ ^ 2 / 4) := by
  let S : Ω → ℝ := fun ω => ∑ i, (if B i ω then 1 else 0)
  let m : ℝ := ∑ i, (p i : ℝ)
  have hm : 0 ≤ m := by
    dsimp [m]
    exact Finset.sum_nonneg (fun i _ => by positivity)
  have hS : Measurable S := by
    dsimp [S]
    refine Finset.measurable_fun_sum Finset.univ ?_
    intro i hi
    exact Measurable.ite
      (measurableSet_preimage (hMeas i) (measurableSet_singleton (true : Bool)))
      measurable_const measurable_const
  have hupper_mgf := poissonBinomialMgfBound hp hB hLaw (δ / 2) (by
    intro i
    exact hExp (δ / 2) i)
  have hlower_mgf := poissonBinomialMgfBound hp hB hLaw (-δ / 2) (by
    intro i
    exact hExp (-δ / 2) i)
  have hupper_markov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (μ := μ) (t := (1 + δ) * m) hS (by linarith) (hExpS (δ / 2))
  have hlower_markov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (μ := μ) (S := fun ω => -S ω) (lam := δ / 2) (t := -(1 - δ) * m)
      hS.neg (by linarith)
    (by
      have hEq :
          (fun ω => Real.exp (δ / 2 * (fun ω => -S ω) ω)) =
            (fun ω => Real.exp ((-δ / 2) * ∑ i, (if B i ω then 1 else 0))) := by
        funext ω
        dsimp [S]
        congr 1
        ring
      rw [hEq]
      exact hExpS (-δ / 2))
  have hupper_exp : Real.exp (δ / 2) ≤ 1 + δ / 2 + (δ / 2) ^ 2 :=
    exp_add_half_le δ hδ0.le hδ1
  have hlower_exp : Real.exp (-δ / 2) ≤ 1 - δ / 2 + (δ / 2) ^ 2 :=
    exp_neg_half_le δ hδ0.le hδ1
  have hupper_coeff :
      -(δ / 2 * ((1 + δ) * m)) + (Real.exp (δ / 2) - 1) * m ≤
        -(m * δ ^ 2 / 4) := by
    have hcoeff :
        -(δ / 2 * (1 + δ)) + (Real.exp (δ / 2) - 1) ≤ -(δ ^ 2 / 4) := by
      nlinarith [hupper_exp]
    have := mul_le_mul_of_nonneg_right hcoeff hm
    nlinarith
  have hlower_coeff :
      -(δ / 2 * (-(1 - δ) * m)) + (Real.exp (-δ / 2) - 1) * m ≤
        -(m * δ ^ 2 / 4) := by
    have hcoeff :
        (δ / 2) * (1 - δ) + (Real.exp (-δ / 2) - 1) ≤ -(δ ^ 2 / 4) := by
      nlinarith [hlower_exp]
    have := mul_le_mul_of_nonneg_right hcoeff hm
    nlinarith
  have hupper_raw : μ.real (S ⁻¹' Set.Ici ((1 + δ) * m)) ≤
      Real.exp (-(δ / 2 * ((1 + δ) * m))) *
        Real.exp ((Real.exp (δ / 2) - 1) * m) := by
    apply le_trans hupper_markov
    apply mul_le_mul_of_nonneg_left _ (Real.exp_nonneg _)
    simpa [S, m, mul_assoc] using hupper_mgf
  have hlower_raw : μ.real ((fun ω => -S ω) ⁻¹' Set.Ici (-(1 - δ) * m)) ≤
      Real.exp (-(δ / 2 * (-(1 - δ) * m))) *
        Real.exp ((Real.exp (-δ / 2) - 1) * m) := by
    apply le_trans hlower_markov
    apply mul_le_mul_of_nonneg_left _ (Real.exp_nonneg _)
    have hEq :
        (fun ω => Real.exp (δ / 2 * (fun ω => -S ω) ω)) =
          (fun ω => Real.exp ((-δ / 2) * ∑ i, (if B i ω then 1 else 0))) := by
      funext ω
      dsimp [S]
      congr 1
      ring
    rw [hEq]
    simpa [m] using hlower_mgf
  have hupper : μ.real {ω | (1 + δ) * m ≤ S ω} ≤
      Real.exp (-(m * δ ^ 2 / 4)) := by
    rw [show {ω | (1 + δ) * m ≤ S ω} = S ⁻¹' Set.Ici ((1 + δ) * m) by rfl]
    refine hupper_raw.trans ?_
    rw [← Real.exp_add]
    exact Real.exp_le_exp.2 hupper_coeff
  have hlower : μ.real {ω | S ω ≤ (1 - δ) * m} ≤
      Real.exp (-(m * δ ^ 2 / 4)) := by
    have hset : {ω | S ω ≤ (1 - δ) * m} =
        (fun ω => -S ω) ⁻¹' Set.Ici (-(1 - δ) * m) := by
      ext ω
      simp only [Set.mem_setOf_eq, Set.mem_preimage, Set.mem_Ici]
      constructor <;> intro h <;> linarith
    rw [hset]
    refine hlower_raw.trans ?_
    rw [← Real.exp_add]
    exact Real.exp_le_exp.2 hlower_coeff
  let U : Set Ω := {ω | (1 + δ) * m ≤ S ω}
  let L : Set Ω := {ω | S ω ≤ (1 - δ) * m}
  have hsubset : {ω | δ * m ≤ |S ω - m|} ⊆ U ∪ L := by
    intro ω hω
    change δ * m ≤ |S ω - m| at hω
    by_cases hupper : (1 + δ) * m ≤ S ω
    · exact Or.inl hupper
    · right
      have hnotupper : S ω < (1 + δ) * m := lt_of_not_ge hupper
      by_contra hnotlower
      have hlower' : (1 - δ) * m < S ω := lt_of_not_ge hnotlower
      have habs : |S ω - m| < δ * m := by
        rw [abs_lt]
        constructor <;> linarith
      exact (not_lt_of_ge hω) habs
  have hmono {A B : Set Ω} (hAB : A ⊆ B) : μ.real A ≤ μ.real B := by
    rw [Measure.real_def, Measure.real_def]
    exact ENNReal.toReal_mono (measure_ne_top μ B) (measure_mono hAB)
  have hunion : μ.real (U ∪ L) ≤ μ.real U + μ.real L := by
    rw [Measure.real_def, Measure.real_def, Measure.real_def]
    calc
      (μ (U ∪ L)).toReal ≤ (μ U + μ L).toReal := by
        apply ENNReal.toReal_mono
        · exact ENNReal.add_ne_top.mpr ⟨measure_ne_top μ U, measure_ne_top μ L⟩
        · exact measure_union_le U L
      _ = (μ U).toReal + (μ L).toReal :=
        ENNReal.toReal_add (measure_ne_top μ U) (measure_ne_top μ L)
  have hfinal : μ.real {ω | δ * m ≤ |S ω - m|} ≤
      2 * Real.exp (-m * δ ^ 2 / 4) := by
    calc
      μ.real {ω | δ * m ≤ |S ω - m|} ≤ μ.real (U ∪ L) := hmono hsubset
      _ ≤ μ.real U + μ.real L := hunion
      _ ≤ Real.exp (-(m * δ ^ 2 / 4)) + Real.exp (-(m * δ ^ 2 / 4)) :=
        add_le_add (by simpa [U] using hupper) (by simpa [L] using hlower)
      _ = 2 * Real.exp (-m * δ ^ 2 / 4) := by ring
  simpa [S, m] using hfinal

/-! The sum of independent Poisson variables has the Poisson law with summed rate. -/
theorem poissonAddLaw
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X Y : Ω → ℕ} {r s : ℝ≥0}
    (hX : HasLaw X (ProbabilityTheory.poissonMeasure r) μ)
    (hY : HasLaw Y (ProbabilityTheory.poissonMeasure s) μ)
    (hXY : X ⟂ᵢ[μ] Y) :
    HasLaw (X + Y) (ProbabilityTheory.poissonMeasure (r + s)) μ := by
  have h := hXY.hasLaw_add hX hY
  rw [poissonMeasure_conv_poissonMeasure] at h
  exact h

/-! The point-mass sharpness calculation from Remark 2.3.4.  We state the
asymptotic with its exact Stirling normalization; the book's `≍` notation is
the corresponding two-sided constant-factor consequence. -/
theorem poissonPointMass_isEquivalent_stirling (rate : ℝ≥0) (hrate : 0 < rate) :
    (fun k : ℕ => ProbabilityTheory.poissonPMFReal rate k) ~[Filter.atTop]
      (fun k : ℕ =>
        Real.exp (-(rate : ℝ)) *
          (Real.exp 1 * (rate : ℝ) / (k : ℝ)) ^ k /
            Real.sqrt (2 * (k : ℝ) * Real.pi)) := by
  have _hrate_real : 0 < (rate : ℝ) := by exact_mod_cast hrate
  have hfactorial := Stirling.factorial_isEquivalent_stirling
  have hnumerator :
      (fun k : ℕ => Real.exp (-(rate : ℝ)) * (rate : ℝ) ^ k) ~[Filter.atTop]
        (fun k : ℕ => Real.exp (-(rate : ℝ)) * (rate : ℝ) ^ k) :=
    Asymptotics.IsEquivalent.refl
  have hinverse :
      (fun k : ℕ => ((k.factorial : ℝ)⁻¹)) ~[Filter.atTop]
        (fun k : ℕ =>
          (Real.sqrt (2 * (k : ℝ) * Real.pi) *
          ((k : ℝ) / Real.exp 1) ^ k)⁻¹) := by
    simpa only [Pi.inv_apply] using hfactorial.inv
  have hproduct :
      (fun k : ℕ =>
        Real.exp (-(rate : ℝ)) * (rate : ℝ) ^ k *
          ((k.factorial : ℝ)⁻¹)) ~[Filter.atTop]
        (fun k : ℕ =>
          Real.exp (-(rate : ℝ)) * (rate : ℝ) ^ k *
            (Real.sqrt (2 * (k : ℝ) * Real.pi) *
            ((k : ℝ) / Real.exp 1) ^ k)⁻¹) := by
    simpa only [Pi.mul_apply] using hnumerator.mul hinverse
  have hleft :
      (fun k : ℕ =>
        Real.exp (-(rate : ℝ)) * (rate : ℝ) ^ k *
          ((k.factorial : ℝ)⁻¹)) =ᶠ[Filter.atTop]
        (fun k : ℕ => ProbabilityTheory.poissonPMFReal rate k) := by
    filter_upwards [] with k
    simp [ProbabilityTheory.poissonPMFReal, div_eq_mul_inv]
  have hright :
      (fun k : ℕ =>
        Real.exp (-(rate : ℝ)) * (rate : ℝ) ^ k *
          (Real.sqrt (2 * (k : ℝ) * Real.pi) *
            ((k : ℝ) / Real.exp 1) ^ k)⁻¹) =ᶠ[Filter.atTop]
        (fun k : ℕ =>
          Real.exp (-(rate : ℝ)) *
            (Real.exp 1 * (rate : ℝ) / (k : ℝ)) ^ k /
              Real.sqrt (2 * (k : ℝ) * Real.pi)) := by
    have hlarge : ∀ᶠ k : ℕ in Filter.atTop, 1 ≤ k :=
      Filter.eventually_atTop.2 ⟨1, fun _ hk => hk⟩
    filter_upwards [hlarge] with k hk
    have hk0 : (k : ℝ) ≠ 0 := by
      exact_mod_cast (Nat.ne_of_gt hk)
    have hscale : Real.sqrt (2 * (k : ℝ) * Real.pi) ≠ 0 := by
      positivity
    rw [div_pow, div_pow]
    field_simp [hk0, hscale, Real.exp_ne_zero]
    rw [mul_pow]
  exact (hproduct.congr_left hleft).congr_right hright

/-- The scalar Bernoulli MGF identity and its finite independent-product bound. -/
structure BernoulliMgfModelData : Prop where
  scalar : ∀ (p : ℝ≥0), (hp : p ≤ 1) → ∀ lam : ℝ,
    ((∫ b : Bool, Real.exp (lam * (if b then 1 else 0)) ∂
        (PMF.bernoulli p hp).toMeasure) =
        1 + (Real.exp lam - 1) * (p : ℝ)) ∧
      (1 + (Real.exp lam - 1) * (p : ℝ) ≤
        Real.exp ((Real.exp lam - 1) * (p : ℝ)))
  tensor : ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {p : ι → ℝ≥0},
    (hp : ∀ i, p i ≤ 1) →
    iIndepFun B μ →
    (∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ) →
    ∀ lam : ℝ,
    (∀ i, Integrable
      (fun ω => Real.exp (lam * (if B i ω then 1 else 0))) μ) →
    (∫ ω, Real.exp (lam * ∑ i, (if B i ω then 1 else 0)) ∂μ) ≤
      Real.exp ((Real.exp lam - 1) * ∑ i, (p i : ℝ))

theorem bernoulliMgfModel : BernoulliMgfModelData :=
  { scalar := fun p hp lam => bernoulliMgfBound p hp lam
    tensor := fun hp hB hLaw lam hExp => poissonBinomialMgfBound hp hB hLaw lam hExp }

/-- The source-facing data for `G(n,p)` and its vertex-degree observable. -/
structure ErdosRenyiModelData (n : ℕ) (p : Set.Icc (0 : ℝ) 1) where
  /-- The stored measure on graphs. -/
  graphLaw : Measure (SimpleGraph (Fin n))
  /-- The stored natural-valued observable for each vertex and graph. -/
  degree : Fin n → SimpleGraph (Fin n) → ℕ

/-- The Erdős--Rényi model on `Fin n`, with independent edge indicators. -/
noncomputable def erdosRenyiModel (n : ℕ) (p : Set.Icc (0 : ℝ) 1) :
    ErdosRenyiModelData n p :=
  { graphLaw := SimpleGraph.binomialRandom (Fin n) p
    degree := fun v G =>
      @SimpleGraph.degree (Fin n) G v (Fintype.ofFinite (G.neighborSet v)) }

theorem erdosRenyiModel_degree_eq_graphDegreeSum
    (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (v : Fin n) (G : SimpleGraph (Fin n)) :
    (erdosRenyiModel n p).degree v G = graphDegreeSum v G := by
  dsimp [erdosRenyiModel]
  letI : Fintype (G.neighborSet v) := Fintype.ofFinite _
  calc
    @SimpleGraph.degree (Fin n) G v (Fintype.ofFinite (G.neighborSet v)) =
        Fintype.card (G.neighborSet v) :=
      (SimpleGraph.card_neighborSet_eq_degree G v).symm
    _ = (G.neighborSet v).ncard := by
      rw [Set.ncard_eq_toFinset_card', Set.toFinset_card]
    _ = graphDegreeSum v G := (graphDegreeSum_eq_graphDegree v G).symm

/-- The fixed set of possible edges incident to a vertex.  This is the finite
edge-coordinate index set used when reducing a random-graph degree to a
Bernoulli product observable. -/
def potentialIncidentEdges {V : Type*} (v : V) : Set (Sym2 V) :=
  (⊤ : SimpleGraph V).incidenceSet v

/-- Count the selected edges in the fixed potential incidence set. -/
def incidentEdgeCount {V : Type*} [Fintype V] (v : V) (G : SimpleGraph V) : ℕ :=
  (potentialIncidentEdges v ∩ G.edgeSet).ncard

theorem potentialIncidentEdges_inter_edgeSet {V : Type*} [Fintype V]
    (v : V) (G : SimpleGraph V) :
    potentialIncidentEdges v ∩ G.edgeSet = G.incidenceSet v := by
  classical
  ext e
  constructor
  · rintro ⟨⟨_, hv⟩, he⟩
    exact ⟨he, hv⟩
  · rintro ⟨he, hv⟩
    have heTop : e ∈ (⊤ : SimpleGraph V).edgeSet := by
      simpa [SimpleGraph.edgeSet] using G.not_isDiag_of_mem_edgeSet he
    exact ⟨⟨heTop, hv⟩, he⟩

theorem incidentEdgeCount_eq_degree {V : Type*} [Fintype V]
    (v : V) (G : SimpleGraph V) :
    incidentEdgeCount v G = @SimpleGraph.degree V G v (Fintype.ofFinite (G.neighborSet v)) := by
  classical
  letI : Fintype (G.neighborSet v) := Fintype.ofFinite _
  rw [incidentEdgeCount, potentialIncidentEdges_inter_edgeSet]
  simp [Set.ncard_eq_toFinset_card']

/-- The canonical Erdős--Rényi law is a probability measure. -/
instance erdosRenyiModel.isProbabilityMeasure
    (n : ℕ) (p : Set.Icc (0 : ℝ) 1) :
    IsProbabilityMeasure (erdosRenyiModel n p).graphLaw := by
  dsimp [erdosRenyiModel]
  infer_instance

theorem erdosRenyiDegreeLaw
    (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (v : Fin n) :
    HasLaw ((erdosRenyiModel n p).degree v)
      (graphBinomialLaw n p)
      (erdosRenyiModel n p).graphLaw := by
  have h := graphDegreeSum_hasLaw p v
  have hcongr :
      (erdosRenyiModel n p).degree v = graphDegreeSum v := by
    funext G
    exact erdosRenyiModel_degree_eq_graphDegreeSum n p v G
  have h' := h.congr (Filter.Eventually.of_forall (fun G => congrFun hcongr G))
  simpa [erdosRenyiModel] using h'

/-! The exact finite MGF of Mathlib's canonical binomial PMF. -/
theorem binomialMgfExact (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (lam : ℝ) :
    (∫ k : Fin (n + 1), Real.exp (lam * (k : ℝ)) ∂
      (PMF.binomial (unitInterval.toNNReal p)
        (by change (p : ℝ) ≤ 1; exact p.2.2) n).toMeasure) =
      (1 - (p : ℝ) + (p : ℝ) * Real.exp lam) ^ n := by
  rw [PMF.integral_eq_sum]
  simp only [smul_eq_mul, PMF.binomial_apply]
  rw [Finset.sum_fin_eq_sum_range]
  have hpNN : unitInterval.toNNReal p ≤ 1 := by
    change (p : ℝ) ≤ 1
    exact p.2.2
  have hq :
      (1 - (unitInterval.toNNReal p : ℝ≥0∞)).toReal = 1 - (p : ℝ) := by
    rw [ENNReal.toReal_sub_of_le (by exact_mod_cast hpNN) ENNReal.one_ne_top]
    rfl
  rw [show 1 - (p : ℝ) + (p : ℝ) * Real.exp lam =
      ((p : ℝ) * Real.exp lam) + (1 - (p : ℝ)) by ring]
  rw [add_pow]
  apply Finset.sum_congr rfl
  intro x hx
  have hxn : x ≤ n := Nat.le_of_lt_succ (Finset.mem_range.mp hx)
  have hexp : Real.exp (lam * (x : ℝ)) = Real.exp lam ^ x := by
    rw [mul_comm, Real.exp_nat_mul]
  simp only [dif_pos (Nat.lt_succ_of_le hxn)]
  simp [hq, ENNReal.toReal_mul, hexp]
  ring

theorem binomialMgfBound (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (lam : ℝ) :
    (∫ k : Fin (n + 1), Real.exp (lam * (k : ℝ)) ∂
      (PMF.binomial (unitInterval.toNNReal p)
        (by change (p : ℝ) ≤ 1; exact p.2.2) n).toMeasure) ≤
      Real.exp ((Real.exp lam - 1) * (n * (p : ℝ))) := by
  rw [binomialMgfExact]
  have hbase : 1 + (Real.exp lam - 1) * (p : ℝ) ≤
      Real.exp ((Real.exp lam - 1) * (p : ℝ)) := by
    simpa [add_comm] using
      Real.add_one_le_exp ((Real.exp lam - 1) * (p : ℝ))
  have hpow :
      (1 + (Real.exp lam - 1) * (p : ℝ)) ^ n ≤
        Real.exp ((Real.exp lam - 1) * (p : ℝ)) ^ n :=
    pow_le_pow_left₀ (by
      have hp0 : 0 ≤ (p : ℝ) := p.2.1
      have hp1 : (p : ℝ) ≤ 1 := p.2.2
      have hprod : -(p : ℝ) ≤ (Real.exp lam - 1) * (p : ℝ) := by
        have he : 0 ≤ Real.exp lam := (Real.exp_pos lam).le
        nlinarith [mul_le_mul_of_nonneg_right (by linarith) hp0]
      linarith [hp1, hprod]) hbase n
  calc
    (1 - (p : ℝ) + (p : ℝ) * Real.exp lam) ^ n =
        (1 + (Real.exp lam - 1) * (p : ℝ)) ^ n := by
      congr 1
      ring
    _ ≤ Real.exp ((Real.exp lam - 1) * (p : ℝ)) ^ n := hpow
    _ = Real.exp ((Real.exp lam - 1) * (n * (p : ℝ))) := by
      rw [← Real.exp_nat_mul]
      congr 1
      ring

private lemma exp_add_half_le_graph (δ : ℝ) (hδ0 : 0 ≤ δ) (hδ1 : δ ≤ 1) :
    Real.exp (δ / 2) ≤ 1 + δ / 2 + (δ / 2) ^ 2 := by
  have hrem := Real.abs_exp_sub_one_sub_id_le (x := δ / 2) (by
    calc
      |δ / 2| = δ / 2 := abs_of_nonneg (by positivity)
      _ ≤ 1 := by linarith)
  have hrem' : Real.exp (δ / 2) - 1 - δ / 2 ≤ (δ / 2) ^ 2 :=
    (le_abs_self _).trans hrem
  linarith

private lemma exp_neg_half_le_graph (δ : ℝ) (hδ0 : 0 ≤ δ) (hδ1 : δ ≤ 1) :
    Real.exp (-δ / 2) ≤ 1 - δ / 2 + (δ / 2) ^ 2 := by
  have hrem := Real.abs_exp_sub_one_sub_id_le (x := -δ / 2) (by
    calc
      |-δ / 2| = δ / 2 := by
        rw [abs_of_nonpos (by linarith)]
        ring
      _ ≤ 1 := by linarith)
  have hrem' : Real.exp (-δ / 2) - 1 - (-δ / 2) ≤ (-δ / 2) ^ 2 :=
    (le_abs_self _).trans hrem
  linarith

theorem binomialTwoSidedBound (m : ℕ) (p : Set.Icc (0 : ℝ) 1) {δ : ℝ}
    (hδ0 : 0 < δ) (hδ1 : δ ≤ 1) :
    let μ : Measure (Fin (m + 1)) :=
      (PMF.binomial (unitInterval.toNNReal p)
        (by change (p : ℝ) ≤ 1; exact p.2.2) m).toMeasure
    μ.real {k |
        δ * (m * (p : ℝ)) ≤ |(k : ℝ) - m * (p : ℝ)|} ≤
      2 * Real.exp (-(m * (p : ℝ)) * δ ^ 2 / 4) := by
  dsimp
  let μ : Measure (Fin (m + 1)) :=
    (PMF.binomial (unitInterval.toNNReal p)
      (by change (p : ℝ) ≤ 1; exact p.2.2) m).toMeasure
  let S : Fin (m + 1) → ℝ := fun k => (k : ℝ)
  let mr : ℝ := m * (p : ℝ)
  have hm : 0 ≤ mr := by
    dsimp [mr]
    exact mul_nonneg (by positivity) p.2.1
  have hS : Measurable S := by
    dsimp [S]
    exact measurable_of_finite _
  have hupper_mgf :
      (∫ k, Real.exp ((δ / 2) * S k) ∂μ) ≤
        Real.exp ((Real.exp (δ / 2) - 1) * mr) := by
    simpa [S, mr, μ] using binomialMgfBound m p (δ / 2)
  have hlower_mgf :
      (∫ k, Real.exp ((-δ / 2) * S k) ∂μ) ≤
        Real.exp ((Real.exp (-δ / 2) - 1) * mr) := by
    simpa [S, mr, μ] using binomialMgfBound m p (-δ / 2)
  have hupper_markov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (μ := μ) (S := S) (lam := δ / 2) (t := (1 + δ) * mr) hS (by linarith)
      (by exact Integrable.of_finite)
  have hlower_markov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (μ := μ) (S := fun k => -S k) (lam := δ / 2)
      (t := -(1 - δ) * mr) hS.neg (by linarith)
      (by exact Integrable.of_finite)
  have hupper_exp : Real.exp (δ / 2) ≤ 1 + δ / 2 + (δ / 2) ^ 2 :=
    exp_add_half_le_graph δ hδ0.le hδ1
  have hlower_exp : Real.exp (-δ / 2) ≤ 1 - δ / 2 + (δ / 2) ^ 2 :=
    exp_neg_half_le_graph δ hδ0.le hδ1
  have hupper_coeff :
      -(δ / 2 * ((1 + δ) * mr)) + (Real.exp (δ / 2) - 1) * mr ≤
        -(mr * δ ^ 2 / 4) := by
    have hcoeff :
        -(δ / 2 * (1 + δ)) + (Real.exp (δ / 2) - 1) ≤ -(δ ^ 2 / 4) := by
      nlinarith [hupper_exp]
    have := mul_le_mul_of_nonneg_right hcoeff hm
    nlinarith
  have hlower_coeff :
      -(δ / 2 * (-(1 - δ) * mr)) + (Real.exp (-δ / 2) - 1) * mr ≤
        -(mr * δ ^ 2 / 4) := by
    have hcoeff :
        (δ / 2) * (1 - δ) + (Real.exp (-δ / 2) - 1) ≤ -(δ ^ 2 / 4) := by
      nlinarith [hlower_exp]
    have := mul_le_mul_of_nonneg_right hcoeff hm
    nlinarith
  have hupper_raw : μ.real (S ⁻¹' Set.Ici ((1 + δ) * mr)) ≤
      Real.exp (-(δ / 2 * ((1 + δ) * mr))) *
        Real.exp ((Real.exp (δ / 2) - 1) * mr) := by
    apply le_trans hupper_markov
    apply mul_le_mul_of_nonneg_left _ (Real.exp_nonneg _)
    simpa [S, mr] using hupper_mgf
  have hlower_raw : μ.real ((fun k => -S k) ⁻¹' Set.Ici (-(1 - δ) * mr)) ≤
      Real.exp (-(δ / 2 * (-(1 - δ) * mr))) *
        Real.exp ((Real.exp (-δ / 2) - 1) * mr) := by
    apply le_trans hlower_markov
    apply mul_le_mul_of_nonneg_left _ (Real.exp_nonneg _)
    convert hlower_mgf using 1
    all_goals simp [S]
    all_goals ring
  have hupper : μ.real {k | (1 + δ) * mr ≤ S k} ≤
      Real.exp (-(mr * δ ^ 2 / 4)) := by
    rw [show {k | (1 + δ) * mr ≤ S k} = S ⁻¹' Set.Ici ((1 + δ) * mr) by rfl]
    refine hupper_raw.trans ?_
    rw [← Real.exp_add]
    exact Real.exp_le_exp.2 hupper_coeff
  have hlower : μ.real {k | S k ≤ (1 - δ) * mr} ≤
      Real.exp (-(mr * δ ^ 2 / 4)) := by
    have hset : {k | S k ≤ (1 - δ) * mr} =
        (fun k => -S k) ⁻¹' Set.Ici (-(1 - δ) * mr) := by
      ext k
      simp only [Set.mem_setOf_eq, Set.mem_preimage, Set.mem_Ici]
      constructor <;> intro h <;> linarith
    rw [hset]
    refine hlower_raw.trans ?_
    rw [← Real.exp_add]
    exact Real.exp_le_exp.2 hlower_coeff
  let U : Set (Fin (m + 1)) := {k | (1 + δ) * mr ≤ S k}
  let L : Set (Fin (m + 1)) := {k | S k ≤ (1 - δ) * mr}
  have hsubset : {k | δ * mr ≤ |S k - mr|} ⊆ U ∪ L := by
    intro k h
    change δ * mr ≤ |S k - mr| at h
    by_cases hu : (1 + δ) * mr ≤ S k
    · exact Or.inl hu
    · right
      have hnu : S k < (1 + δ) * mr := lt_of_not_ge hu
      by_contra hnl
      have hnl' : (1 - δ) * mr < S k := lt_of_not_ge hnl
      have habs : |S k - mr| < δ * mr := by
        rw [abs_lt]
        constructor <;> linarith
      exact (not_lt_of_ge h) habs
  have hmono {A B : Set (Fin (m + 1))} (hAB : A ⊆ B) : μ.real A ≤ μ.real B := by
    rw [Measure.real_def, Measure.real_def]
    exact ENNReal.toReal_mono (measure_ne_top μ B) (measure_mono hAB)
  have hunion : μ.real (U ∪ L) ≤ μ.real U + μ.real L := by
    rw [Measure.real_def, Measure.real_def, Measure.real_def]
    calc
      (μ (U ∪ L)).toReal ≤ (μ U + μ L).toReal := by
        apply ENNReal.toReal_mono
        · exact ENNReal.add_ne_top.mpr ⟨measure_ne_top μ U, measure_ne_top μ L⟩
        · exact measure_union_le U L
      _ = (μ U).toReal + (μ L).toReal :=
        ENNReal.toReal_add (measure_ne_top μ U) (measure_ne_top μ L)
  have hfinal : μ.real {k | δ * mr ≤ |S k - mr|} ≤
      2 * Real.exp (-mr * δ ^ 2 / 4) := by
    calc
      μ.real {k | δ * mr ≤ |S k - mr|} ≤ μ.real (U ∪ L) := hmono hsubset
      _ ≤ μ.real U + μ.real L := hunion
      _ ≤ Real.exp (-(mr * δ ^ 2 / 4)) + Real.exp (-(mr * δ ^ 2 / 4)) :=
        add_le_add (by simpa [U] using hupper) (by simpa [L] using hlower)
      _ = 2 * Real.exp (-mr * δ ^ 2 / 4) := by ring
  simpa [S, mr, μ] using hfinal

set_option maxHeartbeats 4000000 in
theorem erdosRenyiDegreeDeviationBound
    (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (v : Fin n) {δ : ℝ}
    (hδ0 : 0 < δ) (hδ1 : δ ≤ 1) :
    (erdosRenyiModel n p).graphLaw.real {G |
        δ * ((n - 1) * (p : ℝ)) ≤
          |((erdosRenyiModel n p).degree v G : ℝ) - (n - 1) * (p : ℝ)|} ≤
      2 * Real.exp (-((n - 1) * (p : ℝ)) * δ ^ 2 / 4) := by
  let A : Set ℕ := {k |
    δ * ((n - 1) * (p : ℝ)) ≤ |(k : ℝ) - (n - 1) * (p : ℝ)|}
  have hA : MeasurableSet A := by
    exact (Set.to_countable A).measurableSet
  have hLaw := erdosRenyiDegreeLaw n p v
  have hn0 : n ≠ 0 := by
    intro hn0
    subst n
    exact Nat.not_lt_zero _ v.isLt
  have hn1 : 1 ≤ n := Nat.one_le_iff_ne_zero.mpr hn0
  have hsub : ((n - 1 : ℕ) : ℝ) = (n : ℝ) - 1 := by
    rw [Nat.cast_sub hn1]
    norm_num
  have hgraph :
      (erdosRenyiModel n p).graphLaw.real
          ((erdosRenyiModel n p).degree v ⁻¹' A) =
        (graphBinomialLaw n p).real A := by
    rw [Measure.real_def, Measure.real_def, ← hLaw.map_eq,
      Measure.map_apply_of_aemeasurable hLaw.aemeasurable hA]
  rw [show {G |
      δ * ((n - 1) * (p : ℝ)) ≤
        |((erdosRenyiModel n p).degree v G : ℝ) - (n - 1) * (p : ℝ)|} =
      ((erdosRenyiModel n p).degree v ⁻¹' A) by
        ext G
        rfl]
  rw [hgraph]
  rw [graphBinomialLaw]
  have hpmf :
      ((PMF.map (fun i : Fin (n - 1 + 1) => (i : ℕ))
          (PMF.binomial (unitInterval.toNNReal p)
            (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1))).toMeasure).real A =
        (PMF.binomial (unitInterval.toNNReal p)
          (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1)).toMeasure.real
          ((fun i : Fin (n - 1 + 1) => (i : ℕ)) ⁻¹' A) := by
    change (((PMF.map (fun i : Fin (n - 1 + 1) => (i : ℕ))
        (PMF.binomial (unitInterval.toNNReal p)
          (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1))).toMeasure A).toReal) =
      ((PMF.binomial (unitInterval.toNNReal p)
        (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1)).toMeasure
        ((fun i : Fin (n - 1 + 1) => (i : ℕ)) ⁻¹' A)).toReal
    rw [PMF.toMeasure_map_apply (p := PMF.binomial (unitInterval.toNNReal p)
      (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1))
      (f := fun i : Fin (n - 1 + 1) => (i : ℕ))
      A (measurable_of_countable _) hA]
  rw [hpmf]
  have hpre :
      (fun i : Fin (n - 1 + 1) => (i : ℕ)) ⁻¹' A =
        {i : Fin (n - 1 + 1) | δ * ((n - 1) * (p : ℝ)) ≤
          |((i : ℕ) : ℝ) - (n - 1) * (p : ℝ)|} := by
    ext i
    rfl
  rw [hpre]
  simpa [hsub] using (binomialTwoSidedBound (n - 1) p hδ0 hδ1)

theorem binomialUpperTailBound (m : ℕ) (p : Set.Icc (0 : ℝ) 1) {t : ℝ} :
    let μ : Measure (Fin (m + 1)) :=
      (PMF.binomial (unitInterval.toNNReal p)
        (by change (p : ℝ) ≤ 1; exact p.2.2) m).toMeasure
    μ.real {k | t ≤ (k : ℝ)} ≤
      Real.exp (-t + 2 * (m * (p : ℝ))) := by
  dsimp
  let μ : Measure (Fin (m + 1)) :=
    (PMF.binomial (unitInterval.toNNReal p)
      (by change (p : ℝ) ≤ 1; exact p.2.2) m).toMeasure
  let S : Fin (m + 1) → ℝ := fun k => (k : ℝ)
  have hS : Measurable S := by
    dsimp [S]
    exact measurable_of_finite _
  have hmgf :
      (∫ k, Real.exp (S k) ∂μ) ≤
        Real.exp ((Real.exp 1 - 1) * (m * (p : ℝ))) := by
    simpa [S, μ, one_mul] using binomialMgfBound m p 1
  have hmarkov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (μ := μ) (S := S) (lam := 1) (t := t) hS (by norm_num)
      (by exact Integrable.of_finite)
  have hraw : μ.real (S ⁻¹' Set.Ici t) ≤
      Real.exp (-t) * Real.exp ((Real.exp 1 - 1) * (m * (p : ℝ))) := by
    calc
      μ.real (S ⁻¹' Set.Ici t) ≤
          Real.exp (-t) * (∫ k, Real.exp (S k) ∂μ) := by
        simpa [S, one_mul] using hmarkov
      _ ≤ Real.exp (-t) *
          Real.exp ((Real.exp 1 - 1) * (m * (p : ℝ))) :=
        mul_le_mul_of_nonneg_left hmgf (Real.exp_nonneg _)
  calc
    μ.real {k | t ≤ (k : ℝ)} = μ.real (S ⁻¹' Set.Ici t) := by rfl
    _ ≤ Real.exp (-t) *
        Real.exp ((Real.exp 1 - 1) * (m * (p : ℝ))) := hraw
    _ = Real.exp (-t + (Real.exp 1 - 1) * (m * (p : ℝ))) := by
      rw [← Real.exp_add]
    _ ≤ Real.exp (-t + 2 * (m * (p : ℝ))) := by
      apply Real.exp_le_exp.2
      have hμ : 0 ≤ (m : ℝ) * (p : ℝ) :=
        mul_nonneg (Nat.cast_nonneg _) p.2.1
      have hexp : Real.exp 1 - 1 < 2 := by
        linarith [Real.exp_one_lt_three]
      nlinarith

theorem erdosRenyiDegreeUpperBound
    (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (v : Fin n) {t : ℝ} :
    (erdosRenyiModel n p).graphLaw.real {G |
        t ≤ ((erdosRenyiModel n p).degree v G : ℝ)} ≤
      Real.exp (-t + 2 * ((n - 1) * (p : ℝ))) := by
  let A : Set ℕ := {k | t ≤ (k : ℝ)}
  have hA : MeasurableSet A := by
    exact (Set.to_countable A).measurableSet
  have hLaw := erdosRenyiDegreeLaw n p v
  have hn0 : n ≠ 0 := by
    intro hn0
    subst n
    exact Nat.not_lt_zero _ v.isLt
  have hn1 : 1 ≤ n := Nat.one_le_iff_ne_zero.mpr hn0
  have hsub : ((n - 1 : ℕ) : ℝ) = (n : ℝ) - 1 := by
    rw [Nat.cast_sub hn1]
    norm_num
  have hgraph :
      (erdosRenyiModel n p).graphLaw.real
          ((erdosRenyiModel n p).degree v ⁻¹' A) =
        (graphBinomialLaw n p).real A := by
    rw [Measure.real_def, Measure.real_def, ← hLaw.map_eq,
      Measure.map_apply_of_aemeasurable hLaw.aemeasurable hA]
  rw [show {G |
      t ≤ ((erdosRenyiModel n p).degree v G : ℝ)} =
      ((erdosRenyiModel n p).degree v ⁻¹' A) by
        ext G
        rfl]
  rw [hgraph, graphBinomialLaw]
  have hpmf :
      ((PMF.map (fun i : Fin (n - 1 + 1) => (i : ℕ))
          (PMF.binomial (unitInterval.toNNReal p)
            (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1))).toMeasure).real A =
        (PMF.binomial (unitInterval.toNNReal p)
          (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1)).toMeasure.real
          ((fun i : Fin (n - 1 + 1) => (i : ℕ)) ⁻¹' A) := by
    change (((PMF.map (fun i : Fin (n - 1 + 1) => (i : ℕ))
        (PMF.binomial (unitInterval.toNNReal p)
          (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1))).toMeasure A).toReal) =
      ((PMF.binomial (unitInterval.toNNReal p)
        (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1)).toMeasure
        ((fun i : Fin (n - 1 + 1) => (i : ℕ)) ⁻¹' A)).toReal
    rw [PMF.toMeasure_map_apply (p := PMF.binomial (unitInterval.toNNReal p)
      (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1))
      (f := fun i : Fin (n - 1 + 1) => (i : ℕ))
      A (measurable_of_countable _) hA]
  rw [hpmf]
  have hpre :
      (fun i : Fin (n - 1 + 1) => (i : ℕ)) ⁻¹' A =
        {i : Fin (n - 1 + 1) | t ≤ ((i : ℕ) : ℝ)} := by
    ext i
    rfl
  rw [hpre]
  simpa [hsub] using (binomialUpperTailBound (n - 1) p (t := t))

theorem binomialUpperTailMgfBound (m : ℕ) (p : Set.Icc (0 : ℝ) 1)
    {t lam : ℝ} (hlam : 0 < lam) :
    let μ : Measure (Fin (m + 1)) :=
      (PMF.binomial (unitInterval.toNNReal p)
        (by change (p : ℝ) ≤ 1; exact p.2.2) m).toMeasure
    μ.real {k | t ≤ (k : ℝ)} ≤
      Real.exp (-lam * t + (Real.exp lam - 1) * (m * (p : ℝ))) := by
  dsimp
  let μ : Measure (Fin (m + 1)) :=
    (PMF.binomial (unitInterval.toNNReal p)
      (by change (p : ℝ) ≤ 1; exact p.2.2) m).toMeasure
  let S : Fin (m + 1) → ℝ := fun k => (k : ℝ)
  have hS : Measurable S := by
    dsimp [S]
    exact measurable_of_finite _
  have hmgf :
      (∫ k, Real.exp (lam * S k) ∂μ) ≤
        Real.exp ((Real.exp lam - 1) * (m * (p : ℝ))) := by
    simpa [S, μ] using binomialMgfBound m p lam
  have hmarkov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (μ := μ) (S := S) (lam := lam) (t := t) hS hlam
      (by exact Integrable.of_finite)
  calc
    μ.real {k | t ≤ (k : ℝ)} = μ.real (S ⁻¹' Set.Ici t) := by rfl
    _ ≤ Real.exp (-lam * t) * (∫ k, Real.exp (lam * S k) ∂μ) := by
      simpa [S] using hmarkov
    _ ≤ Real.exp (-lam * t) *
        Real.exp ((Real.exp lam - 1) * (m * (p : ℝ))) :=
      mul_le_mul_of_nonneg_left hmgf (Real.exp_nonneg _)
    _ = Real.exp (-lam * t + (Real.exp lam - 1) * (m * (p : ℝ))) := by
      rw [← Real.exp_add]

theorem erdosRenyiDegreeUpperBoundAt
    (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (v : Fin n)
    {t lam : ℝ} (hlam : 0 < lam) :
    (erdosRenyiModel n p).graphLaw.real {G |
        t ≤ ((erdosRenyiModel n p).degree v G : ℝ)} ≤
      Real.exp (-lam * t + (Real.exp lam - 1) * ((n - 1) * (p : ℝ))) := by
  let A : Set ℕ := {k | t ≤ (k : ℝ)}
  have hA : MeasurableSet A := by
    exact (Set.to_countable A).measurableSet
  have hLaw := erdosRenyiDegreeLaw n p v
  have hn0 : n ≠ 0 := by
    intro hn0
    subst n
    exact Nat.not_lt_zero _ v.isLt
  have hn1 : 1 ≤ n := Nat.one_le_iff_ne_zero.mpr hn0
  have hsub : ((n - 1 : ℕ) : ℝ) = (n : ℝ) - 1 := by
    rw [Nat.cast_sub hn1]
    norm_num
  have hgraph :
      (erdosRenyiModel n p).graphLaw.real
          ((erdosRenyiModel n p).degree v ⁻¹' A) =
        (graphBinomialLaw n p).real A := by
    rw [Measure.real_def, Measure.real_def, ← hLaw.map_eq,
      Measure.map_apply_of_aemeasurable hLaw.aemeasurable hA]
  rw [show {G |
      t ≤ ((erdosRenyiModel n p).degree v G : ℝ)} =
      ((erdosRenyiModel n p).degree v ⁻¹' A) by
        ext G
        rfl]
  rw [hgraph, graphBinomialLaw]
  have hpmf :
      ((PMF.map (fun i : Fin (n - 1 + 1) => (i : ℕ))
          (PMF.binomial (unitInterval.toNNReal p)
            (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1))).toMeasure).real A =
        (PMF.binomial (unitInterval.toNNReal p)
          (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1)).toMeasure.real
          ((fun i : Fin (n - 1 + 1) => (i : ℕ)) ⁻¹' A) := by
    change (((PMF.map (fun i : Fin (n - 1 + 1) => (i : ℕ))
        (PMF.binomial (unitInterval.toNNReal p)
          (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1))).toMeasure A).toReal) =
      ((PMF.binomial (unitInterval.toNNReal p)
        (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1)).toMeasure
        ((fun i : Fin (n - 1 + 1) => (i : ℕ)) ⁻¹' A)).toReal
    rw [PMF.toMeasure_map_apply (p := PMF.binomial (unitInterval.toNNReal p)
      (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1))
      (f := fun i : Fin (n - 1 + 1) => (i : ℕ))
      A (measurable_of_countable _) hA]
  rw [hpmf]
  have hpre :
      (fun i : Fin (n - 1 + 1) => (i : ℕ)) ⁻¹' A =
        {i : Fin (n - 1 + 1) | t ≤ ((i : ℕ) : ℝ)} := by
    ext i
    rfl
  rw [hpre]
  simpa [hsub] using (binomialUpperTailMgfBound (n - 1) p (t := t) hlam)

set_option maxHeartbeats 4000000 in
theorem erdosRenyiAlmostRegular
    (n : ℕ) (hn : 2 ≤ n) (p : Set.Icc (0 : ℝ) 1)
    (hd : 4000 * Real.log (n : ℝ) ≤ (n - 1) * (p : ℝ)) :
    (erdosRenyiModel n p).graphLaw.real {G |
        ∀ v : Fin n,
          |((erdosRenyiModel n p).degree v G : ℝ) - (n - 1) * (p : ℝ)| <
            ((n - 1) * (p : ℝ)) / 10} ≥ (9 : ℝ) / 10 := by
  let d : ℝ := (n - 1) * (p : ℝ)
  let P : Measure (SimpleGraph (Fin n)) := (erdosRenyiModel n p).graphLaw
  let Bad : Fin n → Set (SimpleGraph (Fin n)) := fun v =>
    {G | (1 / 10 : ℝ) * d ≤
      |((erdosRenyiModel n p).degree v G : ℝ) - d|}
  let Good : Set (SimpleGraph (Fin n)) := {G |
    ∀ v : Fin n,
      |((erdosRenyiModel n p).degree v G : ℝ) - d| < d / 10}
  have hbad_meas : ∀ v : Fin n, MeasurableSet (Bad v) := by
    intro v
    have heq : Bad v = {G |
        (1 / 10 : ℝ) * d ≤ |(graphDegreeSum v G : ℝ) - d|} := by
      ext G
      simp only [Bad, Set.mem_setOf_eq]
      rw [erdosRenyiModel_degree_eq_graphDegreeSum]
    rw [heq]
    have hcast : Measurable (fun k : ℕ => (k : ℝ)) := measurable_of_countable _
    have hmeas : Measurable (fun G : SimpleGraph (Fin n) =>
        |(graphDegreeSum v G : ℝ) - d|) := by
      exact ((hcast.comp (measurable_graphDegreeSum v)).sub measurable_const).abs
    exact hmeas (measurableSet_Ici)
  have hbad_each : ∀ v : Fin n, P.real (Bad v) ≤
      2 * Real.exp (-d / 400) := by
    intro v
    dsimp [P, Bad, d]
    convert erdosRenyiDegreeDeviationBound n p v
      (δ := (1 : ℝ) / 10) (by norm_num) (by norm_num) using 1; ring
  have hbad_union : P.real (⋃ v, Bad v) ≤
      2 * (n : ℝ) * Real.exp (-d / 400) := by
    calc
      P.real (⋃ v, Bad v) ≤ ∑ v, P.real (Bad v) :=
        measureReal_iUnion_fintype_le (μ := P) Bad
      _ ≤ ∑ _v : Fin n, 2 * Real.exp (-d / 400) := by
        exact Finset.sum_le_sum (fun v _ => hbad_each v)
      _ = 2 * (n : ℝ) * Real.exp (-d / 400) := by
        simp
        ring
  have hnpos : 0 < (n : ℝ) := by
    exact_mod_cast (Nat.zero_lt_of_lt hn)
  have hn2 : (2 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  have hdexp : Real.exp (-d / 400) ≤
      Real.exp (-10 * Real.log (n : ℝ)) := by
    apply Real.exp_le_exp.2
    dsimp [d]
    nlinarith [hd]
  have hexp : Real.exp (-10 * Real.log (n : ℝ)) =
      ((n : ℝ) ^ 10)⁻¹ := by
    have hpow : Real.exp (10 * Real.log (n : ℝ)) = (n : ℝ) ^ 10 := by
      calc
        Real.exp (10 * Real.log (n : ℝ)) =
            Real.exp (Real.log (n : ℝ)) ^ 10 := by
          convert Real.exp_nat_mul (Real.log (n : ℝ)) 10 using 1
        _ = (n : ℝ) ^ 10 := by rw [Real.exp_log hnpos]
    rw [show -10 * Real.log (n : ℝ) = -(10 * Real.log (n : ℝ)) by ring,
      Real.exp_neg, hpow]
  have hpow9 : (2 : ℝ) ^ 9 ≤ (n : ℝ) ^ 9 :=
    pow_le_pow_left₀ (by norm_num) hn2 9
  have h20 : 20 * (n : ℝ) ≤ (n : ℝ) ^ 10 := by
    have hmul := mul_le_mul_of_nonneg_left hpow9 hnpos.le
    calc
      20 * (n : ℝ) ≤ 512 * (n : ℝ) := by nlinarith
      _ = (n : ℝ) * (2 : ℝ) ^ 9 := by ring
      _ ≤ (n : ℝ) * (n : ℝ) ^ 9 := hmul
      _ = (n : ℝ) ^ 10 := by ring
  have hsmall : 2 * (n : ℝ) * Real.exp (-d / 400) ≤ (1 : ℝ) / 10 := by
    have hpowpos : 0 < (n : ℝ) ^ 10 := by positivity
    have hdiv : 2 * (n : ℝ) / (n : ℝ) ^ 10 ≤ (1 : ℝ) / 10 := by
      rw [div_le_iff₀ hpowpos]
      nlinarith [h20]
    calc
      2 * (n : ℝ) * Real.exp (-d / 400) ≤
          2 * (n : ℝ) * Real.exp (-10 * Real.log (n : ℝ)) :=
        mul_le_mul_of_nonneg_left hdexp (by positivity)
      _ = 2 * (n : ℝ) / (n : ℝ) ^ 10 := by
        rw [hexp]
        simp [div_eq_mul_inv]
      _ ≤ (1 : ℝ) / 10 := hdiv
  have hbad_small : P.real (⋃ v, Bad v) ≤ (1 : ℝ) / 10 :=
    hbad_union.trans hsmall
  have hgood_eq : Good = (⋃ v, Bad v)ᶜ := by
    ext G
    simp only [Good, Bad, Set.mem_compl_iff, Set.mem_iUnion, Set.mem_setOf_eq]
    constructor
    · intro hG hbad
      rcases hbad with ⟨v, hv⟩
      exact (not_le_of_gt (hG v)) (by
        convert hv using 1; ring)
    · intro hG v
      have hnot : ¬ (1 / 10 : ℝ) * d ≤
          |((erdosRenyiModel n p).degree v G : ℝ) - d| := by
        intro hv
        exact hG ⟨v, hv⟩
      exact (lt_of_not_ge (by
        convert hnot using 1; ring))
  have hUmeas : MeasurableSet (⋃ v, Bad v) := by
    exact MeasurableSet.iUnion hbad_meas
  have hgoodprob : P.real Good ≥ (9 : ℝ) / 10 := by
    rw [hgood_eq, measureReal_compl hUmeas]
    have hP : P.real Set.univ = 1 := by
      simp [P]
    rw [hP]
    linarith
  simpa [P, Good, d] using hgoodprob

theorem erdosRenyiSparseMaxDegreeLogBound
    (p : ℕ → Set.Icc (0 : ℝ) 1) (C : ℝ) (hC : 0 ≤ C)
    (hbound : ∀ᶠ n in Filter.atTop,
      ((n - 1 : ℕ) : ℝ) * (p n : ℝ) ≤ C * Real.log (n : ℝ)) :
    ∀ᶠ n in Filter.atTop,
      (erdosRenyiModel n (p n)).graphLaw.real {G |
        ∀ v : Fin n,
          ((erdosRenyiModel n (p n)).degree v G : ℝ) <
            (2 * C + 5) * Real.log (n : ℝ)} ≥ (9 : ℝ) / 10 := by
  filter_upwards [hbound,
    Filter.eventually_atTop.2 ⟨3, fun n hn => hn⟩] with n hdn hn3
  let d : ℝ := ((n - 1 : ℕ) : ℝ) * (p n : ℝ)
  let T : ℝ := (2 * C + 5) * Real.log (n : ℝ)
  let P : Measure (SimpleGraph (Fin n)) := (erdosRenyiModel n (p n)).graphLaw
  let Bad : Fin n → Set (SimpleGraph (Fin n)) := fun v =>
    {G | T ≤ ((erdosRenyiModel n (p n)).degree v G : ℝ)}
  let Good : Set (SimpleGraph (Fin n)) := {G |
    ∀ v : Fin n,
      ((erdosRenyiModel n (p n)).degree v G : ℝ) < T}
  have hnpos : 0 < (n : ℝ) := by
    exact_mod_cast (Nat.zero_lt_of_lt hn3)
  have hn2 : (2 : ℝ) ≤ (n : ℝ) := by
    exact_mod_cast (show 2 ≤ n by omega)
  have hn1 : 1 ≤ n := by omega
  have hsub : ((n - 1 : ℕ) : ℝ) = (n : ℝ) - 1 := by
    rw [Nat.cast_sub hn1]
    norm_num
  have hlogpos : 0 < Real.log (n : ℝ) := by
    apply Real.log_pos
    exact_mod_cast (show 1 < n by omega)
  have hdn' : d ≤ C * Real.log (n : ℝ) := by
    simpa [d] using hdn
  have hbad_meas : ∀ v : Fin n, MeasurableSet (Bad v) := by
    intro v
    have heq : Bad v = {G |
        T ≤ (graphDegreeSum v G : ℝ)} := by
      ext G
      simp only [Bad, Set.mem_setOf_eq]
      rw [erdosRenyiModel_degree_eq_graphDegreeSum]
    rw [heq]
    have hcast : Measurable (fun k : ℕ => (k : ℝ)) := measurable_of_countable _
    have hmeas : Measurable (fun G : SimpleGraph (Fin n) =>
        (graphDegreeSum v G : ℝ)) := by
      exact hcast.comp (measurable_graphDegreeSum v)
    exact hmeas (measurableSet_Ici)
  have hbad_each : ∀ v : Fin n, P.real (Bad v) ≤
      Real.exp (-T + 2 * d) := by
    intro v
    dsimp [P, Bad, T, d]
    simpa [hsub] using (erdosRenyiDegreeUpperBound n (p n) v
      (t := (2 * C + 5) * Real.log (n : ℝ)))
  have hbad_union : P.real (⋃ v, Bad v) ≤
      (n : ℝ) * Real.exp (-T + 2 * d) := by
    calc
      P.real (⋃ v, Bad v) ≤ ∑ v, P.real (Bad v) :=
        measureReal_iUnion_fintype_le (μ := P) Bad
      _ ≤ ∑ _v : Fin n, Real.exp (-T + 2 * d) := by
        exact Finset.sum_le_sum (fun v _ => hbad_each v)
      _ = (n : ℝ) * Real.exp (-T + 2 * d) := by
        simp
  have hexp_tail : Real.exp (-T + 2 * d) ≤
      Real.exp (-5 * Real.log (n : ℝ)) := by
    apply Real.exp_le_exp.2
    dsimp [T]
    nlinarith [hdn']
  have hpow : Real.exp (5 * Real.log (n : ℝ)) = (n : ℝ) ^ 5 := by
    calc
      Real.exp (5 * Real.log (n : ℝ)) =
          Real.exp (Real.log (n : ℝ)) ^ 5 := by
        convert Real.exp_nat_mul (Real.log (n : ℝ)) 5 using 1
      _ = (n : ℝ) ^ 5 := by rw [Real.exp_log hnpos]
  have hexp5 : Real.exp (-5 * Real.log (n : ℝ)) =
      ((n : ℝ) ^ 5)⁻¹ := by
    rw [show -5 * Real.log (n : ℝ) = -(5 * Real.log (n : ℝ)) by ring,
      Real.exp_neg, hpow]
  have hpow4 : (2 : ℝ) ^ 4 ≤ (n : ℝ) ^ 4 :=
    pow_le_pow_left₀ (by norm_num) hn2 4
  have hpow4' : (16 : ℝ) ≤ (n : ℝ) ^ 4 := by
    norm_num at hpow4 ⊢
    exact hpow4
  have hten : 10 * (n : ℝ) ≤ (n : ℝ) ^ 5 := by
    have hmul := mul_le_mul_of_nonneg_left hpow4' hnpos.le
    calc
      10 * (n : ℝ) ≤ 16 * (n : ℝ) := by nlinarith
      _ ≤ (n : ℝ) * (n : ℝ) ^ 4 := by simpa [mul_comm] using hmul
      _ = (n : ℝ) ^ 5 := by ring
  have hsmall : (n : ℝ) * Real.exp (-5 * Real.log (n : ℝ)) ≤
      (1 : ℝ) / 10 := by
    have hpowpos : 0 < (n : ℝ) ^ 5 := by positivity
    have hdiv : (n : ℝ) / (n : ℝ) ^ 5 ≤ (1 : ℝ) / 10 := by
      rw [div_le_iff₀ hpowpos]
      nlinarith [hten]
    rw [hexp5]
    simpa [div_eq_mul_inv] using hdiv
  have hbad_small : P.real (⋃ v, Bad v) ≤ (1 : ℝ) / 10 :=
    hbad_union.trans <| by
      calc
        (n : ℝ) * Real.exp (-T + 2 * d) ≤
            (n : ℝ) * Real.exp (-5 * Real.log (n : ℝ)) :=
          mul_le_mul_of_nonneg_left hexp_tail hnpos.le
        _ ≤ (1 : ℝ) / 10 := hsmall
  have hgood_eq : Good = (⋃ v, Bad v)ᶜ := by
    ext G
    simp only [Good, Bad, Set.mem_compl_iff, Set.mem_iUnion, Set.mem_setOf_eq]
    constructor
    · intro hG hbad
      rcases hbad with ⟨v, hv⟩
      exact (not_le_of_gt (hG v)) hv
    · intro hG v
      exact lt_of_not_ge (fun hv => hG ⟨v, hv⟩)
  have hUmeas : MeasurableSet (⋃ v, Bad v) := by
    exact MeasurableSet.iUnion hbad_meas
  have hgoodprob : P.real Good ≥ (9 : ℝ) / 10 := by
    rw [hgood_eq, measureReal_compl hUmeas]
    have hP : P.real Set.univ = 1 := by
      simp [P]
    rw [hP]
    linarith
  simpa [P, Good, T] using hgoodprob

theorem erdosRenyiVerySparseMaxDegreeLogLogBound
    (p : ℕ → Set.Icc (0 : ℝ) 1) (C : ℝ) (hC : 0 ≤ C)
    (hbound : ∀ᶠ n in Filter.atTop,
      ((n - 1 : ℕ) : ℝ) * (p n : ℝ) ≤ C) :
    ∀ᶠ n in Filter.atTop,
      (erdosRenyiModel n (p n)).graphLaw.real {G |
        ∀ v : Fin n,
          ((erdosRenyiModel n (p n)).degree v G : ℝ) <
            (C + 5) * Real.log (n : ℝ) / Real.log (Real.log (n : ℝ))} ≥
      (9 : ℝ) / 10 := by
  filter_upwards [hbound,
    Filter.eventually_atTop.2 ⟨16, fun n hn => hn⟩] with n hdn hn16
  let d : ℝ := ((n - 1 : ℕ) : ℝ) * (p n : ℝ)
  let L : ℝ := Real.log (n : ℝ)
  let LL : ℝ := Real.log L
  let T : ℝ := (C + 5) * L / LL
  let lambda : ℝ := LL
  let P : Measure (SimpleGraph (Fin n)) := (erdosRenyiModel n (p n)).graphLaw
  let Bad : Fin n → Set (SimpleGraph (Fin n)) := fun v =>
    {G | T ≤ ((erdosRenyiModel n (p n)).degree v G : ℝ)}
  let Good : Set (SimpleGraph (Fin n)) := {G |
    ∀ v : Fin n,
      ((erdosRenyiModel n (p n)).degree v G : ℝ) < T}
  have hnpos : 0 < (n : ℝ) := by
    exact_mod_cast (Nat.zero_lt_of_lt hn16)
  have hn2 : (2 : ℝ) ≤ (n : ℝ) := by
    exact_mod_cast (show 2 ≤ n by omega)
  have hn3 : (3 : ℝ) ≤ (n : ℝ) := by
    exact_mod_cast (show 3 ≤ n by omega)
  have hn1 : 1 ≤ n := by omega
  have hsub : ((n - 1 : ℕ) : ℝ) = (n : ℝ) - 1 := by
    rw [Nat.cast_sub hn1]
    norm_num
  have hLpos : 0 < L := by
    dsimp [L]
    exact Real.log_pos (by exact_mod_cast (show 1 < n by omega))
  have hL1 : 1 < L := by
    dsimp [L]
    apply (Real.lt_log_iff_exp_lt hnpos).2
    exact lt_of_lt_of_le Real.exp_one_lt_three hn3
  have hLLpos : 0 < LL := by
    dsimp [LL]
    exact Real.log_pos hL1
  have hLLne : LL ≠ 0 := ne_of_gt hLLpos
  have hlam : 0 < lambda := by simpa [lambda] using hLLpos
  have hdn' : d ≤ C := by
    simpa [d] using hdn
  have hexpLambda : Real.exp lambda = L := by
    dsimp [lambda]
    rw [Real.exp_log hLpos]
  have hLLne' : Real.log (Real.log (n : ℝ)) ≠ 0 := by
    simpa [LL, L] using hLLne
  have hlambdaT : lambda * T = (C + 5) * L := by
    dsimp [lambda, T]
    field_simp [hLLne']
  have hdnonneg : 0 ≤ d := by
    dsimp [d]
    exact mul_nonneg (Nat.cast_nonneg _) (p n).2.1
  have hmul : (L - 1) * d ≤ (L - 1) * C := by
    apply mul_le_mul_of_nonneg_left hdn'
    linarith
  have hstep : (L - 1) * C ≤ L * C := by
    nlinarith [hC]
  have htail : -lambda * T + (Real.exp lambda - 1) * d ≤ -5 * L := by
    rw [show -lambda * T = -(lambda * T) by ring, hlambdaT, hexpLambda]
    nlinarith [hmul, hstep]
  have hbad_meas : ∀ v : Fin n, MeasurableSet (Bad v) := by
    intro v
    have heq : Bad v = {G |
        T ≤ (graphDegreeSum v G : ℝ)} := by
      ext G
      simp only [Bad, Set.mem_setOf_eq]
      rw [erdosRenyiModel_degree_eq_graphDegreeSum]
    rw [heq]
    have hcast : Measurable (fun k : ℕ => (k : ℝ)) := measurable_of_countable _
    have hmeas : Measurable (fun G : SimpleGraph (Fin n) =>
        (graphDegreeSum v G : ℝ)) := by
      exact hcast.comp (measurable_graphDegreeSum v)
    exact hmeas (measurableSet_Ici)
  have hbad_each : ∀ v : Fin n, P.real (Bad v) ≤
      Real.exp (-lambda * T + (Real.exp lambda - 1) * d) := by
    intro v
    dsimp [P, Bad, T, lambda, d, L, LL]
    simpa [hsub] using (erdosRenyiDegreeUpperBoundAt n (p n) v
      (t := (C + 5) * Real.log (n : ℝ) / Real.log (Real.log (n : ℝ)))
      (lam := Real.log (Real.log (n : ℝ))) hlam)
  have hbad_union : P.real (⋃ v, Bad v) ≤
      (n : ℝ) * Real.exp (-lambda * T + (Real.exp lambda - 1) * d) := by
    calc
      P.real (⋃ v, Bad v) ≤ ∑ v, P.real (Bad v) :=
        measureReal_iUnion_fintype_le (μ := P) Bad
      _ ≤ ∑ _v : Fin n,
          Real.exp (-lambda * T + (Real.exp lambda - 1) * d) := by
        exact Finset.sum_le_sum (fun v _ => hbad_each v)
      _ = (n : ℝ) * Real.exp (-lambda * T +
          (Real.exp lambda - 1) * d) := by
        simp
  have hexp_tail : Real.exp (-lambda * T + (Real.exp lambda - 1) * d) ≤
      Real.exp (-5 * L) := by
    exact Real.exp_le_exp.2 htail
  have hpow : Real.exp (5 * L) = (n : ℝ) ^ 5 := by
    dsimp [L]
    calc
      Real.exp (5 * Real.log (n : ℝ)) =
          Real.exp (Real.log (n : ℝ)) ^ 5 := by
        convert Real.exp_nat_mul (Real.log (n : ℝ)) 5 using 1
      _ = (n : ℝ) ^ 5 := by rw [Real.exp_log hnpos]
  have hexp5 : Real.exp (-5 * L) = ((n : ℝ) ^ 5)⁻¹ := by
    rw [show -5 * L = -(5 * L) by ring, Real.exp_neg, hpow]
  have hpow4 : (2 : ℝ) ^ 4 ≤ (n : ℝ) ^ 4 :=
    pow_le_pow_left₀ (by norm_num) hn2 4
  have hpow4' : (16 : ℝ) ≤ (n : ℝ) ^ 4 := by
    norm_num at hpow4 ⊢
    exact hpow4
  have hten : 10 * (n : ℝ) ≤ (n : ℝ) ^ 5 := by
    have hmul' := mul_le_mul_of_nonneg_left hpow4' hnpos.le
    calc
      10 * (n : ℝ) ≤ 16 * (n : ℝ) := by nlinarith
      _ ≤ (n : ℝ) * (n : ℝ) ^ 4 := by simpa [mul_comm] using hmul'
      _ = (n : ℝ) ^ 5 := by ring
  have hsmall : (n : ℝ) * Real.exp (-5 * L) ≤ (1 : ℝ) / 10 := by
    have hpowpos : 0 < (n : ℝ) ^ 5 := by positivity
    have hdiv : (n : ℝ) / (n : ℝ) ^ 5 ≤ (1 : ℝ) / 10 := by
      rw [div_le_iff₀ hpowpos]
      nlinarith [hten]
    rw [hexp5]
    simpa [div_eq_mul_inv] using hdiv
  have hbad_small : P.real (⋃ v, Bad v) ≤ (1 : ℝ) / 10 :=
    hbad_union.trans <| by
      calc
        (n : ℝ) * Real.exp (-lambda * T + (Real.exp lambda - 1) * d) ≤
            (n : ℝ) * Real.exp (-5 * L) :=
          mul_le_mul_of_nonneg_left hexp_tail hnpos.le
        _ ≤ (1 : ℝ) / 10 := hsmall
  have hgood_eq : Good = (⋃ v, Bad v)ᶜ := by
    ext G
    simp only [Good, Bad, Set.mem_compl_iff, Set.mem_iUnion, Set.mem_setOf_eq]
    constructor
    · intro hG hbad
      rcases hbad with ⟨v, hv⟩
      exact (not_le_of_gt (hG v)) hv
    · intro hG v
      exact lt_of_not_ge (fun hv => hG ⟨v, hv⟩)
  have hUmeas : MeasurableSet (⋃ v, Bad v) := by
    exact MeasurableSet.iUnion hbad_meas
  have hgoodprob : P.real Good ≥ (9 : ℝ) / 10 := by
    rw [hgood_eq, measureReal_compl hUmeas]
    have hP : P.real Set.univ = 1 := by
      simp [P]
    rw [hP]
    linarith
  simpa [P, Good, T, L, LL] using hgoodprob

end NumStability.HDP.Scalar.IndependentSums.Chernoff

namespace NumStability.HDP.Contract

theorem hdp_02_hlem_hpoisson_hadd
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X Y : Ω → ℕ} {r s : ℝ≥0}
    (hX : HasLaw X (ProbabilityTheory.poissonMeasure r) μ)
    (hY : HasLaw Y (ProbabilityTheory.poissonMeasure s) μ)
    (hXY : X ⟂ᵢ[μ] Y) :
    HasLaw (X + Y) (ProbabilityTheory.poissonMeasure (r + s)) μ :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.poissonAddLaw hX hY hXY

theorem hdp_02_hrem_h2_d3_d4 (rate : ℝ≥0) (hrate : 0 < rate) :
    (fun k : ℕ => ProbabilityTheory.poissonPMFReal rate k) ~[Filter.atTop]
      (fun k : ℕ =>
        Real.exp (-(rate : ℝ)) *
          (Real.exp 1 * (rate : ℝ) / (k : ℝ)) ^ k /
            Real.sqrt (2 * (k : ℝ) * Real.pi)) :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.poissonPointMass_isEquivalent_stirling
    rate hrate

theorem hdp_02_hthm_h2_d3_d1
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {p : ι → ℝ≥0}
    (hp : ∀ i, p i ≤ 1)
    (hB : iIndepFun B μ)
    (hLaw : ∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ)
    (hMeas : ∀ i, Measurable (B i))
    {t : ℝ}
    (hExp : ∀ i, Integrable
      (fun ω => Real.exp (Real.log (t / (∑ i, (p i : ℝ))) *
        (if B i ω then 1 else 0))) μ)
    (ht : ∑ i, (p i : ℝ) < t)
    (hμ : 0 < ∑ i, (p i : ℝ))
    (hExpS : Integrable
      (fun ω => Real.exp (Real.log (t / (∑ i, (p i : ℝ))) *
        ∑ i, (if B i ω then 1 else 0))) μ) :
    μ.real {ω | t ≤ ∑ i, (if B i ω then 1 else 0)} ≤
      Real.exp (-(∑ i, (p i : ℝ))) *
        ((Real.exp 1 * (∑ i, (p i : ℝ)) / t) ^ t) :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.poissonBinomialChernoffBound
    hp hB hLaw hMeas hExp ht hμ hExpS

theorem hdp_02_hex_h2_d3_d2
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {p : ι → ℝ≥0}
    (hp : ∀ i, p i ≤ 1)
    (hB : iIndepFun B μ)
    (hLaw : ∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ)
    (hMeas : ∀ i, Measurable (B i))
    {t : ℝ}
    (hExp : ∀ i, Integrable
      (fun ω => Real.exp ((-Real.log ((∑ i, (p i : ℝ)) / t)) *
        (if B i ω then 1 else 0))) μ)
    (ht : 0 < t)
    (htμ : t < ∑ i, (p i : ℝ))
    (hExpS : Integrable
      (fun ω => Real.exp (Real.log ((∑ i, (p i : ℝ)) / t) *
        (-∑ i, (if B i ω then 1 else 0)))) μ) :
    μ.real {ω | ∑ i, (if B i ω then 1 else 0) ≤ t} ≤
      Real.exp (-(∑ i, (p i : ℝ))) *
        ((Real.exp 1 * (∑ i, (p i : ℝ)) / t) ^ t) :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.poissonBinomialLowerChernoffBound
    hp hB hLaw hMeas hExp ht htμ hExpS

theorem hdp_02_hlem_hbernoulli_hmgf_hbound :
    NumStability.HDP.Scalar.IndependentSums.Chernoff.BernoulliMgfModelData :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.bernoulliMgfModel

theorem hdp_02_hlem_hbernoulli_hmgf_hbound_scalar
    (p : ℝ≥0) (hp : p ≤ 1) (lam : ℝ) :
    ((∫ b : Bool, Real.exp (lam * (if b then 1 else 0)) ∂
        (PMF.bernoulli p hp).toMeasure) =
        1 + (Real.exp lam - 1) * (p : ℝ)) ∧
      (1 + (Real.exp lam - 1) * (p : ℝ) ≤
        Real.exp ((Real.exp lam - 1) * (p : ℝ))) :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.bernoulliMgfBound p hp lam

theorem hdp_02_hlem_her_hdegree_hlaw
    (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (v : Fin n) :
    HasLaw ((NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n p).degree v)
      (NumStability.HDP.Scalar.IndependentSums.Chernoff.graphBinomialLaw n p)
      (NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n p).graphLaw :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiDegreeLaw n p v

theorem hdp_02_hprop_h2_d4_d1
    (n : ℕ) (hn : 2 ≤ n) (p : Set.Icc (0 : ℝ) 1)
    (hd : 4000 * Real.log (n : ℝ) ≤ (n - 1) * (p : ℝ)) :
    (NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n p).graphLaw.real
        {G |
          ∀ v : Fin n,
            |((NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n p).degree v G : ℝ) -
                (n - 1) * (p : ℝ)| <
              ((n - 1) * (p : ℝ)) / 10} ≥ (9 : ℝ) / 10 :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiAlmostRegular n hn p hd

theorem hdp_02_hex_h2_d4_d2
    (p : ℕ → Set.Icc (0 : ℝ) 1) (C : ℝ) (hC : 0 ≤ C)
    (hbound : ∀ᶠ n in Filter.atTop,
      ((n - 1 : ℕ) : ℝ) * (p n : ℝ) ≤ C * Real.log (n : ℝ)) :
    ∀ᶠ n in Filter.atTop,
      (NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n (p n)).graphLaw.real
        {G |
          ∀ v : Fin n,
            ((NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n (p n)).degree v G : ℝ) <
              (2 * C + 5) * Real.log (n : ℝ)} ≥ (9 : ℝ) / 10 :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiSparseMaxDegreeLogBound
    p C hC hbound

theorem hdp_02_hex_h2_d4_d3
    (p : ℕ → Set.Icc (0 : ℝ) 1) (C : ℝ) (hC : 0 ≤ C)
    (hbound : ∀ᶠ n in Filter.atTop,
      ((n - 1 : ℕ) : ℝ) * (p n : ℝ) ≤ C) :
    ∀ᶠ n in Filter.atTop,
      (NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n (p n)).graphLaw.real
        {G |
          ∀ v : Fin n,
            ((NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n (p n)).degree v G : ℝ) <
              (C + 5) * Real.log (n : ℝ) / Real.log (Real.log (n : ℝ))} ≥
        (9 : ℝ) / 10 :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiVerySparseMaxDegreeLogLogBound
    p C hC hbound

end NumStability.HDP.Contract
