/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Normed.Lp.lpSpace

/-!
# The pointwise centered stencil on actual bilateral real ℓ² data

The value is the literal centered coordinate function, with its square-summability
proved from reindexing the actual exponent-two summation. This module imports no
project continuous-linear-map or general project reindex construction.
-/

namespace NumStability

/-- Translating integer coordinates preserves actual square summability. -/
theorem memLp2_integerTranslate (shift : ℤ) (u : lp (fun _ : ℤ => ℝ) 2) :
    Memℓp (fun i : ℤ => u (i + shift)) 2 := by
  let e : ℤ ≃ ℤ :=
    { toFun := fun i => i + shift
      invFun := fun i => i - shift
      left_inv := fun i => by simp
      right_inv := fun i => by simp }
  apply memℓp_gen
  have hp : 0 < (2 : ENNReal).toReal := by norm_num
  exact (e.summable_iff (f := fun j => ‖u j‖ ^ (2 : ENNReal).toReal)).mpr
    ((lp.memℓp u).summable hp)

/-- The actual centered coordinate formula belongs to the same ℓ² space. -/
theorem memLp2_centeredCoordinate (courant : ℝ) (u : lp (fun _ : ℤ => ℝ) 2) :
    Memℓp (fun i : ℤ => u i - courant / 2 * (u (i + 1) - u (i - 1))) 2 := by
  have hforward := memLp2_integerTranslate 1 u
  have hbackward := memLp2_integerTranslate (-1) u
  have h := (lp.memℓp u).sub ((hforward.sub hbackward).const_smul (courant / 2))
  simpa only [Pi.sub_apply, Pi.smul_apply, smul_eq_mul, sub_eq_add_neg] using h

/-- A centered step as a literal square-summable coordinate function. -/
noncomputable def centeredPointwiseL2Step (courant : ℝ) (u : lp (fun _ : ℤ => ℝ) 2) :
    lp (fun _ : ℤ => ℝ) 2 :=
  ⟨fun i => u i - courant / 2 * (u (i + 1) - u (i - 1)),
    memLp2_centeredCoordinate courant u⟩

@[simp] theorem centeredPointwiseL2Step_apply
    (courant : ℝ) (u : lp (fun _ : ℤ => ℝ) 2) (i : ℤ) :
    centeredPointwiseL2Step courant u i =
      u i - courant / 2 * (u (i + 1) - u (i - 1)) := rfl

end NumStability
