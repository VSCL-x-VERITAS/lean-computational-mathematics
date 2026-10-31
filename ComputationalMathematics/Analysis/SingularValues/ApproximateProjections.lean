import ComputationalMathematics.Analysis.SingularValues.ApproximateIsometries
import ComputationalMathematics.Analysis.SingularValues.ApproximateIsometryConverse
import ComputationalMathematics.Analysis.SingularValues.Projections

/-!
# Approximate rectangular projections

An `n × m` approximate projection is defined by the near-isometric action of
its transpose from `ℝⁿ` into `ℝᵐ`.  This is the quantitative version of the
exact projection/isometry transpose duality.
-/

namespace NumStability

noncomputable section

/-- Direct metric-distortion formulation of an approximate projection. -/
def ApproximateProjectionBounds {n m : ℕ}
    (Q : Matrix (Fin n) (Fin m) ℝ) (δ : ℝ) : Prop :=
  ∀ x : EuclideanSpace ℝ (Fin n),
    (1 - δ) * ‖x‖ ≤ ‖Matrix.toEuclideanLin Q.transpose x‖ ∧
      ‖Matrix.toEuclideanLin Q.transpose x‖ ≤ (1 + δ) * ‖x‖

/-- Independent Gram-defect formulation of an approximate rectangular
projection.  Unlike `ApproximateProjectionBounds`, this measures directly how
far the row Gram matrix `Q Qᵀ` is from the identity. -/
def ApproximateProjectionDefect {n m : ℕ}
    (Q : Matrix (Fin n) (Fin m) ℝ) (ε : ℝ) : Prop :=
  realMatrixOperatorNorm (Q * Q.transpose - 1) ≤ ε

/-- The transpose of an approximate isometric embedding is an approximate
projection with the same distortion parameter. -/
theorem approximateProjectionBounds_transpose_of_approximateIsometryBounds
    {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ) (δ : ℝ)
    (hA : ApproximateIsometryBounds A δ) :
    ApproximateProjectionBounds A.transpose δ := by
  intro x
  simpa using hA x

/-- Quantitative transpose duality: an approximate isometric embedding is
exactly an approximate projection after transposition, with the same direct
metric-distortion parameter. -/
theorem approximateIsometryBounds_iff_transpose_approximateProjectionBounds
    {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ) (δ : ℝ) :
    ApproximateIsometryBounds A δ ↔
      ApproximateProjectionBounds A.transpose δ := by
  constructor
  · exact approximateProjectionBounds_transpose_of_approximateIsometryBounds A δ
  · intro hA x
    simpa [ApproximateProjectionBounds] using hA x

/-- A direct approximate isometry becomes an approximate projection after
transposition.  The conclusion uses the independent row-Gram defect and makes
the quantitative loss explicit. -/
theorem approximateProjectionDefect_transpose_of_approximateIsometryBounds
    {m n : ℕ} (A : Matrix (Fin m) (Fin (n + 1)) ℝ) {δ : ℝ}
    (hδ : 0 ≤ δ) (hA : ApproximateIsometryBounds A δ) :
    ApproximateProjectionDefect A.transpose (3 * max δ (δ ^ 2)) := by
  have hExtreme : ExtremeSingularValueBounds A δ :=
    extremeSingularValueBounds_of_approximateIsometryBounds A hA
  have hGram :=
    gramDeviation_le_three_max_of_extremeSingularValueBounds A hδ hExtreme
  simpa [ApproximateProjectionDefect] using hGram

end

end NumStability
