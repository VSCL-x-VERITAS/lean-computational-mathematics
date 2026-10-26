/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.HalfSquareTaylor
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLipschitzTrace
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersFlux

/-!
# Smooth spatial consistency of the actual Burgers Godunov flux

For nonnegative data the selected shock/fan flux is the left physical flux.
The first-order spatial estimate is instantiated on exact cell averages of
a bounded smooth profile. Time truncation and global convergence are separate.
-/

open MeasureTheory

namespace NumStability

theorem leveque04_burgersSelectedInterfaceFlux_nonnegative
    (left right : ℝ) (hl : 0 ≤ left) (hr : 0 ≤ right) :
    (leveque04_burgersSelectedInterfaceState left right) ^ 2 / 2 = left ^ 2 / 2 := by
  rw [leveque04_burgersSelectedInterfaceFlux_eq_max, max_eq_right hl, min_eq_left hr]
  simp [max_eq_left (by positivity : (0 : ℝ) ≤ left ^ 2 / 2)]

/-- The actual interface-flux divergence approximates the spatial derivative
of the half-square with first-order error for nonnegative smooth data. -/
theorem leveque04_burgersGodunov_smoothSpatial_error
    (f f' : ℝ → ℝ) (B M K center width : ℝ)
    (hB : 0 ≤ B) (hM : 0 ≤ M) (hK : 0 ≤ K) (hwidth : 0 < width)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hvalue : ∀ x, 0 ≤ f x ∧ |f x| ≤ B) (hderiv : ∀ x, |f' x| ≤ M)
    (hLip : ∀ x y, |f' x - f' y| ≤ K * |x - y|) :
    |((leveque04_burgersSelectedInterfaceState (f center) (f (center + width))) ^ 2 / 2 -
        (leveque04_burgersSelectedInterfaceState (f (center - width)) (f center)) ^ 2 / 2) /
        width - f center * f' center| ≤ (B * K + M ^ 2) * width := by
  rw [leveque04_burgersSelectedInterfaceFlux_nonnegative _ _ (hvalue center).1
      (hvalue (center + width)).1,
    leveque04_burgersSelectedInterfaceFlux_nonnegative _ _ (hvalue (center - width)).1
      (hvalue center).1]
  exact halfSquare_backwardDifference_error f f' B M K center width hB hM hK hwidth
    hf (fun x => (hvalue x).2) hderiv hLip

/-- Exact averages inherit the smooth spatial consistency bound. The
comparison derivative is the derivative of their own physical half-square,
not a substituted point-sample scheme. -/
theorem leveque04_burgersGodunov_exactAverage_smoothSpatial_error
    (q qX : ℝ → ℝ) (B M K center width : ℝ)
    (hB : 0 ≤ B) (hM : 0 ≤ M) (hK : 0 ≤ K) (hwidth : 0 < width)
    (hq : ∀ x, HasDerivAt q (qX x) x)
    (hvalue : ∀ x, 0 ≤ q x ∧ |q x| ≤ B) (hderiv : ∀ x, |qX x| ≤ M)
    (hLip : ∀ x y, |qX x - qX y| ≤ K * |x - y|) :
    let avg := fun c => oneDimensionalCellAverage q (c - width / 2) (c + width / 2)
    let slope := (q (center + width / 2) - q (center - width / 2)) / width
    |((leveque04_burgersSelectedInterfaceState (avg center) (avg (center + width))) ^ 2 / 2 -
        (leveque04_burgersSelectedInterfaceState (avg (center - width)) (avg center)) ^ 2 / 2) /
        width - avg center * slope| ≤ (B * K + M ^ 2) * width := by
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
  have hAvgBounds (x : ℝ) : 0 ≤ avg x ∧ |avg x| ≤ B := by
    have hinterval : x - width / 2 < x + width / 2 := by linarith
    constructor
    · dsimp [avg, oneDimensionalCellAverage]
      exact mul_nonneg (inv_nonneg.mpr (sub_nonneg.mpr hinterval.le))
        (intervalIntegral.integral_nonneg_of_forall hinterval.le (fun y => (hvalue y).1))
    · exact abs_oneDimensionalCellAverage_le_of_bound q B _ _ hinterval
        (hcont.intervalIntegrable _ _) (fun y => (hvalue y).2)
  have hSlope (x : ℝ) : |slope x| ≤ M := by
    dsimp [slope]
    rw [abs_div, abs_of_pos hwidth]
    apply (div_le_iff₀ hwidth).2
    have h := hqLip (x + width / 2) (x - width / 2)
    have hid : x + width / 2 - (x - width / 2) = width := by ring
    simpa only [hid, abs_of_pos hwidth] using h
  exact leveque04_burgersGodunov_smoothSpatial_error avg slope B M K center width
    hB hM hK hwidth hAvg hAvgBounds hSlope
    (fun x y => oneDimensionalCellAverage_faceSlope_lipschitz q qX K width x y hwidth hq hLip)

/-- The physical gradient of the averaged state differs from the exact
physical face divergence by first-order error, without a sign restriction. -/
theorem leveque04_burgersExactAverage_physicalGradient_error
    (q qX : ℝ → ℝ) (B M K center width : ℝ)
    (hB : 0 ≤ B) (hM : 0 ≤ M) (hK : 0 ≤ K) (hwidth : 0 < width)
    (hq : ∀ x, HasDerivAt q (qX x) x)
    (hvalue : ∀ x, |q x| ≤ B) (hderiv : ∀ x, |qX x| ≤ M)
    (hLip : ∀ x y, |qX x - qX y| ≤ K * |x - y|) :
    let avg := oneDimensionalCellAverage q (center - width / 2) (center + width / 2)
    let slope := (q (center + width / 2) - q (center - width / 2)) / width
    |avg * slope - (q (center + width / 2) ^ 2 / 2 - q (center - width / 2) ^ 2 / 2) / width| ≤
      (B * K + M ^ 2) * width := by
  let avg := fun c => oneDimensionalCellAverage q (c - width / 2) (c + width / 2)
  let slope := (q (center + width / 2) - q (center - width / 2)) / width
  let C := B * K + M ^ 2
  have hC : 0 ≤ C := by dsimp [C]; positivity
  have hcont : Continuous q := continuous_iff_continuousAt.mpr (fun x => (hq x).continuousAt)
  have hqXLip : LipschitzWith ⟨K, hK⟩ qX := LipschitzWith.of_dist_le_mul (by
    intro x y
    simpa only [Real.dist_eq, NNReal.coe_mk] using hLip x y)
  have hqXcont : Continuous qX := hqXLip.continuous
  have hqLip (x y : ℝ) : |q x - q y| ≤ M * |x - y| := by
    have h := Convex.norm_image_sub_le_of_norm_hasDerivWithin_le
      (f := q) (f' := qX) (s := Set.univ)
      (fun z _ => (hq z).hasDerivWithinAt)
      (fun z _ => by simpa only [Real.norm_eq_abs] using hderiv z)
      (convex_univ : Convex ℝ (Set.univ : Set ℝ)) (Set.mem_univ y) (Set.mem_univ x)
    simpa only [Real.norm_eq_abs] using h
  have hinterval : center - width / 2 < center + width / 2 := by linarith
  have hA : |avg center| ≤ B := abs_oneDimensionalCellAverage_le_of_bound q B _ _ hinterval
    (hcont.intervalIntegrable _ _) hvalue
  have hAerror := oneDimensionalCellAverage_sub_center_le_of_lipschitz q M center width
    hM hwidth hcont hqLip
  have hSlopeIdentity : oneDimensionalCellAverage qX
      (center - width / 2) (center + width / 2) = slope := by
    rw [oneDimensionalCellAverage_derivativeProfile_eq_faceSlope q qX _ _ hq hqXcont]
    dsimp [slope]
    congr 1
    ring
  have hSlopeError : |slope - qX center| ≤ K * (width / 2) := by
    rw [← hSlopeIdentity]
    exact oneDimensionalCellAverage_sub_center_le_of_lipschitz qX K center width hK hwidth hqXcont hLip
  have hProductError : |avg center * slope - q center * qX center| ≤ C * (width / 2) := by
    calc
      _ = |avg center * (slope - qX center) + (avg center - q center) * qX center| := by congr 1; ring
      _ ≤ |avg center * (slope - qX center)| + |(avg center - q center) * qX center| := abs_add_le _ _
      _ = |avg center| * |slope - qX center| + |avg center - q center| * |qX center| := by rw [abs_mul, abs_mul]
      _ ≤ B * (K * (width / 2)) + (M * (width / 2)) * M := by
        exact add_le_add (mul_le_mul hA hSlopeError (abs_nonneg _) hB)
          (mul_le_mul hAerror (hderiv center) (abs_nonneg _) (by positivity))
      _ = _ := by dsimp [C]; ring
  have hpLip := halfSquare_comp_deriv_lipschitz q qX B M K hB hM hq
    hvalue hderiv hLip
  have hPerror := oneDimensionalCellAverage_sub_center_le_of_lipschitz
    (fun x => q x * qX x) C center width hC hwidth (hcont.mul hqXcont) hpLip
  have hcompare : |avg center * slope - oneDimensionalCellAverage (fun x => q x * qX x)
      (center - width / 2) (center + width / 2)| ≤ C * width := by
    have htriangle := abs_sub_le (avg center * slope) (q center * qX center)
      (oneDimensionalCellAverage (fun x => q x * qX x) (center - width / 2) (center + width / 2))
    rw [abs_sub_comm (q center * qX center)] at htriangle
    linarith
  have hphysical : oneDimensionalCellAverage (fun x => q x * qX x)
      (center - width / 2) (center + width / 2) =
      (q (center + width / 2) ^ 2 / 2 - q (center - width / 2) ^ 2 / 2) / width := by
    have hflux (x : ℝ) : HasDerivAt (fun y => q y ^ 2 / 2) (q x * qX x) x := by
      apply (((hq x).pow 2).div_const 2).congr_deriv
      ring
    rw [oneDimensionalCellAverage_derivativeProfile_eq_faceSlope _ _ _ _ hflux (hcont.mul hqXcont)]
    congr 1
    ring
  rw [hphysical] at hcompare
  exact hcompare

/-- Comparing the actual flux divergence with the exact physical
face divergence still gives first-order spatial error on exact averages. -/
theorem leveque04_burgersGodunov_exactAverage_physicalSpatial_error
    (q qX : ℝ → ℝ) (B M K center width : ℝ)
    (hB : 0 ≤ B) (hM : 0 ≤ M) (hK : 0 ≤ K) (hwidth : 0 < width)
    (hq : ∀ x, HasDerivAt q (qX x) x)
    (hvalue : ∀ x, 0 ≤ q x ∧ |q x| ≤ B) (hderiv : ∀ x, |qX x| ≤ M)
    (hLip : ∀ x y, |qX x - qX y| ≤ K * |x - y|) :
    let avg := fun c => oneDimensionalCellAverage q (c - width / 2) (c + width / 2)
    |((leveque04_burgersSelectedInterfaceState (avg center) (avg (center + width))) ^ 2 / 2 -
        (leveque04_burgersSelectedInterfaceState (avg (center - width)) (avg center)) ^ 2 / 2) /
        width - (q (center + width / 2) ^ 2 / 2 - q (center - width / 2) ^ 2 / 2) / width| ≤
      2 * (B * K + M ^ 2) * width := by
  let avg := fun c => oneDimensionalCellAverage q (c - width / 2) (c + width / 2)
  let slope := (q (center + width / 2) - q (center - width / 2)) / width
  let C := B * K + M ^ 2
  have hcompare := leveque04_burgersExactAverage_physicalGradient_error q qX B M K center width
    hB hM hK hwidth hq (fun x => (hvalue x).2) hderiv hLip
  have hstep := leveque04_burgersGodunov_exactAverage_smoothSpatial_error q qX B M K center width
    hB hM hK hwidth hq hvalue hderiv hLip
  dsimp only at hstep ⊢
  have htriangle := abs_sub_le
    (((leveque04_burgersSelectedInterfaceState (avg center) (avg (center + width))) ^ 2 / 2 -
      (leveque04_burgersSelectedInterfaceState (avg (center - width)) (avg center)) ^ 2 / 2) / width)
    (avg center * slope)
    ((q (center + width / 2) ^ 2 / 2 - q (center - width / 2) ^ 2 / 2) / width)
  change |_ - avg center * slope| ≤ C * width at hstep
  change |_| ≤ 2 * C * width
  linarith

end NumStability
