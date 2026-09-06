import Mathlib.Data.Real.Basic
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import ComputationalMathematics.Algorithms.CondEstimation
import ComputationalMathematics.Analysis.ConditionEstimatorLowerBound
import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.Source.Higham.Chapter15.Algorithm03.OneNormPowerMethod.Basic
import ComputationalMathematics.Source.Higham.Chapter15.Algorithm04.LAPACKNormEstimator.Basic
import ComputationalMathematics.Source.Higham.Chapter15.Algorithm04.LAPACKNormEstimator.ConditionEstimate.Bounds
import ComputationalMathematics.Source.Higham.Chapter15.Equation06.LAPACKCounterexample.Basic
import ComputationalMathematics.Source.Higham.Chapter15.Section01.ConditionNumbers.ConditionEstimators

/-!
# Chapter15CondEst (compatibility wrapper)

Import-only historical path, retained so existing imports of `NumStability.Algorithms.Chapter15CondEst`
keep resolving. Its whole declaration block moved unchanged to
`NumStability.Source.Higham.Chapter15.Algorithm04.LAPACKNormEstimator.ConditionEstimate.Bounds`, which is imported above. The module's own original imports are
re-stated so consumers that reached an identifier transitively through this
path still see the same surface. This module declares nothing.
-/
