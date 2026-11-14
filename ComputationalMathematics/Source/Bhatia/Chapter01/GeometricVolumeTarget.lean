/-
SPDX-License-Identifier: MIT
Bhatia, Matrix Analysis (1997), I.5, printed 20 / PDF 32.
Source-prescribed geometric object and proof-free targets; acceptance is separate.
-/
import Mathlib.Analysis.InnerProductSpace.GramMatrix
import Mathlib.MeasureTheory.Measure.Haar.OfBasis
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

set_option autoImplicit false
universe u
open scoped BigOperators

namespace NumStability.Bhatia.Chapter01.Targets

/-- The actual real span in Euclidean L2 space, not an ambient measure carrier. -/
noncomputable def geometricTupleSpan {n k : ℕ} (x : Fin k → EuclideanSpace ℝ (Fin n)) :
    Submodule ℝ (EuclideanSpace ℝ (Fin n)) :=
  Submodule.span ℝ (Set.range x)

/-- The same supplied sides regarded as elements of their span. -/
noncomputable def geometricTupleInSpan {n k : ℕ} (x : Fin k → EuclideanSpace ℝ (Fin n)) :
    Fin k → geometricTupleSpan x :=
  fun i => ⟨x i, Submodule.subset_span (Set.mem_range_self i)⟩

/-- The exact canonical inner-product Lebesgue construction used by
measureSpaceOfInnerProductSpace. Spelling it out prevents an ambient subtype
measure from silently replacing the intrinsic measure. No measure is supplied
by the caller. -/
noncomputable def geometricTupleMeasure {n k : ℕ}
    (x : Fin k → EuclideanSpace ℝ (Fin n)) :
    @MeasureTheory.Measure (geometricTupleSpan x) (borel (geometricTupleSpan x)) :=
  letI : MeasurableSpace (geometricTupleSpan x) := borel (geometricTupleSpan x)
  letI : BorelSpace (geometricTupleSpan x) := ⟨rfl⟩
  (stdOrthonormalBasis ℝ (geometricTupleSpan x)).toBasis.addHaar

/-- Unsigned geometric k-volume as intrinsic Lebesgue measure of the actual
closed coefficient-cube image in the k-dimensional span; deficient rank gives
k-volume zero, rather than the potentially positive lower-rank intrinsic volume. -/
noncomputable def geometricVolumeENNReal {n k : ℕ}
    (x : Fin k → EuclideanSpace ℝ (Fin n)) : ENNReal :=
  if Module.finrank ℝ (geometricTupleSpan x) = k then
    geometricTupleMeasure x (parallelepiped (geometricTupleInSpan x))
  else 0

/-- Real-valued volume. The separate finiteness target below is a required
foundation obligation; no finiteness premise is supplied by a caller. -/
noncomputable def geometricVolume {n k : ℕ}
    (x : Fin k → EuclideanSpace ℝ (Fin n)) : ℝ :=
  (geometricVolumeENNReal x).toReal

/-- Foundation obligation, not an assumption of either source target. -/
def geometricVolumeFinitenessTarget : Prop :=
  ∀ (n k : ℕ) (x : Fin k → EuclideanSpace ℝ (Fin n)),
    geometricVolumeENNReal x ≠ ⊤

/-- Explicit compatible zero-tuple extension: the zero-dimensional point has
volume one. The source does not prescribe this boundary. -/
def geometricVolumeEmptyTupleTarget : Prop :=
  ∀ (n : ℕ) (x : Fin 0 → EuclideanSpace ℝ (Fin n)),
    geometricVolume x = 1

/-- The real Gram determinant equals the square of the independently defined
unsigned geometric volume, for every tuple, including degenerate and k>n. -/
def gramDeterminantVolumeTarget : Prop :=
  ∀ (n k : ℕ) (x : Fin k → EuclideanSpace ℝ (Fin n)),
    Matrix.det (Matrix.gram ℝ x) = geometricVolume x ^ 2

/-- Replace only side i by itself plus an arbitrary real linear combination
of the other current sides. The coefficient at i is ignored by construction. -/
noncomputable def singleSideShear {n k : ℕ} (x : Fin k → EuclideanSpace ℝ (Fin n))
    (i : Fin k) (c : Fin k → ℝ) : Fin k → EuclideanSpace ℝ (Fin n) :=
  Function.update x i (x i + ∑ j ∈ Finset.univ.erase i, c j • x j)

/-- Finite successive operations, each applied to the current tuple. -/
noncomputable def applySideShears {n k : ℕ}
    (ops : List (Fin k × (Fin k → ℝ)))
    (x : Fin k → EuclideanSpace ℝ (Fin n)) :
    Fin k → EuclideanSpace ℝ (Fin n) :=
  ops.foldl (fun current op => singleSideShear current op.1 op.2) x

/-- Complete source shear/reduction account: S1 determinant invariance,
S2 volume itself invariant, S3 finite orthogonal reduction allowing zero
entries, and S4 the squared-volume equality for every orthogonal tuple. -/
def volumeShearTarget : Prop :=
  (∀ (n k : ℕ) (x : Fin k → EuclideanSpace ℝ (Fin n))
    (i : Fin k) (c : Fin k → ℝ),
    Matrix.det (Matrix.gram ℝ (singleSideShear x i c)) =
      Matrix.det (Matrix.gram ℝ x) ∧
    geometricVolume (singleSideShear x i c) = geometricVolume x) ∧
  (∀ (n k : ℕ) (x : Fin k → EuclideanSpace ℝ (Fin n)),
    ∃ ops : List (Fin k × (Fin k → ℝ)),
      Pairwise (fun i j : Fin k =>
        inner ℝ ((applySideShears ops x) i) ((applySideShears ops x) j) = 0)) ∧
  (∀ (n k : ℕ) (x : Fin k → EuclideanSpace ℝ (Fin n)),
    Pairwise (fun i j : Fin k => inner ℝ (x i) (x j) = 0) →
    Matrix.det (Matrix.gram ℝ x) = geometricVolume x ^ 2)

end NumStability.Bhatia.Chapter01.Targets
