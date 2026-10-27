/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.HalfSquareTaylor
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersSmoothSpatial
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersSplitFlux

/-!
# Smooth Burgers Godunov spatial error without a sign restriction

Taylor estimates for the two quadratic half-fluxes give the split-flux
error. The exact shock-selection correction is quadratic in adjacent jumps.
-/

namespace NumStability

/-- The actual Burgers flux divergence is first-order consistent for any
bounded smooth real profile, including profiles crossing zero. -/
theorem leveque04_burgersGodunov_mixed_smoothSpatial_error
    (f f' : ℝ → ℝ) (B M K center width : ℝ)
    (hB : 0 ≤ B) (hM : 0 ≤ M) (hK : 0 ≤ K) (hwidth : 0 < width)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hvalue : ∀ x, |f x| ≤ B) (hderiv : ∀ x, |f' x| ≤ M)
    (hLip : ∀ x y, |f' x - f' y| ≤ K * |x - y|) :
    |((leveque04_burgersSelectedInterfaceState (f center) (f (center + width))) ^ 2 / 2 -
        (leveque04_burgersSelectedInterfaceState (f (center - width)) (f center)) ^ 2 / 2) /
        width - f center * f' center| ≤ (2 * (B * K + M ^ 2) + M ^ 2) * width := by
  let A := fun x => (max 0 (f x)) ^ 2 / 2
  let N := fun x => (min 0 (f x)) ^ 2 / 2
  let C := B * K + M ^ 2
  have hC : 0 ≤ C := by dsimp [C]; positivity
  have hvalueLip (x y : ℝ) : |f x - f y| ≤ M * |x - y| := by
    have h := Convex.norm_image_sub_le_of_norm_hasDerivWithin_le
      (f := f) (f' := f') (s := Set.univ)
      (fun z _ => (hf z).hasDerivWithinAt)
      (fun z _ => by simpa only [Real.norm_eq_abs] using hderiv z)
      (convex_univ : Convex ℝ (Set.univ : Set ℝ)) (Set.mem_univ y) (Set.mem_univ x)
    simpa only [Real.norm_eq_abs] using h
  have hA (x : ℝ) : HasDerivAt A (max 0 (f x) * f' x) x :=
    (hasDerivAt_sq_max_zero_div_two (f x)).comp x (hf x)
  have hN (x : ℝ) : HasDerivAt N (min 0 (f x) * f' x) x :=
    (hasDerivAt_sq_min_zero_div_two (f x)).comp x (hf x)
  let RA := A (center - width) - (A center - width * (max 0 (f center) * f' center))
  let RN := N (center + width) - (N center + width * (min 0 (f center) * f' center))
  have hRA : |RA| ≤ C * width ^ 2 := by
    have h := firstOrderTaylorError_le_of_lipschitzDeriv A (fun x => max 0 (f x) * f' x)
      C center (center - width) hC hA
      (sq_max_zero_comp_deriv_lipschitz f f' B M K hB hM hvalue hderiv hvalueLip hLip)
    convert h using 1 <;> dsimp [RA] <;> ring_nf
  have hRN : |RN| ≤ C * width ^ 2 := by
    have h := firstOrderTaylorError_le_of_lipschitzDeriv N (fun x => min 0 (f x) * f' x)
      C center (center + width) hC hN
      (sq_min_zero_comp_deriv_lipschitz f f' B M K hB hM hvalue hderiv hvalueLip hLip)
    convert h using 1 <;> dsimp [RN] <;> ring_nf
  let splitG := (A center + N (center + width) - (A (center - width) + N center)) / width
  have hparts : max 0 (f center) + min 0 (f center) = f center := by
    simpa only [zero_add] using max_add_min (0 : ℝ) (f center)
  have hsplitIdentity : splitG - f center * f' center = (-RA + RN) / width := by
    dsimp [splitG, RA, RN]
    field_simp
    nlinarith [congrArg (fun z => width * (z * f' center)) hparts]
  have hsplit : |splitG - f center * f' center| ≤ 2 * C * width := by
    rw [hsplitIdentity, abs_div, abs_of_pos hwidth]
    apply (div_le_iff₀ hwidth).2
    have h := abs_add_le (-RA) RN
    rw [abs_neg] at h
    nlinarith
  let flux := fun l r => (leveque04_burgersSelectedInterfaceState l r) ^ 2 / 2
  let ER := flux (f center) (f (center + width)) - (A center + N (center + width))
  let EL := flux (f (center - width)) (f center) - (A (center - width) + N center)
  have hcorrection (x y : ℝ) (hdist : |f x - f y| ≤ M * width) :
      |flux (f x) (f y) - (A x + N y)| ≤ (M * width) ^ 2 / 2 := by
    have h := leveque04_burgersSelectedInterfaceFlux_split_difference (f x) (f y)
    apply h.trans
    rw [← sq_abs (f x - f y)]
    gcongr
  have hER : |ER| ≤ (M * width) ^ 2 / 2 := hcorrection center (center + width) (by
    have h := hvalueLip center (center + width)
    simpa only [sub_add_cancel_left, abs_neg, abs_of_pos hwidth] using h)
  have hEL : |EL| ≤ (M * width) ^ 2 / 2 := hcorrection (center - width) center (by
    have h := hvalueLip (center - width) center
    simpa only [sub_sub_cancel_left, abs_neg, abs_of_pos hwidth] using h)
  let numericalG := (flux (f center) (f (center + width)) -
    flux (f (center - width)) (f center)) / width
  have hcorrectionIdentity : numericalG - splitG = (ER - EL) / width := by
    dsimp [numericalG, splitG, ER, EL]
    ring
  have hactual : |numericalG - splitG| ≤ M ^ 2 * width := by
    rw [hcorrectionIdentity, abs_div, abs_of_pos hwidth]
    apply (div_le_iff₀ hwidth).2
    have h := abs_sub_le ER 0 EL
    simp only [sub_zero, zero_sub, abs_neg] at h
    nlinarith
  have h := abs_sub_le numericalG splitG (f center * f' center)
  change |numericalG - f center * f' center| ≤ _
  change |splitG - f center * f' center| ≤ 2 * (B * K + M ^ 2) * width at hsplit
  linarith

/-- The mixed-sign spatial estimate applies to exact centered averages,
with their inherited derivative and value bounds. -/
theorem leveque04_burgersGodunov_mixed_exactAverage_smoothSpatial_error
    (q qX : ℝ → ℝ) (B M K center width : ℝ)
    (hB : 0 ≤ B) (hM : 0 ≤ M) (hK : 0 ≤ K) (hwidth : 0 < width)
    (hq : ∀ x, HasDerivAt q (qX x) x)
    (hvalue : ∀ x, |q x| ≤ B) (hderiv : ∀ x, |qX x| ≤ M)
    (hLip : ∀ x y, |qX x - qX y| ≤ K * |x - y|) :
    let avg := fun c => oneDimensionalCellAverage q (c - width / 2) (c + width / 2)
    let slope := (q (center + width / 2) - q (center - width / 2)) / width
    |((leveque04_burgersSelectedInterfaceState (avg center) (avg (center + width))) ^ 2 / 2 -
        (leveque04_burgersSelectedInterfaceState (avg (center - width)) (avg center)) ^ 2 / 2) /
        width - avg center * slope| ≤ (2 * (B * K + M ^ 2) + M ^ 2) * width := by
  let avg := fun c => oneDimensionalCellAverage q (c - width / 2) (c + width / 2)
  let slope := fun c => (q (c + width / 2) - q (c - width / 2)) / width
  have hcont : Continuous q := continuous_iff_continuousAt.mpr (fun x => (hq x).continuousAt)
  have hqLip (x y : ℝ) : |q x - q y| ≤ M * |x - y| := by
    have h := Convex.norm_image_sub_le_of_norm_hasDerivWithin_le
      (f := q) (f' := qX) (s := Set.univ)
      (fun z _ => (hq z).hasDerivWithinAt)
      (fun z _ => by simpa only [Real.norm_eq_abs] using hderiv z)
      (convex_univ : Convex ℝ (Set.univ : Set ℝ)) (Set.mem_univ y) (Set.mem_univ x)
    simpa only [Real.norm_eq_abs] using h
  have hAvg (x : ℝ) : HasDerivAt avg (slope x) x :=
    oneDimensionalCellAverage_hasDerivAt_center q width x hcont hwidth
  have hAvgBound (x : ℝ) : |avg x| ≤ B :=
    abs_oneDimensionalCellAverage_le_of_bound q B _ _ (by linarith)
      (hcont.intervalIntegrable _ _) hvalue
  have hSlope (x : ℝ) : |slope x| ≤ M := by
    dsimp [slope]
    rw [abs_div, abs_of_pos hwidth]
    apply (div_le_iff₀ hwidth).2
    have h := hqLip (x + width / 2) (x - width / 2)
    have hid : x + width / 2 - (x - width / 2) = width := by ring
    simpa only [hid, abs_of_pos hwidth] using h
  exact leveque04_burgersGodunov_mixed_smoothSpatial_error avg slope B M K center width
    hB hM hK hwidth hAvg hAvgBound hSlope
    (fun x y => oneDimensionalCellAverage_faceSlope_lipschitz q qX K width x y hwidth hq hLip)

/-- The mixed-sign exact-average estimate compares directly to physical
face divergence, with a mesh-independent first-order coefficient. -/
theorem leveque04_burgersGodunov_mixed_exactAverage_physicalSpatial_error
    (q qX : ℝ → ℝ) (B M K center width : ℝ)
    (hB : 0 ≤ B) (hM : 0 ≤ M) (hK : 0 ≤ K) (hwidth : 0 < width)
    (hq : ∀ x, HasDerivAt q (qX x) x)
    (hvalue : ∀ x, |q x| ≤ B) (hderiv : ∀ x, |qX x| ≤ M)
    (hLip : ∀ x y, |qX x - qX y| ≤ K * |x - y|) :
    let avg := fun c => oneDimensionalCellAverage q (c - width / 2) (c + width / 2)
    |((leveque04_burgersSelectedInterfaceState (avg center) (avg (center + width))) ^ 2 / 2 -
        (leveque04_burgersSelectedInterfaceState (avg (center - width)) (avg center)) ^ 2 / 2) /
        width - (q (center + width / 2) ^ 2 / 2 - q (center - width / 2) ^ 2 / 2) / width| ≤
      (3 * (B * K + M ^ 2) + M ^ 2) * width := by
  let avg := fun c => oneDimensionalCellAverage q (c - width / 2) (c + width / 2)
  let slope := (q (center + width / 2) - q (center - width / 2)) / width
  have hcompare := leveque04_burgersExactAverage_physicalGradient_error q qX B M K center width
    hB hM hK hwidth hq hvalue hderiv hLip
  have hstep := leveque04_burgersGodunov_mixed_exactAverage_smoothSpatial_error q qX B M K center width
    hB hM hK hwidth hq hvalue hderiv hLip
  dsimp only at hstep hcompare ⊢
  have h := abs_sub_le
    (((leveque04_burgersSelectedInterfaceState (avg center) (avg (center + width))) ^ 2 / 2 -
      (leveque04_burgersSelectedInterfaceState (avg (center - width)) (avg center)) ^ 2 / 2) / width)
    (avg center * slope)
    ((q (center + width / 2) ^ 2 / 2 - q (center - width / 2) ^ 2 / 2) / width)
  linarith

end NumStability
