/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.MovingRiemannJump
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.StationaryJump
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalLinearAdvection
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.VariableCoefficient
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLipschitzTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageNeighborTaylor
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannSelfSimilarity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.TravelingJumpAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FirstOrderEquation
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.MaterialDerivative
import ComputationalMathematics.Analysis.PartialDifferentialEquations.VariableLinearFlux
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.Order.Ring.Abs
import Mathlib.Analysis.Calculus.ContDiff.Operations
import Mathlib.Analysis.Calculus.Deriv.Pow
import Mathlib.Analysis.Calculus.Deriv.Prod
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Analysis.Normed.Module.FiniteDimension
import Mathlib.Analysis.ODE.Gronwall
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import Mathlib.Analysis.SpecialFunctions.Log.Deriv
import Mathlib.Data.Matrix.Mul
import Mathlib.Data.Real.Basic
import Mathlib.MeasureTheory.Function.JacobianOneDim
import Mathlib.MeasureTheory.Integral.IntervalIntegral.AbsolutelyContinuousFun
import Mathlib.MeasureTheory.Measure.Lebesgue.EqHaar
import Mathlib.MeasureTheory.Measure.OpenPos
import Mathlib.Tactic.Abel
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.FunProp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
import Mathlib.Topology.MetricSpace.Lipschitz
import Mathlib.Topology.Order.Compact

/-!
# AffineExponentialRiemann

Source-independent mathematics. Actual derivatives, integrability and displayed analytic hypotheses are retained.
-/

namespace NumStability

open Set Filter MeasureTheory Topology
open scoped BigOperators Topology NNReal

/-- The backward characteristic label for the original variable-speed
transport equation with coefficient x+1. -/
noncomputable def variableTransportLabel (x t : ℝ) : ℝ := (x+1)*Real.exp (-t)-1

theorem variableTransportLabel_derivatives (x t : ℝ) :
    HasDerivAt (fun τ => variableTransportLabel x τ)
      (-((x+1)*Real.exp (-t))) t ∧
    HasDerivAt (fun ξ => variableTransportLabel ξ t) (Real.exp (-t)) x ∧
    (-((x+1)*Real.exp (-t)))+(x+1)*Real.exp (-t)=0 := by
  refine ⟨?_,?_,by ring⟩
  · simpa [variableTransportLabel] using
      ((((hasDerivAt_id t).neg.exp).const_mul (x+1)).sub_const 1)
  · simpa [variableTransportLabel] using
      (((hasDerivAt_id x).add_const 1).mul_const (Real.exp (-t))).sub_const 1

theorem variableTransportLabel_characteristic (origin t : ℝ) :
    variableTransportLabel ((origin+1)*Real.exp t-1) t = origin := by
  simp only [variableTransportLabel,sub_add_cancel,mul_assoc]
  rw [← Real.exp_add]
  simp

theorem variableTransportCurve_actual_speed (origin t : ℝ) :
    HasDerivAt (fun τ => (origin+1)*Real.exp τ-1)
      (((origin+1)*Real.exp t-1)+1) t := by
  simpa using ((Real.hasDerivAt_exp t).const_mul (origin+1)).sub_const 1

/-- Actual two-state characteristic transport recovers the Riemann initial
data and has its jump at the nonlinear characteristic issuing from zero. -/
theorem variableTransportRiemann_initial_and_front
    {State : Type*} (L O R : State) :
    IsRiemannData (fun x => riemannData L O R (variableTransportLabel x 0)) L R ∧
    (∀ x t, riemannData L O R (variableTransportLabel x t) =
      riemannData L O R (x-(Real.exp t-1))) ∧
    (∀ origin t, riemannData L O R
      (variableTransportLabel ((origin+1)*Real.exp t-1) t) = riemannData L O R origin) := by
  refine ⟨?_,?_,?_⟩
  · simpa [variableTransportLabel] using riemannData_isRiemannData L O R
  · intro x t
    have heq : variableTransportLabel x t = (x-(Real.exp t-1))*Real.exp (-t) := by
      have he : Real.exp t*Real.exp (-t)=1 := by rw [← Real.exp_add]; simp
      dsimp only [variableTransportLabel]
      nlinarith
    rw [heq]
    exact riemannData_mul_pos L O R _ (Real.exp_pos (-t))
  · intro origin t
    rw [variableTransportLabel_characteristic]

/-- The physical front's speed is not a global constant. This examines
only the literal global reading of the Chapter4 constant-speed wording. -/
theorem variableTransportFront_not_constant_speed :
    ¬ ∃ c : ℝ, ∀ t : ℝ, Real.exp t-1=c*t := by
  rintro ⟨c,hc⟩
  have heq : (fun t : ℝ => Real.exp t-1) = fun t => c*t := funext hc
  have hd (t : ℝ) : Real.exp t = c := by
    have h := (Real.hasDerivAt_exp t).sub_const 1
    rw [heq] at h
    simpa using h.unique ((hasDerivAt_id t).const_mul c)
  have h := Real.exp_injective ((hd 0).trans (hd 1).symm)
  norm_num at h

/-- The same original transported Riemann field is discontinuous at
the actual front exp(t)-1, rather than merely possessing a formal curve. -/
theorem variableTransportRiemann_discontinuous_front {m : ℕ}
    (L O R : Fin (m+1) → ℝ) (hne : L ≠ R) (t : ℝ) :
    ¬ ContinuousAt (fun x => riemannData L O R (variableTransportLabel x t))
      (Real.exp t-1) := by
  have heq : (fun x => riemannData L O R (variableTransportLabel x t)) =
      fun x => travelingWave (riemannData L O R) 1 x (Real.exp t-1) := by
    funext x
    simpa only [travelingWave,one_mul] using
      (variableTransportRiemann_initial_and_front L O R).2.1 x t
  rw [heq]
  simpa only [one_mul] using vectorStep_not_continuousAt_jump L O R hne 1 (Real.exp t-1)

/-- The actual transported Riemann field admits no fixed x/t profile,
even on one forward numerical step, when its two states differ. -/
theorem variableTransportRiemann_not_selfsimilar {State : Type*}
    (L O R : State) (hne : L ≠ R) :
    ¬ ∃ profile : ℝ → State, ∀ x t, t ∈ Set.Ioo (0:ℝ) 1 →
      riemannData L O R (variableTransportLabel x t)=profile (x/t) := by
  rintro ⟨profile,hprofile⟩
  let A := Real.exp (1/3:ℝ)-1
  let B := Real.exp (2/3:ℝ)-1
  have he : 1 < Real.exp (1/3:ℝ) := Real.one_lt_exp_iff.mpr (by norm_num)
  have hdouble : Real.exp (2/3:ℝ)=Real.exp (1/3:ℝ)*Real.exp (1/3:ℝ) := by
    rw [← Real.exp_add]
    congr 1
    norm_num
  have hgap : 2*A < B := by
    dsimp only [A,B]
    rw [hdouble]
    nlinarith [sq_pos_of_pos (sub_pos.mpr he)]
  let x := (A+B/2)/2
  have hright : 0 < x-A := by dsimp only [x];linarith
  have hleft : 2*x-B < 0 := by dsimp only [x];linarith
  have hr := hprofile x (1/3) (by norm_num)
  have hl := hprofile (2*x) (2/3) (by norm_num)
  rw [(variableTransportRiemann_initial_and_front L O R).2.1] at hr hl
  change riemannData L O R (x-A)=_ at hr
  change riemannData L O R (2*x-B)=_ at hl
  simp only [riemannData,not_lt.mpr hright.le,hright,ite_false,ite_true] at hr
  simp only [riemannData,hleft,ite_true] at hl
  have hratio : (2*x)/(2/3:ℝ)=x/(1/3:ℝ) := by ring
  rw [hratio] at hl
  exact hne (hl.trans hr.symm)

theorem variableTransportFront_not_constant_on_forward_step :
    ¬ ∃ c : ℝ, ∀ t ∈ Set.Ioo (0:ℝ) 1, Real.exp t-1=c*t := by
  rintro ⟨c,hc⟩
  have hd (t : ℝ) (ht : t ∈ Set.Ioo (0:ℝ) 1) : Real.exp t = c := by
    have heq : (fun τ : ℝ => Real.exp τ-1) =ᶠ[𝓝 t] fun τ => c*τ := by
      filter_upwards [isOpen_Ioo.mem_nhds ht] with τ hτ
      exact hc τ hτ
    have hline := ((hasDerivAt_id t).const_mul c).congr_of_eventuallyEq heq
    simpa using ((Real.hasDerivAt_exp t).sub_const 1).unique hline
  have h := Real.exp_injective ((hd (1/3) (by norm_num)).trans
    (hd (2/3) (by norm_num)).symm)
  norm_num at h

theorem variableTransportRiemann_forward_variable_speed_corrected :
    (∀ t ∈ Icc (0:ℝ) 1,
      HasDerivAt (fun τ => Real.exp τ-1) ((Real.exp t-1)+1) t ∧
      0 < (Real.exp t-1)+1 ∧ (Real.exp t-1)+1 ≤ Real.exp 1) ∧
    (¬ ∃ c : ℝ, ∀ t ∈ Ioo (0:ℝ) 1, Real.exp t-1=c*t) := by
  refine ⟨?_,variableTransportFront_not_constant_on_forward_step⟩
  intro t ht
  refine ⟨?_,?_,?_⟩
  · simpa only [sub_add_cancel] using (Real.hasDerivAt_exp t).sub_const 1
  · simpa only [sub_add_cancel] using Real.exp_pos t
  · simpa only [sub_add_cancel] using Real.exp_le_exp.mpr ht.2

/-- The actual characteristic Riemann field is not even spatially almost-
everywhere self-similar on a positive step. This failure occurs on an open
interval of positive volume, and survives changes on spatial null sets. -/
theorem variableTransportRiemann_not_ae_selfsimilar
    (L O R : ℝ) (hne : L ≠ R) :
    ¬ ∃ profile : ℝ → ℝ, ∀ t ∈ Ioo (0:ℝ) 1,
      (fun x => riemannData L O R (variableTransportLabel x t)) =ᵐ[volume]
        (fun x => profile (x/t)) := by
  rintro ⟨profile,hprofile⟩
  let A := Real.exp (1/3:ℝ)-1
  let B := Real.exp (2/3:ℝ)-1
  have he : 1 < Real.exp (1/3:ℝ) := Real.one_lt_exp_iff.mpr (by norm_num)
  have hdouble : Real.exp (2/3:ℝ)=Real.exp (1/3:ℝ)*Real.exp (1/3:ℝ) := by
    rw [← Real.exp_add];congr 1;norm_num
  have hgap : 2*A < B := by
    dsimp only [A,B]
    rw [hdouble]
    nlinarith [sq_pos_of_pos (sub_pos.mpr he)]
  have h1 := hprofile (1/3) (by norm_num)
  have h2 := (Measure.quasiMeasurePreserving_smul (volume : Measure ℝ)
    (by norm_num : (2:ℝ) ≠ 0)).ae (hprofile (2/3) (by norm_num))
  change ∀ᵐ x ∂volume,
    riemannData L O R (variableTransportLabel (2*x) (2/3))=profile ((2*x)/(2/3)) at h2
  have hAE : ∀ᵐ x ∂volume,
      riemannData L O R (variableTransportLabel x (1/3))=
        riemannData L O R (variableTransportLabel (2*x) (2/3)) := by
    filter_upwards [h1,h2] with x hx1 hx2
    have hratio : (2*x)/(2/3:ℝ)=x/(1/3:ℝ) := by ring
    rw [hratio] at hx2
    exact hx1.trans hx2.symm
  have hpos : volume (Ioo A (B/2)) ≠ 0 := by
    rw [Real.volume_Ioo]
    exact ne_of_gt (ENNReal.ofReal_pos.mpr (by linarith))
  obtain ⟨x,hx,hfield⟩ := Measure.exists_mem_of_measure_ne_zero_of_ae hpos (ae_restrict_of_ae hAE)
  rw [(variableTransportRiemann_initial_and_front L O R).2.1,
    (variableTransportRiemann_initial_and_front L O R).2.1] at hfield
  change riemannData L O R (x-A)=riemannData L O R (2*x-B) at hfield
  have hr : 0 < x-A := sub_pos.mpr hx.1
  have hl : 2*x-B < 0 := by linarith [hx.2]
  simp only [riemannData,not_lt.mpr hr.le,hr,hl,ite_true,ite_false] at hfield
  exact hne hfield.symm

/-- No finite family of constant-speed Riemann jump waves represents the
actual varying-coefficient solution, even modulo spatial null sets at every
positive time. -/
theorem variableTransportRiemann_no_finite_constant_speed_waves
    (L O R : ℝ) (hne : L ≠ R) :
    ¬ ∃ (m : ℕ) (base : ℝ) (left origin right speed : Fin m → ℝ),
      ∀ t ∈ Ioo (0:ℝ) 1,
        (fun x => riemannData L O R (variableTransportLabel x t)) =ᵐ[volume]
          (fun x => base+∑ p, riemannData (left p) (origin p) (right p) (x-speed p*t)) := by
  rintro ⟨m,base,left,origin,right,speed,hfield⟩
  obtain ⟨profile,hprofile⟩ := finiteConstantSpeedRiemannWaves_selfsimilar m base left origin right speed
  apply variableTransportRiemann_not_ae_selfsimilar L O R hne
  refine ⟨profile,?_⟩
  intro t ht
  filter_upwards [hfield t ht] with x hx
  exact hx.trans (hprofile x t ht.1)

theorem riemannData_continuous_label_derivative_zero
    (L O R : ℝ) (f : ℝ → ℝ) (x : ℝ) (hf : ContinuousAt f x) (hne : f x ≠ 0) :
    HasDerivAt (fun y => riemannData L O R (f y)) 0 x := by
  by_cases hneg : f x < 0
  · have heq : (fun y => riemannData L O R (f y)) =ᶠ[𝓝 x] fun _ => L := by
      filter_upwards [hf.eventually (Iio_mem_nhds hneg)] with y hy
      simp [riemannData,hy]
    exact (hasDerivAt_const x L).congr_of_eventuallyEq heq
  · have hpos : 0 < f x := lt_of_le_of_ne (le_of_not_gt hneg) hne.symm
    have heq : (fun y => riemannData L O R (f y)) =ᶠ[𝓝 x] fun _ => R := by
      filter_upwards [hf.eventually (Ioi_mem_nhds hpos)] with y hy
      simp [riemannData,hy,not_lt.mpr hy.le]
    exact (hasDerivAt_const x R).congr_of_eventuallyEq heq

/-- Actual limiting initial trace of the characteristic solution at every
point away from the initial jump, not just assigned values at time zero. -/
theorem variableTransportRiemann_actual_initial_trace
    (L O R x : ℝ) (hx : x ≠ 0) :
    Tendsto (fun τ => riemannData L O R (variableTransportLabel x τ))
      (𝓝 (0:ℝ)) (𝓝 (riemannData L O R x)) := by
  have hzero : variableTransportLabel x 0=x := by simp [variableTransportLabel]
  have h := riemannData_continuous_label_derivative_zero L O R
    (variableTransportLabel x) 0 (variableTransportLabel_derivatives x 0).1.continuousAt
    (by rw [hzero];exact hx)
  simpa only [hzero] using h.continuousAt.tendsto

end NumStability
