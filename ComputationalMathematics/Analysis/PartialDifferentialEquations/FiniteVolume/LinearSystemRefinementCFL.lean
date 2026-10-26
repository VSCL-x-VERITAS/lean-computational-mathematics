/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AdvectionRefinementCFL
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearCharacteristicCoordinates
import Mathlib.Analysis.Normed.Module.FiniteDimension
import Mathlib.Tactic
/-!
# CFL necessity for coupled linear-system refinement

Testing the full vector numerical evolution with one injected characteristic
mode derives each necessary speed bound. The numerical update need not
preserve or decouple the characteristic modes. Exact physical evolution,
its coordinate formula and rectangle conservation are existing producers.
-/

open Set Filter MeasureTheory
open scoped Topology
namespace NumStability

def IsVectorCenteredStencilUpdateFamily (radius : ℕ)
    {m : ℕ} (update : ℕ → ℕ → (ℤ → Fin m → ℝ) → ℤ → Fin m → ℝ) : Prop :=
  ∀ n k (left right : ℤ → Fin m → ℝ) (i : ℤ),
    (∀ j ∈ Icc (i-(radius : ℤ)) (i+(radius : ℤ)), left j = right j) →
      update n k left i = update n k right i

def IsVectorLocalRefinementInitialization {m : ℕ}
    (initialData : ℕ → (ℝ → Fin m → ℝ) → ℤ → Fin m → ℝ) (X T ratio : ℝ) : Prop :=
  ∀ n (f g : ℝ → Fin m → ℝ), Continuous f → Continuous g → ∀ j : ℤ,
    EqOn f g (Icc
      (X+(j : ℝ)*fixedRatioRefinementCellWidth T ratio n-
        fixedRatioRefinementCellWidth T ratio n/2)
      (X+(j : ℝ)*fixedRatioRefinementCellWidth T ratio n+
        fixedRatioRefinementCellWidth T ratio n/2)) →
      initialData n f j = initialData n g j

def IsLinearSystemRefinementConvergent {m : ℕ}
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (update : ℕ → ℕ → (ℤ → Fin m → ℝ) → ℤ → Fin m → ℝ)
    (initialData : ℕ → (ℝ → Fin m → ℝ) → ℤ → Fin m → ℝ) (X T : ℝ) : Prop :=
  ∀ f : ℝ → Fin m → ℝ, Continuous f →
    Tendsto (fun n => centeredStencilEvolution (update n) (initialData n f) (n+1) 0)
      atTop (nhds (linearCharacteristicEvolution basis speeds f X T))


/-- Actual coupled vector evolution is tested with one injected eigenmode;
no numerical decoupling or scalar projected update is assumed. -/
theorem linearSystemRefinement_eachCourant_le
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (update : ℕ → ℕ → (ℤ → Fin m → ℝ) → ℤ → Fin m → ℝ)
    (initialData : ℕ → (ℝ → Fin m → ℝ) → ℤ → Fin m → ℝ)
    (radius : ℕ) (X T ratio : ℝ) (hT : 0 < T) (hratio : 0 < ratio)
    (hlocal : ∀ n k (left right : ℤ → Fin m → ℝ) (i : ℤ),
      (∀ j ∈ Icc (i-(radius : ℤ)) (i+(radius : ℤ)), left j = right j) →
        update n k left i = update n k right i)
    (hinitial : ∀ n (f g : ℝ → Fin m → ℝ), Continuous f → Continuous g → ∀ j : ℤ,
      EqOn f g (Icc
        (X+(j : ℝ)*fixedRatioRefinementCellWidth T ratio n-
          fixedRatioRefinementCellWidth T ratio n/2)
        (X+(j : ℝ)*fixedRatioRefinementCellWidth T ratio n+
          fixedRatioRefinementCellWidth T ratio n/2)) →
        initialData n f j = initialData n g j)
    (hconverges : ∀ f : ℝ → Fin m → ℝ, Continuous f →
      Tendsto (fun n => centeredStencilEvolution (update n) (initialData n f) (n+1) 0)
        atTop (nhds (linearCharacteristicEvolution basis speeds f X T))) :
    ∀ p, |speeds p| *ratio ≤ radius := by
  classical
  intro p
  let width := fun n : ℕ => T/(ratio*((n+1 : ℕ) : ℝ))
  let Rn := fun n : ℕ => ((n+1 : ℕ) : ℝ)*radius*width n+width n/2
  let domain := fun n : ℕ => Icc (X-Rn n) (X+Rn n)
  let inject := fun f : ℝ → ℝ => fun x => f x • basis p
  let coordinate := fun v : Fin m → ℝ => basis.equivFun v p
  let approximation := fun n (f : ℝ → ℝ) => coordinate
    (centeredStencilEvolution (update n) (initialData n (inject f)) (n+1) 0)
  have hcoordinate : Continuous coordinate :=
    (continuous_apply p).comp basis.equivFun.toContinuousLinearEquiv.continuous
  have hinject (f : ℝ → ℝ) (hf : Continuous f) : Continuous (inject f) :=
    hf.smul continuous_const
  have hw (n : ℕ) : 0 ≤ width n := by dsimp [width]; positivity
  have hlocalPhysical : ∀ n f g, Continuous f → Continuous g →
      (∀ y ∈ domain n, f y = g y) → approximation n f = approximation n g := by
    intro n f g hf hg hagree
    apply congrArg coordinate
    apply centeredStencilEvolution_localInitialization
      (update n) radius (initialData n) X (width n) (hw n) (hlocal n)
        (inject f) (inject g) (n+1) 0
    · exact hinitial n (inject f) (inject g) (hinject f hf) (hinject g hg)
    · intro x hx
      have hx' : x ∈ domain n := by
        simpa only [domain,Rn,Int.cast_zero,zero_mul,add_zero,sub_add_eq_sub_sub,add_assoc] using hx
      dsimp [inject]
      rw [hagree x hx']
  have hconv : ∀ f : ℝ → ℝ, Continuous f →
      Tendsto (fun n => approximation n f) atTop (nhds (f (X-speeds p*T))) := by
    intro f hf
    have h := hcoordinate.continuousAt.tendsto.comp (hconverges (inject f) (hinject f hf))
    have hvalue : coordinate (linearCharacteristicEvolution basis speeds (inject f) X T) =
        f (X-speeds p*T) := by
      change basis.equivFun (linearCharacteristicEvolution basis speeds (inject f) X T) p = f (X-speeds p*T)
      rw [linearCharacteristicEvolution_coordinate]
      simp [inject]
    simpa only [Function.comp_def,approximation,hvalue] using h
  have hlimit : Tendsto Rn atTop (nhds ((radius : ℝ)*T/ratio)) :=
    fixedRatioRefinement_cellConeRadius_tendsto T ratio radius hratio
  have hnecessary := convergence_admissible_limiting_closedCone
    Continuous (fun f => f (X-speeds p*T)) domain approximation X ((radius : ℝ)*T/ratio) Rn
    hlocalPhysical hconv (fun _ => Subset.refl _) hlimit (X-speeds p*T)
    (evaluation_continuous_essential_neighborhood _)
  have hdisplacement : |speeds p| *T ≤ (radius : ℝ)*T/ratio := by
    simpa only [sub_sub_cancel_left,abs_neg,abs_mul,abs_of_pos hT] using hnecessary
  have hb := (le_div_iff₀ hratio).mp hdisplacement
  apply (mul_le_mul_iff_left₀ hT).mp
  nlinarith [hb]

/-- The reused characteristic evolution is an actual rectangle conservation
solution for every continuous vector datum and starts with that datum. -/
theorem linearCharacteristicEvolution_continuous_initial_reference
    {m : ℕ} (A : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (initial : ℝ → Fin m → ℝ) (hcontinuous : Continuous initial) :
    (∀ x, linearCharacteristicEvolution basis speeds initial x 0 = initial x) ∧
    IsRectangleConservationLawSolution
      (linearCharacteristicEvolution basis speeds initial) A.mulVec := by
  constructor
  · exact linearCharacteristicEvolution_initial basis speeds initial
  · apply linearCharacteristicEvolution_isRectangleSolution A basis speeds heigen initial
    intro p a b
    exact ((continuous_apply p).comp
      (basis.equivFun.toContinuousLinearEquiv.continuous.comp hcontinuous)).intervalIntegrable a b

end NumStability
