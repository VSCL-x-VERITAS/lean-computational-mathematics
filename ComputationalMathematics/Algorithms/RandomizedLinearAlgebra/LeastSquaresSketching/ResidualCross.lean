import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LeastSquaresSketching.Objectives.Core
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LeastSquaresSketching.ResidualCrossMoments

/-!
# Least-squares residual cross-term guarantees

Orthogonality and exact residual decompositions connect leverage-sampling cross
moments to deterministic and probabilistic least-squares objective bounds.
-/

namespace NumStability
open scoped BigOperators

/-- Optimal residuals are orthogonal to every vector represented by the columns. -/
theorem lsResidual_inner_column_combination_eq_zero
    {m n : ℕ} {A : Fin m → Fin n → ℝ} {b : Fin m → ℝ}
    {x : Fin n → ℝ} (hmin : IsLeastSquaresMinimizer A b x)
    (q : Fin n → ℝ) :
    (∑ i : Fin m, rectMatMulVec A q i * lsResidual A b x i) = 0 := by
  classical
  have horth := hmin.rectLSNormalEquations.residual_orthogonal
  unfold rectMatMulVec
  simp_rw [Finset.sum_mul]
  rw [Finset.sum_comm]
  calc
    (∑ j : Fin n, ∑ i : Fin m, A i j * q j * lsResidual A b x i) =
        ∑ j : Fin n, q j * (∑ i : Fin m, A i j * lsResidual A b x i) := by
          apply Finset.sum_congr rfl
          intro j _
          rw [Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro i _
          ring
    _ = 0 := by simp_rw [horth]; simp

/-- Exact Pythagorean expansion around an LS minimizer. -/
theorem lsObjective_eq_min_add_direction_sq
    {m n : ℕ} {A : Fin m → Fin n → ℝ} {b : Fin m → ℝ}
    {xOpt : Fin n → ℝ} (hopt : IsLeastSquaresMinimizer A b xOpt)
    (x : Fin n → ℝ) :
    lsObjective A b x = lsObjective A b xOpt +
      vecNorm2Sq (rectMatMulVec A (fun j => x j - xOpt j)) := by
  have h := lsObjective_add_direction_eq A b xOpt (fun j => x j - xOpt j)
  have hx : (fun j => xOpt j + (x j - xOpt j)) = x := by ext j; ring
  rw [hx] at h
  have ho := hopt.rectLSNormalEquations.residual_orthogonal
  simp_rw [ho, mul_zero, Finset.sum_const_zero] at h
  simpa using h

/-- A common row sketch sends a residual to the identically scaled residual. -/
theorem rowSampleLSResidualWithBasisScale_eq_scaled_residual
    {m n d s : ℕ} (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ)
    (U : Fin m → Fin d → ℝ) (samples : RowTrace m s)
    (x : Fin n → ℝ) (t : Fin s) :
    lsResidual (rowSampleLSMatrixWithBasisScale s U A samples)
      (rowSampleLSVectorWithBasisScale s U b samples) x t =
      lsResidual A b x (samples t) / rowSampleScaleDen s U (samples t) := by
  unfold lsResidual rectMatMulVec rowSampleLSMatrixWithBasisScale
    rowSampleLSVectorWithBasisScale
  rw [sub_div, Finset.sum_div]
  congr 1
  apply Finset.sum_congr rfl
  intro j _
  ring

/-- The image of a coefficient difference under a factored input. -/
theorem rectMatMulVec_eq_basis_coordinate_sum
    {m n d : ℕ} (A : Fin m → Fin n → ℝ)
    (U : Fin m → Fin d → ℝ) (C : Fin n → Fin d → ℝ)
    (hA : ∀ i j, A i j = ∑ a : Fin d, U i a * C j a)
    (q : Fin n → ℝ) (i : Fin m) :
    rectMatMulVec A q i =
      ∑ a : Fin d, U i a * (∑ j : Fin n, C j a * q j) := by
  unfold rectMatMulVec
  simp_rw [hA, Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro a _
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _
  ring

/-- Coercivity and a residual cross term give a quadratic relative-error bridge.
The lower Gram accuracy may be fixed independently of the final accuracy. -/
theorem lsObjective_le_min_add_cross_of_lower_sketch
    {m n d s : ℕ}
    (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ)
    (U : Fin m → Fin d → ℝ) (hU : HasOrthonormalColumns U)
    (C : Fin n → Fin d → ℝ)
    (hA : ∀ i j, A i j = ∑ a : Fin d, U i a * C j a)
    (samples : RowTrace m s) (xHat xOpt : Fin n → ℝ)
    (hopt : IsLeastSquaresMinimizer A b xOpt)
    (hhat : IsLeastSquaresMinimizer
      (rowSampleLSMatrixWithBasisScale s U A samples)
      (rowSampleLSVectorWithBasisScale s U b samples) xHat)
    (hlower : ∀ z : Fin d → ℝ,
      (1 / 2 : ℝ) * vecNorm2Sq z ≤
        vecNorm2Sq (fun t : Fin s =>
          ∑ a : Fin d, rowSampleSketch s U samples t a * z a)) :
    lsObjective A b xHat ≤ lsObjective A b xOpt +
      4 * vecNorm2Sq (fun a : Fin d =>
        ∑ t : Fin s, rowSampleSketch s U samples t a *
          (lsResidual A b xOpt (samples t) /
            rowSampleScaleDen s U (samples t))) := by
  classical
  let q : Fin n → ℝ := fun j => xHat j - xOpt j
  let z : Fin d → ℝ := fun a => ∑ j : Fin n, C j a * q j
  let v : Fin s → ℝ := fun t => ∑ a : Fin d, rowSampleSketch s U samples t a * z a
  let w : Fin s → ℝ := fun t => lsResidual A b xOpt (samples t) /
    rowSampleScaleDen s U (samples t)
  let g : Fin d → ℝ := fun a => ∑ t : Fin s, rowSampleSketch s U samples t a * w t
  let SA := rowSampleLSMatrixWithBasisScale s U A samples
  let Sb := rowSampleLSVectorWithBasisScale s U b samples
  have hv : ∀ t, rectMatMulVec SA q t = v t := by
    intro t
    have hi := rectMatMulVec_eq_basis_coordinate_sum A U C hA q (samples t)
    calc
      rectMatMulVec SA q t = rectMatMulVec A q (samples t) /
          rowSampleScaleDen s U (samples t) := by
        dsimp [SA, rectMatMulVec, rowSampleLSMatrixWithBasisScale]
        rw [Finset.sum_div]
        apply Finset.sum_congr rfl
        intro j _
        ring
      _ = v t := by
        rw [hi, Finset.sum_div]
        dsimp [v, z, rowSampleSketch, rowSampleIncrement]
        apply Finset.sum_congr rfl
        intro a _
        ring
  have hr : ∀ t, lsResidual SA Sb xHat t = v t + w t := by
    intro t
    have hscaled := rowSampleLSResidualWithBasisScale_eq_scaled_residual A b U samples xOpt t
    have hlin : rectMatMulVec SA xHat t =
        rectMatMulVec SA q t + rectMatMulVec SA xOpt t := by
      dsimp [rectMatMulVec, q]
      rw [← Finset.sum_add_distrib]
      apply Finset.sum_congr rfl
      intro j _
      ring
    change rectMatMulVec SA xHat t - Sb t = v t + w t
    rw [hlin, hv]
    change lsResidual SA Sb xOpt t = w t at hscaled
    change rectMatMulVec SA xOpt t - Sb t = w t at hscaled
    linarith
  have hzero := lsResidual_inner_column_combination_eq_zero hhat q
  have hvw : (∑ t : Fin s, v t * (v t + w t)) = 0 := by
    change (∑ t : Fin s, rectMatMulVec SA q t * lsResidual SA Sb xHat t) = 0 at hzero
    simpa only [hv, hr] using hzero
  have hcross : (∑ t : Fin s, v t * w t) = ∑ a : Fin d, z a * g a := by
    dsimp [v, g]
    simp_rw [Finset.sum_mul, Finset.mul_sum]
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro a _
    apply Finset.sum_congr rfl
    intro t _
    ring
  have henergy : vecNorm2Sq v = -(∑ a : Fin d, z a * g a) := by
    dsimp [vecNorm2Sq]
    simp_rw [mul_add] at hvw
    rw [Finset.sum_add_distrib, hcross] at hvw
    simpa only [pow_two] using (eq_neg_of_add_eq_zero_left hvw)
  have hcoerce : (1 / 2 : ℝ) * vecNorm2Sq z ≤ -(∑ a : Fin d, z a * g a) := by
    simpa only [← henergy] using hlower z
  have hcs := vecInnerProduct_sq_le z g
  have hz := vecNorm2Sq_nonneg z
  have hg := vecNorm2Sq_nonneg g
  have hbound : vecNorm2Sq z ≤ 4 * vecNorm2Sq g := by
    by_cases hz0 : vecNorm2Sq z = 0
    · rw [hz0]; positivity
    · have hzpos : 0 < vecNorm2Sq z := lt_of_le_of_ne hz (Ne.symm hz0)
      have hneg : (∑ a : Fin d, z a * g a) ≤ 0 := by linarith
      have hsquare : ((1 / 2 : ℝ) * vecNorm2Sq z) ^ 2 ≤
          (∑ a : Fin d, z a * g a) ^ 2 := by nlinarith
      nlinarith
  have hisom : vecNorm2Sq (rectMatMulVec A q) = vecNorm2Sq z := by
    have heq : rectMatMulVec A q = rectMatMulVec U z := by
      ext i
      exact rectMatMulVec_eq_basis_coordinate_sum A U C hA q i
    rw [heq]
    exact hasOrthonormalColumns_vecNorm2Sq_rectMatMulVec_eq U hU z
  have hpyth := lsObjective_eq_min_add_direction_sq hopt xHat
  change lsObjective A b xHat = lsObjective A b xOpt + vecNorm2Sq (rectMatMulVec A q) at hpyth
  rw [hpyth, hisom]
  change lsObjective A b xOpt + vecNorm2Sq z ≤ lsObjective A b xOpt + 4 * vecNorm2Sq g
  linarith

/-- The least-squares optimal residual is orthogonal to any basis of the input
column space. The representation is not required to be square or invertible. -/
theorem lsResidual_orthogonal_of_basis_columns_in_range
    {m n d : ℕ} (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ)
    (U : Fin m → Fin d → ℝ) (Q : Fin d → Fin n → ℝ)
    (hQ : ∀ i a, U i a = rectMatMulVec A (Q a) i)
    (xOpt : Fin n → ℝ) (hopt : IsLeastSquaresMinimizer A b xOpt) :
    ∀ a : Fin d, ∑ i : Fin m, U i a * lsResidual A b xOpt i = 0 := by
  intro a
  simp_rw [hQ]
  exact lsResidual_inner_column_combination_eq_zero hopt (Q a)

/-- Square-root row scaling gives exactly the unsquared-denominator cross
estimator, including rows of zero probability. -/
theorem rowSampleSketch_residual_cross_eq
    {m d s : ℕ} (U : Fin m → Fin d → ℝ)
    (hden : 0 < rowSqNormProbDen U) (hs : 0 < (s : ℝ))
    (r : Fin m → ℝ) (samples : RowTrace m s) :
    (fun a : Fin d => ∑ t : Fin s, rowSampleSketch s U samples t a *
      (r (samples t) / rowSampleScaleDen s U (samples t))) =
        rowSampleResidualCross U r samples := by
  ext a
  unfold rowSampleResidualCross
  rw [Finset.sum_div]
  apply Finset.sum_congr rfl
  intro t _
  let i := samples t
  by_cases hp : rowSqNormProb U i = 0
  · have hz := rowSampleResidualCross_row_zero_of_prob_zero U hden i hp a
    simp [rowSampleSketch, rowSampleIncrement, i, hz]
  · have hpnonneg := rowSqNormProb_nonneg U hden i
    have hppos : 0 < rowSqNormProb U i := lt_of_le_of_ne hpnonneg (Ne.symm hp)
    have hscale : rowSampleScaleDen s U i * rowSampleScaleDen s U i =
        (s : ℝ) * rowSqNormProb U i := by
      exact Real.mul_self_sqrt (mul_nonneg hs.le hpnonneg)
    change U i a / rowSampleScaleDen s U i * (r i / rowSampleScaleDen s U i) =
      U i a * r i / rowSqNormProb U i / (s : ℝ)
    field_simp [rowSampleScaleDen_ne_zero s U i hs hppos, hp, hs.ne']
    rw [sq, hscale]
    ring

/-- Rank-adapted orthonormal basis of the input column space. Appending the zero
vector to the generating columns does not enlarge their span. -/
noncomputable def lsColumnSpaceBasisMatrix {m n : ℕ}
    (A : Fin m → Fin n → ℝ) :=
  augmentedSpanBasisMatrix A (fun _ => 0)

/-- Coordinates of the input columns in the rank-adapted basis. -/
noncomputable def lsColumnSpaceColumnCoords {m n : ℕ}
    (A : Fin m → Fin n → ℝ) :=
  augmentedSpanColumnCoords A (fun _ => 0)

theorem hasOrthonormalColumns_lsColumnSpaceBasisMatrix {m n : ℕ}
    (A : Fin m → Fin n → ℝ) : HasOrthonormalColumns (lsColumnSpaceBasisMatrix A) :=
  hasOrthonormalColumns_augmentedSpanBasisMatrix A (fun _ => 0)

theorem lsColumnSpaceBasisMatrix_input_representation {m n : ℕ}
    (A : Fin m → Fin n → ℝ) : ∀ i j,
    A i j = ∑ a, lsColumnSpaceBasisMatrix A i a * lsColumnSpaceColumnCoords A j a := by
  exact (columnsAndRhsInColumnSpace_augmentedSpanBasisMatrix A (fun _ => 0)).1

/-- Every selected basis column is a linear combination of the actual input
columns. This also shows the construction does not hide an augmented b-space. -/
theorem lsColumnSpaceBasisMatrix_column_in_range {m n : ℕ}
    (A : Fin m → Fin n → ℝ)
    (a : Fin (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)))) :
    ∃ q : Fin n → ℝ, ∀ i, lsColumnSpaceBasisMatrix A i a = rectMatMulVec A q i := by
  classical
  let S := augmentedDataSpan A (fun _ => 0)
  let B := stdOrthonormalBasis ℝ S
  have hb : ((B a : S) : EuclideanSpace ℝ (Fin m)) ∈
      Submodule.span ℝ (Set.range (augmentedDataVector A (fun _ => 0))) := (B a).property
  obtain ⟨c, hc⟩ := (Submodule.mem_span_range_iff_exists_fun ℝ).mp hb
  refine ⟨fun j => c (Sum.inl j), ?_⟩
  intro i
  have hi := congrArg (fun v : EuclideanSpace ℝ (Fin m) => v i) hc
  change lsColumnSpaceBasisMatrix A i a = _
  symm
  simpa [rectMatMulVec, lsColumnSpaceBasisMatrix, augmentedSpanBasisMatrix,
    augmentedDataVector, euclideanVec, Pi.smul_apply, smul_eq_mul, S, B, mul_comm]
    using hi

/-- Coefficient witnesses for expressing basis columns in the input range. -/
noncomputable def lsColumnSpaceBasisInputCoords {m n : ℕ}
    (A : Fin m → Fin n → ℝ)
    (a : Fin (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)))) : Fin n → ℝ :=
  Classical.choose (lsColumnSpaceBasisMatrix_column_in_range A a)

theorem lsColumnSpaceBasisMatrix_range_representation {m n : ℕ}
    (A : Fin m → Fin n → ℝ) : ∀ i a,
    lsColumnSpaceBasisMatrix A i a = rectMatMulVec A (lsColumnSpaceBasisInputCoords A a) i := by
  intro i a
  exact Classical.choose_spec (lsColumnSpaceBasisMatrix_column_in_range A a) i

/-- Zero-dimensional column space makes every coefficient vector equally good. -/
theorem lsObjective_eq_of_zero_columnSpace_basis
    {m n : ℕ} (A : Fin m → Fin n → ℝ)
    (hzero : Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) = 0)
    (b : Fin m → ℝ) (x y : Fin n → ℝ) :
    lsObjective A b x = lsObjective A b y := by
  have hA : ∀ i j, A i j = 0 := by
    intro i j
    have h := lsColumnSpaceBasisMatrix_input_representation A i j
    haveI : IsEmpty (Fin (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)))) := by
      rw [hzero]
      infer_instance
    simpa using h
  unfold lsObjective
  congr 1
  ext i
  simp [lsResidual, rectMatMulVec, hA]

/-- A squared-objective relative bound implies the same relative residual-norm
bound, so the objective convention preserves the source accuracy guarantee. -/
theorem lsResidual_norm_le_of_objective_le
    {m n : ℕ} {A : Fin m → Fin n → ℝ} {b : Fin m → ℝ}
    {xHat xOpt : Fin n → ℝ} {η : ℝ} (hη : 0 ≤ η)
    (h : lsObjective A b xHat ≤ (1 + η) * lsObjective A b xOpt) :
    vecNorm2 (lsResidual A b xHat) ≤ (1 + η) * vecNorm2 (lsResidual A b xOpt) := by
  have hfactor : 1 + η ≤ (1 + η) ^ 2 := by nlinarith
  have hb := h.trans (mul_le_mul_of_nonneg_right hfactor (lsObjective_nonneg A b xOpt))
  apply (sq_le_sq₀ (vecNorm2_nonneg _) (mul_nonneg (by linarith) (vecNorm2_nonneg _))).mp
  rw [mul_pow, vecNorm2_sq, vecNorm2_sq]
  exact hb

end NumStability
