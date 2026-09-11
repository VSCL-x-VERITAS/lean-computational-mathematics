import ComputationalMathematics.Source.Vershynin.Chapter02.Section04.Exercise05.Signature

/-!
# Exercise 2.4.5: discrepancy witness and corrected theorem

The printed `d = O(1)` hypothesis permits `p(n) = 0`, so its positive
maximum-degree lower bound is false.  The corrected theorem adds an eventual
positive lower bound on expected degree.
-/

noncomputable section

open MeasureTheory Filter
open scoped Topology

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.IndependentSums.Chernoff

/-- Exercise 2.4.5 source obstruction, printed pages 22--23. -/
theorem hdp_02_hex_h2_d4_d5_source_obstruction :
    hdp_02_hex_h2_d4_d5_source_obstruction__contract_type := by
  have h := erdosRenyiVerySparseDegreeLower_sourceObstruction
  refine ⟨h.1, ?_⟩
  rintro ⟨c, hc, hclaim⟩
  apply h.2
  refine ⟨c, hc, ?_⟩
  filter_upwards [hclaim] with n hn
  change (SimpleGraph.binomialRandom (Fin n) (0 : Set.Icc (0 : ℝ) 1)).real
    {G | ∃ v : Fin n,
      c * (Real.log (n : ℝ) / Real.log (Real.log (n : ℝ))) ≤
        (erdosRenyiModel n (0 : Set.Icc (0 : ℝ) 1)).degree v G} ≥
      (9 : ℝ) / 10 at hn
  have hevent :
      {G : SimpleGraph (Fin n) | ∃ v : Fin n,
        c * (Real.log (n : ℝ) / Real.log (Real.log (n : ℝ))) ≤
          (erdosRenyiModel n (0 : Set.Icc (0 : ℝ) 1)).degree v G} =
      {G | ∃ v : Fin n, c * logLogDegreeScale n ≤ graphDegreeSum v G} := by
    ext G
    simp only [Set.mem_setOf_eq, logLogDegreeScale]
    constructor
    · rintro ⟨v, hv⟩
      exact ⟨v, by simpa only [erdosRenyiModel_degree_eq_graphDegreeSum] using hv⟩
    · rintro ⟨v, hv⟩
      exact ⟨v, by simpa only [erdosRenyiModel_degree_eq_graphDegreeSum] using hv⟩
  rwa [hevent] at hn

/-- Exercise 2.4.5 corrected by a positive expected-degree lower bound. -/
theorem hdp_02_hex_h2_d4_d5_corrected
    (p : ℕ → Set.Icc (0 : ℝ) 1) (c C : ℝ) (hc : 0 < c)
    (hlower : ∀ᶠ n : ℕ in atTop,
      c ≤ ((n - 1 : ℕ) : ℝ) * (p n : ℝ))
    (hupper : ∀ᶠ n : ℕ in atTop,
      ((n - 1 : ℕ) : ℝ) * (p n : ℝ) ≤ C) :
    ∀ᶠ n : ℕ in atTop,
      (erdosRenyiModel n (p n)).graphLaw.real
          {G | ∃ v : Fin n,
            (Real.log (n : ℝ) / Real.log (Real.log (n : ℝ))) / 128 ≤
              (erdosRenyiModel n (p n)).degree v G} ≥
        (9 : ℝ) / 10 := by
  have h := erdosRenyiVerySparseExistsDegree_corrected p c C hc hlower hupper
  filter_upwards [h] with n hn
  change (SimpleGraph.binomialRandom (Fin n) (p n)).real
    {G | ∃ v : Fin n,
      (Real.log (n : ℝ) / Real.log (Real.log (n : ℝ))) / 128 ≤
        (erdosRenyiModel n (p n)).degree v G} ≥ (9 : ℝ) / 10
  have hevent :
      {G : SimpleGraph (Fin n) | ∃ v : Fin n,
        (Real.log (n : ℝ) / Real.log (Real.log (n : ℝ))) / 128 ≤
          (erdosRenyiModel n (p n)).degree v G} =
      {G | ∃ v : Fin n,
        logLogDegreeScale n / 128 ≤ graphDegreeSum v G} := by
    ext G
    simp only [Set.mem_setOf_eq, logLogDegreeScale]
    constructor
    · rintro ⟨v, hv⟩
      exact ⟨v, by simpa only [erdosRenyiModel_degree_eq_graphDegreeSum] using hv⟩
    · rintro ⟨v, hv⟩
      exact ⟨v, by simpa only [erdosRenyiModel_degree_eq_graphDegreeSum] using hv⟩
  rw [hevent]
  exact hn

theorem hdp_02_hex_h2_d4_d5_source_obstruction__contract :
    hdp_02_hex_h2_d4_d5_source_obstruction__contract_type :=
  hdp_02_hex_h2_d4_d5_source_obstruction

theorem hdp_02_hex_h2_d4_d5_corrected__contract :
    hdp_02_hex_h2_d4_d5_corrected__contract_type :=
  hdp_02_hex_h2_d4_d5_corrected

end NumStability.HDP.Contract
