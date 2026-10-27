/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# Constitutive Laws Target

An entropy-fixed slice of a supplied partial internal-energy law. The value
outside its domain is immaterial at the locally covered points used below.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

namespace NumStability.Eymard.Chapter01

/-- An entropy-fixed slice of a supplied partial internal-energy law. The value
outside its domain is immaterial at the locally covered points used below. -/
noncomputable def thermodynamicSlice (A : Set (ℝ × ℝ)) (epsilon : A → ℝ)
    (entropy tau : ℝ) : ℝ := by
  classical
  exact if h : (tau, entropy) ∈ A then epsilon ⟨(tau, entropy), h⟩ else 0

/-- Applicability of the reciprocal density and ordinary first partial
derivative, without requiring joint differentiability or a global gas law. -/
def IsConstitutiveState (A : Set (ℝ × ℝ)) (epsilon : A → ℝ)
    (density entropy : ℝ) : Prop :=
  density ≠ 0 ∧ (1 / density, entropy) ∈ A ∧
    (∀ᶠ tau in nhds (1 / density), (tau, entropy) ∈ A) ∧
      DifferentiableAt ℝ (thermodynamicSlice A epsilon entropy) (1 / density)

/-- The pressure prescription with the positive partial-derivative sign printed
in Example 2.1 of the January 2019 manuscript. -/
noncomputable def constitutivePressure (A : Set (ℝ × ℝ)) (epsilon : A → ℝ)
    (density entropy : ℝ) : ℝ :=
  deriv (thermodynamicSlice A epsilon entropy) (1 / density)

/-- Total energy from the same supplied internal-energy law and scalar velocity. -/
noncomputable def constitutiveEnergy (A : Set (ℝ × ℝ)) (epsilon : A → ℝ)
    (density velocity entropy : ℝ) : ℝ :=
  density * (thermodynamicSlice A epsilon entropy (1 / density) + velocity ^ 2 / 2)

/-- The complete pointwise constitutive application to supplied one-dimensional
flow fields. This prescribes pressure and energy and makes no solver assertion. -/
def constitutiveLawsTarget : Prop :=
  ∀ (A : Set (ℝ × ℝ)) (epsilon : A → ℝ) (region : Set (ℝ × ℝ))
    (density velocity entropy : ℝ → ℝ → ℝ),
    (∀ x t, (x, t) ∈ region → IsConstitutiveState A epsilon (density x t) (entropy x t)) →
      ∀ x t, (x, t) ∈ region →
        HasDerivAt (thermodynamicSlice A epsilon (entropy x t))
            (constitutivePressure A epsilon (density x t) (entropy x t)) (1 / density x t) ∧
          ∃ h : (1 / density x t, entropy x t) ∈ A,
            constitutiveEnergy A epsilon (density x t) (velocity x t) (entropy x t) =
              density x t * (epsilon ⟨(1 / density x t, entropy x t), h⟩ +
                velocity x t ^ 2 / 2)

end NumStability.Eymard.Chapter01
