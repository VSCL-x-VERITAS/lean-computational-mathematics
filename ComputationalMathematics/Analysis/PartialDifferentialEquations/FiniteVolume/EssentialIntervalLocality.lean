/- SPDX-License-Identifier: MIT -/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AdmissibleDomainNecessity

open Set Metric
namespace NumStability

/-- A functional determined on a closed interval has no essential point outside it.
The data class need not be a vector space or contain arbitrary impulses. -/
theorem essentialPointOnClass_subset_interval
    {E V : Type*} (admissible : (ℝ → E) → Prop) (value : (ℝ → E) → V)
    (X radius : ℝ)
    (hlocal : ∀ f g, admissible f → admissible g →
      EqOn f g (Icc (X - radius) (X + radius)) → value f = value g) :
    {x | IsEssentialPointOnClass admissible value x} ⊆ Icc (X - radius) (X + radius) := by
  intro x hx
  by_contra hout
  have hgap : radius < |x - X| := by
    by_contra! h
    apply hout
    constructor <;> linarith [(abs_le.mp h).1, (abs_le.mp h).2]
  let ε := (|x - X| - radius) / 2
  have hε : 0 < ε := by dsimp [ε]; linarith
  obtain ⟨f, g, hf, hg, houtside, hne⟩ := hx ε hε
  apply hne
  apply hlocal f g hf hg
  intro y hy
  apply houtside
  intro hball
  have hyabs : |y - X| ≤ radius := abs_le.mpr ⟨by linarith [hy.1], by linarith [hy.2]⟩
  have hdist : |x - y| < ε := by
    simpa only [mem_ball, Real.dist_eq, abs_sub_comm] using hball
  have ht := abs_sub_le x y X
  dsimp [ε] at hdist
  linarith

end NumStability
