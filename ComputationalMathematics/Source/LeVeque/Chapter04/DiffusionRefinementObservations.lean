/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.ExplicitDiffusionStep
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AdmissibleDomainNecessity
import Mathlib.Logic.Function.Iterate

/-!
# Actual explicit-diffusion observations under physical refinement

These transparent definitions fix the Chapter4 diffusion update, its iteration
count and its observation before testing changes in physical initial data.
Point samples and actual finite-volume cell means are separate initializations
of the same update. No supplied evolution or initialization callback occurs.

The admitted data class is every bounded continuous real profile on the whole
line. A numerical domain uses generic every-neighborhood essentiality for the
fixed initialized observation. These definitions assert no influence theorem,
positivity, convergence, stability or continuum PDE realization.
-/

namespace NumStability

/-- All bounded continuous real profiles, stated directly as continuity and a
global pointwise absolute-value bound. -/
def leveque04_diffusionRefinementData (initial : ℝ → ℝ) : Prop :=
  Continuous initial ∧ ∃ bound : ℝ, ∀ space : ℝ, |initial space| ≤ bound

/-- The observation lies at site0, whose physical coordinate is `observation`.
Other sites are the centers of the corresponding uniform finite-volume cells. -/
def leveque04_diffusionRefinementSite
    (observation width : ℝ) (index : ℤ) : ℝ :=
  observation + (index : ℝ) * width

/-- Actual point-value initialization at the prescribed physical grid sites. -/
def leveque04_diffusionPointInitial
    (observation width : ℝ) (initial : ℝ → ℝ) (index : ℤ) : ℝ :=
  initial (leveque04_diffusionRefinementSite observation width index)

/-- Actual normalized spatial integral over the cell centered at a grid site.
Positive width and bounded continuous data are supplied by the target. -/
noncomputable def leveque04_diffusionCellAverageInitial
    (observation width : ℝ) (initial : ℝ → ℝ) (index : ℤ) : ℝ :=
  oneDimensionalCellAverage initial
    (leveque04_diffusionRefinementSite observation width index - width / 2)
    (leveque04_diffusionRefinementSite observation width index + width / 2)

/-- Iterate the actual conservative diffusion update after point sampling,
then observe index0. Conductivity `i` belongs to the face between cells i-1/i. -/
noncomputable def leveque04_diffusionPointObservation
    (observation timeStep width : ℝ) (conductivity : ℤ → ℝ) (steps : ℕ)
    (initial : ℝ → ℝ) : ℝ :=
  ((leveque04_explicitDiffusionStep timeStep width conductivity)^[steps]
    (leveque04_diffusionPointInitial observation width initial)) 0

/-- The same actual update and observation, initialized by actual cell means. -/
noncomputable def leveque04_diffusionCellAverageObservation
    (observation timeStep width : ℝ) (conductivity : ℤ → ℝ) (steps : ℕ)
    (initial : ℝ → ℝ) : ℝ :=
  ((leveque04_explicitDiffusionStep timeStep width conductivity)^[steps]
    (leveque04_diffusionCellAverageInitial observation width initial)) 0

/-- Actual per-mesh physical influence for the fixed point-initialized method.
This does not replace functional influence by a structural readgraph. -/
def leveque04_diffusionPointNumericalDomain
    (observation timeStep width : ℝ) (conductivity : ℤ → ℝ)
    (steps : ℕ) : Set ℝ :=
  {point | IsEssentialPointOnClass leveque04_diffusionRefinementData
    (leveque04_diffusionPointObservation observation timeStep width conductivity steps)
    point}

/-- Actual per-mesh physical influence for the fixed cell-mean-initialized method.
Physical influence can include a cell interior, not just the cell-center lattice. -/
def leveque04_diffusionCellAverageNumericalDomain
    (observation timeStep width : ℝ) (conductivity : ℤ → ℝ)
    (steps : ℕ) : Set ℝ :=
  {point | IsEssentialPointOnClass leveque04_diffusionRefinementData
    (leveque04_diffusionCellAverageObservation
      observation timeStep width conductivity steps) point}

end NumStability
