import ComputationalMathematics.Analysis.MatrixAlgebra
import Mathlib.MeasureTheory.Integral.Bochner.Basic

/-!
# Finite-dimensional vector moments

Reusable expectation identities for random vectors with finitely many real
coordinates.
-/

noncomputable section

open MeasureTheory
open scoped BigOperators

namespace NumStability.HDP.Vector.Moments

/-- The expected squared Euclidean norm is the cardinality of the coordinate
index when every coordinate has integrable unit second moment. -/
theorem expectation_vecNorm2Sq_eq_card
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ)
    (hX : ∀ i, Integrable (fun ω => (X i ω) ^ 2) μ)
    (hSecond : ∀ i, (∫ ω, (X i ω) ^ 2 ∂μ) = 1) :
    (∫ ω, NumStability.vecNorm2Sq (fun i => X i ω) ∂μ) = n := by
  unfold NumStability.vecNorm2Sq
  rw [integral_finset_sum Finset.univ]
  · simp [hSecond]
  · intro i _hi
    exact hX i

end NumStability.HDP.Vector.Moments
