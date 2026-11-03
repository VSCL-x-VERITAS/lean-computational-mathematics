/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAStageDefinition
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.QuadraticTaylorApproximation

/-!
# A prescribed-certificate interpretation of the REA recipe

The user-selected convention requires execution and a prescribed equation-related
certificate. This two-mode family is a coordinator realization of that convention,
not a uniquely printed or exhaustive catalogue. Arbitrary IVP relations retain
only their template meaning. No criterion is an unrestricted validity predicate.
-/

namespace NumStability

open MeasureTheory

/-- The actual scalar advection forward problem, using the same speed in its flux. -/
def leveque04_scalarAdvectionForwardIVP (speed : ℝ) : Leveque04ForwardIVP 1 :=
  fun initial horizon evolved =>
    (∀ x, evolved x 0 = initial x) ∧
    ∀ left right : ℝ,
      LocalConservationLaw.RectangleReferenceOn evolved (fun state => speed • state)
        left right horizon

/-- The one-state matrix corresponding to the same scalar advection speed. -/
def leveque04_scalarAdvectionMatrix (speed : ℝ) : Matrix (Fin 1) (Fin 1) ℝ :=
  fun _ _ => speed

/-- Closed, substantive criterion choices. Budgets depend on inputs, never the output.
Reference mode uses the whole physical line and the finite-state sup norm.
The residual constructor is indexed by the actual same-speed scalar IVP body. -/
inductive Leveque04PrescribedREACriterion :
    (m : ℕ) → Leveque04ForwardIVP m → Type where
  | reference {m : ℕ} (problem : Leveque04ForwardIVP m)
      (errorBudget : OneDimensionalFiniteVolumeGrid → (ℝ → Fin m → ℝ) → ℝ → ℝ) :
      Leveque04PrescribedREACriterion m problem
  | scalarResidual (speed : ℝ)
      (residualBudget : OneDimensionalFiniteVolumeGrid →
        (ℝ → Fin 1 → ℝ) → ℝ → ℝ → ℝ) :
      Leveque04PrescribedREACriterion 1 (leveque04_scalarAdvectionForwardIVP speed)

/-- The actual mathematical certificate, with no free predicate alternative.
The residual mode has no exact-reference-existence conjunct. Its path has C1
regularity on the forward strip and actual derivatives at its points. -/
def Leveque04REAPrescribedCertificate :
    {m : ℕ} → {problem : Leveque04ForwardIVP m} →
    Leveque04PrescribedREACriterion m problem →
    OneDimensionalFiniteVolumeGrid → (ℝ → Fin m → ℝ) → ℝ → (ℝ → Fin m → ℝ) → Prop
  | m, _, .reference problem errorBudget, grid, reconstructed, timeStep, endpoint =>
      0 ≤ errorBudget grid reconstructed timeStep ∧
      ∃ reference : ℝ → ℝ → Fin m → ℝ,
        problem reconstructed timeStep reference ∧
        (∀ x, reference x 0 = reconstructed x) ∧
        ∀ x, ‖endpoint x - reference x timeStep‖ ≤ errorBudget grid reconstructed timeStep
  | _, _, .scalarResidual speed residualBudget, grid, reconstructed, timeStep, endpoint =>
      IntervalIntegrable (residualBudget grid reconstructed timeStep) volume 0 timeStep ∧
      (∀ t ∈ Set.Icc 0 timeStep, 0 ≤ residualBudget grid reconstructed timeStep t) ∧
      ∃ path : ℝ → ℝ → ℝ,
        ContDiffOn ℝ 1 (Function.uncurry path) (Set.univ ×ˢ Set.Icc 0 timeStep) ∧
        (∀ x, path x 0 = reconstructed x 0) ∧
        (∀ x, path x timeStep = endpoint x 0) ∧
        ∀ x, ∀ t ∈ Set.Icc 0 timeStep,
          HasDerivAt (fun τ => path x τ) (deriv (fun τ => path x τ) t) t ∧
          HasDerivAt (fun y => path y t) (deriv (fun y => path y t) x) x ∧
          |deriv (fun τ => path x τ) t + speed * deriv (fun y => path y t) x| ≤
            residualBudget grid reconstructed timeStep t

/-- The procedure and its criterion/budget policy are fixed before execution. -/
structure Leveque04PrescribedREAProcedure
    {m : ℕ} (problem : Leveque04ForwardIVP m) where
  criterion : Leveque04PrescribedREACriterion m problem
  execute : OneDimensionalFiniteVolumeGrid → (ℝ → Fin m → ℝ) →
    ℝ → Option (ℝ → Fin m → ℝ)

/-- Exact fixed-IVP evolution, or actual execution AND its prescribed certificate. -/
def Leveque04CertifiedREAEndpointFor
    {m : ℕ} (problem : Leveque04ForwardIVP m)
    (approximation : Option (Leveque04PrescribedREAProcedure problem))
    (grid : OneDimensionalFiniteVolumeGrid)
    (reconstructed : ℝ → Fin m → ℝ) (timeStep : ℝ)
    (endpoint : ℝ → Fin m → ℝ) : Prop :=
  (∃ evolved : ℝ → ℝ → Fin m → ℝ,
    problem reconstructed timeStep evolved ∧ ∀ x, endpoint x = evolved x timeStep) ∨
  (∃ procedure : Leveque04PrescribedREAProcedure problem,
    approximation = some procedure ∧
    procedure.execute grid reconstructed timeStep = some endpoint ∧
    Leveque04REAPrescribedCertificate procedure.criterion grid reconstructed timeStep endpoint)

/-- The same common reconstruction/averaging recipe with the qualified endpoint rule. -/
def Leveque04CertifiedREAStageFor
    {m : ℕ} (problem : Leveque04ForwardIVP m)
    (approximation : Option (Leveque04PrescribedREAProcedure problem))
    (grid : OneDimensionalFiniteVolumeGrid) (old : ℤ → Fin m → ℝ)
    (timeStep : ℝ) (next : ℤ → Fin m → ℝ) : Prop :=
  0 < m ∧ 0 < timeStep ∧ Leveque04REAGridCoversLine grid ∧
  ∃ reconstructed endpoint : ℝ → Fin m → ℝ,
    Leveque04REAReconstruction grid old reconstructed ∧
    (∀ i, IntervalIntegrable endpoint volume (grid.cellLeft i) (grid.cellRight i)) ∧
    Leveque04CertifiedREAEndpointFor problem approximation grid reconstructed timeStep endpoint ∧
    ∀ i, next i = oneDimensionalCellAverage endpoint (grid.cellLeft i) (grid.cellRight i)

/-- The actual same-speed time-Taylor map; a returned value alone is not certification. -/
noncomputable def leveque04_scalarTaylorProcedure (speed curvature : ℝ) :
    Leveque04PrescribedREAProcedure (leveque04_scalarAdvectionForwardIVP speed) :=
  { criterion := .scalarResidual speed
      (fun _ _ _ t => AdvectionTaylor.residualBudget speed curvature t)
    execute := fun _ reconstructed timeStep =>
      some (fun x component => reconstructed x component - speed * timeStep *
        deriv (fun y => reconstructed y component) x) }

/-- A genuine polynomial reconstruction, embedded in the one-state physical model. -/
def leveque04_quadraticREAReconstruction (curvature linear constant : ℝ) : ℝ → Fin 1 → ℝ :=
  fun x _ => AdvectionTaylor.quadraticProfile curvature linear constant x

/-- The actual Taylor endpoint in that same one-state model. -/
def leveque04_quadraticREAEndpoint
    (speed curvature linear constant timeStep : ℝ) : ℝ → Fin 1 → ℝ :=
  fun x _ => AdvectionTaylor.quadraticTaylorPath speed curvature linear constant x timeStep

/-- The actual transported reference, not an unconstrained reference field. -/
def leveque04_quadraticREAReference
    (speed curvature linear constant : ℝ) : ℝ → ℝ → Fin 1 → ℝ :=
  fun x t _ => travelingWave (AdvectionTaylor.quadraticProfile curvature linear constant) speed x t

/-- Stored old data are the actual means of this reconstruction on the selected cells. -/
noncomputable def leveque04_quadraticREAOldMeans
    (curvature linear constant : ℝ) (grid : OneDimensionalFiniteVolumeGrid) : ℤ → Fin 1 → ℝ :=
  fun i => oneDimensionalCellAverage (leveque04_quadraticREAReconstruction curvature linear constant)
    (grid.cellLeft i) (grid.cellRight i)

/-- New data are the actual means of the certified approximate endpoint. -/
noncomputable def leveque04_quadraticREANextMeans
    (speed curvature linear constant timeStep : ℝ)
    (grid : OneDimensionalFiniteVolumeGrid) : ℤ → Fin 1 → ℝ :=
  fun i => oneDimensionalCellAverage (leveque04_quadraticREAEndpoint speed curvature linear constant timeStep)
    (grid.cellLeft i) (grid.cellRight i)

end NumStability
