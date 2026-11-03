/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CNWholeLineCancellationTarget
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.CrankNicolsonWholeLineInverse
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.CrankNicolsonWholeLineInfluence
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.CrankNicolsonWholeLineStructure

/-!
# The researched whole-line CN cancellation witness

The specified geometric convolution is the actual inverse on all bounded
integer arrays and gives the unique bounded CN step. Its solved coefficient
vanishes on the diagonal although the unsolved coefficient graph is connected.
The separate broad source interpretations remain outside this reviewed target.
-/

namespace NumStability

theorem leveque04_cnWholeLineCancellation : Leveque04CNWholeLineCancellationTarget := by
  refine ⟨summable_abs_cnWholeLineResolventKernel, summable_abs_cnWholeLineStepKernel,
    cnWholeLineStepKernel_zero, ?_, ?_, cnWholeLineCoordinateInfluences_iff,
    cnWholeLineImplicitOperator_eq_three_coefficients, cnWholeLineStructurallyCoupled_all⟩
  · intro offset hoffset
    exact ⟨cnWholeLineStepKernel_eq_of_ne_zero offset hoffset,
      cnWholeLineStepKernel_pos_of_ne_zero offset hoffset⟩
  · intro data hdata
    refine ⟨isBoundedWholeLineData_cnWholeLineResolvent data hdata,
      isBoundedWholeLineData_cnWholeLineUpdate data hdata, ?_,
      isCNWholeLineStep_update data hdata, ?_, ?_⟩
    · intro i
      exact ⟨summable_abs_cnWholeLineResolvent_integrand data hdata i,
        summable_abs_cnWholeLineStep_integrand data hdata i,
        cnWholeLineImplicitOperator_resolvent_apply data hdata i,
        congrFun (cnWholeLineResolvent_implicitOperator data hdata) i,
        cnWholeLineUpdate_eq_tsum_stepKernel data hdata i,
        congrFun (cnWholeLineImplicitOperator_update data hdata) i⟩
    · intro after hafter hstep
      exact eq_cnWholeLineUpdate_of_isCNWholeLineStep data after hdata hafter hstep
    · intro observation site amplitude
      exact ⟨isBoundedWholeLineData_cnWholeLinePerturb data hdata site amplitude,
        cnWholeLineUpdate_perturb data hdata observation site amplitude,
        fun hamplitude => cnWholeLineUpdate_perturb_ne_iff data hdata observation site amplitude
          hamplitude⟩

end NumStability
