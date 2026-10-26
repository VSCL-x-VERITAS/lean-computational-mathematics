/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.ForwardDifference
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic

/-!
# Flux Operator Polynomial Target

Owner-selected local polynomial illustration of the flux/operator distinction.
The construction is authored; its numbers are not those of printed Example 5.1.
The only supplied parameter is the positive central-cell width.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

noncomputable section

namespace NumStability.Eymard.Chapter01

/-- Owner-selected local polynomial illustration of the flux/operator distinction.
The construction is authored; its numbers are not those of printed Example 5.1.
The only supplied parameter is the positive central-cell width. -/
def fluxOperatorPolynomialTarget : Prop :=
  ∀ h : ℝ, 0 < h →
    let u : ℝ → ℝ := fun x => x ^ 2
    let aL := -5 * h / 2
    let bL := -h / 2
    let aK := bL
    let bK := h / 2
    let aR := bK
    let bR := 5 * h / 2
    let L := Set.Ioo aL bL
    let K := Set.Ioo aK bK
    let R := Set.Ioo aR bR
    let xL := (aL + bL) / 2
    let xK := (aK + bK) / 2
    let xR := (aR + bR) / 2
    let dL := |xL - xK|
    let dR := |xR - xK|
    let nL : ℝ := -1
    let nR : ℝ := 1
    let NL := NumStability.FiniteVolume.forwardDifferenceQuotient u xL (xK - xL)
    let NR := -NumStability.FiniteVolume.forwardDifferenceQuotient u xK (xR - xK)
    let PL := -(deriv u aK) * nL
    let PR := -(deriv u bK) * nR
    let Ah := (NL + NR) / MeasureTheory.volume.real K
    let A := -(deriv (deriv u) xK)
    L.Nonempty ∧ K.Nonempty ∧ R.Nonempty ∧
    Disjoint L K ∧ Disjoint K R ∧ Disjoint L R ∧
    bL = aK ∧ bK = aR ∧
    bL - aL = 2 * h ∧ bK - aK = h ∧ bR - aR = 2 * h ∧
    MeasureTheory.volume.real L = 2 * h ∧
    MeasureTheory.volume.real K = h ∧
    MeasureTheory.volume.real R = 2 * h ∧
    xL = -3 * h / 2 ∧ xK = 0 ∧ xR = 3 * h / 2 ∧
    xL ∈ L ∧ xK ∈ K ∧ xR ∈ R ∧
    dL = 3 * h / 2 ∧ dR = 3 * h / 2 ∧
    0 < dL ∧ 0 < dR ∧ xK - xL = dL ∧ xR - xK = dR ∧
    NL = -(u xL - u xK) / dL ∧ NR = -(u xR - u xK) / dR ∧
    NL = -3 * h / 2 ∧ NR = -3 * h / 2 ∧ PL = -h ∧ PR = -h ∧
    |NL - PL| = h / 2 ∧ |NR - PR| = h / 2 ∧
    Ah = -3 ∧ A = -2 ∧
    (PL + PR) / MeasureTheory.volume.real K = A ∧ |Ah - A| = 1

end NumStability.Eymard.Chapter01
