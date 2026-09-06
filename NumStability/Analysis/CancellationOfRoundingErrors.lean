-- NumStability/Analysis/CancellationOfRoundingErrors.lean
--
-- Import-only compatibility wrapper retained by reorganization wave R03
-- (phase branch B0005, projection P0005). This historical path is preserved,
-- not deleted and not Git-renamed, so every existing `import` keeps resolving.
-- All of its declarations moved unchanged to the canonical module(s) below.

import Mathlib.Analysis.Calculus.Deriv.Slope
import Mathlib.Analysis.SpecialFunctions.Complex.LogBounds
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Log.Deriv
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity
import ComputationalMathematics.Analysis.Error.Measures.ScalarDefinitions
import ComputationalMathematics.Analysis.FloatingPointArithmetic.Format
import ComputationalMathematics.Analysis.FloatingPointArithmetic.NearestRoundingError
import ComputationalMathematics.Analysis.Rounding
import ComputationalMathematics.Source.Higham.Chapter01.FloatingPointArithmetic.CancellationOfRoundingErrors
import ComputationalMathematics.Source.Higham.Chapter01.Problem05.CompensatedLogarithm.Basic
import ComputationalMathematics.Source.Higham.Chapter01.Section11.Accumulation.Basic
import ComputationalMathematics.Source.Higham.Chapter01.Section14.CancellationOfRoundingErrors.Algorithm02RoundedCore

/-!
# CancellationOfRoundingErrors (compatibility wrapper)

Declaration-free import-only wrapper. Canonical module(s):

* `NumStability.Source.Higham.Chapter01.Section14.CancellationOfRoundingErrors.Algorithm02RoundedCore`

Retained by wave R03 so historical imports continue to resolve unchanged.
-/
