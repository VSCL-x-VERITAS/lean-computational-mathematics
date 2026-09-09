import ComputationalMathematics.Source.LeVeque.Chapter01.RiemannLocalRoutineInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.BiasedLocalRiemannRoutine

open MeasureTheory NumStability NumStability.LocalRiemannInformation
open NumStability.BiasedLocalRiemannRoutine

namespace LocalRoutineApplicability

/-- Literal application of the primary's full second clause, with all local
physical assumptions discharged for a zero field and a nonconsistent routine. -/
noncomputable def actual_two_face_source_application :=
  let contract := (leveque01_localRiemannRoutineInterface_sourceContract law
    ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).2
  contract
    (biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ)))
    0 0 0 proper_states.1 proper_states.1 proper_states.1
    (a := 0) (b := 1) (s := 0) (t := 1) (by norm_num) (by norm_num)
    trivial trivial (fun _ _ => 0)
    (intervalIntegrable_const (hc := by simp)) (intervalIntegrable_const (hc := by simp))
    (by simpa only [law, StationaryRiemannField.physicalFlux] using
      (intervalIntegrable_const (hc := by simp) : IntervalIntegrable (fun _ : ℝ => (0 : Fin 1 → ℝ)) volume 0 1))
    (by simpa only [law, StationaryRiemannField.physicalFlux] using
      (intervalIntegrable_const (hc := by simp) : IntervalIntegrable (fun _ : ℝ => (0 : Fin 1 → ℝ)) volume 0 1))
    (by simp [law, StationaryRiemannField.physicalFlux])

theorem actual_reference_and_nonconsistency :
    (∃ physicalReference : Reference equalProblem,
      ‖(biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).flux equalProblem trivial -
        physicalReference.meanFlux‖ = 1 / 2) ∧
    ¬ (biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).Consistent :=
  ⟨⟨reference equalProblem, equal_state_error⟩, not_consistent⟩

#check actual_two_face_source_application
#print axioms actual_two_face_source_application
#check actual_reference_and_nonconsistency
#print axioms actual_reference_and_nonconsistency

end LocalRoutineApplicability
