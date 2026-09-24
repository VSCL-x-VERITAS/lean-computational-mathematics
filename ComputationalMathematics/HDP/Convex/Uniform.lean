import ComputationalMathematics.HDP.Convex.Body
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.MeasureTheory.Measure.OpenPos
import Mathlib.Probability.ConditionalProbability
import Mathlib.Probability.HasLaw

/-!
# Uniform probability laws on convex bodies

This module defines normalized Lebesgue measure on a finite-dimensional convex
body and packages the corresponding vector-valued law.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Convex

/-- Normalized Lebesgue measure on a finite-dimensional set.  For a convex
body, positivity and boundedness make this a probability measure. -/
def uniformConvexBodyMeasure {n : ℕ} (K : Set (Fin n → ℝ)) :
    Measure (Fin n → ℝ) :=
  ProbabilityTheory.cond volume K

/-- Normalized Lebesgue measure on a convex body is a probability measure. -/
theorem uniformConvexBodyMeasure_isProbabilityMeasure {n : ℕ}
    {K : Set (Fin n → ℝ)} (hK : IsConvexBody K) :
    IsProbabilityMeasure (uniformConvexBodyMeasure K) := by
  unfold uniformConvexBodyMeasure
  exact cond_isProbabilityMeasure_of_finite
    (Measure.measure_pos_of_nonempty_interior volume hK.2.2).ne'
    hK.2.1.measure_lt_top.ne

/-- A finite real random vector is uniform on a convex body when the set is a
convex body and the vector's joint law is normalized Lebesgue measure on it. -/
def HasUniformConvexBodyLaw {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ) (K : Set (Fin n → ℝ)) : Prop :=
  IsConvexBody K ∧
    HasLaw (fun ω i => X i ω) (uniformConvexBodyMeasure K) μ

/-- The componentwise characterization of a uniform convex-body law. -/
theorem hasUniformConvexBodyLaw_iff {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} {X : Fin n → Ω → ℝ} {K : Set (Fin n → ℝ)} :
    HasUniformConvexBodyLaw μ X K ↔
      IsConvexBody K ∧
        HasLaw (fun ω i => X i ω) (uniformConvexBodyMeasure K) μ :=
  Iff.rfl

end NumStability.HDP.Convex
