import ComputationalMathematics.HDP.Scalar.IndependentSums.GraphDegreeDecoupling
import ComputationalMathematics.Source.Vershynin.Chapter02.Section04.Exercise04.Signature

/-!
# Exercise 2.4.4: sparse graphs are not almost regular

For an Erdős--Rényi graph whose expected degree is little-oh of `log n`, an
integer threshold equal to ten times that expected degree is eventually reached
by some vertex with probability at least `0.9`.
-/

noncomputable section

open MeasureTheory Filter
open scoped Topology

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.IndependentSums.Chernoff

/-- Exercise 2.4.4, printed page 22. -/
theorem hdp_02_hex_h2_d4_d4
    (p : ℕ → Set.Icc (0 : ℝ) 1) (k : ℕ → ℕ)
    (hrel : ∀ n, (k n : ℝ) =
      10 * ((n - 1 : ℕ) : ℝ) * (p n : ℝ))
    (hsmall : Tendsto
      (fun n => (k n : ℝ) / Real.log (n : ℝ)) atTop (𝓝 0)) :
    ∀ᶠ n in atTop,
      (erdosRenyiModel n (p n)).graphLaw.real {G |
        ∃ v : Fin n, k n ≤ (erdosRenyiModel n (p n)).degree v G} ≥
      (9 : ℝ) / 10 := by
  have h := erdosRenyiSparseExistsDegreeTenExpectedEventually p k hrel hsmall
  filter_upwards [h] with n hn
  change (SimpleGraph.binomialRandom (Fin n) (p n)).real {G |
    ∃ v : Fin n, k n ≤ (erdosRenyiModel n (p n)).degree v G} ≥ (9 : ℝ) / 10
  have hevent : {G : SimpleGraph (Fin n) |
      ∃ v : Fin n, k n ≤ (erdosRenyiModel n (p n)).degree v G} =
      {G : SimpleGraph (Fin n) | ∃ v : Fin n, k n ≤ graphDegreeSum v G} := by
    ext G
    simp only [Set.mem_setOf_eq]
    constructor
    · rintro ⟨v, hv⟩
      exact ⟨v, by simpa only [erdosRenyiModel_degree_eq_graphDegreeSum] using hv⟩
    · rintro ⟨v, hv⟩
      exact ⟨v, by simpa only [erdosRenyiModel_degree_eq_graphDegreeSum] using hv⟩
  rw [hevent]
  exact hn

/-- The implementation inhabits the frozen source-facing signature. -/
theorem hdp_02_hex_h2_d4_d4__contract :
    hdp_02_hex_h2_d4_d4__contract_type :=
  hdp_02_hex_h2_d4_d4

end NumStability.HDP.Contract
