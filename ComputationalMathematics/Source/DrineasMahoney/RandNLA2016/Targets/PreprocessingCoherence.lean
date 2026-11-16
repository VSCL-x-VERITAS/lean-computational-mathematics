import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.PreprocessingGeometry
import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Algorithm03.RandomProjectionPreconditioning.CoherenceGuarantees

/-!
# Joint Walsh sketch geometry and actual sampled-system coherence

These contracts instantiate the admitted real-Walsh realization. Rows are iid
with replacement independently of the signs. The historical child identifier
also mentions Fourier; no complex Fourier realization is asserted here.
The actual sampled leverage is the normalized diagonal of
`W (WᵀW)⁻¹ Wᵀ`, with its full-rank domain proved from sketch geometry.
Ambient logarithms are retained; the `d log d` specialization has an explicit
rank-versus-ambient-log regime. No running-time assertion is made.
-/
namespace NumStability.Source.DrineasMahoney.RandNLA2016.Targets
open scoped BigOperators

/-- The full joint child022 guarantee, including simultaneous geometry for all
vectors of the represented fixed subspace and the sharp row radius. -/
def signedWalshJointEmbedding : Prop :=
  ∃ C : ℝ, 0 < C ∧ ∀ (p d s : ℕ) (U : Fin (2 ^ p) → Fin d → ℝ),
    HasOrthonormalColumns U → 0 < d → d ≤ 2 ^ p → 0 < s →
    ∀ ε δ : ℝ, 0 < ε → ε < 1 → 0 < δ → δ < 1 →
    C / ε ^ 2 * ((d : ℝ) + Real.log ((2 * ((2 ^ p : ℕ) : ℝ)) / δ)) *
      Real.log ((2 * (d : ℝ)) / δ) ≤ (s : ℝ) →
    1 - δ ≤ (signedHadamardUniformRowTraceProbability
      (m := 2 ^ p) (s := s) (pow_pos (by norm_num) p)).eventProb
      {z | let Q := signedHadamardBasis (walshRotation p) U z.1
           let W := uniformScaledRowSketch Q z.2
           (∀ i, rowNormSq Q i ≤ hadamardJointRowRadius (2 ^ p) d δ / ((2 ^ p : ℕ) : ℝ)) ∧
           opNorm2 (fun j k => finiteIdMatrix j k - rowGram W j k) ≤ ε ∧
           ∀ x : Fin d → ℝ,
             (1 - ε) * vecNorm2Sq (rectMatMulVec U x) ≤ vecNorm2Sq (rectMatMulVec W x) ∧
             vecNorm2Sq (rectMatMulVec W x) ≤ (1 + ε) * vecNorm2Sq (rectMatMulVec U x)}

/-- Actual sampled-projector coherence on every stated successful geometry
event, rather than the unnormalized row norm of the sampled table. -/
def sampledWalshProjectorCoherence : Prop :=
  ∀ (p d s : ℕ) (U : Fin (2 ^ p) → Fin d → ℝ),
    HasOrthonormalColumns U → 0 < d → 0 < s →
    ∀ δ : ℝ, 0 < δ → δ < 1 →
    ∀ (ω : RademacherTrace (2 ^ p)) (samples : RowTrace (2 ^ p) s),
    let Q := signedHadamardBasis (walshRotation p) U ω
    let W := uniformScaledRowSketch Q samples
    let L := (Real.sqrt (d : ℝ) +
      Real.sqrt (8 * Real.log (((2 ^ p : ℕ) : ℝ) / δ))) ^ 2
    (∀ i, rowNormSq Q i ≤ L / ((2 ^ p : ℕ) : ℝ)) →
    opNorm2 (fun j k => finiteIdMatrix j k - rowGram W j k) ≤ (1 / 2 : ℝ) →
      Matrix.rank (W : Matrix (Fin s) (Fin d) ℝ) = d ∧
      (∀ t, 0 ≤ fullRankLeverageProb W t) ∧
      (∑ t : Fin s, fullRankLeverageProb W t) = 1 ∧
      ∀ t, fullRankLeverageProb W t ≤ 2 * L / ((s : ℝ) * (d : ℝ))

/-- Fixed-confidence joint geometry and actual sampled projector coherence at
the general count, and its rank-dominates-log specialization. The same positive
universal confidence and sample constant work for all fixed inputs. -/
def signedWalshCoherenceSampleScale : Prop :=
  ∃ C q0 : ℝ, 0 < C ∧ 0 < q0 ∧ q0 < 1 ∧
    ∀ (p d s : ℕ) (U : Fin (2 ^ p) → Fin d → ℝ),
      HasOrthonormalColumns U → 0 < d → d ≤ 2 ^ p → 0 < s →
      let success := {z : RademacherTrace (2 ^ p) × RowTrace (2 ^ p) s |
        let Q := signedHadamardBasis (walshRotation p) U z.1
        let W := uniformScaledRowSketch Q z.2
        let L := hadamardJointRowRadius (2 ^ p) d (1 / 2)
        (∀ i, rowNormSq Q i ≤ L / ((2 ^ p : ℕ) : ℝ)) ∧
        opNorm2 (fun j k => finiteIdMatrix j k - rowGram W j k) ≤ (1 / 2 : ℝ) ∧
        Matrix.rank (W : Matrix (Fin s) (Fin d) ℝ) = d ∧
        ∀ t, fullRankLeverageProb W t ≤ 2 * L / ((s : ℝ) * (d : ℝ))}
      let P := signedHadamardUniformRowTraceProbability
        (m := 2 ^ p) (s := s) (pow_pos (by norm_num) p)
      (C * ((d : ℝ) + Real.log (2 * ((2 ^ p : ℕ) : ℝ))) * Real.log (2 * (d : ℝ)) ≤ (s : ℝ) →
        q0 ≤ P.eventProb success) ∧
      (Real.log (2 * ((2 ^ p : ℕ) : ℝ)) ≤ (d : ℝ) →
        (2 * C) * (d : ℝ) * Real.log (2 * (d : ℝ)) ≤ (s : ℝ) →
        q0 ≤ P.eventProb success)

/-- Complete selected row023 geometry, rotated spreading, actual sampled
projector coherence, and quantified sample-scale contract. -/
def signedWalshCoherenceGuarantees : Prop :=
  signedWalshExactGeometry ∧ signedWalshMassSpreading ∧
    sampledWalshProjectorCoherence ∧ signedWalshCoherenceSampleScale
end NumStability.Source.DrineasMahoney.RandNLA2016.Targets
