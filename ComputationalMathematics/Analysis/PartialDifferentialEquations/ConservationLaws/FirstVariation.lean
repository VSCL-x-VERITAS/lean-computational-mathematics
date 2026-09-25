/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Slope
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.Calculus.Deriv.Comp
import Mathlib.Data.Matrix.Basic

/-!
# First variation of a conservation residual

For a constant background state and an affine amplitude family
`qε = q₀ + ε • v`, this module differentiates the *full* classical residual
`(qε)_t + (f(qε))_x` at zero amplitude. The hypotheses ask for actual space
and time derivatives of `v`, a flux derivative along nearby amplitude states,
and continuity of its action on the spatial derivative. These assumptions are
local at the chosen space-time point and do not assume the linearized PDE.
-/

open Filter

namespace NumStability

/-- The actual classical conservation residual of an affine amplitude family. -/
noncomputable def amplitudeConservationResidual {m : ℕ}
    (background : Fin m → ℝ) (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (variation : ℝ → ℝ → (Fin m → ℝ)) (x t ε : ℝ) : Fin m → ℝ :=
  deriv (fun τ => background + ε • variation x τ) t +
    deriv (fun ξ => flux (background + ε • variation ξ t)) x

private theorem hasDerivAt_id_smul_of_continuousAt
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (g : ℝ → E) (hg : ContinuousAt g 0) :
    HasDerivAt (fun ε : ℝ => ε • g ε) (g 0) 0 := by
  rw [hasDerivAt_iff_tendsto_slope_zero]
  have heq :
      (fun ε : ℝ => ε⁻¹ • ((ε • g ε) - (0 : ℝ) • g 0))
        =ᶠ[nhdsWithin (0 : ℝ) {0}ᶜ] g := by
    filter_upwards [self_mem_nhdsWithin] with ε hε
    simp [inv_smul_smul₀ hε]
  simpa only [zero_add] using
    (hg.tendsto.mono_left nhdsWithin_le_nhds).congr' heq.symm

/-- The amplitude derivative of the actual nonlinear residual equals the
time derivative of the variation plus the background flux derivative applied
to its spatial derivative. -/
theorem amplitudeConservationResidual_hasDerivAt
    {m : ℕ} (background : Fin m → ℝ)
    (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (fluxDerivative : (Fin m → ℝ) → ((Fin m → ℝ) →L[ℝ] (Fin m → ℝ)))
    (variation : ℝ → ℝ → (Fin m → ℝ)) (x t : ℝ)
    (variationTime variationSpace : Fin m → ℝ)
    (htime : HasDerivAt (variation x) variationTime t)
    (hspace : HasDerivAt (fun ξ => variation ξ t) variationSpace x)
    (hcontinuous : ContinuousAt
      (fun ε : ℝ => fluxDerivative
        (background + ε • variation x t) variationSpace) 0)
    (hflux : ∀ᶠ ε : ℝ in nhds (0 : ℝ),
      HasFDerivAt flux (fluxDerivative
        (background + ε • variation x t))
        (background + ε • variation x t)) :
    HasDerivAt
      (amplitudeConservationResidual background flux variation x t)
      (variationTime + fluxDerivative background variationSpace) 0 := by
  let G : ℝ → (Fin m → ℝ) := fun ε =>
    variationTime + fluxDerivative
      (background + ε • variation x t) variationSpace
  have hG : ContinuousAt G 0 := continuousAt_const.add hcontinuous
  have hmain : HasDerivAt (fun ε : ℝ => ε • G ε)
      (variationTime + fluxDerivative background variationSpace) 0 := by
    simpa only [G, zero_smul, add_zero] using
      hasDerivAt_id_smul_of_continuousAt G hG
  apply hmain.congr_of_eventuallyEq
  filter_upwards [hflux] with ε hfluxε
  have htimeε : HasDerivAt
      (fun τ => background + ε • variation x τ)
      (ε • variationTime) t :=
    (htime.const_smul ε).const_add background
  have hspaceε : HasDerivAt
      (fun ξ => background + ε • variation ξ t)
      (ε • variationSpace) x :=
    (hspace.const_smul ε).const_add background
  have hfluxSpace : HasDerivAt
      (fun ξ => flux (background + ε • variation ξ t))
      (fluxDerivative (background + ε • variation x t)
        (ε • variationSpace)) x := by
    simpa only [Function.comp_def] using
      hfluxε.comp_hasDerivAt x hspaceε
  simp only [amplitudeConservationResidual, G, htimeε.deriv,
    hfluxSpace.deriv, map_smul, smul_add]

/-- The linearized equation is exactly the condition that the first
variation of the nonlinear residual vanish. -/
theorem amplitudeConservationResidual_zeroVariation_iff
    {m : ℕ} (background : Fin m → ℝ)
    (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (fluxDerivative : (Fin m → ℝ) → ((Fin m → ℝ) →L[ℝ] (Fin m → ℝ)))
    (variation : ℝ → ℝ → (Fin m → ℝ)) (x t : ℝ)
    (variationTime variationSpace : Fin m → ℝ)
    (htime : HasDerivAt (variation x) variationTime t)
    (hspace : HasDerivAt (fun ξ => variation ξ t) variationSpace x)
    (hcontinuous : ContinuousAt
      (fun ε : ℝ => fluxDerivative
        (background + ε • variation x t) variationSpace) 0)
    (hflux : ∀ᶠ ε : ℝ in nhds (0 : ℝ),
      HasFDerivAt flux (fluxDerivative
        (background + ε • variation x t))
        (background + ε • variation x t)) :
    HasDerivAt (amplitudeConservationResidual background flux variation x t)
      0 0 ↔
      variationTime + fluxDerivative background variationSpace = 0 := by
  have h := amplitudeConservationResidual_hasDerivAt
    background flux fluxDerivative variation x t
    variationTime variationSpace htime hspace hcontinuous hflux
  constructor
  · intro hzero
    exact (hzero.unique h).symm
  · intro hzero
    simpa only [hzero] using h

end NumStability
