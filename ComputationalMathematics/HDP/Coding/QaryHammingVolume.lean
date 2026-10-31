import ComputationalMathematics.HDP.Coding.FiniteAlphabetCode
import Mathlib.Data.Fintype.Card

/-!
# Finite-alphabet Hamming-ball and packing bounds

A word in a Hamming ball is determined by the coordinates that changed and
their new symbols. Allowing every alphabet symbol at a changed coordinate
gives a convenient upper bound; exact `(q-1)` counting is unnecessary for the
fixed 26-symbol code below.
-/

open Finset
open scoped NNReal ENNReal

namespace NumStability.HDP.Coding

private def qarySupport {q n : ℕ} (x y : QaryWord q n) : Finset (Fin n) :=
  Finset.univ.filter fun i => x i ≠ y i

private abbrev qarySupportData (q n : ℕ) :=
  Σ S : Finset (Fin n), S → Fin q

private def qarySupportEncode {q n : ℕ} (x y : QaryWord q n) :
    qarySupportData q n :=
  ⟨qarySupport x y, fun i => y i⟩

private def qarySupportDecode {q n : ℕ} (x : QaryWord q n)
    (d : qarySupportData q n) : QaryWord q n :=
  fun i => if h : i ∈ d.1 then d.2 ⟨i, h⟩ else x i

private theorem qarySupportDecode_encode {q n : ℕ} (x y : QaryWord q n) :
    qarySupportDecode x (qarySupportEncode x y) = y := by
  funext i
  by_cases hi : i ∈ qarySupport x y
  · simp [qarySupportDecode, qarySupportEncode, hi]
  · have hxy : x i = y i := by
      by_contra h
      exact hi (by simp [qarySupport, h])
    simp [qarySupportDecode, qarySupportEncode, hi, hxy]

private theorem qarySupport_card {q n : ℕ} (x y : QaryWord q n) :
    (qarySupport x y).card = hammingDist x y := rfl

private abbrev qaryBoundedSupportData (q n m : ℕ) :=
  Σ S : {S : Finset (Fin n) // S.card ≤ m}, S.val → Fin q

private def qaryBoundedSupportEncode {q n m : ℕ} (x : QaryWord q n)
    (y : {y : QaryWord q n // hammingDist x y ≤ m}) :
    qaryBoundedSupportData q n m :=
  ⟨⟨qarySupport x y.val, by simpa [qarySupport_card] using y.property⟩,
    fun i => y.val i⟩

private def qaryBoundedSupportDecode {q n m : ℕ} (x : QaryWord q n)
    (d : qaryBoundedSupportData q n m) : QaryWord q n :=
  qarySupportDecode x ⟨d.1.val, d.2⟩

private theorem qaryBoundedSupportDecode_encode {q n m : ℕ} (x : QaryWord q n)
    (y : {y : QaryWord q n // hammingDist x y ≤ m}) :
    qaryBoundedSupportDecode x (qaryBoundedSupportEncode x y) = y.val := by
  exact qarySupportDecode_encode x y.val

private theorem qaryBall_card_le_supportData {q n m : ℕ} (x : QaryWord q n) :
    Fintype.card {y : QaryWord q n // hammingDist x y ≤ m} ≤
      Fintype.card (qaryBoundedSupportData q n m) := by
  apply Fintype.card_le_of_injective (qaryBoundedSupportEncode x)
  intro a b hab
  apply Subtype.ext
  have h := congrArg (qaryBoundedSupportDecode x) hab
  simpa [qaryBoundedSupportDecode_encode] using h

private theorem card_qaryBoundedSupportData (q n m : ℕ) :
    Fintype.card (qaryBoundedSupportData q n m) =
      ∑ S : {S : Finset (Fin n) // S.card ≤ m}, q ^ S.val.card := by
  classical
  simp [Fintype.card_sigma]

private def qaryFinsetsUpToCard (n m : ℕ) : Finset (Finset (Fin n)) :=
  (Finset.range (m + 1)).disjiUnion
    (fun j => Finset.univ.powersetCard j)
    (Finset.univ.pairwise_disjoint_powersetCard.set_pairwise _)

private theorem mem_qaryFinsetsUpToCard {n m : ℕ} (S : Finset (Fin n)) :
    S ∈ qaryFinsetsUpToCard n m ↔ S.card ≤ m := by
  simp [qaryFinsetsUpToCard]

private theorem sum_bounded_supports (q n m : ℕ) :
    (∑ S : {S : Finset (Fin n) // S.card ≤ m}, q ^ S.val.card) =
      ∑ j ∈ Finset.range (m + 1), n.choose j * q ^ j := by
  classical
  have hsubsum :
      (∑ S : {S : Finset (Fin n) // S.card ≤ m}, q ^ S.val.card) =
        ∑ S ∈ Finset.univ.filter (fun S : Finset (Fin n) => S.card ≤ m),
          q ^ S.card := by
    simpa using (Finset.sum_subtype_eq_sum_filter
      (s := Finset.univ) (p := fun S : Finset (Fin n) => S.card ≤ m)
      (f := fun S => q ^ S.card))
  rw [hsubsum]
  have hfilter :
      Finset.univ.filter (fun S : Finset (Fin n) => S.card ≤ m) =
        qaryFinsetsUpToCard n m := by
    ext S
    simp [mem_qaryFinsetsUpToCard]
  rw [hfilter]
  unfold qaryFinsetsUpToCard
  rw [Finset.sum_disjiUnion]
  apply Finset.sum_congr rfl
  intro j hj
  calc
    (∑ S ∈ (Finset.univ : Finset (Fin n)).powersetCard j, q ^ S.card) =
        ((Finset.univ : Finset (Fin n)).powersetCard j).card * q ^ j := by
          calc
            _ = ∑ _S ∈ (Finset.univ : Finset (Fin n)).powersetCard j, q ^ j := by
              apply Finset.sum_congr rfl
              intro S hS
              rw [(Finset.mem_powersetCard.mp hS).2]
            _ = ((Finset.univ : Finset (Fin n)).powersetCard j).card * q ^ j := by
              simp [Finset.sum_const]
    _ = n.choose j * q ^ j := by
      rw [Finset.card_powersetCard]
      simp

/-- A Hamming ball has at most the weighted sum of coordinate-subset counts.
The factor `q ^ j` deliberately overcounts the `q-1` actual changes. -/
theorem qaryBall_card_le_weightedVolume {q n m : ℕ} (x : QaryWord q n) :
    Fintype.card {y : QaryWord q n // hammingDist x y ≤ m} ≤
      ∑ j ∈ Finset.range (m + 1), n.choose j * q ^ j := by
  calc
    _ ≤ Fintype.card (qaryBoundedSupportData q n m) :=
      qaryBall_card_le_supportData x
    _ = _ := by rw [card_qaryBoundedSupportData, sum_bounded_supports]

private theorem qary_card_le_card_mul_volume_of_cover {q n m : ℕ}
    (C : Set (QaryHammingSpace q n)) (hCfin : C.Finite)
    (hcover : ∀ y : QaryWord q n, ∃ x ∈ C,
      hammingDist (Hamming.ofHamming x) y ≤ m) :
    q ^ n ≤ Set.ncard C *
      (∑ j ∈ Finset.range (m + 1), n.choose j * q ^ j) := by
  classical
  let center : QaryWord q n → C := fun y =>
    ⟨(hcover y).choose, (hcover y).choose_spec.1⟩
  let offset : QaryWord q n → qaryBoundedSupportData q n m := fun y =>
    qaryBoundedSupportEncode (Hamming.ofHamming (center y).val)
      ⟨y, (hcover y).choose_spec.2⟩
  let f : QaryWord q n → C × qaryBoundedSupportData q n m :=
    fun y => (center y, offset y)
  have hf : Function.Injective f := by
    intro y z hyz
    have hc : center y = center z := congrArg Prod.fst hyz
    have ho : offset y = offset z := congrArg Prod.snd hyz
    calc
      y = qaryBoundedSupportDecode (Hamming.ofHamming (center y).val) (offset y) := by
        exact (qaryBoundedSupportDecode_encode (Hamming.ofHamming (center y).val)
          ⟨y, (hcover y).choose_spec.2⟩).symm
      _ = qaryBoundedSupportDecode (Hamming.ofHamming (center z).val) (offset z) := by
        rw [hc, ho]
      _ = z := qaryBoundedSupportDecode_encode (Hamming.ofHamming (center z).val)
        ⟨z, (hcover z).choose_spec.2⟩
  letI : Fintype C := hCfin.fintype
  have hcard := Fintype.card_le_of_injective f hf
  have hword : Fintype.card (QaryWord q n) = q ^ n := by
    simp [QaryWord]
  rw [hword, Fintype.card_prod, card_qaryBoundedSupportData,
    sum_bounded_supports] at hcard
  simpa [← Nat.card_coe_set_eq, Nat.card_eq_fintype_card] using hcard

/-- Maximal separation covers the whole cube, giving the finite-alphabet
Gilbert--Varshamov counting inequality with the coarse ball bound. -/
theorem qary_pow_le_packingNumber_mul_volume
    (q n r : ℕ) :
    q ^ n ≤ (qaryHammingPackingNumber q n r).toNat *
      (∑ j ∈ Finset.range (2 * r + 1), n.choose j * q ^ j) := by
  let P : Set (QaryHammingSpace q n) :=
    Metric.maximalSeparatedSet ((2 * r : ℕ) : ℝ≥0) Set.univ
  have htop : qaryHammingPackingNumber q n r ≠ ⊤ := by
    apply ne_of_lt
    exact (Metric.packingNumber_le_encard_self
      (ε := ((2 * r : ℕ) : ℝ≥0))
      (Set.univ : Set (QaryHammingSpace q n))).trans_lt (by simp)
  have hPfin : P.Finite := by
    apply Set.encard_lt_top_iff.mp
    rw [Metric.encard_maximalSeparatedSet htop]
    exact lt_top_iff_ne_top.mpr htop
  have hCover : Metric.IsCover ((2 * r : ℕ) : ℝ≥0)
      (Set.univ : Set (QaryHammingSpace q n)) P :=
    Metric.isCover_maximalSeparatedSet htop
  have hcover : ∀ y : QaryWord q n, ∃ x ∈ P,
      hammingDist (Hamming.ofHamming x) y ≤ 2 * r := by
    intro y
    obtain ⟨x, hx, hxy⟩ := hCover (Set.mem_univ (Hamming.toHamming y))
    refine ⟨x, hx, ?_⟩
    change edist (Hamming.toHamming y) x ≤
      (((2 * r : ℕ) : ℝ≥0) : ℝ≥0∞) at hxy
    rw [edist_nndist] at hxy
    have hxy' : nndist (Hamming.toHamming y) x ≤ ((2 * r : ℕ) : ℝ≥0) :=
      ENNReal.coe_le_coe.mp hxy
    rw [Hamming.nndist_eq_hammingDist] at hxy'
    have hnat : hammingDist y (Hamming.ofHamming x) ≤ 2 * r := by
      exact_mod_cast hxy'
    simpa [hammingDist_comm] using hnat
  have hnat := qary_card_le_card_mul_volume_of_cover P hPfin hcover
  have hPcard : Set.ncard P = (qaryHammingPackingNumber q n r).toNat := by
    rw [Set.ncard_def, Metric.encard_maximalSeparatedSet htop]
    rfl
  simpa [hPcard] using hnat

private theorem qaryVolume26 :
    (∑ j ∈ Finset.range 5, (30 : ℕ).choose j * 26 ^ j) = 12595080681 := by
  decide

/-- A uniform code for all twelve-symbol messages over a 26-symbol alphabet
with thirty-symbol codewords, correcting two substitution errors. -/
noncomputable def alphabet26Code12To30Correcting2 :
    QaryErrorCorrectingCode 26 12 30 2 := by
  have hnum : 26 ^ 12 *
      (∑ j ∈ Finset.range 5, (30 : ℕ).choose j * 26 ^ j) ≤ 26 ^ 30 := by
    rw [qaryVolume26]
    norm_num
  have hnat := qary_pow_le_packingNumber_mul_volume 26 30 2
  have hpackNat : 26 ^ 12 ≤ (qaryHammingPackingNumber 26 30 2).toNat := by
    exact Nat.le_of_mul_le_mul_right (hnum.trans hnat)
      (by rw [qaryVolume26]; norm_num)
  have hpack : ENat.card (QaryWord 26 12) ≤ qaryHammingPackingNumber 26 30 2 := by
    rw [ENat.card_eq_coe_fintype_card]
    have hcard : Fintype.card (QaryWord 26 12) = 26 ^ 12 := by
      simp [QaryWord]
    rw [hcard]
    calc
      (26 ^ 12 : ℕ∞) ≤ ((qaryHammingPackingNumber 26 30 2).toNat : ℕ∞) :=
        ENat.coe_le_coe.mpr hpackNat
      _ ≤ qaryHammingPackingNumber 26 30 2 := ENat.coe_toNat_le_self _
  exact qaryCodeOfPacking (by norm_num) hpack

end NumStability.HDP.Coding
