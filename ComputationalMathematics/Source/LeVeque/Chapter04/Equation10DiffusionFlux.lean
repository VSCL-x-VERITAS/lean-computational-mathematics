/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FickFluxModel

/-!
# LeVeque Chapter 4, equation (4.10): centered diffusion flux

An interface indexed by `i` lies between cells `i - 1` and `i`. The supplied
interface coefficient represents the source's chosen approximation to the
physical diffusivity there; its accuracy is a separate question.
-/

namespace NumStability

/-- The proposed two-cell diffusion flux uses the Chapter 2 Fick law with a
centered difference quotient as its discrete gradient. -/
noncomputable def leveque04_diffusionInterfaceFlux
    (interfaceDiffusivity cellAverage : ℤ → ℝ) (cellWidth : ℝ) (i : ℤ) : ℝ :=
  Leveque02Tracer.fickFlux (interfaceDiffusivity i)
    ((cellAverage i - cellAverage (i - 1)) / cellWidth)

/-- The scheme class specified by (4.10) on a uniform positive-width grid. -/
def IsLeveque04DiffusionFlux
    (interfaceDiffusivity cellAverage : ℤ → ℝ) (cellWidth : ℝ)
    (interfaceFlux : ℤ → ℝ) : Prop :=
  0 < cellWidth ∧ ∀ i,
    interfaceFlux i =
      -(interfaceDiffusivity i *
        ((cellAverage i - cellAverage (i - 1)) / cellWidth))

/-- The discrete Fick-flux construction realizes exactly the displayed
interface formula (4.10). -/
theorem leveque04_equation10
    (interfaceDiffusivity cellAverage : ℤ → ℝ) (cellWidth : ℝ)
    (hwidth : 0 < cellWidth) :
    IsLeveque04DiffusionFlux interfaceDiffusivity cellAverage cellWidth
      (fun i => leveque04_diffusionInterfaceFlux
        interfaceDiffusivity cellAverage cellWidth i) := by
  refine ⟨hwidth, ?_⟩
  intro i
  rfl

end NumStability
