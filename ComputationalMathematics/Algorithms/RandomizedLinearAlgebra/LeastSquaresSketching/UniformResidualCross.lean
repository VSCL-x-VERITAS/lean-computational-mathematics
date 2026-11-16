import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LeastSquaresSketching.ResidualCross
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.UniformRows.Core

/-!
# Uniform-sampling least-squares residual cross terms

Uniform row-trace moments and leverage caps give deterministic and probabilistic
residual cross-term bounds for the exact sampled least-squares objective.
-/

namespace NumStability
open scoped BigOperators

/-- Uniform row sampling is the row-norm law of the ambient identity matrix. -/
theorem rowSqNormProb_idMatrix_eq_uniformRowProb {m : ℕ}
    (i : Fin m) : rowSqNormProb (idMatrix m) i = uniformRowProb i := by
  unfold rowSqNormProb
  rw [show rowSqNormProbDen (idMatrix m) = (m : ℝ) from
    rowSqNormProbDen_eq_nat_of_orthonormal_columns _ (hasOrthonormalColumns_idMatrix m)]
  simp [rowNormSq, idMatrix, uniformRowProb]

/-- The identical iid uniform trace law, with all normalization proofs hidden
by finite-probability extensionality. -/
theorem rowSqNormTraceProbability_idMatrix_eq_uniformRowTraceProbability
    {m s : ℕ} (hm : 0 < m) :
    rowSqNormTraceProbability (steps := s) (idMatrix m)
      (rowSqNormProbDen_pos_of_orthonormal_columns _ (hasOrthonormalColumns_idMatrix m) hm) =
      uniformRowTraceProbability (steps := s) hm := by
  apply FiniteProbability.ext
  intro samples
  simp [rowSqNormTraceProbability, uniformRowTraceProbability,
    rowSqNormTraceProbMass, uniformRowTraceProbMass,
    rowSqNormProb_idMatrix_eq_uniformRowProb]

/-- Residual cross product for the literal uniform row-sampling sketch. -/
noncomputable def uniformRowResidualCross {m d s : ℕ}
    (U : Fin m → Fin d → ℝ) (r : Fin m → ℝ) (samples : RowTrace m s) : Fin d → ℝ :=
  fun j => (∑ t : Fin s, (m : ℝ) * U (samples t) j * r (samples t)) / (s : ℝ)

/-- Uniform residual cross variance scales linearly in the row leverage cap. -/
theorem uniformRowResidualCross_expectation_vecNorm2Sq_le
    {m d s : ℕ} (U : Fin m → Fin d → ℝ) (r : Fin m → ℝ)
    (hm : 0 < m) (hs : 0 < (s : ℝ)) {L : ℝ}
    (hrow : ∀ i : Fin m, (m : ℝ) * rowNormSq U i ≤ L)
    (horth : ∀ j : Fin d, ∑ i : Fin m, U i j * r i = 0) :
    (uniformRowTraceProbability (steps := s) hm).expectationReal
      (fun samples => vecNorm2Sq (uniformRowResidualCross U r samples)) ≤
      L / (s : ℝ) * vecNorm2Sq r := by
  classical
  have hmR : (m : ℝ) ≠ 0 := by exact_mod_cast hm.ne'
  have hcoord : ∀ j : Fin d,
      (uniformRowTraceProbability (steps := s) hm).expectationReal
        (fun samples => uniformRowResidualCross U r samples j ^ 2) =
      (1 / (s : ℝ)) * ∑ i : Fin m,
        uniformRowProb i * ((m : ℝ) * U i j * r i) ^ 2 := by
    intro j
    have hv := rowSqNormTraceProbability_expectationReal_sampleAverage_sub_mean_sq
      (s := s) (idMatrix m)
      (rowSqNormProbDen_pos_of_orthonormal_columns _ (hasOrthonormalColumns_idMatrix m) hm)
      hs (fun i => (m : ℝ) * U i j * r i)
    have hmean : (∑ i : Fin m, uniformRowProb i * ((m : ℝ) * U i j * r i)) = 0 := by
      calc
        _ = ∑ i : Fin m, U i j * r i := by
          apply Finset.sum_congr rfl
          intro i _
          dsimp [uniformRowProb]
          field_simp
        _ = 0 := horth j
    simpa [rowSqNormTraceProbability_idMatrix_eq_uniformRowTraceProbability hm,
      rowSqNormProb_idMatrix_eq_uniformRowProb, hmean, uniformRowResidualCross] using hv
  calc
    _ = (1 / (s : ℝ)) * ∑ i : Fin m, ∑ j : Fin d,
        uniformRowProb i * ((m : ℝ) * U i j * r i) ^ 2 := by
      unfold vecNorm2Sq
      rw [FiniteProbability.expectationReal_sum]
      simp_rw [hcoord]
      rw [← Finset.mul_sum, Finset.sum_comm]
    _ = (1 / (s : ℝ)) * ∑ i : Fin m, ((m : ℝ) * rowNormSq U i) * r i ^ 2 := by
      congr 1
      apply Finset.sum_congr rfl
      intro i _
      unfold rowNormSq
      rw [Finset.mul_sum, Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro j _
      dsimp [uniformRowProb]
      field_simp
    _ ≤ (1 / (s : ℝ)) * ∑ i : Fin m, L * r i ^ 2 := by
      apply mul_le_mul_of_nonneg_left _ (by positivity)
      apply Finset.sum_le_sum
      intro i _
      exact mul_le_mul_of_nonneg_right (hrow i) (sq_nonneg _)
    _ = L / (s : ℝ) * vecNorm2Sq r := by
      rw [← Finset.mul_sum]
      unfold vecNorm2Sq
      ring

/-- Relative Markov bound for uniform sampled residual cross products. -/
theorem uniformRowResidualCross_eventProb_ge_one_sub
    {m d s : ℕ} (U : Fin m → Fin d → ℝ) (r : Fin m → ℝ)
    (hm : 0 < m) (hs : 0 < (s : ℝ)) {L : ℝ} (hL : 0 ≤ L)
    (hrow : ∀ i : Fin m, (m : ℝ) * rowNormSq U i ≤ L)
    (horth : ∀ j : Fin d, ∑ i : Fin m, U i j * r i = 0)
    (η : ℝ) (hη : 0 < η) :
    1 - 4 * L / ((s : ℝ) * η) ≤ (uniformRowTraceProbability (steps := s) hm).eventProb
      {samples | vecNorm2Sq (uniformRowResidualCross U r samples) ≤ η / 4 * vecNorm2Sq r} := by
  classical
  let P := uniformRowTraceProbability (steps := s) hm
  by_cases hr : vecNorm2Sq r = 0
  · have hrzero : ∀ i, r i = 0 := by
      have hsum := (Finset.sum_eq_zero_iff_of_nonneg
        (fun i (_ : i ∈ (Finset.univ : Finset (Fin m))) => sq_nonneg (r i))).mp hr
      intro i
      exact sq_eq_zero_iff.mp (hsum i (Finset.mem_univ i))
    have hevent : P.eventProb {samples | vecNorm2Sq (uniformRowResidualCross U r samples) ≤
        η / 4 * vecNorm2Sq r} = 1 := by
      apply P.eventProb_eq_one_of_forall
      intro samples
      simp [uniformRowResidualCross, hrzero, vecNorm2Sq]
    rw [hevent]
    have : 0 ≤ 4 * L / ((s : ℝ) * η) := by positivity
    linarith
  · have hrpos : 0 < vecNorm2Sq r := lt_of_le_of_ne (vecNorm2Sq_nonneg r) (Ne.symm hr)
    have hT : 0 < η / 4 * vecNorm2Sq r := by positivity
    have hmom := uniformRowResidualCross_expectation_vecNorm2Sq_le U r hm hs hrow horth
    have hmarkov := P.eventProb_real_le_ge_one_sub_expectationReal_div
      (fun samples => vecNorm2Sq (uniformRowResidualCross U r samples))
      (η / 4 * vecNorm2Sq r) (fun _ => vecNorm2Sq_nonneg _) hT
    have hratio : P.expectationReal
        (fun samples => vecNorm2Sq (uniformRowResidualCross U r samples)) /
          (η / 4 * vecNorm2Sq r) ≤ 4 * L / ((s : ℝ) * η) := by
      calc
        _ ≤ (L / (s : ℝ) * vecNorm2Sq r) / (η / 4 * vecNorm2Sq r) :=
          div_le_div_of_nonneg_right hmom hT.le
        _ = _ := by field_simp
    exact (sub_le_sub_left hratio 1).trans hmarkov

/-- Common rescaled right-hand side for a supplied row probability table. -/
noncomputable def rowSampleVectorWithProb {m s : ℕ}
    (p : Fin m → ℝ) (b : Fin m → ℝ) (samples : RowTrace m s) : Fin s → ℝ :=
  fun t => b (samples t) / rowSampleScaleDenWithProb s p (samples t)

/-- Deterministic residual-cross endgame for an arbitrary common linear sketch.
Only a lower embedding inequality is required. -/
theorem lsObjective_le_min_add_cross_of_factored_sketch
    {m n d s : ℕ} (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ)
    (U : Fin m → Fin d → ℝ) (hU : HasOrthonormalColumns U)
    (C : Fin n → Fin d → ℝ)
    (hA : ∀ i j, A i j = ∑ a : Fin d, U i a * C j a)
    (SA : Fin s → Fin n → ℝ) (Sb : Fin s → ℝ)
    (V : Fin s → Fin d → ℝ) (w : Fin s → ℝ)
    (hSA : ∀ t j, SA t j = ∑ a : Fin d, V t a * C j a)
    (xHat xOpt : Fin n → ℝ) (hopt : IsLeastSquaresMinimizer A b xOpt)
    (hhat : IsLeastSquaresMinimizer SA Sb xHat)
    (hw : ∀ t, lsResidual SA Sb xOpt t = w t)
    (hlower : ∀ z : Fin d → ℝ, (1 / 2 : ℝ) * vecNorm2Sq z ≤
      vecNorm2Sq (rectMatMulVec V z)) :
    lsObjective A b xHat ≤ lsObjective A b xOpt +
      4 * vecNorm2Sq (fun a => ∑ t : Fin s, V t a * w t) := by
  classical
  let q : Fin n → ℝ := fun j => xHat j - xOpt j
  let z : Fin d → ℝ := fun a => ∑ j : Fin n, C j a * q j
  let v := rectMatMulVec V z
  let g : Fin d → ℝ := fun a => ∑ t : Fin s, V t a * w t
  have hv : ∀ t, rectMatMulVec SA q t = v t :=
    rectMatMulVec_eq_basis_coordinate_sum SA V C hSA q
  have hr : ∀ t, lsResidual SA Sb xHat t = v t + w t := by
    intro t
    have hlin : rectMatMulVec SA xHat t =
        rectMatMulVec SA q t + rectMatMulVec SA xOpt t := by
      dsimp [rectMatMulVec, q]
      rw [← Finset.sum_add_distrib]
      apply Finset.sum_congr rfl
      intro j _
      ring
    change rectMatMulVec SA xHat t - Sb t = v t + w t
    rw [hlin, hv]
    have hwt := hw t
    change rectMatMulVec SA xOpt t - Sb t = w t at hwt
    linarith
  have hzero := lsResidual_inner_column_combination_eq_zero hhat q
  have hvw : (∑ t : Fin s, v t * (v t + w t)) = 0 := by
    simpa only [hv, hr] using hzero
  have hcross : (∑ t : Fin s, v t * w t) = ∑ a : Fin d, z a * g a := by
    dsimp [v, rectMatMulVec, g]
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

/-- Product of two entries sharing the literal uniform row denominator. -/
theorem uniform_scaled_entry_product {m s : ℕ} (hm : 0 < m)
    (hs : 0 < (s : ℝ)) (i : Fin m) (a b : ℝ) :
    a / rowSampleScaleDenWithProb s (uniformRowProb (m := m)) i *
      (b / rowSampleScaleDenWithProb s (uniformRowProb (m := m)) i) =
        ((m : ℝ) * a * b) / (s : ℝ) := by
  have hmR : 0 < (m : ℝ) := by exact_mod_cast hm
  have hp : 0 < uniformRowProb i := by dsimp [uniformRowProb]; positivity
  have hd := rowSampleScaleDenWithProb_ne_zero s uniformRowProb i hs hp
  have hscale : rowSampleScaleDenWithProb s (uniformRowProb (m := m)) i *
      rowSampleScaleDenWithProb s (uniformRowProb (m := m)) i = (s : ℝ) * (m : ℝ)⁻¹ := by
    exact Real.mul_self_sqrt (mul_nonneg hs.le (le_of_lt (inv_pos.mpr hmR)))
  field_simp [hd, hs.ne']
  rw [sq, hscale]
  field_simp

/-- The literal common uniform sketch has exactly the established uniform Gram. -/
theorem rowSketchGram_uniform_prob_eq {m d s : ℕ}
    (U : Fin m → Fin d → ℝ) (hm : 0 < m) (hs : 0 < (s : ℝ))
    (samples : RowTrace m s) :
    rowSketchGram (rowSampleSketchWithProb s U uniformRowProb samples) =
      uniformRowSampleGram U samples := by
  ext j k
  unfold rowSketchGram uniformRowSampleGram
  rw [Finset.sum_div]
  apply Finset.sum_congr rfl
  intro t _
  exact uniform_scaled_entry_product hm hs (samples t) _ _

/-- The uniform cross estimator is exactly the cross term of the literal sketch. -/
theorem uniform_prob_residual_cross_eq {m d s : ℕ}
    (U : Fin m → Fin d → ℝ) (r : Fin m → ℝ)
    (hm : 0 < m) (hs : 0 < (s : ℝ)) (samples : RowTrace m s) :
    (fun a => ∑ t : Fin s,
      rowSampleSketchWithProb s U uniformRowProb samples t a *
        rowSampleVectorWithProb uniformRowProb r samples t) =
      uniformRowResidualCross U r samples := by
  ext a
  unfold uniformRowResidualCross
  rw [Finset.sum_div]
  apply Finset.sum_congr rfl
  intro t _
  exact uniform_scaled_entry_product hm hs (samples t) _ _

/-- Uniform common row sampling specializes the deterministic LS endgame. -/
theorem lsObjective_le_min_add_uniform_cross
    {m n d s : ℕ} (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ)
    (U : Fin m → Fin d → ℝ) (hU : HasOrthonormalColumns U)
    (C : Fin n → Fin d → ℝ)
    (hA : ∀ i j, A i j = ∑ a : Fin d, U i a * C j a)
    (hm : 0 < m) (hs : 0 < (s : ℝ)) (samples : RowTrace m s)
    (xHat xOpt : Fin n → ℝ) (hopt : IsLeastSquaresMinimizer A b xOpt)
    (hhat : IsLeastSquaresMinimizer
      (rowSampleSketchWithProb s A uniformRowProb samples)
      (rowSampleVectorWithProb uniformRowProb b samples) xHat)
    (hGram : finiteLoewnerLe
      (fun j k : Fin d => -(uniformRowSampleGram U samples j k - finiteIdMatrix j k))
      (fun j k : Fin d => (1 / 2 : ℝ) * finiteIdMatrix j k)) :
    lsObjective A b xHat ≤ lsObjective A b xOpt +
      4 * vecNorm2Sq (uniformRowResidualCross U (lsResidual A b xOpt) samples) := by
  let SA := rowSampleSketchWithProb s A uniformRowProb samples
  let Sb := rowSampleVectorWithProb uniformRowProb b samples
  let V := rowSampleSketchWithProb s U uniformRowProb samples
  let w := rowSampleVectorWithProb uniformRowProb (lsResidual A b xOpt) samples
  have hSA : ∀ t j, SA t j = ∑ a : Fin d, V t a * C j a := by
    intro t j
    dsimp [SA, V, rowSampleSketchWithProb, rowSampleIncrementWithProb]
    rw [hA, Finset.sum_div]
    apply Finset.sum_congr rfl
    intro a _
    ring
  have hw : ∀ t, lsResidual SA Sb xOpt t = w t := by
    intro t
    dsimp [lsResidual, rectMatMulVec, SA, Sb, w, rowSampleVectorWithProb,
      rowSampleSketchWithProb, rowSampleIncrementWithProb]
    rw [sub_div, Finset.sum_div]
    congr 1
    apply Finset.sum_congr rfl
    intro j _
    ring
  have hlower : ∀ z : Fin d → ℝ,
      (1 / 2 : ℝ) * vecNorm2Sq z ≤ vecNorm2Sq (rectMatMulVec V z) := by
    intro z
    have hg := hGram z
    rw [finiteQuadraticForm_smul_finiteIdMatrix, finiteQuadraticForm_neg,
      finiteQuadraticForm_sub, finiteQuadraticForm_finiteIdMatrix] at hg
    have hquad := vecNorm2Sq_rowSketch_linearCombination_eq_quadratic_rowSketchGram V z
    change vecNorm2Sq (rectMatMulVec V z) = _ at hquad
    rw [show rowSketchGram V = uniformRowSampleGram U samples from
      rowSketchGram_uniform_prob_eq U hm hs samples] at hquad
    change vecNorm2Sq (rectMatMulVec V z) = finiteQuadraticForm (uniformRowSampleGram U samples) z at hquad
    rw [hquad]
    rw [finiteVecNorm2Sq_fin] at hg
    linarith
  have hdet := lsObjective_le_min_add_cross_of_factored_sketch A b U hU C hA
    SA Sb V w hSA xHat xOpt hopt hhat hw hlower
  rw [show (fun a => ∑ t : Fin s, V t a * w t) =
    uniformRowResidualCross U (lsResidual A b xOpt) samples from
    uniform_prob_residual_cross_eq U (lsResidual A b xOpt) hm hs samples] at hdet
  exact hdet

end NumStability
