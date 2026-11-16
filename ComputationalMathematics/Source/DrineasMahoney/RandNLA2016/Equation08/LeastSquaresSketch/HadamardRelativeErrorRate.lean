import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Concentration.TraceMGF.UniformRowsLinearVariance
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LeastSquaresSketching.UniformResidualCross
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Preconditioning.ExactTransforms.UniformRowComposition
import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Algorithm03.RandomProjectionPreconditioning.Preconditioning

/-!
# Signed-Hadamard least squares with reciprocal accuracy sample dependence

Both data and right-hand side undergo the same orthogonal signed-Hadamard
transform, followed by common uniform sampling and exact least-squares solve.
The row cap comes from the existing finite-cube preprocessing theorem. A linear
matrix variance proxy controls the input-column-space lower Gram, while a
scalar second moment controls the optimal residual cross product.
-/

namespace NumStability
open scoped BigOperators

/-- Uniform row-sampled least squares under a deterministic row leverage cap.
The two budgets are linear in the cap and the accuracy budget is reciprocal. -/
theorem uniformRowTraceProbability_eventProb_lsObjective_le_one_add_eta_of_row_cap
    {m n d s : ℕ} (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ)
    (U : Fin m → Fin d → ℝ) (hU : HasOrthonormalColumns U)
    (C : Fin n → Fin d → ℝ) (Q : Fin d → Fin n → ℝ)
    (hA : ∀ i j, A i j = ∑ a : Fin d, U i a * C j a)
    (hQ : ∀ i a, U i a = rectMatMulVec A (Q a) i)
    (hm : 0 < m) (hd : 0 < d) (hs : 0 < (s : ℝ))
    (xHat : RowTrace m s → Fin n → ℝ) (xOpt : Fin n → ℝ)
    (hopt : IsLeastSquaresMinimizer A b xOpt)
    (hhat : ∀ samples, IsLeastSquaresMinimizer
      (rowSampleSketchWithProb s A uniformRowProb samples)
      (rowSampleVectorWithProb uniformRowProb b samples) (xHat samples))
    {L η δ : ℝ} (hL : 1 ≤ L) (hη : 0 < η) (hδ : 0 < δ) (hδone : δ < 1)
    (hrow : ∀ i : Fin m, (m : ℝ) * rowNormSq U i ≤ L)
    (hbudgetEmbedding : 10 * L * Real.log ((2 * (d : ℝ)) / δ) ≤ (s : ℝ))
    (hbudgetCross : 8 * L / (η * δ) ≤ (s : ℝ)) :
    1 - δ ≤ (uniformRowTraceProbability (steps := s) hm).eventProb
      {samples | lsObjective A b (xHat samples) ≤ (1 + η) * lsObjective A b xOpt} := by
  classical
  let P := uniformRowTraceProbability (steps := s) hm
  let EGram : Set (RowTrace m s) := {samples | finiteLoewnerLe
    (fun j k : Fin d => -(uniformRowSampleGram U samples j k - finiteIdMatrix j k))
    (fun j k : Fin d => (1 / 2 : ℝ) * finiteIdMatrix j k)}
  let ECross : Set (RowTrace m s) := {samples |
    vecNorm2Sq (uniformRowResidualCross U (lsResidual A b xOpt) samples) ≤
      η / 4 * lsObjective A b xOpt}
  have hGram : 1 - δ / 2 ≤ P.eventProb EGram :=
    uniformRowTraceProbability_eventProb_uniformRowSampleGram_lower_half_ge_one_sub_of_linear_budget
      U hU hm hd hs hL hδ hδone hrow hbudgetEmbedding
  have hCross : 1 - 4 * L / ((s : ℝ) * η) ≤ P.eventProb ECross := by
    exact uniformRowResidualCross_eventProb_ge_one_sub U (lsResidual A b xOpt)
      hm hs (by linarith) hrow
      (lsResidual_orthogonal_of_basis_columns_in_range A b U Q hQ xOpt hopt) η hη
  have hinter := P.eventProb_inter_ge_one_sub_add EGram ECross (δ / 2)
    (4 * L / ((s : ℝ) * η)) hGram hCross
  have hfail : δ / 2 + 4 * L / ((s : ℝ) * η) ≤ δ := by
    have hb := (div_le_iff₀ (mul_pos hη hδ)).mp hbudgetCross
    have hc : 4 * L / ((s : ℝ) * η) ≤ δ / 2 := by
      apply (div_le_iff₀ (mul_pos hs hη)).mpr
      nlinarith
    linarith
  have hsub : EGram ∩ ECross ⊆
      {samples | lsObjective A b (xHat samples) ≤ (1 + η) * lsObjective A b xOpt} := by
    intro samples hgood
    have hdeter := lsObjective_le_min_add_uniform_cross A b U hU C hA
      hm hs samples (xHat samples) xOpt hopt (hhat samples) hgood.1
    have hc := hgood.2
    change vecNorm2Sq (uniformRowResidualCross U (lsResidual A b xOpt) samples) ≤
      η / 4 * lsObjective A b xOpt at hc
    change lsObjective A b (xHat samples) ≤ (1 + η) * lsObjective A b xOpt
    nlinarith
  exact (sub_le_sub_left hfail 1).trans (hinter.trans (P.eventProb_mono hsub))

/-- The signed-Hadamard preprocessing radius is bounded by a linear rank plus
logarithm cap. -/
theorem signedHadamard_row_cap_radius_le
    {m d : ℕ} (hm : 0 < m) {δ : ℝ} (hδ : 0 < δ) (hδm : δ < (m : ℝ)) :
    (m : ℝ) * (Real.sqrt ((d : ℝ) * (m : ℝ)⁻¹) +
      Real.sqrt (8 * Real.log ((m : ℝ) / δ) / (m : ℝ))) ^ 2 ≤
        2 * (d : ℝ) + 16 * Real.log ((m : ℝ) / δ) := by
  have hmR : 0 < (m : ℝ) := by exact_mod_cast hm
  have hlog : 0 ≤ Real.log ((m : ℝ) / δ) := by
    apply Real.log_nonneg
    exact (le_div_iff₀ hδ).mpr (by simpa using hδm.le)
  let a := Real.sqrt ((d : ℝ) * (m : ℝ)⁻¹)
  let b := Real.sqrt (8 * Real.log ((m : ℝ) / δ) / (m : ℝ))
  have ha : (m : ℝ) * a ^ 2 = (d : ℝ) := by
    dsimp [a]
    rw [Real.sq_sqrt (mul_nonneg (Nat.cast_nonneg d) (inv_nonneg.mpr hmR.le))]
    field_simp
  have hb : (m : ℝ) * b ^ 2 = 8 * Real.log ((m : ℝ) / δ) := by
    dsimp [b]
    rw [Real.sq_sqrt (div_nonneg (mul_nonneg (by norm_num) hlog) hmR.le)]
    field_simp
  have hdiff := mul_nonneg hmR.le (sq_nonneg (a - b))
  change (m : ℝ) * (a + b) ^ 2 ≤ _
  nlinarith

/-- Page-87 signed-Hadamard then uniform-sampling LS algorithm, for an arbitrary
basis of exactly the input column space. The basis affects only the analysis;
the literal algorithm samples uniformly after transforming both A and b. -/
theorem signedHadamardUniformRowTraceProbability_eventProb_lsObjective_le_one_add_eta_of_columnSpace_sample_count
    {m n d s : ℕ} (H : Fin m → Fin m → ℝ)
    (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ)
    (U : Fin m → Fin d → ℝ) (hU : HasOrthonormalColumns U)
    (C : Fin n → Fin d → ℝ) (Q : Fin d → Fin n → ℝ)
    (hA : ∀ i j, A i j = ∑ a : Fin d, U i a * C j a)
    (hQ : ∀ i a, U i a = rectMatMulVec A (Q a) i)
    (hH : IsOrthogonal m H) (hflat : HadamardFlat m H)
    (hm : 0 < m) (hd : 0 < d) (hs : 0 < (s : ℝ))
    (xHat : RademacherTrace m × RowTrace m s → Fin n → ℝ) (xOpt : Fin n → ℝ)
    (hopt : IsLeastSquaresMinimizer A b xOpt)
    (hhat : ∀ ω samples, IsLeastSquaresMinimizer
      (rowSampleSketchWithProb s
        (preconditionRows (matMul m H (diagMatrix (rademacherSignVector ω))) A)
        uniformRowProb samples)
      (rowSampleVectorWithProb uniformRowProb
        (matMulVec m (matMul m H (diagMatrix (rademacherSignVector ω))) b) samples)
      (xHat (ω, samples)))
    {η δPre δSample : ℝ} (hη : 0 < η)
    (hδPre : 0 < δPre) (hδPreOne : δPre < 1)
    (hδSample : 0 < δSample) (hδSampleOne : δSample < 1)
    (hbudgetEmbedding :
      10 * (2 * (d : ℝ) + 16 * Real.log ((m : ℝ) / δPre)) *
        Real.log ((2 * (d : ℝ)) / δSample) ≤ (s : ℝ))
    (hbudgetCross :
      8 * (2 * (d : ℝ) + 16 * Real.log ((m : ℝ) / δPre)) / (η * δSample) ≤ (s : ℝ)) :
    1 - (δPre + δSample) ≤
      (signedHadamardUniformRowTraceProbability (m := m) (s := s) hm).eventProb
        {z | lsObjective A b (xHat z) ≤ (1 + η) * lsObjective A b xOpt} := by
  classical
  let P := rademacherTraceProbability m
  let R := uniformRowTraceProbability (m := m) (steps := s) hm
  let T : RademacherTrace m → Fin m → Fin m → ℝ :=
    fun ω => matMul m H (diagMatrix (rademacherSignVector ω))
  let V : RademacherTrace m → Fin m → Fin d → ℝ := fun ω => preconditionRows (T ω) U
  let A' : RademacherTrace m → Fin m → Fin n → ℝ := fun ω => preconditionRows (T ω) A
  let b' : RademacherTrace m → Fin m → ℝ := fun ω => matMulVec m (T ω) b
  let L := 2 * (d : ℝ) + 16 * Real.log ((m : ℝ) / δPre)
  let EPre : Set (RademacherTrace m) := {ω | ∀ i : Fin m,
    rowNormSq (V ω) i ≤ (Real.sqrt ((d : ℝ) * (m : ℝ)⁻¹) +
      Real.sqrt (8 * Real.log ((m : ℝ) / δPre) / (m : ℝ))) ^ 2}
  let F : RademacherTrace m → Set (RowTrace m s) :=
    fun ω => {samples | lsObjective A b (xHat (ω, samples)) ≤ (1 + η) * lsObjective A b xOpt}
  have hmR : (1 : ℝ) ≤ (m : ℝ) := by exact_mod_cast hm
  have hdR : (1 : ℝ) ≤ (d : ℝ) := by exact_mod_cast hd
  have hδPrem : δPre < (m : ℝ) := lt_of_lt_of_le hδPreOne hmR
  have hlog : 0 ≤ Real.log ((m : ℝ) / δPre) :=
    Real.log_nonneg ((le_div_iff₀ hδPre).mpr (by simpa using hδPrem.le))
  have hL : 1 ≤ L := by dsimp [L]; linarith
  have hPre : 1 - δPre ≤ P.eventProb EPre := by
    exact rademacherTraceProbability_eventProb_forall_rowNormSq_signedHadamard_le_log_delta_ge_one_sub_delta
      H U hm hflat hU hδPre hδPrem
  have hcond : ∀ ω, ω ∈ EPre → 1 - δSample ≤ R.eventProb (F ω) := by
    intro ω hω
    have hT : IsOrthogonal m (T ω) :=
      signedOrthogonalPreconditioner_isOrthogonal H (rademacherSignVector ω) hH (rademacherSignVector_sq ω)
    have hV : HasOrthonormalColumns (V ω) :=
      signedOrthogonalPreconditionRows_hasOrthonormalColumns H (rademacherSignVector ω) U hH
        (rademacherSignVector_sq ω) hU
    have hrow : ∀ i : Fin m, (m : ℝ) * rowNormSq (V ω) i ≤ L := by
      intro i
      exact (mul_le_mul_of_nonneg_left (hω i) (Nat.cast_nonneg m)).trans
        (signedHadamard_row_cap_radius_le hm hδPre hδPrem)
    have hA' : ∀ i j, A' ω i j = ∑ a : Fin d, V ω i a * C j a := by
      intro i j
      dsimp [A', V, preconditionRows]
      simp_rw [hA, Finset.mul_sum]
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro a _
      rw [Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro k _
      ring
    have hQ' : ∀ i a, V ω i a = rectMatMulVec (A' ω) (Q a) i := by
      intro i a
      change (∑ k : Fin m, T ω i k * U k a) =
        rectMatMulVec (matMulRectLeft (T ω) A) (Q a) i
      rw [rectMatMulVec_matMulRectLeft]
      simp_rw [hQ]
      rfl
    have hobj : ∀ x, lsObjective (A' ω) (b' ω) x = lsObjective A b x := by
      intro x
      exact lsObjective_matMulRectLeft_orthogonal (T ω) A b x hT
    have hopt' : IsLeastSquaresMinimizer (A' ω) (b' ω) xOpt := by
      intro x
      simpa only [hobj] using hopt x
    have hp := uniformRowTraceProbability_eventProb_lsObjective_le_one_add_eta_of_row_cap
      (A' ω) (b' ω) (V ω) hV C Q hA' hQ' hm hd hs
      (fun samples => xHat (ω, samples)) xOpt hopt' (hhat ω)
      hL hη hδSample hδSampleOne hrow hbudgetEmbedding hbudgetCross
    simpa only [hobj] using hp
  have hjoint := P.prod_eventProb_inter_dependent_ge_one_sub_add R EPre F δPre δSample
    hδSample.le hPre hcond
  apply hjoint.trans
  apply FiniteProbability.eventProb_mono
  intro z hz
  exact hz.2

/-- A rank-adapted, input-only instance of the literal signed-Hadamard uniform
sampling algorithm. Write `d=rank(A)` and `L=2d+16log(2m/δ)`. Sufficient sample
counts are `10L log(4d/δ)` and `16L/(ηδ)`, giving probability at least `1-δ`.
In particular the final accuracy occurs to the first reciprocal power. -/
theorem signedHadamardUniformRowTraceProbability_eventProb_lsObjective_le_one_add_eta_of_rank_sample_count
    {m n s : ℕ} (H : Fin m → Fin m → ℝ)
    (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ)
    (hH : IsOrthogonal m H) (hflat : HadamardFlat m H)
    (hm : 0 < m)
    (hd : 0 < Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)))
    (hs : 0 < (s : ℝ))
    (xHat : RademacherTrace m × RowTrace m s → Fin n → ℝ) (xOpt : Fin n → ℝ)
    (hopt : IsLeastSquaresMinimizer A b xOpt)
    (hhat : ∀ ω samples, IsLeastSquaresMinimizer
      (rowSampleSketchWithProb s
        (preconditionRows (matMul m H (diagMatrix (rademacherSignVector ω))) A)
        uniformRowProb samples)
      (rowSampleVectorWithProb uniformRowProb
        (matMulVec m (matMul m H (diagMatrix (rademacherSignVector ω))) b) samples)
      (xHat (ω, samples)))
    {η δ : ℝ} (hη : 0 < η) (hδ : 0 < δ) (hδone : δ < 1)
    (hbudgetEmbedding :
      let d := (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) : ℝ)
      let L := 2 * d + 16 * Real.log ((2 * (m : ℝ)) / δ)
      10 * L * Real.log ((4 * d) / δ) ≤ (s : ℝ))
    (hbudgetCross :
      let d := (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) : ℝ)
      let L := 2 * d + 16 * Real.log ((2 * (m : ℝ)) / δ)
      16 * L / (η * δ) ≤ (s : ℝ)) :
    1 - δ ≤ (signedHadamardUniformRowTraceProbability (m := m) (s := s) hm).eventProb
      {z | lsObjective A b (xHat z) ≤ (1 + η) * lsObjective A b xOpt} := by
  let d := Module.finrank ℝ (augmentedDataSpan A (fun _ => 0))
  have hmLog : Real.log ((m : ℝ) / (δ / 2)) = Real.log ((2 * (m : ℝ)) / δ) := by
    congr 1
    ring
  have hdLog : Real.log ((2 * (d : ℝ)) / (δ / 2)) = Real.log ((4 * (d : ℝ)) / δ) := by
    congr 1
    ring
  have hembedding :
      10 * (2 * (d : ℝ) + 16 * Real.log ((m : ℝ) / (δ / 2))) *
        Real.log ((2 * (d : ℝ)) / (δ / 2)) ≤ (s : ℝ) := by
    rw [hmLog, hdLog]
    exact hbudgetEmbedding
  have hcross :
      8 * (2 * (d : ℝ) + 16 * Real.log ((m : ℝ) / (δ / 2))) / (η * (δ / 2)) ≤ (s : ℝ) := by
    rw [hmLog]
    convert hbudgetCross using 1
    ring
  have hp :=
    signedHadamardUniformRowTraceProbability_eventProb_lsObjective_le_one_add_eta_of_columnSpace_sample_count
      H A b (lsColumnSpaceBasisMatrix A) (hasOrthonormalColumns_lsColumnSpaceBasisMatrix A)
      (lsColumnSpaceColumnCoords A) (lsColumnSpaceBasisInputCoords A)
      (lsColumnSpaceBasisMatrix_input_representation A) (lsColumnSpaceBasisMatrix_range_representation A)
      hH hflat hm hd hs xHat xOpt hopt hhat hη
      (δPre := δ / 2) (δSample := δ / 2)
      (by linarith) (by linarith) (by linarith) (by linarith) hembedding hcross
  have heq : δ / 2 + δ / 2 = δ := by ring
  simpa only [heq] using hp

/-- Zero rank needs no sampling; the residual norm is independent of the output
coefficient vector, including the degenerate empty input dimensions. -/
theorem lsResidual_norm_le_one_add_eta_of_zero_column_rank
    {m n : ℕ} (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ)
    (hzero : Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) = 0)
    (xHat xOpt : Fin n → ℝ) {η : ℝ} (hη : 0 ≤ η) :
    vecNorm2 (lsResidual A b xHat) ≤ (1 + η) * vecNorm2 (lsResidual A b xOpt) := by
  apply lsResidual_norm_le_of_objective_le hη
  rw [lsObjective_eq_of_zero_columnSpace_basis A hzero b xHat xOpt]
  have hnonneg := lsObjective_nonneg A b xOpt
  nlinarith

/-- Equation (8) unsquared residual accuracy for the same literal algorithm
and the same reciprocal-accuracy sample budgets. -/
theorem signedHadamardUniformRowTraceProbability_eventProb_lsResidual_norm_le_one_add_eta_of_rank_sample_count
    {m n s : ℕ} (H : Fin m → Fin m → ℝ)
    (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ)
    (hH : IsOrthogonal m H) (hflat : HadamardFlat m H)
    (hm : 0 < m)
    (hd : 0 < Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)))
    (hs : 0 < (s : ℝ))
    (xHat : RademacherTrace m × RowTrace m s → Fin n → ℝ) (xOpt : Fin n → ℝ)
    (hopt : IsLeastSquaresMinimizer A b xOpt)
    (hhat : ∀ ω samples, IsLeastSquaresMinimizer
      (rowSampleSketchWithProb s
        (preconditionRows (matMul m H (diagMatrix (rademacherSignVector ω))) A)
        uniformRowProb samples)
      (rowSampleVectorWithProb uniformRowProb
        (matMulVec m (matMul m H (diagMatrix (rademacherSignVector ω))) b) samples)
      (xHat (ω, samples)))
    {η δ : ℝ} (hη : 0 < η) (hδ : 0 < δ) (hδone : δ < 1)
    (hbudgetEmbedding :
      let d := (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) : ℝ)
      let L := 2 * d + 16 * Real.log ((2 * (m : ℝ)) / δ)
      10 * L * Real.log ((4 * d) / δ) ≤ (s : ℝ))
    (hbudgetCross :
      let d := (Module.finrank ℝ (augmentedDataSpan A (fun _ => 0)) : ℝ)
      let L := 2 * d + 16 * Real.log ((2 * (m : ℝ)) / δ)
      16 * L / (η * δ) ≤ (s : ℝ)) :
    1 - δ ≤ (signedHadamardUniformRowTraceProbability (m := m) (s := s) hm).eventProb
      {z | vecNorm2 (lsResidual A b (xHat z)) ≤ (1 + η) * vecNorm2 (lsResidual A b xOpt)} := by
  have hp := signedHadamardUniformRowTraceProbability_eventProb_lsObjective_le_one_add_eta_of_rank_sample_count
    H A b hH hflat hm hd hs xHat xOpt hopt hhat hη hδ hδone hbudgetEmbedding hbudgetCross
  apply hp.trans
  apply FiniteProbability.eventProb_mono
  intro z hgood
  exact lsResidual_norm_le_of_objective_le hη.le hgood

end NumStability
