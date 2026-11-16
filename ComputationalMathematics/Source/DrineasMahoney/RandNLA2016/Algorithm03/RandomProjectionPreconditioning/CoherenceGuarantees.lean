import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.UniformRows.ProjectorCoherence
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Concentration.TraceMGF.UniformRowsUpperLinearVariance
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Preconditioning.ExactTransforms.UniformRowComposition
import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Algorithm03.RandomProjectionPreconditioning.Preconditioning

/-!
# Joint signed-Hadamard iid sampling geometry and actual sampled coherence

The sign law and the replacement row law are independent factors. The radius
retains its ambient logarithm. Projector leverage is calculated from the
actual sampled column space, not from an unnormalized sampled row norm.
-/
namespace NumStability
open scoped BigOperators

/-- The fixed-basis table after signed preprocessing. -/
noncomputable def signedHadamardBasis {m d : ℕ}
    (H : Fin m → Fin m → ℝ) (U : Fin m → Fin d → ℝ)
    (ω : RademacherTrace m) : Fin m → Fin d → ℝ :=
  preconditionRows (matMul m H (diagMatrix (rademacherSignVector ω))) U

/-- Sharp primary-source radius with a total failure budget split in half. -/
noncomputable def hadamardJointRowRadius (m d : ℕ) (δ : ℝ) : ℝ :=
  (Real.sqrt (d : ℝ) + Real.sqrt (8 * Real.log ((2 * (m : ℝ)) / δ))) ^ 2

/-- Joint geometry retains the actual row cap, both centered Gram inequalities,
and the literal spectral norm of the sampled table. -/
def signedHadamardJointGeometryEvent {m d s : ℕ}
    (H : Fin m → Fin m → ℝ) (U : Fin m → Fin d → ℝ) (ε δ : ℝ) :
    Set (RademacherTrace m × RowTrace m s) :=
  {z | let Q := signedHadamardBasis H U z.1
       let G := uniformRowSampleGram Q z.2
       (∀ i, rowNormSq Q i ≤ hadamardJointRowRadius m d δ / (m : ℝ)) ∧
       finiteLoewnerLe (fun j k => G j k - finiteIdMatrix j k)
         (fun j k => ε * finiteIdMatrix j k) ∧
       finiteLoewnerLe (fun j k => -(G j k - finiteIdMatrix j k))
         (fun j k => ε * finiteIdMatrix j k) ∧
       opNorm2 (fun j k => finiteIdMatrix j k -
         rowGram (uniformScaledRowSketch Q z.2) j k) ≤ ε}

/-- Sharp radius bounded by rank plus the ambient logarithm. -/
theorem hadamardJointRowRadius_le_linear {m d : ℕ} (hm : 0 < m)
    {δ : ℝ} (hδ : 0 < δ) (hδ1 : δ < 1) :
    hadamardJointRowRadius m d δ ≤
      2 * (d : ℝ) + 16 * Real.log ((2 * (m : ℝ)) / δ) := by
  have hmR : (1 : ℝ) ≤ (m : ℝ) := by exact_mod_cast hm
  have hlog : 0 ≤ Real.log ((2 * (m : ℝ)) / δ) := by
    apply Real.log_nonneg
    apply (le_div_iff₀ hδ).mpr
    nlinarith
  have ha := Real.sq_sqrt (Nat.cast_nonneg d : (0 : ℝ) ≤ (d : ℝ))
  have hb := Real.sq_sqrt (mul_nonneg (by norm_num : (0 : ℝ) ≤ 8) hlog)
  have hdiff := sq_nonneg (Real.sqrt (d : ℝ) - Real.sqrt (8 * Real.log ((2 * (m : ℝ)) / δ)))
  unfold hadamardJointRowRadius
  nlinarith

private theorem hadamardJointRowRadius_eq_normalized {m d : ℕ}
    (hm : 0 < m) {δ : ℝ} (hδ : 0 < δ) (hδ1 : δ < 1) :
    (Real.sqrt ((d : ℝ) * (m : ℝ)⁻¹) +
      Real.sqrt (8 * Real.log ((m : ℝ) / (δ / 2)) / (m : ℝ))) ^ 2 =
      hadamardJointRowRadius m d δ / (m : ℝ) := by
  have hmR : (1 : ℝ) ≤ (m : ℝ) := by exact_mod_cast hm
  have harg : (m : ℝ) / (δ / 2) = (2 * (m : ℝ)) / δ := by ring
  have hlog : 0 ≤ 8 * Real.log ((2 * (m : ℝ)) / δ) := by
    apply mul_nonneg (by norm_num)
    apply Real.log_nonneg
    apply (le_div_iff₀ hδ).mpr
    nlinarith
  rw [harg, ← div_eq_mul_inv, Real.sqrt_div (Nat.cast_nonneg d),
    Real.sqrt_div hlog, ← add_div, div_pow, Real.sq_sqrt (Nat.cast_nonneg m)]
  rfl

/-- A universal sufficient sample count for joint signed-Hadamard and actual
independent uniform replacement-row geometry. Positive rank includes one. -/
theorem signedHadamardUniformRowTraceProbability_joint_geometry_of_sample_count
    {m d s : ℕ} (H : Fin m → Fin m → ℝ) (U : Fin m → Fin d → ℝ)
    (hH : IsOrthogonal m H) (hflat : HadamardFlat m H)
    (hU : HasOrthonormalColumns U) (hm : 0 < m) (hd : 0 < d) (hs : 0 < (s : ℝ))
    {ε δ : ℝ} (hε : 0 < ε) (hε1 : ε < 1) (hδ : 0 < δ) (hδ1 : δ < 1)
    (hbudget : 1000 / ε ^ 2 *
      ((d : ℝ) + Real.log ((2 * (m : ℝ)) / δ)) *
        Real.log ((2 * (d : ℝ)) / δ) ≤ (s : ℝ)) :
    1 - δ ≤ (signedHadamardUniformRowTraceProbability (m := m) (s := s) hm).eventProb
      (signedHadamardJointGeometryEvent H U ε δ) := by
  classical
  let P := rademacherTraceProbability m
  let R := uniformRowTraceProbability (m := m) (steps := s) hm
  let Q := signedHadamardBasis H U
  let L := 2 * (d : ℝ) + 16 * Real.log ((2 * (m : ℝ)) / δ)
  let E : Set (RademacherTrace m) := {ω | ∀ i,
    rowNormSq (Q ω) i ≤ hadamardJointRowRadius m d δ / (m : ℝ)}
  let F : RademacherTrace m → Set (RowTrace m s) := fun ω => {samples |
    finiteLoewnerLe (fun j k : Fin d => uniformRowSampleGram (Q ω) samples j k - finiteIdMatrix j k)
      (fun j k => ε * finiteIdMatrix j k) ∧
    finiteLoewnerLe (fun j k : Fin d => -(uniformRowSampleGram (Q ω) samples j k - finiteIdMatrix j k))
      (fun j k => ε * finiteIdMatrix j k)}
  have hmR : (1 : ℝ) ≤ (m : ℝ) := by exact_mod_cast hm
  have hdR : (1 : ℝ) ≤ (d : ℝ) := by exact_mod_cast hd
  have hδhalf : 0 < δ / 2 := by linarith
  have hδhalfm : δ / 2 < (m : ℝ) := by linarith
  have hpre : 1 - δ / 2 ≤ P.eventProb E := by
    have h := rademacherTraceProbability_eventProb_forall_rowNormSq_signedHadamard_le_log_delta_ge_one_sub_delta
      H U hm hflat hU hδhalf hδhalfm
    simpa only [P, E, Q, signedHadamardBasis,
      hadamardJointRowRadius_eq_normalized hm hδ hδ1] using h
  have hlogm : 0 ≤ Real.log ((2 * (m : ℝ)) / δ) := by
    apply Real.log_nonneg
    apply (le_div_iff₀ hδ).mpr
    nlinarith
  have hlogd : 0 ≤ Real.log ((2 * (d : ℝ)) / δ) := by
    apply Real.log_nonneg
    apply (le_div_iff₀ hδ).mpr
    nlinarith
  have hL : 1 ≤ L := by dsimp [L]; linarith
  have hlogdouble : Real.log ((2 * (d : ℝ)) / (δ / 2)) ≤
      2 * Real.log ((2 * (d : ℝ)) / δ) := by
    have harg : (2 * (d : ℝ)) / (δ / 2) = 2 * ((2 * (d : ℝ)) / δ) := by ring
    have htwo : Real.log 2 ≤ Real.log ((2 * (d : ℝ)) / δ) := by
      apply Real.log_le_log (by norm_num)
      apply (le_div_iff₀ hδ).mpr
      nlinarith
    rw [harg, Real.log_mul (by norm_num) (ne_of_gt (div_pos (by positivity) hδ))]
    linarith
  have hbudget' : 10 * L * Real.log ((2 * (d : ℝ)) / (δ / 2)) ≤
      (s : ℝ) * ε ^ 2 := by
    have hLbound : L ≤ 16 * ((d : ℝ) + Real.log ((2 * (m : ℝ)) / δ)) := by
      dsimp [L]; linarith
    have hleft := (mul_le_mul_of_nonneg_left hlogdouble (by linarith : 0 ≤ L)).trans
      (mul_le_mul_of_nonneg_right hLbound (by positivity : 0 ≤ 2 * Real.log ((2 * (d : ℝ)) / δ)))
    have hbudgetscaled := mul_le_mul_of_nonneg_right hbudget (sq_nonneg ε)
    have hcancel : (1000 / ε ^ 2) * ε ^ 2 = 1000 :=
      div_mul_cancel₀ _ (ne_of_gt (sq_pos_of_pos hε))
    have heq : (1000 / ε ^ 2 * ((d : ℝ) + Real.log ((2 * (m : ℝ)) / δ)) *
        Real.log ((2 * (d : ℝ)) / δ)) * ε ^ 2 =
        1000 * ((d : ℝ) + Real.log ((2 * (m : ℝ)) / δ)) * Real.log ((2 * (d : ℝ)) / δ) := by
      calc
        _ = ((1000 / ε ^ 2) * ε ^ 2) *
            ((d : ℝ) + Real.log ((2 * (m : ℝ)) / δ)) * Real.log ((2 * (d : ℝ)) / δ) := by ring
        _ = _ := by rw [hcancel]
    rw [heq] at hbudgetscaled
    have hab : 0 ≤ ((d : ℝ) + Real.log ((2 * (m : ℝ)) / δ)) * Real.log ((2 * (d : ℝ)) / δ) :=
      mul_nonneg (by positivity) hlogd
    nlinarith
  have hconditional : ∀ ω, ω ∈ E → 1 - δ / 2 ≤ R.eventProb (F ω) := by
    intro ω hω
    have hQ : HasOrthonormalColumns (Q ω) :=
      signedOrthogonalPreconditionRows_hasOrthonormalColumns H (rademacherSignVector ω) U hH
        (rademacherSignVector_sq ω) hU
    have hcap : ∀ i, (m : ℝ) * rowNormSq (Q ω) i ≤ L := by
      intro i
      have hi := mul_le_mul_of_nonneg_left (hω i) (Nat.cast_nonneg m)
      have hmne : (m : ℝ) ≠ 0 := by exact_mod_cast (ne_of_gt hm)
      have hr := hadamardJointRowRadius_le_linear (d := d) hm hδ hδ1
      dsimp [L]
      field_simp at hi
      exact hi.trans hr
    have hlogsample : 0 ≤ Real.log ((2 * (d : ℝ)) / (δ / 2)) := by
      apply Real.log_nonneg
      apply (le_div_iff₀ hδhalf).mpr
      nlinarith
    have hLpos : 0 < L := by linarith
    have hdenUpper : 0 < 2 * L + (2 / 3 : ℝ) * L * ε := by positivity
    have hdenLower : 0 < 2 * L + (2 / 3 : ℝ) * ε := by positivity
    have hbudgetUpper : Real.log ((2 * (d : ℝ)) / (δ / 2)) ≤
        (s : ℝ) * (ε ^ 2 / (2 * L + (2 / 3 : ℝ) * L * ε)) := by
      rw [← mul_div_assoc]
      apply (le_div_iff₀ hdenUpper).mpr
      have hden : 2 * L + (2 / 3 : ℝ) * L * ε ≤ 10 * L := by nlinarith
      have hmul := mul_le_mul_of_nonneg_left hden hlogsample
      nlinarith
    have hbudgetLower : Real.log ((2 * (d : ℝ)) / (δ / 2)) ≤
        (s : ℝ) * (ε ^ 2 / (2 * L + (2 / 3 : ℝ) * ε)) := by
      rw [← mul_div_assoc]
      apply (le_div_iff₀ hdenLower).mpr
      have hden : 2 * L + (2 / 3 : ℝ) * ε ≤ 10 * L := by nlinarith
      have hmul := mul_le_mul_of_nonneg_left hden hlogsample
      nlinarith
    have hu := uniformRowTraceProbability_eventProb_uniformRowSampleGram_upper_ge_one_sub_of_linear_budget
      (Q ω) hQ hm hd hs hLpos hε hδhalf hcap hbudgetUpper
    have hl := uniformRowTraceProbability_eventProb_uniformRowSampleGram_lower_ge_one_sub_of_linear_budget
      (Q ω) hQ hm hd hs hLpos hε hδhalf hcap hbudgetLower
    have hinter := R.eventProb_inter_ge_one_sub_add _ _
      ((δ / 2) / 2) ((δ / 2) / 2) hu hl
    convert hinter using 1; ring
  have hjoint := P.prod_eventProb_inter_dependent_ge_one_sub_add R E F
    (δ / 2) (δ / 2) (by linarith) hpre hconditional
  have hjoint' : 1 - δ ≤ (P.prod R).eventProb {z | z.1 ∈ E ∧ z.2 ∈ F z.1} := by
    convert hjoint using 1; ring
  apply hjoint'.trans
  apply FiniteProbability.eventProb_mono
  intro z hz
  refine ⟨hz.1, hz.2.1, hz.2.2, ?_⟩
  exact opNorm2_uniformScaledRowSketch_gram_error_le_of_two_sided
    (Q z.1) z.2 hε.le hz.2.1 hz.2.2

/-- At fixed accuracy and confidence the general budget is bounded by a
universal multiple of `(d+log(2m))*log(2d)`. -/
theorem signedHadamard_fixed_budget_le {m d : ℕ} (hm : 0 < m) (hd : 0 < d) :
    1000 / (1 / 2 : ℝ) ^ 2 *
      ((d : ℝ) + Real.log ((2 * (m : ℝ)) / (1 / 2))) *
        Real.log ((2 * (d : ℝ)) / (1 / 2)) ≤
      20000 * ((d : ℝ) + Real.log (2 * (m : ℝ))) * Real.log (2 * (d : ℝ)) := by
  have hmR : (1 : ℝ) ≤ (m : ℝ) := by exact_mod_cast hm
  have hdR : (1 : ℝ) ≤ (d : ℝ) := by exact_mod_cast hd
  have logdouble : ∀ x : ℝ, 1 ≤ x →
      Real.log ((2 * x) / (1 / 2)) ≤ 2 * Real.log (2 * x) := by
    intro x hx
    have harg : (2 * x) / (1 / 2) = 2 * (2 * x) := by ring
    rw [harg, Real.log_mul (by norm_num) (by positivity)]
    have hlog := Real.log_le_log (by norm_num : (0 : ℝ) < 2)
      (by linarith : (2 : ℝ) ≤ 2 * x)
    linarith
  have hmLog : 0 ≤ Real.log (2 * (m : ℝ)) :=
    Real.log_nonneg (by linarith)
  have hdLog : 0 ≤ Real.log (2 * (d : ℝ)) :=
    Real.log_nonneg (by linarith)
  have hmb : (d : ℝ) + Real.log ((2 * (m : ℝ)) / (1 / 2)) ≤
      2 * ((d : ℝ) + Real.log (2 * (m : ℝ))) := by
    have h := logdouble (m : ℝ) hmR
    linarith
  have hdb := logdouble (d : ℝ) hdR
  have hdLog' : 0 ≤ Real.log ((2 * (d : ℝ)) / (1 / 2)) := by
    apply Real.log_nonneg
    norm_num
    linarith
  have hprod := mul_le_mul hmb hdb hdLog'
    (by positivity : 0 ≤ 2 * ((d : ℝ) + Real.log (2 * (m : ℝ))))
  have hnonneg := mul_nonneg
    (by positivity : 0 ≤ (d : ℝ) + Real.log (2 * (m : ℝ))) hdLog
  have hcoef : 1000 / (1 / 2 : ℝ) ^ 2 = 4000 := by norm_num
  rw [hcoef]
  calc
    _ = 4000 * (((d : ℝ) + Real.log ((2 * (m : ℝ)) / (1 / 2))) *
        Real.log ((2 * (d : ℝ)) / (1 / 2))) := by ring
    _ ≤ 4000 * (2 * ((d : ℝ) + Real.log (2 * (m : ℝ))) *
        (2 * Real.log (2 * (d : ℝ)))) :=
      mul_le_mul_of_nonneg_left hprod (by norm_num)
    _ = 16000 * (((d : ℝ) + Real.log (2 * (m : ℝ))) * Real.log (2 * (d : ℝ))) := by ring
    _ ≤ 20000 * (((d : ℝ) + Real.log (2 * (m : ℝ))) * Real.log (2 * (d : ℝ))) :=
      mul_le_mul_of_nonneg_right (by norm_num) hnonneg
    _ = _ := by ring

end NumStability
