/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellFaradayTarget
import Mathlib.Tactic

/-!
# LeVeque equation (2.110): Faraday evolution
-/

namespace NumStability.Leveque02Tracer

/-- The Faraday vector equation and its three Cartesian component equations
agree when exactly their required partial derivatives exist. -/
theorem maxwellFaraday : maxwellFaradayTarget := by
  intro magneticInduction electricField position time
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
