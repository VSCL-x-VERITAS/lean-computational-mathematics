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
# ContractingEnergy

Source-independent mathematics. Actual derivatives, integrability and displayed analytic hypotheses are retained.
-/

namespace NumStability

open Set Filter MeasureTheory Topology
open scoped BigOperators Topology NNReal

/-- Differentiate actual energy on an affine contracting interval directly
from joint field differentiability and continuous actual partials. This
does not assume differentiability of the integral primitive. -/
theorem actualIntegral_local_affine_contracting_derivative
    (E Et Ex : ℝ → ℝ → ℝ) (a b C t ε lo hi : ℝ) (hε : 0 < ε)
    (hposition : ∀ τ ∈ Icc (t-ε) (t+ε), ∀ y ∈ Icc (0:ℝ) 1,
      a+C*τ+(b-a-2*C*τ)*y ∈ Icc lo hi)
    (hE : ContinuousOn (Function.uncurry (fun τ x => E x τ))
      (Icc (t-ε) (t+ε) ×ˢ Icc lo hi))
    (hEt : ContinuousOn (Function.uncurry (fun τ x => Et x τ))
      (Icc (t-ε) (t+ε) ×ˢ Icc lo hi))
    (hEx : ContinuousOn (Function.uncurry (fun τ x => Ex x τ))
      (Icc (t-ε) (t+ε) ×ˢ Icc lo hi))
    (hjoint : ∀ x τ, x ∈ Icc lo hi → τ ∈ Icc (t-ε) (t+ε) →
      DifferentiableAt ℝ (Function.uncurry E) (x,τ))
    (htime : ∀ x τ, x ∈ Icc lo hi → τ ∈ Icc (t-ε) (t+ε) →
      HasDerivAt (fun s => E x s) (Et x τ) τ)
    (hspace : ∀ x τ, x ∈ Icc lo hi → τ ∈ Icc (t-ε) (t+ε) →
      HasDerivAt (fun ξ => E ξ τ) (Ex x τ) x) :
    HasDerivAt (fun τ => ∫ x in (a+C*τ)..(b-C*τ), E x τ)
      (∫ y in (0:ℝ)..1,
        -2*C*E (a+C*t+(b-a-2*C*t)*y) t +
          (b-a-2*C*t)*(Et (a+C*t+(b-a-2*C*t)*y) t +
            (C-2*C*y)*Ex (a+C*t+(b-a-2*C*t)*y) t)) t := by
  let width : ℝ → ℝ := fun τ => b-a-2*C*τ
  let position : ℝ → ℝ → ℝ := fun τ y => a+C*τ+width τ*y
  let F : ℝ → ℝ → ℝ := fun τ y => width τ * E (position τ y) τ
  let Ft : ℝ → ℝ → ℝ := fun τ y =>
    -2*C*E (position τ y) τ + width τ*(Et (position τ y) τ+(C-2*C*y)*Ex (position τ y) τ)
  have hmap : Continuous (fun p : ℝ × ℝ => (p.1,position p.1 p.2)) := by
    dsimp [position,width]; fun_prop
  let domain := Icc (t-ε) (t+ε) ×ˢ Icc (0:ℝ) 1
  have hmaps : Set.MapsTo (fun p : ℝ × ℝ => (p.1,position p.1 p.2)) domain
      (Icc (t-ε) (t+ε) ×ˢ Icc lo hi) := by
    intro p hp; exact ⟨hp.1,hposition p.1 hp.1 p.2 hp.2⟩
  have hec : ContinuousOn (fun p : ℝ × ℝ => E (position p.1 p.2) p.1) domain :=
    hE.comp hmap.continuousOn hmaps
  have hetc : ContinuousOn (fun p : ℝ × ℝ => Et (position p.1 p.2) p.1) domain :=
    hEt.comp hmap.continuousOn hmaps
  have hexc : ContinuousOn (fun p : ℝ × ℝ => Ex (position p.1 p.2) p.1) domain :=
    hEx.comp hmap.continuousOn hmaps
  have hwc : Continuous (fun p : ℝ × ℝ => width p.1) := by dsimp [width]; fun_prop
  have hvc : Continuous (fun p : ℝ × ℝ => C-2*C*p.2) := by fun_prop
  have hc : ContinuousOn (Function.uncurry F) domain := hwc.continuousOn.mul hec
  have hc' : ContinuousOn (Function.uncurry Ft) domain :=
    (hec.const_mul (-2*C)).add (hwc.continuousOn.mul (hetc.add (hvc.continuousOn.mul hexc)))
  have hd (τ y : ℝ) (hτ : τ ∈ Icc (t-ε) (t+ε)) (hy : y ∈ Icc (0:ℝ) 1) : HasDerivAt (fun s => F s y) (Ft τ y) τ := by
    have hw : HasDerivAt width (-2*C) τ := by
      dsimp [width]
      convert (hasDerivAt_const τ (b-a)).sub ((hasDerivAt_id τ).const_mul (2*C)) using 1; ring
    have hp : HasDerivAt (fun s => position s y) (C-2*C*y) τ := by
      dsimp [position]
      convert (((hasDerivAt_id τ).const_mul C).const_add a).add (hw.mul_const y) using 1; ring
    have he := materialDerivative_hasDerivWithinAt
      (q := E) (velocity := fun _ => C-2*C*y) (curve := fun s => position s y) (t := τ)
      (spaceDomain := Set.univ) (timeDomain := Set.univ) (characteristicTimes := Set.univ)
      (Set.mem_univ τ) (fun _ _ => ⟨Set.mem_univ _,Set.mem_univ _⟩)
      uniqueDiffWithinAt_univ uniqueDiffWithinAt_univ
      (hjoint (position τ y) τ (hposition τ hτ y hy) hτ).hasFDerivAt.hasFDerivWithinAt
      (htime (position τ y) τ (hposition τ hτ y hy) hτ).hasDerivWithinAt (hspace (position τ y) τ (hposition τ hτ y hy) hτ).hasDerivWithinAt
      hp.hasDerivWithinAt
    have he' := hasDerivWithinAt_univ.mp he
    simpa only [F,Ft,smul_eq_mul] using hw.mul he'
  have hi : HasDerivAt (fun τ => ∫ y in (0:ℝ)..1, F τ y) (∫ y in (0:ℝ)..1, Ft t y) t := by
    apply LocalLinearAdvection.local_integral_hasDerivAt F Ft (by norm_num)
      (c := t-ε) (d := t+ε) (by constructor <;> linarith) hc hc'
    intro τ hτ y hy; exact hd τ y (Ioo_subset_Icc_self hτ) hy
  have heq (τ : ℝ) : (∫ y in (0:ℝ)..1, F τ y) = ∫ x in (a+C*τ)..(b-C*τ), E x τ := by
    dsimp only [F,position]
    rw [intervalIntegral.integral_const_mul]
    have h := intervalIntegral.smul_integral_comp_mul_add (fun x => E x τ) (width τ) (a+C*τ)
      (a := 0) (b := 1)
    simp only [smul_eq_mul,mul_zero,zero_add,mul_one] at h
    convert h using 1 <;> dsimp [width] <;> ring_nf
  convert hi.congr_of_eventuallyEq (Filter.Eventually.of_forall (fun τ => (heq τ).symm)) using 1

/-- Actual endpoint transport follows from the affine derivative and FTC;
there is no integral-primitive regularity premise. -/
theorem actualIntegral_local_contracting_endpoint_derivative
    (E Et Ex : ℝ → ℝ → ℝ) (a b C t ε lo hi : ℝ) (hε : 0 < ε)
    (hposition : ∀ τ ∈ Icc (t-ε) (t+ε), ∀ y ∈ Icc (0:ℝ) 1,
      a+C*τ+(b-a-2*C*τ)*y ∈ Icc lo hi)
    (hE : ContinuousOn (Function.uncurry (fun τ x => E x τ))
      (Icc (t-ε) (t+ε) ×ˢ Icc lo hi))
    (hEt : ContinuousOn (Function.uncurry (fun τ x => Et x τ))
      (Icc (t-ε) (t+ε) ×ˢ Icc lo hi))
    (hEx : ContinuousOn (Function.uncurry (fun τ x => Ex x τ))
      (Icc (t-ε) (t+ε) ×ˢ Icc lo hi))
    (hjoint : ∀ x τ, x ∈ Icc lo hi → τ ∈ Icc (t-ε) (t+ε) →
      DifferentiableAt ℝ (Function.uncurry E) (x,τ))
    (htime : ∀ x τ, x ∈ Icc lo hi → τ ∈ Icc (t-ε) (t+ε) →
      HasDerivAt (fun s => E x s) (Et x τ) τ)
    (hspace : ∀ x τ, x ∈ Icc lo hi → τ ∈ Icc (t-ε) (t+ε) →
      HasDerivAt (fun ξ => E ξ τ) (Ex x τ) x) :
    HasDerivAt (fun τ => ∫ x in (a+C*τ)..(b-C*τ), E x τ)
      ((∫ x in (a+C*t)..(b-C*t), Et x t) - C*E (b-C*t) t - C*E (a+C*t) t) t := by
  let w := b-a-2*C*t
  let l := a+C*t
  let r := b-C*t
  let pos : ℝ → ℝ := fun y => l+w*y
  let v : ℝ → ℝ := fun y => C-2*C*y
  let G : ℝ → ℝ := fun y => v y * E (pos y) t
  let Gx : ℝ → ℝ := fun y => -2*C*E (pos y) t + v y*w*Ex (pos y) t
  have hp (y : ℝ) : HasDerivAt pos w y := by
    simpa only [pos,zero_add,mul_one] using (hasDerivAt_const y l).add ((hasDerivAt_id y).const_mul w)
  have hv (y : ℝ) : HasDerivAt v (-2*C) y := by
    dsimp [v]
    convert (hasDerivAt_const y C).sub ((hasDerivAt_id y).const_mul (2*C)) using 1; ring
  have ht : t ∈ Icc (t-ε) (t+ε) := by constructor <;> linarith
  have hG (y : ℝ) (hy : y ∈ Icc (0:ℝ) 1) : HasDerivAt G (Gx y) y := by
    convert (hv y).mul ((hspace (pos y) t (hposition t ht y hy) ht).comp y (hp y)) using 1; dsimp [G,Gx]; ring
  have hcpos : Continuous pos := by dsimp [pos]; fun_prop
  have hmaps : Set.MapsTo (fun y => (t,pos y)) (Icc (0:ℝ) 1)
      (Icc (t-ε) (t+ε) ×ˢ Icc lo hi) := by
    intro y hy; exact ⟨ht,hposition t ht y hy⟩
  have hce : ContinuousOn (fun y => E (pos y) t) (Icc (0:ℝ) 1) :=
    hE.comp (continuous_const.prodMk hcpos).continuousOn hmaps
  have hcet : ContinuousOn (fun y => Et (pos y) t) (Icc (0:ℝ) 1) :=
    hEt.comp (continuous_const.prodMk hcpos).continuousOn hmaps
  have hcex : ContinuousOn (fun y => Ex (pos y) t) (Icc (0:ℝ) 1) :=
    hEx.comp (continuous_const.prodMk hcpos).continuousOn hmaps
  have hcv : Continuous v := by dsimp [v]; fun_prop
  have hcgx : ContinuousOn Gx (Icc (0:ℝ) 1) :=
    (hce.const_mul (-2*C)).add ((hcv.continuousOn.mul continuousOn_const).mul hcex)
  have hiG : (∫ y in (0:ℝ)..1, Gx y) = G 1-G 0 :=
    intervalIntegral.integral_eq_sub_of_hasDerivAt (fun y hy => hG y (by simpa only [uIcc_of_le (by norm_num : (0:ℝ) ≤ 1)] using hy)) (hcgx.intervalIntegrable_of_Icc (by norm_num))
  have hpos0 : pos 0 = l := by simp [pos]
  have hpos1 : pos 1 = r := by dsimp [pos,l,w,r]; ring
  have hiEt : (∫ y in (0:ℝ)..1, w*Et (pos y) t) = ∫ x in l..r, Et x t := by
    rw [intervalIntegral.integral_const_mul]
    have h := intervalIntegral.smul_integral_comp_mul_add (fun x => Et x t) w l (a := 0) (b := 1)
    simp only [smul_eq_mul,mul_zero,zero_add,mul_one] at h
    have hr : w+l=r := by dsimp [w,l,r]; ring
    simpa only [pos,add_comm l,hr] using h
  have hIntegralIdentity : (∫ y in (0:ℝ)..1,
      -2*C*E (a+C*t+(b-a-2*C*t)*y) t +
        (b-a-2*C*t)*(Et (a+C*t+(b-a-2*C*t)*y) t +
          (C-2*C*y)*Ex (a+C*t+(b-a-2*C*t)*y) t)) =
      (∫ x in l..r, Et x t)-C*E r t-C*E l t := by
    calc
      _ = ∫ y in (0:ℝ)..1, w*Et (pos y) t + Gx y := by
        apply intervalIntegral.integral_congr; intro y _; dsimp [Gx,pos,w,l,v]; ring
      _ = (∫ y in (0:ℝ)..1, w*Et (pos y) t)+(∫ y in (0:ℝ)..1, Gx y) :=
        intervalIntegral.integral_add ((hcet.const_mul w).intervalIntegrable_of_Icc (by norm_num)) (hcgx.intervalIntegrable_of_Icc (by norm_num))
      _ = _ := by rw [hiEt,hiG]; dsimp only [G]; rw [hpos0,hpos1]; dsimp [v]; ring
  have hactual := actualIntegral_local_affine_contracting_derivative E Et Ex a b C t ε lo hi hε hposition hE hEt hEx hjoint htime hspace
  rw [hIntegralIdentity] at hactual
  exact hactual

/-- Integrate the actual local energy inequality and use the contracting
boundary sign. This is the bound for the derivative proved separately by
moving-interval differentiation, not an assumed propagation conclusion. -/
theorem actualEnergy_contracting_interval_growth
    (E Et F Fx : ℝ → ℝ) (a b C K : ℝ) (hab : a ≤ b)
    (hE : IntervalIntegrable E volume a b)
    (hEt : IntervalIntegrable Et volume a b)
    (hFx : IntervalIntegrable Fx volume a b)
    (hflux : ∀ x ∈ uIcc a b, HasDerivAt F (Fx x) x)
    (hlocal : ∀ x ∈ Icc a b, Et x + Fx x ≤ K * E x)
    (hla : |F a| ≤ C * E a) (hrb : |F b| ≤ C * E b) :
    (∫ x in a..b, Et x) + (-C) * E b - C * E a ≤ K * (∫ x in a..b, E x) := by
  have h := intervalIntegral.integral_mono_on hab (hEt.add hFx) (hE.const_mul K) hlocal
  rw [intervalIntegral.integral_add hEt hFx,
    intervalIntegral.integral_const_mul,
    intervalIntegral.integral_eq_sub_of_hasDerivAt hflux hFx] at h
  have ha := (abs_le.mp hla).2
  have hb := (abs_le.mp hrb).1
  linarith

/-- Apply the existing scalar, one-sided Gronwall theorem to nonnegative
actual energy. An absolute derivative bound would be unnecessarily strong. -/
theorem actualEnergy_eq_zero_of_one_sided_growth
    (energy energyDerivative : ℝ → ℝ) (a b K : ℝ)
    (hc : ContinuousOn energy (Icc a b))
    (hd : ∀ t ∈ Ico a b, HasDerivWithinAt energy (energyDerivative t) (Ici t) t)
    (hnonneg : ∀ t ∈ Icc a b, 0 ≤ energy t)
    (hzero : energy a = 0)
    (hgrowth : ∀ t ∈ Ico a b, energyDerivative t ≤ K * energy t) :
    ∀ t ∈ Icc a b, energy t = 0 := by
  have h := le_gronwallBound_of_liminf_deriv_right_le hc
    (fun t ht _ hr => (hd t ht).liminf_right_slope_le hr)
    (δ := 0) (ε := 0) (by simpa only [hzero] using le_refl (0 : ℝ))
    (by simpa only [add_zero] using hgrowth)
  intro t ht
  exact le_antisymm (by simpa only [gronwallBound_ε0_δ0] using h t ht) (hnonneg t ht)

/-- Zero actual nonnegative energy on a nondegenerate interval implies
pointwise zero, including the endpoints, by the existing open-positive
measure and continuity API. -/
theorem actualEnergy_pointwise_zero
    (E : ℝ → ℝ) (a b : ℝ) (hab : a < b)
    (hc : ContinuousOn E (Icc a b))
    (hn : ∀ x ∈ Icc a b, 0 ≤ E x)
    (hz : (∫ x in a..b, E x) = 0) :
    ∀ x ∈ Icc a b, E x = 0 := by
  have hn' : 0 ≤ᵐ[volume.restrict (Ioc a b)] E := by
    rw [Filter.EventuallyLE,ae_restrict_iff' measurableSet_Ioc]
    filter_upwards with x hx using hn x (Ioc_subset_Icc_self hx)
  have hae := (intervalIntegral.integral_eq_zero_iff_of_le_of_nonneg_ae hab.le hn'
    ((by simpa only [uIcc_of_le hab.le] using hc : ContinuousOn E (uIcc a b)).intervalIntegrable)).mp hz
  have hae' : E =ᵐ[volume.restrict (Icc a b)] 0 := by
    rwa [Measure.restrict_congr_set (Ioc_ae_eq_Icc (μ := volume))] at hae
  exact Measure.eqOn_Icc_of_ae_eq volume hab.ne hae' hc continuousOn_const

/-- Zero actual squared-coordinate energy gives zero actual state.
This uses the existing finite-dimensional Euclidean norm producer. -/
theorem actualCoordinate_zero_of_zero_energy
    {ι : Type*} [Fintype ι] (w : ι → ℝ)
    (hz : (∑ p : ι, (w p)^2) = 0) : w = 0 := by
  have hnorm : finiteVecNorm2 w = 0 := by
    apply sq_eq_zero_iff.mp
    simpa only [finiteVecNorm2_sq,finiteVecNorm2Sq] using hz
  funext p
  exact (finiteVecNorm2_eq_zero_iff w).mp hnorm p

/-- Local actual-field regularity suffices for finite-horizon cone energy.
The moving integral derivative is derived, not assumed. -/
theorem actualEnergy_local_contracting_cone_zero
    (E Et Ex F Fx : ℝ → ℝ → ℝ) (a b C T K δ lo hi : ℝ)
    (hC : 0 ≤ C) (hT : 0 ≤ T) (hwidth : 0 < b-a-2*C*T) (hδ : 0 < δ)
    (hposition : ∀ τ ∈ Icc (-δ) (T+δ), ∀ y ∈ Icc (0:ℝ) 1,
      a+C*τ+(b-a-2*C*τ)*y ∈ Icc lo hi)
    (hE : ContinuousOn (Function.uncurry (fun τ x => E x τ)) (Icc (-δ) (T+δ) ×ˢ Icc lo hi))
    (hEt : ContinuousOn (Function.uncurry (fun τ x => Et x τ)) (Icc (-δ) (T+δ) ×ˢ Icc lo hi))
    (hEx : ContinuousOn (Function.uncurry (fun τ x => Ex x τ)) (Icc (-δ) (T+δ) ×ˢ Icc lo hi))
    (hFx : ContinuousOn (Function.uncurry (fun τ x => Fx x τ)) (Icc (-δ) (T+δ) ×ˢ Icc lo hi))
    (hjoint : ∀ x τ, x ∈ Icc lo hi → τ ∈ Icc (-δ) (T+δ) → DifferentiableAt ℝ (Function.uncurry E) (x,τ))
    (htime : ∀ x τ, x ∈ Icc lo hi → τ ∈ Icc (-δ) (T+δ) → HasDerivAt (fun s => E x s) (Et x τ) τ)
    (hspace : ∀ x τ, x ∈ Icc lo hi → τ ∈ Icc (-δ) (T+δ) → HasDerivAt (fun ξ => E ξ τ) (Ex x τ) x)
    (hflux : ∀ x τ, x ∈ Icc lo hi → τ ∈ Icc (-δ) (T+δ) → HasDerivAt (fun ξ => F ξ τ) (Fx x τ) x)
    (hnonneg : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), 0 ≤ E x τ)
    (hlocal : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), Et x τ + Fx x τ ≤ K*E x τ)
    (hbound : ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), |F x τ| ≤ C*E x τ)
    (hinit : ∀ x ∈ Icc a b, E x 0 = 0) :
    ∀ τ ∈ Icc 0 T, ∀ x ∈ Icc (a+C*τ) (b-C*τ), E x τ = 0 := by
  let energy : ℝ → ℝ := fun τ => ∫ x in (a+C*τ)..(b-C*τ), E x τ
  let derivative : ℝ → ℝ := fun τ => (∫ x in (a+C*τ)..(b-C*τ), Et x τ)-C*E (b-C*τ) τ-C*E (a+C*τ) τ
  have htimebox (τ : ℝ) (hτ : τ ∈ Icc 0 T) : τ ∈ Icc (-δ) (T+δ) := by constructor <;> linarith [hτ.1,hτ.2]
  have horder (τ : ℝ) (hτ : τ ∈ Icc 0 T) : a+C*τ < b-C*τ := by
    have hh := mul_le_mul_of_nonneg_left hτ.2 (show 0 ≤ 2*C by positivity); linarith
  have hconebox (τ x : ℝ) (hτ : τ ∈ Icc 0 T) (hx : x ∈ Icc (a+C*τ) (b-C*τ)) : x ∈ Icc lo hi := by
    have hl := hposition τ (htimebox τ hτ) 0 ⟨le_rfl,by norm_num⟩
    have hr := hposition τ (htimebox τ hτ) 1 ⟨by norm_num,le_rfl⟩
    simp only [mul_zero,add_zero] at hl
    have hr' : b-C*τ ∈ Icc lo hi := by convert hr using 1; ring
    exact ⟨hl.1.trans hx.1,hx.2.trans hr'.2⟩
  have hd (τ : ℝ) (hτ : τ ∈ Icc 0 T) : HasDerivAt energy (derivative τ) τ := by
    have hsub : Icc (τ-δ/2) (τ+δ/2) ⊆ Icc (-δ) (T+δ) := by
      intro t ht; constructor <;> linarith [ht.1,ht.2,hτ.1,hτ.2]
    have hp : Icc (τ-δ/2) (τ+δ/2) ×ˢ Icc lo hi ⊆ Icc (-δ) (T+δ) ×ˢ Icc lo hi := by
      intro p hp; exact ⟨hsub hp.1,hp.2⟩
    exact actualIntegral_local_contracting_endpoint_derivative E Et Ex a b C τ (δ/2) lo hi (by positivity)
      (fun t ht y hy => hposition t (hsub ht) y hy) (hE.mono hp) (hEt.mono hp) (hEx.mono hp)
      (fun x t hx ht => hjoint x t hx (hsub ht)) (fun x t hx ht => htime x t hx (hsub ht))
      (fun x t hx ht => hspace x t hx (hsub ht))
  have hslice (H : ℝ → ℝ → ℝ) (hc : ContinuousOn (Function.uncurry (fun τ x => H x τ)) (Icc (-δ) (T+δ) ×ˢ Icc lo hi))
      (τ : ℝ) (hτ : τ ∈ Icc 0 T) : ContinuousOn (fun x => H x τ) (Icc (a+C*τ) (b-C*τ)) :=
    hc.comp (continuous_const.prodMk continuous_id).continuousOn
      (fun x hx => ⟨htimebox τ hτ,hconebox τ x hτ hx⟩)
  have hiint (H : ℝ → ℝ → ℝ) (hc : ContinuousOn (Function.uncurry (fun τ x => H x τ)) (Icc (-δ) (T+δ) ×ˢ Icc lo hi))
      (τ : ℝ) (hτ : τ ∈ Icc 0 T) : IntervalIntegrable (fun x => H x τ) volume (a+C*τ) (b-C*τ) :=
    (hslice H hc τ hτ).intervalIntegrable_of_Icc (horder τ hτ).le
  have hg (τ : ℝ) (hτ : τ ∈ Ico 0 T) : derivative τ ≤ K*energy τ := by
    have ht := Ico_subset_Icc_self hτ; have ho := horder τ ht
    have h := actualEnergy_contracting_interval_growth (fun x => E x τ) (fun x => Et x τ) (fun x => F x τ) (fun x => Fx x τ)
      (a+C*τ) (b-C*τ) C K ho.le (hiint E hE τ ht) (hiint Et hEt τ ht) (hiint Fx hFx τ ht)
      (fun x hx => hflux x τ (hconebox τ x ht (by simpa only [uIcc_of_le ho.le] using hx)) (htimebox τ ht))
      (hlocal τ ht) (hbound τ ht _ ⟨le_rfl,ho.le⟩) (hbound τ ht _ ⟨ho.le,le_rfl⟩)
    simpa only [derivative,energy,neg_mul] using h
  have hn (τ : ℝ) (hτ : τ ∈ Icc 0 T) : 0 ≤ energy τ := intervalIntegral.integral_nonneg (horder τ hτ).le (hnonneg τ hτ)
  have hz : energy 0 = 0 := by
    dsimp [energy];simp only [mul_zero,add_zero,sub_zero]
    calc
      (∫ x in a..b, E x 0) = ∫ x in a..b, (0:ℝ) := by
        apply intervalIntegral.integral_congr; intro x hx
        have hab := horder 0 ⟨le_rfl,hT⟩; simp only [mul_zero,add_zero,sub_zero] at hab
        exact hinit x (by simpa only [uIcc_of_le hab.le] using hx)
      _ = 0 := by simp
  have hc : ContinuousOn energy (Icc 0 T) := fun τ hτ => (hd τ hτ).continuousAt.continuousWithinAt
  have hall := actualEnergy_eq_zero_of_one_sided_growth energy derivative 0 T K hc
    (fun τ hτ => (hd τ (Ico_subset_Icc_self hτ)).hasDerivWithinAt) hn hz hg
  intro τ hτ
  exact actualEnergy_pointwise_zero (fun x => E x τ) (a+C*τ) (b-C*τ) (horder τ hτ) (hslice E hE τ hτ) (hnonneg τ hτ) (hall τ hτ)

end NumStability
