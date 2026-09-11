/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.SectionMass

/-!
# LeVeque Chapter 2, Equation (2.1)

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 2,
printed page 15 (raw PDF page 37), equation (2.1).

The printed text writes the integral of the tracer density over `[x₁, x₂]` and
says it *represents the total mass of the tracer in the section of pipe between
`x₁` and `x₂` at the particular time `t`*.

The claim is therefore not an equation between two given quantities; it is the
assertion that this integral may be read as a mass.  What is formalized here is
exactly that reading: the quantity is degenerate on an empty section, reverses
with orientation, is additive over adjacent sections, is local to the section,
and is nonnegative and monotone in the density.  A final theorem gives the
converse, that a continuous density is recovered from the masses it assigns, so
nothing is lost in passing between the two descriptions.

Integrability is a hypothesis of the additivity and monotonicity clauses rather
than a standing assumption, matching the printed text's silence about the
regularity of `q` at this point in the chapter.
-/

open MeasureTheory
open scoped Interval

namespace NumStability

/-- Equation (2.1): the total mass of tracer in the section of pipe between
`x₁` and `x₂` at time `t`. -/
noncomputable def leveque02Equation01SectionMass
    (q : ℝ → ℝ → ℝ) (x₁ x₂ t : ℝ) : ℝ :=
  sectionMass (fun x => q x t) x₁ x₂

theorem leveque02_equation01_eq_intervalIntegral
    (q : ℝ → ℝ → ℝ) (x₁ x₂ t : ℝ) :
    leveque02Equation01SectionMass q x₁ x₂ t = ∫ x in x₁..x₂, q x t := rfl

/-- The printed reading of (2.1): the integral of the density over a section
behaves in every respect as the mass contained in that section. -/
theorem leveque02_equation01_totalMass (q : ℝ → ℝ → ℝ) (t : ℝ) :
    (∀ x₁ : ℝ, leveque02Equation01SectionMass q x₁ x₁ t = 0)
      ∧ (∀ x₁ x₂ : ℝ, leveque02Equation01SectionMass q x₁ x₂ t
            = -leveque02Equation01SectionMass q x₂ x₁ t)
      ∧ (∀ x₁ x₂ x₃ : ℝ,
            IntervalIntegrable (fun x => q x t) volume x₁ x₂ →
            IntervalIntegrable (fun x => q x t) volume x₂ x₃ →
            leveque02Equation01SectionMass q x₁ x₂ t
                + leveque02Equation01SectionMass q x₂ x₃ t
              = leveque02Equation01SectionMass q x₁ x₃ t)
      ∧ (∀ (r : ℝ → ℝ → ℝ) (x₁ x₂ : ℝ),
            Set.EqOn (fun x => q x t) (fun x => r x t) (Set.uIcc x₁ x₂) →
            leveque02Equation01SectionMass q x₁ x₂ t
              = leveque02Equation01SectionMass r x₁ x₂ t)
      ∧ (∀ x₁ x₂ : ℝ, x₁ ≤ x₂ → (∀ x ∈ Set.Icc x₁ x₂, 0 ≤ q x t) →
            0 ≤ leveque02Equation01SectionMass q x₁ x₂ t)
      ∧ (∀ (r : ℝ → ℝ → ℝ) (x₁ x₂ : ℝ), x₁ ≤ x₂ →
            IntervalIntegrable (fun x => q x t) volume x₁ x₂ →
            IntervalIntegrable (fun x => r x t) volume x₁ x₂ →
            (∀ x ∈ Set.Icc x₁ x₂, q x t ≤ r x t) →
            leveque02Equation01SectionMass q x₁ x₂ t
              ≤ leveque02Equation01SectionMass r x₁ x₂ t) :=
  ⟨fun x₁ => sectionMass_self _ x₁,
   fun x₁ x₂ => sectionMass_symm _ x₁ x₂,
   fun _ _ _ hab hbc => sectionMass_add_adjacent hab hbc,
   fun _ _ _ hEqOn => sectionMass_congr hEqOn,
   fun _ _ hle hnonneg => sectionMass_nonneg hle hnonneg,
   fun _ _ _ hle hq hr hmono => sectionMass_mono hle hq hr hmono⟩

/-- The converse reading: at a fixed time a continuous density is determined by
the masses (2.1) assigns to sections. -/
theorem leveque02_equation01_density_determined
    {q r : ℝ → ℝ → ℝ} {t : ℝ}
    (hq : Continuous fun x => q x t) (hr : Continuous fun x => r x t)
    (hmass : ∀ x₁ x₂ : ℝ,
      leveque02Equation01SectionMass q x₁ x₂ t
        = leveque02Equation01SectionMass r x₁ x₂ t) :
    ∀ x, q x t = r x t :=
  fun x => congrFun (eq_of_sectionMass_eq hq hr hmass) x

end NumStability
