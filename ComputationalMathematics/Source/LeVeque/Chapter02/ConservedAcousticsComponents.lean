/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ConservedAcousticsComponentsTarget

/-!
# Conserved-component form of the linear acoustics system

This source wrapper expands the constant coefficient matrix equation into its
density and momentum coordinate equations.
-/

namespace NumStability.Leveque02Tracer
/-- Equation (2.47): the constant-matrix system in conserved density/momentum components. -/
theorem conservedAcousticsComponents : conservedAcousticsComponentsTarget := by
  intro pressureLaw densityBackground u s hρ hP density momentum x t
  constructor
  · rintro ⟨qt, qx, ht, hx, hres⟩
    refine ⟨qt 0, qt 1, qx 0, qx 1, hasDerivAt_pi.mp ht 0,
      hasDerivAt_pi.mp ht 1, hasDerivAt_pi.mp hx 0, hasDerivAt_pi.mp hx 1, ?_, ?_⟩
    · simpa [Matrix.mulVec, dotProduct, Fin.sum_univ_two] using congrFun hres 0
    · simpa [Matrix.mulVec, dotProduct, Fin.sum_univ_two, add_assoc] using congrFun hres 1
  · rintro ⟨ρt, mt, ρx, mx, hρt, hmt, hρx, hmx, hfirst, hsecond⟩
    refine ⟨![ρt, mt], ![ρx, mx], ?_, ?_, ?_⟩
    · exact hasDerivAt_pi.mpr (by simpa [Fin.forall_fin_two] using And.intro hρt hmt)
    · exact hasDerivAt_pi.mpr (by simpa [Fin.forall_fin_two] using And.intro hρx hmx)
    · ext i
      fin_cases i
      · simpa [Matrix.mulVec, dotProduct, Fin.sum_univ_two] using hfirst
      · simpa [Matrix.mulVec, dotProduct, Fin.sum_univ_two, add_assoc, mul_comm] using hsecond
end NumStability.Leveque02Tracer

