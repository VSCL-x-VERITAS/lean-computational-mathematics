/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.CrankNicolsonWholeLine
import Mathlib.Analysis.Normed.Module.RCLike.Real

/-!
# A whole-line CN supporting correction witness

This target uses the original consulted fixed example beta=dx=1,dt=3/2 on
all bounded integer-indexed real arrays. It requires the actual geometric
inverse and unique bounded CN solution, not only geometric coefficient
arithmetic. Structural coupling and actual coordinate response are distinct.

It is not a replacement or closure of LeVeque's broad printed71 statement:
the structural-envelope and limiting-CFL readings, and all seven retained
source ambiguities, remain separate. No unconditional source-error verdict
is asserted by this proof-free target.
-/

namespace NumStability

/-- Absolute convergence, actual inverse/unique bounded step, and the exact
all-index cancellation response of the specified whole-line CN example. -/
def Leveque04CNWholeLineCancellationTarget : Prop :=
  Summable (fun offset : ℤ => |cnWholeLineResolventKernel offset|) ∧
  Summable (fun offset : ℤ => |cnWholeLineStepKernel offset|) ∧
  cnWholeLineStepKernel 0 = 0 ∧
  (∀ offset : ℤ, offset ≠ 0 →
    cnWholeLineStepKernel offset = (1 / 3 : ℝ) ^ offset.natAbs ∧
      0 < cnWholeLineStepKernel offset) ∧
  (∀ data : ℤ → ℝ, IsBoundedWholeLineData data →
    IsBoundedWholeLineData (cnWholeLineResolvent data) ∧
    IsBoundedWholeLineData (cnWholeLineUpdate data) ∧
    (∀ i : ℤ,
      Summable (fun j : ℤ => |cnWholeLineResolventKernel (i - j) * data j|) ∧
      Summable (fun j : ℤ => |cnWholeLineStepKernel (i - j) * data j|) ∧
      cnWholeLineImplicitOperator (cnWholeLineResolvent data) i = data i ∧
      cnWholeLineResolvent (cnWholeLineImplicitOperator data) i = data i ∧
      cnWholeLineUpdate data i =
        (∑' j : ℤ, cnWholeLineStepKernel (i - j) * data j) ∧
      cnWholeLineImplicitOperator (cnWholeLineUpdate data) i =
        cnWholeLineOldDataOperator data i) ∧
    IsCNWholeLineStep data (cnWholeLineUpdate data) ∧
    (∀ after : ℤ → ℝ, IsBoundedWholeLineData after →
      IsCNWholeLineStep data after → after = cnWholeLineUpdate data) ∧
    (∀ observation site : ℤ, ∀ amplitude : ℝ,
      IsBoundedWholeLineData (cnWholeLinePerturb data site amplitude) ∧
      cnWholeLineUpdate (cnWholeLinePerturb data site amplitude) observation =
        cnWholeLineUpdate data observation +
          amplitude * cnWholeLineStepKernel (observation - site) ∧
      (amplitude ≠ 0 →
        (cnWholeLineUpdate (cnWholeLinePerturb data site amplitude) observation ≠
            cnWholeLineUpdate data observation ↔ observation ≠ site)))) ∧
  (∀ observation site : ℤ,
    CNWholeLineCoordinateInfluences observation site ↔ observation ≠ site) ∧
  (∀ data : ℤ → ℝ, ∀ i : ℤ,
    cnWholeLineImplicitOperator data i =
      cnWholeLineImplicitCoefficient i i * data i +
        cnWholeLineImplicitCoefficient i (i - 1) * data (i - 1) +
        cnWholeLineImplicitCoefficient i (i + 1) * data (i + 1)) ∧
  (∀ i j : ℤ, CNWholeLineStructurallyCoupled i j)

end NumStability
