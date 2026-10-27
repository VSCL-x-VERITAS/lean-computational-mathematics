/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainLocalReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRectangleCellAverage

/-!
# Exact finite Riemann-chain cell-average step

The actual constructed nonlinear Riemann chain has the exact normalized conservative cell update through its actual physical Riemann face time averages.
-/

open MeasureTheory
namespace NumStability

/-- An actual normalized conservative cell update of the constructed field. -/
theorem finiteRiemannChain_cellAverage_step
    {m : ℕ} (states : ℕ → Fin m → ℝ) (fields : ℕ → ℝ → ℝ → Fin m → ℝ)
    (count cell : ℕ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (width bound horizon : ℝ)
    (hcell : cell + 1 < count) (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hhorizon : 0 < horizon) (hcfl : 2 * bound * horizon ≤ width)
    (hfields : ∀ j < count, LocalConservationLaw.RectangleReferenceOn (fields j) flux
      ((cell : ℝ) * width) ((cell + 1 : ℕ) * width) horizon)
    (hleft : ∀ j < count, ∀ x, ∀ t ∈ Set.Icc 0 horizon,
      x < (j : ℝ) * width - bound * t → fields j x t = states j)
    (hright : ∀ j < count, ∀ x, ∀ t ∈ Set.Icc 0 horizon,
      (j : ℝ) * width + bound * t < x → fields j x t = states (j + 1)) :
    oneDimensionalCellAverage
      (fun x => finiteRiemannChainAssembly states (fun j => fields j x horizon) count)
      ((cell : ℝ) * width) ((cell + 1 : ℕ) * width) =
      states (cell + 1) - (horizon / width) •
        (oneDimensionalCellAverage
          (fun t => flux (fields (cell + 1) ((cell + 1 : ℕ) * width) t)) 0 horizon -
        oneDimensionalCellAverage
          (fun t => flux (fields cell ((cell : ℝ) * width) t)) 0 horizon) := by
  let a := (cell : ℝ) * width
  let b := (cell + 1 : ℕ) * width
  let q := fun x t => finiteRiemannChainAssembly states (fun j => fields j x t) count
  have hab : a < b := by dsimp [a, b]; push_cast; nlinarith
  have hwidthEq : b - a = width := by dsimp [a, b]; push_cast; ring
  have hreference := finiteRiemannChain_rectangleReferenceOn_of_uniform_cones_free_fronts
    states fields count flux a b width bound horizon hwidth hbound hhorizon.le hcfl hfields
    (fun j hj x _ t ht => hleft j hj x t ht)
    (fun j hj x _ t ht => hright j hj x t ht)
  have hinitial := finiteRiemannChainAssembly_initial_cell_integral states
    (fun j x => fields j x 0) count cell width (by omega) hwidth
    (fun j hj x hx => hleft j hj x 0 ⟨le_rfl, hhorizon.le⟩ (by simpa using hx))
    (fun j hj x hx => hright j hj x 0 ⟨le_rfl, hhorizon.le⟩ (by simpa using hx))
  have hinitialAverage : oneDimensionalCellAverage (fun x => q x 0) a b = states (cell + 1) := by
    change (b - a)⁻¹ • (∫ x in a..b, q x 0) = _
    rw [hwidthEq]
    dsimp only [q, a, b]
    rw [hinitial]
    simp [smul_smul, hwidth.ne']
  have hface (k : ℕ) (hk : k < count) :
      oneDimensionalCellAverage (fun t => flux (q ((k : ℝ) * width) t)) 0 horizon =
        oneDimensionalCellAverage (fun t => flux (fields k ((k : ℝ) * width) t)) 0 horizon := by
    unfold oneDimensionalCellAverage
    congr 1
    apply intervalIntegral.integral_congr
    intro t ht
    have ht' : t ∈ Set.Icc 0 horizon := by
      simpa only [Set.uIcc_of_le hhorizon.le] using ht
    change flux (q ((k : ℝ) * width) t) = flux (fields k ((k : ℝ) * width) t)
    apply congrArg flux
    exact finiteRiemannChainAssembly_eq_interface_profile states fields count k width bound horizon t
      hk hwidth hbound ht' hcfl
      (fun j hj x => hleft j hj x t ht') (fun j hj x => hright j hj x t ht')
  have hstep := rectangleReferenceOn_cellAverage_step_of_initial q flux (states (cell + 1))
    a b horizon a b hreference ⟨le_rfl, hab.le⟩ ⟨hab.le, le_rfl⟩ hab hhorizon hinitialAverage
  rw [hwidthEq, hface cell (by omega), hface (cell + 1) hcell] at hstep
  exact hstep

end NumStability
