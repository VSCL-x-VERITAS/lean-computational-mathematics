/- Proof-free owner-qualified fixed-grid corrected target with explicit computed-solution identity. -/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.CrankNicolsonWholeLine

namespace NumStability

/-- The same computed map used by coordinate influence is the unique bounded
solution of the actual fixed CN equation. Structural connectivity still fails
to imply influence from every site. The parameters remain beta=h=1,dt=3/2;
no kernel formula, universal parameter family, stability or limiting claim is
added. The v1 target and its first native capture remain preserved separately. -/
def Leveque04ImplicitDomainFixedGridCorrectionIdentifiedTarget : Prop :=
  (∀ data : ℤ → ℝ, IsBoundedWholeLineData data →
    IsBoundedWholeLineData (cnWholeLineUpdate data) ∧
    IsCNWholeLineStep data (cnWholeLineUpdate data) ∧
    ∀ after : ℤ → ℝ, IsBoundedWholeLineData after →
      IsCNWholeLineStep data after → after = cnWholeLineUpdate data) ∧
  (∀ observation site : ℤ, CNWholeLineStructurallyCoupled observation site) ∧
  ¬ (∀ observation site : ℤ, CNWholeLineCoordinateInfluences observation site)

end NumStability
