/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Fin.VecNotation
import Mathlib.Data.Real.Basic

/-!
# Euler Vectors Target

The three conserved components of the one-dimensional gas system.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

namespace NumStability.Eymard.Chapter01

/-- The three conserved components of the one-dimensional gas system. -/
noncomputable def eulerConservedVector (density velocity energy : ℝ) : Fin 3 → ℝ :=
  ![density, density * velocity, energy]

/-- The corresponding three flux components, with pressure supplied by the
particular gas. This definition makes no equation-of-state or PDE assertion. -/
noncomputable def eulerFluxVector (density velocity energy pressure : ℝ) : Fin 3 → ℝ :=
  ![density * velocity, density * velocity ^ 2 + pressure, velocity * (energy + pressure)]

/-- Example 2.1's complete vector assignments, applied to supplied scalar fields
on an arbitrary space-time region. The three coordinates index equations; there
is one spatial coordinate. The manuscript supplies no source term in this display. -/
def eulerVectorsTarget : Prop :=
  ∀ (region : Set (ℝ × ℝ)) (density velocity energy pressure : ℝ → ℝ → ℝ)
    (x t : ℝ), (x, t) ∈ region →
    let q := eulerConservedVector (density x t) (velocity x t) (energy x t)
    let F := eulerFluxVector (density x t) (velocity x t) (energy x t) (pressure x t)
    q 0 = density x t ∧ q 1 = density x t * velocity x t ∧ q 2 = energy x t ∧
      F 0 = density x t * velocity x t ∧
      F 1 = density x t * velocity x t ^ 2 + pressure x t ∧
      F 2 = velocity x t * (energy x t + pressure x t)

end NumStability.Eymard.Chapter01
