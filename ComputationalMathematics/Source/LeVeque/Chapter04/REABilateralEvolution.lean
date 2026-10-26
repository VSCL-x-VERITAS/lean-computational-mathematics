/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RiemannProfileInitialTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BilateralRiemannChainNoninteraction
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BilateralRiemannChainInitialTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRectangleCellAverage

/-!
# Bilateral reconstruction, evolution and averaging

The actual integer-indexed field is assembled from compatible finite windows
of the given local Riemann profiles. Its window finiteness is derived from
ordered affine exterior fronts and adjacent noninteraction, without a global
speed bound. The closed evolution step lies strictly before a comparison
noninteraction horizon. This margin is part of every statement.

Constituent physical and entropy balances transfer to the constructed field.
Its initial open cells have the reconstructed states, its cell averages obey
the conservative update with the actual physical face fluxes, and its initial
trace follows from the exterior states away from grid interfaces. Values on
interfaces are not prescribed by reconstruction. These conditional results
do not assert existence or uniqueness of local Riemann solutions.
-/

open MeasureTheory Filter
open scoped Topology
namespace NumStability

/-- The actual bilateral REA field, with finite windows derived from noninteraction. -/
noncomputable def leveque04_reaBilateralEvolution
    {E : Type*} [AddCommGroup E] (states : ℤ → E) (fields : ℤ → ℝ → ℝ → E)
    (leftSpeed rightSpeed : ℤ → ℝ) (origin width horizon step : ℝ)
    (hwidth : 0 < width) (hstep : 0 ≤ step) (hbefore : step < horizon)
    (hspeeds : ∀ j, leftSpeed j ≤ rightSpeed j)
    (hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + rightSpeed j * horizon ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * horizon)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      x < origin + (j : ℝ) * width + leftSpeed j * time → fields j x time = states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      origin + (j : ℝ) * width + rightSpeed j * time < x → fields j x time = states (j + 1)) :
    ℝ → ℝ → E :=
  bilateralRiemannChainEvolution states fields step
    (riemannChain_pointwise_finite_of_noninteraction states fields leftSpeed rightSpeed
      origin width horizon step hwidth hstep hbefore hspeeds hinteraction hleft hright)

/-- Constituent physical balances give physical conservation of the constructed field. -/
theorem leveque04_reaBilateralEvolution_rectangleReferenceOn
    {m : ℕ} (states : ℤ → Fin m → ℝ) (fields : ℤ → ℝ → ℝ → Fin m → ℝ)
    (leftSpeed rightSpeed : ℤ → ℝ) (origin width horizon step : ℝ)
    (hwidth : 0 < width) (hstep : 0 ≤ step) (hbefore : step < horizon)
    (hspeeds : ∀ j, leftSpeed j ≤ rightSpeed j)
    (hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + rightSpeed j * horizon ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * horizon)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      x < origin + (j : ℝ) * width + leftSpeed j * time → fields j x time = states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      origin + (j : ℝ) * width + rightSpeed j * time < x → fields j x time = states (j + 1))
    (flux : (Fin m → ℝ) → Fin m → ℝ) (left right : ℝ) (hbox : left ≤ right)
    (hfields : ∀ j, LocalConservationLaw.RectangleReferenceOn (fields j) flux left right step) :
    LocalConservationLaw.RectangleReferenceOn
      (leveque04_reaBilateralEvolution states fields leftSpeed rightSpeed origin width horizon step
        hwidth hstep hbefore hspeeds hinteraction hleft hright) flux left right step := by
  exact bilateralRiemannChain_rectangleReferenceOn_of_noninteraction states fields leftSpeed rightSpeed
    origin width horizon step left right flux hwidth hstep hbefore hbox _ hspeeds hinteraction hfields hleft hright

/-- The reconstructed state determines each initial cell mass; interface values are free. -/
theorem leveque04_reaBilateralEvolution_initialCellMass
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    (states : ℤ → E) (fields : ℤ → ℝ → ℝ → E)
    (leftSpeed rightSpeed : ℤ → ℝ) (origin width horizon step : ℝ)
    (hwidth : 0 < width) (hstep : 0 ≤ step) (hbefore : step < horizon)
    (hspeeds : ∀ j, leftSpeed j ≤ rightSpeed j)
    (hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + rightSpeed j * horizon ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * horizon)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      x < origin + (j : ℝ) * width + leftSpeed j * time → fields j x time = states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      origin + (j : ℝ) * width + rightSpeed j * time < x → fields j x time = states (j + 1))
    (cell : ℤ) :
    (∫ x in (origin + (cell : ℝ) * width)..(origin + ((cell + 1 : ℤ) : ℝ) * width),
      leveque04_reaBilateralEvolution states fields leftSpeed rightSpeed origin width horizon step
        hwidth hstep hbefore hspeeds hinteraction hleft hright x 0) = width • states (cell + 1) := by
  have hzero : (0 : ℝ) ∈ Set.Icc 0 horizon := ⟨le_refl _, hstep.trans hbefore.le⟩
  exact bilateralRiemannChainEvolution_initial_cell_integral states fields origin width step hwidth hstep _
    (fun j x hx => hleft j x 0 hzero (by simpa only [mul_zero, add_zero] using hx))
    (fun j x hx => hright j x 0 hzero (by simpa only [mul_zero, add_zero] using hx)) cell

/-- Averaging the actual evolution gives the conservative update with its physical face fluxes. -/
theorem leveque04_reaBilateralEvolution_cellAverage_step
    {m : ℕ} (states : ℤ → Fin m → ℝ) (fields : ℤ → ℝ → ℝ → Fin m → ℝ)
    (leftSpeed rightSpeed : ℤ → ℝ) (origin width horizon step : ℝ)
    (hwidth : 0 < width) (hstep : 0 < step) (hbefore : step < horizon)
    (hspeeds : ∀ j, leftSpeed j ≤ rightSpeed j)
    (hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + rightSpeed j * horizon ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * horizon)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      x < origin + (j : ℝ) * width + leftSpeed j * time → fields j x time = states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      origin + (j : ℝ) * width + rightSpeed j * time < x → fields j x time = states (j + 1))
    (flux : (Fin m → ℝ) → Fin m → ℝ) (cell : ℤ)
    (hfields : ∀ j, LocalConservationLaw.RectangleReferenceOn (fields j) flux
      (origin + (cell : ℝ) * width) (origin + ((cell + 1 : ℤ) : ℝ) * width) step) :
    let q := leveque04_reaBilateralEvolution states fields leftSpeed rightSpeed origin width horizon step
      hwidth hstep.le hbefore hspeeds hinteraction hleft hright
    oneDimensionalCellAverage (fun x => q x step)
      (origin + (cell : ℝ) * width) (origin + ((cell + 1 : ℤ) : ℝ) * width) =
      states (cell + 1) - (step / width) •
        (oneDimensionalCellAverage (fun time => flux (q (origin + ((cell + 1 : ℤ) : ℝ) * width) time)) 0 step -
          oneDimensionalCellAverage (fun time => flux (q (origin + (cell : ℝ) * width) time)) 0 step) := by
  let q := leveque04_reaBilateralEvolution states fields leftSpeed rightSpeed origin width horizon step
    hwidth hstep.le hbefore hspeeds hinteraction hleft hright
  let a := origin + (cell : ℝ) * width
  let b := origin + ((cell + 1 : ℤ) : ℝ) * width
  have hwidthEq : b - a = width := by dsimp [a, b]; push_cast; ring
  have hab : a < b := by linarith
  have hreference := leveque04_reaBilateralEvolution_rectangleReferenceOn states fields leftSpeed rightSpeed
    origin width horizon step hwidth hstep.le hbefore hspeeds hinteraction hleft hright flux a b hab.le hfields
  have hmass := leveque04_reaBilateralEvolution_initialCellMass states fields leftSpeed rightSpeed
    origin width horizon step hwidth hstep.le hbefore hspeeds hinteraction hleft hright cell
  have hinitial : oneDimensionalCellAverage (fun x => q x 0) a b = states (cell + 1) := by
    change (b - a)⁻¹ • (∫ x in a..b, q x 0) = _
    rw [hwidthEq]
    change width⁻¹ • (∫ x in (origin + (cell : ℝ) * width)..(origin + ((cell + 1 : ℤ) : ℝ) * width),
      leveque04_reaBilateralEvolution states fields leftSpeed rightSpeed origin width horizon step
        hwidth hstep.le hbefore hspeeds hinteraction hleft hright x 0) = _
    rw [hmass]
    simp [smul_smul, hwidth.ne']
  have hresult := rectangleReferenceOn_cellAverage_step_of_initial q flux (states (cell + 1))
    a b step a b hreference ⟨le_refl _, hab.le⟩ ⟨hab.le, le_refl _⟩ hab hstep hinitial
  rw [hwidthEq] at hresult
  exact hresult

/-- The actual evolution inherits every constituent rectangle entropy inequality. -/
theorem leveque04_reaBilateralEvolution_entropy_rectangle
    {E : Type*} [AddCommGroup E] (states : ℤ → E) (fields : ℤ → ℝ → ℝ → E)
    (leftSpeed rightSpeed : ℤ → ℝ) (origin width horizon step : ℝ)
    (hwidth : 0 < width) (hstep : 0 ≤ step) (hbefore : step < horizon)
    (hspeeds : ∀ j, leftSpeed j ≤ rightSpeed j)
    (hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + rightSpeed j * horizon ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * horizon)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      x < origin + (j : ℝ) * width + leftSpeed j * time → fields j x time = states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      origin + (j : ℝ) * width + rightSpeed j * time < x → fields j x time = states (j + 1))
    (entropy entropyFlux : E → ℝ) (a b s t : ℝ)
    (hab : a ≤ b) (hst : s ≤ t) (hs : 0 ≤ s) (ht : t ≤ step)
    (hspace : ∀ j, ∀ τ ∈ ({s, t} : Set ℝ),
      IntervalIntegrable (fun x => entropy (fields j x τ)) volume a b)
    (hflux : ∀ j, ∀ x ∈ ({a, b} : Set ℝ),
      IntervalIntegrable (fun τ => entropyFlux (fields j x τ)) volume s t)
    (hlocal : ∀ j,
      (∫ x in a..b, entropy (fields j x t)) - (∫ x in a..b, entropy (fields j x s)) ≤
        ∫ τ in s..t, entropyFlux (fields j a τ) - entropyFlux (fields j b τ)) :
    (∫ x in a..b, entropy (leveque04_reaBilateralEvolution states fields leftSpeed rightSpeed origin width horizon step hwidth hstep hbefore hspeeds hinteraction hleft hright x t)) -
      (∫ x in a..b, entropy (leveque04_reaBilateralEvolution states fields leftSpeed rightSpeed origin width horizon step hwidth hstep hbefore hspeeds hinteraction hleft hright x s)) ≤
        ∫ τ in s..t,
          entropyFlux (leveque04_reaBilateralEvolution states fields leftSpeed rightSpeed origin width horizon step hwidth hstep hbefore hspeeds hinteraction hleft hright a τ) -
          entropyFlux (leveque04_reaBilateralEvolution states fields leftSpeed rightSpeed origin width horizon step hwidth hstep hbefore hspeeds hinteraction hleft hright b τ) := by
  exact bilateralRiemannChain_entropy_rectangle_of_noninteraction states fields leftSpeed rightSpeed
    origin width horizon step hwidth hstep hbefore _ hspeeds hinteraction hleft hright
    entropy entropyFlux a b s t hab hst hs ht hspace hflux hlocal


/-- Away from grid interfaces, the actual evolution approaches its reconstructed initial value. -/
theorem leveque04_reaBilateralEvolution_initialTrace
    {E : Type*} [NormedAddCommGroup E] (states : ℤ → E) (fields : ℤ → ℝ → ℝ → E)
    (leftSpeed rightSpeed : ℤ → ℝ) (origin width horizon step : ℝ)
    (hwidth : 0 < width) (hstep : 0 < step) (hbefore : step < horizon)
    (hspeeds : ∀ j, leftSpeed j ≤ rightSpeed j)
    (hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + rightSpeed j * horizon ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * horizon)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      x < origin + (j : ℝ) * width + leftSpeed j * time → fields j x time = states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      origin + (j : ℝ) * width + rightSpeed j * time < x → fields j x time = states (j + 1))
    (x : ℝ) (hx : ∀ j : ℤ, x ≠ origin + (j : ℝ) * width) :
    let q := leveque04_reaBilateralEvolution states fields leftSpeed rightSpeed origin width horizon step
      hwidth hstep.le hbefore hspeeds hinteraction hleft hright
    Tendsto (q x) (𝓝[>] (0 : ℝ)) (𝓝 (q x 0)) := by
  obtain ⟨radius, hradius⟩ := riemannChainWindow_exists_of_noninteraction states fields leftSpeed rightSpeed
    origin width horizon step x x hwidth hstep.le hbefore hspeeds hinteraction hleft hright
  exact bilateralRiemannChainEvolution_tendsto states fields step hstep.le _ x radius (𝓝[>] (0 : ℝ))
    (Icc_mem_nhdsGT hstep) (fun time ht => hradius x ⟨le_refl _, le_refl _⟩ time ht)
    (fun j => riemannProfile_tendsto_initial_of_affine_fronts (fields j) (states j) (states (j + 1))
      (origin + (j : ℝ) * width) (leftSpeed j) (rightSpeed j) horizon x
      (hstep.trans hbefore) (hx j) (fun time ht => hleft j x time ht)
      (fun time ht => hright j x time ht))

end NumStability
