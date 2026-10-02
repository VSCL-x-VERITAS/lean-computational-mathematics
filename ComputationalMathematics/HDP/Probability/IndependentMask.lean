import Mathlib.Probability.Independence.Basic

/-!
# Independence after extending a subtype-indexed family by zero

This module supplies a reusable bridge for sparse and triangular random
objects: an independent family on a subtype remains independent after it is
extended to the ambient finite index type by deterministic zeros.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set
open scoped BigOperators

namespace NumStability.HDP.Probability

/-- Extending an independent real-valued family from a decidable subtype by
zero preserves independence. -/
theorem iIndepFun_subtype_zeroExtend
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (p : ι → Prop) [DecidablePred p]
    (X : {i // p i} → Ω → ℝ)
    (hIndep : iIndepFun X μ) :
    iIndepFun (fun i ω => if hi : p i then X ⟨i, hi⟩ ω else 0) μ := by
  rw [iIndepFun_iff_measure_inter_preimage_eq_mul]
  intro S sets hsets
  let Y : ι → Ω → ℝ := fun i ω => if hi : p i then X ⟨i, hi⟩ ω else 0
  by_cases hbad : ∃ i ∈ S, ¬ p i ∧ (0 : ℝ) ∉ sets i
  · rcases hbad with ⟨i, hiS, hip, hi0⟩
    have hpre : Y i ⁻¹' sets i = ∅ := by
      ext ω
      simp [Y, hip, hi0]
    have hinter : (⋂ j ∈ S, Y j ⁻¹' sets j) = ∅ := by
      apply eq_empty_iff_forall_notMem.mpr
      intro ω hω
      have hiMem : ω ∈ Y i ⁻¹' sets i :=
        Set.mem_iInter.mp (Set.mem_iInter.mp hω i) hiS
      rw [hpre] at hiMem
      exact hiMem
    have hprod : (∏ j ∈ S, μ (Y j ⁻¹' sets j)) = 0 := by
      apply Finset.prod_eq_zero hiS
      simp [hpre]
    simp [Y, hinter, hprod]
  · push_neg at hbad
    have hinter :
        (⋂ i ∈ S, Y i ⁻¹' sets i) =
          ⋂ i ∈ S.filter p, Y i ⁻¹' sets i := by
      ext ω
      simp only [Set.mem_iInter, Finset.mem_filter]
      constructor
      · intro h i hi
        exact h i hi.1
      · intro h i hiS
        by_cases hip : p i
        · exact h i ⟨hiS, hip⟩
        · simpa [Y, hip] using hbad i hiS hip
    have hprod :
        (∏ i ∈ S.filter p, μ (Y i ⁻¹' sets i)) =
          ∏ i ∈ S, μ (Y i ⁻¹' sets i) := by
      apply Finset.prod_subset (Finset.filter_subset _ _)
      intro i hiS hiFilter
      have hip : ¬p i := by
        simpa [Finset.mem_filter, hiS] using hiFilter
      have hi0 : (0 : ℝ) ∈ sets i := hbad i hiS hip
      simp [Y, hip, hi0]
    have hsource := hIndep.measure_inter_preimage_eq_mul
      (S.subtype p) (sets := fun i => sets i.1) (by
        intro i hi
        exact hsets i.1 (by simpa using hi))
    have hleft :
        (⋂ i ∈ S.filter p, Y i ⁻¹' sets i) =
          ⋂ i ∈ S.subtype p, X i ⁻¹' sets i.1 := by
      ext ω
      simp only [Set.mem_iInter, Finset.mem_filter, Finset.mem_subtype]
      constructor
      · intro h i hiS
        simpa [Y, i.2] using h i.1 ⟨hiS, i.2⟩
      · intro h i hi
        simpa [Y, hi.2] using h ⟨i, hi.2⟩ hi.1
    have hright :
        (∏ i ∈ S.filter p, μ (Y i ⁻¹' sets i)) =
          ∏ i ∈ S.subtype p, μ (X i ⁻¹' sets i.1) := by
      symm
      calc
        (∏ i ∈ S.subtype p, μ (X i ⁻¹' sets i.1)) =
            ∏ i ∈ S.subtype p, μ (Y i.1 ⁻¹' sets i.1) := by
          apply Finset.prod_congr rfl
          intro i _hi
          simp [Y, i.2]
        _ = ∏ i ∈ S.filter p, μ (Y i ⁻¹' sets i) :=
          Finset.prod_subtype_eq_prod_filter
            (s := S) (p := p) (fun i => μ (Y i ⁻¹' sets i))
    rw [hinter, ← hprod]
    rw [hleft, hright]
    exact hsource

end NumStability.HDP.Probability
