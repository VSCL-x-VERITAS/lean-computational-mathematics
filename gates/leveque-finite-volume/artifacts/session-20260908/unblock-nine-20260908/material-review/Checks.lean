import ComputationalMathematics.Source.LeVeque.Chapter01.SourceTermsRectangleBalance
import ComputationalMathematics.Source.LeVeque.Chapter01.MaterialInterfaceLocalRiemannData
import ComputationalMathematics.Source.LeVeque.Chapter01.MaterialCellVolumeAveraging
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.LinearProduction
import ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Examples.LocalMaterialInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.CellVolumeAverage
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic

open MeasureTheory

namespace NumStability.MaterialUnblockingChecks

def unitState : Fin 1 → ℝ := fun _ => 1
noncomputable def profile : ℝ → Fin 1 → ℝ := riemannData 0 0 unitState
noncomputable def state (rate : ℝ) (x t : ℝ) : Fin 1 → ℝ := (rate * t) • profile x
noncomputable def production (rate : ℝ) (x _t : ℝ) : Fin 1 → ℝ := rate • profile x

theorem profile_eq_scalar_smul (x : ℝ) :
    profile x = riemannData (0 : ℝ) 0 1 x • unitState := by
  unfold profile riemannData
  split_ifs <;> simp

theorem balance (rate : ℝ) :
    IsRectangleBalanceLawSolution (state rate) (fun _ => 0) (production rate) :=
  linearAmplitude_isRectangleBalanceLawSolution profile
    (riemannData_intervalIntegrable 0 0 unitState) rate

theorem source_integral (rate : ℝ) :
    (∫ _τ in (1 : ℝ)..2, ∫ x in (1 : ℝ)..2, production rate x _τ) = rate • unitState := by
  simp only [production, profile_eq_scalar_smul, smul_smul,
    intervalIntegral.integral_smul_const, riemannStep_signed_source_integral]

/-- The literal Fin 1 fixture invokes the full new source theorem. -/
theorem source_capstone_instance (rate : ℝ) :
    IsRectangleBalanceLawSolution (state rate) (fun _ => 0) (production rate) ∧
    (∀ a b s t,
      (∫ τ in s..t, ∫ x in a..b, production rate x τ) =
        ((∫ x in a..b, state rate x t) - (∫ x in a..b, state rate x s)) -
          (∫ _τ in s..t, (0 : Fin 1 → ℝ) - 0)) ∧
    (IsRectangleConservationLawSolution (state rate) (fun _ => 0) ↔
      ∀ a b s t, (∫ τ in s..t, ∫ x in a..b, production rate x τ) = 0) ∧
    (¬ IsRectangleConservationLawSolution (state rate) (fun _ => 0) ↔
      ∃ a b s t, (∫ τ in s..t, ∫ x in a..b, production rate x τ) ≠ 0) ∧
    (∀ a b, ∀ᵐ t,
      HasDerivAt (fun s => ∫ x in a..b, state rate x s)
        ((0 : Fin 1 → ℝ) - 0 + ∫ x in a..b, production rate x t) t) := by
  have h : IsRectangleBalanceLawSolution (state rate)
      (fun q => (0 : ℝ) • q) (production rate) := by
    simpa only [zero_smul] using balance rate
  simpa only [zero_smul] using leveque01_sourceTermsRectangleBalance 0 h

theorem nonconservation (rate : ℝ) (hrate : rate ≠ 0) :
    ¬ IsRectangleConservationLawSolution (state rate) (fun _ => 0) := by
  apply (source_capstone_instance rate).2.2.2.1.mpr
  refine ⟨1, 2, 1, 2, ?_⟩
  rw [source_integral]
  intro heq
  apply hrate
  simpa [unitState] using congrFun heq (0 : Fin 1)

theorem positive_and_negative_instances :
    ¬ IsRectangleConservationLawSolution (state 1) (fun _ => 0) ∧
    ¬ IsRectangleConservationLawSolution (state (-1)) (fun _ => 0) ∧
    ((∫ τ in (1 : ℝ)..2, ∫ x in (1 : ℝ)..2, production 1 x τ) (0 : Fin 1)) = 1 ∧
    ((∫ τ in (1 : ℝ)..2, ∫ x in (1 : ℝ)..2, production (-1) x τ) (0 : Fin 1)) = -1 := by
  refine ⟨nonconservation 1 (by norm_num), nonconservation (-1) (by norm_num), ?_, ?_⟩ <;>
    simp [source_integral, unitState]

/-- Both jumps satisfy the new target, while the medium has no global constant-side model. -/
theorem local_medium_applicability (originMaterial originState : ℝ) :
    HasJumpAt (LocalMaterialInterface.varyingMedium originMaterial) 0 0 1 ∧
    HasJumpAt (riemannData (2 : ℝ) originState 3) 0 2 3 ∧
    (¬ ∃ ml mr, IsRiemannData (LocalMaterialInterface.varyingMedium originMaterial) ml mr) ∧
    ¬ ContinuousAt (LocalMaterialInterface.varyingMedium originMaterial) 0 ∧
    ¬ ContinuousAt (riemannData (2 : ℝ) originState 3) 0 := by
  have h := leveque01_materialInterfaceLocalRiemannData
    (LocalMaterialInterface.varyingMedium_hasJumpAt originMaterial)
    (riemannData_isRiemannData (2 : ℝ) originState 3) (by norm_num)
  exact ⟨h.1.1, h.1.2, LocalMaterialInterface.varyingMedium_not_isRiemannData originMaterial,
    h.2.2.2.1, h.2.2.2.2.1⟩

open CellVolumeAverageExamples

/-- The actual new assignment theorem includes heterogeneous fields with equal averages. -/
theorem equal_average_applicability :
    ∃ assigned : Bool → ℝ,
      (∀ cell, IsCellVolumeAverage volume (symmetricCells.cellRegion cell)
        (fun x : ℝ => x ^ 2) (assigned cell)) ∧
      assigned false = assigned true ∧
      (∀ cell, ∃ x ∈ symmetricCells.cellRegion cell, ∃ y ∈ symmetricCells.cellRegion cell,
        (x ^ 2 : ℝ) ≠ y ^ 2) := by
  obtain ⟨assigned, hassigned, _, _, _⟩ := leveque01_materialCellVolumeAveraging
    symmetricCells volume (fun x : ℝ => x ^ 2)
    (fun cell => by rw [symmetricCells_volume]; norm_num)
    (fun cell => by rw [symmetricCells_volume]; norm_num) quadratic_integrable_on_cell
  have hvalue (cell : Bool) : assigned cell = (1 / 3 : ℝ) :=
    (hassigned cell).2.2.2.trans (quadratic_cell_average cell)
  exact ⟨assigned, hassigned, (hvalue false).trans (hvalue true).symm,
    quadratic_heterogeneous_each_cell⟩

/-- Different assigned values are also obtained from the same new target. -/
theorem different_average_applicability :
    ∃ assigned : Bool → ℝ,
      (∀ cell, IsCellVolumeAverage volume (symmetricCells.cellRegion cell)
        (fun x : ℝ => x) (assigned cell)) ∧ assigned false ≠ assigned true := by
  obtain ⟨assigned, hassigned, _, _, _⟩ := leveque01_materialCellVolumeAveraging
    symmetricCells volume (fun x : ℝ => x)
    (fun cell => by rw [symmetricCells_volume]; norm_num)
    (fun cell => by rw [symmetricCells_volume]; norm_num)
    (fun cell => (heterogeneous_different_average_nonvacuity.1 cell).2.2.1)
  refine ⟨assigned, hassigned, ?_⟩
  rw [(hassigned false).2.2.2, (hassigned true).2.2.2]
  exact heterogeneous_different_average_nonvacuity.2

/-- Exact installed ordinary real-volume meaning for the new audit packets. -/
theorem selectedInstance : Real.measureSpace = measureSpaceOfInnerProductSpace (E := ℝ) := rfl
theorem selectedVolume :
    (volume : Measure ℝ) = (stdOrthonormalBasis ℝ ℝ).toBasis.addHaar := rfl
theorem stieltjesIdentity :
    @MeasureTheory.MeasureSpace.volume ℝ Real.measureSpace =
      StieltjesFunction.id.measure := Real.volume_eq_stieltjes_id
theorem unitInterval :
    (@MeasureTheory.MeasureSpace.volume ℝ Real.measureSpace) (Set.Ioc 0 1) = 1 := by simp
theorem selectedBorel : Real.measureSpace.toMeasurableSpace = borel ℝ := rfl

end NumStability.MaterialUnblockingChecks

#check NumStability.leveque01_sourceTermsRectangleBalance
#check NumStability.leveque01_materialInterfaceLocalRiemannData
#check NumStability.leveque01_materialCellVolumeAveraging
#print axioms NumStability.leveque01_sourceTermsRectangleBalance
#print axioms NumStability.leveque01_materialInterfaceLocalRiemannData
#print axioms NumStability.leveque01_materialCellVolumeAveraging

open NumStability.MaterialUnblockingChecks
#check NumStability.MaterialUnblockingChecks.unitState
#print axioms NumStability.MaterialUnblockingChecks.unitState
#check NumStability.MaterialUnblockingChecks.profile
#print axioms NumStability.MaterialUnblockingChecks.profile
#check NumStability.MaterialUnblockingChecks.state
#print axioms NumStability.MaterialUnblockingChecks.state
#check NumStability.MaterialUnblockingChecks.production
#print axioms NumStability.MaterialUnblockingChecks.production
#check NumStability.MaterialUnblockingChecks.profile_eq_scalar_smul
#print axioms NumStability.MaterialUnblockingChecks.profile_eq_scalar_smul
#check NumStability.MaterialUnblockingChecks.balance
#print axioms NumStability.MaterialUnblockingChecks.balance
#check NumStability.MaterialUnblockingChecks.source_integral
#print axioms NumStability.MaterialUnblockingChecks.source_integral
#check NumStability.MaterialUnblockingChecks.source_capstone_instance
#print axioms NumStability.MaterialUnblockingChecks.source_capstone_instance
#check NumStability.MaterialUnblockingChecks.nonconservation
#print axioms NumStability.MaterialUnblockingChecks.nonconservation
#check NumStability.MaterialUnblockingChecks.positive_and_negative_instances
#print axioms NumStability.MaterialUnblockingChecks.positive_and_negative_instances
#check NumStability.MaterialUnblockingChecks.local_medium_applicability
#print axioms NumStability.MaterialUnblockingChecks.local_medium_applicability
#check NumStability.MaterialUnblockingChecks.equal_average_applicability
#print axioms NumStability.MaterialUnblockingChecks.equal_average_applicability
#check NumStability.MaterialUnblockingChecks.different_average_applicability
#print axioms NumStability.MaterialUnblockingChecks.different_average_applicability
#check NumStability.MaterialUnblockingChecks.selectedInstance
#print axioms NumStability.MaterialUnblockingChecks.selectedInstance
#check NumStability.MaterialUnblockingChecks.selectedVolume
#print axioms NumStability.MaterialUnblockingChecks.selectedVolume
#check NumStability.MaterialUnblockingChecks.stieltjesIdentity
#print axioms NumStability.MaterialUnblockingChecks.stieltjesIdentity
#check NumStability.MaterialUnblockingChecks.unitInterval
#print axioms NumStability.MaterialUnblockingChecks.unitInterval
#check NumStability.MaterialUnblockingChecks.selectedBorel
#print axioms NumStability.MaterialUnblockingChecks.selectedBorel

set_option pp.all true in
#print Real.measureSpace
set_option pp.all true in
#print measureSpaceOfInnerProductSpace
set_option pp.all true in
#print MeasureTheory.MeasureSpace.volume
set_option pp.all true in
#print NumStability.IsRectangleBalanceLawSolution
#check Real.volume_eq_stieltjes_id
#check Real.volume_Ioc
#check Real.volume_real_Ioc_of_le
#print axioms Real.volume_Ioc
