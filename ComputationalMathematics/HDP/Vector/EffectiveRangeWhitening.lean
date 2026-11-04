import ComputationalMathematics.Analysis.SingularValues.CompactSVD

import ComputationalMathematics.HDP.Vector.Whitening

/-!
# Whitening on the effective raw-moment range

Exact constructed factors and actual empirical error include singular and rank-zero populations.
-/

noncomputable section

set_option backward.isDefEq.respectTransparency false

namespace NumStability.HDP.Vector.Whitening

section

open _root_.MeasureTheory _root_.ProbabilityTheory _root_.Matrix

open scoped ENNReal NNReal MatrixOrder BigOperators

open NumStability.HDP.Vector

theorem compactSVD_raw_factor_and_left_inverse
    {m n r : ℕ} (A : Matrix (Fin m) (Fin n) ℝ)
    (U : Matrix (Fin m) (Fin r) ℝ) (d : Fin r → ℝ)
    (V : Matrix (Fin n) (Fin r) ℝ)
    (hSVD : NumStability.Higham20CompactRealSVD A U d V) :
    let B := U * Matrix.diagonal d
    let P := Matrix.diagonal (fun i ↦ (d i)⁻¹) * U.transpose
    A * A.transpose = B * B.transpose ∧ P * B = 1 := by
  let B := U * Matrix.diagonal d
  let P := Matrix.diagonal (fun i ↦ (d i)⁻¹) * U.transpose
  have hA : B * V.transpose = A := hSVD.factorization
  have hU : U.transpose * U = 1 := hSVD.left_columns_orthonormal
  have hV : V.transpose * V = 1 := hSVD.right_columns_orthonormal
  have hDiag : Matrix.diagonal (fun i ↦ (d i)⁻¹) * Matrix.diagonal d = 1 :=
    NumStability.finiteMatMul_finiteDiagonal_inv_self
      (fun i ↦ ne_of_gt (hSVD.singularValue_pos i))
  constructor
  · rw [← hA, Matrix.transpose_mul, Matrix.transpose_transpose,
      Matrix.mul_assoc, ← Matrix.mul_assoc V.transpose V B.transpose,
      hV, Matrix.one_mul]
  · change (Matrix.diagonal (fun i ↦ (d i)⁻¹) * U.transpose) *
      (U * Matrix.diagonal d) = 1
    rw [Matrix.mul_assoc, ← Matrix.mul_assoc U.transpose U (Matrix.diagonal d),
      hU, Matrix.one_mul, hDiag]

theorem exists_raw_covariance_factor_left_inverse {n : ℕ}
    (Sigma : Matrix (Fin n) (Fin n) ℝ) (hPSD : Sigma.PosSemidef) :
    ∃ r : ℕ, r ≤ n ∧
      ∃ (B : Matrix (Fin n) (Fin r) ℝ) (P : Matrix (Fin r) (Fin n) ℝ),
        Sigma = B * B.transpose ∧ P * B = 1 := by
  let A : Matrix (Fin n) (Fin n) ℝ := CFC.sqrt Sigma
  let s := NumStability.Ch14Ext.ch14ext_nonzeroRightGramSingularIndices A
  let U : Matrix (Fin n) (Fin s.card) ℝ := NumStability.Ch14Ext.ch14ext_compactSVDLeft A
  let d : Fin s.card → ℝ := NumStability.Ch14Ext.ch14ext_compactSVDSingularValues A
  let V : Matrix (Fin n) (Fin s.card) ℝ := NumStability.Ch14Ext.ch14ext_compactSVDRight A
  have hSVD := NumStability.Ch14Ext.ch14ext_compactSVD_certificate A
  have hFactor := compactSVD_raw_factor_and_left_inverse A U d V hSVD
  have hBound : s.card ≤ n := by
    simpa only [Finset.card_univ, Fintype.card_fin] using
      (Finset.card_le_card (Finset.subset_univ s))
  refine ⟨s.card, hBound, U * Matrix.diagonal d,
    Matrix.diagonal (fun i ↦ (d i)⁻¹) * U.transpose, ?_, hFactor.2⟩
  exact (NumStability.HDP.Vector.Whitening.positive_squareRoot_factor
    Sigma hPSD).1.trans hFactor.1

theorem exists_actual_effective_range_whitening
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {m n : ℕ} (X : Ω → Fin n → ℝ) (Xsample : Fin m → Ω → Fin n → ℝ) (K : ℝ≥0)
    (hSG : SubGaussian.IsSubGaussian μ (fun j ω ↦ X ω j))
    (hRelative : SubGaussian.SatisfiesPsiTwoL2Bound μ (fun j ω ↦ X ω j) K)
    (hMeas : ∀ j, Measurable (fun ω ↦ X ω j))
    (hSampleMeas : ∀ i j, Measurable (fun ω ↦ Xsample i ω j))
    (hLaw : ∀ i, IdentDistrib (Xsample i) X μ μ) (hIndep : iIndepFun Xsample μ) :
    ∃ r : ℕ, r ≤ n ∧
      ∃ (B : Matrix (Fin n) (Fin r) ℝ) (P : Matrix (Fin r) (Fin n) ℝ),
        Covariance.secondMomentMatrix μ (fun j ω ↦ X ω j) = B * B.transpose ∧
        P * B = 1 ∧
        let Z := fun ω ↦ P.mulVec (X ω)
        let Zsample := fun i ω ↦ P.mulVec (Xsample i ω)
        Isotropy.IsIsotropic μ (fun j ω ↦ Z ω j) ∧
          SubGaussian.IsSubGaussian μ (fun j ω ↦ Z ω j) ∧
          SubGaussian.SatisfiesPsiTwoL2Bound μ (fun j ω ↦ Z ω j) K ∧
          SubGaussian.PsiTwoNorm μ (fun j ω ↦ Z ω j) ≤ (K : ℝ≥0∞) ∧
          (∀ i, IdentDistrib (Zsample i) Z μ μ) ∧
          iIndepFun Zsample μ ∧
          (∀ i, SubGaussian.PsiTwoNorm μ (fun j ω ↦ Zsample i ω j) ≤ (K : ℝ≥0∞)) ∧
          (X =ᵐ[μ] fun ω ↦ B.mulVec (Z ω)) ∧
          (∀ᵐ ω ∂μ, ∀ i, Xsample i ω = B.mulVec (Zsample i ω)) := by
  have hLp := NumStability.HDP.Vector.Whitening.coordinate_memLp_of_subGaussian hSG
  have hPSD := Covariance.secondMomentMatrix_posSemidef (fun j ω ↦ X ω j) hLp
  obtain ⟨r, hr, B, P, hSecond, hLeft⟩ :=
    exists_raw_covariance_factor_left_inverse _ hPSD
  exact ⟨r, hr, B, P, hSecond, hLeft,
    NumStability.HDP.Vector.Whitening.actual_rectangular_whitening
      B P X Xsample K hLp hSecond hLeft hSG hRelative hMeas hSampleMeas hLaw hIndep⟩

end

section

open _root_.MeasureTheory _root_.ProbabilityTheory _root_.Matrix

open scoped ENNReal NNReal MatrixOrder BigOperators

open NumStability.HDP.Vector

open NumStability.HDP.Vector.Covariance

theorem rectangular_error_norm_le_covariance_mul_gram
    {n r : ℕ} (B : Matrix (Fin n) (Fin r) ℝ)
    (R : Matrix (Fin r) (Fin r) ℝ) (Sigma SigmaM : Matrix (Fin n) (Fin n) ℝ)
    (hSigma : Sigma = B * B.transpose)
    (hSigmaM : SigmaM = B * (1 + R) * B.transpose) :
    NumStability.realMatrixOperatorNorm (SigmaM - Sigma) ≤
      NumStability.realMatrixOperatorNorm R * NumStability.realMatrixOperatorNorm Sigma := by
  have hRaw := singularWhitening_error_norm_le B R Sigma SigmaM hSigma hSigmaM
  change NumStability.realMatrixOperatorNorm (SigmaM - Sigma) ≤
    NumStability.realMatrixOperatorNorm B * NumStability.realMatrixOperatorNorm R *
      NumStability.realMatrixOperatorNorm B.transpose at hRaw
  rw [NumStability.HDP.Matrix.realMatrixOperatorNorm_transpose] at hRaw
  calc
    NumStability.realMatrixOperatorNorm (SigmaM - Sigma) ≤
        NumStability.realMatrixOperatorNorm B * NumStability.realMatrixOperatorNorm R *
          NumStability.realMatrixOperatorNorm B := hRaw
    _ = NumStability.realMatrixOperatorNorm R *
        NumStability.realMatrixOperatorNorm B ^ 2 := by ring
    _ = NumStability.realMatrixOperatorNorm R * NumStability.realMatrixOperatorNorm Sigma := by
      rw [hSigma, realMatrixOperatorNorm_mul_transpose_self]

theorem actual_rectangular_sample_error_of_rows
    {m n r : ℕ} (B : Matrix (Fin n) (Fin r) ℝ)
    (Sigma : Matrix (Fin n) (Fin n) ℝ)
    (X : Matrix (Fin m) (Fin n) ℝ) (Z : Matrix (Fin m) (Fin r) ℝ)
    (hSigma : Sigma = B * B.transpose)
    (hRows : ∀ i, X i = B.mulVec (Z i)) :
    let Rm := (m : ℝ)⁻¹ • (Z.transpose * Z) - 1
    sampleCovariance X - Sigma = B * Rm * B.transpose ∧
      NumStability.realMatrixOperatorNorm (sampleCovariance X - Sigma) ≤
        NumStability.realMatrixOperatorNorm Rm * NumStability.realMatrixOperatorNorm Sigma := by
  let Rm := (m : ℝ)⁻¹ • (Z.transpose * Z) - 1
  have hEmpirical : sampleCovariance X = B * (1 + Rm) * B.transpose := by
    rw [show X = (fun i ↦ B.mulVec (Z i)) from funext hRows,
      NumStability.HDP.Vector.Whitening.sampleCovariance_factor]
    have hCancel : 1 + Rm = (m : ℝ)⁻¹ • (Z.transpose * Z) := by
      dsimp [Rm]
      abel
    rw [hCancel]
  exact ⟨singularWhitening_error_factorization B Rm Sigma (sampleCovariance X) hSigma hEmpirical,
    rectangular_error_norm_le_covariance_mul_gram B Rm Sigma (sampleCovariance X) hSigma hEmpirical⟩

theorem exists_actual_empirical_error_factor_ae
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {m n : ℕ}
    (X : Ω → Fin n → ℝ) (Xsample : Fin m → Ω → Fin n → ℝ)
    (hLp : ∀ j, MemLp (fun ω ↦ X ω j) 2 μ)
    (hLaw : ∀ i, IdentDistrib (Xsample i) X μ μ) :
    let Sigma := secondMomentMatrix μ (fun j ω ↦ X ω j)
    ∃ r : ℕ, r ≤ n ∧
      ∃ (B : Matrix (Fin n) (Fin r) ℝ) (P : Matrix (Fin r) (Fin n) ℝ),
        Sigma = B * B.transpose ∧ P * B = 1 ∧
          ∀ᵐ ω ∂μ,
            let Z : Matrix (Fin m) (Fin r) ℝ := fun i ↦ P.mulVec (Xsample i ω)
            let Rm := (m : ℝ)⁻¹ • (Z.transpose * Z) - 1
            randomSampleCovariance Xsample ω - Sigma = B * Rm * B.transpose ∧
              NumStability.realMatrixOperatorNorm (randomSampleCovariance Xsample ω - Sigma) ≤
                NumStability.realMatrixOperatorNorm Rm * NumStability.realMatrixOperatorNorm Sigma := by
  let Sigma := secondMomentMatrix μ (fun j ω ↦ X ω j)
  obtain ⟨r, hr, B, P, hSigma, hLeft⟩ :=
    NumStability.HDP.Vector.Whitening.exists_raw_covariance_factor_left_inverse Sigma
      (secondMomentMatrix_posSemidef (fun j ω ↦ X ω j) hLp)
  refine ⟨r, hr, B, P, hSigma, hLeft, ?_⟩
  have hEach : ∀ i, Xsample i =ᵐ[μ] fun ω ↦ B.mulVec (P.mulVec (Xsample i ω)) :=
    fun i ↦ NumStability.HDP.Vector.Whitening.reconstruction_of_identDistrib
      B P X (Xsample i) hLp hSigma hLeft (hLaw i)
  have hAll : ∀ᵐ ω ∂μ, ∀ i, Xsample i ω = B.mulVec (P.mulVec (Xsample i ω)) :=
    ae_all_iff.mpr hEach
  filter_upwards [hAll] with ω hω
  exact actual_rectangular_sample_error_of_rows B Sigma (fun i ↦ Xsample i ω)
    (fun i ↦ P.mulVec (Xsample i ω)) hSigma hω

end

end NumStability.HDP.Vector.Whitening

end
