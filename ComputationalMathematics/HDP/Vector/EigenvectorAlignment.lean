import Mathlib.Geometry.Euclidean.Angle.Unoriented.Basic

/-!
# Eigenvector alignment up to sign

For unit vectors, a small sine of the angle gives a small Euclidean distance
after choosing the better of the two possible signs.  This is the elementary
geometric step used after a Davis--Kahan estimate.
-/

noncomputable section

open RealInnerProductSpace

namespace NumStability.HDP.Vector

private theorem norm_sub_le_sqrt_two_mul_sin_angle_of_inner_nonneg
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (u v : E) (hu : ‖u‖ = 1) (hv : ‖v‖ = 1) (huv : 0 ≤ inner ℝ u v) :
    ‖u - v‖ ≤ Real.sqrt 2 * Real.sin (InnerProductGeometry.angle u v) := by
  have huv_le : inner ℝ u v ≤ 1 := by
    have h := abs_real_inner_le_norm u v
    rw [hu, hv, one_mul] at h
    exact le_trans (le_abs_self _) h
  have hcos : Real.cos (InnerProductGeometry.angle u v) = inner ℝ u v := by
    rw [InnerProductGeometry.cos_angle, hu, hv, one_mul, div_one]
  have htrig := Real.sin_sq_add_cos_sq (InnerProductGeometry.angle u v)
  rw [hcos] at htrig
  have hsin : 0 ≤ Real.sin (InnerProductGeometry.angle u v) :=
    InnerProductGeometry.sin_angle_nonneg u v
  have hsqrt : (Real.sqrt 2) ^ 2 = 2 := Real.sq_sqrt (by norm_num)
  have hnormsq : ‖u - v‖ ^ 2 = 2 * (1 - inner ℝ u v) := by
    rw [norm_sub_sq_real, hu, hv]
    ring
  have hsquares :
      ‖u - v‖ ^ 2 ≤
        (Real.sqrt 2 * Real.sin (InnerProductGeometry.angle u v)) ^ 2 := by
    rw [hnormsq, mul_pow, hsqrt]
    nlinarith
  have hrhs :
      0 ≤ Real.sqrt 2 * Real.sin (InnerProductGeometry.angle u v) :=
    mul_nonneg (Real.sqrt_nonneg _) hsin
  nlinarith [norm_nonneg (u - v)]

/-- Unit vectors can be aligned by a sign so that their distance is at most
`sqrt 2` times the sine of their (unoriented) angle.  Since sine is unchanged
when one vector is negated, this is the sign-invariant angle used for
one-dimensional eigenspaces. -/
theorem exists_sign_norm_sub_le_sqrt_two_mul_sin_angle
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (u v : E) (hu : ‖u‖ = 1) (hv : ‖v‖ = 1) :
    ∃ θ : ℝ, (θ = -1 ∨ θ = 1) ∧
      ‖u - θ • v‖ ≤ Real.sqrt 2 * Real.sin (InnerProductGeometry.angle u v) := by
  by_cases huv : 0 ≤ inner ℝ u v
  · refine ⟨1, Or.inr rfl, ?_⟩
    simpa using
      norm_sub_le_sqrt_two_mul_sin_angle_of_inner_nonneg u v hu hv huv
  · refine ⟨-1, Or.inl rfl, ?_⟩
    have hneg : 0 ≤ inner ℝ u (-v) := by
      rw [inner_neg_right]
      exact neg_nonneg.mpr (le_of_not_ge huv)
    have h := norm_sub_le_sqrt_two_mul_sin_angle_of_inner_nonneg
      u (-v) hu (by simpa using hv) hneg
    rw [InnerProductGeometry.angle_neg_right, Real.sin_pi_sub] at h
    simpa using h

/-- The sign-alignment consequence in the form used after Davis--Kahan: a
bound `sin(angle u v) ≤ η` gives a sign choice at distance at most
`sqrt 2 * η`. -/
theorem exists_sign_norm_sub_le_of_sin_angle_le
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (u v : E) (hu : ‖u‖ = 1) (hv : ‖v‖ = 1) (η : ℝ)
    (hangle : Real.sin (InnerProductGeometry.angle u v) ≤ η) :
    ∃ θ : ℝ, (θ = -1 ∨ θ = 1) ∧
      ‖u - θ • v‖ ≤ Real.sqrt 2 * η := by
  obtain ⟨θ, hθ, hdist⟩ :=
    exists_sign_norm_sub_le_sqrt_two_mul_sin_angle u v hu hv
  exact ⟨θ, hθ, hdist.trans (mul_le_mul_of_nonneg_left hangle (Real.sqrt_nonneg _))⟩

end NumStability.HDP.Vector
