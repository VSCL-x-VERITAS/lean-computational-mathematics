/- Draft of a local-time, admissible-state numerical Riemann contract. -/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalCellErrorBounds
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage

open MeasureTheory

namespace ScopedRiemannInformationDraft
open NumStability

/-- The physical law is classified only at its explicitly admissible states. -/
structure Law (m : ℕ) where
  positive_dimension : 0 < m
  states : Set (Fin m → ℝ)
  flux : (Fin m → ℝ) → Fin m → ℝ
  hyperbolic : IsHyperbolicFluxOn flux states

/-- Ordered admissible states and the actual positive time horizon. -/
structure Problem {m : ℕ} (law : Law m) where
  left : Fin m → ℝ
  right : Fin m → ℝ
  left_mem : left ∈ law.states
  right_mem : right ∈ law.states
  duration : ℝ
  duration_pos : 0 < duration

/-- An independent physical Riemann reference on the selected finite time slab.
The numerical result type does not contain this field. Values after the horizon
are irrelevant; the initial interface value is left unspecified. -/
structure Reference {m : ℕ} {law : Law m} (problem : Problem law) where
  field : ℝ → ℝ → Fin m → ℝ
  initial : IsRiemannData (fun x => field x 0) problem.left problem.right
  admissible : ∀ x τ, 0 < τ → τ ≤ problem.duration → field x τ ∈ law.states
  spatial_integrable : ∀ a b τ, 0 ≤ τ → τ ≤ problem.duration →
    IntervalIntegrable (fun x => field x τ) volume a b
  face_integrable : ∀ x s t, 0 ≤ s → s ≤ t → t ≤ problem.duration →
    IntervalIntegrable (fun τ => law.flux (field x τ)) volume s t
  rectangle : ∀ a b s t, 0 ≤ s → s ≤ t → t ≤ problem.duration →
    (∫ x in a..b, field x t) - (∫ x in a..b, field x s) =
      ∫ τ in s..t, (law.flux (field a τ) - law.flux (field b τ))

noncomputable def Reference.meanFlux {m : ℕ} {law : Law m} {problem : Problem law}
    (reference : Reference problem) : Fin m → ℝ :=
  oneDimensionalCellAverage (fun τ => law.flux (reference.field 0 τ)) 0 problem.duration

/-- A procedure may return arbitrary dependent information. Its approximation
contract compares the resulting flux with an independent physical solution of
the same ordered problem over the same time interval. This existential proof
does not require the numerical procedure to construct or return that solution.
No nonconstant accuracy or solution existence is inferred from consistency. -/
structure Method {m : ℕ} (law : Law m)
    (Result : Problem law → Type*) (Information : Type*) where
  domain : Problem law → Prop
  solve : (problem : Problem law) → domain problem → Result problem
  extract : {problem : Problem law} → Result problem → Information
  numericalFlux : Information → Fin m → ℝ
  errorBound : Problem law → ℝ
  accurate : ∀ problem hdomain, ∃ reference : Reference problem,
    ‖numericalFlux (extract (solve problem hdomain)) - reference.meanFlux‖ ≤ errorBound problem
  consistent : ∀ problem hdomain, problem.left = problem.right →
    numericalFlux (extract (solve problem hdomain)) = law.flux problem.left

noncomputable def Method.flux {m : ℕ} {law : Law m}
    {Result : Problem law → Type*} {Information : Type*}
    (method : Method law Result Information) (problem : Problem law) (hdomain : method.domain problem) :
    Fin m → ℝ := method.numericalFlux (method.extract (method.solve problem hdomain))

/-- The quantitative comparison refers to a physical solution of the same
nonconstant or constant input problem, not to an unconstrained result certificate. -/
theorem Method.reference_comparison {m : ℕ} {law : Law m}
    {Result : Problem law → Type*} {Information : Type*}
    (method : Method law Result Information) (problem : Problem law) (hdomain : method.domain problem) :
    ∃ reference : Reference problem,
      IsRiemannData (fun x => reference.field x 0) problem.left problem.right ∧
      IsOneDimensionalCellAverage (fun τ => law.flux (reference.field 0 τ)) 0 problem.duration
        reference.meanFlux ∧
      0 ≤ method.errorBound problem ∧
      ‖method.flux problem hdomain - reference.meanFlux‖ ≤ method.errorBound problem ∧
      ∀ physicalMean : Fin m → ℝ, ∀ comparisonBound : ℝ,
        ‖reference.meanFlux - physicalMean‖ ≤ comparisonBound →
        ‖method.flux problem hdomain - physicalMean‖ ≤
          method.errorBound problem + comparisonBound := by
  obtain ⟨reference, herror⟩ := method.accurate problem hdomain
  refine ⟨reference, reference.initial,
    oneDimensionalCellAverage_isCellAverage _ problem.duration_pos
      (reference.face_integrable 0 0 problem.duration le_rfl problem.duration_pos.le le_rfl),
    (norm_nonneg _).trans herror, herror, ?_⟩
  intro physicalMean comparisonBound hcomparison
  calc
    ‖method.flux problem hdomain - physicalMean‖ =
        ‖(method.flux problem hdomain - reference.meanFlux) +
          (reference.meanFlux - physicalMean)‖ := by congr 1; module
    _ ≤ ‖method.flux problem hdomain - reference.meanFlux‖ +
        ‖reference.meanFlux - physicalMean‖ := norm_add_le _ _
    _ ≤ method.errorBound problem + comparisonBound := add_le_add herror hcomparison

end ScopedRiemannInformationDraft

#check ScopedRiemannInformationDraft.Method.reference_comparison
#print axioms ScopedRiemannInformationDraft.Method.reference_comparison

namespace ScopedRiemannInformationDraft
open NumStability

def adjacentProblem {m : ℕ} (law : Law m) {Cell Face : Type*}
    (leftCell rightCell : Face → Cell) (old : Cell → Fin m → ℝ)
    (hstates : ∀ cell, old cell ∈ law.states) (duration : ℝ) (hduration : 0 < duration)
    (face : Face) : Problem law where
  left := old (leftCell face)
  right := old (rightCell face)
  left_mem := hstates _
  right_mem := hstates _
  duration := duration
  duration_pos := hduration

/-- Selected outputs solve the same ordered admissible problems up to their
supplied flux-error certificates. The physical cell comparison is local in
space and time and keeps Riemann-reference error separate from interaction
with the independent physical cell reference. -/
theorem local_interface_contract {m : ℕ} (law : Law m)
    {Result : Problem law → Type*} {Information : Type*}
    (method : Method law Result Information) {Cell Face : Type*}
    (leftCell rightCell : Face → Cell) (old : Cell → Fin m → ℝ)
    (hstates : ∀ cell, old cell ∈ law.states)
    (cell : Cell) (leftFace rightFace : Face)
    (hleftCell : rightCell leftFace = cell) (hrightCell : leftCell rightFace = cell)
    {a b s t : ℝ} (hab : a < b) (hst : s < t)
    (hdomain : ∀ face, method.domain
      (adjacentProblem law leftCell rightCell old hstates (t - s) (sub_pos.mpr hst) face))
    (oldDensity newDensity : ℝ → Fin m → ℝ) (physicalFlux : Face → ℝ → Fin m → ℝ)
    (holdDensity : IntervalIntegrable oldDensity volume a b)
    (hnewDensity : IntervalIntegrable newDensity volume a b)
    (hleftFlux : IntervalIntegrable (physicalFlux leftFace) volume s t)
    (hrightFlux : IntervalIntegrable (physicalFlux rightFace) volume s t)
    (hphysicalBalance : (∫ x in a..b, newDensity x) - (∫ x in a..b, oldDensity x) =
      ∫ τ in s..t, (physicalFlux leftFace τ - physicalFlux rightFace τ)) :
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
      IsOneDimensionalCellAverage oldDensity a b (oneDimensionalCellAverage oldDensity a b) ∧
      IsOneDimensionalCellAverage newDensity a b (oneDimensionalCellAverage newDensity a b) ∧
      oneDimensionalCellAverage oldDensity a b = cellVolumeAverage volume (Set.Ioc a b) oldDensity ∧
      next = old cell - ((t - s) / (b - a)) •
        (numericalFlux rightFace - numericalFlux leftFace) ∧
      (b - a) • (next - oneDimensionalCellAverage newDensity a b) =
        (b - a) • (old cell - oneDimensionalCellAverage oldDensity a b) +
        (t - s) • ((numericalFlux leftFace - oneDimensionalCellAverage (physicalFlux leftFace) s t) -
          (numericalFlux rightFace - oneDimensionalCellAverage (physicalFlux rightFace) s t)) ∧
      ∀ oldBound leftComparison rightComparison : ℝ,
        ‖old cell - oneDimensionalCellAverage oldDensity a b‖ ≤ oldBound →
        ‖leftReference.meanFlux - oneDimensionalCellAverage (physicalFlux leftFace) s t‖ ≤ leftComparison →
        ‖rightReference.meanFlux - oneDimensionalCellAverage (physicalFlux rightFace) s t‖ ≤ rightComparison →
        ‖next - oneDimensionalCellAverage newDensity a b‖ ≤
          oldBound + (t - s) / (b - a) *
            ((method.errorBound (problem leftFace) + leftComparison) +
              (method.errorBound (problem rightFace) + rightComparison)) := by
  dsimp only
  let problem := adjacentProblem law leftCell rightCell old hstates (t - s) (sub_pos.mpr hst)
  let numericalFlux := fun face => method.flux (problem face) (hdomain face)
  have hfv := finiteVolumeLocalCell_error_contract oldDensity newDensity physicalFlux old
    (fun _ => numericalFlux) cell leftFace rightFace hab hst holdDensity hnewDensity
    hleftFlux hrightFlux hphysicalBalance
  obtain ⟨leftReference, hleftInitial, hleftMean, _, hleftError, hleftComparison⟩ :=
    method.reference_comparison (problem leftFace) (hdomain leftFace)
  obtain ⟨rightReference, hrightInitial, hrightMean, _, hrightError, hrightComparison⟩ :=
    method.reference_comparison (problem rightFace) (hdomain rightFace)
  refine ⟨law.positive_dimension, law.hyperbolic, ?_, ?_, ?_, ?_,
    leftReference, rightReference, ?_, ?_, hleftMean, hrightMean,
    hleftError, hrightError, hfv.1, hfv.2.1, hfv.2.2.2.2.1,
    hfv.2.2.2.2.2.2.1, hfv.2.2.2.2.2.2.2.1, ?_⟩
  · intro face
    exact ⟨rfl, rfl, rfl, rfl⟩
  · exact congrArg old hleftCell
  · exact congrArg old hrightCell
  · intro face hequal
    exact method.consistent (problem face) (hdomain face) hequal
  · simpa only [problem, adjacentProblem, hleftCell] using hleftInitial
  · simpa only [problem, adjacentProblem, hrightCell] using hrightInitial
  · intro oldBound leftComparison rightComparison hold hleft hright
    exact hfv.2.2.2.2.2.2.2.2 oldBound
      (method.errorBound (problem leftFace) + leftComparison)
      (method.errorBound (problem rightFace) + rightComparison) hold
      (hleftComparison _ _ hleft) (hrightComparison _ _ hright)

end ScopedRiemannInformationDraft

#check ScopedRiemannInformationDraft.local_interface_contract
#print axioms ScopedRiemannInformationDraft.local_interface_contract
