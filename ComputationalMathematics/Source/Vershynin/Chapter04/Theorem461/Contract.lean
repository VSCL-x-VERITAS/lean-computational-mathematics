import ComputationalMathematics.HDP.Matrix.IsotropicRows
import ComputationalMathematics.Analysis.SingularValues.ExtremeValues

/-!
# Vershynin Chapter 4, Theorem 4.6.1
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal

namespace NumStability.HDP.Contract

/-- Vershynin, Theorem 4.6.1: the extreme coefficients of any certified
ordered SVD of a random matrix with independent mean-zero isotropic
sub-Gaussian rows satisfy the two-sided estimate at scale `C K² (√n+t)`
with simultaneous failure probability at most `2 exp (-t²)`.
Each matrix admits a certificate and every certificate has the same endpoint
coefficients, so no measurability premise on certificate choices is required. -/
theorem hdp_04_theorem_4_6_1 :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ}
        (_hm : 0 < m)
        (A : Ω → Matrix (Fin m) (Fin (n + 1)) ℝ) {K : ℝ},
        1 ≤ K →
        (∀ i j, Measurable (fun ω => A ω i j)) →
        (∀ i j, MemLp (fun ω => A ω i j) 2 μ) →
        (∀ i j, ∫ ω, A ω i j ∂μ = 0) →
        (∀ i, NumStability.HDP.Vector.Isotropy.IsIsotropic μ
          (fun j ω => A ω i j)) →
        (∀ i, NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω => A ω i j) ≤ ENNReal.ofReal K) →
        iIndepFun (fun i ω => fun j => A ω i j) μ →
        ∀ {t : ℝ}, 0 ≤ t →
          ∀ (r : Ω → ℕ) (s : Ω → Fin (n + 1) → ℝ)
            (u : ∀ ω, Fin (r ω) → EuclideanSpace ℝ (Fin m))
            (v : ∀ ω, Fin (r ω) → EuclideanSpace ℝ (Fin (n + 1))),
            (∀ ω, NumStability.IsRealMatrixSVD (A ω) (r ω) (s ω) (u ω) (v ω)) →
          μ.real {ω |
            Real.sqrt (m : ℝ) -
                  C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t) >
                s ω (Fin.last n) ∨
              s ω ⟨0, Nat.succ_pos n⟩ >
                Real.sqrt (m : ℝ) +
                  C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t)} ≤
            2 * Real.exp (-(t ^ 2)) := by
  rcases
      NumStability.HDP.Matrix.exists_extremeSingularValue_tail_of_independent_isotropic_subGaussian_rows with
    ⟨C, hC, htail⟩
  refine ⟨C, hC, ?_⟩
  intro Ω instΩ μ instμ m n hm A K hK hMeas hLp hMean hIso hPsi hIndep t ht
    r s u v hSVD
  have hevent :
      {ω | Real.sqrt (m : ℝ) - C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t) >
          s ω (Fin.last n) ∨
        s ω ⟨0, Nat.succ_pos n⟩ >
          Real.sqrt (m : ℝ) + C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t)} =
      {ω | Real.sqrt (m : ℝ) - C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t) >
          NumStability.rectCourantFischerSingularValue (A ω) (Fin.last n) ∨
        NumStability.rectCourantFischerSingularValue (A ω) (0 : Fin (n + 1)) >
          Real.sqrt (m : ℝ) + C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t)} := by
    ext ω
    simp only [Set.mem_setOf_eq]
    rw [(hSVD ω).extremeSingularValues_eq_rectCourantFischer.1,
      (hSVD ω).extremeSingularValues_eq_rectCourantFischer.2]
  rw [hevent]
  exact htail hm A hK hMeas hLp hMean hIso hPsi hIndep ht

/-- Theorem 4.6.1 with exhaustive coordinate SVD data and a scalar gauge
bound along every unit direction. These premises are equivalent to the
existing decomposition and vector-gauge premises, pointwise in the sample. -/
theorem hdp_04_theorem_4_6_1_explicit_svd :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ}
        (_hm : 0 < m)
        (A : Ω → Matrix (Fin m) (Fin (n + 1)) ℝ) {K : ℝ},
        1 ≤ K →
        (∀ i j, Measurable (fun ω => A ω i j)) →
        (∀ i j, MemLp (fun ω => A ω i j) 2 μ) →
        (∀ i j, ∫ ω, A ω i j ∂μ = 0) →
        (∀ i, NumStability.HDP.Vector.Isotropy.IsIsotropic μ
          (fun j ω => A ω i j)) →
        (∀ i (z : Fin (n + 1) → ℝ), (∑ j, z j ^ 2) = 1 →
          NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
            (fun ω ↦ ∑ j, A ω i j * z j) ≤ ENNReal.ofReal K) →
        iIndepFun (fun i ω => fun j => A ω i j) μ →
        ∀ {t : ℝ}, 0 ≤ t →
          ∀ (r : Ω → ℕ) (s : Ω → Fin (n + 1) → ℝ)
            (u : ∀ ω, Fin (r ω) → EuclideanSpace ℝ (Fin m))
            (v : ∀ ω, Fin (r ω) → EuclideanSpace ℝ (Fin (n + 1))),
            (∀ ω, NumStability.RealMatrixSVDExplicitFields
              (A ω) (r ω) (s ω) (u ω) (v ω)) →
          μ.real {ω |
            Real.sqrt (m : ℝ) -
                  C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t) >
                s ω (Fin.last n) ∨
              s ω ⟨0, Nat.succ_pos n⟩ >
                Real.sqrt (m : ℝ) +
                  C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t)} ≤
            2 * Real.exp (-(t ^ 2)) := by
  obtain ⟨C, hC, htail⟩ := hdp_04_theorem_4_6_1
  refine ⟨C, hC, ?_⟩
  intro Ω instΩ μ instμ m n hm A K hK hMeas hLp hMean hIso hMarginal hIndep t ht
    r s u v hFields
  exact htail hm A hK hMeas hLp hMean hIso
    (fun i ↦ NumStability.HDP.Vector.SubGaussian.psiTwoNorm_le_iff_unit_marginals.mpr
      (hMarginal i)) hIndep ht r s u v
    (fun ω ↦ NumStability.isRealMatrixSVD_iff_explicit_fields.mpr (hFields ω))

end NumStability.HDP.Contract
