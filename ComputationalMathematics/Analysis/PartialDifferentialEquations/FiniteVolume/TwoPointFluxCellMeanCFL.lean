/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AdvectionCellMeanLpCFL
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CenteredStencilEvolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference

/-!
# A necessary CFL bound for two-point conservative fluxes

The numerical trajectory uses one shared two-state flux family and the actual
conservative flux-difference update. Exact physical cell means initialize it.
Physical cell-mean error convergence for every fixed smooth compact profile
forces the scalar-advection Courant bound for all exponents at least one,
including infinity. The same flux family is fixed before the profile varies.

The proof applies the existing three-point locality and physical-norm CFL
results to this update.
-/

open Set
open scoped ENNReal

namespace NumStability

/-- Convergence in the physical cell-mean grid norm of a two-point conservative
flux scheme for every fixed smooth compact scalar profile requires the
fixed-ratio Courant number to be at most one. -/
theorem advectionRefinement_courant_le_one_of_twoPointFluxCellMeanConvergence :
  ∀ (p : ENNReal) [Fact (1 ≤ p)] (speed origin T ratio : ℝ)
    (numericalFlux : ℕ → ℕ → (Fin 1 → ℝ) → (Fin 1 → ℝ) → Fin 1 → ℝ),
    0 < T → 0 < ratio →
    let width : ℕ → ℝ := fixedRatioRefinementCellWidth T ratio
    let dt : ℕ → ℝ := fun n => T / ((n + 1 : ℕ) : ℝ)
    let update : ℕ → ℕ → (ℤ → Fin 1 → ℝ) → ℤ → Fin 1 → ℝ :=
      fun n k u i => conservativeFluxDifferenceUpdateInt (dt n / width n) u
        (fun j => numericalFlux n k (u (j - 1)) (u j)) i
    (∀ profile : ℝ → ℝ,
      ContDiff ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) profile → HasCompactSupport profile →
      (∀ x, 0 ≤ profile x ∧ profile x ≤ 1) →
      IsPhysicalCellMeanLpConvergent_s03 p
        (fun x t (_ : Fin 1) => travelingWave profile speed x t)
        origin T width dt (fun n => n + 1)
        (fun n k => centeredStencilEvolution (update n)
          (fun j : ℤ => oneDimensionalCellAverage
            (fun x (_ : Fin 1) => profile x)
            (origin + (j : ℝ) * width n)
            (origin + ((j : ℝ) + 1) * width n)) k)) →
    |speed| * ratio ≤ 1 := by
  intro p hp speed origin T ratio numericalFlux hT hratio
  dsimp only
  intro hconv
  let width : ℕ → ℝ := fixedRatioRefinementCellWidth T ratio
  let dt : ℕ → ℝ := fun n => T / ((n + 1 : ℕ) : ℝ)
  let update : ℕ → ℕ → (ℤ → Fin 1 → ℝ) → ℤ → Fin 1 → ℝ :=
    fun n k u i => conservativeFluxDifferenceUpdateInt (dt n / width n) u
      (fun j => numericalFlux n k (u (j - 1)) (u j)) i
  have hlocal : ∀ n k (left right : ℤ → Fin 1 → ℝ) (i : ℤ),
      (∀ j ∈ Icc (i - (1 : ℤ)) (i + (1 : ℤ)), left j = right j) →
        update n k left i = update n k right i := by
    intro n k left right i hagree
    let G : ℕ → ℤ → (Fin 1 → ℝ) → (Fin 1 → ℝ) →
        (Fin 1 → ℝ) → Fin 1 → ℝ :=
      fun _ _ l c r => c - (dt n / width n) •
        (numericalFlux n k c r - numericalFlux n k l c)
    have h := centeredStencilEvolution_threePoint_locality
      G left right 1 i (by simpa using hagree)
    simpa [centeredStencilEvolution, G, update,
      conservativeFluxDifferenceUpdateInt] using h
  simpa only [Nat.cast_one] using
    (advectionRefinement_courant_le_of_cellMeanLpConvergence
      p speed origin T ratio 1 update hT hratio hlocal hconv)

end NumStability
