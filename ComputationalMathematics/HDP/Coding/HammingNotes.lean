import ComputationalMathematics.HDP.Coding.HammingConverse
import Mathlib.Analysis.SpecialFunctions.BinaryEntropy

/-!
# The literal Hamming bound printed in the Chapter 4 notes
-/

namespace NumStability.HDP.Coding

/-- The literal function printed in the Chapter 4 notes.  The second term has
the plus sign appearing in the source; this is intentionally kept distinct
from the standard binary entropy, whose second term has a minus sign. -/
noncomputable def printedBinaryEntropy (t : ℝ) : ℝ :=
  -t * Real.logb 2 t + (1 - t) * Real.logb 2 (1 - t)

/-- The finite Hamming converse implies the Chapter 4 notes' literal
`R ≤ 1 - h(δ)` bound when the radius is positive and at most the block
length.  This is the quantitative core used below. -/
private theorem ErrorCorrectingCode.codingRate_le_one_sub_printedBinaryEntropy_of_pos_le
    {k n r : ℕ} (C : ErrorCorrectingCode k n r)
    (hr : 0 < r) (hrn : r ≤ n) :
    codingRate k n ≤ 1 - printedBinaryEntropy (errorFraction r n) := by
  let δ : ℝ := errorFraction r n
  have hn : 0 < n := hr.trans_le hrn
  have hnR : (0 : ℝ) < n := by exact_mod_cast hn
  have hδpos : 0 < δ := by dsimp [δ, errorFraction]; positivity
  have hδle : δ ≤ 1 := by
    dsimp [δ, errorFraction]
    exact (div_le_one hnR).2 (by exact_mod_cast hrn)
  have hrest0 : 0 ≤ 1 - δ := sub_nonneg.mpr hδle
  have hlogrest : Real.logb 2 (1 - δ) ≤ 0 :=
    Real.logb_nonpos (by norm_num) hrest0 (by linarith)
  have hrest : (1 - δ) * Real.logb 2 (1 - δ) ≤ 0 :=
    mul_nonpos_of_nonneg_of_nonpos hrest0 hlogrest
  have hbase := C.codingRate_le_one_sub_errorFraction_mul_logb hr hrn
  change codingRate k n ≤ 1 - δ * Real.logb 2 (1 / δ) at hbase
  have hinv : Real.logb 2 (1 / δ) = -Real.logb 2 δ := by
    rw [one_div, Real.logb_inv]
  rw [hinv] at hbase
  dsimp [printedBinaryEntropy]
  nlinarith

/-- The literal printed entropy is at most one on the nonnegative half-line.
This includes the source-relevant interval and also handles totalized edge
cases such as a zero block length. -/
theorem printedBinaryEntropy_le_one_of_nonneg {t : ℝ} (ht : 0 ≤ t) :
    printedBinaryEntropy t ≤ 1 := by
  have hlog2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hprinted :
      printedBinaryEntropy t =
        (-t * Real.log t + (1 - t) * Real.log (1 - t)) / Real.log 2 := by
    simp [printedBinaryEntropy, Real.logb]
    ring
  rw [hprinted]
  apply (div_le_one hlog2).2
  by_cases ht1 : t ≤ 1
  · have hrest0 : 0 ≤ 1 - t := sub_nonneg.mpr ht1
    have hrest1 : 1 - t ≤ 1 := by linarith
    have hrest_nonpos : (1 - t) * Real.log (1 - t) ≤ 0 :=
      Real.mul_log_nonpos hrest0 hrest1
    have hbin := Real.binEntropy_le_log_two (p := t)
    have hbin_formula :
        Real.binEntropy t =
          -t * Real.log t - (1 - t) * Real.log (1 - t) := by
      simp [Real.binEntropy, Real.log_inv]
      ring
    rw [hbin_formula] at hbin
    linarith
  · have ht1' : 1 ≤ t := le_of_not_ge ht1
    let y : ℝ := t - 1
    have hy0 : 0 ≤ y := by dsimp [y]; linarith
    have hfirst : -t * Real.log t ≤ 0 := by
      have := Real.mul_log_nonneg ht1'
      linarith
    have hrest_eq :
        (1 - t) * Real.log (1 - t) = Real.negMulLog y := by
      have hone : 1 - t = -y := by dsimp [y]; ring
      rw [hone, Real.log_neg_eq_log]
      simp [Real.negMulLog]
    have hneg_le : Real.negMulLog y ≤ Real.log 2 := by
      by_cases hy1 : y ≤ 1
      · have hother : 0 ≤ Real.negMulLog (1 - y) :=
          Real.negMulLog_nonneg (sub_nonneg.mpr hy1) (by linarith)
        have hbin := Real.binEntropy_le_log_two (p := y)
        rw [Real.binEntropy_eq_negMulLog_add_negMulLog_one_sub] at hbin
        linarith
      · have hy1' : 1 ≤ y := le_of_not_ge hy1
        have hmul : 0 ≤ y * Real.log y := Real.mul_log_nonneg hy1'
        have hneg_nonpos : Real.negMulLog y ≤ 0 := by
          simpa [Real.negMulLog, neg_mul] using neg_nonpos.mpr hmul
        exact hneg_nonpos.trans hlog2.le
    rw [hrest_eq]
    linarith

/-- An injective binary encoder cannot carry more message bits than its block
length. -/
theorem ErrorCorrectingCode.messageBits_le_blockLength
    {k n r : ℕ} (C : ErrorCorrectingCode k n r) : k ≤ n := by
  have hcard : Fintype.card (BinaryWord k) ≤ Fintype.card (BinaryWord n) :=
    Fintype.card_le_of_injective C.encode C.encode_injective
  simpa only [BinaryWord, Fintype.card_fun, Fintype.card_fin,
    Nat.pow_le_pow_iff_right (by omega : 1 < 2)] using hcard

/-- Every finite binary error-correcting code obeys the literal Hamming bound
printed in the Chapter 4 notes.  No extra positivity or radius-versus-length
hypotheses are needed: positive-message codes force the latter geometrically,
while the totalized boundary cases follow from injectivity and the elementary
entropy bound above. -/
theorem ErrorCorrectingCode.codingRate_le_one_sub_printedBinaryEntropy
    {k n r : ℕ} (C : ErrorCorrectingCode k n r) :
    codingRate k n ≤ 1 - printedBinaryEntropy (errorFraction r n) := by
  by_cases hr0 : r = 0
  · subst r
    have hkn := C.messageBits_le_blockLength
    norm_num [errorFraction, printedBinaryEntropy]
    unfold codingRate
    by_cases hn0 : n = 0
    · subst n
      simp_all
    · have hnR : (0 : ℝ) < n := by exact_mod_cast Nat.pos_of_ne_zero hn0
      exact (div_le_one hnR).2 (by exact_mod_cast hkn)
  · have hr : 0 < r := Nat.pos_of_ne_zero hr0
    by_cases hk0 : k = 0
    · subst k
      simp only [codingRate, Nat.cast_zero, zero_div]
      have hnonneg : 0 ≤ errorFraction r n := by
        unfold errorFraction
        positivity
      linarith [printedBinaryEntropy_le_one_of_nonneg hnonneg]
    · have hk : 0 < k := Nat.pos_of_ne_zero hk0
      let x₀ : BinaryWord k := 0
      let x₁ : BinaryWord k := fun _ ↦ 1
      have hx : x₀ ≠ x₁ := by
        intro heq
        have hcoord := congrFun heq ⟨0, hk⟩
        simp [x₀, x₁] at hcoord
      have hdist := C.two_mul_lt_hammingDist_encode hx
      have hdist_le : hammingDist (C.encode x₀) (C.encode x₁) ≤ n := by
        simpa only [Fintype.card_fin] using
          (hammingDist_le_card_fintype (x := C.encode x₀) (y := C.encode x₁))
      have hrn : r ≤ n := by omega
      exact C.codingRate_le_one_sub_printedBinaryEntropy_of_pos_le hr hrn

end NumStability.HDP.Coding
