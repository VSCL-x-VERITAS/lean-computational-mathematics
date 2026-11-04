import ComputationalMathematics.HDP.Vector.SubGaussianL2
import ComputationalMathematics.HDP.Scalar.SubGaussianDomination
import Mathlib.Probability.IdentDistrib

/-!
# Law invariance of vector sub-Gaussian norms

This additive module keeps law-transport bridges separate from the frozen
`SubGaussianL2` core.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Vector.SubGaussian

/-- The vector `ψ₂` norm depends only on the joint law of the vector. -/
theorem psiTwoNorm_eq_of_identDistrib
    {Ω Ω' : Type*} [MeasurableSpace Ω] [MeasurableSpace Ω'] {n : ℕ}
    {μ : Measure Ω} {μ' : Measure Ω'}
    {X : Fin n → Ω → ℝ} {Y : Fin n → Ω' → ℝ}
    (hX : ∀ j, Measurable (X j)) (hY : ∀ j, Measurable (Y j))
    (hXY : ProbabilityTheory.IdentDistrib
      (fun ω ↦ fun j ↦ X j ω) (fun ω ↦ fun j ↦ Y j ω) μ μ') :
    PsiTwoNorm μ X = PsiTwoNorm μ' Y := by
  have hmarginal (u : Fin n → ℝ) :
      ProbabilityTheory.IdentDistrib
        (NumStability.HDP.Vector.linearMarginal X u)
        (NumStability.HDP.Vector.linearMarginal Y u) μ μ' := by
    let projection : (Fin n → ℝ) → ℝ := fun z ↦ ∑ j, z j * u j
    have hprojection : Measurable projection := by
      dsimp [projection]
      fun_prop
    simpa [projection, Function.comp_def,
      NumStability.HDP.Vector.linearMarginal] using hXY.comp hprojection
  have hscalar (u : Fin n → ℝ) :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
          (NumStability.HDP.Vector.linearMarginal X u) =
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ'
          (NumStability.HDP.Vector.linearMarginal Y u) := by
    have hXm : Measurable (NumStability.HDP.Vector.linearMarginal X u) := by
      unfold NumStability.HDP.Vector.linearMarginal
      fun_prop
    have hYm : Measurable (NumStability.HDP.Vector.linearMarginal Y u) := by
      unfold NumStability.HDP.Vector.linearMarginal
      fun_prop
    let ν : Measure ℝ := Measure.map
      (NumStability.HDP.Vector.linearMarginal X u) μ
    have hXLaw : ProbabilityTheory.HasLaw
        (NumStability.HDP.Vector.linearMarginal X u) ν μ :=
      ⟨hXm.aemeasurable, rfl⟩
    have hYLaw : ProbabilityTheory.HasLaw
        (NumStability.HDP.Vector.linearMarginal Y u) ν μ' :=
      (hmarginal u).hasLaw hXLaw
    exact NumStability.HDP.Scalar.SubGaussian.psiTwoNorm_eq_of_sameLaw
      hXm hYm hXLaw hYLaw
  unfold PsiTwoNorm
  apply le_antisymm
  · refine iSup_le fun u ↦ ?_
    exact (hscalar u.1).le.trans (le_iSup (fun v : UnitDirection n ↦
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ'
        (NumStability.HDP.Vector.linearMarginal Y v.1)) u)
  · refine iSup_le fun u ↦ ?_
    exact (hscalar u.1).ge.trans (le_iSup (fun v : UnitDirection n ↦
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
        (NumStability.HDP.Vector.linearMarginal X v.1)) u)

end NumStability.HDP.Vector.SubGaussian
