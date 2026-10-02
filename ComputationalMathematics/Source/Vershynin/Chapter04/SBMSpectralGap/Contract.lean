import ComputationalMathematics.Source.Vershynin.Chapter04.Equation417LooplessFullCorrection.Contract
import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedFinSBM

/-!
# Vershynin Chapter 4, stochastic-block spectral gap
-/

namespace NumStability.HDP.Contract

private abbrev SBMVertex (k : ℕ) :=
  NumStability.HDP.Graph.StochasticBlock.Vertex k

/-- For the inherited loopless expectation, subtracting `pI` shifts every
eigenvalue by `-p` and hence preserves all spectral gaps.  For total size
`n=2k`, the second signal eigenvalue is separated both from the shifted null
eigenspace and from the first eigenvalue by the source scale
`min((p-q)/2,q)n`. -/
theorem hdp_04_sbm_spectral_gap_arithmetic_decomposition
    {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hpq : θ.q < θ.p) :
    min
        (((k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p) - (-(θ.p : ℝ)))
        (((k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p) -
          ((k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p)) =
      min (((θ.p : ℝ) - θ.q) / 2) θ.q * ((2 * k : ℕ) : ℝ) ∧
    (0 < min (((θ.p : ℝ) - θ.q) / 2) θ.q * ((2 * k : ℕ) : ℝ) ↔
      0 < (θ.q : ℝ)) ∧
    (looplessExpectedAdjacency k θ.p θ.q).mulVec
        (NumStability.HDP.Graph.StochasticBlock.communitySign k) =
      (((k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p) •
        NumStability.HDP.Graph.StochasticBlock.communitySign k) ∧
    (∀ x : SBMVertex k → ℝ,
      ∃ a b : ℝ, ∃ y : SBMVertex k → ℝ,
        x = a • NumStability.HDP.Graph.StochasticBlock.allOnes k +
            b • NumStability.HDP.Graph.StochasticBlock.communitySign k + y ∧
          (∀ c : Fin 2, ∑ t : Fin k, y (c, t) = 0) ∧
          (looplessExpectedAdjacency k θ.p θ.q).mulVec y =
            (-(θ.p : ℝ)) • y) := by
  refine ⟨?_, ?_, (hdp_04_equation_4_17_corrected hk θ hpq).2, ?_⟩
  · have hk0 : (0 : ℝ) ≤ ((2 * k : ℕ) : ℝ) := by positivity
    rw [min_mul_of_nonneg _ _ hk0]
    congr 1
    · push_cast
      ring
    · have hcast : (((2 * k : ℕ) : ℝ)) = 2 * (k : ℝ) := by
        norm_num
      rw [hcast]
      ring
  · have hdiff : 0 < ((θ.p : ℝ) - θ.q) / 2 := by
      have hpqR : (θ.q : ℝ) < θ.p := by exact_mod_cast hpq
      exact half_pos (sub_pos.mpr hpqR)
    have hn : (0 : ℝ) < ((2 * k : ℕ) : ℝ) := by positivity
    rw [mul_pos_iff_of_pos_right hn, lt_min_iff]
    exact and_iff_right hdiff
  · intro x
    obtain ⟨a, b, y, hxy, hy⟩ :=
      NumStability.HDP.Graph.StochasticBlock.exists_signal_complement_decomposition hk x
    refine ⟨a, b, y, hxy, hy, ?_⟩
    exact (hdp_04_equation_4_17_loopless_full_corrected hk θ hpq).2.2.2 y hy

/-- Vershynin, Sections 4.5.1--4.5.4, with the inherited no-loop convention
made explicit.  The exact balanced independent-Bernoulli law has population
matrix `D = E A`; its first two ordered eigenpairs are the shifted versions of
Equation (4.17).  When `k ≥ 2`, the displayed
`min ((p-q)/2) q * n` lower bound is attained and hence is the actual
separation of the second eigenvalue.  When `k = 1`, the bulk eigenspace is
absent and the only remaining spectral distance is `q n`, recorded in the
last conjunct. -/
theorem hdp_04_sbm_spectral_gap :
    ∀ {k : ℕ} (hk : 0 < k)
      (θ : NumStability.HDP.Graph.StochasticBlock.Parameters),
      0 < θ.q → θ.q < θ.p →
      let n := 2 * k
      let community := BalancedFinSBM.community k
      let P := NumStability.HDP.Graph.FinStochasticBlock.measure community θ
      let A : (NumStability.HDP.Graph.FinStochasticBlock.UpperPair n → Bool) →
          Matrix (Fin n) (Fin n) ℝ :=
        NumStability.HDP.Graph.FinStochasticBlock.adjacency
      let hD := BalancedFinSBM.population_hermitian k θ.p θ.q
      (∀ i j : Fin n, (∫ ω, A ω i j ∂P) =
          BalancedFinSBM.population k θ.p θ.q i j) ∧
      (∀ ω i j, A ω i j = 0 ∨ A ω i j = 1) ∧
      (BalancedFinSBM.population k θ.p θ.q).mulVec
          (BalancedFinSBM.allOnes k) =
        (((k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p) •
          BalancedFinSBM.allOnes k) ∧
      (BalancedFinSBM.population k θ.p θ.q).mulVec
          (BalancedFinSBM.communitySign k) =
        (((k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p) •
          BalancedFinSBM.communitySign k) ∧
      NumStability.hermitianOrderedEigenvalue hD ⟨0, by omega⟩ =
        (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p ∧
      NumStability.hermitianOrderedEigenvalue hD ⟨1, by omega⟩ =
        (k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p ∧
      (∀ j : Fin n, j ≠ ⟨1, by omega⟩ →
        min (((θ.p : ℝ) - θ.q) / 2) θ.q * (n : ℝ) ≤
          |NumStability.hermitianOrderedEigenvalue hD ⟨1, by omega⟩ -
            NumStability.hermitianOrderedEigenvalue hD j|) ∧
      (2 ≤ k → ∃ j : Fin n, j ≠ ⟨1, by omega⟩ ∧
        |NumStability.hermitianOrderedEigenvalue hD ⟨1, by omega⟩ -
            NumStability.hermitianOrderedEigenvalue hD j| =
          min (((θ.p : ℝ) - θ.q) / 2) θ.q * (n : ℝ)) ∧
      (k = 1 → ∀ j : Fin n, j ≠ ⟨1, by omega⟩ →
        |NumStability.hermitianOrderedEigenvalue hD ⟨1, by omega⟩ -
            NumStability.hermitianOrderedEigenvalue hD j| =
          (θ.q : ℝ) * (n : ℝ)) := by
  intro k hk θ hq hpq
  dsimp only
  let n := 2 * k
  let community := BalancedFinSBM.community k
  let P := NumStability.HDP.Graph.FinStochasticBlock.measure community θ
  let A : (NumStability.HDP.Graph.FinStochasticBlock.UpperPair n → Bool) →
      Matrix (Fin n) (Fin n) ℝ :=
    NumStability.HDP.Graph.FinStochasticBlock.adjacency
  let hD := BalancedFinSBM.population_hermitian k θ.p θ.q
  let e0 : Fin n := ⟨0, by dsimp [n]; omega⟩
  let e1 : Fin n := ⟨1, by dsimp [n]; omega⟩
  have hqR : (0 : ℝ) < θ.q := by exact_mod_cast hq
  have hpqR : (θ.q : ℝ) < θ.p := by exact_mod_cast hpq
  have hzero : NumStability.hermitianOrderedEigenvalue hD e0 =
      (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p := by
    simpa [n, hD, e0] using
      BalancedFinSBM.orderedEigenvalue_zero_eq_top hk θ hq hpq
  have hone : NumStability.hermitianOrderedEigenvalue hD e1 =
      (k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p := by
    simpa [n, hD, e1] using
      BalancedFinSBM.orderedEigenvalue_one_eq_second hk θ hq hpq
  refine ⟨?_, ?_, ?_, ?_, hzero, hone, ?_, ?_, ?_⟩
  · intro i j
    simpa [n, community, P, A,
      BalancedFinSBM.expectedAdjacency_eq_population] using
      NumStability.HDP.Graph.FinStochasticBlock.adjacency_expectation
        (BalancedFinSBM.community k) θ i j
  · intro ω i j
    exact NumStability.HDP.Graph.FinStochasticBlock.adjacency_zero_or_one ω i j
  · exact BalancedFinSBM.population_mulVec_allOnes hk θ hpq
  · exact BalancedFinSBM.population_mulVec_communitySign hk θ hpq
  · intro j hj
    simpa [n, hD, e1] using
      BalancedFinSBM.population_second_eigengap hk θ hq hpq j hj
  · intro hk2
    let e2 : Fin n := ⟨2, by dsimp [n]; omega⟩
    have he12 : e1 ≤ e2 := by simp [e1, e2]
    have he2ne1 : e2 ≠ e1 := by simp [e1, e2]
    have hb2 : NumStability.hermitianOrderedEigenbasis hD e2 ≠ 0 :=
      (NumStability.hermitianOrderedEigenbasis hD).orthonormal.ne_zero e2
    have hb2raw :
        (NumStability.hermitianOrderedEigenbasis hD e2).ofLp ≠ 0 := by
      intro hraw
      apply hb2
      apply (EuclideanSpace.equiv (Fin n) ℝ).injective
      simpa using hraw
    have heig2 : (BalancedFinSBM.population k θ.p θ.q).mulVec
        (NumStability.hermitianOrderedEigenbasis hD e2) =
          NumStability.hermitianOrderedEigenvalue hD e2 •
            NumStability.hermitianOrderedEigenbasis hD e2 := by
      have h := NumStability.hermitianOrderedEigenbasis_apply hD e2
      simpa [n] using congrArg (EuclideanSpace.equiv (Fin n) ℝ) h
    have hcases := BalancedFinSBM.population_eigenvalue_cases hk θ hpq
      hb2raw heig2
    have htwo : NumStability.hermitianOrderedEigenvalue hD e2 =
        -(θ.p : ℝ) := by
      rcases hcases with htop | hsecond | hbottom
      · have hanti :=
          NumStability.hermitianOrderedEigenvalue_antitone hD he12
        rw [hone, htop] at hanti
        have hkR : (0 : ℝ) < k := by exact_mod_cast hk
        exfalso
        nlinarith [mul_pos hkR hqR]
      · exact (he2ne1 ((BalancedFinSBM.orderedEigenvalue_eq_second_iff
          hk θ hq hpq e2).mp hsecond)).elim
      · exact hbottom
    by_cases hbranch : (((θ.p : ℝ) - θ.q) / 2) ≤ θ.q
    · refine ⟨e2, he2ne1, ?_⟩
      rw [hone, htwo, min_eq_left hbranch, abs_of_nonneg]
      · push_cast
        ring
      · have hkR : (0 : ℝ) < k := by exact_mod_cast hk
        nlinarith [mul_pos hkR (sub_pos.mpr hpqR)]
    · have hqle : (θ.q : ℝ) ≤ ((θ.p : ℝ) - θ.q) / 2 :=
        le_of_not_ge hbranch
      refine ⟨e0, by simp [e0, e1], ?_⟩
      rw [hone, hzero, min_eq_right hqle, abs_of_nonpos]
      · push_cast
        ring
      · have hkR : (0 : ℝ) < k := by exact_mod_cast hk
        nlinarith [mul_pos hkR hqR]
  · intro hk1 j hj
    have hj0 : j = e0 := by
      apply Fin.ext
      have hjle : j.val ≤ 1 := by
        exact Nat.le_of_lt_succ (by simpa [n, hk1] using j.isLt)
      rcases Nat.le_one_iff_eq_zero_or_eq_one.mp hjle with hval | hval
      · simpa [e0] using hval
      · exfalso
        apply hj
        apply Fin.ext
        simpa [e1] using hval
    subst j
    rw [hone, hzero, abs_of_nonpos]
    · have hncast : (n : ℝ) = 2 * (k : ℝ) := by
        norm_num [n]
      rw [hncast]
      ring
    · have hkR : (0 : ℝ) < k := by exact_mod_cast hk
      nlinarith [mul_pos hkR hqR]

end NumStability.HDP.Contract
