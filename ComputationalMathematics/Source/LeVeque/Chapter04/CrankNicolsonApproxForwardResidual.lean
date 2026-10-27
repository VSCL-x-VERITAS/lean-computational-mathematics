/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CrankNicolsonPeriodicAccuracy

/-!
# Forward-time residual for approximate interface diffusivity

The smooth exact-average forward-time residual for the physical
diffusivity transfers to the periodic Crank–Nicolson update with an
accurate approximate interface coefficient. The coefficient and slope
budgets remain explicit.
-/

namespace NumStability

open MeasureTheory Interval

/-- A forward-time smooth diffusion solution has a quadratic normalized
residual for the approximate-face finite periodic CN stencil when face
coefficient errors and exact-average slopes obey the displayed budgets. -/
theorem leveque04_crankNicolson_periodicSmoothApprox_forward_residual
    (n : ℕ) [NeZero n]
    (q qTime qX qXX qXXX fluxDerivative : ℝ → ℝ → ℝ)
    (diffusivity : ℝ → ℝ)
    (coefficient exactCoefficient before after : ZMod n → ℝ)
    (K2 K3 D L width oldTime timeStep curvatureBound E Ederiv M S : ℝ)
    (hK2 : 0 ≤ K2) (hK3 : 0 ≤ K3)
    (hwidth : 0 < width) (htime : 0 < timeStep)
    (hE : 0 ≤ E) (hEderiv : 0 ≤ Ederiv)
    (hcoefficient : ∀ j : ℤ,
      leveque04_periodicLift n exactCoefficient j =
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
    (hq : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x,
      HasDerivAt (fun ξ => q ξ τ) (qX x τ) x)
    (hqX : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x,
      HasDerivAt (fun ξ => qX ξ τ) (qXX x τ) x)
    (hqXX : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x,
      HasDerivAt (fun ξ => qXX ξ τ) (qXXX x τ) x)
    (hLip2 : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x y,
      |qXX x τ - qXX y τ| ≤ K2 * |x - y|)
    (hLip3 : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x y,
      |qXXX x τ - qXXX y τ| ≤ K3 * |x - y|)
    (hDbound : ∀ x, |diffusivity x| ≤ D)
    (hDLip : ∀ x y, |diffusivity x - diffusivity y| ≤ L * |x - y|)
    (hFluxDerivative : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x,
      HasDerivAt (fun ξ => -(diffusivity ξ * qX ξ τ))
        (fluxDerivative x τ) x)
    (hPDE : ∀ τ ∈ Set.Icc oldTime (oldTime + timeStep), ∀ x,
      qTime x τ + fluxDerivative x τ = 0)
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
        [[oldTime, oldTime + timeStep]] τ| ≤ curvatureBound)
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
        curvatureBound * timeStep ^ 2 / 12 +
          ((D * K3 / 2 + L * K2 / 2) + Ederiv * M + E * S) * width ^ 2 := by
  have hbase (j : ℤ) := by
    have h := leveque04_crankNicolson_indexedSmoothResidual_forward_bound
      q qTime qX qXX qXXX fluxDerivative diffusivity
      K2 K3 D L width oldTime timeStep curvatureBound j
      hK2 hK3 hwidth htime hq hqX hqXX hLip2 hLip3 hDbound hDLip
      hFluxDerivative hPDE (hfxInt j) (hInterchange j)
      (hleftInt j) (hrightInt j) (hTimeSmooth j) (hCurvature j)
    have hc : (fun k : ℤ => diffusivity ((k : ℝ) * width - width / 2)) =
        leveque04_periodicLift n exactCoefficient := by
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
  have h := leveque04_periodicCN_approxCoefficientResidual_bound
    n coefficient exactCoefficient before after timeStep width
    (curvatureBound * timeStep ^ 2 / 12 +
      (D * K3 / 2 + L * K2 / 2) * width ^ 2)
    E Ederiv M S htime hwidth hE hEderiv hbase herror herrorDiff
    hbeforeSlope hbeforeSlopeDiff hafterSlope hafterSlopeDiff
  intro i
  convert h i using 1; ring

end NumStability
