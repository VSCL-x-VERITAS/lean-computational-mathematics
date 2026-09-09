/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage

open MeasureTheory

/-!
# Riemann information with local physical comparison

A numerical procedure returns arbitrary problem-indexed information. Its
specified flux error is certified against some rectangle-conserved Riemann
reference on the same finite time slab and with the same ordered states.
The reference is existentially selected and can depend on the method. No
entropy condition, uniqueness, prescribed tolerance or convergence is asserted.
Hyperbolicity uses the ambient flux derivative only at admissible states.
-/

namespace NumStability.LocalRiemannInformation
open NumStability

/-- The physical law is classified only at its explicitly admissible states. -/
structure Law (m : ℕ) where
  positive_dimension : 0 < m
  /-- The set of admissible conserved states at which the law is classified. -/
  states : Set (Fin m → ℝ)
  /-- The physical flux as a function of the conserved state. -/
  flux : (Fin m → ℝ) → Fin m → ℝ
  hyperbolic : IsHyperbolicFluxOn flux states

/-- Ordered admissible states and the actual positive time horizon. -/
structure Problem {m : ℕ} (law : Law m) where
  /-- The constant admissible initial state to the left of the interface. -/
  left : Fin m → ℝ
  /-- The constant admissible initial state to the right of the interface. -/
  right : Fin m → ℝ
  left_mem : left ∈ law.states
  right_mem : right ∈ law.states
  /-- The positive length of the finite time slab on which the problem is posed. -/
  duration : ℝ
  duration_pos : 0 < duration

/-- A physical Riemann reference on the selected finite time slab.
Existential selection may depend on the method; its numerical result type need not contain this field. Values after the horizon
are irrelevant; the initial interface value is left unspecified. -/
structure Reference {m : ℕ} {law : Law m} (problem : Problem law) where
  /-- The space-time state field of the reference, evaluated at position `x` and time `τ`. -/
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

/-- The time average over `[0, problem.duration]` of the physical flux of the reference
field at the interface `x = 0`: the mean physical flux through the interface on the slab. -/
noncomputable def Reference.meanFlux {m : ℕ} {law : Law m} {problem : Problem law}
    (reference : Reference problem) : Fin m → ℝ :=
  oneDimensionalCellAverage (fun τ => law.flux (reference.field 0 τ)) 0 problem.duration

/-- A procedure may return arbitrary dependent information. Its approximation
contract compares the resulting flux with some physical solution of
the same ordered problem over the same time interval. This existential proof
does not require the numerical procedure to construct or return that solution.
No nonconstant accuracy or solution existence is inferred from consistency. -/
structure Method {m : ℕ} (law : Law m)
    (Result : Problem law → Type*) (Information : Type*) where
  /-- The problems the procedure accepts; `solve` is only defined on them. -/
  domain : Problem law → Prop
  /-- Run the procedure on an accepted problem, producing its problem-indexed result. -/
  solve : (problem : Problem law) → domain problem → Result problem
  /-- Extract the method-specific information from a result of the procedure. -/
  extract : {problem : Problem law} → Result problem → Information
  /-- Convert extracted information into a numerical interface flux vector. -/
  numericalFlux : Information → Fin m → ℝ
  /-- The certified bound, for each problem, on the distance between the numerical flux and
  the mean flux of some rectangle-conserved Riemann reference of that problem. -/
  errorBound : Problem law → ℝ
  accurate : ∀ problem hdomain, ∃ reference : Reference problem,
    ‖numericalFlux (extract (solve problem hdomain)) - reference.meanFlux‖ ≤ errorBound problem
  consistent : ∀ problem hdomain, problem.left = problem.right →
    numericalFlux (extract (solve problem hdomain)) = law.flux problem.left

/-- The numerical flux the procedure assigns to an accepted problem: solve it, extract the
method's information from the result, and convert that information into a flux vector. -/
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

end NumStability.LocalRiemannInformation
