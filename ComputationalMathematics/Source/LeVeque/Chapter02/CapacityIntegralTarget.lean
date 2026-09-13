/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus

/-!
# Capacity conservation from every test section

The conserved density is capacity times state, whereas endpoint flux is
evaluated at the state itself. Actual time derivatives and classical local
regularity make the integral conservation premise meaningful. This proof-free
target retains the general passage from all test sections to the capacity PDE.
-/

open MeasureTheory Set

namespace NumStability.Leveque02Tracer

/-- Weighted integral conservation yields the capacity law throughout a local section. -/
def capacityIntegralTarget : Prop :=
  ∀ (q qt : ℝ → ℝ → ℝ) (capacity flux fluxDerivative : ℝ → ℝ)
    (L R c d t : ℝ), L < R → t ∈ Ioo c d →
    ContinuousOn (fun p : ℝ × ℝ => capacity p.1 * q p.1 p.2)
      (Icc L R ×ˢ Icc c d) →
    ContinuousOn (fun p : ℝ × ℝ => capacity p.1 * qt p.1 p.2)
      (Icc L R ×ˢ Icc c d) →
    (∀ τ ∈ Ioo c d, ∀ x ∈ Icc L R, HasDerivAt (q x) (qt x τ) τ) →
    (∀ x ∈ Icc L R,
      HasDerivWithinAt (fun ξ => flux (q ξ t)) (fluxDerivative x) (Icc L R) x) →
    ContinuousOn fluxDerivative (Icc L R) →
    (∀ a ∈ Icc L R, ∀ b ∈ Icc L R, a ≤ b →
      HasDerivAt (fun τ => ∫ x in a..b, capacity x * q x τ)
        (flux (q a t) - flux (q b t)) t) →
    ∀ x ∈ Icc L R, capacity x * qt x t + fluxDerivative x = 0

end NumStability.Leveque02Tracer
