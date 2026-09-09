/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RectangleBalanceTemporalDerivative

/-!
# LeVeque Chapter 1, source terms under the ordinary-density interpretation

The contaminant paragraph on printed page 4 (raw PDF page 26) motivates source
terms when mass changes beyond boundary transport. The coordinator-selected
interpretation uses signed production densities with the explicit iterated
integrability in `IsRectangleBalanceLawSolution`. It excludes singular production
measures and retains the mass-rate identity almost everywhere for each fixed
spatial interval. These choices are not asserted to be explicit in the source.
-/

open MeasureTheory

namespace NumStability

/-- For a scalar contaminant with constant advective speed, the source integral
is exactly the mass change after boundary exchange. Homogeneous conservation
holds precisely when every rectangle source contribution vanishes. The last
clause permits an exceptional time set depending on the fixed spatial interval.
No spatial state derivative or source sign is prescribed. -/
theorem leveque01_sourceTermsRectangleBalance
    {q production : ℝ → ℝ → Fin 1 → ℝ} (speed : ℝ)
    (h : IsRectangleBalanceLawSolution q (fun state => speed • state) production) :
    IsRectangleBalanceLawSolution q (fun state => speed • state) production ∧
    (∀ a b s t,
      (∫ τ in s..t, ∫ x in a..b, production x τ) =
        ((∫ x in a..b, q x t) - (∫ x in a..b, q x s)) -
          (∫ τ in s..t, speed • q a τ - speed • q b τ)) ∧
    (IsRectangleConservationLawSolution q (fun state => speed • state) ↔
      ∀ a b s t, (∫ τ in s..t, ∫ x in a..b, production x τ) = 0) ∧
    (¬ IsRectangleConservationLawSolution q (fun state => speed • state) ↔
      ∃ a b s t, (∫ τ in s..t, ∫ x in a..b, production x τ) ≠ 0) ∧
    (∀ a b, ∀ᵐ t,
      HasDerivAt (fun s => ∫ x in a..b, q x s)
        (speed • q a t - speed • q b t + ∫ x in a..b, production x t) t) :=
  ⟨h, h.integrated_source_eq_mass_defect, h.conservation_iff_source_integrals_zero,
    h.not_conservation_iff_exists_nonzero_source_integral, h.hasDerivAt_mass_ae⟩

end NumStability
