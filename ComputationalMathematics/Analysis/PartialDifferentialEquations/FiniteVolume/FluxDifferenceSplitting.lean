/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference
import Mathlib.Tactic.Abel

/-!
# Additive flux-difference splitting

Two oriented fluctuations split the difference between neighboring physical
fluxes. Their common face flux turns the wave-form update into a conservative
flux difference, so finite blocks retain only boundary fluxes.
-/

namespace NumStability.FluxDifferenceSplitting

variable {E : Type*} [AddCommGroup E]

/-- At interface `i`, the physical-flux jump is the sum of left-going and
right-going fluctuations. -/
def IsSplit (physical leftGoing rightGoing : ℤ → E) : Prop :=
  ∀ i, physical i - physical (i - 1) =
    leftGoing i + rightGoing i

/-- The shared interface flux from the right-cell physical flux and its
outgoing right-going fluctuation. -/
def faceFlux (physical rightGoing : ℤ → E) (i : ℤ) : E :=
  physical i - rightGoing i

/-- The two neighboring formulas for a single face imply its physical-flux
difference splitting. -/
theorem isSplit_of_faceFlux_forms
    (physical leftGoing rightGoing selectedFaceFlux : ℤ → E)
    (hleft : ∀ i, selectedFaceFlux i = physical (i - 1) + leftGoing i)
    (hright : ∀ i, selectedFaceFlux i = physical i - rightGoing i) :
    IsSplit physical leftGoing rightGoing := by
  intro i
  have hl := hleft i
  have hr := hright i
  have hflux : physical i = selectedFaceFlux i + rightGoing i := by
    rw [hr]
    abel
  rw [hflux, hl]
  abel

/-- Under the split relation, the face flux can equally be computed from
the left-cell physical flux and the incoming left-going fluctuation. -/
theorem faceFlux_eq_left
    (physical leftGoing rightGoing : ℤ → E)
    (hsplit : IsSplit physical leftGoing rightGoing) (i : ℤ) :
    faceFlux physical rightGoing i =
      physical (i - 1) + leftGoing i := by
  have h := hsplit i
  unfold faceFlux
  calc
    physical i - rightGoing i =
        physical (i - 1) + (physical i - physical (i - 1)) -
          rightGoing i := by abel
    _ = physical (i - 1) + leftGoing i := by rw [h]; abel

/-- Consecutive selected face fluxes differ by the right-going fluctuation
from the left face and left-going fluctuation from the right face. -/
theorem faceFlux_difference
    (physical leftGoing rightGoing : ℤ → E)
    (hsplit : IsSplit physical leftGoing rightGoing) (i : ℤ) :
    faceFlux physical rightGoing (i + 1) -
      faceFlux physical rightGoing i =
        rightGoing i + leftGoing (i + 1) := by
  rw [faceFlux_eq_left physical leftGoing rightGoing hsplit (i + 1)]
  simp only [add_sub_cancel_right]
  unfold faceFlux
  abel

/-- A finite block of wave-form split updates has only the two boundary
face fluxes after summation. -/
theorem sum_waveUpdates
    [Module ℝ E] (scale : ℝ) (old : ℕ → E)
    (physical leftGoing rightGoing : ℤ → E)
    (hsplit : IsSplit physical leftGoing rightGoing)
    (cellCount : ℕ) :
    Finset.sum (Finset.range cellCount)
      (fun i => old i - scale • (rightGoing (i : ℤ) + leftGoing ((i : ℤ) + 1))) =
      Finset.sum (Finset.range cellCount) old -
        scale • (faceFlux physical rightGoing (cellCount : ℤ) -
          faceFlux physical rightGoing 0) := by
  have hstep (i : ℕ) :
      old i - scale • (rightGoing (i : ℤ) + leftGoing ((i : ℤ) + 1)) =
        conservativeFluxDifferenceUpdate scale old
          (fun j : ℕ => faceFlux physical rightGoing (j : ℤ)) i := by
    have hdiff := faceFlux_difference physical leftGoing rightGoing hsplit (i : ℤ)
    simpa only [conservativeFluxDifferenceUpdate, Nat.cast_add,
      Nat.cast_one] using
      congrArg (fun change : E => old i - scale • change) hdiff.symm
  calc
    _ = Finset.sum (Finset.range cellCount)
        (conservativeFluxDifferenceUpdate scale old
          (fun j : ℕ => faceFlux physical rightGoing (j : ℤ))) := by
          apply Finset.sum_congr rfl
          intro i _
          exact hstep i
    _ = _ := sum_conservativeFluxDifferenceUpdate scale old
      (fun j : ℕ => faceFlux physical rightGoing (j : ℤ)) cellCount

end NumStability.FluxDifferenceSplitting
