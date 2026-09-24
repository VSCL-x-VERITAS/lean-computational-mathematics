import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.HDP.Vector.Gaussian
import ComputationalMathematics.HDP.Vector.GaussianIndependence

/-!
# Bilinear moments of finite linear marginals

This module packages deterministic linear marginals of finite random vectors
and derives their bilinear second moment from isotropy.  Standard Gaussian
vectors inherit the result from the existing Gaussian-to-isotropy bridge.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Vector

/-- The scalar marginal of a finite random vector along a deterministic
vector. -/
def linearMarginal {Ω : Type*} {n : ℕ} (X : Fin n → Ω → ℝ)
    (u : Fin n → ℝ) : Ω → ℝ :=
  fun ω => ∑ i, X i ω * u i

/-- The continuous linear functional underlying a finite scalar marginal. -/
def linearMarginalCLM {n : ℕ} (u : Fin n → ℝ) : (Fin n → ℝ) →L[ℝ] ℝ :=
  ∑ i, (u i) • ContinuousLinearMap.proj i

@[simp]
theorem linearMarginalCLM_apply {n : ℕ} (u x : Fin n → ℝ) :
    linearMarginalCLM u x = ∑ i, x i * u i := by
  simp [linearMarginalCLM, mul_comm]

/-- Split a finite family of pairs into the corresponding pair of finite
families. -/
def splitPairCoordinatesCLM {m : ℕ} :
    (Fin m → ℝ × ℝ) →L[ℝ] (Fin m → ℝ) × (Fin m → ℝ) :=
  (ContinuousLinearMap.pi fun i =>
      (ContinuousLinearMap.fst ℝ ℝ ℝ).comp
        (ContinuousLinearMap.proj i : (Fin m → ℝ × ℝ) →L[ℝ] ℝ × ℝ)).prod
    (ContinuousLinearMap.pi fun i =>
      (ContinuousLinearMap.snd ℝ ℝ ℝ).comp
        (ContinuousLinearMap.proj i : (Fin m → ℝ × ℝ) →L[ℝ] ℝ × ℝ))

@[simp]
theorem splitPairCoordinatesCLM_apply {m : ℕ} (x : Fin m → ℝ × ℝ) :
    splitPairCoordinatesCLM x = (fun i => (x i).1, fun i => (x i).2) :=
  rfl

/-- The real `L²` distance written directly as the square root of the
integrated squared pointwise difference. -/
def scalarL2Distance {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (Y Z : Ω → ℝ) : ℝ :=
  Real.sqrt (∫ ω, (Y ω - Z ω) ^ 2 ∂μ)

namespace Isotropy

/-- The bilinear second moment of two linear marginals of an isotropic vector
is the Euclidean dot product of their deterministic directions. -/
theorem integral_linearMarginal_mul_linearMarginal
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} {X : Fin n → Ω → ℝ}
    (hXLp : ∀ i, MemLp (X i) 2 μ) (hIso : IsIsotropic μ X)
    (u v : Fin n → ℝ) :
    (∫ ω, linearMarginal X u ω * linearMarginal X v ω ∂μ) =
      ∑ i, u i * v i := by
  have hTerm : ∀ i j,
      Integrable (fun ω => (u j * v i) * (X j ω * X i ω)) μ := by
    intro i j
    exact ((hXLp j).integrable_mul (hXLp i)).const_mul _
  calc
    (∫ ω, linearMarginal X u ω * linearMarginal X v ω ∂μ) =
        ∫ ω, ∑ i, ∑ j, (u j * v i) * (X j ω * X i ω) ∂μ := by
          congr 1
          funext ω
          simp only [linearMarginal, Finset.sum_mul, Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro i _
          apply Finset.sum_congr rfl
          intro j _
          ring
    _ = ∑ i, ∑ j, ∫ ω, (u j * v i) * (X j ω * X i ω) ∂μ := by
          rw [integral_finset_sum]
          · apply Finset.sum_congr rfl
            intro i _
            rw [integral_finset_sum]
            intro j _
            exact hTerm i j
          · intro i _
            exact integrable_finset_sum _ (fun j _ => hTerm i j)
    _ = ∑ i, ∑ j, (u j * v i) * (∫ ω, X j ω * X i ω ∂μ) := by
          apply Finset.sum_congr rfl
          intro i _
          apply Finset.sum_congr rfl
          intro j _
          rw [integral_const_mul]
    _ = ∑ i, u i * v i := by
          have hCoord := (isIsotropic_iff_integral_mul μ X).1 hIso
          simp [hCoord]

end Isotropy

namespace Gaussian

/-- Standard Gaussian linear marginals reproduce the Euclidean inner product
through their bilinear second moment. -/
theorem integral_linearMarginal_mul_linearMarginal_of_isStandardNormal
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Fin n → Ω → ℝ} (hX : IsStandardNormal μ X)
    (u v : Fin n → ℝ) :
    (∫ ω, linearMarginal X u ω * linearMarginal X v ω ∂μ) =
      ∑ i, u i * v i := by
  have hCoord := (isStandardNormal_iff_iIndepFun_hasLaw.mp hX).2
  exact Isotropy.integral_linearMarginal_mul_linearMarginal
    (fun i => (hCoord i).hasGaussianLaw.memLp_two)
    (isIsotropic_of_isStandardNormal hX) u v

/-- Linear marginals of a standard Gaussian vector form an isometric copy of
finite-dimensional Euclidean space inside scalar `L²`. -/
theorem scalarL2Distance_linearMarginal_of_isStandardNormal
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Fin n → Ω → ℝ} (hX : IsStandardNormal μ X)
    (u v : Fin n → ℝ) :
    scalarL2Distance μ (linearMarginal X u) (linearMarginal X v) =
      NumStability.vecNorm2 (u - v) := by
  unfold scalarL2Distance NumStability.vecNorm2 NumStability.vecNorm2Sq
  congr 1
  calc
    (∫ ω, (linearMarginal X u ω - linearMarginal X v ω) ^ 2 ∂μ) =
        ∫ ω, linearMarginal X (u - v) ω * linearMarginal X (u - v) ω ∂μ := by
          congr 1
          funext ω
          have hsub :
              linearMarginal X u ω - linearMarginal X v ω =
                linearMarginal X (u - v) ω := by
            simp only [linearMarginal, Pi.sub_apply]
            rw [← Finset.sum_sub_distrib]
            apply Finset.sum_congr rfl
            intro i _
            ring
          rw [hsub]
          ring
    _ = ∑ i, (u - v) i * (u - v) i :=
      integral_linearMarginal_mul_linearMarginal_of_isStandardNormal hX (u - v) (u - v)
    _ = ∑ i, (u - v) i ^ 2 := by
      apply Finset.sum_congr rfl
      intro i _
      ring

/-- Two linear marginals of a standard Gaussian vector are jointly Gaussian. -/
theorem hasGaussianLaw_linearMarginal_pair_of_isStandardNormal
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Fin n → Ω → ℝ} (hX : IsStandardNormal μ X)
    (u v : Fin n → ℝ) :
    HasGaussianLaw (fun ω => (linearMarginal X u ω, linearMarginal X v ω)) μ := by
  have hCoord := isStandardNormal_iff_iIndepFun_hasLaw.mp hX
  have hJoint : HasGaussianLaw (fun ω i => X i ω) μ :=
    iIndepFun.hasGaussianLaw (fun i => (hCoord.2 i).hasGaussianLaw) hCoord.1
  have h := hJoint.map_fun ((linearMarginalCLM u).prod (linearMarginalCLM v))
  simpa [linearMarginal] using h

/-- Linear marginals of a standard Gaussian vector in orthogonal directions
are independent. -/
theorem indepFun_linearMarginals_of_isStandardNormal
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Fin n → Ω → ℝ} (hX : IsStandardNormal μ X)
    (u v : Fin n → ℝ) (huv : ∑ i, u i * v i = 0) :
    IndepFun (linearMarginal X u) (linearMarginal X v) μ := by
  have hCoord := isStandardNormal_iff_iIndepFun_hasLaw.mp hX
  have hPair := hasGaussianLaw_linearMarginal_pair_of_isStandardNormal hX u v
  apply hPair.indepFun_of_covariance_eq_zero
  rw [covariance_eq_sub hPair.fst.memLp_two hPair.snd.memLp_two]
  have huMean : μ[linearMarginal X u] = 0 := by
    unfold linearMarginal
    rw [integral_finset_sum]
    · simp_rw [integral_mul_const]
      simp [(hCoord.2 _).integral_eq]
    · intro i _
      exact (hCoord.2 i).hasGaussianLaw.integrable.mul_const _
  have hvMean : μ[linearMarginal X v] = 0 := by
    unfold linearMarginal
    rw [integral_finset_sum]
    · simp_rw [integral_mul_const]
      simp [(hCoord.2 _).integral_eq]
    · intro i _
      exact (hCoord.2 i).hasGaussianLaw.integrable.mul_const _
  change (∫ ω, linearMarginal X u ω * linearMarginal X v ω ∂μ) - _ = 0
  rw [integral_linearMarginal_mul_linearMarginal_of_isStandardNormal hX u v,
    huv, huMean, hvMean]
  norm_num

/-- Applying two orthogonal linear functionals rowwise to independent
standard-Gaussian rows produces two independent output vectors. -/
theorem indepFun_rowwise_linearMarginals_of_isStandardNormal
    {Ω : Type*} [MeasurableSpace Ω] {m n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {G : Fin m → Fin n → Ω → ℝ}
    (hRows : iIndepFun (fun i ω => fun j => G i j ω) μ)
    (hRowLaw : ∀ i, IsStandardNormal μ (G i))
    (u v : Fin n → ℝ) (huv : ∑ i, u i * v i = 0) :
    IndepFun
      (fun ω i => linearMarginal (G i) u ω)
      (fun ω i => linearMarginal (G i) v ω) μ := by
  have hPairLaw : ∀ i, HasGaussianLaw
      (fun ω => (linearMarginal (G i) u ω, linearMarginal (G i) v ω)) μ :=
    fun i => hasGaussianLaw_linearMarginal_pair_of_isStandardNormal (hRowLaw i) u v
  have hPairIndep : iIndepFun
      (fun i ω => (linearMarginal (G i) u ω, linearMarginal (G i) v ω)) μ := by
    have h := hRows.comp
      (fun _ row => (∑ j, row j * u j, ∑ j, row j * v j)) (fun _ => by fun_prop)
    simpa [Function.comp_def, linearMarginal] using h
  have hJointPairs : HasGaussianLaw
      (fun ω i => (linearMarginal (G i) u ω, linearMarginal (G i) v ω)) μ :=
    iIndepFun.hasGaussianLaw hPairLaw hPairIndep
  have hJoint : HasGaussianLaw
      (fun ω =>
        (fun i => linearMarginal (G i) u ω,
          fun i => linearMarginal (G i) v ω)) μ := by
    have h := hJointPairs.map_fun (splitPairCoordinatesCLM (m := m))
    simpa using h
  apply hJoint.indepFun_of_covariance_eval
  intro i j
  by_cases hij : i = j
  · subst j
    exact (indepFun_linearMarginals_of_isStandardNormal (hRowLaw i) u v huv).covariance_eq_zero
      (hPairLaw i).fst.memLp_two (hPairLaw i).snd.memLp_two
  · have hIndepRows : IndepFun
        (fun ω => fun k => G i k ω) (fun ω => fun k => G j k ω) μ :=
      hRows.indepFun hij
    have hIndep := hIndepRows.comp
        (φ := fun row : Fin n → ℝ => ∑ k, row k * u k)
        (ψ := fun row : Fin n → ℝ => ∑ k, row k * v k)
        (by fun_prop) (by fun_prop)
    exact hIndep.covariance_eq_zero (hPairLaw i).fst.memLp_two (hPairLaw j).snd.memLp_two

end Gaussian

end NumStability.HDP.Vector
