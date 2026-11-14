/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.MatrixExponentialTarget
import ComputationalMathematics.Analysis.LinearOperators.Schur.Complex.Triangulation
import ComputationalMathematics.Analysis.LinearOperators.Schur.Complex.NormalTriangular.Diagonal
import ComputationalMathematics.Analysis.LinearOperators.Jordan.NormalForm.PrimaryDecomposition
import Mathlib.Analysis.SpecialFunctions.Complex.Log

/-!
# Bhatia Chapter I: matrix logarithms

Exercise I.2.8, printed page 8: every invertible complex matrix is an exponential,
and every unitary matrix is the exponential of a skew-Hermitian matrix.

*Unitary matrices.* A Schur triangulation `U = V T Vᴴ` with `V` unitary gives an
upper-triangular `T` that is again unitary, hence normal, hence diagonal. Its
diagonal entries `dᵢ` have modulus one, so their principal logarithms are purely
imaginary. The matrix `A = V diag(log dᵢ) Vᴴ` is therefore skew-Hermitian, and
`exp A = V diag(dᵢ) Vᴴ = U`.

*Invertible matrices.* In a basis adapted to the generalized eigenspaces, the
matrix `M` becomes block diagonal, with blocks `μ • 1 + Nμ` for the eigenvalues
`μ` and nilpotent `Nμ`; invertibility of `M` forces every `μ ≠ 0`. Each block is
`exp (log μ • 1 + L)` where `exp L = 1 + μ⁻¹ Nμ`. A logarithm of a unipotent
matrix `1 + X` is built by successive approximation inside the polynomials in `X`:
if `exp Y = 1 + X + R` with `R` divisible by `X ^ (k + 1)`, then
`exp (Y - R) = 1 + X + R'` with `R'` divisible by `X ^ (k + 2)`. Once the power of
`X` vanishes the approximation is exact. The block logarithms are assembled with
the change-of-basis matrices, which commute with `exp`.

As in `Mathlib.Analysis.Normed.Algebra.MatrixExponential`, unifying the
operator-norm instances with the product-topology instances needs
`backward.isDefEq.respectTransparency false`.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

open scoped Matrix

namespace NumStability.Bhatia.Chapter01

open Matrix

/-- Conjugating by a pair of mutually inverse rectangular matrices commutes with `exp`. -/
private theorem exp_mul_mul_of_mul_eq_one {σ τ : Type*} [Fintype σ] [DecidableEq σ] [Fintype τ]
    [DecidableEq τ] (P : Matrix τ σ ℂ) (Q : Matrix σ τ ℂ) (hQP : Q * P = 1) (hPQ : P * Q = 1)
    (L : Matrix σ σ ℂ) :
    NormedSpace.exp (P * L * Q) = P * NormedSpace.exp L * Q := by
  let φ : Matrix σ σ ℂ →+* Matrix τ τ ℂ :=
    { toFun := fun X => P * X * Q
      map_one' := by simp [hPQ]
      map_mul' := fun X Y => by
        calc P * (X * Y) * Q = P * X * (Q * P) * Y * Q := by
              rw [hQP]; simp [Matrix.mul_assoc]
          _ = P * X * Q * (P * Y * Q) := by simp [Matrix.mul_assoc]
      map_zero' := by simp
      map_add' := fun X Y => by simp [Matrix.mul_add, Matrix.add_mul] }
  have hφ : Continuous φ :=
    (continuous_const.matrix_mul continuous_id).matrix_mul continuous_const
  open scoped Matrix.Norms.Operator in
  exact (NormedSpace.map_exp φ hφ L).symm

/-- The exponential of a complex diagonal matrix. -/
private theorem exp_diagonal_complex {m : Type*} [Fintype m] [DecidableEq m] (d : m → ℂ) :
    NormedSpace.exp (Matrix.diagonal d) = Matrix.diagonal fun i => Complex.exp (d i) := by
  rw [Matrix.exp_diagonal]
  congr 1
  funext i
  open scoped Matrix.Norms.Operator in
  rw [Pi.coe_exp, Complex.exp_eq_exp_ℂ]



/-- The principal logarithm of a unimodular complex number is purely imaginary. -/
private theorem star_log_of_norm_eq_one {z : ℂ} (hz : ‖z‖ = 1) :
    star (Complex.log z) = -Complex.log z := by
  apply Complex.ext
  · simp [Complex.log_re, hz]
  · simp

/-- Exercise I.2.8: every unitary matrix is the exponential of a skew-Hermitian matrix. -/
theorem unitaryMatrixIsExpSkewHermitian : Targets.unitaryMatrixIsExpSkewHermitian := by
  intro n U ⟨hUU, hUU'⟩
  obtain ⟨V, T, hV, hT, hUpper⟩ := schur_triangulation U
  have hV1 : Vᴴ * V = 1 := Matrix.mem_unitaryGroup_iff'.mp hV
  have hV2 : V * Vᴴ = 1 := Matrix.mem_unitaryGroup_iff.mp hV
  -- `T` is unitary.
  have hTT : Tᴴ * T = 1 := by
    rw [← hT]
    simp only [Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose, Matrix.mul_assoc]
    rw [← Matrix.mul_assoc V, hV2, Matrix.one_mul, ← Matrix.mul_assoc Uᴴ, hUU',
      Matrix.one_mul, hV1]
  have hTT' : T * Tᴴ = 1 := mul_eq_one_comm.mp hTT
  have hDiag := normal_upperTriangular_isDiag (T := T)
    (fun i j hji => hUpper i j (Fin.lt_def.mpr hji)) (by rw [hTT, hTT'])
  have hTdiag : T = Matrix.diagonal fun i => T i i := by
    ext i j
    by_cases hij : i = j
    · subst hij; simp
    · rw [hDiag i j hij, Matrix.diagonal_apply_ne _ hij]
  have hnorm : ∀ i, ‖T i i‖ = 1 := by
    intro i
    have h := congrFun (congrFun hTT i) i
    rw [hTdiag] at h
    simp only [Matrix.diagonal_conjTranspose, Matrix.diagonal_mul_diagonal,
      Matrix.diagonal_apply_eq, Matrix.one_apply_eq, Pi.star_apply] at h
    have h' : ((‖T i i‖ ^ 2 : ℝ) : ℂ) = 1 := by
      rw [← h, Complex.star_def, Complex.conj_mul']; push_cast; rfl
    have h2 : ‖T i i‖ ^ 2 = 1 := by exact_mod_cast h'
    nlinarith [norm_nonneg (T i i)]
  have hne : ∀ i, T i i ≠ 0 := fun i h => by simpa [h] using hnorm i
  refine ⟨V * Matrix.diagonal (fun i => Complex.log (T i i)) * Vᴴ, ?_, ?_⟩
  · simp only [Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose,
      Matrix.diagonal_conjTranspose, Matrix.mul_assoc]
    have : (star fun i => Complex.log (T i i)) = -fun i => Complex.log (T i i) := by
      funext i; exact star_log_of_norm_eq_one (hnorm i)
    rw [this, show (-fun i => Complex.log (T i i)) = fun i => -Complex.log (T i i) from rfl,
      ← Matrix.diagonal_neg, Matrix.neg_mul, Matrix.mul_neg]
  · change NormedSpace.exp _ = U
    rw [exp_mul_mul_of_mul_eq_one V Vᴴ hV1 hV2, exp_diagonal_complex]
    simp only [Complex.exp_log (hne _)]
    rw [← hTdiag, ← hT, ← Matrix.mul_assoc, ← Matrix.mul_assoc, hV2, Matrix.one_mul,
      Matrix.mul_assoc, hV2, Matrix.mul_one]


section Nilpotent

variable {m : Type*} [Fintype m] [DecidableEq m]

/-- The exponential of a matrix `Z` with `Z ^ N = 0` is the finite exponential sum. -/
private theorem exp_eq_sum_of_pow_eq_zero {Z : Matrix m m ℂ} {N : ℕ} (hZ : Z ^ N = 0) :
    NormedSpace.exp Z = ∑ i ∈ Finset.range N, ((i.factorial : ℂ)⁻¹) • Z ^ i := by
  rw [congrFun (NormedSpace.exp_eq_tsum ℂ) Z]
  refine tsum_eq_sum fun i hi => ?_
  rw [Finset.mem_range, not_lt] at hi
  rw [pow_eq_zero_of_le hi hZ, smul_zero]

open Polynomial in
/-- For `X` nilpotent, the exponential of `X w(X)` is `1 + X w(X) + (X w(X))² s(X)` for some
polynomial `s`. -/
private theorem exists_exp_aeval_X_mul (X : Matrix m m ℂ) {N : ℕ} (hX : X ^ N = 0)
    (w : ℂ[X]) :
    ∃ s : ℂ[X], NormedSpace.exp (aeval X (Polynomial.X * w)) =
      aeval X (1 + Polynomial.X * w + (Polynomial.X * w) ^ 2 * s) := by
  set z : ℂ[X] := Polynomial.X * w
  have hZ : (aeval X z) ^ (N + 2) = 0 := by
    rw [← map_pow, show z ^ (N + 2) = Polynomial.X ^ N * (Polynomial.X ^ 2 * w ^ (N + 2)) by
      simp only [z]; ring, map_mul, map_pow, aeval_X, hX, zero_mul]
  refine ⟨∑ i ∈ Finset.range N, C ((((i + 2).factorial : ℂ))⁻¹) * z ^ i, ?_⟩
  rw [exp_eq_sum_of_pow_eq_zero hZ, Finset.sum_range_succ', Finset.sum_range_succ']
  simp only [map_add, map_mul, map_pow, map_sum, aeval_C, map_one, Algebra.algebraMap_eq_smul_one,
    Finset.mul_sum]
  simp only [zero_add, Nat.factorial_zero, Nat.factorial_one, Nat.cast_one, inv_one, one_smul,
    pow_zero, pow_one]
  rw [add_assoc, add_comm]
  congr 1
  · rw [add_comm]
  · refine Finset.sum_congr rfl fun i _ => ?_
    rw [smul_one_mul, mul_smul_comm, ← pow_add, add_comm 2 i]


open Polynomial in
/-- Two polynomial expressions in the same matrix commute. -/
private theorem commute_aeval_aeval (X : Matrix m m ℂ) (p q : ℂ[X]) :
    Commute (aeval X p) (aeval X q) := by
  rw [Commute, SemiconjBy, ← map_mul, ← map_mul, mul_comm]

open Polynomial in
/-- Successive approximation of a logarithm of `1 + X`: for each `k` some `exp (X p(X))`
agrees with `1 + X` up to a multiple of `X ^ (k + 1)`. -/
private theorem exists_exp_aeval_eq_one_add_X_add (X : Matrix m m ℂ) {N : ℕ} (hX : X ^ N = 0) :
    ∀ k : ℕ, ∃ p q : ℂ[X], NormedSpace.exp (aeval X (Polynomial.X * p)) =
      aeval X (1 + Polynomial.X + Polynomial.X ^ (k + 1) * q) := by
  intro k
  induction k with
  | zero =>
    refine ⟨0, -1, ?_⟩
    simp
  | succ k ih =>
    obtain ⟨p, q, hpq⟩ := ih
    obtain ⟨s, hs⟩ := exists_exp_aeval_X_mul X hX (-(Polynomial.X ^ k * q))
    refine ⟨p + -(Polynomial.X ^ k * q),
      -q + Polynomial.X ^ k * q ^ 2 *
        (s - 1 + Polynomial.X * s + Polynomial.X ^ (k + 1) * q * s), ?_⟩
    rw [mul_add, map_add, Matrix.exp_add_of_commute _ _ (commute_aeval_aeval X _ _), hpq, hs,
      ← map_mul]
    congr 1
    ring

open Polynomial in
/-- Every unipotent matrix `1 + X`, with `X` nilpotent, is an exponential. -/
private theorem exists_exp_eq_one_add_of_isNilpotent {X : Matrix m m ℂ} (hX : IsNilpotent X) :
    ∃ L : Matrix m m ℂ, NormedSpace.exp L = 1 + X := by
  obtain ⟨N, hN⟩ := hX
  obtain ⟨p, q, hpq⟩ := exists_exp_aeval_eq_one_add_X_add X hN N
  refine ⟨aeval X (Polynomial.X * p), ?_⟩
  rw [hpq]
  simp [pow_succ, hN]

/-- A matrix `μ • 1 + Nμ` with `μ ≠ 0` and `Nμ` nilpotent is an exponential. -/
private theorem exists_exp_eq_smul_one_add {μ : ℂ} (hμ : μ ≠ 0) {Nμ : Matrix m m ℂ}
    (hN : IsNilpotent Nμ) : ∃ L : Matrix m m ℂ, NormedSpace.exp L = μ • 1 + Nμ := by
  have hN' : IsNilpotent (μ⁻¹ • Nμ) := by
    obtain ⟨k, hk⟩ := hN
    exact ⟨k, by rw [smul_pow, hk, smul_zero]⟩
  obtain ⟨L, hL⟩ := exists_exp_eq_one_add_of_isNilpotent hN'
  refine ⟨Matrix.diagonal (fun _ => Complex.log μ) + L, ?_⟩
  have hc : Commute (Matrix.diagonal (fun _ : m => Complex.log μ)) L := by
    rw [← Matrix.smul_one_eq_diagonal]
    exact (Commute.one_left L).smul_left _
  rw [Matrix.exp_add_of_commute _ _ hc, hL, exp_diagonal_complex, Complex.exp_log hμ,
    ← Matrix.smul_one_eq_diagonal, mul_add, mul_one, smul_one_mul, smul_smul,
    mul_inv_cancel₀ hμ, one_smul]

end Nilpotent


/-- Exercise I.2.8: every invertible complex square matrix is the exponential of some
matrix. -/
theorem invertibleMatrixIsExp : Targets.invertibleMatrixIsExp := by
  classical
  intro n M hM
  set f : Module.End ℂ (Fin n → ℂ) := Matrix.toLin' M with hf
  let k : ℂ → ℕ := fun μ => Module.finrank ℂ (f.maxGenEigenspace μ)
  let S : Finset ℂ :=
    Finset.univ.image (Sigma.fst : (Σ μ : ℂ, Fin (k μ)) → ℂ)
  let e : (Σ μ : S, Fin (k μ)) ≃ (Σ μ : ℂ, Fin (k μ)) :=
    { toFun := fun x => ⟨x.1.1, x.2⟩
      invFun := fun x => ⟨⟨x.1, Finset.mem_image_of_mem _ (Finset.mem_univ x)⟩, x.2⟩
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl }
  let b' : Module.Basis (Σ μ : S, Fin (k μ)) ℂ (Fin n → ℂ) :=
    (primaryBasis f).reindex e.symm
  let blk : ∀ μ : S, Matrix (Fin (k μ)) (Fin (k μ)) ℂ := fun μ => primaryDiagBlock f μ
  have hB : LinearMap.toMatrix b' b' f = Matrix.blockDiagonal' blk := by
    ext ⟨μ, c⟩ ⟨ν, a⟩
    have hentry : LinearMap.toMatrix b' b' f ⟨μ, c⟩ ⟨ν, a⟩ =
        LinearMap.toMatrix (primaryBasis f) (primaryBasis f) f ⟨μ.1, c⟩ ⟨ν.1, a⟩ := by
      simp only [b', LinearMap.toMatrix_apply, Module.Basis.reindex_apply,
        Module.Basis.repr_reindex, Finsupp.mapDomain_equiv_apply]
      rfl
    rw [hentry]
    by_cases h : μ = ν
    · subst h
      rw [Matrix.blockDiagonal'_apply_eq]
      rfl
    · rw [Matrix.blockDiagonal'_apply_ne _ _ _ h]
      exact toMatrix_primaryBasis_block_offDiag f (fun h' => h (Subtype.ext h')) a c
  -- Change of basis between the standard basis and `b'`.
  let P : Matrix (Fin n) (Σ μ : S, Fin (k μ)) ℂ := (Pi.basisFun ℂ (Fin n)).toMatrix b'
  let Q : Matrix (Σ μ : S, Fin (k μ)) (Fin n) ℂ := b'.toMatrix (Pi.basisFun ℂ (Fin n))
  have hPQ : P * Q = 1 := Module.Basis.toMatrix_mul_toMatrix_flip _ _
  have hQP : Q * P = 1 := Module.Basis.toMatrix_mul_toMatrix_flip _ _
  have hM' : P * Matrix.blockDiagonal' blk * Q = M := by
    rw [← hB, basis_toMatrix_mul_linearMap_toMatrix_mul_basis_toMatrix,
      LinearMap.toMatrix_eq_toMatrix', hf, LinearMap.toMatrix'_toLin']
  -- The block-diagonal matrix is invertible.
  have hdet : IsUnit (Matrix.blockDiagonal' blk).det := by
    have hMinv : M * M⁻¹ = 1 :=
      Matrix.mul_nonsing_inv M ((Matrix.isUnit_iff_isUnit_det M).mp hM)
    refine Matrix.isUnit_det_of_right_inverse (B := Q * M⁻¹ * P) ?_
    calc Matrix.blockDiagonal' blk * (Q * M⁻¹ * P)
        = (Q * P) * Matrix.blockDiagonal' blk * (Q * M⁻¹ * P) := by rw [hQP, Matrix.one_mul]
      _ = Q * (P * Matrix.blockDiagonal' blk * Q) * M⁻¹ * P := by simp only [Matrix.mul_assoc]
      _ = 1 := by rw [hM', Matrix.mul_assoc Q M, hMinv, Matrix.mul_one, hQP]
  -- Every block belongs to a nonzero eigenvalue.
  have hμ : ∀ μ : S, (μ : ℂ) ≠ 0 := by
    rintro ⟨μ, hmem⟩ h0
    obtain ⟨⟨ν, a⟩, -, hν⟩ := Finset.mem_image.mp hmem
    simp only at hν
    subst hν
    have h0' : ν = 0 := h0
    subst h0'
    obtain ⟨K, hK⟩ := isNilpotent_toMatrix_nilpotentPart f 0
    have hblk : blk ⟨0, hmem⟩ ^ K = 0 := by
      change primaryDiagBlock f 0 ^ K = 0
      rw [primaryDiagBlock_eq, zero_smul, zero_add]
      exact hK
    have hcol : ∀ i, (Matrix.blockDiagonal' blk ^ K) i ⟨⟨0, hmem⟩, a⟩ = 0 := by
      rintro ⟨ρ, c⟩
      rw [← Matrix.blockDiagonal'_pow]
      by_cases h : ρ = ⟨0, hmem⟩
      · subst h
        rw [Matrix.blockDiagonal'_apply_eq, Pi.pow_apply, hblk, Matrix.zero_apply]
      · rw [Matrix.blockDiagonal'_apply_ne _ _ _ h]
    have h1 := Matrix.det_eq_zero_of_column_eq_zero _ hcol
    rw [Matrix.det_pow] at h1
    exact (hdet.pow K).ne_zero h1
  -- Take a logarithm of every block.
  have hL : ∀ μ : S,
      ∃ L : Matrix (Fin (k μ)) (Fin (k μ)) ℂ, NormedSpace.exp L = blk μ := by
    intro μ
    change ∃ L, NormedSpace.exp L = primaryDiagBlock f μ
    rw [primaryDiagBlock_eq]
    exact exists_exp_eq_smul_one_add (hμ μ) (isNilpotent_toMatrix_nilpotentPart f μ)
  choose L hL using hL
  refine ⟨P * Matrix.blockDiagonal' L * Q, ?_⟩
  change NormedSpace.exp _ = M
  rw [exp_mul_mul_of_mul_eq_one P Q hQP hPQ, Matrix.exp_blockDiagonal', ← hM']
  open scoped Matrix.Norms.Operator in
  rw [Pi.exp_def]
  simp only [hL]

end NumStability.Bhatia.Chapter01
