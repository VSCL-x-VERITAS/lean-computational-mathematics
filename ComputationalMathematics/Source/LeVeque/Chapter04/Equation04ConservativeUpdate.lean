/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference

/-!
# LeVeque Chapter 4, equation (4.4): conservative update

The integer interface index `j` denotes the left edge of cell `j`, so
`edgeFlux j` represents the source's `Fⁿ_(j-1/2)` and `edgeFlux (j + 1)`
represents `Fⁿ_(j+1/2)`. `before` and `after` represent the two consecutive
time levels, with a positive time step and cell width.
-/

namespace NumStability

/-- The conservative finite-volume step of (4.4), using the reusable
flux-difference update. -/
noncomputable def leveque04_finiteVolumeUpdate
    {m : ℕ} (timeStep cellWidth : ℝ)
    (cellAverage edgeFlux : ℤ → (Fin m → ℝ)) (i : ℤ) : Fin m → ℝ :=
  conservativeFluxDifferenceUpdateInt
    (timeStep / cellWidth) cellAverage edgeFlux i

/-- A pair of consecutive cell-average fields follows the scheme template
(4.4). The shared `edgeFlux` assigns one flux to each interface. -/
def IsLeveque04ConservativeStep
    {m : ℕ} (timeStep cellWidth : ℝ)
    (before after edgeFlux : ℤ → (Fin m → ℝ)) : Prop :=
  0 < m ∧ 0 < timeStep ∧ 0 < cellWidth ∧
    ∀ i, after i = before i -
      (timeStep / cellWidth) • (edgeFlux (i + 1) - edgeFlux i)

/-- The reusable flux-difference update constructs a step of the form (4.4). -/
theorem leveque04_equation04
    {m : ℕ} (timeStep cellWidth : ℝ)
    (cellAverage edgeFlux : ℤ → (Fin m → ℝ))
    (hdim : 0 < m) (htime : 0 < timeStep) (hwidth : 0 < cellWidth) :
    IsLeveque04ConservativeStep timeStep cellWidth
      cellAverage
      (fun i => leveque04_finiteVolumeUpdate timeStep cellWidth cellAverage edgeFlux i)
      edgeFlux := by
  refine ⟨hdim, htime, hwidth, ?_⟩
  intro i
  rfl

end NumStability
