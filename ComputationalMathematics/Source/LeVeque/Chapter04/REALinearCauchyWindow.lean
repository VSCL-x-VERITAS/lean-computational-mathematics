/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BilateralRiemannChainMap
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BilateralRiemannChainSelection
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearCharacteristicCoordinates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannChainEvolution
import ComputationalMathematics.Source.LeVeque.Chapter04.REAActiveLinearEvolution
import ComputationalMathematics.Source.LeVeque.Chapter04.REAUniformReconstruction

/-!
# Characteristic identification of a finite linear Riemann window

Characteristic coordinates telescope independently in the bilateral assembly.
Consequently any compatible finite window of the actual linear Riemann fields
equals characteristic evolution of the reconstructed cell data, including
the left-continuous representative at wave fronts.
-/

namespace NumStability

/-- A compatible finite window of the actual linear Riemann fields equals
the independent characteristic Cauchy field, without a spectral-width CFL
assumption. -/
theorem leveque04_linearRiemannWindow_eq_characteristicCauchy
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (states : ℤ → Fin m → ℝ)
    (origin width : ℝ) (hwidth : 0 < width) (x time : ℝ)
    (hfinite : ∃ radius, IsRiemannChainWindow states
      (fun j => linearRiemannSolution basis speeds (states j) (states j)
        (states (j + 1)) (x - (origin + (j : ℝ) * width)) time) radius) :
    bilateralRiemannChainAssembly states
      (fun j => linearRiemannSolution basis speeds (states j) (states j)
        (states (j + 1)) (x - (origin + (j : ℝ) * width)) time) hfinite =
      linearCharacteristicEvolution basis speeds
        (leveque04_uniformReconstruction origin width states) x time := by
  classical
  apply basis.equivFun.injective
  funext p
  let f : (Fin m → ℝ) →+ ℝ :=
    ((LinearMap.proj p).comp basis.equivFun.toLinearMap).toAddMonoidHom
  let profiles := fun j => linearRiemannSolution basis speeds (states j) (states j)
    (states (j + 1)) (x - (origin + (j : ℝ) * width)) time
  have hmapped : ∃ radius,
      IsRiemannChainWindow (fun j => f (states j)) (fun j => f (profiles j)) radius := by
    obtain ⟨radius, hradius⟩ := hfinite
    exact ⟨radius, hradius.map f⟩
  change f (bilateralRiemannChainAssembly states profiles hfinite) = _
  rw [bilateralRiemannChainAssembly_map states profiles f hfinite hmapped,
    linearCharacteristicEvolution_coordinate]
  let cell : ℤ := ⌈(x - speeds p * time - origin) / width⌉
  have hcell : (cell : ℝ) - 1 < (x - speeds p * time - origin) / width ∧
      (x - speeds p * time - origin) / width ≤ (cell : ℝ) :=
    Int.ceil_eq_iff.mp rfl
  have hleft := (lt_div_iff₀ hwidth).mp hcell.1
  have hright := (div_le_iff₀ hwidth).mp hcell.2
  have hbefore : ∀ j < cell, f (profiles j) = f (states (j + 1)) := by
    intro j hj
    have hjcast : (j : ℝ) ≤ (cell : ℝ) - 1 := by
      exact_mod_cast (show j ≤ cell - 1 by omega)
    have hfoot : 0 < x - (origin + (j : ℝ) * width) - speeds p * time := by
      have := mul_le_mul_of_nonneg_right hjcast hwidth.le
      linarith
    change basis.equivFun (linearRiemannSolution basis speeds _ _ _ _ _) p = _
    rw [linearRiemannSolution_coordinate]
    simp only [riemannData, if_neg (not_lt_of_gt hfoot), if_pos hfoot]
    rfl
  have hafter : ∀ j, cell ≤ j → f (profiles j) = f (states j) := by
    intro j hj
    have hjcast : (cell : ℝ) ≤ (j : ℝ) := by exact_mod_cast hj
    have hfoot : x - (origin + (j : ℝ) * width) - speeds p * time ≤ 0 := by
      have := mul_le_mul_of_nonneg_right hjcast hwidth.le
      linarith
    change basis.equivFun (linearRiemannSolution basis speeds _ _ _ _ _) p = _
    rw [linearRiemannSolution_coordinate]
    by_cases hstrict : x - (origin + (j : ℝ) * width) - speeds p * time < 0
    · simp [riemannData, hstrict, f]
    · have hzero : x - (origin + (j : ℝ) * width) - speeds p * time = 0 := by
        linarith
      simp [riemannData, hzero, f]
  rw [bilateralRiemannChainAssembly_eq_state _ _ hmapped cell hbefore hafter]
  rfl

/-- The active-front constructor is exactly the characteristic Cauchy field
on its entire closed step, with no restriction on inactive modes. -/
theorem leveque04_linearREAActiveEvolution_eq_characteristicCauchy
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (states : ℤ → Fin m → ℝ)
    (leftSpeed rightSpeed : ℤ → ℝ) (origin width bound step : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hstep : 0 ≤ step)
    (hfronts : ∀ j, -bound ≤ leftSpeed j ∧ leftSpeed j ≤ rightSpeed j ∧
      rightSpeed j ≤ bound)
    (hactive : ∀ j p,
      basis.equivFun (states j) p ≠ basis.equivFun (states (j + 1)) p →
        leftSpeed j ≤ speeds p ∧ speeds p ≤ rightSpeed j)
    (hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + rightSpeed j * step ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * step)
    (x time : ℝ) (htime : time ∈ Set.Icc 0 step) :
    leveque04_linearREAActiveEvolution basis speeds states leftSpeed rightSpeed
      origin width bound step hwidth hbound hstep hfronts hactive hinteraction x time =
      linearCharacteristicEvolution basis speeds
        (leveque04_uniformReconstruction origin width states) x time := by
  unfold leveque04_linearREAActiveEvolution leveque04_reaBoundedEvolution
  simp only [bilateralRiemannChainEvolution, dif_pos htime]
  exact leveque04_linearRiemannWindow_eq_characteristicCauchy
    basis speeds states origin width hwidth x time _

/-- Linear superposition identifies the actual bilateral Riemann assembly
with the Cauchy field even after waves overlap. -/
theorem leveque04_linearRiemannChainEvolution_eq_characteristicCauchy
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (states : ℤ → Fin m → ℝ)
    (origin width horizon : ℝ) (hwidth : 0 < width) (hhorizon : 0 ≤ horizon)
    (x time : ℝ) (htime : time ∈ Set.Icc 0 horizon) :
    linearRiemannChainEvolution basis speeds states origin width horizon
      hwidth hhorizon x time =
      linearCharacteristicEvolution basis speeds
        (leveque04_uniformReconstruction origin width states) x time := by
  unfold linearRiemannChainEvolution
  simp only [bilateralRiemannChainEvolution, dif_pos htime]
  exact leveque04_linearRiemannWindow_eq_characteristicCauchy
    basis speeds states origin width hwidth x time _

/-- Arbitrary cell data give a physical exact Cauchy field, identified with
the actual linear Riemann assembly on every closed forward horizon. -/
theorem leveque04_linearRiemannChain_exactCauchy
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (states : ℤ → Fin m → ℝ) (origin width horizon : ℝ)
    (hwidth : 0 < width) (hhorizon : 0 ≤ horizon) :
    let initial := leveque04_uniformReconstruction origin width states
    let exact := linearCharacteristicEvolution basis speeds initial
    (∀ x, exact x 0 = initial x) ∧
      IsRectangleConservationLawSolution exact coefficient.mulVec ∧
      ∀ time ∈ Set.Icc 0 horizon, ∀ x,
        linearRiemannChainEvolution basis speeds states origin width horizon
          hwidth hhorizon x time = exact x time := by
  dsimp only
  refine ⟨linearCharacteristicEvolution_initial basis speeds _, ?_, ?_⟩
  · apply linearCharacteristicEvolution_isRectangleSolution coefficient basis speeds heigen
    intro p a b
    exact leveque04_uniformReconstruction_intervalIntegrable
      origin width hwidth (fun j => basis.equivFun (states j) p) a b
  · intro time htime x
    exact leveque04_linearRiemannChainEvolution_eq_characteristicCauchy
      basis speeds states origin width horizon hwidth hhorizon x time htime

end NumStability
