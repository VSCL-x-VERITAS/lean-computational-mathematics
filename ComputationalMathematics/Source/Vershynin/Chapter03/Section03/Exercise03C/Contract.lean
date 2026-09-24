import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Exercise03C.Signature
import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Exercise03A.Contract

/-! Exercise 3.3.3(c): a Gaussian matrix acting on a fixed unit vector. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Contract

/-- Independent standard-Gaussian rows, applied to a fixed unit vector, form
a standard-Gaussian output vector.  The row packaging is equivalent to the
source's i.i.d. standard-Gaussian entry description. -/
theorem hdp_03_ex_3_3_3c : hdp_03_ex_3_3_3c__contract_type := by
  intro m n Omega _ mu _ G u hRows hRowLaw hu
  apply NumStability.HDP.Vector.Gaussian.isStandardNormal_iff_iIndepFun_hasLaw.mpr
  constructor
  · have hIndep := hRows.comp
      (fun _ row => ∑ j, row j * u j) (fun _ => by fun_prop)
    simpa [Function.comp_def] using hIndep
  · intro i
    have hLaw := hdp_03_ex_3_3_3a mu (G i) u (hRowLaw i)
    convert hLaw using 1
    congr 2
    apply NNReal.eq
    change (1 : ℝ) = ‖u‖ ^ 2
    rw [hu]
    norm_num

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_3_3c__contract : hdp_03_ex_3_3_3c__contract_type :=
  hdp_03_ex_3_3_3c

end NumStability.HDP.Contract
