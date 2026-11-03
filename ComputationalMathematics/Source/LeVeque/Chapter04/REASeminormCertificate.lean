/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAGeneralPrescribedCertificate
import Mathlib.Analysis.Seminorm

/-!
# REA certificates measured directly by prescribed raw-field seminorms

The actual measured data are the domain, measure, raw submodule, real seminorm
and its exact AE-zero kernel. No auxiliary quotient carrier appears in this
recipe. Generic IVP semantics are unchanged: the selected relation supplies its
own initial-data/solution concept, which may use a weak or entropy trace.
Arbitrary relations and abstract compatible presentations remain templates,
not automatically authenticated physical equations. All policies precede the
execution endpoint; the generic definition asserts no universal solver.
-/

namespace NumStability.REA.SeminormRecipe
open MeasureTheory

structure Descriptor (α : Type) [MeasurableSpace α] (d : ℕ) where
  domain : Set α
  domain_nonempty : domain.Nonempty
  measure : Measure domain
  measure_ne_zero : measure ≠ 0
  raw : Submodule ℝ (domain → State d)
  q : Seminorm ℝ raw
  kernel_ae_zero : ∀ e : raw, q e = 0 ↔ ∀ᵐ x ∂measure, e.val x = 0

/-- Literal raw membership, original representative and original seminorm. -/
def RawBound {α : Type} [MeasurableSpace α] {d : ℕ}
    (D : Descriptor α d) (f : α → State d) (budget : ℝ) : Prop :=
  0 ≤ budget ∧ ∃ e : D.raw, (∀ x : D.domain, e.val x = f x) ∧ D.q e ≤ budget

structure ReferencePolicy (m : ℕ) where
  descriptor : Input m → Descriptor ℝ m
  budget : Input m → ℝ

/-- SAME supplied IVP concept; no additional universal pointwise t=0 guard. -/
def ReferenceCertificate {m : ℕ} (problem : Leveque04ForwardIVP m)
    (P : ReferencePolicy m) (i : Input m) (endpoint : Profile m) : Prop :=
  ∃ reference : Field m,
    problem i.initial i.step reference ∧
    RawBound (P.descriptor i) (fun x => endpoint x - reference x i.step) (P.budget i)

structure ResidualPolicy {m : ℕ} {problem : Leveque04ForwardIVP m}
    (P : ResidualPresentation problem) (J : Input m → Type) where
  tests_nonempty : ∀ i, Nonempty (J i)
  descriptor : ∀ (i : Input m) (_j : J i),
    letI := P.indexMeasurableSpace i
    Descriptor (P.Index i) P.components
  budget : ∀ i : Input m, J i → ℝ

/-- The same actual presentation field, defect, endpoint and initial-data law. -/
def ResidualCertificate {m : ℕ} {problem : Leveque04ForwardIVP m}
    (P : ResidualPresentation problem) {J : Input m → Type}
    (M : ResidualPolicy P J) (i : Input m) (endpoint : Profile m) : Prop :=
  letI := P.indexMeasurableSpace i
  ∃ w : P.Path i,
    (∀ x, P.field i w x i.step = endpoint x) ∧
    ∀ j : J i, RawBound (M.descriptor i j) (P.defect i w) (M.budget i j)

inductive Criterion {m : ℕ} (problem : Leveque04ForwardIVP m) : Type 1 where
  | reference (policy : ReferencePolicy m) : Criterion problem
  | residual (presentation : ResidualPresentation problem)
      {J : Input m → Type} (policy : ResidualPolicy presentation J) : Criterion problem

def Certificate {m : ℕ} {problem : Leveque04ForwardIVP m}
    (criterion : Criterion problem) (i : Input m) (endpoint : Profile m) : Prop :=
  match criterion with
  | .reference policy => ReferenceCertificate problem policy i endpoint
  | .residual presentation policy => ResidualCertificate presentation policy i endpoint

structure Procedure {m : ℕ} (problem : Leveque04ForwardIVP m) where
  criterion : Criterion problem
  execute : Input m → Option (Profile m)

/-- The exact alternative retains precisely the SAME supplied IVP semantics. -/
def Endpoint {m : ℕ} (problem : Leveque04ForwardIVP m)
    (method : Option (Procedure problem)) (i : Input m) (endpoint : Profile m) : Prop :=
  (∃ evolved : Field m,
    problem i.initial i.step evolved ∧ ∀ x, endpoint x = evolved x i.step) ∨
  (∃ procedure : Procedure problem,
    method = some procedure ∧ procedure.execute i = some endpoint ∧
      Certificate procedure.criterion i endpoint)

def Stage {m : ℕ} (problem : Leveque04ForwardIVP m)
    (method : Option (Procedure problem)) (grid : OneDimensionalFiniteVolumeGrid)
    (old : ℤ → State m) (step : ℝ) (next : ℤ → State m) : Prop :=
  0 < m ∧ ∃ hstep : 0 < step,
    Leveque04REAGridCoversLine grid ∧
    ∃ reconstructed endpoint : Profile m,
      Leveque04REAReconstruction grid old reconstructed ∧
      (∀ j, IntervalIntegrable endpoint volume (grid.cellLeft j) (grid.cellRight j)) ∧
      Endpoint problem method ⟨grid, reconstructed, step, hstep⟩ endpoint ∧
      ∀ j, next j = oneDimensionalCellAverage endpoint (grid.cellLeft j) (grid.cellRight j)

/-- Proof-free generic recipe with unchanged physical operations and quantifiers. -/
def GenericRecipeTarget : Prop :=
  ∀ (m : ℕ) (problem : Leveque04ForwardIVP m)
    (method : Option (Procedure problem)) (grid : OneDimensionalFiniteVolumeGrid)
    (old : ℤ → State m) (step : ℝ) (next : ℤ → State m),
    Stage problem method grid old step next ↔
      0 < m ∧ ∃ hstep : 0 < step,
        Leveque04REAGridCoversLine grid ∧
        ∃ reconstructed endpoint : Profile m,
          ((∀ j component, ∃ polynomial : Polynomial ℝ,
            ∀ x ∈ Set.Ioo (grid.cellLeft j) (grid.cellRight j),
              reconstructed x component = polynomial.eval x) ∧
            (∀ j, IntervalIntegrable reconstructed volume
              (grid.cellLeft j) (grid.cellRight j)) ∧
            ∀ j, oneDimensionalCellAverage reconstructed
              (grid.cellLeft j) (grid.cellRight j) = old j) ∧
          (∀ j, IntervalIntegrable endpoint volume
            (grid.cellLeft j) (grid.cellRight j)) ∧
          ((∃ evolved : Field m, problem reconstructed step evolved ∧
            ∀ x, endpoint x = evolved x step) ∨
            ∃ procedure : Procedure problem,
              method = some procedure ∧
              procedure.execute ⟨grid, reconstructed, step, hstep⟩ = some endpoint ∧
              Certificate procedure.criterion ⟨grid, reconstructed, step, hstep⟩ endpoint) ∧
          ∀ j, next j = oneDimensionalCellAverage endpoint
            (grid.cellLeft j) (grid.cellRight j)

/-- The identical actual Taylor execution, with a direct prescribed criterion. -/
noncomputable def ScalarTaylorProcedure (speed : ℝ)
    (criterion : Criterion (ConservativeIVP (fun state : State 1 => speed • state))) :
    Procedure (ConservativeIVP (fun state : State 1 => speed • state)) where
  criterion := criterion
  execute := fun i => some (fun x component => i.initial x component -
    speed * i.step * deriv (fun y => i.initial y component) x)

end NumStability.REA.SeminormRecipe
