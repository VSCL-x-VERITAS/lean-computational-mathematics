import ComputationalMathematics.HDP.Matrix.IsotropicRows

/-!
# Vershynin Chapter 4, Theorem 4.6.1
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal

namespace NumStability.HDP.Contract

/-- Vershynin, Theorem 4.6.1 / Equation (4.21): the extreme singular values
of a matrix with independent, mean-zero, isotropic sub-Gaussian rows lie
within `C K² (√n+t)` of `√m`, except on an event of probability at most
`2 exp (-t²)`.  The column count is written as `n+1` so both extreme singular
values are defined without an external positive-dimension hypothesis. -/
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
  rcases
      NumStability.HDP.Matrix.exists_normalizedGramDeviation_tail_of_independent_isotropic_subGaussian_rows with
    ⟨C, hC, htail⟩
  refine ⟨C, hC, ?_⟩
  intro Ω instΩ μ instμ m n hm A K hK hMeas hLp _hMean hIso hPsi hIndep t ht
  have hKpos : 0 < K := lt_of_lt_of_le zero_lt_one hK
  let δ : ℝ := C *
    (Real.sqrt (((n + 1 : ℕ) : ℝ) / (m : ℝ)) +
      t / Real.sqrt (m : ℝ))
  have hδ : 0 < δ := by
    dsimp [δ]
    have : 0 < Real.sqrt (((n + 1 : ℕ) : ℝ) / (m : ℝ)) := by
      positivity
    positivity
  have htail' := htail hm (Nat.succ_pos n) A hKpos hMeas hLp hIso hPsi hIndep ht
  have hmreal : 0 < (m : ℝ) := by exact_mod_cast hm
  have hsqrtm : 0 < Real.sqrt (m : ℝ) := Real.sqrt_pos.2 hmreal
  have hscale :
      Real.sqrt (m : ℝ) * (K ^ 2 * δ) =
        C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t) := by
    dsimp [δ]
    rw [Real.sqrt_div (by positivity : (0 : ℝ) ≤ (n + 1 : ℕ))]
    field_simp
    norm_num [Nat.cast_add, Nat.cast_one]
  have hsubset :
      {ω |
        Real.sqrt (m : ℝ) -
              C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t) >
            NumStability.rectCourantFischerSingularValue
              (A ω) (Fin.last n) ∨
          NumStability.rectCourantFischerSingularValue
              (A ω) (0 : Fin (n + 1)) >
            Real.sqrt (m : ℝ) +
              C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t)} ⊆
      {ω |
        K ^ 2 * max δ (δ ^ 2) <
          NumStability.realMatrixOperatorNorm
            (((m : ℝ)⁻¹) • ((A ω).transpose * A ω) -
              (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ))} := by
    intro ω hbad
    by_contra hnot
    have hGram :
        NumStability.realMatrixOperatorNorm
            (((m : ℝ)⁻¹) • ((A ω).transpose * A ω) -
              (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ)) ≤
          K ^ 2 * max δ (δ ^ 2) := le_of_not_gt hnot
    have hs :=
      NumStability.HDP.Matrix.extremeSingularValueBounds_of_normalizedGramDeviation
        hm (A ω) hK hδ hGram
    rw [hscale] at hs
    rcases hbad with hbad | hbad
    · exact (not_lt_of_ge hs.1) hbad
    · exact (not_lt_of_ge hs.2.2) hbad
  exact (measureReal_mono hsubset (by
    exact ne_top_of_le_ne_top
      (show μ Set.univ ≠ (⊤ : ℝ≥0∞) by simp)
      (measure_mono (Set.subset_univ _)))).trans htail'

end NumStability.HDP.Contract
