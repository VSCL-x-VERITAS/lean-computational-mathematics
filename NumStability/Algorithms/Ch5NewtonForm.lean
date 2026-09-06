import Mathlib.Data.Real.Basic
import Mathlib.Tactic
import ComputationalMathematics.Algorithms.PolynomialEvaluation.DerivativeEvaluation.ErrorBounds
import ComputationalMathematics.Analysis.Rounding
import ComputationalMathematics.FloatingPoint.Model
import ComputationalMathematics.Source.Higham.Chapter05.Section03.NewtonEvaluation.Basic

/-!
# Ch5NewtonForm (compatibility module)

Import-only module retained so existing imports of `NumStability.Algorithms.Ch5NewtonForm`
keep resolving. Every declaration moved unchanged to the canonical
modules imported above. The module's own original imports are
re-stated so consumers reaching an identifier transitively through
this path still see the same surface.
-/
