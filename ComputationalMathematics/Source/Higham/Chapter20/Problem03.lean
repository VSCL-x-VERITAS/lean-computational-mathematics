import ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.MinimumNorm.Pseudoinverse.CompactSVD
import ComputationalMathematics.Analysis.SingularValues.CompactSVD
import ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.MinimumNorm.Pseudoinverse.UnderdeterminedSpec
import ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.MinimumNorm.Solvers.UnderdeterminedSpec
import ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.MinimumNorm.Specifications.UnderdeterminedSpec
import ComputationalMathematics.Source.Higham.Chapter21.Equation04.UnderdeterminedSpec
import ComputationalMathematics.Source.Higham.Chapter21.Equation05.UnderdeterminedSpec
import ComputationalMathematics.Source.Higham.Chapter21.Lemma02.Symmetrization.UnderdeterminedSpec
import ComputationalMathematics.Source.Higham.Chapter21.Theorem01.ComponentwisePerturbation.UnderdeterminedSpec
import ComputationalMathematics.Analysis.MatrixAlgebra

namespace NumStability

open scoped BigOperators

/-!
# Higham Chapter 20 — Problem03

Canonical source correspondence module extracted without change from Higham20Problem20_3.
-/

private theorem higham20_symmetric_eq_of_mul_eq_left
    {n : Nat} (P Q : Fin n -> Fin n -> Real)
    (hP : IsSymmetricFiniteMatrix P) (hQ : IsSymmetricFiniteMatrix Q)
    (hPQ : rectMatMul P Q = P) (hQP : rectMatMul Q P = Q) :
    P = Q := by
  ext i j
  calc
    P i j = rectMatMul P Q i j := by rw [hPQ]
    _ = rectMatMul Q P j i := by
      unfold rectMatMul
      apply Finset.sum_congr rfl
      intro k _
      rw [hP i k, hQ k j]
      ring
    _ = Q j i := by rw [hQP]
    _ = Q i j := hQ j i
private theorem higham20_symmetric_eq_of_mul_eq_right
    {n : Nat} (P Q : Fin n -> Fin n -> Real)
    (hP : IsSymmetricFiniteMatrix P) (hQ : IsSymmetricFiniteMatrix Q)
    (hPQ : rectMatMul P Q = Q) (hQP : rectMatMul Q P = P) :
    P = Q := by
  ext i j
  calc
    P i j = rectMatMul Q P i j := by rw [hQP]
    _ = rectMatMul P Q j i := by
      unfold rectMatMul
      apply Finset.sum_congr rfl
      intro k _
      rw [hQ i k, hP k j]
      ring
    _ = Q j i := by rw [hPQ]
    _ = Q i j := hQ j i
/-- The four Moore--Penrose equations determine the pseudoinverse uniquely.
This is the uniqueness assertion in Higham's Problem 20.3. -/
theorem higham20_problem20_3_moorePenrose_unique
    {m n : Nat} (A : Fin m -> Fin n -> Real)
    (X Y : Fin n -> Fin m -> Real)
    (hX : RectMoorePenrosePseudoinverse m n A X)
    (hY : RectMoorePenrosePseudoinverse m n A Y) :
    X = Y := by
  have hDomainXY :
      rectMatMul (rectMatMul X A) (rectMatMul Y A) = rectMatMul X A := by
    calc
      rectMatMul (rectMatMul X A) (rectMatMul Y A) =
          rectMatMul X (rectMatMul (rectMatMul A Y) A) := by
            rw [rectMatMul_assoc X A (rectMatMul Y A),
              ← rectMatMul_assoc A Y A]
      _ = rectMatMul X A := by rw [hY.reproduces_matrix]
  have hDomainYX :
      rectMatMul (rectMatMul Y A) (rectMatMul X A) = rectMatMul Y A := by
    calc
      rectMatMul (rectMatMul Y A) (rectMatMul X A) =
          rectMatMul Y (rectMatMul (rectMatMul A X) A) := by
            rw [rectMatMul_assoc Y A (rectMatMul X A),
              ← rectMatMul_assoc A X A]
      _ = rectMatMul Y A := by rw [hX.reproduces_matrix]
  have hDomain : rectMatMul X A = rectMatMul Y A :=
    higham20_symmetric_eq_of_mul_eq_left
      (rectMatMul X A) (rectMatMul Y A)
      hX.domain_projection_symmetric hY.domain_projection_symmetric
      hDomainXY hDomainYX
  have hRangeXY :
      rectMatMul (rectMatMul A X) (rectMatMul A Y) = rectMatMul A Y := by
    calc
      rectMatMul (rectMatMul A X) (rectMatMul A Y) =
          rectMatMul (rectMatMul (rectMatMul A X) A) Y := by
            exact (rectMatMul_assoc (rectMatMul A X) A Y).symm
      _ = rectMatMul A Y := by rw [hX.reproduces_matrix]
  have hRangeYX :
      rectMatMul (rectMatMul A Y) (rectMatMul A X) = rectMatMul A X := by
    calc
      rectMatMul (rectMatMul A Y) (rectMatMul A X) =
          rectMatMul (rectMatMul (rectMatMul A Y) A) X := by
            exact (rectMatMul_assoc (rectMatMul A Y) A X).symm
      _ = rectMatMul A X := by rw [hY.reproduces_matrix]
  have hRange : rectMatMul A X = rectMatMul A Y :=
    higham20_symmetric_eq_of_mul_eq_right
      (rectMatMul A X) (rectMatMul A Y)
      hX.range_projection_symmetric hY.range_projection_symmetric
      hRangeXY hRangeYX
  calc
    X = rectMatMul (rectMatMul X A) X := hX.reproduces_pseudoinverse.symm
    _ = rectMatMul (rectMatMul Y A) X := by rw [hDomain]
    _ = rectMatMul Y (rectMatMul A X) := rectMatMul_assoc Y A X
    _ = rectMatMul Y (rectMatMul A Y) := by rw [hRange]
    _ = rectMatMul (rectMatMul Y A) Y := (rectMatMul_assoc Y A Y).symm
    _ = Y := hY.reproduces_pseudoinverse
/-- Swapping a matrix and its Moore--Penrose inverse swaps the first two
Penrose equations and the two symmetric projections. -/
theorem RectMoorePenrosePseudoinverse.reverse
    {m n : Nat} {A : Fin m -> Fin n -> Real}
    {Aplus : Fin n -> Fin m -> Real}
    (hMP : RectMoorePenrosePseudoinverse m n A Aplus) :
    RectMoorePenrosePseudoinverse n m Aplus A where
  reproduces_matrix := hMP.reproduces_pseudoinverse
  reproduces_pseudoinverse := hMP.reproduces_matrix
  range_projection_symmetric := hMP.domain_projection_symmetric
  domain_projection_symmetric := hMP.range_projection_symmetric
/-- Higham, 2nd ed., Chapter 20, Problem 20.3: the Moore--Penrose inverse is
involutive.  If `Aplus` is the Moore--Penrose inverse of `A`, then every
Moore--Penrose inverse `Aplusplus` of `Aplus` is exactly `A`. -/
theorem higham20_problem20_3_moorePenrose_involutive
    {m n : Nat} (A : Fin m -> Fin n -> Real)
    (Aplus : Fin n -> Fin m -> Real)
    (Aplusplus : Fin m -> Fin n -> Real)
    (hAplus : RectMoorePenrosePseudoinverse m n A Aplus)
    (hAplusplus : RectMoorePenrosePseudoinverse n m Aplus Aplusplus) :
    Aplusplus = A :=
  higham20_problem20_3_moorePenrose_unique Aplus Aplusplus A
    hAplusplus hAplus.reverse
/-- Problem 20.3 combined source endpoint: the compact-SVD reciprocal table is
the unique Moore--Penrose inverse, and taking its Moore--Penrose inverse again
returns the original arbitrary-rank matrix. -/
theorem higham20_problem20_3_compactSVD_unique_and_involutive
    {m n r : Nat} (A : Fin m -> Fin n -> Real)
    (U : Fin m -> Fin r -> Real) (sigma : Fin r -> Real)
    (V : Fin n -> Fin r -> Real)
    (hSVD : Higham20CompactRealSVD A U sigma V) :
    let Aplus := higham20Problem20_3SVDPseudoinverse U sigma V
    RectMoorePenrosePseudoinverse m n A Aplus /\
      (forall Y : Fin n -> Fin m -> Real,
        RectMoorePenrosePseudoinverse m n A Y -> Y = Aplus) /\
      (forall Aplusplus : Fin m -> Fin n -> Real,
        RectMoorePenrosePseudoinverse n m Aplus Aplusplus ->
          Aplusplus = A) := by
  dsimp only
  have hMP := higham20_problem20_3_compactSVD_moorePenrose A U sigma V hSVD
  refine ⟨hMP, ?_, ?_⟩
  · intro Y hY
    exact higham20_problem20_3_moorePenrose_unique A Y _ hY hMP
  · intro Aplusplus hAplusplus
    exact higham20_problem20_3_moorePenrose_involutive
      A _ Aplusplus hMP hAplusplus

end NumStability
