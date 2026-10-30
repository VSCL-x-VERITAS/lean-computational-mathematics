import ComputationalMathematics.HDP.Matrix.SubGaussianEntries
import ComputationalMathematics.HDP.Matrix.LiteralBilinearMaximum
import ComputationalMathematics.HDP.Scalar.SubGaussian.ZeroFiniteFamily

/-!
# Intrinsic-scale tails for literal bilinear maxima

Compose the existing intrinsic entry concentration theorem with the literal
finite-maximum event bridge. The constant is uniform over probability spaces,
dimensions, entry laws, nets and thresholds. This ordinary result makes no
choice about an author's zero-scale or empty-dimension conventions.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Matrix

/-- When the intrinsic entry scale is zero, every actual bilinear pairing is
zero almost surely, so the literal finite maximum has its exact threshold
event. This keeps the zero-scale case separate from any quotient convention. -/
theorem measure_bilinear_maximum_of_zero_entry_scale
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {m n : ℕ}
    [Nonempty (Fin m)] [Nonempty (Fin n)]
    (A : Ω → Matrix (Fin m) (Fin n) ℝ)
    (hMeas : ∀ ij : Fin m × Fin n,
      Measurable (fun ω ↦ A ω ij.1 ij.2))
    (hFinite : ∀ ij : Fin m × Fin n,
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
        (fun ω ↦ A ω ij.1 ij.2) < ∞)
    (hScale : NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
      (fun ij : Fin m × Fin n ↦ fun ω ↦ A ω ij.1 ij.2) = 0)
    (N : Finset (EuclideanSpace ℝ (Fin n)))
    (M : Finset (EuclideanSpace ℝ (Fin m)))
    (hN : N.Nonempty) (hM : M.Nonempty) (u : ℝ) :
    μ {ω | u ≤ (N ×ˢ M).sup' (hN.product hM)
      (fun xy ↦ inner ℝ (Matrix.toEuclideanLin (A ω) xy.1) xy.2)} =
      if u ≤ 0 then 1 else 0 := by
  have hA :=
    (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax_eq_zero_iff_matrix_ae_zero
      hMeas hFinite).mp hScale
  have hEvent :
      {ω | u ≤ (N ×ˢ M).sup' (hN.product hM)
        (fun xy ↦ inner ℝ (Matrix.toEuclideanLin (A ω) xy.1) xy.2)} =ᵐ[μ]
        {ω | u ≤ (0 : ℝ)} := by
    filter_upwards [hA] with ω hω
    change (u ≤ (N ×ˢ M).sup' (hN.product hM)
      (fun xy ↦ inner ℝ (Matrix.toEuclideanLin (A ω) xy.1) xy.2)) = (u ≤ 0)
    rw [hω]
    simp
  rw [measure_congr hEvent]
  by_cases hu : u ≤ 0 <;> simp [hu]

/-- The largest actual matrix pairing over two finite quarter-nets has the
standard intrinsic-scale union bound. No fixed-pair tail is assumed: it comes
from independence, centering and sub-Gaussianity of the actual entries. -/
theorem exists_bilinear_maximum_tail_of_independent_centered_subGaussian_entries :
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
                    fun ω => A ω ij.1 ij.2)) ^ 2)) := by
  classical
  obtain ⟨c, hc, htail⟩ :=
    exists_fixed_bilinear_tail_of_independent_subGaussian_entries
  refine ⟨c, hc, ?_⟩
  intro Ω instΩ μ instμ m n instm instn A hSub hCenter hIndep
    N M hNnet hMnet hN hM hNcard hMcard u hu
  let p : ℝ := 2 * Real.exp (-(c * u ^ 2 /
    (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
      (fun ij : Fin m × Fin n => fun ω => A ω ij.1 ij.2)) ^ 2))
  have hp : 0 ≤ p := by dsimp [p]; positivity
  have hpair : ∀ x ∈ N, ∀ y ∈ M,
      μ {ω | u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) x) y} ≤
        ENNReal.ofReal p := by
    intro x hx y hy
    refine (measure_mono (t :=
      {ω | u ≤ |inner ℝ (Matrix.toEuclideanLin (A ω) x) y|}) ?_).trans ?_
    · intro ω hω
      change u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) x) y at hω
      exact hω.trans (le_abs_self _)
    · rw [← ofReal_measureReal]
      exact ENNReal.ofReal_le_ofReal
        (htail A hSub hCenter hIndep x y
          (hNnet.1 x hx) (hMnet.1 y hy) hu)
  have hbound := measure_bilinear_maximum_ge_le_nine_pow
    μ A N M hN hM hNcard hMcard u (ENNReal.ofReal p) hpair
  rw [Measure.real_def]
  calc
    _ ≤ (((9 ^ (n + m) : ℕ) : ℝ≥0∞) * ENNReal.ofReal p).toReal :=
      ENNReal.toReal_mono (by finiteness) hbound
    _ = (9 ^ (n + m) : ℕ) * p := by
      rw [ENNReal.toReal_mul, ENNReal.toReal_natCast, ENNReal.toReal_ofReal hp]
    _ = _ := by dsimp [p]; ring

end NumStability.HDP.Matrix
