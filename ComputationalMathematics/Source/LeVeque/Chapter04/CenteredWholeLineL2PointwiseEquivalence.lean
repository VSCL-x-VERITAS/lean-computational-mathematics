/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CenteredWholeLineL2InstabilityTarget
import ComputationalMathematics.Source.LeVeque.Chapter04.CenteredWholeLineL2InstabilityPointwiseTarget

/-!
# Exact equality between the pointwise and continuous-linear centered ℓ² steps

These proofs use coordinate equality and iteration only. They prove neither
instability proposition. The pointwise target does not import this bridge.
-/

namespace NumStability

/-- The two representations are equal in the identical actual ℓ² carrier. -/
theorem centeredPointwiseL2Step_eq_old
    (courant : ℝ) (u : lp (fun _ : ℤ => ℝ) 2) :
    centeredPointwiseL2Step courant u = leveque04_centeredWholeLineL2Step courant u := by
  apply lp.ext
  funext i
  simp only [centeredPointwiseL2Step_apply, leveque04_centeredWholeLineL2Step_apply]

/-- Equality persists at every natural iterate, on all actual ℓ² data. -/
theorem centeredPointwiseL2Step_iterate_eq_old
    (courant : ℝ) (n : ℕ) (u : lp (fun _ : ℤ => ℝ) 2) :
    (centeredPointwiseL2Step courant)^[n] u =
      (leveque04_centeredWholeLineL2Step courant)^[n] u := by
  induction n with
  | zero => rfl
  | succ n ih =>
      rw [Function.iterate_succ_apply', Function.iterate_succ_apply', ih]
      exact centeredPointwiseL2Step_eq_old courant _

/-- The literal step is the same actual conservative centered-advection update. -/
theorem centeredPointwiseL2Step_eq_actual
    (timeStep width speed : ℝ) (hwidth : 0 < width)
    (u : lp (fun _ : ℤ => ℝ) 2) (i : ℤ) :
    centeredPointwiseL2Step (speed * timeStep / width) u i =
      leveque04_centeredScalarAdvectionStep timeStep width speed u i := by
  calc
    _ = leveque04_centeredWholeLineL2Step (speed * timeStep / width) u i :=
      congrArg (fun v : lp (fun _ : ℤ => ℝ) 2 => v i)
        (centeredPointwiseL2Step_eq_old (speed * timeStep / width) u)
    _ = _ := leveque04_centeredWholeLineL2Step_eq_actual timeStep width speed hwidth u i

/-- Complete quantified proposition equivalence, without using an instability proof. -/
theorem centeredWholeLineL2Instability_pointwise_iff_old :
    leveque04_centeredWholeLineL2Instability_pointwiseTarget ↔
      leveque04_centeredWholeLineL2Instability_target := by
  unfold leveque04_centeredWholeLineL2Instability_pointwiseTarget
    leveque04_centeredWholeLineL2Instability_target
  simp only [centeredPointwiseL2Step_iterate_eq_old]

end NumStability
