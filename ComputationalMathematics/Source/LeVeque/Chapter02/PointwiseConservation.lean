/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalLinearAdvection
import ComputationalMathematics.Source.LeVeque.Chapter02.PointwiseConservationTarget

/-!
# LeVeque equation (2.10)

The baseline local zero-integral theorem gives the conservation residual on the
section interior. Continuity extends the identity to the closed endpoints,
where the audited target uses actual spatial derivatives within the section.
-/

open MeasureTheory Set

namespace NumStability.Leveque02Tracer

/-- Every subinterval identity implies the pointwise classical conservation law. -/
theorem pointwiseConservation : pointwiseConservationTarget := by
  intro q flux qt fluxDerivative L R t hLR _htime _hspace hcontinuous hintegrals
  have hzero : EqOn (fun x => qt x + fluxDerivative x) (fun _ => 0) (Ioo L R) := by
    intro x hx
    apply LocalLinearAdvection.eq_zero_of_local_integrals _
      (hcontinuous.mono Ioo_subset_Icc_self) hx
    intro a ha b hb
    rcases le_total a b with hab | hba
    · exact hintegrals a (Ioo_subset_Icc_self ha) b (Ioo_subset_Icc_self hb) hab
    · rw [intervalIntegral.integral_symm b a,
        hintegrals b (Ioo_subset_Icc_self hb) a (Ioo_subset_Icc_self ha) hba, neg_zero]
  exact hzero.of_subset_closure hcontinuous continuousOn_const Ioo_subset_Icc_self
    (by rw [closure_Ioo hLR.ne])

end NumStability.Leveque02Tracer
