/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFullCFLWeakTest

/-!
# Whole-line compact-test weak identity for the supplied-ghost finite field

The actual existing finite-grid field is the spatial translation of the finite
sum already proved weak on the full characteristic-CFL slab. The initial term
uses its actual finite piecewise-constant reconstruction, without imposing a
zero test value on the initial face or a periodic boundary convention.
-/

noncomputable section
open Set MeasureTheory

namespace NumStability

/-- The actual finite supplied-ghost field satisfies the literal whole-line
compact-test weak formula on its full characteristic-CFL forward slab. -/
theorem leveque04_burgersFiniteGridREA_weakTest_fullCFL
    {N : ℕ} (old : Fin (N + 2) → ℝ) (origin width bound horizon : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hhorizon : 0 ≤ horizon)
    (hstates : ∀ j, |old j| ≤ bound) (hcfl : bound * horizon ≤ width)
    (test : ℝ × ℝ → ℝ) (htest : ContDiff ℝ 1 test)
    (hsupport : HasCompactSupport test)
    (hslab : tsupport test ⊆ {z : ℝ × ℝ | z.2 < horizon}) :
    (∫ time in Ici (0 : ℝ), ∫ x,
      leveque04_burgersFiniteGridREA old origin width x time 0 *
          fderiv ℝ test (x, time) (0, 1) +
        (leveque04_burgersFiniteGridREA old origin width x time 0 ^ 2 / 2) *
          fderiv ℝ test (x, time) (1, 0)) +
      (∫ x, leveque04_burgersFiniteGridREA old origin width x 0 0 * test (x, 0)) = 0 := by
  let states : ℕ → ℝ := fun j => old ⟨min j (N + 1), by omega⟩
  let q : ℝ × ℝ → ℝ := fun z => leveque04_burgersFiniteChain states (N + 1) width z.1 z.2 0
  let shifted : ℝ × ℝ → ℝ := fun z => test (z + (origin, 0))
  have hshifted : ContDiff ℝ 1 shifted := htest.comp (contDiff_id.add contDiff_const)
  have hshiftSupport : HasCompactSupport shifted :=
    hsupport.comp_homeomorph (Homeomorph.addRight (origin, (0 : ℝ)))
  have hshiftSlab : tsupport shifted ⊆ {z : ℝ × ℝ | z.2 < horizon} := by
    intro z hz
    have hmem : z + (origin, 0) ∈ tsupport test :=
      tsupport_comp_subset_preimage test (continuous_id.add continuous_const) hz
    simpa only [Prod.snd_add, add_zero, mem_setOf_eq] using hslab hmem
  have hderiv (x t : ℝ) (v : ℝ × ℝ) :
      fderiv ℝ shifted (x, t) v = fderiv ℝ test (x + origin, t) v := by
    simpa only [shifted, Prod.mk_add_mk, add_zero] using
      congrArg (fun f : (ℝ × ℝ) →L[ℝ] ℝ => f v)
        (fderiv_comp_add_right (𝕜 := ℝ) (f := test) (x := (x, t)) (origin, 0))
  have hchain := leveque04_burgersFiniteChain_weakTest_fullCFL states (N + 1) width bound horizon
    hwidth hbound hhorizon (fun j _ => hstates _) hcfl shifted hshifted hshiftSupport hshiftSlab
  have htranslate (time : ℝ) :
      (∫ x, q (x - origin, time) * fderiv ℝ test (x, time) (0, 1) +
        (q (x - origin, time) ^ 2 / 2) * fderiv ℝ test (x, time) (1, 0)) =
      ∫ x, q (x, time) * fderiv ℝ shifted (x, time) (0, 1) +
        (q (x, time) ^ 2 / 2) * fderiv ℝ shifted (x, time) (1, 0) := by
    calc
      _ = ∫ x, q (x + origin - origin, time) * fderiv ℝ test (x + origin, time) (0, 1) +
          (q (x + origin - origin, time) ^ 2 / 2) *
            fderiv ℝ test (x + origin, time) (1, 0) :=
        (integral_add_right_eq_self
          (fun x => q (x - origin, time) * fderiv ℝ test (x, time) (0, 1) +
            (q (x - origin, time) ^ 2 / 2) * fderiv ℝ test (x, time) (1, 0)) origin).symm
      _ = _ := by simp only [add_sub_cancel_right, hderiv]
  have htranslateInitial :
      (∫ x, q (x - origin, 0) * test (x, 0)) = ∫ x, q (x, 0) * shifted (x, 0) := by
    simpa only [shifted, Prod.mk_add_mk, add_zero, add_sub_cancel_right] using
      (integral_add_right_eq_self (fun x => q (x - origin, 0) * test (x, 0)) origin).symm
  change (∫ time in Ici (0 : ℝ), ∫ x,
      q (x - origin, time) * fderiv ℝ test (x, time) (0, 1) +
        (q (x - origin, time) ^ 2 / 2) * fderiv ℝ test (x, time) (1, 0)) +
      (∫ x, q (x - origin, 0) * test (x, 0)) = 0
  simp_rw [htranslate]
  rw [htranslateInitial]
  exact hchain

end NumStability
