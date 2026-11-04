/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFullCFLFiniteGridREA

/-!
# Entropy rectangles on the full characteristic-CFL Burgers window

The actual finite sum inherits every reference-state entropy rectangle from
its selected pair fields. This is a constructed finite-time property under
`bound * horizon ≤ width`, not entropy uniqueness or post-horizon evolution.
-/

open MeasureTheory
namespace NumStability

/-- The actual constructed finite shock/fan evolution satisfies every
reference-state entropy inequality on the entire forward step, including
the initial entropy face, under the full characteristic CFL. -/
theorem leveque04_burgersFiniteChain_entropy_rectangle_fullCFL
    (states : ℕ → ℝ) (count : ℕ) (width bound horizon reference a b s t : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hstates : ∀ j ≤ count, |states j| ≤ bound)
    (hcfl : bound * horizon ≤ width)
    (hab : a ≤ b) (hs : 0 ≤ s) (hst : s ≤ t) (ht : t ≤ horizon) :
    (∫ x in a..b, |leveque04_burgersFiniteChain states count width x t 0 - reference|) -
      (∫ x in a..b, |leveque04_burgersFiniteChain states count width x s 0 - reference|) ≤
        ∫ τ in s..t,
          burgersKruzkovFlux reference (leveque04_burgersFiniteChain states count width a τ 0) -
          burgersKruzkovFlux reference (leveque04_burgersFiniteChain states count width b τ 0) := by
  apply finiteRiemannChain_entropy_rectangle_of_ordered_profiles
    (fun (j : ℕ) (_ : Fin 1) => states j)
    (fun j (x τ : ℝ) (_ : Fin 1) => leveque04_burgersSelectedField
      (states j) (states (j + 1)) (x - (j : ℝ) * width) τ) count
    (fun u => |u 0 - reference|) (fun u => burgersKruzkovFlux reference (u 0))
    a b s t hab hst
  · intro x _ τ hτ
    have hforward : τ ∈ Set.Icc 0 horizon := ⟨hs.trans hτ.1, hτ.2.trans ht⟩
    exact leveque04_burgersFiniteChain_ordered_fullCFL states count width bound horizon x τ
      hwidth hbound hstates hcfl hforward
  · intro j _ τ _
    have h := leveque04_burgersSelectedField_entropy_space_integrable
      (states j) (states (j + 1)) reference (a - (j : ℝ) * width) (b - (j : ℝ) * width) τ
    simpa only [sub_add_cancel] using h.comp_sub_right ((j : ℝ) * width)
  · intro j _ x _
    exact leveque04_burgersSelectedField_entropy_flux_integrable_forward
      (states j) (states (j + 1)) reference (x - (j : ℝ) * width) s t hs (hs.trans hst)
  · intro j _
    change (∫ x in a..b, |leveque04_burgersSelectedField (states j) (states (j + 1))
      (x - (j : ℝ) * width) t - reference|) -
      (∫ x in a..b, |leveque04_burgersSelectedField (states j) (states (j + 1))
        (x - (j : ℝ) * width) s - reference|) ≤ _
    rw [intervalIntegral.integral_comp_sub_right
      (f := fun y => |leveque04_burgersSelectedField (states j) (states (j + 1)) y t - reference|),
      intervalIntegral.integral_comp_sub_right
      (f := fun y => |leveque04_burgersSelectedField (states j) (states (j + 1)) y s - reference|)]
    exact leveque04_burgersSelectedField_entropy_rectangle_forward
      (states j) (states (j + 1)) reference (a - (j : ℝ) * width) (b - (j : ℝ) * width)
      s t (by linarith) hs hst


/-- The same actual entropy rectangle inequality for supplied finite ghost arrays. -/
theorem leveque04_burgersFiniteGridREA_entropy_rectangle_fullCFL
    {N : ℕ} (old : Fin (N + 2) → ℝ)
    (origin width bound duration reference a b s t : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hstates : ∀ j, |old j| ≤ bound) (hcfl : bound * duration ≤ width)
    (hab : a ≤ b) (hs : 0 ≤ s) (hst : s ≤ t) (ht : t ≤ duration) :
    (∫ x in a..b,
      |leveque04_burgersFiniteGridREA old origin width x t 0 - reference|) -
      (∫ x in a..b,
        |leveque04_burgersFiniteGridREA old origin width x s 0 - reference|) ≤
      ∫ time in s..t,
        burgersKruzkovFlux reference (leveque04_burgersFiniteGridREA old origin width a time 0) -
          burgersKruzkovFlux reference (leveque04_burgersFiniteGridREA old origin width b time 0) := by
  let states : ℕ → ℝ := fun j => old ⟨min j (N + 1), by omega⟩
  have h := leveque04_burgersFiniteChain_entropy_rectangle_fullCFL
    states (N + 1) width bound duration reference
    (a - origin) (b - origin) s t hwidth hbound
    (fun j _ => hstates _) hcfl (by linarith) hs hst ht
  change (∫ x in a..b,
      |leveque04_burgersFiniteChain states (N + 1) width (x - origin) t 0 - reference|) -
      (∫ x in a..b,
        |leveque04_burgersFiniteChain states (N + 1) width (x - origin) s 0 - reference|) ≤
      ∫ time in s..t,
        burgersKruzkovFlux reference
            (leveque04_burgersFiniteChain states (N + 1) width (a - origin) time 0) -
          burgersKruzkovFlux reference
            (leveque04_burgersFiniteChain states (N + 1) width (b - origin) time 0)
  rw [intervalIntegral.integral_comp_sub_right
      (f := fun x => |leveque04_burgersFiniteChain states (N + 1)
        width x t 0 - reference|),
    intervalIntegral.integral_comp_sub_right
      (f := fun x => |leveque04_burgersFiniteChain states (N + 1)
        width x s 0 - reference|)]
  exact h

end NumStability
