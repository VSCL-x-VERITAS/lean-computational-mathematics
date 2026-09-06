-- NumStability/Analysis/FloatingPointArithmetic.lean
--
-- Import-only compatibility wrapper retained by reorganization wave R03
-- (phase branch B0005, projection P0005). This historical path is preserved,
-- not deleted and not Git-renamed, so every existing `import` keeps resolving.
-- All of its declarations moved unchanged to the canonical module(s) below.

import Mathlib.Data.Nat.Digits.Lemmas
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring
import ComputationalMathematics.Analysis.Error.Measures.All
import ComputationalMathematics.Analysis.FloatingPointArithmetic.DoubleRounding.All
import ComputationalMathematics.Analysis.FloatingPointArithmetic.DoubleRounding.FiniteNormalRange
import ComputationalMathematics.Analysis.FloatingPointArithmetic.DoubleRounding.ToyBinary
import ComputationalMathematics.Analysis.FloatingPointArithmetic.ErrorModels.All
import ComputationalMathematics.Analysis.FloatingPointArithmetic.ExactSubtraction
import ComputationalMathematics.Analysis.FloatingPointArithmetic.Format
import ComputationalMathematics.Analysis.FloatingPointArithmetic.IeeeExceptions
import ComputationalMathematics.Analysis.FloatingPointArithmetic.IeeeOperations
import ComputationalMathematics.Analysis.FloatingPointArithmetic.IeeeSpecialValueOperations.Results
import ComputationalMathematics.Analysis.FloatingPointArithmetic.IeeeValue
import ComputationalMathematics.Analysis.FloatingPointArithmetic.MidpointRounding.All
import ComputationalMathematics.Analysis.FloatingPointArithmetic.MidpointRounding.DecimalTieExamples
import ComputationalMathematics.Analysis.FloatingPointArithmetic.NearestRoundingError
import ComputationalMathematics.Analysis.FloatingPointArithmetic.Rounding
import ComputationalMathematics.Analysis.FloatingPointArithmetic.RoundToEvenLocalError
import ComputationalMathematics.Analysis.FloatingPointArithmetic.StandardModel
import ComputationalMathematics.Analysis.FloatingPointArithmetic.TrigonometricCancellation.All
import ComputationalMathematics.Analysis.FloatingPointArithmetic.TrigonometricCancellation.Core
import ComputationalMathematics.Source.Higham.Chapter01.Problem01.RelativeError.All
import ComputationalMathematics.Source.Higham.Chapter01.Section03.ErrorSources.All
import ComputationalMathematics.Source.Higham.Chapter01.Section07.Cancellation.All
import ComputationalMathematics.Source.Higham.Chapter02.FloatingPointArithmetic.AdditiveUnderflowModel
import ComputationalMathematics.Source.Higham.Chapter02.FloatingPointArithmetic.Environment
import ComputationalMathematics.Source.Higham.Chapter02.Section04.NoGuardModel.All

/-!
# FloatingPointArithmetic (compatibility wrapper)

Declaration-free import-only wrapper. Canonical module(s):

* `NumStability.Analysis.FloatingPointArithmetic.IeeeSpecialValueOperations.Results`

Retained by wave R03 so historical imports continue to resolve unchanged.
-/
