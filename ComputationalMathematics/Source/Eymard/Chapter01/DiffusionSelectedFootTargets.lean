/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.RectangleBoundaryFootTargets
import ComputationalMathematics.Source.Eymard.Chapter01.DiffusionTargets

/-!
# Diffusion Selected Foot Targets

Selected source realization of the existing numerical construction (1.10).
The producer remains rectangleBoundaryFlux with rectangleFaceDistance. Its
expression using the endpoint-computed foot requires the separate geometric
correspondence; merely unfolding the existing flux does not establish it.
The conclusion is a numerical formula, with no exact PDE-flux claim.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false
noncomputable section

namespace NumStability.Eymard.Chapter01
open NumStability.FiniteVolume NumStability.FiniteVolume.Planar

/-- Selected source realization of the existing numerical construction (1.10).
The producer remains rectangleBoundaryFlux with rectangleFaceDistance. Its
expression using the endpoint-computed foot requires the separate geometric
correspondence; merely unfolding the existing flux does not establish it.
The conclusion is a numerical formula, with no exact PDE-flux claim. -/
def boundaryDiffusionSelectedFootTarget : Prop :=
  ∀ (K : Rectangle2) (σ : Segment),
    K.region ⊆ diffusionUnitSquare →
    σ.carrier ⊆ frontier diffusionUnitSquare →
    HasRectangleBoundaryFoot K σ → ∀ uK : ℝ,
      rectangleBoundaryFlux K σ uK =
        (dist σ.a σ.b / dist K.center (segmentSupportingFoot σ K.center)) * uK

/-- Explicit source correspondence for each applicable incident boundary face.
The premise is exactly existing actual side/sidePoint membership, through
HasLaterAdmissibleDiffusionBoundaryFeet. No desired equality is an input. -/
def diffusionSelectedBoundaryCorrespondenceTarget : Prop :=
  ∀ (Cell Face : Type*) [DecidableEq Face]
    (M : Example12DiffusionMesh Cell Face),
    HasLaterAdmissibleDiffusionBoundaryFeet M →
      ∀ K σ, σ ∈ M.data.cellFaces K → M.data.neighbour K σ = none →
        let R := M.data.rectangle K
        let e := M.data.edge σ
        let z := segmentSupportingFoot e R.center
        z ∈ e.carrier ∧ z ∈ frontier diffusionUnitSquare ∧
        inner ℝ (R.center - z) (e.b - e.a) = 0 ∧
        0 < dist R.center z ∧
        rectangleFaceDistance R e = dist R.center z ∧
        dist R.center z = ‖R.center - z‖ ∧
        ∀ uK : ℝ, rectangleBoundaryFlux R e uK =
          (dist e.a e.b / dist R.center z) * uK

/-- Conditional full expansion of the existing scheme predicate, using exactly
the same computed foot as the local source realization. Every original mesh,
source and unknown binder, finite incident-face sum and both flux cases remain.
This separate target adds only explicit boundary-foot applicability; it does
not replace the preserved broad diffusionSchemeTarget. -/
def diffusionSchemeSelectedFootTarget : Prop :=
  ∀ (Cell Face : Type*) [DecidableEq Face]
    (M : Example12DiffusionMesh Cell Face),
    HasLaterAdmissibleDiffusionBoundaryFeet M →
      ∀ (source : DiffusionSourceData M) (values : Cell → ℝ),
        IsPrintedDiffusionScheme M source values ↔
          ∀ K, (∑ σ ∈ M.data.cellFaces K,
            match M.data.neighbour K σ with
            | some L => -(dist (M.data.edge σ).a (M.data.edge σ).b /
                dist (M.data.rectangle K).center (M.data.rectangle L).center) *
                  (values L - values K)
            | none => (dist (M.data.edge σ).a (M.data.edge σ).b /
                dist (M.data.rectangle K).center
                  (segmentSupportingFoot (M.data.edge σ) (M.data.rectangle K).center)) *
                    values K) =
              (MeasureTheory.volume (M.data.rectangle K).region).toReal * source.fMean K

end NumStability.Eymard.Chapter01
