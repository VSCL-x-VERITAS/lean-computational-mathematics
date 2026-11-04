/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LinearUniformModalAverage
import ComputationalMathematics.Source.LeVeque.Chapter04.REALinearCauchyWindow
import ComputationalMathematics.Source.LeVeque.Chapter04.ThreeWaveREA

/-!
# Physical wave superposition and cell averages

This proof-free specification uses the actual constant linear Cauchy field and
its actual spatial integrals. The full one-cell CFL range, including overlapping
fronts and zero time, is a derived elaboration of the characteristic formula.
The source's informal step-size framing and sign wording are retained separately
in the source-admission evidence.
-/

namespace NumStability

/-- Complete linear wave-superposition realization, with the signed three-wave
specialization. All cell arrays are arbitrary bilateral arrays. -/
def Leveque04WaveSuperpositionAverageTarget : Prop :=
  (∀ (m : ℕ), 0 < m →
    ∀ (coefficient : Matrix (Fin m) (Fin m) ℝ)
      (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ),
      (∀ p, coefficient.mulVec (basis p) = speeds p • basis p) →
    ∀ (old : ℤ → Fin m → ℝ) (origin width horizon : ℝ)
      (hwidth : 0 < width) (hhorizon : 0 < horizon),
    let initial := leveque04_uniformReconstruction origin width old
    let exact := linearCharacteristicEvolution basis speeds initial
    (∀ x, exact x 0 = initial x) ∧
      IsRectangleConservationLawSolution exact coefficient.mulVec ∧
      (∀ i, oneDimensionalCellAverage initial
        (leveque04_uniformInterface origin width (i - 1))
        (leveque04_uniformInterface origin width i) = old i) ∧
      (∀ time ∈ Set.Icc 0 horizon, ∀ x,
        linearRiemannChainEvolution basis speeds old origin width horizon
          hwidth hhorizon.le x time = exact x time) ∧
      ((∀ p, |speeds p * horizon| ≤ width) →
      ∀ time ∈ Set.Icc 0 horizon, ∀ i,
        (∀ p, oneDimensionalCellAverage
            (fun x => basis.equivFun (initial (x - speeds p * time)) p • basis p)
            (leveque04_uniformInterface origin width (i - 1))
            (leveque04_uniformInterface origin width i) -
              basis.equivFun (old i) p • basis p =
            -(time / width) •
              (max (speeds p) 0 •
                  leveque03_riemannWave basis (old (i - 1)) (old i) p +
                min (speeds p) 0 •
                  leveque03_riemannWave basis (old i) (old (i + 1)) p)) ∧
        oneDimensionalCellAverage (fun x => exact x time)
            (leveque04_uniformInterface origin width (i - 1))
            (leveque04_uniformInterface origin width i) =
          old i - (time / width) •
            ((∑ p, max (speeds p) 0 •
                leveque03_riemannWave basis (old (i - 1)) (old i) p) +
              ∑ p, min (speeds p) 0 •
                leveque03_riemannWave basis (old i) (old (i + 1)) p))) ∧
  (∀ (coefficient : Matrix (Fin 3) (Fin 3) ℝ)
      (basis : Module.Basis (Fin 3) ℝ (Fin 3 → ℝ)) (speeds : Fin 3 → ℝ),
      (∀ p, coefficient.mulVec (basis p) = speeds p • basis p) →
      speeds 0 < 0 → 0 < speeds 1 → speeds 1 < speeds 2 →
    ∀ (old : ℤ → Fin 3 → ℝ) (origin width time : ℝ),
      0 < width → 0 ≤ time → (∀ p, |speeds p * time| ≤ width) →
    ∀ i, oneDimensionalCellAverage
        (fun x => linearCharacteristicEvolution basis speeds
          (leveque04_uniformReconstruction origin width old) x time)
        (leveque04_uniformInterface origin width (i - 1))
        (leveque04_uniformInterface origin width i) =
      old i - (time / width) •
        (speeds 1 • leveque03_riemannWave basis (old (i - 1)) (old i) 1 +
          speeds 2 • leveque03_riemannWave basis (old (i - 1)) (old i) 2 +
          speeds 0 • leveque03_riemannWave basis (old i) (old (i + 1)) 0))

end NumStability
