import ComputationalMathematics.HDP.Vector.SignRecovery

/-!
# Relabeling binary threshold error counts

Relabeling vertices, community labels and score values together preserves the
exact threshold error count. The transport includes empty carriers and zero
scores under the existing nonpositive-side convention.
-/

namespace NumStability.HDP.Vector.SignRecovery

/-- Transport the exact zero-threshold error count along label- and
score-preserving vertex equivalences, including zero scores. -/
theorem card_binaryThresholdMisclassifications_eq_of_equiv {n m : ℕ}
    (community : Fin n → Fin 2) (relabeled : Fin m → Fin 2) (e : Fin n ≃ Fin m)
    (hc : ∀ i, relabeled (e i) = community i) (v : Fin n → ℝ) (w : Fin m → ℝ)
    (hw : ∀ i, w (e i) = v i) :
    (binaryThresholdMisclassifications community v).card =
      (binaryThresholdMisclassifications relabeled w).card := by
  apply Finset.card_equiv e
  intro i
  simp [binaryThresholdMisclassifications, hc, hw]

end NumStability.HDP.Vector.SignRecovery
