import ComputationalMathematics.HDP.Matrix.NormConcentration

/-!
# Vershynin Chapter 4, Exercise 4.6.4
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal

namespace NumStability.HDP.Contract

/-- Vershynin, Exercise 4.6.4: the conclusion of Theorem 4.6.1, whose
alternative proof combines Theorem 3.1.1 norm concentration with the
unsquared net estimate from Exercise 4.4.4 and a finite union bound.
The complete endpoint statement is preserved. -/
theorem hdp_04_exercise_4_6_4 :
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
          (∀ ω i,
              s ω (Fin.last n) ≤
                s ω i ∧
              s ω i ≤
                s ω ⟨0, Nat.succ_pos n⟩) ∧
            μ.real {ω |
              Real.sqrt (m : ℝ) -
                    C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t) >
                  s ω (Fin.last n) ∨
                s ω ⟨0, Nat.succ_pos n⟩ >
                  Real.sqrt (m : ℝ) +
                    C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t)} ≤
              2 * Real.exp (-(t ^ 2)) := by
  classical
  obtain ⟨C, hC, htail⟩ := NumStability.HDP.Matrix.exists_extremeSingularValue_tail_via_normConcentration
  refine ⟨C, hC, ?_⟩
  intro Ω instΩ μ instμ m n hm A K hK hMeas hLp hMean hIso hPsi hIndep t ht
    r s u v hSVD
  constructor
  · intro ω i
    exact ⟨(hSVD ω).singularValues_antitone (Fin.le_last i),
      (hSVD ω).singularValues_antitone (Fin.zero_le i)⟩
  · have hevent :
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
    exact htail hm A hK hMeas hLp hMean hIso
      hPsi hIndep ht

/-- Exercise 4.6.4 with exhaustive coordinate SVD data and unit scalar
marginals, proved by the same norm-concentration and net-union route.
Both public formulations use one reusable endpoint-tail producer. -/
theorem hdp_04_exercise_4_6_4_explicit_svd :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ}
        (_hm : 0 < m)
        (A : Ω → Matrix (Fin m) (Fin (n + 1)) ℝ) {K : ℝ},
        1 ≤ K →
        (∀ i j, Measurable (fun ω ↦ A ω i j)) →
        (∀ i j, MemLp (fun ω ↦ A ω i j) 2 μ) →
        (∀ i j, ∫ ω, A ω i j ∂μ = 0) →
        (∀ i, NumStability.HDP.Vector.Isotropy.IsIsotropic μ
          (fun j ω ↦ A ω i j)) →
        (∀ i (z : Fin (n + 1) → ℝ), (∑ j, z j ^ 2) = 1 →
          NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
            (fun ω ↦ ∑ j, A ω i j * z j) ≤ ENNReal.ofReal K) →
        iIndepFun (fun i ω ↦ fun j ↦ A ω i j) μ →
        ∀ {t : ℝ}, 0 ≤ t →
          ∀ (r : Ω → ℕ) (s : Ω → Fin (n + 1) → ℝ)
            (u : ∀ ω, Fin (r ω) → EuclideanSpace ℝ (Fin m))
            (v : ∀ ω, Fin (r ω) → EuclideanSpace ℝ (Fin (n + 1))),
            (∀ ω, NumStability.RealMatrixSVDExplicitFields
              (A ω) (r ω) (s ω) (u ω) (v ω)) →
          (∀ ω i, s ω (Fin.last n) ≤ s ω i ∧
              s ω i ≤ s ω ⟨0, Nat.succ_pos n⟩) ∧
            μ.real {ω |
              Real.sqrt (m : ℝ) -
                    C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t) >
                  s ω (Fin.last n) ∨
                s ω ⟨0, Nat.succ_pos n⟩ >
                  Real.sqrt (m : ℝ) +
                    C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t)} ≤
              2 * Real.exp (-(t ^ 2)) := by
  classical
  obtain ⟨C, hC, htail⟩ := NumStability.HDP.Matrix.exists_extremeSingularValue_tail_via_normConcentration
  refine ⟨C, hC, ?_⟩
  intro Ω instΩ μ instμ m n hm A K hK hMeas hLp hMean hIso hMarginal hIndep t ht
    r s u v hFields
  have hSVD : ∀ ω, NumStability.IsRealMatrixSVD
      (A ω) (r ω) (s ω) (u ω) (v ω) :=
    fun ω ↦ NumStability.isRealMatrixSVD_iff_explicit_fields.mpr (hFields ω)
  constructor
  · intro ω i
    exact ⟨(hSVD ω).singularValues_antitone (Fin.le_last i),
      (hSVD ω).singularValues_antitone (Fin.zero_le i)⟩
  · have hevent :
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
    exact htail hm A hK hMeas hLp hMean hIso
      (fun i ↦ NumStability.HDP.Vector.SubGaussian.psiTwoNorm_le_iff_unit_marginals.mpr
        (hMarginal i)) hIndep ht

end NumStability.HDP.Contract
