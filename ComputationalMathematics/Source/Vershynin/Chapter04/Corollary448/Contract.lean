import ComputationalMathematics.HDP.Matrix.SymmetricOperatorNormSubGaussian

/-!
# Vershynin Chapter 4, Corollary 4.4.8

Source-facing contract for the operator norm of a symmetric matrix with
independent centered sub-Gaussian entries on and above the diagonal.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

/-- Vershynin, Corollary 4.4.8: a symmetric `n × n` random matrix whose
entries on and above the diagonal are independent, mean-zero, sub-Gaussian
variables satisfies
`P{‖A‖ > C K (√n + t)} ≤ 4 exp (-t²)` for every `t > 0`, where `K` is the
maximum intrinsic `ψ₂` norm of all entries. -/
theorem hdp_04_corollary_4_4_8 :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {n : ℕ} (hn : 0 < n),
        letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
        ∀ (A : Ω → Matrix (Fin n) (Fin n) ℝ),
        (∀ ω i j, A ω i j = A ω j i) →
        (∀ ij : {ij : Fin n × Fin n // ij.1 ≤ ij.2},
          NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
            (fun ω => A ω ij.1.1 ij.1.2)) →
        (∀ ij : {ij : Fin n × Fin n // ij.1 ≤ ij.2},
          Integrable (fun ω => A ω ij.1.1 ij.1.2) μ ∧
            (∫ ω, A ω ij.1.1 ij.1.2 ∂μ) = 0) →
        iIndepFun
          (fun ij : {ij : Fin n × Fin n // ij.1 ≤ ij.2} =>
            fun ω => A ω ij.1.1 ij.1.2) μ →
        ∀ {t : ℝ}, 0 < t →
          μ.real {ω |
            C * NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
                (fun ij : Fin n × Fin n => fun ω => A ω ij.1 ij.2) *
                (Real.sqrt n + t) <
              NumStability.realMatrixOperatorNorm (A ω)} ≤
            4 * Real.exp (-t ^ 2) :=
  NumStability.HDP.Matrix.exists_symmetric_operatorNorm_tail_of_independent_centered_subGaussian_entries

end NumStability.HDP.Contract
