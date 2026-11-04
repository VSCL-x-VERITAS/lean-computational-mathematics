/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.DerivativeOnFibers
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionShockSpeed
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionFanEdges

/-!
# Actual shock-or-fan classification of nonzero initial-jump boundaries

At almost every positive time either boundary of a nonzero original jump is
an edge of an actual nonempty ascending fan, moving at its original edge state,
or an actual downward jump moving at the mean of its two spatial traces.
Interactions are unrestricted. Equal-state material labels are excluded from
this active-wave statement. No physical S bound or CFL conclusion is assumed.
-/

noncomputable section
open Set MeasureTheory Filter
open scoped Topology NNReal

namespace NumStability

private theorem unique_minimizer_eq_label {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time label : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time)
    (hbracket : (∃ y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width x time, y ≤ label) ∧
      (∃ z ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width x time, label ≤ z))
    (heq : sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width x time) =
      leveque04_burgersFiniteActionFoot old origin width x time) :
    sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width x time) = label ∧
      leveque04_burgersFiniteActionFoot old origin width x time = label := by
  obtain ⟨⟨y, hy, hyl⟩, ⟨z, hz, hlz⟩⟩ := hbracket
  have hl := (leveque04_burgersFiniteActionMinimizingFeet_sInf_isLeast
    old origin width x time hwidth htime).2 hy
  have hr := (leveque04_burgersFiniteActionFoot_isGreatest
    old origin width x time hwidth htime).2 hz
  have hfoot : leveque04_burgersFiniteActionFoot old origin width x time = label := by
    apply le_antisymm _ (hlz.trans hr)
    rw [← heq]
    exact hl.trans hyl
  exact ⟨heq.trans hfoot, hfoot⟩

private theorem left_unique_is_open_fan {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width) (htime : 0 < time)
    (hjump : leveque04_burgersActionState old j.val ≠ leveque04_burgersActionState old (j.val + 1))
    (heq : sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width
      (leveque04_burgersFiniteActionLabelLeft old origin width
        (leveque04_burgersActionFace origin width j.val) time) time) =
      leveque04_burgersFiniteActionFoot old origin width
        (leveque04_burgersFiniteActionLabelLeft old origin width
          (leveque04_burgersActionFace origin width j.val) time) time) :
    leveque04_burgersFiniteActionLabelLeft old origin width
        (leveque04_burgersActionFace origin width j.val) time <
      leveque04_burgersFiniteActionLabelRight old origin width
        (leveque04_burgersActionFace origin width j.val) time ∧
    leveque04_burgersActionState old j.val < leveque04_burgersActionState old (j.val + 1) ∧
    leveque04_burgersFiniteActionLabelLeft old origin width
        (leveque04_burgersActionFace origin width j.val) time =
      leveque04_burgersActionFace origin width j.val + leveque04_burgersActionState old j.val * time := by
  let a := leveque04_burgersActionFace origin width j.val
  have hf := unique_minimizer_eq_label old origin width _ time a hwidth.le htime
    (leveque04_burgersFiniteActionLabelLeft_minimizers_bracket old origin width a time hwidth.le htime) heq
  have hpos := leveque04_burgersFiniteActionLabelLeft_eq_characteristic_of_leastFoot_eq_face
    old origin width time j hwidth htime hf.1
  have hopen : leveque04_burgersFiniteActionLabelLeft old origin width a time <
      leveque04_burgersFiniteActionLabelRight old origin width a time := by
    apply lt_of_le_of_ne (leveque04_burgersFiniteActionLabelBoundaries_ordered old origin width a time hwidth.le htime)
    intro hsame
    have hfr : leveque04_burgersFiniteActionFoot old origin width
        (leveque04_burgersFiniteActionLabelRight old origin width a time) time = a := by
      rw [← hsame]
      exact hf.2
    have hright := leveque04_burgersFiniteActionLabelRight_eq_characteristic_of_greatestFoot_eq_face
      old origin width time j hwidth htime hfr
    have hm : (leveque04_burgersActionState old j.val -
        leveque04_burgersActionState old (j.val + 1)) * time = 0 := by
      dsimp [a] at hsame
      nlinarith [hpos, hright]
    exact hjump (sub_eq_zero.mp ((mul_eq_zero.mp hm).resolve_right htime.ne'))
  exact ⟨hopen, leveque04_burgersFiniteActionLabelPlateau_face_ascending old origin width time j hwidth htime hopen, hpos⟩

private theorem right_unique_is_open_fan {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width) (htime : 0 < time)
    (hjump : leveque04_burgersActionState old j.val ≠ leveque04_burgersActionState old (j.val + 1))
    (heq : sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width
      (leveque04_burgersFiniteActionLabelRight old origin width
        (leveque04_burgersActionFace origin width j.val) time) time) =
      leveque04_burgersFiniteActionFoot old origin width
        (leveque04_burgersFiniteActionLabelRight old origin width
          (leveque04_burgersActionFace origin width j.val) time) time) :
    leveque04_burgersFiniteActionLabelLeft old origin width
        (leveque04_burgersActionFace origin width j.val) time <
      leveque04_burgersFiniteActionLabelRight old origin width
        (leveque04_burgersActionFace origin width j.val) time ∧
    leveque04_burgersActionState old j.val < leveque04_burgersActionState old (j.val + 1) ∧
    leveque04_burgersFiniteActionLabelRight old origin width
        (leveque04_burgersActionFace origin width j.val) time =
      leveque04_burgersActionFace origin width j.val + leveque04_burgersActionState old (j.val + 1) * time := by
  let a := leveque04_burgersActionFace origin width j.val
  have hf := unique_minimizer_eq_label old origin width _ time a hwidth.le htime
    (leveque04_burgersFiniteActionLabelRight_minimizers_bracket old origin width a time hwidth.le htime) heq
  have hpos := leveque04_burgersFiniteActionLabelRight_eq_characteristic_of_greatestFoot_eq_face
    old origin width time j hwidth htime hf.2
  have hopen : leveque04_burgersFiniteActionLabelLeft old origin width a time <
      leveque04_burgersFiniteActionLabelRight old origin width a time := by
    apply lt_of_le_of_ne (leveque04_burgersFiniteActionLabelBoundaries_ordered old origin width a time hwidth.le htime)
    intro hsame
    have hfl : sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width
        (leveque04_burgersFiniteActionLabelLeft old origin width a time) time) = a := by
      rw [hsame]
      exact hf.1
    have hleft := leveque04_burgersFiniteActionLabelLeft_eq_characteristic_of_leastFoot_eq_face
      old origin width time j hwidth htime hfl
    have hm : (leveque04_burgersActionState old j.val -
        leveque04_burgersActionState old (j.val + 1)) * time = 0 := by
      dsimp [a] at hsame
      nlinarith [hpos, hleft]
    exact hjump (sub_eq_zero.mp ((mul_eq_zero.mp hm).resolve_right htime.ne'))
  exact ⟨hopen, leveque04_burgersFiniteActionLabelPlateau_face_ascending old origin width time j hwidth htime hopen, hpos⟩

private theorem curve_cases_ae {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) (curve : ℝ → ℝ)
    {C : ℝ≥0} (hcurve : LipschitzWith C curve) (hwidth : 0 ≤ width) (a q : ℝ)
    (hcontact : ∀ time, 0 < time → sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width
      (curve time) time) = leveque04_burgersFiniteActionFoot old origin width (curve time) time →
      curve time = a + q * time) :
    ∀ᵐ time : ℝ, 0 < time →
      (curve time = a + q * time ∧ deriv curve time = q ∧
        sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width (curve time) time) =
          leveque04_burgersFiniteActionFoot old origin width (curve time) time) ∨
      (leveque04_burgersFiniteActionEvolution old origin width (curve time) time <
          (curve time - sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width (curve time) time)) / time ∧
        deriv curve time =
          (((curve time - sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width (curve time) time)) / time) +
            leveque04_burgersFiniteActionEvolution old origin width (curve time) time) / 2) := by
  filter_upwards [leveque04_burgersFiniteAction_curve_shock_speed_ae old origin width curve hcurve hwidth,
    lipschitz_deriv_eq_slope_ae_of_eq_affine curve hcurve a q] with time hshock hlinear
  intro ht
  have hleast := leveque04_burgersFiniteActionMinimizingFeet_sInf_isLeast old origin width (curve time) time hwidth ht
  have hgreat := leveque04_burgersFiniteActionFoot_isGreatest old origin width (curve time) time hwidth ht
  by_cases heq : sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width (curve time) time) =
      leveque04_burgersFiniteActionFoot old origin width (curve time) time
  · exact Or.inl ⟨hcontact time ht heq, hlinear (hcontact time ht heq), heq⟩
  · have hlt := lt_of_le_of_ne (hleast.2 hgreat.1) heq
    have hjump : leveque04_burgersFiniteActionEvolution old origin width (curve time) time <
        (curve time - sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width (curve time) time)) / time := by
      rw [leveque04_burgersFiniteActionEvolution_positive old origin width _ time ht,
        leveque04_burgersFiniteActionVelocity]
      exact div_lt_div_of_pos_right (by linarith) ht
    have hs := hshock ht _ hleast.1 _ hgreat.1 heq
    refine Or.inr ⟨hjump, ?_⟩
    simpa only [leveque04_burgersFiniteActionEvolution_positive old origin width _ time ht,
      leveque04_burgersFiniteActionVelocity] using hs

/-- Every nonzero original-jump LEFT boundary is an actual open fan edge
or an actual shock, with its corresponding physical velocity almost everywhere. -/
theorem leveque04_burgersFiniteActionLabelLeft_wave_classification_ae {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) (j : Fin (N + 1)) (hwidth : 0 < width)
    (hjump : leveque04_burgersActionState old j.val ≠ leveque04_burgersActionState old (j.val + 1)) :
    let a := leveque04_burgersActionFace origin width j.val
    let curve := leveque04_burgersFiniteActionLabelLeft old origin width a
    ∀ᵐ time : ℝ, 0 < time →
      (curve time < leveque04_burgersFiniteActionLabelRight old origin width a time ∧
        leveque04_burgersActionState old j.val < leveque04_burgersActionState old (j.val + 1) ∧
        curve time = a + leveque04_burgersActionState old j.val * time ∧
        deriv curve time = leveque04_burgersActionState old j.val) ∨
      (leveque04_burgersFiniteActionEvolution old origin width (curve time) time <
          (curve time - sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width (curve time) time)) / time ∧
        deriv curve time =
          (((curve time - sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width (curve time) time)) / time) +
            leveque04_burgersFiniteActionEvolution old origin width (curve time) time) / 2) := by
  let a := leveque04_burgersActionFace origin width j.val
  let curve := leveque04_burgersFiniteActionLabelLeft old origin width a
  have hlip := (leveque04_burgersFiniteActionLabelBoundaries_time_lipschitz old origin width a hwidth.le).1
  have hc := curve_cases_ae old origin width curve hlip hwidth.le a (leveque04_burgersActionState old j.val)
    (fun t ht heq => (left_unique_is_open_fan old origin width t j hwidth ht hjump heq).2.2)
  filter_upwards [hc] with time ht
  intro htime
  rcases ht htime with ⟨hpos, hv, heq⟩ | hs
  · have hf := left_unique_is_open_fan old origin width time j hwidth htime hjump heq
    exact Or.inl ⟨hf.1, hf.2.1, hpos, hv⟩
  · exact Or.inr hs

/-- The corresponding RIGHT-boundary classification uses the original
right fan state; the shock branch uses the actual current physical traces. -/
theorem leveque04_burgersFiniteActionLabelRight_wave_classification_ae {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) (j : Fin (N + 1)) (hwidth : 0 < width)
    (hjump : leveque04_burgersActionState old j.val ≠ leveque04_burgersActionState old (j.val + 1)) :
    let a := leveque04_burgersActionFace origin width j.val
    let curve := leveque04_burgersFiniteActionLabelRight old origin width a
    ∀ᵐ time : ℝ, 0 < time →
      (leveque04_burgersFiniteActionLabelLeft old origin width a time < curve time ∧
        leveque04_burgersActionState old j.val < leveque04_burgersActionState old (j.val + 1) ∧
        curve time = a + leveque04_burgersActionState old (j.val + 1) * time ∧
        deriv curve time = leveque04_burgersActionState old (j.val + 1)) ∨
      (leveque04_burgersFiniteActionEvolution old origin width (curve time) time <
          (curve time - sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width (curve time) time)) / time ∧
        deriv curve time =
          (((curve time - sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width (curve time) time)) / time) +
            leveque04_burgersFiniteActionEvolution old origin width (curve time) time) / 2) := by
  let a := leveque04_burgersActionFace origin width j.val
  let curve := leveque04_burgersFiniteActionLabelRight old origin width a
  have hlip := (leveque04_burgersFiniteActionLabelBoundaries_time_lipschitz old origin width a hwidth.le).2
  have hc := curve_cases_ae old origin width curve hlip hwidth.le a (leveque04_burgersActionState old (j.val + 1))
    (fun t ht heq => (right_unique_is_open_fan old origin width t j hwidth ht hjump heq).2.2)
  filter_upwards [hc] with time ht
  intro htime
  rcases ht htime with ⟨hpos, hv, heq⟩ | hs
  · have hf := right_unique_is_open_fan old origin width time j hwidth htime hjump heq
    exact Or.inl ⟨hf.1, hf.2.1, hpos, hv⟩
  · exact Or.inr hs

end NumStability
