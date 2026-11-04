/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteGridREA
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFullCFLChain

/-!
# Physical finite-grid means under the full characteristic Burgers CFL

The actual existing finite-sum selected field now has rectangle conservation,
physical face averages and exact finite-recipe cell means under
`bound * duration ≤ width`, including contact and zero bound. The array has
supplied nonperiodic ghost states. No callback or outcome premise is added.
A bound on only active shock-front speeds is a separate source-scope question;
no global evolution past this forward window or entropy uniqueness is asserted.
-/

open MeasureTheory Filter
open scoped Topology

namespace NumStability

private def fullCFLGridStates {N : ℕ} (old : Fin (N + 2) → ℝ) (j : ℕ) : ℝ :=
  old ⟨min j (N + 1), by omega⟩

private theorem fullCFLGridStates_eq {N : ℕ} (old : Fin (N + 2) → ℝ)
    (j : ℕ) (hj : j < N + 2) :
    fullCFLGridStates old j = old ⟨j, hj⟩ := by
  simp only [fullCFLGridStates, min_eq_left (show j ≤ N + 1 by omega)]

/-- The actual translated finite field satisfies local rectangle conservation
through the full characteristic-CFL duration, including its terminal face. -/
theorem leveque04_burgersFiniteGridREA_rectangleReferenceOn_fullCFL
    {N : ℕ} (old : Fin (N + 2) → ℝ) (origin width bound duration left right : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hduration : 0 ≤ duration)
    (hstates : ∀ j, |old j| ≤ bound) (hcfl : bound * duration ≤ width) :
    LocalConservationLaw.RectangleReferenceOn
      (leveque04_burgersFiniteGridREA old origin width)
      (fun state (_ : Fin 1) => (state 0) ^ 2 / 2) left right duration := by
  have hq := leveque04_burgersFiniteChain_rectangleReferenceOn_fullCFL
    (fullCFLGridStates old) (N + 1) (left - origin) (right - origin)
    width bound duration hwidth hbound hduration
    (fun j _ => hstates _) hcfl
  refine ⟨?_, ?_, ?_⟩
  · intro time ht
    simpa only [leveque04_burgersFiniteGridREA, sub_add_cancel] using
      (hq.1 time ht).comp_sub_right origin
  · intro x hx
    exact hq.2.1 (x - origin) ⟨by linarith [hx.1], by linarith [hx.2]⟩
  · intro a ha b hb s hs t ht
    change (∫ x in a..b,
        leveque04_burgersFiniteChain (fullCFLGridStates old) (N + 1) width (x - origin) t) -
      (∫ x in a..b,
        leveque04_burgersFiniteChain (fullCFLGridStates old) (N + 1) width (x - origin) s) = _
    rw [intervalIntegral.integral_comp_sub_right
        (f := fun x => leveque04_burgersFiniteChain (fullCFLGridStates old) (N + 1) width x t)
        (d := origin),
      intervalIntegral.integral_comp_sub_right
        (f := fun x => leveque04_burgersFiniteChain (fullCFLGridStates old) (N + 1) width x s)
        (d := origin)]
    exact hq.2.2 (a - origin) ⟨by linarith [ha.1], by linarith [ha.2]⟩
      (b - origin) ⟨by linarith [hb.1], by linarith [hb.2]⟩ s hs t ht

/-- Every physical mesh face selects its own actual Riemann profile at all
times in the closed full characteristic-CFL interval. No division by the bound is used. -/
theorem leveque04_burgersFiniteGridREA_face_profile_fullCFL
    {N : ℕ} (old : Fin (N + 2) → ℝ) (origin width bound duration time : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hstates : ∀ j, |old j| ≤ bound) (hcfl : bound * duration ≤ width)
    (htime : time ∈ Set.Icc 0 duration) (face : Fin (N + 1)) :
    leveque04_burgersFiniteGridREA old origin width
        (leveque04_uniformInterface origin width (face.val : ℤ)) time =
      (fun _ : Fin 1 => leveque04_burgersSelectedField
        (old face.castSucc) (old face.succ) 0 time) := by
  let states := fullCFLGridStates old
  have hface := leveque04_burgersFiniteChain_face_profile_fullCFL
    states (N + 1) face.val width bound duration time face.isLt hwidth hbound
    (fun j _ => hstates _) hcfl htime
  have hleft : states face.val = old face.castSucc :=
    fullCFLGridStates_eq old _ (by omega)
  have hright : states (face.val + 1) = old face.succ :=
    fullCFLGridStates_eq old _ (by omega)
  simpa only [leveque04_burgersFiniteGridREA, leveque04_burgersFiniteChain,
    leveque04_uniformInterface, Int.cast_natCast, add_sub_cancel_left, sub_self,
    hleft, hright] using hface

/-- The actual field's time-averaged physical face flux is exactly the
compiled finite recipe flux, through the terminal full-CFL equality. -/
theorem leveque04_burgersFiniteGridREA_faceFluxAverage_fullCFL
    {N : ℕ} (old : Fin (N + 2) → ℝ) (origin width bound duration : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hduration : 0 < duration)
    (hstates : ∀ j, |old j| ≤ bound) (hcfl : bound * duration ≤ width)
    (face : Fin (N + 1)) :
    oneDimensionalCellAverage
      (fun time (_ : Fin 1) =>
        (leveque04_burgersFiniteGridREA old origin width
          (leveque04_uniformInterface origin width (face.val : ℤ)) time 0) ^ 2 / 2)
      0 duration = (fun _ : Fin 1 => leveque04_burgersFiniteGridFlux old face) := by
  apply (oneDimensionalCellAverage_congr_ae ?_).trans
    (oneDimensionalCellAverage_const _ 0 duration hduration.ne)
  filter_upwards [ae_restrict_mem measurableSet_uIoc] with time ht
  have htime : 0 < time ∧ time ≤ duration := by
    simpa only [Set.uIoc_of_le hduration.le, Set.mem_Ioc] using ht
  rw [leveque04_burgersFiniteGridREA_face_profile_fullCFL old origin width bound duration time
    hwidth hbound hstates hcfl ⟨htime.1.le, htime.2⟩ face]
  funext p
  rw [leveque04_burgersSelectedField_interface _ _ time htime.1]
  rfl

/-- The actual terminal vector cell mean is the finite recipe update for
every supplied-ghost array under the inclusive full characteristic-CFL hypothesis. -/
-- Preserve the source hypotheses and the existing public interface.
@[nolint unusedArguments]
theorem leveque04_burgersFiniteGridREA_terminalMean_fullCFL
    {N : ℕ} (_hN : 1 ≤ N) (old : Fin (N + 2) → ℝ)
    (origin width bound duration : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hduration : 0 < duration)
    (hstates : ∀ j, |old j| ≤ bound) (hcfl : bound * duration ≤ width)
    (cell : Fin N) :
    oneDimensionalCellAverage
      (fun x => leveque04_burgersFiniteGridREA old origin width x duration)
      (leveque04_uniformInterface origin width (cell.castSucc.val : ℤ))
      (leveque04_uniformInterface origin width (cell.succ.val : ℤ)) =
        (fun _ : Fin 1 => leveque04_burgersFiniteGridStep duration width old cell) := by
  let a := leveque04_uniformInterface origin width (cell.castSucc.val : ℤ)
  let b := leveque04_uniformInterface origin width (cell.succ.val : ℤ)
  let q := leveque04_burgersFiniteGridREA old origin width
  let flux : (Fin 1 → ℝ) → Fin 1 → ℝ := fun state _ => (state 0) ^ 2 / 2
  have hlength : b - a = width := leveque04_burgersFiniteGrid_cell_width origin width cell
  have hab : a < b := by linarith
  have hq := leveque04_burgersFiniteGridREA_rectangleReferenceOn_fullCFL old origin width bound
    duration a b hwidth hbound hduration.le hstates hcfl
  have hinitial := leveque04_burgersFiniteGridREA_initialMean old origin width hwidth cell
  have hstep := rectangleReferenceOn_cellAverage_step_of_initial q flux
    (fun _ : Fin 1 => old cell.castSucc.succ) a b duration a b hq
    ⟨le_refl _, hab.le⟩ ⟨hab.le, le_refl _⟩ hab hduration hinitial
  rw [hlength] at hstep
  have hleft := leveque04_burgersFiniteGridREA_faceFluxAverage_fullCFL old origin width bound duration
    hwidth hbound hduration hstates hcfl cell.castSucc
  have hright := leveque04_burgersFiniteGridREA_faceFluxAverage_fullCFL old origin width bound duration
    hwidth hbound hduration hstates hcfl cell.succ
  change oneDimensionalCellAverage (fun time => flux (q a time)) 0 duration = _ at hleft
  change oneDimensionalCellAverage (fun time => flux (q b time)) 0 duration = _ at hright
  rw [hleft, hright] at hstep
  exact hstep.trans (by
    funext p
    simp only [Pi.sub_apply, Pi.smul_apply, smul_eq_mul,
      leveque04_burgersFiniteGridStep_eq_fluxDifference])

/-- The physical scalar cell mean at the terminal time is the actual finite
recipe value. The integrability needed for coordinate averaging is proved. -/
theorem leveque04_burgersFiniteGridREA_scalarMean_fullCFL
    {N : ℕ} (hN : 1 ≤ N) (old : Fin (N + 2) → ℝ)
    (origin width bound duration : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hduration : 0 < duration)
    (hstates : ∀ j, |old j| ≤ bound) (hcfl : bound * duration ≤ width)
    (cell : Fin N) :
    oneDimensionalCellAverage
      (fun x => leveque04_burgersFiniteGridREA old origin width x duration 0)
      (leveque04_uniformInterface origin width (cell.castSucc.val : ℤ))
      (leveque04_uniformInterface origin width (cell.succ.val : ℤ)) =
        leveque04_burgersFiniteGridStep duration width old cell := by
  have hq := leveque04_burgersFiniteGridREA_rectangleReferenceOn_fullCFL old origin width bound duration
    (leveque04_uniformInterface origin width (cell.castSucc.val : ℤ))
    (leveque04_uniformInterface origin width (cell.succ.val : ℤ))
    hwidth hbound hduration.le hstates hcfl
  rw [← oneDimensionalCellAverage_apply _ _ _ (hq.1 duration ⟨hduration.le, le_rfl⟩) 0,
    leveque04_burgersFiniteGridREA_terminalMean_fullCFL hN old origin width bound duration
      hwidth hbound hduration hstates hcfl cell]

/-- The same scalar mean identity holds on the entire closed interval,
including its initial face. This is a separate consequence of the terminal result. -/
theorem leveque04_burgersFiniteGridREA_scalarMean_on_interval_fullCFL
    {N : ℕ} (hN : 1 ≤ N) (old : Fin (N + 2) → ℝ)
    (origin width bound duration : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hduration : 0 < duration)
    (hstates : ∀ j, |old j| ≤ bound) (hcfl : bound * duration ≤ width)
    (time : ℝ) (htime : time ∈ Set.Icc 0 duration) (cell : Fin N) :
    oneDimensionalCellAverage
      (fun x => leveque04_burgersFiniteGridREA old origin width x time 0)
      (leveque04_uniformInterface origin width (cell.castSucc.val : ℤ))
      (leveque04_uniformInterface origin width (cell.succ.val : ℤ)) =
        leveque04_burgersFiniteGridStep time width old cell := by
  by_cases ht0 : time = 0
  · subst time
    have hq := leveque04_burgersFiniteGridREA_rectangleReferenceOn_fullCFL old origin width bound duration
      (leveque04_uniformInterface origin width (cell.castSucc.val : ℤ))
      (leveque04_uniformInterface origin width (cell.succ.val : ℤ))
      hwidth hbound hduration.le hstates hcfl
    rw [← oneDimensionalCellAverage_apply _ _ _ (hq.1 0 ⟨le_rfl, hduration.le⟩) 0,
      leveque04_burgersFiniteGridREA_initialMean old origin width hwidth cell]
    simp [leveque04_burgersFiniteGridStep_eq_fluxDifference]
  · have htpos : 0 < time := lt_of_le_of_ne htime.1 (Ne.symm ht0)
    apply leveque04_burgersFiniteGridREA_scalarMean_fullCFL hN old origin width bound time
      hwidth hbound htpos hstates
    nlinarith [mul_le_mul_of_nonneg_left htime.2 hbound]

end NumStability
