import ComputationalMathematics.HDP.Matrix.SubGaussianEntries

/-!
# Vershynin Chapter 4, Equation (4.14)
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped RealInnerProductSpace

namespace NumStability.HDP.Contract

/-- Vershynin, Equation (4.14): for fixed unit vectors `x` and `y`, the
bilinear form `⟪A x, y⟫` of a matrix with independent centered sub-Gaussian
entries has a Gaussian upper tail at the maximum entrywise `ψ₂` scale.

The positive-scale premise makes explicit the effective domain of the printed
quotient `u² / K²`; the source gives no extended-value convention at `K = 0`.
-/
theorem hdp_04_equation_4_14 :
    ∃ c : ℝ, 0 < c ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ}
        [Nonempty (Fin m)] [Nonempty (Fin n)],
        ∀ (A : Ω → Matrix (Fin m) (Fin n) ℝ),
        (∀ ij : Fin m × Fin n,
          NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
            (fun ω ↦ A ω ij.1 ij.2)) →
        (∀ ij : Fin m × Fin n,
          Integrable (fun ω ↦ A ω ij.1 ij.2) μ ∧
            (∫ ω, A ω ij.1 ij.2 ∂μ) = 0) →
        iIndepFun (fun ij : Fin m × Fin n ↦
          fun ω ↦ A ω ij.1 ij.2) μ →
        0 < NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
          (fun ij : Fin m × Fin n ↦ fun ω ↦ A ω ij.1 ij.2) →
        ∀ (x : EuclideanSpace ℝ (Fin n))
          (y : EuclideanSpace ℝ (Fin m)),
          ‖x‖ = 1 → ‖y‖ = 1 →
          ∀ {u : ℝ}, 0 ≤ u →
            μ.real {ω |
              inner ℝ (Matrix.toEuclideanLin (A ω) x) y ≥ u} ≤
              2 * Real.exp
                (-(c * u ^ 2 /
                  (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
                    (fun ij : Fin m × Fin n ↦
                      fun ω ↦ A ω ij.1 ij.2)) ^ 2)) := by
  obtain ⟨c, hc, htail⟩ :=
    NumStability.HDP.Matrix.exists_fixed_bilinear_tail_of_independent_subGaussian_entries
  refine ⟨c, hc, ?_⟩
  intro Ω _ μ _ m n _ _ A hSub hCenter hIndep _hK x y hx hy u hu
  have hAbs := htail A hSub hCenter hIndep x y hx hy hu
  apply (measureReal_mono ?_ (measure_ne_top μ _)).trans hAbs
  intro ω hω
  exact hω.trans (le_abs_self (inner ℝ (Matrix.toEuclideanLin (A ω) x) y))

end NumStability.HDP.Contract
