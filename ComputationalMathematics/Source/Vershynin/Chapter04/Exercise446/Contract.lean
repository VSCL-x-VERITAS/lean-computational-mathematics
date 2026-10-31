import ComputationalMathematics.HDP.Matrix.OperatorNormExpectation

/-!
# Vershynin Chapter 4, Exercise 4.4.6
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

/-- Vershynin, Exercise 4.4.6: integrating Theorem 4.4.5 gives an absolute
constant `C` for which the expected operator norm is bounded by
`C K (sqrt m + sqrt n)`. -/
theorem hdp_04_exercise_4_4_6 :
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
            (Real.sqrt m + Real.sqrt n) :=
  NumStability.HDP.Matrix.exists_expected_operatorNorm_bound_of_independent_centered_subGaussian_entries

end NumStability.HDP.Contract
