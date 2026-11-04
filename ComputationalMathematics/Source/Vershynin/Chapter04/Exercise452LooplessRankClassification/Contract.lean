import ComputationalMathematics.HDP.Graph.StochasticBlockDecomposition
import ComputationalMathematics.Source.Vershynin.Chapter04.Equation417LooplessFullCorrection.Contract
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse

/-!
# Loopless rank correction to Vershynin Exercise 4.5.2

This separately named analyst correction classifies the rank of the actual
loopless expectation. It retains the existing zero-rank obstruction and
corrected spectral actions. It does not assert the printed rank-two claim.
The proof bodies are transported from the completed reviewed rank artifacts.
-/

noncomputable section

namespace NumStability.HDP.Contract

open NumStability.HDP.Graph.StochasticBlock

/-- Conditional full-rank foundation for the loopless expectation. Both
shifted signal eigenvalues must be nonzero. This is not a statement or proof
of the original source Exercise 4.5.2. -/
theorem looplessExpectedAdjacency_rank_eq_full_of_shifted_signals_ne_zero
    {k : ℕ} (hk : 0 < k) (θ : Parameters) (hpq : θ.q < θ.p)
    (hfirst : (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p ≠ 0)
    (hsecond : (k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p ≠ 0) :
    (looplessExpectedAdjacency k θ.p θ.q).rank = 2 * k := by
  have hp : (θ.p : ℝ) ≠ 0 :=
    ne_of_gt (lt_of_le_of_lt (NNReal.coe_nonneg θ.q)
      (NNReal.coe_lt_coe.mpr hpq))
  have hkR : (k : ℝ) ≠ 0 := by exact_mod_cast Nat.ne_of_gt hk
  have hc := hdp_04_equation_4_17_loopless_full_corrected hk θ hpq
  have hkernel : ∀ x : Vertex k → ℝ,
      (looplessExpectedAdjacency k θ.p θ.q).mulVec x = 0 → x = 0 := by
    intro x hx
    obtain ⟨a, b, y, hxy, hy⟩ :=
      exists_signal_complement_decomposition hk x
    let l1 : ℝ := (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p
    let l2 : ℝ := (k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p
    have heq := hx
    rw [hxy, Matrix.mulVec_add, Matrix.mulVec_add, Matrix.mulVec_smul,
      Matrix.mulVec_smul, hc.2.1, hc.2.2.1, hc.2.2.2 y hy] at heq
    have hsum0 := congrArg
      (fun z : Vertex k → ℝ => ∑ t : Fin k, z (0, t)) heq
    have hsum1 := congrArg
      (fun z : Vertex k → ℝ => ∑ t : Fin k, z (1, t)) heq
    simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul,
      Finset.sum_add_distrib, ← Finset.mul_sum, hy 0, hy 1, mul_zero,
      allOnes, Function.const_apply, communitySign,
      Fin.isValue, if_pos, Finset.sum_const, Finset.card_univ, Fintype.card_fin,
      nsmul_eq_mul, Pi.zero_apply] at hsum0 hsum1
    norm_num at hsum1
    have he0 : (a * l1 + b * l2) * (k : ℝ) = 0 := by
      convert hsum0 using 1
      dsimp [l1, l2]
      ring
    have he1 : (a * l1 - b * l2) * (k : ℝ) = 0 := by
      convert hsum1 using 1
      dsimp [l1, l2]
      ring
    have he0' : a * l1 + b * l2 = 0 := (mul_eq_zero.mp he0).resolve_right hkR
    have he1' : a * l1 - b * l2 = 0 := (mul_eq_zero.mp he1).resolve_right hkR
    have haProd : a * l1 = 0 := by nlinarith [he0', he1']
    have hbProd : b * l2 = 0 := by nlinarith [he0', he1']
    have ha : a = 0 := (mul_eq_zero.mp haProd).resolve_right hfirst
    have hb : b = 0 := (mul_eq_zero.mp hbProd).resolve_right hsecond
    have hy0 : y = 0 := by
      rw [ha, hb] at heq
      simp only [zero_smul, zero_add] at heq
      exact (smul_eq_zero_iff_right (neg_ne_zero.mpr hp)).mp heq
    rw [hxy, ha, hb, hy0]
    simp
  have hinjective :
      Function.Injective (looplessExpectedAdjacency k θ.p θ.q).mulVec := by
    change Function.Injective (looplessExpectedAdjacency k θ.p θ.q).mulVecLin
    exact LinearMap.ker_eq_bot.mp (LinearMap.ker_eq_bot'.mpr hkernel)
  have hunit := Matrix.mulVec_injective_iff_isUnit.mp hinjective
  simpa [Vertex] using Matrix.rank_of_isUnit
    (looplessExpectedAdjacency k θ.p θ.q) hunit

/-- Conditional rank foundation for the loopless expectation when precisely
the signed-community signal eigenvalue is zero. This does not prove the
original source Exercise 4.5.2. -/
theorem looplessExpectedAdjacency_rank_eq_full_sub_one_of_second_signal_eq_zero
    {k : ℕ} (hk : 0 < k) (θ : Parameters) (hpq : θ.q < θ.p)
    (hfirst : (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p ≠ 0)
    (hsecond : (k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p = 0) :
    (looplessExpectedAdjacency k θ.p θ.q).rank = 2 * k - 1 := by
  have hp : (θ.p : ℝ) ≠ 0 :=
    ne_of_gt (lt_of_le_of_lt (NNReal.coe_nonneg θ.q)
      (NNReal.coe_lt_coe.mpr hpq))
  have hkR : (k : ℝ) ≠ 0 := by exact_mod_cast Nat.ne_of_gt hk
  have hc := hdp_04_equation_4_17_loopless_full_corrected hk θ hpq
  have hkernel : ∀ x : Vertex k → ℝ,
      (looplessExpectedAdjacency k θ.p θ.q).mulVec x = 0 →
        ∃ b : ℝ, x = b • communitySign k := by
    intro x hx
    obtain ⟨a, b, y, hxy, hy⟩ :=
      exists_signal_complement_decomposition hk x
    have heq := hx
    rw [hxy, Matrix.mulVec_add, Matrix.mulVec_add, Matrix.mulVec_smul,
      Matrix.mulVec_smul, hc.2.1, hc.2.2.1, hc.2.2.2 y hy, hsecond] at heq
    simp only [zero_smul, smul_zero, add_zero] at heq
    have hsum0 := congrArg
      (fun z : Vertex k → ℝ => ∑ t : Fin k, z (0, t)) heq
    simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul,
      Finset.sum_add_distrib, ← Finset.mul_sum, hy 0, mul_zero,
      allOnes, Function.const_apply, Finset.sum_const, Finset.card_univ,
      Fintype.card_fin, nsmul_eq_mul, Pi.zero_apply] at hsum0
    have haProd :
        a * ((k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p) * (k : ℝ) = 0 := by
      convert hsum0 using 1
      ring
    have haSignal : a * ((k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p) = 0 :=
      (mul_eq_zero.mp haProd).resolve_right hkR
    have ha : a = 0 := (mul_eq_zero.mp haSignal).resolve_right hfirst
    have hy0 : y = 0 := by
      rw [ha] at heq
      simp only [zero_smul, zero_add] at heq
      exact (smul_eq_zero_iff_right (neg_ne_zero.mpr hp)).mp heq
    refine ⟨b, ?_⟩
    rw [hxy, ha, hy0]
    simp
  have hker :
      LinearMap.ker (looplessExpectedAdjacency k θ.p θ.q).mulVecLin =
        Submodule.span ℝ {communitySign k} := by
    ext x
    constructor
    · intro hx
      change (looplessExpectedAdjacency k θ.p θ.q).mulVec x = 0 at hx
      obtain ⟨b, hb⟩ := hkernel x hx
      exact Submodule.mem_span_singleton.mpr ⟨b, hb.symm⟩
    · intro hx
      obtain ⟨b, rfl⟩ := Submodule.mem_span_singleton.mp hx
      change (looplessExpectedAdjacency k θ.p θ.q).mulVec
        (b • communitySign k) = 0
      rw [Matrix.mulVec_smul, hc.2.2.1, hsecond]
      simp
  have hsign : communitySign k ≠ 0 := by
    simpa using (linearIndependent_allOnes_communitySign hk).ne_zero (1 : Fin 2)
  have hnullity : Module.finrank ℝ
      (LinearMap.ker (looplessExpectedAdjacency k θ.p θ.q).mulVecLin) = 1 := by
    rw [hker]
    exact finrank_span_singleton hsign
  have hrank := LinearMap.finrank_range_add_finrank_ker
    (looplessExpectedAdjacency k θ.p θ.q).mulVecLin
  change (looplessExpectedAdjacency k θ.p θ.q).rank +
    Module.finrank ℝ (LinearMap.ker (looplessExpectedAdjacency k θ.p θ.q).mulVecLin) =
      Module.finrank ℝ (Vertex k → ℝ) at hrank
  rw [hnullity, Module.finrank_fintype_fun_eq_card] at hrank
  simp only [Vertex, Fintype.card_prod, Fintype.card_fin] at hrank
  omega

/-- For singleton communities the within-community parameter does not affect
the loopless matrix. This identity transports the existing concrete zero-rank
witness; it is not a new rank-zero proof. -/
theorem looplessExpectedAdjacency_singleton_within_parameter_independent
    (p p' q : ℝ) :
    looplessExpectedAdjacency 1 p q = looplessExpectedAdjacency 1 p' q := by
  ext i j
  by_cases hij : i = j
  · simp [looplessExpectedAdjacency, hij]
  · have hcomm : i.1 ≠ j.1 := by
      intro h
      exact hij (Prod.ext h (Subsingleton.elim _ _))
    simp [looplessExpectedAdjacency, hij, hcomm]

/-- The first shifted signal eigenvalue is positive precisely outside the
singleton case with no cross-community edges. -/
theorem loopless_first_shifted_signal_pos_iff_not_singleton_zero
    {k : ℕ} (hk : 0 < k) (θ : Parameters) (hpq : θ.q < θ.p) :
    0 < (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p ↔
      ¬ (k = 1 ∧ θ.q = 0) := by
  constructor
  · intro hpos ⟨hk1, hq0⟩
    simp [hk1, hq0] at hpos
  · intro hnontrivial
    have hp : (0 : ℝ) < θ.p :=
      lt_of_le_of_lt (NNReal.coe_nonneg θ.q) (NNReal.coe_lt_coe.mpr hpq)
    by_cases hk1 : k = 1
    · have hqne : θ.q ≠ 0 := fun hq => hnontrivial ⟨hk1, hq⟩
      have hqpos : (0 : ℝ) < θ.q :=
        lt_of_le_of_ne (NNReal.coe_nonneg θ.q) (NNReal.coe_ne_zero.mpr hqne).symm
      simpa [hk1] using hqpos
    · have hk2 : (2 : ℝ) ≤ k := by
        exact_mod_cast (show 2 ≤ k by omega)
      have hwithin : 0 ≤ ((k : ℝ) - 2) * (θ.p : ℝ) :=
        mul_nonneg (sub_nonneg.mpr hk2) hp.le
      have hcross : 0 ≤ (k : ℝ) * (θ.q : ℝ) :=
        mul_nonneg (by positivity) (NNReal.coe_nonneg θ.q)
      nlinarith

/-- Complete conditional rank classification for the actual loopless matrix.
This reuses the two checked conditional rank foundations and the existing
concrete zero-rank witness. It does not establish the printed Exercise 4.5.2
or resolve its diagonal-convention uncertainty. -/
theorem hdp_04_exercise_4_5_2_loopless_rank_classification
    {k : ℕ} (hk : 0 < k) (θ : Parameters) (hpq : θ.q < θ.p) :
    (looplessExpectedAdjacency k θ.p θ.q).rank =
      if k = 1 ∧ θ.q = 0 then 0
      else if (k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p = 0 then 2 * k - 1
      else 2 * k := by
  by_cases hexception : k = 1 ∧ θ.q = 0
  · rw [if_pos hexception]
    obtain ⟨hk1, hq0⟩ := hexception
    subst k
    have hwitness : (looplessExpectedAdjacency 1 (1 : ℝ) 0).rank = 0 :=
      hdp_04_exercise_4_5_2_counterexample.1
    simpa [hq0, looplessExpectedAdjacency_singleton_within_parameter_independent
      (θ.p : ℝ) 1 0] using hwitness
  · rw [if_neg hexception]
    have hfirst : (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p ≠ 0 :=
      ne_of_gt ((loopless_first_shifted_signal_pos_iff_not_singleton_zero
        hk θ hpq).mpr hexception)
    by_cases hsecond : (k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p = 0
    · rw [if_pos hsecond]
      exact looplessExpectedAdjacency_rank_eq_full_sub_one_of_second_signal_eq_zero
        hk θ hpq hfirst hsecond
    · rw [if_neg hsecond]
      exact looplessExpectedAdjacency_rank_eq_full_of_shifted_signals_ne_zero
        hk θ hpq hfirst hsecond

end NumStability.HDP.Contract
