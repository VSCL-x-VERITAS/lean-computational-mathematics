/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PositivePressureSlopeNecessaryTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.FluidJacobian
import ComputationalMathematics.Source.LeVeque.Chapter02.IsentropicSoundSpeed
import Mathlib.Tactic

/-!
# LeVeque Chapter 2: PositivePressureSlopeNecessary

Proof that a complete real Euler eigensystem needs positive pressure slope.
-/

namespace NumStability.Leveque02Tracer

private theorem gas_eigenvalue_sq
    (velocity pressureSlope eigenvalue : ℝ) (v : Fin 2 → ℝ)
    (hvne : v ≠ 0)
    (hv : (!![0, 1; -velocity ^ 2 + pressureSlope, 2 * velocity] :
      Matrix (Fin 2) (Fin 2) ℝ).mulVec v = eigenvalue • v) :
    pressureSlope = (eigenvalue - velocity) ^ 2 := by
  have hfirst : v 1 = eigenvalue * v 0 := by
    have h := congrFun hv (0 : Fin 2)
    simpa [Matrix.mulVec, dotProduct, Fin.sum_univ_two] using h
  have hsecond : (-velocity ^ 2 + pressureSlope) * v 0 +
      2 * velocity * v 1 = eigenvalue * v 1 := by
    have h := congrFun hv (1 : Fin 2)
    simpa [Matrix.mulVec, dotProduct, Fin.sum_univ_two] using h
  have hfirstNe : v 0 ≠ 0 := by
    intro hzero
    have hsecondZero : v 1 = 0 := by simpa [hzero] using hfirst
    apply hvne
    funext i
    fin_cases i <;> simp [hzero, hsecondZero]
  rw [hfirst] at hsecond
  have hproduct : (pressureSlope - (eigenvalue - velocity) ^ 2) * v 0 = 0 := by
    nlinarith [hsecond]
  exact sub_eq_zero.mp ((mul_eq_zero.mp hproduct).resolve_right hfirstNe)

private theorem gas_zero_slope_not_hyperbolic
    (density velocity : ℝ) (hdensity : 0 < density) :
    ¬ IsRealHyperbolicMatrix
      (fluidFluxJacobian (fluidConservedState density velocity) 0) := by
  intro hhyper
  obtain ⟨eigenvalues, eigenbasis, heigen⟩ := hhyper
  have hmatrix :
      fluidFluxJacobian (fluidConservedState density velocity) 0 =
        (!![0, 1; -velocity ^ 2, 2 * velocity] : Matrix (Fin 2) (Fin 2) ℝ) := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [fluidFluxJacobian, fluidConservedState]
    all_goals field_simp [ne_of_gt hdensity]
  let projection : (Fin 2 → ℝ) →ₗ[ℝ] ℝ :=
    LinearMap.proj 1 - velocity • LinearMap.proj 0
  have hprojection : projection = 0 := eigenbasis.ext (fun p => by
    have hsquare := gas_eigenvalue_sq velocity 0 (eigenvalues p)
      (eigenbasis p) (eigenbasis.ne_zero p) (by simpa [hmatrix] using heigen p)
    have heigenzero : eigenvalues p = velocity := by
      nlinarith [hsquare]
    have hfirst := congrFun (heigen p) (0 : Fin 2)
    rw [hmatrix] at hfirst
    have hcomponent : (eigenbasis p) 1 = velocity * (eigenbasis p) 0 := by
      simpa [Matrix.mulVec, dotProduct, Fin.sum_univ_two, heigenzero] using hfirst
    simp [projection, hcomponent])
  have hvalue := congrArg
    (fun f : (Fin 2 → ℝ) →ₗ[ℝ] ℝ => f ![0, 1]) hprojection
  norm_num [projection] at hvalue

theorem positivePressureSlopeNecessary : positivePressureSlopeNecessaryTarget := by
  intro pressureLaw density velocity pressureSlope hdensity hpressure
  dsimp only
  constructor
  · constructor
    · intro hhyper
      obtain ⟨eigenvalues, eigenbasis, heigen⟩ := hhyper
      have hmatrix :
          fluidFluxJacobian (fluidConservedState density velocity) pressureSlope =
            (!![0, 1; -velocity ^ 2 + pressureSlope, 2 * velocity] :
              Matrix (Fin 2) (Fin 2) ℝ) := by
        exact (fluidJacobian pressureLaw density velocity pressureSlope hdensity hpressure).1
      have hsquare := gas_eigenvalue_sq velocity pressureSlope (eigenvalues 0)
        (eigenbasis 0) (eigenbasis.ne_zero 0) (by rw [← hmatrix]; exact heigen 0)
      have hnonneg : 0 ≤ pressureSlope := by rw [hsquare]; positivity
      by_contra hnotpositive
      have hzero : pressureSlope = 0 := le_antisymm (le_of_not_gt hnotpositive) hnonneg
      apply gas_zero_slope_not_hyperbolic density velocity hdensity
      rw [← hzero]
      exact ⟨eigenvalues, eigenbasis, heigen⟩
    · intro hslope
      exact (isentropicSoundSpeed.1 pressureLaw density velocity pressureSlope
        hdensity hslope hpressure).2.2.2.2
  · intro hzero
    subst pressureSlope
    exact gas_zero_slope_not_hyperbolic density velocity hdensity

end NumStability.Leveque02Tracer
