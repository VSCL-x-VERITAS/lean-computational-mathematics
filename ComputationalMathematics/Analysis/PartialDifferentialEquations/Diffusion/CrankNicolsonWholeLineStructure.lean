/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.CrankNicolsonWholeLine
import Lean.Elab.Tactic.Omega
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-!
# The actual unsolved whole-line implicit coefficient graph

Every integer site connects to its two neighbors through nonzero off-diagonal
coefficients. Finite paths connect all pairs of sites. This structural fact
does not assert a nonzero coefficient in the solved update.
-/

namespace NumStability

@[simp]
theorem cnWholeLineImplicitCoefficient_self (i : ℤ) :
    cnWholeLineImplicitCoefficient i i = 5 / 2 := by
  simp [cnWholeLineImplicitCoefficient]

@[simp]
theorem cnWholeLineImplicitCoefficient_left (i : ℤ) :
    cnWholeLineImplicitCoefficient i (i - 1) = -(3 / 4) := by
  have hne : i - 1 ≠ i := by omega
  simp [cnWholeLineImplicitCoefficient, hne]

@[simp]
theorem cnWholeLineImplicitCoefficient_right (i : ℤ) :
    cnWholeLineImplicitCoefficient i (i + 1) = -(3 / 4) := by
  have hne : i + 1 ≠ i := by omega
  simp [cnWholeLineImplicitCoefficient, hne]

theorem cnWholeLineImplicitOperator_eq_three_coefficients (data : ℤ → ℝ) (i : ℤ) :
    cnWholeLineImplicitOperator data i =
      cnWholeLineImplicitCoefficient i i * data i +
        cnWholeLineImplicitCoefficient i (i - 1) * data (i - 1) +
          cnWholeLineImplicitCoefficient i (i + 1) * data (i + 1) := by
  simp only [cnWholeLineImplicitCoefficient_self, cnWholeLineImplicitCoefficient_left,
    cnWholeLineImplicitCoefficient_right, cnWholeLineImplicitOperator]
  ring

theorem cnWholeLineStructurallyCoupled_right (i : ℤ) :
    CNWholeLineStructurallyCoupled i (i + 1) := by
  apply Relation.ReflTransGen.single
  refine ⟨by omega, ?_⟩
  rw [cnWholeLineImplicitCoefficient_right]
  norm_num

theorem cnWholeLineStructurallyCoupled_left (i : ℤ) :
    CNWholeLineStructurallyCoupled i (i - 1) := by
  apply Relation.ReflTransGen.single
  refine ⟨by omega, ?_⟩
  rw [cnWholeLineImplicitCoefficient_left]
  norm_num

/-- All pairs are connected in the graph of the actual unsolved operator. -/
theorem cnWholeLineStructurallyCoupled_all (i j : ℤ) :
    CNWholeLineStructurallyCoupled i j := by
  have hreach : ∀ offset : ℤ, CNWholeLineStructurallyCoupled i (i + offset) := by
    intro offset
    induction offset using Int.induction_on with
    | zero =>
        simpa using (Relation.ReflTransGen.refl : CNWholeLineStructurallyCoupled i i)
    | succ n ih =>
        have h := Relation.ReflTransGen.trans ih
          (cnWholeLineStructurallyCoupled_right (i + (n : ℤ)))
        convert h using 1
        omega
    | pred n ih =>
        have h := Relation.ReflTransGen.trans ih
          (cnWholeLineStructurallyCoupled_left (i + -(n : ℤ)))
        convert h using 1
        omega
  simpa using hreach (j - i)

end NumStability
