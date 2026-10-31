import ComputationalMathematics.HDP.Graph.StochasticBlock
import Mathlib.LinearAlgebra.Eigenspace.Basic

/-!
# Nonzero spectrum of the balanced block signal

The block-constant matrix has exactly its two signal eigenvalues
among nonzero spectral values. They may coincide when the cross-community
probability is zero.
-/

noncomputable section

open Matrix

namespace NumStability.HDP.Graph.StochasticBlock

/-- The image of the balanced block matrix lies in its two signal directions. -/
theorem expectedAdjacency_mulVec_signal_span
    (k : ℕ) (p q : ℝ) (x : Vertex k → ℝ) :
    ∃ a b : ℝ,
      (expectedAdjacency k p q).mulVec x =
        a • allOnes k + b • communitySign k := by
  let t := (signalCoefficients k p q).mulVec x
  refine ⟨t 0, t 1, ?_⟩
  rw [expectedAdjacency_eq_signalBasis_mul, ← Matrix.mulVec_mulVec]
  funext i
  simp [Matrix.mulVec, dotProduct, signalBasis, Fin.sum_univ_two, t]
  ring

/-- A nonzero eigenvector for a nonzero eigenvalue has one of the two signal
eigenvalues, even when the two signal values coincide. -/
theorem expectedAdjacency_nonzero_eigenvalue_eq_signal
    {k : ℕ} (hk : 0 < k) (p q μ : ℝ) (hμ : μ ≠ 0)
    (x : Vertex k → ℝ) (hx : x ≠ 0)
    (hEig : (expectedAdjacency k p q).mulVec x = μ • x) :
    μ = (k : ℝ) * (p + q) ∨ μ = (k : ℝ) * (p - q) := by
  obtain ⟨u, v, huv⟩ := expectedAdjacency_mulVec_signal_span k p q x
  let a : ℝ := μ⁻¹ * u
  let b : ℝ := μ⁻¹ * v
  have hrepr : x = a • allOnes k + b • communitySign k := by
    calc
      x = μ⁻¹ • (μ • x) := by simp [smul_smul, hμ]
      _ = μ⁻¹ • (expectedAdjacency k p q).mulVec x := by rw [hEig]
      _ = μ⁻¹ • (u • allOnes k + v • communitySign k) := by rw [huv]
      _ = a • allOnes k + b • communitySign k := by
        simp [a, b, smul_add, smul_smul]
  have hlin := hEig
  rw [hrepr, Matrix.mulVec_add, Matrix.mulVec_smul,
    Matrix.mulVec_smul, expectedAdjacency_mulVec_allOnes,
    expectedAdjacency_mulVec_communitySign] at hlin
  have h0 := congrFun hlin ((0 : Fin 2), (⟨0, hk⟩ : Fin k))
  have h1 := congrFun hlin ((1 : Fin 2), (⟨0, hk⟩ : Fin k))
  simp [allOnes, communitySign] at h0 h1
  have ha : ((k : ℝ) * (p + q) - μ) * a = 0 := by nlinarith [h0, h1]
  have hb : ((k : ℝ) * (p - q) - μ) * b = 0 := by nlinarith [h0, h1]
  rcases mul_eq_zero.mp ha with ha | ha
  · exact Or.inl (sub_eq_zero.mp ha).symm
  · rcases mul_eq_zero.mp hb with hb | hb
    · exact Or.inr (sub_eq_zero.mp hb).symm
    · exfalso
      apply hx
      rw [hrepr, ha, hb]
      simp

/-- Complete classification of the nonzero eigenvalues of the block
matrix, with no assumption that the two values are distinct. -/
theorem expectedAdjacency_nonzero_hasEigenvalue_iff
    {k : ℕ} (hk : 0 < k) (p q μ : ℝ) (hμ : μ ≠ 0) :
    Module.End.HasEigenvalue (expectedAdjacency k p q).mulVecLin μ ↔
      μ = (k : ℝ) * (p + q) ∨ μ = (k : ℝ) * (p - q) := by
  constructor
  · intro h
    obtain ⟨x, hx⟩ := h.exists_hasEigenvector
    exact expectedAdjacency_nonzero_eigenvalue_eq_signal hk p q μ hμ x hx.2
      (by simpa only [Matrix.mulVecLin_apply] using hx.apply_eq_smul)
  · intro h
    rcases h with rfl | rfl
    · apply Module.End.hasEigenvalue_of_hasEigenvector
      exact ⟨(Module.End.mem_eigenspace_iff).2
        (by simpa only [Matrix.mulVecLin_apply] using
          expectedAdjacency_mulVec_allOnes k p q),
        (linearIndependent_allOnes_communitySign hk).ne_zero 0⟩
    · apply Module.End.hasEigenvalue_of_hasEigenvector
      exact ⟨(Module.End.mem_eigenspace_iff).2
        (by simpa only [Matrix.mulVecLin_apply] using
          expectedAdjacency_mulVec_communitySign k p q),
        (linearIndependent_allOnes_communitySign hk).ne_zero 1⟩

/-- The complete rank and nonzero spectral data of the balanced
block matrix, with no distinct-eigenvalue assumption on the two signals. -/
theorem expectedAdjacency_rank_and_nonzero_spectrum
    {k : ℕ} (hk : 0 < k) {p q : ℝ} (hq : 0 ≤ q) (hpq : q < p) :
    (expectedAdjacency k p q).rank = 2 ∧
      (expectedAdjacency k p q).mulVec (allOnes k) =
        ((k : ℝ) * (p + q)) • allOnes k ∧
      (expectedAdjacency k p q).mulVec (communitySign k) =
        ((k : ℝ) * (p - q)) • communitySign k ∧
      ∀ μ : ℝ, μ ≠ 0 →
        (Module.End.HasEigenvalue (expectedAdjacency k p q).mulVecLin μ ↔
          μ = (k : ℝ) * (p + q) ∨ μ = (k : ℝ) * (p - q)) := by
  exact ⟨expectedAdjacency_rank_eq_two hk hq hpq,
    expectedAdjacency_mulVec_allOnes k p q,
    expectedAdjacency_mulVec_communitySign k p q,
    fun μ hμ => expectedAdjacency_nonzero_hasEigenvalue_iff hk p q μ hμ⟩

end NumStability.HDP.Graph.StochasticBlock
