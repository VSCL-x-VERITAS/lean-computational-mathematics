/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.PositiveKernel
import ComputationalMathematics.Source.Bhatia.Chapter01.PositiveInvertibleTarget

/-!
# Invertibility and strict positivity

Source correspondence for Bhatia, *Matrix Analysis* (1997), Chapter I.2,
printed page 4 (PDF page 16): a positive operator is strictly positive exactly
when it has a two-sided linear inverse. The statement includes dimension zero.
-/

set_option autoImplicit false

namespace NumStability.Bhatia.Chapter01

/-- The positive-invertible equivalence, with positivity as a hypothesis and
invertibility expressed by an actual two-sided linear inverse. -/
theorem positiveInvertible : Targets.positiveInvertible := by
  intro H _ _ _ A hA
  constructor
  · intro hstrict
    have hinj : Function.Injective A := by
      intro x y hxy
      by_contra hne
      have hzero : A (x - y) = 0 := by
        rw [map_sub, hxy, sub_self]
      have hpos := hstrict (x - y) (sub_ne_zero.mpr hne)
      simpa [hzero] using hpos
    let e := LinearEquiv.ofInjectiveEndo A hinj
    refine ⟨e.symm.toLinearMap, ?_, ?_⟩
    · exact LinearEquiv.ofInjectiveEndo_right_inv A hinj
    · exact LinearEquiv.ofInjectiveEndo_left_inv A hinj
  · rintro ⟨B, _hAB, hBA⟩ x hx
    by_contra hnot
    have hzero : (inner ℂ x (A x)).re = 0 :=
      le_antisymm (le_of_not_gt hnot) (hA.re_inner_nonneg_right x)
    have hAx : A x = 0 :=
      (NumStability.positive_re_inner_eq_zero_iff A hA x).mp hzero
    have hback := congrArg (fun T : H →ₗ[ℂ] H => T x) hBA
    have hxzero : x = 0 := by
      simpa [hAx] using hback.symm
    exact hx hxzero

end NumStability.Bhatia.Chapter01
