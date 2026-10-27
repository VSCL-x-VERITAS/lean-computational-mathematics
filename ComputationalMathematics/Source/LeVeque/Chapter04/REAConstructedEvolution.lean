/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainAffineFronts
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainInitialTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainAffineEntropy

/-!
# Constructed nonlinear REA evolution

Chapter 4, printed page 77: individually conserving Riemann profiles are
pieced together before adjacent waves interact. These source wrappers use
the actual finite field with signed asymmetric fronts, its nonuniform initial
cell mass and initial trace, and inherited constituent entropy inequalities.
No uniqueness or general nonlinear Riemann solvability is asserted.
-/

open MeasureTheory Filter
open scoped Topology
namespace NumStability

/-- The actual finite Riemann field obtained by piecing consecutive local
solutions between ordered interfaces; nonlinear fluxes are not added. -/
abbrev leveque04_reaEvolution {E : Type*} [AddCommGroup E]
    (states : ℕ → E) (fields : ℕ → ℝ → ℝ → E) (count : ℕ) (x t : ℝ) : E :=
  finiteRiemannChainAssembly states (fun j => fields j x t) count

/-- Chapter 4, printed page 77: piece together the individually conserving
Riemann profiles before adjacent waves interact. The actual asymmetric
noninteraction condition constructs physical conservation of the finite field. -/
theorem leveque04_reaEvolution_rectangleReferenceOn
    {m : ℕ} (states : ℕ → Fin m → ℝ) (fields : ℕ → ℝ → ℝ → Fin m → ℝ)
    (centers leftSpeed rightSpeed : ℕ → ℝ) (count : ℕ)
    (flux : (Fin m → ℝ) → Fin m → ℝ) (left right horizon : ℝ)
    (hhorizon : 0 ≤ horizon)
    (hcenters : ∀ i j, i < j → j < count → centers i < centers j)
    (hspeeds : ∀ j < count, leftSpeed j ≤ rightSpeed j)
    (hinteraction : ∀ j, j + 1 < count →
      centers j + rightSpeed j * horizon ≤ centers (j + 1) + leftSpeed (j + 1) * horizon)
    (hfields : ∀ j < count, LocalConservationLaw.RectangleReferenceOn
      (fields j) flux left right horizon)
    (hleft : ∀ j < count, ∀ x ∈ Set.Icc left right, ∀ time ∈ Set.Icc 0 horizon,
      x < centers j + leftSpeed j * time → fields j x time = states j)
    (hright : ∀ j < count, ∀ x ∈ Set.Icc left right, ∀ time ∈ Set.Icc 0 horizon,
      centers j + rightSpeed j * time < x → fields j x time = states (j + 1)) :
    LocalConservationLaw.RectangleReferenceOn
      (fun x time => leveque04_reaEvolution states fields count x time)
      flux left right horizon := by
  exact finiteRiemannChain_rectangleReferenceOn_of_affine_fronts states fields centers leftSpeed rightSpeed count flux left right horizon hhorizon hcenters hspeeds hinteraction hfields hleft hright

/-- The piecewise-constant reconstruction has exactly its prescribed
nonuniform initial cell mass, independently of jump-point representatives. -/
theorem leveque04_reaEvolution_initialCellMass
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    (states : ℕ → E) (profiles : ℕ → ℝ → E) (centers : ℕ → ℝ) (count cell : ℕ)
    (hcell : cell + 1 < count)
    (hcenters : ∀ i j, i < j → j < count → centers i < centers j)
    (hleft : ∀ j < count, ∀ x, x < centers j → profiles j x = states j)
    (hright : ∀ j < count, ∀ x, centers j < x → profiles j x = states (j + 1)) :
    (∫ x in centers cell..centers (cell + 1),
      leveque04_reaEvolution states (fun j x _ => profiles j x) count x 0) =
        (centers (cell + 1) - centers cell) • states (cell + 1) := by
  exact finiteRiemannChainAssembly_initial_cell_integral_of_centers states profiles centers count cell hcell hcenters hleft hright

/-- Individually entropy-admissible Riemann profiles give the actual finite
REA field its entropy inequality on the full closed noninteracting step. -/
theorem leveque04_reaEvolution_entropy_rectangle
    {E : Type*} [AddCommGroup E] (states : ℕ → E) (fields : ℕ → ℝ → ℝ → E)
    (centers leftSpeed rightSpeed : ℕ → ℝ) (count : ℕ)
    (entropy entropyFlux : E → ℝ) (a b s t horizon : ℝ)
    (hab : a ≤ b) (hst : s ≤ t) (hs : 0 ≤ s) (ht : t ≤ horizon)
    (hcenters : ∀ i j, i < j → j < count → centers i < centers j)
    (hspeeds : ∀ j < count, leftSpeed j ≤ rightSpeed j)
    (hinteraction : ∀ j, j + 1 < count →
      centers j + rightSpeed j * horizon ≤ centers (j + 1) + leftSpeed (j + 1) * horizon)
    (hleft : ∀ j < count, ∀ x, ∀ time ∈ Set.Icc 0 horizon,
      x < centers j + leftSpeed j * time → fields j x time = states j)
    (hright : ∀ j < count, ∀ x, ∀ time ∈ Set.Icc 0 horizon,
      centers j + rightSpeed j * time < x → fields j x time = states (j + 1))
    (hspace : ∀ j < count, ∀ τ ∈ ({s, t} : Set ℝ),
      IntervalIntegrable (fun x => entropy (fields j x τ)) volume a b)
    (hflux : ∀ j < count, ∀ x ∈ ({a, b} : Set ℝ),
      IntervalIntegrable (fun τ => entropyFlux (fields j x τ)) volume s t)
    (hlocal : ∀ j < count,
      (∫ x in a..b, entropy (fields j x t)) -
        (∫ x in a..b, entropy (fields j x s)) ≤
          ∫ τ in s..t, entropyFlux (fields j a τ) - entropyFlux (fields j b τ)) :
    (∫ x in a..b, entropy (leveque04_reaEvolution states fields count x t)) -
      (∫ x in a..b, entropy (leveque04_reaEvolution states fields count x s)) ≤
        ∫ τ in s..t,
          entropyFlux (leveque04_reaEvolution states fields count a τ) -
          entropyFlux (leveque04_reaEvolution states fields count b τ) := by
  exact finiteRiemannChain_entropy_rectangle_of_affine_fronts states fields centers leftSpeed rightSpeed count entropy entropyFlux a b s t horizon hab hst hs ht hcenters hspeeds hinteraction hleft hright hspace hflux hlocal

/-- Off the initial interfaces, the actual REA field inherits the
right-hand initial trace of every local Riemann solution. -/
theorem leveque04_reaEvolution_initialTrace
    {E : Type*} [NormedAddCommGroup E]
    (states : ℕ → E) (fields : ℕ → ℝ → ℝ → E)
    (centers : ℕ → ℝ) (count : ℕ) (x : ℝ)
    (hx : ∀ j < count, x ≠ centers j)
    (htraces : ∀ j < count, x ≠ centers j →
      Tendsto (fields j x) (𝓝[>] (0 : ℝ)) (𝓝 (fields j x 0))) :
    Tendsto (fun t => leveque04_reaEvolution states fields count x t)
      (𝓝[>] (0 : ℝ)) (𝓝 (leveque04_reaEvolution states fields count x 0)) := by
  exact finiteRiemannChainAssembly_tendsto (𝓝[>] (0 : ℝ)) states
    (fun j => fields j x 0) (fun j => fields j x) count (fun j hj => htraces j hj (hx j hj))

end NumStability
