/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Logic.Relation

/-!
# A fixed whole-line Crank–Nicolson cancellation witness

The data are real sequences on the integer lattice. Diffusivity and spatial
width are one, and the time step is `3/2`, so the coefficient in the
Crank–Nicolson diffusion equation is `3/4`. The specified geometric
convolution is not assumed to be an inverse: summability, inverse identities,
bounded solvability and coordinate response are separate target obligations.

The sums are total on arbitrary raw sequences; their intended solution
interpretation is restricted to the explicitly defined full bounded class.
-/

namespace NumStability

/-- The full class of bounded real sequences, without a fixed common bound. -/
def IsBoundedWholeLineData (data : ℤ → ℝ) : Prop :=
  ∃ bound : ℝ, 0 ≤ bound ∧ ∀ i : ℤ, |data i| ≤ bound

/-- The fixed proposed Green kernel at coefficient `3/4`. -/
noncomputable def cnWholeLineResolventKernel (offset : ℤ) : ℝ :=
  (1 / 2 : ℝ) * (1 / 3 : ℝ) ^ offset.natAbs

/-- The fixed CN kernel `2R - delta`, distinct from the resolvent kernel. -/
noncomputable def cnWholeLineStepKernel (offset : ℤ) : ℝ :=
  2 * cnWholeLineResolventKernel offset - if offset = 0 then 1 else 0

/-- The actual geometric convolution with the supplied initial array. -/
noncomputable def cnWholeLineResolvent (data : ℤ → ℝ) (i : ℤ) : ℝ :=
  ∑' j : ℤ, cnWholeLineResolventKernel (i - j) * data j

/-- The actual proposed CN array, not a callback or assumed inverse. -/
noncomputable def cnWholeLineUpdate (data : ℤ → ℝ) (i : ℤ) : ℝ :=
  2 * cnWholeLineResolvent data i - data i

/-- The centered second difference at spatial width one. -/
def cnWholeLineSecondDifference (data : ℤ → ℝ) (i : ℤ) : ℝ :=
  data (i - 1) - 2 * data i + data (i + 1)

/-- The left-hand implicit operator `I - (3/4) Delta`. -/
noncomputable def cnWholeLineImplicitOperator (data : ℤ → ℝ) (i : ℤ) : ℝ :=
  (5 / 2 : ℝ) * data i - (3 / 4 : ℝ) * (data (i - 1) + data (i + 1))

/-- The right-hand data operator `2I - A = I + (3/4) Delta`. -/
noncomputable def cnWholeLineOldDataOperator (data : ℤ → ℝ) (i : ℤ) : ℝ :=
  2 * data i - cnWholeLineImplicitOperator data i

/-- Exactly the fixed scalar diffusion CN recurrence at beta=dx=1,dt=3/2. -/
def IsCNWholeLineStep (before after : ℤ → ℝ) : Prop :=
  ∀ i : ℤ, after i = before i + (3 / 4 : ℝ) *
    (cnWholeLineSecondDifference before i + cnWholeLineSecondDifference after i)

/-- A single-coordinate perturbation, of arbitrary real amplitude. -/
def cnWholeLinePerturb (data : ℤ → ℝ) (site : ℤ) (amplitude : ℝ) : ℤ → ℝ :=
  Function.update data site (data site + amplitude)

/-- Actual coordinate influence over the full bounded input class. -/
def CNWholeLineCoordinateInfluences (observation site : ℤ) : Prop :=
  ∃ first second : ℤ → ℝ,
    IsBoundedWholeLineData first ∧ IsBoundedWholeLineData second ∧
      (∀ j : ℤ, j ≠ site → first j = second j) ∧
      cnWholeLineUpdate first observation ≠ cnWholeLineUpdate second observation

/-- Entries of the actual unsolved three-point implicit operator. -/
noncomputable def cnWholeLineImplicitCoefficient (i j : ℤ) : ℝ :=
  if j = i then 5 / 2
  else if j = i - 1 ∨ j = i + 1 then -(3 / 4) else 0

/-- Structural coupling uses nonzero off-diagonal entries of the unsolved
operator, not the coefficients of its solved CN update. -/
def CNWholeLineStructurallyCoupled (i j : ℤ) : Prop :=
  Relation.ReflTransGen
    (fun source destination : ℤ =>
      source ≠ destination ∧ cnWholeLineImplicitCoefficient source destination ≠ 0) i j

end NumStability
