/- Proof-free owner-qualified target. No proof or statement acceptance is supplied. -/
import ComputationalMathematics.Source.LeVeque.Chapter04.DiffusionRefinementObservations

open Set Filter
open scoped Topology

namespace NumStability

/-- The actual left face of the cell centered at X+i*h is X+(i-1/2)*h. -/
noncomputable def leveque04_diffusionRefinementExactFaces
    (conductivity : ℝ → ℝ) (observation width : ℝ) : ℤ → ℝ :=
  fun i => conductivity (observation + ((i : ℝ) - (1 / 2 : ℝ)) * width)

/-- Necessary scaling and separate constructive quadratic families for the
actual owner-selected physical model. No all-family attainment, uniform
positive lower bound, fixed shared profile or quantitative theta is primary. -/
def Leveque04DiffusionRefinementPhysicalTarget : Prop :=
  (∀ (conductivity : ℝ → ℝ) (observation horizon : ℝ)
      (timeStep width : ℕ → ℝ) (steps : ℕ → ℕ),
    Continuous conductivity → (∀ x, 0 < conductivity x) →
    (∃ bound : ℝ, ∀ x, |conductivity x| ≤ bound) →
    0 < horizon →
    (∀ k, 0 < timeStep k) → (∀ k, 0 < width k) →
    Tendsto timeStep atTop (𝓝 0) → Tendsto width atTop (𝓝 0) →
    (∀ k, (steps k : ℝ) * timeStep k = horizon) →
    (numericalLimitingDomain
        (fun k => leveque04_diffusionPointNumericalDomain observation
          (timeStep k) (width k)
          (leveque04_diffusionRefinementExactFaces conductivity observation (width k))
          (steps k)) = univ ∨
      numericalLimitingDomain
        (fun k => leveque04_diffusionCellAverageNumericalDomain observation
          (timeStep k) (width k)
          (leveque04_diffusionRefinementExactFaces conductivity observation (width k))
          (steps k)) = univ) →
    Tendsto (fun k => timeStep k / width k) atTop (𝓝 0)) ∧
  (∀ (conductivity : ℝ → ℝ) (observation horizon : ℝ),
    Continuous conductivity → (∀ x, 0 < conductivity x) →
    (∃ bound : ℝ, ∀ x, |conductivity x| ≤ bound) →
    0 < horizon →
    ∃ (timeStep width : ℕ → ℝ) (steps : ℕ → ℕ),
      (∀ k, 0 < timeStep k) ∧ (∀ k, 0 < width k) ∧
      Tendsto timeStep atTop (𝓝 0) ∧ Tendsto width atTop (𝓝 0) ∧
      (∀ k, (steps k : ℝ) * timeStep k = horizon) ∧
      (∃ C : ℝ, 0 < C ∧ ∀ᶠ k in atTop, timeStep k ≤ C * width k ^ 2) ∧
      numericalLimitingDomain
        (fun k => leveque04_diffusionPointNumericalDomain observation
          (timeStep k) (width k)
          (leveque04_diffusionRefinementExactFaces conductivity observation (width k))
          (steps k)) = univ) ∧
  (∀ (conductivity : ℝ → ℝ) (observation horizon : ℝ),
    Continuous conductivity → (∀ x, 0 < conductivity x) →
    (∃ bound : ℝ, ∀ x, |conductivity x| ≤ bound) →
    0 < horizon →
    ∃ (timeStep width : ℕ → ℝ) (steps : ℕ → ℕ),
      (∀ k, 0 < timeStep k) ∧ (∀ k, 0 < width k) ∧
      Tendsto timeStep atTop (𝓝 0) ∧ Tendsto width atTop (𝓝 0) ∧
      (∀ k, (steps k : ℝ) * timeStep k = horizon) ∧
      (∃ C : ℝ, 0 < C ∧ ∀ᶠ k in atTop, timeStep k ≤ C * width k ^ 2) ∧
      numericalLimitingDomain
        (fun k => leveque04_diffusionCellAverageNumericalDomain observation
          (timeStep k) (width k)
          (leveque04_diffusionRefinementExactFaces conductivity observation (width k))
          (steps k)) = univ)

end NumStability
