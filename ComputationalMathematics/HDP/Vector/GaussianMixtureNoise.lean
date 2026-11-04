import ComputationalMathematics.HDP.Vector.GaussianMixtureConcentration
import ComputationalMathematics.HDP.Vector.GaussianNormConcentration
import ComputationalMathematics.HDP.Matrix.OperatorNormSubGaussian
import Mathlib.Probability.Independence.InfinitePi

/-!
# Gaussian noise matrix in the canonical mixture model

The latent presentation of the Gaussian mixture exposes an `m × n` matrix of
independent standard-normal noise coordinates.  This file packages its joint
independence and the standard rectangular operator-norm tail.
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal RealInnerProductSpace

namespace NumStability.HDP.Vector.GaussianMixture

/-- Every canonical noise row has the joint standard-normal law. -/
theorem canonicalNoise_isStandardNormal {m n : ℕ} (i : Fin m) :
    NumStability.HDP.Vector.Gaussian.IsStandardNormal
      (latentNoiseSampleMeasure m n)
      (fun j ω ↦ canonicalNoise ω i j) := by
  simpa [canonicalNoise, Function.comp_def] using
    (latentNoise_isStandardNormal n).fun_comp (canonicalRow_hasLaw m n i)

/-- The canonical Gaussian noise rows are mutually independent. -/
theorem canonicalNoises_iIndep (m n : ℕ) :
    iIndepFun (fun i ↦ fun ω ↦ canonicalNoise ω i)
      (latentNoiseSampleMeasure m n) := by
  have h := (canonicalRows_iIndep m n).comp
    (fun _i (z : ℝ × (Fin n → ℝ)) ↦ z.2) (fun _i ↦ measurable_snd)
  simpa [canonicalNoise, Function.comp_def] using h

/-- All entries of the canonical Gaussian noise matrix are jointly
independent, including coordinates within one row. -/
theorem canonicalNoiseEntries_iIndep (m n : ℕ) :
    iIndepFun
      (fun ij : Fin m × Fin n ↦ fun ω ↦ canonicalNoise ω ij.1 ij.2)
      (latentNoiseSampleMeasure m n) := by
  letI : IsProbabilityMeasure (latentNoiseSampleMeasure m n) :=
    ⟨by simp [latentNoiseSampleMeasure]⟩
  refine iIndepFun_uncurry'
    (P := latentNoiseSampleMeasure m n)
    (X := fun i j ω ↦ canonicalNoise ω i j) ?_ ?_ ?_
  · intro i j
    unfold canonicalNoise
    fun_prop
  · exact canonicalNoises_iIndep m n
  · intro i
    exact
      (NumStability.HDP.Vector.Gaussian.isStandardNormal_iff_iIndepFun_hasLaw.mp
        (canonicalNoise_isStandardNormal i)).1

/-- Every canonical noise coordinate has the one-dimensional `N(0,1)` law. -/
theorem canonicalNoise_coordinate_hasLaw {m n : ℕ} (i : Fin m) (j : Fin n) :
    HasLaw (fun ω ↦ canonicalNoise ω i j) (gaussianReal 0 1)
      (latentNoiseSampleMeasure m n) := by
  letI : IsProbabilityMeasure (latentNoiseSampleMeasure m n) :=
    ⟨by simp [latentNoiseSampleMeasure]⟩
  exact
    (NumStability.HDP.Vector.Gaussian.isStandardNormal_iff_iIndepFun_hasLaw.mp
      (canonicalNoise_isStandardNormal i)).2 j

/-- Canonical noise coordinates are centered, integrable, and scalar
sub-Gaussian. -/
theorem canonicalNoise_coordinate_subGaussian_centered {m n : ℕ}
    (i : Fin m) (j : Fin n) :
    NumStability.HDP.Scalar.SubGaussian.IsSubGaussian
        (latentNoiseSampleMeasure m n) (fun ω ↦ canonicalNoise ω i j) ∧
      Integrable (fun ω ↦ canonicalNoise ω i j)
        (latentNoiseSampleMeasure m n) ∧
      (∫ ω, canonicalNoise ω i j ∂latentNoiseSampleMeasure m n) = 0 := by
  letI : IsProbabilityMeasure (latentNoiseSampleMeasure m n) :=
    ⟨by simp [latentNoiseSampleMeasure]⟩
  have hLaw := canonicalNoise_coordinate_hasLaw i j
  have hSub : NumStability.HDP.Scalar.SubGaussian.IsSubGaussian
      (latentNoiseSampleMeasure m n) (fun ω ↦ canonicalNoise ω i j) := by
    apply
      (NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite).2
    rw [NumStability.HDP.Scalar.SubGaussian.psiTwoNorm_eq_of_hasLaw
      (by unfold canonicalNoise; fun_prop) hLaw]
    exact NumStability.HDP.Scalar.SubGaussian.gaussianPsiTwoGauge_finite.1
  exact ⟨hSub, hLaw.hasGaussianLaw.integrable,
    by simpa using hLaw.integral_eq⟩

/-- The maximum scalar `ψ₂` norm of the canonical noise entries is at most
the explicit standard-Gaussian bound two. -/
theorem canonicalNoise_psiTwoNormMax_le_two {m n : ℕ}
    [Nonempty (Fin m × Fin n)] :
    NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax
        (latentNoiseSampleMeasure m n)
        (fun ij : Fin m × Fin n ↦ fun ω ↦ canonicalNoise ω ij.1 ij.2) ≤ 2 := by
  letI : IsProbabilityMeasure (latentNoiseSampleMeasure m n) :=
    ⟨by simp [latentNoiseSampleMeasure]⟩
  unfold NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax
  apply Finset.sup'_le Finset.univ_nonempty
  intro ij _hij
  have hLaw := canonicalNoise_coordinate_hasLaw ij.1 ij.2
  have hGauge :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
          (latentNoiseSampleMeasure m n)
          (fun ω ↦ canonicalNoise ω ij.1 ij.2) ≤ ENNReal.ofReal 2 := by
    rw [NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_eq_of_hasLaw
      (by unfold canonicalNoise; fun_prop) hLaw]
    exact NumStability.HDP.Scalar.SubGaussian.gaussianPsiTwoGauge_le_two_mul.1
  simpa [NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm] using
    (ENNReal.toReal_mono ENNReal.ofReal_ne_top hGauge)

/-- The canonical Gaussian noise matrix has the standard
`√n + √m + t` operator-norm upper tail. -/
theorem exists_canonicalNoise_operatorNorm_tail :
    ∃ C : ℝ, 0 < C ∧
      ∀ {m n : ℕ}, 0 < m → 0 < n →
        ∀ {t : ℝ}, 0 < t →
          (latentNoiseSampleMeasure m n).real
            {ω | 2 * C * (Real.sqrt n + Real.sqrt m + t) <
              NumStability.realMatrixOperatorNorm
                (fun i j ↦ canonicalNoise ω i j)} ≤
            2 * Real.exp (-t ^ 2) := by
  obtain ⟨C, hC, hTail⟩ :=
    NumStability.HDP.Matrix.exists_operatorNorm_tail_of_independent_centered_subGaussian_entries
  refine ⟨C, hC, ?_⟩
  intro m n hm hn t ht
  letI : IsProbabilityMeasure (latentNoiseSampleMeasure m n) :=
    ⟨by simp [latentNoiseSampleMeasure]⟩
  letI : Nonempty (Fin m) := Fin.pos_iff_nonempty.mp hm
  letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
  let A : (Fin m → ℝ × (Fin n → ℝ)) → Matrix (Fin m) (Fin n) ℝ :=
    fun ω i j ↦ canonicalNoise ω i j
  have hSub : ∀ ij : Fin m × Fin n,
      NumStability.HDP.Scalar.SubGaussian.IsSubGaussian
        (latentNoiseSampleMeasure m n) (fun ω ↦ A ω ij.1 ij.2) := by
    intro ij
    exact (canonicalNoise_coordinate_subGaussian_centered ij.1 ij.2).1
  have hCenter : ∀ ij : Fin m × Fin n,
      Integrable (fun ω ↦ A ω ij.1 ij.2) (latentNoiseSampleMeasure m n) ∧
        (∫ ω, A ω ij.1 ij.2 ∂latentNoiseSampleMeasure m n) = 0 := by
    intro ij
    exact (canonicalNoise_coordinate_subGaussian_centered ij.1 ij.2).2
  have hIndep : iIndepFun
      (fun ij : Fin m × Fin n ↦ fun ω ↦ A ω ij.1 ij.2)
      (latentNoiseSampleMeasure m n) := by
    simpa [A] using canonicalNoiseEntries_iIndep m n
  have hRaw := hTail hm hn A hSub hCenter hIndep ht
  have hK : NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax
      (latentNoiseSampleMeasure m n)
      (fun ij : Fin m × Fin n ↦ fun ω ↦ A ω ij.1 ij.2) ≤ 2 := by
    simpa [A] using (canonicalNoise_psiTwoNormMax_le_two
      (m := m) (n := n))
  have hS : 0 ≤ Real.sqrt n + Real.sqrt m + t := by positivity
  apply (measureReal_mono ?_ (measure_ne_top _ _)).trans hRaw
  intro ω hω
  change 2 * C * (Real.sqrt n + Real.sqrt m + t) <
      NumStability.realMatrixOperatorNorm (A ω) at hω
  change C *
      NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax
        (latentNoiseSampleMeasure m n)
        (fun ij : Fin m × Fin n ↦ fun ω ↦ A ω ij.1 ij.2) *
        (Real.sqrt n + Real.sqrt m + t) <
      NumStability.realMatrixOperatorNorm (A ω)
  calc
    C *
          NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax
            (latentNoiseSampleMeasure m n)
            (fun ij : Fin m × Fin n ↦ fun ω ↦ A ω ij.1 ij.2) *
          (Real.sqrt n + Real.sqrt m + t) ≤
        C * 2 * (Real.sqrt n + Real.sqrt m + t) :=
      mul_le_mul_of_nonneg_right
        (mul_le_mul_of_nonneg_left hK hC.le) hS
    _ = 2 * C * (Real.sqrt n + Real.sqrt m + t) := by ring
    _ < NumStability.realMatrixOperatorNorm (A ω) := hω

end NumStability.HDP.Vector.GaussianMixture
