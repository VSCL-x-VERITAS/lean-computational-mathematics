import ComputationalMathematics.Algorithms.LinearSystems.LeastSquares.Existence
import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.LeastSquaresConstructions

/-!
# Joint least-squares sketch construction wrappers

Actual finite sampling laws and chosen exact minimizers inhabit the source
construction contracts. Quantitative approximation and computation-cost
obligations remain separate.
-/

namespace NumStability.Source.DrineasMahoney.RandNLA2016

open scoped BigOperators

theorem relativeLeverageLeastSquaresConstruction : Targets.relativeLeverageLeastSquaresConstruction := by
  intro m n s A b a α _hm _hn _hs hα0 hα ha
  constructor
  · intro hzero y
    exact le_of_eq (lsObjective_eq_of_zero_columnSpace_basis A hzero b (fun _ => 0) y)
  · intro hd
    let P := relativeLeverageScoreProbability (lsColumnSpaceBasisMatrix A)
      (hasOrthonormalColumns_lsColumnSpaceBasisMatrix A) hd a hα (ha hd)
    let xHat : RowTrace m s → Fin n → ℝ := fun samples =>
      leastSquaresMinimizer (rowSampleSketchWithProb s A P.prob samples)
        (rowSampleVectorWithProb P.prob b samples)
    refine ⟨P, xHat, (fun _ => rfl), ?_, (fun _ => rfl),
      P.iid_eventProb_positive s, (fun _ _ _ => rfl), (fun _ _ => rfl), ?_⟩
    · intro i
      exact relativeLeverageScoreProbability_ge_fraction _
        (hasOrthonormalColumns_lsColumnSpaceBasisMatrix A) hd a hα0 hα (ha hd) i
    · intro samples
      exact ⟨leastSquaresMinimizer_isLeastSquaresMinimizer _ _,
        leastSquaresMinimizer_residual_norm_le _ _⟩

private theorem uniform_inverse_scale_eq_sqrt_div {m s : ℕ}
    (hm : 0 < m) (hs : 0 < s) (i : Fin m) (a : ℝ) :
    a / rowSampleScaleDenWithProb s (uniformRowProb (m := m)) i =
      Real.sqrt ((m : ℝ) / (s : ℝ)) * a := by
  have hmR : (m : ℝ) ≠ 0 := by exact_mod_cast hm.ne'
  have hsR : (s : ℝ) ≠ 0 := by exact_mod_cast hs.ne'
  unfold rowSampleScaleDenWithProb uniformRowProb
  rw [div_eq_mul_inv, ← Real.sqrt_inv]
  have heq : ((s : ℝ) * (m : ℝ)⁻¹)⁻¹ = (m : ℝ) / (s : ℝ) := by field_simp
  rw [heq]
  ring

theorem walshUniformLeastSquaresConstruction : Targets.walshUniformLeastSquaresConstruction := by
  intro q n s A b hm _hn hs
  let m := 2 ^ q
  let H := Targets.leastSquaresWalshMatrix q
  let xHat : RademacherTrace m × RowTrace m s → Fin n → ℝ := fun z =>
    let T := matMul m H (diagMatrix (rademacherSignVector z.1))
    leastSquaresMinimizer
      (rowSampleSketchWithProb s (preconditionRows T A) uniformRowProb z.2)
      (rowSampleVectorWithProb uniformRowProb (matMulVec m T b) z.2)
  refine ⟨isOrthogonal_sqrt_inv_nat_mul_sylvesterSignPattern q,
    hadamardFlat_sqrt_inv_nat_mul_sylvesterSignPattern q,
    xHat, (fun _ => rfl), (fun _ => rfl), ?_⟩
  intro ω samples
  refine ⟨?_, ?_, leastSquaresMinimizer_isLeastSquaresMinimizer _ _,
    leastSquaresMinimizer_residual_norm_le _ _⟩
  · intro t j
    exact uniform_inverse_scale_eq_sqrt_div hm hs (samples t) _
  · intro t
    exact uniform_inverse_scale_eq_sqrt_div hm hs (samples t) _

end NumStability.Source.DrineasMahoney.RandNLA2016
