/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.PiecewiseConstantReconstruction
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates
import Mathlib.Algebra.Polynomial.Eval.Defs

/-!
# LeVeque Chapter 4, Algorithm 4.1: reconstruct, evolve, average

An REA stage reconstructs a piecewise polynomial from the old cell
averages, evolves that reconstructed field exactly or approximately,
and takes normalized cell averages of the evolved field. The stage is
data supplied by a method; a method-specific predicate certifies its
evolution. An exact solver can use the integral conservation law there.
-/

namespace NumStability

/-- The three mathematical ingredients of a valid REA step for a
one-dimensional hyperbolic conservation law. -/
structure Leveque04REAStage
    {m : ℕ} (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (grid : OneDimensionalFiniteVolumeGrid)
    (old : ℤ → (Fin m → ℝ))
    (EvolutionValid : (ℝ → ℝ → (Fin m → ℝ)) → Prop) where
  /-- Reconstructed old-time field, polynomial within each open cell. -/
  reconstructed : ℝ → (Fin m → ℝ)
  piecewise_polynomial : ∀ i k, ∃ polynomial : Polynomial ℝ,
    ∀ x ∈ Set.Ioo (grid.cellLeft i) (grid.cellRight i),
      reconstructed x k = polynomial.eval x
  /-- Reconstruction preserves each stored old cell average. -/
  old_averages : ∀ i,
    oneDimensionalCellAverage reconstructed
        (grid.cellLeft i) (grid.cellRight i) = old i
  /-- Evolved field with the reconstructed state at time zero. -/
  evolved : ℝ → ℝ → (Fin m → ℝ)
  initial_trace : ∀ x, evolved x 0 = reconstructed x
  evolution_valid : EvolutionValid evolved

/-- A precise choice of evolution criterion for an exact REA stage. An
approximate solver supplies its own error or residual criterion. -/
def IsLeveque04ExactEvolution
    {m : ℕ} (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (evolved : ℝ → ℝ → (Fin m → ℝ)) : Prop :=
  IsIntegralConservationLawSolution evolved law.physicalFlux

/-- The averaging stage of Algorithm 4.1, after the supplied exact
evolution for one positive time step. -/
noncomputable def Leveque04REAStage.nextAverage
    {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    {grid : OneDimensionalFiniteVolumeGrid}
    {old : ℤ → (Fin m → ℝ)}
    {EvolutionValid : (ℝ → ℝ → (Fin m → ℝ)) → Prop}
    (stage : Leveque04REAStage law grid old EvolutionValid)
    (timeStep : ℝ) (i : ℤ) : Fin m → ℝ :=
  oneDimensionalCellAverage (fun x => stage.evolved x timeStep)
    (grid.cellLeft i) (grid.cellRight i)

/-- Algorithm 4.1 produces the normalized cell integral of the evolved
reconstruction; the reconstruction and PDE evolution are certified by
the stage fields. -/
theorem leveque04_algorithm41
    {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    {grid : OneDimensionalFiniteVolumeGrid}
    {old : ℤ → (Fin m → ℝ)}
    {EvolutionValid : (ℝ → ℝ → (Fin m → ℝ)) → Prop}
    (stage : Leveque04REAStage law grid old EvolutionValid)
    (timeStep : ℝ) (_htime : 0 < timeStep) (i : ℤ) :
    stage.nextAverage timeStep i =
      oneDimensionalCellAverage (fun x => stage.evolved x timeStep)
        (grid.cellLeft i) (grid.cellRight i) := rfl

/-- A pointwise error criterion for an approximate REA evolution controls
its one-step cell average relative to a reference evolution. -/
theorem leveque04_reaApproximateEvolution_cellAverageError
    {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    {grid : OneDimensionalFiniteVolumeGrid}
    {old : ℤ → (Fin m → ℝ)}
    {ReferenceValid ApproximateValid : (ℝ → ℝ → (Fin m → ℝ)) → Prop}
    (reference : Leveque04REAStage law grid old ReferenceValid)
    (approximate : Leveque04REAStage law grid old ApproximateValid)
    (timeStep : ℝ) (i : ℤ) (error : ℝ)
    (hreference : IntervalIntegrable (fun x => reference.evolved x timeStep)
      MeasureTheory.volume (grid.cellLeft i) (grid.cellRight i))
    (happroximate : IntervalIntegrable (fun x => approximate.evolved x timeStep)
      MeasureTheory.volume (grid.cellLeft i) (grid.cellRight i))
    (herror : ∀ x ∈ Set.uIoc (grid.cellLeft i) (grid.cellRight i),
      ‖approximate.evolved x timeStep - reference.evolved x timeStep‖ ≤ error) :
    ‖approximate.nextAverage timeStep i - reference.nextAverage timeStep i‖ ≤
      error := by
  exact norm_oneDimensionalCellAverage_sub_le
    (grid.cell_nonempty i) happroximate hreference herror

end NumStability
