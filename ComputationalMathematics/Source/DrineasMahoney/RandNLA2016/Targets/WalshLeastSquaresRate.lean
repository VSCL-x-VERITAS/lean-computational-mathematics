import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.LeastSquaresConstructions

/-! # Quantitative children of the joint Walsh least-squares construction

The source's rough sample scale is represented by existence of a universal
constant. Success1/2 is a concrete sufficient interpretation of qualitative
positive success probability. Neither contract asserts fast execution or an
implicit extension to row dimensions other than powers of two.
-/

namespace NumStability.Source.DrineasMahoney.RandNLA2016.Targets

/-- Actual exact minimizers of the common HD/uniform-row sketch of A and b. -/
def IsWalshLeastSquaresOutput {q n s : ℕ}
    (A : Fin (2 ^ q) → Fin n → ℝ) (b : Fin (2 ^ q) → ℝ)
    (xHat : RademacherTrace (2 ^ q) × RowTrace (2 ^ q) s → Fin n → ℝ) : Prop :=
  ∀ ω samples,
    let T := matMul (2 ^ q) (leastSquaresWalshMatrix q) (diagMatrix (rademacherSignVector ω))
    IsLeastSquaresMinimizer
      (rowSampleSketchWithProb s (preconditionRows T A) uniformRowProb samples)
      (rowSampleVectorWithProb uniformRowProb (matMulVec (2 ^ q) T b) samples)
      (xHat (ω, samples))

/-- Original027-relative-error: every sufficient integer budget controls the
original unsquared residual for every exact sketch minimizer. Actual outputs
exist; no minimizer, embedding or final quality is postulated as source input. -/
def walshUniformLeastSquaresRelativeError : Prop :=
  ∃ C : ℝ, 1 ≤ C ∧
    ∀ (q n s : ℕ) (A : Fin (2 ^ q) → Fin n → ℝ) (b : Fin (2 ^ q) → ℝ)
      (hm : 0 < 2 ^ q) (ε : ℝ),
      0 < n → 0 < s → 0 < ε → ε < 1 →
      C * (n : ℝ) * Real.log (2 * ((2 ^ q : ℕ) : ℝ)) / ε ≤ (s : ℝ) →
      (∃ xHat : RademacherTrace (2 ^ q) × RowTrace (2 ^ q) s → Fin n → ℝ,
        IsWalshLeastSquaresOutput A b xHat) ∧
      ∀ (xHat : RademacherTrace (2 ^ q) × RowTrace (2 ^ q) s → Fin n → ℝ)
        (xOpt : Fin n → ℝ),
        IsWalshLeastSquaresOutput A b xHat → IsLeastSquaresMinimizer A b xOpt →
        (1 / 2 : ℝ) ≤ (signedHadamardUniformRowTraceProbability (m := 2 ^ q) (s := s) hm).eventProb
          {z | vecNorm2 (lsResidual A b (xHat z)) ≤ (1 + ε) * vecNorm2 (lsResidual A b xOpt)}

/-- Original027-samples: a dimension/accuracy-only integer budget at the source
scale comes with actual joint sketch outputs and the fixed-probability original
residual guarantee. This asserts algorithm success, not just an arithmetic count. -/
def walshUniformLeastSquaresSamples : Prop :=
  ∃ C : ℝ, 1 ≤ C ∧
    ∀ (q n : ℕ) (A : Fin (2 ^ q) → Fin n → ℝ) (b : Fin (2 ^ q) → ℝ)
      (hm : 0 < 2 ^ q) (ε : ℝ), 0 < n → 0 < ε → ε < 1 →
      ∃ s : ℕ, s = ⌈C * (n : ℝ) * Real.log (2 * ((2 ^ q : ℕ) : ℝ)) / ε⌉₊ ∧
        0 < s ∧ (s : ℝ) ≤ 2 * C * (n : ℝ) * Real.log (2 * ((2 ^ q : ℕ) : ℝ)) / ε ∧
      ∃ xHat : RademacherTrace (2 ^ q) × RowTrace (2 ^ q) s → Fin n → ℝ,
        IsWalshLeastSquaresOutput A b xHat ∧
        ∀ xOpt : Fin n → ℝ, IsLeastSquaresMinimizer A b xOpt →
          (1 / 2 : ℝ) ≤ (signedHadamardUniformRowTraceProbability (m := 2 ^ q) (s := s) hm).eventProb
            {z | vecNorm2 (lsResidual A b (xHat z)) ≤ (1 + ε) * vecNorm2 (lsResidual A b xOpt)}

end NumStability.Source.DrineasMahoney.RandNLA2016.Targets
