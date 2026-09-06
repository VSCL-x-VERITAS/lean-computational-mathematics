-- NumStability/Algorithms/Horner.lean
--
-- Import-only compatibility wrapper retained by reorganization wave R03
-- (phase branch B0005, projection P0005). This historical path is preserved,
-- not deleted and not Git-renamed, so every existing `import` keeps resolving.
-- All of its declarations moved unchanged to the canonical module(s) below.

import Mathlib.Data.Real.Basic
import Mathlib.Tactic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import ComputationalMathematics.Algorithms.PolynomialEvaluation.DerivativeEvaluation.ErrorBounds
import ComputationalMathematics.Algorithms.PolynomialEvaluation.ElementaryErrorBounds
import ComputationalMathematics.Algorithms.PolynomialEvaluation.MatrixNorms
import ComputationalMathematics.Algorithms.PolynomialEvaluation.RootProduct
import ComputationalMathematics.Analysis.FloatingPointArithmetic.IeeeSpecialValueOperations.Results
import ComputationalMathematics.Analysis.ForwardError
import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.Analysis.Rounding
import ComputationalMathematics.FloatingPoint.Model
import ComputationalMathematics.Source.Higham.Chapter05.Equation14.MatrixPolynomialForms.Basic
import ComputationalMathematics.Source.Higham.Chapter05.Problem01.DifferentiatedHorner.Basic
import ComputationalMathematics.Source.Higham.Chapter05.Problem02.PowerBuilding.Basic
import ComputationalMathematics.Source.Higham.Chapter05.Problem03.EvenOddSplitting.Basic
import ComputationalMathematics.Source.Higham.Chapter05.Problem06.MatrixPolynomialHorner.Basic
import ComputationalMathematics.Source.Higham.Chapter05.Section01.Horner.Basic
import ComputationalMathematics.Source.Higham.Chapter05.Section01.RelativeError.Basic
import ComputationalMathematics.Source.Higham.Chapter05.Section02.DerivativeEvaluation.Bidiagonal
import ComputationalMathematics.Source.Higham.Chapter05.Section02.DerivativeEvaluation.SyntheticDivision
import ComputationalMathematics.Source.Higham.Chapter05.Section03.DividedDifferences.Basic
import ComputationalMathematics.Source.Higham.Chapter05.Section03.LejaOrdering.Basic
import ComputationalMathematics.Source.Higham.Chapter05.Section03.NewtonEvaluation.HornerBasis

/-!
# Horner (compatibility wrapper)

Declaration-free import-only wrapper. Canonical module(s):

* `NumStability.Algorithms.PolynomialEvaluation.DerivativeEvaluation.ErrorBounds`

Retained by wave R03 so historical imports continue to resolve unchanged.
-/
