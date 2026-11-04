/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerPredictor
import ComputationalMathematics.Source.LeVeque.Chapter04.Equation10DiffusionFlux
import ComputationalMathematics.Source.LeVeque.Chapter04.PositiveSpeedUpwind

/-!
# A specified scalar artificial-viscosity correction

The uncorrected flux is the actual Richtmyer flux on a scalar linear physical
flux, represented in its sole `Fin 1` component. The correction is the actual
Fick flux on the centered two-cell gradient. Its coefficient is chosen to cancel
the scalar antidiffusive correction of (6.9). The update is the existing
conservative flux-difference construction; no inverse or nonoscillation property
is assumed by these definitions.
-/

namespace NumStability

/-- The actual scalar linear Richtmyer/Lax--Wendroff face flux. -/
noncomputable def leveque04_scalarLWFaceFlux
    (speed timeStep cellWidth left right : ℝ) : ℝ :=
  leveque04_richtmyerFlux timeStep cellWidth
    (fun (state : Fin 1 → ℝ) (_ : Fin 1) => speed * state 0)
    (fun _ : Fin 1 => left) (fun _ : Fin 1 => right) 0

/-- The diffusion coefficient of the proposed exact scalar cancellation. -/
noncomputable def leveque04_scalarLWAddedViscosity
    (speed timeStep cellWidth : ℝ) : ℝ :=
  speed * cellWidth / 2 * (1 - speed * timeStep / cellWidth)

/-- The actual Fick correction on the centered two-state gradient. -/
noncomputable def leveque04_scalarLWAddedDiffusiveFlux
    (speed timeStep cellWidth left right : ℝ) : ℝ :=
  Leveque02Tracer.fickFlux
    (leveque04_scalarLWAddedViscosity speed timeStep cellWidth)
    ((right - left) / cellWidth)

/-- The actual Richtmyer face flux plus the specified artificial viscosity. -/
noncomputable def leveque04_scalarLWCorrectedFaceFlux
    (speed timeStep cellWidth left right : ℝ) : ℝ :=
  leveque04_scalarLWFaceFlux speed timeStep cellWidth left right +
    leveque04_scalarLWAddedDiffusiveFlux speed timeStep cellWidth left right

/-- The corrected numerical flux at the left interface of cell `i`. -/
noncomputable def leveque04_scalarLWCorrectedInterfaceFlux
    (speed timeStep cellWidth : ℝ) (old : ℤ → ℝ) (i : ℤ) : ℝ :=
  leveque04_scalarLWCorrectedFaceFlux speed timeStep cellWidth
    (old (i - 1)) (old i)

/-- One actual conservative step using the specified corrected interface flux. -/
noncomputable def leveque04_scalarLWCorrectedStep
    (speed timeStep cellWidth : ℝ) (old : ℤ → ℝ) (i : ℤ) : ℝ :=
  conservativeFluxDifferenceUpdateInt (timeStep / cellWidth) old
    (leveque04_scalarLWCorrectedInterfaceFlux speed timeStep cellWidth old) i

end NumStability
