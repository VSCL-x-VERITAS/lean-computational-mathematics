/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Normed.Lp.BoundedRealMultiplier
import ComputationalMathematics.Analysis.InnerProductSpace.DissipativeCrankNicolson

/-!
# Weighted divergence-form diffusion on square-summable sequences

An isometric shift and its genuine inverse define discrete gradient and
divergence operators. Bounded nonnegative face coefficients yield dissipation
of the actual composed operator, and hence unconditional Hilbert-space
Crank–Nicolson solvability and perturbation contraction.
-/

open scoped InnerProductSpace

namespace NumStability
noncomputable section

/-- Divergence of the weighted backward difference, scaled by the physical
mesh width. The backward shift is the inverse of the supplied isometry. -/
def weightedL2Diffusion {ι : Type*}
    (shift : lp (fun _ : ι => ℝ) 2 ≃ₗᵢ[ℝ] lp (fun _ : ι => ℝ) 2)
    (b : ι → ℝ) (C : ℝ) (hC : 0 ≤ C) (hb : ∀ i, |b i| ≤ C) (width : ℝ) :
    lp (fun _ : ι => ℝ) 2 →L[ℝ] lp (fun _ : ι => ℝ) 2 :=
  (width ^ 2)⁻¹ •
    ((shift.toContinuousLinearEquiv.toContinuousLinearMap - ContinuousLinearMap.id ℝ _).comp
      ((l2BoundedRealMultiplier b C hC hb).comp
        (ContinuousLinearMap.id ℝ _ - shift.symm.toContinuousLinearEquiv.toContinuousLinearMap)))

/-- The actual divergence-form operator is dissipative; no desired energy
inequality is assumed as a premise. -/
theorem weightedL2Diffusion_dissipative {ι : Type*}
    (shift : lp (fun _ : ι => ℝ) 2 ≃ₗᵢ[ℝ] lp (fun _ : ι => ℝ) 2)
    (b : ι → ℝ) (C : ℝ) (hC : 0 ≤ C) (hb : ∀ i, |b i| ≤ C)
    (hpos : ∀ i, 0 ≤ b i) (width : ℝ) (u : lp (fun _ : ι => ℝ) 2) :
    ⟪weightedL2Diffusion shift b C hC hb width u, u⟫_ℝ ≤ 0 := by
  let gradient := u - shift.symm u
  let flux := l2BoundedRealMultiplier b C hC hb gradient
  have hdiv : ⟪shift flux - flux, u⟫_ℝ = -⟪flux, gradient⟫_ℝ := by
    rw [inner_sub_left, shift.inner_map_eq_flip]
    dsimp only [gradient]
    rw [inner_sub_right]
    ring
  have hflux : 0 ≤ ⟪flux, gradient⟫_ℝ :=
    l2BoundedRealMultiplier_inner_nonneg b C hC hb hpos gradient
  change ⟪(width ^ 2)⁻¹ • (shift flux - flux), u⟫_ℝ ≤ 0
  rw [real_inner_smul_left, hdiv]
  exact mul_nonpos_of_nonneg_of_nonpos (inv_nonneg.mpr (sq_nonneg width)) (neg_nonpos.mpr hflux)

/-- The actual weighted shift diffusion CN equation has a unique square-summable
solution for every nonnegative time step. -/
theorem weightedL2Diffusion_crankNicolson_existsUnique {ι : Type*}
    (shift : lp (fun _ : ι => ℝ) 2 ≃ₗᵢ[ℝ] lp (fun _ : ι => ℝ) 2)
    (b : ι → ℝ) (C : ℝ) (hC : 0 ≤ C) (hb : ∀ i, |b i| ≤ C)
    (hpos : ∀ i, 0 ≤ b i) (width : ℝ)
    (before : lp (fun _ : ι => ℝ) 2) (timeStep : ℝ) (htime : 0 ≤ timeStep) :
    ∃! after : lp (fun _ : ι => ℝ) 2,
      after - before = (timeStep / 2) •
        weightedL2Diffusion shift b C hC hb width (after + before) :=
  dissipative_crankNicolson_existsUnique
    (weightedL2Diffusion shift b C hC hb width)
    (weightedL2Diffusion_dissipative shift b C hC hb hpos width) before timeStep htime

/-- Two actual CN solutions contract perturbations, without an upper step bound. -/
theorem weightedL2Diffusion_crankNicolson_norm_sub_le {ι : Type*}
    (shift : lp (fun _ : ι => ℝ) 2 ≃ₗᵢ[ℝ] lp (fun _ : ι => ℝ) 2)
    (b : ι → ℝ) (C : ℝ) (hC : 0 ≤ C) (hb : ∀ i, |b i| ≤ C)
    (hpos : ∀ i, 0 ≤ b i) (width : ℝ)
    (before₁ after₁ before₂ after₂ : lp (fun _ : ι => ℝ) 2)
    (timeStep : ℝ) (htime : 0 ≤ timeStep)
    (hstep₁ : after₁ - before₁ = (timeStep / 2) •
      weightedL2Diffusion shift b C hC hb width (after₁ + before₁))
    (hstep₂ : after₂ - before₂ = (timeStep / 2) •
      weightedL2Diffusion shift b C hC hb width (after₂ + before₂)) :
    ‖after₁ - after₂‖ ≤ ‖before₁ - before₂‖ := by
  let L := weightedL2Diffusion shift b C hC hb width
  apply dissipative_crankNicolson_contracts L.toLinearMap
    (before₁ - before₂) (after₁ - after₂) timeStep htime
    (weightedL2Diffusion_dissipative shift b C hC hb hpos width)
  have hsub := congrArg₂ (fun x y => x - y) hstep₁ hstep₂
  have heq : (after₁ - after₂) + (before₁ - before₂) =
      (after₁ + before₁) - (after₂ + before₂) := by abel
  rw [heq, map_sub, smul_sub]
  calc
    _ = (after₁ - before₁) - (after₂ - before₂) := by abel
    _ = _ := hsub

end
end NumStability
