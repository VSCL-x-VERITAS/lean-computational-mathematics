/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellPlaneWaveMatrixModel
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity
import Mathlib.Analysis.SpecialFunctions.Sqrt

/-!
# Proof-free target for LeVeque equation (2.119)

The real-speed and hyperbolicity assertion requires a positive product of the
two scalar material coefficients. Equation (2.118) itself only requires a
nonzero product.
-/

namespace NumStability.Leveque02Tracer

/-- The two eigenvalues of the transverse Maxwell matrix are `−c` and `c`,
where `c=1/√(εμ)` is a positive real speed. The displayed eigenvectors form a
full real basis. -/
def maxwellPlaneWaveSpeedTarget : Prop :=
  ∀ (permittivity permeability : ℝ),
    0 < permittivity * permeability →
    let speed : ℝ := 1 / Real.sqrt (permittivity * permeability)
    let eigenvalues : Fin 2 → ℝ := ![-speed, speed]
    let eigenvectors : Fin 2 → (Fin 2 → ℝ) :=
      ![![-speed, 1], ![speed, 1]]
    (0 < speed ∧
      Function.Injective eigenvalues ∧
      (∀ i, eigenvectors i ≠ 0) ∧
      (∀ i,
        (maxwellPlaneWaveCoefficient permittivity permeability).mulVec (eigenvectors i) =
          eigenvalues i • eigenvectors i) ∧
      IsRealHyperbolicMatrix (maxwellPlaneWaveCoefficient permittivity permeability))

end NumStability.Leveque02Tracer
