import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Topology.Order.Compact

/-!
# Quadratic optimization over Euclidean unit vectors

This file provides the compact unit-vector relaxation used by the
Grothendieck and semidefinite-programming applications.
-/

namespace NumStability.HDP.Optimization

open scoped BigOperators InnerProductSpace

/-- A unit vector in the `n`-dimensional real Euclidean space. -/
abbrev UnitEuclideanVector (n : ℕ) :=
  Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1

/-- An `n`-tuple of unit vectors in `ℝⁿ`. -/
abbrev UnitVectorFamily (n : ℕ) := Fin n → UnitEuclideanVector n

noncomputable instance unitEuclideanVectorCompactSpace (n : ℕ) :
    CompactSpace (UnitEuclideanVector n) :=
  Metric.sphere.compactSpace _ _

noncomputable instance unitEuclideanVectorNonempty (n : ℕ) [Nonempty (Fin n)] :
    Nonempty (UnitEuclideanVector n) := by
  let i : Fin n := Classical.choice inferInstance
  refine ⟨⟨EuclideanSpace.single i (1 : ℝ), ?_⟩⟩
  simp

/-- The relaxed quadratic objective `∑ i, j, Aᵢⱼ ⟪Xᵢ, Xⱼ⟫`. -/
noncomputable def vectorQuadraticValue {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ)
    (X : UnitVectorFamily n) : ℝ :=
  ∑ i, ∑ j, A i j * ⟪(X i : EuclideanSpace ℝ (Fin n)), X j⟫_ℝ

theorem continuous_vectorQuadraticValue {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) :
    Continuous (vectorQuadraticValue A) := by
  unfold vectorQuadraticValue
  fun_prop

/-- A maximizing unit-vector family, obtained from compactness. -/
noncomputable def vectorQuadraticMaximizer {n : ℕ} [Nonempty (Fin n)]
    (A : Matrix (Fin n) (Fin n) ℝ) : UnitVectorFamily n :=
  Classical.choose
    (isCompact_univ.exists_isMaxOn Set.univ_nonempty
      (continuous_vectorQuadraticValue A).continuousOn)

/-- The maximum value of the unit-vector quadratic relaxation. -/
noncomputable def vectorQuadraticMaximum {n : ℕ} [Nonempty (Fin n)]
    (A : Matrix (Fin n) (Fin n) ℝ) : ℝ :=
  vectorQuadraticValue A (vectorQuadraticMaximizer A)

theorem vectorQuadraticValue_le_maximum {n : ℕ} [Nonempty (Fin n)]
    (A : Matrix (Fin n) (Fin n) ℝ) (X : UnitVectorFamily n) :
    vectorQuadraticValue A X ≤ vectorQuadraticMaximum A := by
  exact (Classical.choose_spec
    (isCompact_univ.exists_isMaxOn Set.univ_nonempty
      (continuous_vectorQuadraticValue A).continuousOn)).2 (Set.mem_univ X)

theorem exists_vectorQuadraticValue_eq_maximum {n : ℕ} [Nonempty (Fin n)]
    (A : Matrix (Fin n) (Fin n) ℝ) :
    ∃ X : UnitVectorFamily n,
      vectorQuadraticValue A X = vectorQuadraticMaximum A :=
  ⟨vectorQuadraticMaximizer A, rfl⟩

end NumStability.HDP.Optimization
