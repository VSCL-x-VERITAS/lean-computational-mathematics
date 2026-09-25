/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Equation77FirstOrderWaveTarget
import Mathlib.Analysis.Calculus.Deriv.Add

/-!
# LeVeque Chapter 2, Equation (2.77): first-order wave system
-/

namespace NumStability.Leveque02Tracer

/-- The scalar wave equation and commuting mixed partials produce the
two-component constant-coefficient system in Equation (2.77). -/
theorem equation77FirstOrderWave : equation77FirstOrderWaveTarget := by
  intro c₀ pressure pressureTime pressureSpace hc hfirst x t ptt pxx ptx pxt
    hptt hpxx hptx hpxt hwave hmixed
  change ∃ qt qx : Fin 2 → ℝ,
    HasDerivAt
        (fun τ => ![pressureTime x τ, -pressureSpace x τ]) qt t ∧
      HasDerivAt
        (fun ξ => ![pressureTime ξ t, -pressureSpace ξ t]) qx x ∧
        qt + (!![0, c₀ ^ 2; 1, 0]).mulVec qx = 0
  refine ⟨![ptt, -pxt], ![ptx, -pxx], ?_, ?_, ?_⟩
  · apply hasDerivAt_pi.mpr
    simpa [Fin.forall_fin_two] using And.intro hptt hpxt.neg
  · apply hasDerivAt_pi.mpr
    simpa [Fin.forall_fin_two] using And.intro hptx hpxx.neg
  · ext i
    fin_cases i
    · simp [hwave, mul_comm]
    · simp [hmixed]

end NumStability.Leveque02Tracer
