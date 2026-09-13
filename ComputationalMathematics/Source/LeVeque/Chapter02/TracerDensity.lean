/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.TracerDensityTarget

/-!
# Linear tracer density in LeVeque Chapter 2

The correspondence records the conversion from volumetric tracer density to
mass per unit pipe length, on nonnegative physical inputs. The source gives
this convention immediately before equation (2.1).
-/

namespace NumStability.Leveque02Tracer

/-- Multiplication by cross-sectional area gives linear tracer density. -/
theorem densityDefinition : densityDefinitionTarget := by
  intro volumetricDensity area x t hdensity harea
  rfl

end NumStability.Leveque02Tracer
