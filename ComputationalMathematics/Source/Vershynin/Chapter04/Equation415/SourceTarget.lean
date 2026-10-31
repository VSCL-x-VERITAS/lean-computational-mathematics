import ComputationalMathematics.HDP.Matrix.SubGaussianBilinearMaximum

/-! Draft proof-free target. Uncompiled and unaudited. -/
noncomputable section
open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

def hdp_04_equation_4_15_natural_domain_target : Prop :=
    ∃ c : ℝ, 0 < c ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ}
        [Nonempty (Fin m)] [Nonempty (Fin n)],
        ∀ (A : Ω → Matrix (Fin m) (Fin n) ℝ),
        (∀ ij : Fin m × Fin n,
          NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
            (fun ω => A ω ij.1 ij.2)) →
        (∀ ij : Fin m × Fin n,
          Integrable (fun ω => A ω ij.1 ij.2) μ ∧
            (∫ ω, A ω ij.1 ij.2 ∂μ) = 0) →
        iIndepFun (fun ij : Fin m × Fin n =>
          fun ω => A ω ij.1 ij.2) μ →
        0 < NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
          (fun ij : Fin m × Fin n => fun ω => A ω ij.1 ij.2) →
        ∀ (N : Finset (EuclideanSpace ℝ (Fin n)))
          (M : Finset (EuclideanSpace ℝ (Fin m))),
        NumStability.HDP.Metric.IsFiniteUnitSphereNet (1 / 4 : ℝ) N →
        NumStability.HDP.Metric.IsFiniteUnitSphereNet (1 / 4 : ℝ) M →
        ∀ (hN : N.Nonempty) (hM : M.Nonempty),
        N.card ≤ 9 ^ n → M.card ≤ 9 ^ m →
        ∀ {u : ℝ}, 0 ≤ u →
          μ.real {ω | u ≤ (N ×ˢ M).sup' (hN.product hM)
            (fun xy ↦ inner ℝ (Matrix.toEuclideanLin (A ω) xy.1) xy.2)} ≤
            2 * (9 ^ (n + m) : ℕ) *
              Real.exp (-(c * u ^ 2 /
                (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
                  (fun ij : Fin m × Fin n =>
                    fun ω => A ω ij.1 ij.2)) ^ 2))

end NumStability.HDP.Contract
