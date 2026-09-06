import Mathlib.Analysis.Asymptotics.Lemmas
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
import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.Source.Higham.Chapter14.Algorithm04.SecondStage.GaussJordanStep
import ComputationalMathematics.Source.Higham.Chapter14.Algorithm04.Accumulation.GaussJordanAccumulation
import ComputationalMathematics.Source.Higham.Chapter14.Algorithm04.SecondStage.GaussJordanQConstruction
import ComputationalMathematics.Source.Higham.Chapter14.Theorem05.ForwardError.GaussJordanQConstruction
import ComputationalMathematics.Analysis.MatrixNorms.EntrywiseAbsolute.Basic
import ComputationalMathematics.Source.Higham.Chapter10.Equation07.AbsoluteFactorNorm.Endpoints
import ComputationalMathematics.Source.Higham.Chapter14.Corollary06.SPD.GaussJordanSPDCorollary
import ComputationalMathematics.Source.Higham.Chapter14.Problem15
import ComputationalMathematics.Source.Higham.Chapter14.Corollary06.SPD.Concrete

import ComputationalMathematics.Source.Higham.Chapter14.Corollary06.SPD.Closure

/-!
# Ch14Corollary146Closure (compatibility module)

Import-only module retained so existing imports of `NumStability.Algorithms.Ch14Corollary146Closure`
keep resolving. Every declaration moved unchanged to the canonical
modules imported above. The module's own original imports are
re-stated so consumers reaching an identifier transitively through
this path still see the same surface.
-/
