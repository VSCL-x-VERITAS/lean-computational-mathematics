/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePeriodicFluxDifference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.MonotoneConservativeContraction
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PeriodicGridSamples
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface
import Mathlib.Data.ZMod.Basic

/-!
# Finite periodic selected Godunov flux and conservation

The finite periodic step uses the selected certified Riemann method at each
ordered adjacent pair. Its conservation is structural; an L1 accuracy transfer
additionally needs a monotonicity certificate for the selected solver.
-/

namespace NumStability

/-- The ordered scalar Riemann problem for two prescribed cell values. -/
def leveque04_scalarPairRiemannProblem
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (left right : ℝ) : HyperbolicRiemannProblem law :=
  { leftState := fun _ => left, rightState := fun _ => right }

/-- The ordered scalar Riemann problem at the left face of periodic cell `i`. -/
def leveque04_periodicScalarRiemannProblem
    {n : ℕ} [NeZero n]
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (u : ZMod n → ℝ) (i : ZMod n) : HyperbolicRiemannProblem law :=
  leveque04_scalarPairRiemannProblem law (u (i - 1)) (u i)

/-- The scalar component of the flux selected from a certified Riemann solve
at a periodic left face. -/
noncomputable def leveque04_periodicSelectedGodunovFaceFlux
    {n : ℕ} [NeZero n] {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin 1)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (hdomain : ∀ (u : ZMod n → ℝ) (i : ZMod n),
      method.domain (leveque04_periodicScalarRiemannProblem law u i))
    (u : ZMod n → ℝ) (i : ZMod n) : ℝ :=
  method.numericalFluxFromInformation
    (method.extractInformation
      (method.solve (leveque04_periodicScalarRiemannProblem law u i)
        (hdomain u i))) 0

/-- The selected two-state numerical flux when the certified solver covers
every ordered scalar pair. -/
noncomputable def leveque04_selectedGodunovTwoStateFlux
    {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin 1)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (hpairs : ∀ left right,
      method.domain (leveque04_scalarPairRiemannProblem law left right))
    (left right : ℝ) : ℝ :=
  method.numericalFluxFromInformation
    (method.extractInformation
      (method.solve (leveque04_scalarPairRiemannProblem law left right)
        (hpairs left right))) 0

/-- The selected scalar flux inherits physical constant-state consistency
from the certified Riemann interface method. -/
theorem leveque04_selectedGodunovTwoStateFlux_consistent
    {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin 1)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (hpairs : ∀ left right,
      method.domain (leveque04_scalarPairRiemannProblem law left right))
    (state : ℝ) :
    leveque04_selectedGodunovTwoStateFlux method hpairs state state =
      law.physicalFlux (fun _ : Fin 1 => state) 0 := by
  simpa [leveque04_selectedGodunovTwoStateFlux,
    leveque04_scalarPairRiemannProblem] using
    congrArg (fun v : Fin 1 → ℝ => v 0)
      (method.consistent_on_constant_states (fun _ : Fin 1 => state))

/-- The conservative finite periodic update using the actual selected
Riemann face-flux procedure. -/
noncomputable def leveque04_periodicSelectedGodunovStep
    {n : ℕ} [NeZero n] {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin 1)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (hdomain : ∀ (u : ZMod n → ℝ) (i : ZMod n),
      method.domain (leveque04_periodicScalarRiemannProblem law u i))
    (ratio : ℝ) (u : ZMod n → ℝ) (i : ZMod n) : ℝ :=
  finitePeriodicFluxDifferenceUpdate (Equiv.addRight (1 : ZMod n)) ratio
    u (leveque04_periodicSelectedGodunovFaceFlux method hdomain u) i

/-- With a solver defined on all scalar pairs, the selected periodic step is
the generic two-state numerical-flux step for that very solver. -/
theorem leveque04_periodicSelectedGodunovStep_eq_twoState
    {n : ℕ} [NeZero n] {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin 1)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (hpairs : ∀ left right,
      method.domain (leveque04_scalarPairRiemannProblem law left right))
    (ratio : ℝ) (u : ZMod n → ℝ) (i : ZMod n) :
    leveque04_periodicSelectedGodunovStep method
      (fun v j => hpairs (v (j - 1)) (v j)) ratio u i =
    finitePeriodicTwoStateFluxStep n
      (leveque04_selectedGodunovTwoStateFlux method hpairs) ratio u i := by
  rfl

/-- Every constant periodic scalar state is fixed by the selected
Godunov flux-difference step, for any time-step-to-width ratio. -/
theorem leveque04_periodicSelectedGodunovStep_constant
    {n : ℕ} [NeZero n] {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin 1)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (hpairs : ∀ left right,
      method.domain (leveque04_scalarPairRiemannProblem law left right))
    (ratio state : ℝ) (i : ZMod n) :
    leveque04_periodicSelectedGodunovStep method
      (fun v j => hpairs (v (j - 1)) (v j)) ratio (fun _ => state) i = state := by
  rw [leveque04_periodicSelectedGodunovStep_eq_twoState]
  simp [finitePeriodicTwoStateFluxStep,
    finitePeriodicFluxDifferenceUpdate]

/-- Monotonicity of the selected Riemann-flux update follows from concrete
two-state flux directions and their local CFL bound. Those solver properties
remain explicit obligations for a nonlinear entropy-selected instance. -/
theorem leveque04_periodicSelectedGodunovStep_monotone_of_flux
    {n : ℕ} [NeZero n] {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin 1)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (hpairs : ∀ left right,
      method.domain (leveque04_scalarPairRiemannProblem law left right))
    (ratio : ℝ) (hratio : 0 ≤ ratio)
    (hleft : ∀ a b c, a ≤ b →
      leveque04_selectedGodunovTwoStateFlux method hpairs a c ≤
        leveque04_selectedGodunovTwoStateFlux method hpairs b c)
    (hright : ∀ a b c, a ≤ b →
      leveque04_selectedGodunovTwoStateFlux method hpairs c b ≤
        leveque04_selectedGodunovTwoStateFlux method hpairs c a)
    (hcfl : ∀ a b l r, a ≤ b →
      ratio * ((leveque04_selectedGodunovTwoStateFlux method hpairs b r -
        leveque04_selectedGodunovTwoStateFlux method hpairs a r) +
        (leveque04_selectedGodunovTwoStateFlux method hpairs l a -
          leveque04_selectedGodunovTwoStateFlux method hpairs l b)) ≤ b - a)
    (u v : ZMod n → ℝ) (huv : ∀ i, u i ≤ v i) (i : ZMod n) :
    leveque04_periodicSelectedGodunovStep method
      (fun w j => hpairs (w (j - 1)) (w j)) ratio u i ≤
    leveque04_periodicSelectedGodunovStep method
      (fun w j => hpairs (w (j - 1)) (w j)) ratio v i := by
  rw [leveque04_periodicSelectedGodunovStep_eq_twoState,
    leveque04_periodicSelectedGodunovStep_eq_twoState]
  exact finitePeriodicTwoStateFluxStep_monotone n
    (leveque04_selectedGodunovTwoStateFlux method hpairs) ratio
    hratio hleft hright hcfl u v huv i

/-- One-sided Lipschitz bounds for the actual selected scalar Riemann flux
replace the four-state local CFL premise by a mesh-ratio bound. -/
theorem leveque04_periodicSelectedGodunovStep_monotone_of_lipschitz
    {n : ℕ} [NeZero n] {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin 1)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (hpairs : ∀ left right,
      method.domain (leveque04_scalarPairRiemannProblem law left right))
    (ratio leftBound rightBound : ℝ)
    (hratio : 0 ≤ ratio)
    (hcfl : ratio * (leftBound + rightBound) ≤ 1)
    (hleft : ∀ a b c, a ≤ b →
      leveque04_selectedGodunovTwoStateFlux method hpairs a c ≤
        leveque04_selectedGodunovTwoStateFlux method hpairs b c)
    (hright : ∀ a b c, a ≤ b →
      leveque04_selectedGodunovTwoStateFlux method hpairs c b ≤
        leveque04_selectedGodunovTwoStateFlux method hpairs c a)
    (hleftBound : ∀ a b c, a ≤ b →
      leveque04_selectedGodunovTwoStateFlux method hpairs b c -
        leveque04_selectedGodunovTwoStateFlux method hpairs a c ≤
          leftBound * (b - a))
    (hrightBound : ∀ a b c, a ≤ b →
      leveque04_selectedGodunovTwoStateFlux method hpairs c a -
        leveque04_selectedGodunovTwoStateFlux method hpairs c b ≤
          rightBound * (b - a))
    (u v : ZMod n → ℝ) (huv : ∀ i, u i ≤ v i)
    (i : ZMod n) :
    leveque04_periodicSelectedGodunovStep method
      (fun w j => hpairs (w (j - 1)) (w j)) ratio u i ≤
    leveque04_periodicSelectedGodunovStep method
      (fun w j => hpairs (w (j - 1)) (w j)) ratio v i := by
  rw [leveque04_periodicSelectedGodunovStep_eq_twoState,
    leveque04_periodicSelectedGodunovStep_eq_twoState]
  exact finitePeriodicTwoStateFluxStep_monotone_of_lipschitz n
    (leveque04_selectedGodunovTwoStateFlux method hpairs)
    ratio leftBound rightBound hratio hcfl hleft hright
    hleftBound hrightBound u v huv i

/-- The selected Godunov periodic step preserves the total scalar cell sum
for every ratio, independently of monotonicity or accuracy conditions. -/
theorem leveque04_periodicSelectedGodunovStep_conserve
    {n : ℕ} [NeZero n] {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin 1)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (hdomain : ∀ (u : ZMod n → ℝ) (i : ZMod n),
      method.domain (leveque04_periodicScalarRiemannProblem law u i))
    (ratio : ℝ) (u : ZMod n → ℝ) :
    (∑ i, leveque04_periodicSelectedGodunovStep method hdomain ratio u i) =
      ∑ i, u i := by
  exact finitePeriodicFluxDifferenceUpdate_conserve
    (Equiv.addRight (1 : ZMod n)) ratio u
    (leveque04_periodicSelectedGodunovFaceFlux method hdomain u)

/-- The actual finite periodic selected Riemann-flux step contracts L1
distance when its two-state flux has the stated directions and one-sided
Lipschitz bounds under the corresponding CFL ratio. -/
theorem leveque04_periodicSelectedGodunovStep_l1_contract_of_lipschitz
    {n : ℕ} [NeZero n] {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin 1)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (hpairs : ∀ left right,
      method.domain (leveque04_scalarPairRiemannProblem law left right))
    (ratio leftBound rightBound : ℝ)
    (hratio : 0 ≤ ratio)
    (hcfl : ratio * (leftBound + rightBound) ≤ 1)
    (hleft : ∀ a b c, a ≤ b →
      leveque04_selectedGodunovTwoStateFlux method hpairs a c ≤
        leveque04_selectedGodunovTwoStateFlux method hpairs b c)
    (hright : ∀ a b c, a ≤ b →
      leveque04_selectedGodunovTwoStateFlux method hpairs c b ≤
        leveque04_selectedGodunovTwoStateFlux method hpairs c a)
    (hleftBound : ∀ a b c, a ≤ b →
      leveque04_selectedGodunovTwoStateFlux method hpairs b c -
        leveque04_selectedGodunovTwoStateFlux method hpairs a c ≤
          leftBound * (b - a))
    (hrightBound : ∀ a b c, a ≤ b →
      leveque04_selectedGodunovTwoStateFlux method hpairs c a -
        leveque04_selectedGodunovTwoStateFlux method hpairs c b ≤
          rightBound * (b - a))
    (u v : ZMod n → ℝ) :
    (∑ i, |leveque04_periodicSelectedGodunovStep method
        (fun w j => hpairs (w (j - 1)) (w j)) ratio u i -
      leveque04_periodicSelectedGodunovStep method
        (fun w j => hpairs (w (j - 1)) (w j)) ratio v i|) ≤
      ∑ i, |u i - v i| := by
  apply finiteMonotoneConservative_l1_contract
    (leveque04_periodicSelectedGodunovStep method
      (fun w j => hpairs (w (j - 1)) (w j)) ratio)
  · intro a b hab i
    exact leveque04_periodicSelectedGodunovStep_monotone_of_lipschitz
      method hpairs ratio leftBound rightBound hratio hcfl
      hleft hright hleftBound hrightBound a b hab i
  · intro a
    exact leveque04_periodicSelectedGodunovStep_conserve
      method (fun w j => hpairs (w (j - 1)) (w j)) ratio a

/-- A monotone selected periodic Godunov update accumulates local defects
additively in finite-grid L1. The monotonicity premise is deliberately explicit:
it must be certified for the chosen nonlinear Riemann method and CFL range. -/
theorem leveque04_periodicSelectedGodunov_iterate_error
    {n : ℕ} [NeZero n] {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin 1)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (hdomain : ∀ (u : ZMod n → ℝ) (i : ZMod n),
      method.domain (leveque04_periodicScalarRiemannProblem law u i))
    (ratio : ℝ)
    (hmono : ∀ u v : ZMod n → ℝ, (∀ i, u i ≤ v i) → ∀ i,
      leveque04_periodicSelectedGodunovStep method hdomain ratio u i ≤
        leveque04_periodicSelectedGodunovStep method hdomain ratio v i)
    (approx exactState residual : ℕ → ZMod n → ℝ)
    (happrox : ∀ k i, approx (k + 1) i =
      leveque04_periodicSelectedGodunovStep method hdomain ratio (approx k) i)
    (hexact : ∀ k i, exactState (k + 1) i =
      leveque04_periodicSelectedGodunovStep method hdomain ratio
        (exactState k) i + residual k i)
    (steps : ℕ) :
    (∑ i, |approx steps i - exactState steps i|) ≤
      (∑ i, |approx 0 i - exactState 0 i|) +
        ∑ k ∈ Finset.range steps, ∑ i, |residual k i| := by
  exact finiteMonotoneConservative_iterate_error
    (leveque04_periodicSelectedGodunovStep method hdomain ratio)
    hmono (leveque04_periodicSelectedGodunovStep_conserve method hdomain ratio)
    approx exactState residual happrox hexact steps

/-- The selected nonlinear step inherits finite-time L1 error accumulation
from explicit two-state flux directions and their CFL bound. The remaining
accuracy obligation is a quantitative local defect for exact cell averages. -/
theorem leveque04_periodicSelectedGodunov_iterate_error_of_flux
    {n : ℕ} [NeZero n] {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin 1)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (hpairs : ∀ left right,
      method.domain (leveque04_scalarPairRiemannProblem law left right))
    (ratio : ℝ) (hratio : 0 ≤ ratio)
    (hleft : ∀ a b c, a ≤ b →
      leveque04_selectedGodunovTwoStateFlux method hpairs a c ≤
        leveque04_selectedGodunovTwoStateFlux method hpairs b c)
    (hright : ∀ a b c, a ≤ b →
      leveque04_selectedGodunovTwoStateFlux method hpairs c b ≤
        leveque04_selectedGodunovTwoStateFlux method hpairs c a)
    (hcfl : ∀ a b l r, a ≤ b →
      ratio * ((leveque04_selectedGodunovTwoStateFlux method hpairs b r -
        leveque04_selectedGodunovTwoStateFlux method hpairs a r) +
        (leveque04_selectedGodunovTwoStateFlux method hpairs l a -
          leveque04_selectedGodunovTwoStateFlux method hpairs l b)) ≤ b - a)
    (approx exactState residual : ℕ → ZMod n → ℝ)
    (happrox : ∀ k i, approx (k + 1) i =
      leveque04_periodicSelectedGodunovStep method
        (fun w j => hpairs (w (j - 1)) (w j)) ratio (approx k) i)
    (hexact : ∀ k i, exactState (k + 1) i =
      leveque04_periodicSelectedGodunovStep method
        (fun w j => hpairs (w (j - 1)) (w j)) ratio
        (exactState k) i + residual k i)
    (steps : ℕ) :
    (∑ i, |approx steps i - exactState steps i|) ≤
      (∑ i, |approx 0 i - exactState 0 i|) +
        ∑ k ∈ Finset.range steps, ∑ i, |residual k i| := by
  apply leveque04_periodicSelectedGodunov_iterate_error method
    (fun w j => hpairs (w (j - 1)) (w j)) ratio
  · intro u v huv i
    exact leveque04_periodicSelectedGodunovStep_monotone_of_flux
      method hpairs ratio hratio hleft hright hcfl u v huv i
  · exact happrox
  · exact hexact

/-- A uniform first-order local defect gives a fixed-horizon first-order
mean L1 error for the selected periodic Riemann-flux update, conditional on
the concrete flux direction and CFL bounds. -/
theorem leveque04_periodicSelectedGodunov_fixedHorizonMeanError
    {n : ℕ} [NeZero n] {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin 1)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (hpairs : ∀ left right,
      method.domain (leveque04_scalarPairRiemannProblem law left right))
    (ratio timeStep width localBound horizon : ℝ)
    (hratio : 0 ≤ ratio) (hwidth : 0 < width)
    (hbound : 0 ≤ localBound)
    (hleft : ∀ a b c, a ≤ b →
      leveque04_selectedGodunovTwoStateFlux method hpairs a c ≤
        leveque04_selectedGodunovTwoStateFlux method hpairs b c)
    (hright : ∀ a b c, a ≤ b →
      leveque04_selectedGodunovTwoStateFlux method hpairs c b ≤
        leveque04_selectedGodunovTwoStateFlux method hpairs c a)
    (hcfl : ∀ a b l r, a ≤ b →
      ratio * ((leveque04_selectedGodunovTwoStateFlux method hpairs b r -
        leveque04_selectedGodunovTwoStateFlux method hpairs a r) +
        (leveque04_selectedGodunovTwoStateFlux method hpairs l a -
          leveque04_selectedGodunovTwoStateFlux method hpairs l b)) ≤ b - a)
    (approx exactState residual : ℕ → ZMod n → ℝ)
    (happrox : ∀ k i, approx (k + 1) i =
      leveque04_periodicSelectedGodunovStep method
        (fun w j => hpairs (w (j - 1)) (w j)) ratio (approx k) i)
    (hexact : ∀ k i, exactState (k + 1) i =
      leveque04_periodicSelectedGodunovStep method
        (fun w j => hpairs (w (j - 1)) (w j)) ratio
        (exactState k) i + residual k i)
    (hlocal : ∀ k i, |residual k i| ≤ timeStep * localBound * width)
    (steps : ℕ) (hhorizon : (steps : ℝ) * timeStep ≤ horizon) :
    (∑ i, |approx steps i - exactState steps i|) /
        (Fintype.card (ZMod n) : ℝ) ≤
      (∑ i, |approx 0 i - exactState 0 i|) /
        (Fintype.card (ZMod n) : ℝ) +
          horizon * localBound * width := by
  exact finiteMonotoneConservative_fixedHorizonMeanError
    (leveque04_periodicSelectedGodunovStep method
      (fun w j => hpairs (w (j - 1)) (w j)) ratio)
    (by
      intro u v huv i
      exact leveque04_periodicSelectedGodunovStep_monotone_of_flux
        method hpairs ratio hratio hleft hright hcfl u v huv i)
    (leveque04_periodicSelectedGodunovStep_conserve method
      (fun w j => hpairs (w (j - 1)) (w j)) ratio)
    timeStep width localBound horizon hwidth hbound
    approx exactState residual happrox hexact hlocal steps hhorizon

/-- A quadratic adjacent error in the actual selected Riemann face flux gives
a first-order one-step defect for the finite periodic conservative update. -/
theorem leveque04_periodicSelectedGodunov_localDefect_of_faceDifference
    {n : ℕ} [NeZero n] {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin 1)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (hdomain : ∀ (u : ZMod n → ℝ) (i : ZMod n),
      method.domain (leveque04_periodicScalarRiemannProblem law u i))
    (old exactFace exactNext : ZMod n → ℝ)
    (timeStep width bound : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hexact : ∀ i, exactNext i =
      finitePeriodicFluxDifferenceUpdate (Equiv.addRight (1 : ZMod n))
        (timeStep / width) old exactFace i)
    (hface : ∀ i,
      let numericalFace := leveque04_periodicSelectedGodunovFaceFlux
        method hdomain old
      |((numericalFace (i + 1) - exactFace (i + 1)) -
          (numericalFace i - exactFace i))| ≤ bound * width ^ 2)
    (i : ZMod n) :
    |leveque04_periodicSelectedGodunovStep method hdomain
        (timeStep / width) old i - exactNext i| ≤
      timeStep * bound * width := by
  exact finitePeriodicFluxDifferenceUpdate_localDefect_of_faceDifference
    (Equiv.addRight (1 : ZMod n)) old exactFace
    (leveque04_periodicSelectedGodunovFaceFlux method hdomain old)
    exactNext timeStep width bound htime hwidth hexact hface i

/-- A periodic differentiable extension of the selected-minus-ideal face
error supplies the adjacent error bound for the actual selected flux. -/
theorem leveque04_periodicSelectedGodunov_faceDifference_of_smoothError
    {n : ℕ} [NeZero n] (hn : 2 ≤ n) {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin 1)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (hdomain : ∀ (u : ZMod n → ℝ) (i : ZMod n),
      method.domain (leveque04_periodicScalarRiemannProblem law u i))
    (old exactFace : ZMod n → ℝ)
    (error error' : ℝ → ℝ) (width bound : ℝ) (hwidth : 0 < width)
    (hsample : ∀ i,
      leveque04_periodicSelectedGodunovFaceFlux method hdomain old i -
        exactFace i = error ((i.val : ℝ) * width))
    (hperiod : ∀ x, error (x + (n : ℝ) * width) = error x)
    (hderiv : ∀ x, HasDerivAt error (error' x) x)
    (hderivBound : ∀ x, |error' x| ≤ bound * width)
    (i : ZMod n) :
    let numericalFace := leveque04_periodicSelectedGodunovFaceFlux
      method hdomain old
    |((numericalFace (i + 1) - exactFace (i + 1)) -
        (numericalFace i - exactFace i))| ≤ bound * width ^ 2 := by
  dsimp only
  rw [hsample (i + 1), hsample i]
  exact periodicSmoothFaceError_adjacent_bound n hn
    error error' width bound hwidth hperiod hderiv hderivBound i

/-- A mesh-uniform adjacent selected-face error and the exact conservative
balance give a fixed-horizon first-order mean L1 bound. The face-error and
selected-solver hypotheses remain explicit proof obligations. -/
theorem leveque04_periodicSelectedGodunov_fixedHorizonMeanError_of_faceDifference
    {n : ℕ} [NeZero n] {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin 1)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (hpairs : ∀ left right,
      method.domain (leveque04_scalarPairRiemannProblem law left right))
    (timeStep width bound horizon : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < width) (hbound : 0 ≤ bound)
    (hleft : ∀ a b c, a ≤ b →
      leveque04_selectedGodunovTwoStateFlux method hpairs a c ≤
        leveque04_selectedGodunovTwoStateFlux method hpairs b c)
    (hright : ∀ a b c, a ≤ b →
      leveque04_selectedGodunovTwoStateFlux method hpairs c b ≤
        leveque04_selectedGodunovTwoStateFlux method hpairs c a)
    (hcfl : ∀ a b l r, a ≤ b →
      (timeStep / width) *
        ((leveque04_selectedGodunovTwoStateFlux method hpairs b r -
          leveque04_selectedGodunovTwoStateFlux method hpairs a r) +
          (leveque04_selectedGodunovTwoStateFlux method hpairs l a -
            leveque04_selectedGodunovTwoStateFlux method hpairs l b)) ≤ b - a)
    (approx exactState : ℕ → ZMod n → ℝ)
    (exactFace : ℕ → ZMod n → ℝ)
    (happrox : ∀ k i, approx (k + 1) i =
      leveque04_periodicSelectedGodunovStep method
        (fun w j => hpairs (w (j - 1)) (w j)) (timeStep / width)
        (approx k) i)
    (hexact : ∀ k i, exactState (k + 1) i =
      finitePeriodicFluxDifferenceUpdate (Equiv.addRight (1 : ZMod n))
        (timeStep / width) (exactState k) (exactFace k) i)
    (hface : ∀ k i,
      let numericalFace := leveque04_periodicSelectedGodunovFaceFlux
        method (fun w j => hpairs (w (j - 1)) (w j)) (exactState k)
      |((numericalFace (i + 1) - exactFace k (i + 1)) -
          (numericalFace i - exactFace k i))| ≤ bound * width ^ 2)
    (steps : ℕ) (hhorizon : (steps : ℝ) * timeStep ≤ horizon) :
    (∑ i, |approx steps i - exactState steps i|) /
        (Fintype.card (ZMod n) : ℝ) ≤
      (∑ i, |approx 0 i - exactState 0 i|) /
        (Fintype.card (ZMod n) : ℝ) + horizon * bound * width := by
  let hdomain : ∀ (w : ZMod n → ℝ) (j : ZMod n),
      method.domain (leveque04_periodicScalarRiemannProblem law w j) :=
    fun w j => hpairs (w (j - 1)) (w j)
  let residual : ℕ → ZMod n → ℝ := fun k i =>
    exactState (k + 1) i -
      leveque04_periodicSelectedGodunovStep method hdomain
        (timeStep / width) (exactState k) i
  have hexactResidual : ∀ k i, exactState (k + 1) i =
      leveque04_periodicSelectedGodunovStep method hdomain
        (timeStep / width) (exactState k) i + residual k i := by
    intro k i
    dsimp [residual]
    ring
  have hlocal : ∀ k i, |residual k i| ≤ timeStep * bound * width := by
    intro k i
    have hstep := leveque04_periodicSelectedGodunov_localDefect_of_faceDifference
      method hdomain (exactState k) (exactFace k) (exactState (k + 1))
      timeStep width bound htime hwidth (hexact k) (hface k) i
    simpa only [residual, abs_sub_comm] using hstep
  exact leveque04_periodicSelectedGodunov_fixedHorizonMeanError
    method hpairs (timeStep / width) timeStep width bound horizon
    (div_nonneg htime.le hwidth.le) hwidth hbound
    hleft hright hcfl approx exactState residual
    happrox hexactResidual hlocal steps hhorizon

end NumStability
