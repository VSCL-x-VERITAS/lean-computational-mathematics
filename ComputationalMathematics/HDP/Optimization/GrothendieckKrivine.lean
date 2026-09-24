import ComputationalMathematics.HDP.Graph.GaussianHyperplaneExpectation
import ComputationalMathematics.HDP.Optimization.GrothendieckConstant
import ComputationalMathematics.HDP.Tensor.KrivineFeature

/-!
# Krivine's Grothendieck bound

This module assembles the reusable Gaussian-hyperplane and tensor-feature
foundations used in Krivine's bound for finite bilinear forms.
-/

noncomputable section

open MeasureTheory
open scoped BigOperators InnerProductSpace

namespace NumStability.HDP.Optimization

/-- A sign-vector bound controls the Gaussian hyperplane correlation sum. -/
theorem gaussianHyperplaneCorrelation_bilinear_le_one
    {d m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ)
    (hsign : ∀ x y, IsSignVector x → IsSignVector y →
      bilinearValue A x y ≤ 1)
    (X : Fin m → EuclideanSpace ℝ (Fin d))
    (Y : Fin n → EuclideanSpace ℝ (Fin d)) :
    (∑ i, ∑ j, A i j *
      NumStability.HDP.Graph.gaussianHyperplaneSignCorrelation (X i) (Y j)) ≤ 1 := by
  let U : Fin m → (Fin d → ℝ) → ℝ := fun i g =>
    (NumStability.HDP.Graph.hyperplaneSign (X i) (WithLp.toLp 2 g)).value
  let V : Fin n → (Fin d → ℝ) → ℝ := fun j g =>
    (NumStability.HDP.Graph.hyperplaneSign (Y j) (WithLp.toLp 2 g)).value
  have hInt : Integrable
      (fun g => bilinearValue A (fun i => U i g) (fun j => V j g))
      (NumStability.standardGaussianVectorMeasure d) := by
    unfold bilinearValue
    apply integrable_finset_sum
    intro i _hi
    apply integrable_finset_sum
    intro j _hj
    simpa [U, V, mul_assoc] using
      (NumStability.HDP.Graph.integrable_hyperplaneSign_value_mul
        (X i) (Y j)).const_mul (A i j)
  have hU : ∀ᵐ g ∂NumStability.standardGaussianVectorMeasure d,
      ∀ i, |U i g| ≤ (1 : ℝ) := by
    filter_upwards [] with g
    intro i
    dsimp [U]
    cases NumStability.HDP.Graph.hyperplaneSign (X i) (WithLp.toLp 2 g) <;>
      norm_num
  have hV : ∀ᵐ g ∂NumStability.standardGaussianVectorMeasure d,
      ∀ j, |V j g| ≤ (1 : ℝ) := by
    filter_upwards [] with g
    intro j
    dsimp [V]
    cases NumStability.HDP.Graph.hyperplaneSign (Y j) (WithLp.toLp 2 g) <;>
      norm_num
  have hbound := integral_bilinearValue_le_sq_of_sign_of_abs_le
    (NumStability.standardGaussianVectorMeasure d) A hsign
    (R := (1 : ℝ)) zero_le_one U V hInt hU hV
  have hEq :
      (∫ g, bilinearValue A (fun i => U i g) (fun j => V j g)
        ∂NumStability.standardGaussianVectorMeasure d) =
        ∑ i, ∑ j, A i j *
          NumStability.HDP.Graph.gaussianHyperplaneSignCorrelation (X i) (Y j) := by
    unfold bilinearValue
    rw [integral_finset_sum]
    · apply Finset.sum_congr rfl
      intro i _hi
      rw [integral_finset_sum]
      · apply Finset.sum_congr rfl
        intro j _hj
        rw [show (fun a => A i j * (fun i => U i a) i * (fun j => V j a) j) =
            (fun a => A i j * (U i a * V j a)) by
          funext a
          ring]
        rw [integral_const_mul]
        rfl
      · intro j _hj
        simpa [U, V, mul_assoc] using
          (NumStability.HDP.Graph.integrable_hyperplaneSign_value_mul
            (X i) (Y j)).const_mul (A i j)
    · intro i _hi
      apply integrable_finset_sum
      intro j _hj
      simpa [U, V, mul_assoc] using
        (NumStability.HDP.Graph.integrable_hyperplaneSign_value_mul
          (X i) (Y j)).const_mul (A i j)
  rw [hEq] at hbound
  norm_num at hbound ⊢
  exact hbound

/-- Krivine's feature map and Grothendieck's Gaussian sign identity give the
explicit constant `1 / β`. -/
theorem isGrothendieckConstant_inv_krivineBeta :
    IsGrothendieckConstant.{u} NumStability.HDP.Tensor.krivineBeta⁻¹ := by
  intro m n A hsign E _ _ u v hu hv
  let M := bipartiteUnitGram u v
  have hM : IsCorrelationMatrixOn M :=
    bipartiteUnitGram_isCorrelationMatrixOn u v hu hv
  obtain ⟨u0, v0, hu0, hv0, hgram0⟩ :=
    exists_bipartite_unit_families_gram_eq hM
  let uc : Fin m → Fin (m + n) → ℝ := fun i k =>
    u0 i (finSumFinEquiv.symm k)
  let vc : Fin n → Fin (m + n) → ℝ := fun j k =>
    v0 j (finSumFinEquiv.symm k)
  have huc (i : Fin m) : ∑ k, uc i k * uc i k = 1 := by
    rw [sum_bipartiteCoordinates_mul]
    rw [real_inner_self_eq_norm_sq, hu0 i]
    norm_num
  have hvc (j : Fin n) : ∑ k, vc j k * vc j k = 1 := by
    rw [sum_bipartiteCoordinates_mul]
    rw [real_inner_self_eq_norm_sq, hv0 j]
    norm_num
  let L : Fin m → NumStability.HDP.Tensor.PowerSeriesFeatureSpace (m + n) :=
    fun i => NumStability.HDP.Tensor.krivineLeftFeature (uc i)
  let R : Fin n → NumStability.HDP.Tensor.PowerSeriesFeatureSpace (m + n) :=
    fun j => NumStability.HDP.Tensor.krivineRightFeature (vc j)
  have hL (i : Fin m) : ‖L i‖ = 1 :=
    (NumStability.HDP.Tensor.krivineFeature_norm (uc i) (huc i)).1
  have hR (j : Fin n) : ‖R j‖ = 1 :=
    (NumStability.HDP.Tensor.krivineFeature_norm (vc j) (hvc j)).2
  let N := bipartiteUnitGram L R
  have hN : IsCorrelationMatrixOn N :=
    bipartiteUnitGram_isCorrelationMatrixOn L R hL hR
  obtain ⟨u1, v1, hu1, hv1, hgram1⟩ :=
    exists_bipartite_unit_families_gram_eq hN
  let u2 : Fin m → EuclideanSpace ℝ (Fin (m + n)) := fun i =>
    WithLp.toLp 2 (fun k => u1 i (finSumFinEquiv.symm k))
  let v2 : Fin n → EuclideanSpace ℝ (Fin (m + n)) := fun j =>
    WithLp.toLp 2 (fun k => v1 j (finSumFinEquiv.symm k))
  have hu2 (i : Fin m) : ‖u2 i‖ = 1 := by
    rw [NumStability.HDP.Vector.Spherical.norm_toLp_eq_vecNorm2,
      vecNorm2_bipartiteCoordinates, hu1 i]
  have hv2 (j : Fin n) : ‖v2 j‖ = 1 := by
    rw [NumStability.HDP.Vector.Spherical.norm_toLp_eq_vecNorm2,
      vecNorm2_bipartiteCoordinates, hv1 j]
  have hcross0 (i : Fin m) (j : Fin n) :
      ⟪u0 i, v0 j⟫_ℝ = ⟪u i, v j⟫_ℝ := by
    have h := congrFun (congrFun hgram0 (Sum.inl i)) (Sum.inr j)
    simpa [M, bipartiteUnitGram, Matrix.gram_apply] using h
  have hcross1 (i : Fin m) (j : Fin n) :
      ⟪u1 i, v1 j⟫_ℝ = ⟪L i, R j⟫_ℝ := by
    have h := congrFun (congrFun hgram1 (Sum.inl i)) (Sum.inr j)
    simpa [N, bipartiteUnitGram, Matrix.gram_apply] using h
  have hcross2 (i : Fin m) (j : Fin n) :
      ⟪u2 i, v2 j⟫_ℝ = ⟪u1 i, v1 j⟫_ℝ := by
    rw [PiLp.inner_apply]
    change (∑ k, ⟪u1 i (finSumFinEquiv.symm k),
      v1 j (finSumFinEquiv.symm k)⟫_ℝ) = _
    have hinner (a b : ℝ) : ⟪a, b⟫_ℝ = a * b := by
      simpa using (RCLike.inner_apply' a b)
    simp_rw [hinner]
    exact sum_bipartiteCoordinates_mul (u1 i) (v1 j)
  have hpair (i : Fin m) (j : Fin n) :
      NumStability.HDP.Graph.gaussianHyperplaneSignCorrelation (u2 i) (v2 j) =
        NumStability.HDP.Tensor.krivineBeta * ⟪u i, v j⟫_ℝ := by
    calc
      NumStability.HDP.Graph.gaussianHyperplaneSignCorrelation (u2 i) (v2 j) =
          2 / Real.pi * Real.arcsin ⟪u2 i, v2 j⟫_ℝ :=
        NumStability.HDP.Graph.grothendieckSignCorrelation
          (u2 i) (v2 j) (hu2 i) (hv2 j)
      _ = 2 / Real.pi * Real.arcsin ⟪L i, R j⟫_ℝ := by
        rw [hcross2, hcross1]
      _ = NumStability.HDP.Tensor.krivineBeta *
          (∑ k, uc i k * vc j k) := by
        exact NumStability.HDP.Tensor.krivineFeature_arcsin
          (uc i) (vc j) (huc i) (hvc j)
      _ = NumStability.HDP.Tensor.krivineBeta * ⟪u0 i, v0 j⟫_ℝ := by
        rw [sum_bipartiteCoordinates_mul]
      _ = NumStability.HDP.Tensor.krivineBeta * ⟪u i, v j⟫_ℝ := by
        rw [hcross0]
  have hcorr := gaussianHyperplaneCorrelation_bilinear_le_one
    A hsign u2 v2
  have hscaled : NumStability.HDP.Tensor.krivineBeta *
      innerBilinearValue A u v ≤ 1 := by
    calc
      NumStability.HDP.Tensor.krivineBeta * innerBilinearValue A u v =
          ∑ i, ∑ j, A i j *
            NumStability.HDP.Graph.gaussianHyperplaneSignCorrelation (u2 i) (v2 j) := by
        unfold innerBilinearValue
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro i _hi
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro j _hj
        rw [hpair]
        ring
      _ ≤ 1 := hcorr
  have hbeta : 0 < NumStability.HDP.Tensor.krivineBeta := by
    rw [NumStability.HDP.Tensor.krivineBeta]
    exact mul_pos (div_pos (by norm_num) Real.pi_pos)
      NumStability.HDP.Tensor.krivineScale_pos
  calc
    innerBilinearValue A u v =
        NumStability.HDP.Tensor.krivineBeta⁻¹ *
          (NumStability.HDP.Tensor.krivineBeta * innerBilinearValue A u v) := by
      field_simp [ne_of_gt hbeta]
    _ ≤ NumStability.HDP.Tensor.krivineBeta⁻¹ * 1 :=
      mul_le_mul_of_nonneg_left hscaled (inv_nonneg.mpr hbeta.le)
    _ = NumStability.HDP.Tensor.krivineBeta⁻¹ := mul_one _

end NumStability.HDP.Optimization
