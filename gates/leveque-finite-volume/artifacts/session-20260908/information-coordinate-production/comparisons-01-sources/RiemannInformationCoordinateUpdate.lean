/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod

/-!
# Admitted information routines in coordinate-line updates

An actual adjacent problem supplies the selected result and extracted face flux.
The off-domain extension has no solver meaning; admitted updates are independent
of it. Cell and finite-line balances reuse the canonical shared-face executor.
No returned field, trace, accuracy assertion or total-routine assumption is added.
-/

namespace NumStability.RiemannInformationCoordinate

open scoped BigOperators

variable {D : Type*} [DecidableEq D] {m : ℕ}
variable {laws : D → OneDimensionalHyperbolicConservationLaw (Fin m)}
variable {Result : (d : D) → HyperbolicRiemannProblem (laws d) → Type*}
variable {Information : D → Type*}
variable (methods : (d : D) → ℝ → RiemannInformationFluxMethod (laws d) (Result d) (Information d))


def FaceAdmitted (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (cell : D → ℤ) : Prop :=
  (methods d dt).domain (adjacentCellRiemannProblem (laws d)
    (fun j => state (Function.update cell d j)) (cell d))

def StageAdmitted (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) : Prop :=
  ∀ cell, FaceAdmitted methods d dt state cell

def selectedFaceFlux (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (cell : D → ℤ)
    (h : FaceAdmitted methods d dt state cell) : Fin m → ℝ :=
  (methods d dt).numericalFlux ((methods d dt).extract ((methods d dt).solve
    (adjacentCellRiemannProblem (laws d) (fun j => state (Function.update cell d j)) (cell d)) h))

noncomputable def guardedRule (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (cell : D → ℤ) (dt : ℝ) (line : ℤ → Fin m → ℝ) : Fin m → ℝ := by
  classical
  exact if h : (methods d dt).domain (adjacentCellRiemannProblem (laws d) line (cell d)) then
    area d cell • (methods d dt).numericalFlux ((methods d dt).extract
      ((methods d dt).solve (adjacentCellRiemannProblem (laws d) line (cell d)) h))
  else fallback d cell dt line

theorem normalFaceFlux_of_admitted (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (cell : D → ℤ)
    (h : FaceAdmitted methods d dt state cell) :
    CoordinateLineBalance.normalFaceFlux (guardedRule methods area fallback) d dt state cell =
      area d cell • selectedFaceFlux methods d dt state cell h := by
  unfold FaceAdmitted at h
  simp only [CoordinateLineBalance.normalFaceFlux, guardedRule, dif_pos h, selectedFaceFlux]

theorem admitted_face_observation (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (cell : D → ℤ)
    (h : FaceAdmitted methods d dt state cell) :
    let problem := adjacentCellRiemannProblem (laws d)
      (fun j => state (Function.update cell d j)) (cell d)
    let result := (methods d dt).solve problem h
    problem.leftState = state (Function.update cell d (cell d - 1)) ∧
      problem.rightState = state cell ∧
      CoordinateLineBalance.normalFaceFlux (guardedRule methods area fallback) d dt state cell =
        area d cell • (methods d dt).numericalFlux ((methods d dt).extract result) := by
  refine ⟨rfl, ?_, normalFaceFlux_of_admitted methods area fallback d dt state cell h⟩
  simp [adjacentCellRiemannProblem]

theorem normalFaceFlux_fallback_independent (area : D → (D → ℤ) → ℝ)
    (fallback other : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (cell : D → ℤ)
    (h : FaceAdmitted methods d dt state cell) :
    CoordinateLineBalance.normalFaceFlux (guardedRule methods area fallback) d dt state cell =
      CoordinateLineBalance.normalFaceFlux (guardedRule methods area other) d dt state cell := by
  rw [normalFaceFlux_of_admitted methods area fallback d dt state cell h,
    normalFaceFlux_of_admitted methods area other d dt state cell h]

theorem advance_fallback_independent (volume : (D → ℤ) → ℝ)
    (area : D → (D → ℤ) → ℝ)
    (fallback other : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ)
    (h : StageAdmitted methods d dt state) :
    CoordinateLineBalance.advance volume (guardedRule methods area fallback) d dt state =
      CoordinateLineBalance.advance volume (guardedRule methods area other) d dt state := by
  funext cell
  unfold CoordinateLineBalance.advance CoordinateLineBalance.netOutwardFlux
  rw [normalFaceFlux_fallback_independent methods area fallback other d dt state _ (h _),
    normalFaceFlux_fallback_independent methods area fallback other d dt state cell (h cell)]

theorem admitted_cell_mass_balance (volume : (D → ℤ) → ℝ) (hvolume : ∀ cell, 0 < volume cell)
    (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ)
    (h : StageAdmitted methods d dt state) (cell : D → ℤ) :
    volume cell • CoordinateLineBalance.advance volume (guardedRule methods area fallback) d dt state cell =
      volume cell • state cell - dt •
        (area d (Function.update cell d (cell d + 1)) •
            selectedFaceFlux methods d dt state (Function.update cell d (cell d + 1)) (h _) -
          area d cell • selectedFaceFlux methods d dt state cell (h cell)) := by
  rw [CoordinateLineBalance.advance_mass_balance volume hvolume, CoordinateLineBalance.netOutwardFlux,
    normalFaceFlux_of_admitted methods area fallback d dt state _ (h _),
    normalFaceFlux_of_admitted methods area fallback d dt state cell (h cell)]

theorem admitted_finite_line_mass_balance (volume : (D → ℤ) → ℝ)
    (hvolume : ∀ cell, 0 < volume cell) (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ)
    (h : StageAdmitted methods d dt state) (base : D → ℤ) (start : ℤ) (count : ℕ) :
    (∑ k ∈ Finset.range count, volume (Function.update base d (start + k)) •
      CoordinateLineBalance.advance volume (guardedRule methods area fallback) d dt state
        (Function.update base d (start + k))) =
      (∑ k ∈ Finset.range count, volume (Function.update base d (start + k)) •
        state (Function.update base d (start + k))) - dt •
      (area d (Function.update base d (start + count)) •
          selectedFaceFlux methods d dt state (Function.update base d (start + count)) (h _) -
        area d (Function.update base d start) •
          selectedFaceFlux methods d dt state (Function.update base d start) (h _)) := by
  rw [CoordinateLineBalance.finite_line_mass_balance volume hvolume,
    normalFaceFlux_of_admitted methods area fallback d dt state _ (h _),
    normalFaceFlux_of_admitted methods area fallback d dt state _ (h _)]

end NumStability.RiemannInformationCoordinate
