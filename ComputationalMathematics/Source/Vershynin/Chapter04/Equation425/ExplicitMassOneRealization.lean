import ComputationalMathematics.HDP.Vector.Whitening

/-!
# Equation (4.25) for a supplied measurable realization

This independently audited qualified contract states probability normalization
as total mass one. It retains positive dimensions, the actual raw second moment,
measurable supplied families, their laws, independence and isotropy, invertible
population covariance, and exact reconstruction at the selected outcome.
Both coefficient-one operator norm conclusions are preserved.

The proof composes the existing probability constructor, coordinate L2,
second-moment positivity and principal-square-root sample-error results.
It asserts no sample-family existence, expectation bound or author-wide choice
between pointwise and almost-everywhere equality. The singular-population case
and the unrestricted source statement remain outside this selected contract.
-/

noncomputable section

set_option backward.isDefEq.respectTransparency false

open _root_.MeasureTheory _root_.ProbabilityTheory _root_.Matrix
open scoped ENNReal NNReal BigOperators MatrixOrder

universe u

namespace NumStability.HDP.Contract

/-- Same mathematical setting with probability normalization stated explicitly. -/
def equation425MassOneMeasurableFamiliesSuppliedRealizationInvertible : Prop :=
  ∀ {Ω : Type u} [MeasurableSpace Ω] {μ : Measure Ω}, μ Set.univ = 1 →
    ∀ {m n : ℕ}, 0 < m → 0 < n →
    ∀ (X : Ω → Fin n → ℝ)
      (Xsample Zsample : Fin m → Ω → Fin n → ℝ) (K : ℝ≥0),
    Measurable X →
    (∀ i, Measurable (Xsample i)) →
    (∀ i, Measurable (Zsample i)) →
    1 ≤ K →
    NumStability.HDP.Vector.SubGaussian.IsSubGaussian μ (fun j ω ↦ X ω j) →
    NumStability.HDP.Vector.SubGaussian.SatisfiesPsiTwoL2Bound μ
      (fun j ω ↦ X ω j) K →
    (∀ i, IdentDistrib (Xsample i) X μ μ) →
    iIndepFun Zsample μ →
    (∀ i, NumStability.HDP.Vector.Isotropy.IsIsotropic μ
      (fun j ω ↦ Zsample i ω j)) →
    let Sigma := NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
      (fun j ω ↦ X ω j)
    IsUnit Sigma →
    ∀ ω : Ω,
    (∀ i, Xsample i ω = (CFC.sqrt Sigma).mulVec (Zsample i ω)) →
    let SigmaM := NumStability.HDP.Vector.Covariance.randomSampleCovariance Xsample ω
    let A : Matrix (Fin m) (Fin n) ℝ := fun i ↦ Zsample i ω
    let Rm := (m : ℝ)⁻¹ • (A.transpose * A) - 1
    ‖NumStability.realMatrixContinuousLinearMap (SigmaM - Sigma)‖ =
        ‖NumStability.realMatrixContinuousLinearMap
          (CFC.sqrt Sigma * Rm * CFC.sqrt Sigma)‖ ∧
      ‖NumStability.realMatrixContinuousLinearMap
        (CFC.sqrt Sigma * Rm * CFC.sqrt Sigma)‖ ≤
        ‖NumStability.realMatrixContinuousLinearMap Rm‖ *
          ‖NumStability.realMatrixContinuousLinearMap Sigma‖

/-- Qualified source wrapper composing the canonical norm-chain producers. -/
theorem equation425_mass_one_measurable_families_supplied_realization_invertible :
    equation425MassOneMeasurableFamiliesSuppliedRealizationInvertible.{u} := by
  intro Ω _ μ hMass
  letI : IsProbabilityMeasure μ := IsProbabilityMeasure.mk hMass
  intro m n _hm _hn X Xsample Zsample K
    _hMeasX _hMeasSamples _hMeasZ _hK hSG _hRelative
    _hLaw _hIndep _hIso
  dsimp only
  intro _hUnit ω hRows
  let Sigma := NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
    (fun j ω ↦ X ω j)
  have hLp := NumStability.HDP.Vector.Whitening.coordinate_memLp_of_subGaussian hSG
  have hPSD : Sigma.PosSemidef :=
    NumStability.HDP.Vector.Covariance.secondMomentMatrix_posSemidef
      (fun j ω ↦ X ω j) hLp
  obtain ⟨_, hEqual, hBound⟩ :=
    NumStability.HDP.Vector.Whitening.canonical_squareRoot_sample_error_of_factor
      Sigma hPSD (fun i ↦ Xsample i ω) (fun i ↦ Zsample i ω) hRows
  exact ⟨hEqual, hEqual.symm.trans_le hBound⟩

end NumStability.HDP.Contract
