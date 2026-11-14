/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.NumericalRangeBasicTarget

/-!
# Bhatia Chapter I: elementary properties of the numerical range

Section I.2, printed page 8. Unitary invariance follows by substituting `U* x`,
which runs over the unit sphere as `x` does. The affine formula uses
`⟨x, (aA + bI) x⟩ = a⟨x, A x⟩ + b` on unit vectors, with both sides empty in
dimension zero. A normalized eigenvector realizes its eigenvalue. Closedness
holds because `W(A)` is the continuous image of the compact unit sphere.
-/

set_option autoImplicit false
universe u

open scoped Pointwise

namespace NumStability.Bhatia.Chapter01

variable {H : Type u} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]

omit [FiniteDimensional ℂ H] in
/-- A unit vector has `⟨x, x⟩ = 1`. -/
private lemma inner_self_of_norm_one {x : H} (hx : ‖x‖ = 1) : inner ℂ x x = (1 : ℂ) := by
  rw [inner_self_eq_norm_sq_to_K, hx]; simp

/-- Section I.2: `W(U A U*) = W(A)` for unitary `U`. -/
theorem numericalRangeUnitaryInvariant : Targets.numericalRangeUnitaryInvariant.{u} := by
  intro H _ _ _ A U hUU hUU'
  have hnorm : ∀ x : H, ‖LinearMap.adjoint U x‖ = ‖x‖ := by
    intro x
    have h : inner ℂ (LinearMap.adjoint U x) (LinearMap.adjoint U x) = inner ℂ x x := by
      rw [LinearMap.adjoint_inner_left, ← LinearMap.comp_apply, hUU, LinearMap.id_apply]
    rw [@norm_eq_sqrt_re_inner ℂ, @norm_eq_sqrt_re_inner ℂ, h]
  have hnorm' : ∀ x : H, ‖U x‖ = ‖x‖ := by
    intro x
    have h : inner ℂ (U x) (U x) = inner ℂ x x := by
      rw [← LinearMap.adjoint_inner_right, ← LinearMap.comp_apply, hUU', LinearMap.id_apply]
    rw [@norm_eq_sqrt_re_inner ℂ, @norm_eq_sqrt_re_inner ℂ, h]
  ext z
  constructor
  · rintro ⟨x, hx, rfl⟩
    refine ⟨LinearMap.adjoint U x, by rw [hnorm, hx], ?_⟩
    simp only [LinearMap.comp_apply]
    rw [← LinearMap.adjoint_inner_left]
  · rintro ⟨y, hy, rfl⟩
    have hpres : ∀ v w : H, inner ℂ (U v) (U w) = inner ℂ v w := by
      intro v w
      rw [← LinearMap.adjoint_inner_left, ← LinearMap.comp_apply (LinearMap.adjoint U) U, hUU',
        LinearMap.id_apply]
    have hback : LinearMap.adjoint U (U y) = y := by
      rw [← LinearMap.comp_apply (LinearMap.adjoint U) U, hUU', LinearMap.id_apply]
    refine ⟨U y, by rw [hnorm', hy], ?_⟩
    simp only [LinearMap.comp_apply, hback, hpres]

/-- Section I.2: `W(aA + bI) = a W(A) + b W(I)`. -/
theorem numericalRangeAffine : Targets.numericalRangeAffine.{u} := by
  intro H _ _ _ A a b
  ext z
  simp only [Set.mem_setOf_eq, Set.mem_add, Set.mem_smul_set, LinearMap.id_apply]
  constructor
  · rintro ⟨x, hx, rfl⟩
    refine ⟨a * inner ℂ x (A x), ⟨inner ℂ x (A x), ⟨x, hx, rfl⟩, rfl⟩,
      b * 1, ⟨1, ⟨x, hx, (inner_self_of_norm_one hx).symm⟩, rfl⟩, ?_⟩
    simp [inner_add_right, inner_smul_right, hx]
  · rintro ⟨_, ⟨w, ⟨x, hx, rfl⟩, rfl⟩, _, ⟨v, ⟨y, hy, rfl⟩, rfl⟩, rfl⟩
    refine ⟨x, hx, ?_⟩
    simp [inner_add_right, inner_smul_right, hx, hy, smul_eq_mul]

/-- Section I.2: every eigenvalue lies in `W(A)`. -/
theorem eigenvalueMemNumericalRange : Targets.eigenvalueMemNumericalRange.{u} := by
  intro H _ _ _ A lam ⟨v, hv, hAv⟩
  have hn : (‖v‖ : ℂ) ≠ 0 := by exact_mod_cast norm_ne_zero_iff.2 hv
  set x : H := ((‖v‖ : ℂ)⁻¹) • v
  have hx : ‖x‖ = 1 := by
    simp only [x, norm_smul, norm_inv, Complex.norm_real, Real.norm_eq_abs, abs_norm]
    exact inv_mul_cancel₀ (norm_ne_zero_iff.2 hv)
  refine ⟨x, hx, ?_⟩
  have hAx : A x = lam • x := by
    simp only [x, map_smul, hAv, smul_comm lam]
  rw [hAx, inner_smul_right, inner_self_of_norm_one hx, mul_one]

/-- Section I.2: `W(A)` is closed. -/
theorem numericalRangeClosed : Targets.numericalRangeClosed.{u} := by
  intro H _ _ _ A
  have hset : {z : ℂ | ∃ x : H, ‖x‖ = 1 ∧ z = inner ℂ x (A x)} =
      (fun x : H => inner ℂ x (A x)) '' Metric.sphere (0 : H) 1 := by
    ext z
    simp [eq_comm]
  rw [hset]
  have hA : Continuous A := LinearMap.continuous_of_finiteDimensional A
  haveI : ProperSpace H := FiniteDimensional.proper ℂ H
  exact ((isCompact_sphere 0 1).image (continuous_id.inner hA)).isClosed

end NumStability.Bhatia.Chapter01
