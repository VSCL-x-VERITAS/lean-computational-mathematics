import ComputationalMathematics.Source.Vershynin.Chapter04.Equation417LooplessFullCorrection.ActualSpectrum

/-! UNVERIFIED ordinary proof candidate. No compiler has been invoked.
The target definition below is copied verbatim from the frozen target. -/

noncomputable section

open Matrix MeasureTheory
open NumStability.HDP.Graph NumStability.HDP.Graph.StochasticBlock

namespace NumStability.HDP.Contract

def ordinary_q0_ordered_top_eq_second_target : Prop :=
  ∀ {k : ℕ} (hk : 0 < k) (θ : Parameters) (hpq : θ.q < θ.p), θ.q = 0 →
    let A : Matrix (Vertex k) (Vertex k) ℝ := fun i j =>
      ∫ ω, stochasticBlockAdjacency ω i j ∂graphMeasure k θ
    let hT : A.toEuclideanLin.IsSymmetric :=
      Matrix.isHermitian_iff_isSymmetric.mp
        (stochasticBlock_mean_matrix_isHermitian hk θ hpq)
    let hn : Module.finrank ℝ (EuclideanSpace ℝ (Vertex k)) = 2 * k := by
      simp [Vertex]
    hT.eigenvalues hn ⟨0, by omega⟩ =
      hT.eigenvalues hn ⟨1, by omega⟩

theorem ordinary_q0_ordered_top_eq_second_candidate :
    ordinary_q0_ordered_top_eq_second_target := by
  classical
  intro k hk θ hpq hq0
  let A : Matrix (Vertex k) (Vertex k) ℝ := fun i j =>
    ∫ ω, stochasticBlockAdjacency ω i j ∂graphMeasure k θ
  let hT : A.toEuclideanLin.IsSymmetric :=
    Matrix.isHermitian_iff_isSymmetric.mp
      (stochasticBlock_mean_matrix_isHermitian hk θ hpq)
  let hn : Module.finrank ℝ (EuclideanSpace ℝ (Vertex k)) = 2 * k := by
    simp [Vertex]
  let f : Fin (2 * k) → ℝ := hT.eigenvalues hn
  let e0 : Fin (2 * k) := ⟨0, by omega⟩
  let e1 : Fin (2 * k) := ⟨1, by omega⟩
  change f e0 = f e1
  let a : ℝ := (k : ℝ) * (θ.p : ℝ) - θ.p
  let r : ℝ := -(θ.p : ℝ)
  have hkR : (0 : ℝ) < k := by exact_mod_cast hk
  have hp : 0 < θ.p := by simpa only [hq0] using hpq
  have hpR : (0 : ℝ) < θ.p := by exact_mod_cast hp
  have hqR : (θ.q : ℝ) = 0 := by exact_mod_cast hq0
  have hra : r < a := by
    dsimp only [r, a]
    linarith [mul_pos hkR hpR]
  have hf_cases (i : Fin (2 * k)) : f i = a ∨ f i = r := by
    have hv := hT.hasEigenvector_eigenvectorBasis hn i
    have hv0 : WithLp.ofLp (hT.eigenvectorBasis hn i) ≠ 0 := by
      intro hz
      apply hv.2
      apply WithLp.ofLp_injective 2
      exact hz
    have hmem : hT.eigenvectorBasis hn i ∈
        Module.End.eigenspace A.toEuclideanLin (f i) := hv.1
    rw [NumStability.eigenspace_toEuclideanLin_eq_comap] at hmem
    have hmemraw : WithLp.ofLp (hT.eigenvectorBasis hn i) ∈
        Module.End.eigenspace A.mulVecLin (f i) := hmem
    have heig : Module.End.HasEigenvalue A.mulVecLin (f i) :=
      Module.End.hasEigenvalue_of_hasEigenvector ⟨hmemraw, hv0⟩
    have hcases :=
      (stochasticBlock_mean_hasEigenvalue_iff hk θ hpq (f i)).mp heig
    simp only [hqR, add_zero, sub_zero] at hcases
    rcases hcases with h | h | ⟨h, _⟩
    · exact Or.inl h
    · exact Or.inl h
    · exact Or.inr h
  have hanti : Antitone f := hT.eigenvalues_antitone hn
  have hcount : (Finset.univ.filter fun i : Fin (2 * k) => f i = r).card =
      2 * k - 2 := stochasticBlock_mean_sorted_residual_count hk θ hpq
  have hsecond : f e1 = a := by
    rcases hf_cases e1 with ha | hr
    · exact ha
    · exfalso
      have hsubset : (Finset.univ : Finset (Fin (2 * k))).erase e0 ⊆
          Finset.univ.filter (fun i => f i = r) := by
        intro j hj
        have hne : j ≠ e0 := (Finset.mem_erase.mp hj).1
        have hjpos : 0 < j.val := by
          by_contra hnot
          have hz : j.val = 0 := by omega
          apply hne
          apply Fin.ext
          exact hz
        have hle : e1 ≤ j := by
          change 1 ≤ j.val
          omega
        have hfj : f j ≤ r := by simpa only [hr] using hanti hle
        have heq : f j = r := by
          rcases hf_cases j with ha | heq
          · exfalso
            rw [ha] at hfj
            exact (not_le_of_gt hra) hfj
          · exact heq
        exact Finset.mem_filter.mpr ⟨Finset.mem_univ j, heq⟩
      have hcard := Finset.card_le_card hsubset
      have herase : ((Finset.univ : Finset (Fin (2 * k))).erase e0).card =
          2 * k - 1 := by
        rw [Finset.card_erase_of_mem (Finset.mem_univ e0)]
        simp
      rw [herase, hcount] at hcard
      omega
  have hfirst : f e0 = a := by
    rcases hf_cases e0 with ha | hr
    · exact ha
    · have hle : e0 ≤ e1 := by
        change (0 : ℕ) ≤ 1
        omega
      have hbound := hanti hle
      rw [hsecond, hr] at hbound
      exact False.elim ((not_le_of_gt hra) hbound)
  exact hfirst.trans hsecond.symm

end NumStability.HDP.Contract
