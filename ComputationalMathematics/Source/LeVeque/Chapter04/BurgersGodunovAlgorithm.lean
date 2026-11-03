/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersGodunovAlgorithmTarget
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersOleinikBound

/-!
# The all-state Burgers Godunov construction

The existing selected pair fields, physical fluxes and finite conservative
recipe satisfy the frozen source target. The assembled physical field uses
the stated characteristic-state CFL, including equality and zero bound.
-/

noncomputable section

open Set MeasureTheory Filter
open scoped Topology BigOperators

namespace NumStability

private theorem burgersFiniteGrid_test_integrable
    {N : ℕ} (old : Fin (N + 2) → ℝ) (origin width : ℝ)
    (test : ℝ × ℝ → ℝ) (htest : ContDiff ℝ 1 test)
    (hsupport : HasCompactSupport test) :
    Integrable (fun z : ℝ × ℝ =>
      leveque04_burgersFiniteGridREA old origin width z.1 z.2 0 *
          forwardTestDerivative test (0, 1) z +
        (leveque04_burgersFiniteGridREA old origin width z.1 z.2 0 ^ 2 / 2) *
          forwardTestDerivative test (1, 0) z) ∧
    Integrable (fun x => leveque04_burgersFiniteGridREA old origin width x 0 0 *
      test (x, 0)) := by
  classical
  let states : ℕ → ℝ := fun j => old ⟨min j (N + 1), by omega⟩
  let q : ℝ × ℝ → ℝ := fun z => leveque04_burgersFiniteGridREA old origin width z.1 z.2 0
  let piece : ℕ → ℝ × ℝ → ℝ := fun j z => leveque04_burgersSelectedField
    (states j) (states (j + 1)) (z.1 - origin - (j : ℝ) * width) z.2
  have hpiece (j : ℕ) : Measurable (piece j) :=
    (leveque04_burgersSelectedField_measurable _ _).comp
      (((measurable_fst.sub_const origin).sub_const ((j : ℝ) * width)).prodMk measurable_snd)
  have hqeq (z : ℝ × ℝ) :
      q z = states 0 + ∑ j ∈ Finset.range (N + 1), (piece j z - states j) := by
    simp only [q, leveque04_burgersFiniteGridREA, leveque04_burgersFiniteChain,
      finiteRiemannChainAssembly, Pi.add_apply, Pi.sub_apply, Finset.sum_apply]
    rfl
  have hq : Measurable q := by
    rw [show q = (fun z => states 0 +
      ∑ j ∈ Finset.range (N + 1), (piece j z - states j)) from funext hqeq]
    exact measurable_const.add ((Finset.range (N + 1)).measurable_sum
      (fun j _ => (hpiece j).sub_const (states j)))
  let bound := |states 0| + ∑ j ∈ Finset.range (N + 1),
    (max |states j| |states (j + 1)| + |states j|)
  have hbound (z : ℝ × ℝ) : |q z| ≤ bound := by
    rw [hqeq]
    calc
      _ ≤ |states 0| + |∑ j ∈ Finset.range (N + 1), (piece j z - states j)| := abs_add_le _ _
      _ ≤ |states 0| + ∑ j ∈ Finset.range (N + 1), |piece j z - states j| :=
        add_le_add le_rfl (Finset.abs_sum_le_sum_abs _ _)
      _ ≤ bound := by
        apply add_le_add le_rfl (Finset.sum_le_sum (fun j _ => ?_))
        have hsub : |piece j z - states j| ≤ |piece j z| + |states j| := by
          simpa only [Real.norm_eq_abs] using norm_sub_le (piece j z) (states j)
        exact hsub.trans (add_le_add
          (leveque04_burgersSelectedField_abs_le_max _ _ _ _) le_rfl)
  have hfluxbound (z : ℝ × ℝ) : |q z ^ 2 / 2| ≤ bound ^ 2 / 2 := by
    rw [abs_of_nonneg (div_nonneg (sq_nonneg _) (by norm_num))]
    have hu := abs_le.mp (hbound z)
    have hp := mul_nonneg (show 0 ≤ bound + q z by linarith)
      (show 0 ≤ bound - q z by linarith)
    nlinarith
  have hs := globalTest_forward_hasCompactSupport test hsupport
  exact ⟨(forwardTestDerivative_mul_integrable q hq bound hbound test htest.contDiffOn hs
    (0, 1)).add (forwardTestDerivative_mul_integrable (fun z => q z ^ 2 / 2)
      ((hq.pow_const 2).div_const 2) (bound ^ 2 / 2) hfluxbound test htest.contDiffOn hs (1, 0)),
    travelingWave_weakTest_initial_integrable _
      (hq.comp (measurable_id.prodMk measurable_const)) bound (fun x => hbound (x, 0))
      test htest.continuous hsupport⟩

/-- The exact frozen all-state construction, with the unconditional recipe
and the separately conditional full characteristic-CFL physical realization. -/
theorem leveque04_burgersGodunovAlgorithm : Leveque04BurgersGodunovAlgorithmTarget := by
  refine ⟨?_, ?_, leveque04_burgersOleinikBound, leveque04_burgersPhysicalFluctuations, ?_, ?_⟩
  · have hderiv (state : ℝ) : HasDerivAt (fun q : ℝ => q ^ 2 / 2) state state := by
      convert ((hasDerivAt_id state).pow 2).div_const 2 using 1
      norm_num
    intro state
    refine ⟨hderiv state, ?_⟩
    have heq : deriv (fun q : ℝ => q ^ 2 / 2) = fun q => q :=
      funext (fun q => (hderiv q).deriv)
    rw [heq]
    exact hasDerivAt_id state
  · intro left right
    refine ⟨leveque04_burgersSelectedField_initial left right, ?_, ?_, ?_,
      leveque04_burgersSelectedField_measurable left right, ?_, ?_,
      leveque04_burgersSelectedField_initialTrace left right,
      leveque04_burgersSelectedField_localL1_initialTrace left right, ?_, ?_⟩
    · intro x time htime
      by_cases horder : left ≤ right
      · simp only [leveque04_burgersSelectedField, if_pos horder,
          leveque04_burgersRarefactionGlobalCandidate_positive left right x time htime,
          leveque04_burgersRarefactionForward, leveque04_burgersRarefactionProfile]
      · simp only [leveque04_burgersSelectedField, if_neg horder, travelingWave,
          riemannData, ite_self, sub_neg]
    · rintro rfl x time _
      exact leveque04_burgersSelectedField_constant left x time
    · intro hshock
      exact ⟨by linarith, by linarith, by ring⟩
    · intro x time _
      exact leveque04_burgersSelectedField_abs_le_max left right x time
    · intro time a b _
      exact ⟨leveque04_burgersSelectedField_intervalIntegrable_space left right time a b,
        leveque04_burgersSelectedField_integrableOn_Icc left right time a b,
        leveque04_burgersSelectedField_initialError_integrableOn_Icc left right time a b⟩
    · intro test htest hsupport
      have h := leveque04_burgersSelectedField_weakTest_spacetime left right test htest.contDiffOn
        (globalTest_forward_hasCompactSupport test hsupport)
      exact ⟨h.1, h.2.1, leveque04_burgersSelectedField_weakTest left right test htest.contDiffOn
        (globalTest_forward_hasCompactSupport test hsupport)⟩
    · have hspeed : 0 < (left + right) / 2 ↔ 0 < left + right := by
        constructor <;> intro h <;> linarith
      simp only [leveque04_burgersSelectedInterfaceState, leveque04_burgersRarefactionProfile,
        hspeed]
  · intro N _hN old origin width duration hwidth hduration
    refine ⟨?_, ?_, leveque04_burgersFiniteGridStep_totalMass_balance duration width old hwidth, ?_⟩
    · intro face
      exact ⟨fun _ _ => rfl,
        leveque04_burgersFiniteGridField_initial old origin width face,
        leveque04_burgersFiniteGridField_zeroRay old origin width face, rfl,
        leveque04_burgersFiniteGridFlux_timeAverage old origin width duration hduration face⟩
    · intro cell
      exact ⟨leveque04_burgersFiniteGrid_cell_width origin width cell,
        leveque04_burgersFiniteGridStep_eq_fluxDifference duration width old cell,
        leveque04_burgersFiniteGridStep_eq_physicalFluctuationUpdate
          duration width hduration hwidth old cell⟩
    · intro hboundary
      rw [leveque04_burgersFiniteGridStep_totalMass_balance duration width old hwidth,
        hboundary, sub_self, mul_zero, sub_zero]
  · intro N hN old origin width bound duration hwidth hbound hduration hstates hcfl
    refine ⟨leveque04_burgersFiniteGridREA_initialMean old origin width hwidth, ?_,
      leveque04_burgersFiniteGridREA_faceFluxAverage_fullCFL old origin width bound duration
        hwidth hbound hduration hstates hcfl,
      leveque04_burgersFiniteGridREA_terminalMean_fullCFL hN old origin width bound duration
        hwidth hbound hduration hstates hcfl,
      leveque04_burgersFiniteGridREA_scalarMean_on_interval_fullCFL hN old origin width bound duration
        hwidth hbound hduration hstates hcfl, ?_, ?_, ?_⟩
    · intro face time htime
      exact leveque04_burgersFiniteGridREA_face_profile_fullCFL old origin width bound duration time
        hwidth hbound hstates hcfl htime face
    · intro a b
      exact leveque04_burgersFiniteGridREA_rectangleReferenceOn_fullCFL old origin width bound
        duration a b hwidth hbound hduration.le hstates hcfl
    · intro reference a b s t hab hs hst ht
      exact leveque04_burgersFiniteGridREA_entropy_rectangle_fullCFL old origin width bound duration
        reference a b s t hwidth hbound hstates hcfl hab hs hst ht
    · intro test htest hsupport hslab
      obtain ⟨hspace, hinitial⟩ := burgersFiniteGrid_test_integrable old origin width test htest hsupport
      exact ⟨hspace, hinitial,
        leveque04_burgersFiniteGridREA_weakTest_fullCFL old origin width bound duration
          hwidth hbound hduration.le hstates hcfl test htest hsupport hslab⟩

end NumStability
