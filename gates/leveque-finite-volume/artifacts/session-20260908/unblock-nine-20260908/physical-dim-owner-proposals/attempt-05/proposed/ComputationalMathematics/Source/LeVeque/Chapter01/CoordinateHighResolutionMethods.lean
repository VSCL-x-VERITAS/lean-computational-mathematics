/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalHighResolutionSweep

/-!
# Chapter 1 coordinate splitting on a physical logical grid

This correspondence uses the recorded physical logical-grid and separately adopted
high-resolution interpretations. It executes supplied capacity methods through positive,
admitted coordinate substeps on the selected measured mesh. Core quality retains
uniform smooth order and quantitative oscillation control; stability is required only
inside the conditional error analysis. The underlying assumptions are supplied measured
directional balances, with no continuum-equivalence inference from tensor/normal data.
The earlier common-area source contract is preserved in its frozen historical audit;
this replacement requires its own source-faithfulness decision.
-/

namespace NumStability
variable {D FacePoint : Type*} [Fintype D] [DecidableEq D] [MeasurableSpace FacePoint] {m : ℕ}

/-- Chapter 1 coordinate splitting under the recorded physical logical-grid
interpretation and the separately adopted high-resolution convention: order
greater than one on smooth references and quantitative oscillation control.
The supplied methods execute positive, admitted coordinate substeps on the
selected measured mesh, with explicit stage-dependent boundary inputs.
Stability and physical reference-error hypotheses belong to the conditional
analysis, rather than to the coordinate construction or core quality. -/
theorem leveque01_coordinateHighResolutionMethods_sourceContract
    (hm : 0 < m) (hD : 0 < Fintype.card D)
    (family : NumStability.PhysicalRefinementQuality.Family D FacePoint m)
    (quality : family.HasHighResolution) (level : ℕ) (direction : ℕ → D) (duration : ℕ → ℝ)
    (ghost : ℕ → D → family.Line level → ℤ → Fin m → ℝ)
    (initial : family.Cell level → Fin m → ℝ) (steps : ℕ)
    (hschedule : ∀ d : D, ∃ k < steps, direction k = d)
    (hvalid : NumStability.PhysicalHighResolutionSweep.ValidSubsteps family level direction duration ghost initial steps) :
    0 < m ∧ 0 < Fintype.card D ∧
      NumStability.PhysicalHighResolutionSweep.Specification family level direction duration ghost initial steps ∧
      NumStability.PhysicalHighResolutionSweep.ValidSubsteps family level direction duration ghost initial steps :=
  ⟨hm, hD, NumStability.PhysicalHighResolutionSweep.admitted_specification family quality level direction duration ghost
    initial steps hschedule hvalid⟩

end NumStability
