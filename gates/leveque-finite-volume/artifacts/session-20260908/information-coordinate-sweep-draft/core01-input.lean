import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineSweep
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod

namespace NumStability.InformationCoordinateSweepDraft

open MeasureTheory
open scoped BigOperators

variable {D : Type*} [DecidableEq D] {m : ℕ}
variable {laws : D → OneDimensionalHyperbolicConservationLaw (Fin m)}
variable {Result : (d : D) → HyperbolicRiemannProblem (laws d) → Type*}
variable {Information : D → Type*}
variable (methods : (d : D) → ℝ → RiemannInformationFluxMethod (laws d) (Result d) (Information d))

/-- Admission is for this face of this actual numerical state at this stage duration. -/
def FaceAdmitted (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (cell : D → ℤ) : Prop :=
  (methods d dt).domain (adjacentCellRiemannProblem (laws d)
    (fun j => state (Function.update cell d j)) (cell d))

def StageAdmitted (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) : Prop :=
  ∀ cell, FaceAdmitted methods d dt state cell

/-- Numerical information is extracted from the selected solve of the actual ordered pair. -/
def selectedFaceFlux (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (cell : D → ℤ)
    (h : FaceAdmitted methods d dt state cell) : Fin m → ℝ :=
  (methods d dt).numericalFlux ((methods d dt).extract ((methods d dt).solve
    (adjacentCellRiemannProblem (laws d) (fun j => state (Function.update cell d j)) (cell d)) h))

/-- Explicit total extension for the canonical algebraic API. The off-domain
fallback is not a Riemann solve and has no asserted physical meaning. -/
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

/-- The actual ordered local problem and extraction from its selected result.
No space-time field or trace property is part of this observation. -/
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

/-- Every later admission is checked on the actual preceding update. This does
not assert preservation of the domain from admission of the initial state alone. -/
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

/-- Any selected stage in an admitted execution sees an admitted actual prefix state. -/
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

/-- No operational face observation in an admitted sweep uses the fallback. -/
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

/-- Strict line locality is inherited from the canonical line-reading operation. -/
theorem advance_line_local (volume : (D → ℤ) → ℝ) (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state other : (D → ℤ) → Fin m → ℝ) (base : D → ℤ)
    (hline : ∀ j, state (Function.update base d j) = other (Function.update base d j)) :
    ∀ j, CoordinateLineBalance.advance volume (guardedRule methods area fallback) d dt state
        (Function.update base d j) =
      CoordinateLineBalance.advance volume (guardedRule methods area fallback) d dt other
        (Function.update base d j) :=
  CoordinateLineBalance.advance_line_local volume _ d dt state other base hline

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

/-- Interior shared-face values cancel; only actual selected exterior solves remain. -/
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

/-- The second balance uses the first actual output, with its separate admission. -/
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

end NumStability.InformationCoordinateSweepDraft


#check NumStability.InformationCoordinateSweepDraft.FaceAdmitted
#print axioms NumStability.InformationCoordinateSweepDraft.FaceAdmitted
#check NumStability.InformationCoordinateSweepDraft.StageAdmitted
#print axioms NumStability.InformationCoordinateSweepDraft.StageAdmitted
#check NumStability.InformationCoordinateSweepDraft.selectedFaceFlux
#print axioms NumStability.InformationCoordinateSweepDraft.selectedFaceFlux
#check NumStability.InformationCoordinateSweepDraft.guardedRule
#print axioms NumStability.InformationCoordinateSweepDraft.guardedRule
#check NumStability.InformationCoordinateSweepDraft.normalFaceFlux_of_admitted
#print axioms NumStability.InformationCoordinateSweepDraft.normalFaceFlux_of_admitted
#check NumStability.InformationCoordinateSweepDraft.admitted_face_observation
#print axioms NumStability.InformationCoordinateSweepDraft.admitted_face_observation
#check NumStability.InformationCoordinateSweepDraft.normalFaceFlux_fallback_independent
#print axioms NumStability.InformationCoordinateSweepDraft.normalFaceFlux_fallback_independent
#check NumStability.InformationCoordinateSweepDraft.advance_fallback_independent
#print axioms NumStability.InformationCoordinateSweepDraft.advance_fallback_independent
#check NumStability.InformationCoordinateSweepDraft.SweepAdmitted
#print axioms NumStability.InformationCoordinateSweepDraft.SweepAdmitted
#check NumStability.InformationCoordinateSweepDraft.sweepAdmitted_fallback_independent
#print axioms NumStability.InformationCoordinateSweepDraft.sweepAdmitted_fallback_independent
#check NumStability.InformationCoordinateSweepDraft.sweep_fallback_independent
#print axioms NumStability.InformationCoordinateSweepDraft.sweep_fallback_independent
#check NumStability.InformationCoordinateSweepDraft.admission_at_prefix
#print axioms NumStability.InformationCoordinateSweepDraft.admission_at_prefix
#check NumStability.InformationCoordinateSweepDraft.executed_face_uses_selected_solve
#print axioms NumStability.InformationCoordinateSweepDraft.executed_face_uses_selected_solve
#check NumStability.InformationCoordinateSweepDraft.advance_line_local
#print axioms NumStability.InformationCoordinateSweepDraft.advance_line_local
#check NumStability.InformationCoordinateSweepDraft.admitted_cell_mass_balance
#print axioms NumStability.InformationCoordinateSweepDraft.admitted_cell_mass_balance
#check NumStability.InformationCoordinateSweepDraft.admitted_finite_line_mass_balance
#print axioms NumStability.InformationCoordinateSweepDraft.admitted_finite_line_mass_balance
#check NumStability.InformationCoordinateSweepDraft.admitted_two_stage_balance
#print axioms NumStability.InformationCoordinateSweepDraft.admitted_two_stage_balance
