import Mathlib.Analysis.Matrix.PosDef
import Mathlib.Analysis.Matrix.Spectrum
import ComputationalMathematics.HDP.Vector.Covariance

/-!
# Principal components of a positive-semidefinite matrix

The Hermitian eigenvalues are indexed in decreasing order, with multiplicity.
Mathlib's chosen orthonormal eigenbasis fixes a noncomputable representative
inside repeated eigenspaces.  PCA is the orthogonal projection onto the span of
an initial segment of those directions.
-/

noncomputable section

namespace NumStability.HDP.Vector.PrincipalComponents

open MeasureTheory

/-- Convert a `Fin n` rank into Mathlib's cardinality-indexed ordered spectrum. -/
def sortedEigenRank (n : ℕ) (i : Fin n) : Fin (Fintype.card (Fin n)) :=
  Fin.cast (by simp) i

/-- The label in Mathlib's chosen eigenbasis corresponding to an ordered spectral rank. -/
def sortedEigenIndex (n : ℕ) (i : Fin n) : Fin n :=
  (Fintype.equivOfCardEq
    (Fintype.card_fin (Fintype.card (Fin n)))) (sortedEigenRank n i)

/-- The eigenvalue at decreasing spectral rank `i`, retaining multiplicity. -/
def principalEigenvalue {n : ℕ}
    {M : Matrix (Fin n) (Fin n) ℝ} (hM : M.PosSemidef) (i : Fin n) : ℝ :=
  hM.1.eigenvalues₀ (sortedEigenRank n i)

/-- The chosen unit eigenvector at decreasing spectral rank `i`.

When eigenvalues repeat, this uses Mathlib's chosen orthonormal basis of that
eigenspace; no uniqueness of an individual direction is asserted. -/
def principalDirection {n : ℕ}
    {M : Matrix (Fin n) (Fin n) ℝ} (hM : M.PosSemidef) (i : Fin n) :
    EuclideanSpace ℝ (Fin n) :=
  hM.1.eigenvectorBasis (sortedEigenIndex n i)

/-- Principal eigenvalues decrease with their spectral rank. -/
theorem principalEigenvalue_antitone {n : ℕ}
    {M : Matrix (Fin n) (Fin n) ℝ} (hM : M.PosSemidef) :
    Antitone (principalEigenvalue hM) := by
  intro i j hij
  exact hM.1.eigenvalues₀_antitone (by
    simpa [sortedEigenRank] using hij)

/-- A principal direction is an eigenvector for its correspondingly ranked eigenvalue. -/
theorem mulVec_principalDirection {n : ℕ}
    {M : Matrix (Fin n) (Fin n) ℝ} (hM : M.PosSemidef) (i : Fin n) :
    Matrix.mulVec M (principalDirection hM i) =
      (principalEigenvalue hM i) • (principalDirection hM i) := by
  have h := hM.1.mulVec_eigenvectorBasis (sortedEigenIndex n i)
  simpa [principalDirection, principalEigenvalue, sortedEigenIndex,
    sortedEigenRank, Matrix.IsHermitian.eigenvalues] using h

/-- Every chosen principal direction has Euclidean norm one. -/
theorem norm_principalDirection {n : ℕ}
    {M : Matrix (Fin n) (Fin n) ℝ} (hM : M.PosSemidef) (i : Fin n) :
    ‖principalDirection hM i‖ = 1 := by
  exact hM.1.eigenvectorBasis.orthonormal.1 (sortedEigenIndex n i)

/-- The eigenvalue at rank `i` for the second-moment matrix of a finite random
vector. -/
def secondMomentPrincipalEigenvalue
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ)
    (hX : ∀ i, MemLp (X i) 2 μ) (i : Fin n) : ℝ :=
  principalEigenvalue
    (NumStability.HDP.Vector.Covariance.secondMomentMatrix_posSemidef X hX) i

/-- The chosen unit principal direction at rank `i` for a finite random
vector's second-moment matrix. -/
def secondMomentPrincipalDirection
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ)
    (hX : ∀ i, MemLp (X i) 2 μ) (i : Fin n) : EuclideanSpace ℝ (Fin n) :=
  principalDirection
    (NumStability.HDP.Vector.Covariance.secondMomentMatrix_posSemidef X hX) i

/-- The second-moment principal eigenvalues decrease with their rank. -/
theorem secondMomentPrincipalEigenvalue_antitone
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ)
    (hX : ∀ i, MemLp (X i) 2 μ) :
    Antitone (secondMomentPrincipalEigenvalue μ X hX) :=
  principalEigenvalue_antitone
    (NumStability.HDP.Vector.Covariance.secondMomentMatrix_posSemidef X hX)

/-- Each chosen second-moment principal direction is an eigenvector for the
correspondingly ranked eigenvalue. -/
theorem secondMomentMatrix_mulVec_principalDirection
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ)
    (hX : ∀ i, MemLp (X i) 2 μ) (i : Fin n) :
    Matrix.mulVec (NumStability.HDP.Vector.Covariance.secondMomentMatrix μ X)
        (secondMomentPrincipalDirection μ X hX i) =
      (secondMomentPrincipalEigenvalue μ X hX i) •
        (secondMomentPrincipalDirection μ X hX i) :=
  mulVec_principalDirection
    (NumStability.HDP.Vector.Covariance.secondMomentMatrix_posSemidef X hX) i

/-- Each chosen second-moment principal direction has Euclidean norm one. -/
theorem norm_secondMomentPrincipalDirection
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ)
    (hX : ∀ i, MemLp (X i) 2 μ) (i : Fin n) :
    ‖secondMomentPrincipalDirection μ X hX i‖ = 1 :=
  norm_principalDirection
    (NumStability.HDP.Vector.Covariance.secondMomentMatrix_posSemidef X hX) i

/-- The subspace spanned by the first `k` principal directions. -/
def principalSubspace {n : ℕ}
    {M : Matrix (Fin n) (Fin n) ℝ} (hM : M.PosSemidef)
    (k : ℕ) (hk : k ≤ n) : Submodule ℝ (EuclideanSpace ℝ (Fin n)) :=
  Submodule.span ℝ (Set.range fun i : Fin k =>
    principalDirection hM (Fin.castLE hk i))

/-- PCA projection onto the span of the first `k` principal directions. -/
def principalProjection {n : ℕ}
    {M : Matrix (Fin n) (Fin n) ℝ} (hM : M.PosSemidef)
    (k : ℕ) (hk : k ≤ n) :
    EuclideanSpace ℝ (Fin n) →L[ℝ] EuclideanSpace ℝ (Fin n) :=
  (principalSubspace hM k hk).starProjection

/-- The PCA projection lies in the leading principal subspace. -/
theorem principalProjection_mem {n : ℕ}
    {M : Matrix (Fin n) (Fin n) ℝ} (hM : M.PosSemidef)
    (k : ℕ) (hk : k ≤ n) (x : EuclideanSpace ℝ (Fin n)) :
    principalProjection hM k hk x ∈ principalSubspace hM k hk := by
  exact Submodule.starProjection_apply_mem _ _

/-- The residual after PCA projection is orthogonal to the leading principal subspace. -/
theorem sub_principalProjection_mem_orthogonal {n : ℕ}
    {M : Matrix (Fin n) (Fin n) ℝ} (hM : M.PosSemidef)
    (k : ℕ) (hk : k ≤ n) (x : EuclideanSpace ℝ (Fin n)) :
    x - principalProjection hM k hk x ∈ (principalSubspace hM k hk)ᗮ := by
  exact Submodule.sub_starProjection_mem_orthogonal _

end NumStability.HDP.Vector.PrincipalComponents
