/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CrankNicolsonEnergy
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsOrderWitness
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerAccuracy

import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import Mathlib.MeasureTheory.Integral.IntervalIntegral.TrapezoidalRule

/-!
# LeVeque Chapter 4: temporal order of Crank–Nicolson

The scalar amplification factor of a dissipative linear mode agrees
with the second-order Taylor polynomial through quadratic order. Its
exact rational remainder is cubic. Connecting this mode calculation
to the variable-coefficient spatial diffusion grid requires separate
operator and regularity estimates.
-/

namespace NumStability

open MeasureTheory Interval

/-- One time interval of Crank–Nicolson averaging has a cubic
quadrature error for a twice continuously differentiable exact flux
with uniformly bounded second derivative. -/
theorem leveque04_crankNicolson_temporalQuadrature_bound
    (flux : ℝ → ℝ) (oldTime timeStep curvatureBound : ℝ)
    (htime : 0 < timeStep)
    (hsmooth : ContDiffOn ℝ 2 flux [[oldTime, oldTime + timeStep]])
    (hcurvature : ∀ t,
      |iteratedDerivWithin 2 flux [[oldTime, oldTime + timeStep]] t| ≤
        curvatureBound) :
    |(∫ t in oldTime..oldTime + timeStep, flux t) -
        timeStep / 2 * (flux oldTime + flux (oldTime + timeStep))| ≤
      timeStep ^ 3 * curvatureBound / 12 := by
  have h := trapezoidal_error_le_of_c2 hsmooth hcurvature
    (N := 1) (by norm_num)
  rw [trapezoidal_error, trapezoidal_integral_one] at h
  have hwidth : |oldTime + timeStep - oldTime| = timeStep := by
    simp [abs_of_pos htime]
  simpa [hwidth, abs_of_pos htime, abs_sub_comm] using h

/-- Second-order spatial flux estimates at both time levels, together
with a C² time flux and exact conservation, give a quadratic
time-normalized local Crank–Nicolson residual. -/
theorem leveque04_crankNicolson_spaceTimeResidual_bound
    (exactFlux : ℝ → ℝ)
    (oldTime timeStep width oldValue newValue
      oldDiscreteFlux newDiscreteFlux spatialBound curvatureBound : ℝ)
    (htime : 0 < timeStep)
    (hsmooth : ContDiffOn ℝ 2 exactFlux [[oldTime, oldTime + timeStep]])
    (hcurvature : ∀ t,
      |iteratedDerivWithin 2 exactFlux [[oldTime, oldTime + timeStep]] t| ≤
        curvatureBound)
    (hbalance : newValue - oldValue =
      ∫ t in oldTime..oldTime + timeStep, exactFlux t)
    (hold : |oldDiscreteFlux - exactFlux oldTime| ≤
      spatialBound * width ^ 2)
    (hnew : |newDiscreteFlux - exactFlux (oldTime + timeStep)| ≤
      spatialBound * width ^ 2) :
    |(newValue - oldValue -
        timeStep / 2 * (oldDiscreteFlux + newDiscreteFlux)) / timeStep| ≤
      curvatureBound * timeStep ^ 2 / 12 + spatialBound * width ^ 2 := by
  have htimeBound := leveque04_crankNicolson_temporalQuadrature_bound
    exactFlux oldTime timeStep curvatureBound htime hsmooth hcurvature
  have hspaceSum : |(oldDiscreteFlux - exactFlux oldTime) +
      (newDiscreteFlux - exactFlux (oldTime + timeStep))| ≤
      2 * spatialBound * width ^ 2 := by
    calc
      _ ≤ |oldDiscreteFlux - exactFlux oldTime| +
          |newDiscreteFlux - exactFlux (oldTime + timeStep)| := abs_add_le _ _
      _ ≤ _ := by linarith
  have hresidual :
      |newValue - oldValue -
          timeStep / 2 * (oldDiscreteFlux + newDiscreteFlux)| ≤
        timeStep ^ 3 * curvatureBound / 12 +
          timeStep * spatialBound * width ^ 2 := by
    rw [hbalance]
    have hidentity :
        (∫ t in oldTime..oldTime + timeStep, exactFlux t) -
            timeStep / 2 * (oldDiscreteFlux + newDiscreteFlux) =
          ((∫ t in oldTime..oldTime + timeStep, exactFlux t) -
            timeStep / 2 *
              (exactFlux oldTime + exactFlux (oldTime + timeStep))) -
          timeStep / 2 *
            ((oldDiscreteFlux - exactFlux oldTime) +
              (newDiscreteFlux - exactFlux (oldTime + timeStep))) := by ring
    rw [hidentity]
    calc
      _ ≤ |(∫ t in oldTime..oldTime + timeStep, exactFlux t) -
          timeStep / 2 *
            (exactFlux oldTime + exactFlux (oldTime + timeStep))| +
          |timeStep / 2 *
            ((oldDiscreteFlux - exactFlux oldTime) +
              (newDiscreteFlux - exactFlux (oldTime + timeStep)))| := by
            simpa only [sub_eq_add_neg, abs_neg] using
              (abs_add_le
                ((∫ t in oldTime..oldTime + timeStep, exactFlux t) -
                  timeStep / 2 *
                    (exactFlux oldTime + exactFlux (oldTime + timeStep)))
                (-(timeStep / 2 *
                  ((oldDiscreteFlux - exactFlux oldTime) +
                    (newDiscreteFlux - exactFlux (oldTime + timeStep))))))
      _ ≤ _ := by
        rw [abs_mul, abs_of_pos (by linarith : 0 < timeStep / 2)]
        have hscaled := mul_le_mul_of_nonneg_left hspaceSum
          (by linarith : 0 ≤ timeStep / 2)
        nlinarith [htimeBound]
  rw [abs_div, abs_of_pos htime]
  apply (div_le_iff₀ htime).mpr
  nlinarith [hresidual]

/-- Scalar Crank–Nicolson amplification for `u' = lambda*u` with
`z=lambda*dt`. -/
noncomputable def leveque04_crankNicolsonAmplification (z : ℝ) : ℝ :=
  (1 + z / 2) / (1 - z / 2)

/-- The amplification factor differs from the second-order Taylor
polynomial by an exact cubic rational remainder. -/
theorem leveque04_crankNicolsonAmplification_taylor2
    (z : ℝ) (hden : 1 - z / 2 ≠ 0) :
    leveque04_crankNicolsonAmplification z -
        (1 + z + z ^ 2 / 2) =
      z ^ 3 / (4 * (1 - z / 2)) := by
  unfold leveque04_crankNicolsonAmplification
  have hden2 : 2 - z ≠ 0 := by
    intro h
    apply hden
    linarith
  field_simp [hden, hden2]
  ring

/-- For a dissipative scalar mode, the time-step remainder is at most
`|z|³/4` with no upper restriction on the time step. -/
theorem leveque04_crankNicolsonAmplification_taylor2_bound
    (z : ℝ) (hz : z ≤ 0) :
    |leveque04_crankNicolsonAmplification z -
        (1 + z + z ^ 2 / 2)| ≤ |z| ^ 3 / 4 := by
  have hden : 0 < 1 - z / 2 := by linarith
  rw [leveque04_crankNicolsonAmplification_taylor2 z (ne_of_gt hden)]
  rw [abs_div, abs_pow, abs_of_pos (by positivity : 0 < 4 * (1 - z / 2))]
  have hdenBound : (4 : ℝ) ≤ 4 * (1 - z / 2) := by linarith
  exact div_le_div_of_nonneg_left (pow_nonneg (abs_nonneg z) 3)
    (by norm_num) hdenBound

/-- With a fixed nonpositive mode eigenvalue, dividing the one-step
error by the positive time step leaves a quadratic bound in that
time step. -/
theorem leveque04_crankNicolson_temporalResidual_bound
    (eigenvalue timeStep : ℝ)
    (heigen : eigenvalue ≤ 0) (htime : 0 < timeStep) :
    |leveque04_crankNicolsonAmplification (eigenvalue * timeStep) -
        (1 + eigenvalue * timeStep +
          (eigenvalue * timeStep) ^ 2 / 2)| / timeStep ≤
      |eigenvalue| ^ 3 * timeStep ^ 2 / 4 := by
  have hz : eigenvalue * timeStep ≤ 0 :=
    mul_nonpos_of_nonpos_of_nonneg heigen htime.le
  have h := leveque04_crankNicolsonAmplification_taylor2_bound
    (eigenvalue * timeStep) hz
  apply (div_le_iff₀ htime).mpr
  rw [abs_mul, abs_of_pos htime] at h
  nlinarith [h]

/-- The centered diffusion flux (4.10), applied to exact quadratic
cell averages, equals the physical Fick flux at the interface. The
cell-average `h²/12` correction cancels in the gradient. -/
theorem leveque04_diffusion_quadraticFaceFlux_exact
    (diffusivity width : ℝ) (i : ℤ) (hwidth : 0 < width) :
    leveque04_diffusionInterfaceFlux (fun _ => diffusivity)
        (leveque04_quadraticCellAverage width) width i =
      -(diffusivity * (2 * ((i : ℝ) * width - width / 2))) := by
  have hne : width ≠ 0 := ne_of_gt hwidth
  simp only [leveque04_diffusionInterfaceFlux,
    Leveque02Tracer.fickFlux, leveque04_quadraticCellAverage]
  push_cast
  field_simp
  ring

/-- The exact cubic cell averages reuse the Chapter 4 polynomial
average identity already used for Richtmyer accuracy. -/
noncomputable def leveque04_cubicCellAverage
    (width : ℝ) (i : ℤ) : ℝ :=
  ((i : ℝ) * width) ^ 3 + ((i : ℝ) * width) * width ^ 2 / 4

theorem leveque04_cubicCellAverage_exact
    (width : ℝ) (i : ℤ) (hwidth : 0 < width) :
    oneDimensionalCellAverage (fun x : ℝ => x ^ 3)
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2) =
      leveque04_cubicCellAverage width i := by
  simpa only [leveque04_cubicCellAverage] using
    leveque04_cubicAverageAtCenter ((i : ℝ) * width) width hwidth

/-- On exact cubic cell averages, the centered interface gradient has
an exact `width²/2` error relative to the physical cubic derivative. -/
theorem leveque04_diffusion_cubicFaceFlux_error
    (diffusivity width : ℝ) (i : ℤ) (hwidth : 0 < width) :
    leveque04_diffusionInterfaceFlux (fun _ => diffusivity)
        (leveque04_cubicCellAverage width) width i -
      (-(diffusivity *
        (3 * (((i : ℝ) * width - width / 2) ^ 2)))) =
      -(diffusivity * width ^ 2 / 2) := by
  have hne : width ≠ 0 := ne_of_gt hwidth
  simp only [leveque04_diffusionInterfaceFlux,
    Leveque02Tracer.fickFlux, leveque04_cubicCellAverage]
  push_cast
  field_simp
  ring

/-- Averaging an affine time-dependent flux at the old and new times
equals its exact midpoint value. -/
theorem leveque04_crankNicolson_affineTimeFlux_exact
    (slope intercept oldTime timeStep : ℝ) :
    ((slope * oldTime + intercept) +
        (slope * (oldTime + timeStep) + intercept)) / 2 =
      slope * (oldTime + timeStep / 2) + intercept := by
  ring

/-- On exact smooth cell averages, the equation (4.10) flux approximates the physical Fick flux at each interface with a quadratic spatial error. -/
theorem leveque04_diffusion_smoothFaceFlux_error_le
    (f f' f'' diffusivity : ℝ → ℝ) (K width : ℝ) (i : ℤ)
    (hK : 0 ≤ K) (hwidth : 0 < width)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hf' : ∀ x, HasDerivAt f' (f'' x) x)
    (hLip : ∀ x y, |f'' x - f'' y| ≤ K * |x - y|) :
    |leveque04_diffusionInterfaceFlux
        (fun j => diffusivity ((j : ℝ) * width - width / 2))
        (fun j => oneDimensionalCellAverage f
          ((j : ℝ) * width - width / 2)
          ((j : ℝ) * width + width / 2)) width i -
      (-(diffusivity ((i : ℝ) * width - width / 2) *
        f' ((i : ℝ) * width - width / 2)))| ≤
      |diffusivity ((i : ℝ) * width - width / 2)| * (K * width ^ 2 / 2) := by
  let face := (i : ℝ) * width - width / 2
  let cellAvg : ℤ → ℝ := fun j => oneDimensionalCellAverage f
    ((j : ℝ) * width - width / 2)
    ((j : ℝ) * width + width / 2)
  have hcelli : cellAvg i = oneDimensionalCellAverage f face (face + width) := by
    dsimp [cellAvg, face]
    congr 1 <;> ring
  have hcellprev : cellAvg (i - 1) =
      oneDimensionalCellAverage f (face - width) face := by
    dsimp [cellAvg, face]
    push_cast
    congr 1 <;> ring
  have hbase := oneDimensionalCellAverage_centeredSlope_error_le
    f f' f'' K face width hK hwidth hf hf' hLip
  have hflux : |-(diffusivity face * ((cellAvg i - cellAvg (i - 1)) / width)) -
      (-(diffusivity face * f' face))| ≤
      |diffusivity face| * (K * width ^ 2 / 2) := by
    rw [hcelli, hcellprev]
    have hid : -(diffusivity face *
        ((oneDimensionalCellAverage f face (face + width) -
          oneDimensionalCellAverage f (face - width) face) / width)) -
        (-(diffusivity face * f' face)) =
      -(diffusivity face *
        ((oneDimensionalCellAverage f face (face + width) -
          oneDimensionalCellAverage f (face - width) face) / width - f' face)) := by ring
    rw [hid, abs_neg, abs_mul]
    exact mul_le_mul_of_nonneg_left hbase (abs_nonneg _)
  simpa only [face, cellAvg, leveque04_diffusionInterfaceFlux,
    Leveque02Tracer.fickFlux] using hflux

/-- A uniform interface diffusivity bound makes the exact-average
spatial flux error uniform over all grid interfaces. -/
theorem leveque04_diffusion_smoothFaceFlux_uniform_error_le
    (f f' f'' diffusivity : ℝ → ℝ) (K D width : ℝ)
    (hK : 0 ≤ K) (hwidth : 0 < width)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hf' : ∀ x, HasDerivAt f' (f'' x) x)
    (hLip : ∀ x y, |f'' x - f'' y| ≤ K * |x - y|)
    (hD : ∀ x, |diffusivity x| ≤ D) (i : ℤ) :
    |leveque04_diffusionInterfaceFlux
        (fun j => diffusivity ((j : ℝ) * width - width / 2))
        (fun j => oneDimensionalCellAverage f
          ((j : ℝ) * width - width / 2)
          ((j : ℝ) * width + width / 2)) width i -
      (-(diffusivity ((i : ℝ) * width - width / 2) *
        f' ((i : ℝ) * width - width / 2)))| ≤
      D * (K * width ^ 2 / 2) := by
  have hflux := leveque04_diffusion_smoothFaceFlux_error_le
    f f' f'' diffusivity K width i hK hwidth hf hf' hLip
  have hnonneg : 0 ≤ K * width ^ 2 / 2 := by positivity
  exact hflux.trans (mul_le_mul_of_nonneg_right (hD _) hnonneg)

/-- Variable diffusivity and neighboring slope-error cancellation give a quadratic discrete divergence error for exact smooth cell averages. -/
theorem leveque04_weightedCellAverageSlopeError_divergence_le
    (f f' f'' f''' diffusivity : ℝ → ℝ)
    (K2 K3 D L face width : ℝ)
    (hK2 : 0 ≤ K2) (hK3 : 0 ≤ K3)
    (hwidth : 0 < width)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hf' : ∀ x, HasDerivAt f' (f'' x) x)
    (hf'' : ∀ x, HasDerivAt f'' (f''' x) x)
    (hLip2 : ∀ x y, |f'' x - f'' y| ≤ K2 * |x - y|)
    (hLip3 : ∀ x y, |f''' x - f''' y| ≤ K3 * |x - y|)
    (hDbound : ∀ x, |diffusivity x| ≤ D)
    (hDLip : ∀ x y, |diffusivity x - diffusivity y| ≤ L * |x - y|) :
    let err : ℝ → ℝ := fun c =>
      (oneDimensionalCellAverage f c (c + width) -
        oneDimensionalCellAverage f (c - width) c) / width - f' c
    |(diffusivity (face + width) * err (face + width) -
        diffusivity face * err face) / width| ≤
      (D * K3 / 2 + L * K2 / 2) * width ^ 2 := by
  intro err
  have he0 : |err face| ≤ K2 * width ^ 2 / 2 :=
    oneDimensionalCellAverage_centeredSlope_error_le
      f f' f'' K2 face width hK2 hwidth hf hf' hLip2
  have hdiff : |err (face + width) - err face| ≤ K3 * width ^ 3 / 2 :=
    oneDimensionalCellAverage_centeredSlopeError_neighbor_bound
      f f' f'' f''' K3 face width hK3 hwidth hf hf' hf'' hLip3
  have hDL : |diffusivity (face + width) - diffusivity face| ≤ L * width := by
    have h := hDLip (face + width) face
    simpa only [show face + width - face = width by ring,
      abs_of_pos hwidth] using h
  have hA : |diffusivity (face + width)| *
      |err (face + width) - err face| ≤ D * (K3 * width ^ 3 / 2) := by
    calc
      _ ≤ |diffusivity (face + width)| * (K3 * width ^ 3 / 2) :=
        mul_le_mul_of_nonneg_left hdiff (abs_nonneg _)
      _ ≤ _ := mul_le_mul_of_nonneg_right (hDbound _) (by positivity)
  have hB : |diffusivity (face + width) - diffusivity face| * |err face| ≤
      (L * width) * (K2 * width ^ 2 / 2) := by
    calc
      _ ≤ |diffusivity (face + width) - diffusivity face| *
          (K2 * width ^ 2 / 2) := mul_le_mul_of_nonneg_left he0 (abs_nonneg _)
      _ ≤ _ := mul_le_mul_of_nonneg_right hDL (by positivity)
  have hnum : |diffusivity (face + width) * err (face + width) -
      diffusivity face * err face| ≤
      (D * K3 / 2 + L * K2 / 2) * width ^ 3 := by
    calc
      _ = |diffusivity (face + width) *
          (err (face + width) - err face) +
          (diffusivity (face + width) - diffusivity face) * err face| := by
            congr 1
            ring
      _ ≤ |diffusivity (face + width)| *
          |err (face + width) - err face| +
          |diffusivity (face + width) - diffusivity face| * |err face| := by
            simpa only [abs_mul] using abs_add_le
              (diffusivity (face + width) * (err (face + width) - err face))
              ((diffusivity (face + width) - diffusivity face) * err face)
      _ ≤ D * (K3 * width ^ 3 / 2) +
          (L * width) * (K2 * width ^ 2 / 2) := add_le_add hA hB
      _ = _ := by ring
  have hnum2 : |diffusivity (face + width) * err (face + width) -
      diffusivity face * err face| ≤
      ((D * K3 / 2 + L * K2 / 2) * width ^ 2) * width := by
    convert hnum using 1 <;> ring
  rw [abs_div, abs_of_pos hwidth]
  exact (div_le_iff₀ hwidth).mpr hnum2

/-- The discrete divergence of the exact-average Fick flux approximates the physical flux divergence to quadratic spatial order. -/
theorem leveque04_diffusion_smoothFluxDivergence_error_le
    (f f' f'' f''' diffusivity : ℝ → ℝ)
    (K2 K3 D L face width : ℝ)
    (hK2 : 0 ≤ K2) (hK3 : 0 ≤ K3) (hwidth : 0 < width)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hf' : ∀ x, HasDerivAt f' (f'' x) x)
    (hf'' : ∀ x, HasDerivAt f'' (f''' x) x)
    (hLip2 : ∀ x y, |f'' x - f'' y| ≤ K2 * |x - y|)
    (hLip3 : ∀ x y, |f''' x - f''' y| ≤ K3 * |x - y|)
    (hDbound : ∀ x, |diffusivity x| ≤ D)
    (hDLip : ∀ x y, |diffusivity x - diffusivity y| ≤ L * |x - y|) :
    let numericalFlux : ℝ → ℝ := fun c =>
      -(diffusivity c *
        ((oneDimensionalCellAverage f c (c + width) -
          oneDimensionalCellAverage f (c - width) c) / width))
    let physicalFlux : ℝ → ℝ := fun c => -(diffusivity c * f' c)
    |(numericalFlux (face + width) - numericalFlux face) / width -
      (physicalFlux (face + width) - physicalFlux face) / width| ≤
      (D * K3 / 2 + L * K2 / 2) * width ^ 2 := by
  intro numericalFlux physicalFlux
  let err : ℝ → ℝ := fun c =>
    (oneDimensionalCellAverage f c (c + width) -
      oneDimensionalCellAverage f (c - width) c) / width - f' c
  have h := leveque04_weightedCellAverageSlopeError_divergence_le
    f f' f'' f''' diffusivity K2 K3 D L face width
    hK2 hK3 hwidth hf hf' hf'' hLip2 hLip3 hDbound hDLip
  have heq : (numericalFlux (face + width) - numericalFlux face) / width -
      (physicalFlux (face + width) - physicalFlux face) / width =
      -((diffusivity (face + width) * err (face + width) -
        diffusivity face * err face) / width) := by
    dsimp [numericalFlux, physicalFlux, err]
    ring
  rw [heq, abs_neg]
  exact h

/-- A pointwise conservation equation and spatial FTC give the exact instantaneous cell flux balance. -/
theorem leveque04_diffusion_spatialCellBalance
    (qTime flux fluxDerivative : ℝ → ℝ) (a b : ℝ)
    (hflux : ∀ x, HasDerivAt flux (fluxDerivative x) x)
    (hpde : ∀ x, qTime x + fluxDerivative x = 0)
    (hfx : IntervalIntegrable fluxDerivative volume a b) :
    (∫ x in a..b, qTime x) = flux a - flux b := by
  have heq : qTime = fun x => -fluxDerivative x := by
    funext x
    linarith [hpde x]
  rw [heq, intervalIntegral.integral_neg]
  have h := intervalIntegral.integral_eq_sub_of_hasDerivAt
    (fun x _ => hflux x) hfx
  rw [h]
  ring

/-- Differentiation under the cell integral and temporal FTC integrate the exact diffusion flux balance between two time levels. -/
theorem leveque04_diffusion_integratedCellAverageBalance
    (q qTime flux fluxDerivative : ℝ → ℝ → ℝ)
    (a b oldTime timeStep width : ℝ)
    (hwidth : b - a = width)
    (hflux : ∀ τ x, HasDerivAt (fun ξ => flux ξ τ) (fluxDerivative x τ) x)
    (hpde : ∀ τ x, qTime x τ + fluxDerivative x τ = 0)
    (hfx : ∀ τ, IntervalIntegrable (fun x => fluxDerivative x τ) volume a b)
    (hinterchange : ∀ τ,
      HasDerivAt (fun σ => ∫ x in a..b, q x σ)
        (∫ x in a..b, qTime x τ) τ)
    (hleft : IntervalIntegrable (fun τ => flux a τ) volume oldTime (oldTime + timeStep))
    (hright : IntervalIntegrable (fun τ => flux b τ) volume oldTime (oldTime + timeStep)) :
    oneDimensionalCellAverage (fun x => q x (oldTime + timeStep)) a b -
      oneDimensionalCellAverage (fun x => q x oldTime) a b =
      ∫ τ in oldTime..oldTime + timeStep,
        (flux a τ - flux b τ) / width := by
  have hderiv (τ : ℝ) :
      HasDerivAt (fun σ => ∫ x in a..b, q x σ)
        (flux a τ - flux b τ) τ := by
    have hspatial := leveque04_diffusion_spatialCellBalance
      (fun x => qTime x τ) (fun x => flux x τ)
      (fun x => fluxDerivative x τ) a b (hflux τ) (hpde τ) (hfx τ)
    have hs := hinterchange τ
    rw [hspatial] at hs
    exact hs
  have hint : IntervalIntegrable (fun τ => flux a τ - flux b τ)
      volume oldTime (oldTime + timeStep) := hleft.sub hright
  have htime := intervalIntegral.integral_eq_sub_of_hasDerivAt
    (fun τ _ => hderiv τ) hint
  calc
    _ = ((∫ x in a..b, q x (oldTime + timeStep)) -
        (∫ x in a..b, q x oldTime)) / width := by
          simp only [oneDimensionalCellAverage, hwidth, smul_eq_mul]
          ring
    _ = (∫ τ in oldTime..oldTime + timeStep,
        (flux a τ - flux b τ)) / width := by rw [htime]
    _ = ∫ τ in oldTime..oldTime + timeStep,
        (flux a τ - flux b τ) / width := by
          rw [intervalIntegral.integral_div]

/-- For a smooth exact heat solution, the Crank-Nicolson update formed from exact cell averages has a local residual of order `timeStep² + width²` under the stated spatial and temporal regularity bounds. -/
theorem leveque04_crankNicolson_smoothExactCellResidual_bound
    (q qTime qX qXX qXXX fluxDerivative : ℝ → ℝ → ℝ)
    (diffusivity : ℝ → ℝ)
    (K2 K3 D L face width oldTime timeStep curvatureBound : ℝ)
    (hK2 : 0 ≤ K2) (hK3 : 0 ≤ K3)
    (hwidth : 0 < width) (htime : 0 < timeStep)
    (hq : ∀ τ x, HasDerivAt (fun ξ => q ξ τ) (qX x τ) x)
    (hqX : ∀ τ x, HasDerivAt (fun ξ => qX ξ τ) (qXX x τ) x)
    (hqXX : ∀ τ x, HasDerivAt (fun ξ => qXX ξ τ) (qXXX x τ) x)
    (hLip2 : ∀ τ x y, |qXX x τ - qXX y τ| ≤ K2 * |x - y|)
    (hLip3 : ∀ τ x y, |qXXX x τ - qXXX y τ| ≤ K3 * |x - y|)
    (hDbound : ∀ x, |diffusivity x| ≤ D)
    (hDLip : ∀ x y, |diffusivity x - diffusivity y| ≤ L * |x - y|)
    (hFluxDerivative : ∀ τ x,
      HasDerivAt (fun ξ => -(diffusivity ξ * qX ξ τ))
        (fluxDerivative x τ) x)
    (hPDE : ∀ τ x, qTime x τ + fluxDerivative x τ = 0)
    (hfxInt : ∀ τ,
      IntervalIntegrable (fun x => fluxDerivative x τ) volume face (face + width))
    (hInterchange : ∀ τ,
      HasDerivAt (fun σ => ∫ x in face..face + width, q x σ)
        (∫ x in face..face + width, qTime x τ) τ)
    (hleftInt : IntervalIntegrable
      (fun τ => -(diffusivity face * qX face τ)) volume oldTime (oldTime + timeStep))
    (hrightInt : IntervalIntegrable
      (fun τ => -(diffusivity (face + width) * qX (face + width) τ))
      volume oldTime (oldTime + timeStep))
    (hTimeSmooth : ContDiffOn ℝ 2
      (fun τ => (-(diffusivity face * qX face τ) -
        -(diffusivity (face + width) * qX (face + width) τ)) / width)
      [[oldTime, oldTime + timeStep]])
    (hCurvature : ∀ τ,
      |iteratedDerivWithin 2
        (fun σ => (-(diffusivity face * qX face σ) -
          -(diffusivity (face + width) * qX (face + width) σ)) / width)
        [[oldTime, oldTime + timeStep]] τ| ≤ curvatureBound) :
    let numericalFlux : ℝ → ℝ → ℝ := fun c τ =>
      -(diffusivity c *
        ((oneDimensionalCellAverage (fun x => q x τ) c (c + width) -
          oneDimensionalCellAverage (fun x => q x τ) (c - width) c) / width))
    let netNumericalFlux : ℝ → ℝ := fun τ =>
      (numericalFlux face τ - numericalFlux (face + width) τ) / width
    |(oneDimensionalCellAverage (fun x => q x (oldTime + timeStep))
          face (face + width) -
        oneDimensionalCellAverage (fun x => q x oldTime) face (face + width) -
        timeStep / 2 *
          (netNumericalFlux oldTime + netNumericalFlux (oldTime + timeStep))) /
      timeStep| ≤
      curvatureBound * timeStep ^ 2 / 12 +
        (D * K3 / 2 + L * K2 / 2) * width ^ 2 := by
  intro numericalFlux netNumericalFlux
  let exactFlux : ℝ → ℝ := fun τ =>
    (-(diffusivity face * qX face τ) -
      -(diffusivity (face + width) * qX (face + width) τ)) / width
  have hBalance :
      oneDimensionalCellAverage (fun x => q x (oldTime + timeStep)) face (face + width) -
        oneDimensionalCellAverage (fun x => q x oldTime) face (face + width) =
        ∫ τ in oldTime..oldTime + timeStep, exactFlux τ := by
    exact leveque04_diffusion_integratedCellAverageBalance
      q qTime (fun x τ => -(diffusivity x * qX x τ)) fluxDerivative
      face (face + width) oldTime timeStep width (by ring)
      hFluxDerivative hPDE hfxInt hInterchange hleftInt hrightInt
  have hSpace (τ : ℝ) :
      |netNumericalFlux τ - exactFlux τ| ≤
        (D * K3 / 2 + L * K2 / 2) * width ^ 2 := by
    let discFace : ℝ → ℝ := fun c => numericalFlux c τ
    let physFace : ℝ → ℝ := fun c => -(diffusivity c * qX c τ)
    have h := leveque04_diffusion_smoothFluxDivergence_error_le
      (fun x => q x τ) (fun x => qX x τ) (fun x => qXX x τ)
      (fun x => qXXX x τ) diffusivity K2 K3 D L face width
      hK2 hK3 hwidth (hq τ) (hqX τ) (hqXX τ)
      (hLip2 τ) (hLip3 τ) hDbound hDLip
    change |(discFace (face + width) - discFace face) / width -
      (physFace (face + width) - physFace face) / width| ≤
        (D * K3 / 2 + L * K2 / 2) * width ^ 2 at h
    have heq : netNumericalFlux τ - exactFlux τ =
        -((discFace (face + width) - discFace face) / width -
          (physFace (face + width) - physFace face) / width) := by
      dsimp [netNumericalFlux, exactFlux, discFace, physFace]
      ring
    rw [heq, abs_neg]
    exact h
  exact leveque04_crankNicolson_spaceTimeResidual_bound
    exactFlux oldTime timeStep width
    (oneDimensionalCellAverage (fun x => q x oldTime) face (face + width))
    (oneDimensionalCellAverage (fun x => q x (oldTime + timeStep)) face (face + width))
    (netNumericalFlux oldTime) (netNumericalFlux (oldTime + timeStep))
    (D * K3 / 2 + L * K2 / 2) curvatureBound
    htime hTimeSmooth hCurvature hBalance
    (hSpace oldTime) (hSpace (oldTime + timeStep))

/-- The residual of the existing conservative CN step is the time-centered difference of its two interface flux divergences. -/
theorem leveque04_crankNicolson_indexedResidual_eq_fluxResidual
    (diffusivity before after : ℤ → ℝ) (timeStep width : ℝ) (i : ℤ) :
    (after i - conservativeFluxDifferenceUpdateInt (timeStep / width) before
      (leveque04_crankNicolsonInterfaceFlux diffusivity width before after) i) /
      timeStep =
    (after i - before i - timeStep / 2 *
      (((leveque04_diffusionInterfaceFlux diffusivity before width i -
          leveque04_diffusionInterfaceFlux diffusivity before width (i + 1)) / width) +
       ((leveque04_diffusionInterfaceFlux diffusivity after width i -
          leveque04_diffusionInterfaceFlux diffusivity after width (i + 1)) / width))) /
      timeStep := by
  simp only [conservativeFluxDifferenceUpdateInt, smul_eq_mul,
    leveque04_crankNicolsonInterfaceFlux]
  ring

/-- The indexed equation-(4.10) flux on exact averages equals its continuous-face form. -/
theorem leveque04_diffusion_exactAverage_interfaceFlux_eq
    (f d : ℝ → ℝ) (width : ℝ) (i : ℤ) :
    let face := (i : ℝ) * width - width / 2
    leveque04_diffusionInterfaceFlux
        (fun j => d ((j : ℝ) * width - width / 2))
        (fun j => oneDimensionalCellAverage f
          ((j : ℝ) * width - width / 2)
          ((j : ℝ) * width + width / 2)) width i =
      -(d face *
        ((oneDimensionalCellAverage f face (face + width) -
          oneDimensionalCellAverage f (face - width) face) / width)) := by
  intro face
  let cellAvg : ℤ → ℝ := fun j => oneDimensionalCellAverage f
    ((j : ℝ) * width - width / 2)
    ((j : ℝ) * width + width / 2)
  have hcelli : cellAvg i = oneDimensionalCellAverage f face (face + width) := by
    dsimp [cellAvg, face]
    congr 1 <;> ring
  have hcellprev : cellAvg (i - 1) =
      oneDimensionalCellAverage f (face - width) face := by
    dsimp [cellAvg, face]
    push_cast
    congr 1 <;> ring
  change -(d face * ((cellAvg i - cellAvg (i - 1)) / width)) =
    -(d face * ((oneDimensionalCellAverage f face (face + width) -
      oneDimensionalCellAverage f (face - width) face) / width))
  rw [hcelli, hcellprev]

/-- Indexing exact cell averages by grid centers converts the conservative equation-(4.13) residual to the continuous-face residual. -/
theorem leveque04_crankNicolson_exactAverage_indexedResidual_eq
    (oldProfile newProfile diffusivity : ℝ → ℝ)
    (width timeStep : ℝ) (i : ℤ) :
    let face := (i : ℝ) * width - width / 2
    let coefficient : ℤ → ℝ := fun j => diffusivity ((j : ℝ) * width - width / 2)
    let before : ℤ → ℝ := fun j => oneDimensionalCellAverage oldProfile
      ((j : ℝ) * width - width / 2) ((j : ℝ) * width + width / 2)
    let after : ℤ → ℝ := fun j => oneDimensionalCellAverage newProfile
      ((j : ℝ) * width - width / 2) ((j : ℝ) * width + width / 2)
    let oldFaceFlux : ℝ → ℝ := fun c => -(diffusivity c *
      ((oneDimensionalCellAverage oldProfile c (c + width) -
        oneDimensionalCellAverage oldProfile (c - width) c) / width))
    let newFaceFlux : ℝ → ℝ := fun c => -(diffusivity c *
      ((oneDimensionalCellAverage newProfile c (c + width) -
        oneDimensionalCellAverage newProfile (c - width) c) / width))
    (after i - conservativeFluxDifferenceUpdateInt (timeStep / width) before
      (leveque04_crankNicolsonInterfaceFlux coefficient width before after) i) /
      timeStep =
    (oneDimensionalCellAverage newProfile face (face + width) -
      oneDimensionalCellAverage oldProfile face (face + width) -
      timeStep / 2 *
        (((oldFaceFlux face - oldFaceFlux (face + width)) / width) +
         ((newFaceFlux face - newFaceFlux (face + width)) / width))) /
      timeStep := by
  intro face coefficient before after oldFaceFlux newFaceFlux
  have havgOld : before i = oneDimensionalCellAverage oldProfile face (face + width) := by
    dsimp [before, face]
    congr 1 <;> ring
  have havgNew : after i = oneDimensionalCellAverage newProfile face (face + width) := by
    dsimp [after, face]
    congr 1 <;> ring
  have hnext : ((i + 1 : ℤ) : ℝ) * width - width / 2 = face + width := by
    dsimp [face]
    push_cast
    ring
  have hOldFace : leveque04_diffusionInterfaceFlux coefficient before width i =
      oldFaceFlux face := by
    have h := leveque04_diffusion_exactAverage_interfaceFlux_eq oldProfile diffusivity width i
    exact h
  have hNewFace : leveque04_diffusionInterfaceFlux coefficient after width i =
      newFaceFlux face := by
    have h := leveque04_diffusion_exactAverage_interfaceFlux_eq newProfile diffusivity width i
    exact h
  have hOldNext : leveque04_diffusionInterfaceFlux coefficient before width (i + 1) =
      oldFaceFlux (face + width) := by
    have h := leveque04_diffusion_exactAverage_interfaceFlux_eq oldProfile diffusivity width (i + 1)
    dsimp only at h
    rw [hnext] at h
    exact h
  have hNewNext : leveque04_diffusionInterfaceFlux coefficient after width (i + 1) =
      newFaceFlux (face + width) := by
    have h := leveque04_diffusion_exactAverage_interfaceFlux_eq newProfile diffusivity width (i + 1)
    dsimp only at h
    rw [hnext] at h
    exact h
  rw [leveque04_crankNicolson_indexedResidual_eq_fluxResidual coefficient before after timeStep width i,
    havgOld, havgNew, hOldFace, hNewFace, hOldNext, hNewNext]

/-- An accuracy bound for continuous-face exact averages transfers unchanged to the existing integer-indexed equation-(4.13) stencil. -/
theorem leveque04_crankNicolson_exactAverage_indexedResidual_bound
    (oldProfile newProfile diffusivity : ℝ → ℝ)
    (width timeStep bound : ℝ) (i : ℤ) :
    let face := (i : ℝ) * width - width / 2
    let coefficient : ℤ → ℝ := fun j => diffusivity ((j : ℝ) * width - width / 2)
    let before : ℤ → ℝ := fun j => oneDimensionalCellAverage oldProfile
      ((j : ℝ) * width - width / 2) ((j : ℝ) * width + width / 2)
    let after : ℤ → ℝ := fun j => oneDimensionalCellAverage newProfile
      ((j : ℝ) * width - width / 2) ((j : ℝ) * width + width / 2)
    let oldFaceFlux : ℝ → ℝ := fun c => -(diffusivity c *
      ((oneDimensionalCellAverage oldProfile c (c + width) -
        oneDimensionalCellAverage oldProfile (c - width) c) / width))
    let newFaceFlux : ℝ → ℝ := fun c => -(diffusivity c *
      ((oneDimensionalCellAverage newProfile c (c + width) -
        oneDimensionalCellAverage newProfile (c - width) c) / width))
    |(oneDimensionalCellAverage newProfile face (face + width) -
      oneDimensionalCellAverage oldProfile face (face + width) -
      timeStep / 2 *
        (((oldFaceFlux face - oldFaceFlux (face + width)) / width) +
         ((newFaceFlux face - newFaceFlux (face + width)) / width))) /
      timeStep| ≤ bound →
    |(after i - conservativeFluxDifferenceUpdateInt (timeStep / width) before
      (leveque04_crankNicolsonInterfaceFlux coefficient width before after) i) /
      timeStep| ≤ bound := by
  intro face coefficient before after oldFaceFlux newFaceFlux h
  rw [leveque04_crankNicolson_exactAverage_indexedResidual_eq oldProfile newProfile diffusivity width timeStep i]
  exact h

/-- With exact interface diffusivities, the centered spatial and temporal
Crank-Nicolson face flux approximates the time-averaged physical diffusion
flux to second order under uniform smoothness bounds. -/
theorem leveque04_crankNicolson_timeAveragedFaceFlux_error_le
    (q qX qXX : ℝ → ℝ → ℝ) (diffusivity : ℝ → ℝ)
    (K D width oldTime timeStep curvatureBound : ℝ) (i : ℤ)
    (hK : 0 ≤ K) (hwidth : 0 < width) (htime : 0 < timeStep)
    (hq : ∀ τ x, HasDerivAt (fun ξ => q ξ τ) (qX x τ) x)
    (hqX : ∀ τ x, HasDerivAt (fun ξ => qX ξ τ) (qXX x τ) x)
    (hLip : ∀ τ x y, |qXX x τ - qXX y τ| ≤ K * |x - y|)
    (hD : ∀ x, |diffusivity x| ≤ D)
    (hsmooth : ContDiffOn ℝ 2
      (fun τ => -(diffusivity ((i : ℝ) * width - width / 2) *
        qX ((i : ℝ) * width - width / 2) τ))
      [[oldTime, oldTime + timeStep]])
    (hcurvature : ∀ τ,
      |iteratedDerivWithin 2
        (fun σ => -(diffusivity ((i : ℝ) * width - width / 2) *
          qX ((i : ℝ) * width - width / 2) σ))
        [[oldTime, oldTime + timeStep]] τ| ≤ curvatureBound) :
    let face := (i : ℝ) * width - width / 2
    let coefficient : ℤ → ℝ := fun j => diffusivity ((j : ℝ) * width - width / 2)
    let averages : ℝ → ℤ → ℝ := fun τ j => oneDimensionalCellAverage
      (fun x => q x τ) ((j : ℝ) * width - width / 2)
        ((j : ℝ) * width + width / 2)
    let numericalFlux : ℝ → ℝ := fun τ =>
      leveque04_diffusionInterfaceFlux coefficient (averages τ) width i
    let physicalFlux : ℝ → ℝ := fun τ => -(diffusivity face * qX face τ)
    |(timeStep / 2 * (numericalFlux oldTime + numericalFlux (oldTime + timeStep)) -
      ∫ τ in oldTime..oldTime + timeStep, physicalFlux τ) / timeStep| ≤
      curvatureBound * timeStep ^ 2 / 12 + D * K / 2 * width ^ 2 := by
  intro face coefficient averages numericalFlux physicalFlux
  have hold := leveque04_diffusion_smoothFaceFlux_uniform_error_le
    (fun x => q x oldTime) (fun x => qX x oldTime)
    (fun x => qXX x oldTime) diffusivity K D width hK hwidth
    (hq oldTime) (hqX oldTime) (hLip oldTime) hD i
  have hnew := leveque04_diffusion_smoothFaceFlux_uniform_error_le
    (fun x => q x (oldTime + timeStep))
    (fun x => qX x (oldTime + timeStep))
    (fun x => qXX x (oldTime + timeStep)) diffusivity K D width hK hwidth
    (hq (oldTime + timeStep)) (hqX (oldTime + timeStep))
    (hLip (oldTime + timeStep)) hD i
  have hold' : |numericalFlux oldTime - physicalFlux oldTime| ≤
      (D * K / 2) * width ^ 2 := by
    calc
      _ ≤ D * (K * width ^ 2 / 2) := by
        simpa [face, coefficient, averages, numericalFlux, physicalFlux] using hold
      _ = _ := by ring
  have hnew' : |numericalFlux (oldTime + timeStep) -
      physicalFlux (oldTime + timeStep)| ≤
      (D * K / 2) * width ^ 2 := by
    calc
      _ ≤ D * (K * width ^ 2 / 2) := by
        simpa [face, coefficient, averages, numericalFlux, physicalFlux] using hnew
      _ = _ := by ring
  have hbase := leveque04_crankNicolson_spaceTimeResidual_bound
    physicalFlux oldTime timeStep width 0
    (∫ τ in oldTime..oldTime + timeStep, physicalFlux τ)
    (numericalFlux oldTime) (numericalFlux (oldTime + timeStep))
    (D * K / 2) curvatureBound htime
    (by simpa [physicalFlux, face] using hsmooth)
    (by simpa [physicalFlux, face] using hcurvature)
    (by ring) hold' hnew'
  have hid :
      (timeStep / 2 * (numericalFlux oldTime + numericalFlux (oldTime + timeStep)) -
        ∫ τ in oldTime..oldTime + timeStep, physicalFlux τ) / timeStep =
      -((∫ τ in oldTime..oldTime + timeStep, physicalFlux τ) - 0 -
        timeStep / 2 * (numericalFlux oldTime + numericalFlux (oldTime + timeStep))) /
          timeStep := by ring
  rw [hid, neg_div, abs_neg]
  exact hbase

/-- The smooth exact-average residual bound applies to the integer-indexed
equation-(4.13) conservative update at the corresponding cell. -/
theorem leveque04_crankNicolson_indexedSmoothResidual_bound
    (q qTime qX qXX qXXX fluxDerivative : ℝ → ℝ → ℝ)
    (diffusivity : ℝ → ℝ)
    (K2 K3 D L width oldTime timeStep curvatureBound : ℝ) (i : ℤ)
    (hK2 : 0 ≤ K2) (hK3 : 0 ≤ K3)
    (hwidth : 0 < width) (htime : 0 < timeStep)
    (hq : ∀ τ x, HasDerivAt (fun ξ => q ξ τ) (qX x τ) x)
    (hqX : ∀ τ x, HasDerivAt (fun ξ => qX ξ τ) (qXX x τ) x)
    (hqXX : ∀ τ x, HasDerivAt (fun ξ => qXX ξ τ) (qXXX x τ) x)
    (hLip2 : ∀ τ x y, |qXX x τ - qXX y τ| ≤ K2 * |x - y|)
    (hLip3 : ∀ τ x y, |qXXX x τ - qXXX y τ| ≤ K3 * |x - y|)
    (hDbound : ∀ x, |diffusivity x| ≤ D)
    (hDLip : ∀ x y, |diffusivity x - diffusivity y| ≤ L * |x - y|)
    (hFluxDerivative : ∀ τ x,
      HasDerivAt (fun ξ => -(diffusivity ξ * qX ξ τ))
        (fluxDerivative x τ) x)
    (hPDE : ∀ τ x, qTime x τ + fluxDerivative x τ = 0)
    (hfxInt : ∀ τ,
      IntervalIntegrable (fun x => fluxDerivative x τ) volume
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2))
    (hInterchange : ∀ τ,
      HasDerivAt (fun σ => ∫ x in ((i : ℝ) * width - width / 2)..
        ((i : ℝ) * width + width / 2), q x σ)
        (∫ x in ((i : ℝ) * width - width / 2)..
          ((i : ℝ) * width + width / 2), qTime x τ) τ)
    (hleftInt : IntervalIntegrable
      (fun τ => -(diffusivity ((i : ℝ) * width - width / 2) *
        qX ((i : ℝ) * width - width / 2) τ))
      volume oldTime (oldTime + timeStep))
    (hrightInt : IntervalIntegrable
      (fun τ => -(diffusivity ((i : ℝ) * width + width / 2) *
        qX ((i : ℝ) * width + width / 2) τ))
      volume oldTime (oldTime + timeStep))
    (hTimeSmooth : ContDiffOn ℝ 2
      (fun τ => (-(diffusivity ((i : ℝ) * width - width / 2) *
        qX ((i : ℝ) * width - width / 2) τ) -
        -(diffusivity ((i : ℝ) * width + width / 2) *
          qX ((i : ℝ) * width + width / 2) τ)) / width)
      [[oldTime, oldTime + timeStep]])
    (hCurvature : ∀ τ,
      |iteratedDerivWithin 2
        (fun σ => (-(diffusivity ((i : ℝ) * width - width / 2) *
          qX ((i : ℝ) * width - width / 2) σ) -
          -(diffusivity ((i : ℝ) * width + width / 2) *
            qX ((i : ℝ) * width + width / 2) σ)) / width)
        [[oldTime, oldTime + timeStep]] τ| ≤ curvatureBound) :
    let coefficient : ℤ → ℝ := fun j =>
      diffusivity ((j : ℝ) * width - width / 2)
    let before : ℤ → ℝ := fun j => oneDimensionalCellAverage
      (fun x => q x oldTime)
      ((j : ℝ) * width - width / 2) ((j : ℝ) * width + width / 2)
    let after : ℤ → ℝ := fun j => oneDimensionalCellAverage
      (fun x => q x (oldTime + timeStep))
      ((j : ℝ) * width - width / 2) ((j : ℝ) * width + width / 2)
    |(after i - conservativeFluxDifferenceUpdateInt (timeStep / width) before
      (leveque04_crankNicolsonInterfaceFlux coefficient width before after) i) /
      timeStep| ≤
      curvatureBound * timeStep ^ 2 / 12 +
        (D * K3 / 2 + L * K2 / 2) * width ^ 2 := by
  intro coefficient before after
  have hface : (i : ℝ) * width - width / 2 + width =
      (i : ℝ) * width + width / 2 := by ring
  have hlocal := leveque04_crankNicolson_smoothExactCellResidual_bound
    q qTime qX qXX qXXX fluxDerivative diffusivity
    K2 K3 D L ((i : ℝ) * width - width / 2) width oldTime timeStep
    curvatureBound hK2 hK3 hwidth htime hq hqX hqXX hLip2 hLip3
    hDbound hDLip hFluxDerivative hPDE
    (by simpa only [hface] using hfxInt)
    (by simpa only [hface] using hInterchange)
    hleftInt (by simpa only [hface] using hrightInt)
    (by simpa only [hface] using hTimeSmooth)
    (by simpa only [hface] using hCurvature)
  have hindexed := leveque04_crankNicolson_exactAverage_indexedResidual_bound
    (fun x => q x oldTime) (fun x => q x (oldTime + timeStep))
    diffusivity width timeStep
    (curvatureBound * timeStep ^ 2 / 12 +
      (D * K3 / 2 + L * K2 / 2) * width ^ 2) i
  exact hindexed (by simpa only [hface] using hlocal)

/-- A quadratic interface-coefficient approximation preserves the quadratic
spatial face-flux estimate when the exact-average slope is bounded. -/
theorem leveque04_diffusion_approxCoefficient_faceFlux_error_le
    (f f' f'' diffusivity : ℝ → ℝ) (coefficient : ℤ → ℝ)
    (K D E M width : ℝ) (i : ℤ)
    (hK : 0 ≤ K) (hE : 0 ≤ E) (hwidth : 0 < width)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hf' : ∀ x, HasDerivAt f' (f'' x) x)
    (hLip : ∀ x y, |f'' x - f'' y| ≤ K * |x - y|)
    (hD : |diffusivity ((i : ℝ) * width - width / 2)| ≤ D)
    (hcoeff : |coefficient i - diffusivity ((i : ℝ) * width - width / 2)| ≤
      E * width ^ 2)
    (hslope : |(oneDimensionalCellAverage f
        ((i : ℝ) * width - width / 2) ((i : ℝ) * width + width / 2) -
        oneDimensionalCellAverage f
          (((i - 1 : ℤ) : ℝ) * width - width / 2)
          (((i - 1 : ℤ) : ℝ) * width + width / 2)) / width| ≤ M) :
    let averages : ℤ → ℝ := fun j => oneDimensionalCellAverage f
      ((j : ℝ) * width - width / 2) ((j : ℝ) * width + width / 2)
    |leveque04_diffusionInterfaceFlux coefficient averages width i -
      (-(diffusivity ((i : ℝ) * width - width / 2) *
        f' ((i : ℝ) * width - width / 2)))| ≤
      (E * M + D * K / 2) * width ^ 2 := by
  intro averages
  let face := (i : ℝ) * width - width / 2
  let exactCoefficient : ℤ → ℝ := fun j =>
    diffusivity ((j : ℝ) * width - width / 2)
  let slope := (averages i - averages (i - 1)) / width
  have hbase := leveque04_diffusion_smoothFaceFlux_error_le
    f f' f'' diffusivity K width i hK hwidth hf hf' hLip
  have hbase' : |leveque04_diffusionInterfaceFlux exactCoefficient averages width i -
      (-(diffusivity face * f' face))| ≤ D * K / 2 * width ^ 2 := by
    calc
      _ ≤ |diffusivity face| * (K * width ^ 2 / 2) := by
        simpa only [averages, face, exactCoefficient] using hbase
      _ ≤ D * (K * width ^ 2 / 2) :=
        mul_le_mul_of_nonneg_right hD (by positivity)
      _ = _ := by ring
  have hslope' : |slope| ≤ M := by
    simpa only [slope, averages] using hslope
  have hcoefficient :
      |leveque04_diffusionInterfaceFlux coefficient averages width i -
        leveque04_diffusionInterfaceFlux exactCoefficient averages width i| ≤
      E * M * width ^ 2 := by
    have hid : leveque04_diffusionInterfaceFlux coefficient averages width i -
        leveque04_diffusionInterfaceFlux exactCoefficient averages width i =
        -((coefficient i - diffusivity face) * slope) := by
      simp only [leveque04_diffusionInterfaceFlux, Leveque02Tracer.fickFlux]
      dsimp [exactCoefficient, slope, face]
      ring
    rw [hid, abs_neg, abs_mul]
    calc
      _ ≤ (E * width ^ 2) * |slope| :=
        mul_le_mul_of_nonneg_right hcoeff (abs_nonneg _)
      _ ≤ (E * width ^ 2) * M :=
        mul_le_mul_of_nonneg_left hslope' (by positivity)
      _ = _ := by ring
  have hsplit : leveque04_diffusionInterfaceFlux coefficient averages width i -
      (-(diffusivity face * f' face)) =
      (leveque04_diffusionInterfaceFlux coefficient averages width i -
        leveque04_diffusionInterfaceFlux exactCoefficient averages width i) +
      (leveque04_diffusionInterfaceFlux exactCoefficient averages width i -
        (-(diffusivity face * f' face))) := by ring
  rw [show ((i : ℝ) * width - width / 2) = face from rfl, hsplit]
  calc
    _ ≤ |leveque04_diffusionInterfaceFlux coefficient averages width i -
          leveque04_diffusionInterfaceFlux exactCoefficient averages width i| +
        |leveque04_diffusionInterfaceFlux exactCoefficient averages width i -
          (-(diffusivity face * f' face))| := abs_add_le _ _
    _ ≤ E * M * width ^ 2 + D * K / 2 * width ^ 2 := add_le_add hcoefficient hbase'
    _ = _ := by ring

/-- An explicitly second-order interface-coefficient approximation gives a
second-order centered approximation to the time-averaged physical face flux. -/
theorem leveque04_crankNicolson_approxCoefficient_timeAveragedFaceFlux_error_le
    (q qX qXX : ℝ → ℝ → ℝ) (diffusivity : ℝ → ℝ)
    (coefficient : ℤ → ℝ)
    (K D E M width oldTime timeStep curvatureBound : ℝ) (i : ℤ)
    (hK : 0 ≤ K) (hE : 0 ≤ E) (hwidth : 0 < width)
    (htime : 0 < timeStep)
    (hq : ∀ τ x, HasDerivAt (fun ξ => q ξ τ) (qX x τ) x)
    (hqX : ∀ τ x, HasDerivAt (fun ξ => qX ξ τ) (qXX x τ) x)
    (hLip : ∀ τ x y, |qXX x τ - qXX y τ| ≤ K * |x - y|)
    (hD : |diffusivity ((i : ℝ) * width - width / 2)| ≤ D)
    (hcoeff : |coefficient i - diffusivity ((i : ℝ) * width - width / 2)| ≤
      E * width ^ 2)
    (hslope : ∀ τ,
      |(oneDimensionalCellAverage (fun x => q x τ)
          ((i : ℝ) * width - width / 2) ((i : ℝ) * width + width / 2) -
          oneDimensionalCellAverage (fun x => q x τ)
            (((i - 1 : ℤ) : ℝ) * width - width / 2)
            (((i - 1 : ℤ) : ℝ) * width + width / 2)) / width| ≤ M)
    (hsmooth : ContDiffOn ℝ 2
      (fun τ => -(diffusivity ((i : ℝ) * width - width / 2) *
        qX ((i : ℝ) * width - width / 2) τ))
      [[oldTime, oldTime + timeStep]])
    (hcurvature : ∀ τ,
      |iteratedDerivWithin 2
        (fun σ => -(diffusivity ((i : ℝ) * width - width / 2) *
          qX ((i : ℝ) * width - width / 2) σ))
        [[oldTime, oldTime + timeStep]] τ| ≤ curvatureBound) :
    let face := (i : ℝ) * width - width / 2
    let averages : ℝ → ℤ → ℝ := fun τ j => oneDimensionalCellAverage
      (fun x => q x τ) ((j : ℝ) * width - width / 2)
        ((j : ℝ) * width + width / 2)
    let numericalFlux : ℝ → ℝ := fun τ =>
      leveque04_diffusionInterfaceFlux coefficient (averages τ) width i
    let physicalFlux : ℝ → ℝ := fun τ => -(diffusivity face * qX face τ)
    |(timeStep / 2 * (numericalFlux oldTime + numericalFlux (oldTime + timeStep)) -
      ∫ τ in oldTime..oldTime + timeStep, physicalFlux τ) / timeStep| ≤
      curvatureBound * timeStep ^ 2 / 12 +
        (E * M + D * K / 2) * width ^ 2 := by
  intro face averages numericalFlux physicalFlux
  have hface (τ : ℝ) :
      |numericalFlux τ - physicalFlux τ| ≤
        (E * M + D * K / 2) * width ^ 2 := by
    have h := leveque04_diffusion_approxCoefficient_faceFlux_error_le
      (fun x => q x τ) (fun x => qX x τ) (fun x => qXX x τ)
      diffusivity coefficient K D E M width i hK hE hwidth
      (hq τ) (hqX τ) (hLip τ) hD hcoeff (hslope τ)
    simpa only [face, averages, numericalFlux, physicalFlux] using h
  have hbase := leveque04_crankNicolson_spaceTimeResidual_bound
    physicalFlux oldTime timeStep width 0
    (∫ τ in oldTime..oldTime + timeStep, physicalFlux τ)
    (numericalFlux oldTime) (numericalFlux (oldTime + timeStep))
    (E * M + D * K / 2) curvatureBound htime
    (by simpa [physicalFlux, face] using hsmooth)
    (by simpa [physicalFlux, face] using hcurvature)
    (by ring) (hface oldTime) (hface (oldTime + timeStep))
  have hid :
      (timeStep / 2 * (numericalFlux oldTime + numericalFlux (oldTime + timeStep)) -
        ∫ τ in oldTime..oldTime + timeStep, physicalFlux τ) / timeStep =
      -((∫ τ in oldTime..oldTime + timeStep, physicalFlux τ) - 0 -
        timeStep / 2 * (numericalFlux oldTime + numericalFlux (oldTime + timeStep))) /
          timeStep := by ring
  rw [hid, neg_div, abs_neg]
  exact hbase

/-- Adjacent coefficient errors need one extra power of the mesh width in
their difference to preserve a quadratic flux-divergence estimate. -/
theorem leveque04_coefficientSlopeDivergence_error_le
    (errorLeft errorRight slopeLeft slopeRight E Ederiv M S width : ℝ)
    (hwidth : 0 < width) (hE : 0 ≤ E) (hEderiv : 0 ≤ Ederiv)
    (herror : |errorLeft| ≤ E * width ^ 2)
    (herrorDiff : |errorRight - errorLeft| ≤ Ederiv * width ^ 3)
    (hslope : |slopeRight| ≤ M)
    (hslopeDiff : |slopeRight - slopeLeft| ≤ S * width) :
    |(errorRight * slopeRight - errorLeft * slopeLeft) / width| ≤
      (Ederiv * M + E * S) * width ^ 2 := by
  have hfirst : |(errorRight - errorLeft) * slopeRight| ≤
      Ederiv * M * width ^ 3 := by
    rw [abs_mul]
    calc
      _ ≤ (Ederiv * width ^ 3) * |slopeRight| :=
        mul_le_mul_of_nonneg_right herrorDiff (abs_nonneg _)
      _ ≤ (Ederiv * width ^ 3) * M :=
        mul_le_mul_of_nonneg_left hslope (by positivity)
      _ = _ := by ring
  have hsecond : |errorLeft * (slopeRight - slopeLeft)| ≤
      E * S * width ^ 3 := by
    rw [abs_mul]
    calc
      _ ≤ (E * width ^ 2) * |slopeRight - slopeLeft| :=
        mul_le_mul_of_nonneg_right herror (abs_nonneg _)
      _ ≤ (E * width ^ 2) * (S * width) :=
        mul_le_mul_of_nonneg_left hslopeDiff (by positivity)
      _ = _ := by ring
  have hidentity : errorRight * slopeRight - errorLeft * slopeLeft =
      (errorRight - errorLeft) * slopeRight +
        errorLeft * (slopeRight - slopeLeft) := by ring
  rw [abs_div, abs_of_pos hwidth]
  apply (div_le_iff₀ hwidth).2
  calc
    |errorRight * slopeRight - errorLeft * slopeLeft| ≤
        |(errorRight - errorLeft) * slopeRight| +
          |errorLeft * (slopeRight - slopeLeft)| := by
            rw [hidentity]
            exact abs_add_le _ _
    _ ≤ Ederiv * M * width ^ 3 + E * S * width ^ 3 :=
      add_le_add hfirst hsecond
    _ = (Ederiv * M + E * S) * width ^ 2 * width := by ring

/-- The regular adjacent-coefficient error budget transfers to the actual
two-face finite-volume diffusion flux divergence. -/
theorem leveque04_diffusion_approxCoefficient_divergence_error_le
    (coefficient exactCoefficient : ℤ → ℝ) (u : ℤ → ℝ)
    (E Ederiv M S width : ℝ) (i : ℤ)
    (hwidth : 0 < width) (hE : 0 ≤ E) (hEderiv : 0 ≤ Ederiv)
    (herror : |coefficient i - exactCoefficient i| ≤ E * width ^ 2)
    (herrorDiff : |(coefficient (i + 1) - exactCoefficient (i + 1)) -
      (coefficient i - exactCoefficient i)| ≤ Ederiv * width ^ 3)
    (hslope : |(u (i + 1) - u i) / width| ≤ M)
    (hslopeDiff : |(u (i + 1) - u i) / width -
      (u i - u (i - 1)) / width| ≤ S * width) :
    |(((leveque04_diffusionInterfaceFlux coefficient u width (i + 1) -
        leveque04_diffusionInterfaceFlux coefficient u width i) -
       (leveque04_diffusionInterfaceFlux exactCoefficient u width (i + 1) -
        leveque04_diffusionInterfaceFlux exactCoefficient u width i)) / width)| ≤
      (Ederiv * M + E * S) * width ^ 2 := by
  have h := leveque04_coefficientSlopeDivergence_error_le
    (coefficient i - exactCoefficient i)
    (coefficient (i + 1) - exactCoefficient (i + 1))
    ((u i - u (i - 1)) / width)
    ((u (i + 1) - u i) / width)
    E Ederiv M S width hwidth hE hEderiv herror herrorDiff hslope hslopeDiff
  have hid :
      ((leveque04_diffusionInterfaceFlux coefficient u width (i + 1) -
          leveque04_diffusionInterfaceFlux coefficient u width i) -
        (leveque04_diffusionInterfaceFlux exactCoefficient u width (i + 1) -
          leveque04_diffusionInterfaceFlux exactCoefficient u width i)) / width =
      -(((coefficient (i + 1) - exactCoefficient (i + 1)) *
          ((u (i + 1) - u i) / width) -
        (coefficient i - exactCoefficient i) *
          ((u i - u (i - 1)) / width)) / width) := by
    simp [leveque04_diffusionInterfaceFlux, Leveque02Tracer.fickFlux]
    ring
  rw [hid, abs_neg]
  exact h

/-- A uniform error bound on the two old/new coefficient-induced flux
divergences transfers the indexed Crank-Nicolson residual bound. -/
theorem leveque04_crankNicolson_coefficientResidual_transfer
    (coefficient exactCoefficient before after : ℤ → ℝ)
    (timeStep width baseBound coefficientBound : ℝ) (i : ℤ)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hbase : |(after i - conservativeFluxDifferenceUpdateInt
      (timeStep / width) before
      (leveque04_crankNicolsonInterfaceFlux exactCoefficient width before after) i) /
      timeStep| ≤ baseBound)
    (hbefore : |(((leveque04_diffusionInterfaceFlux coefficient before width (i + 1) -
        leveque04_diffusionInterfaceFlux coefficient before width i) -
       (leveque04_diffusionInterfaceFlux exactCoefficient before width (i + 1) -
        leveque04_diffusionInterfaceFlux exactCoefficient before width i)) / width)| ≤
      coefficientBound)
    (hafter : |(((leveque04_diffusionInterfaceFlux coefficient after width (i + 1) -
        leveque04_diffusionInterfaceFlux coefficient after width i) -
       (leveque04_diffusionInterfaceFlux exactCoefficient after width (i + 1) -
        leveque04_diffusionInterfaceFlux exactCoefficient after width i)) / width)| ≤
      coefficientBound) :
    |(after i - conservativeFluxDifferenceUpdateInt
      (timeStep / width) before
      (leveque04_crankNicolsonInterfaceFlux coefficient width before after) i) /
      timeStep| ≤ baseBound + coefficientBound := by
  let oldDifference :=
    ((leveque04_diffusionInterfaceFlux coefficient before width (i + 1) -
      leveque04_diffusionInterfaceFlux coefficient before width i) -
     (leveque04_diffusionInterfaceFlux exactCoefficient before width (i + 1) -
      leveque04_diffusionInterfaceFlux exactCoefficient before width i)) / width
  let newDifference :=
    ((leveque04_diffusionInterfaceFlux coefficient after width (i + 1) -
      leveque04_diffusionInterfaceFlux coefficient after width i) -
     (leveque04_diffusionInterfaceFlux exactCoefficient after width (i + 1) -
      leveque04_diffusionInterfaceFlux exactCoefficient after width i)) / width
  have hid :
      (after i - conservativeFluxDifferenceUpdateInt (timeStep / width) before
        (leveque04_crankNicolsonInterfaceFlux coefficient width before after) i) /
          timeStep =
      (after i - conservativeFluxDifferenceUpdateInt (timeStep / width) before
        (leveque04_crankNicolsonInterfaceFlux exactCoefficient width before after) i) /
          timeStep + (oldDifference + newDifference) / 2 := by
    rw [leveque04_crankNicolson_indexedResidual_eq_fluxResidual,
      leveque04_crankNicolson_indexedResidual_eq_fluxResidual]
    dsimp [oldDifference, newDifference]
    field_simp
    ring
  have hdiff : |(oldDifference + newDifference) / 2| ≤ coefficientBound := by
    have hold : |oldDifference| ≤ coefficientBound := hbefore
    have hnew : |newDifference| ≤ coefficientBound := hafter
    rw [abs_div, abs_of_pos (by norm_num : (0 : ℝ) < 2)]
    nlinarith [abs_add_le oldDifference newDifference]
  rw [hid]
  exact (abs_add_le _ _).trans (add_le_add hbase hdiff)

/-- The explicit adjacent-face coefficient regularity budget preserves the
quadratic indexed Crank-Nicolson residual at both time levels. -/
theorem leveque04_crankNicolson_approxCoefficient_indexedResidual_bound
    (coefficient exactCoefficient before after : ℤ → ℝ)
    (timeStep width baseBound E Ederiv M S : ℝ) (i : ℤ)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hE : 0 ≤ E) (hEderiv : 0 ≤ Ederiv)
    (hbase : |(after i - conservativeFluxDifferenceUpdateInt
      (timeStep / width) before
      (leveque04_crankNicolsonInterfaceFlux exactCoefficient width before after) i) /
      timeStep| ≤ baseBound)
    (herror : |coefficient i - exactCoefficient i| ≤ E * width ^ 2)
    (herrorDiff : |(coefficient (i + 1) - exactCoefficient (i + 1)) -
      (coefficient i - exactCoefficient i)| ≤ Ederiv * width ^ 3)
    (hbeforeSlope : |(before (i + 1) - before i) / width| ≤ M)
    (hbeforeSlopeDiff : |(before (i + 1) - before i) / width -
      (before i - before (i - 1)) / width| ≤ S * width)
    (hafterSlope : |(after (i + 1) - after i) / width| ≤ M)
    (hafterSlopeDiff : |(after (i + 1) - after i) / width -
      (after i - after (i - 1)) / width| ≤ S * width) :
    |(after i - conservativeFluxDifferenceUpdateInt
      (timeStep / width) before
      (leveque04_crankNicolsonInterfaceFlux coefficient width before after) i) /
      timeStep| ≤ baseBound + (Ederiv * M + E * S) * width ^ 2 := by
  apply leveque04_crankNicolson_coefficientResidual_transfer
    coefficient exactCoefficient before after timeStep width baseBound
    ((Ederiv * M + E * S) * width ^ 2) i htime hwidth hbase
  · exact leveque04_diffusion_approxCoefficient_divergence_error_le
      coefficient exactCoefficient before E Ederiv M S width i
      hwidth hE hEderiv herror herrorDiff hbeforeSlope hbeforeSlopeDiff
  · exact leveque04_diffusion_approxCoefficient_divergence_error_le
      coefficient exactCoefficient after E Ederiv M S width i
      hwidth hE hEderiv herror herrorDiff hafterSlope hafterSlopeDiff

/-- The smooth exact-cell residual and regular approximate-coefficient
budget combine for the integer-indexed equation-(4.13) update. -/
theorem leveque04_crankNicolson_smoothApproxCoefficient_indexedResidual_bound
    (q qTime qX qXX qXXX fluxDerivative : ℝ → ℝ → ℝ)
    (diffusivity : ℝ → ℝ)
    (coefficient before after : ℤ → ℝ)
    (K2 K3 D L width oldTime timeStep curvatureBound E Ederiv M S : ℝ) (i : ℤ)
    (hK2 : 0 ≤ K2) (hK3 : 0 ≤ K3)
    (hwidth : 0 < width) (htime : 0 < timeStep)
    (hE : 0 ≤ E) (hEderiv : 0 ≤ Ederiv)
    (hbefore : before = fun (j : ℤ) => oneDimensionalCellAverage
      (fun x => q x oldTime)
      ((j : ℝ) * width - width / 2) ((j : ℝ) * width + width / 2))
    (hafter : after = fun (j : ℤ) => oneDimensionalCellAverage
      (fun x => q x (oldTime + timeStep))
      ((j : ℝ) * width - width / 2) ((j : ℝ) * width + width / 2))
    (hq : ∀ τ x, HasDerivAt (fun ξ => q ξ τ) (qX x τ) x)
    (hqX : ∀ τ x, HasDerivAt (fun ξ => qX ξ τ) (qXX x τ) x)
    (hqXX : ∀ τ x, HasDerivAt (fun ξ => qXX ξ τ) (qXXX x τ) x)
    (hLip2 : ∀ τ x y, |qXX x τ - qXX y τ| ≤ K2 * |x - y|)
    (hLip3 : ∀ τ x y, |qXXX x τ - qXXX y τ| ≤ K3 * |x - y|)
    (hDbound : ∀ x, |diffusivity x| ≤ D)
    (hDLip : ∀ x y, |diffusivity x - diffusivity y| ≤ L * |x - y|)
    (hFluxDerivative : ∀ τ x,
      HasDerivAt (fun ξ => -(diffusivity ξ * qX ξ τ))
        (fluxDerivative x τ) x)
    (hPDE : ∀ τ x, qTime x τ + fluxDerivative x τ = 0)
    (hfxInt : ∀ τ,
      IntervalIntegrable (fun x => fluxDerivative x τ) volume
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2))
    (hInterchange : ∀ τ,
      HasDerivAt (fun σ => ∫ x in ((i : ℝ) * width - width / 2)..
        ((i : ℝ) * width + width / 2), q x σ)
        (∫ x in ((i : ℝ) * width - width / 2)..
          ((i : ℝ) * width + width / 2), qTime x τ) τ)
    (hleftInt : IntervalIntegrable
      (fun τ => -(diffusivity ((i : ℝ) * width - width / 2) *
        qX ((i : ℝ) * width - width / 2) τ))
      volume oldTime (oldTime + timeStep))
    (hrightInt : IntervalIntegrable
      (fun τ => -(diffusivity ((i : ℝ) * width + width / 2) *
        qX ((i : ℝ) * width + width / 2) τ))
      volume oldTime (oldTime + timeStep))
    (hTimeSmooth : ContDiffOn ℝ 2
      (fun τ => (-(diffusivity ((i : ℝ) * width - width / 2) *
        qX ((i : ℝ) * width - width / 2) τ) -
        -(diffusivity ((i : ℝ) * width + width / 2) *
          qX ((i : ℝ) * width + width / 2) τ)) / width)
      [[oldTime, oldTime + timeStep]])
    (hCurvature : ∀ τ,
      |iteratedDerivWithin 2
        (fun σ => (-(diffusivity ((i : ℝ) * width - width / 2) *
          qX ((i : ℝ) * width - width / 2) σ) -
          -(diffusivity ((i : ℝ) * width + width / 2) *
            qX ((i : ℝ) * width + width / 2) σ)) / width)
        [[oldTime, oldTime + timeStep]] τ| ≤ curvatureBound)
    (herror : |coefficient i -
      diffusivity ((i : ℝ) * width - width / 2)| ≤ E * width ^ 2)
    (herrorDiff : |(coefficient (i + 1) -
      diffusivity (((i + 1 : ℤ) : ℝ) * width - width / 2)) -
      (coefficient i - diffusivity ((i : ℝ) * width - width / 2))| ≤
        Ederiv * width ^ 3)
    (hbeforeSlope : |(before (i + 1) - before i) / width| ≤ M)
    (hbeforeSlopeDiff : |(before (i + 1) - before i) / width -
      (before i - before (i - 1)) / width| ≤ S * width)
    (hafterSlope : |(after (i + 1) - after i) / width| ≤ M)
    (hafterSlopeDiff : |(after (i + 1) - after i) / width -
      (after i - after (i - 1)) / width| ≤ S * width) :
    |(after i - conservativeFluxDifferenceUpdateInt (timeStep / width) before
      (leveque04_crankNicolsonInterfaceFlux coefficient width before after) i) /
      timeStep| ≤
      curvatureBound * timeStep ^ 2 / 12 +
        (D * K3 / 2 + L * K2 / 2 + Ederiv * M + E * S) * width ^ 2 := by
  let exactCoefficient : ℤ → ℝ := fun j =>
    diffusivity ((j : ℝ) * width - width / 2)
  have hbase := leveque04_crankNicolson_indexedSmoothResidual_bound
    q qTime qX qXX qXXX fluxDerivative diffusivity
    K2 K3 D L width oldTime timeStep curvatureBound i
    hK2 hK3 hwidth htime hq hqX hqXX hLip2 hLip3 hDbound hDLip
    hFluxDerivative hPDE hfxInt hInterchange hleftInt hrightInt
    hTimeSmooth hCurvature
  have hbase' : |(after i - conservativeFluxDifferenceUpdateInt
      (timeStep / width) before
      (leveque04_crankNicolsonInterfaceFlux exactCoefficient width before after) i) /
      timeStep| ≤
      curvatureBound * timeStep ^ 2 / 12 +
        (D * K3 / 2 + L * K2 / 2) * width ^ 2 := by
    simpa only [exactCoefficient, hbefore, hafter] using hbase
  have h := leveque04_crankNicolson_approxCoefficient_indexedResidual_bound
    coefficient exactCoefficient before after timeStep width
    (curvatureBound * timeStep ^ 2 / 12 +
      (D * K3 / 2 + L * K2 / 2) * width ^ 2)
    E Ederiv M S i htime hwidth hE hEderiv hbase'
    herror herrorDiff hbeforeSlope hbeforeSlopeDiff hafterSlope hafterSlopeDiff
  convert h using 1 <;> ring

/-- The centered cell average of the affine profile `q(x)=x` is its center. -/
theorem leveque04_affineCenteredCellAverage
    (width : ℝ) (j : ℤ) (hwidth : 0 < width) :
    oneDimensionalCellAverage (fun x : ℝ => x)
      ((j : ℝ) * width - width / 2)
      ((j : ℝ) * width + width / 2) = (j : ℝ) * width := by
  have hw : width ≠ 0 := ne_of_gt hwidth
  norm_num [oneDimensionalCellAverage, integral_id, smul_eq_mul]
  field_simp
  ring

/-- A face coefficient with first-order error produces first-order flux
    error even for the stationary affine diffusion profile `q(x,t)=x`.
    The old and new grid values are its exact centered cell averages. -/
theorem leveque04_crankNicolson_firstOrderCoefficient_affineFluxError
    (width : ℝ) (hwidth : 0 < width) :
    |leveque04_crankNicolsonInterfaceFlux (fun _ => 1 + width) width
        (fun j => (j : ℝ) * width) (fun j => (j : ℝ) * width) 0 -
      Leveque02Tracer.fickFlux 1 1| = width := by
  have hflux :
      leveque04_crankNicolsonInterfaceFlux (fun _ => 1 + width) width
          (fun j => (j : ℝ) * width) (fun j => (j : ℝ) * width) 0 =
        -(1 + width) := by
    simp [leveque04_crankNicolsonInterfaceFlux,
      leveque04_diffusionInterfaceFlux, Leveque02Tracer.fickFlux]
    field_simp
    ring
  rw [hflux]
  simp [Leveque02Tracer.fickFlux, abs_of_pos hwidth]

/-- A merely first-order-consistent face coefficient admits no uniform
    second-order flux constant, even on arbitrarily fine affine cells. -/
theorem leveque04_crankNicolson_firstOrderCoefficient_notQuadratic
    (C epsilon : ℝ) (hC : 0 ≤ C) (hepsilon : 0 < epsilon) :
    ∃ width : ℝ, 0 < width ∧ width < epsilon ∧
      C * width ^ 2 <
        |leveque04_crankNicolsonInterfaceFlux (fun _ => 1 + width) width
            (fun j => (j : ℝ) * width) (fun j => (j : ℝ) * width) 0 -
          Leveque02Tracer.fickFlux 1 1| := by
  let width := min (epsilon / 2) (1 / (2 * (C + 1)))
  have hden : 0 < 2 * (C + 1) := by linarith
  have hwidth : 0 < width :=
    lt_min (by linarith) (div_pos (by norm_num) hden)
  have hsmall : width ≤ epsilon / 2 := min_le_left _ _
  have hcap : width ≤ 1 / (2 * (C + 1)) := min_le_right _ _
  have hratio : (C + 1) * width ≤ 1 / 2 := by
    have h := mul_le_mul_of_nonneg_left hcap (by linarith : 0 ≤ C + 1)
    have hid : (C + 1) * (1 / (2 * (C + 1))) = 1 / 2 := by
      field_simp
    simpa only [hid] using h
  have hCwidth : C * width < 1 := by nlinarith
  refine ⟨width, hwidth, by linarith, ?_⟩
  rw [leveque04_crankNicolson_firstOrderCoefficient_affineFluxError width hwidth]
  calc
    C * width ^ 2 = (C * width) * width := by ring
    _ < 1 * width := mul_lt_mul_of_pos_right hCwidth hwidth
    _ = width := one_mul _

/-- Integrate a diffusion cell balance using only forward-time PDE data. -/
theorem leveque04_diffusion_integratedCellAverageBalance_forward
    (q qTime flux fluxDerivative : ℝ → ℝ → ℝ)
    (a b oldTime timeStep width : ℝ)
    (hwidth : b - a = width) (htime : 0 ≤ timeStep)
    (hflux : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x,
      HasDerivAt (fun ξ => flux ξ τ) (fluxDerivative x τ) x)
    (hpde : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x,
      qTime x τ + fluxDerivative x τ = 0)
    (hfx : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep),
      IntervalIntegrable (fun x => fluxDerivative x τ) volume a b)
    (hinterchange : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep),
      HasDerivAt (fun σ => ∫ x in a..b, q x σ)
        (∫ x in a..b, qTime x τ) τ)
    (hleft : IntervalIntegrable (fun τ => flux a τ) volume oldTime (oldTime + timeStep))
    (hright : IntervalIntegrable (fun τ => flux b τ) volume oldTime (oldTime + timeStep)) :
    oneDimensionalCellAverage (fun x => q x (oldTime + timeStep)) a b -
      oneDimensionalCellAverage (fun x => q x oldTime) a b =
      ∫ τ in oldTime..oldTime + timeStep,
        (flux a τ - flux b τ) / width := by
  have hderiv (τ : ℝ) (hτ : τ ∈ Set.Icc oldTime (oldTime + timeStep)) :
      HasDerivAt (fun σ => ∫ x in a..b, q x σ)
        (flux a τ - flux b τ) τ := by
    have hspatial := leveque04_diffusion_spatialCellBalance
      (fun x => qTime x τ) (fun x => flux x τ)
      (fun x => fluxDerivative x τ) a b
      (hflux τ hτ) (hpde τ hτ) (hfx τ hτ)
    have hs := hinterchange τ hτ
    rw [hspatial] at hs
    exact hs
  have hint : IntervalIntegrable (fun τ => flux a τ - flux b τ)
      volume oldTime (oldTime + timeStep) := hleft.sub hright
  have htimeFTC := intervalIntegral.integral_eq_sub_of_hasDerivAt
    (fun τ hτ => hderiv τ (by
      simpa only [Set.uIcc_of_le (by linarith : oldTime ≤ oldTime + timeStep)]
        using hτ)) hint
  calc
    _ = ((∫ x in a..b, q x (oldTime + timeStep)) -
        (∫ x in a..b, q x oldTime)) / width := by
          simp only [oneDimensionalCellAverage, hwidth, smul_eq_mul]
          ring
    _ = (∫ τ in oldTime..oldTime + timeStep,
        (flux a τ - flux b τ)) / width := by rw [htimeFTC]
    _ = ∫ τ in oldTime..oldTime + timeStep,
        (flux a τ - flux b τ) / width := by
          rw [intervalIntegral.integral_div]

/-- A smooth exact-average CN residual using regularity and the PDE only
on the current forward time interval. -/
theorem leveque04_crankNicolson_smoothExactCellResidual_forward_bound
    (q qTime qX qXX qXXX fluxDerivative : ℝ → ℝ → ℝ)
    (diffusivity : ℝ → ℝ)
    (K2 K3 D L face width oldTime timeStep curvatureBound : ℝ)
    (hK2 : 0 ≤ K2) (hK3 : 0 ≤ K3)
    (hwidth : 0 < width) (htime : 0 < timeStep)
    (hq : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x, HasDerivAt (fun ξ => q ξ τ) (qX x τ) x)
    (hqX : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x, HasDerivAt (fun ξ => qX ξ τ) (qXX x τ) x)
    (hqXX : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x, HasDerivAt (fun ξ => qXX ξ τ) (qXXX x τ) x)
    (hLip2 : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x y, |qXX x τ - qXX y τ| ≤ K2 * |x - y|)
    (hLip3 : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x y, |qXXX x τ - qXXX y τ| ≤ K3 * |x - y|)
    (hDbound : ∀ x, |diffusivity x| ≤ D)
    (hDLip : ∀ x y, |diffusivity x - diffusivity y| ≤ L * |x - y|)
    (hFluxDerivative : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x,
      HasDerivAt (fun ξ => -(diffusivity ξ * qX ξ τ))
        (fluxDerivative x τ) x)
    (hPDE : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x, qTime x τ + fluxDerivative x τ = 0)
    (hfxInt : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep),
      IntervalIntegrable (fun x => fluxDerivative x τ) volume face (face + width))
    (hInterchange : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep),
      HasDerivAt (fun σ => ∫ x in face..face + width, q x σ)
        (∫ x in face..face + width, qTime x τ) τ)
    (hleftInt : IntervalIntegrable
      (fun τ => -(diffusivity face * qX face τ)) volume oldTime (oldTime + timeStep))
    (hrightInt : IntervalIntegrable
      (fun τ => -(diffusivity (face + width) * qX (face + width) τ))
      volume oldTime (oldTime + timeStep))
    (hTimeSmooth : ContDiffOn ℝ 2
      (fun τ => (-(diffusivity face * qX face τ) -
        -(diffusivity (face + width) * qX (face + width) τ)) / width)
      [[oldTime, oldTime + timeStep]])
    (hCurvature : ∀ τ,
      |iteratedDerivWithin 2
        (fun σ => (-(diffusivity face * qX face σ) -
          -(diffusivity (face + width) * qX (face + width) σ)) / width)
        [[oldTime, oldTime + timeStep]] τ| ≤ curvatureBound) :
    let numericalFlux : ℝ → ℝ → ℝ := fun c τ =>
      -(diffusivity c *
        ((oneDimensionalCellAverage (fun x => q x τ) c (c + width) -
          oneDimensionalCellAverage (fun x => q x τ) (c - width) c) / width))
    let netNumericalFlux : ℝ → ℝ := fun τ =>
      (numericalFlux face τ - numericalFlux (face + width) τ) / width
    |(oneDimensionalCellAverage (fun x => q x (oldTime + timeStep))
          face (face + width) -
        oneDimensionalCellAverage (fun x => q x oldTime) face (face + width) -
        timeStep / 2 *
          (netNumericalFlux oldTime + netNumericalFlux (oldTime + timeStep))) /
      timeStep| ≤
      curvatureBound * timeStep ^ 2 / 12 +
        (D * K3 / 2 + L * K2 / 2) * width ^ 2 := by
  intro numericalFlux netNumericalFlux
  let exactFlux : ℝ → ℝ := fun τ =>
    (-(diffusivity face * qX face τ) -
      -(diffusivity (face + width) * qX (face + width) τ)) / width
  have hBalance :
      oneDimensionalCellAverage (fun x => q x (oldTime + timeStep)) face (face + width) -
        oneDimensionalCellAverage (fun x => q x oldTime) face (face + width) =
        ∫ τ in oldTime..oldTime + timeStep, exactFlux τ := by
    exact leveque04_diffusion_integratedCellAverageBalance_forward
      q qTime (fun x τ => -(diffusivity x * qX x τ)) fluxDerivative
      face (face + width) oldTime timeStep width (by ring) htime.le
      hFluxDerivative hPDE hfxInt hInterchange hleftInt hrightInt
  have hSpace (τ : ℝ) (hτ : τ ∈ Set.Icc oldTime (oldTime + timeStep)) :
      |netNumericalFlux τ - exactFlux τ| ≤
        (D * K3 / 2 + L * K2 / 2) * width ^ 2 := by
    let discFace : ℝ → ℝ := fun c => numericalFlux c τ
    let physFace : ℝ → ℝ := fun c => -(diffusivity c * qX c τ)
    have h := leveque04_diffusion_smoothFluxDivergence_error_le
      (fun x => q x τ) (fun x => qX x τ) (fun x => qXX x τ)
      (fun x => qXXX x τ) diffusivity K2 K3 D L face width
      hK2 hK3 hwidth (hq τ hτ) (hqX τ hτ) (hqXX τ hτ)
      (hLip2 τ hτ) (hLip3 τ hτ) hDbound hDLip
    change |(discFace (face + width) - discFace face) / width -
      (physFace (face + width) - physFace face) / width| ≤
        (D * K3 / 2 + L * K2 / 2) * width ^ 2 at h
    have heq : netNumericalFlux τ - exactFlux τ =
        -((discFace (face + width) - discFace face) / width -
          (physFace (face + width) - physFace face) / width) := by
      dsimp [netNumericalFlux, exactFlux, discFace, physFace]
      ring
    rw [heq, abs_neg]
    exact h
  exact leveque04_crankNicolson_spaceTimeResidual_bound
    exactFlux oldTime timeStep width
    (oneDimensionalCellAverage (fun x => q x oldTime) face (face + width))
    (oneDimensionalCellAverage (fun x => q x (oldTime + timeStep)) face (face + width))
    (netNumericalFlux oldTime) (netNumericalFlux (oldTime + timeStep))
    (D * K3 / 2 + L * K2 / 2) curvatureBound
    htime hTimeSmooth hCurvature hBalance
    (hSpace oldTime (by constructor <;> linarith))
    (hSpace (oldTime + timeStep) (by constructor <;> linarith))

/-- The forward-time exact-average residual transfers to the same
integer-indexed conservative CN step. -/
theorem leveque04_crankNicolson_indexedSmoothResidual_forward_bound
    (q qTime qX qXX qXXX fluxDerivative : ℝ → ℝ → ℝ)
    (diffusivity : ℝ → ℝ)
    (K2 K3 D L width oldTime timeStep curvatureBound : ℝ) (i : ℤ)
    (hK2 : 0 ≤ K2) (hK3 : 0 ≤ K3)
    (hwidth : 0 < width) (htime : 0 < timeStep)
    (hq : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x, HasDerivAt (fun ξ => q ξ τ) (qX x τ) x)
    (hqX : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x, HasDerivAt (fun ξ => qX ξ τ) (qXX x τ) x)
    (hqXX : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x, HasDerivAt (fun ξ => qXX ξ τ) (qXXX x τ) x)
    (hLip2 : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x y, |qXX x τ - qXX y τ| ≤ K2 * |x - y|)
    (hLip3 : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x y, |qXXX x τ - qXXX y τ| ≤ K3 * |x - y|)
    (hDbound : ∀ x, |diffusivity x| ≤ D)
    (hDLip : ∀ x y, |diffusivity x - diffusivity y| ≤ L * |x - y|)
    (hFluxDerivative : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x,
      HasDerivAt (fun ξ => -(diffusivity ξ * qX ξ τ))
        (fluxDerivative x τ) x)
    (hPDE : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x, qTime x τ + fluxDerivative x τ = 0)
    (hfxInt : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep),
      IntervalIntegrable (fun x => fluxDerivative x τ) volume
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2))
    (hInterchange : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep),
      HasDerivAt (fun σ => ∫ x in ((i : ℝ) * width - width / 2)..
        ((i : ℝ) * width + width / 2), q x σ)
        (∫ x in ((i : ℝ) * width - width / 2)..
          ((i : ℝ) * width + width / 2), qTime x τ) τ)
    (hleftInt : IntervalIntegrable
      (fun τ => -(diffusivity ((i : ℝ) * width - width / 2) *
        qX ((i : ℝ) * width - width / 2) τ))
      volume oldTime (oldTime + timeStep))
    (hrightInt : IntervalIntegrable
      (fun τ => -(diffusivity ((i : ℝ) * width + width / 2) *
        qX ((i : ℝ) * width + width / 2) τ))
      volume oldTime (oldTime + timeStep))
    (hTimeSmooth : ContDiffOn ℝ 2
      (fun τ => (-(diffusivity ((i : ℝ) * width - width / 2) *
        qX ((i : ℝ) * width - width / 2) τ) -
        -(diffusivity ((i : ℝ) * width + width / 2) *
          qX ((i : ℝ) * width + width / 2) τ)) / width)
      [[oldTime, oldTime + timeStep]])
    (hCurvature : ∀ τ,
      |iteratedDerivWithin 2
        (fun σ => (-(diffusivity ((i : ℝ) * width - width / 2) *
          qX ((i : ℝ) * width - width / 2) σ) -
          -(diffusivity ((i : ℝ) * width + width / 2) *
            qX ((i : ℝ) * width + width / 2) σ)) / width)
        [[oldTime, oldTime + timeStep]] τ| ≤ curvatureBound) :
    let coefficient : ℤ → ℝ := fun j =>
      diffusivity ((j : ℝ) * width - width / 2)
    let before : ℤ → ℝ := fun j => oneDimensionalCellAverage
      (fun x => q x oldTime)
      ((j : ℝ) * width - width / 2) ((j : ℝ) * width + width / 2)
    let after : ℤ → ℝ := fun j => oneDimensionalCellAverage
      (fun x => q x (oldTime + timeStep))
      ((j : ℝ) * width - width / 2) ((j : ℝ) * width + width / 2)
    |(after i - conservativeFluxDifferenceUpdateInt (timeStep / width) before
      (leveque04_crankNicolsonInterfaceFlux coefficient width before after) i) /
      timeStep| ≤
      curvatureBound * timeStep ^ 2 / 12 +
        (D * K3 / 2 + L * K2 / 2) * width ^ 2 := by
  intro coefficient before after
  have hface : (i : ℝ) * width - width / 2 + width =
      (i : ℝ) * width + width / 2 := by ring
  have hlocal := leveque04_crankNicolson_smoothExactCellResidual_forward_bound
    q qTime qX qXX qXXX fluxDerivative diffusivity
    K2 K3 D L ((i : ℝ) * width - width / 2) width oldTime timeStep
    curvatureBound hK2 hK3 hwidth htime hq hqX hqXX hLip2 hLip3
    hDbound hDLip hFluxDerivative hPDE
    (by simpa only [hface] using hfxInt)
    (by simpa only [hface] using hInterchange)
    hleftInt (by simpa only [hface] using hrightInt)
    (by simpa only [hface] using hTimeSmooth)
    (by simpa only [hface] using hCurvature)
  have hindexed := leveque04_crankNicolson_exactAverage_indexedResidual_bound
    (fun x => q x oldTime) (fun x => q x (oldTime + timeStep))
    diffusivity width timeStep
    (curvatureBound * timeStep ^ 2 / 12 +
      (D * K3 / 2 + L * K2 / 2) * width ^ 2) i
  exact hindexed (by simpa only [hface] using hlocal)

/-- A second derivative within a closed time interval vanishes outside
that interval, so an interval curvature bound supplies the all-point
premise of the trapezoidal estimate. -/
theorem leveque04_iteratedDerivWithin_two_global_of_interval
    (flux : ℝ → ℝ) (a b bound : ℝ)
    (hab : a ≤ b) (hbound : 0 ≤ bound)
    (hlocal : ∀ t ∈ Set.Icc a b,
      |iteratedDerivWithin 2 flux [[a, b]] t| ≤ bound) :
    ∀ t, |iteratedDerivWithin 2 flux [[a, b]] t| ≤ bound := by
  intro t
  by_cases ht : t ∈ Set.Icc a b
  · exact hlocal t ht
  · have hout : t ∉ closure [[a, b]] := by
      simpa only [Set.uIcc_of_le hab, closure_Icc] using ht
    rw [iteratedDerivWithin_succ,
      derivWithin_zero_of_notMem_closure hout, abs_zero]
    exact hbound

/-- The cubic CN quadrature error needs a curvature bound only on the
forward time interval. -/
theorem leveque04_crankNicolson_temporalQuadrature_intervalBound
    (flux : ℝ → ℝ) (oldTime timeStep curvatureBound : ℝ)
    (htime : 0 < timeStep) (hcurvatureNonneg : 0 ≤ curvatureBound)
    (hsmooth : ContDiffOn ℝ 2 flux [[oldTime, oldTime + timeStep]])
    (hcurvature : ∀ t ∈ Set.Icc oldTime (oldTime + timeStep),
      |iteratedDerivWithin 2 flux [[oldTime, oldTime + timeStep]] t| ≤
        curvatureBound) :
    |(∫ t in oldTime..oldTime + timeStep, flux t) -
        timeStep / 2 * (flux oldTime + flux (oldTime + timeStep))| ≤
      timeStep ^ 3 * curvatureBound / 12 := by
  apply leveque04_crankNicolson_temporalQuadrature_bound
    flux oldTime timeStep curvatureBound htime hsmooth
  exact leveque04_iteratedDerivWithin_two_global_of_interval
    flux oldTime (oldTime + timeStep) curvatureBound
    (by linarith) hcurvatureNonneg hcurvature

/-- The forward-time exact-average CN residual needs temporal curvature
only on the current closed step interval. -/
theorem leveque04_crankNicolson_smoothExactCellResidual_interval_bound
    (q qTime qX qXX qXXX fluxDerivative : ℝ → ℝ → ℝ)
    (diffusivity : ℝ → ℝ)
    (K2 K3 D L face width oldTime timeStep curvatureBound : ℝ)
    (hK2 : 0 ≤ K2) (hK3 : 0 ≤ K3)
    (hwidth : 0 < width) (htime : 0 < timeStep)
    (hcurvatureNonneg : 0 ≤ curvatureBound)
    (hq : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x, HasDerivAt (fun ξ => q ξ τ) (qX x τ) x)
    (hqX : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x, HasDerivAt (fun ξ => qX ξ τ) (qXX x τ) x)
    (hqXX : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x, HasDerivAt (fun ξ => qXX ξ τ) (qXXX x τ) x)
    (hLip2 : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x y, |qXX x τ - qXX y τ| ≤ K2 * |x - y|)
    (hLip3 : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x y, |qXXX x τ - qXXX y τ| ≤ K3 * |x - y|)
    (hDbound : ∀ x, |diffusivity x| ≤ D)
    (hDLip : ∀ x y, |diffusivity x - diffusivity y| ≤ L * |x - y|)
    (hFluxDerivative : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x,
      HasDerivAt (fun ξ => -(diffusivity ξ * qX ξ τ))
        (fluxDerivative x τ) x)
    (hPDE : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x, qTime x τ + fluxDerivative x τ = 0)
    (hfxInt : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep),
      IntervalIntegrable (fun x => fluxDerivative x τ) volume face (face + width))
    (hInterchange : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep),
      HasDerivAt (fun σ => ∫ x in face..face + width, q x σ)
        (∫ x in face..face + width, qTime x τ) τ)
    (hleftInt : IntervalIntegrable
      (fun τ => -(diffusivity face * qX face τ)) volume oldTime (oldTime + timeStep))
    (hrightInt : IntervalIntegrable
      (fun τ => -(diffusivity (face + width) * qX (face + width) τ))
      volume oldTime (oldTime + timeStep))
    (hTimeSmooth : ContDiffOn ℝ 2
      (fun τ => (-(diffusivity face * qX face τ) -
        -(diffusivity (face + width) * qX (face + width) τ)) / width)
      [[oldTime, oldTime + timeStep]])
    (hCurvature : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep),
      |iteratedDerivWithin 2
        (fun σ => (-(diffusivity face * qX face σ) -
          -(diffusivity (face + width) * qX (face + width) σ)) / width)
        [[oldTime, oldTime + timeStep]] τ| ≤ curvatureBound) :
    let numericalFlux : ℝ → ℝ → ℝ := fun c τ =>
      -(diffusivity c *
        ((oneDimensionalCellAverage (fun x => q x τ) c (c + width) -
          oneDimensionalCellAverage (fun x => q x τ) (c - width) c) / width))
    let netNumericalFlux : ℝ → ℝ := fun τ =>
      (numericalFlux face τ - numericalFlux (face + width) τ) / width
    |(oneDimensionalCellAverage (fun x => q x (oldTime + timeStep))
          face (face + width) -
        oneDimensionalCellAverage (fun x => q x oldTime) face (face + width) -
        timeStep / 2 *
          (netNumericalFlux oldTime + netNumericalFlux (oldTime + timeStep))) /
      timeStep| ≤
      curvatureBound * timeStep ^ 2 / 12 +
        (D * K3 / 2 + L * K2 / 2) * width ^ 2 := by
  have hglobal := leveque04_iteratedDerivWithin_two_global_of_interval
    (fun σ => (-(diffusivity face * qX face σ) -
      -(diffusivity (face + width) * qX (face + width) σ)) / width)
    oldTime (oldTime + timeStep) curvatureBound
    (by linarith) hcurvatureNonneg hCurvature
  exact leveque04_crankNicolson_smoothExactCellResidual_forward_bound
    q qTime qX qXX qXXX fluxDerivative diffusivity
    K2 K3 D L face width oldTime timeStep curvatureBound
    hK2 hK3 hwidth htime hq hqX hqXX hLip2 hLip3
    hDbound hDLip hFluxDerivative hPDE hfxInt hInterchange
    hleftInt hrightInt hTimeSmooth hglobal

end NumStability
