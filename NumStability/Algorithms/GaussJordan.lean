import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import ComputationalMathematics.Algorithms.LinearSystems.GaussJordan.ErrorAnalysis.GaussJordan
import ComputationalMathematics.Algorithms.LU.GaussianElimination
import ComputationalMathematics.Analysis.ForwardError
import ComputationalMathematics.Analysis.Rounding
import ComputationalMathematics.FloatingPoint.Model
import ComputationalMathematics.Source.Higham.Chapter09.Problems
import ComputationalMathematics.Source.Higham.Chapter09.Section01
import ComputationalMathematics.Source.Higham.Chapter09.Section02
import ComputationalMathematics.Source.Higham.Chapter09.Section03
import ComputationalMathematics.Source.Higham.Chapter09.Section04
import ComputationalMathematics.Source.Higham.Chapter09.Section05
import ComputationalMathematics.Source.Higham.Chapter09.Section06
import ComputationalMathematics.Source.Higham.Chapter09.Section08
import ComputationalMathematics.Source.Higham.Chapter09.Section10
import ComputationalMathematics.Source.Higham.Chapter09.Section11
import ComputationalMathematics.Source.Higham.Chapter14.Corollary07.RowDominantCertificates.CumulativeProductBounds

/-!
# GaussJordan (compatibility module)

Import-only module retained so existing imports of `NumStability.Algorithms.GaussJordan` keep
resolving. Every declaration moved unchanged to `NumStability.Source.Higham.Chapter14.Corollary07.RowDominantCertificates.CumulativeProductBounds`.
The module's own original imports are re-stated so consumers reaching an
identifier transitively through this path still see the same surface.
-/
