import ComputationalMathematics.HDP.Vector.SphericalSubGaussian

/-!
# Projective marginals of the spherical law

This module isolates the exact Gaussian-ratio representation behind the
projective central limit theorem for the uniform law on `√n Sⁿ⁻¹`.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Vector.Spherical

/-- The law of the scalar projection of the canonical spherical vector in
dimension `d + 1`. -/
def sphericalMarginalMeasure (d : ℕ) (u : Fin (d + 1) → ℝ) : Measure ℝ :=
  Measure.map
    (NumStability.HDP.Vector.linearMarginal
      (fun i : Fin (d + 1) => fun x : Fin (d + 1) → ℝ => x i) u)
    (sphericalVectorMeasure (d + 1))

/-- The Gaussian ratio whose law is the spherical marginal in direction
`u`. -/
def gaussianProjectiveRatio (d : ℕ) (u : Fin (d + 1) → ℝ)
    (x : Fin (d + 1) → ℝ) : ℝ :=
  Real.sqrt (d + 1) * (NumStability.vecNorm2 x)⁻¹ *
    ∑ i, u i * x i

theorem measurable_sphericalLinearMarginal (d : ℕ)
    (u : Fin (d + 1) → ℝ) :
    Measurable
      (NumStability.HDP.Vector.linearMarginal
        (fun i : Fin (d + 1) => fun x : Fin (d + 1) → ℝ => x i) u) := by
  unfold NumStability.HDP.Vector.linearMarginal
  fun_prop

/-- The scalar projection of a spherical vector is exactly represented by a
standard Gaussian projection divided by the Gaussian Euclidean radius and
multiplied by `√(d+1)`. -/
theorem gaussianProjectiveRatio_hasLaw_sphericalMarginal
    (d : ℕ) (u : Fin (d + 1) → ℝ) :
    HasLaw (gaussianProjectiveRatio d u)
      (sphericalMarginalMeasure d u)
      (NumStability.standardGaussianVectorMeasure (d + 1)) := by
  let L : (Fin (d + 1) → ℝ) → ℝ :=
    NumStability.HDP.Vector.linearMarginal
      (fun i : Fin (d + 1) => fun x : Fin (d + 1) → ℝ => x i) u
  have hL : Measurable L := measurable_sphericalLinearMarginal d u
  have hCanonical : HasLaw L (sphericalMarginalMeasure d u)
      (sphericalVectorMeasure (d + 1)) := by
    refine ⟨hL.aemeasurable, ?_⟩
    rfl
  have hComposed : HasLaw
      (fun x => L (gaussianDirectionVector d x))
      (sphericalMarginalMeasure d u)
      (NumStability.standardGaussianVectorMeasure (d + 1)) :=
    hCanonical.fun_comp (gaussianDirectionVectorLaw d)
  apply hComposed.congr
  have hne : ∀ᵐ x ∂NumStability.standardGaussianVectorMeasure (d + 1), x ≠ 0 := by
    rw [ae_iff]
    simpa only [not_ne_iff, Set.setOf_eq_eq_singleton] using
      NumStability.standardGaussianVectorMeasure_singleton_zero d
  filter_upwards [hne] with x hx
  symm
  simpa [L, gaussianProjectiveRatio] using
    (linearMarginal_gaussianDirectionVector_of_ne_zero d u x hx)

/-- For unit `u`, the numerator in the Gaussian-ratio representation has the
standard one-dimensional normal law. -/
theorem gaussianProjectiveNumerator_hasStandardNormalLaw
    (d : ℕ) (u : NumStability.HDP.Vector.SubGaussian.UnitDirection (d + 1)) :
    HasLaw (fun x : Fin (d + 1) → ℝ => ∑ i, u.1 i * x i)
      (gaussianReal 0 1)
      (NumStability.standardGaussianVectorMeasure (d + 1)) := by
  simpa using NumStability.HDP.Vector.Gaussian.unitWeightedGaussianLaw u

end NumStability.HDP.Vector.Spherical
