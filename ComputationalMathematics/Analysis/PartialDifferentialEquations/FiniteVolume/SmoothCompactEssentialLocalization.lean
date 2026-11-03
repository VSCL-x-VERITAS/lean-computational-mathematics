/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CompactEssentialLocalization
import Mathlib.Analysis.Calculus.ContDiff.Operations
import Mathlib.Topology.Algebra.Support

/-!
# Compact localization on smooth compactly supported data

The admitted class consists of actual smooth compactly supported real-vector
fields. Finite bump overwrites remain in that same class. Local invariance then
telescopes across a finite compact cover, and same-observable convergence forces
lower-limit containment for the actual fixed-mesh essential domains relative to
this class. No inference from a broader admitted class is used.
-/

noncomputable section

open Set Metric Filter
open scoped BigOperators Topology

namespace NumStability

variable {E W : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- Smooth compactly supported fields on the real line. There is no common
support or norm bound imposed on the whole class. -/
def IsSmoothCompactField (f : ℝ → E) : Prop :=
  ContDiff ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) f ∧ HasCompactSupport f

/-- Actual finite overwrites preserve smoothness and compact support. The scalar
cutoffs themselves need not be compactly supported for this closure statement:
the vector difference is compactly supported. -/
theorem finiteBumpOverwrite_smoothCompact {ι : Type*}
    (cutoff : ι → ℝ → ℝ) (f g : ℝ → E) (s : Finset ι)
    (hf : IsSmoothCompactField f) (hg : IsSmoothCompactField g)
    (hc : ∀ i, ContDiff ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) (cutoff i)) :
    IsSmoothCompactField (finiteBumpOverwrite cutoff f g s) := by
  classical
  have hprod : ContDiff ℝ ((⊤ : ℕ∞) : WithTop ℕ∞)
      (fun x : ℝ => ∏ i ∈ s, (1 - cutoff i x)) := by
    induction s using Finset.induction_on with
    | empty => simpa using (contDiff_const :
        ContDiff ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) (fun _ : ℝ => (1 : ℝ)))
    | @insert i s hi ih =>
        simpa only [Finset.prod_insert hi] using (contDiff_const.sub (hc i)).mul ih
  refine ⟨hg.1.add (hprod.smul (hf.1.sub hg.1)), ?_⟩
  have hdifference : HasCompactSupport (fun x : ℝ => f x - g x) := hf.2.sub hg.2
  exact hg.2.add hdifference.smul_left

/-- Local invariance on the smooth compact class telescopes through actual
finite patches whose membership in that class was proved above. -/
theorem finiteBumpOverwrite_smoothCompact_functional_eq {ι : Type*}
    (F : (ℝ → E) → W) (U : ι → Set ℝ) (cutoff : ι → ℝ → ℝ)
    (f g : ℝ → E) (s : Finset ι)
    (hf : IsSmoothCompactField f) (hg : IsSmoothCompactField g)
    (hc : ∀ i, ContDiff ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) (cutoff i))
    (hsupport : ∀ i x, x ∉ U i → cutoff i x = 0)
    (hinvariant : ∀ i (p q : ℝ → E), IsSmoothCompactField p →
      IsSmoothCompactField q → (∀ x, x ∉ U i → p x = q x) → F p = F q) :
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
          · exact finiteBumpOverwrite_smoothCompact cutoff f g _ hf hg hc
          · exact finiteBumpOverwrite_smoothCompact cutoff f g _ hf hg hc
          · intro x hx
            simp [finiteBumpOverwrite, Finset.prod_insert hi, hsupport i x hx]
        _ = F f := ih

/-- Nonessentiality on a compact set prevents an arbitrary functional from
distinguishing smooth compactly supported fields equal outside that set. -/
theorem smoothCompact_eq_of_no_essential_on_compact
    (F : (ℝ → E) → W) (K : Set ℝ) (hK : IsCompact K)
    (f g : ℝ → E) (hf : IsSmoothCompactField f) (hg : IsSmoothCompactField g)
    (houtside : ∀ x, x ∉ K → f x = g x)
    (hnon : ∀ x ∈ K, ¬ IsEssentialPointOnClass IsSmoothCompactField F x) : F f = F g := by
  classical
  have hlocal (x : K) : ∃ r : ℝ, 0 < r ∧
      ∀ (p q : ℝ → E), IsSmoothCompactField p → IsSmoothCompactField q →
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
  have hsame := finiteBumpOverwrite_smoothCompact_functional_eq F
    (fun i : K => ball (i : ℝ) (radius i)) (fun i => bump i) f g s hf hg
    (fun i => (bump i).contDiff)
    (by
      intro i x hx
      exact Function.notMem_support.mp (by simpa [(bump i).support_eq] using hx))
    hinvariant
  rw [hpatch] at hsame
  exact hsame.symm

/-- A distinguishable compactly confined perturbation meets the essential
set computed in the same smooth compact admitted class. -/
theorem smoothCompact_compact_perturbation_meets_essential
    (F : (ℝ → E) → W) (K : Set ℝ) (hK : IsCompact K)
    (f g : ℝ → E) (hf : IsSmoothCompactField f) (hg : IsSmoothCompactField g)
    (houtside : ∀ x, x ∉ K → f x = g x) (hne : F f ≠ F g) :
    ∃ x ∈ K, IsEssentialPointOnClass IsSmoothCompactField F x := by
  by_contra h
  push_neg at h
  exact hne (smoothCompact_eq_of_no_essential_on_compact F K hK f g hf hg houtside h)

/-- All-data SAME-observable convergence on the smooth compact class forces
lower-limit containment for the actual fixed-mesh essential domains on that
same class. This asserts no finite-p-to-pointwise transfer or PDE solution law. -/
theorem smoothCompact_convergence_essential_lowerLimit
    {V : Type*} [NormedAddCommGroup V]
    (exactValue : (ℝ → E) → V) (approximation : ℕ → (ℝ → E) → V)
    (hconverges : ∀ f, IsSmoothCompactField f →
      Tendsto (fun n => approximation n f) atTop (𝓝 (exactValue f))) :
    {x | IsEssentialPointOnClass IsSmoothCompactField exactValue x} ⊆
      numericalLimitingDomain
        (fun n => {x | IsEssentialPointOnClass IsSmoothCompactField (approximation n) x}) := by
  intro x hx radius hradius
  obtain ⟨f, g, hf, hg, houtside, hne⟩ := hx (radius / 2) (half_pos hradius)
  have heventual := ((hconverges f hf).sub (hconverges g hg)).eventually_ne
    (sub_ne_zero.mpr hne)
  filter_upwards [heventual] with n hn
  obtain ⟨y, hy, hessential⟩ := smoothCompact_compact_perturbation_meets_essential
    (approximation n) (closedBall x (radius / 2)) (isCompact_closedBall _ _) f g hf hg
    (fun z hz => houtside z (fun hball => hz (ball_subset_closedBall hball)))
    (fun h => hn (sub_eq_zero.mpr h))
  exact ⟨y, hessential, lt_of_le_of_lt hy (half_lt_self hradius)⟩

end NumStability
