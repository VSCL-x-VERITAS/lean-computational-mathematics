import ComputationalMathematics.HDP.Optimization.GrothendieckBipartiteSDP
import Mathlib.Topology.Order.Compact

/-!
# Attainment of finite bipartite Grothendieck optima

This module implements the finite-dimensional reduction in Step 1 of the
elementary proof of Grothendieck's inequality.  Gram matrices move arbitrary
finite Hilbert-space families into the Euclidean space indexed by the combined
row and column set.  Compactness of the corresponding unit spheres then gives
an attained matrix-specific optimum.
-/

noncomputable section

open scoped BigOperators InnerProductSpace

namespace NumStability.HDP.Optimization

/-- The canonical Euclidean space large enough to realize the Gram matrix of
an `m`-by-`n` pair of finite vector families. -/
abbrev BipartiteEuclideanSpace (m n : ℕ) :=
  EuclideanSpace ℝ (Sum (Fin m) (Fin n))

/-- A unit vector in the canonical bipartite Euclidean space. -/
abbrev BipartiteUnitVector (m n : ℕ) :=
  Metric.sphere (0 : BipartiteEuclideanSpace m n) 1

/-- A pair of row and column unit-vector families in the canonical Euclidean
space. -/
abbrev BipartiteUnitFamilies (m n : ℕ) :=
  (Fin m → BipartiteUnitVector m n) ×
    (Fin n → BipartiteUnitVector m n)

noncomputable instance bipartiteUnitVectorCompactSpace (m n : ℕ) :
    CompactSpace (BipartiteUnitVector m n) :=
  Metric.sphere.compactSpace _ _

theorem bipartiteUnitFamilies_nonempty (m n : ℕ) :
    Nonempty (BipartiteUnitFamilies m n) := by
  classical
  rcases isEmpty_or_nonempty (Sum (Fin m) (Fin n)) with h | h
  · letI : IsEmpty (Sum (Fin m) (Fin n)) := h
    exact ⟨(fun i ↦ isEmptyElim (@Sum.inl (Fin m) (Fin n) i),
      fun j ↦ isEmptyElim (@Sum.inr (Fin m) (Fin n) j))⟩
  · letI : Nonempty (Sum (Fin m) (Fin n)) := h
    let k : Sum (Fin m) (Fin n) := Classical.choice h
    letI : Nonempty (BipartiteUnitVector m n) :=
      ⟨⟨EuclideanSpace.single k (1 : ℝ), by simp⟩⟩
    infer_instance

/-- The bipartite bilinear objective on the canonical compact unit-vector
domain. -/
def bipartiteUnitValue {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ)
    (P : BipartiteUnitFamilies m n) : ℝ :=
  innerBilinearValue A
    (fun i ↦ (P.1 i : BipartiteEuclideanSpace m n))
    (fun j ↦ (P.2 j : BipartiteEuclideanSpace m n))

theorem continuous_bipartiteUnitValue {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    Continuous (bipartiteUnitValue A) := by
  unfold bipartiteUnitValue innerBilinearValue
  fun_prop

/-- A maximizing pair of unit-vector families for a finite real matrix. -/
noncomputable def bipartiteUnitMaximizer {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) : BipartiteUnitFamilies m n := by
  letI := bipartiteUnitFamilies_nonempty m n
  exact Classical.choose
    (isCompact_univ.exists_isMaxOn Set.univ_nonempty
      (continuous_bipartiteUnitValue A).continuousOn)

/-- The attained matrix-specific unit-vector optimum. -/
noncomputable def bipartiteUnitMaximum {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) : ℝ :=
  bipartiteUnitValue A (bipartiteUnitMaximizer A)

theorem bipartiteUnitValue_le_maximum {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (P : BipartiteUnitFamilies m n) :
    bipartiteUnitValue A P ≤ bipartiteUnitMaximum A := by
  letI := bipartiteUnitFamilies_nonempty m n
  exact (Classical.choose_spec
    (isCompact_univ.exists_isMaxOn Set.univ_nonempty
      (continuous_bipartiteUnitValue A).continuousOn)).2 (Set.mem_univ P)

theorem exists_bipartiteUnitValue_eq_maximum {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    ∃ P : BipartiteUnitFamilies m n,
      bipartiteUnitValue A P = bipartiteUnitMaximum A :=
  ⟨bipartiteUnitMaximizer A, rfl⟩

/-- Any unit-vector families in any real Hilbert space have objective at most
the canonical finite-dimensional maximum. -/
theorem innerBilinearValue_le_bipartiteUnitMaximum
    {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ)
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (X : Fin m → E) (Y : Fin n → E)
    (hX : ∀ i, ‖X i‖ = 1) (hY : ∀ j, ‖Y j‖ = 1) :
    innerBilinearValue A X Y ≤ bipartiteUnitMaximum A := by
  let M := bipartiteUnitGram X Y
  have hM : IsCorrelationMatrixOn M :=
    bipartiteUnitGram_isCorrelationMatrixOn X Y hX hY
  obtain ⟨X', Y', hX', hY', hgram⟩ :=
    exists_bipartite_unit_families_gram_eq hM
  let P : BipartiteUnitFamilies m n :=
    ((fun i ↦ ⟨X' i, by simpa [Metric.mem_sphere] using hX' i⟩),
      (fun j ↦ ⟨Y' j, by simpa [Metric.mem_sphere] using hY' j⟩))
  have hvalue : innerBilinearValue A X Y = bipartiteUnitValue A P := by
    calc
      innerBilinearValue A X Y =
          bipartiteSemidefiniteValue A (bipartiteUnitGram X Y) :=
        (bipartiteSemidefiniteValue_unitGram A X Y).symm
      _ = bipartiteSemidefiniteValue A (bipartiteUnitGram X' Y') := by
        rw [hgram]
      _ = innerBilinearValue A X' Y' :=
        bipartiteSemidefiniteValue_unitGram A X' Y'
      _ = bipartiteUnitValue A P := rfl
  rw [hvalue]
  exact bipartiteUnitValue_le_maximum A P

theorem bipartiteUnitMaximum_nonneg {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    0 ≤ bipartiteUnitMaximum A := by
  let P := bipartiteUnitMaximizer A
  let Pneg : BipartiteUnitFamilies m n :=
    ((fun i ↦ ⟨-(P.1 i : BipartiteEuclideanSpace m n), by
        simp⟩), P.2)
  have hneg := bipartiteUnitValue_le_maximum A Pneg
  have hvalue : bipartiteUnitValue A Pneg = -bipartiteUnitValue A P := by
    unfold bipartiteUnitValue innerBilinearValue
    simp [Pneg]
  rw [hvalue] at hneg
  change -bipartiteUnitMaximum A ≤ bipartiteUnitMaximum A at hneg
  linarith

/-- The attained finite-dimensional maximum is the universal unit-vector
bound for the matrix. -/
theorem bipartiteUnitMaximum_universalUnitBound {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    UniversalUnitBound.{u} A (bipartiteUnitMaximum A) := by
  intro E _ _ X Y hX hY
  exact innerBilinearValue_le_bipartiteUnitMaximum A X Y hX hY

/-- Homogeneous form of the matrix-specific attained optimum. -/
theorem bipartiteUnitMaximum_universalPiNormBound {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    UniversalPiNormBound.{u} A (bipartiteUnitMaximum A) := by
  exact (universalUnitBound_iff_universalPiNormBound A
    (bipartiteUnitMaximum A) (bipartiteUnitMaximum_nonneg A)).1
    (bipartiteUnitMaximum_universalUnitBound A)

end NumStability.HDP.Optimization
