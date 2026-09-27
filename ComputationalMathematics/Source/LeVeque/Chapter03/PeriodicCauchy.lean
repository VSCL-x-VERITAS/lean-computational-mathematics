/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.CauchySolution
import ComputationalMathematics.Source.LeVeque.Chapter03.PeriodicBoundary
import Mathlib.Algebra.Order.ToIntervalMod

/-!
# Periodic Cauchy data and boundary traces

This is the direct periodicity part of Example 3.4 on printed page 61/raw PDF
page 83. It applies to the explicit whole-line initial-data solution, even
when the initial profile is not differentiable.
-/

namespace NumStability

/-- Periodicity of the whole-line initial state with spatial period `period`. -/
def leveque03_IsPeriodicInitialState
    {m : ℕ} (initialState : ℝ → (Fin m → ℝ)) (period : ℝ) : Prop :=
  ∀ x, initialState (x + period) = initialState x

/-- Repeat interval data on the half-open cell `[a,b)` using the canonical
interval-modulo map. Values at the seam agree when the endpoint data agree. -/
noncomputable def leveque03_periodicExtension
    {m : ℕ} (initialState : ℝ → (Fin m → ℝ))
    (a b : ℝ) (hab : a < b) : ℝ → (Fin m → ℝ) :=
  fun x => initialState (toIcoMod (sub_pos.mpr hab) a x)

theorem leveque03_periodicExtension_periodic
    {m : ℕ} (initialState : ℝ → (Fin m → ℝ))
    (a b : ℝ) (hab : a < b) :
    leveque03_IsPeriodicInitialState
      (leveque03_periodicExtension initialState a b hab) (b - a) := by
  intro x
  exact congrArg initialState ((toIcoMod_periodic (sub_pos.mpr hab) a) x)

theorem leveque03_periodicExtension_agrees_halfOpen
    {m : ℕ} (initialState : ℝ → (Fin m → ℝ))
    (a b : ℝ) (hab : a < b) (x : ℝ)
    (hx : a ≤ x ∧ x < b) :
    leveque03_periodicExtension initialState a b hab x = initialState x := by
  unfold leveque03_periodicExtension
  have hcell : x ∈ Set.Ico a (a + (b - a)) := by
    simpa only [Set.mem_Ico, show a + (b - a) = b by ring] using hx
  rw [(toIcoMod_eq_self (sub_pos.mpr hab)).mpr hcell]

theorem leveque03_periodicExtension_agrees_closed
    {m : ℕ} (initialState : ℝ → (Fin m → ℝ))
    (a b : ℝ) (hab : a < b)
    (hcompat : initialState a = initialState b)
    (x : ℝ) (hx : a ≤ x ∧ x ≤ b) :
    leveque03_periodicExtension initialState a b hab x = initialState x := by
  rcases lt_or_eq_of_le hx.2 with hlt | heq
  · exact leveque03_periodicExtension_agrees_halfOpen
      initialState a b hab x ⟨hx.1, hlt⟩
  · subst x
    have ha : toIcoMod (sub_pos.mpr hab) a a = a :=
      (toIcoMod_eq_self (sub_pos.mpr hab)).mpr
        (by simpa [Set.mem_Ico] using (show a ≤ a ∧ a < b from ⟨le_refl a, hab⟩))
    have hperiod := (toIcoMod_periodic (sub_pos.mpr hab) a) a
    have hb : toIcoMod (sub_pos.mpr hab) a b = a := by
      simpa only [show a + (b - a) = b by ring, ha] using hperiod
    simp [leveque03_periodicExtension, hb, hcompat]

/-- If the supplied whole-line initial data are already periodic, repeating
their restriction to one cell recovers exactly the same global profile. -/
theorem leveque03_periodicExtension_eq_of_periodic
    {m : ℕ} (initialState : ℝ → (Fin m → ℝ))
    (a b : ℝ) (hab : a < b)
    (hperiodic : leveque03_IsPeriodicInitialState initialState (b - a)) :
    leveque03_periodicExtension initialState a b hab = initialState := by
  funext x
  unfold leveque03_periodicExtension
  obtain ⟨_, z, hx⟩ := (toIcoMod_eq_iff (sub_pos.mpr hab)).mp
    (show toIcoMod (sub_pos.mpr hab) a x =
      toIcoMod (sub_pos.mpr hab) a x from rfl)
  have hper : Function.Periodic initialState (b - a) := hperiodic
  calc
    initialState (toIcoMod (sub_pos.mpr hab) a x) =
        initialState (toIcoMod (sub_pos.mpr hab) a x + z • (b - a)) :=
      (hper.zsmul z _).symm
    _ = initialState x := congrArg initialState hx.symm

/-- Translating periodic initial data along each characteristic preserves the
same spatial period in the constructed Cauchy solution. -/
theorem leveque03_initialDataSolution_periodic
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (eigenvalues : Fin m → ℝ)
    (initialState : ℝ → (Fin m → ℝ)) (period : ℝ)
    (hperiodic : leveque03_IsPeriodicInitialState initialState period) :
    ∀ x t,
      leveque03_initialDataSolution eigenbasis eigenvalues initialState
          (x + period) t =
        leveque03_initialDataSolution eigenbasis eigenvalues initialState x t := by
  intro x t
  unfold leveque03_initialDataSolution
  apply congrArg (fun f : Fin m → ℝ =>
    ((Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis).mulVec f)
  funext p
  unfold leveque03_initialCharacteristicVariables
  have hx : x + period - eigenvalues p * t =
      (x - eigenvalues p * t) + period := by ring
  rw [hx, hperiodic (x - eigenvalues p * t)]

/-- The whole-line solution from periodic initial data satisfies the paired
boundary values at the endpoints of one spatial period. -/
theorem leveque03_initialDataSolution_periodicBoundary
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (eigenvalues : Fin m → ℝ)
    (initialState : ℝ → (Fin m → ℝ)) (a b : ℝ)
    (hperiodic : leveque03_IsPeriodicInitialState initialState (b - a)) :
    leveque03_IsPeriodicBoundary
      (leveque03_initialDataSolution eigenbasis eigenvalues initialState) a b := by
  intro t _
  have h := leveque03_initialDataSolution_periodic eigenbasis eigenvalues
    initialState (b - a) hperiodic a t
  have hab : a + (b - a) = b := by ring
  rw [hab] at h
  exact h.symm

/-- Every differentiable whole-line Cauchy solution with this constant
eigenbasis agrees with the explicitly translated initial data. -/
theorem leveque03_periodicCauchy_unique
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (eigenvalues : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      eigenvalues p • eigenbasis p)
    (initialState : ℝ → (Fin m → ℝ))
    (q : ℝ → ℝ → (Fin m → ℝ))
    (hq : Differentiable ℝ (Function.uncurry q))
    (hpde : ∀ x t, IsConstantCoefficientLinearSystemSolutionAt q coefficient x t)
    (hinit : ∀ x, q x 0 = initialState x)
    (x t : ℝ) :
    q x t = leveque03_initialDataSolution eigenbasis eigenvalues initialState x t := by
  rw [leveque03_cauchySolution coefficient eigenbasis eigenvalues heigen
    initialState q hq hpde hinit x t]
  exact (leveque03_initialDataSolution_formula eigenbasis eigenvalues
    initialState x t).symm

/-- A classical whole-line Cauchy solution from periodic initial data obeys
the periodic boundary condition on the chosen spatial interval. -/
theorem leveque03_periodicCauchy_boundary
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (eigenvalues : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      eigenvalues p • eigenbasis p)
    (initialState : ℝ → (Fin m → ℝ)) (a b : ℝ)
    (hperiodic : leveque03_IsPeriodicInitialState initialState (b - a))
    (q : ℝ → ℝ → (Fin m → ℝ))
    (hq : Differentiable ℝ (Function.uncurry q))
    (hpde : ∀ x t, IsConstantCoefficientLinearSystemSolutionAt q coefficient x t)
    (hinit : ∀ x, q x 0 = initialState x) :
    leveque03_IsPeriodicBoundary q a b := by
  intro t ht
  rw [leveque03_periodicCauchy_unique coefficient eigenbasis eigenvalues
    heigen initialState q hq hpde hinit a t,
    leveque03_periodicCauchy_unique coefficient eigenbasis eigenvalues
      heigen initialState q hq hpde hinit b t]
  exact leveque03_initialDataSolution_periodicBoundary
    eigenbasis eigenvalues initialState a b hperiodic t ht

/-- Periodic differentiable initial characteristic data construct a classical
whole-line Cauchy solution satisfying the source's endpoint condition (3.41).
The construction uses the existing m-family reconstruction theorem. -/
theorem leveque03_periodicCauchyConstruction
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (eigenvalues : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      eigenvalues p • eigenbasis p)
    (initialState : ℝ → (Fin m → ℝ))
    (hdiff : ∀ p, Differentiable ℝ
      (fun x => leveque03_initialCharacteristicVariables eigenbasis initialState x p))
    (a b : ℝ)
    (hperiodic : leveque03_IsPeriodicInitialState initialState (b - a)) :
    (∀ x t, IsConstantCoefficientLinearSystemSolutionAt
      (leveque03_initialDataSolution eigenbasis eigenvalues initialState)
      coefficient x t) ∧
    (∀ x, leveque03_initialDataSolution eigenbasis eigenvalues initialState x 0 =
      initialState x) ∧
    leveque03_IsPeriodicBoundary
      (leveque03_initialDataSolution eigenbasis eigenvalues initialState) a b := by
  let w : ℝ → ℝ → Fin m → ℝ := fun x t p =>
    travelingWave
      (fun y => leveque03_initialCharacteristicVariables eigenbasis initialState y p)
      (eigenvalues p) x t
  have hw : ∀ p x t, IsLinearAdvectionSolutionAt
      (fun y s => w y s p) (eigenvalues p) x t := by
    intro p x t
    exact (travelingWave_isLinearAdvectionSolution (eigenvalues p) (hdiff p)) x t
  have hwi : ∀ x, w x 0 =
      leveque03_initialCharacteristicVariables eigenbasis initialState x := by
    intro x
    funext p
    simp [w, travelingWave]
  have hsys := leveque03_reconstructedCauchySolution coefficient eigenbasis
    eigenvalues heigen initialState w hw hwi
  refine ⟨?_, ?_, leveque03_initialDataSolution_periodicBoundary
    eigenbasis eigenvalues initialState a b hperiodic⟩
  · intro x t
    change IsConstantCoefficientLinearSystemSolutionAt
      (fun ξ τ => ((Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis).mulVec (w ξ τ))
      coefficient x t
    exact hsys.1 x t
  · intro x
    change ((Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis).mulVec (w x 0) =
      initialState x
    exact hsys.2 x

end NumStability
