import ComputationalMathematics.Source.Vershynin.Chapter04.Equation415.OwnerQualifiedFullTarget

/-!
# Equation 4.15: the net-maximum probability bound

The owner-qualified formula has positive scale and positive dimensions. The
zero-scale and empty-dimension statements are separate conjuncts.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal BigOperators

universe u

namespace NumStability.HDP.Contract.Equation415OwnerQualified

private theorem positiveScale_bound : PositiveScaleParent.{u} := by
  classical
  obtain ⟨c, hc, htail⟩ :=
    NumStability.HDP.Matrix.exists_fixed_bilinear_tail_of_independent_subGaussian_entries
  refine ⟨c, hc, ?_⟩
  intro Ω _ μ _ m n _ _ A hSG hCenter hIndep
  dsimp only
  intro _hK N M hNnet hMnet hN hM hNcard hMcard u hu
  let b : ℝ := 2 * Real.exp (-(c * u ^ 2 /
    (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
      (fun ij : Fin m × Fin n => fun ω => A ω ij.1 ij.2)) ^ 2))
  have hb : 0 ≤ b := by dsimp [b]; positivity
  have hpair : ∀ x ∈ N, ∀ y ∈ M,
      μ.real {ω | u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) x) y} ≤ b := by
    intro x hx y hy
    refine (measureReal_mono ?_).trans
      (htail A hSG hCenter hIndep x y (hNnet.1 x hx) (hMnet.1 y hy) hu)
    intro ω hω
    change u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) x) y at hω
    exact hω.trans (le_abs_self _)
  let event := fun xy : EuclideanSpace ℝ (Fin n) × EuclideanSpace ℝ (Fin m) =>
    {ω | u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) xy.1) xy.2}
  have hProductEvent :
      {ω | u ≤ (N ×ˢ M).sup' (hN.product hM)
        (fun xy => inner ℝ (Matrix.toEuclideanLin (A ω) xy.1) xy.2)} =
      ⋃ xy ∈ N ×ˢ M, event xy := by
    ext ω
    simp only [Set.mem_setOf_eq, Finset.le_sup'_iff, Set.mem_iUnion, event, exists_prop]
  have hsum : (∑ xy ∈ N ×ˢ M, μ.real (event xy)) ≤
      (9 ^ (n + m) : ℕ) * b := by
    calc
      _ ≤ ∑ _xy ∈ N ×ˢ M, b := by
        apply Finset.sum_le_sum
        intro xy hxy
        exact hpair xy.1 (Finset.mem_product.mp hxy).1
          xy.2 (Finset.mem_product.mp hxy).2
      _ = ((N.card * M.card : ℕ) : ℝ) * b := by simp
      _ ≤ (9 ^ (n + m) : ℕ) * b := by
        apply mul_le_mul_of_nonneg_right _ hb
        exact_mod_cast ((Nat.mul_le_mul hNcard hMcard).trans_eq (pow_add 9 n m).symm)
  have hUnion : μ.real {ω | u ≤ (N ×ˢ M).sup' (hN.product hM)
      (fun xy => inner ℝ (Matrix.toEuclideanLin (A ω) xy.1) xy.2)} ≤
      ∑ xy ∈ N ×ˢ M, μ.real (event xy) := by
    rw [hProductEvent]
    exact measureReal_biUnion_finset_le (N ×ˢ M) event
  exact ⟨hpair, NumStability.HDP.Matrix.bilinear_maximum_event_eq_union
    A N M hN hM u, hUnion, hsum, hUnion.trans hsum⟩

private theorem zeroScale_bound : ZeroScaleMatrixCase.{u} := by
  classical
  intro Ω _ μ _ m n _ _ A hMeas hFinite
  dsimp only
  have hzero := NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax_eq_zero_iff_matrix_ae_zero
    hMeas hFinite
  refine ⟨hzero, ?_⟩
  intro hK N M hN hM
  refine ⟨?_, ?_⟩
  · filter_upwards [hzero.mp hK] with ω hω
    simp [hω]
  · intro u _hu
    have h := NumStability.HDP.Matrix.measure_bilinear_maximum_of_zero_entry_scale
      A hMeas hFinite hK N M hN hM u
    simpa only [Measure.real_def, ENNReal.toReal_one, ENNReal.toReal_zero,
      apply_ite] using congrArg ENNReal.toReal h

private theorem emptyDimension_union : EmptyDimensionUnionCase.{u} := by
  classical
  intro Ω _ μ _ m n hDim A N M hNnet hMnet
  rcases hDim with rfl | rfl
  · have hMempty : M = ∅ := by
      apply Finset.eq_empty_of_forall_notMem
      intro x hx
      have h := hMnet.1 x hx
      have hx0 : x = 0 := Subsingleton.elim _ _
      simp [hx0] at h
    refine ⟨fun _ => Subsingleton.elim _ _, by simp [hMempty], ?_⟩
    intro u
    simp [hMempty]
  · have hNempty : N = ∅ := by
      apply Finset.eq_empty_of_forall_notMem
      intro x hx
      have h := hNnet.1 x hx
      have hx0 : x = 0 := Subsingleton.elim _ _
      simp [hx0] at h
    refine ⟨fun _ => Subsingleton.elim _ _, by simp [hNempty], ?_⟩
    intro u
    simp [hNempty]

theorem equation415_owner_qualified_proved : CompleteOwnerQualifiedParent.{u} :=
  ⟨positiveScale_bound, zeroScale_bound, emptyDimension_union⟩

end NumStability.HDP.Contract.Equation415OwnerQualified
