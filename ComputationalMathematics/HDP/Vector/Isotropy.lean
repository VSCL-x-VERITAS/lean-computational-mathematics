import ComputationalMathematics.HDP.Vector.Covariance

/-!
# Isotropic finite random vectors

This module defines isotropy through the uncentered second-moment matrix and
provides its coordinatewise identity-matrix form.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Vector.Isotropy

/-- A finite real random vector is isotropic when its second-moment matrix is
the identity matrix. -/
def IsIsotropic {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ) : Prop :=
  NumStability.HDP.Vector.Covariance.secondMomentMatrix μ X = 1

/-- The coordinate-product formulation of isotropy. -/
theorem isIsotropic_iff_integral_mul
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ) :
    IsIsotropic μ X ↔
      ∀ i j, (∫ ω, X i ω * X j ω ∂μ) = if i = j then 1 else 0 := by
  rw [IsIsotropic]
  constructor
  · intro h i j
    have hij := congrFun (congrFun h i) j
    simpa [NumStability.HDP.Vector.Covariance.secondMomentMatrix] using hij
  · intro h
    funext i j
    simpa [NumStability.HDP.Vector.Covariance.secondMomentMatrix] using h i j

/-- Every coordinate of an isotropic vector has unit second moment. -/
theorem integral_sq_coordinate
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} {X : Fin n → Ω → ℝ}
    (hX : IsIsotropic μ X) (i : Fin n) :
    ∫ ω, (X i ω) ^ 2 ∂μ = 1 := by
  have hii := (isIsotropic_iff_integral_mul μ X).1 hX i i
  simpa [pow_two] using hii

end NumStability.HDP.Vector.Isotropy
