/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CrankNicolsonAccuracy
import ComputationalMathematics.Source.LeVeque.Chapter04.WeightedDiffusionEnergy

/-!
# Periodic realization of the indexed Crank–Nicolson flux

The smooth residual estimates use the integer-indexed conservative flux,
while the unconditional energy and existence results use a finite periodic
grid. This module identifies their update equations under periodic lifting.
-/

namespace NumStability

open MeasureTheory Interval

/-- Lift data on a finite periodic grid to an integer-indexed grid. -/
def leveque04_periodicLift (n : ℕ) (u : ZMod n → ℝ) (i : ℤ) : ℝ :=
  u (i : ZMod n)

/-- The integer-indexed conservative CN update on periodic data is
exactly the finite periodic weighted-diffusion equation (4.13). -/
theorem leveque04_crankNicolson_periodicLift_update
    (n : ℕ) [NeZero n] (interfaceDiffusivity before after : ZMod n → ℝ)
    (width timeStep : ℝ) (hwidth : 0 < width) (i : ℤ) :
    conservativeFluxDifferenceUpdateInt (timeStep / width)
        (leveque04_periodicLift n before)
        (leveque04_crankNicolsonInterfaceFlux
          (leveque04_periodicLift n interfaceDiffusivity) width
          (leveque04_periodicLift n before)
          (leveque04_periodicLift n after)) i =
      before (i : ZMod n) + timeStep / (2 * width ^ 2) *
        (interfaceDiffusivity ((i : ZMod n) + 1) *
            (before ((i : ZMod n) + 1) - before (i : ZMod n)) -
          interfaceDiffusivity (i : ZMod n) *
            (before (i : ZMod n) - before ((i : ZMod n) - 1)) +
          interfaceDiffusivity ((i : ZMod n) + 1) *
            (after ((i : ZMod n) + 1) - after (i : ZMod n)) -
          interfaceDiffusivity (i : ZMod n) *
            (after (i : ZMod n) - after ((i : ZMod n) - 1))) := by
  rw [leveque04_crankNicolson_update_eq timeStep width _ _ _ i hwidth]
  simp only [leveque04_periodicLift, Int.cast_add, Int.cast_sub,
    Int.cast_one]

/-- The indexed CN equation and the finite periodic equation are the
same statement for periodically lifted data. -/
theorem leveque04_crankNicolson_periodicLift_iff
    (n : ℕ) [NeZero n] (interfaceDiffusivity before after : ZMod n → ℝ)
    (width timeStep : ℝ) (hwidth : 0 < width) :
    IsLeveque04CrankNicolsonStep timeStep width
        (leveque04_periodicLift n interfaceDiffusivity)
        (leveque04_periodicLift n before)
        (leveque04_periodicLift n after) ↔
      ∀ i : ZMod n, after i =
        before i + timeStep / (2 * width ^ 2) *
          (interfaceDiffusivity (i + 1) * (before (i + 1) - before i) -
            interfaceDiffusivity i * (before i - before (i - 1)) +
            interfaceDiffusivity (i + 1) * (after (i + 1) - after i) -
            interfaceDiffusivity i * (after i - after (i - 1))) := by
  rw [IsLeveque04CrankNicolsonStep]
  simp only [hwidth, true_and]
  simp_rw [leveque04_crankNicolson_periodicLift_update n
    interfaceDiffusivity before after width timeStep hwidth]
  simp only [leveque04_periodicLift]
  constructor
  · intro h i
    obtain ⟨j, rfl⟩ := ZMod.intCast_surjective i
    exact h j
  · intro h i
    exact h (i : ZMod n)

/-- The same integer-indexed flux step used in the smooth residual
theorems has a unique periodic after-state for nonnegative face samples. -/
theorem leveque04_crankNicolson_periodicLift_existsUnique
    (n : ℕ) [NeZero n] (interfaceDiffusivity : ZMod n → ℝ)
    (width timeStep : ℝ)
    (hdiffusivity : ∀ i, 0 ≤ interfaceDiffusivity i)
    (hwidth : 0 < width) (htime : 0 ≤ timeStep)
    (before : ZMod n → ℝ) :
    ∃! after : ZMod n → ℝ,
      IsLeveque04CrankNicolsonStep timeStep width
        (leveque04_periodicLift n interfaceDiffusivity)
        (leveque04_periodicLift n before)
        (leveque04_periodicLift n after) := by
  obtain ⟨after, hafter, hunique⟩ :=
    leveque04_periodicVariableCrankNicolson_existsUnique n
      interfaceDiffusivity width timeStep hdiffusivity hwidth htime before
  refine ⟨after, ?_, ?_⟩
  · exact (leveque04_crankNicolson_periodicLift_iff n
      interfaceDiffusivity before after width timeStep hwidth).mpr hafter
  · intro other hother
    exact hunique other ((leveque04_crankNicolson_periodicLift_iff n
      interfaceDiffusivity before other width timeStep hwidth).mp hother)

/-- Two solutions of the same lifted conservative CN flux update contract
their finite periodic squared difference energy without a CFL bound. -/
theorem leveque04_crankNicolson_periodicLift_differenceEnergy
    (n : ℕ) [NeZero n] (interfaceDiffusivity : ZMod n → ℝ)
    (width timeStep : ℝ)
    (hdiffusivity : ∀ i, 0 ≤ interfaceDiffusivity i)
    (hwidth : 0 < width) (htime : 0 ≤ timeStep)
    (before₁ after₁ before₂ after₂ : ZMod n → ℝ)
    (hstep₁ : IsLeveque04CrankNicolsonStep timeStep width
      (leveque04_periodicLift n interfaceDiffusivity)
      (leveque04_periodicLift n before₁)
      (leveque04_periodicLift n after₁))
    (hstep₂ : IsLeveque04CrankNicolsonStep timeStep width
      (leveque04_periodicLift n interfaceDiffusivity)
      (leveque04_periodicLift n before₂)
      (leveque04_periodicLift n after₂)) :
    (∑ i, (after₁ i - after₂ i) ^ 2) ≤
      ∑ i, (before₁ i - before₂ i) ^ 2 := by
  exact leveque04_periodicVariableCrankNicolson_differenceEnergy n
    interfaceDiffusivity width timeStep hdiffusivity hwidth htime
    before₁ after₁ before₂ after₂
    ((leveque04_crankNicolson_periodicLift_iff n
      interfaceDiffusivity before₁ after₁ width timeStep hwidth).mp hstep₁)
    ((leveque04_crankNicolson_periodicLift_iff n
      interfaceDiffusivity before₂ after₂ width timeStep hwidth).mp hstep₂)

/-- An indexed conservative-flux residual bound transfers exactly to
the finite periodic CN equation on the same face coefficients. -/
theorem leveque04_crankNicolson_periodicLift_residual_bound
    (n : ℕ) [NeZero n] (interfaceDiffusivity before after : ZMod n → ℝ)
    (width timeStep residualBound : ℝ) (hwidth : 0 < width)
    (hindexed : ∀ j : ℤ,
      |(leveque04_periodicLift n after j -
        conservativeFluxDifferenceUpdateInt (timeStep / width)
          (leveque04_periodicLift n before)
          (leveque04_crankNicolsonInterfaceFlux
            (leveque04_periodicLift n interfaceDiffusivity) width
            (leveque04_periodicLift n before)
            (leveque04_periodicLift n after)) j) / timeStep| ≤
        residualBound) :
    ∀ i : ZMod n,
      |(after i - (before i + timeStep / (2 * width ^ 2) *
        (interfaceDiffusivity (i + 1) * (before (i + 1) - before i) -
          interfaceDiffusivity i * (before i - before (i - 1)) +
          interfaceDiffusivity (i + 1) * (after (i + 1) - after i) -
          interfaceDiffusivity i * (after i - after (i - 1))))) / timeStep| ≤
        residualBound := by
  intro i
  obtain ⟨j, rfl⟩ := ZMod.intCast_surjective i
  simpa only [leveque04_periodicLift,
    leveque04_crankNicolson_periodicLift_update n
      interfaceDiffusivity before after width timeStep hwidth j]
    using hindexed j

/-- Smooth exact cell averages that are compatible with a periodic grid
inherit the indexed second-order local residual on the very same finite
periodic CN equation used in the energy theorem. -/
theorem leveque04_crankNicolson_periodicSmoothResidual_bound
    (n : ℕ) [NeZero n]
    (q qTime qX qXX qXXX fluxDerivative : ℝ → ℝ → ℝ)
    (diffusivity : ℝ → ℝ)
    (interfaceDiffusivity before after : ZMod n → ℝ)
    (K2 K3 D L width oldTime timeStep curvatureBound : ℝ)
    (hK2 : 0 ≤ K2) (hK3 : 0 ≤ K3)
    (hwidth : 0 < width) (htime : 0 < timeStep)
    (hcoefficient : ∀ j : ℤ,
      leveque04_periodicLift n interfaceDiffusivity j =
        diffusivity ((j : ℝ) * width - width / 2))
    (hbefore : ∀ j : ℤ,
      leveque04_periodicLift n before j = oneDimensionalCellAverage
        (fun x => q x oldTime)
        ((j : ℝ) * width - width / 2)
        ((j : ℝ) * width + width / 2))
    (hafter : ∀ j : ℤ,
      leveque04_periodicLift n after j = oneDimensionalCellAverage
        (fun x => q x (oldTime + timeStep))
        ((j : ℝ) * width - width / 2)
        ((j : ℝ) * width + width / 2))
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
    (hfxInt : ∀ j : ℤ, ∀ τ,
      IntervalIntegrable (fun x => fluxDerivative x τ) volume
        ((j : ℝ) * width - width / 2)
        ((j : ℝ) * width + width / 2))
    (hInterchange : ∀ j : ℤ, ∀ τ,
      HasDerivAt (fun σ => ∫ x in ((j : ℝ) * width - width / 2)..
        ((j : ℝ) * width + width / 2), q x σ)
        (∫ x in ((j : ℝ) * width - width / 2)..
          ((j : ℝ) * width + width / 2), qTime x τ) τ)
    (hleftInt : ∀ j : ℤ, IntervalIntegrable
      (fun τ => -(diffusivity ((j : ℝ) * width - width / 2) *
        qX ((j : ℝ) * width - width / 2) τ))
      volume oldTime (oldTime + timeStep))
    (hrightInt : ∀ j : ℤ, IntervalIntegrable
      (fun τ => -(diffusivity ((j : ℝ) * width + width / 2) *
        qX ((j : ℝ) * width + width / 2) τ))
      volume oldTime (oldTime + timeStep))
    (hTimeSmooth : ∀ j : ℤ, ContDiffOn ℝ 2
      (fun τ => (-(diffusivity ((j : ℝ) * width - width / 2) *
        qX ((j : ℝ) * width - width / 2) τ) -
        -(diffusivity ((j : ℝ) * width + width / 2) *
          qX ((j : ℝ) * width + width / 2) τ)) / width)
      [[oldTime, oldTime + timeStep]])
    (hCurvature : ∀ j : ℤ, ∀ τ,
      |iteratedDerivWithin 2
        (fun σ => (-(diffusivity ((j : ℝ) * width - width / 2) *
          qX ((j : ℝ) * width - width / 2) σ) -
          -(diffusivity ((j : ℝ) * width + width / 2) *
            qX ((j : ℝ) * width + width / 2) σ)) / width)
        [[oldTime, oldTime + timeStep]] τ| ≤ curvatureBound) :
    ∀ i : ZMod n,
      |(after i - (before i + timeStep / (2 * width ^ 2) *
        (interfaceDiffusivity (i + 1) * (before (i + 1) - before i) -
          interfaceDiffusivity i * (before i - before (i - 1)) +
          interfaceDiffusivity (i + 1) * (after (i + 1) - after i) -
          interfaceDiffusivity i * (after i - after (i - 1))))) / timeStep| ≤
        curvatureBound * timeStep ^ 2 / 12 +
          (D * K3 / 2 + L * K2 / 2) * width ^ 2 := by
  apply leveque04_crankNicolson_periodicLift_residual_bound n
    interfaceDiffusivity before after width timeStep
    (curvatureBound * timeStep ^ 2 / 12 +
      (D * K3 / 2 + L * K2 / 2) * width ^ 2) hwidth
  intro j
  have h := leveque04_crankNicolson_indexedSmoothResidual_bound
    q qTime qX qXX qXXX fluxDerivative diffusivity
    K2 K3 D L width oldTime timeStep curvatureBound j
    hK2 hK3 hwidth htime hq hqX hqXX hLip2 hLip3 hDbound hDLip
    hFluxDerivative hPDE (hfxInt j) (hInterchange j)
    (hleftInt j) (hrightInt j) (hTimeSmooth j) (hCurvature j)
  have hc : (fun k : ℤ => diffusivity ((k : ℝ) * width - width / 2)) =
      leveque04_periodicLift n interfaceDiffusivity := by
    funext k
    exact (hcoefficient k).symm
  have hb : (fun k : ℤ => oneDimensionalCellAverage
      (fun x => q x oldTime)
      ((k : ℝ) * width - width / 2)
      ((k : ℝ) * width + width / 2)) =
      leveque04_periodicLift n before := by
    funext k
    exact (hbefore k).symm
  have ha : (fun k : ℤ => oneDimensionalCellAverage
      (fun x => q x (oldTime + timeStep))
      ((k : ℝ) * width - width / 2)
      ((k : ℝ) * width + width / 2)) =
      leveque04_periodicLift n after := by
    funext k
    exact (hafter k).symm
  dsimp only at h
  rw [← hafter j] at h
  simpa only [hc, hb, ha] using h

/-- The forward-time exact-average residual holds on the same finite
periodic variable-face CN update as the energy theorem. -/
theorem leveque04_crankNicolson_periodicSmoothResidual_forward_bound
    (n : ℕ) [NeZero n]
    (q qTime qX qXX qXXX fluxDerivative : ℝ → ℝ → ℝ)
    (diffusivity : ℝ → ℝ)
    (interfaceDiffusivity before after : ZMod n → ℝ)
    (K2 K3 D L width oldTime timeStep curvatureBound : ℝ)
    (hK2 : 0 ≤ K2) (hK3 : 0 ≤ K3)
    (hwidth : 0 < width) (htime : 0 < timeStep)
    (hcoefficient : ∀ j : ℤ,
      leveque04_periodicLift n interfaceDiffusivity j =
        diffusivity ((j : ℝ) * width - width / 2))
    (hbefore : ∀ j : ℤ,
      leveque04_periodicLift n before j = oneDimensionalCellAverage
        (fun x => q x oldTime)
        ((j : ℝ) * width - width / 2)
        ((j : ℝ) * width + width / 2))
    (hafter : ∀ j : ℤ,
      leveque04_periodicLift n after j = oneDimensionalCellAverage
        (fun x => q x (oldTime + timeStep))
        ((j : ℝ) * width - width / 2)
        ((j : ℝ) * width + width / 2))
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
    (hfxInt : ∀ j : ℤ, ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep),
      IntervalIntegrable (fun x => fluxDerivative x τ) volume
        ((j : ℝ) * width - width / 2)
        ((j : ℝ) * width + width / 2))
    (hInterchange : ∀ j : ℤ, ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep),
      HasDerivAt (fun σ => ∫ x in ((j : ℝ) * width - width / 2)..
        ((j : ℝ) * width + width / 2), q x σ)
        (∫ x in ((j : ℝ) * width - width / 2)..
          ((j : ℝ) * width + width / 2), qTime x τ) τ)
    (hleftInt : ∀ j : ℤ, IntervalIntegrable
      (fun τ => -(diffusivity ((j : ℝ) * width - width / 2) *
        qX ((j : ℝ) * width - width / 2) τ))
      volume oldTime (oldTime + timeStep))
    (hrightInt : ∀ j : ℤ, IntervalIntegrable
      (fun τ => -(diffusivity ((j : ℝ) * width + width / 2) *
        qX ((j : ℝ) * width + width / 2) τ))
      volume oldTime (oldTime + timeStep))
    (hTimeSmooth : ∀ j : ℤ, ContDiffOn ℝ 2
      (fun τ => (-(diffusivity ((j : ℝ) * width - width / 2) *
        qX ((j : ℝ) * width - width / 2) τ) -
        -(diffusivity ((j : ℝ) * width + width / 2) *
          qX ((j : ℝ) * width + width / 2) τ)) / width)
      [[oldTime, oldTime + timeStep]])
    (hCurvature : ∀ j : ℤ, ∀ τ,
      |iteratedDerivWithin 2
        (fun σ => (-(diffusivity ((j : ℝ) * width - width / 2) *
          qX ((j : ℝ) * width - width / 2) σ) -
          -(diffusivity ((j : ℝ) * width + width / 2) *
            qX ((j : ℝ) * width + width / 2) σ)) / width)
        [[oldTime, oldTime + timeStep]] τ| ≤ curvatureBound) :
    ∀ i : ZMod n,
      |(after i - (before i + timeStep / (2 * width ^ 2) *
        (interfaceDiffusivity (i + 1) * (before (i + 1) - before i) -
          interfaceDiffusivity i * (before i - before (i - 1)) +
          interfaceDiffusivity (i + 1) * (after (i + 1) - after i) -
          interfaceDiffusivity i * (after i - after (i - 1))))) / timeStep| ≤
        curvatureBound * timeStep ^ 2 / 12 +
          (D * K3 / 2 + L * K2 / 2) * width ^ 2 := by
  apply leveque04_crankNicolson_periodicLift_residual_bound n
    interfaceDiffusivity before after width timeStep
    (curvatureBound * timeStep ^ 2 / 12 +
      (D * K3 / 2 + L * K2 / 2) * width ^ 2) hwidth
  intro j
  have h := leveque04_crankNicolson_indexedSmoothResidual_forward_bound
    q qTime qX qXX qXXX fluxDerivative diffusivity
    K2 K3 D L width oldTime timeStep curvatureBound j
    hK2 hK3 hwidth htime hq hqX hqXX hLip2 hLip3 hDbound hDLip
    hFluxDerivative hPDE (hfxInt j) (hInterchange j)
    (hleftInt j) (hrightInt j) (hTimeSmooth j) (hCurvature j)
  have hc : (fun k : ℤ => diffusivity ((k : ℝ) * width - width / 2)) =
      leveque04_periodicLift n interfaceDiffusivity := by
    funext k
    exact (hcoefficient k).symm
  have hb : (fun k : ℤ => oneDimensionalCellAverage
      (fun x => q x oldTime)
      ((k : ℝ) * width - width / 2)
      ((k : ℝ) * width + width / 2)) =
      leveque04_periodicLift n before := by
    funext k
    exact (hbefore k).symm
  have ha : (fun k : ℤ => oneDimensionalCellAverage
      (fun x => q x (oldTime + timeStep))
      ((k : ℝ) * width - width / 2)
      ((k : ℝ) * width + width / 2)) =
      leveque04_periodicLift n after := by
    funext k
    exact (hafter k).symm
  dsimp only at h
  rw [← hafter j] at h
  simpa only [hc, hb, ha] using h

/-- Quadratic face-coefficient error and cubic adjacent-error variation
preserve a quadratic residual on the same finite periodic CN update. -/
theorem leveque04_periodicCN_approxCoefficientResidual_bound
    (n : ℕ) [NeZero n]
    (coefficient exactCoefficient before after : ZMod n → ℝ)
    (timeStep width baseBound E Ederiv M S : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hE : 0 ≤ E) (hEderiv : 0 ≤ Ederiv)
    (hbase : ∀ j : ℤ,
      |(leveque04_periodicLift n after j -
        conservativeFluxDifferenceUpdateInt (timeStep / width)
          (leveque04_periodicLift n before)
          (leveque04_crankNicolsonInterfaceFlux
            (leveque04_periodicLift n exactCoefficient) width
            (leveque04_periodicLift n before)
            (leveque04_periodicLift n after)) j) / timeStep| ≤ baseBound)
    (herror : ∀ j : ℤ,
      |leveque04_periodicLift n coefficient j -
        leveque04_periodicLift n exactCoefficient j| ≤ E * width ^ 2)
    (herrorDiff : ∀ j : ℤ,
      |(leveque04_periodicLift n coefficient (j + 1) -
          leveque04_periodicLift n exactCoefficient (j + 1)) -
        (leveque04_periodicLift n coefficient j -
          leveque04_periodicLift n exactCoefficient j)| ≤ Ederiv * width ^ 3)
    (hbeforeSlope : ∀ j : ℤ,
      |(leveque04_periodicLift n before (j + 1) -
        leveque04_periodicLift n before j) / width| ≤ M)
    (hbeforeSlopeDiff : ∀ j : ℤ,
      |(leveque04_periodicLift n before (j + 1) -
          leveque04_periodicLift n before j) / width -
        (leveque04_periodicLift n before j -
          leveque04_periodicLift n before (j - 1)) / width| ≤ S * width)
    (hafterSlope : ∀ j : ℤ,
      |(leveque04_periodicLift n after (j + 1) -
        leveque04_periodicLift n after j) / width| ≤ M)
    (hafterSlopeDiff : ∀ j : ℤ,
      |(leveque04_periodicLift n after (j + 1) -
          leveque04_periodicLift n after j) / width -
        (leveque04_periodicLift n after j -
          leveque04_periodicLift n after (j - 1)) / width| ≤ S * width) :
    ∀ i : ZMod n,
      |(after i - (before i + timeStep / (2 * width ^ 2) *
        (coefficient (i + 1) * (before (i + 1) - before i) -
          coefficient i * (before i - before (i - 1)) +
          coefficient (i + 1) * (after (i + 1) - after i) -
          coefficient i * (after i - after (i - 1))))) / timeStep| ≤
        baseBound + (Ederiv * M + E * S) * width ^ 2 := by
  apply leveque04_crankNicolson_periodicLift_residual_bound n
    coefficient before after width timeStep
    (baseBound + (Ederiv * M + E * S) * width ^ 2) hwidth
  intro j
  exact leveque04_crankNicolson_approxCoefficient_indexedResidual_bound
    (leveque04_periodicLift n coefficient)
    (leveque04_periodicLift n exactCoefficient)
    (leveque04_periodicLift n before)
    (leveque04_periodicLift n after)
    timeStep width baseBound E Ederiv M S j htime hwidth hE hEderiv
    (hbase j) (herror j) (herrorDiff j)
    (hbeforeSlope j) (hbeforeSlopeDiff j)
    (hafterSlope j) (hafterSlopeDiff j)

end NumStability
