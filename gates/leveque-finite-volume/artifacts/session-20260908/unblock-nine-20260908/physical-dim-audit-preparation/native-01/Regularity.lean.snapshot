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

/- Exact C-infinity constructor and ContDiffOn -> ContDiffWithinAt -> Taylor-series regularity, distinct from the outer analytic top. -/

#print ContDiffOn
#print axioms ContDiffOn

#print ContDiffWithinAt
#print axioms ContDiffWithinAt

#print HasFTaylorSeriesUpToOn
#print axioms HasFTaylorSeriesUpToOn

#check @WithTop.coe_ne_top
#print axioms WithTop.coe_ne_top

set_option pp.all true in
#check (⊤ : WithTop ℕ∞)

set_option pp.all true in
#check ((⊤ : ℕ∞) : WithTop ℕ∞)
