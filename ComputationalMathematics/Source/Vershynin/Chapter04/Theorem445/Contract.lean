import ComputationalMathematics.HDP.Matrix.OperatorNormSubGaussian

/-!
# Vershynin Chapter 4, Theorem 4.4.5

Source-facing contract for the operator norm of a rectangular matrix with
independent mean-zero sub-Gaussian entries.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

/-- Vershynin, Theorem 4.4.5: there is an absolute positive constant `C`
such that an `m × n` random matrix with independent mean-zero sub-Gaussian
entries satisfies
`P{‖A‖ > C K (√n + √m + t)} ≤ 2 exp (-t²)` for every `t > 0`, where
`K` is the maximum intrinsic `ψ₂` norm of an entry. -/
theorem hdp_04_theorem_4_4_5 :
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
        ∀ {t : ℝ}, 0 < t →
          μ.real {ω |
            C * NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
                (fun ij : Fin m × Fin n => fun ω => A ω ij.1 ij.2) *
                (Real.sqrt n + Real.sqrt m + t) <
              NumStability.realMatrixOperatorNorm (A ω)} ≤
            2 * Real.exp (-t ^ 2) :=
  NumStability.HDP.Matrix.exists_operatorNorm_tail_of_independent_centered_subGaussian_entries

end NumStability.HDP.Contract
