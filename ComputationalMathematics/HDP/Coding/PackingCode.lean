import ComputationalMathematics.HDP.Coding.ErrorCorrection
import Mathlib.Topology.MetricSpace.CoveringNumbers

/-!
# Error-correcting codes from Hamming packings

This module turns a sufficiently large separated subset of the binary Hamming
cube into an encoder and uses nearest-codeword decoding to correct errors.
-/

open Function Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Coding

/-- The binary Hamming cube of dimension `n`, equipped with its Hamming metric. -/
abbrev BinaryHammingSpace (n : ℕ) := Hamming (fun _ : Fin n ↦ Fin 2)

/-- The packing number of the binary Hamming cube at Hamming radius `2r`. -/
noncomputable def binaryHammingPackingNumber (n r : ℕ) : ℕ∞ :=
  Metric.packingNumber ((2 * r : ℕ) : ℝ≥0)
    (Set.univ : Set (BinaryHammingSpace n))

private theorem binaryHammingPackingNumber_ne_top (n r : ℕ) :
    binaryHammingPackingNumber n r ≠ ⊤ := by
  apply ne_of_lt
  exact (Metric.packingNumber_le_encard_self
    (ε := ((2 * r : ℕ) : ℝ≥0))
    (Set.univ : Set (BinaryHammingSpace n))).trans_lt (by simp)

/-- If the binary Hamming cube contains at least as many `2r`-separated
points as there are `k`-bit messages, then there is an `n`-bit code correcting
every pattern of at most `r` errors. -/
noncomputable def errorCorrectingCodeOfPacking {k n r : ℕ}
    (hpack : ENat.card (BinaryWord k) ≤ binaryHammingPackingNumber n r) :
    ErrorCorrectingCode k n r := by
  let P : Set (BinaryHammingSpace n) :=
    Metric.maximalSeparatedSet ((2 * r : ℕ) : ℝ≥0) Set.univ
  have htop : Metric.packingNumber ((2 * r : ℕ) : ℝ≥0)
      (Set.univ : Set (BinaryHammingSpace n)) ≠ ⊤ :=
    binaryHammingPackingNumber_ne_top n r
  have hsize : (Set.univ : Set (BinaryWord k)).encard ≤ P.encard := by
    rw [Set.encard_univ, Metric.encard_maximalSeparatedSet htop]
    exact hpack
  let hexists :=
    (Set.toFinite (Set.univ : Set (BinaryWord k))).exists_injOn_of_encard_le hsize
  let encodeH : BinaryWord k → BinaryHammingSpace n := Classical.choose hexists
  have hencodeH_mem : Set.univ ⊆ encodeH ⁻¹' P := (Classical.choose_spec hexists).1
  have hencodeH_inj : Set.InjOn encodeH Set.univ := (Classical.choose_spec hexists).2
  let encode : BinaryWord k → BinaryWord n := fun x ↦ Hamming.ofHamming (encodeH x)
  have hsep : ∀ x x', x ≠ x' →
      2 * r < hammingDist (encode x) (encode x') := by
    intro x x' hxx'
    have hx : encodeH x ∈ P := hencodeH_mem (Set.mem_univ x)
    have hx' : encodeH x' ∈ P := hencodeH_mem (Set.mem_univ x')
    have hne : encodeH x ≠ encodeH x' :=
      fun h ↦ hxx' (hencodeH_inj (Set.mem_univ x) (Set.mem_univ x') h)
    have hfar := Metric.isSeparated_maximalSeparatedSet hx hx' hne
    change (((2 * r : ℕ) : ℝ≥0) : ℝ≥0∞) < edist (encodeH x) (encodeH x') at hfar
    rw [edist_nndist] at hfar
    have hfar' : ((2 * r : ℕ) : ℝ≥0) < nndist (encodeH x) (encodeH x') :=
      ENNReal.coe_lt_coe.mp hfar
    rw [Hamming.nndist_eq_hammingDist] at hfar'
    exact_mod_cast hfar'
  exact errorCorrectingCodeOfSeparated encode hsep

end NumStability.HDP.Coding
