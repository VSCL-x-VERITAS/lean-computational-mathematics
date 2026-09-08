import ComputationalMathematics.Source.LeVeque.Chapter01.EigenvaluePropagation
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxUpdateErrorBounds
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic

/-!
Prospective qualification checks only. No new declaration, axiom, source
interpretation, accepted audit or theorem proof is introduced. The two checked
average terms and finite-sum term apply existing canonical theorems directly.
-/

open MeasureTheory NumStability

set_option pp.all true in
#print Real.measureSpace
set_option pp.all true in
#print MeasureTheory.MeasureSpace.volume
set_option pp.all true in
#check (volume : Measure ℝ)
set_option pp.all true in
#check (fun m : ℕ => (inferInstance : CompleteSpace (Fin m → ℝ)))

#check MeasureTheory.integral_def
#check MeasureTheory.integral_eq
#check MeasureTheory.integral_undef
#check intervalIntegral.integral_of_le
#check intervalIntegrable_iff_integrableOn_Ioc_of_le
#check Real.volume_eq_stieltjes_id
#check Real.volume_Ioc
#check Real.volume_real_Ioc_of_le

#print NumStability.IsConstantCoefficientLinearSystemSolutionAt
#print NumStability.IsLinearAdvectionSolutionAt
#check NumStability.constantCoefficientSystem_iff_eigenbasisAdvection
#check NumStability.constantCoefficientSystem_characteristicPropagation
#check NumStability.leveque01_eigenvalues_completeWavePropagation
#check NumStability.eigenmodeTravelingWave_isRectangleSolution
#check NumStability.finite_sum_isRectangleSolution

#print NumStability.IsRectangleConservationLawSolution
#print NumStability.oneDimensionalCellAverage
#print NumStability.cellVolumeAverage
#print NumStability.IsCellVolumeAverage
#print NumStability.IsOneDimensionalCellAverage
#check NumStability.cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage
#check NumStability.timeAveragedPhysicalFaceFlux_isCellAverage
#check NumStability.finiteVolumeCellAverageOn_mass_balance
#check NumStability.riemannFiniteVolumeUpdate_weighted_error
#check NumStability.riemannFiniteVolumeUpdate_error_le

section Applications

variable {m : ℕ}

-- Spatial native-volume qualification of the exact same reference average.
#check fun (grid : OneDimensionalFiniteVolumeGrid)
    (q : ℝ → ℝ → (Fin m → ℝ)) (s : ℝ) (i : ℤ) =>
  (cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage
    (fun x => q x s) (grid.cell_nonempty i) :
    cellVolumeAverage volume (Set.Ioc (grid.cellLeft i) (grid.cellRight i))
      (fun x => q x s) = finiteVolumeCellAverageOn grid (fun x => q x s) i)

-- Temporal native-volume qualification of the same physical face reference.
#check fun (grid : OneDimensionalFiniteVolumeGrid)
    (q : ℝ → ℝ → (Fin m → ℝ)) (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (s t : ℝ) (hst : s < t) (i : ℤ) =>
  (cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage
    (fun τ => flux (q (grid.cellLeft i) τ)) hst :
    cellVolumeAverage volume (Set.Ioc s t) (fun τ => flux (q (grid.cellLeft i) τ)) =
      timeAveragedPhysicalFaceFlux grid q flux s t i)

-- Available nonsmooth construction: conservation of the specified sum.
-- This does not assert representation or uniqueness of every weak solution.
#check fun (A : Matrix (Fin m) (Fin m) ℝ)
    (b : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (heigen : ∀ i, A.mulVec (b i) = speeds i • b i)
    (profiles : Fin m → ℝ → ℝ)
    (hp : ∀ i a c, IntervalIntegrable (profiles i) volume a c) =>
  finite_sum_isRectangleSolution A
    (fun i => eigenmodeTravelingWave (profiles i) (speeds i) (b i))
    (fun i => eigenmodeTravelingWave_isRectangleSolution
      A (profiles i) (hp i) (speeds i) (b i) (heigen i))

end Applications

#print axioms MeasureTheory.integral_def
#print axioms MeasureTheory.integral_eq
#print axioms MeasureTheory.integral_undef
#print axioms intervalIntegral.integral_of_le
#print axioms intervalIntegrable_iff_integrableOn_Ioc_of_le
#print axioms Real.volume_eq_stieltjes_id
#print axioms Real.volume_Ioc
#print axioms Real.volume_real_Ioc_of_le
#print axioms NumStability.constantCoefficientSystem_iff_eigenbasisAdvection
#print axioms NumStability.constantCoefficientSystem_characteristicPropagation
#print axioms NumStability.leveque01_eigenvalues_completeWavePropagation
#print axioms NumStability.eigenmodeTravelingWave_isRectangleSolution
#print axioms NumStability.finite_sum_isRectangleSolution
#print axioms NumStability.cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage
#print axioms NumStability.timeAveragedPhysicalFaceFlux_isCellAverage
#print axioms NumStability.finiteVolumeCellAverageOn_mass_balance
#print axioms NumStability.riemannFiniteVolumeUpdate_weighted_error
#print axioms NumStability.riemannFiniteVolumeUpdate_error_le
