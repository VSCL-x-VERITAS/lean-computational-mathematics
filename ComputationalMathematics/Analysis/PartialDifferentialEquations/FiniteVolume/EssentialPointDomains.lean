/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AdmissibleDomainNecessity

/-!
# Domains of neighborhood-essential observations

Equality on the admitted class preserves the essential-point domain. Constants
have empty domains, while continuous point evaluation has a singleton domain.
The evaluation witnesses reuse the existing continuous localized perturbations.
-/

namespace NumStability

theorem essentialPointDomain_eq_of_eq_on_class
    {X E V : Type*} [PseudoMetricSpace X]
    (admissible : (X → E) → Prop) (left right : (X → E) → V)
    (heq : ∀ f, admissible f → left f = right f) :
    {point | IsEssentialPointOnClass admissible left point} =
      {point | IsEssentialPointOnClass admissible right point} := by
  ext point
  constructor
  · intro h radius hradius
    obtain ⟨f, g, hf, hg, houtside, hdifferent⟩ := h radius hradius
    exact ⟨f, g, hf, hg, houtside, by rwa [← heq f hf, ← heq g hg]⟩
  · intro h radius hradius
    obtain ⟨f, g, hf, hg, houtside, hdifferent⟩ := h radius hradius
    exact ⟨f, g, hf, hg, houtside, by rwa [heq f hf, heq g hg]⟩

theorem essentialPointDomain_const
    {X E V : Type*} [PseudoMetricSpace X]
    (admissible : (X → E) → Prop) (value : V) :
    {point | IsEssentialPointOnClass admissible (fun _ => value) point} = ∅ := by
  apply Set.eq_empty_iff_forall_notMem.mpr
  intro point h
  obtain ⟨f, g, _, _, _, hdifferent⟩ := h 1 (by norm_num)
  exact hdifferent rfl

theorem essentialPointDomain_continuous_evaluation
    {V : Type*} [NormedAddCommGroup V] [NormedSpace ℝ V] [Nontrivial V]
    (center : ℝ) :
    {point | IsEssentialPointOnClass Continuous (fun f : ℝ → V => f center) point} =
      {center} := by
  ext point
  constructor
  · intro h
    apply Set.mem_singleton_iff.mpr
    by_contra hne
    have hdist : 0 < dist center point := dist_pos.mpr (Ne.symm hne)
    obtain ⟨f, g, _, _, houtside, hdifferent⟩ := h (dist center point) hdist
    have hexterior : center ∉ Metric.ball point (dist center point) := by
      simp only [Metric.mem_ball, lt_self_iff_false, not_false_eq_true]
    exact hdifferent (houtside center hexterior)
  · intro h
    have heq : point = center := Set.mem_singleton_iff.mp h
    subst point
    exact evaluation_continuous_essentialPointOnClass center

end NumStability
