/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineSweep
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateUpdate

/-!
# Admitted successive coordinate-line updates

Every stage is admitted on its actual preceding output. The canonical ordered
sweep is unchanged, and all operational results are independent of the arbitrary
off-domain extension. Initial admission does not imply later admission.
-/

namespace NumStability.RiemannInformationCoordinate

variable {D : Type*} [DecidableEq D] {m : ℕ}
variable {laws : D → OneDimensionalHyperbolicConservationLaw (Fin m)}
variable {Result : (d : D) → HyperbolicRiemannProblem (laws d) → Type*}
variable {Information : D → Type*}
variable (methods : (d : D) → ℝ → RiemannInformationFluxMethod (laws d) (Result d) (Information d))


def SweepAdmitted (volume : (D → ℤ) → ℝ) (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ) :
    List (D × ℝ) → ((D → ℤ) → Fin m → ℝ) → Prop
  | [], _ => True
  | (d, dt) :: stages, state => StageAdmitted methods d dt state ∧
      SweepAdmitted volume area fallback stages
        (CoordinateLineBalance.advance volume (guardedRule methods area fallback) d dt state)

theorem sweepAdmitted_fallback_independent (volume : (D → ℤ) → ℝ)
    (area : D → (D → ℤ) → ℝ)
    (fallback other : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (stages : List (D × ℝ)) (state : (D → ℤ) → Fin m → ℝ)
    (h : SweepAdmitted methods volume area fallback stages state) :
    SweepAdmitted methods volume area other stages state := by
  induction stages generalizing state with
  | nil => trivial
  | cons step stages ih =>
    rcases step with ⟨d, dt⟩
    refine ⟨h.1, ?_⟩
    rw [← advance_fallback_independent methods volume area fallback other d dt state h.1]
    exact ih _ h.2

theorem sweep_fallback_independent (volume : (D → ℤ) → ℝ)
    (area : D → (D → ℤ) → ℝ)
    (fallback other : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (stages : List (D × ℝ)) (state : (D → ℤ) → Fin m → ℝ)
    (h : SweepAdmitted methods volume area fallback stages state) :
    CoordinateLineBalance.sweep volume (guardedRule methods area fallback) stages state =
      CoordinateLineBalance.sweep volume (guardedRule methods area other) stages state := by
  induction stages generalizing state with
  | nil => rfl
  | cons step stages ih =>
    rcases step with ⟨d, dt⟩
    rw [CoordinateLineBalance.sweep_cons, CoordinateLineBalance.sweep_cons,
      ← advance_fallback_independent methods volume area fallback other d dt state h.1]
    exact ih _ h.2

theorem admission_at_prefix (volume : (D → ℤ) → ℝ) (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (before : List (D × ℝ)) (d : D) (dt : ℝ) (after : List (D × ℝ))
    (state : (D → ℤ) → Fin m → ℝ)
    (h : SweepAdmitted methods volume area fallback (before ++ (d, dt) :: after) state) :
    StageAdmitted methods d dt
      (CoordinateLineBalance.sweep volume (guardedRule methods area fallback) before state) := by
  induction before generalizing state with
  | nil => exact h.1
  | cons step before ih =>
    rcases step with ⟨e, ds⟩
    rw [CoordinateLineBalance.sweep_cons]
    exact ih _ h.2

theorem executed_face_uses_selected_solve (volume : (D → ℤ) → ℝ)
    (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (before : List (D × ℝ)) (d : D) (dt : ℝ) (after : List (D × ℝ))
    (state : (D → ℤ) → Fin m → ℝ)
    (h : SweepAdmitted methods volume area fallback (before ++ (d, dt) :: after) state)
    (cell : D → ℤ) :
    let current := CoordinateLineBalance.sweep volume (guardedRule methods area fallback) before state
    ∃ admitted : FaceAdmitted methods d dt current cell,
      CoordinateLineBalance.normalFaceFlux (guardedRule methods area fallback) d dt current cell =
        area d cell • selectedFaceFlux methods d dt current cell admitted := by
  exact ⟨admission_at_prefix methods volume area fallback before d dt after state h cell,
    normalFaceFlux_of_admitted methods area fallback d dt _ cell _⟩

theorem admitted_two_stage_balance (volume : (D → ℤ) → ℝ)
    (hvolume : ∀ cell, 0 < volume cell) (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d e : D) (dt ds : ℝ) (state : (D → ℤ) → Fin m → ℝ)
    (h : SweepAdmitted methods volume area fallback [(d, dt), (e, ds)] state) (cell : D → ℤ) :
    let first := CoordinateLineBalance.advance volume (guardedRule methods area fallback) d dt state
    volume cell • CoordinateLineBalance.sweep volume (guardedRule methods area fallback)
        [(d, dt), (e, ds)] state cell = volume cell • state cell -
      dt • (area d (Function.update cell d (cell d + 1)) • selectedFaceFlux methods d dt state
          (Function.update cell d (cell d + 1)) (h.1 _) -
        area d cell • selectedFaceFlux methods d dt state cell (h.1 cell)) -
      ds • (area e (Function.update cell e (cell e + 1)) • selectedFaceFlux methods e ds first
          (Function.update cell e (cell e + 1)) (h.2.1 _) -
        area e cell • selectedFaceFlux methods e ds first cell (h.2.1 cell)) := by
  rw [CoordinateLineBalance.sweep_two]
  rw [admitted_cell_mass_balance methods volume hvolume area fallback e ds _ h.2.1,
    admitted_cell_mass_balance methods volume hvolume area fallback d dt state h.1]

end NumStability.RiemannInformationCoordinate
