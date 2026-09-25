/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellDivergenceModel
import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellFaradayModel

/-!
# Classical regularity for propagation of Maxwell divergence constraints

The paired derivative witnesses express the three mixed spatial partial
equalities needed for divergence of curl to vanish. They follow from ordinary
`C²` spatial regularity, which the chapter leaves implicit.
-/

namespace NumStability.Leveque02Tracer

/-- Three commuting pairs of mixed spatial derivatives in Cartesian curl. -/
def HasMaxwellMixedSpatialPartialsAt
    (field : MaxwellField) (position : MaxwellVector) (time : ℝ) : Prop :=
  ∃ a b c : ℝ,
    HasDerivAt
      (fun s => maxwellSpatialPartial field 2 1
        (Function.update position 0 s) time) a (position 0) ∧
    HasDerivAt
      (fun s => maxwellSpatialPartial field 2 0
        (Function.update position 1 s) time) a (position 1) ∧
    HasDerivAt
      (fun s => maxwellSpatialPartial field 1 2
        (Function.update position 0 s) time) b (position 0) ∧
    HasDerivAt
      (fun s => maxwellSpatialPartial field 1 0
        (Function.update position 2 s) time) b (position 2) ∧
    HasDerivAt
      (fun s => maxwellSpatialPartial field 0 2
        (Function.update position 1 s) time) c (position 1) ∧
    HasDerivAt
      (fun s => maxwellSpatialPartial field 0 1
        (Function.update position 2 s) time) c (position 2)

/-- The vector field of ordinary time partial derivatives. -/
noncomputable def maxwellTimeDerivativeField (field : MaxwellField) : MaxwellField :=
  fun position time component => maxwellTimePartial field component position time

/-- A scalar multiple of the Cartesian curl as a time-dependent field. -/
noncomputable def maxwellScaledCurlField
    (scale : ℝ) (field : MaxwellField) : MaxwellField :=
  fun position time component => scale * maxwellCurl field position time component

end NumStability.Leveque02Tracer
