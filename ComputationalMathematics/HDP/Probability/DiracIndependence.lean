import Mathlib.MeasureTheory.Measure.Dirac
import Mathlib.Probability.Independence.Basic

/-!
# Joint independence under a point mass

Every dependent family of random variables is mutually independent under a
point mass when underlying singletons are measurable. Family measurability is
not needed.
-/

noncomputable section
open _root_.MeasureTheory _root_.ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Probability

/-- Every family is mutually independent under a point mass when singletons
in the underlying space are measurable; no measurability of the family is needed. -/
theorem iIndepFun_dirac
    {Ω ι : Type*} [MeasurableSpace Ω] [MeasurableSingletonClass Ω]
    {β : ι → Type*} [∀ i, MeasurableSpace (β i)]
    (f : ∀ i, Ω → β i) (a : Ω) : iIndepFun f (Measure.dirac a) := by
  classical
  apply iIndepFun_iff_measure_inter_preimage_eq_mul.mpr
  intro S sets _hsets
  by_cases h : ∀ i ∈ S, f i a ∈ sets i
  · have hLeft : a ∈ ⋂ i ∈ S, f i ⁻¹' sets i := by
      simpa only [Set.mem_iInter, Set.mem_preimage] using h
    rw [Measure.dirac_apply_of_mem hLeft]
    symm
    exact Finset.prod_eq_one fun i hi ↦ Measure.dirac_apply_of_mem (h i hi)
  · have hLeft : a ∉ ⋂ i ∈ S, f i ⁻¹' sets i := by
      simpa only [Set.mem_iInter, Set.mem_preimage] using h
    rw [Measure.dirac_apply, Set.indicator_of_notMem hLeft]
    symm
    push_neg at h
    obtain ⟨i, hi, hNot⟩ := h
    exact Finset.prod_eq_zero hi (by simp [Measure.dirac_apply, hNot])

end NumStability.HDP.Probability
