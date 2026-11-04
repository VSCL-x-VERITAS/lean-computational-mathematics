/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference
import Mathlib.Tactic.Abel

/-!
# Positive rectangles and the actual all-oriented rectangle law

The literal rectangle defect changes sign under either orientation reversal
and vanishes on a collapsed interval. These algebraic facts require no smoothness
or existence assertion. On the explicit spatial-slice/time-flux integrability
carrier they identify positive-rectangle testing with the existing local
conservation predicate on the whole closed forward strip. The orientation
argument works for any real horizon, in particular every positive horizon.
-/

noncomputable section
open Set MeasureTheory

namespace NumStability.LocalConservationLaw

section NormedSpace

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- SAME physical flux, oriented spatial masses and oriented time flux. -/
def rectangleDefect (q : ℝ → ℝ → E) (flux : E → E) (a b s t : ℝ) : E :=
  (∫ x in a..b, q x t) - (∫ x in a..b, q x s) -
    ∫ τ in s..t, flux (q a τ) - flux (q b τ)

@[simp]
theorem rectangleDefect_zero_width (q : ℝ → ℝ → E) (flux : E → E) (a s t : ℝ) :
    rectangleDefect q flux a a s t = 0 := by
  simp [rectangleDefect]

@[simp]
theorem rectangleDefect_zero_duration (q : ℝ → ℝ → E) (flux : E → E) (a b s : ℝ) :
    rectangleDefect q flux a b s s = 0 := by
  simp [rectangleDefect]

theorem rectangleDefect_swap_space (q : ℝ → ℝ → E) (flux : E → E) (a b s t : ℝ) :
    rectangleDefect q flux b a s t = -rectangleDefect q flux a b s t := by
  have hf : (fun τ => flux (q b τ) - flux (q a τ)) =
      fun τ => -(flux (q a τ) - flux (q b τ)) := by
    funext τ
    abel
  unfold rectangleDefect
  rw [intervalIntegral.integral_symm (a := a) (b := b) (f := fun x => q x t),
    intervalIntegral.integral_symm (a := a) (b := b) (f := fun x => q x s),
    hf, intervalIntegral.integral_neg]
  abel

theorem rectangleDefect_swap_time (q : ℝ → ℝ → E) (flux : E → E) (a b s t : ℝ) :
    rectangleDefect q flux a b t s = -rectangleDefect q flux a b s t := by
  unfold rectangleDefect
  rw [intervalIntegral.integral_symm (a := s) (b := t)
    (f := fun τ => flux (q a τ) - flux (q b τ))]
  abel

/-- Positive rectangles suffice for the entire oriented defect family, including
all four time/spatial orientations, collapsed intervals, and both strip ends. -/
theorem rectangleDefect_zero_all_iff_positive
    (q : ℝ → ℝ → E) (flux : E → E) (T : ℝ) :
    (∀ a b : ℝ, ∀ s ∈ Icc 0 T, ∀ t ∈ Icc 0 T,
      rectangleDefect q flux a b s t = 0) ↔
    (∀ a b : ℝ, a < b → ∀ s t : ℝ, 0 ≤ s → s < t → t ≤ T →
      rectangleDefect q flux a b s t = 0) := by
  constructor
  · intro h a b _ s t hs hst ht
    exact h a b s ⟨hs, hst.le.trans ht⟩ t ⟨hs.trans hst.le, ht⟩
  · intro h
    have hordered (a b : ℝ) (hab : a < b) :
        ∀ s ∈ Icc 0 T, ∀ t ∈ Icc 0 T, rectangleDefect q flux a b s t = 0 := by
      intro s hs t ht
      rcases lt_trichotomy s t with hst | rfl | hts
      · exact h a b hab s t hs.1 hst ht.2
      · exact rectangleDefect_zero_duration q flux a b s
      · rw [rectangleDefect_swap_time q flux a b t s,
          h a b hab t s ht.1 hts hs.2, neg_zero]
    intro a b s hs t ht
    rcases lt_trichotomy a b with hab | rfl | hba
    · exact hordered a b hab s hs t ht
    · exact rectangleDefect_zero_width q flux a s t
    · rw [rectangleDefect_swap_space q flux b a s t,
        hordered b a hba s hs t ht, neg_zero]

end NormedSpace

/-- Exact positive-rectangle characterization of the existing all-oriented
reference relation, on its SAME actual integrability carrier. There is no
positive-dimension, regularity, exact-reference or narrower-time premise. -/
theorem rectangleReferenceOn_all_iff_positive_defect {m : ℕ}
    (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ) (T : ℝ)
    (hspace : ∀ t ∈ Icc 0 T, ∀ a b : ℝ,
      IntervalIntegrable (fun x => q x t) volume a b)
    (hflux : ∀ x : ℝ, IntervalIntegrable (fun t => flux (q x t)) volume 0 T) :
    (∀ left right : ℝ, RectangleReferenceOn q flux left right T) ↔
      (∀ a b : ℝ, a < b → ∀ s t : ℝ, 0 ≤ s → s < t → t ≤ T →
        rectangleDefect q flux a b s t = 0) := by
  rw [← rectangleDefect_zero_all_iff_positive]
  constructor
  · intro h a b s hs t ht
    have hb := (h (min a b) (max a b)).2.2
      a ⟨min_le_left _ _, le_max_left _ _⟩
      b ⟨min_le_right _ _, le_max_right _ _⟩ s hs t ht
    exact sub_eq_zero.mpr hb
  · intro h left right
    refine ⟨fun t ht => hspace t ht left right, fun x _ => hflux x, ?_⟩
    intro a _ b _ s hs t ht
    exact sub_eq_zero.mp (h a b s hs t ht)

end NumStability.LocalConservationLaw
