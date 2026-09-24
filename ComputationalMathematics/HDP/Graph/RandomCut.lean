import ComputationalMathematics.HDP.Graph.MaxCutSigns
import Mathlib.Algebra.BigOperators.Expect

/-!
# Uniform random cuts of finite simple graphs

This file gives a finite, measure-free model of the random partition used by
the elementary one-half approximation for maximum cut.  A labeling
`V → Bool` is sampled uniformly from the finite function type, and the average is
expressed with `Finset.expect`.
-/

namespace NumStability.HDP.Graph

open scoped BigOperators

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- Convert a Boolean side-label into a two-valued optimization sign. -/
def boolSign (b : Bool) : NumStability.HDP.Optimization.Sign :=
  if b then .pos else .neg

@[simp] theorem boolSign_value (b : Bool) :
    (boolSign b).value = if b then (1 : ℝ) else -1 := by
  cases b <;> rfl

/-- Flip one coordinate of a Boolean labeling. -/
def flipCoordinate (i : V) : (V → Bool) ≃ (V → Bool) where
  toFun x := Function.update x i (!(x i))
  invFun x := Function.update x i (!(x i))
  left_inv x := by
    funext k
    by_cases hki : k = i
    · subst k
      simp
    · simp [Function.update, hki]
  right_inv x := by
    funext k
    by_cases hki : k = i
    · subst k
      simp
    · simp [Function.update, hki]

/-- Distinct unbiased Boolean coordinates have zero sign-product average. -/
theorem expect_boolSign_mul_eq_zero {i j : V} (hij : i ≠ j) :
    (𝔼 x : V → Bool, (boolSign (x i)).value * (boolSign (x j)).value) = 0 := by
  let f : (V → Bool) → ℝ := fun x ↦
    (boolSign (x i)).value * (boolSign (x j)).value
  have hflip (x : V → Bool) : f (flipCoordinate i x) = -f x := by
    simp [f, flipCoordinate, hij.symm]
    cases x i <;> cases x j <;> norm_num [boolSign]
  have hperm : (𝔼 x : V → Bool, f (flipCoordinate i x)) = 𝔼 x : V → Bool, f x := by
    exact Fintype.expect_equiv (flipCoordinate i) _ _ (fun _ ↦ rfl)
  simp_rw [hflip] at hperm
  rw [Finset.expect_neg_distrib] at hperm
  exact neg_eq_self.mp hperm

/-- Uniform expectation of the cut value obtained from independent unbiased
Boolean vertex labels. -/
noncomputable def uniformBoolCutExpectation (G : SimpleGraph V) [DecidableRel G.Adj] : ℝ :=
  𝔼 x : V → Bool, signCutValue G (fun v ↦ boolSign (x v))

/-- A uniform random bipartition cuts exactly half of the graph edges on
average. -/
theorem uniformBoolCutExpectation_eq_half_edges (G : SimpleGraph V)
    [DecidableRel G.Adj] :
    uniformBoolCutExpectation G = (G.edgeFinset.card : ℝ) / 2 := by
  classical
  have hterm (i j : V) :
      (𝔼 x : V → Bool,
        G.adjMatrix ℝ i j *
          (1 - (boolSign (x i)).value * (boolSign (x j)).value)) =
        G.adjMatrix ℝ i j := by
    by_cases hij : i = j
    · subst j
      simp
    · rw [← Finset.mul_expect]
      rw [Finset.expect_sub_distrib, Fintype.expect_const,
        expect_boolSign_mul_eq_zero hij]
      ring
  have hadj : (∑ i : V, ∑ j : V, G.adjMatrix ℝ i j) =
      2 * (G.edgeFinset.card : ℝ) := by
    have hsum :
        (∑ p : V × V, if G.Adj p.1 p.2 then (1 : ℝ) else 0) =
          ((Finset.univ.filter fun p : V × V ↦ G.Adj p.1 p.2).card : ℝ) := by
      exact Finset.sum_boole (R := ℝ) (fun p : V × V ↦ G.Adj p.1 p.2) Finset.univ
    rw [Fintype.sum_prod_type] at hsum
    simp_rw [G.adjMatrix_apply]
    rw [hsum, ← Nat.cast_ofNat, ← Nat.cast_mul, G.two_mul_card_edgeFinset]
  rw [uniformBoolCutExpectation]
  simp_rw [signCutValue]
  rw [← Finset.mul_expect]
  rw [Finset.expect_sum_comm]
  simp_rw [Finset.expect_sum_comm, hterm]
  rw [hadj]
  ring

/-- The uniform random cut has expected size at least half the maximum-cut
value. -/
theorem half_maxCut_le_uniformBoolCutExpectation (G : SimpleGraph V)
    [DecidableRel G.Adj] :
    (maxCut G : ℝ) / 2 ≤ uniformBoolCutExpectation G := by
  classical
  rw [uniformBoolCutExpectation_eq_half_edges]
  gcongr
  unfold maxCut cutSize
  exact Finset.sup_le (fun S _ ↦ Finset.card_filter_le _ _)

end NumStability.HDP.Graph
