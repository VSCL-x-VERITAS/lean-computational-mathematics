import Lean
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod

set_option pp.deepTerms true
set_option pp.maxSteps 1000000
set_option pp.proofs false

namespace BlindEvidenceDiagnostic
open NumStability.DirectionalLine

noncomputable def explicitRate {m : ℕ} (family : LineFamily m)
    (quality : family.HasControlledHighResolution) : ℝ :=
  (Classical.indefiniteDescription (fun L : ℝ => 0 ≤ L ∧ ∀ n values other,
    family.admitted n values → family.admitted n other → ∀ E : ℝ, 0 ≤ E →
    (∀ j ∈ Finset.Ico (family.inputStart n) (family.inputStart n + family.inputCount n),
      ‖values j - other j‖ ≤ E) →
    ∀ j ∈ Finset.Ico (family.activeStart n) (family.activeStart n + family.activeCount n),
      ‖family.advance n values j - family.advance n other j‖ ≤ (1 + L * family.dt n) * E)
    quality.stability).val

theorem explicitRate_eq {m : ℕ} (family : LineFamily m)
    (quality : family.HasControlledHighResolution) :
    explicitRate family quality = family.stabilityRate quality := rfl

end BlindEvidenceDiagnostic

#print NumStability.DirectionalLine.LineFamily.stabilityRate
#print BlindEvidenceDiagnostic.explicitRate
#check BlindEvidenceDiagnostic.explicitRate_eq
#print axioms BlindEvidenceDiagnostic.explicitRate_eq
set_option pp.explicit true in
#print NumStability.DirectionalLine.LineFamily.stabilityRate
#print ContDiffOn
#print ContDiffWithinAt
#print HasFTaylorSeriesUpToOn
set_option pp.all true in
#check (⊤ : WithTop ℕ∞)
set_option pp.all true in
#check ((⊤ : ℕ∞) : WithTop ℕ∞)
