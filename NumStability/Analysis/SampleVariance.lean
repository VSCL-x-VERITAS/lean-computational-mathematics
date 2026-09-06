-- NumStability/Analysis/SampleVariance.lean
--
-- Import-only compatibility wrapper retained by reorganization wave R03
-- (phase branch B0005, projection P0005). This historical path is preserved,
-- not deleted and not Git-renamed, so every existing `import` keeps resolving.
-- All of its declarations moved unchanged to the canonical module(s) below.

import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Analysis.Asymptotics.Defs
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
import Mathlib.Topology.Basic
import ComputationalMathematics.Analysis.Error.Measures.ScalarDefinitions
import ComputationalMathematics.Analysis.FloatingPointArithmetic.IeeeSpecialValueOperations.Results
import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.Analysis.Statistics.SampleVariance.Core
import ComputationalMathematics.Analysis.Statistics.SampleVariance.RoundingErrorBounds.Theorems
import ComputationalMathematics.Analysis.Statistics.SampleVariance.TwoPass
import ComputationalMathematics.Analysis.Statistics.SampleVariance.Updating
import ComputationalMathematics.Analysis.Summation.ErrorBounds
import ComputationalMathematics.Source.Higham.Chapter01.Problem07.SampleVarianceConditioning.ConditionNumbers
import ComputationalMathematics.Source.Higham.Chapter01.Problem10.TwoPassSampleVariance.Bounds
import ComputationalMathematics.Source.Higham.Chapter01.Problem10.TwoPassSampleVariance.RemainderBound.Theorem
import ComputationalMathematics.Source.Higham.Chapter01.Section09.SampleVariance.Examples
import ComputationalMathematics.Source.Higham.Chapter01.Section09.SampleVariance.IeeeSingleOnePassCounterexample.Results

/-!
# SampleVariance (compatibility wrapper)

Declaration-free import-only wrapper. Canonical module(s):

* `NumStability.Analysis.Statistics.SampleVariance.RoundingErrorBounds.Theorems`
* `NumStability.Source.Higham.Chapter01.Problem10.TwoPassSampleVariance.RemainderBound.Theorem`
* `NumStability.Source.Higham.Chapter01.Section09.SampleVariance.IeeeSingleOnePassCounterexample.Results`

Retained by wave R03 so historical imports continue to resolve unchanged.
-/
