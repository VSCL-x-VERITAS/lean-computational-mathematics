import Mathlib.InformationTheory.Hamming
import Mathlib.Topology.MetricSpace.CoveringNumbers

/-!
# Error-correcting codes over a finite alphabet

The basic Hamming packing construction works for any positive alphabet size.
This module supplies a uniform total decoder once enough separated codewords
exist. Numerical packing bounds are separate.
-/

open Function Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Coding

/-- Words of length `n` over the alphabet `Fin q`. -/
abbrev QaryWord (q n : ℕ) := Fin n → Fin q

/-- One encoder and total decoder correcting all corruptions of radius `r`. -/
structure QaryErrorCorrectingCode (q k n r : ℕ) where
  /-- The fixed encoding map. -/
  encode : QaryWord q k → QaryWord q n
  /-- The fixed decoding map. -/
  decode : QaryWord q n → QaryWord q k
  /-- Uniform correction of all messages and received words in range. -/
  corrects : ∀ (x : QaryWord q k) (y : QaryWord q n),
    hammingDist y (encode x) ≤ r → decode y = x

/-- Choose a nearby message if one exists, otherwise return a default word. -/
noncomputable def qarySeparatedDecode {q k n r : ℕ} (hq : 0 < q)
    (encode : QaryWord q k → QaryWord q n) (y : QaryWord q n) : QaryWord q k :=
  if h : ∃ x : QaryWord q k, hammingDist y (encode x) ≤ r then
    Classical.choose h
  else fun _ => ⟨0, hq⟩

private theorem qarySeparatedUniqueNearby {q k n r : ℕ}
    (encode : QaryWord q k → QaryWord q n)
    (hsep : ∀ x x', x ≠ x' → 2 * r < hammingDist (encode x) (encode x'))
    (y : QaryWord q n) {x x' : QaryWord q k}
    (hx : hammingDist y (encode x) ≤ r)
    (hx' : hammingDist y (encode x') ≤ r) : x = x' := by
  by_contra hne
  have hfar := hsep x x' hne
  have htri := hammingDist_triangle (encode x) y (encode x')
  rw [hammingDist_comm (encode x) y] at htri
  omega

/-- Separated codewords admit a decoder correcting `r` substitutions. -/
noncomputable def qaryCodeOfSeparated {q k n r : ℕ} (hq : 0 < q)
    (encode : QaryWord q k → QaryWord q n)
    (hsep : ∀ x x', x ≠ x' → 2 * r < hammingDist (encode x) (encode x')) :
    QaryErrorCorrectingCode q k n r where
  encode := encode
  decode := qarySeparatedDecode hq encode
  corrects := by
    intro x y hy
    let h : ∃ x' : QaryWord q k, hammingDist y (encode x') ≤ r := ⟨x, hy⟩
    rw [qarySeparatedDecode, dif_pos h]
    exact qarySeparatedUniqueNearby encode hsep y (Classical.choose_spec h) hy

/-- The Hamming metric on `q`-ary words. -/
abbrev QaryHammingSpace (q n : ℕ) := Hamming (fun _ : Fin n ↦ Fin q)

/-- The maximal number of codewords at separation `2r`. -/
noncomputable def qaryHammingPackingNumber (q n r : ℕ) : ℕ∞ :=
  Metric.packingNumber ((2 * r : ℕ) : ℝ≥0)
    (Set.univ : Set (QaryHammingSpace q n))

/-- A large enough finite-alphabet packing gives a uniform error-correcting
code. The requisite packing-number lower bound is a separate obligation. -/
noncomputable def qaryCodeOfPacking {q k n r : ℕ} (hq : 0 < q)
    (hpack : ENat.card (QaryWord q k) ≤ qaryHammingPackingNumber q n r) :
    QaryErrorCorrectingCode q k n r := by
  letI : Nonempty (Fin q) := ⟨⟨0, hq⟩⟩
  letI : Nonempty (QaryHammingSpace q n) :=
    ⟨Hamming.toHamming (fun _ => ⟨0, hq⟩)⟩
  let P : Set (QaryHammingSpace q n) :=
    Metric.maximalSeparatedSet ((2 * r : ℕ) : ℝ≥0) Set.univ
  have htop : Metric.packingNumber ((2 * r : ℕ) : ℝ≥0)
      (Set.univ : Set (QaryHammingSpace q n)) ≠ ⊤ := by
    apply ne_of_lt
    exact (Metric.packingNumber_le_encard_self
      (ε := ((2 * r : ℕ) : ℝ≥0))
      (Set.univ : Set (QaryHammingSpace q n))).trans_lt (by simp)
  have hsize : (Set.univ : Set (QaryWord q k)).encard ≤ P.encard := by
    rw [Set.encard_univ, Metric.encard_maximalSeparatedSet htop]
    exact hpack
  let hexists :=
    (Set.toFinite (Set.univ : Set (QaryWord q k))).exists_injOn_of_encard_le hsize
  let encodeH : QaryWord q k → QaryHammingSpace q n := Classical.choose hexists
  have hencodeH_mem : Set.univ ⊆ encodeH ⁻¹' P := (Classical.choose_spec hexists).1
  have hencodeH_inj : Set.InjOn encodeH Set.univ := (Classical.choose_spec hexists).2
  let encode : QaryWord q k → QaryWord q n := fun x ↦ Hamming.ofHamming (encodeH x)
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
  exact qaryCodeOfSeparated hq encode hsep

end NumStability.HDP.Coding
