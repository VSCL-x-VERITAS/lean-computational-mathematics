/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.QuasilinearMatrixTarget

/-!
# The Jacobian form of a conservation law

Reuse the existing quasilinear equivalence and standard matrix representation.
-/

namespace NumStability.Leveque02Tracer

/-- The actual flux derivative yields the matrix residual in equation (2.41). -/
theorem quasilinearMatrix : quasilinearMatrixTarget := by
  intro m q flux derivative x t qx hqx hflux
  rw [conservationLaw_iff_quasilinearAt q flux (fun _ => derivative) x t qx hqx hflux]
  simp only [LinearMap.toMatrix'_mulVec, ContinuousLinearMap.coe_coe]
  constructor
  · rintro ⟨qt, qx', hqt, hqx', hres⟩
    have heq := hqx'.unique hqx
    subst qx'
    exact ⟨qt, hqt, hres⟩
  · rintro ⟨qt, hqt, hres⟩
    exact ⟨qt, qx, hqt, hqx, hres⟩

end NumStability.Leveque02Tracer
