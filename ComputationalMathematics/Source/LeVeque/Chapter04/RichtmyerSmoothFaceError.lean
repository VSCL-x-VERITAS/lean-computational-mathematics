/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerNonlinearAccuracy
import ComputationalMathematics.Source.LeVeque.Chapter04.SmoothFaceErrorVariation

/-!
# Smooth face-error transfer for nonlinear Richtmyer

A face-error profile whose spatial derivative is quadratic in the mesh
width has cubic variation between adjacent numerical interfaces. This
is the face premise of the existing nonlinear conservative residual
theorem.
-/

namespace NumStability

/-- A smooth extension of the Richtmyer face error with derivative
bounded by `bound·width²` has cubic adjacent-face variation. -/
theorem leveque04_richtmyer_faceDifference_of_smoothError
    {m : ℕ} (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (old exactFace : ℤ → Fin m → ℝ)
    (error error' : Fin m → ℝ → ℝ)
    (timeStep width bound : ℝ) (hwidth : 0 < width)
    (hsample : ∀ i k,
      let numericalFace := leveque04_localInterfaceFlux
        (leveque04_richtmyerFlux timeStep width physicalFlux) old
      numericalFace i k - exactFace i k =
        error k ((i : ℝ) * width))
    (hderiv : ∀ k x, HasDerivAt (error k) (error' k x) x)
    (hderivBound : ∀ k x, |error' k x| ≤ bound * width ^ 2) :
    ∀ i k,
      let numericalFace := leveque04_localInterfaceFlux
        (leveque04_richtmyerFlux timeStep width physicalFlux) old
      |((numericalFace (i + 1) k - exactFace (i + 1) k) -
          (numericalFace i k - exactFace i k))| ≤
        bound * width ^ 3 := by
  exact leveque04_smoothFaceError_adjacent_bound
    (leveque04_localInterfaceFlux
      (leveque04_richtmyerFlux timeStep width physicalFlux) old)
    exactFace error error' width bound hwidth hsample hderiv hderivBound

/-- The smooth face-error derivative bound discharges the face premise
of the nonlinear Richtmyer normalized local residual theorem. -/
theorem leveque04_richtmyer_nonlinear_smoothFaceError_residual
    {m : ℕ} (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (old exactFace exactNext : ℤ → Fin m → ℝ)
    (error error' : Fin m → ℝ → ℝ)
    (timeStep width bound : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hexact : ∀ i, exactNext i =
      leveque04_finiteVolumeUpdate timeStep width old exactFace i)
    (hsample : ∀ i k,
      let numericalFace := leveque04_localInterfaceFlux
        (leveque04_richtmyerFlux timeStep width physicalFlux) old
      numericalFace i k - exactFace i k =
        error k ((i : ℝ) * width))
    (hderiv : ∀ k x, HasDerivAt (error k) (error' k x) x)
    (hderivBound : ∀ k x, |error' k x| ≤ bound * width ^ 2)
    (i : ℤ) (k : Fin m) :
    let numericalFace := leveque04_localInterfaceFlux
      (leveque04_richtmyerFlux timeStep width physicalFlux) old
    |(leveque04_finiteVolumeUpdate timeStep width old numericalFace i k -
        exactNext i k) / timeStep| ≤ bound * width ^ 2 := by
  exact leveque04_richtmyer_nonlinear_faceDifference_residual
    physicalFlux old exactFace exactNext timeStep width bound
    htime hwidth hexact
    (leveque04_richtmyer_faceDifference_of_smoothError
      physicalFlux old exactFace error error' timeStep width bound
      hwidth hsample hderiv hderivBound) i k

end NumStability
