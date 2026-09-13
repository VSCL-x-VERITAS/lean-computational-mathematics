/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Equation01

/-!
# The tracer-density model underlying LeVeque (2.1)

The opening paragraph of Chapter 2 (printed page 15, PDF page 37) distinguishes
volumetric tracer density from tracer mass per unit length. Multiplication by
pipe cross-sectional area converts the former to the latter.

The definitions here make that interpretation and its mathematical domain
explicit. `volumetricDensity` is measured in mass per volume; `area` in area;
their product in mass per length; and `physicalSectionMass` in mass. These are
the roles of real-valued coordinates in the model, not a formal units calculus.

Admissibility concerns one ordered segment at one time. It requires nonnegative
physical input data on that segment and existence of the finite integral.
The book leaves the analytic integration framework implicit; this realization
uses the Lebesgue integral. No temporal conservation law is asserted.

-/

namespace NumStability.Leveque02Tracer

/-- Convert volumetric tracer density to tracer mass per unit pipe length. -/
noncomputable def linearDensity
    (volumetricDensity : ℝ → ℝ → ℝ) (area : ℝ → ℝ) (x t : ℝ) : ℝ :=
  volumetricDensity x t * area x

/-- The physical and analytic domain of a fixed-time segment-mass reading.
No assumptions are imposed outside this segment or at other times. -/
def AdmissibleSegment
    (volumetricDensity : ℝ → ℝ → ℝ) (area : ℝ → ℝ) (a b t : ℝ) : Prop :=
  a < b ∧
    (∀ x ∈ Set.Icc a b, 0 ≤ volumetricDensity x t) ∧
    (∀ x ∈ Set.Icc a b, 0 ≤ area x) ∧
    IntervalIntegrable (fun x => linearDensity volumetricDensity area x t)
      MeasureTheory.volume a b

/-- Instantaneous tracer mass for admissible data in the one-dimensional pipe
model. The argument restricts the physical interpretation of the existing
oriented integral notation to ordered, nonnegative, integrable data.
The admissibility proof is intentionally required by the interface even though
the integral's value does not depend on that proof. -/
@[nolint unusedArguments]
noncomputable def physicalSectionMass
    (volumetricDensity : ℝ → ℝ → ℝ) (area : ℝ → ℝ) (a b t : ℝ)
    (_admissible : AdmissibleSegment volumetricDensity area a b t) : ℝ :=
  leveque02Equation01SectionMass (linearDensity volumetricDensity area) a b t

end NumStability.Leveque02Tracer
