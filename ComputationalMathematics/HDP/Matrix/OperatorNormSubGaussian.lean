import ComputationalMathematics.HDP.Matrix.SubGaussianEntries
import ComputationalMathematics.HDP.Matrix.NetUnionBound
import ComputationalMathematics.HDP.Metric.EuclideanSphereCovering
import Mathlib.Analysis.Complex.ExponentialBounds

/-!
# Operator norm of a matrix with sub-Gaussian bilinear tails

The net construction and finite-union estimate are combined here with explicit
constant arithmetic. Entrywise independence is connected to the fixed-vector
hypothesis in `SubGaussianEntries`.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set
open scoped ENNReal BigOperators RealInnerProductSpace

namespace NumStability.HDP.Matrix

/-- Explicit arithmetic that absorbs the cardinality of two quarter-nets into
a sub-Gaussian exponent. -/
lemma nine_pow_mul_subGaussian_exp_le
    {m n : ℕ} {c K t : ℝ} (hc : 0 < c) (hK : 0 < K) (ht : 0 ≤ t) :
    let C := 8 * max 1 c⁻¹
    let S := Real.sqrt n + Real.sqrt m + t
    (9 ^ (n + m) : ℕ) *
        (2 * Real.exp (-(c * ((C * K * S) / 2) ^ 2 / K ^ 2))) ≤
      2 * Real.exp (-t ^ 2) := by
  dsimp only
  let q : ℝ := max 1 c⁻¹
  have hq1 : 1 ≤ q := le_max_left _ _
  have hqinv : c⁻¹ ≤ q := le_max_right _ _
  have hcinv : c * c⁻¹ = 1 := mul_inv_cancel₀ hc.ne'
  have hcq : 1 ≤ c * q := by
    rw [← hcinv]
    exact mul_le_mul_of_nonneg_left hqinv hc.le
  have hcq2 : 1 ≤ c * q ^ 2 := by
    nlinarith
  let S : ℝ := Real.sqrt n + Real.sqrt m + t
  have hn0 : 0 ≤ (n : ℝ) := by positivity
  have hm0 : 0 ≤ (m : ℝ) := by positivity
  have hnm0 : 0 ≤ (n + m : ℝ) := by positivity
  have hsqrtn : (Real.sqrt n) ^ 2 = (n : ℝ) := by
    exact Real.sq_sqrt hn0
  have hsqrtm : (Real.sqrt m) ^ 2 = (m : ℝ) := by
    exact Real.sq_sqrt hm0
  have hS : (n + m : ℝ) + t ^ 2 ≤ S ^ 2 := by
    dsimp [S]
    nlinarith [Real.sqrt_nonneg (n : ℝ), Real.sqrt_nonneg (m : ℝ)]
  have hexponent :
      16 * ((n + m : ℝ) + t ^ 2) ≤
        c * ((8 * q * K * S) / 2) ^ 2 / K ^ 2 := by
    have hmain : 16 * S ^ 2 ≤
        c * ((8 * q * K * S) / 2) ^ 2 / K ^ 2 := by
      field_simp [hK.ne']
      nlinarith [sq_nonneg K, sq_nonneg S]
    exact (mul_le_mul_of_nonneg_left hS (by norm_num)).trans hmain
  have he4 : (9 : ℝ) ≤ Real.exp 4 := by
    calc
      (9 : ℝ) ≤ 2 ^ 4 := by norm_num
      _ ≤ (Real.exp 1) ^ 4 :=
        pow_le_pow_left₀ (by norm_num) Real.exp_one_gt_two.le 4
      _ = Real.exp 4 := by
        rw [← Real.exp_nat_mul]
        norm_num
  have hcard : ((9 ^ (n + m) : ℕ) : ℝ) ≤
      Real.exp (4 * (n + m : ℝ)) := by
    calc
      ((9 ^ (n + m) : ℕ) : ℝ) = (9 : ℝ) ^ (n + m) := by norm_cast
      _ ≤ (Real.exp 4) ^ (n + m) :=
        pow_le_pow_left₀ (by norm_num) he4 (n + m)
      _ = Real.exp (4 * (n + m : ℝ)) := by
        rw [← Real.exp_nat_mul]
        congr 1
        push_cast
        ring
  calc
    (9 ^ (n + m) : ℕ) *
          (2 * Real.exp (-(c * ((8 * max 1 c⁻¹ * K *
            (Real.sqrt n + Real.sqrt m + t)) / 2) ^ 2 / K ^ 2))) ≤
        Real.exp (4 * (n + m : ℝ)) *
          (2 * Real.exp (-(c * ((8 * q * K * S) / 2) ^ 2 / K ^ 2))) := by
      dsimp [q, S]
      gcongr
    _ = 2 * Real.exp
        (4 * (n + m : ℝ) -
          c * ((8 * q * K * S) / 2) ^ 2 / K ^ 2) := by
      calc
        Real.exp (4 * (n + m : ℝ)) *
            (2 * Real.exp (-(c * ((8 * q * K * S) / 2) ^ 2 / K ^ 2))) =
            2 * (Real.exp (4 * (n + m : ℝ)) *
              Real.exp (-(c * ((8 * q * K * S) / 2) ^ 2 / K ^ 2))) := by ring
        _ = 2 * Real.exp
            (4 * (n + m : ℝ) -
              c * ((8 * q * K * S) / 2) ^ 2 / K ^ 2) := by
          rw [← Real.exp_add]
          congr 2
    _ ≤ 2 * Real.exp (-t ^ 2) := by
      gcongr
      nlinarith

/-- A uniform fixed-vector sub-Gaussian tail yields the standard rectangular
matrix operator-norm tail. -/
theorem operatorNorm_tail_of_fixed_bilinear_subGaussian
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {m n : ℕ} (hm : 0 < m) (hn : 0 < n)
    (A : Ω → Matrix (Fin m) (Fin n) ℝ) {c K : ℝ}
    (hc : 0 < c) (hK : 0 < K)
    (hfixed : ∀ (x : EuclideanSpace ℝ (Fin n))
      (y : EuclideanSpace ℝ (Fin m)),
      ‖x‖ = 1 → ‖y‖ = 1 →
      ∀ {u : ℝ}, 0 ≤ u →
        μ.real {ω | |inner ℝ (Matrix.toEuclideanLin (A ω) x) y| ≥ u} ≤
          2 * Real.exp (-(c * u ^ 2 / K ^ 2))) :
    let C := 8 * max 1 c⁻¹
    0 < C ∧ ∀ {t : ℝ}, 0 < t →
      μ.real {ω |
        C * K * (Real.sqrt n + Real.sqrt m + t) <
          NumStability.realMatrixOperatorNorm (A ω)} ≤
        2 * Real.exp (-t ^ 2) := by
  dsimp only
  let C : ℝ := 8 * max 1 c⁻¹
  have hC : 0 < C := by
    dsimp [C]
    positivity
  refine ⟨hC, ?_⟩
  intro t ht
  obtain ⟨N, hN, hNne, hNcard⟩ :=
    NumStability.HDP.Metric.exists_quarterNet_card_le_nine_pow n hn
  obtain ⟨M, hM, hMne, hMcard⟩ :=
    NumStability.HDP.Metric.exists_quarterNet_card_le_nine_pow m hm
  let S : ℝ := Real.sqrt n + Real.sqrt m + t
  let u : ℝ := C * K * S / 2
  have hS : 0 ≤ S := by
    dsimp [S]
    positivity
  have hu : 0 ≤ u := by
    dsimp [u]
    positivity
  have hpair : ∀ x ∈ N, ∀ y ∈ M,
      μ.real {ω | u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) x) y} ≤
        2 * Real.exp (-(c * u ^ 2 / K ^ 2)) := by
    intro x hx y hy
    calc
      μ.real {ω | u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) x) y} ≤
          μ.real {ω | |inner ℝ (Matrix.toEuclideanLin (A ω) x) y| ≥ u} := by
        apply measureReal_mono
        intro ω hω
        change u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) x) y at hω
        change u ≤ |inner ℝ (Matrix.toEuclideanLin (A ω) x) y|
        exact hω.trans (le_abs_self _)
        exact measure_ne_top μ _
      _ ≤ 2 * Real.exp (-(c * u ^ 2 / K ^ 2)) :=
        hfixed x y (hN.1 x hx) (hM.1 y hy) hu
  have hnet := measureReal_realMatrixOperatorNorm_gt_two_mul_le_nine_pow
    (μ := μ) A N M hN hM hNne hMne hNcard hMcard u
      (2 * Real.exp (-(c * u ^ 2 / K ^ 2))) (by positivity) hpair
  have hnum := nine_pow_mul_subGaussian_exp_le
    (m := m) (n := n) hc hK ht.le
  have hthreshold :
      2 * u = C * K * (Real.sqrt n + Real.sqrt m + t) := by
    dsimp [u, S]
    ring
  calc
    μ.real {ω |
        C * K * (Real.sqrt n + Real.sqrt m + t) <
          NumStability.realMatrixOperatorNorm (A ω)} =
        μ.real {ω | 2 * u < NumStability.realMatrixOperatorNorm (A ω)} := by
      rw [hthreshold]
    _ ≤ (9 ^ (n + m) : ℕ) *
        (2 * Real.exp (-(c * u ^ 2 / K ^ 2))) := hnet
    _ ≤ 2 * Real.exp (-t ^ 2) := by
      simpa [C, u, S] using hnum

/-- A rectangular matrix with independent centered sub-Gaussian entries has
the standard operator-norm upper tail. The absolute constant is uniform over
the probability space, dimensions, entry distributions, and threshold. -/
theorem exists_operatorNorm_tail_of_independent_centered_subGaussian_entries :
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
        ∀ {t : ℝ}, 0 < t →
          μ.real {ω |
            C * NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
                (fun ij : Fin m × Fin n => fun ω => A ω ij.1 ij.2) *
                (Real.sqrt n + Real.sqrt m + t) <
              NumStability.realMatrixOperatorNorm (A ω)} ≤
            2 * Real.exp (-t ^ 2) := by
  rcases exists_fixed_bilinear_tail_of_independent_subGaussian_entries with
    ⟨c, hc, htail⟩
  let C : ℝ := 8 * max 1 c⁻¹
  have hC : 0 < C := by
    dsimp [C]
    positivity
  refine ⟨C, hC, ?_⟩
  intro Ω instΩ μ instμ m n hm hn A hSub hCenter hIndep t ht
  letI : Nonempty (Fin m) := Fin.pos_iff_nonempty.mp hm
  letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
  let X : Fin m × Fin n → Ω → ℝ :=
    fun ij ω => A ω ij.1 ij.2
  let K : ℝ :=
    NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X
  have hfixed := htail A hSub hCenter hIndep
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
    have hMatrixZero : A =ᵐ[μ] (fun _ : Ω => (0 : Matrix (Fin m) (Fin n) ℝ)) := by
      filter_upwards [hAllZero] with ω hω
      ext i j
      exact hω (i, j) (Finset.mem_univ _)
    have hEventZero :
        μ {ω | 0 < NumStability.realMatrixOperatorNorm (A ω)} = 0 := by
      rw [measure_eq_zero_iff_ae_notMem]
      filter_upwards [hMatrixZero] with ω hω
      simp [hω, NumStability.realMatrixOperatorNorm,
        NumStability.realMatrixContinuousLinearMap]
    have hRealEventZero :
        μ.real {ω | 0 < NumStability.realMatrixOperatorNorm (A ω)} = 0 := by
      rw [Measure.real_def, hEventZero]
      simp
    change μ.real {ω | C * K *
        (Real.sqrt n + Real.sqrt m + t) <
          NumStability.realMatrixOperatorNorm (A ω)} ≤
        2 * Real.exp (-t ^ 2)
    rw [hKzero]
    simpa using hRealEventZero.trans_le (by positivity)
  · have hKnonneg : 0 ≤ K := by
      simpa [K] using
        (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax_nonneg
          (μ := μ) (X := X))
    have hK : 0 < K := lt_of_le_of_ne hKnonneg (Ne.symm hKzero)
    have hmatrix := operatorNorm_tail_of_fixed_bilinear_subGaussian
      (μ := μ) hm hn A hc hK hfixed
    change μ.real {ω | C * K *
        (Real.sqrt n + Real.sqrt m + t) <
          NumStability.realMatrixOperatorNorm (A ω)} ≤
        2 * Real.exp (-t ^ 2)
    simpa [C] using hmatrix.2 ht

end NumStability.HDP.Matrix
