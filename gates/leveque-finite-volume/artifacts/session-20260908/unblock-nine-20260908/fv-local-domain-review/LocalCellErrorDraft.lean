/- Prospective local-domain FV contract. Draft evidence only; no production or audit replacement. -/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle

open MeasureTheory

namespace FVLocalDomainDraft
open NumStability

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/- The corresponding existing generic norm lemma is private in FluxUpdateErrorBounds.
This draft records the small missing public API without editing that frozen owner. -/
theorem norm_bound_of_weighted_error
    {width dt oldBound leftBound rightBound : ℝ} (hw : 0 < width) (hdt : 0 ≤ dt)
    {nextError oldError leftError rightError : E}
    (hbalance : width • nextError = width • oldError + dt • (leftError - rightError))
    (hold : ‖oldError‖ ≤ oldBound) (hleft : ‖leftError‖ ≤ leftBound)
    (hright : ‖rightError‖ ≤ rightBound) :
    ‖nextError‖ ≤ oldBound + dt / width * (leftBound + rightBound) := by
  have hnorm : width * ‖nextError‖ ≤
      width * ‖oldError‖ + dt * (‖leftError‖ + ‖rightError‖) := by
    calc
      _ = ‖width • nextError‖ := by simp [norm_smul, abs_of_pos hw]
      _ = ‖width • oldError + dt • (leftError - rightError)‖ := congrArg norm hbalance
      _ ≤ ‖width • oldError‖ + ‖dt • (leftError - rightError)‖ := norm_add_le _ _
      _ ≤ _ := by
        simp only [norm_smul, Real.norm_eq_abs, abs_of_pos hw, abs_of_nonneg hdt]
        exact add_le_add le_rfl (mul_le_mul_of_nonneg_left (norm_sub_le leftError rightError) hdt)
  apply (mul_le_mul_iff_right₀ hw).mp
  calc
    width * ‖nextError‖ ≤ width * oldBound + dt * (leftBound + rightBound) :=
      hnorm.trans (add_le_add (mul_le_mul_of_nonneg_left hold hw.le)
        (mul_le_mul_of_nonneg_left (add_le_add hleft hright) hdt))
    _ = width * (oldBound + dt / width * (leftBound + rightBound)) := by field_simp

/-- Only the selected cell's two density slices and the selected time slab's
two physical face histories enter the reference law. No global solution,
global grid, derivative, or equality to arbitrary pointwise representatives is assumed.
Shared face IDs can be reused for neighboring cells and for boundary data. -/
theorem local_cell_error_contract {Cell Face : Type*}
    (oldDensity newDensity : ℝ → E) (physicalFlux : Face → ℝ → E)
    (numericalOld : Cell → E) (rule : (Cell → E) → Face → E)
    (cell : Cell) (leftFace rightFace : Face)
    {a b s t : ℝ} (hab : a < b) (hst : s < t)
    (holdDensity : IntervalIntegrable oldDensity volume a b)
    (hnewDensity : IntervalIntegrable newDensity volume a b)
    (hleftFlux : IntervalIntegrable (physicalFlux leftFace) volume s t)
    (hrightFlux : IntervalIntegrable (physicalFlux rightFace) volume s t)
    (hphysicalBalance : (∫ x in a..b, newDensity x) - (∫ x in a..b, oldDensity x) =
      ∫ τ in s..t, (physicalFlux leftFace τ - physicalFlux rightFace τ)) :
    IsOneDimensionalCellAverage oldDensity a b (oneDimensionalCellAverage oldDensity a b) ∧
    IsOneDimensionalCellAverage newDensity a b (oneDimensionalCellAverage newDensity a b) ∧
    IsOneDimensionalCellAverage (physicalFlux leftFace) s t
      (oneDimensionalCellAverage (physicalFlux leftFace) s t) ∧
    IsOneDimensionalCellAverage (physicalFlux rightFace) s t
      (oneDimensionalCellAverage (physicalFlux rightFace) s t) ∧
    oneDimensionalCellAverage oldDensity a b =
      cellVolumeAverage volume (Set.Ioc a b) oldDensity ∧
    oneDimensionalCellAverage (physicalFlux leftFace) s t =
      cellVolumeAverage volume (Set.Ioc s t) (physicalFlux leftFace) ∧
    finiteVolumeCellAverageUpdate (t - s) (b - a) (numericalOld cell)
      (rule numericalOld rightFace - rule numericalOld leftFace) =
      numericalOld cell - ((t - s) / (b - a)) •
        (rule numericalOld rightFace - rule numericalOld leftFace) ∧
    (b - a) • (finiteVolumeCellAverageUpdate (t - s) (b - a) (numericalOld cell)
      (rule numericalOld rightFace - rule numericalOld leftFace) -
      oneDimensionalCellAverage newDensity a b) =
      (b - a) • (numericalOld cell - oneDimensionalCellAverage oldDensity a b) +
        (t - s) • ((rule numericalOld leftFace - oneDimensionalCellAverage (physicalFlux leftFace) s t) -
          (rule numericalOld rightFace - oneDimensionalCellAverage (physicalFlux rightFace) s t)) ∧
    ∀ oldBound leftBound rightBound : ℝ,
      ‖numericalOld cell - oneDimensionalCellAverage oldDensity a b‖ ≤ oldBound →
      ‖rule numericalOld leftFace - oneDimensionalCellAverage (physicalFlux leftFace) s t‖ ≤ leftBound →
      ‖rule numericalOld rightFace - oneDimensionalCellAverage (physicalFlux rightFace) s t‖ ≤ rightBound →
      ‖finiteVolumeCellAverageUpdate (t - s) (b - a) (numericalOld cell)
        (rule numericalOld rightFace - rule numericalOld leftFace) -
        oneDimensionalCellAverage newDensity a b‖ ≤
        oldBound + (t - s) / (b - a) * (leftBound + rightBound) := by
  have href : (b - a) • oneDimensionalCellAverage newDensity a b -
      (b - a) • oneDimensionalCellAverage oldDensity a b =
      (t - s) • (oneDimensionalCellAverage (physicalFlux leftFace) s t -
        oneDimensionalCellAverage (physicalFlux rightFace) s t) := by
    rw [cellWidth_smul_oneDimensionalCellAverage _ hab,
      cellWidth_smul_oneDimensionalCellAverage _ hab, smul_sub,
      cellWidth_smul_oneDimensionalCellAverage _ hst,
      cellWidth_smul_oneDimensionalCellAverage _ hst,
      ← intervalIntegral.integral_sub hleftFlux hrightFlux]
    exact hphysicalBalance
  have herror : (b - a) • (finiteVolumeCellAverageUpdate (t - s) (b - a) (numericalOld cell)
      (rule numericalOld rightFace - rule numericalOld leftFace) -
      oneDimensionalCellAverage newDensity a b) =
      (b - a) • (numericalOld cell - oneDimensionalCellAverage oldDensity a b) +
        (t - s) • ((rule numericalOld leftFace - oneDimensionalCellAverage (physicalFlux leftFace) s t) -
          (rule numericalOld rightFace - oneDimensionalCellAverage (physicalFlux rightFace) s t)) := by
    rw [smul_sub, cellVolume_smul_finiteVolumeCellAverageUpdate _ _ _ _
      (ne_of_gt (sub_pos.mpr hab)), eq_add_of_sub_eq href]
    module
  refine ⟨oneDimensionalCellAverage_isCellAverage _ hab holdDensity,
    oneDimensionalCellAverage_isCellAverage _ hab hnewDensity,
    oneDimensionalCellAverage_isCellAverage _ hst hleftFlux,
    oneDimensionalCellAverage_isCellAverage _ hst hrightFlux,
    (cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage _ hab).symm,
    (cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage _ hst).symm, rfl, herror, ?_⟩
  intro oldBound leftBound rightBound hold hleft hright
  exact norm_bound_of_weighted_error (sub_pos.mpr hab) (sub_nonneg.mpr hst.le)
    herror hold hleft hright

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
  have h := local_cell_error_contract (fun x => q x s) (fun x => q x t)
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
  have h := local_cell_error_contract
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

end FVLocalDomainDraft

#check FVLocalDomainDraft.local_cell_error_contract
#check FVLocalDomainDraft.global_pointwise_consumer
#check FVLocalDomainDraft.lateJump_not_global
#check FVLocalDomainDraft.local_nonzero_error_consumer
#check FVLocalDomainDraft.local_nonzero_error_value
#check FVLocalDomainDraft.interval_average_congr_ae
#print axioms FVLocalDomainDraft.local_cell_error_contract
#print axioms FVLocalDomainDraft.global_pointwise_consumer
#print axioms FVLocalDomainDraft.lateJump_not_global
#print axioms FVLocalDomainDraft.local_nonzero_error_consumer
#print axioms FVLocalDomainDraft.local_nonzero_error_value
#print axioms FVLocalDomainDraft.interval_average_congr_ae
