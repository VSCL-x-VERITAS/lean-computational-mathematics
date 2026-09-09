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

/- Full primary, actual Family and nested reference/quality/certificate domains; final execution Specification and positive admitted substeps. -/

#print NumStability.PhysicalRefinementQuality.Family
#print axioms NumStability.PhysicalRefinementQuality.Family

#print NumStability.PhysicalRefinementQuality.Family.referenceGhost
#print axioms NumStability.PhysicalRefinementQuality.Family.referenceGhost

#print NumStability.PhysicalRefinementQuality.Family.projected
#print axioms NumStability.PhysicalRefinementQuality.Family.projected

#print NumStability.PhysicalRefinementQuality.Family.SmoothReference
#print axioms NumStability.PhysicalRefinementQuality.Family.SmoothReference

#print NumStability.PhysicalRefinementQuality.Family.AccuracyCertificate
#print axioms NumStability.PhysicalRefinementQuality.Family.AccuracyCertificate

#print NumStability.PhysicalRefinementQuality.Family.variation
#print axioms NumStability.PhysicalRefinementQuality.Family.variation

#print NumStability.PhysicalRefinementQuality.Family.HasHighResolution
#print axioms NumStability.PhysicalRefinementQuality.Family.HasHighResolution

#print NumStability.PhysicalHighResolutionSweep.coordinates
#print axioms NumStability.PhysicalHighResolutionSweep.coordinates

#print NumStability.PhysicalHighResolutionSweep.method
#print axioms NumStability.PhysicalHighResolutionSweep.method

#print NumStability.PhysicalHighResolutionSweep.execution
#print axioms NumStability.PhysicalHighResolutionSweep.execution

#print NumStability.PhysicalHighResolutionSweep.Specification
#print axioms NumStability.PhysicalHighResolutionSweep.Specification

#print NumStability.PhysicalHighResolutionSweep.ValidSubsteps
#print axioms NumStability.PhysicalHighResolutionSweep.ValidSubsteps

#check @NumStability.leveque01_coordinateHighResolutionMethods_sourceContract
#print axioms NumStability.leveque01_coordinateHighResolutionMethods_sourceContract

#check @NumStability.PhysicalRefinementQuality.Family.HasHighResolution.two_state_available
#print axioms NumStability.PhysicalRefinementQuality.Family.HasHighResolution.two_state_available

#check @NumStability.PhysicalRefinementQuality.Family.AccuracyCertificate.available_at_threshold
#print axioms NumStability.PhysicalRefinementQuality.Family.AccuracyCertificate.available_at_threshold

#check @NumStability.PhysicalRefinementQuality.Family.AccuracyCertificate.perturbed_at
#print axioms NumStability.PhysicalRefinementQuality.Family.AccuracyCertificate.perturbed_at

#check @NumStability.PhysicalHighResolutionSweep.specification
#print axioms NumStability.PhysicalHighResolutionSweep.specification

#check @NumStability.PhysicalHighResolutionSweep.admitted_specification
#print axioms NumStability.PhysicalHighResolutionSweep.admitted_specification
