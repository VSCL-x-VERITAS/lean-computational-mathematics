import ComputationalMathematics.HDP.Matrix.OperatorNormSubGaussian
import ComputationalMathematics.HDP.Matrix.OperatorNormIntegrability
import ComputationalMathematics.HDP.Probability.TailExpectation

/-!
# Expected operator norm of a sub-Gaussian matrix

The Chapter 4 operator-norm tail is integrated here using the reusable
layer-cake bridge.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Matrix

/-- A rectangular matrix with independent centered sub-Gaussian entries has
expected operator norm of order `K (sqrt m + sqrt n)`. -/
theorem exists_expected_operatorNorm_bound_of_independent_centered_subGaussian_entries :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ} (hm : 0 < m) (hn : 0 < n),
        letI : Nonempty (Fin m) := Fin.pos_iff_nonempty.mp hm
        letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
        ∀ (A : Ω → Matrix (Fin m) (Fin n) ℝ),
        (∀ ij : Fin m × Fin n,
          NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
            (fun ω => A ω ij.1 ij.2)) →
        (∀ ij : Fin m × Fin n,
          Integrable (fun ω => A ω ij.1 ij.2) μ ∧
            (∫ ω, A ω ij.1 ij.2 ∂μ) = 0) →
        iIndepFun (fun ij : Fin m × Fin n =>
          fun ω => A ω ij.1 ij.2) μ →
        (∫ ω, NumStability.realMatrixOperatorNorm (A ω) ∂μ) ≤
          C * NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
              (fun ij : Fin m × Fin n => fun ω => A ω ij.1 ij.2) *
            (Real.sqrt m + Real.sqrt n) := by
  rcases exists_operatorNorm_tail_of_independent_centered_subGaussian_entries with
    ⟨C₀, hC₀, htail⟩
  refine ⟨2 * C₀, by positivity, ?_⟩
  intro Ω _ μ _ m n hm hn A hSub hCenter hIndep
  letI : Nonempty (Fin m) := Fin.pos_iff_nonempty.mp hm
  letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
  have hNormInt : Integrable
      (fun ω => NumStability.realMatrixOperatorNorm (A ω)) μ :=
    integrable_realMatrixOperatorNorm_of_entries A (fun ij => (hCenter ij).1)
  let X : Fin m × Fin n → Ω → ℝ :=
    fun ij ω => A ω ij.1 ij.2
  let K : ℝ :=
    NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X
  change (∫ ω, NumStability.realMatrixOperatorNorm (A ω) ∂μ) ≤
    (2 * C₀) * K * (Real.sqrt m + Real.sqrt n)
  by_cases hKzero : K = 0
  · have hEntryZero : ∀ ij : Fin m × Fin n,
        (fun ω => A ω ij.1 ij.2) =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) := by
      intro ij
      have hRealZero :
          (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ (X ij)).toReal = 0 := by
        apply le_antisymm
        · exact (NumStability.HDP.Scalar.SubGaussian.psiTwoNorm_toReal_le_max
            (μ := μ) (X := X) ij).trans_eq hKzero
        · exact ENNReal.toReal_nonneg
      have hFinite :
          NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ (X ij) < ∞ :=
        (NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite
          (μ := μ) (X := X ij)).mp (hSub ij)
      have hNormZero :
          NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ (X ij) = 0 :=
        ((ENNReal.toReal_eq_zero_iff _).mp hRealZero).resolve_right
          (ne_of_lt hFinite)
      apply (NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_eq_zero_iff_ae_eq_zero
        (hSub ij).1).mp
      simpa [NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm] using hNormZero
    have hAllZero :
        ∀ᵐ ω ∂μ, ∀ ij ∈ (Finset.univ : Finset (Fin m × Fin n)),
          A ω ij.1 ij.2 = 0 := by
      rw [Filter.eventually_all_finset]
      intro ij _hij
      exact hEntryZero ij
    have hMatrixZero : A =ᵐ[μ]
        (fun _ : Ω => (0 : Matrix (Fin m) (Fin n) ℝ)) := by
      filter_upwards [hAllZero] with ω hω
      ext i j
      exact hω (i, j) (Finset.mem_univ _)
    have hOpZero :
        (fun ω => NumStability.realMatrixOperatorNorm (A ω)) =ᵐ[μ]
          (fun _ : Ω => (0 : ℝ)) := by
      filter_upwards [hMatrixZero] with ω hω
      simp [hω, NumStability.realMatrixOperatorNorm,
        NumStability.realMatrixContinuousLinearMap]
    rw [integral_congr_ae hOpZero, hKzero]
    simp
  · have hKnonneg : 0 ≤ K := by
      simpa [K] using
        (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax_nonneg
          (μ := μ) (X := X))
    have hK : 0 < K := lt_of_le_of_ne hKnonneg (Ne.symm hKzero)
    let S : ℝ := Real.sqrt n + Real.sqrt m
    have hb : 0 < C₀ * K := mul_pos hC₀ hK
    have htail' : ∀ {t : ℝ}, 0 < t →
        μ.real {ω |
          C₀ * K * S + (C₀ * K) * t <
            NumStability.realMatrixOperatorNorm (A ω)} ≤
          2 * Real.exp (-t ^ 2) := by
      intro t ht
      have h := htail hm hn A hSub hCenter hIndep ht
      simpa [K, X, S, mul_add] using h
    have hExpected :=
      NumStability.HDP.Probability.expectation_le_add_mul_sqrt_pi_of_gaussian_upper_tail
        hNormInt hb htail'
    have hn1 : (1 : ℝ) ≤ (n : ℝ) := by
      exact_mod_cast (Nat.one_le_iff_ne_zero.mpr (Nat.ne_of_gt hn))
    have hm1 : (1 : ℝ) ≤ (m : ℝ) := by
      exact_mod_cast (Nat.one_le_iff_ne_zero.mpr (Nat.ne_of_gt hm))
    have hsqrtn : 1 ≤ Real.sqrt (n : ℝ) := (Real.one_le_sqrt).2 hn1
    have hsqrtm : 1 ≤ Real.sqrt (m : ℝ) := (Real.one_le_sqrt).2 hm1
    have hS : 2 ≤ S := by dsimp [S]; linarith
    have hsqrtpi : Real.sqrt Real.pi ≤ 2 := by
      exact (Real.sqrt_le_iff).2 ⟨by norm_num, by nlinarith [Real.pi_le_four]⟩
    have hsqrtpiS : Real.sqrt Real.pi ≤ S := hsqrtpi.trans hS
    calc
      (∫ ω, NumStability.realMatrixOperatorNorm (A ω) ∂μ) ≤
          C₀ * K * S + (C₀ * K) * Real.sqrt Real.pi := hExpected
      _ ≤ C₀ * K * S + C₀ * K * S :=
        add_le_add le_rfl (mul_le_mul_of_nonneg_left hsqrtpiS hb.le)
      _ = C₀ * K * (S + S) := by ring
      _ = (2 * C₀) * K * (Real.sqrt m + Real.sqrt n) := by
        dsimp [S]
        ring

end NumStability.HDP.Matrix
