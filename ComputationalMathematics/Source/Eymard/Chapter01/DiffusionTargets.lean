/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.PlanarGeometry
import ComputationalMathematics.Analysis.FiniteVolume.RectangularDiffusion
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import Mathlib.MeasureTheory.Integral.Bochner.Set

/-!
# Diffusion Targets

Equation (1.9) on every applicable local common edge, in either orientation.
The unknowns are arbitrary reals. No exact solution, smoothness, orthogonality,
whole-side conformity or global mesh is needed for this definition.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false
noncomputable section
open MeasureTheory

namespace NumStability.Eymard.Chapter01

open NumStability.FiniteVolume
open NumStability.FiniteVolume.Planar

/-- Open unit square in the canonical Euclidean plane. -/
def diffusionUnitSquare : Set Point := {x | ∀ i, 0 < x i ∧ x i < 1}

/-- Equation (1.9) on every applicable local common edge, in either orientation.
The unknowns are arbitrary reals. No exact solution, smoothness, orthogonality,
whole-side conformity or global mesh is needed for this definition. -/
def interiorDiffusionFluxTarget : Prop :=
  ∀ (K L : Rectangle2) (σ : Segment),
    K.region ⊆ diffusionUnitSquare → L.region ⊆ diffusionUnitSquare →
    IsInteriorRectangleFace K L σ → ∀ uK uL : ℝ,
      rectangleInteriorFlux K L σ uK uL =
        -(dist σ.a σ.b / dist K.center L.center) * (uL - uK)

/-- Equation (1.10), with its positive sign and the homogeneous boundary value.
The selected reading is distance to this particular face. Raw PDF39 identifies
this with its boundary d_sigma only when the perpendicular foot belongs to the
face; see HasRectangleBoundaryFoot. The broad side-piece definition does not
silently assert that extra admissibility or the source's orthogonality claim. -/
def boundaryDiffusionFluxTarget : Prop :=
  ∀ (K : Rectangle2) (σ : Segment), K.region ⊆ diffusionUnitSquare →
    σ.carrier ⊆ frontier diffusionUnitSquare →
    IsBoundaryRectangleFace K σ → ∀ uK : ℝ,
      rectangleBoundaryFlux K σ uK =
        (dist σ.a σ.b / Metric.infDist K.center σ.carrier) * uK

/-- Literal global-boundary reading of the ambiguous Chapter 1 phrase.
Kept separately from the selected face-distance interpretation; these functions
are generally different. Neither reading is asserted to be an exact PDE flux. -/
def boundaryDiffusionFluxGlobalBoundaryReading (K : Rectangle2) (σ : Segment)
    (uK : ℝ) : ℝ :=
  (σ.length / Metric.infDist K.center (frontier diffusionUnitSquare)) * uK

/-- Source correspondence for complete assembly. Local formula targets above
do not require this global context. Faces may be side pieces, and only the
per-cell `cellFaces` are finite; no global `Fintype` or conformity is required. -/
structure Example12DiffusionMesh (Cell Face : Type*) [DecidableEq Face] where
  /-- Underlying rectangular cell-and-face data. -/
  data : RectangularDiffusionData Cell Face
  contained : ∀ K, (data.rectangle K).region ⊆ diffusionUnitSquare
  disjoint : ∀ K L, K ≠ L →
    Disjoint (data.rectangle K).region (data.rectangle L).region
  closure_cover : closure diffusionUnitSquare = ⋃ K, closure (data.rectangle K).region
  faces_cover : ∀ K, frontier (data.rectangle K).region =
    ⋃ σ ∈ data.cellFaces K, (data.edge σ).carrier
  face_interiors_disjoint : ∀ K σ τ, σ ∈ data.cellFaces K →
    τ ∈ data.cellFaces K → σ ≠ τ →
      Disjoint (openSegment ℝ (data.edge σ).a (data.edge σ).b)
        (openSegment ℝ (data.edge τ).a (data.edge τ).b)
  interior_faces : ∀ K σ L, σ ∈ data.cellFaces K → data.neighbour K σ = some L →
    K ≠ L ∧ IsInteriorRectangleFace (data.rectangle K) (data.rectangle L) (data.edge σ) ∧
      σ ∈ data.cellFaces L ∧ data.neighbour L σ = some K ∧
      closure (data.rectangle K).region ∩ closure (data.rectangle L).region =
        (data.edge σ).carrier
  boundary_faces : ∀ K σ, σ ∈ data.cellFaces K → data.neighbour K σ = none →
    IsBoundaryRectangleFace (data.rectangle K) (data.edge σ) ∧
      (data.edge σ).carrier ⊆ frontier diffusionUnitSquare
  interior_incidence : ∀ K σ L J, σ ∈ data.cellFaces K →
    data.neighbour K σ = some L → σ ∈ data.cellFaces J → J = K ∨ J = L
  boundary_incidence : ∀ K σ J, σ ∈ data.cellFaces K →
    data.neighbour K σ = none → σ ∈ data.cellFaces J → J = K

/-- Additional boundary applicability for comparison with raw PDF39's
admissible-mesh distance. The generic conditional scheme below remains defined
on side pieces; no later admissibility, orthogonality or consistency theorem is
inferred solely from rectangular cell shape. -/
def HasLaterAdmissibleDiffusionBoundaryFeet {Cell Face : Type*}
    [DecidableEq Face] (M : Example12DiffusionMesh Cell Face) : Prop :=
  ∀ K σ, σ ∈ M.data.cellFaces K → M.data.neighbour K σ = none →
    HasRectangleBoundaryFoot (M.data.rectangle K) (M.data.edge σ)

/-- The actual source field and supplied approximate-mean data are fixed before
the unknowns. Applicability makes the exact mean below a genuine mean. No
quantitative approximation condition or equality with that mean is imposed. -/
structure DiffusionSourceData {Cell Face : Type*} [DecidableEq Face]
    (M : Example12DiffusionMesh Cell Face) where
  /-- Spatial source term in the diffusion balance. -/
  f : Point → ℝ
  mean_applicable : ∀ K,
    volume (M.data.rectangle K).region ≠ 0 ∧
    volume (M.data.rectangle K).region ≠ ⊤ ∧
    IntegrableOn f (M.data.rectangle K).region
  /-- Supplied cellwise source values. -/
  fMean : Cell → ℝ

/-- Mathematical referent of `fMean`, reusing the existing normalized integral.
The ambient field is used only on each actual cell; its outside values do not
enter this integral or the discrete equations. -/
def diffusionExactCellMean {Cell Face : Type*} [DecidableEq Face]
    {M : Example12DiffusionMesh Cell Face} (source : DiffusionSourceData M)
    (K : Cell) : ℝ :=
  NumStability.cellVolumeAverage volume (M.data.rectangle K).region source.f

/-- The supplied approximation's discrepancy, with no invented error bound.
This gives the actual source field a precise mathematical referent without
forcing the supplied approximate means to equal exact means. -/
def diffusionCellMeanDiscrepancy {Cell Face : Type*} [DecidableEq Face]
    {M : Example12DiffusionMesh Cell Face} (source : DiffusionSourceData M)
    (K : Cell) : ℝ :=
  source.fMean K - diffusionExactCellMean source K

/-- Complete printed equation (1.11), as a predicate on the unknown family.
Both (1.9) interior and (1.10) boundary cases occur in the finite cell sum.
This definition asserts no solver existence, uniqueness, consistency or exact
sampling property, and is not an implication from the exact balance (1.8). -/
def IsPrintedDiffusionScheme {Cell Face : Type*} [DecidableEq Face]
    (M : Example12DiffusionMesh Cell Face) (source : DiffusionSourceData M)
    (values : Cell → ℝ) : Prop :=
  ∀ K, (∑ σ ∈ M.data.cellFaces K, rectangularNumericalFlux M.data values K σ) =
    (M.data.rectangle K).area * source.fMean K

/-- Transparent proof-free target for the full conditional scheme definition,
including the literal interior and boundary expressions and positive RHS. -/
def diffusionSchemeTarget : Prop :=
  ∀ (Cell Face : Type*) [DecidableEq Face]
    (M : Example12DiffusionMesh Cell Face) (source : DiffusionSourceData M)
    (values : Cell → ℝ), IsPrintedDiffusionScheme M source values ↔
      ∀ K, (∑ σ ∈ M.data.cellFaces K,
        match M.data.neighbour K σ with
        | some L => -(dist (M.data.edge σ).a (M.data.edge σ).b /
            dist (M.data.rectangle K).center (M.data.rectangle L).center) *
              (values L - values K)
        | none => (dist (M.data.edge σ).a (M.data.edge σ).b /
            Metric.infDist (M.data.rectangle K).center (M.data.edge σ).carrier) * values K) =
          (volume (M.data.rectangle K).region).toReal * source.fMean K

end NumStability.Eymard.Chapter01
