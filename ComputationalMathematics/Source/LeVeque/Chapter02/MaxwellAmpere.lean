/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellAmpereTarget
import Mathlib.Tactic

/-!
# LeVeque equation (2.109): charge/current-free Maxwell evolution
-/

namespace NumStability.Leveque02Tracer

/-- The vector Ampère evolution equation is equivalent to its three Cartesian
component equations when its time and spatial partial derivatives exist. -/
theorem maxwellAmpere : maxwellAmpereTarget := by
  intro electricDisplacement magneticField position time
  constructor
  · rintro ⟨htime, hspace, hvector⟩
    refine ⟨htime, hspace, ?_, ?_, ?_⟩
    · have h := congrFun hvector (0 : Fin 3)
      simp [maxwellCurl] at h
      linarith
    · have h := congrFun hvector (1 : Fin 3)
      simp [maxwellCurl] at h
      linarith
    · have h := congrFun hvector (2 : Fin 3)
      simp [maxwellCurl] at h
      linarith
  · rintro ⟨htime, hspace, h0, h1, h2⟩
    refine ⟨htime, hspace, ?_⟩
    funext i
    fin_cases i
    · simp only [maxwellCurl]
      simp
      linarith
    · simp only [maxwellCurl]
      simp
      linarith
    · simp only [maxwellCurl]
      simp
      linarith

end NumStability.Leveque02Tracer
