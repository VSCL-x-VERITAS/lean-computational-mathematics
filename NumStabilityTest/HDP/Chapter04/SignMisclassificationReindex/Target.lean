import ComputationalMathematics.HDP.Vector.SignRecovery

namespace NumStability.HDP.Verification

def SignMisclassificationReindexClosedTarget : Prop :=
  ∀ (n m : ℕ) (community : Fin n → Fin 2) (relabeled : Fin m → Fin 2)
    (e : Fin n ≃ Fin m),
    (∀ i, relabeled (e i) = community i) →
    ∀ (v : Fin n → ℝ) (w : Fin m → ℝ),
      (∀ i, w (e i) = v i) →
      (NumStability.HDP.Vector.SignRecovery.binaryThresholdMisclassifications community v).card =
        (NumStability.HDP.Vector.SignRecovery.binaryThresholdMisclassifications relabeled w).card

end NumStability.HDP.Verification
