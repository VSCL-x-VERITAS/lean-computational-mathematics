/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.InnerProductSpace.PiL2

/-!
# Coordinate balance laws

Pointwise balance predicates use only the scalar time and diagonal spatial
partials that occur in the equation. Fields are supplied on the ambient space;
an operative region restricts where the predicates are required. These are
ambient two-sided slice derivatives, with no assertion about weak solutions,
boundary traces, one-sided derivatives, or independence of ambient extensions.
-/

set_option autoImplicit false

open scoped BigOperators

noncomputable section

namespace NumStability.FiniteVolume.CoordinateBalance

/-- Finite-dimensional real Euclidean coordinate space. -/
abbrev Point (d : ℕ) := EuclideanSpace ℝ (Fin d)

/-- Replace exactly the `i`th spatial coordinate. -/
def replace {d : ℕ} (x : Point d) (i : Fin d) (s : ℝ) : Point d :=
  WithLp.toLp 2 (Function.update (fun j => x j) i s)

/-- Derivative in time of the scalar field, with the spatial point fixed. -/
def timePartial {d : ℕ} (q : Point d → ℝ → ℝ) (x : Point d) (t : ℝ) : ℝ :=
  deriv (fun τ => q x τ) t

/-- One-dimensional derivative along a selected spatial coordinate, with time fixed. -/
def spatialPartial {d : ℕ} (q : Point d → ℝ → ℝ)
    (i : Fin d) (x : Point d) (t : ℝ) : ℝ :=
  deriv (fun s => q (replace x i s) t) (x i)

/-- Sum of the spatial coordinate derivatives of the corresponding vector components. -/
def divergence {d : ℕ} (F : Point d → ℝ → Point d) (x : Point d) (t : ℝ) : ℝ :=
  ∑ i, spatialPartial (fun x t => F x t i) i x t

/-- Exactly the scalar slice derivatives appearing in the local equation. -/
def PartialsExistAt {d : ℕ} (q : Point d → ℝ → ℝ)
    (F : Point d → ℝ → Point d) (x : Point d) (t : ℝ) : Prop :=
  DifferentiableAt ℝ (fun τ => q x τ) t ∧
    ∀ i, DifferentiableAt ℝ (fun s => F (replace x i s) t i) (x i)

/-- Applicability is part of the law; totalized derivative values alone do not
make a nondifferentiable field a solution. -/
def LocalLawAt {d : ℕ} (q : Point d → ℝ → ℝ)
    (F : Point d → ℝ → Point d) (f : Point d → ℝ → ℝ)
    (x : Point d) (t : ℝ) : Prop :=
  PartialsExistAt q F x t ∧ timePartial q x t + divergence F x t = f x t

/-- Pointwise local balance of the conserved density, flux divergence and source on a space-time
set. -/
def LocalLawOn {d : ℕ} (R : Set (Point d × ℝ)) (q : Point d → ℝ → ℝ)
    (F : Point d → ℝ → Point d) (f : Point d → ℝ → ℝ) : Prop :=
  ∀ x t, (x, t) ∈ R → LocalLawAt q F f x t

/-- A finite family of scalar equations. Equation indices are independent of
spatial indices; a one-dimensional three-equation system has `d = 1, n = 3`.
This support definition does not impose a relation between these dimensions. -/
def SystemLocalLawOn {d n : ℕ} (R : Set (Point d × ℝ))
    (q : Point d → ℝ → Fin n → ℝ) (F : Point d → ℝ → Fin n → Point d)
    (f : Point d → ℝ → Fin n → ℝ) : Prop :=
  ∀ a, LocalLawOn R (fun x t => q x t a) (fun x t => F x t a) (fun x t => f x t a)

/-- Physical constitutive data may use the unknown, its spatial derivatives,
or both. These functions are prescribed data, not differential operators. -/
inductive FluxLaw (d : ℕ) (V : Type*) where
  | value : (Point d → ℝ → V → Point d) → FluxLaw d V
  | gradient : (Point d → ℝ → (Fin d → V) → Point d) → FluxLaw d V
  | valueGradient : (Point d → ℝ → V → (Fin d → V) → Point d) → FluxLaw d V

/-- Supplied constitutive maps for the conserved density, vector flux and source. -/
structure TypicalConstitutiveData (d : ℕ) (V : Type*) where
  /-- Constitutive conserved-density map evaluated at position, time and state. -/
  qbar : Point d → ℝ → V → ℝ
  /-- State-dependent constitutive vector flux law. -/
  flux : FluxLaw d V
  /-- Constitutive source map evaluated at position, time and state. -/
  source : Point d → ℝ → V → ℝ

variable {V : Type*} [NormedAddCommGroup V] [NormedSpace ℝ V]

/-- Spatial coordinate derivatives, with values in the unknown's space.
For scalar unknowns this is the coordinate-gradient representation; for finite
vector unknowns its two indices are spatial direction and unknown component.
No identification with a joint Frechet derivative is asserted here. -/
def spatialJacobian {d : ℕ} (u : Point d → ℝ → V)
    (x : Point d) (t : ℝ) : Fin d → V :=
  fun i => deriv (fun s => u (replace x i s) t) (x i)

/-- Applicability condition for the coordinate Jacobian identities at the selected point and time. -/
def JacobianApplicableAt {d : ℕ} (u : Point d → ℝ → V)
    (x : Point d) (t : ℝ) : Prop :=
  ∀ i, DifferentiableAt ℝ (fun s => u (replace x i s) t) (x i)

/-- Evaluate the constitutive flux along the supplied state field. -/
def evaluateFlux {d : ℕ} (Φ : FluxLaw d V) (u : Point d → ℝ → V)
    (x : Point d) (t : ℝ) : Point d :=
  match Φ with
  | .value g => g x t (u x t)
  | .gradient g => g x t (spatialJacobian u x t)
  | .valueGradient g => g x t (u x t) (spatialJacobian u x t)

/-- Value-only fluxes impose no differentiability requirement on `u` itself. -/
def FluxApplicableAt {d : ℕ} (Φ : FluxLaw d V) (u : Point d → ℝ → V)
    (x : Point d) (t : ℝ) : Prop :=
  match Φ with
  | .value _ => True
  | .gradient _ => JacobianApplicableAt u x t
  | .valueGradient _ => JacobianApplicableAt u x t

/-- Compose the constitutive conserved density with the supplied state field. -/
def closedQ {d : ℕ} (C : TypicalConstitutiveData d V)
    (u : Point d → ℝ → V) (x : Point d) (t : ℝ) : ℝ :=
  C.qbar x t (u x t)

/-- Compose the constitutive source with the supplied state field. -/
def closedSource {d : ℕ} (C : TypicalConstitutiveData d V)
    (u : Point d → ℝ → V) (x : Point d) (t : ℝ) : ℝ :=
  C.source x t (u x t)

/-- An optional typical closure selected by supplied constitutive data.
This is neither an exhaustive classification of physical laws nor a claim that
such data or a satisfying unknown exist. It includes applicability of any used spatial
derivatives and the law for the actual composed conserved quantity and flux. -/
def ClosedLawOn {d : ℕ} (C : TypicalConstitutiveData d V)
    (R : Set (Point d × ℝ)) (u : Point d → ℝ → V) : Prop :=
  (∀ x t, (x, t) ∈ R → FluxApplicableAt C.flux u x t) ∧
    LocalLawOn R (closedQ C u) (evaluateFlux C.flux u) (closedSource C u)

/-- Characterization by derivatives of the actual composed fields. -/
def ClosureFormula {d : ℕ} (C : TypicalConstitutiveData d V)
    (R : Set (Point d × ℝ)) (u : Point d → ℝ → V) : Prop :=
  ClosedLawOn C R u ↔ ∀ x t, (x, t) ∈ R →
    FluxApplicableAt C.flux u x t ∧
      ∃ qt : ℝ, ∃ di : Fin d → ℝ,
        HasDerivAt (fun τ => C.qbar x τ (u x τ)) qt t ∧
        (∀ i, HasDerivAt (fun s => evaluateFlux C.flux u (replace x i s) t i)
          (di i) (x i)) ∧
        qt + (∑ i, di i) = C.source x t (u x t)

/-- Spatial coordinates precede the final time coordinate. -/
abbrev SpaceTimeCoordinate (d : ℕ) := Sum (Fin d) Unit
/-- Euclidean coordinates consisting of the spatial coordinates and one time coordinate. -/
abbrev SpaceTimePoint (d : ℕ) := EuclideanSpace ℝ (SpaceTimeCoordinate d)

/-- Pack the spatial point and time into the Euclidean space-time coordinates. -/
def pack {d : ℕ} (x : Point d) (t : ℝ) : SpaceTimePoint d :=
  WithLp.toLp 2 (Sum.elim (fun i => x i) (fun _ => t))

/-- Extract the spatial coordinates from a space-time point. -/
def spacePart {d : ℕ} (z : SpaceTimePoint d) : Point d :=
  WithLp.toLp 2 (fun i => z (Sum.inl i))

/-- Extract the time coordinate from a space-time point. -/
def timePart {d : ℕ} (z : SpaceTimePoint d) : ℝ := z (Sum.inr ())

/-- The explicit field `(F,q)`, with the positive time component `q`. -/
def spaceTimeFlux {d : ℕ} (q : Point d → ℝ → ℝ)
    (F : Point d → ℝ → Point d) (z : SpaceTimePoint d) : SpaceTimePoint d :=
  WithLp.toLp 2 (Sum.elim (fun i => F (spacePart z) (timePart z) i)
    (fun _ => q (spacePart z) (timePart z)))

/-- Replace one space-time coordinate by a supplied real value. -/
def replaceSpaceTime {d : ℕ} (z : SpaceTimePoint d)
    (j : SpaceTimeCoordinate d) (s : ℝ) : SpaceTimePoint d :=
  WithLp.toLp 2 (Function.update (fun k => z k) j s)

/-- Sum of all coordinate derivatives of the full space-time vector field. -/
def spaceTimeDivergence {d : ℕ} (G : SpaceTimePoint d → SpaceTimePoint d)
    (z : SpaceTimePoint d) : ℝ :=
  ∑ j, deriv (fun s => G (replaceSpaceTime z j s) j) (z j)

/-- Existence of the coordinate partial derivatives of a space-time vector field at a point. -/
def SpaceTimePartialsExistAt {d : ℕ} (G : SpaceTimePoint d → SpaceTimePoint d)
    (z : SpaceTimePoint d) : Prop :=
  ∀ j, DifferentiableAt ℝ (fun s => G (replaceSpaceTime z j s) j) (z j)

end NumStability.FiniteVolume.CoordinateBalance
