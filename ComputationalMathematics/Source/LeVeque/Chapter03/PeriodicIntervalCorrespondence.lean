/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.PeriodicSeam
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearSystems.ForwardCauchy

/-!
# Example 3.4: interval and whole-line correspondence

Printed page 61/raw PDF page 83. The Cauchy-to-interval direction is
constructed from compatible interval data. The converse periodizes a
classical interval solution, glues its positive-time derivatives at the
seam, and applies forward-time uniqueness.
-/

namespace NumStability

theorem leveque03_periodicCauchy_fromInterval
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (eigenvalues : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      eigenvalues p • eigenbasis p)
    (initialState : ℝ → (Fin m → ℝ))
    (a b : ℝ) (hab : a < b)
    (hcompat : initialState a = initialState b)
    (hdiff : ∀ p, Differentiable ℝ
      (fun x => leveque03_initialCharacteristicVariables eigenbasis
        (leveque03_periodicExtension initialState a b hab) x p)) :
    (∀ x t, IsConstantCoefficientLinearSystemSolutionAt
      (leveque03_initialDataSolution eigenbasis eigenvalues
        (leveque03_periodicExtension initialState a b hab))
      coefficient x t) ∧
    (∀ x, a ≤ x → x ≤ b →
      leveque03_initialDataSolution eigenbasis eigenvalues
        (leveque03_periodicExtension initialState a b hab) x 0 =
        initialState x) ∧
    leveque03_IsPeriodicBoundary
      (leveque03_initialDataSolution eigenbasis eigenvalues
        (leveque03_periodicExtension initialState a b hab)) a b := by
  have hperiodic := leveque03_periodicExtension_periodic initialState a b hab
  obtain ⟨hpde, hinit, hboundary⟩ :=
    leveque03_periodicCauchyConstruction coefficient eigenbasis eigenvalues
      heigen (leveque03_periodicExtension initialState a b hab)
      hdiff a b hperiodic
  refine ⟨hpde, ?_, hboundary⟩
  intro x hxa hxb
  rw [hinit x]
  exact leveque03_periodicExtension_agrees_closed initialState a b hab
    hcompat x ⟨hxa, hxb⟩

/-- Given an independently supplied global classical extension, Cauchy
uniqueness identifies it with the periodic-data formula. The theorem below
constructs the needed positive-time extension from an interval solution. -/
theorem leveque03_periodicInterval_eq_of_classicalExtension
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (eigenvalues : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      eigenvalues p • eigenbasis p)
    (initialState : ℝ → (Fin m → ℝ))
    (a b : ℝ) (hab : a < b)
    (q Q : ℝ → ℝ → (Fin m → ℝ))
    (hQdiff : Differentiable ℝ (Function.uncurry Q))
    (hQPDE : ∀ x t, IsConstantCoefficientLinearSystemSolutionAt
      Q coefficient x t)
    (hQinit : ∀ x,
      Q x 0 = leveque03_periodicExtension initialState a b hab x)
    (hQagree : ∀ x t, a ≤ x → x ≤ b → 0 ≤ t → q x t = Q x t) :
    ∀ x t, a ≤ x → x ≤ b → 0 ≤ t →
      q x t =
        leveque03_initialDataSolution eigenbasis eigenvalues
          (leveque03_periodicExtension initialState a b hab) x t := by
  intro x t hxa hxb ht
  rw [hQagree x t hxa hxb ht]
  exact leveque03_periodicCauchy_unique coefficient eigenbasis eigenvalues
    heigen (leveque03_periodicExtension initialState a b hab)
    Q hQdiff hQPDE hQinit x t

/-- A classical periodic interval solution agrees, at nonnegative times,
with the whole-line Cauchy formula for its periodically repeated initial data.
The system is noncharacteristic at the boundary, and the interval solution is
jointly continuous through the initial line and classical at positive times. -/
theorem leveque03_periodicInterval_eq_cauchySolution
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (eigenvalues : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      eigenvalues p • eigenbasis p)
    (hnonzero : ∀ p, eigenvalues p ≠ 0)
    (initialState : ℝ → (Fin m → ℝ))
    (a b : ℝ) (hab : a < b)
    (q : ℝ → ℝ → (Fin m → ℝ))
    (hboundary : leveque03_IsPeriodicBoundary q a b)
    (hcont : ∀ y t, a ≤ y → y ≤ b → 0 ≤ t →
      ContinuousAt (Function.uncurry q) (y, t))
    (hdiff : ∀ y t, a ≤ y → y ≤ b → 0 < t →
      DifferentiableAt ℝ (Function.uncurry q) (y, t))
    (hpde : ∀ y t, a ≤ y → y ≤ b → 0 < t →
      IsConstantCoefficientLinearSystemSolutionAt q coefficient y t)
    (hinit : ∀ y, a ≤ y → y ≤ b → q y 0 = initialState y) :
    ∀ x t, a ≤ x → x ≤ b → 0 ≤ t →
      q x t =
        leveque03_initialDataSolution eigenbasis eigenvalues
          (leveque03_periodicExtension initialState a b hab) x t := by
  let Q : ℝ → ℝ → (Fin m → ℝ) :=
    fun ξ τ => q (toIcoMod (sub_pos.mpr hab) a ξ) τ
  have hinj : Function.Injective coefficient.mulVec :=
    matrix_mulVec_injective_of_nonzero_eigenvalues
      coefficient eigenbasis eigenvalues heigen hnonzero
  have hQcont : ContinuousOn (Function.uncurry Q)
      (Set.prod Set.univ (Set.Ici 0)) :=
    leveque03_periodicContinuation_continuousOn q a b hab hboundary hcont
  have hQdiff : DifferentiableOn ℝ (Function.uncurry Q)
      (Set.prod Set.univ (Set.Ioi 0)) := by
    intro z hz
    exact (leveque03_periodicContinuation_jointDifferentiable
      coefficient hinj q a b hab hboundary hdiff hpde z.1 z.2 hz.2).differentiableWithinAt
  have hQpde : ∀ x t, 0 < t →
      IsConstantCoefficientLinearSystemSolutionAt Q coefficient x t :=
    leveque03_periodicContinuation_pde coefficient hinj
      q a b hab hboundary hdiff hpde
  have hQinit : ∀ x,
      Q x 0 = leveque03_periodicExtension initialState a b hab x := by
    intro x
    have hcell := toIcoMod_mem_Ico (sub_pos.mpr hab) a x
    have hb : toIcoMod (sub_pos.mpr hab) a x ≤ b := by
      dsimp at hcell ⊢
      linarith [hcell.2]
    exact hinit _ hcell.1 hb
  intro x t hxa hxb ht
  have hcompat : (fun y => q y t) a = (fun y => q y t) b :=
    hboundary t ht
  have hQagree : Q x t = q x t :=
    leveque03_periodicExtension_agrees_closed
      (fun y => q y t) a b hab hcompat x ⟨hxa, hxb⟩
  rw [← hQagree]
  have hforward := constantCoefficientSystem_forwardCauchy
    coefficient eigenbasis eigenvalues heigen Q hQcont hQdiff hQpde x t ht
  calc
    Q x t = ∑ p,
        (eigenbasis.equivFun (Q (x - eigenvalues p * t) 0) p) •
          eigenbasis p := hforward
    _ = ∑ p,
        (eigenbasis.equivFun
          (leveque03_periodicExtension initialState a b hab
            (x - eigenvalues p * t)) p) • eigenbasis p := by
          apply Finset.sum_congr rfl
          intro p _
          rw [hQinit]
    _ = leveque03_initialDataSolution eigenbasis eigenvalues
          (leveque03_periodicExtension initialState a b hab) x t := by
          rw [leveque03_initialDataSolution_formula]
          apply Finset.sum_congr rfl
          intro p _
          congr 1
          exact (congrFun (leveque03_characteristicCoordinates eigenbasis
            (leveque03_periodicExtension initialState a b hab
              (x - eigenvalues p * t))) p).symm

end NumStability
