/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution
import Mathlib.Topology.Algebra.Module.FiniteDimension
import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.Analysis.Calculus.FDeriv.Linear

/-!
# Linear rectangle-certified Riemann interface methods

The explicit eigenbasis Riemann solution supplies a method on every ordered
pair of states for a real hyperbolic matrix. Its information is the actual
solution value on ray zero, and its physical matrix flux is constant-state
consistent. No general nonlinear existence or stability theorem is asserted.
-/

open MeasureTheory

namespace NumStability
/-- A real hyperbolic matrix gives a law with an actual constant flux derivative. -/
noncomputable def linearHyperbolicConservationLaw
    {ι : Type*} [Fintype ι] (A : Matrix ι ι ℝ) (hA : IsRealHyperbolicMatrix A) :
    OneDimensionalHyperbolicConservationLaw ι := by
  classical
  exact
    { physicalFlux := A.mulVec
      fluxDerivative := fun _ => (Matrix.toLin' A).toContinuousLinearMap
      fluxJacobian := fun _ => A
      hasFDerivAt_physicalFlux := fun _ => (Matrix.toLin' A).toContinuousLinearMap.hasFDerivAt
      fluxDerivative_eq_jacobian_mulVec := fun _ _ => rfl
      jacobian_hyperbolic := fun _ => hA }

/-- Constant Riemann data remain the same constant in the explicit eigenbasis solution. -/
theorem linearRiemannSolution_constant
    {ι : Type*} [Fintype ι] (eigenbasis : Module.Basis ι ℝ (ι → ℝ))
    (eigenvalues : ι → ℝ) (state : ι → ℝ) (x t : ℝ) :
    linearRiemannSolution eigenbasis eigenvalues state state state x t = state := by
  simp only [linearRiemannSolution, eigenmodeTravelingWave, travelingWave,
    riemannData, ite_self]
  rw [← eigenbasis.equivFun_symm_apply]
  exact eigenbasis.equivFun.symm_apply_apply state

/-- The solver is the independently checked eigenbasis Riemann construction. -/
noncomputable def certifiedLinearRectangleRiemannSolution
    {ι : Type*} [Fintype ι] (A : Matrix ι ι ℝ) (hA : IsRealHyperbolicMatrix A)
    (eigenbasis : Module.Basis ι ℝ (ι → ℝ)) (eigenvalues : ι → ℝ)
    (heigen : ∀ p, A.mulVec (eigenbasis p) = eigenvalues p • eigenbasis p)
    (problem : HyperbolicRiemannProblem (linearHyperbolicConservationLaw A hA)) :
    CertifiedRectangleRiemannSolution (linearHyperbolicConservationLaw A hA) problem where
  solution := linearRiemannSolution eigenbasis eigenvalues
    problem.leftState problem.leftState problem.rightState
  solves := by
    refine ⟨?_, linearRiemannSolution_isRectangleSolution A eigenbasis eigenvalues heigen
      problem.leftState problem.leftState problem.rightState⟩
    simpa only [linearRiemannSolution_initial] using
      riemannData_isRiemannData problem.leftState problem.leftState problem.rightState

/-- For a linear hyperbolic law the domain is all ordered state pairs. Information
is the actual solution value on ray zero; its physical flux is consistent. -/
noncomputable def linearRectangleRiemannInterfaceFluxMethod
    {ι : Type*} [Fintype ι] (A : Matrix ι ι ℝ) (hA : IsRealHyperbolicMatrix A)
    (eigenbasis : Module.Basis ι ℝ (ι → ℝ)) (eigenvalues : ι → ℝ)
    (heigen : ∀ p, A.mulVec (eigenbasis p) = eigenvalues p • eigenbasis p) :
    RectangleRiemannInterfaceFluxMethod (linearHyperbolicConservationLaw A hA) (ι → ℝ) where
  domain := fun _ => True
  solve := fun problem _ =>
    certifiedLinearRectangleRiemannSolution A hA eigenbasis eigenvalues heigen problem
  extractInformation := fun solved => solved.solution 0 1
  numericalFluxFromInformation := A.mulVec
  constants_in_domain := fun _ => True.intro
  consistent_on_constant_states := by
    intro state
    change A.mulVec (linearRiemannSolution eigenbasis eigenvalues state state state 0 1) = _
    rw [linearRiemannSolution_constant]
    rfl

/-- Every real hyperbolic matrix admits a certified method whose domain is all
ordered state pairs. -/
theorem linearRectangleRiemannInterfaceFluxMethod_exists_total
    {ι : Type*} [Fintype ι] (A : Matrix ι ι ℝ) (hA : IsRealHyperbolicMatrix A) :
    ∃ method : RectangleRiemannInterfaceFluxMethod
        (linearHyperbolicConservationLaw A hA) (ι → ℝ),
      ∀ problem, method.domain problem := by
  obtain ⟨eigenvalues, eigenbasis, heigen⟩ := hA
  exact ⟨linearRectangleRiemannInterfaceFluxMethod A
    ⟨eigenvalues, eigenbasis, heigen⟩ eigenbasis eigenvalues heigen, fun _ => True.intro⟩

/-- The abstract method contract is inhabited for every real hyperbolic matrix. -/
theorem linearRectangleRiemannInterfaceFluxMethod_nonempty
    {ι : Type*} [Fintype ι] (A : Matrix ι ι ℝ) (hA : IsRealHyperbolicMatrix A) :
    Nonempty (RectangleRiemannInterfaceFluxMethod (linearHyperbolicConservationLaw A hA) (ι → ℝ)) := by
  obtain ⟨method, _⟩ := linearRectangleRiemannInterfaceFluxMethod_exists_total A hA
  exact ⟨method⟩

/-- The chosen information agrees with the solution on ray zero at every positive time. -/
theorem linearRectangleRiemannInterfaceFluxMethod_information
    {ι : Type*} [Fintype ι] (A : Matrix ι ι ℝ) (hA : IsRealHyperbolicMatrix A)
    (eigenbasis : Module.Basis ι ℝ (ι → ℝ)) (eigenvalues : ι → ℝ)
    (heigen : ∀ p, A.mulVec (eigenbasis p) = eigenvalues p • eigenbasis p)
    (problem : HyperbolicRiemannProblem (linearHyperbolicConservationLaw A hA))
    {t : ℝ} (ht : 0 < t) :
    (linearRectangleRiemannInterfaceFluxMethod A hA eigenbasis eigenvalues heigen).extractInformation
      ((linearRectangleRiemannInterfaceFluxMethod A hA eigenbasis eigenvalues heigen).solve problem trivial) =
    linearRiemannSolution eigenbasis eigenvalues problem.leftState problem.leftState problem.rightState 0 t := by
  exact (linearRiemannSolution_rayZero eigenbasis eigenvalues
    problem.leftState problem.leftState problem.rightState ht).symm

end NumStability
