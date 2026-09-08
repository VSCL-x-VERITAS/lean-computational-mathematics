/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxUpdateErrorBounds
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface

/-!
# Conditional errors of selected rectangle Riemann methods

For each admitted ordered adjacent-cell problem, compare the actual selected
numerical flux with the physical trace of its returned local solution, then
compare that trace with an independent global rectangle-conservative field.
Both pointwise error bounds on `(0, dt]` are explicit hypotheses. Constant-state
consistency alone does not imply either bound for unequal data.

Solver admissibility is required only for the fixed old array. The generic
law and method supply no general nonlinear existence, entropy, convergence,
accuracy order, stability or CFL result. The block estimate controls the norm
of total weighted mass error, allowing cancellation between cells.
-/

open MeasureTheory
open scoped BigOperators

namespace NumStability

variable {m : ℕ} {Information : Type*}
variable {law : OneDimensionalHyperbolicConservationLaw (Fin m)}

/-- Numerical-to-local and local-to-global trace bounds control the selected interface flux error. -/
theorem rectangleRiemannInterfaceFlux_error_le (grid : OneDimensionalFiniteVolumeGrid)
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    {q : ℝ → ℝ → (Fin m → ℝ)} (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    (old : ℤ → (Fin m → ℝ))
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j))
    {dt solverBound traceBound : ℝ} (hdt : 0 < dt) (j : ℤ)
    (hnumerical : ∀ τ ∈ Set.uIoc 0 dt,
      ‖rectangleRiemannInterfaceFlux method old hdomain j -
        law.physicalFlux ((method.solve (adjacentCellRiemannProblem law old j)
          (hdomain j)).solution 0 τ)‖ ≤ solverBound)
    (htrace : ∀ τ ∈ Set.uIoc 0 dt,
      ‖law.physicalFlux ((method.solve (adjacentCellRiemannProblem law old j)
          (hdomain j)).solution 0 τ) - law.physicalFlux (q (grid.cellLeft j) τ)‖ ≤ traceBound) :
    ‖rectangleRiemannInterfaceFlux method old hdomain j -
      timeAveragedPhysicalFaceFlux grid q law.physicalFlux 0 dt j‖ ≤ solverBound + traceBound := by
  let numerical := rectangleRiemannInterfaceFlux method old hdomain j
  let localFlux := fun τ => law.physicalFlux
    ((method.solve (adjacentCellRiemannProblem law old j) (hdomain j)).solution 0 τ)
  have hconst : oneDimensionalCellAverage (fun _ : ℝ => numerical) 0 dt = numerical := by
    simp [oneDimensionalCellAverage, intervalIntegral.integral_const, smul_smul, hdt.ne']
  have hlocal : IntervalIntegrable localFlux volume 0 dt :=
    (method.solve (adjacentCellRiemannProblem law old j) (hdomain j)).solves.2.2.1 0 0 dt
  have hn : ‖numerical - oneDimensionalCellAverage localFlux 0 dt‖ ≤ solverBound := by
    rw [← hconst]
    exact norm_oneDimensionalCellAverage_sub_le hdt (intervalIntegrable_const) hlocal hnumerical
  have ht : ‖oneDimensionalCellAverage localFlux 0 dt -
      timeAveragedPhysicalFaceFlux grid q law.physicalFlux 0 dt j‖ ≤ traceBound :=
    norm_oneDimensionalCellAverage_sub_le hdt hlocal (hq.2.1 _ _ _) htrace
  calc
    _ ≤ ‖numerical - oneDimensionalCellAverage localFlux 0 dt‖ +
        ‖oneDimensionalCellAverage localFlux 0 dt -
          timeAveragedPhysicalFaceFlux grid q law.physicalFlux 0 dt j‖ := by
      exact norm_sub_le_norm_sub_add_norm_sub _ _ _
    _ ≤ solverBound + traceBound := add_le_add hn ht

/-- For the fixed admissible old array, the two face estimates control the next cell-average error. -/
theorem rectangleRiemannInterfaceFlux_update_error_le (grid : OneDimensionalFiniteVolumeGrid)
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    {q : ℝ → ℝ → (Fin m → ℝ)} (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    (old : ℤ → (Fin m → ℝ))
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j))
    {dt oldBound : ℝ} (hdt : 0 < dt) (i : ℤ)
    (solverBound traceBound : ℤ → ℝ)
    (hold : ‖old i - finiteVolumeCellAverageOn grid (fun x => q x 0) i‖ ≤ oldBound)
    (hnumerical : ∀ j τ, τ ∈ Set.uIoc 0 dt →
      ‖rectangleRiemannInterfaceFlux method old hdomain j -
        law.physicalFlux ((method.solve (adjacentCellRiemannProblem law old j)
          (hdomain j)).solution 0 τ)‖ ≤ solverBound j)
    (htrace : ∀ j τ, τ ∈ Set.uIoc 0 dt →
      ‖law.physicalFlux ((method.solve (adjacentCellRiemannProblem law old j)
          (hdomain j)).solution 0 τ) - law.physicalFlux (q (grid.cellLeft j) τ)‖ ≤ traceBound j) :
    ‖riemannFiniteVolumeUpdate grid dt old
      (rectangleRiemannInterfaceFlux method old hdomain) i -
      finiteVolumeCellAverageOn grid (fun x => q x dt) i‖ ≤
      oldBound + dt / grid.cellVolume i *
        ((solverBound i + traceBound i) + (solverBound (i + 1) + traceBound (i + 1))) := by
  simpa using riemannFiniteVolumeUpdate_error_le grid hq
    (fun _ _ _ => rectangleRiemannInterfaceFlux method old hdomain)
    hdt old i hold
    (rectangleRiemannInterfaceFlux_error_le grid method hq old hdomain hdt i (hnumerical i) (htrace i))
    (rectangleRiemannInterfaceFlux_error_le grid method hq old hdomain hdt (i + 1) (hnumerical (i + 1)) (htrace (i + 1)))

/-- Only exterior face errors survive in the bound on total block mass error; cancellation is allowed. -/
theorem rectangleRiemannInterfaceFlux_block_mass_error_le (grid : OneDimensionalFiniteVolumeGrid)
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    {q : ℝ → ℝ → (Fin m → ℝ)} (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    (old : ℤ → (Fin m → ℝ))
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j))
    {dt : ℝ} (hdt : 0 < dt) (start : ℤ) (count : ℕ)
    (oldBound : ℕ → ℝ) (solverBound traceBound : ℤ → ℝ)
    (hold : ∀ k ∈ Finset.range count,
      ‖old (start + k) - finiteVolumeCellAverageOn grid (fun x => q x 0) (start + k)‖ ≤ oldBound k)
    (hnumerical : ∀ j τ, τ ∈ Set.uIoc 0 dt →
      ‖rectangleRiemannInterfaceFlux method old hdomain j -
        law.physicalFlux ((method.solve (adjacentCellRiemannProblem law old j)
          (hdomain j)).solution 0 τ)‖ ≤ solverBound j)
    (htrace : ∀ j τ, τ ∈ Set.uIoc 0 dt →
      ‖law.physicalFlux ((method.solve (adjacentCellRiemannProblem law old j)
          (hdomain j)).solution 0 τ) - law.physicalFlux (q (grid.cellLeft j) τ)‖ ≤ traceBound j) :
    ‖∑ k ∈ Finset.range count, grid.cellVolume (start + k) •
      (riemannFiniteVolumeUpdate grid dt old
        (rectangleRiemannInterfaceFlux method old hdomain) (start + k) -
        finiteVolumeCellAverageOn grid (fun x => q x dt) (start + k))‖ ≤
      (∑ k ∈ Finset.range count, grid.cellVolume (start + k) * oldBound k) +
        dt * ((solverBound start + traceBound start) +
          (solverBound (start + count) + traceBound (start + count))) := by
  simpa using riemannFiniteVolumeUpdate_block_mass_error_le grid hq
    (fun _ _ _ => rectangleRiemannInterfaceFlux method old hdomain)
    hdt old start count oldBound hold
    (rectangleRiemannInterfaceFlux_error_le grid method hq old hdomain hdt start (hnumerical start) (htrace start))
    (rectangleRiemannInterfaceFlux_error_le grid method hq old hdomain hdt (start + count)
      (hnumerical (start + count)) (htrace (start + count)))


end NumStability
