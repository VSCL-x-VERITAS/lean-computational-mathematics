import ComputationalMathematics.HDP.Vector.Bernoulli
import ComputationalMathematics.HDP.Vector.SubGaussianIndependent
import ComputationalMathematics.HDP.Scalar.SubGaussianDomination

/-!
# Symmetric Bernoulli vectors are sub-Gaussian

This module specializes the independent-coordinate vector theorem to the
canonical product Rademacher law on the discrete cube.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Vector.Bernoulli

open NumStability.HDP.Scalar.IndependentSums.Hoeffding

/-- The PMF-based Rademacher law and the two-atom law used for exact `ψ₂`
computations are the same probability measure. -/
theorem rademacherPMF_toMeasure_eq_rademacherPsiTwoLaw :
    rademacherPMF.toMeasure =
      NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw := by
  rw [show rademacherPMF.toMeasure =
      Measure.map rademacherValue fairBernoulliPMF.toMeasure by
        unfold rademacherPMF
        exact (PMF.toMeasure_map rademacherValue fairBernoulliPMF
          (measurable_of_countable _)).symm]
  ext s hs
  rw [Measure.map_apply (measurable_of_countable _) hs]
  by_cases hneg : (-1 : ℝ) ∈ s <;> by_cases hpos : (1 : ℝ) ∈ s <;>
    simp [fairBernoulliPMF, rademacherValue, PMF.bernoulli_apply,
      NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw,
      hs, Measure.add_apply, Measure.smul_apply, hneg, hpos]

/-- Section 3.4.1's symmetric Bernoulli example: the canonical product law
is sub-Gaussian with a dimension-free vector `ψ₂` bound. -/
theorem discreteCube_isSubGaussian_psiTwoNorm_le :
    ∃ K : ℝ, 0 < K ∧ ∀ n : ℕ, 0 < n →
      NumStability.HDP.Vector.SubGaussian.IsSubGaussian
          (discreteCubeMeasure n) (fun i x ↦ x i) ∧
        NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
          (discreteCubeMeasure n) (fun i x ↦ x i) ≤ ENNReal.ofReal K := by
  rcases NumStability.HDP.Vector.SubGaussian.independentCenteredCoordinates_vectorSubGaussian with
    ⟨C, hC, hVector⟩
  let q : ℝ := 1 / Real.sqrt (Real.log 2)
  have hlog : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hq : 0 < q := by
    dsimp [q]
    positivity
  refine ⟨C * q, mul_pos (lt_of_lt_of_le (by norm_num) hC) hq, ?_⟩
  intro n hn
  letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
  let μ := discreteCubeMeasure n
  letI : IsProbabilityMeasure μ := by
    dsimp [μ, discreteCubeMeasure]
    infer_instance
  have hCube : HasUniformDiscreteCubeLaw μ (fun i x ↦ x i) := by
    exact ProbabilityTheory.HasLaw.id
  have hSymmetric : IsSymmetricBernoulli μ (fun i x ↦ x i) :=
    isSymmetricBernoulli_iff_hasUniformDiscreteCubeLaw.mpr hCube
  have hCoordGauge (i : Fin n) :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ (fun x ↦ x i) =
        ENNReal.ofReal q := by
    rw [NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_eq_of_hasLaw
      (measurable_pi_apply i) (hSymmetric.2 i),
      rademacherPMF_toMeasure_eq_rademacherPsiTwoLaw,
      NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoGauge_exact]
  have hSub : ∀ i,
      NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (fun x ↦ x i) := by
    intro i
    apply (NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite).2
    simpa [NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm, hCoordGauge i] using
      (ENNReal.ofReal_lt_top : ENNReal.ofReal q < ∞)
  have hCenter : ∀ i, Integrable (fun x : Fin n → ℝ ↦ x i) μ ∧
      (∫ x, x i ∂μ) = 0 := by
    intro i
    exact ⟨(memLp_of_hasLaw_rademacher (hSymmetric.2 i)).integrable
      (by norm_num), integral_eq_zero_of_hasLaw_rademacher (hSymmetric.2 i)⟩
  have hMax :
      NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ (fun i x ↦ x i) = q := by
    unfold NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax
    apply le_antisymm
    · apply Finset.sup'_le
      intro i _
      rw [NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm, hCoordGauge i,
        ENNReal.toReal_ofReal hq.le]
    · let i : Fin n := Classical.choice inferInstance
      have hi := Finset.le_sup'
        (fun j : Fin n ↦
          (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
            (fun x ↦ x j)).toReal) (Finset.mem_univ i)
      rw [NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm, hCoordGauge i,
        ENNReal.toReal_ofReal hq.le] at hi
      exact hi
  have hResult := hVector hSub hCenter hSymmetric.1
  refine ⟨hResult.1, hResult.2.trans ?_⟩
  apply ENNReal.ofReal_le_ofReal
  rw [hMax]

end NumStability.HDP.Vector.Bernoulli
