import ComputationalMathematics.HDP.Vector.SignRecovery

namespace NumStability.HDP.Verification

def SignPositiveScalingClosedTarget : Prop :=
  ∀ (n : ℕ) (community : Fin n → Fin 2) (v : Fin n → ℝ)
    (a : ℝ), 0 < a →
    NumStability.HDP.Vector.SignRecovery.binaryThresholdMisclassifications
      community (a • v) =
    NumStability.HDP.Vector.SignRecovery.binaryThresholdMisclassifications
      community v

end NumStability.HDP.Verification
