/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution

/-!
# LeVeque Chapter 1, linear Riemann solution in an eigenbasis

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 5 (raw PDF page 27), continuing on printed page 6 (raw PDF page 28).
-/

namespace NumStability

/-- A real hyperbolic matrix gives a Riemann solution by finite eigenmode
superposition. Conservation is the time-integrated rectangle balance, and the
origin value is independently selected. -/
theorem leveque01_linearRiemann_eigensolution
    {ι : Type*} [Fintype ι] {coefficient : Matrix ι ι ℝ}
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (leftState valueAtOrigin rightState : ι → ℝ) :
    ∃ (eigenvalues : ι → ℝ) (eigenbasis : Module.Basis ι ℝ (ι → ℝ)),
      (∀ p, coefficient.mulVec (eigenbasis p) = eigenvalues p • eigenbasis p) ∧
      IsRectangleConservationLawSolution
        (linearRiemannSolution eigenbasis eigenvalues leftState valueAtOrigin rightState)
        coefficient.mulVec ∧
      (∀ x, linearRiemannSolution eigenbasis eigenvalues leftState valueAtOrigin rightState x 0 =
        riemannData leftState valueAtOrigin rightState x) ∧
      (∀ x t, 0 < t →
        linearRiemannSolution eigenbasis eigenvalues leftState valueAtOrigin rightState x t =
        linearRiemannSolution eigenbasis eigenvalues leftState valueAtOrigin rightState (x / t) 1) := by
  rcases hcoefficient with ⟨eigenvalues, eigenbasis, heigen⟩
  exact ⟨eigenvalues, eigenbasis, heigen,
    linearRiemannSolution_isRectangleSolution coefficient eigenbasis eigenvalues heigen
      leftState valueAtOrigin rightState,
    linearRiemannSolution_initial eigenbasis eigenvalues leftState valueAtOrigin rightState,
    fun x _t ht => linearRiemannSolution_selfSimilar eigenbasis eigenvalues
      leftState valueAtOrigin rightState x ht⟩

end NumStability
