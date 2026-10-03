import ComputationalMathematics.Source.Vershynin.Chapter04.Theorem461.Contract

/-!
# Vershynin Chapter 4, Equation (4.21)
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

/-- Vershynin, Equation (4.21): the ordered SVD coefficients lie between
its extreme coefficients, and the simultaneous endpoint failure probability
has the printed constant, scale and exponent. -/
theorem hdp_04_equation_4_21 :
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
  rcases hdp_04_theorem_4_6_1 with ⟨C, hC, htail⟩
  refine ⟨C, hC, ?_⟩
  intro Ω instΩ μ instμ m n hm A K hK hMeas hLp hMean hIso hPsi hIndep t ht
    r s u v hSVD
  refine ⟨?_, htail hm A hK hMeas hLp hMean hIso hPsi hIndep ht r s u v hSVD⟩
  intro ω i
  exact ⟨(hSVD ω).singularValues_antitone (Fin.le_last i),
    (hSVD ω).singularValues_antitone (Fin.zero_le i)⟩

end NumStability.HDP.Contract
