import ComputationalMathematics.HDP.Vector.IndependentCoordinates
import ComputationalMathematics.Analysis.TestMatrices.Gaussian.GaussianOrthogonal

/-!
# Standard Gaussian random vectors

This module reuses the library's canonical finite product standard-Gaussian
measure and connects it to independent standard-normal coordinates and
isotropy.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Vector.Gaussian

/-- The product of the one-dimensional standard Gaussian densities is the
finite-dimensional radial Gaussian density, written using the coordinate
sum of squares. -/
theorem standardGaussianProductDensity_eq (n : ℕ) (x : Fin n → ℝ) :
    (∏ i : Fin n, gaussianPDFReal 0 1 (x i)) =
      (Real.sqrt (2 * Real.pi))⁻¹ ^ n *
        Real.exp (-(∑ i : Fin n, (x i) ^ 2) / 2) := by
  simp only [gaussianPDFReal, NNReal.coe_one, mul_one, sub_zero]
  rw [Finset.prod_mul_distrib, Finset.prod_const, Finset.card_fin]
  congr 1
  rw [← Real.exp_sum]
  congr 1
  rw [← Finset.sum_div, ← Finset.sum_neg_distrib]

/-- A finite random vector is standard normal when its joint law is the
canonical product of one-dimensional `N(0,1)` laws. -/
def IsStandardNormal {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ) : Prop :=
  HasLaw (fun ω i => X i ω) (NumStability.standardGaussianVectorMeasure n) μ

/-- Orthogonal matrix multiplication preserves the joint standard-normal law. -/
theorem isStandardNormal_mulVec_orthogonalGroup
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} {X : Fin n → Ω → ℝ}
    (Q : Matrix.orthogonalGroup (Fin n) ℝ)
    (hX : IsStandardNormal μ X) :
    IsStandardNormal μ
      (fun i ω ↦ Matrix.mulVec (Q : Matrix (Fin n) (Fin n) ℝ)
        (fun j ↦ X j ω) i) := by
  unfold IsStandardNormal at hX ⊢
  have hQ : HasLaw
      (fun x : Fin n → ℝ ↦
        Matrix.mulVec (Q : Matrix (Fin n) (Fin n) ℝ) x)
      (NumStability.standardGaussianVectorMeasure n)
      (NumStability.standardGaussianVectorMeasure n) := by
    refine ⟨(by fun_prop), ?_⟩
    exact NumStability.standardGaussianVectorMeasure_map_orthogonalGroup n Q
  simpa only [Function.comp_def] using hQ.fun_comp hX

/-- The product-law definition is equivalent to mutually independent
standard-normal coordinates. -/
theorem isStandardNormal_iff_iIndepFun_hasLaw
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Fin n → Ω → ℝ} :
    IsStandardNormal μ X ↔
      iIndepFun X μ ∧ ∀ i, HasLaw (X i) (gaussianReal 0 1) μ := by
  constructor
  · intro hX
    have hCoord : ∀ i, HasLaw (X i) (gaussianReal 0 1) μ := by
      intro i
      exact (NumStability.standardGaussianVectorCoordinate_hasLaw n i).fun_comp hX
    refine ⟨?_, hCoord⟩
    apply (iIndepFun_iff_map_fun_eq_pi_map fun i => (hCoord i).aemeasurable).2
    rw [hX.map_eq]
    unfold NumStability.standardGaussianVectorMeasure
    congr 1
    funext i
    exact (hCoord i).map_eq.symm
  · rintro ⟨hIndep, hCoord⟩
    have hMeas : ∀ i, AEMeasurable (X i) μ := fun i => (hCoord i).aemeasurable
    refine ⟨aemeasurable_pi_lambda _ hMeas, ?_⟩
    rw [(iIndepFun_iff_map_fun_eq_pi_map hMeas).1 hIndep]
    unfold NumStability.standardGaussianVectorMeasure
    congr 1
    funext i
    exact (hCoord i).map_eq

/-- A finite-dimensional real random vector has a Gaussian law exactly when
all of its one-dimensional inner-product marginals have Gaussian laws. -/
theorem hasGaussianLaw_iff_inner_marginals
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} {X : Ω → EuclideanSpace ℝ (Fin n)}
    (hX : AEMeasurable X μ) :
    HasGaussianLaw X μ ↔
      ∀ θ : EuclideanSpace ℝ (Fin n),
        HasGaussianLaw (fun ω => innerSL ℝ θ (X ω)) μ := by
  constructor
  · intro hGaussian θ
    exact hGaussian.map_fun (innerSL ℝ θ)
  · intro hMarginal
    refine ⟨?_⟩
    apply isGaussian_of_isGaussian_map
    intro L
    obtain ⟨θ, rfl⟩ :=
      (InnerProductSpace.toDual ℝ (EuclideanSpace ℝ (Fin n))).surjective L
    have hθ := (hMarginal θ).isGaussian_map
    rw [AEMeasurable.map_map_of_aemeasurable (by fun_prop) hX]
    simpa [Function.comp_def, InnerProductSpace.toDual_apply_eq_toDualMap_apply] using hθ

/-- Every finite standard normal random vector is isotropic. -/
theorem isIsotropic_of_isStandardNormal
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Fin n → Ω → ℝ} (hX : IsStandardNormal μ X) :
    NumStability.HDP.Vector.Isotropy.IsIsotropic μ X := by
  have hCoord := (isStandardNormal_iff_iIndepFun_hasLaw.mp hX)
  apply NumStability.HDP.Vector.Isotropy.isIsotropic_of_iIndepFun_mean_zero_variance_one
  · intro i
    exact (hCoord.2 i).hasGaussianLaw.memLp_two
  · exact hCoord.1
  · intro i
    simpa using (hCoord.2 i).integral_eq
  · intro i
    rw [(hCoord.2 i).variance_eq]
    exact variance_id_gaussianReal

end NumStability.HDP.Vector.Gaussian
