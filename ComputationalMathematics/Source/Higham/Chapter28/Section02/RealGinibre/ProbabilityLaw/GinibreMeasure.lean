import ComputationalMathematics.MeasureTheory.Constructions.Pi
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Algebra.Polynomial.Roots
import Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral
import Mathlib.Analysis.SpecialFunctions.OrdinaryHypergeometric
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Stirling
import Mathlib.Data.Nat.Choose.Cast
import Mathlib.Data.Nat.Choose.Sum
import Mathlib.Data.Nat.Choose.Vandermonde
import Mathlib.LinearAlgebra.Matrix.Block
import Mathlib.LinearAlgebra.UnitaryGroup
import Mathlib.MeasureTheory.Constructions.Pi
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.MeasureTheory.Integral.Pi
import Mathlib.MeasureTheory.Measure.Haar.Basic
import Mathlib.Probability.Distributions.Gaussian.Real
import ComputationalMathematics.Algorithms.LinearSystems.QR.HouseholderReflector
import ComputationalMathematics.Algorithms.LinearSystems.QR.Householder.TrailingPanels
import ComputationalMathematics.Analysis.Conditioning.LinearSystems.PerronFrobenius
import ComputationalMathematics.Analysis.MatrixAlgebra

/-!
# Chapter28 Section02 RealGinibre ProbabilityLaw GinibreMeasure

Canonical destination for material split out of
`NumStability.Algorithms.TestMatrices.Higham28GinibreMeasure` by wave W09 of the August 2026 repository reorganization.
Declaration names, statements and proofs are unchanged; only the
module they live in has changed. The historical module still
resolves and re-exports this one.
-/

noncomputable section

open MeasureTheory

open scoped ENNReal


namespace NumStability

open ProbabilityTheory

/-- The ordinary real-valued standard-Gaussian joint density of an `n × n`
matrix with respect to `realGinibreLebesgueMeasure`. -/
noncomputable def realGinibreDensityReal (n : ℕ) (A : RSqMat n) : ℝ :=
  ∏ i : Fin n, ∏ j : Fin n, gaussianPDFReal 0 1 (A i j)

theorem realGinibreDensityReal_pos (n : ℕ) (A : RSqMat n) :
    0 < realGinibreDensityReal n A := by
  unfold realGinibreDensityReal
  apply Finset.prod_pos
  intro i _
  apply Finset.prod_pos
  intro j _
  exact gaussianPDFReal_pos 0 1 (A i j) (by norm_num)

end NumStability

end
