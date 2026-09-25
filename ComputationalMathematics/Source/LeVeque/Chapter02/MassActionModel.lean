/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MassActionModelTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.ReactionMatrix

/-!
# LeVeque Chapter 2: MassActionModel

Mass-action reaction terms for transported dilute species.
-/

namespace NumStability.Leveque02Tracer

theorem massActionModel : massActionModelTarget := by
  intro m n velocity input output rateConstant _hm _hn _hrate
  constructor
  · exact (reactionMatrix m velocity).1
  · intro q spatialDerivative x t _hconcentration hspace
    exact (reactionMatrix m velocity).2
      q (massActionSource input output rateConstant) spatialDerivative x t hspace

#print axioms massActionModel

end NumStability.Leveque02Tracer
