/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# Flux-difference residual from adjacent face errors

The conservative update depends on the difference of neighboring face
fluxes. A bound on the difference of their errors controls the local
residual without discarding cancellation.
-/

namespace NumStability

/-- Cubic neighboring face-error variation gives a quadratic
time-normalized residual for a conservative flux-difference step. -/
theorem conservativeFluxDifferenceUpdateInt_residual_of_faceDifference
    {m : ℕ} (old exactFace numericalFace exactNext : ℤ → Fin m → ℝ)
    (timeStep width bound : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hexact : ∀ i, exactNext i =
      conservativeFluxDifferenceUpdateInt (timeStep / width)
        old exactFace i)
    (hface : ∀ i k,
      |((numericalFace (i + 1) k - exactFace (i + 1) k) -
          (numericalFace i k - exactFace i k))| ≤
        bound * width ^ 3)
    (i : ℤ) (k : Fin m) :
    |(conservativeFluxDifferenceUpdateInt (timeStep / width)
        old numericalFace i k - exactNext i k) / timeStep| ≤
      bound * width ^ 2 := by
  have hidentity :
      (conservativeFluxDifferenceUpdateInt (timeStep / width)
          old numericalFace i k - exactNext i k) / timeStep =
        -((numericalFace (i + 1) k - exactFace (i + 1) k) -
          (numericalFace i k - exactFace i k)) / width := by
    rw [hexact i]
    simp only [conservativeFluxDifferenceUpdateInt,
      Pi.sub_apply, Pi.smul_apply, smul_eq_mul]
    field_simp
    ring
  rw [hidentity, abs_div, abs_neg, abs_of_pos hwidth]
  apply (div_le_iff₀ hwidth).2
  calc
    |(numericalFace (i + 1) k - exactFace (i + 1) k) -
        (numericalFace i k - exactFace i k)| ≤ bound * width ^ 3 := hface i k
    _ = (bound * width ^ 2) * width := by ring

end NumStability
