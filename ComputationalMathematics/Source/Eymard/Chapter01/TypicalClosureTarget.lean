/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.Eymard.Chapter01.GeneralLawTarget

/-!
# Typical Closure Target

Section 2's optional constitutive forms for a scalar unknown or a finite
nonempty real vector unknown. Model maps are fixed before the unknown. The
flux constructor selects value-only, gradient-only or combined dependence.
The time derivative differentiates the composite `qbar(x,t,u(x,t))`.
The source and conserved quantity have no gradient argument in this selected
typical interface. The interface implements the displayed options; the source
hedges do not classify all possible constitutive laws. No relation
between the number of unknown components and a scalar equation is imposed.
Transport/diffusion identifications and their separate source issues are not
silently resolved by this definition.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

namespace NumStability.Eymard.Chapter01

open NumStability.FiniteVolume.CoordinateBalance

/-- Section 2's optional constitutive forms for a scalar unknown or a finite
nonempty real vector unknown. Model maps are fixed before the unknown. The
flux constructor selects value-only, gradient-only or combined dependence.
The time derivative differentiates the composite `qbar(x,t,u(x,t))`.
The source and conserved quantity have no gradient argument in this selected
typical interface. The interface implements the displayed options; the source
hedges do not classify all possible constitutive laws. No relation
between the number of unknown components and a scalar equation is imposed.
Transport/diffusion identifications and their separate source issues are not
silently resolved by this definition. -/
def typicalClosureTarget : Prop :=
  (∀ d, IsSourceDimension d → ∀ (C : TypicalConstitutiveData d ℝ)
    (R : Set (Point d × ℝ)) (u : Point d → ℝ → ℝ), ClosureFormula C R u) ∧
  (∀ d, IsSourceDimension d → ∀ m : ℕ, 0 < m →
    ∀ (C : TypicalConstitutiveData d (Fin m → ℝ))
      (R : Set (Point d × ℝ)) (u : Point d → ℝ → Fin m → ℝ),
      ClosureFormula C R u)

end NumStability.Eymard.Chapter01
