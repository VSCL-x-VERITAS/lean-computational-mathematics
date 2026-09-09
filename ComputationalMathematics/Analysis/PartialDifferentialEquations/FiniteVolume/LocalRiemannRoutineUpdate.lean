/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalCellErrorBounds
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRiemannRoutine

/-!
# Local finite-volume updates from arbitrary information routines

Only the two selected face problems must be in the routine's execution domain.
Independent bounds against physical time-averaged face fluxes directly control
the update. A separate conditional clause permits a same-problem Riemann
reference comparison, without requiring such references for routine execution
or for the direct physical error estimate. Exact consistency is not assumed.
-/

open MeasureTheory

namespace NumStability.LocalRiemannInformation
open NumStability

theorem routine_local_interface_contract {m : ℕ} (law : Law m)
    {Result : Problem law → Type*} {Information : Type*}
    (routine : Routine law Result Information)
    (left center right : Fin m → ℝ)
    (hleftState : left ∈ law.states) (hcenterState : center ∈ law.states)
    (hrightState : right ∈ law.states)
    {a b s t : ℝ} (hab : a < b) (hst : s < t)
    (hleftDomain : routine.domain
      ⟨left, center, hleftState, hcenterState, t - s, sub_pos.mpr hst⟩)
    (hrightDomain : routine.domain
      ⟨center, right, hcenterState, hrightState, t - s, sub_pos.mpr hst⟩)
    (oldDensity newDensity : ℝ → Fin m → ℝ)
    (leftPhysicalFlux rightPhysicalFlux : ℝ → Fin m → ℝ)
    (holdDensity : IntervalIntegrable oldDensity volume a b)
    (hnewDensity : IntervalIntegrable newDensity volume a b)
    (hleftFlux : IntervalIntegrable leftPhysicalFlux volume s t)
    (hrightFlux : IntervalIntegrable rightPhysicalFlux volume s t)
    (hphysicalBalance : (∫ x in a..b, newDensity x) - (∫ x in a..b, oldDensity x) =
      ∫ τ in s..t, (leftPhysicalFlux τ - rightPhysicalFlux τ)) :
    let leftProblem : Problem law := ⟨left, center, hleftState, hcenterState, t - s, sub_pos.mpr hst⟩
    let rightProblem : Problem law := ⟨center, right, hcenterState, hrightState, t - s, sub_pos.mpr hst⟩
    let leftFlux := routine.flux leftProblem hleftDomain
    let rightFlux := routine.flux rightProblem hrightDomain
    let next := finiteVolumeCellAverageUpdate (t - s) (b - a) center (rightFlux - leftFlux)
    0 < m ∧ IsHyperbolicFluxOn law.flux law.states ∧
    leftProblem.left = left ∧ leftProblem.right = center ∧
    rightProblem.left = center ∧ rightProblem.right = right ∧
    leftProblem.duration = t - s ∧ rightProblem.duration = t - s ∧
    leftFlux = routine.numericalFlux (routine.extract (routine.solve leftProblem hleftDomain)) ∧
    rightFlux = routine.numericalFlux (routine.extract (routine.solve rightProblem hrightDomain)) ∧
    IsOneDimensionalCellAverage oldDensity a b (oneDimensionalCellAverage oldDensity a b) ∧
    IsOneDimensionalCellAverage newDensity a b (oneDimensionalCellAverage newDensity a b) ∧
    IsOneDimensionalCellAverage leftPhysicalFlux s t
      (oneDimensionalCellAverage leftPhysicalFlux s t) ∧
    IsOneDimensionalCellAverage rightPhysicalFlux s t
      (oneDimensionalCellAverage rightPhysicalFlux s t) ∧
    oneDimensionalCellAverage oldDensity a b = cellVolumeAverage volume (Set.Ioc a b) oldDensity ∧
    next = center - ((t - s) / (b - a)) • (rightFlux - leftFlux) ∧
    (b - a) • (next - oneDimensionalCellAverage newDensity a b) =
      (b - a) • (center - oneDimensionalCellAverage oldDensity a b) +
        (t - s) • ((leftFlux - oneDimensionalCellAverage leftPhysicalFlux s t) -
          (rightFlux - oneDimensionalCellAverage rightPhysicalFlux s t)) ∧
    (∀ oldBound leftBound rightBound : ℝ,
      ‖center - oneDimensionalCellAverage oldDensity a b‖ ≤ oldBound →
      ‖leftFlux - oneDimensionalCellAverage leftPhysicalFlux s t‖ ≤ leftBound →
      ‖rightFlux - oneDimensionalCellAverage rightPhysicalFlux s t‖ ≤ rightBound →
      ‖next - oneDimensionalCellAverage newDensity a b‖ ≤
        oldBound + (t - s) / (b - a) * (leftBound + rightBound)) ∧
    (∀ (leftReference : Reference leftProblem) (rightReference : Reference rightProblem)
        (leftSolverBound rightSolverBound : ℝ),
      ‖leftFlux - leftReference.meanFlux‖ ≤ leftSolverBound →
      ‖rightFlux - rightReference.meanFlux‖ ≤ rightSolverBound →
      IsRiemannData (fun x => leftReference.field x 0) left center ∧
      IsRiemannData (fun x => rightReference.field x 0) center right ∧
      IsOneDimensionalCellAverage (fun τ => law.flux (leftReference.field 0 τ)) 0 (t - s)
        leftReference.meanFlux ∧
      IsOneDimensionalCellAverage (fun τ => law.flux (rightReference.field 0 τ)) 0 (t - s)
        rightReference.meanFlux ∧
      ∀ oldBound leftComparison rightComparison : ℝ,
        ‖center - oneDimensionalCellAverage oldDensity a b‖ ≤ oldBound →
        ‖leftReference.meanFlux - oneDimensionalCellAverage leftPhysicalFlux s t‖ ≤ leftComparison →
        ‖rightReference.meanFlux - oneDimensionalCellAverage rightPhysicalFlux s t‖ ≤ rightComparison →
        ‖next - oneDimensionalCellAverage newDensity a b‖ ≤
          oldBound + (t - s) / (b - a) *
            ((leftSolverBound + leftComparison) + (rightSolverBound + rightComparison))) := by
  dsimp only
  let leftProblem : Problem law := ⟨left, center, hleftState, hcenterState, t - s, sub_pos.mpr hst⟩
  let rightProblem : Problem law := ⟨center, right, hcenterState, hrightState, t - s, sub_pos.mpr hst⟩
  let leftFlux := routine.flux leftProblem hleftDomain
  let rightFlux := routine.flux rightProblem hrightDomain
  have hfv := finiteVolumeLocalCell_error_contract oldDensity newDensity
    (fun side : Bool => if side then rightPhysicalFlux else leftPhysicalFlux)
    (fun _ : Unit => center) (fun _ side => if side then rightFlux else leftFlux)
    () false true hab hst holdDensity hnewDensity hleftFlux hrightFlux hphysicalBalance
  refine ⟨law.positive_dimension, law.hyperbolic, rfl, rfl, rfl, rfl, rfl, rfl,
    rfl, rfl, hfv.1, hfv.2.1, hfv.2.2.1, hfv.2.2.2.1,
    hfv.2.2.2.2.1, hfv.2.2.2.2.2.2.1, hfv.2.2.2.2.2.2.2.1,
    hfv.2.2.2.2.2.2.2.2, ?_⟩
  intro leftReference rightReference leftSolverBound rightSolverBound hleftError hrightError
  obtain ⟨hleftInitial, hleftMean, hleftComparison⟩ :=
    routine.reference_comparison leftProblem hleftDomain leftReference hleftError
  obtain ⟨hrightInitial, hrightMean, hrightComparison⟩ :=
    routine.reference_comparison rightProblem hrightDomain rightReference hrightError
  refine ⟨hleftInitial, hrightInitial, hleftMean, hrightMean, ?_⟩
  intro oldBound leftComparison rightComparison hold hleft hright
  exact hfv.2.2.2.2.2.2.2.2 oldBound
    (leftSolverBound + leftComparison) (rightSolverBound + rightComparison)
    hold (hleftComparison _ _ hleft) (hrightComparison _ _ hright)

end NumStability.LocalRiemannInformation
