import ComputationalMathematics.Source.Vershynin.Chapter04.Equation425.ConstructedPointwiseTarget
import ComputationalMathematics.HDP.Vector.WhiteningLawFamily

/-!
# Equation 4.25: constructed whitening coupling

Proof of the separately recorded analyst completion, with the principal PSD
root and a jointly constructed population and sample family.
-/

noncomputable section

set_option backward.isDefEq.respectTransparency false

open MeasureTheory ProbabilityTheory Matrix
open scoped ENNReal NNReal BigOperators MatrixOrder

namespace NumStability.HDP.Contract

theorem equation425_constructed_pointwise_proved : equation425ConstructedPointwiseTarget := by
  intro m n _hm _hn ν _ K _hK hSG _hRelative hLp
  dsimp only
  let Sigma := NumStability.HDP.Vector.Covariance.secondMomentMatrix ν
    (fun j (x : Fin n → ℝ) => x j)
  have hPSD : Sigma.PosSemidef :=
    NumStability.HDP.Vector.Covariance.secondMomentMatrix_posSemidef _ hLp
  refine ⟨(CFC.sqrt_nonneg Sigma).posSemidef,
    CFC.sqrt_mul_sqrt_self Sigma hPSD.nonneg, ?_⟩
  obtain ⟨T, P, Q, _hData, Ω, measurableΩ, μ, hμ, F, Z, hMeas, hCoordLp,
    hFLaw, hFIndep, hZIndep, hPairIndep, _hBase, hIdent, hIso, hZSG, hPoint⟩ :=
    NumStability.HDP.Vector.Whitening.exists_principal_lawWhitening_family
      (ι := Option (Fin m)) ν
      (fun j => NumStability.HDP.Vector.Whitening.coordinate_isSubGaussian hSG j)
  letI : MeasurableSpace Ω := measurableΩ
  letI : IsProbabilityMeasure μ := hμ
  refine ⟨Ω, measurableΩ, μ, hμ, F, Z, hMeas, hCoordLp,
    (fun o => (hFLaw o).map_eq), hFIndep, hZIndep, hPairIndep,
    (fun o => hIdent o none), hIso, hZSG, hPoint, ?_⟩
  intro ω
  have hGram := NumStability.HDP.Vector.Whitening.sampleCovariance_eq_normalizedGram
    (fun i => Z (some i) ω)
  obtain ⟨hFactor, hNormEq, hNormBound⟩ :=
    NumStability.HDP.Vector.Whitening.canonical_squareRoot_sample_error_of_factor
      Sigma hPSD (fun i => F (some i) ω) (fun i => Z (some i) ω)
      (fun i => hPoint (some i) ω)
  refine ⟨congrArg (fun A => A - 1) hGram.symm, hFactor, hNormEq, ?_⟩
  exact hNormEq.symm.le.trans hNormBound

end NumStability.HDP.Contract
