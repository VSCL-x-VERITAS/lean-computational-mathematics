import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedFinSBM
import ComputationalMathematics.Source.Vershynin.Chapter04.Equation417LooplessFullCorrection.Q0IndexedGap

/-!
# Fin-indexed zero-crossing population spectrum

This ordinary foundation transports the residual eigenspace dimension through
the balanced vertex reindexing and identifies the first two ordered population
eigenvalues when the cross-community probability is zero. It does not classify
the printed Chapter 4 spectral-gap statement.
-/

noncomputable section

open Matrix
open NumStability.HDP.Graph NumStability.HDP.Graph.StochasticBlock

namespace NumStability.HDP.Contract

private theorem population_residual_finrank {k : ℕ} (hk : 0 < k)
    (θ : Parameters) (hpq : θ.q < θ.p) :
    Module.finrank ℝ (Module.End.eigenspace
      (BalancedFinSBM.population k θ.p θ.q).mulVecLin (-(θ.p : ℝ))) =
      2 * k - 2 := by
  classical
  let e : (Fin (2 * k) → ℝ) ≃ₗ[ℝ] (Vertex k → ℝ) :=
    LinearEquiv.piCongrLeft ℝ (fun _ : Vertex k => ℝ)
      (BalancedFinSBM.indexEquiv k).symm
  have hspace : Module.End.eigenspace
      (BalancedFinSBM.population k θ.p θ.q).mulVecLin (-(θ.p : ℝ)) =
      (Module.End.eigenspace
        (looplessExpectedAdjacency k θ.p θ.q).mulVecLin (-(θ.p : ℝ))).comap
          e.toLinearMap := by
    ext x
    simp only [Module.End.mem_eigenspace_iff, Submodule.mem_comap]
    have hex : e x = x ∘ BalancedFinSBM.indexEquiv k := by
      ext v
      simp [e, LinearEquiv.piCongrLeft, LinearEquiv.piCongrLeft',
        Equiv.piCongrLeft']
    simp only [Matrix.mulVecLin_apply]
    change (BalancedFinSBM.population k θ.p θ.q).mulVec x = -(θ.p : ℝ) • x ↔
      (looplessExpectedAdjacency k θ.p θ.q).mulVec
          (e x) =
        -(θ.p : ℝ) • (e x)
    rw [hex]
    have ht : (BalancedFinSBM.population k θ.p θ.q).mulVec x =
        ((looplessExpectedAdjacency k θ.p θ.q).mulVec
          (x ∘ BalancedFinSBM.indexEquiv k)) ∘
            (BalancedFinSBM.indexEquiv k).symm := by
      simpa [BalancedFinSBM.population, Function.comp_def] using
        BalancedFinSBM.reindex_mulVec
          (looplessExpectedAdjacency k θ.p θ.q)
          (x ∘ BalancedFinSBM.indexEquiv k)
    rw [ht]
    constructor
    · intro h
      funext v
      have hv := congrFun h (BalancedFinSBM.indexEquiv k v)
      simpa [Function.comp_def] using hv
    · intro h
      rw [h]
      funext i
      simp [Function.comp_def]
  rw [hspace, Submodule.comap_equiv_eq_map_symm, LinearEquiv.finrank_map_eq]
  rw [← stochasticBlock_mean_matrix_eq_loopless hk θ hpq]
  exact finrank_stochasticBlock_mean_residual_eigenspace hk θ hpq

def ordinary_q0_fin_ordered_top_eq_second_target : Prop :=
  ∀ {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters)
    (hpq : θ.q < θ.p), θ.q = 0 →
      NumStability.hermitianOrderedEigenvalue
          (BalancedFinSBM.population_hermitian k θ.p θ.q) ⟨0, by omega⟩ =
        NumStability.hermitianOrderedEigenvalue
          (BalancedFinSBM.population_hermitian k θ.p θ.q) ⟨1, by omega⟩

theorem ordinary_q0_fin_ordered_top_eq_second_candidate :
    ordinary_q0_fin_ordered_top_eq_second_target := by
  classical
  intro k hk θ hpq hq0
  let hD := BalancedFinSBM.population_hermitian k θ.p θ.q
  let f : Fin (2 * k) → ℝ := NumStability.hermitianOrderedEigenvalue hD
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
    have hv0 : (NumStability.hermitianOrderedEigenbasis hD i).ofLp ≠ 0 := by
      intro hz
      apply (NumStability.hermitianOrderedEigenbasis hD).orthonormal.ne_zero i
      apply WithLp.ofLp_injective 2
      exact hz
    have heig : (BalancedFinSBM.population k θ.p θ.q).mulVec
        (NumStability.hermitianOrderedEigenbasis hD i) =
        f i • NumStability.hermitianOrderedEigenbasis hD i := by
      have h := NumStability.hermitianOrderedEigenbasis_apply hD i
      simpa [f] using congrArg (EuclideanSpace.equiv (Fin (2 * k)) ℝ) h
    have hcases := BalancedFinSBM.population_eigenvalue_cases hk θ hpq hv0 heig
    simp only [hqR, add_zero, sub_zero] at hcases
    rcases hcases with h | h | h
    · exact Or.inl h
    · exact Or.inl h
    · exact Or.inr h
  have hanti : Antitone f :=
    (Matrix.isHermitian_iff_isSymmetric.mp hD).eigenvalues_antitone
      finrank_euclideanSpace_fin
  have hcount : (Finset.univ.filter fun i : Fin (2 * k) => f i = r).card =
      2 * k - 2 := by
    change Finset.card {i | (Matrix.isHermitian_iff_isSymmetric.mp hD).eigenvalues
      finrank_euclideanSpace_fin i = r} = _
    rw [NumStability.card_filter_symmetric_eigenvalues_eq_finrank,
      NumStability.finrank_eigenspace_toEuclideanLin_eq_mulVecLin]
    exact population_residual_finrank hk θ hpq
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

#print axioms ordinary_q0_fin_ordered_top_eq_second_candidate

end NumStability.HDP.Contract
