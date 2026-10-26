/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REABilateralEvolution
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersFiniteChain
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BilateralRiemannChainSelection
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersFlux
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersLocalTruncation
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersBoundedStep
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersPeriodicError
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersForwardEntropy

/-!
# A selected nonlinear Burgers evolution for bilateral REA

Bounded integer-indexed cell states supply selected local Burgers shock or
rarefaction fields. Under the noninteraction CFL, the bilateral assembly
constructs a physical evolution on the whole real line.
-/

namespace NumStability

open MeasureTheory Filter
open scoped Topology

/-- The selected Burgers Riemann field at each uniform interface. -/
noncomputable def leveque04_burgersBilateralField
    (states : ℤ → ℝ) (origin width : ℝ)
    (j : ℤ) (x time : ℝ) : Fin 1 → ℝ :=
  fun _ => leveque04_burgersSelectedField (states j) (states (j + 1))
    (x - (origin + (j : ℝ) * width)) time

/-- Uniform bounded Burgers states produce a concrete bilateral REA
evolution before the adjacent selected Riemann fans interact. -/
noncomputable def leveque04_burgersBilateralEvolution
    (states : ℤ → ℝ) (origin width bound horizon step : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hstates : ∀ j, -bound ≤ states j ∧ states j ≤ bound)
    (hstep : 0 ≤ step) (hbefore : step < horizon)
    (hCFL : 2 * bound * horizon ≤ width) : ℝ → ℝ → Fin 1 → ℝ := by
  apply leveque04_reaBilateralEvolution
    (fun j (_ : Fin 1) => states j)
    (leveque04_burgersBilateralField states origin width)
    (fun _ => -bound) (fun _ => bound)
    origin width horizon step hwidth hstep hbefore
  · intro j
    linarith
  · intro j
    push_cast
    nlinarith
  · intro j x time htime hx
    funext p
    exact leveque04_burgersSelectedField_left_of_cone
      (states j) (states (j + 1)) bound
      (x - (origin + (j : ℝ) * width)) time
      (hstates j) (hstates (j + 1)) htime.1 (by linarith)
  · intro j x time htime hx
    funext p
    exact leveque04_burgersSelectedField_right_of_cone
      (states j) (states (j + 1)) bound
      (x - (origin + (j : ℝ) * width)) time
      (hstates j) (hstates (j + 1)) htime.1 (by linarith)

/-- The constructed bilateral nonlinear field conserves Burgers flux on
each bounded rectangle during the noninteracting step. -/
theorem leveque04_burgersBilateralEvolution_rectangleReferenceOn
    (states : ℤ → ℝ) (origin width bound horizon step left right : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hstates : ∀ j, -bound ≤ states j ∧ states j ≤ bound)
    (hstep : 0 ≤ step) (hbefore : step < horizon)
    (hCFL : 2 * bound * horizon ≤ width) (hbox : left ≤ right) :
    LocalConservationLaw.RectangleReferenceOn
      (leveque04_burgersBilateralEvolution states origin width bound horizon step
        hwidth hbound hstates hstep hbefore hCFL)
      (fun state (_ : Fin 1) => (state 0) ^ 2 / 2) left right step := by
  unfold leveque04_burgersBilateralEvolution
  apply leveque04_reaBilateralEvolution_rectangleReferenceOn
    (fun j (_ : Fin 1) => states j)
    (leveque04_burgersBilateralField states origin width)
    (fun _ => -bound) (fun _ => bound)
    origin width horizon step hwidth hstep hbefore
    (by intro j; linarith)
    (by intro j; push_cast; nlinarith)
    (by
      intro j x time htime hx
      funext p
      exact leveque04_burgersSelectedField_left_of_cone
        (states j) (states (j + 1)) bound
        (x - (origin + (j : ℝ) * width)) time
        (hstates j) (hstates (j + 1)) htime.1 (by linarith))
    (by
      intro j x time htime hx
      funext p
      exact leveque04_burgersSelectedField_right_of_cone
        (states j) (states (j + 1)) bound
        (x - (origin + (j : ℝ) * width)) time
        (hstates j) (hstates (j + 1)) htime.1 (by linarith))
    (fun state (_ : Fin 1) => (state 0) ^ 2 / 2) left right hbox
  intro j
  have hscalar := IsRectangleConservationLawSolution.spatialShift _ _
    (leveque04_burgersSelectedField_isRectangleSolution
      (states j) (states (j + 1))) (origin + (j : ℝ) * width)
  have hvector := IsRectangleConservationLawSolution.pi
    (fun (x time : ℝ) (_ : Fin 1) =>
      leveque04_burgersSelectedField (states j) (states (j + 1))
        (x - (origin + (j : ℝ) * width)) time)
    (fun _ u => u ^ 2 / 2) (fun _ => hscalar)
  have hflux : (fun state : Fin 1 → ℝ => fun p => (state p) ^ 2 / 2) =
      (fun state : Fin 1 → ℝ => fun _ => (state 0) ^ 2 / 2) := by
    funext state p
    fin_cases p
    rfl
  rw [hflux] at hvector
  exact IsRectangleConservationLawSolution.rectangleReferenceOn _ _
    hvector left right step

/-- The constructed bilateral Burgers evolution satisfies every Kružkov
entropy rectangle inequality through its noninteracting step. -/
theorem leveque04_burgersBilateralEvolution_entropy_rectangle
    (states : ℤ → ℝ) (origin width bound horizon step reference a b s t : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hstates : ∀ j, -bound ≤ states j ∧ states j ≤ bound)
    (hstep : 0 ≤ step) (hbefore : step < horizon)
    (hCFL : 2 * bound * horizon ≤ width)
    (hab : a ≤ b) (hst : s ≤ t) (hs : 0 ≤ s) (ht : t ≤ step) :
    (∫ x in a..b,
      |(leveque04_burgersBilateralEvolution states origin width bound horizon step
        hwidth hbound hstates hstep hbefore hCFL x t) 0 - reference|) -
      (∫ x in a..b,
        |(leveque04_burgersBilateralEvolution states origin width bound horizon step
          hwidth hbound hstates hstep hbefore hCFL x s) 0 - reference|) ≤
      ∫ τ in s..t,
        burgersKruzkovFlux reference
            ((leveque04_burgersBilateralEvolution states origin width bound horizon step
              hwidth hbound hstates hstep hbefore hCFL a τ) 0) -
          burgersKruzkovFlux reference
            ((leveque04_burgersBilateralEvolution states origin width bound horizon step
              hwidth hbound hstates hstep hbefore hCFL b τ) 0) := by
  unfold leveque04_burgersBilateralEvolution
  apply leveque04_reaBilateralEvolution_entropy_rectangle
    (fun j (_ : Fin 1) => states j)
    (leveque04_burgersBilateralField states origin width)
    (fun _ => -bound) (fun _ => bound)
    origin width horizon step hwidth hstep hbefore
    (by intro j; linarith)
    (by intro j; push_cast; nlinarith)
    (by
      intro j x time htime hx
      funext p
      exact leveque04_burgersSelectedField_left_of_cone
        (states j) (states (j + 1)) bound
        (x - (origin + (j : ℝ) * width)) time
        (hstates j) (hstates (j + 1)) htime.1 (by linarith))
    (by
      intro j x time htime hx
      funext p
      exact leveque04_burgersSelectedField_right_of_cone
        (states j) (states (j + 1)) bound
        (x - (origin + (j : ℝ) * width)) time
        (hstates j) (hstates (j + 1)) htime.1 (by linarith))
    (fun state => |state 0 - reference|)
    (fun state => burgersKruzkovFlux reference (state 0))
    a b s t hab hst hs ht
  · intro j τ hτ
    let shift := origin + (j : ℝ) * width
    have h := leveque04_burgersSelectedField_entropy_space_integrable
      (states j) (states (j + 1)) reference (a - shift) (b - shift) τ
    simpa only [leveque04_burgersBilateralField, sub_add_cancel] using
      (h.comp_sub_right shift)
  · intro j x hx
    exact leveque04_burgersSelectedField_entropy_flux_integrable_forward
      (states j) (states (j + 1)) reference
      (x - (origin + (j : ℝ) * width)) s t hs (hs.trans hst)
  · intro j
    let shift := origin + (j : ℝ) * width
    have h := leveque04_burgersSelectedField_entropy_rectangle_forward
      (states j) (states (j + 1)) reference
      (a - shift) (b - shift) s t (by linarith) hs hst
    have htIntegral :
        (∫ x in a..b,
          |leveque04_burgersSelectedField (states j) (states (j + 1))
            (x - shift) t - reference|) =
        ∫ x in a - shift..b - shift,
          |leveque04_burgersSelectedField (states j) (states (j + 1))
            x t - reference| :=
      intervalIntegral.integral_comp_sub_right
        (fun y => |leveque04_burgersSelectedField (states j) (states (j + 1))
          y t - reference|) shift
    have hsIntegral :
        (∫ x in a..b,
          |leveque04_burgersSelectedField (states j) (states (j + 1))
            (x - shift) s - reference|) =
        ∫ x in a - shift..b - shift,
          |leveque04_burgersSelectedField (states j) (states (j + 1))
            x s - reference| :=
      intervalIntegral.integral_comp_sub_right
        (fun y => |leveque04_burgersSelectedField (states j) (states (j + 1))
          y s - reference|) shift
    change
      (∫ x in a..b,
        |leveque04_burgersSelectedField (states j) (states (j + 1))
          (x - shift) t - reference|) -
        (∫ x in a..b,
          |leveque04_burgersSelectedField (states j) (states (j + 1))
            (x - shift) s - reference|) ≤
        ∫ τ in s..t,
          burgersKruzkovFlux reference
              (leveque04_burgersSelectedField (states j) (states (j + 1))
                (a - shift) τ) -
            burgersKruzkovFlux reference
              (leveque04_burgersSelectedField (states j) (states (j + 1))
                (b - shift) τ)
    rw [htIntegral, hsIntegral]
    exact h

/-- Away from the lattice interfaces, the selected bilateral Burgers
evolution has the reconstructed initial trace from positive time. -/
theorem leveque04_burgersBilateralEvolution_initialTrace
    (states : ℤ → ℝ) (origin width bound horizon step : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hstates : ∀ j, -bound ≤ states j ∧ states j ≤ bound)
    (hstep : 0 < step) (hbefore : step < horizon)
    (hCFL : 2 * bound * horizon ≤ width)
    (x : ℝ) (hx : ∀ j : ℤ, x ≠ origin + (j : ℝ) * width) :
    Filter.Tendsto
      (leveque04_burgersBilateralEvolution states origin width bound horizon step
        hwidth hbound hstates hstep.le hbefore hCFL x)
      (𝓝[>] (0 : ℝ))
      (𝓝 (leveque04_burgersBilateralEvolution states origin width bound horizon step
        hwidth hbound hstates hstep.le hbefore hCFL x 0)) := by
  unfold leveque04_burgersBilateralEvolution
  apply leveque04_reaBilateralEvolution_initialTrace
    (fun j (_ : Fin 1) => states j)
    (leveque04_burgersBilateralField states origin width)
    (fun _ => -bound) (fun _ => bound)
    origin width horizon step hwidth hstep hbefore
    (by intro j; linarith)
    (by intro j; push_cast; nlinarith)
    (by
      intro j y time htime hy
      funext p
      exact leveque04_burgersSelectedField_left_of_cone
        (states j) (states (j + 1)) bound
        (y - (origin + (j : ℝ) * width)) time
        (hstates j) (hstates (j + 1)) htime.1 (by linarith))
    (by
      intro j y time htime hy
      funext p
      exact leveque04_burgersSelectedField_right_of_cone
        (states j) (states (j + 1)) bound
        (y - (origin + (j : ℝ) * width)) time
        (hstates j) (hstates (j + 1)) htime.1 (by linarith))
    x hx

/-- At time zero the concrete bilateral Burgers field is the prescribed
piecewise-constant reconstruction in every open cell. -/
theorem leveque04_burgersBilateralEvolution_initial_openCell
    (states : ℤ → ℝ) (origin width bound horizon step : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hstates : ∀ j, -bound ≤ states j ∧ states j ≤ bound)
    (hstep : 0 ≤ step) (hbefore : step < horizon)
    (hCFL : 2 * bound * horizon ≤ width)
    (cell : ℤ) (x : ℝ)
    (hx : x ∈ Set.Ioo (origin + (cell : ℝ) * width)
      (origin + ((cell + 1 : ℤ) : ℝ) * width)) :
    leveque04_burgersBilateralEvolution states origin width bound horizon step
      hwidth hbound hstates hstep hbefore hCFL x 0 =
        (fun _ : Fin 1 => states (cell + 1)) := by
  let fields := leveque04_burgersBilateralField states origin width
  have hspeeds : ∀ j : ℤ, -bound ≤ bound := by intro j; linarith
  have hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + bound * horizon ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + -bound * horizon := by
    intro j
    push_cast
    nlinarith
  have hleft : ∀ (j : ℤ) (y time : ℝ), time ∈ Set.Icc 0 horizon →
      y < origin + (j : ℝ) * width + -bound * time →
      fields j y time = (fun _ : Fin 1 => states j) := by
    intro j y time htime hy
    funext p
    exact leveque04_burgersSelectedField_left_of_cone
      (states j) (states (j + 1)) bound
      (y - (origin + (j : ℝ) * width)) time
      (hstates j) (hstates (j + 1)) htime.1 (by linarith)
  have hright : ∀ (j : ℤ) (y time : ℝ), time ∈ Set.Icc 0 horizon →
      origin + (j : ℝ) * width + bound * time < y →
      fields j y time = (fun _ : Fin 1 => states (j + 1)) := by
    intro j y time htime hy
    funext p
    exact leveque04_burgersSelectedField_right_of_cone
      (states j) (states (j + 1)) bound
      (y - (origin + (j : ℝ) * width)) time
      (hstates j) (hstates (j + 1)) htime.1 (by linarith)
  have hfinite := riemannChain_pointwise_finite_of_noninteraction
    (fun j (_ : Fin 1) => states j) fields
    (fun _ => -bound) (fun _ => bound)
    origin width horizon step hwidth hstep hbefore
    hspeeds hinteraction hleft hright
  unfold leveque04_burgersBilateralEvolution leveque04_reaBilateralEvolution
  exact bilateralRiemannChainEvolution_initial_eq_cell_state
    (fun j (_ : Fin 1) => states j) fields origin width step
    hwidth hstep hfinite
    (by
      intro j y hy
      exact hleft j y 0 ⟨le_refl _, hstep.trans hbefore.le⟩
        (by simpa only [mul_zero, add_zero] using hy))
    (by
      intro j y hy
      exact hright j y 0 ⟨le_refl _, hstep.trans hbefore.le⟩
        (by simpa only [mul_zero, add_zero] using hy))
    cell x hx

/-- The initial mass of every cell in the constructed nonlinear field is
its prescribed constant state times the uniform cell width. -/
theorem leveque04_burgersBilateralEvolution_initialCellMass
    (states : ℤ → ℝ) (origin width bound horizon step : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hstates : ∀ j, -bound ≤ states j ∧ states j ≤ bound)
    (hstep : 0 ≤ step) (hbefore : step < horizon)
    (hCFL : 2 * bound * horizon ≤ width) (cell : ℤ) :
    (∫ x in (origin + (cell : ℝ) * width)..
        (origin + ((cell + 1 : ℤ) : ℝ) * width),
      leveque04_burgersBilateralEvolution states origin width bound horizon step
        hwidth hbound hstates hstep hbefore hCFL x 0) =
      width • (fun _ : Fin 1 => states (cell + 1)) := by
  unfold leveque04_burgersBilateralEvolution
  apply leveque04_reaBilateralEvolution_initialCellMass
    (fun j (_ : Fin 1) => states j)
    (leveque04_burgersBilateralField states origin width)
    (fun _ => -bound) (fun _ => bound)
    origin width horizon step hwidth hstep hbefore

/-- The initial normalized cell average of the selected nonlinear
evolution reproduces its prescribed old cell state. -/
theorem leveque04_burgersBilateralEvolution_initialCellAverage
    (states : ℤ → ℝ) (origin width bound horizon step : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hstates : ∀ j, -bound ≤ states j ∧ states j ≤ bound)
    (hstep : 0 ≤ step) (hbefore : step < horizon)
    (hCFL : 2 * bound * horizon ≤ width) (cell : ℤ) :
    oneDimensionalCellAverage
      (fun x => leveque04_burgersBilateralEvolution states origin width bound
        horizon step hwidth hbound hstates hstep hbefore hCFL x 0)
      (origin + (cell : ℝ) * width)
      (origin + ((cell + 1 : ℤ) : ℝ) * width) =
      (fun _ : Fin 1 => states (cell + 1)) := by
  have hmass := leveque04_burgersBilateralEvolution_initialCellMass
    states origin width bound horizon step hwidth hbound hstates hstep
    hbefore hCFL cell
  have hlength :
      (origin + ((cell + 1 : ℤ) : ℝ) * width) -
        (origin + (cell : ℝ) * width) = width := by
    push_cast
    ring
  unfold oneDimensionalCellAverage
  rw [hlength, hmass]
  simp [smul_smul, hwidth.ne']

/-- Averaging the constructed Burgers evolution gives the conservative
finite-volume step with its physical time-averaged face fluxes. -/
theorem leveque04_burgersBilateralEvolution_cellAverageStep
    (states : ℤ → ℝ) (origin width bound horizon step : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hstates : ∀ j, -bound ≤ states j ∧ states j ≤ bound)
    (hstep : 0 < step) (hbefore : step < horizon)
    (hCFL : 2 * bound * horizon ≤ width) (cell : ℤ) :
    let q := leveque04_burgersBilateralEvolution states origin width bound
      horizon step hwidth hbound hstates hstep.le hbefore hCFL
    let a := origin + (cell : ℝ) * width
    let b := origin + ((cell + 1 : ℤ) : ℝ) * width
    let flux : (Fin 1 → ℝ) → Fin 1 → ℝ :=
      fun state _ => (state 0) ^ 2 / 2
    oneDimensionalCellAverage (fun x => q x step) a b =
      (fun _ : Fin 1 => states (cell + 1)) - (step / width) •
        (oneDimensionalCellAverage (fun time => flux (q b time)) 0 step -
          oneDimensionalCellAverage (fun time => flux (q a time)) 0 step) := by
  dsimp only
  let q := leveque04_burgersBilateralEvolution states origin width bound
    horizon step hwidth hbound hstates hstep.le hbefore hCFL
  let a := origin + (cell : ℝ) * width
  let b := origin + ((cell + 1 : ℤ) : ℝ) * width
  let flux : (Fin 1 → ℝ) → Fin 1 → ℝ :=
    fun state _ => (state 0) ^ 2 / 2
  have hlength : b - a = width := by
    dsimp [a, b]
    push_cast
    ring
  have hab : a < b := by linarith
  have hq : LocalConservationLaw.RectangleReferenceOn q flux a b step := by
    exact leveque04_burgersBilateralEvolution_rectangleReferenceOn
      states origin width bound horizon step a b hwidth hbound hstates
      hstep.le hbefore hCFL hab.le
  have hinitial : oneDimensionalCellAverage (fun x => q x 0) a b =
      (fun _ : Fin 1 => states (cell + 1)) := by
    exact leveque04_burgersBilateralEvolution_initialCellAverage
      states origin width bound horizon step hwidth hbound hstates
      hstep.le hbefore hCFL cell
  have hresult := rectangleReferenceOn_cellAverage_step_of_initial q flux
    (fun _ : Fin 1 => states (cell + 1)) a b step a b hq
    ⟨le_refl _, hab.le⟩ ⟨hab.le, le_refl _⟩ hab hstep hinitial
  rw [hlength] at hresult
  exact hresult

/-- At each positive time before interaction, the actual bilateral field
selects the local Burgers Riemann profile at its own interface. -/
theorem leveque04_burgersBilateralEvolution_face_profile
    (states : ℤ → ℝ) (origin width bound horizon step time : ℝ)
    (hwidth : 0 < width) (hbound : 0 < bound)
    (hstates : ∀ j, -bound ≤ states j ∧ states j ≤ bound)
    (hstep : 0 ≤ step) (hbefore : step < horizon)
    (hCFL : 2 * bound * horizon ≤ width)
    (htime : 0 < time) (htimeStep : time ≤ step) (j : ℤ) :
    leveque04_burgersBilateralEvolution states origin width bound horizon step
      hwidth hbound.le hstates hstep hbefore hCFL
      (origin + (j : ℝ) * width) time =
    leveque04_burgersBilateralField states origin width j
      (origin + (j : ℝ) * width) time := by
  unfold leveque04_burgersBilateralEvolution leveque04_reaBilateralEvolution
  apply bilateralRiemannChainEvolution_eq_profile
    (fun k (_ : Fin 1) => states k)
    (leveque04_burgersBilateralField states origin width)
    step _ (origin + (j : ℝ) * width) time
    ⟨htime.le, htimeStep⟩ j
  · intro k hk
    have hkj : (k : ℝ) + 1 ≤ (j : ℝ) := by
      exact_mod_cast (show k + 1 ≤ j by omega)
    have hdist := mul_le_mul_of_nonneg_right hkj hwidth.le
    have htravel : bound * time < bound * horizon :=
      mul_lt_mul_of_pos_left (lt_of_le_of_lt htimeStep hbefore) hbound
    funext p
    exact leveque04_burgersSelectedField_right_of_cone
      (states k) (states (k + 1)) bound
      ((origin + (j : ℝ) * width) - (origin + (k : ℝ) * width)) time
      (hstates k) (hstates (k + 1)) htime.le (by nlinarith)
  · intro k hk
    have hjk : (j : ℝ) + 1 ≤ (k : ℝ) := by
      exact_mod_cast (show j + 1 ≤ k by omega)
    have hdist := mul_le_mul_of_nonneg_right hjk hwidth.le
    have htravel : bound * time < bound * horizon :=
      mul_lt_mul_of_pos_left (lt_of_le_of_lt htimeStep hbefore) hbound
    funext p
    exact leveque04_burgersSelectedField_left_of_cone
      (states k) (states (k + 1)) bound
      ((origin + (j : ℝ) * width) - (origin + (k : ℝ) * width)) time
      (hstates k) (hstates (k + 1)) htime.le (by nlinarith)

/-- The physical time-average at a face of the actual bilateral field is
the time-average of its selected local Burgers Riemann solution. -/
theorem leveque04_burgersBilateralEvolution_faceFluxAverage
    (states : ℤ → ℝ) (origin width bound horizon step : ℝ)
    (hwidth : 0 < width) (hbound : 0 < bound)
    (hstates : ∀ j, -bound ≤ states j ∧ states j ≤ bound)
    (hstep : 0 < step) (hbefore : step < horizon)
    (hCFL : 2 * bound * horizon ≤ width) (j : ℤ) :
    let q := leveque04_burgersBilateralEvolution states origin width bound
      horizon step hwidth hbound.le hstates hstep.le hbefore hCFL
    oneDimensionalCellAverage
      (fun time (_ : Fin 1) => (q (origin + (j : ℝ) * width) time 0) ^ 2 / 2)
      0 step =
    oneDimensionalCellAverage
      (fun time (_ : Fin 1) =>
        (leveque04_burgersSelectedField (states j) (states (j + 1)) 0 time) ^ 2 / 2)
      0 step := by
  dsimp only
  have hface (time : ℝ) (htime : time ∈ Set.uIoc 0 step) :
      leveque04_burgersBilateralEvolution states origin width bound horizon step
        hwidth hbound.le hstates hstep.le hbefore hCFL
        (origin + (j : ℝ) * width) time 0 =
      leveque04_burgersSelectedField (states j) (states (j + 1)) 0 time := by
    have ht : 0 < time ∧ time ≤ step := by
      simpa only [Set.uIoc_of_le hstep.le, Set.mem_Ioc] using htime
    rw [leveque04_burgersBilateralEvolution_face_profile states origin width
      bound horizon step time hwidth hbound hstates hstep.le hbefore hCFL
      ht.1 ht.2 j]
    simp [leveque04_burgersBilateralField]
  unfold oneDimensionalCellAverage
  congr 1
  apply intervalIntegral.integral_congr_ae
  exact Filter.Eventually.of_forall (fun time htime => by
    funext p
    rw [hface time htime])

/-- The time-averaged physical flux at a face of the actual bilateral
Burgers evolution is the selected Godunov numerical interface flux. -/
theorem leveque04_burgersBilateralEvolution_faceFlux_eq_selected
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (hburgers : ∀ u : ℝ,
      law.physicalFlux (fun _ : Fin 1 => u) 0 = u ^ 2 / 2)
    (states : ℤ → ℝ) (origin width bound horizon step : ℝ)
    (hwidth : 0 < width) (hbound : 0 < bound)
    (hstates : ∀ j, -bound ≤ states j ∧ states j ≤ bound)
    (hstep : 0 < step) (hbefore : step < horizon)
    (hCFL : 2 * bound * horizon ≤ width) (j : ℤ) :
    let q := leveque04_burgersBilateralEvolution states origin width bound
      horizon step hwidth hbound.le hstates hstep.le hbefore hCFL
    let problem : HyperbolicRiemannProblem law :=
      ⟨fun _ : Fin 1 => states j, fun _ : Fin 1 => states (j + 1)⟩
    let method := leveque04_burgersSelectedFluxMethod law hburgers step hstep
    oneDimensionalCellAverage
      (fun time => law.physicalFlux (q (origin + (j : ℝ) * width) time))
      0 step =
    method.numericalFluxFromInformation
      (method.extractInformation (method.solve problem trivial)) := by
  dsimp only
  rw [leveque04_burgersSelectedFlux_eq_timeAverage law hburgers
    ⟨fun _ : Fin 1 => states j, fun _ : Fin 1 => states (j + 1)⟩ step hstep]
  rw [leveque04_burgersPhysicalFlux_eq law hburgers]
  simpa only using
    (leveque04_burgersBilateralEvolution_faceFluxAverage states origin width
      bound horizon step hwidth hbound hstates hstep hbefore hCFL j)

/-- With the old array indexed by cell centers, the selected interface
method's flux is exactly the constructed bilateral field's physical face
time average. -/
theorem leveque04_burgersBilateralEvolution_faceFlux_eq_method
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (hburgers : ∀ u : ℝ,
      law.physicalFlux (fun _ : Fin 1 => u) 0 = u ^ 2 / 2)
    (states : ℤ → ℝ) (origin width bound horizon step : ℝ)
    (hwidth : 0 < width) (hbound : 0 < bound)
    (hstates : ∀ j, -bound ≤ states j ∧ states j ≤ bound)
    (hstep : 0 < step) (hbefore : step < horizon)
    (hCFL : 2 * bound * horizon ≤ width) (j : ℤ) :
    let q := leveque04_burgersBilateralEvolution states origin width bound
      horizon step hwidth hbound.le hstates hstep.le hbefore hCFL
    let old : ℤ → Fin 1 → ℝ := fun i _ => states (i + 1)
    let method := leveque04_burgersSelectedFluxMethod law hburgers step hstep
    oneDimensionalCellAverage
      (fun time => law.physicalFlux (q (origin + (j : ℝ) * width) time))
      0 step =
    rectangleRiemannInterfaceFlux method old (fun _ => trivial) j := by
  dsimp only
  rw [leveque04_burgersBilateralEvolution_faceFlux_eq_selected law hburgers
    states origin width bound horizon step hwidth hbound hstates hstep
    hbefore hCFL j]
  simp only [rectangleRiemannInterfaceFlux,
    adjacentCellRectangleRiemannInformation, adjacentCellRiemannProblem]
  congr 3
  all_goals
    have hj : j - 1 + 1 = j := by omega
    simp only [hj]

/-- The constructed nonlinear REA step equals the certified selected
Burgers Godunov flux-difference update before neighboring fans interact. -/
theorem leveque04_burgersBilateralEvolution_eq_selectedGodunovStep
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (hburgers : ∀ u : ℝ,
      law.physicalFlux (fun _ : Fin 1 => u) 0 = u ^ 2 / 2)
    (states : ℤ → ℝ) (origin width bound horizon step : ℝ)
    (hwidth : 0 < width) (hbound : 0 < bound)
    (hstates : ∀ j, -bound ≤ states j ∧ states j ≤ bound)
    (hstep : 0 < step) (hbefore : step < horizon)
    (hCFL : 2 * bound * horizon ≤ width) (cell : ℤ) :
    let q := leveque04_burgersBilateralEvolution states origin width bound
      horizon step hwidth hbound.le hstates hstep.le hbefore hCFL
    let old : ℤ → Fin 1 → ℝ := fun i _ => states (i + 1)
    let method := leveque04_burgersSelectedFluxMethod law hburgers step hstep
    let faceFlux := rectangleRiemannInterfaceFlux method old (fun _ => trivial)
    oneDimensionalCellAverage (fun x => q x step)
      (origin + (cell : ℝ) * width)
      (origin + ((cell + 1 : ℤ) : ℝ) * width) =
    conservativeFluxDifferenceUpdateInt (step / width) old faceFlux cell := by
  dsimp only
  let q := leveque04_burgersBilateralEvolution states origin width bound
    horizon step hwidth hbound.le hstates hstep.le hbefore hCFL
  let old : ℤ → Fin 1 → ℝ := fun i _ => states (i + 1)
  let method := leveque04_burgersSelectedFluxMethod law hburgers step hstep
  let faceFlux := rectangleRiemannInterfaceFlux method old (fun _ => trivial)
  have hface (j : ℤ) :
      oneDimensionalCellAverage
        (fun time (_ : Fin 1) =>
          (q (origin + (j : ℝ) * width) time 0) ^ 2 / 2) 0 step =
        faceFlux j := by
    simpa only [leveque04_burgersPhysicalFlux_eq law hburgers] using
      (leveque04_burgersBilateralEvolution_faceFlux_eq_method law hburgers
        states origin width bound horizon step hwidth hbound hstates hstep
        hbefore hCFL j)
  have hstepEq := leveque04_burgersBilateralEvolution_cellAverageStep
    states origin width bound horizon step hwidth hbound.le hstates
    hstep hbefore hCFL cell
  dsimp only at hstepEq
  rw [hface cell] at hstepEq
  have hright :
      oneDimensionalCellAverage
        (fun time (_ : Fin 1) =>
          (q (origin + ((cell + 1 : ℤ) : ℝ) * width) time 0) ^ 2 / 2)
        0 step = faceFlux (cell + 1) := by
    simpa only using hface (cell + 1)
  rw [hright] at hstepEq
  simpa only [conservativeFluxDifferenceUpdateInt, old, faceFlux] using hstepEq

/-- In the scalar coordinate, the constructed nonlinear REA average is
the selected two-state Burgers Godunov stencil. -/
theorem leveque04_burgersBilateralEvolution_scalarGodunovStep
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (hburgers : ∀ u : ℝ,
      law.physicalFlux (fun _ : Fin 1 => u) 0 = u ^ 2 / 2)
    (states : ℤ → ℝ) (origin width bound horizon step : ℝ)
    (hwidth : 0 < width) (hbound : 0 < bound)
    (hstates : ∀ j, -bound ≤ states j ∧ states j ≤ bound)
    (hstep : 0 < step) (hbefore : step < horizon)
    (hCFL : 2 * bound * horizon ≤ width) (cell : ℤ) :
    (oneDimensionalCellAverage
      (fun x => leveque04_burgersBilateralEvolution states origin width bound
        horizon step hwidth hbound.le hstates hstep.le hbefore hCFL x step)
      (origin + (cell : ℝ) * width)
      (origin + ((cell + 1 : ℤ) : ℝ) * width)) 0 =
    states (cell + 1) - step / width *
      ((leveque04_burgersSelectedInterfaceState
          (states (cell + 1)) (states (cell + 2))) ^ 2 / 2 -
        (leveque04_burgersSelectedInterfaceState
          (states cell) (states (cell + 1))) ^ 2 / 2) := by
  let old : ℤ → Fin 1 → ℝ := fun i _ => states (i + 1)
  let method := leveque04_burgersSelectedFluxMethod law hburgers step hstep
  let faceFlux := rectangleRiemannInterfaceFlux method old (fun _ => trivial)
  have hface (j : ℤ) : (faceFlux j) 0 =
      (leveque04_burgersSelectedInterfaceState (states j) (states (j + 1))) ^ 2 / 2 := by
    have hscalar := leveque04_burgersSelectedFlux_scalar law hburgers
      ⟨fun _ : Fin 1 => states j, fun _ : Fin 1 => states (j + 1)⟩
      step hstep
    dsimp [faceFlux, rectangleRiemannInterfaceFlux,
      adjacentCellRectangleRiemannInformation, adjacentCellRiemannProblem, old]
    convert hscalar using 1
    congr 3
    all_goals
      have hj : j - 1 + 1 = j := by omega
      simp only [hj]
  have hstepEq := leveque04_burgersBilateralEvolution_eq_selectedGodunovStep
    law hburgers states origin width bound horizon step hwidth hbound hstates
    hstep hbefore hCFL cell
  dsimp only at hstepEq
  rw [conservativeFluxDifferenceUpdateInt] at hstepEq
  have hcoord := congrArg (fun v : Fin 1 → ℝ => v 0) hstepEq
  simp only [Pi.sub_apply, Pi.smul_apply, smul_eq_mul] at hcoord
  have hleft := hface cell
  have hright := hface (cell + 1)
  dsimp only [faceFlux, method, old] at hleft hright
  rw [hleft, hright] at hcoord
  simpa only [old, add_assoc] using hcoord

/-- A periodic array lifted to the integer line has a concrete bilateral
Burgers REA step equal to the evaluated periodic Godunov step. -/
theorem leveque04_burgersBilateralEvolution_periodicStep
    (n : ℕ) [NeZero n]
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (hburgers : ∀ u : ℝ,
      law.physicalFlux (fun _ : Fin 1 => u) 0 = u ^ 2 / 2)
    (u : ZMod n → ℝ) (origin width bound horizon step : ℝ)
    (hwidth : 0 < width) (hbound : 0 < bound)
    (hu : ∀ i, -bound ≤ u i ∧ u i ≤ bound)
    (hstep : 0 < step) (hbefore : step < horizon)
    (hCFL : 2 * bound * horizon ≤ width) (cell : ℤ) :
    let states : ℤ → ℝ := fun j => u (j : ZMod n)
    (oneDimensionalCellAverage
      (fun x => leveque04_burgersBilateralEvolution states origin width bound
        horizon step hwidth hbound.le (fun j => hu (j : ZMod n))
        hstep.le hbefore hCFL x step)
      (origin + (cell : ℝ) * width)
      (origin + ((cell + 1 : ℤ) : ℝ) * width)) 0 =
    leveque04_burgersGodunovStep n (step / width) u ((cell + 1 : ℤ) : ZMod n) := by
  dsimp only
  have h := leveque04_burgersBilateralEvolution_scalarGodunovStep law hburgers
    (fun j : ℤ => u (j : ZMod n)) origin width bound horizon step hwidth hbound
    (fun j => hu (j : ZMod n)) hstep hbefore hCFL cell
  have hidx : ((cell + 2 : ℤ) : ZMod n) = ((cell + 1 : ℤ) : ZMod n) + 1 := by
    push_cast
    ring
  rw [hidx] at h
  simpa only [leveque04_burgersGodunovStep, finitePeriodicTwoStateFluxStep,
    finitePeriodicFluxDifferenceUpdate, Equiv.coe_addRight,
    add_sub_cancel_right, Int.cast_add, Int.cast_one, Int.cast_sub,
    sub_add_cancel, add_sub_cancel_left] using h

/-- Every step of a periodic orbit generated by the concrete bilateral
Burgers REA construction is the evaluated Godunov step. -/
theorem leveque04_burgersBilateralEvolution_periodicOrbitStep
    (n : ℕ) [NeZero n]
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (hburgers : ∀ u : ℝ,
      law.physicalFlux (fun _ : Fin 1 => u) 0 = u ^ 2 / 2)
    (approx : ℕ → ZMod n → ℝ) (origin width bound horizon step : ℝ)
    (hwidth : 0 < width) (hbound : 0 < bound)
    (hstates : ∀ k i, -bound ≤ approx k i ∧ approx k i ≤ bound)
    (hstep : 0 < step) (hbefore : step < horizon)
    (hCFL : 2 * bound * horizon ≤ width)
    (hrea : ∀ k i,
      let cell : ℤ := (i.val : ℤ) - 1
      let states : ℤ → ℝ := fun j => approx k (j : ZMod n)
      approx (k + 1) i =
        (oneDimensionalCellAverage
          (fun x => leveque04_burgersBilateralEvolution states origin width
            bound horizon step hwidth hbound.le
            (fun j => hstates k (j : ZMod n)) hstep.le hbefore hCFL x step)
          (origin + (cell : ℝ) * width)
          (origin + ((cell + 1 : ℤ) : ℝ) * width)) 0) :
    ∀ k i, approx (k + 1) i =
      leveque04_burgersGodunovStep n (step / width) (approx k) i := by
  intro k i
  have h := leveque04_burgersBilateralEvolution_periodicStep n law hburgers
    (approx k) origin width bound horizon step hwidth hbound (hstates k)
    hstep hbefore hCFL ((i.val : ℤ) - 1)
  dsimp only at h
  have hi : ((((i.val : ℤ) - 1) + 1 : ℤ) : ZMod n) = i := by
    simpa only [sub_add_cancel, Int.cast_natCast] using ZMod.natCast_zmod_val i
  rw [hi] at h
  exact (hrea k i).trans h

/-- The canonical periodic Burgers orbit is the iterate of its evaluated
selected Riemann-flux update. -/
noncomputable def leveque04_burgersPeriodicREAOrbit
    (n : ℕ) [NeZero n] (ratio : ℝ) (initial : ZMod n → ℝ) :
    ℕ → ZMod n → ℝ :=
  fun k => (fun u i => leveque04_burgersGodunovStep n ratio u i)^[k] initial

theorem leveque04_burgersPeriodicREAOrbit_step
    (n : ℕ) [NeZero n] (ratio : ℝ) (initial : ZMod n → ℝ)
    (k : ℕ) (i : ZMod n) :
    leveque04_burgersPeriodicREAOrbit n ratio initial (k + 1) i =
      leveque04_burgersGodunovStep n ratio
        (leveque04_burgersPeriodicREAOrbit n ratio initial k) i := by
  simp only [leveque04_burgersPeriodicREAOrbit, Function.iterate_succ_apply']

/-- Every step of the canonical bounded periodic orbit is realized as the
cell average of the constructed bilateral physical Burgers evolution. -/
theorem leveque04_burgersPeriodicREAOrbit_realized
    (n : ℕ) [NeZero n]
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (hburgers : ∀ u : ℝ,
      law.physicalFlux (fun _ : Fin 1 => u) 0 = u ^ 2 / 2)
    (initial : ZMod n → ℝ) (origin width bound horizon step : ℝ)
    (hwidth : 0 < width) (hbound : 0 < bound)
    (hinitial : ∀ i, -bound ≤ initial i ∧ initial i ≤ bound)
    (hstep : 0 < step) (hbefore : step < horizon)
    (hCFL : 2 * bound * horizon ≤ width) (k : ℕ) (i : ZMod n) :
    let orbit := leveque04_burgersPeriodicREAOrbit n (step / width) initial
    let cell : ℤ := (i.val : ℤ) - 1
    let states : ℤ → ℝ := fun j => orbit k (j : ZMod n)
    ∃ hstates : ∀ j, -bound ≤ states j ∧ states j ≤ bound,
      orbit (k + 1) i =
        (oneDimensionalCellAverage
          (fun x => leveque04_burgersBilateralEvolution states origin width
            bound horizon step hwidth hbound.le hstates hstep.le hbefore hCFL x step)
          (origin + (cell : ℝ) * width)
          (origin + ((cell + 1 : ℤ) : ℝ) * width)) 0 := by
  dsimp only
  let orbit := leveque04_burgersPeriodicREAOrbit n (step / width) initial
  have hratio : 0 ≤ step / width := div_nonneg hstep.le hwidth.le
  have hcfl : step / width * (bound + bound) ≤ 1 := by
    have hscaled := mul_le_mul_of_nonneg_left (le_of_lt hbefore)
      (show 0 ≤ bound + bound by linarith)
    have hproduct : step * (bound + bound) ≤ width := by nlinarith [hscaled, hCFL]
    have hdiv : step * (bound + bound) / width ≤ 1 :=
      (div_le_iff₀ hwidth).2 (by simpa using hproduct)
    simpa only [div_mul_eq_mul_div] using hdiv
  have hbounded (j : ZMod n) : -bound ≤ orbit k j ∧ orbit k j ≤ bound := by
    exact leveque04_burgersGodunovStep_orbit_bounds n bound (step / width)
      hbound.le hratio hcfl orbit
      (fun t j => leveque04_burgersPeriodicREAOrbit_step n (step / width) initial t j)
      (by simpa only [orbit, leveque04_burgersPeriodicREAOrbit,
        Function.iterate_zero, id_eq] using hinitial) k j
  refine ⟨fun j => hbounded (j : ZMod n), ?_⟩
  have h := leveque04_burgersBilateralEvolution_periodicStep n law hburgers
    (orbit k) origin width bound horizon step hwidth hbound hbounded
    hstep hbefore hCFL ((i.val : ℤ) - 1)
  dsimp only at h
  have hi : ((((i.val : ℤ) - 1) + 1 : ℤ) : ZMod n) = i := by
    simpa only [sub_add_cancel, Int.cast_natCast] using ZMod.natCast_zmod_val i
  rw [hi] at h
  exact (leveque04_burgersPeriodicREAOrbit_step n (step / width) initial k i).trans
    h.symm

/-- A smooth physical Burgers solution inherits the existing first-order
one-step residual bound for the constructed nonlinear REA evolution when
its three old cell values are exact averages. -/
theorem leveque04_burgersBilateralEvolution_smoothLocalResidual
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (hburgers : ∀ u : ℝ,
      law.physicalFlux (fun _ : Fin 1 => u) 0 = u ^ 2 / 2)
    (states : ℤ → ℝ) (origin width bound horizon step oldTime : ℝ)
    (q : ℝ → ℝ → ℝ) (qX : ℝ → ℝ) (B M K D : ℝ)
    (hwidth : 0 < width) (hbound : 0 < bound)
    (hstates : ∀ j, -bound ≤ states j ∧ states j ≤ bound)
    (hstep : 0 < step) (hbefore : step < horizon)
    (hCFL : 2 * bound * horizon ≤ width)
    (hB : 0 ≤ B) (hM : 0 ≤ M) (hK : 0 ≤ K) (hD : 0 ≤ D)
    (hq : ∀ x, HasDerivAt (fun y => q y oldTime) (qX x) x)
    (hvalue : ∀ x, |q x oldTime| ≤ B)
    (hderiv : ∀ x, |qX x| ≤ M)
    (hLip : ∀ x y, |qX x - qX y| ≤ K * |x - y|)
    (hTime : ∀ center τ σ,
      |leveque04_burgersPhysicalFaceDivergence q center width τ -
        leveque04_burgersPhysicalFaceDivergence q center width σ| ≤
        D * |τ - σ|)
    (cell : ℤ)
    (hsample :
      let center := origin + (cell : ℝ) * width + width / 2
      let avg := fun c => oneDimensionalCellAverage (fun x => q x oldTime)
        (c - width / 2) (c + width / 2)
      states cell = avg (center - width) ∧
      states (cell + 1) = avg center ∧
      states (cell + 2) = avg (center + width))
    (hbalance :
      let center := origin + (cell : ℝ) * width + width / 2
      (∫ x in center - width / 2..center + width / 2,
        q x (oldTime + step)) -
        (∫ x in center - width / 2..center + width / 2,
          q x oldTime) =
        ∫ τ in oldTime..oldTime + step,
          (q (center - width / 2) τ ^ 2 / 2 -
            q (center + width / 2) τ ^ 2 / 2)) :
    let center := origin + (cell : ℝ) * width + width / 2
    |((oneDimensionalCellAverage
        (fun x => leveque04_burgersBilateralEvolution states origin width
          bound horizon step hwidth hbound.le hstates hstep.le hbefore hCFL x step)
        (origin + (cell : ℝ) * width)
        (origin + ((cell + 1 : ℤ) : ℝ) * width)) 0 -
      oneDimensionalCellAverage (fun x => q x (oldTime + step))
        (center - width / 2) (center + width / 2)) / step| ≤
      (3 * (B * K + M ^ 2) + M ^ 2) * width + D * step := by
  dsimp only at hsample hbalance ⊢
  let center := origin + (cell : ℝ) * width + width / 2
  let avg := fun τ c => oneDimensionalCellAverage (fun x => q x τ)
    (c - width / 2) (c + width / 2)
  have hlocal := leveque04_burgersGodunov_mixed_exactAverage_localTruncation
    q qX B M K D center width oldTime step hB hM hK hD hwidth hstep
    hq hvalue hderiv hLip (hTime center) hbalance
  dsimp only at hlocal
  have hrea := leveque04_burgersBilateralEvolution_scalarGodunovStep
    law hburgers states origin width bound horizon step hwidth hbound
    hstates hstep hbefore hCFL cell
  have hleft : origin + (cell : ℝ) * width = center - width / 2 := by
    dsimp [center]
    ring
  have hright : origin + ((cell + 1 : ℤ) : ℝ) * width =
      center + width / 2 := by
    dsimp [center]
    push_cast
    ring
  rw [hleft, hright] at hrea
  rw [← hsample.1, ← hsample.2.1, ← hsample.2.2] at hlocal
  rw [← hrea] at hlocal
  have hnum :
      (oneDimensionalCellAverage
        (fun x => leveque04_burgersBilateralEvolution states origin width
          bound horizon step hwidth hbound.le hstates hstep.le hbefore hCFL x step)
        (origin + (cell : ℝ) * width)
        (origin + ((cell + 1 : ℤ) : ℝ) * width)) 0 =
      (oneDimensionalCellAverage
        (fun x => leveque04_burgersBilateralEvolution states origin width
          bound horizon step hwidth hbound.le hstates hstep.le hbefore hCFL x step)
        (center - width / 2) (center + width / 2)) 0 := by
    rw [hleft, hright]
  rw [hnum]
  exact hlocal

/-- The periodic orbit of concrete selected Burgers REA evolutions inherits
the fixed-horizon mean L1 error bound against smooth physical cell averages. -/
theorem leveque04_burgersBilateralEvolution_periodic_fixedHorizonMeanError
    (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (hburgers : ∀ u : ℝ,
      law.physicalFlux (fun _ : Fin 1 => u) 0 = u ^ 2 / 2)
    (q qX : ℝ → ℝ → ℝ)
    (B M K D origin width startTime timeStep localHorizon horizon : ℝ)
    (hB : 0 < B) (hM : 0 ≤ M) (hK : 0 ≤ K) (hD : 0 ≤ D)
    (hwidth : 0 < width) (htime : 0 < timeStep)
    (hbefore : timeStep < localHorizon)
    (hCFL : 2 * B * localHorizon ≤ width)
    (approx : ℕ → ZMod n → ℝ) (steps : ℕ)
    (hstates : ∀ k i, -B ≤ approx k i ∧ approx k i ≤ B)
    (hrea : ∀ k i,
      let cell : ℤ := (i.val : ℤ) - 1
      let states : ℤ → ℝ := fun j => approx k (j : ZMod n)
      approx (k + 1) i =
        (oneDimensionalCellAverage
          (fun x => leveque04_burgersBilateralEvolution states origin width
            B localHorizon timeStep hwidth hB.le
            (fun j => hstates k (j : ZMod n)) htime.le hbefore hCFL x timeStep)
          (origin + (cell : ℝ) * width)
          (origin + ((cell + 1 : ℤ) : ℝ) * width)) 0)
    (hq : ∀ k ≤ steps, ∀ x,
      HasDerivAt (fun y => q y (startTime + (k : ℝ) * timeStep))
        (qX x (startTime + (k : ℝ) * timeStep)) x)
    (hperiod : ∀ k < steps, ∀ x,
      q (x + (n : ℝ) * width) (startTime + (k : ℝ) * timeStep) =
        q x (startTime + (k : ℝ) * timeStep))
    (hvalue : ∀ k ≤ steps, ∀ x,
      |q x (startTime + (k : ℝ) * timeStep)| ≤ B)
    (hderiv : ∀ k < steps, ∀ x,
      |qX x (startTime + (k : ℝ) * timeStep)| ≤ M)
    (hLip : ∀ k < steps, ∀ x y,
      |qX x (startTime + (k : ℝ) * timeStep) -
        qX y (startTime + (k : ℝ) * timeStep)| ≤ K * |x - y|)
    (hTime : ∀ center τ σ,
      |leveque04_burgersPhysicalFaceDivergence q center width τ -
        leveque04_burgersPhysicalFaceDivergence q center width σ| ≤ D * |τ - σ|)
    (hbalance : ∀ k < steps, ∀ center,
      (∫ x in center - width / 2..center + width / 2,
        q x (startTime + (k : ℝ) * timeStep + timeStep)) -
          (∫ x in center - width / 2..center + width / 2,
            q x (startTime + (k : ℝ) * timeStep)) =
        ∫ τ in startTime + (k : ℝ) * timeStep..startTime + (k : ℝ) * timeStep + timeStep,
          (q (center - width / 2) τ ^ 2 / 2 - q (center + width / 2) τ ^ 2 / 2))
    (hhorizon : (steps : ℝ) * timeStep ≤ horizon) :
    let exact := fun (k : ℕ) i => leveque04_periodicVectorExactCellAverage n
      (fun x τ (_ : Fin 1) => q x τ) width (startTime + (k : ℝ) * timeStep) i 0
    (∑ i, |approx steps i - exact steps i|) / (Fintype.card (ZMod n) : ℝ) ≤
      (∑ i, |approx 0 i - exact 0 i|) / (Fintype.card (ZMod n) : ℝ) +
        horizon * ((3 * (B * K + M ^ 2) + M ^ 2) +
          D * (timeStep / width)) * width := by
  have happrox := leveque04_burgersBilateralEvolution_periodicOrbitStep
    n law hburgers approx origin width B localHorizon timeStep hwidth hB
    hstates htime hbefore hCFL hrea
  have hcfl : timeStep / width * (B + B) ≤ 1 := by
    have hscaled := mul_le_mul_of_nonneg_left (le_of_lt hbefore)
      (show 0 ≤ B + B by linarith)
    have hproduct : timeStep * (B + B) ≤ width := by nlinarith [hscaled, hCFL]
    have hdiv : timeStep * (B + B) / width ≤ 1 :=
      (div_le_iff₀ hwidth).2 (by simpa using hproduct)
    simpa only [div_mul_eq_mul_div] using hdiv
  exact leveque04_burgersGodunov_mixed_periodic_fixedHorizonMeanError
    n hn q qX B M K D width startTime timeStep horizon hB.le hM hK hD
    hwidth htime hcfl approx steps happrox (hstates 0) hq hperiod hvalue
    hderiv hLip hTime hbalance hhorizon

/-- From bounded initial data, the canonical periodic selected Burgers orbit
has a physical bilateral REA realization at every step and the smooth
fixed-horizon mean L1 first-order estimate. -/
theorem leveque04_burgersPeriodicREAOrbit_constructed_fixedHorizonMeanError
    (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (hburgers : ∀ u : ℝ,
      law.physicalFlux (fun _ : Fin 1 => u) 0 = u ^ 2 / 2)
    (initial : ZMod n → ℝ) (q qX : ℝ → ℝ → ℝ)
    (B M K D origin width startTime timeStep localHorizon horizon : ℝ)
    (hB : 0 < B) (hM : 0 ≤ M) (hK : 0 ≤ K) (hD : 0 ≤ D)
    (hwidth : 0 < width) (htime : 0 < timeStep)
    (hbefore : timeStep < localHorizon)
    (hCFL : 2 * B * localHorizon ≤ width)
    (hinitial : ∀ i, -B ≤ initial i ∧ initial i ≤ B)
    (steps : ℕ)
    (hq : ∀ k ≤ steps, ∀ x,
      HasDerivAt (fun y => q y (startTime + (k : ℝ) * timeStep))
        (qX x (startTime + (k : ℝ) * timeStep)) x)
    (hperiod : ∀ k < steps, ∀ x,
      q (x + (n : ℝ) * width) (startTime + (k : ℝ) * timeStep) =
        q x (startTime + (k : ℝ) * timeStep))
    (hvalue : ∀ k ≤ steps, ∀ x,
      |q x (startTime + (k : ℝ) * timeStep)| ≤ B)
    (hderiv : ∀ k < steps, ∀ x,
      |qX x (startTime + (k : ℝ) * timeStep)| ≤ M)
    (hLip : ∀ k < steps, ∀ x y,
      |qX x (startTime + (k : ℝ) * timeStep) -
        qX y (startTime + (k : ℝ) * timeStep)| ≤ K * |x - y|)
    (hTime : ∀ center τ σ,
      |leveque04_burgersPhysicalFaceDivergence q center width τ -
        leveque04_burgersPhysicalFaceDivergence q center width σ| ≤ D * |τ - σ|)
    (hbalance : ∀ k < steps, ∀ center,
      (∫ x in center - width / 2..center + width / 2,
        q x (startTime + (k : ℝ) * timeStep + timeStep)) -
          (∫ x in center - width / 2..center + width / 2,
            q x (startTime + (k : ℝ) * timeStep)) =
        ∫ τ in startTime + (k : ℝ) * timeStep..startTime + (k : ℝ) * timeStep + timeStep,
          (q (center - width / 2) τ ^ 2 / 2 - q (center + width / 2) τ ^ 2 / 2))
    (hhorizon : (steps : ℝ) * timeStep ≤ horizon) :
    let orbit := leveque04_burgersPeriodicREAOrbit n (timeStep / width) initial
    let exact := fun (k : ℕ) i => leveque04_periodicVectorExactCellAverage n
      (fun x τ (_ : Fin 1) => q x τ) width (startTime + (k : ℝ) * timeStep) i 0
    (∀ k i,
      let cell : ℤ := (i.val : ℤ) - 1
      let states : ℤ → ℝ := fun j => orbit k (j : ZMod n)
      ∃ hstates : ∀ j, -B ≤ states j ∧ states j ≤ B,
        orbit (k + 1) i =
          (oneDimensionalCellAverage
            (fun x => leveque04_burgersBilateralEvolution states origin width
              B localHorizon timeStep hwidth hB.le hstates htime.le hbefore hCFL
              x timeStep)
            (origin + (cell : ℝ) * width)
            (origin + ((cell + 1 : ℤ) : ℝ) * width)) 0) ∧
      (∑ i, |orbit steps i - exact steps i|) / (Fintype.card (ZMod n) : ℝ) ≤
        (∑ i, |orbit 0 i - exact 0 i|) / (Fintype.card (ZMod n) : ℝ) +
          horizon * ((3 * (B * K + M ^ 2) + M ^ 2) +
            D * (timeStep / width)) * width := by
  dsimp only
  constructor
  · intro k i
    exact leveque04_burgersPeriodicREAOrbit_realized n law hburgers initial
      origin width B localHorizon timeStep hwidth hB hinitial htime hbefore
      hCFL k i
  · have hcfl : timeStep / width * (B + B) ≤ 1 := by
      have hscaled := mul_le_mul_of_nonneg_left (le_of_lt hbefore)
        (show 0 ≤ B + B by linarith)
      have hproduct : timeStep * (B + B) ≤ width := by nlinarith [hscaled, hCFL]
      have hdiv : timeStep * (B + B) / width ≤ 1 :=
        (div_le_iff₀ hwidth).2 (by simpa using hproduct)
      simpa only [div_mul_eq_mul_div] using hdiv
    exact leveque04_burgersGodunov_mixed_periodic_fixedHorizonMeanError
      n hn q qX B M K D width startTime timeStep horizon hB.le hM hK hD
      hwidth htime hcfl
      (leveque04_burgersPeriodicREAOrbit n (timeStep / width) initial) steps
      (fun k i => leveque04_burgersPeriodicREAOrbit_step n
        (timeStep / width) initial k i)
      (by simpa only [leveque04_burgersPeriodicREAOrbit,
        Function.iterate_zero, id_eq] using hinitial)
      hq hperiod hvalue hderiv hLip hTime hbalance hhorizon

end NumStability
