/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerPredictor
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifferenceResidual

/-!
# Nonlinear Richtmyer flux accuracy foundations

The flux-difference form of the actual two-step Richtmyer method converts
control of neighboring face-flux errors into a normalized local residual.
The face-error condition is stated explicitly for a general physical flux.
-/

namespace NumStability

/-- If neighboring Richtmyer face-flux errors differ by at most a cubic
mesh term, the actual nonlinear finite-volume update has a quadratic
normalized local residual. -/
theorem leveque04_richtmyer_nonlinear_faceDifference_residual
    {m : ℕ} (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (old exactFace exactNext : ℤ → Fin m → ℝ)
    (timeStep width bound : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hexact : ∀ i, exactNext i =
      leveque04_finiteVolumeUpdate timeStep width old exactFace i)
    (hface : ∀ i k,
      let numericalFace := leveque04_localInterfaceFlux
        (leveque04_richtmyerFlux timeStep width physicalFlux) old
      |((numericalFace (i + 1) k - exactFace (i + 1) k) -
          (numericalFace i k - exactFace i k))| ≤
        bound * width ^ 3)
    (i : ℤ) (k : Fin m) :
    let numericalFace := leveque04_localInterfaceFlux
      (leveque04_richtmyerFlux timeStep width physicalFlux) old
    |(leveque04_finiteVolumeUpdate timeStep width old numericalFace i k -
        exactNext i k) / timeStep| ≤ bound * width ^ 2 := by
  dsimp only
  let numericalFace := leveque04_localInterfaceFlux
    (leveque04_richtmyerFlux timeStep width physicalFlux) old
  exact conservativeFluxDifferenceUpdateInt_residual_of_faceDifference
    old exactFace numericalFace exactNext timeStep width bound
    htime hwidth hexact hface i k

end NumStability
