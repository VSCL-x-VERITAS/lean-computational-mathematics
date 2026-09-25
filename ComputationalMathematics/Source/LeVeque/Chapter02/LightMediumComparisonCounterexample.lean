/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LightMediumComparisonCounterexampleTarget
import Mathlib.Tactic

/-!
# Counterexample to an unqualified medium-speed comparison
-/

namespace NumStability.Leveque02Tracer

/-- The precise condition missing from the printed comparison. -/
theorem lightMediumComparisonCorrected :
    lightMediumComparisonCorrectedTarget := by
  intro permittivity permeability vacuumPermittivity vacuumPermeability
    hmedium hvacuum
  have hmroot : 0 < Real.sqrt (permittivity * permeability) :=
    Real.sqrt_pos.2 hmedium
  have hvroot : 0 < Real.sqrt (vacuumPermittivity * vacuumPermeability) :=
    Real.sqrt_pos.2 hvacuum
  constructor
  · intro hspeed
    have hroot :
        Real.sqrt (vacuumPermittivity * vacuumPermeability) <
          Real.sqrt (permittivity * permeability) :=
      (inv_lt_inv₀ hmroot hvroot).1 (by simpa only [one_div] using hspeed)
    exact (Real.sqrt_lt_sqrt_iff hvacuum.le).1 hroot
  · intro hproduct
    simpa only [one_div] using
      (inv_lt_inv₀ hmroot hvroot).2
        (Real.sqrt_lt_sqrt hvacuum.le hproduct)

/-- Positive scalar material coefficients alone do not make every different
medium slower than the displayed vacuum reference. -/
theorem lightMediumComparisonCounterexample :
    lightMediumComparisonCounterexampleTarget := by
  intro vacuumPermittivity vacuumPermeability hε hμ
  dsimp [lightMediumComparisonCounterexampleTarget] at *
  have hmediumPermittivity : 0 < vacuumPermittivity / 4 := by positivity
  have hmediumProduct : 0 < (vacuumPermittivity / 4) * vacuumPermeability :=
    mul_pos hmediumPermittivity hμ
  have hvacuumProduct : 0 < vacuumPermittivity * vacuumPermeability :=
    mul_pos hε hμ
  have hproduct :
      (vacuumPermittivity / 4) * vacuumPermeability <
        vacuumPermittivity * vacuumPermeability := by
    nlinarith [mul_pos hε hμ]
  have hspeed :
      1 / Real.sqrt (vacuumPermittivity * vacuumPermeability) <
        1 / Real.sqrt ((vacuumPermittivity / 4) * vacuumPermeability) :=
    (lightMediumComparisonCorrected
      vacuumPermittivity vacuumPermeability
      (vacuumPermittivity / 4) vacuumPermeability
      hvacuumProduct hmediumProduct).2 hproduct
  refine ⟨hmediumPermittivity, hμ, ?_, hspeed, hspeed.not_gt⟩
  intro hpair
  have heq := congrArg Prod.fst hpair
  dsimp at heq
  linarith

end NumStability.Leveque02Tracer
