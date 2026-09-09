/- Draft of a local-time, admissible-state numerical Riemann contract. -/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity
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
