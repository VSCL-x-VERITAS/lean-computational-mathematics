/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AdmissibleDomainNecessity
import Mathlib.Analysis.Calculus.BumpFunction.FiniteDimension
import Mathlib.Algebra.Order.BigOperators.Ring.Finset
import Mathlib.Topology.Algebra.Monoid

/-!
# Compact localization of bounded continuous functional influence

Finite bump overwrites connect any two bounded continuous fields whose difference
is confined to a compact set. An arbitrary functional that ignores every local
change near each point of that compact set therefore takes the same value on the
fields. No continuity or linearity of the functional is assumed.

Consequently, all-data convergence for the same observable forces lower-limit
containment of the actual fixed-mesh essential sets. This is not a transfer from
finite-p grid convergence to pointwise convergence, and it does not apply to
arbitrary admissible classes lacking the concrete patch closure used here.
-/

noncomputable section

open Set Metric Filter
open scoped BigOperators Topology

namespace NumStability

variable {X E W : Type*} [TopologicalSpace X]
variable [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- All continuous fields with a global finite norm bound. The bound may depend
on the field; it is not a common boundedness restriction on the admitted class. -/
def IsBoundedContinuousField (f : X → E) : Prop :=
  Continuous f ∧ ∃ C : ℝ, ∀ x, ‖f x‖ ≤ C

/-- Overwrite selected regions of `f` by `g`. Each insertion is confined to the
support of the corresponding actual cutoff. -/
def finiteBumpOverwrite {ι : Type*} (cutoff : ι → X → ℝ)
    (f g : X → E) (s : Finset ι) (x : X) : E :=
  g x + (∏ i ∈ s, (1 - cutoff i x)) • (f x - g x)

/-- Every finite overwrite remains in the actual bounded continuous class. -/
theorem finiteBumpOverwrite_admissible {ι : Type*}
    (cutoff : ι → X → ℝ) (f g : X → E) (s : Finset ι)
    (hf : IsBoundedContinuousField f) (hg : IsBoundedContinuousField g)
    (hc : ∀ i, Continuous (cutoff i))
    (h01 : ∀ i x, 0 ≤ cutoff i x ∧ cutoff i x ≤ 1) :
    IsBoundedContinuousField (finiteBumpOverwrite cutoff f g s) := by
  refine ⟨hg.1.add ((continuous_finset_prod s (fun i _ =>
    continuous_const.sub (hc i))).smul (hf.1.sub hg.1)), ?_⟩
  obtain ⟨Cf, hCf⟩ := hf.2
  obtain ⟨Cg, hCg⟩ := hg.2
  refine ⟨Cg + (Cf + Cg), fun x => ?_⟩
  have hp0 : 0 ≤ ∏ i ∈ s, (1 - cutoff i x) :=
    Finset.prod_nonneg (fun i _ => sub_nonneg.mpr (h01 i x).2)
  have hp1 : (∏ i ∈ s, (1 - cutoff i x)) ≤ 1 :=
    Finset.prod_le_one (fun i _ => sub_nonneg.mpr (h01 i x).2)
      (fun i _ => sub_le_self _ (h01 i x).1)
  have hpnorm : ‖∏ i ∈ s, (1 - cutoff i x)‖ ≤ 1 := by
    simpa only [Real.norm_eq_abs, abs_of_nonneg hp0] using hp1
  calc
    ‖finiteBumpOverwrite cutoff f g s x‖ ≤
        ‖g x‖ + ‖(∏ i ∈ s, (1 - cutoff i x)) • (f x - g x)‖ :=
      norm_add_le _ _
    _ ≤ ‖g x‖ + ‖f x - g x‖ := by
      rw [norm_smul]
      exact add_le_add le_rfl
        ((mul_le_mul_of_nonneg_right hpnorm (norm_nonneg (f x - g x))).trans_eq (one_mul ‖f x - g x‖))
    _ ≤ Cg + (Cf + Cg) :=
      add_le_add (hCg x) ((norm_sub_le _ _).trans (add_le_add (hCf x) (hCg x)))

/-- Actual finite local invariance telescopes along bump overwrites. No generic
patch-closure axiom is assumed: admissibility follows from the previous lemma. -/
theorem finiteBumpOverwrite_functional_eq {ι : Type*}
    (F : (X → E) → W) (U : ι → Set X) (cutoff : ι → X → ℝ)
    (f g : X → E) (s : Finset ι)
    (hf : IsBoundedContinuousField f) (hg : IsBoundedContinuousField g)
    (hc : ∀ i, Continuous (cutoff i))
    (h01 : ∀ i x, 0 ≤ cutoff i x ∧ cutoff i x ≤ 1)
    (hsupport : ∀ i x, x ∉ U i → cutoff i x = 0)
    (hinvariant : ∀ i (p q : X → E), IsBoundedContinuousField p →
      IsBoundedContinuousField q → (∀ x, x ∉ U i → p x = q x) → F p = F q) :
    F (finiteBumpOverwrite cutoff f g s) = F f := by
  classical
  induction s using Finset.induction_on with
  | empty =>
      have h : finiteBumpOverwrite cutoff f g ∅ = f := by
        funext x
        simp [finiteBumpOverwrite]
      rw [h]
  | @insert i s hi ih =>
      calc
        F (finiteBumpOverwrite cutoff f g (insert i s)) =
            F (finiteBumpOverwrite cutoff f g s) := by
          apply hinvariant i
          · exact finiteBumpOverwrite_admissible cutoff f g _ hf hg hc h01
          · exact finiteBumpOverwrite_admissible cutoff f g _ hf hg hc h01
          · intro x hx
            simp [finiteBumpOverwrite, Finset.prod_insert hi, hsupport i x hx]
        _ = F f := ih

/-- If an arbitrary functional has no bounded-continuous essential point on a
compact real set, it cannot distinguish bounded continuous fields equal outside
that set. The codomain needs no algebraic or topological structure. -/
theorem boundedContinuous_eq_of_no_essential_on_compact
    (F : (ℝ → E) → W) (K : Set ℝ) (hK : IsCompact K)
    (f g : ℝ → E) (hf : IsBoundedContinuousField f)
    (hg : IsBoundedContinuousField g)
    (houtside : ∀ x, x ∉ K → f x = g x)
    (hnon : ∀ x ∈ K,
      ¬ IsEssentialPointOnClass IsBoundedContinuousField F x) : F f = F g := by
  classical
  have hlocal (x : K) : ∃ r : ℝ, 0 < r ∧
      ∀ (p q : ℝ → E), IsBoundedContinuousField p →
        IsBoundedContinuousField q →
        (∀ y, y ∉ ball (x : ℝ) r → p y = q y) → F p = F q := by
    have h := hnon x x.2
    unfold IsEssentialPointOnClass at h
    push_neg at h
    exact h
  choose radius hpos hinvariant using hlocal
  let bump (x : K) : ContDiffBump (x : ℝ) :=
    ⟨radius x / 2, radius x, half_pos (hpos x), half_lt_self (hpos x)⟩
  obtain ⟨s, hs⟩ := hK.elim_finite_subcover
    (fun x : K => ball (x : ℝ) (radius x / 2)) (fun _ => isOpen_ball) (by
      intro x hx
      exact mem_iUnion.mpr ⟨⟨x, hx⟩, mem_ball_self (half_pos (hpos ⟨x, hx⟩))⟩)
  have hpatch : finiteBumpOverwrite (fun i => bump i) f g s = g := by
    funext x
    by_cases hx : x ∈ K
    · obtain ⟨i, hi, hxi⟩ := mem_iUnion₂.mp (hs hx)
      have hone : bump i x = 1 :=
        (bump i).one_of_mem_closedBall (ball_subset_closedBall hxi)
      have hzero : (∏ j ∈ s, (1 - bump j x)) = 0 :=
        Finset.prod_eq_zero_iff.mpr ⟨i, hi, by rw [hone, sub_self]⟩
      simp [finiteBumpOverwrite, hzero]
    · simp [finiteBumpOverwrite, houtside x hx]
  have hsame := finiteBumpOverwrite_functional_eq F
    (fun i : K => ball (i : ℝ) (radius i)) (fun i => bump i) f g s hf hg
    (fun i => (bump i).continuous)
    (fun i x => ⟨(bump i).nonneg, (bump i).le_one⟩)
    (by
      intro i x hx
      exact Function.notMem_support.mp (by simpa [(bump i).support_eq] using hx))
    hinvariant
  rw [hpatch] at hsame
  exact hsame.symm

/-- A distinguishable compactly confined perturbation contains an actual
fixed-functional essential point, not merely a point in a read envelope. -/
theorem boundedContinuous_compact_perturbation_meets_essential
    (F : (ℝ → E) → W) (K : Set ℝ) (hK : IsCompact K)
    (f g : ℝ → E) (hf : IsBoundedContinuousField f)
    (hg : IsBoundedContinuousField g)
    (houtside : ∀ x, x ∉ K → f x = g x) (hne : F f ≠ F g) :
    ∃ x ∈ K, IsEssentialPointOnClass IsBoundedContinuousField F x := by
  by_contra h
  push_neg at h
  exact hne (boundedContinuous_eq_of_no_essential_on_compact F K hK f g hf hg houtside h)

/-- Same-observable convergence on ALL bounded continuous fields forces the
lower limit of actual fixed-mesh numerical essential domains to contain the exact
essential domain. Compact localization is applied separately at each late mesh;
no exchange of radius and eventual-index quantifiers is made. -/
theorem boundedContinuous_convergence_essential_lowerLimit
    {V : Type*} [NormedAddCommGroup V]
    (exactValue : (ℝ → E) → V) (approximation : ℕ → (ℝ → E) → V)
    (hconverges : ∀ f, IsBoundedContinuousField f →
      Tendsto (fun n => approximation n f) atTop (𝓝 (exactValue f))) :
    {x | IsEssentialPointOnClass IsBoundedContinuousField exactValue x} ⊆
      numericalLimitingDomain
        (fun n => {x | IsEssentialPointOnClass IsBoundedContinuousField (approximation n) x}) := by
  intro x hx radius hradius
  obtain ⟨f, g, hf, hg, houtside, hne⟩ := hx (radius / 2) (half_pos hradius)
  have heventual := ((hconverges f hf).sub (hconverges g hg)).eventually_ne
    (sub_ne_zero.mpr hne)
  filter_upwards [heventual] with n hn
  obtain ⟨y, hy, hessential⟩ := boundedContinuous_compact_perturbation_meets_essential
    (approximation n) (closedBall x (radius / 2)) (isCompact_closedBall _ _) f g hf hg
    (fun z hz => houtside z (fun hball => hz (ball_subset_closedBall hball)))
    (fun h => hn (sub_eq_zero.mpr h))
  refine ⟨y, hessential, ?_⟩
  exact lt_of_le_of_lt hy (half_lt_self hradius)

end NumStability



