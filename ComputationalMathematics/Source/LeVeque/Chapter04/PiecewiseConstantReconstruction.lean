/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Cell

/-!
# LeVeque Chapter 4: Godunov's piecewise-constant REA reconstruction

This is the first reconstruction choice in Algorithm 4.1. The condition is
stated cellwise so it can be used with any valid spatial cell partition.
-/

namespace NumStability

/-- A reconstruction takes the old cell average as its value at every point
inside that cell, as specified for Godunov's first-order REA step. -/
def IsLeveque04PiecewiseConstantReconstruction
    (interface : ℤ → ℝ) (cellAverage : ℤ → ℝ)
    (reconstructed : ℝ → ℝ) : Prop :=
  ∀ i : ℤ, ∀ x ∈ leveque04_cell interface i,
    reconstructed x = cellAverage i

/-- The cellwise value equation for Godunov's piecewise-constant
reconstruction, with the source's open-cell convention. -/
theorem leveque04_reaPiecewiseConstant
    (interface : ℤ → ℝ) (cellAverage : ℤ → ℝ)
    (reconstructed : ℝ → ℝ)
    (hconstant : IsLeveque04PiecewiseConstantReconstruction
      interface cellAverage reconstructed)
    (i : ℤ) (x : ℝ) (hx : x ∈ leveque04_cell interface i) :
    reconstructed x = cellAverage i := hconstant i x hx

/-- The system-valued cell equation follows componentwise from the scalar
reconstruction contract, with the same arbitrary interfaces and open cells. -/
theorem leveque04_reaPiecewiseConstant_system
    {m : ℕ} (interface : ℤ → ℝ) (cellAverage : ℤ → Fin m → ℝ)
    (reconstructed : ℝ → Fin m → ℝ)
    (hconstant : ∀ component, IsLeveque04PiecewiseConstantReconstruction
      interface (fun i => cellAverage i component)
      (fun x => reconstructed x component))
    (i : ℤ) (x : ℝ) (hx : x ∈ leveque04_cell interface i) :
    reconstructed x = cellAverage i := by
  funext component
  exact leveque04_reaPiecewiseConstant interface
    (fun j => cellAverage j component) (fun y => reconstructed y component)
    (hconstant component) i x hx

end NumStability
