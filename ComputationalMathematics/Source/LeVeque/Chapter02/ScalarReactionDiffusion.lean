/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ScalarReactionDiffusionTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.ReactionDiffusion
import Mathlib.Tactic

/-!
# LeVeque Chapter 2: ScalarReactionDiffusion

Proof of the componentwise reaction-diffusion equation.
-/

open Set
namespace NumStability.Leveque02Tracer

theorem scalarReactionDiffusion : scalarReactionDiffusionTarget := by
  intro m q gradient qt qxx velocity diffusivity production x t spaceDomain
    hm hopen hx htime hspace hgradient
  dsimp only
  intro hbalance
  have h := reactionDiffusion m q gradient qt qxx velocity
    (fun _ => diffusivity) production x t spaceDomain
    hm hopen hx htime hspace hgradient hbalance
  simpa [Matrix.mulVec_diagonal, Pi.smul_apply, smul_eq_mul] using h

end NumStability.Leveque02Tracer
