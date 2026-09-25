/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.HomogeneousReactingFlowHyperbolicityTarget

/-!
# LeVeque Chapter 2: homogeneous radioactive conversion
-/

namespace NumStability.Leveque02Tracer

/-- At zero reaction rate, the two species share one repeated characteristic
speed. -/
theorem homogeneousReactingFlowHyperbolicity :
    homogeneousReactingFlowHyperbolicityTarget := by
  intro velocity
  let coefficient := homogeneousReactingFlowCoefficient velocity
  have hmul (state : Fin 2 → ℝ) :
      coefficient.mulVec state = velocity • state := by
    ext i
    simp [coefficient, homogeneousReactingFlowCoefficient, Matrix.mulVec_diagonal,
      Pi.smul_apply]
  have hsym : coefficient.transpose = coefficient := by
    simp [coefficient, homogeneousReactingFlowCoefficient, Matrix.diagonal_transpose]
  have heigen (speed : ℝ) :
      Module.End.HasEigenvalue (Matrix.toLin' coefficient) speed ↔
        speed = velocity := by
    change Module.End.HasEigenvalue
      (Matrix.toLin' (Matrix.diagonal (fun _ : Fin 2 => velocity))) speed ↔
        speed = velocity
    rw [hasEigenvalue_toLin'_diagonal_iff]
    constructor
    · rintro ⟨i, hi⟩
      exact hi.symm
    · intro h
      exact ⟨0, h.symm⟩
  refine ⟨?_, hmul, hsym, symmetricStrictHyperbolicity.1 coefficient hsym,
    heigen, ?_⟩
  · intro q spaceDerivative x t hspace
    have hflux : (fun state : Fin 2 → ℝ => velocity • state) =
        constantLinearFlux coefficient := by
      funext state
      exact (hmul state).symm
    rw [hflux]
    change IsConservationLawSolutionAt q (constantLinearFlux coefficient) x t ↔
      IsConstantCoefficientLinearSystemSolutionAt q coefficient x t
    exact conservationLaw_constantLinearFlux_iff
      q coefficient x t spaceDerivative hspace
  · rintro ⟨speeds, hinjective, hall⟩
    have hzero : speeds 0 = velocity := (heigen _).mp (hall 0)
    have hone : speeds 1 = velocity := (heigen _).mp (hall 1)
    have h01 : (0 : Fin 2) = 1 := hinjective (hzero.trans hone.symm)
    exact (by decide : (0 : Fin 2) ≠ 1) h01

end NumStability.Leveque02Tracer
