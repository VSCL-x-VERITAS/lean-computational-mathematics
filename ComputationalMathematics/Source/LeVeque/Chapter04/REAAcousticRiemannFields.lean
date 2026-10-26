/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.AcousticEigenbasis
import ComputationalMathematics.Source.LeVeque.Chapter04.REAAcousticHalfCFL
import ComputationalMathematics.Source.LeVeque.Chapter04.REACertifiedRiemannFields
import ComputationalMathematics.Source.LeVeque.Chapter04.REABoundedSelection
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRectangleRiemannInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannFluxAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RectangleTranslation
import Mathlib.Tactic.Linarith

/-!
# Selected stationary acoustic Riemann fields for REA

At each physical face, the explicit eigenbasis solver takes the reconstructed
neighboring cell states as its left and right data. Its extremal speeds are
exactly `-c` and `c` when the background velocity is zero.
-/

namespace NumStability

/-- Both stationary acoustic characteristic speeds lie in the closed
sound-speed interval, including zero sound speed. -/
theorem leveque04_acousticSpeeds_abs_le_soundSpeed
    (soundSpeed : ℝ) (hsound : 0 ≤ soundSpeed) (p : Fin 2) :
    |leveque04_acousticSpeeds 0 soundSpeed p| ≤ soundSpeed := by
  fin_cases p <;> simp [leveque04_acousticSpeeds, abs_of_nonneg, abs_of_nonpos, hsound]

/-- The actual selected linear acoustic Riemann profile at face `j` of the
piecewise-constant reconstruction. -/
noncomputable def leveque04_acousticREAField
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (states : ℤ → Fin 2 → ℝ) (origin width : ℝ)
    (j : ℤ) (x time : ℝ) : Fin 2 → ℝ :=
  linearRiemannSolution
    (leveque04_acousticEigenbasis density soundSpeed himpedance)
    (leveque04_acousticSpeeds 0 soundSpeed)
    (states j) (states j) (states (j + 1))
    (x - (origin + (j : ℝ) * width)) time

/-- The selected acoustic Riemann profile retains the reconstructed state
strictly to the left of its extreme front. -/
theorem leveque04_acousticREAField_left
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (states : ℤ → Fin 2 → ℝ) (origin width : ℝ)
    (hsound : 0 ≤ soundSpeed) (j : ℤ) (x time : ℝ)
    (htime : 0 ≤ time)
    (hx : x < origin + (j : ℝ) * width + (-soundSpeed) * time) :
    leveque04_acousticREAField density soundSpeed himpedance
      states origin width j x time = states j := by
  unfold leveque04_acousticREAField
  apply linearRiemannSolution_farLeft
    (leveque04_acousticEigenbasis density soundSpeed himpedance)
    (leveque04_acousticSpeeds 0 soundSpeed)
    (states j) (states j) (states (j + 1)) soundSpeed
    (x - (origin + (j : ℝ) * width)) time
    (leveque04_acousticSpeeds_abs_le_soundSpeed soundSpeed hsound) htime
  nlinarith

/-- The selected acoustic Riemann profile retains the reconstructed state
strictly to the right of its extreme front. -/
theorem leveque04_acousticREAField_right
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (states : ℤ → Fin 2 → ℝ) (origin width : ℝ)
    (hsound : 0 ≤ soundSpeed) (j : ℤ) (x time : ℝ)
    (htime : 0 ≤ time)
    (hx : origin + (j : ℝ) * width + soundSpeed * time < x) :
    leveque04_acousticREAField density soundSpeed himpedance
      states origin width j x time = states (j + 1) := by
  unfold leveque04_acousticREAField
  apply linearRiemannSolution_farRight
    (leveque04_acousticEigenbasis density soundSpeed himpedance)
    (leveque04_acousticSpeeds 0 soundSpeed)
    (states j) (states j) (states (j + 1)) soundSpeed
    (x - (origin + (j : ℝ) * width)) time
    (leveque04_acousticSpeeds_abs_le_soundSpeed soundSpeed hsound) htime
  linarith

/-- Every selected stationary acoustic Riemann profile conserves the
physical pressure-velocity matrix flux on any requested rectangle. -/
theorem leveque04_acousticREAField_rectangleReferenceOn
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (states : ℤ → Fin 2 → ℝ) (origin width : ℝ)
    (j : ℤ) (left right horizon : ℝ) :
    LocalConservationLaw.RectangleReferenceOn
      (leveque04_acousticREAField density soundSpeed himpedance
        states origin width j)
      (convectedLinearAcousticsMatrix
        (density * soundSpeed ^ 2) density 0).mulVec
      left right horizon := by
  have hsolution := linearRiemannSolution_isRectangleSolution
    (convectedLinearAcousticsMatrix
      (density * soundSpeed ^ 2) density 0)
    (leveque04_acousticEigenbasis density soundSpeed himpedance)
    (leveque04_acousticSpeeds 0 soundSpeed)
    (leveque04_acousticEigenbasis_eigen density soundSpeed 0 himpedance)
    (states j) (states j) (states (j + 1))
  exact IsRectangleConservationLawSolution.rectangleReferenceOn _ _
    (IsRectangleConservationLawSolution.spatialShift _ _ hsolution
      (origin + (j : ℝ) * width)) left right horizon

/-- The actual selected pressure-velocity acoustic Riemann profiles assemble
into a bilateral solution on the closed half-cell step. -/
noncomputable def leveque04_acousticREAClosedEvolution
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (states : ℤ → Fin 2 → ℝ)
    (origin width step : ℝ)
    (hwidth : 0 < width) (hsound : 0 ≤ soundSpeed) (hstep : 0 ≤ step)
    (hcfl : soundSpeed * step / width ≤ 1 / 2) :
    ℝ → ℝ → Fin 2 → ℝ :=
  leveque04_acousticClosedEvolution states
    (leveque04_acousticREAField density soundSpeed himpedance states origin width)
    origin width soundSpeed step hwidth hsound hstep hcfl
    (fun j x time ht hx =>
      leveque04_acousticREAField_left density soundSpeed himpedance
        states origin width hsound j x time ht.1 hx)
    (fun j x time ht hx =>
      leveque04_acousticREAField_right density soundSpeed himpedance
        states origin width hsound j x time ht.1 hx)

/-- The selected pressure-velocity acoustic evolution obeys the physical
conservative cell-average update at the closed half-cell CFL endpoint. -/
theorem leveque04_acousticREAClosedEvolution_cellAverage_step
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (states : ℤ → Fin 2 → ℝ)
    (origin width step : ℝ)
    (hwidth : 0 < width) (hsound : 0 ≤ soundSpeed) (hstep : 0 < step)
    (hcfl : soundSpeed * step / width ≤ 1 / 2)
    (cell : ℤ) :
    let q := leveque04_acousticREAClosedEvolution density soundSpeed
      himpedance states origin width step hwidth hsound hstep.le hcfl
    oneDimensionalCellAverage (fun x => q x step)
      (origin + (cell : ℝ) * width)
      (origin + ((cell + 1 : ℤ) : ℝ) * width) =
      states (cell + 1) - (step / width) •
        (oneDimensionalCellAverage
          (fun time => (convectedLinearAcousticsMatrix
            (density * soundSpeed ^ 2) density 0).mulVec
              (q (origin + ((cell + 1 : ℤ) : ℝ) * width) time)) 0 step -
          oneDimensionalCellAverage
            (fun time => (convectedLinearAcousticsMatrix
              (density * soundSpeed ^ 2) density 0).mulVec
                (q (origin + (cell : ℝ) * width) time)) 0 step) := by
  simpa only [leveque04_acousticREAClosedEvolution] using
    (leveque04_acousticClosedEvolution_cellAverage_step states
      (leveque04_acousticREAField density soundSpeed himpedance states origin width)
      origin width soundSpeed step hwidth hsound hstep hcfl
      (fun j x time ht hx =>
        leveque04_acousticREAField_left density soundSpeed himpedance
          states origin width hsound j x time ht.1 hx)
      (fun j x time ht hx =>
        leveque04_acousticREAField_right density soundSpeed himpedance
          states origin width hsound j x time ht.1 hx)
      (convectedLinearAcousticsMatrix
        (density * soundSpeed ^ 2) density 0).mulVec cell
      (fun j => leveque04_acousticREAField_rectangleReferenceOn
        density soundSpeed himpedance states origin width j
        (origin + (cell : ℝ) * width)
        (origin + ((cell + 1 : ℤ) : ℝ) * width) step))

/-- The explicit selected acoustic profile is exactly the local field
returned by the certified adjacent-state Riemann method at the same face. -/
theorem leveque04_acousticREAField_eq_certifiedLocalField
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (states : ℤ → Fin 2 → ℝ) (origin width : ℝ)
    (j : ℤ) (x time : ℝ) :
    let coefficient := convectedLinearAcousticsMatrix
      (density * soundSpeed ^ 2) density 0
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      (leveque04_acoustic_hyperbolic density soundSpeed 0 himpedance)
      (leveque04_acousticEigenbasis density soundSpeed himpedance)
      (leveque04_acousticSpeeds 0 soundSpeed)
      (leveque04_acousticEigenbasis_eigen density soundSpeed 0 himpedance)
    leveque04_acousticREAField density soundSpeed himpedance
      states origin width j x time =
      leveque04_reaCertifiedLocalField method states (fun _ => True.intro)
        (fun k => origin + ((k - 1 : ℤ) : ℝ) * width) (j + 1) x time := by
  simp [leveque04_acousticREAField, leveque04_reaCertifiedLocalField,
    linearRectangleRiemannInterfaceFluxMethod,
    certifiedLinearRectangleRiemannSolution, adjacentCellRiemannProblem]

/-- At every positive time of the closed half-cell step, the actual acoustic
REA field selects the local Riemann profile at its physical face. -/
theorem leveque04_acousticREAClosedEvolution_face_profile
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (states : ℤ → Fin 2 → ℝ)
    (origin width step : ℝ)
    (hwidth : 0 < width) (hsound : 0 < soundSpeed) (hstep : 0 ≤ step)
    (hcfl : soundSpeed * step / width ≤ 1 / 2)
    (j : ℤ) (time : ℝ) (htime : 0 < time) (htimeStep : time ≤ step) :
    leveque04_acousticREAClosedEvolution density soundSpeed
      himpedance states origin width step hwidth hsound.le hstep hcfl
      (origin + (j : ℝ) * width) time =
    leveque04_acousticREAField density soundSpeed himpedance
      states origin width j (origin + (j : ℝ) * width) time := by
  let fields := leveque04_acousticREAField density soundSpeed himpedance
    states origin width
  have hspeeds : ∀ k : ℤ, -soundSpeed ≤ (fun _ : ℤ => -soundSpeed) k ∧
      (fun _ : ℤ => -soundSpeed) k ≤ (fun _ : ℤ => soundSpeed) k ∧
      (fun _ : ℤ => soundSpeed) k ≤ soundSpeed := by
    intro k
    exact ⟨le_refl _, neg_le_self hsound.le, le_refl _⟩
  have hinteraction : ∀ k : ℤ,
      origin + (k : ℝ) * width + soundSpeed * step ≤
        origin + ((k + 1 : ℤ) : ℝ) * width + (-soundSpeed) * step := by
    intro k
    have h := (leveque04_acousticHalfCFL_iff_adjacentFrontsOrdered
      soundSpeed width step origin hsound.le hwidth hstep).mp hcfl k
    simpa [leveque04_acousticSpeeds] using h
  have hleft : ∀ (k : ℤ) (x τ : ℝ), τ ∈ Set.Icc 0 step →
      x < origin + (k : ℝ) * width + (-soundSpeed) * τ →
        fields k x τ = states k := by
    intro k x τ ht hx
    exact leveque04_acousticREAField_left density soundSpeed himpedance
      states origin width hsound.le k x τ ht.1 hx
  have hright : ∀ (k : ℤ) (x τ : ℝ), τ ∈ Set.Icc 0 step →
      origin + (k : ℝ) * width + soundSpeed * τ < x →
        fields k x τ = states (k + 1) := by
    intro k x τ ht hx
    exact leveque04_acousticREAField_right density soundSpeed himpedance
      states origin width hsound.le k x τ ht.1 hx
  have hx : origin + (j : ℝ) * width ∈ Set.Ioo
      (origin + (j : ℝ) * width + (-soundSpeed) * time)
      (origin + (j : ℝ) * width + soundSpeed * time) := by
    constructor <;> dsimp <;> nlinarith [mul_pos hsound htime]
  have hselected := leveque04_reaBoundedEvolution_eq_profile
    states fields (fun _ => -soundSpeed) (fun _ => soundSpeed)
    origin width soundSpeed step hwidth hsound.le hstep hspeeds
    hinteraction hleft hright j (origin + (j : ℝ) * width) time
    ⟨htime.le, htimeStep⟩ hx
  simpa only [leveque04_acousticREAClosedEvolution,
    leveque04_acousticClosedEvolution] using hselected

/-- The assembled acoustic face trace is the certified method's selected
local Riemann solution at every positive time of the step. -/
theorem leveque04_acousticREAClosedEvolution_face_eq_certifiedSolution
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (states : ℤ → Fin 2 → ℝ)
    (origin width step : ℝ)
    (hwidth : 0 < width) (hsound : 0 < soundSpeed) (hstep : 0 < step)
    (hcfl : soundSpeed * step / width ≤ 1 / 2)
    (j : ℤ) (time : ℝ) (htime : time ∈ Set.uIoc 0 step) :
    let coefficient := convectedLinearAcousticsMatrix
      (density * soundSpeed ^ 2) density 0
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      (leveque04_acoustic_hyperbolic density soundSpeed 0 himpedance)
      (leveque04_acousticEigenbasis density soundSpeed himpedance)
      (leveque04_acousticSpeeds 0 soundSpeed)
      (leveque04_acousticEigenbasis_eigen density soundSpeed 0 himpedance)
    leveque04_acousticREAClosedEvolution density soundSpeed
      himpedance states origin width step hwidth hsound.le hstep.le hcfl
      (origin + (j : ℝ) * width) time =
      (method.solve (adjacentCellRiemannProblem
        (linearHyperbolicConservationLaw coefficient
          (leveque04_acoustic_hyperbolic density soundSpeed 0 himpedance))
        states (j + 1)) trivial).solution 0 time := by
  have htimePos : 0 < time := by
    simpa only [min_eq_left hstep.le] using htime.1
  have htimeLe : time ≤ step := by
    simpa only [max_eq_right hstep.le] using htime.2
  rw [leveque04_acousticREAClosedEvolution_face_profile density soundSpeed
    himpedance states origin width step hwidth hsound hstep.le hcfl
    j time htimePos htimeLe]
  rw [leveque04_acousticREAField_eq_certifiedLocalField density soundSpeed
    himpedance states origin width j]
  simp [leveque04_reaCertifiedLocalField]

/-- The time-averaged physical face flux of the actual acoustic REA field is
the selected certified acoustic numerical flux, even at half-cell equality. -/
theorem leveque04_acousticREAClosedEvolution_faceFluxAverage_eq_method
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (states : ℤ → Fin 2 → ℝ)
    (origin width step : ℝ)
    (hwidth : 0 < width) (hsound : 0 < soundSpeed) (hstep : 0 < step)
    (hcfl : soundSpeed * step / width ≤ 1 / 2)
    (j : ℤ) :
    let coefficient := convectedLinearAcousticsMatrix
      (density * soundSpeed ^ 2) density 0
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      (leveque04_acoustic_hyperbolic density soundSpeed 0 himpedance)
      (leveque04_acousticEigenbasis density soundSpeed himpedance)
      (leveque04_acousticSpeeds 0 soundSpeed)
      (leveque04_acousticEigenbasis_eigen density soundSpeed 0 himpedance)
    let q := leveque04_acousticREAClosedEvolution density soundSpeed
      himpedance states origin width step hwidth hsound.le hstep.le hcfl
    oneDimensionalCellAverage
      (fun time => coefficient.mulVec (q (origin + (j : ℝ) * width) time))
      0 step =
      rectangleRiemannInterfaceFlux method states (fun _ => True.intro) (j + 1) := by
  let coefficient := convectedLinearAcousticsMatrix
    (density * soundSpeed ^ 2) density 0
  let hyperbolic := leveque04_acoustic_hyperbolic density soundSpeed 0 himpedance
  let basis := leveque04_acousticEigenbasis density soundSpeed himpedance
  let speeds := leveque04_acousticSpeeds 0 soundSpeed
  let heigen := leveque04_acousticEigenbasis_eigen density soundSpeed 0 himpedance
  have havg := linearRectangleRiemannInterfaceFluxMethod_flux_eq_timeAverage
    coefficient hyperbolic basis speeds heigen
    (adjacentCellRiemannProblem
      (linearHyperbolicConservationLaw coefficient hyperbolic) states (j + 1)) hstep
  dsimp only
  unfold rectangleRiemannInterfaceFlux adjacentCellRectangleRiemannInformation
  rw [havg]
  unfold oneDimensionalCellAverage
  congr 1
  apply intervalIntegral.integral_congr_ae
  exact Filter.Eventually.of_forall (fun time ht =>
    congrArg coefficient.mulVec
      (leveque04_acousticREAClosedEvolution_face_eq_certifiedSolution
        density soundSpeed himpedance states origin width step
        hwidth hsound hstep hcfl j time ht))

/-- One full selected acoustic REA step is exactly the conservative update
from the certified physical Riemann interface method at nonstrict half CFL. -/
theorem leveque04_acousticREAClosedEvolution_eq_selectedStep
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (states : ℤ → Fin 2 → ℝ)
    (origin width step : ℝ)
    (hwidth : 0 < width) (hsound : 0 < soundSpeed) (hstep : 0 < step)
    (hcfl : soundSpeed * step / width ≤ 1 / 2)
    (cell : ℤ) :
    let coefficient := convectedLinearAcousticsMatrix
      (density * soundSpeed ^ 2) density 0
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      (leveque04_acoustic_hyperbolic density soundSpeed 0 himpedance)
      (leveque04_acousticEigenbasis density soundSpeed himpedance)
      (leveque04_acousticSpeeds 0 soundSpeed)
      (leveque04_acousticEigenbasis_eigen density soundSpeed 0 himpedance)
    let q := leveque04_acousticREAClosedEvolution density soundSpeed
      himpedance states origin width step hwidth hsound.le hstep.le hcfl
    oneDimensionalCellAverage (fun x => q x step)
      (origin + (cell : ℝ) * width)
      (origin + ((cell + 1 : ℤ) : ℝ) * width) =
      conservativeFluxDifferenceUpdateInt (step / width) states
        (rectangleRiemannInterfaceFlux method states (fun _ => True.intro))
        (cell + 1) := by
  dsimp only
  rw [leveque04_acousticREAClosedEvolution_cellAverage_step
    density soundSpeed himpedance states origin width step
    hwidth hsound.le hstep hcfl cell]
  rw [leveque04_acousticREAClosedEvolution_faceFluxAverage_eq_method
    density soundSpeed himpedance states origin width step
    hwidth hsound hstep hcfl (cell + 1)]
  rw [leveque04_acousticREAClosedEvolution_faceFluxAverage_eq_method
    density soundSpeed himpedance states origin width step
    hwidth hsound hstep hcfl cell]
  simp only [conservativeFluxDifferenceUpdateInt]

/-- The constructed exact acoustic REA evolution conserves the physical
pressure-velocity flux on every rectangle over the full closed step. -/
theorem leveque04_acousticREAClosedEvolution_rectangleReferenceOn
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (states : ℤ → Fin 2 → ℝ)
    (origin width step : ℝ)
    (hwidth : 0 < width) (hsound : 0 ≤ soundSpeed) (hstep : 0 ≤ step)
    (hcfl : soundSpeed * step / width ≤ 1 / 2)
    (left right : ℝ) (hbox : left ≤ right) :
    LocalConservationLaw.RectangleReferenceOn
      (leveque04_acousticREAClosedEvolution density soundSpeed
        himpedance states origin width step hwidth hsound hstep hcfl)
      (convectedLinearAcousticsMatrix
        (density * soundSpeed ^ 2) density 0).mulVec
      left right step := by
  let fields := leveque04_acousticREAField density soundSpeed himpedance
    states origin width
  have hspeeds : ∀ j : ℤ, -soundSpeed ≤ (fun _ : ℤ => -soundSpeed) j ∧
      (fun _ : ℤ => -soundSpeed) j ≤ (fun _ : ℤ => soundSpeed) j ∧
      (fun _ : ℤ => soundSpeed) j ≤ soundSpeed := by
    intro j
    exact ⟨le_refl _, neg_le_self hsound, le_refl _⟩
  have hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + soundSpeed * step ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + (-soundSpeed) * step := by
    intro j
    have h := (leveque04_acousticHalfCFL_iff_adjacentFrontsOrdered
      soundSpeed width step origin hsound hwidth hstep).mp hcfl j
    simpa [leveque04_acousticSpeeds] using h
  have hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 step →
      x < origin + (j : ℝ) * width + (-soundSpeed) * time →
        fields j x time = states j := by
    intro j x time ht hx
    exact leveque04_acousticREAField_left density soundSpeed himpedance
      states origin width hsound j x time ht.1 hx
  have hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 step →
      origin + (j : ℝ) * width + soundSpeed * time < x →
        fields j x time = states (j + 1) := by
    intro j x time ht hx
    exact leveque04_acousticREAField_right density soundSpeed himpedance
      states origin width hsound j x time ht.1 hx
  simpa only [leveque04_acousticREAClosedEvolution,
    leveque04_acousticClosedEvolution] using
    (leveque04_reaBoundedEvolution_rectangleReferenceOn states fields
      (fun _ => -soundSpeed) (fun _ => soundSpeed)
      origin width soundSpeed step hwidth hsound hstep hspeeds
      hinteraction hleft hright
      (convectedLinearAcousticsMatrix
        (density * soundSpeed ^ 2) density 0).mulVec
      left right hbox
      (fun j => leveque04_acousticREAField_rectangleReferenceOn
        density soundSpeed himpedance states origin width j left right step))

/-- The constructed acoustic evolution has the exact mass of the prescribed
piecewise-constant reconstruction in each cell at time zero. -/
theorem leveque04_acousticREAClosedEvolution_initialCellMass
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (states : ℤ → Fin 2 → ℝ)
    (origin width step : ℝ)
    (hwidth : 0 < width) (hsound : 0 ≤ soundSpeed) (hstep : 0 ≤ step)
    (hcfl : soundSpeed * step / width ≤ 1 / 2)
    (cell : ℤ) :
    (∫ x in (origin + (cell : ℝ) * width)..
      (origin + ((cell + 1 : ℤ) : ℝ) * width),
      leveque04_acousticREAClosedEvolution density soundSpeed
        himpedance states origin width step hwidth hsound hstep hcfl x 0) =
      width • states (cell + 1) := by
  let fields := leveque04_acousticREAField density soundSpeed himpedance
    states origin width
  have hspeeds : ∀ j : ℤ, -soundSpeed ≤ (fun _ : ℤ => -soundSpeed) j ∧
      (fun _ : ℤ => -soundSpeed) j ≤ (fun _ : ℤ => soundSpeed) j ∧
      (fun _ : ℤ => soundSpeed) j ≤ soundSpeed := by
    intro j
    exact ⟨le_refl _, neg_le_self hsound, le_refl _⟩
  have hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + soundSpeed * step ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + (-soundSpeed) * step := by
    intro j
    have h := (leveque04_acousticHalfCFL_iff_adjacentFrontsOrdered
      soundSpeed width step origin hsound hwidth hstep).mp hcfl j
    simpa [leveque04_acousticSpeeds] using h
  have hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 step →
      x < origin + (j : ℝ) * width + (-soundSpeed) * time →
        fields j x time = states j := by
    intro j x time ht hx
    exact leveque04_acousticREAField_left density soundSpeed himpedance
      states origin width hsound j x time ht.1 hx
  have hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 step →
      origin + (j : ℝ) * width + soundSpeed * time < x →
        fields j x time = states (j + 1) := by
    intro j x time ht hx
    exact leveque04_acousticREAField_right density soundSpeed himpedance
      states origin width hsound j x time ht.1 hx
  simpa only [leveque04_acousticREAClosedEvolution,
    leveque04_acousticClosedEvolution] using
    (leveque04_reaBoundedEvolution_initialCellMass states fields
      (fun _ => -soundSpeed) (fun _ => soundSpeed)
      origin width soundSpeed step hwidth hsound hstep hspeeds
      hinteraction hleft hright cell)

/-- At time zero the actual assembled field is the prescribed reconstructed
state at every point in an open cell; face values retain the solver convention. -/
theorem leveque04_acousticREAClosedEvolution_initial_openCell
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (states : ℤ → Fin 2 → ℝ)
    (origin width step : ℝ)
    (hwidth : 0 < width) (hsound : 0 ≤ soundSpeed) (hstep : 0 ≤ step)
    (hcfl : soundSpeed * step / width ≤ 1 / 2)
    (cell : ℤ) (x : ℝ)
    (hx : x ∈ Set.Ioo (origin + (cell : ℝ) * width)
      (origin + ((cell + 1 : ℤ) : ℝ) * width)) :
    leveque04_acousticREAClosedEvolution density soundSpeed
      himpedance states origin width step hwidth hsound hstep hcfl x 0 =
      states (cell + 1) := by
  let fields := leveque04_acousticREAField density soundSpeed himpedance
    states origin width
  have hleft : ∀ (j : ℤ) (y time : ℝ), time ∈ Set.Icc 0 step →
      y < origin + (j : ℝ) * width + (-soundSpeed) * time →
        fields j y time = states j := by
    intro j y time ht hy
    exact leveque04_acousticREAField_left density soundSpeed himpedance
      states origin width hsound j y time ht.1 hy
  have hright : ∀ (j : ℤ) (y time : ℝ), time ∈ Set.Icc 0 step →
      origin + (j : ℝ) * width + soundSpeed * time < y →
        fields j y time = states (j + 1) := by
    intro j y time ht hy
    exact leveque04_acousticREAField_right density soundSpeed himpedance
      states origin width hsound j y time ht.1 hy
  have hcones := riemannChain_uniform_cones_of_affine_fronts states fields
    (fun _ => -soundSpeed) (fun _ => soundSpeed)
    origin width soundSpeed step
    (fun j => ⟨le_refl _, le_refl _⟩) hleft hright
  have hfinite := riemannChain_pointwise_finite_of_uniform_cones
    states fields origin width soundSpeed step
    hwidth hsound hstep hcones.1 hcones.2
  have hinitial := bilateralRiemannChainEvolution_initial_eq_cell_state
    states fields origin width step hwidth hstep hfinite
    (by
      intro j y hy
      exact hleft j y 0 ⟨le_refl _, hstep⟩ (by simpa using hy))
    (by
      intro j y hy
      exact hright j y 0 ⟨le_refl _, hstep⟩ (by simpa using hy))
    cell x hx
  simpa only [leveque04_acousticREAClosedEvolution,
    leveque04_acousticClosedEvolution, leveque04_reaBoundedEvolution]
    using hinitial

end NumStability
