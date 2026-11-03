/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.UniformWaveFrontPairs
import ComputationalMathematics.Source.LeVeque.Chapter04.REALinearCauchyWindow
import Mathlib.Data.Set.Card

/-!
# Actual three-family Cauchy fronts, traces, and local geometry

This proof-free specification retains arbitrary bilateral data and every
positive elapsed time in the global clauses. Full one-cell travel is required
only for the nearest-neighbor formula and interior classification. The strict
separation and equality-contact branches have their own geometric hypotheses.
All fields, waves, averages, and Riemann assemblies below are the actual
defined objects; none of the requested correspondences is an antecedent.
-/

open Filter Set
open scoped Topology BigOperators

namespace NumStability

/-- Complete actual three-wave realization for the sign ordering
`λ₀ < 0 < λ₁ < λ₂`, including vanishing waves and coincident fronts. -/
def Leveque04ThreeWaveLocationsTarget : Prop :=
  ∀ (coefficient : Matrix (Fin 3) (Fin 3) ℝ)
    (basis : Module.Basis (Fin 3) ℝ (Fin 3 → ℝ)) (speeds : Fin 3 → ℝ),
    (∀ p, coefficient.mulVec (basis p) = speeds p • basis p) →
    speeds 0 < 0 → 0 < speeds 1 → speeds 1 < speeds 2 →
  ∀ (old : ℤ → Fin 3 → ℝ) (origin width : ℝ) (hwidth : 0 < width),
  let initial := leveque04_uniformReconstruction origin width old
  let U := linearCharacteristicEvolution basis speeds initial
  let face := leveque04_uniformInterface origin width
  let W := fun (j : ℤ) (p : Fin 3) =>
    leveque03_riemannWave basis (old j) (old (j + 1)) p
  (∀ x, U x 0 = initial x) ∧
    IsRectangleConservationLawSolution U coefficient.mulVec ∧
    (∀ i : ℤ, oneDimensionalCellAverage initial (face (i - 1)) (face i) = old i) ∧
    (∀ (horizon : ℝ) (hhorizon : 0 < horizon),
      (∀ time ∈ Icc 0 horizon, ∀ x,
        linearRiemannChainEvolution basis speeds old origin width horizon
          hwidth hhorizon.le x time = U x time) ∧
      ((speeds 2 - speeds 0) * horizon ≤ width →
        ∀ time ∈ Icc 0 horizon, ∀ j : ℤ,
          (∀ x ∈ Ioo (face j + speeds 0 * time) (face j + speeds 2 * time),
            U x time = linearRiemannSolution basis speeds (old j) (old j)
              (old (j + 1)) (x - face j) time) ∧
          (∀ x ∈ Ioo (face j + speeds 2 * time)
              (face (j + 1) + speeds 0 * time), U x time = old (j + 1)))) ∧
    (∀ (time : ℝ), 0 < time →
      let f := fun x => U x time
      let modalJump := leveque04_uniformModalFrontJump basis speeds origin width old time
      let jump := fun z => ∑ p : Fin 3, modalJump z p
      let D : Set ℝ := {z | ¬ ContinuousAt f z}
      (∀ z : ℝ,
        let Gamma := leveque04_uniformWaveFrontPairs speeds origin width time z
        (∀ (p : Fin 3) (j : ℤ), (p, j) ∈ Gamma ↔
          z = face j + speeds p * time) ∧
        Gamma.card ≤ 3 ∧
        (∀ (p : Fin 3) (j k : ℤ),
          z = face j + speeds p * time →
          z = face k + speeds p * time → j = k) ∧
        (∀ (p : Fin 3) (j : ℤ), z = face j + speeds p * time →
          modalJump z p = W j p) ∧
        (∑ pair ∈ Gamma, W pair.2 pair.1) = jump z ∧
        Tendsto f (𝓝[<] z) (𝓝 (f z)) ∧
        Tendsto f (𝓝[>] z) (𝓝 (f z + jump z)) ∧
        (f z + jump z) - f z = jump z ∧
        (jump z = 0 ↔ ∀ (p : Fin 3) (j : ℤ),
          z = face j + speeds p * time → W j p = 0) ∧
        (z ∈ D ↔ f z ≠ f z + jump z) ∧
        (z ∈ D ↔ ∃ (p : Fin 3) (j : ℤ),
          z = face j + speeds p * time ∧ W j p ≠ 0)) ∧
      (∀ lower upper : ℝ, (D ∩ Icc lower upper).Finite) ∧
      (∀ i : ℤ,
        let a := face (i - 1)
        let b := face i
        let c1 := a + speeds 1 * time
        let c2 := a + speeds 2 * time
        let d0 := b + speeds 0 * time
        let WL := W (i - 1)
        let WR := W i
        let interiorD := D ∩ Ioo a b
        ((∀ p, |speeds p * time| ≤ width) →
          (∀ x ∈ Ioo a b,
            f x = old i - (if x ≤ c1 then WL 1 else 0) -
              (if x ≤ c2 then WL 2 else 0) + (if d0 < x then WR 0 else 0)) ∧
          (∀ z : ℝ,
            z ∈ interiorD ↔ z ∈ Ioo a b ∧
              ((z = c1 ∧ WL 1 ≠ 0) ∨ (z = c2 ∧ WL 2 ≠ 0) ∨
                (z = d0 ∧ WR 0 ≠ 0)))) ∧
        ((a < c1 ∧ c1 < c2 ∧ c2 < d0 ∧ d0 < b) ↔
          (speeds 2 - speeds 0) * time < width) ∧
        ((speeds 2 - speeds 0) * time < width →
          (∀ x ∈ Ioo a c1, f x = old i - WL 1 - WL 2) ∧
          (∀ x ∈ Ioo c1 c2, f x = old i - WL 2) ∧
          (∀ x ∈ Ioo c2 d0, f x = old i) ∧
          (∀ x ∈ Ioo d0 b, f x = old i + WR 0) ∧
          Tendsto f (𝓝[<] c1) (𝓝 (old i - WL 1 - WL 2)) ∧
          Tendsto f (𝓝[>] c1) (𝓝 (old i - WL 2)) ∧
          f c1 = old i - WL 1 - WL 2 ∧
          Tendsto f (𝓝[<] c2) (𝓝 (old i - WL 2)) ∧
          Tendsto f (𝓝[>] c2) (𝓝 (old i)) ∧
          f c2 = old i - WL 2 ∧
          Tendsto f (𝓝[<] d0) (𝓝 (old i)) ∧
          Tendsto f (𝓝[>] d0) (𝓝 (old i + WR 0)) ∧
          f d0 = old i ∧
          (HasJumpAt f c1 (old i - WL 1 - WL 2) (old i - WL 2) ↔ WL 1 ≠ 0) ∧
          (HasJumpAt f c2 (old i - WL 2) (old i) ↔ WL 2 ≠ 0) ∧
          (HasJumpAt f d0 (old i) (old i + WR 0) ↔ WR 0 ≠ 0) ∧
          (interiorD.ncard = 3 ↔ WL 1 ≠ 0 ∧ WL 2 ≠ 0 ∧ WR 0 ≠ 0)) ∧
        ((speeds 2 - speeds 0) * time = width →
          (∀ p, |speeds p * time| ≤ width) ∧
          a < c1 ∧ c1 < c2 ∧ c2 = d0 ∧ d0 < b ∧
          Ioo c2 d0 = ∅ ∧
          Tendsto f (𝓝[<] c2) (𝓝 (old i - WL 2)) ∧
          Tendsto f (𝓝[>] c2) (𝓝 (old i + WR 0)) ∧
          f c2 = old i - WL 2 ∧
          (old i + WR 0) - (old i - WL 2) = WL 2 + WR 0 ∧
          (WL 2 + WR 0 = 0 ↔ WL 2 = 0 ∧ WR 0 = 0) ∧
          (WL 2 + WR 0 ≠ 0 ↔ WL 2 ≠ 0 ∨ WR 0 ≠ 0) ∧
          (HasJumpAt f c2 (old i - WL 2) (old i + WR 0) ↔
            WL 2 ≠ 0 ∨ WR 0 ≠ 0) ∧
          (c1 ∈ D ↔ WL 1 ≠ 0) ∧
          (c2 ∈ D ↔ WL 2 ≠ 0 ∨ WR 0 ≠ 0) ∧
          interiorD.ncard ≤ 2)))

end NumStability
