/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CrankNicolsonUnconditionalStabilityBridge

/-!
# The actual source-facing Crank–Nicolson solution operator

The value of this constructed method is the existing whole-line solved update.
Its attached equation identifies that concrete function with the conservative
source equation (4.13). This introduces no supplied solver or stability premise.
-/

namespace NumStability

/-- The existing computed update, with its actual source equation attached.
Existence and uniqueness belong to the method's construction, rather than an
additional conclusion of the source's finite-horizon stability assertion. -/
noncomputable def leveque04_crankNicolsonSourceUpdate
    (grid : WholeLineDiffusionL2Grid) :
    {N : lp (fun _ : ℤ => ℝ) 2 → lp (fun _ : ℤ => ℝ) 2 //
      ∀ before : lp (fun _ : ℤ => ℝ) 2,
        IsLeveque04CrankNicolsonStep grid.timeStep grid.width
        grid.diffusivity before (N before)} :=
  ⟨grid.update, fun before =>
    (leveque04_crankNicolson_wholeLineStep_iff grid.diffusivity before
      (grid.update before) grid.width grid.timeStep grid.width_pos).mp
      (grid.update_spec before)⟩

end NumStability
