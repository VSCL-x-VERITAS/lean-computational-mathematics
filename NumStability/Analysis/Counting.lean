import Mathlib.Tactic.NormNum
import ComputationalMathematics.Analysis.FloatingPointArithmetic.IeeeSpecialValueOperations.Results
import ComputationalMathematics.Source.Higham.Chapter02.Problem01.FloatingPointCounts.Basic

/-!
# Counting (compatibility module)

Import-only module retained so existing imports of `NumStability.Analysis.Counting`
keep resolving. Every declaration moved unchanged to the canonical
modules imported above. The module's own original imports are
re-stated so consumers reaching an identifier transitively through
this path still see the same surface.
-/
