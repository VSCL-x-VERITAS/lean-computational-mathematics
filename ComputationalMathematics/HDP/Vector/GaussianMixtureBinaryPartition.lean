import ComputationalMathematics.HDP.Vector.GaussianMixturePartitionRecovery

/-!
# Binary partition error and pair relations

Reusable mathematics transported from preserved runtime assets.
-/

noncomputable section

open Matrix Set

namespace NumStability.HDP.Vector.GaussianMixture

/-- Success of an arbitrary binary partition, compared against latent labels
using one global choice of the label represented by its first part. -/
def MakesAtMostBinaryPartitionErrorsUpToSwap {m : ℕ}
    (labels : Fin m → ℝ) (output : Fin m → Prop) (budget : ℝ) : Prop :=
  ∃ firstLabel : ℝ, (firstLabel = -1 ∨ firstLabel = 1) ∧
    (Set.ncard {i | ¬ (output i ↔ labels i = firstLabel)} : ℝ) ≤ budget

/-- Specializing a predicate output to the existing positive-score partition
recovers precisely its existing error predicate, including the score-zero
boundary. -/
theorem makesAtMostBinaryPartitionErrorsUpToSwap_pos_dotProduct_iff
    {m n : ℕ} (labels : Fin m → ℝ) (v : Fin n → ℝ)
    (X : Fin m → Fin n → ℝ) (budget : ℝ) :
    MakesAtMostBinaryPartitionErrorsUpToSwap labels
      (fun i ↦ 0 < dotProduct v (X i)) budget ↔
    MakesAtMostPartitionErrorsUpToSwap labels v X budget :=
  Iff.rfl

/-- Below one permitted error, an arbitrary binary partition preserves the
same-cluster relation at every pair of binary latent labels. Binary support is
required only at that pair. -/
theorem sameCluster_iff_labels_eq_of_binaryPartitionErrors_lt_one_at
    {m : ℕ} (labels : Fin m → ℝ) (output : Fin m → Prop)
    {budget : ℝ} (hbudget : budget < 1)
    (h : MakesAtMostBinaryPartitionErrorsUpToSwap labels output budget)
    (i j : Fin m) (hiLabel : labels i = -1 ∨ labels i = 1)
    (hjLabel : labels j = -1 ∨ labels j = 1) :
    (output i ↔ output j) ↔ labels i = labels j := by
  classical
  let v : Fin 1 → ℝ := fun _ ↦ 1
  let X : Fin m → Fin 1 → ℝ := fun k _ ↦ if output k then 1 else 0
  have hscore (k : Fin m) : (0 < dotProduct v (X k)) ↔ output k := by
    simp only [v, X, dotProduct, Fin.sum_univ_one, one_mul]
    by_cases hk : output k <;> simp [hk]
  have hdir : MakesAtMostPartitionErrorsUpToSwap labels v X budget := by
    simpa only [MakesAtMostPartitionErrorsUpToSwap,
      partitionMisclassifiedIndices, hscore,
      MakesAtMostBinaryPartitionErrorsUpToSwap] using h
  simpa only [hscore] using
    sameCluster_iff_labels_eq_of_partitionErrors_lt_one_at labels v X
      hbudget hdir i j hiLabel hjLabel

/-- All binary latent labels give the corresponding result for every pair. -/
theorem sameCluster_iff_labels_eq_of_binaryPartitionErrors_lt_one
    {m : ℕ} (labels : Fin m → ℝ) (output : Fin m → Prop)
    {budget : ℝ} (hlabels : ∀ i, labels i = -1 ∨ labels i = 1)
    (hbudget : budget < 1)
    (h : MakesAtMostBinaryPartitionErrorsUpToSwap labels output budget)
    (i j : Fin m) :
    (output i ↔ output j) ↔ labels i = labels j :=
  sameCluster_iff_labels_eq_of_binaryPartitionErrors_lt_one_at labels output
    hbudget h i j (hlabels i) (hlabels j)

end NumStability.HDP.Vector.GaussianMixture

end
