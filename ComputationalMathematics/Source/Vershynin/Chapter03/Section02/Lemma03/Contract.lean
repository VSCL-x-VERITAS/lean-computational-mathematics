import ComputationalMathematics.Source.Vershynin.Chapter03.Section02.Lemma03.Signature

/-! Source-facing contract for Lemma 3.2.3. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

/-- Lemma 3.2.3, printed page 47: isotropy is equivalent to every
one-dimensional marginal having second moment equal to the squared Euclidean
norm of its direction. -/
theorem hdp_03_lem_3_2_3 :
    hdp_03_lem_3_2_3__contract_type := by
  intro n Ω _ μ _ X hX
  have hProducts : ∀ i j, Integrable (fun ω => X i ω * X j ω) μ := by
    intro i j
    exact (hX i).integrable_mul (hX j)
  simpa [NumStability.HDP.Vector.Isotropy.marginalSecondMoment] using
    NumStability.HDP.Vector.Isotropy.isIsotropic_iff_marginalSecondMoment μ X hProducts

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Lemma 3.2.3 signature. -/
theorem hdp_03_lem_3_2_3__contract :
    hdp_03_lem_3_2_3__contract_type :=
  hdp_03_lem_3_2_3

end NumStability.HDP.Contract
