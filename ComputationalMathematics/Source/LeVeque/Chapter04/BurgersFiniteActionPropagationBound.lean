/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionWaveClassification
import ComputationalMathematics.Analysis.Calculus.LipschitzDerivativeBound

/-!
# Physical encountered speeds bound actual active-wave propagation

The bound below concerns the SAME constructed whole-line field. At each
positive time through the horizon it bounds the Rankine-Hugoniot speed of every
actual downward jump and the characteristic velocities inside every surviving
actual fan. It imposes no bound on states in constant regions or on material
labels. In particular it does not bound original fan states which interactions
have removed. The actual shock-or-fan classification then bounds derivatives of
nonzero-jump label boundaries; absolute continuity integrates this physical
bound from the original anchors. No CFL or flux-locality conclusion is assumed.
-/

noncomputable section
open Set MeasureTheory Filter
open scoped Topology NNReal

namespace NumStability

/-- The prescribed full-horizon propagation bound for the finite-action Burgers field. -/
def leveque04_burgersFiniteActionPropagationBound {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width horizon bound : ℝ) : Prop :=
  0 ≤ bound ∧ ∀ time ∈ Ioc (0 : ℝ) horizon,
    (∀ x : ℝ, leveque04_burgersFiniteActionEvolution old origin width x time <
        (x - sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width x time)) / time →
      |(((x - sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width x time)) / time) +
        leveque04_burgersFiniteActionEvolution old origin width x time) / 2| ≤ bound) ∧
    (∀ (j : Fin (N + 1)) (x : ℝ),
      leveque04_burgersFiniteActionLabelLeft old origin width
          (leveque04_burgersActionFace origin width j.val) time < x →
        x < leveque04_burgersFiniteActionLabelRight old origin width
          (leveque04_burgersActionFace origin width j.val) time →
        |(x - leveque04_burgersActionFace origin width j.val) / time| ≤ bound)

/-- Actual fan-interior propagation bounds persist at both endpoint limits,
even when a shock truncates a fan before its original state is reached. -/
theorem leveque04_burgersFiniteActionPropagationBound_fan_endpoint_velocities {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width horizon bound time : ℝ)
    (hprop : leveque04_burgersFiniteActionPropagationBound old origin width horizon bound)
    (htime : time ∈ Ioc (0 : ℝ) horizon) (j : Fin (N + 1))
    (hopen : leveque04_burgersFiniteActionLabelLeft old origin width
        (leveque04_burgersActionFace origin width j.val) time <
      leveque04_burgersFiniteActionLabelRight old origin width
        (leveque04_burgersActionFace origin width j.val) time) :
    |(leveque04_burgersFiniteActionLabelLeft old origin width
        (leveque04_burgersActionFace origin width j.val) time -
          leveque04_burgersActionFace origin width j.val) / time| ≤ bound ∧
    |(leveque04_burgersFiniteActionLabelRight old origin width
        (leveque04_burgersActionFace origin width j.val) time -
          leveque04_burgersActionFace origin width j.val) / time| ≤ bound := by
  let a := leveque04_burgersActionFace origin width j.val
  let L := leveque04_burgersFiniteActionLabelLeft old origin width a time
  let R := leveque04_burgersFiniteActionLabelRight old origin width a time
  have hc : IsClosed {x : ℝ | |(x - a) / time| ≤ bound} :=
    isClosed_le ((continuous_id.sub continuous_const).div_const time).abs continuous_const
  have hsub : Ioo L R ⊆ {x : ℝ | |(x - a) / time| ≤ bound} := by
    intro x hx
    exact (hprop.2 time htime).2 j x hx.1 hx.2
  have hclosure := closure_minimal hsub hc
  rw [closure_Ioo (ne_of_lt hopen)] at hclosure
  exact ⟨hclosure ⟨le_refl L, hopen.le⟩, hclosure ⟨hopen.le, le_refl R⟩⟩

/-- The physical bound controls actual derivatives of BOTH boundaries of a
nonzero original jump. Interaction-created shocks use the current trace mean. -/
theorem leveque04_burgersFiniteActionPropagationBound_label_derivatives_ae {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width horizon bound : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width)
    (hjump : leveque04_burgersActionState old j.val ≠ leveque04_burgersActionState old (j.val + 1))
    (hprop : leveque04_burgersFiniteActionPropagationBound old origin width horizon bound) :
    ∀ᵐ time : ℝ, time ∈ Ioc (0 : ℝ) horizon →
      |deriv (leveque04_burgersFiniteActionLabelLeft old origin width
        (leveque04_burgersActionFace origin width j.val)) time| ≤ bound ∧
      |deriv (leveque04_burgersFiniteActionLabelRight old origin width
        (leveque04_burgersActionFace origin width j.val)) time| ≤ bound := by
  let a := leveque04_burgersActionFace origin width j.val
  filter_upwards [leveque04_burgersFiniteActionLabelLeft_wave_classification_ae
      old origin width j hwidth hjump,
    leveque04_burgersFiniteActionLabelRight_wave_classification_ae
      old origin width j hwidth hjump] with time hleft hright
  intro ht
  constructor
  · rcases hleft ht.1 with hf | hs
    · have hb := (leveque04_burgersFiniteActionPropagationBound_fan_endpoint_velocities
        old origin width horizon bound time hprop ht j hf.1).1
      have hq : (leveque04_burgersFiniteActionLabelLeft old origin width a time - a) / time =
          leveque04_burgersActionState old j.val := by
        apply (div_eq_iff ht.1.ne').mpr
        rw [hf.2.2.1]
        ring
      rw [hf.2.2.2, ← hq]
      exact hb
    · rw [hs.2]
      exact (hprop.2 time ht).1 _ hs.1
  · rcases hright ht.1 with hf | hs
    · have hb := (leveque04_burgersFiniteActionPropagationBound_fan_endpoint_velocities
        old origin width horizon bound time hprop ht j hf.1).2
      have hq : (leveque04_burgersFiniteActionLabelRight old origin width a time - a) / time =
          leveque04_burgersActionState old (j.val + 1) := by
        apply (div_eq_iff ht.1.ne').mpr
        rw [hf.2.2.1]
        ring
      rw [hf.2.2.2, ← hq]
      exact hb
    · rw [hs.2]
      exact (hprop.2 time ht).1 _ hs.1

/-- Actual S-cones from original anchors for every active initial jump. The
analytic K only supplies absolute continuity; displacement uses physical S. -/
theorem leveque04_burgersFiniteActionPropagationBound_label_cones {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width horizon bound time : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width)
    (hjump : leveque04_burgersActionState old j.val ≠ leveque04_burgersActionState old (j.val + 1))
    (hprop : leveque04_burgersFiniteActionPropagationBound old origin width horizon bound)
    (htime : time ∈ Icc (0 : ℝ) horizon) :
    |leveque04_burgersFiniteActionLabelLeft old origin width
        (leveque04_burgersActionFace origin width j.val) time -
          leveque04_burgersActionFace origin width j.val| ≤ bound * time ∧
    |leveque04_burgersFiniteActionLabelRight old origin width
        (leveque04_burgersActionFace origin width j.val) time -
          leveque04_burgersActionFace origin width j.val| ≤ bound * time := by
  let a := leveque04_burgersActionFace origin width j.val
  have hlip := leveque04_burgersFiniteActionLabelBoundaries_time_lipschitz old origin width a hwidth.le
  have hd := leveque04_burgersFiniteActionPropagationBound_label_derivatives_ae
    old origin width horizon bound j hwidth hjump hprop
  have hdL : ∀ᵐ s : ℝ, s ∈ Ioc (0 : ℝ) time →
      |deriv (leveque04_burgersFiniteActionLabelLeft old origin width a) s| ≤ bound :=
    hd.mono (fun s hs hst => (hs ⟨hst.1, hst.2.trans htime.2⟩).1)
  have hdR : ∀ᵐ s : ℝ, s ∈ Ioc (0 : ℝ) time →
      |deriv (leveque04_burgersFiniteActionLabelRight old origin width a) s| ≤ bound :=
    hd.mono (fun s hs hst => (hs ⟨hst.1, hst.2.trans htime.2⟩).2)
  have hL := lipschitz_abs_sub_le_of_ae_deriv_le
    (leveque04_burgersFiniteActionLabelLeft old origin width a) hlip.1 0 time bound htime.1 hdL
  have hR := lipschitz_abs_sub_le_of_ae_deriv_le
    (leveque04_burgersFiniteActionLabelRight old origin width a) hlip.2 0 time bound htime.1 hdR
  have hi := leveque04_burgersFiniteActionLabelBoundaries_initial old origin width a
  exact ⟨by simpa only [hi.1, sub_zero] using hL, by simpa only [hi.2, sub_zero] using hR⟩

end NumStability
