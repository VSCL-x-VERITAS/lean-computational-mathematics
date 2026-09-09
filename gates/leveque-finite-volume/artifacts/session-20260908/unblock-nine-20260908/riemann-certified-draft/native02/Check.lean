import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRiemannRoutineUpdate
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.BiasedLocalRiemannRoutine
open MeasureTheory
namespace NumStability.LocalRiemannInformation

/-- Each admitted execution approximates the interface mean flux of some
physical reference for that same ordered Riemann problem and time horizon.
The reference is a proof witness; it need not be returned by the routine.
Exact equal-state consistency is a separate property. -/
def Routine.HasRiemannAccuracy {m : ℕ} {law : Law m}
    {Result : Problem law → Type*} {Information : Type*}
    (routine : Routine law Result Information) (errorBound : Problem law → ℝ) : Prop :=
  ∀ problem admitted, ∃ reference : Reference problem,
    ‖routine.flux problem admitted - reference.meanFlux‖ ≤ errorBound problem

/-- The old method's accuracy certificate survives forgetting consistency. -/
theorem Method.toRoutine_hasRiemannAccuracy {m : ℕ} {law : Law m}
    {Result : Problem law → Type*} {Information : Type*}
    (method : Method law Result Information) :
    method.toRoutine.HasRiemannAccuracy method.errorBound := by
  intro problem admitted
  exact method.accurate problem admitted

/-- A certified execution supplies a same-problem physical comparison,
including its initial states and mean-flux normalization. -/
theorem Routine.HasRiemannAccuracy.reference_comparison {m : ℕ} {law : Law m}
    {Result : Problem law → Type*} {Information : Type*}
    {routine : Routine law Result Information} {errorBound : Problem law → ℝ}
    (haccuracy : routine.HasRiemannAccuracy errorBound)
    (problem : Problem law) (admitted : routine.domain problem) :
    ∃ reference : Reference problem,
      IsRiemannData (fun x => reference.field x 0) problem.left problem.right ∧
      IsOneDimensionalCellAverage (fun τ => law.flux (reference.field 0 τ)) 0 problem.duration
        reference.meanFlux ∧
      0 ≤ errorBound problem ∧
      ‖routine.flux problem admitted - reference.meanFlux‖ ≤ errorBound problem ∧
      ∀ (physicalMean : Fin m → ℝ) (comparisonBound : ℝ),
        ‖reference.meanFlux - physicalMean‖ ≤ comparisonBound →
        ‖routine.flux problem admitted - physicalMean‖ ≤ errorBound problem + comparisonBound := by
  obtain ⟨reference, herror⟩ := haccuracy problem admitted
  obtain ⟨hinitial, hmean, hcomparison⟩ :=
    routine.reference_comparison problem admitted reference herror
  exact ⟨reference, hinitial, hmean, (norm_nonneg _).trans herror, herror, hcomparison⟩

end NumStability.LocalRiemannInformation

namespace NumStability.LocalRiemannInformation
open NumStability

theorem certifiedRoutine_local_interface_contract {m : ℕ} (law : Law m)
    {Result : Problem law → Type*} {Information : Type*}
    (routine : Routine law Result Information)
    (errorBound : Problem law → ℝ) (haccuracy : routine.HasRiemannAccuracy errorBound)
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
    ∃ (leftReference : Reference leftProblem) (rightReference : Reference rightProblem),
      IsRiemannData (fun x => leftReference.field x 0) left center ∧
      IsRiemannData (fun x => rightReference.field x 0) center right ∧
      (∀ x y u v, 0 ≤ u → u ≤ v → v ≤ t - s →
        (∫ z in x..y, leftReference.field z v) - (∫ z in x..y, leftReference.field z u) =
          ∫ τ in u..v, (law.flux (leftReference.field x τ) - law.flux (leftReference.field y τ))) ∧
      (∀ x y u v, 0 ≤ u → u ≤ v → v ≤ t - s →
        (∫ z in x..y, rightReference.field z v) - (∫ z in x..y, rightReference.field z u) =
          ∫ τ in u..v, (law.flux (rightReference.field x τ) - law.flux (rightReference.field y τ))) ∧
      IsOneDimensionalCellAverage (fun τ => law.flux (leftReference.field 0 τ)) 0 (t - s)
        leftReference.meanFlux ∧
      IsOneDimensionalCellAverage (fun τ => law.flux (rightReference.field 0 τ)) 0 (t - s)
        rightReference.meanFlux ∧
      0 ≤ errorBound leftProblem ∧ 0 ≤ errorBound rightProblem ∧
      ‖leftFlux - leftReference.meanFlux‖ ≤ errorBound leftProblem ∧
      ‖rightFlux - rightReference.meanFlux‖ ≤ errorBound rightProblem ∧
      ∀ oldBound leftComparison rightComparison : ℝ,
        ‖center - oneDimensionalCellAverage oldDensity a b‖ ≤ oldBound →
        ‖leftReference.meanFlux - oneDimensionalCellAverage leftPhysicalFlux s t‖ ≤ leftComparison →
        ‖rightReference.meanFlux - oneDimensionalCellAverage rightPhysicalFlux s t‖ ≤ rightComparison →
        ‖next - oneDimensionalCellAverage newDensity a b‖ ≤
          oldBound + (t - s) / (b - a) *
            ((errorBound leftProblem + leftComparison) + (errorBound rightProblem + rightComparison)) := by
  dsimp only
  let leftProblem : Problem law := ⟨left, center, hleftState, hcenterState, t - s, sub_pos.mpr hst⟩
  let rightProblem : Problem law := ⟨center, right, hcenterState, hrightState, t - s, sub_pos.mpr hst⟩
  have hlocal := routine_local_interface_contract law routine left center right
    hleftState hcenterState hrightState hab hst hleftDomain hrightDomain
    oldDensity newDensity leftPhysicalFlux rightPhysicalFlux
    holdDensity hnewDensity hleftFlux hrightFlux hphysicalBalance
  rcases hlocal with ⟨hdim, hhyp, hll, hlr, hrl, hrr, hlt, hrt, hlf, hrf,
    hold, hnew, hleftMean, hrightMean, hvolume, hupdate, hbalance, hdirect, hcompare⟩
  obtain ⟨leftReference, hleftError⟩ := haccuracy leftProblem hleftDomain
  obtain ⟨rightReference, hrightError⟩ := haccuracy rightProblem hrightDomain
  obtain ⟨hleftInitial, hrightInitial, hleftAverage, hrightAverage, hreferenceBound⟩ :=
    hcompare leftReference rightReference (errorBound leftProblem) (errorBound rightProblem)
      hleftError hrightError
  exact ⟨hdim, hhyp, hll, hlr, hrl, hrr, hlt, hrt, hlf, hrf,
    hold, hnew, hleftMean, hrightMean, hvolume, hupdate, hbalance, hdirect,
    leftReference, rightReference, hleftInitial, hrightInitial,
    leftReference.rectangle, rightReference.rectangle, hleftAverage, hrightAverage,
    (norm_nonneg _).trans hleftError, (norm_nonneg _).trans hrightError,
    hleftError, hrightError, hreferenceBound⟩

end NumStability.LocalRiemannInformation

namespace NumStability
open LocalRiemannInformation

theorem leveque01_certifiedRiemannRoutineInterface_sourceContract {m : ℕ}
    (law : Law m)
    {Result : Problem law → Type*} {Information : Type*}
    (routine : Routine law Result Information)
    (errorBound : Problem law → ℝ) (haccuracy : routine.HasRiemannAccuracy errorBound)
    (left center right : Fin m → ℝ)
    (hleftState : left ∈ law.states) (hcenterState : center ∈ law.states)
    (hrightState : right ∈ law.states)
    {a b s t : ℝ} (hab : a < b) (hst : s < t)
    (hleftDomain : routine.domain
      ⟨left, center, hleftState, hcenterState, t - s, sub_pos.mpr hst⟩)
    (hrightDomain : routine.domain
      ⟨center, right, hcenterState, hrightState, t - s, sub_pos.mpr hst⟩)
    (q : ℝ → ℝ → Fin m → ℝ)
    (holdDensity : IntervalIntegrable (fun x => q x s) volume a b)
    (hnewDensity : IntervalIntegrable (fun x => q x t) volume a b)
    (hleftFlux : IntervalIntegrable (fun τ => law.flux (q a τ)) volume s t)
    (hrightFlux : IntervalIntegrable (fun τ => law.flux (q b τ)) volume s t)
    (hphysicalBalance : (∫ x in a..b, (fun x => q x t) x) - (∫ x in a..b, (fun x => q x s) x) =
      ∫ τ in s..t, ((fun τ => law.flux (q a τ)) τ - (fun τ => law.flux (q b τ)) τ)) :
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
    IsOneDimensionalCellAverage (fun x => q x s) a b (oneDimensionalCellAverage (fun x => q x s) a b) ∧
    IsOneDimensionalCellAverage (fun x => q x t) a b (oneDimensionalCellAverage (fun x => q x t) a b) ∧
    IsOneDimensionalCellAverage (fun τ => law.flux (q a τ)) s t
      (oneDimensionalCellAverage (fun τ => law.flux (q a τ)) s t) ∧
    IsOneDimensionalCellAverage (fun τ => law.flux (q b τ)) s t
      (oneDimensionalCellAverage (fun τ => law.flux (q b τ)) s t) ∧
    oneDimensionalCellAverage (fun x => q x s) a b = cellVolumeAverage volume (Set.Ioc a b) (fun x => q x s) ∧
    next = center - ((t - s) / (b - a)) • (rightFlux - leftFlux) ∧
    (b - a) • (next - oneDimensionalCellAverage (fun x => q x t) a b) =
      (b - a) • (center - oneDimensionalCellAverage (fun x => q x s) a b) +
        (t - s) • ((leftFlux - oneDimensionalCellAverage (fun τ => law.flux (q a τ)) s t) -
          (rightFlux - oneDimensionalCellAverage (fun τ => law.flux (q b τ)) s t)) ∧
    (∀ oldBound leftBound rightBound : ℝ,
      ‖center - oneDimensionalCellAverage (fun x => q x s) a b‖ ≤ oldBound →
      ‖leftFlux - oneDimensionalCellAverage (fun τ => law.flux (q a τ)) s t‖ ≤ leftBound →
      ‖rightFlux - oneDimensionalCellAverage (fun τ => law.flux (q b τ)) s t‖ ≤ rightBound →
      ‖next - oneDimensionalCellAverage (fun x => q x t) a b‖ ≤
        oldBound + (t - s) / (b - a) * (leftBound + rightBound)) ∧
    ∃ (leftReference : Reference leftProblem) (rightReference : Reference rightProblem),
      IsRiemannData (fun x => leftReference.field x 0) left center ∧
      IsRiemannData (fun x => rightReference.field x 0) center right ∧
      (∀ x y u v, 0 ≤ u → u ≤ v → v ≤ t - s →
        (∫ z in x..y, leftReference.field z v) - (∫ z in x..y, leftReference.field z u) =
          ∫ τ in u..v, (law.flux (leftReference.field x τ) - law.flux (leftReference.field y τ))) ∧
      (∀ x y u v, 0 ≤ u → u ≤ v → v ≤ t - s →
        (∫ z in x..y, rightReference.field z v) - (∫ z in x..y, rightReference.field z u) =
          ∫ τ in u..v, (law.flux (rightReference.field x τ) - law.flux (rightReference.field y τ))) ∧
      IsOneDimensionalCellAverage (fun τ => law.flux (leftReference.field 0 τ)) 0 (t - s)
        leftReference.meanFlux ∧
      IsOneDimensionalCellAverage (fun τ => law.flux (rightReference.field 0 τ)) 0 (t - s)
        rightReference.meanFlux ∧
      0 ≤ errorBound leftProblem ∧ 0 ≤ errorBound rightProblem ∧
      ‖leftFlux - leftReference.meanFlux‖ ≤ errorBound leftProblem ∧
      ‖rightFlux - rightReference.meanFlux‖ ≤ errorBound rightProblem ∧
      ∀ oldBound leftComparison rightComparison : ℝ,
        ‖center - oneDimensionalCellAverage (fun x => q x s) a b‖ ≤ oldBound →
        ‖leftReference.meanFlux - oneDimensionalCellAverage (fun τ => law.flux (q a τ)) s t‖ ≤ leftComparison →
        ‖rightReference.meanFlux - oneDimensionalCellAverage (fun τ => law.flux (q b τ)) s t‖ ≤ rightComparison →
        ‖next - oneDimensionalCellAverage (fun x => q x t) a b‖ ≤
          oldBound + (t - s) / (b - a) *
            ((errorBound leftProblem + leftComparison) + (errorBound rightProblem + rightComparison)) := by
  exact certifiedRoutine_local_interface_contract law routine errorBound haccuracy left center right
    hleftState hcenterState hrightState hab hst hleftDomain hrightDomain
    (fun x => q x s) (fun x => q x t)
    (fun τ => law.flux (q a τ)) (fun τ => law.flux (q b τ))
    holdDensity hnewDensity hleftFlux hrightFlux hphysicalBalance

end NumStability

namespace NumStability.BiasedLocalRiemannRoutine
open LocalRiemannInformation

/-- Genuine scalar-transport references certify every admitted ordered problem.
The information routine still returns only the original pair of vectors. -/
theorem hasRiemannAccuracy (bias : Fin 1 → ℝ) :
    (biasedRoutine law bias).HasRiemannAccuracy (fun _ => ‖bias‖) := by
  intro problem admitted
  exact ⟨reference problem, (actual_error problem bias).le⟩

theorem certified_nonconsistent :
    (biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).HasRiemannAccuracy (fun _ => 1 / 2) ∧
    ¬ (biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).Consistent := by
  refine ⟨?_, not_consistent⟩
  simpa only [norm_smul, Real.norm_eq_abs, norm_one, abs_of_pos (by norm_num : (0 : ℝ) < 1 / 2), mul_one]
    using hasRiemannAccuracy ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))

end NumStability.BiasedLocalRiemannRoutine

namespace NumStability.CertifiedRiemannRoutineDraft
open LocalRiemannInformation BiasedLocalRiemannRoutine

def leftProblem : Problem law :=
  ⟨0, 1, proper_states.1, proper_states.2.1, 1 - 0, by norm_num⟩

def rightProblem : Problem law :=
  ⟨1, 0, proper_states.2.1, proper_states.1, 1 - 0, by norm_num⟩

theorem both_problems_nonconstant :
    leftProblem.left ≠ leftProblem.right ∧ rightProblem.left ≠ rightProblem.right := by
  constructor
  · intro h
    have hzero := congrFun h (0 : Fin 1)
    norm_num [leftProblem] at hzero
  · intro h
    have hzero := congrFun h (0 : Fin 1)
    norm_num [rightProblem] at hzero

/-- The entire new primary applied to the same certified, biased routine on
neighbor states 0,1,0. All actual cell and time-slab physical assumptions are
discharged for a constant unit density and its physical unit transport flux. -/
noncomputable def actual_two_face_source_application :=
  leveque01_certifiedRiemannRoutineInterface_sourceContract law
    (biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ)))
    (fun _ => 1 / 2) certified_nonconsistent.1
    0 1 0 proper_states.1 proper_states.2.1 proper_states.1
    (a := 0) (b := 1) (s := 0) (t := 1) (by norm_num) (by norm_num)
    trivial trivial (fun _ _ => 1)
    (intervalIntegrable_const (hc := by simp)) (intervalIntegrable_const (hc := by simp))
    (by simpa only [law, StationaryRiemannField.physicalFlux] using
      (intervalIntegrable_const (hc := by simp) : IntervalIntegrable (fun _ : ℝ => (1 : Fin 1 → ℝ)) volume 0 1))
    (by simpa only [law, StationaryRiemannField.physicalFlux] using
      (intervalIntegrable_const (hc := by simp) : IntervalIntegrable (fun _ : ℝ => (1 : Fin 1 → ℝ)) volume 0 1))
    (by simp [law, StationaryRiemannField.physicalFlux])

/-- Both actual face problems have physical references with the same nonzero
certified numerical error, for the routine used in the full source application. -/
theorem both_actual_reference_errors :
    ‖(biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).flux leftProblem trivial -
      (reference leftProblem).meanFlux‖ = 1 / 2 ∧
    ‖(biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).flux rightProblem trivial -
      (reference rightProblem).meanFlux‖ = 1 / 2 := by
  constructor <;> rw [actual_error, norm_smul] <;> norm_num

/-- The example's actual update error is nonzero; the certified Riemann
comparison is not being demonstrated only in a zero-error update. -/
theorem actual_update_error :
    ‖finiteVolumeCellAverageUpdate 1 1 (1 : Fin 1 → ℝ)
      ((biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).flux rightProblem trivial -
       (biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).flux leftProblem trivial) -
      oneDimensionalCellAverage (fun _ : ℝ => (1 : Fin 1 → ℝ)) 0 1‖ = 1 := by
  have hdifference :
      (biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).flux rightProblem trivial -
      (biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).flux leftProblem trivial = 1 := by
    ext i
    norm_num [Routine.flux, biasedRoutine, law, StationaryRiemannField.physicalFlux,
      leftProblem, rightProblem]
  rw [hdifference]
  norm_num [finiteVolumeCellAverageUpdate, oneDimensionalCellAverage]

/-- Extract the jointly certified reference pair from the actual new primary,
rather than combining unrelated inhabitants of its ingredient types. -/
theorem references_from_actual_primary :
    ∃ (leftReference : Reference leftProblem) (rightReference : Reference rightProblem),
      IsRiemannData (fun x => leftReference.field x 0) 0 1 ∧
      IsRiemannData (fun x => rightReference.field x 0) 1 0 ∧
      ‖(biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).flux leftProblem trivial -
        leftReference.meanFlux‖ ≤ 1 / 2 ∧
      ‖(biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).flux rightProblem trivial -
        rightReference.meanFlux‖ ≤ 1 / 2 := by
  rcases actual_two_face_source_application with
    ⟨_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _,
      leftReference, rightReference, hleftInitial, hrightInitial, _, _, _, _, _, _,
      hleftError, hrightError, _⟩
  exact ⟨leftReference, rightReference, hleftInitial, hrightInitial, hleftError, hrightError⟩

end NumStability.CertifiedRiemannRoutineDraft

set_option pp.universes false
set_option pp.fullNames true
set_option pp.explicit true
set_option pp.proofs false
set_option pp.deepTerms true
set_option pp.maxSteps 1000000
set_option maxRecDepth 10000
#check @NumStability.LocalRiemannInformation.Routine.HasRiemannAccuracy
#print axioms NumStability.LocalRiemannInformation.Routine.HasRiemannAccuracy
#check @NumStability.LocalRiemannInformation.Method.toRoutine_hasRiemannAccuracy
#print axioms NumStability.LocalRiemannInformation.Method.toRoutine_hasRiemannAccuracy
#check @NumStability.LocalRiemannInformation.Routine.HasRiemannAccuracy.reference_comparison
#print axioms NumStability.LocalRiemannInformation.Routine.HasRiemannAccuracy.reference_comparison
#check @NumStability.LocalRiemannInformation.certifiedRoutine_local_interface_contract
#print axioms NumStability.LocalRiemannInformation.certifiedRoutine_local_interface_contract
#check @NumStability.leveque01_certifiedRiemannRoutineInterface_sourceContract
#print axioms NumStability.leveque01_certifiedRiemannRoutineInterface_sourceContract
#check @NumStability.BiasedLocalRiemannRoutine.hasRiemannAccuracy
#print axioms NumStability.BiasedLocalRiemannRoutine.hasRiemannAccuracy
#check @NumStability.BiasedLocalRiemannRoutine.certified_nonconsistent
#print axioms NumStability.BiasedLocalRiemannRoutine.certified_nonconsistent
#check @NumStability.CertifiedRiemannRoutineDraft.leftProblem
#print axioms NumStability.CertifiedRiemannRoutineDraft.leftProblem
#check @NumStability.CertifiedRiemannRoutineDraft.rightProblem
#print axioms NumStability.CertifiedRiemannRoutineDraft.rightProblem
#check @NumStability.CertifiedRiemannRoutineDraft.both_problems_nonconstant
#print axioms NumStability.CertifiedRiemannRoutineDraft.both_problems_nonconstant
#check @NumStability.CertifiedRiemannRoutineDraft.actual_two_face_source_application
#print axioms NumStability.CertifiedRiemannRoutineDraft.actual_two_face_source_application
#check @NumStability.CertifiedRiemannRoutineDraft.both_actual_reference_errors
#print axioms NumStability.CertifiedRiemannRoutineDraft.both_actual_reference_errors
#check @NumStability.CertifiedRiemannRoutineDraft.actual_update_error
#print axioms NumStability.CertifiedRiemannRoutineDraft.actual_update_error
#check @NumStability.CertifiedRiemannRoutineDraft.references_from_actual_primary
#print axioms NumStability.CertifiedRiemannRoutineDraft.references_from_actual_primary
