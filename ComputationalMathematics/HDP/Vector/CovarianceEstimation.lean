import ComputationalMathematics.HDP.Vector.Covariance
import ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic
import Mathlib.Probability.IdentDistrib

/-!
# Sample covariance matrices

Finite-sample second-moment matrices used for covariance estimation.
-/

open Matrix
open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Vector.Covariance

/-- The (uncentered) sample covariance, or empirical second-moment matrix,
of a finite family of real vectors. -/
noncomputable def sampleCovariance {m n : ℕ} (X : Fin m → Fin n → ℝ) :
    Matrix (Fin n) (Fin n) ℝ := fun a b ↦
  (m : ℝ)⁻¹ * ∑ i, X i a * X i b

theorem sampleCovariance_apply {m n : ℕ} (X : Fin m → Fin n → ℝ)
    (a b : Fin n) :
    sampleCovariance X a b = (m : ℝ)⁻¹ * ∑ i, X i a * X i b := rfl

/-- A sample of random vectors, evaluated pointwise and converted to its
empirical second-moment matrix. -/
noncomputable def randomSampleCovariance {Ω : Type*}
    {m n : ℕ} (X : Fin m → Ω → Fin n → ℝ) (ω : Ω) :
    Matrix (Fin n) (Fin n) ℝ :=
  sampleCovariance fun i ↦ X i ω

/-- The sample covariance is unbiased when all sample vectors have the same
law as the population vector. -/
theorem integral_randomSampleCovariance_eq_secondMomentMatrix
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {m n : ℕ}
    (hm : 0 < m) (X : Fin m → Ω → Fin n → ℝ) (Z : Ω → Fin n → ℝ)
    (hident : ∀ i, IdentDistrib (X i) Z μ μ)
    (hint : ∀ i a b, Integrable
      (fun ω ↦ X i ω a * X i ω b) μ)
    (a b : Fin n) :
    (∫ ω, randomSampleCovariance X ω a b ∂μ) =
      secondMomentMatrix μ (fun i ω ↦ Z ω i) a b := by
  have heq : ∀ i, (∫ ω, X i ω a * X i ω b ∂μ) =
      ∫ ω, Z ω a * Z ω b ∂μ := by
    intro i
    exact (hident i).comp
      ((measurable_pi_apply a).mul (measurable_pi_apply b)) |>.integral_eq
  rw [secondMomentMatrix]
  simp only [randomSampleCovariance, sampleCovariance]
  rw [MeasureTheory.integral_const_mul]
  rw [MeasureTheory.integral_finset_sum]
  · simp_rw [heq]
    simp [hm.ne']
  · exact fun i _ ↦ hint i a b

/-- The empirical second-moment matrix formed from the first `m` vectors of
an infinite sample. -/
noncomputable def sequenceSampleCovariance
    {Ω : Type*} {n : ℕ}
    (X : ℕ → Ω → Fin n → ℝ) (m : ℕ) (ω : Ω) :
    Matrix (Fin n) (Fin n) ℝ := fun a b ↦
  (m : ℝ)⁻¹ * ∑ i ∈ Finset.range m, X i ω a * X i ω b

/-- For an iid integrable vector sample, empirical second-moment matrices
converge entrywise almost surely to the population second-moment matrix. -/
theorem sequenceSampleCovariance_tendsto_secondMomentMatrix_ae
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    {n : ℕ}
    (X : ℕ → Ω → Fin n → ℝ)
    (hInt : ∀ a b, Integrable (fun ω ↦ X 0 ω a * X 0 ω b) μ)
    (hIndep : Pairwise (fun i j ↦ IndepFun (X i) (X j) μ))
    (hIdent : ∀ i, IdentDistrib (X i) (X 0) μ μ) :
    ∀ᵐ ω ∂μ, ∀ a b,
      Filter.Tendsto (fun m ↦ sequenceSampleCovariance X m ω a b)
        Filter.atTop
        (nhds (secondMomentMatrix μ (fun i ω ↦ X 0 ω i) a b)) := by
  rw [ae_all_iff]
  intro a
  rw [ae_all_iff]
  intro b
  let Y : ℕ → Ω → ℝ := fun i ω ↦ X i ω a * X i ω b
  have hYIndep : Pairwise (fun i j ↦ IndepFun (Y i) (Y j) μ) := by
    intro i j hij
    exact (hIndep hij).comp
      ((measurable_pi_apply a).mul (measurable_pi_apply b))
      ((measurable_pi_apply a).mul (measurable_pi_apply b))
  have hYIdent : ∀ i, IdentDistrib (Y i) (Y 0) μ μ := by
    intro i
    exact (hIdent i).comp
      ((measurable_pi_apply a).mul (measurable_pi_apply b))
  have hSLLN :=
    NumStability.HDP.Scalar.LimitTheorems.strongLaw
      (X := Y) (hInt a b) hYIndep hYIdent
  simpa only [sequenceSampleCovariance, Y, div_eq_mul_inv, mul_comm,
    secondMomentMatrix] using hSLLN

end NumStability.HDP.Vector.Covariance
