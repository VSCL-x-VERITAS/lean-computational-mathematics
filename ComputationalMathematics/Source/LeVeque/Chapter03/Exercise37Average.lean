/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.Exercise37Boundary

/-!
# Exercise 3.7: the slow pressure and velocity fields

Printed page 63/raw PDF page 85. These fields are the macroscopic profiles
requested by the exercise. The separate wave calculation must still establish
that they arise by averaging its rapidly reflected acoustic solution.
-/

namespace NumStability

/-- The pressure profile predicted by slow compression. -/
@[nolint unusedArguments]
def leveque03_exercise37SlowPressure
    (bulkModulus initialPressure epsilon : ℝ) (_x t : ℝ) : ℝ :=
  initialPressure + epsilon * t * bulkModulus

/-- The affine velocity profile from piston speed to a stationary wall. -/
@[nolint unusedArguments]
def leveque03_exercise37SlowVelocity
    (epsilon : ℝ) (x _t : ℝ) : ℝ :=
  epsilon * (1 - x)

theorem leveque03_exercise37SlowPressure_uniform
    (bulkModulus initialPressure epsilon x y t : ℝ) :
    leveque03_exercise37SlowPressure bulkModulus initialPressure epsilon x t =
      leveque03_exercise37SlowPressure bulkModulus initialPressure epsilon y t :=
  rfl

theorem leveque03_exercise37SlowVelocity_boundary
    (epsilon t : ℝ) :
    leveque03_exercise37SlowVelocity epsilon 0 t = epsilon ∧
      leveque03_exercise37SlowVelocity epsilon 1 t = 0 := by
  simp [leveque03_exercise37SlowVelocity]

theorem leveque03_exercise37SlowField_acoustics
    (bulkModulus density initialPressure epsilon x t : ℝ) :
    IsLinearAcousticsSolutionAt
      (leveque03_exercise37SlowPressure bulkModulus initialPressure epsilon)
      (leveque03_exercise37SlowVelocity epsilon)
      bulkModulus density x t := by
  refine ⟨epsilon * bulkModulus, 0, 0, -epsilon, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · convert (((hasDerivAt_id t).const_mul epsilon).mul_const bulkModulus).const_add
      initialPressure using 1; ring
  · simpa [leveque03_exercise37SlowPressure] using
      (hasDerivAt_const x (initialPressure + epsilon * t * bulkModulus))
  · simpa [leveque03_exercise37SlowVelocity] using
      (hasDerivAt_const t (epsilon * (1 - x)))
  · convert ((hasDerivAt_const x (1 : ℝ)).sub (hasDerivAt_id x)).const_mul
      epsilon using 1; ring
  · ring
  · ring

end NumStability
