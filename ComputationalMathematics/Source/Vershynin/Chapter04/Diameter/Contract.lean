import Mathlib.Topology.MetricSpace.Bounded

/-!
# Vershynin, Chapter 4, diameter convention

Source-correspondence contract for the footnote definition of the diameter of a
subset of a metric space.
-/

namespace NumStability.HDP.Contract

open scoped ENNReal

/-- The extended-valued diameter appearing in Vershynin's Chapter 4 footnote,
defined transparently as the supremum of all pairwise extended distances. -/
noncomputable def chapterFourDiameter
    {T : Type*} [MetricSpace T] (K : Set T) : ℝ≥0∞ :=
  sSup (Set.image2 edist K K)

/-- Vershynin, *High-Dimensional Probability*, Chapter 4 footnote:
`diam(K) = sup {d(x,y) : x,y ∈ K}`.  The extended codomain represents the
formula for every set; the additional conjuncts make the empty and unbounded
semantics explicit. -/
theorem hdp_04_diameter_definition
    {T : Type*} [MetricSpace T] (K : Set T) :
    chapterFourDiameter K = Metric.ediam K ∧
      chapterFourDiameter (∅ : Set T) = 0 ∧
      (¬Bornology.IsBounded K → chapterFourDiameter K = ⊤) := by
  have hformula (S : Set T) : chapterFourDiameter S = Metric.ediam S := by
    exact (Metric.ediam_eq_sSup S).symm
  refine ⟨hformula K, ?_, ?_⟩
  · rw [hformula]
    exact Metric.ediam_empty
  · intro hK
    rw [hformula]
    exact Metric.ediam_of_unbounded hK

end NumStability.HDP.Contract
