import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Preconditioning.ExactTransforms.Core

/-!
# Selected preprocessing geometry for Algorithm 3

The survey's qualitative statement is instantiated by two distinct laws. The
square Sylvester/Walsh transform preserves geometry exactly and spreads the
leverage of a fixed positive-dimensional subspace. Its logarithmic constant
comes from the primary signed-Hadamard row-norm bound, not from the survey.
The signed-hash sparse family directly embeds a subspace and makes no claim
that its output leverage is flattened. Zero-dimensional subspaces are handled
without dividing a leverage score by zero.
-/

namespace NumStability.Source.DrineasMahoney.RandNLA2016.Targets

/-- The concrete normalized Sylvester/Walsh matrix in dimension `2^p`. -/
noncomputable def walshRotation (p : ℕ) : Fin (2 ^ p) → Fin (2 ^ p) → ℝ :=
  fun i k => Real.sqrt (((2 ^ p : ℕ) : ℝ)⁻¹) * sylvesterHadamardSignPattern p i k

/-- Exact geometry for every realization of the actual independent sign law. -/
def signedWalshExactGeometry : Prop :=
  ∀ (p d : ℕ) (U : Fin (2 ^ p) → Fin d → ℝ), HasOrthonormalColumns U →
    ∀ ω : RademacherTrace (2 ^ p),
      HasOrthonormalColumns
        (preconditionRows
          (matMul (2 ^ p) (walshRotation p) (diagMatrix (rademacherSignVector ω))) U)

/-- Sharp simultaneous row-norm and normalized-leverage bound for a fixed
subspace. The two bounds hold on the same sign event. -/
def signedWalshMassSpreading : Prop :=
  ∀ (p d : ℕ) (U : Fin (2 ^ p) → Fin d → ℝ), HasOrthonormalColumns U →
    0 < d → ∀ δ : ℝ, 0 < δ → δ < 1 →
      1 - δ ≤ (rademacherTraceProbability (2 ^ p)).eventProb
        {ω | ∀ i : Fin (2 ^ p),
          let Q := preconditionRows
            (matMul (2 ^ p) (walshRotation p) (diagMatrix (rademacherSignVector ω))) U
          let L := (Real.sqrt (d : ℝ) +
            Real.sqrt (8 * Real.log (((2 ^ p : ℕ) : ℝ) / δ))) ^ 2
          rowNormSq Q i ≤ L / ((2 ^ p : ℕ) : ℝ) ∧
          leverageScoreProb Q i ≤ L / (((2 ^ p : ℕ) : ℝ) * (d : ℝ))}

/-- Signed-hash sparse preprocessing directly embeds a fixed subspace. Each
input coordinate has an independent uniform hash and independent unbiased sign.
The same event gives the spectral Gram bound and geometry for every subspace
vector, with the dimension threshold `(d²+d)/(ε²δ)`. -/
def sparseSignedHashSubspaceGeometry : Prop :=
  ∀ (m d t : ℕ) (ht : 0 < t) (U : Fin m → Fin d → ℝ),
    0 < m → HasOrthonormalColumns U →
    ∀ ε δ : ℝ, 0 < ε → ε < 1 → 0 < δ → δ < 1 →
    ((d : ℝ) ^ 2 + (d : ℝ)) / (ε ^ 2 * δ) ≤ (t : ℝ) →
      1 - δ ≤ (countSketchProbability (r := t) (m := m) ht).eventProb
        {x | let Pi := countSketchRows x.1 (rademacherSignVector x.2)
          opNorm2 (fun j k => idMatrix d j k - rowGram (preconditionRows Pi U) j k) ≤ ε ∧
          ∀ v : Fin m → ℝ, (∃ z : Fin d → ℝ, v = rectMatMulVec U z) →
            (1 - ε) * vecNorm2Sq v ≤ vecNorm2Sq (rectMatMulVec Pi v) ∧
            vecNorm2Sq (rectMatMulVec Pi v) ≤ (1 + ε) * vecNorm2Sq v}

/-- Combined parent contract for the two selected preprocessing families:
exact signed-Walsh geometry, its mass spreading, and sparse signed-hash
subspace geometry with its own law and dimension threshold. -/
def preprocessingGeometry : Prop :=
  signedWalshExactGeometry ∧ signedWalshMassSpreading ∧ sparseSignedHashSubspaceGeometry

/-- Every linear preprocessing map preserves the zero subspace exactly. This
branch has no normalized leverage probability or division by its dimension. -/
def zeroSubspacePreprocessingGeometry : Prop :=
  ∀ (m t : ℕ) (Pi : Fin t → Fin m → ℝ) (v : Fin m → ℝ),
    v = 0 → rectMatMulVec Pi v = 0 ∧
      vecNorm2Sq (rectMatMulVec Pi v) = vecNorm2Sq v

end NumStability.Source.DrineasMahoney.RandNLA2016.Targets
