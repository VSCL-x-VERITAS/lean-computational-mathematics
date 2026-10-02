import Mathlib.Data.Set.Pairwise.Chain
import Mathlib.Order.Zorn
import Mathlib.Topology.MetricSpace.CoveringNumbers

/-!
# Cardinal-exact packing and covering witnesses

This module records the two witness-level facts behind the comparison of
packing and covering numbers.  They retain exact cardinal information and do
not choose a convention for representing infinite numerical extrema.
-/

noncomputable section

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Metric

/-- A `2ε`-separated subset injects into every internal `ε`-cover. -/
theorem cardinalMk_le_of_isSeparated_two_mul_of_isCover
    {T : Type*} [MetricSpace T] {ε : ℝ≥0} {K P N : Set T}
    (hPK : P ⊆ K) (hPsep : Metric.IsSeparated (2 * ε) P)
    (_hNK : N ⊆ K) (hNcover : Metric.IsCover ε K N) :
    Cardinal.mk P ≤ Cardinal.mk N := by
  let f : P → N := fun x ↦
    ⟨(hNcover (hPK x.2)).choose,
      (hNcover (hPK x.2)).choose_spec.1⟩
  have hf (x : P) : edist x.1 (f x) ≤ ε :=
    (hNcover (hPK x.2)).choose_spec.2
  apply Cardinal.mk_le_of_injective (f := f)
  intro x y hxy
  apply Subtype.ext
  apply Set.Pairwise.eq hPsep x.2 y.2
  simp only [not_lt]
  calc
    edist (x : T) y ≤ edist (x : T) (f x) + edist (f x : T) y := edist_triangle ..
    _ ≤ 2 * ε := by
      rw [two_mul]
      gcongr
      · exact hf x
      · simpa [edist_comm, hxy] using hf y

private theorem exists_maximal_isSeparated
    {T : Type*} [MetricSpace T] (ε : ℝ≥0) (K : Set T) :
    ∃ P : Set T, Maximal (fun P ↦ P ⊆ K ∧ Metric.IsSeparated ε P) P := by
  apply zorn_subset
  intro c hcS hc
  refine ⟨⋃₀ c, ⟨?_, ?_⟩, ?_⟩
  · intro x hx
    obtain ⟨P, hPc, hxP⟩ := Set.mem_sUnion.mp hx
    exact (hcS hPc).1 hxP
  · exact hc.pairwise_sUnion.mpr fun P hPc ↦ (hcS hPc).2
  · intro P hPc
    exact Set.subset_sUnion_of_mem hPc

/-- Every set has a subset that is simultaneously `ε`-separated and an
internal `ε`-cover. -/
theorem exists_isSeparated_isCover
    {T : Type*} [MetricSpace T] (ε : ℝ≥0) (K : Set T) :
    ∃ P : Set T, P ⊆ K ∧ Metric.IsSeparated ε P ∧ Metric.IsCover ε K P := by
  obtain ⟨P, hP⟩ := exists_maximal_isSeparated ε K
  exact ⟨P, hP.1.1, hP.1.2, Metric.IsCover.of_maximal_isSeparated hP⟩

end NumStability.HDP.Metric
