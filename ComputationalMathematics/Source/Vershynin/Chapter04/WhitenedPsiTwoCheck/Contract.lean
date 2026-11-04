import ComputationalMathematics.HDP.Vector.SubGaussianLaw

/-!
# Vershynin Chapter 4, whitened `ψ₂` check
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- The marginal transfer used in Vershynin's proof of Theorem 4.7.1.
The source constructs `Z` and its copies through an invertible whitening
factor on a probability space. This statement assumes the precise marginal
surjectivity consequence directly, together with the relative `ψ₂` bound,
unit-marginal `L²` normalization, measurability, and identical distribution.
It needs no explicit whitening matrix, original sample family, probability
normalization, positive dimensions, or lower bound `K ≥ 1`. Identical
distribution gives the same vector `ψ₂` bound for every vector-valued
sample `Zᵢ`, rather than merely for the coordinates of one vector. -/
theorem hdp_04_whitened_psi2_check
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    {m n : ℕ}
    (X Z : Ω → Fin n → ℝ)
    (Zsample : Fin m → Ω → Fin n → ℝ) (K : ℝ≥0)
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
