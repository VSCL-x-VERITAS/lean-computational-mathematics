/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.NonlinearMaxwellPositiveSlopeTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.StationaryAcousticsStrictHyperbolicity

/-!
# Local hyperbolicity for positive nonlinear constitutive slopes

This reuses the real-eigenbasis result for the two-state acoustics matrix.
The claim concerns the frozen transverse plane-wave symbol, not the full
nonlinear three-dimensional PDE.
-/

namespace NumStability.Leveque02Tracer

/-- Positive differential constitutive responses make the two-state frozen
Maxwell plane-wave symbol real hyperbolic. -/
theorem nonlinearMaxwellPositiveSlope :
    nonlinearMaxwellPositiveSlopeTarget := by
  intro permittivity permeability electricField magneticField helectric hmagnetic
  have helectricInv :
      0 < (electricConstitutiveSlope permittivity electricField)⁻¹ :=
    inv_pos.mpr helectric
  obtain ⟨_, _, _, _, hhyperbolic⟩ :=
    stationaryAcousticsStrictHyperbolicity
      (electricConstitutiveSlope permittivity electricField)⁻¹
      (magneticConstitutiveSlope permeability magneticField)
      helectricInv hmagnetic
  simpa [frozenNonlinearMaxwellMatrix, linearAcousticsMatrix] using hhyperbolic

end NumStability.Leveque02Tracer
