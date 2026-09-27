/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.AcousticDecomposition

/-!
# Advection of acoustic characteristic strengths

Equation (3.11), printed page 50/raw PDF page 72. The Chapter 2 invariant
equations supply the PDE; the fixed inverse-matrix normalization supplies the
two wave strengths.
-/

namespace NumStability

/-- A fixed scalar multiple of a scalar advection solution solves the same
equation at the same point. -/
private theorem acoustic_advection_const_mul
    (f : ℝ → ℝ → ℝ) (speed c x t : ℝ)
    (h : IsLinearAdvectionSolutionAt f speed x t) :
    IsLinearAdvectionSolutionAt (fun ξ τ => c * f ξ τ) speed x t := by
  rcases h with ⟨qt, qx, ht, hx, hres⟩
  refine ⟨c * qt, c * qx, ht.const_mul c, hx.const_mul c, ?_⟩
  calc
    c * qt + speed * (c * qx) = c * (qt + speed * qx) := by ring
    _ = 0 := by
      have hres' : qt + speed * qx = 0 := by
        simpa only [smul_eq_mul] using hres
      simp [hres']

/-- The left acoustic strength solves advection at speed `-c₀`, and the right
strength solves advection at speed `c₀`. -/
theorem leveque03_acousticCharacteristicAdvection
    (pressure velocity : ℝ → ℝ → ℝ)
    (bulkModulus density soundSpeed x t : ℝ)
    (hZ : 0 < acousticImpedance density soundSpeed)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2)
    (hsystem : IsLinearAcousticsSolutionAt
      pressure velocity bulkModulus density x t) :
    IsLinearAdvectionSolutionAt
      (fun ξ τ => acousticWaveStrengths density soundSpeed
        (pressure ξ τ) (velocity ξ τ) 0) (-soundSpeed) x t ∧
    IsLinearAdvectionSolutionAt
      (fun ξ τ => acousticWaveStrengths density soundSpeed
        (pressure ξ τ) (velocity ξ τ) 1) soundSpeed x t := by
  have hZne : acousticImpedance density soundSpeed ≠ 0 := ne_of_gt hZ
  have hdensity : density ≠ 0 := by
    intro hz
    simp [acousticImpedance, hz] at hZne
  have hL := linearAcousticsLeftInvariant_isLinearAdvectionSolutionAt
    pressure velocity bulkModulus density soundSpeed x t hdensity
    hmaterial hsystem
  have hR := linearAcousticsRightInvariant_isLinearAdvectionSolutionAt
    pressure velocity bulkModulus density soundSpeed x t hdensity
    hmaterial hsystem
  have hleftField :
      (fun ξ τ => acousticWaveStrengths density soundSpeed
        (pressure ξ τ) (velocity ξ τ) 0) =
      (fun ξ τ => -(2 * acousticImpedance density soundSpeed)⁻¹ *
        linearAcousticsLeftInvariant pressure velocity density soundSpeed ξ τ) := by
    funext ξ τ
    have hformula := Leveque02Tracer.acousticWaveStrengthsFormula
      density soundSpeed (pressure ξ τ) (velocity ξ τ) hZ
    have hleft := congrFun hformula 0
    rw [hleft]
    simp [linearAcousticsLeftInvariant, acousticImpedance,
      div_eq_mul_inv]; ring
  have hrightField :
      (fun ξ τ => acousticWaveStrengths density soundSpeed
        (pressure ξ τ) (velocity ξ τ) 1) =
      (fun ξ τ => (2 * acousticImpedance density soundSpeed)⁻¹ *
        linearAcousticsRightInvariant pressure velocity density soundSpeed ξ τ) := by
    funext ξ τ
    have hformula := Leveque02Tracer.acousticWaveStrengthsFormula
      density soundSpeed (pressure ξ τ) (velocity ξ τ) hZ
    have hright := congrFun hformula 1
    rw [hright]
    simp [linearAcousticsRightInvariant, acousticImpedance,
      div_eq_mul_inv]; ring
  rw [hleftField, hrightField]
  exact ⟨acoustic_advection_const_mul _ _ _ _ _ hL,
    acoustic_advection_const_mul _ _ _ _ _ hR⟩

end NumStability
