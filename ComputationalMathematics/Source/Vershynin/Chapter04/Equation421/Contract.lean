import ComputationalMathematics.Source.Vershynin.Chapter04.Theorem461.Contract

/-!
# Vershynin Chapter 4, Equation (4.21)
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

/-- Vershynin, Equation (4.21), exposed separately from its enclosing
Theorem 4.6.1 for source-level traceability.  The first conjunct records the
endpoint-order semantics used by the source notation: index `0` is the largest
singular value and `Fin.last n` is the smallest. -/
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
          (∀ ω i,
              NumStability.rectCourantFischerSingularValue
                  (A ω) (Fin.last n) ≤
                NumStability.rectCourantFischerSingularValue (A ω) i ∧
              NumStability.rectCourantFischerSingularValue (A ω) i ≤
                NumStability.rectCourantFischerSingularValue
                  (A ω) (0 : Fin (n + 1))) ∧
            μ.real {ω |
              Real.sqrt (m : ℝ) -
                    C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t) >
                  NumStability.rectCourantFischerSingularValue
                    (A ω) (Fin.last n) ∨
                NumStability.rectCourantFischerSingularValue
                    (A ω) (0 : Fin (n + 1)) >
                  Real.sqrt (m : ℝ) +
                    C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t)} ≤
              2 * Real.exp (-(t ^ 2)) := by
  rcases hdp_04_theorem_4_6_1 with ⟨C, hC, htail⟩
  refine ⟨C, hC, ?_⟩
  intro Ω instΩ μ instμ m n hm A K hK hMeas hLp hMean hIso hPsi hIndep t ht
  refine ⟨?_, htail hm A hK hMeas hLp hMean hIso hPsi hIndep ht⟩
  intro ω i
  exact ⟨
    NumStability.rectCourantFischerSingularValue_antitone (A ω)
      (Fin.le_last i),
    NumStability.rectCourantFischerSingularValue_antitone (A ω)
      (Fin.zero_le i)⟩

end NumStability.HDP.Contract
