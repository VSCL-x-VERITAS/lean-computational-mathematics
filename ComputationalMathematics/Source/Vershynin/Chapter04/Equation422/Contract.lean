import ComputationalMathematics.HDP.Matrix.IsotropicRows

/-!
# Vershynin Chapter 4, Equation (4.22)
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

/-- Vershynin, Equation (4.22): for a matrix with independent, mean-zero,
isotropic sub-Gaussian rows, the normalized right Gram matrix is uniformly
close to the identity at scale `K² max(δ,δ²)`, except on an event of
probability at most `2 exp (-t²)`. -/
theorem hdp_04_equation_4_22 :
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
        ∀ {t : ℝ}, 0 ≤ t →
          let δ := C *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) + t / Real.sqrt (m : ℝ))
          μ.real {ω |
            K ^ 2 * max δ (δ ^ 2) <
              NumStability.realMatrixOperatorNorm
                (((m : ℝ)⁻¹) • ((A ω).transpose * A ω) -
                  (1 : Matrix (Fin n) (Fin n) ℝ))} ≤
            2 * Real.exp (-(t ^ 2)) := by
  rcases
      NumStability.HDP.Matrix.exists_normalizedGramDeviation_tail_of_independent_isotropic_subGaussian_rows with
    ⟨C, hC, htail⟩
  refine ⟨C, hC, ?_⟩
  intro Ω instΩ μ instμ m n hm hn A K hK hMeas hLp _hMean hIso hPsi hIndep t ht
  exact htail hm hn A hK hMeas hLp hIso hPsi hIndep ht

end NumStability.HDP.Contract
