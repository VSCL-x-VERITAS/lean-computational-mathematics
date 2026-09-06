import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Analysis.Complex.ExponentialBounds
import Mathlib.Analysis.Normed.Algebra.Spectrum
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import ComputationalMathematics.Algorithms.MatVec
import ComputationalMathematics.Algorithms.MatrixPowers.ComputedIteration.Model
import ComputationalMathematics.Algorithms.PolynomialEvaluation.MatrixNorms
import ComputationalMathematics.Analysis.LinearOperators.MatrixPowers.ExactNormBounds.Complex
import ComputationalMathematics.Analysis.LinearOperators.MatrixPowers.ExactNormBounds.Real
import ComputationalMathematics.Analysis.LinearOperators.MatrixPowers.JordanScaling.Complex
import ComputationalMathematics.Analysis.LinearOperators.MatrixPowers.JordanScaling.RealDiagonal
import ComputationalMathematics.Analysis.LinearOperators.MatrixPowers.JordanScaling.RealJordan
import ComputationalMathematics.Analysis.LinearOperators.Pseudospectra.Perturbation.ConvergenceCriterion
import ComputationalMathematics.Analysis.LinearOperators.Pseudospectra.Perturbation.Definitions
import ComputationalMathematics.Analysis.LinearOperators.Pseudospectra.Resolvent.LowerBounds
import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.Analysis.MatrixNorms.Basic
import ComputationalMathematics.Analysis.MatrixNorms.SpectralRadius
import ComputationalMathematics.Analysis.Rounding

/-!
# Analysis.LinearOperators.Pseudospectra.Resolvent.Internal.ScalarNotation

R07 canonical `internal` leaf. Unsupported private notation required by the nearest reusable owner (`_private.NumStability.Analysis.PseudospectralResolvent.0.NumStability.«term↑ₐ»`); the leaf is deliberately internal and is never advertised by a public aggregate.

Whole declaration commands are copied byte-for-byte from `NumStability.Analysis.PseudospectralResolvent`. Declaration names, visibility, namespaces, signatures, and proofs are unchanged; authored-private names are re-mangled only by their reviewed destination module.
-/


namespace NumStability

open scoped BigOperators

section ResolventNorm

variable {𝕜 A : Type*} [NontriviallyNormedField 𝕜] [NormedRing A]
  [NormedAlgebra 𝕜 A] [CompleteSpace A]

local notation "↑ₐ" => algebraMap 𝕜 A

end ResolventNorm

end NumStability
