/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ThreePointInfluenceDomains
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningGridCoverage
import ComputationalMathematics.Source.LeVeque.Chapter04.ThreePointPhysicalDomain

/-!
# LeVeque Chapter 4: the separately labeled structural domain

The displayed three-point read graph fills the limiting interval. This
structural interpretation is valid and preserved explicitly; it does not
assert whole-interval functional influence for each fixed numerical method.
The separate functional diagnosis records the distinction without attributing
an unconditional mathematical error to the author.
-/

open Set Filter
open scoped BigOperators Topology
namespace NumStability

/-- Source-facing structural domain contract: the fixed displayed read
 graph is characterized explicitly, actual fixed-method influence is contained
 in it, and reachable physical sites fill the limiting interval. -/
def Leveque04ThreePointStructuralDomainTarget : Prop :=
  Leveque04ThreePointPhysicalDomainTarget ∧
  (∀ steps : ℕ, ∀ observation : ℤ,
    threePointStencilReadGraphDomain steps observation =
      Icc (observation-(steps : ℤ)) (observation+(steps : ℤ)) ∧
    threePointPermittedInfluenceDomain steps observation =
      threePointStencilReadGraphDomain steps observation) ∧
  (∀ (F : ℕ → ℤ → ℝ → ℝ → ℝ → ℝ) (steps : ℕ) (observation site : ℤ),
    InitialSiteInfluences
      (fun k u j => F k j (u (j-1)) (u j) (u (j+1))) steps observation site →
    site ∈ threePointStencilReadGraphDomain steps observation) ∧
  (∀ (X T ratio : ℝ) (dt width : ℕ → ℝ) (steps : ℕ → ℕ),
    0 < ratio → (∀ k, 0 < width k) → (∀ k, dt k = ratio*width k) →
    (∀ k, (steps k : ℝ)*dt k = T) → Tendsto width atTop (nhds 0) →
    ∀ y ∈ Icc (X-T/ratio) (X+T/ratio), ∃ site : ℕ → ℤ,
      (∀ k, site k ∈ threePointStencilReadGraphDomain (steps k) 0) ∧
      Tendsto (fun k => X+(site k : ℝ)*width k) atTop (nhds y))
/-- Explicitly labeled structural correction, rather than a silent
replacement for fixed-method functional dependence. -/
def Leveque04ThreePointStructuralCorrectionTarget : Prop :=
  Leveque04ThreePointStructuralDomainTarget


theorem leveque04_threePointStructuralCorrection :
    Leveque04ThreePointStructuralCorrectionTarget := by
  change Leveque04ThreePointStructuralDomainTarget
  refine ⟨leveque04_threePointPhysicalDomain,?_,?_,?_⟩
  · intro steps observation
    exact ⟨threePoint_readGraphDomain_eq steps observation,
      (threePoint_readGraph_eq_permittedInfluence steps observation).symm⟩
  · intro F steps observation site h
    rw [threePoint_readGraphDomain_eq]
    exact threePoint_fixedMethod_influence_subset F steps observation site h
  · intro X T ratio dt width steps hratio hwidth hdt hscale hw y hy
    have hphysical (k : ℕ) : (steps k : ℝ)*width k = T/ratio := by
      apply (eq_div_iff hratio.ne').mpr
      calc
        (steps k : ℝ)*width k*ratio = (steps k : ℝ)*dt k := by rw [hdt k]; ring
        _ = T := hscale k
    obtain ⟨site,hbound,hlimit⟩ := threePoint_refining_sites_fill_interval
      X (T/ratio) width steps hwidth hphysical hw y hy
    refine ⟨site,?_,hlimit⟩
    intro k
    rw [threePoint_readGraphDomain_eq]
    simpa only [zero_sub,zero_add] using hbound k


end NumStability
