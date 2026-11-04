import ComputationalMathematics.HDP.Metric.NetApproximation
import ComputationalMathematics.HDP.Probability.FiniteUnion
import ComputationalMathematics.Analysis.OperatorNorms.RealMatrix
import Mathlib.MeasureTheory.Measure.Real

/-!
# Probability bounds for matrix norms from two finite nets

This is the deterministic approximation plus finite-union step used in the
proof of Vershynin's Theorem 4.4.5.
-/

noncomputable section

open MeasureTheory Set
open scoped ENNReal

namespace NumStability.HDP.Matrix

/-- A uniform one-sided tail estimate for bilinear forms on two quarter-nets
gives the corresponding operator-norm tail bound. -/
theorem measure_realMatrixOperatorNorm_gt_two_mul_le_of_quarter_nets
    {Ω : Type*} [MeasurableSpace Ω] {m n : ℕ}
    (μ : Measure Ω) (A : Ω → Matrix (Fin m) (Fin n) ℝ)
    (N : Finset (EuclideanSpace ℝ (Fin n)))
    (M : Finset (EuclideanSpace ℝ (Fin m)))
    (hN : NumStability.HDP.Metric.IsFiniteUnitSphereNet (1 / 4 : ℝ) N)
    (hM : NumStability.HDP.Metric.IsFiniteUnitSphereNet (1 / 4 : ℝ) M)
    (hNnonempty : N.Nonempty) (hMnonempty : M.Nonempty)
    (u : ℝ) (p : ℝ≥0∞)
    (hpair : ∀ x ∈ N, ∀ y ∈ M,
      μ {ω | u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) x) y} ≤ p) :
    μ {ω | 2 * u < NumStability.realMatrixOperatorNorm (A ω)} ≤
      (N.card * M.card) * p := by
  have hsubset :
      {ω | 2 * u < NumStability.realMatrixOperatorNorm (A ω)} ⊆
        ⋃ x ∈ N, ⋃ y ∈ M,
          {ω | u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) x) y} := by
    intro ω hω
    obtain ⟨x, hxN, y, hyM, _hmax, hbound⟩ :=
      NumStability.HDP.Metric.exists_quarter_net_bilinear_max_bound
        (NumStability.realMatrixContinuousLinearMap (A ω)) N M
        hN hM hNnonempty hMnonempty
    have huxy : u < inner ℝ (Matrix.toEuclideanLin (A ω) x) y := by
      change 2 * u < ‖NumStability.realMatrixContinuousLinearMap (A ω)‖ at hω
      change ‖NumStability.realMatrixContinuousLinearMap (A ω)‖ ≤
        2 * inner ℝ (Matrix.toEuclideanLin (A ω) x) y at hbound
      linarith
    simp only [Set.mem_iUnion, Set.mem_setOf_eq]
    exact ⟨x, hxN, y, hyM, huxy.le⟩
  exact (measure_mono hsubset).trans
    (NumStability.HDP.Probability.measure_biUnion_product_le
      μ N M
      (fun x y ↦ {ω | u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) x) y})
      p hpair)

/-- The same estimate with the standard quarter-net cardinality budgets
`|N| ≤ 9ⁿ` and `|M| ≤ 9ᵐ`. -/
theorem measure_realMatrixOperatorNorm_gt_two_mul_le_nine_pow
    {Ω : Type*} [MeasurableSpace Ω] {m n : ℕ}
    (μ : Measure Ω) (A : Ω → Matrix (Fin m) (Fin n) ℝ)
    (N : Finset (EuclideanSpace ℝ (Fin n)))
    (M : Finset (EuclideanSpace ℝ (Fin m)))
    (hN : NumStability.HDP.Metric.IsFiniteUnitSphereNet (1 / 4 : ℝ) N)
    (hM : NumStability.HDP.Metric.IsFiniteUnitSphereNet (1 / 4 : ℝ) M)
    (hNnonempty : N.Nonempty) (hMnonempty : M.Nonempty)
    (hNcard : N.card ≤ 9 ^ n) (hMcard : M.card ≤ 9 ^ m)
    (u : ℝ) (p : ℝ≥0∞)
    (hpair : ∀ x ∈ N, ∀ y ∈ M,
      μ {ω | u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) x) y} ≤ p) :
    μ {ω | 2 * u < NumStability.realMatrixOperatorNorm (A ω)} ≤
      ((9 ^ (n + m) : ℕ) : ℝ≥0∞) * p := by
  refine (measure_realMatrixOperatorNorm_gt_two_mul_le_of_quarter_nets
    μ A N M hN hM hNnonempty hMnonempty u p hpair).trans ?_
  gcongr
  exact_mod_cast (calc
    N.card * M.card ≤ 9 ^ n * 9 ^ m := Nat.mul_le_mul hNcard hMcard
    _ = 9 ^ (n + m) := by rw [pow_add])

/-- Real-valued probability form of
`measure_realMatrixOperatorNorm_gt_two_mul_le_nine_pow`. -/
theorem measureReal_realMatrixOperatorNorm_gt_two_mul_le_nine_pow
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsFiniteMeasure μ]
    {m n : ℕ} (A : Ω → Matrix (Fin m) (Fin n) ℝ)
    (N : Finset (EuclideanSpace ℝ (Fin n)))
    (M : Finset (EuclideanSpace ℝ (Fin m)))
    (hN : NumStability.HDP.Metric.IsFiniteUnitSphereNet (1 / 4 : ℝ) N)
    (hM : NumStability.HDP.Metric.IsFiniteUnitSphereNet (1 / 4 : ℝ) M)
    (hNnonempty : N.Nonempty) (hMnonempty : M.Nonempty)
    (hNcard : N.card ≤ 9 ^ n) (hMcard : M.card ≤ 9 ^ m)
    (u p : ℝ) (hp : 0 ≤ p)
    (hpair : ∀ x ∈ N, ∀ y ∈ M,
      μ.real {ω | u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) x) y} ≤ p) :
    μ.real {ω | 2 * u < NumStability.realMatrixOperatorNorm (A ω)} ≤
      (9 ^ (n + m) : ℕ) * p := by
  have hpair' : ∀ x ∈ N, ∀ y ∈ M,
      μ {ω | u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) x) y} ≤
        ENNReal.ofReal p := by
    intro x hx y hy
    rw [← ofReal_measureReal]
    exact ENNReal.ofReal_le_ofReal (hpair x hx y hy)
  have hbound := measure_realMatrixOperatorNorm_gt_two_mul_le_nine_pow
    μ A N M hN hM hNnonempty hMnonempty hNcard hMcard u
      (ENNReal.ofReal p) hpair'
  rw [Measure.real_def]
  calc
    (μ {ω | 2 * u < NumStability.realMatrixOperatorNorm (A ω)}).toReal ≤
        (((9 ^ (n + m) : ℕ) : ℝ≥0∞) * ENNReal.ofReal p).toReal :=
      ENNReal.toReal_mono (by finiteness) hbound
    _ = (9 ^ (n + m) : ℕ) * p := by
      rw [ENNReal.toReal_mul, ENNReal.toReal_natCast,
        ENNReal.toReal_ofReal hp]

end NumStability.HDP.Matrix
