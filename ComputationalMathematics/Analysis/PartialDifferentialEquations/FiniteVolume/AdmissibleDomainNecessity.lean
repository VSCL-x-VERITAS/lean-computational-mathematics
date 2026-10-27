/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Topology.Instances.Real.Lemmas
import Mathlib.Analysis.Calculus.BumpFunction.FiniteDimension
import Mathlib.Analysis.Normed.Group.Continuity
import Mathlib.Tactic.Linarith

/-!
# Limiting numerical dependence on admitted initial data

Local changes within the admitted data class force numerical domains to meet
every neighborhood of an essential input point. Closed limiting cones then
contain that point. Continuous scalar evaluation admits smooth bump witnesses, which lift to nontrivial vector fields.
The existing scalar dependence APIs forward to the generic producer without changing their types.
-/

open Set Metric Filter
open scoped Topology
namespace NumStability

/-- Admissible neighborhood dependence for arbitrary data and vector outputs.
This does not assume singleton perturbations in a continuous data class. -/
def IsEssentialPointOnClass
    {X E V : Type*} [PseudoMetricSpace X]
    (admissible : (X → E) → Prop) (exactValue : (X → E) → V) (point : X) : Prop :=
  ∀ radius : ℝ, 0 < radius → ∃ f g : X → E,
    admissible f ∧ admissible g ∧
      (∀ y, y ∉ ball point radius → f y = g y) ∧ exactValue f ≠ exactValue g


/-- Every neighborhood meets every sufficiently refined numerical domain. -/
def numericalLimitingDomain {X : Type*} [PseudoMetricSpace X]
    (numericalDomain : ℕ → Set X) : Set X :=
  {point | ∀ radius : ℝ, 0 < radius →
    ∀ᶠ n in atTop, ∃ y ∈ numericalDomain n, y ∈ ball point radius}



theorem convergentPair_eventually_distinguishes_admissible_data
    {X E V : Type*} [NormedAddCommGroup V]
    (admissible : (X → E) → Prop) (exactValue : (X → E) → V)
    (numericalDomain : ℕ → Set X) (approximation : ℕ → (X → E) → V)
    (hlocal : ∀ n f g, admissible f → admissible g →
      (∀ y ∈ numericalDomain n, f y = g y) → approximation n f = approximation n g)
    (f g : X → E) (hadmf : admissible f) (hadmg : admissible g)
    (hf : Tendsto (fun n => approximation n f) atTop (𝓝 (exactValue f)))
    (hg : Tendsto (fun n => approximation n g) atTop (𝓝 (exactValue g)))
    (hdifferent : exactValue f ≠ exactValue g) :
    ∀ᶠ n in atTop, ∃ y ∈ numericalDomain n, f y ≠ g y := by
  have hne := (hf.sub hg).eventually_ne (sub_ne_zero.mpr hdifferent)
  filter_upwards [hne] with n hn
  by_contra hmissing
  have hfg : approximation n f = approximation n g := by
    apply hlocal n f g hadmf hadmg
    intro y hy
    by_contra hneq
    exact hmissing ⟨y,hy,hneq⟩
  exact hn (sub_eq_zero.mpr hfg)

theorem convergence_admissible_essential_neighborhood
    {X E V : Type*} [PseudoMetricSpace X] [NormedAddCommGroup V]
    (admissible : (X → E) → Prop) (exactValue : (X → E) → V)
    (numericalDomain : ℕ → Set X) (approximation : ℕ → (X → E) → V)
    (hlocal : ∀ n f g, admissible f → admissible g →
      (∀ y ∈ numericalDomain n, f y = g y) → approximation n f = approximation n g)
    (hconverges : ∀ f, admissible f →
      Tendsto (fun n => approximation n f) atTop (𝓝 (exactValue f)))
    (point : X) (hessential : IsEssentialPointOnClass admissible exactValue point)
    (radius : ℝ) (hradius : 0 < radius) :
    ∀ᶠ n in atTop, ∃ y ∈ numericalDomain n, y ∈ ball point radius := by
  obtain ⟨f,g,hf,hg,houtside,hdistinct⟩ := hessential radius hradius
  have h := convergentPair_eventually_distinguishes_admissible_data
    admissible exactValue numericalDomain approximation hlocal f g hf hg
    (hconverges f hf) (hconverges g hg) hdistinct
  filter_upwards [h] with n ⟨y,hy,hneq⟩
  refine ⟨y,hy,?_⟩
  by_contra hout
  exact hneq (houtside y hout)

theorem convergence_essential_domain_subset
    {X E V : Type*} [PseudoMetricSpace X] [NormedAddCommGroup V]
    (admissible : (X → E) → Prop) (exactValue : (X → E) → V)
    (numericalDomain : ℕ → Set X) (approximation : ℕ → (X → E) → V)
    (hlocal : ∀ n f g, admissible f → admissible g →
      (∀ y ∈ numericalDomain n, f y = g y) → approximation n f = approximation n g)
    (hconverges : ∀ f, admissible f →
      Tendsto (fun n => approximation n f) atTop (𝓝 (exactValue f))) :
    {point | IsEssentialPointOnClass admissible exactValue point} ⊆
      numericalLimitingDomain numericalDomain := by
  intro point hpoint radius hradius
  exact convergence_admissible_essential_neighborhood
    admissible exactValue numericalDomain approximation hlocal hconverges
    point hpoint radius hradius



theorem convergentPair_eventually_distinguishes_input
    {X : Type*} (admissible : (X → ℝ) → Prop) (exactValue : (X → ℝ) → ℝ)
    (numericalDomain : ℕ → Set X) (approximation : ℕ → (X → ℝ) → ℝ)
    (hlocal : ∀ n f g, admissible f → admissible g → (∀ y ∈ numericalDomain n, f y = g y) →
      approximation n f = approximation n g)
    (f g : X → ℝ) (hadmf : admissible f) (hadmg : admissible g)
    (hf : Tendsto (fun n => approximation n f) atTop (𝓝 (exactValue f)))
    (hg : Tendsto (fun n => approximation n g) atTop (𝓝 (exactValue g)))
    (hdifferent : exactValue f ≠ exactValue g) :
    ∀ᶠ n in atTop, ∃ y ∈ numericalDomain n, f y ≠ g y := by
  exact convergentPair_eventually_distinguishes_admissible_data
    admissible exactValue numericalDomain approximation hlocal f g hadmf hadmg hf hg hdifferent

/-- The dependence domain relative to an admitted data class uses changes
supported in every neighborhood, rather than singleton changes. -/
def IsAdmissibleEssentialPoint
    {X : Type*} [PseudoMetricSpace X] (admissible : (X → ℝ) → Prop)
    (exactValue : (X → ℝ) → ℝ) (point : X) : Prop :=
  ∀ radius : ℝ, 0 < radius → ∃ f g : X → ℝ,
    admissible f ∧ admissible g ∧
      (∀ y, y ∉ ball point radius → f y = g y) ∧ exactValue f ≠ exactValue g

theorem convergence_admissible_domain_neighborhood
    {X : Type*} [PseudoMetricSpace X] (admissible : (X → ℝ) → Prop)
    (exactValue : (X → ℝ) → ℝ)
    (numericalDomain : ℕ → Set X) (approximation : ℕ → (X → ℝ) → ℝ)
    (hlocal : ∀ n f g, admissible f → admissible g → (∀ y ∈ numericalDomain n, f y = g y) →
      approximation n f = approximation n g)
    (hconverges : ∀ f, admissible f →
      Tendsto (fun n => approximation n f) atTop (𝓝 (exactValue f)))
    (point : X) (hessential : IsAdmissibleEssentialPoint admissible exactValue point)
    (radius : ℝ) (hradius : 0 < radius) :
    ∀ᶠ n in atTop, ∃ y ∈ numericalDomain n, y ∈ ball point radius := by
  exact convergence_admissible_essential_neighborhood
    admissible exactValue numericalDomain approximation hlocal hconverges point hessential radius hradius

theorem evaluation_continuous_essential_neighborhood (point : ℝ) :
    IsAdmissibleEssentialPoint Continuous (fun f => f point) point := by
  intro radius hradius
  let cutoff : ContDiffBump point := ⟨radius / 2,radius,half_pos hradius,half_lt_self hradius⟩
  refine ⟨(fun y => cutoff y),(fun _ => 0),(cutoff.contDiff (n := 1)).continuous,
    continuous_const,?_,?_⟩
  · intro y hy
    have hsupport : y ∉ Function.support (fun z => cutoff z) := by
      simpa only [cutoff.support_eq,cutoff] using hy
    exact Function.notMem_support.mp hsupport
  · have hone : cutoff point = 1 := cutoff.one_of_mem_closedBall (mem_closedBall_self cutoff.rIn_pos.le)
    simpa only [hone] using (by norm_num : (1 : ℝ) ≠ 0)


/-- Scalar continuous perturbation witnesses lift to nontrivial vector fields. -/
theorem evaluation_continuous_essentialPointOnClass
    {V : Type*} [NormedAddCommGroup V] [NormedSpace ℝ V] [Nontrivial V]
    (point : ℝ) :
    IsEssentialPointOnClass (E := V) (V := V)
      Continuous (fun f => f point) point := by
  intro radius hradius
  obtain ⟨f,g,hf,hg,houtside,hdifferent⟩ :=
    evaluation_continuous_essential_neighborhood point radius hradius
  obtain ⟨v,hv⟩ := exists_ne (0 : V)
  refine ⟨(fun y => f y • v),(fun y => g y • v),hf.smul continuous_const,
    hg.smul continuous_const,?_,?_⟩
  · intro y hy
    dsimp only
    rw [houtside y hy]
  · intro heq
    dsimp only at heq
    have hzero : (f point-g point) • v = 0 := by
      rw [sub_smul,heq,sub_self]
    rcases smul_eq_zero.mp hzero with hscalar | hvector
    · exact hdifferent (sub_eq_zero.mp hscalar)
    · exact hv hvector


theorem convergence_admissible_limiting_closedCone
    (admissible : (ℝ → ℝ) → Prop) (exactValue : (ℝ → ℝ) → ℝ)
    (numericalDomain : ℕ → Set ℝ) (approximation : ℕ → (ℝ → ℝ) → ℝ)
    (center limitRadius : ℝ) (radius : ℕ → ℝ)
    (hlocal : ∀ n f g, admissible f → admissible g → (∀ y ∈ numericalDomain n, f y = g y) →
      approximation n f = approximation n g)
    (hconverges : ∀ f, admissible f →
      Tendsto (fun n => approximation n f) atTop (𝓝 (exactValue f)))
    (hcone : ∀ n, numericalDomain n ⊆ Icc (center-radius n) (center+radius n))
    (hlimit : Tendsto radius atTop (𝓝 limitRadius))
    (point : ℝ) (hessential : IsAdmissibleEssentialPoint admissible exactValue point) :
    |point-center| ≤ limitRadius := by
  by_contra hnot
  have hgap : limitRadius < |point-center| := lt_of_not_ge hnot
  let ε := (|point-center|-limitRadius)/4
  have hε : 0 < ε := by dsimp [ε]; linarith
  have hradius : ∀ᶠ n in atTop, radius n < limitRadius+ε :=
    hlimit.eventually (Iio_mem_nhds (by linarith : limitRadius < limitRadius+ε))
  have hnear := convergence_admissible_domain_neighborhood
    admissible exactValue numericalDomain approximation hlocal hconverges point hessential ε hε
  obtain ⟨n,hn,⟨y,hy,hclose⟩⟩ := (hradius.and hnear).exists
  have hycone := hcone n hy
  have hybound : |y-center| ≤ radius n := abs_le.mpr ⟨by linarith [hycone.1],by linarith [hycone.2]⟩
  have hdist : |point-y| < ε := by
    rw [mem_ball,Real.dist_eq,abs_sub_comm] at hclose
    exact hclose
  have htriangle := abs_sub_le point y center
  dsimp [ε] at hn hdist
  linarith

end NumStability
