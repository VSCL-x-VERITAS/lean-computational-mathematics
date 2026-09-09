import ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateHighResolutionMethods
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.ZeroFluxCartesianRefinement
import Mathlib.Analysis.Calculus.ContDiff.Defs
import Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries
import Mathlib.MeasureTheory.Integral.Pi
set_option pp.proofs false
set_option pp.fullNames true
set_option pp.deepTerms true
set_option pp.maxSteps 10000000
set_option pp.universes false
set_option maxRecDepth 4096
set_option maxHeartbeats 1600000

/- Full canonical source application, growing physical geometry and nonconstant genuine smooth reference. Prints data definitions, never proof-valued application bodies. -/


/- Canonical-import-only adaptation of the exact frozen 14-declaration joint application. -/
namespace PhysicalDIMCanonicalJoint
open NumStability MeasureTheory Set
open NumStability.FiniteCoordinate NumStability.FiniteCartesian
open NumStability.ZeroFluxCartesianRefinement (family stationary)
open NumStability.RefiningCartesianGrid (Direction State Point Position Cell)

def direction (k : ℕ) : Direction := if k % 2 = 0 then 0 else 1
noncomputable def duration (_k : ℕ) : ℝ := 1/2
noncomputable def ghost (level : ℕ) (_k : ℕ) := family.referenceGhost level stationary
noncomputable def initial (level : ℕ) := family.projected level stationary 0

theorem schedule : ∀ d : Direction, ∃ k < 2, direction k = d := by
  intro d
  fin_cases d
  · exact ⟨0, by omega, rfl⟩
  · exact ⟨1, by omega, rfl⟩

theorem actual_substeps (level : ℕ) :
    ∀ k < 2, 0 < duration k ∧ duration k ≤ family.horizon ∧
      (NumStability.PhysicalHighResolutionSweep.method family level (ghost level) k).Admitted
        (direction k) (duration k)
        (NumStability.PhysicalHighResolutionSweep.execution family level direction duration
          (ghost level) (initial level) k) := by
  intro k _
  refine ⟨by norm_num [duration], by norm_num [duration, family], ?_⟩
  intro cell
  trivial

/-- The entire proposed source target is applied, with its actual family,
nonempty exhaustive two-direction schedule, supplied measured ghosts and
positive admitted intermediate substeps. -/
noncomputable def full_application (level : ℕ) :=
  NumStability.leveque01_coordinateHighResolutionMethods_sourceContract
    (by norm_num : 0 < 1) (by norm_num : 0 < Fintype.card Direction)
    family NumStability.ZeroFluxCartesianRefinement.family_quality level direction duration
    (ghost level) (initial level) 2 schedule (actual_substeps level)

theorem actual_references (level : ℕ) :
    ∀ k < 2, (family.data level).ReferenceOn (direction k) stationary 0 (duration k) := by
  intro k _
  exact NumStability.ZeroFluxCartesianRefinement.stationary_reference level (direction k) 0 (duration k)

theorem cartesian (level : ℕ) :
    CartesianIdentification (family.data level) (NumStability.RefiningCartesianGrid.axes level)
      Subtype.val (fun _ face => face) NumStability.ZeroFluxCartesianRefinement.zeroFlux where
  left_position := fun _ _ => rfl
  right_position := fun _ _ => rfl
  cell_measure := fun _ => rfl
  face_measurable := data_face_measurable (NumStability.RefiningCartesianGrid.axes level)
    (NumStability.RefiningCartesianGrid.active level) (NumStability.RefiningCartesianGrid.active_nonempty level)
    _ _ NumStability.ZeroFluxCartesianRefinement.zero_hyperbolic
  face_measure := data_face_measure (NumStability.RefiningCartesianGrid.axes level)
    (NumStability.RefiningCartesianGrid.active level) (NumStability.RefiningCartesianGrid.active_nonempty level)
    _ _ NumStability.ZeroFluxCartesianRefinement.zero_hyperbolic
  normal_flux := data_normal_flux (NumStability.RefiningCartesianGrid.axes level)
    (NumStability.RefiningCartesianGrid.active level) (NumStability.RefiningCartesianGrid.active_nonempty level)
    _ _ NumStability.ZeroFluxCartesianRefinement.zero_hyperbolic

theorem reference_boundary_exact (level : ℕ) (k : ℕ) :
    ghost level k = family.referenceGhost level stationary := rfl

theorem numerical_step_identity (level : ℕ) (k : ℕ) (current : family.Cell level → State) :
    advance (family.data level) (NumStability.PhysicalHighResolutionSweep.method family level (ghost level) k).rule
      (direction k) (duration k) current = current := by
  funext cell
  simp [advance, NumStability.PhysicalHighResolutionSweep.method, NumStability.CapacityCoordinate.Method.withGhost,
    NumStability.CapacityCoordinate.Method.rule, NumStability.FiniteCoordinate.PhysicalLine.faceRule,
    NumStability.ZeroFluxCartesianRefinement.family, NumStability.ZeroFluxCartesianRefinement.method,
    finiteVolumeCellAverageUpdate]

theorem execution_identity (level : ℕ) (k : ℕ) :
    NumStability.PhysicalHighResolutionSweep.execution family level direction duration
      (ghost level) (initial level) k = initial level := by
  induction k with
  | zero => rfl
  | succ k ih =>
    change advance (family.data level)
      (NumStability.PhysicalHighResolutionSweep.method family level (ghost level) k).rule
      (direction k) (duration k)
      (NumStability.PhysicalHighResolutionSweep.execution family level direction duration
        (ghost level) (initial level) k) = initial level
    rw [numerical_step_identity, ih]

theorem physical_error_zero (level : ℕ) (k : ℕ) (t : ℝ) (cell : family.Cell level) :
    ‖NumStability.PhysicalHighResolutionSweep.execution family level direction duration
      (ghost level) (initial level) k cell - (family.data level).cellMean stationary cell t‖ = 0 := by
  rw [execution_identity]
  have he : initial level cell = (family.data level).cellMean stationary cell t := rfl
  rw [he, sub_self, norm_zero]

/-- One joint inhabitant of the complete primary and its operational
premises, on every growing measured mesh. The nonconstant moving advection
consumer is retained in its separate frozen packet. -/
noncomputable def joint_applicability (level : ℕ) :=
  And.intro (full_application level)
    (And.intro (actual_substeps level)
      (And.intro (actual_references level)
        (And.intro (cartesian level)
          (And.intro NumStability.ZeroFluxCartesianRefinement.stationary_nonconstant
            (And.intro (reference_boundary_exact level)
              (physical_error_zero level))))))

end PhysicalDIMCanonicalJoint


#print NumStability.RefiningCartesianGrid.h
#print axioms NumStability.RefiningCartesianGrid.h

#print NumStability.RefiningCartesianGrid.active
#print axioms NumStability.RefiningCartesianGrid.active

#print NumStability.RefiningCartesianGrid.axes
#print axioms NumStability.RefiningCartesianGrid.axes

#print NumStability.RefiningCartesianGrid.target
#print axioms NumStability.RefiningCartesianGrid.target

#print NumStability.RefiningCartesianGrid.region
#print axioms NumStability.RefiningCartesianGrid.region

#print NumStability.RefiningCartesianGrid.boundaryIndex
#print axioms NumStability.RefiningCartesianGrid.boundaryIndex

#print NumStability.RefiningCartesianGrid.boundaryRegion
#print axioms NumStability.RefiningCartesianGrid.boundaryRegion

#print NumStability.RefiningCartesianGrid.coord
#print axioms NumStability.RefiningCartesianGrid.coord

#print NumStability.ZeroFluxCartesianRefinement.zeroFlux
#print axioms NumStability.ZeroFluxCartesianRefinement.zeroFlux

#print NumStability.ZeroFluxCartesianRefinement.data
#print axioms NumStability.ZeroFluxCartesianRefinement.data

#print NumStability.ZeroFluxCartesianRefinement.coordinates
#print axioms NumStability.ZeroFluxCartesianRefinement.coordinates

#print NumStability.ZeroFluxCartesianRefinement.method
#print axioms NumStability.ZeroFluxCartesianRefinement.method

#print NumStability.ZeroFluxCartesianRefinement.family
#print axioms NumStability.ZeroFluxCartesianRefinement.family

#print NumStability.ZeroFluxCartesianRefinement.stationary
#print axioms NumStability.ZeroFluxCartesianRefinement.stationary

#print PhysicalDIMCanonicalJoint.direction
#print axioms PhysicalDIMCanonicalJoint.direction

#print PhysicalDIMCanonicalJoint.duration
#print axioms PhysicalDIMCanonicalJoint.duration

#print PhysicalDIMCanonicalJoint.ghost
#print axioms PhysicalDIMCanonicalJoint.ghost

#print PhysicalDIMCanonicalJoint.initial
#print axioms PhysicalDIMCanonicalJoint.initial

#check @NumStability.ZeroFluxCartesianRefinement.family_quality
#print axioms NumStability.ZeroFluxCartesianRefinement.family_quality

#check @NumStability.ZeroFluxCartesianRefinement.family_stable
#print axioms NumStability.ZeroFluxCartesianRefinement.family_stable

#check @NumStability.ZeroFluxCartesianRefinement.stationary_smooth
#print axioms NumStability.ZeroFluxCartesianRefinement.stationary_smooth

#check @NumStability.ZeroFluxCartesianRefinement.stationary_nonconstant
#print axioms NumStability.ZeroFluxCartesianRefinement.stationary_nonconstant

#check @NumStability.ZeroFluxCartesianRefinement.stationary_reference
#print axioms NumStability.ZeroFluxCartesianRefinement.stationary_reference

#check @NumStability.ZeroFluxCartesianRefinement.stationary_in_reference_class
#print axioms NumStability.ZeroFluxCartesianRefinement.stationary_in_reference_class

#check @NumStability.ZeroFluxCartesianRefinement.stationary_certificates
#print axioms NumStability.ZeroFluxCartesianRefinement.stationary_certificates

#check @NumStability.ZeroFluxCartesianRefinement.nonconstant_full_quality
#print axioms NumStability.ZeroFluxCartesianRefinement.nonconstant_full_quality

#check @PhysicalDIMCanonicalJoint.schedule
#print axioms PhysicalDIMCanonicalJoint.schedule

#check @PhysicalDIMCanonicalJoint.actual_substeps
#print axioms PhysicalDIMCanonicalJoint.actual_substeps

#check @PhysicalDIMCanonicalJoint.full_application
#print axioms PhysicalDIMCanonicalJoint.full_application

#check @PhysicalDIMCanonicalJoint.actual_references
#print axioms PhysicalDIMCanonicalJoint.actual_references

#check @PhysicalDIMCanonicalJoint.cartesian
#print axioms PhysicalDIMCanonicalJoint.cartesian

#check @PhysicalDIMCanonicalJoint.reference_boundary_exact
#print axioms PhysicalDIMCanonicalJoint.reference_boundary_exact

#check @PhysicalDIMCanonicalJoint.numerical_step_identity
#print axioms PhysicalDIMCanonicalJoint.numerical_step_identity

#check @PhysicalDIMCanonicalJoint.execution_identity
#print axioms PhysicalDIMCanonicalJoint.execution_identity

#check @PhysicalDIMCanonicalJoint.physical_error_zero
#print axioms PhysicalDIMCanonicalJoint.physical_error_zero

#check @PhysicalDIMCanonicalJoint.joint_applicability
#print axioms PhysicalDIMCanonicalJoint.joint_applicability
