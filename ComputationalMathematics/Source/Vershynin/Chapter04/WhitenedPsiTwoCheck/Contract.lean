import ComputationalMathematics.HDP.Vector.SubGaussianLaw

/-!
# Vershynin Chapter 4, whitened `ψ₂` check
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- Vershynin, inline check in the proof of Theorem 4.7.1.  The original
population vector and its sample copies are represented through the same
whitening factor.  Surjectivity on scalar marginals is the precise consequence
of invertibility used to transport (4.24) from `X` to `Z`; isotropy then
normalizes every unit marginal.  Identical distribution gives the same vector
`ψ₂` bound for every *vector-valued sample* `Zᵢ` (not merely every
coordinate of one vector). -/
theorem hdp_04_whitened_psi2_check
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {m n : ℕ}
    (hm : 0 < m) (hn : 0 < n)
    (X Z : Ω → Fin n → ℝ)
    (Xsample Zsample : Fin m → Ω → Fin n → ℝ)
    (B Sigma : Matrix (Fin n) (Fin n) ℝ) (K : ℝ≥0)
    (hK : 1 ≤ K)
    (hSigma : Sigma = B * B.transpose)
    (hXwhiten : ∀ ω, X ω = B.mulVec (Z ω))
    (hXsampleWhiten : ∀ i ω, Xsample i ω = B.mulVec (Zsample i ω))
    (hMarginalSurjective : ∀ u : Fin n → ℝ, ∃ x : Fin n → ℝ,
      NumStability.HDP.Vector.linearMarginal (fun j ω ↦ Z ω j) u =
        NumStability.HDP.Vector.linearMarginal (fun j ω ↦ X ω j) x)
    (hRelative : NumStability.HDP.Vector.SubGaussian.SatisfiesPsiTwoL2Bound μ
      (fun j ω ↦ X ω j) K)
    (hIsotropic : ∀ u : NumStability.HDP.Vector.SubGaussian.UnitDirection n,
      eLpNorm (NumStability.HDP.Vector.linearMarginal (fun j ω ↦ Z ω j) u.1) 2 μ = 1)
    (hZMeasurable : ∀ j, Measurable (fun ω ↦ Z ω j))
    (hZsampleMeasurable : ∀ i j, Measurable (fun ω ↦ Zsample i ω j))
    (hIdent : ∀ i, IdentDistrib (Zsample i) Z μ μ) :
    NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ (fun j ω ↦ Z ω j) ≤
        (K : ℝ≥0∞) ∧
      ∀ i, NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
        (fun j ω ↦ Zsample i ω j) ≤ (K : ℝ≥0∞) := by
  have hWhitenedRelative :
      NumStability.HDP.Vector.SubGaussian.SatisfiesPsiTwoL2Bound μ
        (fun j ω ↦ Z ω j) K := by
    intro u
    rcases hMarginalSurjective u with ⟨x, hx⟩
    simpa only [hx] using hRelative x
  have hPopulation :=
    NumStability.HDP.Vector.SubGaussian.psiTwoNorm_le_of_unit_marginal_l2
      hWhitenedRelative hIsotropic
  refine ⟨hPopulation, fun i ↦ ?_⟩
  have hLaw := NumStability.HDP.Vector.SubGaussian.psiTwoNorm_eq_of_identDistrib
    (fun j ↦ hZsampleMeasurable i j) hZMeasurable (hIdent i)
  exact hLaw.le.trans hPopulation

end NumStability.HDP.Contract
