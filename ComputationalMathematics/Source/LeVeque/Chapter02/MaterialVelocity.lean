/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaterialVelocityTarget

/-!
# LeVeque equation (2.84): time derivative of displacement
-/

namespace NumStability.Leveque02Tracer

/-- Time differentiation of the displacement vector gives its velocity components. -/
theorem materialVelocityFormula : materialVelocityTarget := by
  intro X Y x y t hX hY
  have hfirst : HasDerivAt (fun τ => X x y τ - x)
      (deriv (fun τ => X x y τ) t) t := by
    simpa using (hX.hasDerivAt.sub_const x)
  have hsecond : HasDerivAt (fun τ => Y x y τ - y)
      (deriv (fun τ => Y x y τ) t) t := by
    simpa using (hY.hasDerivAt.sub_const y)
  simpa [materialVelocity, materialDisplacement, currentMaterialLocation,
    deriv_sub_const] using hfirst.prodMk hsecond

end NumStability.Leveque02Tracer
