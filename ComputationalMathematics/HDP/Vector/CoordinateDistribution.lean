import ComputationalMathematics.HDP.Vector.Isotropy
import Mathlib.Probability.HasLaw
import Mathlib.Probability.UniformOn

/-!
# The coordinate distribution

This module packages the uniform law on the scaled canonical basis vectors in
finite-dimensional real space.  The law is represented by mapping Mathlib's
uniform measure on `Fin n` through the canonical-basis embedding.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Vector.CoordinateDistribution

/-- The scaled `i`th canonical basis vector in `ℝⁿ`. -/
def coordinateVector (n : ℕ) (i : Fin n) : Fin n → ℝ :=
  Real.sqrt (n : ℝ) • (Pi.single i (1 : ℝ) : Fin n → ℝ)

/-- Distinct indices give distinct scaled coordinate vectors in positive
dimension. -/
theorem coordinateVector_injective (n : ℕ) [NeZero n] :
    Function.Injective (coordinateVector n) := by
  intro i j hij
  by_contra hne
  have hcoord := congrFun hij i
  simp only [coordinateVector, Pi.smul_apply, smul_eq_mul, Pi.single_apply] at hcoord
  simp [hne] at hcoord
  exact (NeZero.ne n) hcoord

/-- The probability law obtained by choosing one scaled coordinate vector
uniformly. -/
def coordinateDistributionMeasure (n : ℕ) [NeZero n] : Measure (Fin n → ℝ) :=
  Measure.map (coordinateVector n)
    (ProbabilityTheory.uniformOn (Set.univ : Set (Fin n)))

instance (n : ℕ) [NeZero n] : IsProbabilityMeasure (coordinateDistributionMeasure n) := by
  unfold coordinateDistributionMeasure
  exact Measure.isProbabilityMeasure_map (measurable_of_countable _).aemeasurable

/-- A finite random vector has the coordinate distribution when its joint law
is uniform on the scaled canonical basis vectors. -/
def HasCoordinateDistribution {Ω : Type*} [MeasurableSpace Ω] {n : ℕ} [NeZero n]
    (μ : Measure Ω) (X : Fin n → Ω → ℝ) : Prop :=
  HasLaw (fun ω i => X i ω) (coordinateDistributionMeasure n) μ

/-- The coordinate distribution is isotropic: its coordinate covariance
matrix is the identity. -/
theorem coordinateDistributionMeasure_isIsotropic (n : ℕ) [NeZero n] :
    Isotropy.IsIsotropic (coordinateDistributionMeasure n)
      (fun i : Fin n => fun x : Fin n → ℝ => x i) := by
  rw [Isotropy.isIsotropic_iff_integral_mul]
  intro i j
  unfold coordinateDistributionMeasure
  rw [integral_map (measurable_of_countable _).aemeasurable]
  · simp only [coordinateVector, ProbabilityTheory.uniformOn, ProbabilityTheory.cond,
      integral_smul_measure, Measure.restrict_univ, Measure.count_apply_finite,
      Set.toFinite, Pi.smul_apply, smul_eq_mul, Pi.single_apply, integral_count]
    have hn : (n : ℝ) ≠ 0 := by exact_mod_cast (NeZero.ne n)
    have hsqrt : Real.sqrt (n : ℝ) * Real.sqrt (n : ℝ) = (n : ℝ) :=
      Real.mul_self_sqrt (Nat.cast_nonneg n)
    by_cases hij : i = j
    · subst j
      simp [hsqrt, hn]
    · simp [hij]
  · fun_prop

end NumStability.HDP.Vector.CoordinateDistribution
