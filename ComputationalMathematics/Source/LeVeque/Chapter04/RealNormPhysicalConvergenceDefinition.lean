/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RealNormPhysicalConvergenceDefinitionTarget
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalMeshConvergenceProperties

/-!
# Prescribed convergence qualifications

This proves the frozen catalogue of physical mesh geometry and characterizations
of the distinct prescribed convergence criteria. It does not equate those
criteria or prove convergence of a numerical evolution to a PDE solution.
-/

noncomputable section

namespace NumStability

open Filter MeasureTheory Set
open scoped Topology ENNReal

theorem leveque04_realNormPhysicalConvergenceDefinition :
    leveque04_RealNormPhysicalConvergenceDefinitionTarget := by
  constructor
  · intro E _ _ _ _
    refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_,
      ?_, ?_, ?_, ?_⟩
    · intro A origin dx h
      exact isPhysicalCellMesh_uniform origin dx h
    · intro A dt h
      exact isPhysicalTimeMesh_uniform dt h
    · intro A time dt steps T ht hc
      exact hasPhysicalObservationTime_of_horizon time dt steps T ht hc
    · intro A l time dt steps T ht hc hr
      exact physicalTime_tendsto_of_bracket l time dt steps T ht hc.2 hr
    · intro A origin dx dt h
      exact hasPhysicalReconstructionIndices_uniform origin dx dt h
    · intro A l domain active edge dx dt hr hm index hi
      exact physicalCellWidth_tendsto_zero l domain active edge dx dt hr hm index hi
    · intro A l domain active edge time dx dt spaceCell timeCell hr hm ht hl x t hx ht0
      exact physicalReconstructionIndices_tendsto l domain active edge time dx dt
        spaceCell timeCell hr hm ht hl x t hx ht0
    · intro A domain active edge dx hm a i hi
      exact physicalCellGridMeasure_singleton_pos domain active edge dx hm a i hi
    · intro A origin dx _ a
      exact physicalCellGridMeasure_uniform origin dx a
    · intro A active edge a p hp0 hpinf Q reference
      exact gridErrorENorm_physical_finite active edge a p hp0 hpinf Q reference
    · intro A origin dx _ a p hp0 hpinf Q reference
      exact gridErrorENorm_uniform_finite origin dx a p hp0 hpinf Q reference
    · intro A domain active edge dx hm a Q reference
      exact gridErrorENorm_physical_top domain active edge dx hm a Q reference
    · intro A l domain active edge dx dt time steps Q reference X _ _ representation T
      simp only [HasPhysicalRealNormConvergence, HasPhysicalChosenNormConvergence,
        HasRepresentedGridNormConvergence, norm_tendsto_zero_iff_eventually_lt]
      rfl
    · intro A l p domain active edge dx dt time steps Q q T
      simp only [HasPhysicalPointConvergence, HasGridErrorConvergence, gridErrorENorm,
        numericalAtHorizon, pointReference, ennreal_tendsto_zero_iff]
    · intro A l p domain active edge dx dt time steps Q q T
      simp only [HasPhysicalCellMeanConvergence, HasGridErrorConvergence, gridErrorENorm,
        numericalAtHorizon, cellMeanReference, oneDimensionalCellAverage,
        ennreal_tendsto_zero_iff]
    · intro A l domain active edge dx dt time Q spaceCell timeCell q T
      simp only [HasPhysicalSpaceTimeConvergence, HasSpaceTimeL1Convergence,
        numericalSpaceTimeReconstruction, spaceTimeL1Error, ennreal_tendsto_zero_iff]
      rfl
    · intro A l domain active edge dx dt time Q spaceCell timeCell q
      simp only [HasPhysicalLocalSpaceTimeConvergence, HasLocalSpaceTimeL1Convergence,
        HasSpaceTimeL1Convergence, numericalSpaceTimeReconstruction, spaceTimeL1Error,
        ennreal_tendsto_zero_iff]
      rfl
    · intro A l domain active edge dx dt time Q spaceCell timeCell W T
      simp only [HasPhysicalSolutionSetConvergence, HasSolutionSetL1Convergence,
        solutionSetL1Error, numericalSpaceTimeReconstruction, spaceTimeL1Error,
        ennreal_tendsto_zero_iff, iInf_lt_iff, exists_prop]
      rfl
    · intro A l domain active edge dx dt time Q spaceCell timeCell q T
      simp [HasPhysicalSolutionSetConvergence, HasPhysicalSpaceTimeConvergence,
        HasSolutionSetL1Convergence, HasSpaceTimeL1Convergence, solutionSetL1Error]
    · intro A l domain active edge dx dt time Q spaceCell timeCell T h
      letI : NeBot l := h.1.1
      have he := ennreal_tendsto_zero_iff.mp h.2.2.2.2.2.2 1 zero_lt_one
      obtain ⟨a, ha⟩ := he.exists
      simp [solutionSetL1Error] at ha
    · intro D A dataClass solutions selected l p domain active edge dx dt time steps Q initial T
      rfl
    · intro A l p domain active edge dx dt time steps q T hp hr hm ht hc
      refine ⟨hp, hr, hm, ht, hasPhysicalObservationTime_of_horizon time dt steps T ht hc, ?_⟩
      constructor
      · intro a
        simpa only [numericalAtHorizon, pointReference, hc.2 a, sub_self] using
          (aestronglyMeasurable_zero : AEStronglyMeasurable (fun _ : ℤ => (0 : E))
            (physicalCellGridMeasure active edge a))
      · have hz : (fun a => gridErrorENorm p (physicalCellGridMeasure active edge a)
            (numericalAtHorizon (fun a n i => q (physicalCellCenter edge a i) (time a n)) steps a)
            (pointReference q (physicalCellCenter edge) T a)) = fun _ => 0 := by
          funext a
          simp [numericalAtHorizon, pointReference, gridErrorENorm, hc.2 a]
        rw [hz]
        exact tendsto_const_nhds
  · intro A l domain active edge dx dt time steps T h
    rcases h with ⟨_, hr, hm, _, _, herr⟩
    letI : NeBot l := hr.1
    have hc : ∀ a, gridErrorENorm ∞ (physicalCellGridMeasure active edge a)
        (fun _ => (1 : ℝ)) (fun _ => 0) = 1 := by
      intro a
      rw [gridErrorENorm_physical_top domain active edge dx hm a]
      obtain ⟨i, hi⟩ := hm.2.1 a
      apply le_antisymm
      · exact iSup_le (fun _ => by simp)
      · exact le_iSup_of_le ⟨i, hi⟩ (by simp)
    have ht : Tendsto (fun _ : A => (1 : ℝ≥0∞)) l (𝓝 0) := by
      have he : Tendsto (fun a => gridErrorENorm ∞ (physicalCellGridMeasure active edge a)
          (fun _ => (1 : ℝ)) (fun _ => 0)) l (𝓝 0) := herr.2
      simpa only [hc] using he
    obtain ⟨a, ha⟩ := (ennreal_tendsto_zero_iff.mp ht 1 zero_lt_one).exists
    exact (lt_irrefl (1 : ℝ≥0∞)) ha

end NumStability
