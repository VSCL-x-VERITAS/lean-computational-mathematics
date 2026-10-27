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
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageSpatialSlope
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.TravelingJumpAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FirstOrderEquation
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.MaterialDerivative
import ComputationalMathematics.Analysis.PartialDifferentialEquations.VariableLinearFlux
import ComputationalMathematics.Source.LeVeque.Chapter01.ScalarHyperbolicity
import ComputationalMathematics.Source.LeVeque.Chapter04.AcousticEigenbasis
import ComputationalMathematics.Source.LeVeque.Chapter04.LinearRiemannWaveJump
import ComputationalMathematics.Source.LeVeque.Chapter04.NonconservativeWaveScope
import ComputationalMathematics.Source.LeVeque.Chapter04.SpectralFluctuations
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
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.SignedCellAverageSpatialError

/-!
# NonconservativeWaveAveraging

Source correspondence and separately qualified corrections for LeVeque Chapter 4, printed page 76 (raw PDF page 98).
-/

namespace NumStability

open Set Filter MeasureTheory Topology
open scoped BigOperators Topology NNReal

/-- A local approximate solver freezes the actual principal matrix of the
selected nonconservative equation. Its certified PDE is the frozen linear
problem, not an assertion of exact evolution for the original equation. -/
theorem nonconservative_frozen_system_riemann_waves
    {m : ℕ} (equation : FirstOrderEquation (Fin m))
    (hhyp : equation.IsHyperbolic) (position : ℤ → ℝ) (time : ℝ)
    (old : ℤ → Fin m → ℝ)
    (hadmissible : ∀ j, old j ∈ equation.admissibleStates) :
    ∃ (basis : ℤ → Module.Basis (Fin m) ℝ (Fin m → ℝ))
      (speeds : ℤ → Fin m → ℝ),
      (∀ j p, (equation.principal (position j) time (old j)).mulVec (basis j p) =
        speeds j p • basis j p) ∧
      (∀ j, ∑ p, leveque03_riemannWave (basis j) (old (j-1)) (old j) p =
        old j-old (j-1)) ∧
      (∀ j, IsRectangleConservationLawSolution
        (linearRiemannSolution (basis j) (speeds j) (old (j-1)) (old (j-1)) (old j))
        (equation.principal (position j) time (old j)).mulVec) ∧
      (∀ j x, linearRiemannSolution (basis j) (speeds j)
        (old (j-1)) (old (j-1)) (old j) x 0 =
        riemannData (old (j-1)) (old (j-1)) (old j) x) := by
  classical
  have hlocal (j : ℤ) := hhyp (position j) time (old j) (hadmissible j)
  choose speeds basis heigen using hlocal
  refine ⟨basis,speeds,heigen,?_,?_,?_⟩
  · intro j
    exact leveque03_sumRiemannWaves (basis j) _ _
  · intro j
    exact linearRiemannSolution_isRectangleSolution _ (basis j) (speeds j) (heigen j) _ _ _
  · intro j x
    exact linearRiemannSolution_initial (basis j) (speeds j) _ _ _ x

/-- Local approximate evolution assembled from the incoming finite waves.
This definition carries no assertion of exact evolution of a variable PDE. -/
noncomputable def nonconservativeLocalWaveField
    {m : ℕ} (width : ℝ) (old : ℤ → Fin m → ℝ)
    (speeds : ℤ → Fin m → ℝ) (wave : ℤ → Fin m → Fin m → ℝ)
    (i : ℤ) (x t : ℝ) : Fin m → ℝ :=
  old i +
    (∑ p, riemannData (-wave i p) 0 0 (x-leveque04_positiveVelocity (speeds i p)*t)) +
    (∑ p, riemannData 0 0 (wave (i+1) p)
      (x-(width+leveque04_negativeVelocity (speeds (i+1) p)*t)))

theorem nonconservativeLocalWaveField_average
    {m : ℕ} (width step : ℝ) (old : ℤ → Fin m → ℝ)
    (speeds : ℤ → Fin m → ℝ) (wave : ℤ → Fin m → Fin m → ℝ) (i : ℤ)
    (hw : 0 < width) (ht : 0 ≤ step)
    (hleft : ∀ p, leveque04_positiveVelocity (speeds i p)*step ≤ width)
    (hright : ∀ p, -leveque04_negativeVelocity (speeds (i+1) p)*step ≤ width) :
    IntervalIntegrable (fun x => nonconservativeLocalWaveField width old speeds wave i x step)
      volume 0 width ∧
    oneDimensionalCellAverage
      (fun x => nonconservativeLocalWaveField width old speeds wave i x step) 0 width =
      leveque04_directWavePropagationStep (step/width) old speeds wave i := by
  classical
  let left := fun p x => riemannData (-wave i p) 0 0
    (x-leveque04_positiveVelocity (speeds i p)*step)
  let right := fun p x => riemannData 0 0 (wave (i+1) p)
    (x-(width+leveque04_negativeVelocity (speeds (i+1) p)*step))
  have hpos (p : Fin m) : 0 ≤ leveque04_positiveVelocity (speeds i p)*step :=
    mul_nonneg (le_max_right _ _) ht
  have hneg (p : Fin m) : leveque04_negativeVelocity (speeds (i+1) p)*step ≤ 0 :=
    mul_nonpos_of_nonpos_of_nonneg (min_le_right _ _) ht
  have hl (p : Fin m) := riemannData_shifted_intervalIntegral (-wave i p) 0 0
    0 (leveque04_positiveVelocity (speeds i p)*step) width (hpos p) (hleft p)
  have hr (p : Fin m) := riemannData_shifted_intervalIntegral 0 0 (wave (i+1) p)
    0 (width+leveque04_negativeVelocity (speeds (i+1) p)*step) width
    (by have h := hright p; linarith) (by have h := hneg p; linarith)
  have hli : IntervalIntegrable (fun x => ∑ p, left p x) volume 0 width := by
    simpa only [Finset.sum_fn,left] using IntervalIntegrable.sum Finset.univ (fun p _ => (hl p).1)
  have hri : IntervalIntegrable (fun x => ∑ p, right p x) volume 0 width := by
    simpa only [Finset.sum_fn,right] using IntervalIntegrable.sum Finset.univ (fun p _ => (hr p).1)
  have hc : IntervalIntegrable (fun _ : ℝ => old i) volume 0 width := intervalIntegrable_const
  have hfield : IntervalIntegrable
      (fun x => nonconservativeLocalWaveField width old speeds wave i x step)
      volume 0 width := (hc.add hli).add hri
  refine ⟨hfield,?_⟩
  simp only [oneDimensionalCellAverage,sub_zero]
  change width⁻¹ • (∫ x in (0:ℝ)..width,
    old i + (∑ p, left p x) + (∑ p, right p x)) = _
  rw [intervalIntegral.integral_add (hc.add hli) hri,
    intervalIntegral.integral_add hc hli,
    intervalIntegral.integral_const,
    intervalIntegral.integral_finset_sum (fun p _ => (hl p).1),
    intervalIntegral.integral_finset_sum (fun p _ => (hr p).1)]
  simp_rw [(hl _).2,(hr _).2]
  simp only [sub_zero,smul_zero,add_zero,zero_add,sub_add_cancel_left]
  have hsum (s : Fin m → ℝ) (w : Fin m → Fin m → ℝ) :
      (∑ p, (s p*step) • w p) = step • (∑ p, s p • w p) := by
    rw [Finset.smul_sum]
    apply Finset.sum_congr rfl
    intro p _
    rw [smul_smul,mul_comm]
  simp only [smul_neg,neg_smul,Finset.sum_neg_distrib]
  rw [hsum (fun p => leveque04_positiveVelocity (speeds i p)) (wave i),
    hsum (fun p => leveque04_negativeVelocity (speeds (i+1) p)) (wave (i+1))]
  simp only [smul_add,smul_neg,smul_smul,inv_mul_cancel₀ hw.ne',one_smul]
  simp only [leveque04_directWavePropagationStep,leveque04_positiveFluctuation,
    leveque04_negativeFluctuation,sub_eq_add_neg,smul_add,neg_add_rev,
    div_eq_mul_inv]
  rw [mul_comm width⁻¹ step]
  abel

theorem nonconservativeLocalWaveField_initial
    {m : ℕ} (width : ℝ) (old : ℤ → Fin m → ℝ)
    (speeds : ℤ → Fin m → ℝ) (wave : ℤ → Fin m → Fin m → ℝ)
    (i : ℤ) (x : ℝ) (hx : x ∈ Set.Ioo 0 width) :
    nonconservativeLocalWaveField width old speeds wave i x 0 = old i := by
  have hright : x-width < 0 := sub_neg.mpr hx.2
  simp [nonconservativeLocalWaveField,riemannData,not_lt.mpr hx.1.le,hx.1,hright]

theorem nonconservativeLocalWaveField_initial_average
    {m : ℕ} (width : ℝ) (old : ℤ → Fin m → ℝ)
    (speeds : ℤ → Fin m → ℝ) (wave : ℤ → Fin m → Fin m → ℝ)
    (i : ℤ) (hw : 0 < width) :
    oneDimensionalCellAverage
      (fun x => nonconservativeLocalWaveField width old speeds wave i x 0) 0 width = old i := by
  have h := (nonconservativeLocalWaveField_average width 0 old speeds wave i hw le_rfl
    (fun _ => by simpa using hw.le) (fun _ => by simpa using hw.le)).2
  simpa [leveque04_directWavePropagationStep] using h

theorem nonconservativeLocalWaveField_admissible_average
    {m : ℕ} (width step : ℝ) (old : ℤ → Fin m → ℝ)
    (speeds : ℤ → Fin m → ℝ) (wave : ℤ → Fin m → Fin m → ℝ) (i : ℤ)
    (hw : 0 < width) (ht : 0 ≤ step)
    (hleft : ∀ p, leveque04_positiveVelocity (speeds i p)*step ≤ width)
    (hright : ∀ p, -leveque04_negativeVelocity (speeds (i+1) p)*step ≤ width) :
    IsOneDimensionalCellAverage
      (fun x => nonconservativeLocalWaveField width old speeds wave i x step)
      0 width (leveque04_directWavePropagationStep (step/width) old speeds wave i) := by
  have h := nonconservativeLocalWaveField_average width step old speeds wave i hw ht hleft hright
  rw [← h.2]
  exact oneDimensionalCellAverage_isCellAverage _ hw h.1

theorem trueCellAverage_signedSpatial_error_le
    (f f' : ℝ → ℝ) (K center width speed : ℝ)
    (hK : 0 ≤ K) (hw : 0 < width)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hLip : ∀ x y, |f' x-f' y| ≤ K*|x-y|) :
    let avg := fun c => oneDimensionalCellAverage f (c-width/2) (c+width/2)
    |leveque04_positiveVelocity speed * ((avg center-avg (center-width))/width) +
      leveque04_negativeVelocity speed * ((avg (center+width)-avg center)/width) -
      speed * f' center| ≤ |speed| *((3*K/2)*width) := by
  simpa only [leveque04_positiveVelocity, leveque04_negativeVelocity] using
    (trueCellAverage_signedSlope_error_le f f' K center width speed hK hw hf hLip)

/-- Spatial consistency against the actual smooth field for a coefficient
Lipschitz in state; no conservative physical flux is required. -/
theorem trueCellAverage_quasilinearSpatial_error_le
    (f f' : ℝ → ℝ) (coefficient : ℝ → ℝ) (K M A center width : ℝ)
    (hK : 0 ≤ K) (hM : 0 ≤ M) (hA : 0 ≤ A) (hw : 0 < width)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hLip : ∀ x y, |f' x-f' y| ≤ K*|x-y|)
    (hfLip : ∀ x y, |f x-f y| ≤ M*|x-y|)
    (haLip : ∀ u v, |coefficient u-coefficient v| ≤ A*|u-v|) :
    let avg := fun c => oneDimensionalCellAverage f (c-width/2) (c+width/2)
    let speed := coefficient (avg center)
    |leveque04_positiveVelocity speed * ((avg center-avg (center-width))/width) +
      leveque04_negativeVelocity speed * ((avg (center+width)-avg center)/width) -
      coefficient (f center) * f' center| ≤
      |speed| *((3*K/2)*width) + A*(M*(width/2))*|f' center| := by
  simpa only [leveque04_positiveVelocity, leveque04_negativeVelocity] using
    (trueCellAverage_quasilinearSignedSlope_error_le f f' coefficient K M A center width hK hM hA hw hf hLip hfLip haLip)

/-- Smooth-profile spatial consistency of the actual signed spectral waves.
The original equation is homogeneous. Only continuity of its two sampled
spectral operators is needed; an eigenbasis need not itself be continuous. -/
theorem nonconservative_system_spatial_residual_tendsto
    {ι : Type*} {L : Filter ι} {m : ℕ}
    (equation : FirstOrderEquation (Fin m)) (time center : ℝ)
    (f f' : ℝ → Fin m → ℝ) (qt : Fin m → ℝ) (K M : Fin m → ℝ)
    (width : ι → ℝ)
    (basis : ℝ → (Fin m → ℝ) → Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : ℝ → (Fin m → ℝ) → Fin m → ℝ)
    (hK : ∀ p, 0 ≤ K p) (hM : ∀ p, 0 ≤ M p)
    (hf : ∀ p x, HasDerivAt (fun y => f y p) (f' x p) x)
    (hLip : ∀ p x y, |f' x p-f' y p| ≤ K p*|x-y|)
    (hfield : ∀ p x y, |f x p-f y p| ≤ M p*|x-y|)
    (hw : Tendsto width L (𝓝[>] 0))
    (hcenter : f center ∈ equation.admissibleStates)
    (heigen : ∀ x q, q ∈ equation.admissibleStates → ∀ p,
      (equation.principal x time q).mulVec (basis x q p) =
        speeds x q p • basis x q p)
    (hplus : ContinuousAt (fun z : ℝ × (Fin m → ℝ) =>
      (Matrix.toLin' (leveque04_positiveCoefficientPart (basis z.1 z.2)
        (speeds z.1 z.2))).toContinuousLinearMap) (center,f center))
    (hminus : ContinuousAt (fun z : ℝ × (Fin m → ℝ) =>
      (Matrix.toLin' (leveque04_negativeCoefficientPart (basis z.1 z.2)
        (speeds z.1 z.2))).toContinuousLinearMap) (center,f center))
    (hhomogeneous : ∀ x q, equation.forcing x time q = 0)
    (hpde : equation.residual center time (f center) qt (f' center) = 0)
    (hmeans : ∀ᶠ k in L,
      oneDimensionalCellAverage f (center-width k/2) (center+width k/2)
        ∈ equation.admissibleStates ∧
      oneDimensionalCellAverage f (center+width k-width k/2)
        (center+width k+width k/2) ∈ equation.admissibleStates) :
    let avg := fun k c => oneDimensionalCellAverage f (c-width k/2) (c+width k/2)
    (∀ᶠ k in L,
      (∀ p, (equation.principal center time (avg k center)).mulVec
        (basis center (avg k center) p) =
          speeds center (avg k center) p • basis center (avg k center) p) ∧
      (∀ p, (equation.principal (center+width k) time (avg k (center+width k))).mulVec
        (basis (center+width k) (avg k (center+width k)) p) =
          speeds (center+width k) (avg k (center+width k)) p •
            basis (center+width k) (avg k (center+width k)) p)) ∧
    Tendsto (fun k => qt + (width k)⁻¹ •
      (leveque04_positiveFluctuation (speeds center (avg k center))
        (leveque03_riemannWave (basis center (avg k center))
          (avg k (center-width k)) (avg k center)) +
       leveque04_negativeFluctuation (speeds (center+width k) (avg k (center+width k)))
        (leveque03_riemannWave (basis (center+width k) (avg k (center+width k)))
          (avg k center) (avg k (center+width k))))) L (𝓝 0) := by
  classical
  dsimp only
  let avg := fun k c => oneDimensionalCellAverage f (c-width k/2) (c+width k/2)
  let P := fun z : ℝ × (Fin m → ℝ) =>
    (Matrix.toLin' (leveque04_positiveCoefficientPart (basis z.1 z.2)
      (speeds z.1 z.2))).toContinuousLinearMap
  let N := fun z : ℝ × (Fin m → ℝ) =>
    (Matrix.toLin' (leveque04_negativeCoefficientPart (basis z.1 z.2)
      (speeds z.1 z.2))).toContinuousLinearMap
  have hc : Continuous f := continuous_pi (fun p =>
    continuous_iff_continuousAt.mpr (fun x => (hf p x).continuousAt))
  have hzero : Tendsto width L (𝓝 0) := hw.mono_right nhdsWithin_le_nhds
  have hav0 : Tendsto (fun k => avg k center) L (𝓝 (f center)) := by
    simpa only [add_zero] using trueVectorAverage_moving_center_tendsto
      f M center width (fun _ => 0) hM hc hfield hw tendsto_const_nhds
  have hav1 : Tendsto (fun k => avg k (center+width k)) L (𝓝 (f center)) :=
    trueVectorAverage_moving_center_tendsto f M center width width hM hc hfield hw hzero
  have hP : Tendsto (fun k => P (center,avg k center)) L (𝓝 (P (center,f center))) :=
    hplus.tendsto.comp (tendsto_const_nhds.prodMk_nhds hav0)
  have hN : Tendsto (fun k => N (center+width k,avg k (center+width k))) L
      (𝓝 (N (center,f center))) := by
    have hx : Tendsto (fun k => center+width k) L (𝓝 center) := by
      simpa only [add_zero] using (tendsto_const_nhds (x := center)).add hzero
    exact hminus.tendsto.comp (hx.prodMk_nhds hav1)
  have hs := trueVectorAverage_slopes_tendsto f f' K center width hK hf hLip hw
  have hb := isBoundedBilinearMap_apply (𝕜 := ℝ)
    (E := Fin m → ℝ) (F := Fin m → ℝ)
  have hp := hb.continuous.tendsto (P (center,f center),f' center) |>.comp (hP.prodMk_nhds hs.1)
  have hn := hb.continuous.tendsto (N (center,f center),f' center) |>.comp (hN.prodMk_nhds hs.2)
  have hdiag := (Leveque02Tracer.realEigenbasisDiagonalization
    (equation.principal center time (f center)) (speeds center (f center))
    (basis center (f center)) (heigen center (f center) hcenter)).2
  have hsum := leveque04_equation46 _ (basis center (f center)) (speeds center (f center)) hdiag
  have hlimit : qt + (P (center,f center) (f' center) + N (center,f center) (f' center)) = 0 := by
    change qt + ((leveque04_positiveCoefficientPart _ _).mulVec (f' center) +
      (leveque04_negativeCoefficientPart _ _).mulVec (f' center)) = 0
    rw [← Matrix.add_mulVec,hsum]
    simpa only [FirstOrderEquation.residual,hhomogeneous,sub_zero] using hpde
  constructor
  · filter_upwards [hmeans] with k hk
    exact ⟨heigen center (avg k center) hk.1,
      heigen (center+width k) (avg k (center+width k)) hk.2⟩
  · have ht := (tendsto_const_nhds (x := qt)).add (hp.add hn)
    rw [hlimit] at ht
    convert ht using 1
    funext k
    rw [smul_add,← leveque04_equation47,← leveque04_equation48]
    change qt + ((width k)⁻¹ • (leveque04_positiveCoefficientPart _ _).mulVec
      (avg k center-avg k (center-width k)) +
      (width k)⁻¹ • (leveque04_negativeCoefficientPart _ _).mulVec
      (avg k (center+width k)-avg k center)) = _
    change qt + ((width k)⁻¹ • (leveque04_positiveCoefficientPart
      (basis center (avg k center)) (speeds center (avg k center))).mulVec
      (avg k center-avg k (center-width k)) +
      (width k)⁻¹ • (leveque04_negativeCoefficientPart
        (basis (center+width k) (avg k (center+width k)))
        (speeds (center+width k) (avg k (center+width k)))).mulVec
        (avg k (center+width k)-avg k center)) =
      qt + ((leveque04_positiveCoefficientPart
        (basis center (avg k center)) (speeds center (avg k center))).mulVec
        ((width k)⁻¹ • (avg k center-avg k (center-width k))) +
        (leveque04_negativeCoefficientPart
          (basis (center+width k) (avg k (center+width k)))
          (speeds (center+width k) (avg k (center+width k)))).mulVec
          ((width k)⁻¹ • (avg k (center+width k)-avg k center)))
    rw [Matrix.mulVec_smul,Matrix.mulVec_smul]

theorem nonconservative_classical_system_spatial_residual
    {ι : Type*} {L : Filter ι} {m : ℕ}
    (equation : FirstOrderEquation (Fin m)) (time center : ℝ)
    (q : ℝ → ℝ → Fin m → ℝ) (qx : ℝ → Fin m → ℝ) (K M : Fin m → ℝ)
    (width : ι → ℝ)
    (basis : ℝ → (Fin m → ℝ) → Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : ℝ → (Fin m → ℝ) → Fin m → ℝ)
    (hK : ∀ p, 0 ≤ K p) (hM : ∀ p, 0 ≤ M p)
    (hf : ∀ p x, HasDerivAt (fun y => (fun x => q x time) y p) (qx x p) x)
    (hLip : ∀ p x y, |qx x p-qx y p| ≤ K p*|x-y|)
    (hfield : ∀ p x y, |(fun x => q x time) x p-(fun x => q x time) y p| ≤ M p*|x-y|)
    (hw : Tendsto width L (𝓝[>] 0))
    (hclassical : equation.IsClassicalSolutionAt q center time)
    (heigen : ∀ x q, q ∈ equation.admissibleStates → ∀ p,
      (equation.principal x time q).mulVec (basis x q p) =
        speeds x q p • basis x q p)
    (hplus : ContinuousAt (fun z : ℝ × (Fin m → ℝ) =>
      (Matrix.toLin' (leveque04_positiveCoefficientPart (basis z.1 z.2)
        (speeds z.1 z.2))).toContinuousLinearMap) (center,(fun x => q x time) center))
    (hminus : ContinuousAt (fun z : ℝ × (Fin m → ℝ) =>
      (Matrix.toLin' (leveque04_negativeCoefficientPart (basis z.1 z.2)
        (speeds z.1 z.2))).toContinuousLinearMap) (center,(fun x => q x time) center))
    (hhomogeneous : ∀ x q, equation.forcing x time q = 0)
    (hmeans : ∀ᶠ k in L,
      oneDimensionalCellAverage (fun x => q x time) (center-width k/2) (center+width k/2)
        ∈ equation.admissibleStates ∧
      oneDimensionalCellAverage (fun x => q x time) (center+width k-width k/2)
        (center+width k+width k/2) ∈ equation.admissibleStates) :
    ∃ qt : Fin m → ℝ, HasDerivAt (fun τ => q center τ) qt time ∧
    let avg := fun k c => oneDimensionalCellAverage (fun x => q x time) (c-width k/2) (c+width k/2)
    (∀ᶠ k in L,
      (∀ p, (equation.principal center time (avg k center)).mulVec
        (basis center (avg k center) p) =
          speeds center (avg k center) p • basis center (avg k center) p) ∧
      (∀ p, (equation.principal (center+width k) time (avg k (center+width k))).mulVec
        (basis (center+width k) (avg k (center+width k)) p) =
          speeds (center+width k) (avg k (center+width k)) p •
            basis (center+width k) (avg k (center+width k)) p)) ∧
    Tendsto (fun k => qt + (width k)⁻¹ •
      (leveque04_positiveFluctuation (speeds center (avg k center))
        (leveque03_riemannWave (basis center (avg k center))
          (avg k (center-width k)) (avg k center)) +
       leveque04_negativeFluctuation (speeds (center+width k) (avg k (center+width k)))
        (leveque03_riemannWave (basis (center+width k) (avg k (center+width k)))
          (avg k center) (avg k (center+width k))))) L (𝓝 0) := by
  obtain ⟨hcenter,qt,actualQx,hqt,hspace,hpde⟩ := hclassical
  have hqx : actualQx = qx center := hspace.unique
    (hasDerivAt_pi.mpr (fun p => hf p center))
  rw [hqx] at hpde
  exact ⟨qt,hqt,nonconservative_system_spatial_residual_tendsto
    equation time center (fun x => q x time) qx qt K M width basis speeds
    hK hM hf hLip hfield hw hcenter heigen hplus hminus hhomogeneous hpde hmeans⟩

end NumStability
