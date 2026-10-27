/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainEntropy
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersFiniteChain
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersSelectedEntropy

/-!
# Positive-time entropy inequality of the constructed Burgers chain

The individual entropy and entropy-flux traces are integrable. Ordered
noninteraction transports their inequalities to the actual finite field
under the nonstrict cone CFL. The initial-time entropy face remains separate.
-/

open MeasureTheory
namespace NumStability

theorem leveque04_burgersSelectedField_entropy_space_integrable
    (left right reference a b time : ℝ) :
    IntervalIntegrable (fun x => |leveque04_burgersSelectedField left right x time - reference|)
      volume a b := by
  exact (((leveque04_burgersSelectedField_isRectangleSolution left right).1 a b time).sub
    (intervalIntegrable_const (c := reference))).abs

theorem leveque04_burgersSelectedField_entropy_flux_integrable_positive
    (left right reference x s t : ℝ) (hs : 0 < s) (ht : 0 < t) :
    IntervalIntegrable (fun τ => burgersKruzkovFlux reference
      (leveque04_burgersSelectedField left right x τ)) volume s t := by
  by_cases horder : left ≤ right
  · apply (leveque04_burgersRarefactionForward_entropy_flux_integrable
      left right reference x s t hs ht).congr
    intro τ hτ
    have hτpos : 0 < τ := (lt_min hs ht).trans_le (Set.uIoc_subset_uIcc hτ).1
    simp only [leveque04_burgersSelectedField, if_pos horder,
      leveque04_burgersRarefactionGlobalCandidate_positive left right x τ hτpos]
  · have heq : (fun τ => burgersKruzkovFlux reference
        (leveque04_burgersSelectedField left right x τ)) =
        (fun τ => travelingWave
          (riemannData (burgersKruzkovFlux reference left) (burgersKruzkovFlux reference right)
            (burgersKruzkovFlux reference right)) ((left + right) / 2) x τ) := by
      funext τ
      simp only [leveque04_burgersSelectedField, if_neg horder, travelingWave, riemannData]
      split_ifs <;> rfl
    rw [heq]
    exact travelingWave_intervalIntegrable_time _ (riemannData_intervalIntegrable _ _ _)
      ((left + right) / 2) x s t

theorem leveque04_burgersFiniteChain_entropy_rectangle_positive
    (states : ℕ → ℝ) (count : ℕ) (width bound horizon reference a b s t : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hstates : ∀ j ≤ count, -bound ≤ states j ∧ states j ≤ bound)
    (hcfl : 2 * bound * horizon ≤ width)
    (hab : a ≤ b) (hs : 0 < s) (hst : s ≤ t) (ht : t ≤ horizon) :
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
    have hforward : τ ∈ Set.Icc 0 horizon := ⟨hs.le.trans hτ.1, hτ.2.trans ht⟩
    apply isOrderedFiniteRiemannChain_of_uniform_cones _ _ count width bound horizon x τ
      hwidth hbound hforward hcfl
    · intro j hj hx
      funext p
      exact leveque04_burgersSelectedField_left_of_cone
        (states j) (states (j + 1)) bound (x - (j : ℝ) * width) τ
        (hstates j (by omega)) (hstates (j + 1) (by omega)) hforward.1 (by linarith)
    · intro j hj hx
      funext p
      exact leveque04_burgersSelectedField_right_of_closed_cone
        (states j) (states (j + 1)) bound (x - (j : ℝ) * width) τ
        (hstates j (by omega)) (hstates (j + 1) (by omega)) hforward.1 (by linarith)
  · intro j _ τ _
    have h := leveque04_burgersSelectedField_entropy_space_integrable
      (states j) (states (j + 1)) reference (a - (j : ℝ) * width) (b - (j : ℝ) * width) τ
    simpa only [sub_add_cancel] using h.comp_sub_right ((j : ℝ) * width)
  · intro j _ x _
    exact leveque04_burgersSelectedField_entropy_flux_integrable_positive
      (states j) (states (j + 1)) reference (x - (j : ℝ) * width) s t hs (hs.trans_le hst)
  · intro j _
    change (∫ x in a..b, |leveque04_burgersSelectedField (states j) (states (j + 1))
      (x - (j : ℝ) * width) t - reference|) -
      (∫ x in a..b, |leveque04_burgersSelectedField (states j) (states (j + 1))
        (x - (j : ℝ) * width) s - reference|) ≤ _
    rw [intervalIntegral.integral_comp_sub_right
      (f := fun y => |leveque04_burgersSelectedField (states j) (states (j + 1)) y t - reference|),
      intervalIntegral.integral_comp_sub_right
      (f := fun y => |leveque04_burgersSelectedField (states j) (states (j + 1)) y s - reference|)]
    exact leveque04_burgersSelectedField_entropy_rectangle_positive
      (states j) (states (j + 1)) reference (a - (j : ℝ) * width) (b - (j : ℝ) * width)
      s t (by linarith) hs hst

end NumStability
