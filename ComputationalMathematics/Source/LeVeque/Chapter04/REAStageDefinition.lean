/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference
import Mathlib.Algebra.Polynomial.Eval.Defs

/-!
# An IVP-relative reconstruct–evolve–average template

The template is relative to one fixed forward initial-value relation. It does
not assert that every relation is a hyperbolic equation or a valid solution
concept. Exact realizations must provide that relation's certificate.

A declared approximate procedure is a nominal structure indexed by the SAME
relation. Its partial endpoint execution supplies no accuracy or PDE-solution
claim, and requires no exact reference solution. A relation or procedure can
be physically inappropriate; the template never certifies otherwise.

The separate constant-linear relation below has an explicit physical body:
initial data and forward rectangle conservation for the same matrix flux.
No separate unused physical-law field or arbitrary EvolutionValid is stored.
-/

namespace NumStability

open MeasureTheory

/-- The type of a declared forward IVP relation on initial field, horizon and
actual space-time field. This type alone asserts no PDE or hyperbolicity. -/
abbrev Leveque04ForwardIVP (m : ℕ) :=
  (ℝ → Fin m → ℝ) → ℝ → (ℝ → ℝ → Fin m → ℝ) → Prop

/-- An actual partial endpoint procedure declared for one fixed IVP relation.
The nominal relation index is retained even though execution itself is not a
certificate that the output solves the IVP or is an accurate approximation. -/
structure Leveque04DeclaredApproximateProcedure
    {m : ℕ} (problem : Leveque04ForwardIVP m) where
  /-- The declared approximate evolution, which may report execution failure. -/
  execute : OneDimensionalFiniteVolumeGrid → (ℝ → Fin m → ℝ) →
    ℝ → Option (ℝ → Fin m → ℝ)

/-- The actual cells cover the whole physical line, including their interfaces.
Positivity and adjacency are already fields of the grid. -/
def Leveque04REAGridCoversLine (grid : OneDimensionalFiniteVolumeGrid) : Prop :=
  ∀ x : ℝ, ∃ i : ℤ, x ∈ Set.Icc (grid.cellLeft i) (grid.cellRight i)

/-- Actual componentwise polynomial reconstruction, integrable on every cell
and with normalized cell integrals equal to the stored old states. -/
def Leveque04REAReconstruction
    {m : ℕ} (grid : OneDimensionalFiniteVolumeGrid)
    (old : ℤ → Fin m → ℝ) (reconstructed : ℝ → Fin m → ℝ) : Prop :=
  (∀ i component, ∃ polynomial : Polynomial ℝ,
    ∀ x ∈ Set.Ioo (grid.cellLeft i) (grid.cellRight i),
      reconstructed x component = polynomial.eval x) ∧
  (∀ i, IntervalIntegrable reconstructed volume (grid.cellLeft i) (grid.cellRight i)) ∧
  ∀ i, oneDimensionalCellAverage reconstructed (grid.cellLeft i) (grid.cellRight i) = old i

/-- Exact certification of the fixed IVP, or execution of the already fixed
optional approximate procedure. A procedure cannot be selected after seeing
the desired endpoint. The approximate alternative supplies execution only. -/
def Leveque04REAEndpointFor
    {m : ℕ} (problem : Leveque04ForwardIVP m)
    (approximation : Option (Leveque04DeclaredApproximateProcedure problem))
    (grid : OneDimensionalFiniteVolumeGrid)
    (reconstructed : ℝ → Fin m → ℝ) (timeStep : ℝ)
    (endpoint : ℝ → Fin m → ℝ) : Prop :=
  (∃ evolved : ℝ → ℝ → Fin m → ℝ,
    problem reconstructed timeStep evolved ∧ ∀ x, endpoint x = evolved x timeStep) ∨
  (∃ procedure : Leveque04DeclaredApproximateProcedure problem,
    approximation = some procedure ∧
      procedure.execute grid reconstructed timeStep = some endpoint)

/-- The general source recipe as a relation on supplied stage data. It neither
asserts stage existence for every problem nor labels every problem hyperbolic. -/
def Leveque04REAStageFor
    {m : ℕ} (problem : Leveque04ForwardIVP m)
    (approximation : Option (Leveque04DeclaredApproximateProcedure problem))
    (grid : OneDimensionalFiniteVolumeGrid) (old : ℤ → Fin m → ℝ)
    (timeStep : ℝ) (next : ℤ → Fin m → ℝ) : Prop :=
  0 < m ∧ 0 < timeStep ∧ Leveque04REAGridCoversLine grid ∧
  ∃ reconstructed endpoint : ℝ → Fin m → ℝ,
    Leveque04REAReconstruction grid old reconstructed ∧
    (∀ i, IntervalIntegrable endpoint volume (grid.cellLeft i) (grid.cellRight i)) ∧
    Leveque04REAEndpointFor problem approximation grid reconstructed timeStep endpoint ∧
    ∀ i, next i =
      oneDimensionalCellAverage endpoint (grid.cellLeft i) (grid.cellRight i)

/-- The actual forward IVP relation for one specified constant matrix: the
same matrix supplies the physical flux in every forward subrectangle, and
the same reconstructed field supplies the prescribed initial data. -/
def leveque04_linearREAForwardIVP
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ) : Leveque04ForwardIVP m :=
  fun initial horizon evolved =>
    (∀ x, evolved x 0 = initial x) ∧
    ∀ left right : ℝ,
      LocalConservationLaw.RectangleReferenceOn
        evolved coefficient.mulVec left right horizon

end NumStability
