/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference

open MeasureTheory
/-!
# Translation and restriction of rectangle conservation

Spatial translation and restriction of arbitrary nonlinear rectangle conservation laws.
-/

namespace NumStability

theorem IsRectangleConservationLawSolution.spatialShift
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (flux : E → E)
    (hq : IsRectangleConservationLawSolution q flux) (origin : ℝ) :
    IsRectangleConservationLawSolution (fun x t => q (x - origin) t) flux := by
  refine ⟨?_, ?_, ?_⟩
  · intro a b t
    simpa only [sub_add_cancel] using
      (hq.1 (a - origin) (b - origin) t).comp_sub_right origin
  · intro x s t
    exact hq.2.1 (x - origin) s t
  · intro a b s t
    change (∫ x in a..b, q (x - origin) t) -
        (∫ x in a..b, q (x - origin) s) =
      ∫ τ in s..t, flux (q (a - origin) τ) - flux (q (b - origin) τ)
    rw [intervalIntegral.integral_comp_sub_right (f := fun y => q y t) (d := origin),
      intervalIntegral.integral_comp_sub_right (f := fun y => q y s) (d := origin)]
    exact hq.2.2 (a - origin) (b - origin) s t

theorem IsRectangleConservationLawSolution.rectangleReferenceOn
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (hq : IsRectangleConservationLawSolution q flux) (left right horizon : ℝ) :
    LocalConservationLaw.RectangleReferenceOn q flux left right horizon := by
  exact ⟨fun t _ => hq.1 left right t, fun x _ => hq.2.1 x 0 horizon,
    fun a _ b _ s _ t _ => hq.2.2 a b s t⟩

end NumStability
