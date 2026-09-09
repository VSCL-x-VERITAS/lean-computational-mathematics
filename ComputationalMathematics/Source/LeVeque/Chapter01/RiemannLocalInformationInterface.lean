/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRiemannInformationUpdate

/-!
# Chapter 1: local Riemann information and the physical flux

The source contract uses the same law for the ordered Riemann problems and the
physical cell balance. Only the selected cell and time slab require integrability
and conservation. The algorithm can return information without a complete field.
Its specified error is compared with some physically constrained weak Riemann
reference; entropy and uniqueness are not supplied by this introductory passage.
The separately recorded accuracy convention gives conditional bounds, without
an unstated tolerance, order, convergence claim or global solution extension.
-/

open MeasureTheory

namespace NumStability
open LocalRiemannInformation

/-- Source-facing specialization: one physical law, actual ordered numerical inputs,
and only the selected cell and finite time slab. Riemann flux accuracy is a
conditional method specification; no entropy, uniqueness or convergence is claimed. -/
theorem leveque01_localRiemannInformationInterface_sourceContract {m : ℕ} (law : Law m)
    {Result : Problem law → Type*} {Information : Type*}
    (method : Method law Result Information) {Cell Face : Type*}
    (leftCell rightCell : Face → Cell) (old : Cell → Fin m → ℝ)
    (hstates : ∀ cell, old cell ∈ law.states)
    (cell : Cell) (leftFace rightFace : Face)
    (hleftCell : rightCell leftFace = cell) (hrightCell : leftCell rightFace = cell)
    {a b s t : ℝ} (hab : a < b) (hst : s < t)
    (hdomain : ∀ face, method.domain
      (adjacentProblem law leftCell rightCell old hstates (t - s) (sub_pos.mpr hst) face))
    (q : ℝ → ℝ → Fin m → ℝ) (faceLocation : Face → ℝ)
    (hleftLocation : faceLocation leftFace = a) (hrightLocation : faceLocation rightFace = b)
    (holdDensity : IntervalIntegrable (fun x => q x s) volume a b)
    (hnewDensity : IntervalIntegrable (fun x => q x t) volume a b)
    (hleftFlux : IntervalIntegrable (fun τ => law.flux (q a τ)) volume s t)
    (hrightFlux : IntervalIntegrable (fun τ => law.flux (q b τ)) volume s t)
    (hphysicalBalance : (∫ x in a..b, q x t) - (∫ x in a..b, q x s) =
      ∫ τ in s..t, (law.flux (q a τ) - law.flux (q b τ))) :
    let problem := adjacentProblem law leftCell rightCell old hstates (t - s) (sub_pos.mpr hst)
    let numericalFlux := fun face => method.flux (problem face) (hdomain face)
    let next := finiteVolumeCellAverageUpdate (t - s) (b - a) (old cell)
      (numericalFlux rightFace - numericalFlux leftFace)
    0 < m ∧ IsHyperbolicFluxOn law.flux law.states ∧
    (∀ face, (problem face).left = old (leftCell face) ∧
      (problem face).right = old (rightCell face) ∧
      (problem face).duration = t - s ∧
      numericalFlux face = method.numericalFlux
        (method.extract (method.solve (problem face) (hdomain face)))) ∧
    (problem leftFace).right = old cell ∧ (problem rightFace).left = old cell ∧
    (∀ face, old (leftCell face) = old (rightCell face) →
      numericalFlux face = law.flux (old (leftCell face))) ∧
    ∃ (leftReference : Reference (problem leftFace)) (rightReference : Reference (problem rightFace)),
      IsRiemannData (fun x => leftReference.field x 0)
        (old (leftCell leftFace)) (old cell) ∧
      IsRiemannData (fun x => rightReference.field x 0)
        (old cell) (old (rightCell rightFace)) ∧
      IsOneDimensionalCellAverage (fun τ => law.flux (leftReference.field 0 τ)) 0 (t - s)
        leftReference.meanFlux ∧
      IsOneDimensionalCellAverage (fun τ => law.flux (rightReference.field 0 τ)) 0 (t - s)
        rightReference.meanFlux ∧
      ‖numericalFlux leftFace - leftReference.meanFlux‖ ≤ method.errorBound (problem leftFace) ∧
      ‖numericalFlux rightFace - rightReference.meanFlux‖ ≤ method.errorBound (problem rightFace) ∧
      IsOneDimensionalCellAverage (fun x => q x s) a b (oneDimensionalCellAverage (fun x => q x s) a b) ∧
      IsOneDimensionalCellAverage (fun x => q x t) a b (oneDimensionalCellAverage (fun x => q x t) a b) ∧
      oneDimensionalCellAverage (fun x => q x s) a b = cellVolumeAverage volume (Set.Ioc a b) (fun x => q x s) ∧
      next = old cell - ((t - s) / (b - a)) •
        (numericalFlux rightFace - numericalFlux leftFace) ∧
      (b - a) • (next - oneDimensionalCellAverage (fun x => q x t) a b) =
        (b - a) • (old cell - oneDimensionalCellAverage (fun x => q x s) a b) +
        (t - s) • ((numericalFlux leftFace - oneDimensionalCellAverage (fun τ => law.flux (q a τ)) s t) -
          (numericalFlux rightFace - oneDimensionalCellAverage (fun τ => law.flux (q b τ)) s t)) ∧
      ∀ oldBound leftComparison rightComparison : ℝ,
        ‖old cell - oneDimensionalCellAverage (fun x => q x s) a b‖ ≤ oldBound →
        ‖leftReference.meanFlux - oneDimensionalCellAverage (fun τ => law.flux (q a τ)) s t‖ ≤ leftComparison →
        ‖rightReference.meanFlux - oneDimensionalCellAverage (fun τ => law.flux (q b τ)) s t‖ ≤ rightComparison →
        ‖next - oneDimensionalCellAverage (fun x => q x t) a b‖ ≤
          oldBound + (t - s) / (b - a) *
            ((method.errorBound (problem leftFace) + leftComparison) +
              (method.errorBound (problem rightFace) + rightComparison)) := by
  simpa only [hleftLocation, hrightLocation] using
    (LocalRiemannInformation.local_interface_contract law method leftCell rightCell old hstates
      cell leftFace rightFace hleftCell hrightCell hab hst hdomain
      (fun x => q x s) (fun x => q x t) (fun face τ => law.flux (q (faceLocation face) τ))
      holdDensity hnewDensity
      (by simpa only [hleftLocation] using hleftFlux)
      (by simpa only [hrightLocation] using hrightFlux)
      (by simpa only [hleftLocation, hrightLocation] using hphysicalBalance))

end NumStability