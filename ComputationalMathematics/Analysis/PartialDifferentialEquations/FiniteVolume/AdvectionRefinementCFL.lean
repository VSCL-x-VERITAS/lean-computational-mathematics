/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CenteredStencilEvolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AdmissibleDomainNecessity
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Tactic

/-!
# Advection CFL necessity under physical refinement

Actual time-indexed centered updates with local point or cell initialization
can converge on all continuous fields at one fixed physical observation only
if their limiting information cone covers the transported characteristic foot.
The ratio of time step to cell width is held fixed throughout refinement.
-/

open Set Filter
open scoped Topology
namespace NumStability

def IsCenteredStencilUpdateFamily
    (radius : ℕ) (update : ℕ → ℕ → (ℤ → ℝ) → ℤ → ℝ) : Prop :=
  ∀ n k (left right : ℤ → ℝ) (i : ℤ),
    (∀ j ∈ Icc (i-(radius : ℤ)) (i+(radius : ℤ)), left j = right j) →
      update n k left i = update n k right i

noncomputable def fixedRatioRefinementCellWidth (T ratio : ℝ) (n : ℕ) : ℝ :=
  T/(ratio*((n+1 : ℕ) : ℝ))

/-- Local initial data may be point samples, exact cell averages, or any
local data map. The locality premise compares the admitted continuous fields
on the actual closed physical cell; it does not assume the final CFL bound. -/
def IsLocalRefinementInitialization
    (initialData : ℕ → (ℝ → ℝ) → ℤ → ℝ) (X T ratio : ℝ) : Prop :=
  ∀ n (f g : ℝ → ℝ), Continuous f → Continuous g → ∀ j : ℤ,
    EqOn f g (Icc
      (X+(j : ℝ)*fixedRatioRefinementCellWidth T ratio n-
        fixedRatioRefinementCellWidth T ratio n/2)
      (X+(j : ℝ)*fixedRatioRefinementCellWidth T ratio n+
        fixedRatioRefinementCellWidth T ratio n/2)) →
      initialData n f j = initialData n g j

noncomputable def centeredRefinementApproximation
    (update : ℕ → ℕ → (ℤ → ℝ) → ℤ → ℝ)
    (initialData : ℕ → (ℝ → ℝ) → ℤ → ℝ) (n : ℕ) (f : ℝ → ℝ) : ℝ :=
  centeredStencilEvolution (update n) (initialData n f) (n+1) 0

def IsAdvectionRefinementConvergent
    (update : ℕ → ℕ → (ℤ → ℝ) → ℤ → ℝ)
    (initialData : ℕ → (ℝ → ℝ) → ℤ → ℝ) (speed X T : ℝ) : Prop :=
  ∀ f : ℝ → ℝ, Continuous f →
    Tendsto (fun n => centeredRefinementApproximation update initialData n f)
      atTop (𝓝 (f (X-speed*T)))

theorem fixedRatioRefinement_cellConeRadius_tendsto
    (T ratio : ℝ) (radius : ℕ) (hratio : 0 < ratio) :
    Tendsto (fun n : ℕ => ((n+1 : ℕ) : ℝ)*radius*(T/(ratio*((n+1 : ℕ) : ℝ))) +
      (T/(ratio*((n+1 : ℕ) : ℝ)))/2) atTop (𝓝 ((radius : ℝ)*T/ratio)) := by
  have hwidth : Tendsto (fun n : ℕ => T/(ratio*((n+1 : ℕ) : ℝ))) atTop (𝓝 0) := by
    have h := (tendsto_one_div_add_atTop_nhds_zero_nat (𝕜 := ℝ)).const_mul (T/ratio)
    convert h using 1
    · funext n
      have hn : ((n+1 : ℕ) : ℝ) ≠ 0 := by positivity
      simp only [Nat.cast_add,Nat.cast_one] at hn ⊢
      field_simp
    · simp
  have hidentity (n : ℕ) : ((n+1 : ℕ) : ℝ)*radius*(T/(ratio*((n+1 : ℕ) : ℝ))) =
      (radius : ℝ)*T/ratio := by
    have hn : ((n+1 : ℕ) : ℝ) ≠ 0 := by positivity
    field_simp
  simpa only [hidentity,zero_div,add_zero] using
    (tendsto_const_nhds (x := (radius : ℝ)*T/ratio)).add (hwidth.div_const 2)

theorem advectionRefinement_courant_le_of_localInitialization
    (update : ℕ → ℕ → (ℤ → ℝ) → ℤ → ℝ)
    (initialData : ℕ → (ℝ → ℝ) → ℤ → ℝ) (radius : ℕ) (speed X T ratio : ℝ)
    (hT : 0 < T) (hratio : 0 < ratio)
    (hlocal : ∀ n k (left right : ℤ → ℝ) (i : ℤ),
      (∀ j ∈ Icc (i-(radius : ℤ)) (i+(radius : ℤ)), left j = right j) →
        update n k left i = update n k right i)
    (hinitial : IsLocalRefinementInitialization initialData X T ratio)
    (hconverges : IsAdvectionRefinementConvergent update initialData speed X T) :
    |speed| * ratio ≤ radius := by
  let width := fun n : ℕ => T/(ratio*((n+1 : ℕ) : ℝ))
  let Rn := fun n : ℕ => ((n+1 : ℕ) : ℝ)*radius*width n + width n/2
  let domain := fun n : ℕ => Icc (X-Rn n) (X+Rn n)
  let approximation := fun n (f : ℝ → ℝ) =>
    centeredStencilEvolution (update n) (initialData n f) (n+1) 0
  have hw (n : ℕ) : 0 ≤ width n := by dsimp [width]; positivity
  have hlocalPhysical : ∀ n f g, Continuous f → Continuous g →
      (∀ y ∈ domain n, f y = g y) → approximation n f = approximation n g := by
    intro n f g hf hg hagree
    apply centeredStencilEvolution_localInitialization
      (update n) radius (initialData n) X (width n) (hw n) (hlocal n) f g (n+1) 0
    · exact hinitial n f g hf hg
    · simpa only [domain,Rn,Int.cast_zero,zero_mul,add_zero,sub_add_eq_sub_sub,add_assoc] using hagree
  have hlimit : Tendsto Rn atTop (𝓝 ((radius : ℝ)*T/ratio)) :=
    fixedRatioRefinement_cellConeRadius_tendsto T ratio radius hratio
  have hnecessary := convergence_admissible_limiting_closedCone
    Continuous (fun f => f (X-speed*T)) domain approximation X ((radius : ℝ)*T/ratio) Rn
    hlocalPhysical hconverges (fun _ => Subset.refl _) hlimit (X-speed*T)
    (evaluation_continuous_essential_neighborhood _)
  have hdisplacement : |speed| * T ≤ (radius : ℝ)*T/ratio := by
    simpa only [sub_sub_cancel_left,abs_neg,abs_mul,abs_of_pos hT] using hnecessary
  have hb := (le_div_iff₀ hratio).mp hdisplacement
  apply (mul_le_mul_iff_left₀ hT).mp
  nlinarith [hb]

end NumStability
