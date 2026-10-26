/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerNonlinearFaceDerivative

/-!
# Scalar nonlinear Richtmyer residual from the actual face derivative

The continuous neighboring-state profiles interpolate the two cell
averages passed to the actual numerical flux at every integer face.
An explicit bound on its chain-rule derivative relative to the exact
face-flux derivative gives a second-order normalized local residual.
-/

namespace NumStability

/-- The actual scalar nonlinear Richtmyer update has a quadratic
normalized local residual when its computed face-flux derivative differs
from the exact face-flux derivative by at most `bound·width²`. -/
theorem leveque04_richtmyerScalar_smoothFaceDerivative_residual
    (flux flux' leftProfile rightProfile left' right'
      exactFlux exactFlux' : ℝ → ℝ)
    (old exactFace exactNext : ℤ → Fin 1 → ℝ)
    (timeStep width bound : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hleftSample : ∀ j : ℤ,
      old (j - 1) 0 = leftProfile ((j : ℝ) * width))
    (hrightSample : ∀ j : ℤ,
      old j 0 = rightProfile ((j : ℝ) * width))
    (hexactFace : ∀ j : ℤ,
      exactFace j 0 = exactFlux ((j : ℝ) * width))
    (hleft : ∀ x, HasDerivAt leftProfile (left' x) x)
    (hright : ∀ x, HasDerivAt rightProfile (right' x) x)
    (hflux : ∀ z, HasDerivAt flux (flux' z) z)
    (hexactFlux : ∀ x, HasDerivAt exactFlux (exactFlux' x) x)
    (hformulaBound : ∀ x,
      |flux' (leveque04_richtmyerPredictor timeStep width
          (fun state (_ : Fin 1) => flux (state 0))
          (fun _ => leftProfile x) (fun _ => rightProfile x) 0) *
        ((left' x + right' x) / 2 -
          timeStep / (2 * width) *
            (flux' (rightProfile x) * right' x -
              flux' (leftProfile x) * left' x)) -
        exactFlux' x| ≤ bound * width ^ 2)
    (hexact : ∀ i, exactNext i =
      leveque04_finiteVolumeUpdate timeStep width old exactFace i)
    (i : ℤ) :
    let physicalFlux : (Fin 1 → ℝ) → Fin 1 → ℝ :=
      fun state _ => flux (state 0)
    let numericalFace := leveque04_localInterfaceFlux
      (leveque04_richtmyerFlux timeStep width physicalFlux) old
    |(leveque04_finiteVolumeUpdate timeStep width old numericalFace i 0 -
        exactNext i 0) / timeStep| ≤ bound * width ^ 2 := by
  dsimp only
  let physicalFlux : (Fin 1 → ℝ) → Fin 1 → ℝ :=
    fun state _ => flux (state 0)
  let error : ℝ → ℝ := fun x =>
    leveque04_richtmyerFlux timeStep width physicalFlux
      (fun _ => leftProfile x) (fun _ => rightProfile x) 0 - exactFlux x
  let error' : ℝ → ℝ := fun x =>
    flux' (leveque04_richtmyerPredictor timeStep width physicalFlux
      (fun _ => leftProfile x) (fun _ => rightProfile x) 0) *
      ((left' x + right' x) / 2 -
        timeStep / (2 * width) *
          (flux' (rightProfile x) * right' x -
            flux' (leftProfile x) * left' x)) - exactFlux' x
  have hsample (j : ℤ) :
      leveque04_localInterfaceFlux
          (leveque04_richtmyerFlux timeStep width physicalFlux)
          old j 0 - exactFace j 0 = error ((j : ℝ) * width) := by
    have hl : old (j - 1) = fun _ : Fin 1 =>
        leftProfile ((j : ℝ) * width) := by
      funext p
      fin_cases p
      exact hleftSample j
    have hr : old j = fun _ : Fin 1 =>
        rightProfile ((j : ℝ) * width) := by
      funext p
      fin_cases p
      exact hrightSample j
    simp only [leveque04_localInterfaceFlux, hl, hr,
      hexactFace j, error]
  have hderiv (x : ℝ) : HasDerivAt error (error' x) x := by
    exact (leveque04_richtmyerScalarFlux_hasDerivAt
      flux flux' leftProfile rightProfile left' right'
      timeStep width x (hleft x) (hright x) hflux).sub
        (hexactFlux x)
  have hbound (x : ℝ) : |error' x| ≤ bound * width ^ 2 :=
    hformulaBound x
  have hface := leveque04_smoothFaceError_adjacent_bound
    (leveque04_localInterfaceFlux
      (leveque04_richtmyerFlux timeStep width physicalFlux) old)
    exactFace (fun _ => error) (fun _ => error')
    width bound hwidth
    (by intro j k; fin_cases k; exact hsample j)
    (by intro k x; fin_cases k; exact hderiv x)
    (by intro k x; fin_cases k; exact hbound x)
  exact leveque04_richtmyer_nonlinear_faceDifference_residual
    physicalFlux old exactFace exactNext timeStep width bound
    htime hwidth hexact hface i 0

end NumStability
