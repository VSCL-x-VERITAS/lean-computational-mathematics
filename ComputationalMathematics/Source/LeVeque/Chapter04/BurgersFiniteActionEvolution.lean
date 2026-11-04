/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionInitialData
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionMeasurable
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionSpatialIntegral
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionTimeRegularity

/-!
# The same variational field with its actual initial datum

Positive times retain exactly the existing selected finite-action velocity and
potential. At time zero the field is the prescribed finite reconstruction and
the potential is its actual primitive. The nonpositive extension is convenient
for regularity; no conservation assertion at negative times is made.

Joint measurability, a genuine global field bound, initial/positive spatial
integrals and time Lipschitz regularity of the extended potential are derived.
These facts alone are not a compact-test weak or initial local-L1 trace theorem.
-/

noncomputable section
open Set MeasureTheory
open scoped Interval

namespace NumStability

/-- The finite-action Burgers evolution, retaining the supplied profile at nonpositive times. -/
def leveque04_burgersFiniteActionEvolution {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) : ℝ :=
  if time ≤ 0 then leveque04_burgersFiniteActionInitialData old origin width x
  else leveque04_burgersFiniteActionVelocity old origin width x time

/-- The finite-action forward potential, retaining the initial primitive at nonpositive times. -/
def leveque04_burgersFiniteActionForwardPotential {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) : ℝ :=
  if time ≤ 0 then leveque04_burgersInitialPrimitive old origin width x
  else leveque04_burgersFiniteActionPotential old origin width x time

@[simp]
theorem leveque04_burgersFiniteActionEvolution_initial {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x : ℝ) :
    leveque04_burgersFiniteActionEvolution old origin width x 0 =
      leveque04_burgersFiniteActionInitialData old origin width x := by
  simp only [leveque04_burgersFiniteActionEvolution, le_refl, if_true]

theorem leveque04_burgersFiniteActionEvolution_positive {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) (htime : 0 < time) :
    leveque04_burgersFiniteActionEvolution old origin width x time =
      leveque04_burgersFiniteActionVelocity old origin width x time :=
  if_neg (not_le_of_gt htime)

@[simp]
theorem leveque04_burgersFiniteActionForwardPotential_initial {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x : ℝ) :
    leveque04_burgersFiniteActionForwardPotential old origin width x 0 =
      leveque04_burgersInitialPrimitive old origin width x := by
  simp only [leveque04_burgersFiniteActionForwardPotential, le_refl, if_true]

theorem leveque04_burgersFiniteActionForwardPotential_positive {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) (htime : 0 < time) :
    leveque04_burgersFiniteActionForwardPotential old origin width x time =
      leveque04_burgersFiniteActionPotential old origin width x time :=
  if_neg (not_le_of_gt htime)

theorem leveque04_burgersFiniteActionEvolution_joint_measurable {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) :
    Measurable (fun z : ℝ × ℝ => leveque04_burgersFiniteActionEvolution old origin width z.1 z.2) := by
  exact Measurable.ite (measurableSet_le measurable_snd measurable_const)
    ((leveque04_burgersFiniteActionInitialData_measurable old origin width).comp measurable_fst)
    (leveque04_burgersFiniteActionVelocity_joint_measurable old origin width)

theorem leveque04_burgersFiniteActionForwardPotential_joint_measurable {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) :
    Measurable (fun z : ℝ × ℝ => leveque04_burgersFiniteActionForwardPotential old origin width z.1 z.2) := by
  exact Measurable.ite (measurableSet_le measurable_snd measurable_const)
    ((leveque04_burgersInitialPrimitive_continuous old origin width).measurable.comp measurable_fst)
    (leveque04_burgersFiniteActionPotential_joint_measurable old origin width)

theorem leveque04_burgersFiniteActionEvolution_abs_le {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) (hwidth : 0 ≤ width) :
    |leveque04_burgersFiniteActionEvolution old origin width x time| ≤
      leveque04_burgersPrimitiveBound old := by
  unfold leveque04_burgersFiniteActionEvolution
  split_ifs with ht
  · exact leveque04_burgersFiniteActionInitialData_abs_le old origin width x
  · exact leveque04_burgersFiniteActionVelocity_abs_le old origin width x time hwidth (lt_of_not_ge ht)

theorem leveque04_burgersFiniteActionEvolution_spatial_integral {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time left right : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 ≤ time) :
    IntervalIntegrable (fun x => leveque04_burgersFiniteActionEvolution old origin width x time)
      volume left right ∧
      (∫ x in left..right, leveque04_burgersFiniteActionEvolution old origin width x time) =
        leveque04_burgersFiniteActionForwardPotential old origin width right time -
          leveque04_burgersFiniteActionForwardPotential old origin width left time := by
  by_cases ht0 : time = 0
  · subst time
    simpa only [leveque04_burgersFiniteActionEvolution_initial,
      leveque04_burgersFiniteActionForwardPotential_initial] using
      leveque04_burgersFiniteActionInitialData_spatial_integral old origin width left right
  · have htpos : 0 < time := lt_of_le_of_ne htime (Ne.symm ht0)
    have hfun : (fun x => leveque04_burgersFiniteActionEvolution old origin width x time) =
        (fun x => leveque04_burgersFiniteActionVelocity old origin width x time) :=
      funext (fun x => leveque04_burgersFiniteActionEvolution_positive old origin width x time htpos)
    rw [hfun, leveque04_burgersFiniteActionForwardPotential_positive old origin width right time htpos,
      leveque04_burgersFiniteActionForwardPotential_positive old origin width left time htpos]
    exact leveque04_burgersFiniteActionVelocity_spatial_integral old origin width time left right hwidth htpos

private theorem forwardPotential_time_ordered_bound {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x s t : ℝ)
    (hwidth : 0 ≤ width) (hst : s ≤ t) :
    |leveque04_burgersFiniteActionForwardPotential old origin width x s -
      leveque04_burgersFiniteActionForwardPotential old origin width x t| ≤
        leveque04_burgersPrimitiveBound old ^ 2 * (t - s) := by
  by_cases ht : t ≤ 0
  · simp only [leveque04_burgersFiniteActionForwardPotential, if_pos ht, if_pos (hst.trans ht),
      sub_self, abs_zero]
    exact mul_nonneg (sq_nonneg _) (sub_nonneg.mpr hst)
  · have htpos : 0 < t := lt_of_not_ge ht
    by_cases hs : s ≤ 0
    · rw [leveque04_burgersFiniteActionForwardPotential, if_pos hs,
        leveque04_burgersFiniteActionForwardPotential, if_neg ht]
      have hb := leveque04_burgersFiniteActionPotential_abs_sub_initial_le old origin width x t hwidth htpos
      rw [abs_sub_comm] at hb
      have hK := sq_nonneg (leveque04_burgersPrimitiveBound old)
      have hKs := mul_nonpos_of_nonneg_of_nonpos hK hs
      nlinarith
    · rw [leveque04_burgersFiniteActionForwardPotential, if_neg hs,
        leveque04_burgersFiniteActionForwardPotential, if_neg ht]
      have hb := leveque04_burgersFiniteActionPotential_time_abs_sub_le old origin width x s t
        hwidth (lt_of_not_ge hs) htpos
      rwa [abs_of_nonpos (sub_nonpos.mpr hst), neg_sub] at hb

theorem leveque04_burgersFiniteActionForwardPotential_time_abs_sub_le {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x s t : ℝ) (hwidth : 0 ≤ width) :
    |leveque04_burgersFiniteActionForwardPotential old origin width x s -
      leveque04_burgersFiniteActionForwardPotential old origin width x t| ≤
        leveque04_burgersPrimitiveBound old ^ 2 * |s - t| := by
  rcases le_total s t with hst | hts
  · rw [abs_of_nonpos (sub_nonpos.mpr hst), neg_sub]
    exact forwardPotential_time_ordered_bound old origin width x s t hwidth hst
  · rw [abs_sub_comm (leveque04_burgersFiniteActionForwardPotential old origin width x s),
      abs_of_nonneg (sub_nonneg.mpr hts)]
    exact forwardPotential_time_ordered_bound old origin width x t s hwidth hts

theorem leveque04_burgersFiniteActionForwardPotential_time_lipschitz {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x : ℝ) (hwidth : 0 ≤ width) :
    LipschitzWith ⟨leveque04_burgersPrimitiveBound old ^ 2, sq_nonneg _⟩
      (fun time => leveque04_burgersFiniteActionForwardPotential old origin width x time) := by
  apply LipschitzWith.of_dist_le_mul
  intro s t
  simpa only [Real.dist_eq, NNReal.coe_mk] using
    leveque04_burgersFiniteActionForwardPotential_time_abs_sub_le old origin width x s t hwidth

end NumStability
