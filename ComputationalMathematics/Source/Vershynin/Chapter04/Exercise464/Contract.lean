import ComputationalMathematics.Source.Vershynin.Chapter04.Equation421.Contract

/-!
# Vershynin Chapter 4, Exercise 4.6.4
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal

namespace NumStability.HDP.Contract

/-- Vershynin, Exercise 4.6.4: the conclusion of Theorem 4.6.1, whose
suggested alternative proof combines the norm concentration theorem with a
finite-net union bound.  A proof method does not alter the proposition being
proved, so this source-facing contract repeats the complete theorem statement
as a separately tracked exercise result. -/
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
  exact hdp_04_equation_4_21

end NumStability.HDP.Contract
