/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FourierTemperatureGradientTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.FickFluxDensityGradientTarget

/-! Fourier heat carries internal energy by a temperature gradient; Fick diffusion carries tracer mass by a concentration gradient. -/

namespace NumStability.Leveque02Tracer

inductive CarrierKind where
  | heatEnergy
  | tracerMass
  deriving DecidableEq

/-- Density and signed rightward flux indexed by their physical carrier. -/
structure CarrierState (kind : CarrierKind) where
  density : ℝ
  flux : ℝ

/-- Temperature, capacity, and thermal conductivity of a heat material. -/
structure HeatMaterial where
  temperature : ℝ → ℝ → ℝ
  capacity : ℝ → ℝ
  conductivity : ℝ → ℝ

/-- Tracer mass density and diffusion coefficient. -/
structure TracerMaterial where
  concentration : ℝ → ℝ → ℝ
  diffusivity : ℝ → ℝ

/-- Energy density and Fourier energy flux at a point. -/
noncomputable def heatCarrierAt (h : HeatMaterial) (x t : ℝ) :
    CarrierState .heatEnergy :=
  ⟨thermalEnergyDensity h.capacity h.temperature x t,
    fourierHeatFlux (h.conductivity x)
      (deriv (fun ξ => h.temperature ξ t) x)⟩

/-- Tracer mass density and Fick mass flux at a point. -/
noncomputable def tracerCarrierAt (m : TracerMaterial) (x t : ℝ) :
    CarrierState .tracerMass :=
  ⟨m.concentration x t,
    fickFlux (m.diffusivity x)
      (deriv (fun ξ => m.concentration ξ t) x)⟩

/-- Proof-free paired constitutive target. The two carrier indices are part
of the proposition through `heatCarrierAt` and `tracerCarrierAt`; numeric
temperature and concentration fields are allowed to coincide. -/
def fourierFickCarrierTarget : Prop :=
  ∀ (h : HeatMaterial) (m : TracerMaterial)
    (x t temperatureGradient concentrationGradient : ℝ),
    HasDerivAt (fun ξ => h.temperature ξ t) temperatureGradient x →
    HasDerivAt (fun ξ => m.concentration ξ t) concentrationGradient x →
    (heatCarrierAt h x t).density =
        h.capacity x * h.temperature x t ∧
    (heatCarrierAt h x t).flux =
        -(h.conductivity x * temperatureGradient) ∧
    (tracerCarrierAt m x t).density = m.concentration x t ∧
    (tracerCarrierAt m x t).flux =
        -(m.diffusivity x * concentrationGradient)

end NumStability.Leveque02Tracer
