import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Lemma10A.Signature

/-! Source-facing contract for Lemma 3.3.10(a). -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Lemma 3.3.10(a), printed pages 53--54: if `X` chooses a member of a
positive-size tight-frame family uniformly by index, then `sqrt (N / A) X` is
isotropic.  The index law agrees with the proof's normalized finite sum and
retains multiplicity if the indexed family repeats a vector. -/
theorem hdp_03_lem_3_3_10a : hdp_03_lem_3_3_10a__contract_type := by
  intro N n Ω _ μ X u A hFrame hX
  exact
    NumStability.HDP.Vector.FrameIsotropy.isIsotropic_scaled_of_hasUniformFrameLaw
      u A hFrame hX

set_option linter.style.nameCheck false in
theorem hdp_03_lem_3_3_10a__contract : hdp_03_lem_3_3_10a__contract_type :=
  hdp_03_lem_3_3_10a

end NumStability.HDP.Contract
