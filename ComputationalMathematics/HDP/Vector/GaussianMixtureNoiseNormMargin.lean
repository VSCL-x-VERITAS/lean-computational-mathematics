import ComputationalMathematics.HDP.Vector.GaussianMixtureClustering

/-!
# Deterministic norm-margin transfer through exceptional row-noise norms.

Ordinary finite/model-specific prerequisites with explicit hypotheses.
No printed sample commitment or author convention is selected.
-/

noncomputable section
open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal BigOperators

namespace NumStability.HDP.Vector.GaussianMixture

/-- Under an explicit norm-margin budget, every unstable sample point has
exceptionally large noise in its given signed-signal decomposition. -/
theorem directionUnstableIndices_subset_noise_norm_exceptional {m n : ℕ}
    (labels : Fin m → ℝ) (mean : Fin n → ℝ)
    (X Z : Fin m → Fin n → ℝ) (eta tau radius : ℝ)
    (hlabels : ∀ i, labels i = -1 ∨ labels i = 1)
    (hdecomposition : ∀ i, X i = labels i • mean + Z i)
    (heta : 0 ≤ eta)
    (hmargin : eta * (NumStability.vecNorm2 mean + radius) < tau) :
    directionUnstableIndices X eta tau ⊆
      {i | radius < NumStability.vecNorm2 (Z i)} := by
  intro i hi
  change tau ≤ eta * NumStability.vecNorm2 (X i) at hi
  by_contra hnot
  have hnoise : NumStability.vecNorm2 (Z i) ≤ radius := le_of_not_gt hnot
  have hsign : |labels i| = 1 := by
    rcases hlabels i with h | h <;> simp [h]
  have hpoint : NumStability.vecNorm2 (X i) ≤
      NumStability.vecNorm2 mean + radius := by
    calc
      _ = NumStability.vecNorm2 (fun j => labels i * mean j + Z i j) := by
        rw [hdecomposition i]
        rfl
      _ ≤ NumStability.vecNorm2 (fun j => labels i * mean j) +
          NumStability.vecNorm2 (Z i) := NumStability.vecNorm2_add_le _ _
      _ = NumStability.vecNorm2 mean + NumStability.vecNorm2 (Z i) := by
        rw [NumStability.vecNorm2_smul, hsign, one_mul]
      _ ≤ _ := add_le_add (le_refl _) hnoise
  exact (not_le_of_gt
    ((mul_le_mul_of_nonneg_left hpoint heta).trans_lt hmargin)) hi

/-- Existing norm-margin transfer gives a deterministic half-budget result
when only half the allowed sample indices have exceptional row-noise norms. -/
theorem makesAtMostErrorsUpToSign_of_margin_and_noise_norm {m n : ℕ}
    (labels : Fin m → ℝ) (mean v : Fin n → ℝ)
    (X Z : Fin m → Fin n → ℝ) (s eta tau epsilon radius : ℝ)
    (hs : s = -1 ∨ s = 1)
    (hlabels : ∀ i, labels i = -1 ∨ labels i = 1)
    (hdecomposition : ∀ i, X i = labels i • mean + Z i)
    (heta : 0 ≤ eta)
    (hdist : NumStability.vecNorm2 (mean - s • v) ≤ eta)
    (hmargin : eta * (NumStability.vecNorm2 mean + radius) < tau)
    (hideal : (Set.ncard (idealMarginErrors labels mean X tau) : ℝ) ≤ epsilon * m / 2)
    (hnoise : (Set.ncard {i | radius < NumStability.vecNorm2 (Z i)} : ℝ) ≤
      epsilon * m / 2) :
    MakesAtMostErrorsUpToSign labels v X (epsilon * m) := by
  have hsubset := directionUnstableIndices_subset_noise_norm_exceptional
    labels mean X Z eta tau radius hlabels hdecomposition heta hmargin
  have hcard := Set.ncard_le_ncard hsubset
  have hcardReal : (Set.ncard (directionUnstableIndices X eta tau) : ℝ) ≤
      (Set.ncard {i | radius < NumStability.vecNorm2 (Z i)} : ℝ) := by
    exact_mod_cast hcard
  exact makesAtMostErrorsUpToSign_of_margin_and_direction
    labels mean v X s eta tau epsilon hs hlabels hdist hideal (hcardReal.trans hnoise)

end NumStability.HDP.Vector.GaussianMixture
