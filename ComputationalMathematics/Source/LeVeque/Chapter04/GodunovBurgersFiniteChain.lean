/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainGeometry
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RectangleTranslation
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersForwardTrace

/-!
# Constructed noninteracting finite Burgers shock/fan evolution

The nonstrict cone CFL gives local conservation of the actual constructed
field and its prescribed initial trace. Entropy uniqueness and the complete
source-row scope remain separate obligations.
-/

open Filter
open scoped Topology
namespace NumStability

/-- Closed right cone for the selected right representative. -/
theorem leveque04_burgersSelectedField_right_of_closed_cone
    (left right bound x t : ℝ)
    (hl : -bound ≤ left ∧ left ≤ bound) (hr : -bound ≤ right ∧ right ≤ bound)
    (ht : 0 ≤ t) (hx : bound * t ≤ x) :
    leveque04_burgersSelectedField left right x t = right := by
  by_cases ht0 : t = 0
  · subst t
    rw [leveque04_burgersSelectedField_initial]
    simp [riemannData, show ¬ x < 0 by simpa using not_lt.mpr hx]
  have htpos : 0 < t := lt_of_le_of_ne ht (Ne.symm ht0)
  by_cases horder : left ≤ right
  · simp only [leveque04_burgersSelectedField, if_pos horder,
      leveque04_burgersRarefactionGlobalCandidate, if_neg (not_le_of_gt htpos)]
    exact leveque04_burgersRarefactionForward_rightRegion left right x t horder htpos
      ((mul_le_mul_of_nonneg_right hr.2 ht).trans hx)
  · have hspeed : (left + right) / 2 ≤ bound := by linarith [hl.2, hr.2]
    have hright : 0 ≤ x - (left + right) / 2 * t := by
      have h := mul_le_mul_of_nonneg_right hspeed ht
      linarith
    simp [leveque04_burgersSelectedField, horder, travelingWave, riemannData,
      not_lt.mpr hright]

/-- An actual finite family of the selected Burgers shocks and fans,
translated to uniform mesh interfaces. -/
noncomputable def leveque04_burgersFiniteChain
    (states : ℕ → ℝ) (count : ℕ) (width x time : ℝ) : Fin 1 → ℝ :=
  finiteRiemannChainAssembly (fun j _ => states j)
    (fun j _ => leveque04_burgersSelectedField (states j) (states (j + 1))
      (x - (j : ℝ) * width) time) count

/-- The constructed chain has precisely the finite piecewise-constant
Riemann reconstruction at its initial time, including the chosen jump values. -/
theorem leveque04_burgersFiniteChain_initial
    (states : ℕ → ℝ) (count : ℕ) (width x : ℝ) :
    leveque04_burgersFiniteChain states count width x 0 =
      finiteRiemannChainAssembly (fun j _ => states j)
        (fun j _ => riemannData (states j) (states (j + 1)) (states (j + 1))
          (x - (j : ℝ) * width)) count := by
  simp only [leveque04_burgersFiniteChain, leveque04_burgersSelectedField_initial]

/-- Noninteraction CFL constructs a local conserving scalar nonlinear
evolution directly from the selected shock/fan solver. -/
theorem leveque04_burgersFiniteChain_rectangleReferenceOn
    (states : ℕ → ℝ) (count : ℕ) (left right width bound horizon : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hhorizon : 0 ≤ horizon)
    (hstates : ∀ j ≤ count, -bound ≤ states j ∧ states j ≤ bound)
    (hcfl : 2 * bound * horizon ≤ width) :
    LocalConservationLaw.RectangleReferenceOn
      (leveque04_burgersFiniteChain states count width)
      (fun state _ => (state 0) ^ 2 / 2) left right horizon := by
  apply finiteRiemannChain_rectangleReferenceOn_of_uniform_cones
    (fun j _ => states j)
    (fun j x t _ => leveque04_burgersSelectedField (states j) (states (j + 1))
      (x - (j : ℝ) * width) t) count
    (fun state _ => (state 0) ^ 2 / 2) left right width bound horizon
    hwidth hbound hhorizon hcfl
  · intro j hj
    have hscalar := IsRectangleConservationLawSolution.spatialShift _ _
      (leveque04_burgersSelectedField_isRectangleSolution (states j) (states (j + 1)))
      ((j : ℝ) * width)
    have hvector := IsRectangleConservationLawSolution.pi
      (fun (x t : ℝ) (_ : Fin 1) => leveque04_burgersSelectedField (states j) (states (j + 1))
        (x - (j : ℝ) * width) t) (fun _ u => u ^ 2 / 2) (fun _ => hscalar)
    have heq : (fun state : Fin 1 → ℝ => fun p => (state p) ^ 2 / 2) =
        (fun state : Fin 1 → ℝ => fun _ => (state 0) ^ 2 / 2) := by
      funext state p
      fin_cases p
      rfl
    rw [heq] at hvector
    exact IsRectangleConservationLawSolution.rectangleReferenceOn _ _ hvector left right horizon
  · intro j hj x _ t ht hx
    funext p
    exact leveque04_burgersSelectedField_left_of_cone
      (states j) (states (j + 1)) bound (x - (j : ℝ) * width) t
      (hstates j (by omega)) (hstates (j + 1) (by omega)) ht.1 (by linarith)
  · intro j hj x _ t ht hx
    funext p
    exact leveque04_burgersSelectedField_right_of_closed_cone
      (states j) (states (j + 1)) bound (x - (j : ℝ) * width) t
      (hstates j (by omega)) (hstates (j + 1) (by omega)) ht.1 (by linarith)

/-- At a point away from the finitely many initial interfaces, the
constructed field has the prescribed right-hand initial trace. -/
theorem leveque04_burgersFiniteChain_initialTrace
    (states : ℕ → ℝ) (count : ℕ) (width x : ℝ)
    (hx : ∀ j < count, x ≠ (j : ℝ) * width) :
    Tendsto (fun t => leveque04_burgersFiniteChain states count width x t)
      (𝓝[>] (0 : ℝ)) (𝓝 (leveque04_burgersFiniteChain states count width x 0)) := by
  have hterm : ∀ j ∈ Finset.range count,
      Tendsto (fun t => (fun _ : Fin 1 => leveque04_burgersSelectedField
        (states j) (states (j + 1)) (x - (j : ℝ) * width) t) - (fun _ => states j))
        (𝓝[>] (0 : ℝ))
        (𝓝 ((fun _ : Fin 1 => riemannData (states j) (states (j + 1))
          (states (j + 1)) (x - (j : ℝ) * width)) - (fun _ => states j))) := by
    intro j hj
    apply Tendsto.sub _ tendsto_const_nhds
    apply tendsto_pi_nhds.2
    intro p
    exact leveque04_burgersSelectedField_initialTrace (states j) (states (j + 1))
      (x - (j : ℝ) * width) (sub_ne_zero.mpr (hx j (Finset.mem_range.mp hj)))
  have hsum := tendsto_finset_sum (Finset.range count) hterm
  simpa only [leveque04_burgersFiniteChain, finiteRiemannChainAssembly,
    leveque04_burgersSelectedField_initial] using tendsto_const_nhds.add hsum

end NumStability
