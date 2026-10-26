/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAFanAssembly
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RectangleAEEq
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface

open MeasureTheory

/-!
# REA two-fan conservation transfer

Spatial front-point values do not affect cell averages. To transport
the rectangle conservation law to the glued nonlinear fan evolution,
the boundary physical flux must also agree almost everywhere in time
at each fixed face.
-/

namespace NumStability

/-- A certified nonlinear conservation-law solution transports to the
variable-speed two-fan gluing when it agrees off moving fronts and has
the same almost-everywhere time trace of physical flux at every face. -/
theorem leveque04_variableTwoFanEvolution_rectangleSolution_of_ae
    {m : ℕ}
    (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (interface : ℤ → ℝ) (i : ℤ)
    (leftSpeed rightSpeed : ℤ → ℝ)
    (background leftProfile rightProfile : ℝ → ℝ → (Fin m → ℝ))
    (q : ℝ → ℝ → (Fin m → ℝ))
    (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    (hoff : ∀ τ x, x ∉ leveque04_variableTwoFanFronts interface i
      leftSpeed rightSpeed τ →
        q x τ = leveque04_variableTwoFanEvolution interface i
          leftSpeed rightSpeed background leftProfile rightProfile x τ)
    (hface : ∀ x : ℝ, ∀ᵐ τ : ℝ ∂volume,
      law.physicalFlux (q x τ) =
        law.physicalFlux (leveque04_variableTwoFanEvolution interface i
          leftSpeed rightSpeed background leftProfile rightProfile x τ)) :
    IsRectangleConservationLawSolution
      (fun x τ => leveque04_variableTwoFanEvolution interface i
        leftSpeed rightSpeed background leftProfile rightProfile x τ)
      law.physicalFlux := by
  apply rectangleSolution_congr_ae q _ law.physicalFlux hq
  · intro τ
    exact leveque04_variableTwoFanEvolution_eq_ae_of_offFronts
      interface i leftSpeed rightSpeed background leftProfile rightProfile
      (fun x => q x τ) τ (hoff τ)
  · exact hface

end NumStability
