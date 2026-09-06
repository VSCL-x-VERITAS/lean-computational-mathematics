import ComputationalMathematics.HDP.Scalar.GaussianAtoms
import ComputationalMathematics.HDP.Scalar.GaussianTails

/-!
# Tails of the square of a standard normal

This module turns the deterministic identity `g² > t ↔ |g| > √t` into
exact standard-normal probability identities and Mills-ratio bounds.  The
result keeps the polynomial prefactor that the source suppresses when it says
the square has exponential-scale tail `exp (-t / 2)`.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Scalar.GaussianSquareTail

open NumStability.HDP.Scalar.LimitTheorems
open NumStability.HDP.Scalar.GaussianTails
open NumStability.HDP.Scalar.GaussianAtoms

/-- Squaring exceeds a nonnegative threshold exactly when absolute value
exceeds its square root. -/
theorem sq_gt_iff_abs_gt_sqrt (x t : ℝ) (ht : 0 ≤ t) :
    x ^ 2 > t ↔ |x| > Real.sqrt t := by
  calc
    x ^ 2 > t ↔ |x| ^ 2 > (Real.sqrt t) ^ 2 := by
      rw [sq_abs, Real.sq_sqrt ht]
    _ ↔ |x| > Real.sqrt t :=
      sq_lt_sq₀ (Real.sqrt_nonneg t) (abs_nonneg x)

/-- Set form of `sq_gt_iff_abs_gt_sqrt`, split into the two Gaussian tails. -/
theorem sq_tail_set_eq_union (t : ℝ) (ht : 0 ≤ t) :
    {x : ℝ | x ^ 2 > t} = Ioi (Real.sqrt t) ∪ Iio (-Real.sqrt t) := by
  ext x
  simp only [mem_setOf_eq, mem_union, mem_Ioi, mem_Iio]
  rw [sq_gt_iff_abs_gt_sqrt x t ht]
  change Real.sqrt t < |x| ↔ Real.sqrt t < x ∨ x < -Real.sqrt t
  rw [lt_abs]
  constructor
  · rintro (h | h)
    · exact Or.inl h
    · exact Or.inr (by linarith)
  · rintro (h | h)
    · exact Or.inl h
    · exact Or.inr (by linarith)

/-- The standard normal has the same mass on an open upper tail and the
corresponding closed upper tail because it has no atoms. -/
theorem standardNormalLaw_real_Ioi_eq_Ici (s : ℝ) :
    standardNormalLaw.real (Ioi s) = standardNormalLaw.real (Ici s) := by
  have hset : Ici s = {s} ∪ Ioi s := by
    ext x
    simp only [mem_Ici, mem_union, mem_singleton_iff, mem_Ioi]
    constructor
    · intro h
      rcases h.eq_or_lt with h | h
      · exact Or.inl h.symm
      · exact Or.inr h
    · rintro (rfl | h)
      · exact le_rfl
      · exact h.le
  have hdisj : Disjoint ({s} : Set ℝ) (Ioi s) := by
    rw [Set.disjoint_left]
    intro x hx htail
    simp only [mem_singleton_iff] at hx
    subst x
    exact (lt_irrefl s) htail
  have hunion := measureReal_union (μ := standardNormalLaw)
    hdisj measurableSet_Ioi
  rw [← hset] at hunion
  rw [standardNormalLaw_real_singleton] at hunion
  linarith

/-- Reflection symmetry identifies the lower open tail with the upper one. -/
theorem standardNormalLaw_real_Iio_neg (s : ℝ) :
    standardNormalLaw.real (Iio (-s)) = standardNormalLaw.real (Ioi s) := by
  have hmap : standardNormalLaw.map (fun x : ℝ => -x) = standardNormalLaw := by
    simpa [standardNormalLaw] using
      (ProbabilityTheory.gaussianReal_map_neg (μ := (0 : ℝ)) (v := (1 : ℝ≥0)))
  calc
    standardNormalLaw.real (Iio (-s)) =
        (standardNormalLaw.map (fun x : ℝ => -x)).real (Iio (-s)) := by
          rw [hmap]
    _ = standardNormalLaw.real (Ioi s) := by
      simp only [Measure.real_def,
        Measure.map_apply (by fun_prop : Measurable (fun x : ℝ => -x)) measurableSet_Iio,
        neg_preimage, neg_Iio, neg_neg]

/-- The square tail is exactly twice the one-sided Gaussian tail at `√t`. -/
theorem standardNormal_squareTail_eq_two_mul_tail (t : ℝ) (ht : 0 ≤ t) :
    standardNormalLaw.real {x : ℝ | x ^ 2 > t} =
      2 * standardNormalLaw.real (Ici (Real.sqrt t)) := by
  rw [sq_tail_set_eq_union t ht]
  have hs : 0 ≤ Real.sqrt t := Real.sqrt_nonneg t
  have hdisj : Disjoint (Ioi (Real.sqrt t)) (Iio (-Real.sqrt t)) := by
    rw [Set.disjoint_left]
    intro x hupper hlower
    simp only [mem_Ioi] at hupper
    simp only [mem_Iio] at hlower
    linarith
  rw [measureReal_union hdisj measurableSet_Iio]
  rw [standardNormalLaw_real_Iio_neg, standardNormalLaw_real_Ioi_eq_Ici]
  ring

/-- Exact two-sided Mills-ratio bounds for the tail of a squared standard
normal.  In particular, its exponential scale is `exp (-t / 2)`. -/
theorem standardNormal_squareTail_bounds (t : ℝ) (ht : 0 < t) :
    2 * (Real.sqrt (2 * Real.pi))⁻¹ *
          ((1 / Real.sqrt t - 1 / (Real.sqrt t) ^ 3) *
            Real.exp (-t / 2)) ≤
        standardNormalLaw.real {x : ℝ | x ^ 2 > t} ∧
      standardNormalLaw.real {x : ℝ | x ^ 2 > t} ≤
        2 * (Real.sqrt (2 * Real.pi))⁻¹ *
          ((1 / Real.sqrt t) * Real.exp (-t / 2)) := by
  rw [standardNormal_squareTail_eq_two_mul_tail t ht.le]
  have hspos : 0 < Real.sqrt t := Real.sqrt_pos.2 ht
  have htail := standardNormalTail_bounds (Real.sqrt t) hspos
  constructor
  · have h := mul_le_mul_of_nonneg_left htail.1 (by norm_num : (0 : ℝ) ≤ 2)
    simpa [Real.sq_sqrt ht.le, mul_assoc] using h
  · have h := mul_le_mul_of_nonneg_left htail.2 (by norm_num : (0 : ℝ) ≤ 2)
    simpa [Real.sq_sqrt ht.le, mul_assoc] using h

end NumStability.HDP.Scalar.GaussianSquareTail
