/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REACertifiedInitialTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRectangleCellAverage

/-!
# Cell averages of the certified bilateral REA evolution

The reconstructed initial mass and physical rectangle balance of the
selected adjacent Riemann solutions imply the conservative average update.
-/

namespace NumStability
open Set MeasureTheory

/-- Averaging the selected certified Riemann assembly over one cell gives
the conservative update with the evolution's actual physical face fluxes. -/
theorem leveque04_reaCertifiedBilateral_cellAverage_step
    {m : ℕ} {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (states : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law states j))
    (interface : ℤ → ℝ) (leftSpeed rightSpeed : ℤ → ℝ)
    (origin width bound step : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hstep : 0 < step)
    (hface : ∀ j, interface (j + 1) = origin + (j : ℝ) * width)
    (hfinite : ∀ x time, time ∈ Icc 0 step →
      ∃ radius, IsRiemannChainWindow states
        (fun j => leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) x time)
        radius)
    (hspeeds : ∀ j, -bound ≤ leftSpeed j ∧
      leftSpeed j ≤ rightSpeed j ∧ rightSpeed j ≤ bound)
    (hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + rightSpeed j * step ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * step)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Icc 0 step →
      x < origin + (j : ℝ) * width + leftSpeed j * time →
        leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) x time =
          states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Icc 0 step →
      origin + (j : ℝ) * width + rightSpeed j * time < x →
        leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) x time =
          states (j + 1))
    (cell : ℤ) :
    let q := bilateralRiemannChainEvolution states
      (fun j => leveque04_reaCertifiedLocalField method states hdomain interface (j + 1))
      step hfinite
    oneDimensionalCellAverage (fun x => q x step)
      (origin + (cell : ℝ) * width) (origin + ((cell + 1 : ℤ) : ℝ) * width) =
      states (cell + 1) - (step / width) •
        (oneDimensionalCellAverage
          (fun time => law.physicalFlux (q (origin + ((cell + 1 : ℤ) : ℝ) * width) time)) 0 step -
          oneDimensionalCellAverage
            (fun time => law.physicalFlux (q (origin + (cell : ℝ) * width) time)) 0 step) := by
  let q := bilateralRiemannChainEvolution states
    (fun j => leveque04_reaCertifiedLocalField method states hdomain interface (j + 1))
    step hfinite
  let a := origin + (cell : ℝ) * width
  let b := origin + ((cell + 1 : ℤ) : ℝ) * width
  have hwidthEq : b - a = width := by dsimp [a, b]; push_cast; ring
  have hab : a < b := by linarith
  have hreference := leveque04_reaCertifiedBilateral_shifted_rectangleReferenceOn
    method states hdomain interface leftSpeed rightSpeed origin width bound step
    a b hwidth hbound hstep.le hab.le hfinite hspeeds hinteraction hleft hright
  have hmass := leveque04_reaCertifiedBilateral_initial_cell_integral
    method states hdomain interface origin width step hwidth hstep.le hface hfinite cell
  have hinitial : oneDimensionalCellAverage (fun x => q x 0) a b = states (cell + 1) := by
    change (b - a)⁻¹ • (∫ x in a..b, q x 0) = _
    rw [hwidthEq]
    change width⁻¹ • (∫ x in (origin + (cell : ℝ) * width)..
        (origin + ((cell + 1 : ℤ) : ℝ) * width),
      bilateralRiemannChainEvolution states
        (fun j => leveque04_reaCertifiedLocalField method states hdomain interface (j + 1))
        step hfinite x 0) = _
    rw [hmass]
    simp [smul_smul, hwidth.ne']
  have hresult := rectangleReferenceOn_cellAverage_step_of_initial q law.physicalFlux
    (states (cell + 1)) a b step a b hreference
    ⟨le_refl _, hab.le⟩ ⟨hab.le, le_refl _⟩ hab hstep hinitial
  rw [hwidthEq] at hresult
  exact hresult

end NumStability
