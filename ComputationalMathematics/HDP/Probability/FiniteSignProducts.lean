import Mathlib.Algebra.Order.BigOperators.Ring.Finset
import Mathlib.Algebra.Ring.Parity
import Mathlib.Data.Bool.Basic
import Mathlib.Data.Real.Basic
import Mathlib.MeasureTheory.Constructions.Pi
import Mathlib.MeasureTheory.Measure.Real
import Mathlib.Probability.ProbabilityMassFunction.Constructions

/-!
# Finite products with binary signs
-/

open MeasureTheory
open scoped BigOperators NNReal

namespace NumStability.HDP.Probability

/-- The two products for any choice of signs are bounded by the two products
formed from the absolute biases. The bias bounds are retained in the contract. -/
theorem finite_sign_paired_product_le_abs
    {ι : Type*} (I : Finset ι) (t s : ι → ℝ)
    (_ht : ∀ i ∈ I, -1 ≤ t i ∧ t i ≤ 1)
    (hs : ∀ i ∈ I, s i = -1 ∨ s i = 1) :
    (∏ i ∈ I, (1 + s i * t i)) + (∏ i ∈ I, (1 - s i * t i)) ≤
      (∏ i ∈ I, (1 + |t i|)) + (∏ i ∈ I, (1 - |t i|)) := by
  classical
  have hsign_abs : ∀ i ∈ I, |s i| = 1 := by
    intro i hi
    rcases hs i hi with h | h <;> simp [h]
  have hexpand (x : ι → ℝ) :
      (∏ i ∈ I, (1 + x i)) + (∏ i ∈ I, (1 - x i)) =
        ∑ J ∈ I.powerset, (1 + (-1 : ℝ) ^ J.card) * (∏ i ∈ J, x i) := by
    rw [Finset.prod_one_add]
    have hminus : (∏ i ∈ I, (1 - x i)) =
        ∑ J ∈ I.powerset, (-1 : ℝ) ^ J.card * (∏ i ∈ J, x i) := by
      simpa only [sub_eq_add_neg, Finset.prod_neg] using
        (Finset.prod_one_add (f := fun i ↦ -x i) I)
    rw [hminus, ← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro J _hJ
    ring
  rw [hexpand (fun i ↦ s i * t i), hexpand (fun i ↦ |t i|)]
  apply Finset.sum_le_sum
  intro J hJ
  have hcoefficient : 0 ≤ (1 + (-1 : ℝ) ^ J.card) := by
    rw [neg_one_pow_eq_ite]
    split
    · exact add_nonneg zero_le_one zero_le_one
    · simpa only [add_neg_cancel] using (le_refl (0 : ℝ))
  have habs : |∏ i ∈ J, s i * t i| = ∏ i ∈ J, |t i| := by
    rw [Finset.abs_prod]
    apply Finset.prod_congr rfl
    intro i hi
    rw [abs_mul, hsign_abs i ((Finset.mem_powerset.mp hJ) hi), one_mul]
  have hproduct : (∏ i ∈ J, s i * t i) ≤ ∏ i ∈ J, |t i| := by
    rw [← habs]
    exact le_abs_self _
  exact mul_le_mul_of_nonneg_left hproduct hcoefficient

universe u

/-- Real mass of the global Boolean-complement orbit under heterogeneous Bernoulli coordinates. -/
theorem boolean_complement_orbit_mass (ι : Type u) [Fintype ι]
    (p : ι → ℝ≥0) (hp : ∀ i, p i ≤ 1) (s : ι → Bool) :
    (Measure.pi (fun i ↦ (PMF.bernoulli (p i) (hp i)).toMeasure)).real
        ({s, fun i ↦ !(s i)} : Set (ι → Bool)) =
      if Fintype.card ι = 0 then 1 else
        (∏ i, if s i then (p i : ℝ) else 1 - (p i : ℝ)) +
          (∏ i, if s i then 1 - (p i : ℝ) else (p i : ℝ)) := by
  classical
  let ν := Measure.pi (fun i ↦ (PMF.bernoulli (p i) (hp i)).toMeasure)
  have hsingle (a : ι → Bool) :
      ν.real {a} = ∏ i, if a i then (p i : ℝ) else 1 - (p i : ℝ) := by
    rw [measureReal_def]
    change ((Measure.pi (fun i ↦ (PMF.bernoulli (p i) (hp i)).toMeasure)) {a}).toReal = _
    rw [Measure.pi_singleton, ENNReal.toReal_prod]
    apply Finset.prod_congr rfl
    intro i _hi
    rw [(PMF.bernoulli (p i) (hp i)).toMeasure_apply_singleton
      (a i) (measurableSet_singleton (a i)), PMF.bernoulli_apply]
    cases a i
    · change ((↑(1 - p i) : ENNReal)).toReal = 1 - (p i : ℝ)
      rw [ENNReal.coe_toReal]
      exact NNReal.coe_sub (hp i)
    · exact ENNReal.coe_toReal (p i)
  change ν.real ({s, fun i ↦ !(s i)} : Set (ι → Bool)) = _
  by_cases hzero : Fintype.card ι = 0
  · letI : IsEmpty ι := Fintype.card_eq_zero_iff.mp hzero
    have hflip : (fun i ↦ !(s i)) = s := by
      funext i
      exact isEmptyElim i
    rw [if_pos hzero, hflip, Set.pair_eq_singleton, hsingle]
    simp
  · obtain ⟨i⟩ : Nonempty ι := Fintype.card_pos_iff.mp (Nat.pos_of_ne_zero hzero)
    have hne : s ≠ (fun j ↦ !(s j)) := by
      intro h
      exact Bool.not_ne_self (s i) (congr_fun h i).symm
    have hsum := sum_measureReal_singleton (μ := ν)
      ({s, fun j ↦ !(s j)} : Finset (ι → Bool))
    rw [Finset.sum_pair hne] at hsum
    rw [if_neg hzero]
    calc
      ν.real ({s, fun j ↦ !(s j)} : Set (ι → Bool)) =
          ν.real {s} + ν.real {fun j ↦ !(s j)} := by
        simpa only [Finset.coe_pair] using hsum.symm
      _ = (∏ j, if s j then (p j : ℝ) else 1 - (p j : ℝ)) +
          (∏ j, if !(s j) then (p j : ℝ) else 1 - (p j : ℝ)) := by
        rw [hsingle, hsingle]
      _ = (∏ j, if s j then (p j : ℝ) else 1 - (p j : ℝ)) +
          (∏ j, if s j then 1 - (p j : ℝ) else (p j : ℝ)) := by
        congr 1
        apply Finset.prod_congr rfl
        intro j _hj
        cases s j <;> rfl


end NumStability.HDP.Probability
