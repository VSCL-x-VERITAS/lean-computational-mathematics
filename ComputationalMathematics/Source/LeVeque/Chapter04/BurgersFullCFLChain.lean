/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFullCFLGeometry
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainAffineFronts

/-!
# Actual finite Burgers chains under the full characteristic CFL

The existing finite sum of actual selected Riemann fields has ordered asymmetric
wave supports under `bound * horizon ≤ width`. Its nonlinear flux telescopes
pointwise, including touching right-representative shocks. Conservation holds
on the closed forward time window; no global evolution beyond it is claimed.
-/

namespace NumStability

/-- The actual finite profiles are ordered throughout the full characteristic
CFL window. No bound on twice the characteristic speed is imposed. -/
theorem leveque04_burgersFiniteChain_ordered_fullCFL
    (states : ℕ → ℝ) (count : ℕ) (width bound horizon x time : ℝ)
    (_hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hstates : ∀ j ≤ count, |states j| ≤ bound)
    (hcfl : bound * horizon ≤ width) (htime : time ∈ Set.Icc 0 horizon) :
    IsOrderedFiniteRiemannChain (fun j (_ : Fin 1) => states j)
      (fun j (_ : Fin 1) => leveque04_burgersSelectedField
        (states j) (states (j + 1)) (x - (j : ℝ) * width) time) count := by
  let leftEdge := fun j : ℕ => (j : ℝ) * width +
    leveque04_burgersLeftWaveSpeed (states j) (states (j + 1)) * time
  let rightEdge := fun j : ℕ => (j : ℝ) * width +
    leveque04_burgersRightWaveSpeed (states j) (states (j + 1)) * time
  have hinterval : ∀ j < count, leftEdge j ≤ rightEdge j := by
    intro j _
    have h := mul_le_mul_of_nonneg_right
      (leveque04_burgers_waveSpeeds_ordered (states j) (states (j + 1))) htime.1
    dsimp only [leftEdge, rightEdge]
    linarith
  have hadjacent : ∀ j, j + 1 < count → rightEdge j ≤ leftEdge (j + 1) := by
    intro j hj
    have hspread := leveque04_burgers_adjacentWaveSpread_le
      (states j) (states (j + 1)) (states (j + 1 + 1)) bound
      (hstates j (by omega)) (hstates (j + 1) (by omega))
      (hstates (j + 1 + 1) (by omega))
    have hscaled := mul_le_mul_of_nonneg_right hspread htime.1
    have htimebound := mul_le_mul_of_nonneg_left htime.2 hbound
    dsimp only [leftEdge, rightEdge]
    push_cast
    nlinarith
  apply isOrderedFiniteRiemannChain_of_separated_intervals
    (fun j (_ : Fin 1) => states j)
    (fun j (_ : Fin 1) => leveque04_burgersSelectedField
      (states j) (states (j + 1)) (x - (j : ℝ) * width) time)
    leftEdge rightEdge count x hinterval
    (finite_intervals_pairwise_separated_of_adjacent leftEdge rightEdge count hinterval hadjacent)
  · intro j _ hx
    funext p
    exact leveque04_burgersSelectedField_left_of_waveSpeed _ _ _ _ htime.1 (by
      dsimp only [leftEdge] at hx
      linarith)
  · intro j _ hx
    funext p
    exact leveque04_burgersSelectedField_right_of_waveSpeed _ _ _ _ htime.1 (by
      dsimp only [rightEdge] at hx
      linarith)

/-- Every nonlinear map, in particular the actual physical flux, telescopes
along this actual chain. This is a range identity, not global additivity. -/
theorem leveque04_burgersFiniteChain_map_fullCFL
    {E : Type*} [AddCommGroup E] (map : (Fin 1 → ℝ) → E)
    (states : ℕ → ℝ) (count : ℕ) (width bound horizon x time : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hstates : ∀ j ≤ count, |states j| ≤ bound)
    (hcfl : bound * horizon ≤ width) (htime : time ∈ Set.Icc 0 horizon) :
    map (leveque04_burgersFiniteChain states count width x time) =
      finiteRiemannChainAssembly (fun j => map (fun _ : Fin 1 => states j))
        (fun j => map (fun _ : Fin 1 => leveque04_burgersSelectedField
          (states j) (states (j + 1)) (x - (j : ℝ) * width) time)) count := by
  have hp := leveque04_burgersFiniteChain_ordered_fullCFL states count width bound horizon x time
    hwidth hbound hstates hcfl htime
  rcases hp with ⟨k, hk, hbefore, hafter⟩ | ⟨k, hk, hbefore, hafter⟩
  · exact finiteRiemannChainAssembly_map_eq_of_state map _ _ count k hk hbefore hafter
  · exact finiteRiemannChainAssembly_map_eq_of_profile map _ _ count k hk hbefore hafter

/-- Actual local rectangle conservation under the full characteristic CFL,
including the terminal equality time and zero state bound. -/
theorem leveque04_burgersFiniteChain_rectangleReferenceOn_fullCFL
    (states : ℕ → ℝ) (count : ℕ) (left right width bound horizon : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hhorizon : 0 ≤ horizon)
    (hstates : ∀ j ≤ count, |states j| ≤ bound) (hcfl : bound * horizon ≤ width) :
    LocalConservationLaw.RectangleReferenceOn
      (leveque04_burgersFiniteChain states count width)
      (fun state (_ : Fin 1) => (state 0) ^ 2 / 2) left right horizon := by
  apply finiteRiemannChain_rectangleReferenceOn_of_ordered_profiles
    (fun j (_ : Fin 1) => states j)
    (fun j x t (_ : Fin 1) => leveque04_burgersSelectedField
      (states j) (states (j + 1)) (x - (j : ℝ) * width) t)
    count (fun state (_ : Fin 1) => (state 0) ^ 2 / 2) left right horizon hhorizon
  · intro j _
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
  · intro x _ time htime
    exact leveque04_burgersFiniteChain_ordered_fullCFL states count width bound horizon x time
      hwidth hbound hstates hcfl htime

/-- Each fixed original interface sees precisely its own actual Riemann
field through the closed full-CFL window. -/
theorem leveque04_burgersFiniteChain_face_profile_fullCFL
    (states : ℕ → ℝ) (count face : ℕ) (width bound horizon time : ℝ)
    (hface : face < count) (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hstates : ∀ j ≤ count, |states j| ≤ bound)
    (hcfl : bound * horizon ≤ width) (htime : time ∈ Set.Icc 0 horizon) :
    leveque04_burgersFiniteChain states count width ((face : ℝ) * width) time =
      (fun _ : Fin 1 => leveque04_burgersSelectedField (states face) (states (face + 1)) 0 time) := by
  have htimebound : bound * time ≤ width :=
    (mul_le_mul_of_nonneg_left htime.2 hbound).trans hcfl
  have hselected := finiteRiemannChainAssembly_eq_profile
    (fun j (_ : Fin 1) => states j)
    (fun j (_ : Fin 1) => leveque04_burgersSelectedField (states j) (states (j + 1))
      ((face : ℝ) * width - (j : ℝ) * width) time) count face hface
  have hbefore : ∀ j < face,
      (fun _ : Fin 1 => leveque04_burgersSelectedField (states j) (states (j + 1))
        ((face : ℝ) * width - (j : ℝ) * width) time) = (fun _ => states (j + 1)) := by
    intro j hj
    have hcast : (j : ℝ) + 1 ≤ (face : ℝ) := by exact_mod_cast Nat.succ_le_iff.mpr hj
    have hgap := mul_le_mul_of_nonneg_right hcast hwidth.le
    funext p
    exact leveque04_burgersSelectedField_right_of_closed_cone _ _ bound _ time
      (abs_le.mp (hstates j (by omega))) (abs_le.mp (hstates (j + 1) (by omega)))
      htime.1 (by nlinarith)
  have hafter : ∀ j, face < j → j < count →
      (fun _ : Fin 1 => leveque04_burgersSelectedField (states j) (states (j + 1))
        ((face : ℝ) * width - (j : ℝ) * width) time) = (fun _ => states j) := by
    intro j hj hjcount
    have hcast : (face : ℝ) + 1 ≤ (j : ℝ) := by exact_mod_cast Nat.succ_le_iff.mpr hj
    have hgap := mul_le_mul_of_nonneg_right hcast hwidth.le
    funext p
    by_cases ht0 : time = 0
    · subst time
      rw [leveque04_burgersSelectedField_initial]
      have hx : (face : ℝ) * width - (j : ℝ) * width < 0 := by nlinarith
      simp [riemannData, hx]
    · exact leveque04_burgersSelectedField_left_of_closed_characteristic_cone _ _ bound _ time
        (abs_le.mp (hstates j (by omega))) (abs_le.mp (hstates (j + 1) (by omega)))
        (lt_of_le_of_ne htime.1 (Ne.symm ht0)) (by nlinarith)
  simpa only [leveque04_burgersFiniteChain, sub_self] using hselected hbefore hafter

end NumStability
