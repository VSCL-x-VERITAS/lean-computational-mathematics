/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.GramSchmidt.Decomposition

/-!
# Normalized QR construction for a dependent family

A dependent family of dimension length has a normalized Gram–Schmidt family
with at least one zero entry. Its nonzero entries are orthonormal, its initial
spans agree with those of the input, and its triangular coefficient matrix
has a zero row at every zero entry. Completing the nonzero entries to an
orthonormal basis preserves reconstruction with the same coefficients.

The construction works over any `RCLike` field and includes dimension zero.
-/

set_option autoImplicit false
open scoped BigOperators

namespace NumStability

variable {𝕜 H : Type*} [RCLike 𝕜] [NormedAddCommGroup H] [InnerProductSpace 𝕜 H]
variable [FiniteDimensional 𝕜 H]

/-- A dependent family of dimension length admits the normalized zero-column
QR construction and an orthonormal completion. Every orthonormal completion
keeping its nonzero columns reconstructs the input with the same triangular
coefficients. No positive-dimension or nontrivial-space hypothesis is needed. -/
theorem exists_qr_of_not_linearIndependent {n : ℕ}
    (h : Module.finrank 𝕜 H = n) (X : Fin n → H)
    (hX : ¬ LinearIndependent 𝕜 X) :
    let dependent : Fin n → Prop :=
      fun k => X k ∈ Submodule.span 𝕜 (X '' Set.Iio k)
    let residual : (Fin n → H) → Fin n → H :=
      fun Y k => X k -
        ∑ i ∈ Finset.Iio k, inner 𝕜 (Y i) (X k) • Y i
    ∃ (Q0 : Fin n → H) (R : Matrix (Fin n) (Fin n) 𝕜),
      (∃ k : Fin n, Q0 k = 0) ∧
      (∀ k : Fin n,
        (Q0 k = 0 ↔ dependent k) ∧
          (¬ dependent k →
            residual Q0 k ≠ 0 ∧
              Q0 k = (‖residual Q0 k‖ : 𝕜)⁻¹ • residual Q0 k)) ∧
      Orthonormal 𝕜 (fun i : {i : Fin n // Q0 i ≠ 0} => Q0 i.val) ∧
      (∀ k : Fin n,
        Submodule.span 𝕜 (Q0 '' Set.Iic k) =
          Submodule.span 𝕜 (X '' Set.Iic k)) ∧
      (∀ i j : Fin n, j < i → R i j = 0) ∧
      (∀ i : Fin n, Q0 i = 0 → ∀ j : Fin n, R i j = 0) ∧
      (∀ j : Fin n, X j = ∑ i : Fin n, R i j • Q0 i) ∧
      (∃ Q : Fin n → H,
        Orthonormal 𝕜 Q ∧
        (∀ i : Fin n, Q0 i ≠ 0 → Q i = Q0 i) ∧
        Submodule.span 𝕜 (Set.range Q) = ⊤ ∧
        (∀ j : Fin n, X j = ∑ i : Fin n, R i j • Q i)) ∧
      (∀ Q : Fin n → H,
        Orthonormal 𝕜 Q →
        (∀ i : Fin n, Q0 i ≠ 0 → Q i = Q0 i) →
        ∀ j : Fin n, X j = ∑ i : Fin n, R i j • Q i) := by
  classical
  dsimp only
  have hcard : Module.finrank 𝕜 H = Fintype.card (Fin n) := by
    simpa only [Fintype.card_fin] using h
  let Q0 := InnerProductSpace.gramSchmidtNormed 𝕜 X
  let b := InnerProductSpace.gramSchmidtOrthonormalBasis hcard X
  let R := fun i j => inner 𝕜 (b i) (X j)
  have hd := gramSchmidtNormed_decomposition hcard X
  refine ⟨Q0, R, gramSchmidtNormed_exists_eq_zero hcard X hX,
    ?_, InnerProductSpace.gramSchmidtNormed_orthonormal' X, ?_,
    hd.1, hd.2.1, hd.2.2.1, ?_, ?_⟩
  · intro k
    refine ⟨gramSchmidtNormed_eq_zero_iff_mem_span_predecessors X k, ?_⟩
    intro hk
    have hn : InnerProductSpace.gramSchmidt 𝕜 X k ≠ 0 := by
      exact fun hz => hk ((gramSchmidt_eq_zero_iff_mem_span_predecessors X k).mp hz)
    have hr := gramSchmidt_eq_normalized_residual (𝕜 := 𝕜) X k
    constructor
    · simpa only [Q0, hr] using hn
    · exact congrArg (fun v : H => (‖v‖ : 𝕜)⁻¹ • v) hr
  · intro k
    dsimp only [Q0]
    rw [InnerProductSpace.span_gramSchmidtNormed X (Set.Iic k),
      InnerProductSpace.span_gramSchmidt_Iic 𝕜 X k]
  · refine ⟨b, b.orthonormal, hd.2.2.2.2.1, ?_, hd.2.2.2.1⟩
    rw [← b.coe_toBasis]
    exact b.toBasis.span_eq
  · intro Q _hQ hkeep
    exact hd.2.2.2.2.2 Q hkeep

end NumStability
