import ComputationalMathematics.Analysis.Probability.Haar.HomogeneousSpaceUniqueness
import Mathlib.Probability.Independence.Basic

/-!
# Independence from transitive invariance

This module proves that a joint probability law on `A × X` factors when it
is invariant under a transitive measurable group action on its `X` coordinate.
The proof Haar-averages measurable rectangle indicators.
-/

open MeasureTheory ProbabilityTheory Set Measure
open scoped ENNReal

namespace MeasureTheory

/-- If a probability law on `A × X` is invariant under a transitive
measurable group action on `X`, then its two coordinate projections are
independent. -/
theorem indepFun_fst_snd_of_invariant_probability_of_pretransitive
    {G A X : Type*}
    [Group G] [MeasurableSpace G] [MeasurableMul₂ G]
    [MeasurableSpace A] [MeasurableSpace X] [Nonempty X]
    [MulAction G X] [MeasurableSMul₂ G X]
    (htrans : ∀ x y : X, ∃ g : G, y = g • x)
    (rho : Measure G) [SFinite rho] [IsProbabilityMeasure rho]
    [rho.IsMulRightInvariant]
    (mu : Measure (A × X)) [IsProbabilityMeasure mu]
    (hmu : ∀ g : G, Measure.map (fun p : A × X => (p.1, g • p.2)) mu = mu) :
    IndepFun Prod.fst Prod.snd mu := by
  rw [indepFun_iff_measure_inter_preimage_eq_mul]
  intro s t hs ht
  let eX : X → ℝ≥0∞ := t.indicator (fun _ => 1)
  let F : X → ℝ≥0∞ := fun x => ∫⁻ g : G, eX (g • x) ∂rho
  have heX : Measurable eX := measurable_const.indicator ht
  have hact (g : G) : Measurable (fun p : A × X => (p.1, g • p.2)) :=
    measurable_fst.prodMk (measurable_const.smul measurable_snd)
  have hF_const : ∀ x y : X, F x = F y := by
    intro x y
    obtain ⟨g, rfl⟩ := htrans x y
    unfold F
    simpa only [mul_smul] using
      (lintegral_mul_right_eq_self
        (μ := rho) (fun h : G => eX (h • x)) g).symm
  let x0 : X := Classical.choice ‹Nonempty X›
  have havg_aux (u : Set A) (hu : MeasurableSet u) :
      mu (Prod.fst ⁻¹' u ∩ Prod.snd ⁻¹' t) =
        ∫⁻ p : A × X, u.indicator (fun _ => 1) p.1 * F p.2 ∂mu := by
    let eA : A → ℝ≥0∞ := u.indicator (fun _ => 1)
    have heA : Measurable eA := measurable_const.indicator hu
    have huncurry : Measurable
        (Function.uncurry fun (g : G) (p : A × X) => eA p.1 * eX (g • p.2)) := by
      fun_prop
    have hrect (g : G) :
        mu (Prod.fst ⁻¹' u ∩ Prod.snd ⁻¹' t) =
          ∫⁻ p : A × X, eA p.1 * eX (g • p.2) ∂mu := by
      calc
        mu (Prod.fst ⁻¹' u ∩ Prod.snd ⁻¹' t) = mu (u ×ˢ t) := by
          congr 1
        _ = (Measure.map (fun p : A × X => (p.1, g • p.2)) mu) (u ×ˢ t) := by
          rw [hmu g]
        _ = mu ((fun p : A × X => (p.1, g • p.2)) ⁻¹' (u ×ˢ t)) := by
          rw [Measure.map_apply (hact g) (hu.prod ht)]
        _ = ∫⁻ p : A × X, eA p.1 * eX (g • p.2) ∂mu := by
          rw [← lintegral_indicator_one ((hu.prod ht).preimage (hact g))]
          apply lintegral_congr
          intro p
          by_cases hp1 : p.1 ∈ u <;> by_cases hp2 : g • p.2 ∈ t <;>
            simp [eA, eX, Set.indicator, hp1, hp2]
    calc
      mu (Prod.fst ⁻¹' u ∩ Prod.snd ⁻¹' t) =
          ∫⁻ _g : G, mu (Prod.fst ⁻¹' u ∩ Prod.snd ⁻¹' t) ∂rho := by simp
      _ = ∫⁻ g : G, ∫⁻ p : A × X, eA p.1 * eX (g • p.2) ∂mu ∂rho := by
        apply lintegral_congr
        intro g
        exact hrect g
      _ = ∫⁻ p : A × X, ∫⁻ g : G, eA p.1 * eX (g • p.2) ∂rho ∂mu := by
        exact lintegral_lintegral_swap huncurry.aemeasurable
      _ = ∫⁻ p : A × X, eA p.1 * F p.2 ∂mu := by
        apply lintegral_congr
        intro p
        change (∫⁻ g : G, eA p.1 * eX (g • p.2) ∂rho) =
          eA p.1 * (∫⁻ g : G, eX (g • p.2) ∂rho)
        exact lintegral_const_mul (eA p.1)
          (heX.comp (measurable_id.smul measurable_const))
      _ = ∫⁻ p : A × X, u.indicator (fun _ => 1) p.1 * F p.2 ∂mu := rfl
  have havg := havg_aux s hs
  have hright : mu (Prod.snd ⁻¹' t) = F x0 := by
    calc
      mu (Prod.snd ⁻¹' t) =
          mu (Prod.fst ⁻¹' (Set.univ : Set A) ∩ Prod.snd ⁻¹' t) := by simp
      _ = ∫⁻ p : A × X,
          (Set.univ : Set A).indicator (fun _ => 1) p.1 * F p.2 ∂mu :=
        havg_aux Set.univ MeasurableSet.univ
      _ = ∫⁻ _p : A × X, F x0 ∂mu := by
        apply lintegral_congr
        intro p
        simp [hF_const (p.2) x0]
      _ = F x0 := by simp
  rw [havg, hright]
  simp_rw [hF_const _ x0]
  have hind :
      (∫⁻ p : A × X, s.indicator (fun _ => 1) p.1 ∂mu) =
        ∫⁻ p : A × X, (Prod.fst ⁻¹' s).indicator (fun _ => 1) p ∂mu := by
    apply lintegral_congr
    intro p
    by_cases hp : p.1 ∈ s <;> simp [Set.indicator, hp]
  have hind_measure :
      (∫⁻ p : A × X, (Prod.fst ⁻¹' s).indicator (fun _ => 1) p ∂mu) =
        mu (Prod.fst ⁻¹' s) := by
    simpa only using
      (lintegral_indicator_one (μ := mu) (hs.preimage measurable_fst))
  calc
    (∫⁻ p : A × X, s.indicator (fun _ => 1) p.1 * F x0 ∂mu) =
        (∫⁻ p : A × X, s.indicator (fun _ => 1) p.1 ∂mu) * F x0 := by
      exact lintegral_mul_const (F x0)
        ((measurable_const.indicator hs).comp measurable_fst)
    _ = (∫⁻ p : A × X,
        (Prod.fst ⁻¹' s).indicator (fun _ => 1) p ∂mu) * F x0 := by rw [hind]
    _ = mu (Prod.fst ⁻¹' s) * F x0 := by rw [hind_measure]

end MeasureTheory
