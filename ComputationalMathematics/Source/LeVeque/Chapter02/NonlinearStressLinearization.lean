/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.NonlinearStressLinearizationTarget
import Mathlib.Tactic

/-!
# First-order normal-stress law at small extensional strain
-/

namespace NumStability.Leveque02Tracer

/-- A differentiable nonlinear stress law with zero reference stress agrees
with the linear elastic normal-stress law to first order at zero strain. -/
theorem nonlinearStressLinearization : nonlinearStressLinearizationTarget := by
  intro stressLaw lameLambda shearModulus _ hzero hderiv
  refine ⟨hderiv.deriv, ?_⟩
  simpa [hzero, smul_eq_mul, mul_comm] using hderiv.isLittleO

end NumStability.Leveque02Tracer
