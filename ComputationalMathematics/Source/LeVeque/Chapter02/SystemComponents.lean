/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.SystemComponentsTarget

/-!
# Component equations of a conservation law

Package the existing coordinate derivative characterization into the source's
vector and scalar residual correspondence.
-/

namespace NumStability.Leveque02Tracer

/-- Each conserved component satisfies its actual scalar balance. -/
theorem systemComponents : systemComponentsTarget := by
  intro m q flux x t
  constructor
  · rintro ⟨qt, fx, ht, hx, hres⟩ i
    exact ⟨qt i, fx i, hasDerivAt_pi.mp ht i, hasDerivAt_pi.mp hx i,
      congrFun hres i⟩
  · intro h
    choose qt fx ht hx hres using h
    exact ⟨qt, fx, hasDerivAt_pi.mpr ht, hasDerivAt_pi.mpr hx, funext hres⟩

end NumStability.Leveque02Tracer
