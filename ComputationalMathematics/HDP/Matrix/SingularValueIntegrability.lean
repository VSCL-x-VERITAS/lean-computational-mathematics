import ComputationalMathematics.Analysis.SingularValues.CourantFischer
import ComputationalMathematics.HDP.Matrix.OperatorNormIntegrability
import ComputationalMathematics.HDP.Matrix.Weyl

/-!
# Measurability and integrability of finite-matrix singular values

Weyl's inequality makes every ordered eigenvalue of the right Gram matrix
continuous in the matrix entries.  Consequently every Courant--Fischer
singular value is continuous, and entrywise integrability controls it through
the largest singular value/operator norm.
-/

noncomputable section

open Matrix MeasureTheory Filter Topology

namespace NumStability.HDP.Matrix

/-- An ordered eigenvalue of the right Gram matrix varies continuously with
the entries of a real rectangular matrix. -/
theorem continuous_hermitianOrderedEigenvalue_rightGram {m n : ℕ}
    (i : Fin n) :
    Continuous (fun A : Matrix (Fin m) (Fin n) ℝ ↦
      NumStability.hermitianOrderedEigenvalue
        (NumStability.rectCourantFischerRightGram_isHermitian A) i) := by
  rw [continuous_iff_continuousAt]
  intro A
  change Tendsto (fun B : Matrix (Fin m) (Fin n) ℝ ↦
      NumStability.hermitianOrderedEigenvalue
        (NumStability.rectCourantFischerRightGram_isHermitian B) i)
    (nhds A) (nhds (NumStability.hermitianOrderedEigenvalue
      (NumStability.rectCourantFischerRightGram_isHermitian A) i))
  rw [tendsto_iff_dist_tendsto_zero]
  refine squeeze_zero
    (f := fun B : Matrix (Fin m) (Fin n) ℝ ↦
      dist (NumStability.hermitianOrderedEigenvalue
          (NumStability.rectCourantFischerRightGram_isHermitian B) i)
        (NumStability.hermitianOrderedEigenvalue
          (NumStability.rectCourantFischerRightGram_isHermitian A) i))
    (g := fun B ↦ NumStability.realMatrixOperatorNorm
      (NumStability.rectCourantFischerRightGram B -
        NumStability.rectCourantFischerRightGram A))
    (fun _ ↦ dist_nonneg) ?_ ?_
  · intro B
    change |NumStability.hermitianOrderedEigenvalue
          (NumStability.rectCourantFischerRightGram_isHermitian B) i -
        NumStability.hermitianOrderedEigenvalue
          (NumStability.rectCourantFischerRightGram_isHermitian A) i| ≤ _
    exact abs_hermitianOrderedEigenvalue_sub_le_operatorNorm
      (NumStability.rectCourantFischerRightGram B)
      (NumStability.rectCourantFischerRightGram A)
      (NumStability.rectCourantFischerRightGram_isHermitian B)
      (NumStability.rectCourantFischerRightGram_isHermitian A) i
  · have hg : ContinuousAt (fun B : Matrix (Fin m) (Fin n) ℝ ↦
          NumStability.realMatrixOperatorNorm
            (NumStability.rectCourantFischerRightGram B -
              NumStability.rectCourantFischerRightGram A)) A :=
        ((continuous_realMatrixOperatorNorm n n).comp
          (show Continuous (fun B : Matrix (Fin m) (Fin n) ℝ ↦
              NumStability.rectCourantFischerRightGram B -
                NumStability.rectCourantFischerRightGram A) by
            unfold NumStability.rectCourantFischerRightGram
            fun_prop)).continuousAt
    have hopzero :
        NumStability.realMatrixOperatorNorm
            (0 : Matrix (Fin n) (Fin n) ℝ) = 0 := by
      rw [NumStability.realMatrixOperatorNorm]
      have hz : NumStability.realMatrixContinuousLinearMap
          (0 : Matrix (Fin n) (Fin n) ℝ) = 0 := by
        ext x j
        simp [NumStability.realMatrixContinuousLinearMap]
      rw [hz, norm_zero]
    change Tendsto (fun B : Matrix (Fin m) (Fin n) ℝ ↦
          NumStability.realMatrixOperatorNorm
            (NumStability.rectCourantFischerRightGram B -
              NumStability.rectCourantFischerRightGram A))
        (nhds A) (nhds (NumStability.realMatrixOperatorNorm
          (NumStability.rectCourantFischerRightGram A -
            NumStability.rectCourantFischerRightGram A))) at hg
    simpa [hopzero] using hg

/-- Every Courant--Fischer singular value is continuous in the finitely many
matrix entries. -/
theorem continuous_rectCourantFischerSingularValue {m n : ℕ} (i : Fin n) :
    Continuous (fun A : Matrix (Fin m) (Fin n) ℝ ↦
      NumStability.rectCourantFischerSingularValue A i) := by
  exact Real.continuous_sqrt.comp
    (continuous_hermitianOrderedEigenvalue_rightGram i)

/-- Entrywise integrability of a finite random matrix implies integrability of
each ordered singular value. -/
theorem integrable_rectCourantFischerSingularValue_of_entries
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    {m n : ℕ} (A : Ω → Matrix (Fin m) (Fin n) ℝ)
    (hInt : ∀ ij : Fin m × Fin n,
      Integrable (fun ω ↦ A ω ij.1 ij.2) μ) (i : Fin n) :
    Integrable (fun ω ↦
      NumStability.rectCourantFischerSingularValue (A ω) i) μ := by
  letI : MeasurableSpace (Matrix (Fin m) (Fin n) ℝ) := MeasurableSpace.pi
  haveI : BorelSpace (Matrix (Fin m) (Fin n) ℝ) := Pi.borelSpace
  have hAmeas : AEMeasurable A μ := by
    apply aemeasurable_pi_lambda
    intro r
    apply aemeasurable_pi_lambda
    intro c
    exact (hInt (r, c)).aestronglyMeasurable.aemeasurable
  have hSigmaMeas : AEStronglyMeasurable (fun ω ↦
      NumStability.rectCourantFischerSingularValue (A ω) i) μ :=
    ((continuous_rectCourantFischerSingularValue i).measurable.comp_aemeasurable
      hAmeas).aestronglyMeasurable
  have hOpInt := integrable_realMatrixOperatorNorm_of_entries A hInt
  apply hOpInt.mono' hSigmaMeas
  filter_upwards [] with ω
  have hn : 0 < n := lt_of_le_of_lt (Nat.zero_le i) i.isLt
  have hle : NumStability.rectCourantFischerSingularValue (A ω) i ≤
      NumStability.rectCourantFischerSingularValue (A ω) ⟨0, hn⟩ :=
    NumStability.rectCourantFischerSingularValue_antitone (A ω)
      (Nat.zero_le i)
  have htop : NumStability.rectCourantFischerSingularValue (A ω) ⟨0, hn⟩ =
      NumStability.realMatrixOperatorNorm (A ω) :=
    NumStability.rectCourantFischerSingularValue_zero_eq_operatorNorm hn (A ω)
  rw [Real.norm_eq_abs, abs_of_nonneg
    (NumStability.rectCourantFischerSingularValue_nonneg (A ω) i)]
  exact hle.trans_eq htop

end NumStability.HDP.Matrix
