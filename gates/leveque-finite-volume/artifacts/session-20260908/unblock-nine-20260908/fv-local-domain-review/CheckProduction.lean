import ComputationalMathematics.Source.LeVeque.Chapter01.FiniteVolumeLocalFluxUpdate
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle
open MeasureTheory NumStability
namespace FVLocalProductionChecks
variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- The earlier global pointwise representative is an admitted special case,
without requiring that representation in the general local theorem. -/
theorem global_pointwise_consumer {m : ℕ} {Cell : Type*}
    {q : ℝ → ℝ → Fin m → ℝ} {flux : (Fin m → ℝ) → Fin m → ℝ}
    (hq : IsRectangleConservationLawSolution q flux)
    (numericalOld : Cell → Fin m → ℝ) (rule : (Cell → Fin m → ℝ) → Bool → Fin m → ℝ)
    (cell : Cell) {a b s t : ℝ} (hab : a < b) (hst : s < t)
    {oldBound leftBound rightBound : ℝ}
    (hold : ‖numericalOld cell - oneDimensionalCellAverage (fun x => q x s) a b‖ ≤ oldBound)
    (hleft : ‖rule numericalOld false - oneDimensionalCellAverage (fun τ => flux (q a τ)) s t‖ ≤ leftBound)
    (hright : ‖rule numericalOld true - oneDimensionalCellAverage (fun τ => flux (q b τ)) s t‖ ≤ rightBound) :
    ‖finiteVolumeCellAverageUpdate (t - s) (b - a) (numericalOld cell)
      (rule numericalOld true - rule numericalOld false) -
      oneDimensionalCellAverage (fun x => q x t) a b‖ ≤
      oldBound + (t - s) / (b - a) * (leftBound + rightBound) := by
  have h := finiteVolumeLocalCell_error_contract (fun x => q x s) (fun x => q x t)
    (fun face τ => if face then flux (q b τ) else flux (q a τ))
    numericalOld rule cell false true hab hst (hq.1 a b s) (hq.1 a b t)
    (hq.2.1 a s t) (hq.2.1 b s t) (hq.2.2 a b s t)
  exact h.2.2.2.2.2.2.2.2 oldBound leftBound rightBound hold hleft hright

/-- This ambient field is constant on the chosen time slab but fails the
global rectangle property after that slab. The local theorem needs no extension law. -/
noncomputable def lateJump (_x τ : ℝ) : ℝ := if τ ≤ 1 then 0 else 1

theorem lateJump_not_global :
    ¬ IsRectangleConservationLawSolution lateJump (fun _ => (0 : ℝ)) := by
  intro h
  have balance := h.2.2 0 1 1 2
  norm_num [lateJump, intervalIntegral.integral_const] at balance
  change (1 : ℝ) = (1 : ℝ) * (0 : ℝ) at balance
  norm_num at balance

/-- A genuine nonzero numerical error is controlled on [0,1] × [0,1],
even though the supplied ambient density does not satisfy global conservation. -/
theorem local_nonzero_error_consumer :
    ‖finiteVolumeCellAverageUpdate (1 : ℝ) 1 (0 : ℝ) (1 - 0) -
      oneDimensionalCellAverage (fun x => lateJump x 1) 0 1‖ ≤ 1 := by
  have h := finiteVolumeLocalCell_error_contract
    (fun x => lateJump x 0) (fun x => lateJump x 1) (fun (_ : Bool) (_ : ℝ) => (0 : ℝ))
    (fun (_ : Unit) => (0 : ℝ)) (fun _ face => if face then (1 : ℝ) else 0)
    () false true (a := 0) (b := 1) (s := 0) (t := 1) (by norm_num) (by norm_num)
    (by simp [lateJump])
    (by simp [lateJump])
    intervalIntegrable_const intervalIntegrable_const (by simp [lateJump])
  have bound := h.2.2.2.2.2.2.2.2 0 0 1
    (by norm_num [oneDimensionalCellAverage, lateJump])
    (by norm_num [oneDimensionalCellAverage])
    (by norm_num [oneDimensionalCellAverage])
  simpa using bound

theorem local_nonzero_error_value :
    ‖finiteVolumeCellAverageUpdate (1 : ℝ) 1 (0 : ℝ) (1 - 0) -
      oneDimensionalCellAverage (fun x => lateJump x 1) 0 1‖ = 1 := by
  norm_num [finiteVolumeCellAverageUpdate, oneDimensionalCellAverage, lateJump]

/-- Density representatives and temporal flux representatives matter only
up to their respective interval measures. No spatial representative is forced
to determine the separately supplied physical face history. -/
theorem interval_average_congr_ae {u v : ℝ → E} {a b : ℝ} (hab : a < b)
    (h : u =ᵐ[volume.restrict (Set.Ioc a b)] v) :
    oneDimensionalCellAverage u a b = oneDimensionalCellAverage v a b := by
  rw [← cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage _ hab,
    ← cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage _ hab]
  exact cellVolumeAverage_congr_ae volume _ h

end FVLocalProductionChecks

#check @NumStability.norm_le_of_weighted_error_balance
#print axioms NumStability.norm_le_of_weighted_error_balance
#check @NumStability.finiteVolumeLocalCell_error_contract
#print axioms NumStability.finiteVolumeLocalCell_error_contract
#check @NumStability.leveque01_finiteVolumeLocalFluxUpdate_sourceContract
#print axioms NumStability.leveque01_finiteVolumeLocalFluxUpdate_sourceContract
#check @FVLocalProductionChecks.global_pointwise_consumer
#print axioms FVLocalProductionChecks.global_pointwise_consumer
#check @FVLocalProductionChecks.lateJump_not_global
#print axioms FVLocalProductionChecks.lateJump_not_global
#check @FVLocalProductionChecks.local_nonzero_error_consumer
#print axioms FVLocalProductionChecks.local_nonzero_error_consumer
#check @FVLocalProductionChecks.local_nonzero_error_value
#print axioms FVLocalProductionChecks.local_nonzero_error_value
#check @FVLocalProductionChecks.interval_average_congr_ae
#print axioms FVLocalProductionChecks.interval_average_congr_ae
