import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CertifiedRiemannRoutineUpdate
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.BiasedCertifiedRiemannRoutine
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRiemannRoutineAccuracy
import ComputationalMathematics.Source.LeVeque.Chapter01.RiemannCertifiedRoutineInterface
set_option pp.maxSteps 10000000
set_option pp.deepTerms true
set_option pp.proofs false
set_option pp.universes false
set_option maxRecDepth 10000
set_option maxHeartbeats 1600000

open MeasureTheory

namespace NumStability.CertifiedRiemannRoutineDraft
open LocalRiemannInformation BiasedLocalRiemannRoutine

def leftProblem : Problem law :=
  ⟨0, 1, proper_states.1, proper_states.2.1, 1 - 0, by norm_num⟩

def rightProblem : Problem law :=
  ⟨1, 0, proper_states.2.1, proper_states.1, 1 - 0, by norm_num⟩

theorem both_problems_nonconstant :
    leftProblem.left ≠ leftProblem.right ∧ rightProblem.left ≠ rightProblem.right := by
  constructor
  · intro h
    have hzero := congrFun h (0 : Fin 1)
    norm_num [leftProblem] at hzero
  · intro h
    have hzero := congrFun h (0 : Fin 1)
    norm_num [rightProblem] at hzero

/-- The entire new primary applied to the same certified, biased routine on
neighbor states 0,1,0. All actual cell and time-slab physical assumptions are
discharged for a constant unit density and its physical unit transport flux. -/
noncomputable def actual_two_face_source_application :=
  leveque01_certifiedRiemannRoutineInterface_sourceContract law
    (biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ)))
    (fun _ => 1 / 2) certified_nonconsistent.1
    0 1 0 proper_states.1 proper_states.2.1 proper_states.1
    (a := 0) (b := 1) (s := 0) (t := 1) (by norm_num) (by norm_num)
    trivial trivial (fun _ _ => 1)
    (intervalIntegrable_const (hc := by simp)) (intervalIntegrable_const (hc := by simp))
    (by simpa only [law, StationaryRiemannField.physicalFlux] using
      (intervalIntegrable_const (hc := by simp) : IntervalIntegrable (fun _ : ℝ => (1 : Fin 1 → ℝ)) volume 0 1))
    (by simpa only [law, StationaryRiemannField.physicalFlux] using
      (intervalIntegrable_const (hc := by simp) : IntervalIntegrable (fun _ : ℝ => (1 : Fin 1 → ℝ)) volume 0 1))
    (by simp [law, StationaryRiemannField.physicalFlux])

/-- Both actual face problems have physical references with the same nonzero
certified numerical error, for the routine used in the full source application. -/
theorem both_actual_reference_errors :
    ‖(biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).flux leftProblem trivial -
      (reference leftProblem).meanFlux‖ = 1 / 2 ∧
    ‖(biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).flux rightProblem trivial -
      (reference rightProblem).meanFlux‖ = 1 / 2 := by
  constructor <;> rw [actual_error, norm_smul] <;> norm_num

/-- The example's actual update error is nonzero; the certified Riemann
comparison is not being demonstrated only in a zero-error update. -/
theorem actual_update_error :
    ‖finiteVolumeCellAverageUpdate 1 1 (1 : Fin 1 → ℝ)
      ((biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).flux rightProblem trivial -
       (biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).flux leftProblem trivial) -
      oneDimensionalCellAverage (fun _ : ℝ => (1 : Fin 1 → ℝ)) 0 1‖ = 1 := by
  have hdifference :
      (biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).flux rightProblem trivial -
      (biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).flux leftProblem trivial = 1 := by
    ext i
    norm_num [Routine.flux, biasedRoutine, law, StationaryRiemannField.physicalFlux,
      leftProblem, rightProblem]
    rfl
  rw [hdifference]
  have hvalue : finiteVolumeCellAverageUpdate 1 1 (1 : Fin 1 → ℝ) 1 -
      oneDimensionalCellAverage (fun _ : ℝ => (1 : Fin 1 → ℝ)) 0 1 = -(1 : Fin 1 → ℝ) := by
    simp only [finiteVolumeCellAverageUpdate, oneDimensionalCellAverage,
      intervalIntegral.integral_const]
    ext i
    norm_num [Pi.sub_apply, Pi.smul_apply, Pi.one_apply, Pi.neg_apply]
    change (1 : ℝ) - 1 - 1 * 1 = -1
    norm_num
  rw [hvalue, norm_neg, norm_one]

/-- Extract the jointly certified reference pair from the actual new primary,
rather than combining unrelated inhabitants of its ingredient types. -/
theorem references_from_actual_primary :
    ∃ (leftReference : Reference leftProblem) (rightReference : Reference rightProblem),
      IsRiemannData (fun x => leftReference.field x 0) 0 1 ∧
      IsRiemannData (fun x => rightReference.field x 0) 1 0 ∧
      ‖(biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).flux leftProblem trivial -
        leftReference.meanFlux‖ ≤ 1 / 2 ∧
      ‖(biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).flux rightProblem trivial -
        rightReference.meanFlux‖ ≤ 1 / 2 := by
  rcases actual_two_face_source_application with
    ⟨_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _,
      leftReference, rightReference, hleftInitial, hrightInitial, _, _, _, _, _, _,
      hleftError, hrightError, _⟩
  exact ⟨leftReference, rightReference, hleftInitial, hrightInitial, hleftError, hrightError⟩

end NumStability.CertifiedRiemannRoutineDraft

set_option pp.universes false
set_option pp.fullNames true
set_option pp.explicit true
set_option pp.proofs false
set_option pp.deepTerms true
set_option pp.maxSteps 1000000
set_option maxRecDepth 10000

set_option pp.explicit false
set_option pp.maxSteps 10000000
#check @NumStability.LocalRiemannInformation.Routine.HasRiemannAccuracy
#print NumStability.LocalRiemannInformation.Routine.HasRiemannAccuracy
#print axioms NumStability.LocalRiemannInformation.Routine.HasRiemannAccuracy
#check @NumStability.LocalRiemannInformation.Method.toRoutine_hasRiemannAccuracy
#print axioms NumStability.LocalRiemannInformation.Method.toRoutine_hasRiemannAccuracy
#check @NumStability.LocalRiemannInformation.Routine.HasRiemannAccuracy.reference_comparison
#print axioms NumStability.LocalRiemannInformation.Routine.HasRiemannAccuracy.reference_comparison
#check @NumStability.LocalRiemannInformation.certifiedRoutine_local_interface_contract
#print axioms NumStability.LocalRiemannInformation.certifiedRoutine_local_interface_contract
#check @NumStability.BiasedLocalRiemannRoutine.hasRiemannAccuracy
#print axioms NumStability.BiasedLocalRiemannRoutine.hasRiemannAccuracy
#check @NumStability.BiasedLocalRiemannRoutine.certified_nonconsistent
#print axioms NumStability.BiasedLocalRiemannRoutine.certified_nonconsistent
#check @NumStability.leveque01_certifiedRiemannRoutineInterface_sourceContract
#print axioms NumStability.leveque01_certifiedRiemannRoutineInterface_sourceContract
#check @NumStability.LocalRiemannInformation.Law
#print NumStability.LocalRiemannInformation.Law
#print axioms NumStability.LocalRiemannInformation.Law
#check @NumStability.LocalRiemannInformation.Problem
#print NumStability.LocalRiemannInformation.Problem
#print axioms NumStability.LocalRiemannInformation.Problem
#check @NumStability.LocalRiemannInformation.Reference
#print NumStability.LocalRiemannInformation.Reference
#print axioms NumStability.LocalRiemannInformation.Reference
#check @NumStability.LocalRiemannInformation.Reference.meanFlux
#print NumStability.LocalRiemannInformation.Reference.meanFlux
#print axioms NumStability.LocalRiemannInformation.Reference.meanFlux
#check @NumStability.LocalRiemannInformation.Routine
#print NumStability.LocalRiemannInformation.Routine
#print axioms NumStability.LocalRiemannInformation.Routine
#check @NumStability.LocalRiemannInformation.Routine.flux
#print NumStability.LocalRiemannInformation.Routine.flux
#print axioms NumStability.LocalRiemannInformation.Routine.flux
#check @NumStability.LocalRiemannInformation.Routine.Consistent
#print NumStability.LocalRiemannInformation.Routine.Consistent
#print axioms NumStability.LocalRiemannInformation.Routine.Consistent
#check @NumStability.LocalRiemannInformation.Method
#print NumStability.LocalRiemannInformation.Method
#print axioms NumStability.LocalRiemannInformation.Method
#check @NumStability.LocalRiemannInformation.Method.toRoutine
#print NumStability.LocalRiemannInformation.Method.toRoutine
#print axioms NumStability.LocalRiemannInformation.Method.toRoutine
#check @NumStability.LocalRiemannInformation.biasedRoutine
#print NumStability.LocalRiemannInformation.biasedRoutine
#print axioms NumStability.LocalRiemannInformation.biasedRoutine
#check @NumStability.IsRiemannData
#print NumStability.IsRiemannData
#print axioms NumStability.IsRiemannData
#check @NumStability.riemannData
#print NumStability.riemannData
#print axioms NumStability.riemannData
#check @NumStability.oneDimensionalCellAverage
#print NumStability.oneDimensionalCellAverage
#print axioms NumStability.oneDimensionalCellAverage
#check @NumStability.IsOneDimensionalCellAverage
#print NumStability.IsOneDimensionalCellAverage
#print axioms NumStability.IsOneDimensionalCellAverage
#check @NumStability.cellVolumeAverage
#print NumStability.cellVolumeAverage
#print axioms NumStability.cellVolumeAverage
#check @NumStability.IsCellVolumeAverage
#print NumStability.IsCellVolumeAverage
#print axioms NumStability.IsCellVolumeAverage
#check @NumStability.finiteVolumeCellAverageUpdate
#print NumStability.finiteVolumeCellAverageUpdate
#print axioms NumStability.finiteVolumeCellAverageUpdate
#check @NumStability.BiasedLocalRiemannRoutine.law
#print NumStability.BiasedLocalRiemannRoutine.law
#print axioms NumStability.BiasedLocalRiemannRoutine.law
#check @NumStability.BiasedLocalRiemannRoutine.reference
#print NumStability.BiasedLocalRiemannRoutine.reference
#print axioms NumStability.BiasedLocalRiemannRoutine.reference
#check @NumStability.BiasedLocalRiemannRoutine.equalProblem
#print NumStability.BiasedLocalRiemannRoutine.equalProblem
#print axioms NumStability.BiasedLocalRiemannRoutine.equalProblem
#check @NumStability.StationaryRiemannField.transportLaw
#print NumStability.StationaryRiemannField.transportLaw
#print axioms NumStability.StationaryRiemannField.transportLaw
#check @NumStability.StationaryRiemannField.reference
#print NumStability.StationaryRiemannField.reference
#print axioms NumStability.StationaryRiemannField.reference
#check @NumStability.CertifiedRiemannRoutineDraft.leftProblem
#print axioms NumStability.CertifiedRiemannRoutineDraft.leftProblem
#print NumStability.CertifiedRiemannRoutineDraft.leftProblem
#check @NumStability.CertifiedRiemannRoutineDraft.rightProblem
#print axioms NumStability.CertifiedRiemannRoutineDraft.rightProblem
#print NumStability.CertifiedRiemannRoutineDraft.rightProblem
#check @NumStability.CertifiedRiemannRoutineDraft.both_problems_nonconstant
#print axioms NumStability.CertifiedRiemannRoutineDraft.both_problems_nonconstant
#check @NumStability.CertifiedRiemannRoutineDraft.actual_two_face_source_application
#print axioms NumStability.CertifiedRiemannRoutineDraft.actual_two_face_source_application
#check @NumStability.CertifiedRiemannRoutineDraft.both_actual_reference_errors
#print axioms NumStability.CertifiedRiemannRoutineDraft.both_actual_reference_errors
#check @NumStability.CertifiedRiemannRoutineDraft.actual_update_error
#print axioms NumStability.CertifiedRiemannRoutineDraft.actual_update_error
#check @NumStability.CertifiedRiemannRoutineDraft.references_from_actual_primary
#print axioms NumStability.CertifiedRiemannRoutineDraft.references_from_actual_primary
