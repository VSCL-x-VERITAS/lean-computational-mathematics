import Mathlib.Data.Real.Basic
import Mathlib.Tactic.FieldSimp

namespace NumStability.Chapter01Scratch

/-- A field is self-similar at positive time when its value depends only on
the ray x/t. The time-one slice is the selected similarity profile. -/
def IsPositiveTimeSelfSimilar {State : Type*} (q : ℝ → ℝ → State) : Prop :=
  ∀ (x : ℝ) {t : ℝ}, 0 < t → q x t = q (x / t) 1

/-- Value of the selected similarity profile on a ray. -/
def similarityRayValue {State : Type*} (q : ℝ → ℝ → State) (ray : ℝ) : State :=
  q ray 1

theorem IsPositiveTimeSelfSimilar.on_ray {State : Type*} {q : ℝ → ℝ → State}
    (h : IsPositiveTimeSelfSimilar q) (ray : ℝ) {t : ℝ} (ht : 0 < t) :
    q (ray * t) t = similarityRayValue q ray := by
  simpa only [similarityRayValue, mul_div_cancel_right₀ _ ht.ne'] using h (ray * t) ht

/-- The time-one evaluation is the unique value taken on the selected
positive-time ray, including the ray zero used by Riemann flux notation. -/
theorem IsPositiveTimeSelfSimilar.rayValue_iff {State : Type*}
    {q : ℝ → ℝ → State} (h : IsPositiveTimeSelfSimilar q) (ray : ℝ) (value : State) :
    similarityRayValue q ray = value ↔ ∀ t, 0 < t → q (ray * t) t = value := by
  constructor
  · intro hvalue t ht
    exact (h.on_ray ray ht).trans hvalue
  · intro hvalue
    simpa only [similarityRayValue, mul_one] using hvalue 1 zero_lt_one

theorem IsPositiveTimeSelfSimilar.rayZero {State : Type*} {q : ℝ → ℝ → State}
    (h : IsPositiveTimeSelfSimilar q) {t : ℝ} (ht : 0 < t) :
    q 0 t = similarityRayValue q 0 := by
  simpa only [zero_mul] using h.on_ray 0 ht

/-- Any explicitly selected profile supplies a self-similar field. No
continuity or trace uniqueness between different profiles is asserted. -/
theorem ratioProfile_isPositiveTimeSelfSimilar {State : Type*} (profile : ℝ → State) :
    IsPositiveTimeSelfSimilar (fun x t => profile (x / t)) := by
  intro x t _ht
  simp

#print axioms IsPositiveTimeSelfSimilar.on_ray
#print axioms IsPositiveTimeSelfSimilar.rayValue_iff
#print axioms IsPositiveTimeSelfSimilar.rayZero
#print axioms ratioProfile_isPositiveTimeSelfSimilar

end NumStability.Chapter01Scratch
