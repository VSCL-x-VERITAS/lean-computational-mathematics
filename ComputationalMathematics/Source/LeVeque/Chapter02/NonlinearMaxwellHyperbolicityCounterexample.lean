/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellPlaneWaveSpeed
import ComputationalMathematics.Source.LeVeque.Chapter02.NonlinearMaxwellHyperbolicityCounterexampleTarget
import Mathlib.Tactic

/-!
# A positive nonlinear Maxwell law with nonreal characteristic speeds
-/

namespace NumStability.Leveque02Tracer

/-- Field dependence and pointwise positive permittivity do not imply
hyperbolicity of the nonlinear Maxwell plane-wave reduction. -/
theorem nonlinearMaxwellHyperbolicityCounterexample :
    nonlinearMaxwellHyperbolicityCounterexampleTarget := by
  have hden : HasDerivAt (fun e : ℝ => 1 + e ^ 2) 4 2 := by
    convert (hasDerivAt_const (2 : ℝ) (1 : ℝ)).add
      ((hasDerivAt_id (2 : ℝ)).pow 2) using 1
    norm_num
  have hε : HasDerivAt (fun e : ℝ => 1 / (1 + e ^ 2)) (-4 / 25) 2 := by
    convert (hasDerivAt_const (2 : ℝ) (1 : ℝ)).div hden
      (by norm_num : (1 + (2 : ℝ) ^ 2) ≠ 0) using 1
    norm_num
  have hD : HasDerivAt
      (fun e : ℝ => (1 / (1 + e ^ 2)) * e) (-3 / 25) 2 := by
    convert hε.mul (hasDerivAt_id (2 : ℝ)) using 1
    norm_num
  have hderiv :
      deriv (fun e : ℝ => (1 / (1 + e ^ 2)) * e) 2 = -3 / 25 :=
    hD.deriv
  have hsymbol :
      (!![0, 1 / deriv (fun e : ℝ => (1 / (1 + e ^ 2)) * e) 2; 1, 0] :
        Matrix (Fin 2) (Fin 2) ℝ) = !![0, -25 / 3; 1, 0] := by
    simp
    norm_num
  dsimp [nonlinearMaxwellHyperbolicityCounterexampleTarget]
  refine ⟨?_, ?_, hD, hderiv, hsymbol, ?_⟩
  · intro e
    positivity
  · norm_num
  · intro hhyper
    rw [hsymbol] at hhyper
    rcases hhyper with ⟨eigenvalues, eigenbasis, heigen⟩
    let v : Fin 2 → ℝ := eigenbasis 0
    have hvne : v ≠ 0 := eigenbasis.ne_zero 0
    have h0 : (-25 / 3 : ℝ) * v 1 = eigenvalues 0 * v 0 := by
      have h := congrFun (heigen 0) (0 : Fin 2)
      simpa [v, Matrix.mulVec, dotProduct, Fin.sum_univ_two] using h
    have h1 : v 0 = eigenvalues 0 * v 1 := by
      have h := congrFun (heigen 0) (1 : Fin 2)
      simpa [v, Matrix.mulVec, dotProduct, Fin.sum_univ_two] using h
    have hv1 : v 1 = 0 := by
      have hmul : ((eigenvalues 0) ^ 2 + 25 / 3) * v 1 = 0 := by
        calc
          ((eigenvalues 0) ^ 2 + 25 / 3) * v 1 =
              eigenvalues 0 * (eigenvalues 0 * v 1) + (25 / 3) * v 1 := by ring
          _ = eigenvalues 0 * v 0 + (25 / 3) * v 1 := by rw [← h1]
          _ = 0 := by linarith [h0]
      exact (mul_eq_zero.mp hmul).resolve_left (by positivity)
    have hv0 : v 0 = 0 := by simpa [hv1] using h1
    apply hvne
    funext i
    fin_cases i <;> assumption

end NumStability.Leveque02Tracer
