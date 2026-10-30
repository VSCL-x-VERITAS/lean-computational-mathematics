import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Bool.Basic
import ComputationalMathematics.HDP.Probability.FiniteSignProducts
import Mathlib.Tactic.Linarith

/-!
# Weak modes of finite paired Bernoulli products

A supplied coordinatewise weak mode maximizes the sum of a Boolean product
and its complementary product. The statement includes empty index sets,
endpoint weights and ties, and selects no observation or clustering rule.
The measure corollary compares actual Boolean-complement orbit masses and
retains the singleton event for an empty index type.
-/

set_option autoImplicit false
open scoped BigOperators
universe u

namespace NumStability.HDP.Probability

/-- A supplied weak coordinatewise mode maximizes the two complementary
products of the finite Bernoulli weights. -/
theorem modal_paired_product_maximizer :
  ∀ (ι : Type u) (I : Finset ι) (p : ι → ℝ) (s d : ι → Bool),
    (∀ i ∈ I, 0 ≤ p i ∧ p i ≤ 1) →
    (∀ i ∈ I, if d i then 1 - p i ≤ p i else p i ≤ 1 - p i) →
    (∏ i ∈ I, if s i then p i else 1 - p i) +
        (∏ i ∈ I, if s i then 1 - p i else p i) ≤
      (∏ i ∈ I, if d i then p i else 1 - p i) +
        (∏ i ∈ I, if d i then 1 - p i else p i) := by
  classical
  intro ι I p s d hp hd
  let t : ι → ℝ := fun i ↦ 2 * p i - 1
  let sigma : (ι → Bool) → ι → ℝ :=
    fun b i ↦ if b i then 1 else -1
  let C : ℝ := (2 : ℝ) ^ I.card
  have hC : 0 < C := by
    exact pow_pos (by norm_num : (0 : ℝ) < 2) _
  have ht : ∀ i ∈ I, -1 ≤ t i ∧ t i ≤ 1 := by
    intro i hi
    have hpi := hp i hi
    dsimp [t]
    constructor <;> linarith [hpi.1, hpi.2]
  have hs : ∀ i ∈ I, sigma s i = -1 ∨ sigma s i = 1 := by
    intro i _hi
    cases hb : s i <;> simp [sigma, hb]
  have hmodal : ∀ i ∈ I, |t i| = sigma d i * t i := by
    intro i hi
    have hdi := hd i hi
    cases hb : d i with
    | false =>
        simp [hb] at hdi
        have hnonpos : t i ≤ 0 := by
          dsimp [t]
          linarith
        simpa [sigma, hb] using abs_of_nonpos hnonpos
    | true =>
        simp [hb] at hdi
        have hnonneg : 0 ≤ t i := by
          dsimp [t]
          linarith
        simpa [sigma, hb] using abs_of_nonneg hnonneg
  have hmul (f : ι → ℝ) :
      (∏ i ∈ I, (2 : ℝ) * f i) = C * ∏ i ∈ I, f i := by
    rw [Finset.prod_mul_distrib]
    simp [C]
  have hscale (b : ι → Bool) :
      (∏ i ∈ I, (1 + sigma b i * t i)) +
          (∏ i ∈ I, (1 - sigma b i * t i)) =
        C * ((∏ i ∈ I, if b i then p i else 1 - p i) +
          (∏ i ∈ I, if b i then 1 - p i else p i)) := by
    have hplus : (∏ i ∈ I, (1 + sigma b i * t i)) =
        ∏ i ∈ I, (2 : ℝ) * (if b i then p i else 1 - p i) := by
      apply Finset.prod_congr rfl
      intro i _hi
      cases hb : b i <;> simp [sigma, hb, t] <;> ring
    have hminus : (∏ i ∈ I, (1 - sigma b i * t i)) =
        ∏ i ∈ I, (2 : ℝ) * (if b i then 1 - p i else p i) := by
      apply Finset.prod_congr rfl
      intro i _hi
      cases hb : b i <;> simp [sigma, hb, t] <;> ring
    rw [hplus, hminus, hmul, hmul, mul_add]
  have hpaired :=
    NumStability.HDP.Probability.finite_sign_paired_product_le_abs I t (sigma s) ht hs
  have hmodalPlus : (∏ i ∈ I, (1 + |t i|)) =
      ∏ i ∈ I, (1 + sigma d i * t i) := by
    apply Finset.prod_congr rfl
    intro i hi
    rw [hmodal i hi]
  have hmodalMinus : (∏ i ∈ I, (1 - |t i|)) =
      ∏ i ∈ I, (1 - sigma d i * t i) := by
    apply Finset.prod_congr rfl
    intro i hi
    rw [hmodal i hi]
  rw [hmodalPlus, hmodalMinus, hscale s, hscale d] at hpaired
  exact le_of_mul_le_mul_left hpaired hC

/-- Weak coordinate modes maximize the actual mass of the complement orbit. -/
theorem bernoulli_complement_orbit_mode_maximizer (ι : Type u) [Fintype ι]
    (p : ι → NNReal) (hp : ∀ i, p i ≤ 1) (d : ι → Bool)
    (hd : ∀ i, if d i then 1 - (p i : ℝ) ≤ (p i : ℝ)
      else (p i : ℝ) ≤ 1 - (p i : ℝ)) (s : ι → Bool) :
    (MeasureTheory.Measure.pi (fun i ↦ (PMF.bernoulli (p i) (hp i)).toMeasure)).real
        ({s, fun i ↦ !(s i)} : Set (ι → Bool)) ≤
      (MeasureTheory.Measure.pi (fun i ↦ (PMF.bernoulli (p i) (hp i)).toMeasure)).real
        ({d, fun i ↦ !(d i)} : Set (ι → Bool)) := by
  classical
  rw [boolean_complement_orbit_mass ι p hp s,
    boolean_complement_orbit_mass ι p hp d]
  split_ifs with hzero
  · exact le_rfl
  · exact modal_paired_product_maximizer ι Finset.univ (fun i ↦ (p i : ℝ)) s d
      (fun i _ ↦ ⟨NNReal.coe_nonneg _, NNReal.coe_le_one.mpr (hp i)⟩)
      (fun i _ ↦ hd i)


end NumStability.HDP.Probability
