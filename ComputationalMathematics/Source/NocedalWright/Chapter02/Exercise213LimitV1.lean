import ComputationalMathematics.Source.NocedalWright.Chapter02.Exercise213LimitTargetV1
import Mathlib.Data.Real.Archimedean

/-! The reciprocal sequence in Exercise 2.13 converges to zero in the book's
explicit epsilon–threshold sense. -/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- The sequence `1 / k` converges to zero on positive indices. -/
theorem exercise213LimitV1 : exercise213LimitTargetV1 := by
  intro ε hε
  obtain ⟨K, hK, hKε⟩ := Real.exists_nat_pos_inv_lt hε
  refine ⟨K, hK, ?_⟩
  intro k hk
  have hkpos : 0 < (k : ℝ) := by exact_mod_cast lt_of_lt_of_le hK hk
  have hKpos : 0 < (K : ℝ) := by exact_mod_cast hK
  have hKle : (K : ℝ) ≤ (k : ℝ) := by exact_mod_cast hk
  have hle : (k : ℝ)⁻¹ ≤ (K : ℝ)⁻¹ :=
    (inv_le_inv₀ hkpos hKpos).2 hKle
  calc
    |(1 : ℝ) / (k : ℝ)| = (k : ℝ)⁻¹ := by
      rw [one_div, abs_of_pos (inv_pos.mpr hkpos)]
    _ ≤ (K : ℝ)⁻¹ := hle
    _ ≤ ε := le_of_lt hKε

end ComputationalMathematics.Source.NocedalWright.Chapter02
