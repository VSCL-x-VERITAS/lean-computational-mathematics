/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ConvectedAcousticsEigenvaluesTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.BulkModulusModel
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic

/-!
# Proof-free target: Exercise 2.8(a)

The isothermal law has constant derivative `a²`. We state the exact
characteristic roots of the Eulerian pressure-velocity matrix (2.50),
including the repeated-root case `a=0`.
-/

namespace NumStability.Leveque02Tracer

/-- With `P(ρ)=a²ρ`, the Eulerian acoustic speeds are the unordered pair
`u₀−a`, `u₀+a`, equivalently the ordered pair `u₀−|a|`, `u₀+|a|`.
The zero-`a` case has a repeated characteristic root. -/
def exercise28aTarget : Prop :=
  ∀ (a densityBackground backgroundVelocity : ℝ),
    0 < densityBackground →
    let pressureLaw : ℝ → ℝ := fun density => a ^ 2 * density
    let bulkModulus := acousticBulkModulus pressureLaw densityBackground
    let coefficient := convectedLinearAcousticsMatrix
      bulkModulus densityBackground backgroundVelocity
    HasDerivAt pressureLaw (a ^ 2) densityBackground ∧
      bulkModulus = densityBackground * a ^ 2 ∧
      Real.sqrt (bulkModulus / densityBackground) = |a| ∧
      ∀ eigenvalue : ℝ,
        Matrix.det (coefficient - eigenvalue • (1 : Matrix (Fin 2) (Fin 2) ℝ)) = 0 ↔
          eigenvalue = backgroundVelocity - a ∨
            eigenvalue = backgroundVelocity + a

end NumStability.Leveque02Tracer
