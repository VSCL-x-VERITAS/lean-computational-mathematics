import ComputationalMathematics.HDP.Vector.Isotropy
import Mathlib.MeasureTheory.Measure.Dirac

/-!
# Point-mass obstruction to vector isotropy

The coordinate-product characterization rules out isotropy under a Dirac measure
when two distinct coordinate indices are available. Keeping this specialization
separate preserves the base isotropy module and its narrow import boundary.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Vector.Isotropy

/-- No real vector with two distinct coordinates is isotropic under a point
mass on a space with measurable singletons. No measurability or integrability
assumption on the vector is needed. -/
theorem not_isIsotropic_dirac_of_ne_coordinates
    {Ω : Type*} [MeasurableSpace Ω] [MeasurableSingletonClass Ω]
    {n : ℕ} (a : Ω) (X : Fin n → Ω → ℝ)
    (i j : Fin n) (hij : i ≠ j) :
    ¬ IsIsotropic (Measure.dirac a) X := by
  intro hIso
  have hProducts := (isIsotropic_iff_integral_mul (Measure.dirac a) X).1 hIso
  have hDiagI : X i a * X i a = 1 := by
    simpa only [integral_dirac, if_pos rfl] using hProducts i i
  have hDiagJ : X j a * X j a = 1 := by
    simpa only [integral_dirac, if_pos rfl] using hProducts j j
  have hOff : X i a * X j a = 0 := by
    simpa only [integral_dirac, if_neg hij] using hProducts i j
  have hi : X i a ≠ 0 := by
    intro hZero
    rw [hZero, zero_mul] at hDiagI
    exact zero_ne_one hDiagI
  have hj : X j a ≠ 0 := by
    intro hZero
    rw [hZero, zero_mul] at hDiagJ
    exact zero_ne_one hDiagJ
  exact mul_ne_zero hi hj hOff

end NumStability.HDP.Vector.Isotropy
