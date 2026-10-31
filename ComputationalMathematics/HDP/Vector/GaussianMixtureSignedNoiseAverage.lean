import ComputationalMathematics.HDP.Vector.GaussianMixtureSignedNoise
import ComputationalMathematics.HDP.Vector.GaussianNormConcentration

/-!
# Exact joint and norm laws of the ordinary signed-noise average.

These ordinary results reuse the actual latent model and earlier producers.
No author convention, Source target or printed sample commitment is selected.
-/

noncomputable section
open Matrix MeasureTheory ProbabilityTheory
open scoped ENNReal BigOperators
namespace NumStability.HDP.Vector.GaussianMixture

/-- All sign-weighted canonical noise entries are jointly independent. -/
theorem canonicalSignedNoiseEntries_iIndep (m n : ℕ) :
    iIndepFun
      (fun ij : Fin m × Fin n ↦ fun ω ↦
        canonicalLabel ω ij.1 * canonicalNoise ω ij.1 ij.2)
      (latentNoiseSampleMeasure m n) := by
  letI : IsProbabilityMeasure (latentNoiseSampleMeasure m n) :=
    ⟨by simp [latentNoiseSampleMeasure]⟩
  refine iIndepFun_uncurry'
    (P := latentNoiseSampleMeasure m n)
    (X := fun i j ω ↦ canonicalLabel ω i * canonicalNoise ω i j) ?_ ?_ ?_
  · intro i j
    unfold canonicalLabel canonicalNoise
    fun_prop
  · exact canonicalSignedNoises_iIndep m n
  · intro i
    exact
      (NumStability.HDP.Vector.Gaussian.isStandardNormal_iff_iIndepFun_hasLaw.mp
        (canonicalSignedNoise_isStandardNormal i)).1

/-- Transposed sign-weighted noise has the product of independent standard
Gaussian column laws. This proves its joint law, beyond scalar marginals. -/
theorem canonicalSignedNoise_columns_hasLaw (m n : ℕ) :
    HasLaw
      (fun ω : Fin m → ℝ × (Fin n → ℝ) ↦
        fun j i ↦ canonicalLabel ω i * canonicalNoise ω i j)
      (Measure.pi fun _j : Fin n ↦ NumStability.standardGaussianVectorMeasure m)
      (latentNoiseSampleMeasure m n) := by
  letI : IsProbabilityMeasure (latentNoiseSampleMeasure m n) :=
    ⟨by simp [latentNoiseSampleMeasure]⟩
  let X : (Fin n × Fin m) → (Fin m → ℝ × (Fin n → ℝ)) → ℝ :=
    fun p ω ↦ canonicalLabel ω p.2 * canonicalNoise ω p.2 p.1
  have hIndep : iIndepFun X (latentNoiseSampleMeasure m n) := by
    exact (canonicalSignedNoiseEntries_iIndep m n).precomp Prod.swap_injective
  have hLaw : ∀ p, HasLaw (X p) (gaussianReal 0 1)
      (latentNoiseSampleMeasure m n) := by
    intro p
    exact
      (NumStability.HDP.Vector.Gaussian.isStandardNormal_iff_iIndepFun_hasLaw.mp
        (canonicalSignedNoise_isStandardNormal p.2)).2 p.1
  have hFlat : HasLaw (fun ω p ↦ X p ω)
      (Measure.pi fun _p : Fin n × Fin m ↦ gaussianReal 0 1)
      (latentNoiseSampleMeasure m n) := by
    refine ⟨(by unfold X canonicalLabel canonicalNoise; fun_prop), ?_⟩
    rw [(iIndepFun_iff_map_fun_eq_pi_map (fun p ↦ (hLaw p).aemeasurable)).1 hIndep]
    congr 1
    funext p
    exact (hLaw p).map_eq
  have hCurry : HasLaw (MeasurableEquiv.curry (Fin n) (Fin m) ℝ)
      (Measure.pi fun _j : Fin n ↦ NumStability.standardGaussianVectorMeasure m)
      (Measure.pi fun _p : Fin n × Fin m ↦ gaussianReal 0 1) := by
    refine ⟨(by fun_prop), ?_⟩
    simpa only [Measure.infinitePi_eq_pi, NumStability.standardGaussianVectorMeasure] using
      Measure.infinitePi_map_curry (fun _j : Fin n ↦ fun _i : Fin m ↦ gaussianReal 0 1)
  simpa only [X, Function.comp_def, MeasurableEquiv.curry_apply] using
    hCurry.fun_comp hFlat


/-- The whole average vector has independent centered Gaussian coordinates
of variance reciprocal to the positive sample size. The joint column law and
the existing exact coordinate-average law identify the component maps. -/
theorem canonicalSignedNoise_average_hasLaw {m n : ℕ} (hm : 0 < m) :
    HasLaw
      (fun ω : Fin m → ℝ × (Fin n → ℝ) ↦
        fun j ↦ (m : ℝ)⁻¹ * ∑ i, canonicalLabel ω i * canonicalNoise ω i j)
      (Measure.pi fun _j : Fin n ↦
        gaussianReal 0 (Real.toNNReal ((m : ℝ)⁻¹)))
      (latentNoiseSampleMeasure m n) := by
  let avg : (Fin m → ℝ) → ℝ := fun g ↦ (m : ℝ)⁻¹ * ∑ i, g i
  have hAvgMeas : Measurable avg := by unfold avg; fun_prop
  have hComponent : ∀ j : Fin n,
      (NumStability.standardGaussianVectorMeasure m).map avg =
        gaussianReal 0 (Real.toNNReal ((m : ℝ)⁻¹)) := by
    intro j
    have hCol : HasLaw
        (fun ω : Fin m → ℝ × (Fin n → ℝ) ↦
          fun i ↦ canonicalLabel ω i * canonicalNoise ω i j)
        (NumStability.standardGaussianVectorMeasure m)
        (latentNoiseSampleMeasure m n) := by
      exact (measurePreserving_eval
        (μ := fun _j : Fin n ↦ NumStability.standardGaussianVectorMeasure m) j).hasLaw.fun_comp
          (canonicalSignedNoise_columns_hasLaw m n)
    rw [← hCol.map_eq, Measure.map_map hAvgMeas
      (by unfold canonicalLabel canonicalNoise; fun_prop)]
    simpa only [Function.comp_def, avg] using
      (canonicalSignedNoise_average_coordinate_hasLaw hm j).map_eq
  have hWhole : HasLaw
      (fun cols : Fin n → (Fin m → ℝ) ↦ fun j ↦ avg (cols j))
      (Measure.pi fun _j : Fin n ↦ gaussianReal 0 (Real.toNNReal ((m : ℝ)⁻¹)))
      (Measure.pi fun _j : Fin n ↦ NumStability.standardGaussianVectorMeasure m) := by
    have hMeas : Measurable (fun cols : Fin n → (Fin m → ℝ) ↦ fun j ↦ avg (cols j)) :=
      measurable_pi_lambda _ (fun j ↦ hAvgMeas.comp (measurable_pi_apply j))
    refine ⟨hMeas.aemeasurable, ?_⟩
    rw [Measure.pi_map_pi (fun _j ↦ hAvgMeas.aemeasurable)]
    congr 1
    funext j
    exact hComponent j
  simpa only [avg] using
    hWhole.fun_comp (canonicalSignedNoise_columns_hasLaw m n)


/-- Multiplying the joint empirical signed-noise average by sqrt(m) produces
a standard Gaussian vector, under the actual canonical latent sample law. -/
theorem canonicalSignedNoise_normalized_average_isStandardNormal {m n : ℕ}
    (hm : 0 < m) :
    NumStability.HDP.Vector.Gaussian.IsStandardNormal
      (latentNoiseSampleMeasure m n)
      (fun j ω ↦ Real.sqrt (m : ℝ) *
        ((m : ℝ)⁻¹ * ∑ i, canonicalLabel ω i * canonicalNoise ω i j)) := by
  have hmR : (m : ℝ) ≠ 0 := by exact_mod_cast (Nat.ne_of_gt hm)
  have hScale : HasLaw
      (fun g : Fin n → ℝ ↦ fun j ↦ Real.sqrt (m : ℝ) * g j)
      (NumStability.standardGaussianVectorMeasure n)
      (Measure.pi fun _j : Fin n ↦
        gaussianReal 0 (Real.toNNReal ((m : ℝ)⁻¹))) := by
    have hMeas : Measurable
        (fun g : Fin n → ℝ ↦ fun j ↦ Real.sqrt (m : ℝ) * g j) :=
      measurable_pi_lambda _ (fun j ↦ measurable_const.mul (measurable_pi_apply j))
    refine ⟨hMeas.aemeasurable, ?_⟩
    unfold NumStability.standardGaussianVectorMeasure
    rw [Measure.pi_map_pi (fun _j ↦
      (measurable_const_mul (Real.sqrt (m : ℝ))).aemeasurable)]
    simp only [gaussianReal_map_const_mul, mul_zero]
    congr 1
    funext j
    congr 1
    apply NNReal.eq
    simp only [NNReal.coe_mul, NNReal.coe_mk, NNReal.coe_one,
      Real.toNNReal_of_nonneg (inv_nonneg.mpr (Nat.cast_nonneg m))]
    rw [Real.sq_sqrt (Nat.cast_nonneg m), mul_inv_cancel₀ hmR]
  simpa only [NumStability.HDP.Vector.Gaussian.IsStandardNormal] using
    hScale.fun_comp (canonicalSignedNoise_average_hasLaw hm)


/-- The empirical signed-noise average has an absolute-constant Gaussian norm
upper tail at the natural sqrt(n/m) scale. This is an ordinary consequence of
the actual joint normal law, not a clustering or printed-sample-budget claim. -/
theorem exists_canonicalSignedNoise_average_norm_upper_tail :
    ∃ C : ℝ, 0 < C ∧
      ∀ {m n : ℕ}, 0 < m → 0 < n →
        (latentNoiseSampleMeasure m n).real
          {ω | C * Real.sqrt (n : ℝ) / Real.sqrt (m : ℝ) <
            NumStability.vecNorm2
              (fun j ↦ (m : ℝ)⁻¹ * ∑ i,
                canonicalLabel ω i * canonicalNoise ω i j)} ≤
          2 * Real.exp (-(n : ℝ)) := by
  obtain ⟨c, hc, hTail⟩ :=
    NumStability.HDP.Vector.Gaussian.standardGaussianEuclideanNormDeviation_tail
  let C : ℝ := 1 + 1 / Real.sqrt c
  have hsC : 0 < Real.sqrt c := Real.sqrt_pos.2 hc
  have hC : 0 < C := by dsimp [C]; positivity
  refine ⟨C, hC, ?_⟩
  intro m n hm hn
  letI : IsProbabilityMeasure (latentNoiseSampleMeasure m n) :=
    ⟨by simp [latentNoiseSampleMeasure]⟩
  letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
  let avg : (Fin m → ℝ × (Fin n → ℝ)) → Fin n → ℝ :=
    fun ω j ↦ (m : ℝ)⁻¹ * ∑ i, canonicalLabel ω i * canonicalNoise ω i j
  let s : ℝ := Real.sqrt (m : ℝ)
  let X : Fin n → (Fin m → ℝ × (Fin n → ℝ)) → ℝ :=
    fun j ω ↦ s * avg ω j
  let t : ℝ := Real.sqrt (n : ℝ) / Real.sqrt c
  have hs : 0 < s := by
    dsimp [s]
    exact Real.sqrt_pos.2 (by exact_mod_cast hm)
  have ht : 0 ≤ t := by dsimp [t]; positivity
  have hMeas : ∀ j, Measurable (X j) := by
    intro j
    dsimp [X, avg, s]
    unfold canonicalLabel canonicalNoise
    fun_prop
  have hStd : NumStability.HDP.Vector.Gaussian.IsStandardNormal
      (latentNoiseSampleMeasure m n) X := by
    simpa only [X, s, avg] using
      canonicalSignedNoise_normalized_average_isStandardNormal hm
  have hRaw := hTail X hMeas hStd ht
  have hRate : c * t ^ 2 = (n : ℝ) := by
    dsimp [t]
    rw [div_pow, Real.sq_sqrt (Nat.cast_nonneg n), Real.sq_sqrt hc.le]
    field_simp
  rw [hRate] at hRaw
  have hEvent :
      {ω | C * Real.sqrt (n : ℝ) / Real.sqrt (m : ℝ) <
        NumStability.vecNorm2 (avg ω)} ⊆
      {ω | |NumStability.vecNorm2 (fun j ↦ X j ω) -
        Real.sqrt (n : ℝ)| ≥ t} := by
    intro ω hω
    change C * Real.sqrt (n : ℝ) / s < NumStability.vecNorm2 (avg ω) at hω
    change t ≤ |NumStability.vecNorm2 (fun j ↦ X j ω) - Real.sqrt (n : ℝ)|
    have hNorm : NumStability.vecNorm2 (fun j ↦ X j ω) =
        s * NumStability.vecNorm2 (avg ω) := by
      dsimp [X]
      rw [NumStability.vecNorm2_smul, abs_of_pos hs]
    rw [hNorm]
    have hProduct := (div_lt_iff₀ hs).mp hω
    have hExpand : C * Real.sqrt (n : ℝ) = Real.sqrt (n : ℝ) + t := by
      dsimp [C, t]
      ring
    rw [hExpand] at hProduct
    have hDiff : t < s * NumStability.vecNorm2 (avg ω) - Real.sqrt (n : ℝ) := by
      nlinarith
    exact (lt_of_lt_of_le hDiff (le_abs_self _)).le
  exact (measureReal_mono hEvent (measure_ne_top _ _)).trans hRaw


/-- Parameterized ordinary norm tail for the actual signed-noise average.
The absolute constant precedes all dimensions and deviation parameters. -/
theorem exists_canonicalSignedNoise_average_norm_tail :
    ∃ C : ℝ, 0 < C ∧
      ∀ {m n : ℕ}, 0 < m → 0 < n →
        ∀ {t : ℝ}, 0 ≤ t →
          (latentNoiseSampleMeasure m n).real
            {ω | C * (Real.sqrt (n : ℝ) + t) / Real.sqrt (m : ℝ) <
              NumStability.vecNorm2
                (fun j ↦ (m : ℝ)⁻¹ * ∑ i,
                  canonicalLabel ω i * canonicalNoise ω i j)} ≤
            2 * Real.exp (-(t ^ 2)) := by
  obtain ⟨c, hc, hTail⟩ :=
    NumStability.HDP.Vector.Gaussian.standardGaussianEuclideanNormDeviation_tail
  let C : ℝ := 1 + 1 / Real.sqrt c
  have hsC : 0 < Real.sqrt c := Real.sqrt_pos.2 hc
  have hC : 0 < C := by dsimp [C]; positivity
  refine ⟨C, hC, ?_⟩
  intro m n hm hn t ht
  letI : IsProbabilityMeasure (latentNoiseSampleMeasure m n) :=
    ⟨by simp [latentNoiseSampleMeasure]⟩
  letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
  let avg : (Fin m → ℝ × (Fin n → ℝ)) → Fin n → ℝ :=
    fun ω j ↦ (m : ℝ)⁻¹ * ∑ i, canonicalLabel ω i * canonicalNoise ω i j
  let s : ℝ := Real.sqrt (m : ℝ)
  let X : Fin n → (Fin m → ℝ × (Fin n → ℝ)) → ℝ :=
    fun j ω ↦ s * avg ω j
  let u : ℝ := t / Real.sqrt c
  have hs : 0 < s := by
    dsimp [s]
    exact Real.sqrt_pos.2 (by exact_mod_cast hm)
  have hu : 0 ≤ u := by dsimp [u]; positivity
  have hMeas : ∀ j, Measurable (X j) := by
    intro j
    dsimp [X, avg, s]
    unfold canonicalLabel canonicalNoise
    fun_prop
  have hStd : NumStability.HDP.Vector.Gaussian.IsStandardNormal
      (latentNoiseSampleMeasure m n) X := by
    simpa only [X, s, avg] using
      canonicalSignedNoise_normalized_average_isStandardNormal hm
  have hRaw := hTail X hMeas hStd hu
  have hRate : c * u ^ 2 = t ^ 2 := by
    dsimp [u]
    rw [div_pow, Real.sq_sqrt hc.le]
    field_simp
  rw [hRate] at hRaw
  have hThreshold : Real.sqrt (n : ℝ) + u ≤
      C * (Real.sqrt (n : ℝ) + t) := by
    have hExtra : 0 ≤ Real.sqrt (n : ℝ) / Real.sqrt c := by positivity
    have hExpand : C * (Real.sqrt (n : ℝ) + t) =
        Real.sqrt (n : ℝ) + u + (t + Real.sqrt (n : ℝ) / Real.sqrt c) := by
      dsimp [C, u]
      ring
    rw [hExpand]
    linarith
  have hEvent :
      {ω | C * (Real.sqrt (n : ℝ) + t) / Real.sqrt (m : ℝ) <
        NumStability.vecNorm2 (avg ω)} ⊆
      {ω | |NumStability.vecNorm2 (fun j ↦ X j ω) -
        Real.sqrt (n : ℝ)| ≥ u} := by
    intro ω hω
    change C * (Real.sqrt (n : ℝ) + t) / s < NumStability.vecNorm2 (avg ω) at hω
    change u ≤ |NumStability.vecNorm2 (fun j ↦ X j ω) - Real.sqrt (n : ℝ)|
    have hNorm : NumStability.vecNorm2 (fun j ↦ X j ω) =
        s * NumStability.vecNorm2 (avg ω) := by
      dsimp [X]
      rw [NumStability.vecNorm2_smul, abs_of_pos hs]
    rw [hNorm]
    have hProduct := (div_lt_iff₀ hs).mp hω
    have hDiff : u < s * NumStability.vecNorm2 (avg ω) - Real.sqrt (n : ℝ) := by
      linarith
    exact (lt_of_lt_of_le hDiff (le_abs_self _)).le
  exact (measureReal_mono hEvent (measure_ne_top _ _)).trans hRaw

end NumStability.HDP.Vector.GaussianMixture
