import ComputationalMathematics.Analysis.Eigenvalues.Multiplicity
import ComputationalMathematics.HDP.Graph.StochasticBlockSpectrum
import Mathlib.Analysis.Matrix.Hermitian
import ComputationalMathematics.HDP.Graph.CommunityZeroSumKernel
import ComputationalMathematics.Source.Vershynin.Chapter04.SBMLooplessCorrections.Contract


/-!
Ordinary composition of existing expectation and residual-eigenspace APIs.
The printed diagonal discrepancy and its source interpretation remain separately recorded.
-/

noncomputable section

open Matrix MeasureTheory
open NumStability.HDP.Graph NumStability.HDP.Graph.StochasticBlock

namespace NumStability.HDP.Contract

theorem stochasticBlock_mean_matrix_eq_loopless {k : ℕ} (hk : 0 < k)
    (θ : Parameters) (hpq : θ.q < θ.p) :
    (fun i j : Vertex k => ∫ ω, stochasticBlockAdjacency ω i j
      ∂graphMeasure k θ) = looplessExpectedAdjacency k θ.p θ.q := by
  funext i j
  exact (hdp_04_expected_adjacency_decomposition_corrected hk θ hpq).1 i j

theorem stochasticBlock_mean_residual_eigenspace {k : ℕ} (hk : 0 < k)
    (θ : Parameters) (hpq : θ.q < θ.p) :
    Module.End.eigenspace
      (Matrix.mulVecLin (fun i j : Vertex k => ∫ ω, stochasticBlockAdjacency ω i j
        ∂graphMeasure k θ)) (-(θ.p : ℝ)) =
      communityZeroSumSubspace k := by
  rw [stochasticBlock_mean_matrix_eq_loopless hk θ hpq,
    looplessExpectedAdjacency_eq_displayed_sub_diagonal]
  exact expectedAdjacency_sub_diagonal_eigenspace_eq_zero_sum hk
    θ.q.coe_nonneg hpq

theorem finrank_stochasticBlock_mean_residual_eigenspace {k : ℕ} (hk : 0 < k)
    (θ : Parameters) (hpq : θ.q < θ.p) :
    Module.finrank ℝ (Module.End.eigenspace
      (Matrix.mulVecLin (fun i j : Vertex k => ∫ ω, stochasticBlockAdjacency ω i j
        ∂graphMeasure k θ)) (-(θ.p : ℝ))) = 2 * k - 2 := by
  rw [stochasticBlock_mean_residual_eigenspace hk θ hpq]
  exact finrank_communityZeroSumSubspace hk

theorem stochasticBlock_mean_has_residual_eigenvalue_iff {k : ℕ} (hk : 0 < k)
    (θ : Parameters) (hpq : θ.q < θ.p) :
    Module.End.HasEigenvalue
      (Matrix.mulVecLin (fun i j : Vertex k => ∫ ω, stochasticBlockAdjacency ω i j
        ∂graphMeasure k θ)) (-(θ.p : ℝ)) ↔ 1 < k := by
  rw [stochasticBlock_mean_matrix_eq_loopless hk θ hpq,
    looplessExpectedAdjacency_eq_displayed_sub_diagonal]
  exact expectedAdjacency_sub_diagonal_has_residual_eigenvalue_iff hk
    θ.q.coe_nonneg hpq


end NumStability.HDP.Contract

namespace NumStability.HDP.Contract

open Matrix MeasureTheory
open NumStability.HDP.Graph NumStability.HDP.Graph.StochasticBlock

theorem stochasticBlock_mean_matrix_isHermitian {k : ℕ} (hk : 0 < k)
    (θ : Parameters) (hpq : θ.q < θ.p) :
    Matrix.IsHermitian (fun i j : Vertex k => ∫ ω, stochasticBlockAdjacency ω i j
      ∂graphMeasure k θ) := by
  rw [stochasticBlock_mean_matrix_eq_loopless hk θ hpq]
  apply Matrix.IsHermitian.ext
  intro i j
  simp only [star_trivial, looplessExpectedAdjacency]
  by_cases hij : i = j
  · subst j
    rfl
  · have hji : j ≠ i := Ne.symm hij
    simp only [hij, hji, if_false]
    by_cases hc : i.1 = j.1
    · rw [if_pos hc, if_pos hc.symm]
    · rw [if_neg hc, if_neg (Ne.symm hc)]

/-- The signed eigenvalue list of the actual mean contains `-p` exactly
`2*k-2` times. This count is zero for singleton communities (`k = 1`). -/
theorem stochasticBlock_mean_sorted_residual_count {k : ℕ} (hk : 0 < k)
    (θ : Parameters) (hpq : θ.q < θ.p) :
    let A : Matrix (Vertex k) (Vertex k) ℝ := fun i j =>
      ∫ ω, stochasticBlockAdjacency ω i j ∂graphMeasure k θ
    let hT : A.toEuclideanLin.IsSymmetric :=
      Matrix.isHermitian_iff_isSymmetric.mp
        (stochasticBlock_mean_matrix_isHermitian hk θ hpq)
    let hn : Module.finrank ℝ (EuclideanSpace ℝ (Vertex k)) = 2 * k := by
      simp [Vertex]
    Finset.card {i | hT.eigenvalues hn i = -(θ.p : ℝ)} = 2 * k - 2 := by
  dsimp only
  rw [NumStability.card_filter_symmetric_eigenvalues_eq_finrank,
    NumStability.finrank_eigenspace_toEuclideanLin_eq_mulVecLin]
  exact finrank_stochasticBlock_mean_residual_eigenspace hk θ hpq


end NumStability.HDP.Contract

namespace NumStability.HDP.Contract

/-- Complete signed spectrum of the actual loopless mean. The two signal
values may coincide when `q = 0`; the residual value `-p` is present exactly
when `1 < k`. This statement does not order eigenvalues by absolute value. -/
theorem stochasticBlock_mean_hasEigenvalue_iff {k : ℕ} (hk : 0 < k)
    (θ : Parameters) (hpq : θ.q < θ.p) (μ : ℝ) :
    Module.End.HasEigenvalue
      (Matrix.mulVecLin (fun i j : Vertex k =>
        ∫ ω, stochasticBlockAdjacency ω i j ∂graphMeasure k θ)) μ ↔
      μ = (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p ∨
      μ = (k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p ∨
      (μ = -(θ.p : ℝ) ∧ 1 < k) := by
  rw [stochasticBlock_mean_matrix_eq_loopless hk θ hpq,
    looplessExpectedAdjacency_eq_displayed_sub_diagonal]
  constructor
  · intro h
    by_cases hres : μ = -(θ.p : ℝ)
    · exact Or.inr (Or.inr ⟨hres,
        (expectedAdjacency_sub_diagonal_has_residual_eigenvalue_iff hk
          θ.q.coe_nonneg hpq).mp (by simpa only [hres] using h)⟩)
    · have hshift : μ + (θ.p : ℝ) ≠ 0 := by
        intro hz
        apply hres
        linarith
      obtain ⟨x, hx⟩ := h.exists_hasEigenvector
      have hxeigL :
          (expectedAdjacency k θ.p θ.q - (θ.p : ℝ) • 1).mulVec x =
            μ • x := by
        simpa only [Matrix.mulVecLin_apply] using hx.apply_eq_smul
      have hxeig :
          (expectedAdjacency k θ.p θ.q).mulVec x =
            (μ + (θ.p : ℝ)) • x := by
        rw [Matrix.sub_mulVec, Matrix.smul_mulVec, Matrix.one_mulVec] at hxeigL
        calc
          (expectedAdjacency k θ.p θ.q).mulVec x =
              ((expectedAdjacency k θ.p θ.q).mulVec x -
                (θ.p : ℝ) • x) + (θ.p : ℝ) • x := by abel
          _ = μ • x + (θ.p : ℝ) • x := by rw [hxeigL]
          _ = (μ + (θ.p : ℝ)) • x :=
            (add_smul μ (θ.p : ℝ) x).symm
      rcases expectedAdjacency_nonzero_eigenvalue_eq_signal hk
          (θ.p : ℝ) (θ.q : ℝ) (μ + (θ.p : ℝ)) hshift x hx.2 hxeig with
        htop | hsecond
      · exact Or.inl (by linarith)
      · exact Or.inr (Or.inl (by linarith))
  · intro h
    rcases h with rfl | rfl | ⟨rfl, hk2⟩
    · have heig := (hdp_04_equation_4_17_corrected hk θ hpq).1
      rw [looplessExpectedAdjacency_eq_displayed_sub_diagonal] at heig
      apply Module.End.hasEigenvalue_of_hasEigenvector
      exact ⟨Module.End.mem_eigenspace_iff.mpr
        (by simpa only [Matrix.mulVecLin_apply] using heig),
        (linearIndependent_allOnes_communitySign hk).ne_zero 0⟩
    · have heig := (hdp_04_equation_4_17_corrected hk θ hpq).2
      rw [looplessExpectedAdjacency_eq_displayed_sub_diagonal] at heig
      apply Module.End.hasEigenvalue_of_hasEigenvector
      exact ⟨Module.End.mem_eigenspace_iff.mpr
        (by simpa only [Matrix.mulVecLin_apply] using heig),
        (linearIndependent_allOnes_communitySign hk).ne_zero 1⟩
    · exact (expectedAdjacency_sub_diagonal_has_residual_eigenvalue_iff hk
        θ.q.coe_nonneg hpq).mpr hk2


end NumStability.HDP.Contract

end
