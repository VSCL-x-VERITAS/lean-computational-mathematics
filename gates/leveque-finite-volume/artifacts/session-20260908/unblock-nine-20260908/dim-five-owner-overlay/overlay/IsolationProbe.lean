import Lean
import ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateHighResolutionMethods
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.HighResolutionAdvectionLine

open MeasureTheory NumStability.LocalConservationLaw NumStability.DirectionalLine
namespace OverlayIsolation
theorem smooth_definition {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ) (states : Set (Fin m → ℝ)) (a b T : ℝ) :
    SmoothReferenceOn q flux states a b T ↔
      ContDiffOn ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) (Function.uncurry q)
        (Set.Icc a b ×ˢ Set.Icc 0 T) ∧ RectangleReferenceOn q flux a b T ∧
        ∀ x ∈ Set.Icc a b, ∀ t ∈ Set.Icc 0 T, q x t ∈ states := Iff.rfl
theorem spatial_smooth_definition {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : ℝ → (Fin m → ℝ) → Fin m → ℝ) (states : Set (Fin m → ℝ)) (a b T : ℝ) :
    SpatialSmoothReferenceOn q flux states a b T ↔
      ContDiffOn ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) (Function.uncurry q)
        (Set.Icc a b ×ˢ Set.Icc 0 T) ∧ SpatialRectangleReferenceOn q flux a b T ∧
        ∀ x ∈ Set.Icc a b, ∀ t ∈ Set.Icc 0 T, q x t ∈ states := Iff.rfl
theorem chosen_rate_unchanged {m : ℕ} (family : LineFamily m)
    (quality : family.HasControlledHighResolution) :
    family.stabilityRate quality = Classical.choose quality.stability := rfl
end OverlayIsolation
#check OverlayIsolation.smooth_definition
#print axioms OverlayIsolation.smooth_definition
#check OverlayIsolation.spatial_smooth_definition
#print axioms OverlayIsolation.spatial_smooth_definition
#check OverlayIsolation.chosen_rate_unchanged
#print axioms OverlayIsolation.chosen_rate_unchanged
#print NumStability.LocalConservationLaw.SmoothReferenceOn
#print NumStability.DirectionalLine.LineFamily.stabilityRate
#eval do IO.println ("RESOLVED ComputationalMathematics.Analysis.Normed.Group.SequentialError " ++ (← Lean.findOLean `ComputationalMathematics.Analysis.Normed.Group.SequentialError).toString)
#eval do IO.println ("RESOLVED ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalLinearAdvection " ++ (← Lean.findOLean `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalLinearAdvection).toString)
#eval do IO.println ("RESOLVED ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference " ++ (← Lean.findOLean `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference).toString)
#eval do IO.println ("RESOLVED ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCellProjection " ++ (← Lean.findOLean `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCellProjection).toString)
#eval do IO.println ("RESOLVED ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod " ++ (← Lean.findOLean `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod).toString)
#eval do IO.println ("RESOLVED ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethodEstimates " ++ (← Lean.findOLean `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethodEstimates).toString)
#eval do IO.println ("RESOLVED ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.CFLUnitShift " ++ (← Lean.findOLean `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.CFLUnitShift).toString)
#eval do IO.println ("RESOLVED ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.HighResolutionAdvectionLine " ++ (← Lean.findOLean `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.HighResolutionAdvectionLine).toString)
#eval do IO.println ("RESOLVED ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianGeometry " ++ (← Lean.findOLean `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianGeometry).toString)
#eval do IO.println ("RESOLVED ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianReference " ++ (← Lean.findOLean `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianReference).toString)
#eval do IO.println ("RESOLVED ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry " ++ (← Lean.findOLean `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry).toString)
#eval do IO.println ("RESOLVED ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalReferenceError " ++ (← Lean.findOLean `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalReferenceError).toString)
#eval do IO.println ("RESOLVED ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalUpdate " ++ (← Lean.findOLean `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalUpdate).toString)
#eval do IO.println ("RESOLVED ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.HighResolutionCoordinateSweep " ++ (← Lean.findOLean `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.HighResolutionCoordinateSweep).toString)
#eval do IO.println ("RESOLVED ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod " ++ (← Lean.findOLean `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod).toString)
#eval do IO.println ("RESOLVED ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateHighResolutionMethods " ++ (← Lean.findOLean `ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateHighResolutionMethods).toString)
