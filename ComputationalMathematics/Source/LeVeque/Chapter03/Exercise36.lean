/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.Exercise35

/-!
# Exercise 3.6: reflected backward characteristics

Printed page 63/raw PDF page 85. For the tube `[0,4]`, mirror images of
initial points lie at `x + 8k` and `-x + 8k`. Images of the left and right
walls lie at `8k` and `4 + 8k`. The following sets give the complete initial
and boundary parts of the domain of dependence of `(X,T)=(1,10)`, for the
source's unspecified positive sound speed.
-/

namespace NumStability

/-- The two directions of an acoustic characteristic. -/
def leveque03_exercise36Direction (s : ℝ) : Prop := s = 1 ∨ s = -1

/-- An unfolded backward acoustic ray from `(1,10)`. -/
def leveque03_exercise36Ray (soundSpeed s t : ℝ) : ℝ :=
  1 + s * soundSpeed * (10 - t)

/-- The initial-data points reached after any number of wall reflections. -/
def leveque03_exercise36InitialDomain (soundSpeed : ℝ) : Set ℝ :=
  {x | 0 ≤ x ∧ x ≤ 4 ∧
    ∃ (s : ℝ) (k : ℤ), leveque03_exercise36Direction s ∧
      (leveque03_exercise36Ray soundSpeed s 0 = x + 8 * (k : ℝ) ∨
       leveque03_exercise36Ray soundSpeed s 0 = -x + 8 * (k : ℝ))}

/-- Times at which the backward characteristics visit the left wall. -/
def leveque03_exercise36LeftBoundaryTimes (soundSpeed : ℝ) : Set ℝ :=
  {t | 0 ≤ t ∧ t ≤ 10 ∧
    ∃ (s : ℝ) (k : ℤ), leveque03_exercise36Direction s ∧
      leveque03_exercise36Ray soundSpeed s t = 8 * (k : ℝ)}

/-- Times at which the backward characteristics visit the right wall. -/
def leveque03_exercise36RightBoundaryTimes (soundSpeed : ℝ) : Set ℝ :=
  {t | 0 ≤ t ∧ t ≤ 10 ∧
    ∃ (s : ℝ) (k : ℤ), leveque03_exercise36Direction s ∧
      leveque03_exercise36Ray soundSpeed s t = 4 + 8 * (k : ℝ)}

/-- Closed arithmetic description of all initial points of dependence. -/
theorem leveque03_exercise36InitialDomain_iff (soundSpeed x : ℝ) :
    x ∈ leveque03_exercise36InitialDomain soundSpeed ↔
      0 ≤ x ∧ x ≤ 4 ∧ ∃ k : ℤ,
        x = 1 + 10 * soundSpeed - 8 * (k : ℝ) ∨
        x = 8 * (k : ℝ) - (1 + 10 * soundSpeed) ∨
        x = 1 - 10 * soundSpeed - 8 * (k : ℝ) ∨
        x = 8 * (k : ℝ) - (1 - 10 * soundSpeed) := by
  simp only [leveque03_exercise36InitialDomain, Set.mem_setOf_eq,
    leveque03_exercise36Direction, leveque03_exercise36Ray]
  constructor
  · rintro ⟨hx0, hx4, s, k, hs, h⟩
    refine ⟨hx0, hx4, k, ?_⟩
    rcases hs with rfl | rfl
    · rcases h with h | h
      · exact Or.inl (by nlinarith)
      · exact Or.inr (Or.inl (by nlinarith))
    · rcases h with h | h
      · exact Or.inr (Or.inr (Or.inl (by nlinarith)))
      · exact Or.inr (Or.inr (Or.inr (by nlinarith)))
  · rintro ⟨hx0, hx4, k, h⟩
    refine ⟨hx0, hx4, ?_⟩
    rcases h with h | h | h | h
    · exact ⟨1, k, Or.inl rfl, Or.inl (by nlinarith)⟩
    · exact ⟨1, k, Or.inl rfl, Or.inr (by nlinarith)⟩
    · exact ⟨-1, k, Or.inr rfl, Or.inl (by nlinarith)⟩
    · exact ⟨-1, k, Or.inr rfl, Or.inr (by nlinarith)⟩

/-- The complete left-wall time set, as two arithmetic progressions. -/
theorem leveque03_exercise36LeftBoundaryTimes_iff (soundSpeed t : ℝ) :
    t ∈ leveque03_exercise36LeftBoundaryTimes soundSpeed ↔
      0 ≤ t ∧ t ≤ 10 ∧ ∃ k : ℤ,
        soundSpeed * (10 - t) = 8 * (k : ℝ) - 1 ∨
        soundSpeed * (10 - t) = 1 - 8 * (k : ℝ) := by
  simp only [leveque03_exercise36LeftBoundaryTimes, Set.mem_setOf_eq,
    leveque03_exercise36Direction, leveque03_exercise36Ray]
  constructor
  · rintro ⟨ht0, ht10, s, k, hs, h⟩
    refine ⟨ht0, ht10, k, ?_⟩
    rcases hs with rfl | rfl
    · exact Or.inl (by norm_num at h; linarith)
    · exact Or.inr (by norm_num at h; linarith)
  · rintro ⟨ht0, ht10, k, h⟩
    refine ⟨ht0, ht10, ?_⟩
    rcases h with h | h
    · exact ⟨1, k, Or.inl rfl, by norm_num; linarith⟩
    · exact ⟨-1, k, Or.inr rfl, by norm_num; linarith⟩

/-- The complete right-wall time set, as two arithmetic progressions. -/
theorem leveque03_exercise36RightBoundaryTimes_iff (soundSpeed t : ℝ) :
    t ∈ leveque03_exercise36RightBoundaryTimes soundSpeed ↔
      0 ≤ t ∧ t ≤ 10 ∧ ∃ k : ℤ,
        soundSpeed * (10 - t) = 3 + 8 * (k : ℝ) ∨
        soundSpeed * (10 - t) = -(3 + 8 * (k : ℝ)) := by
  simp only [leveque03_exercise36RightBoundaryTimes, Set.mem_setOf_eq,
    leveque03_exercise36Direction, leveque03_exercise36Ray]
  constructor
  · rintro ⟨ht0, ht10, s, k, hs, h⟩
    refine ⟨ht0, ht10, k, ?_⟩
    rcases hs with rfl | rfl
    · exact Or.inl (by norm_num at h; linarith)
    · exact Or.inr (by norm_num at h; linarith)
  · rintro ⟨ht0, ht10, k, h⟩
    refine ⟨ht0, ht10, ?_⟩
    rcases h with h | h
    · exact ⟨1, k, Or.inl rfl, by norm_num; linarith⟩
    · exact ⟨-1, k, Or.inr rfl, by norm_num; linarith⟩

end NumStability
