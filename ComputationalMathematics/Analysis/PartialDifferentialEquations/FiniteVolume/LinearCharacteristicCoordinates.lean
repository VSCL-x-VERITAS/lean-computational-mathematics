/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearCharacteristicEvolution
import Mathlib.Analysis.Normed.Group.Constructions
import Mathlib.Analysis.Normed.Module.FiniteDimension
import Mathlib.Analysis.Normed.Operator.Basic

/-!
# Coordinates of linear characteristic evolution

Taking a characteristic coordinate of the eigenmode superposition selects
that coordinate of the initial data at its translated characteristic foot.
The Riemann-coordinate formula is a specialization of this identity.
-/

namespace NumStability

/-- A basis coordinate is bounded by the operator norm of its coordinate map. -/
theorem basis_coordinate_abs_le_opNorm
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (v : Fin m → ℝ) (p : Fin m) :
    |basis.equivFun v p| ≤
      ‖basis.equivFun.toContinuousLinearEquiv.toContinuousLinearMap‖ * ‖v‖ := by
  let L := basis.equivFun.toContinuousLinearEquiv.toContinuousLinearMap
  calc
    |basis.equivFun v p| = ‖basis.equivFun v p‖ := (Real.norm_eq_abs _).symm
    _ ≤ ‖basis.equivFun v‖ := norm_le_pi_norm _ p
    _ ≤ ‖L‖ * ‖v‖ := by
      simpa only [L, LinearEquiv.coe_toContinuousLinearEquiv] using L.le_opNorm v

/-- Each characteristic coordinate follows its own translated initial datum. -/
theorem linearCharacteristicEvolution_coordinate
    {ι : Type*} [Fintype ι]
    (basis : Module.Basis ι ℝ (ι → ℝ)) (speeds : ι → ℝ)
    (initial : ℝ → ι → ℝ) (x time : ℝ) (p : ι) :
    basis.equivFun (linearCharacteristicEvolution basis speeds initial x time) p =
      basis.equivFun (initial (x - speeds p * time)) p := by
  classical
  simp only [linearCharacteristicEvolution, map_sum, map_smul,
    Finset.sum_apply, Pi.smul_apply, smul_eq_mul]
  simp

/-- The actual Riemann field has the translated scalar datum in each mode,
including the selected front value. -/
theorem linearRiemannSolution_coordinate
    {ι : Type*} [Fintype ι]
    (basis : Module.Basis ι ℝ (ι → ℝ)) (speeds : ι → ℝ)
    (left atOrigin right : ι → ℝ) (x time : ℝ) (p : ι) :
    basis.equivFun (linearRiemannSolution basis speeds left atOrigin right x time) p =
      riemannData (basis.equivFun left p) (basis.equivFun atOrigin p)
        (basis.equivFun right p) (x - speeds p * time) := by
  rw [linearRiemannSolution_eq_characteristicEvolution,
    linearCharacteristicEvolution_coordinate]
  simp only [riemannData]
  split_ifs <;> rfl

end NumStability
