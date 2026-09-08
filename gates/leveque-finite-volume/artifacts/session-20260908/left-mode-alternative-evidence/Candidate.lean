import Mathlib.Analysis.Calculus.Deriv.Abs
import Mathlib.Analysis.Calculus.ContDiff.Operations

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.Characteristics
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TravelingWaveCharacterization
import Mathlib.Data.Real.Sqrt

/-! A draft composition of existing mathematical producers. Source correspondence
and the interpretation of the left-mode profile class are not asserted here. -/
open MeasureTheory

namespace NumStability.LeftModeDomainsDraft

theorem leftMode_solutionDomains
    {bulkModulus density : ℝ}
    (system : LinearAcousticsSolution bulkModulus density)
    (hbulkModulus : 0 < bulkModulus) (hdensity : 0 < density) :
    0 < Real.sqrt (bulkModulus / density) ∧
      IsLinearAdvectionSolution
        (linearAcousticsLeftInvariant system.pressure system.velocity
          density (Real.sqrt (bulkModulus / density)))
        (-Real.sqrt (bulkModulus / density)) ∧
      ∀ profile : ℝ → ℝ,
        (∀ x t, travelingWave profile (-Real.sqrt (bulkModulus / density)) x t =
          profile (x + Real.sqrt (bulkModulus / density) * t)) ∧
        (∀ x t, travelingWave profile (-Real.sqrt (bulkModulus / density))
          (x - Real.sqrt (bulkModulus / density) * t) t = profile x) ∧
        (IsLinearAdvectionSolution
          (travelingWave profile (-Real.sqrt (bulkModulus / density)))
          (-Real.sqrt (bulkModulus / density)) ↔ Differentiable ℝ profile) ∧
        (IsRectangleConservationLawSolution
          (travelingWave profile (-Real.sqrt (bulkModulus / density)))
          (fun state => -Real.sqrt (bulkModulus / density) * state) ↔
          ∀ a b, IntervalIntegrable profile volume a b) := by
  have hratio : 0 < bulkModulus / density := div_pos hbulkModulus hdensity
  have hmaterial : bulkModulus =
      density * (Real.sqrt (bulkModulus / density)) ^ 2 := by
    rw [Real.sq_sqrt hratio.le]
    field_simp [system.density_ne_zero]
  refine ⟨Real.sqrt_pos.2 hratio, ?_, ?_⟩
  · intro x t
    exact linearAcousticsLeftInvariant_isLinearAdvectionSolutionAt
      system.pressure system.velocity bulkModulus density
      (Real.sqrt (bulkModulus / density)) x t system.density_ne_zero
      hmaterial (system.satisfies x t)
  · intro profile
    refine ⟨?_, ?_, travelingWave_isLinearAdvectionSolution_iff profile _, ?_⟩
    · intro x t
      simp [travelingWave]
    · intro x t
      simpa only [neg_mul, sub_eq_add_neg] using
        travelingWave_at_translated_point profile (-Real.sqrt (bulkModulus / density)) x t
    · simpa only [smul_eq_mul] using
        travelingWave_isRectangleConservationLawSolution_iff profile
          (-Real.sqrt (bulkModulus / density))

end NumStability.LeftModeDomainsDraft

#check NumStability.LeftModeDomainsDraft.leftMode_solutionDomains
#print axioms NumStability.LeftModeDomainsDraft.leftMode_solutionDomains

/-!
# Separate witnesses for the prospective left-mode contract

The smooth fixture is an actual acoustic system. The independent absolute-value
profile is scalar transport evidence, not a classical acoustic-system fixture.
Neither witness identifies the source's printed q² with w² or adopts a solution
class for that sentence.
-/

namespace NumStability.LeftModeAlternativeEvidence

def pressure (x t : ℝ) : ℝ := x + t
def velocity (x t : ℝ) : ℝ := -(x + t)

/-- The explicit smooth, nonconstant pressure/velocity pair satisfies acoustics
with K=rho=1, including all four classical partial derivatives. -/
def acousticFixture : LinearAcousticsSolution 1 1 where
  density_ne_zero := by norm_num
  pressure := pressure
  velocity := velocity
  satisfies := by
    intro x t
    refine ⟨1, 1, -1, -1, ?_, ?_, ?_, ?_, ?_, ?_⟩
    · exact (hasDerivAt_id t).const_add x
    · exact (hasDerivAt_id x).add_const t
    · exact ((hasDerivAt_id t).const_add x).neg
    · exact ((hasDerivAt_id x).add_const t).neg
    · norm_num
    · norm_num

theorem pressure_smooth : ContDiff ℝ ⊤ (fun z : ℝ × ℝ => pressure z.1 z.2) :=
  contDiff_fst.add contDiff_snd

theorem velocity_smooth : ContDiff ℝ ⊤ (fun z : ℝ × ℝ => velocity z.1 z.2) :=
  pressure_smooth.neg

theorem fixture_nonconstant :
    acousticFixture.pressure 0 0 ≠ acousticFixture.pressure 1 0 ∧
      acousticFixture.velocity 0 0 ≠ acousticFixture.velocity 1 0 := by
  constructor
  · change (0 : ℝ) + 0 ≠ 1 + 0
    simpa only [add_zero] using (zero_ne_one : (0 : ℝ) ≠ 1)
  · change -((0 : ℝ) + 0) ≠ -(1 + 0)
    exact fun h => (zero_ne_one : (0 : ℝ) ≠ 1) (by simpa only [add_zero] using neg_injective h)

theorem fixture_soundSpeed : Real.sqrt ((1 : ℝ) / 1) = 1 := by
  simp only [div_one, Real.sqrt_one]

/-- The actual acoustic left invariant is the translated profile 2*x at speed -1. -/
theorem fixture_leftInvariant :
    linearAcousticsLeftInvariant acousticFixture.pressure acousticFixture.velocity
      1 (Real.sqrt ((1 : ℝ) / 1)) = travelingWave (fun x : ℝ => 2 * x) (-1) := by
  rw [fixture_soundSpeed]
  funext x t
  change x + t - (1 : ℝ) * (1 : ℝ) * (-(x + t)) = (2 : ℝ) * (x - (-1 : ℝ) * t)
  ring

/-- Specialize the existing given-system producer, without assuming the invariant PDE. -/
theorem fixture_leftEquation :
    IsLinearAdvectionSolution
      (linearAcousticsLeftInvariant acousticFixture.pressure acousticFixture.velocity 1 1) (-1) := by
  simpa using
    (LeftModeDomainsDraft.leftMode_solutionDomains acousticFixture (by norm_num) (by norm_num)).2.1

/-- Concrete existence evidence carries the actual classical system, smoothness,
nonconstancy, and its exact characteristic-profile identity. -/
theorem acoustic_nonvacuity : ∃ system : LinearAcousticsSolution 1 1,
    (∀ x t, system.pressure x t = x + t) ∧
    (∀ x t, system.velocity x t = -(x + t)) ∧
    ContDiff ℝ ⊤ (fun z : ℝ × ℝ => system.pressure z.1 z.2) ∧
    ContDiff ℝ ⊤ (fun z : ℝ × ℝ => system.velocity z.1 z.2) ∧
    system.pressure 0 0 ≠ system.pressure 1 0 ∧
    system.velocity 0 0 ≠ system.velocity 1 0 ∧
    linearAcousticsLeftInvariant system.pressure system.velocity 1
      (Real.sqrt ((1 : ℝ) / 1)) = travelingWave (fun x : ℝ => 2 * x) (-1) := by
  exact ⟨acousticFixture, fun _ _ => rfl, fun _ _ => rfl, pressure_smooth,
    velocity_smooth, fixture_nonconstant.1, fixture_nonconstant.2, fixture_leftInvariant⟩

/-- Absolute value is integrable on every bounded interval. -/
theorem abs_locally_intervalIntegrable (a b : ℝ) :
    IntervalIntegrable (abs : ℝ → ℝ) volume a b := continuous_abs.intervalIntegrable a b

/-- Independent scalar-profile evidence for the rectangle branch at speed -1. -/
theorem abs_rectangle :
    IsRectangleConservationLawSolution (travelingWave (abs : ℝ → ℝ) (-1))
      (fun state : ℝ => (-1) * state) := by
  simpa only [smul_eq_mul] using
    (travelingWave_isRectangleConservationLawSolution_iff (abs : ℝ → ℝ) (-1)).2
      abs_locally_intervalIntegrable

/-- The same profile fails the classical domain; the exact characterization is reused. -/
theorem abs_not_classical :
    ¬ IsLinearAdvectionSolution (travelingWave (abs : ℝ → ℝ) (-1)) (-1) := by
  intro h
  exact not_differentiableAt_abs_zero
    ((travelingWave_isLinearAdvectionSolution_iff (abs : ℝ → ℝ) (-1)).1 h 0)

/-- In particular the classical spatial derivative required at the origin cannot exist. -/
theorem abs_not_classicalAt_origin :
    ¬ IsLinearAdvectionSolutionAt (travelingWave (abs : ℝ → ℝ) (-1)) (-1) 0 0 := by
  rintro ⟨_qt, _qx, _ht, hx, _eq⟩
  exact not_differentiableAt_abs_zero (by simpa only [travelingWave_zero] using hx.differentiableAt)

theorem abs_left_geometry (x t : ℝ) :
    travelingWave (abs : ℝ → ℝ) (-1) x t = |x + t| ∧
      travelingWave (abs : ℝ → ℝ) (-1) (x - t) t = |x| := by
  simp [travelingWave]

theorem abs_characteristic_derivative (x t : ℝ) :
    HasDerivAt (fun τ => travelingWave (abs : ℝ → ℝ) (-1) (x - τ) τ) 0 t := by
  simpa only [neg_one_mul, sub_eq_add_neg] using
    travelingWave_hasDerivAt_characteristic (abs : ℝ → ℝ) (-1) x t

/-- The strict separation of the two profile solution domains is inhabited.
This is not an assertion that abs arises from a classical acoustic system. -/
theorem nonsmooth_profile_nonvacuity :
    IsRectangleConservationLawSolution (travelingWave (abs : ℝ → ℝ) (-1))
        (fun state : ℝ => (-1) * state) ∧
      ¬ IsLinearAdvectionSolution (travelingWave (abs : ℝ → ℝ) (-1)) (-1) :=
  ⟨abs_rectangle, abs_not_classical⟩

/-- The independent nonsmooth profile cannot be the left invariant of a system
in the existing globally classical acoustic class with these coefficients. -/
theorem abs_not_classical_acoustic_leftInvariant :
    ¬ ∃ system : LinearAcousticsSolution 1 1,
      linearAcousticsLeftInvariant system.pressure system.velocity 1 1 =
        travelingWave (abs : ℝ → ℝ) (-1) := by
  rintro ⟨system, hmode⟩
  apply abs_not_classical
  rw [← hmode]
  simpa using
    (LeftModeDomainsDraft.leftMode_solutionDomains system (by norm_num) (by norm_num)).2.1

end NumStability.LeftModeAlternativeEvidence

-- Exact proof-free signature and foundational axiom checks.
#print NumStability.LinearAcousticsSolution
#print NumStability.IsLinearAcousticsSolutionAt
#check NumStability.LeftModeAlternativeEvidence.pressure
#print axioms NumStability.LeftModeAlternativeEvidence.pressure
#check NumStability.LeftModeAlternativeEvidence.velocity
#print axioms NumStability.LeftModeAlternativeEvidence.velocity
#check NumStability.LeftModeAlternativeEvidence.acousticFixture
#print axioms NumStability.LeftModeAlternativeEvidence.acousticFixture
#check NumStability.LeftModeAlternativeEvidence.pressure_smooth
#print axioms NumStability.LeftModeAlternativeEvidence.pressure_smooth
#check NumStability.LeftModeAlternativeEvidence.velocity_smooth
#print axioms NumStability.LeftModeAlternativeEvidence.velocity_smooth
#check NumStability.LeftModeAlternativeEvidence.fixture_nonconstant
#print axioms NumStability.LeftModeAlternativeEvidence.fixture_nonconstant
#check NumStability.LeftModeAlternativeEvidence.fixture_soundSpeed
#print axioms NumStability.LeftModeAlternativeEvidence.fixture_soundSpeed
#check NumStability.LeftModeAlternativeEvidence.fixture_leftInvariant
#print axioms NumStability.LeftModeAlternativeEvidence.fixture_leftInvariant
#check NumStability.LeftModeAlternativeEvidence.fixture_leftEquation
#print axioms NumStability.LeftModeAlternativeEvidence.fixture_leftEquation
#check NumStability.LeftModeAlternativeEvidence.acoustic_nonvacuity
#print axioms NumStability.LeftModeAlternativeEvidence.acoustic_nonvacuity
#check NumStability.LeftModeAlternativeEvidence.abs_locally_intervalIntegrable
#print axioms NumStability.LeftModeAlternativeEvidence.abs_locally_intervalIntegrable
#check NumStability.LeftModeAlternativeEvidence.abs_rectangle
#print axioms NumStability.LeftModeAlternativeEvidence.abs_rectangle
#check NumStability.LeftModeAlternativeEvidence.abs_not_classical
#print axioms NumStability.LeftModeAlternativeEvidence.abs_not_classical
#check NumStability.LeftModeAlternativeEvidence.abs_not_classicalAt_origin
#print axioms NumStability.LeftModeAlternativeEvidence.abs_not_classicalAt_origin
#check NumStability.LeftModeAlternativeEvidence.abs_left_geometry
#print axioms NumStability.LeftModeAlternativeEvidence.abs_left_geometry
#check NumStability.LeftModeAlternativeEvidence.abs_characteristic_derivative
#print axioms NumStability.LeftModeAlternativeEvidence.abs_characteristic_derivative
#check NumStability.LeftModeAlternativeEvidence.nonsmooth_profile_nonvacuity
#print axioms NumStability.LeftModeAlternativeEvidence.nonsmooth_profile_nonvacuity
#check NumStability.LeftModeAlternativeEvidence.abs_not_classical_acoustic_leftInvariant
#print axioms NumStability.LeftModeAlternativeEvidence.abs_not_classical_acoustic_leftInvariant
#check NumStability.linearAcousticsLeftInvariant_isLinearAdvectionSolutionAt
#print axioms NumStability.linearAcousticsLeftInvariant_isLinearAdvectionSolutionAt
#check NumStability.travelingWave_isLinearAdvectionSolution_iff
#print axioms NumStability.travelingWave_isLinearAdvectionSolution_iff
#check NumStability.travelingWave_isRectangleConservationLawSolution_iff
#print axioms NumStability.travelingWave_isRectangleConservationLawSolution_iff
#check NumStability.travelingWave_hasDerivAt_characteristic
#print axioms NumStability.travelingWave_hasDerivAt_characteristic
#check not_differentiableAt_abs_zero
#print axioms not_differentiableAt_abs_zero
#check Continuous.intervalIntegrable
#print axioms Continuous.intervalIntegrable
#check contDiff_fst
#print axioms contDiff_fst
#check contDiff_snd
#print axioms contDiff_snd
#check ContDiff.add
#print axioms ContDiff.add
#check ContDiff.neg
#print axioms ContDiff.neg
