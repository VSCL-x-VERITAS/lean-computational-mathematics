/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersSelectedSolver
import ComputationalMathematics.Analysis.Calculus.SquaredPositivePart

/-!
# Actual interface flux of the selected Burgers solver

The exact physical time average samples one constant zero-ray state
throughout positive time. This includes transonic fans and stationary shocks.
-/

namespace NumStability

/-- Positive-time zero-ray state of the selected Burgers solver.
A stationary shock uses its chosen right representative. -/
noncomputable def leveque04_burgersSelectedInterfaceState (left right : ℝ) : ℝ :=
  if left ≤ right then leveque04_burgersRarefactionProfile left right 0
  else if 0 < (left + right) / 2 then left else right

theorem leveque04_burgersSelectedField_interface
    (left right t : ℝ) (htime : 0 < t) :
    leveque04_burgersSelectedField left right 0 t =
      leveque04_burgersSelectedInterfaceState left right := by
  by_cases horder : left ≤ right
  · simp only [leveque04_burgersSelectedField, if_pos horder,
      leveque04_burgersRarefactionGlobalCandidate_positive left right 0 t htime,
      leveque04_burgersRarefactionForward, zero_div,
      leveque04_burgersSelectedInterfaceState]
  · simp only [leveque04_burgersSelectedField, if_neg horder,
      leveque04_burgersSelectedInterfaceState, travelingWave, zero_sub]
    by_cases hs : 0 < (left + right) / 2
    · have hloc : -((left + right) / 2 * t) < 0 := neg_neg_of_pos (mul_pos hs htime)
      simp [riemannData, hs, hloc]
    · have hloc : ¬ -((left + right) / 2 * t) < 0 := by
        have hprod : (left + right) / 2 * t ≤ 0 :=
          mul_nonpos_of_nonpos_of_nonneg (le_of_not_gt hs) htime.le
        linarith
      simp [riemannData, hs, hloc]

/-- Evaluate the actual method's physical time average at its constant
positive-time zero-ray trace. -/
theorem leveque04_burgersSelectedFlux_eq_interface
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (hburgers : ∀ u : ℝ, law.physicalFlux (fun _ : Fin 1 => u) 0 = u ^ 2 / 2)
    (problem : HyperbolicRiemannProblem law)
    (timeStep : ℝ) (htime : 0 < timeStep) :
    let method := leveque04_burgersSelectedFluxMethod law hburgers timeStep htime
    method.numericalFluxFromInformation (method.extractInformation (method.solve problem trivial)) =
      law.physicalFlux (fun _ : Fin 1 =>
        leveque04_burgersSelectedInterfaceState (problem.leftState 0) (problem.rightState 0)) := by
  dsimp only
  rw [leveque04_burgersSelectedFlux_eq_timeAverage]
  apply oneDimensionalCellAverage_flux_of_constantTrace law
    (fun (x τ : ℝ) (_ : Fin 1) => leveque04_burgersSelectedField
      (problem.leftState 0) (problem.rightState 0) x τ) _ timeStep htime
  intro τ hτ
  have hτpositive : 0 < τ := by
    simpa only [min_eq_left htime.le] using hτ.1
  funext i
  exact leveque04_burgersSelectedField_interface
    (problem.leftState 0) (problem.rightState 0) τ hτpositive

/-- The scalar numerical flux is half the square of the actual
zero-ray state, for every shock and rarefaction pair. -/
theorem leveque04_burgersSelectedFlux_scalar
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (hburgers : ∀ u : ℝ, law.physicalFlux (fun _ : Fin 1 => u) 0 = u ^ 2 / 2)
    (problem : HyperbolicRiemannProblem law)
    (timeStep : ℝ) (htime : 0 < timeStep) :
    let method := leveque04_burgersSelectedFluxMethod law hburgers timeStep htime
    (method.numericalFluxFromInformation (method.extractInformation (method.solve problem trivial))) 0 =
      (leveque04_burgersSelectedInterfaceState (problem.leftState 0) (problem.rightState 0)) ^ 2 / 2 := by
  dsimp only
  rw [leveque04_burgersSelectedFlux_eq_interface]
  exact hburgers _

/-- The actual Burgers zero-ray flux has the monotone two-state form:
the larger of the outgoing positive-left and negative-right fluxes. -/
theorem leveque04_burgersSelectedInterfaceFlux_eq_max (left right : ℝ) :
    (leveque04_burgersSelectedInterfaceState left right) ^ 2 / 2 =
      max ((max 0 left) ^ 2 / 2) ((min 0 right) ^ 2 / 2) := by
  by_cases horder : left ≤ right
  · simp only [leveque04_burgersSelectedInterfaceState, if_pos horder]
    by_cases hl : 0 ≤ left
    · have hr := hl.trans horder
      rw [leveque04_burgersRarefactionProfile_left left right 0 horder hl,
        max_eq_right hl, min_eq_left hr]
      simp [max_eq_left (by positivity : (0 : ℝ) ≤ left ^ 2 / 2)]
    · by_cases hr : right ≤ 0
      · rw [leveque04_burgersRarefactionProfile_right left right 0 horder hr,
          max_eq_left (horder.trans hr), min_eq_right hr]
        simp [max_eq_right (by positivity : (0 : ℝ) ≤ right ^ 2 / 2)]
      · rw [leveque04_burgersRarefactionProfile_interior left right 0
          (le_of_not_ge hl) (le_of_not_ge hr),
          max_eq_left (le_of_not_ge hl), min_eq_left (le_of_not_ge hr)]
        simp
  · have hdesc : right ≤ left := le_of_not_ge horder
    simp only [leveque04_burgersSelectedInterfaceState, if_neg horder]
    by_cases hs : 0 < (left + right) / 2
    · rw [if_pos hs]
      have hl : 0 ≤ left := by linarith
      rw [max_eq_right hl]
      by_cases hr : 0 ≤ right
      · rw [min_eq_left hr]
        simp [max_eq_left (by positivity : (0 : ℝ) ≤ left ^ 2 / 2)]
      · rw [min_eq_right (le_of_not_ge hr), max_eq_left]
        have hprod : 0 ≤ (left - right) * (left + right) :=
          mul_nonneg (sub_nonneg.mpr hdesc) (by linarith)
        nlinarith
    · rw [if_neg hs]
      have hr : right ≤ 0 := by linarith
      rw [min_eq_right hr]
      by_cases hl : left ≤ 0
      · rw [max_eq_left hl]
        simp [max_eq_right (by positivity : (0 : ℝ) ≤ right ^ 2 / 2)]
      · rw [max_eq_right (le_of_not_ge hl), max_eq_right]
        have hprod : (left - right) * (left + right) ≤ 0 :=
          mul_nonpos_of_nonneg_of_nonpos (sub_nonneg.mpr hdesc) (by linarith)
        nlinarith

/-- Increasing the left state cannot decrease the actual scalar flux. -/
theorem leveque04_burgersSelectedInterfaceFlux_monotone_left
    (a b right : ℝ) (hab : a ≤ b) :
    (leveque04_burgersSelectedInterfaceState a right) ^ 2 / 2 ≤
      (leveque04_burgersSelectedInterfaceState b right) ^ 2 / 2 := by
  rw [leveque04_burgersSelectedInterfaceFlux_eq_max,
    leveque04_burgersSelectedInterfaceFlux_eq_max]
  gcongr

/-- Increasing the right state cannot increase the actual scalar flux. -/
theorem leveque04_burgersSelectedInterfaceFlux_antitone_right
    (left a b : ℝ) (hab : a ≤ b) :
    (leveque04_burgersSelectedInterfaceState left b) ^ 2 / 2 ≤
      (leveque04_burgersSelectedInterfaceState left a) ^ 2 / 2 := by
  rw [leveque04_burgersSelectedInterfaceFlux_eq_max,
    leveque04_burgersSelectedInterfaceFlux_eq_max]
  apply max_le_max le_rfl
  have hmin : min 0 a ≤ min 0 b := min_le_min_left 0 hab
  have hsum : min 0 a + min 0 b ≤ 0 :=
    add_nonpos (min_le_left _ _) (min_le_left _ _)
  have hprod : 0 ≤ (min 0 b - min 0 a) * (-(min 0 a + min 0 b)) :=
    mul_nonneg (sub_nonneg.mpr hmin) (neg_nonneg.mpr hsum)
  nlinarith

/-- On bounded left states, the actual numerical flux has left-state
Lipschitz constant equal to the nonnegative state bound. -/
theorem leveque04_burgersSelectedInterfaceFlux_left_lipschitz
    (bound a b right : ℝ) (hbound : 0 ≤ bound) (ha : a ≤ bound) (hb : b ≤ bound) :
    |(leveque04_burgersSelectedInterfaceState a right) ^ 2 / 2 -
      (leveque04_burgersSelectedInterfaceState b right) ^ 2 / 2| ≤ bound * |a - b| := by
  rw [leveque04_burgersSelectedInterfaceFlux_eq_max,
    leveque04_burgersSelectedInterfaceFlux_eq_max]
  exact (abs_max_sub_max_le_abs _ _ _).trans
    (abs_sq_max_zero_div_two_sub_le bound a b hbound ha hb)

/-- On right states bounded below, the actual numerical flux has
right-state Lipschitz constant equal to the nonnegative state bound. -/
theorem leveque04_burgersSelectedInterfaceFlux_right_lipschitz
    (bound left a b : ℝ) (hbound : 0 ≤ bound) (ha : -bound ≤ a) (hb : -bound ≤ b) :
    |(leveque04_burgersSelectedInterfaceState left a) ^ 2 / 2 -
      (leveque04_burgersSelectedInterfaceState left b) ^ 2 / 2| ≤ bound * |a - b| := by
  have hrepr (z : ℝ) : (min 0 z) ^ 2 / 2 = (max 0 (-z)) ^ 2 / 2 := by
    have h := max_neg_neg (0 : ℝ) z
    simp only [neg_zero] at h
    rw [h, neg_sq]
  rw [leveque04_burgersSelectedInterfaceFlux_eq_max,
    leveque04_burgersSelectedInterfaceFlux_eq_max, hrepr, hrepr,
    max_comm ((max 0 left) ^ 2 / 2), max_comm ((max 0 left) ^ 2 / 2)]
  have h := abs_sq_max_zero_div_two_sub_le bound (-a) (-b) hbound
    (by linarith) (by linarith)
  simp only [neg_sub_neg, abs_sub_comm b a] at h
  exact (abs_max_sub_max_le_abs _ _ _).trans h

end NumStability
