import Mathlib.Analysis.Calculus.Taylor
import Mathlib.Analysis.Real.Pi.Bounds
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv

/-!
# The numerical arccos bound for hyperplane rounding

This file proves the explicit `0.878` lower bound used by the randomized
hyperplane rounding argument.  The numerical part is certified exactly: a
signed Taylor remainder bounds cosine, and rational Bernstein coefficients
certify the remaining polynomial inequality on three subintervals.
-/

namespace NumStability.HDP.Graph

open Set

noncomputable section

private noncomputable def ratioMargin (x : ℝ) : ℝ :=
  1 - (4829 / 3500 : ℝ) *
    (x / 2 - x ^ 3 / 24 + x ^ 5 / 720 - x ^ 7 / 40320 + x ^ 9 / 3628800)

private lemma ratioMargin_nonneg {x : ℝ} (hx0 : 0 ≤ x) (hxpi : x ≤ 22 / 7) :
    0 ≤ ratioMargin x := by
  by_cases hlo : x ≤ 23 / 10
  · let z : ℝ := x / (23 / 10)
    have hz0 : 0 ≤ z := by dsimp [z]; positivity
    have hz1 : z ≤ 1 := by dsimp [z]; norm_num at hlo ⊢; linarith
    have hzsub : 0 ≤ 1 - z := sub_nonneg.mpr hz1
    have hbern : 0 ≤
        (1 : ℝ) * (1 - z) ^ 9 +
        (518933 : ℝ) / 70000 * z * (1 - z) ^ 8 +
        (203933 : ℝ) / 8750 * z ^ 2 * (1 - z) ^ 7 +
        (3382903243 : ℝ) / 84000000 * z ^ 3 * (1 - z) ^ 6 +
        (578804043 : ℝ) / 14000000 * z ^ 4 * (1 - z) ^ 5 +
        (910854976379 : ℝ) / 36000000000 * z ^ 5 * (1 - z) ^ 4 +
        (544458744653 : ℝ) / 63000000000 * z ^ 6 * (1 - z) ^ 3 +
        (1886336406424363 : ℝ) / 1411200000000000 * z ^ 7 * (1 - z) ^ 2 +
        (7838208465721 : ℝ) / 235200000000000 * z ^ 8 * (1 - z) +
        (5267196661062173 : ℝ) / 12700800000000000000 * z ^ 9 := by
      positivity
    have heq : ratioMargin x =
        (1 : ℝ) * (1 - z) ^ 9 +
        (518933 : ℝ) / 70000 * z * (1 - z) ^ 8 +
        (203933 : ℝ) / 8750 * z ^ 2 * (1 - z) ^ 7 +
        (3382903243 : ℝ) / 84000000 * z ^ 3 * (1 - z) ^ 6 +
        (578804043 : ℝ) / 14000000 * z ^ 4 * (1 - z) ^ 5 +
        (910854976379 : ℝ) / 36000000000 * z ^ 5 * (1 - z) ^ 4 +
        (544458744653 : ℝ) / 63000000000 * z ^ 6 * (1 - z) ^ 3 +
        (1886336406424363 : ℝ) / 1411200000000000 * z ^ 7 * (1 - z) ^ 2 +
        (7838208465721 : ℝ) / 235200000000000 * z ^ 8 * (1 - z) +
        (5267196661062173 : ℝ) / 12700800000000000000 * z ^ 9 := by
      dsimp [ratioMargin, z]
      ring
    rw [heq]
    exact hbern
  · have hx23 : 23 / 10 ≤ x := (lt_of_not_ge hlo).le
    by_cases hmid : x ≤ 12 / 5
    · let z : ℝ := (x - 23 / 10) / ((12 / 5 : ℝ) - 23 / 10)
      have hz0 : 0 ≤ z := by dsimp [z]; norm_num at hx23 ⊢; linarith
      have hz1 : z ≤ 1 := by dsimp [z]; norm_num at hmid ⊢; linarith
      have hzsub : 0 ≤ 1 - z := sub_nonneg.mpr hz1
      have hbern : 0 ≤
          (5267196661062173 : ℝ) / 12700800000000000000 * (1 - z) ^ 9 +
          (143810632375301 : ℝ) / 58800000000000000 * z * (1 - z) ^ 8 +
          (1179664782845231 : ℝ) / 176400000000000000 * z ^ 2 * (1 - z) ^ 7 +
          (41427864302347 : ℝ) / 3150000000000000 * z ^ 3 * (1 - z) ^ 6 +
          (18255392733451 : ℝ) / 787500000000000 * z ^ 4 * (1 - z) ^ 5 +
          (1107191883487 : ℝ) / 32812500000000 * z ^ 5 * (1 - z) ^ 4 +
          (1124077130779 : ℝ) / 32812500000000 * z ^ 6 * (1 - z) ^ 3 +
          (208044375569 : ℝ) / 9570312500000 * z ^ 7 * (1 - z) ^ 2 +
          (36849251759 : ℝ) / 4785156250000 * z ^ 8 * (1 - z) +
          (695624261 : ℝ) / 598144531250 * z ^ 9 := by
        positivity
      have heq : ratioMargin x =
          (5267196661062173 : ℝ) / 12700800000000000000 * (1 - z) ^ 9 +
          (143810632375301 : ℝ) / 58800000000000000 * z * (1 - z) ^ 8 +
          (1179664782845231 : ℝ) / 176400000000000000 * z ^ 2 * (1 - z) ^ 7 +
          (41427864302347 : ℝ) / 3150000000000000 * z ^ 3 * (1 - z) ^ 6 +
          (18255392733451 : ℝ) / 787500000000000 * z ^ 4 * (1 - z) ^ 5 +
          (1107191883487 : ℝ) / 32812500000000 * z ^ 5 * (1 - z) ^ 4 +
          (1124077130779 : ℝ) / 32812500000000 * z ^ 6 * (1 - z) ^ 3 +
          (208044375569 : ℝ) / 9570312500000 * z ^ 7 * (1 - z) ^ 2 +
          (36849251759 : ℝ) / 4785156250000 * z ^ 8 * (1 - z) +
          (695624261 : ℝ) / 598144531250 * z ^ 9 := by
        dsimp [ratioMargin, z]
        ring
      rw [heq]
      exact hbern
    · have hx24 : 12 / 5 ≤ x := (lt_of_not_ge hmid).le
      let z : ℝ := (x - 12 / 5) / ((22 / 7 : ℝ) - 12 / 5)
      have hz0 : 0 ≤ z := by dsimp [z]; norm_num at hx24 ⊢; linarith
      have hz1 : z ≤ 1 := by dsimp [z]; norm_num at hxpi ⊢; linarith
      have hzsub : 0 ≤ 1 - z := sub_nonneg.mpr hz1
      have hbern : 0 ≤
          (695624261 : ℝ) / 598144531250 * (1 - z) ^ 9 +
          (51942538463 : ℝ) / 1674804687500 * z * (1 - z) ^ 8 +
          (371153798641 : ℝ) / 1172363281250 * z ^ 2 * (1 - z) ^ 7 +
          (2022330923707 : ℝ) / 1406835937500 * z ^ 3 * (1 - z) ^ 6 +
          (1754810580937 : ℝ) / 492392578125 * z ^ 4 * (1 - z) ^ 5 +
          (43949167681739 : ℝ) / 8272195312500 * z ^ 5 * (1 - z) ^ 4 +
          (14249761144789 : ℝ) / 2895268359375 * z ^ 6 * (1 - z) ^ 3 +
          (79038299570372 : ℝ) / 28373629921875 * z ^ 7 * (1 - z) ^ 2 +
          (23433434337737 : ℝ) / 26482054593750 * z ^ 8 * (1 - z) +
          (242634681199297 : ℝ) / 2002043327287500 * z ^ 9 := by
        positivity
      have heq : ratioMargin x =
          (695624261 : ℝ) / 598144531250 * (1 - z) ^ 9 +
          (51942538463 : ℝ) / 1674804687500 * z * (1 - z) ^ 8 +
          (371153798641 : ℝ) / 1172363281250 * z ^ 2 * (1 - z) ^ 7 +
          (2022330923707 : ℝ) / 1406835937500 * z ^ 3 * (1 - z) ^ 6 +
          (1754810580937 : ℝ) / 492392578125 * z ^ 4 * (1 - z) ^ 5 +
          (43949167681739 : ℝ) / 8272195312500 * z ^ 5 * (1 - z) ^ 4 +
          (14249761144789 : ℝ) / 2895268359375 * z ^ 6 * (1 - z) ^ 3 +
          (79038299570372 : ℝ) / 28373629921875 * z ^ 7 * (1 - z) ^ 2 +
          (23433434337737 : ℝ) / 26482054593750 * z ^ 8 * (1 - z) +
          (242634681199297 : ℝ) / 2002043327287500 * z ^ 9 := by
        dsimp [ratioMargin, z]
        ring
      rw [heq]
      exact hbern

/-- The tenth-order Taylor polynomial is a lower bound for cosine on `[0, π]`.
The sign of the Lagrange remainder is controlled by sine on this interval. -/
theorem cosine_tenthOrder_lower_bound {x : ℝ} (hx0 : 0 ≤ x) (hxpi : x ≤ Real.pi) :
    1 - x ^ 2 / 2 + x ^ 4 / 24 - x ^ 6 / 720 + x ^ 8 / 40320 - x ^ 10 / 3628800 ≤
      Real.cos x := by
  rcases eq_or_lt_of_le hx0 with rfl | hxpos
  · norm_num
    exact le_rfl
  · obtain ⟨y, hy, hrem⟩ :=
      taylor_mean_remainder_lagrange_iteratedDeriv (f := Real.cos) (n := 10) hxpos
        Real.contDiff_cos.contDiffOn
    have hsin : 0 ≤ Real.sin y :=
      Real.sin_nonneg_of_nonneg_of_le_pi hy.1.le (hy.2.le.trans hxpi)
    have hderiv : iteratedDeriv 11 Real.cos y = Real.sin y := by
      rw [show 11 = 2 * 5 + 1 by norm_num, Real.iteratedDeriv_odd_cos]
      change (((-1 : ℝ → ℝ) ^ 6) * Real.sin) y = Real.sin y
      rw [show (-1 : ℝ → ℝ) ^ 6 = 1 by norm_num, one_mul]
    rw [hderiv] at hrem
    have hpoly :
        taylorWithinEval Real.cos 10 (Icc 0 x) 0 x =
          1 - x ^ 2 / 2 + x ^ 4 / 24 - x ^ 6 / 720 + x ^ 8 / 40320 - x ^ 10 / 3628800 := by
      have hiter (n : ℕ) : iteratedDerivWithin n Real.cos (Icc 0 x) 0 =
          iteratedDeriv n Real.cos 0 :=
        Real.iteratedDerivWithin_cos_Icc n hxpos ⟨le_rfl, hxpos.le⟩
      norm_num [taylorWithinEval, taylorWithin, taylorCoeffWithin,
        hiter, Real.iteratedDeriv_even_cos, Real.iteratedDeriv_odd_cos,
        Finset.sum_range_succ] <;> ring_nf <;> rfl
    rw [hpoly] at hrem
    have hrem' :
        Real.cos x -
            (1 - x ^ 2 / 2 + x ^ 4 / 24 - x ^ 6 / 720 + x ^ 8 / 40320 -
              x ^ 10 / 3628800) =
          Real.sin y * x ^ 11 / 39916800 := by
      convert hrem using 1 <;> norm_num
    have hrhs : 0 ≤ Real.sin y * x ^ 11 / 39916800 := by positivity
    linarith

private lemma angle_rounding_lower_bound {x : ℝ} (hx0 : 0 ≤ x) (hxpi : x ≤ Real.pi) :
    (439 * Real.pi / 1000) * (1 - Real.cos x) ≤ x := by
  have htaylor := cosine_tenthOrder_lower_bound hx0 hxpi
  let q : ℝ := x ^ 2 / 2 - x ^ 4 / 24 + x ^ 6 / 720 - x ^ 8 / 40320 +
    x ^ 10 / 3628800
  have hcosq : 1 - Real.cos x ≤ q := by
    dsimp [q]
    linarith
  have hq0 : 0 ≤ q := (sub_nonneg.mpr (Real.cos_le_one x)).trans hcosq
  have hpi22 : Real.pi ≤ 22 / 7 := by nlinarith [Real.pi_lt_d4]
  have hx22 : x ≤ 22 / 7 := hxpi.trans hpi22
  have hmargin := ratioMargin_nonneg hx0 hx22
  have hfactor : q = x *
      (x / 2 - x ^ 3 / 24 + x ^ 5 / 720 - x ^ 7 / 40320 + x ^ 9 / 3628800) := by
    dsimp [q]
    ring
  have hpoly : (4829 / 3500 : ℝ) * q ≤ x := by
    rw [hfactor]
    dsimp [ratioMargin] at hmargin
    nlinarith [mul_nonneg hx0 hmargin]
  have hc : 439 * Real.pi / 1000 ≤ (4829 / 3500 : ℝ) := by
    nlinarith [hpi22]
  have hc0 : 0 ≤ 439 * Real.pi / 1000 := by positivity
  calc
    (439 * Real.pi / 1000) * (1 - Real.cos x) ≤
        (439 * Real.pi / 1000) * q := mul_le_mul_of_nonneg_left hcosq hc0
    _ ≤ (4829 / 3500 : ℝ) * q := mul_le_mul_of_nonneg_right hc hq0
    _ ≤ x := hpoly

/-- The explicit Goemans--Williamson numerical inequality used in display
(3.27): on `[-1, 1]`, normalized arccos dominates `0.878 * (1 - t)`. -/
theorem goemansWilliamson_arccos_bound {t : ℝ} (ht : t ∈ Icc (-1 : ℝ) 1) :
    (439 / 500 : ℝ) * (1 - t) ≤ 2 / Real.pi * Real.arccos t := by
  have hangle := angle_rounding_lower_bound (Real.arccos_nonneg t) (Real.arccos_le_pi t)
  rw [Real.cos_arccos ht.1 ht.2] at hangle
  calc
    (439 / 500 : ℝ) * (1 - t) =
        (2 / Real.pi) * ((439 * Real.pi / 1000) * (1 - t)) := by
          field_simp [Real.pi_ne_zero]
          <;> ring
    _ ≤ (2 / Real.pi) * Real.arccos t :=
      mul_le_mul_of_nonneg_left hangle (by positivity)

end

end NumStability.HDP.Graph
