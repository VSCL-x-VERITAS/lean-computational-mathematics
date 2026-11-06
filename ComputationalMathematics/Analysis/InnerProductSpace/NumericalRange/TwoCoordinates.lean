/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.BlochSphere
import ComputationalMathematics.Analysis.Convex.SphereImages
import Mathlib.LinearAlgebra.Complex.FiniteDimensional
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
import Mathlib.Tactic.Ring

/-!
# Convexity of a complex quadratic range in two coordinates

The full unit-pair range of an arbitrary complex two-by-two quadratic form is
an affine image of the Bloch sphere. Its real-linear part maps real Euclidean
three-space to the complex plane and therefore has a nonzero kernel. Its sphere
image equals its closed-ball image, proving convexity without a convexity premise.
-/

set_option autoImplicit false

namespace NumStability

private noncomputable def blochLinear (a b c d : ℂ) :
    EuclideanSpace ℝ (Fin 3) →ₗ[ℝ] ℂ :=
  (EuclideanSpace.projₗ (0 : Fin 3)).smulRight ((b + c) / 2) +
    (EuclideanSpace.projₗ (1 : Fin 3)).smulRight (Complex.I * (b - c) / 2) +
    (EuclideanSpace.projₗ (2 : Fin 3)).smulRight ((a - d) / 2)

set_option backward.isDefEq.respectTransparency false in
private theorem quadratic_eq_bloch (a b c d α β : ℂ)
    (hunit : Complex.normSq α + Complex.normSq β = 1) :
    star α * (a * α + b * β) + star β * (c * α + d * β) =
      (a + d) / 2 + blochLinear a b c d (blochVector α β) := by
  have h : star α * (a * α + b * β) + star β * (c * α + d * β) =
      ((Complex.normSq α + Complex.normSq β : ℝ) : ℂ) * ((a + d) / 2) +
        blochLinear a b c d (blochVector α β) := by
    apply Complex.ext <;>
      simp [blochLinear, blochVector, LinearMap.smulRight_apply,
        Complex.normSq_apply, Complex.mul_re, Complex.mul_im,
        Complex.smul_re, Complex.smul_im, smul_eq_mul] <;>
      ring
  simpa only [hunit, Complex.ofReal_one, one_mul] using h

set_option backward.isDefEq.respectTransparency false in
/-- The actual complex quadratic range of a two-by-two form on all unit pairs
is real convex; none of the four coefficients is restricted. -/
theorem convex_two_coordinate_quadratic_range (a b c d : ℂ) :
    Convex ℝ {z : ℂ | ∃ α β : ℂ,
      Complex.normSq α + Complex.normSq β = 1 ∧
        z = star α * (a * α + b * β) + star β * (c * α + d * β)} := by
  let f := blochLinear a b c d
  have hker : f.ker ≠ ⊥ := LinearMap.ker_ne_bot_of_finrank_lt (by
    rw [finrank_euclideanSpace_fin, Complex.finrank_real_complex]
    norm_num)
  obtain ⟨k, hkm, hk⟩ := f.ker.ne_bot_iff.mp hker
  have hconv : Convex ℝ (f '' Metric.sphere 0 1) :=
    convex_linearMap_image_sphere f ⟨k, hk, LinearMap.mem_ker.mp hkm⟩ 1 zero_le_one
  have hset : {z : ℂ | ∃ α β : ℂ,
      Complex.normSq α + Complex.normSq β = 1 ∧
        z = star α * (a * α + b * β) + star β * (c * α + d * β)} =
      (fun z : ℂ => (a + d) / 2 + z) '' (f '' Metric.sphere 0 1) := by
    ext z
    constructor
    · rintro ⟨α, β, hunit, rfl⟩
      refine ⟨f (blochVector α β), ?_, ?_⟩
      · refine ⟨blochVector α β, ?_, rfl⟩
        simpa only [Metric.mem_sphere, dist_zero_right] using norm_blochVector_eq_one α β hunit
      · exact (quadratic_eq_bloch a b c d α β hunit).symm
    · rintro ⟨w, ⟨r, hr, rfl⟩, rfl⟩
      have hr' : ‖r‖ = 1 := by simpa only [Metric.mem_sphere, dist_zero_right] using hr
      obtain ⟨α, β, hunit, hb⟩ := exists_unit_pair_blochVector r hr'
      refine ⟨α, β, hunit, ?_⟩
      rw [quadratic_eq_bloch a b c d α β hunit, hb]
  rw [hset]
  exact hconv.translate ((a + d) / 2)

end NumStability
