import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle
import Mathlib.Topology.Algebra.Module.FiniteDimension
import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.Analysis.Calculus.FDeriv.Linear

open MeasureTheory
open scoped BigOperators

namespace NumStability

/-- An ordered Riemann initial trace together with time-integrated rectangle conservation. -/
def IsRectangleHyperbolicRiemannSolution
    {Component : Type*} [Fintype Component]
    (law : OneDimensionalHyperbolicConservationLaw Component)
    (problem : HyperbolicRiemannProblem law)
    (solution : ℝ → ℝ → (Component → ℝ)) : Prop :=
  IsRiemannData (fun x => solution x 0) problem.leftState problem.rightState ∧
    IsRectangleConservationLawSolution solution law.physicalFlux

/-- A solution certified for the actual ordered problem it solves. -/
structure CertifiedRectangleRiemannSolution
    {Component : Type*} [Fintype Component]
    (law : OneDimensionalHyperbolicConservationLaw Component)
    (problem : HyperbolicRiemannProblem law) where
  solution : ℝ → ℝ → (Component → ℝ)
  solves : IsRectangleHyperbolicRiemannSolution law problem solution

/-- A solver on an explicit domain, followed by information extraction and a
numerical-flux procedure. Constant problems belong to the domain and have the
physical constant-state flux. No general nonlinear solvability is assumed. -/
structure RectangleRiemannInterfaceFluxMethod
    {Component : Type*} [Fintype Component]
    (law : OneDimensionalHyperbolicConservationLaw Component)
    (Information : Type*) where
  domain : HyperbolicRiemannProblem law → Prop
  solve : (problem : HyperbolicRiemannProblem law) → domain problem →
    CertifiedRectangleRiemannSolution law problem
  extractInformation : {problem : HyperbolicRiemannProblem law} →
    CertifiedRectangleRiemannSolution law problem → Information
  numericalFluxFromInformation : Information → (Component → ℝ)
  constants_in_domain : ∀ state,
    domain ({ leftState := state, rightState := state } : HyperbolicRiemannProblem law)
  consistent_on_constant_states : ∀ state,
    numericalFluxFromInformation
      (extractInformation
        (solve ({ leftState := state, rightState := state } : HyperbolicRiemannProblem law)
          (constants_in_domain state))) = law.physicalFlux state

/-- The information at interface `i` comes from the problem ordered from cell
`i - 1` to cell `i`, with explicit evidence that this problem is in the solver domain. -/
def adjacentCellRectangleRiemannInformation
    {Component Information : Type*} [Fintype Component]
    {law : OneDimensionalHyperbolicConservationLaw Component}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (cellAverages : ℤ → (Component → ℝ))
    (hdomain : ∀ i, method.domain (adjacentCellRiemannProblem law cellAverages i))
    (i : ℤ) : Information :=
  method.extractInformation
    (method.solve (adjacentCellRiemannProblem law cellAverages i) (hdomain i))

def rectangleRiemannInterfaceFlux
    {Component Information : Type*} [Fintype Component]
    {law : OneDimensionalHyperbolicConservationLaw Component}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (cellAverages : ℤ → (Component → ℝ))
    (hdomain : ∀ i, method.domain (adjacentCellRiemannProblem law cellAverages i))
    (i : ℤ) : Component → ℝ :=
  method.numericalFluxFromInformation
    (adjacentCellRectangleRiemannInformation method cellAverages hdomain i)

/-- The finite-volume interface workflow constructs actual normalized cell
averages, certified local solves, extracted information, interface fluxes and
the conservative update. Local Riemann coordinates put each interface at zero. -/
theorem rectangleRiemannInterface_finiteVolumeStep
    {Component Information : Type*} [Fintype Component]
    (law : OneDimensionalHyperbolicConservationLaw Component)
    (grid : OneDimensionalFiniteVolumeGrid)
    (initialState : ℝ → (Component → ℝ))
    (hintegrable : ∀ i, IntervalIntegrable initialState volume
      (grid.cellLeft i) (grid.cellRight i))
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (hdomain : ∀ i, method.domain
      (adjacentCellRiemannProblem law (finiteVolumeCellAverageOn grid initialState) i))
    (timeStep : ℝ) :
    ∃ cellAverages : ℤ → (Component → ℝ),
      (∀ i, IsOneDimensionalCellAverage initialState
        (grid.cellLeft i) (grid.cellRight i) (cellAverages i)) ∧
      (∀ i, grid.cellRight (i - 1) = grid.cellLeft i) ∧
      (∀ i, method.domain (adjacentCellRiemannProblem law cellAverages i)) ∧
      ∃ solved : (i : ℤ) → CertifiedRectangleRiemannSolution law
          (adjacentCellRiemannProblem law cellAverages i),
        (∀ i, IsRiemannData (fun x => (solved i).solution x 0)
          (cellAverages (i - 1)) (cellAverages i)) ∧
        (∀ i, IsRectangleConservationLawSolution (solved i).solution law.physicalFlux) ∧
        ∃ information : ℤ → Information,
          (∀ i, information i = method.extractInformation (solved i)) ∧
          ∃ numericalFlux : ℤ → (Component → ℝ),
            (∀ i, numericalFlux i = method.numericalFluxFromInformation (information i)) ∧
            (∀ state, method.numericalFluxFromInformation
              (method.extractInformation
                (method.solve
                  ({ leftState := state, rightState := state } : HyperbolicRiemannProblem law)
                  (method.constants_in_domain state))) = law.physicalFlux state) ∧
            ∃ updatedCellAverages : ℤ → (Component → ℝ),
              ∀ i, updatedCellAverages i =
                riemannFiniteVolumeUpdate grid timeStep cellAverages numericalFlux i := by
  let cellAverages := finiteVolumeCellAverageOn grid initialState
  refine ⟨cellAverages, ?_, grid.adjacent, hdomain, ?_⟩
  · exact finiteVolumeCellAverageOn_spec grid initialState hintegrable
  · let solved : (i : ℤ) → CertifiedRectangleRiemannSolution law
        (adjacentCellRiemannProblem law cellAverages i) :=
      fun i => method.solve (adjacentCellRiemannProblem law cellAverages i) (hdomain i)
    refine ⟨solved, fun i => (solved i).solves.1, fun i => (solved i).solves.2, ?_⟩
    let information : ℤ → Information := fun i => method.extractInformation (solved i)
    refine ⟨information, fun _ => rfl, ?_⟩
    let numericalFlux : ℤ → (Component → ℝ) :=
      fun i => method.numericalFluxFromInformation (information i)
    refine ⟨numericalFlux, fun _ => rfl, method.consistent_on_constant_states, ?_⟩
    exact ⟨riemannFiniteVolumeUpdate grid timeStep cellAverages numericalFlux, fun _ => rfl⟩

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

/-- LeVeque Chapter 1, printed page 5 (raw PDF page 27), following equation
(1.11): the interface workflow on the explicit solver domain, using rectangle
conservation for the potentially discontinuous local Riemann solutions. The
averages are actual normalized cell integrals, and left/right order is explicit. -/
theorem leveque01_rectangleRiemannInterfaceFlux_sourceContract
    {m : ℕ} (hm : 0 < m) {Information : Type*}
    (law : OneDimensionalHyperbolicConservationLaw Fin m)
    (grid : OneDimensionalFiniteVolumeGrid)
    (initialState : ℝ → (Fin m → ℝ))
    (hintegrable : ∀ i, IntervalIntegrable initialState volume
      (grid.cellLeft i) (grid.cellRight i))
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (hdomain : ∀ i, method.domain
      (adjacentCellRiemannProblem law (finiteVolumeCellAverageOn grid initialState) i))
    (timeStep : ℝ) (htimeStep : 0 < timeStep) :
    0 < m ∧ 0 < timeStep ∧
    ∃ cellAverages : ℤ → (Fin m → ℝ),
      (∀ i, IsOneDimensionalCellAverage initialState
        (grid.cellLeft i) (grid.cellRight i) (cellAverages i)) ∧
      (∀ i, grid.cellRight (i - 1) = grid.cellLeft i) ∧
      (∀ i, method.domain (adjacentCellRiemannProblem law cellAverages i)) ∧
      ∃ solved : (i : ℤ) → CertifiedRectangleRiemannSolution law
          (adjacentCellRiemannProblem law cellAverages i),
        (∀ i, IsRiemannData (fun x => (solved i).solution x 0)
          (cellAverages (i - 1)) (cellAverages i)) ∧
        (∀ i, IsRectangleConservationLawSolution (solved i).solution law.physicalFlux) ∧
        ∃ information : ℤ → Information,
          (∀ i, information i = method.extractInformation (solved i)) ∧
          ∃ numericalFlux : ℤ → (Fin m → ℝ),
            (∀ i, numericalFlux i = method.numericalFluxFromInformation (information i)) ∧
            (∀ state, method.numericalFluxFromInformation
              (method.extractInformation
                (method.solve
                  ({ leftState := state, rightState := state } : HyperbolicRiemannProblem law)
                  (method.constants_in_domain state))) = law.physicalFlux state) ∧
            ∃ updatedCellAverages : ℤ → (Fin m → ℝ),
              ∀ i, updatedCellAverages i =
                riemannFiniteVolumeUpdate grid timeStep cellAverages numericalFlux i := by
  exact ⟨hm, htimeStep, rectangleRiemannInterface_finiteVolumeStep
    law grid initialState hintegrable method hdomain timeStep⟩

#check IsRectangleHyperbolicRiemannSolution
#print axioms IsRectangleHyperbolicRiemannSolution
#check CertifiedRectangleRiemannSolution
#print axioms CertifiedRectangleRiemannSolution
#check RectangleRiemannInterfaceFluxMethod
#print axioms RectangleRiemannInterfaceFluxMethod
#check adjacentCellRectangleRiemannInformation
#print axioms adjacentCellRectangleRiemannInformation
#check rectangleRiemannInterfaceFlux
#print axioms rectangleRiemannInterfaceFlux
#check rectangleRiemannInterface_finiteVolumeStep
#print axioms rectangleRiemannInterface_finiteVolumeStep
#check linearHyperbolicConservationLaw
#print axioms linearHyperbolicConservationLaw
#check linearRiemannSolution_constant
#print axioms linearRiemannSolution_constant
#check certifiedLinearRectangleRiemannSolution
#print axioms certifiedLinearRectangleRiemannSolution
#check linearRectangleRiemannInterfaceFluxMethod
#print axioms linearRectangleRiemannInterfaceFluxMethod
#check linearRectangleRiemannInterfaceFluxMethod_exists_total
#print axioms linearRectangleRiemannInterfaceFluxMethod_exists_total
#check linearRectangleRiemannInterfaceFluxMethod_nonempty
#print axioms linearRectangleRiemannInterfaceFluxMethod_nonempty
#check linearRectangleRiemannInterfaceFluxMethod_information
#print axioms linearRectangleRiemannInterfaceFluxMethod_information
#check leveque01_rectangleRiemannInterfaceFlux_sourceContract
#print axioms leveque01_rectangleRiemannInterfaceFlux_sourceContract

end NumStability
