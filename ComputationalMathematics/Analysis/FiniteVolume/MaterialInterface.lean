/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# Material Interface

Affine extension of the left material branch with interface value v.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

noncomputable section

namespace NumStability.FiniteVolume

/-- Affine extension of the left material branch with interface value v. -/
def interfaceLeftBranch (xK s uK v : ℝ) (x : ℝ) : ℝ :=
  uK + ((v - uK) / (s - xK)) * (x - xK)

/-- Affine extension of the right material branch with interface value v. -/
def interfaceRightBranch (s xL uL v : ℝ) (x : ℝ) : ℝ :=
  v + ((uL - v) / (xL - s)) * (x - s)

/-- The material interface is exactly s; its point value uses the left convention. -/
def alignedInterfaceCoefficient (s kK kL : ℝ) (x : ℝ) : ℝ :=
  if x ≤ s then kK else kL

/-- Actual joined piecewise-affine profile, restricted to [xK,xL] in applications. -/
def interfaceProfile (xK s xL uK uL v : ℝ) (x : ℝ) : ℝ :=
  if x ≤ s then interfaceLeftBranch xK s uK v x
  else interfaceRightBranch s xL uL v x

/-- Endpoint data, shared value traces, and equality of physical rightward flux traces.
No flux or solution is supplied as a premise. Derivatives are of the affine extensions,
so the right trace does not use the arbitrary material value assigned at s. -/
def SatisfiesMaterialInterface (xK s xL kK kL uK uL v : ℝ) : Prop :=
  interfaceLeftBranch xK s uK v xK = uK ∧
  interfaceRightBranch s xL uL v xL = uL ∧
  interfaceLeftBranch xK s uK v s = v ∧
  interfaceRightBranch s xL uL v s = v ∧
  -kK * deriv (interfaceLeftBranch xK s uK v) s =
    -kL * deriv (interfaceRightBranch s xL uL v) s

/-- false denotes K with outward normal +1; true denotes L with outward normal -1. -/
def materialOutwardFlux (xK s xL kK kL uK uL v : ℝ) (side : Bool) : ℝ :=
  if side then kL * deriv (interfaceRightBranch s xL uL v) s
  else -kK * deriv (interfaceLeftBranch xK s uK v) s

end NumStability.FiniteVolume
