import ComputationalMathematics.HDP.Matrix.GramExpectation

/-!
# Vershynin Chapter 4, Exercise 4.6.2
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

/-- Vershynin, Exercise 4.6.2: integrating Equation (4.22) bounds the
expected normalized Gram-matrix deviation by
`C K² (sqrt (n/m) + n/m)`.  Integrability is explicit under the module's
finite-expectation convention. -/
theorem hdp_04_exercise_4_6_2 :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ}
        (_hm : 0 < m) (_hn : 0 < n)
        (A : Ω → Matrix (Fin m) (Fin n) ℝ) {K : ℝ},
        0 < K →
        (∀ i j, Measurable (fun ω => A ω i j)) →
        (∀ i j, MemLp (fun ω => A ω i j) 2 μ) →
        (∀ i j, ∫ ω, A ω i j ∂μ = 0) →
        (∀ i, NumStability.HDP.Vector.Isotropy.IsIsotropic μ
          (fun j ω => A ω i j)) →
        (∀ i, NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω => A ω i j) ≤ ENNReal.ofReal K) →
        iIndepFun (fun i ω => fun j => A ω i j) μ →
        Integrable (fun ω =>
          NumStability.realMatrixOperatorNorm
            (((m : ℝ)⁻¹) • ((A ω).transpose * A ω) -
              (1 : Matrix (Fin n) (Fin n) ℝ))) μ →
        (∫ ω, NumStability.realMatrixOperatorNorm
            (((m : ℝ)⁻¹) • ((A ω).transpose * A ω) -
              (1 : Matrix (Fin n) (Fin n) ℝ)) ∂μ) ≤
          C * K ^ 2 *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) := by
  rcases
      NumStability.HDP.Matrix.exists_expected_normalizedGramDeviation_bound_of_independent_isotropic_subGaussian_rows with
    ⟨C, hC, hbound⟩
  refine ⟨C, hC, ?_⟩
  intro Ω instΩ μ instμ m n hm hn A K hK hMeas hLp _hMean hIso hPsi hIndep hInt
  exact hbound hm hn A hK hMeas hLp hIso hPsi hIndep hInt

end NumStability.HDP.Contract
