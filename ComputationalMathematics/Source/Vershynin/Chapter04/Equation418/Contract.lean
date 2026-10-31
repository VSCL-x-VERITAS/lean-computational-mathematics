import ComputationalMathematics.HDP.Matrix.SymmetricOperatorNormBounded

/-!
# Vershynin Chapter 4, Equation (4.18)

Source-facing contract for the stochastic-block noise estimate.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

/-- Vershynin, Equation (4.18), corrected to the loopless adjacency convention
imported from Definition 3.6.2.  The population matrix `D` has zero diagonal,
within-community off-diagonal entries `p`, and cross-community entries `q`.
For the true residual `A-D`, the source's independence, centering, symmetry,
and boundedness properties imply operator norm at most `C√n` except on an
event of probability at most `4 exp (-n)`. -/
theorem hdp_04_equation_4_18 :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
        [IsProbabilityMeasure P] {n : ℕ} (hn : 0 < n),
        letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
        ∀ (community : Fin n → Fin 2) (p q : ℝ)
          (D : Matrix (Fin n) (Fin n) ℝ)
          (A : Ω → Matrix (Fin n) (Fin n) ℝ),
        0 ≤ q → q < p → p ≤ 1 →
        (∀ i j, D i j =
          if i = j then 0
          else if community i = community j then p else q) →
        (∀ ω i j, (A ω - D) i j = (A ω - D) j i) →
        (∀ i j, Measurable (fun ω => (A ω - D) i j)) →
        (∀ ω i j, |(A ω - D) i j| ≤ 1) →
        (∀ ij : {ij : Fin n × Fin n // ij.1 ≤ ij.2},
          (∫ ω, (A ω - D) ij.1.1 ij.1.2 ∂P) = 0) →
        iIndepFun
          (fun ij : {ij : Fin n × Fin n // ij.1 ≤ ij.2} =>
            fun ω => (A ω - D) ij.1.1 ij.1.2) P →
        P.real {ω |
          C * Real.sqrt n <
            NumStability.realMatrixOperatorNorm (A ω - D)} ≤
            4 * Real.exp (-(n : ℝ)) := by
  rcases
      NumStability.HDP.Matrix.exists_symmetric_operatorNorm_sqrt_tail_of_independent_centered_bounded_entries with
    ⟨C, hC, htail⟩
  refine ⟨C, hC, ?_⟩
  intro Ω instΩ P instP n hn community p q D A _hq _hpq _hp _hD
    hSym hMeas hBound hMean hIndep
  exact htail hn (fun ω ↦ A ω - D) hSym hMeas hBound hMean hIndep

end NumStability.HDP.Contract
