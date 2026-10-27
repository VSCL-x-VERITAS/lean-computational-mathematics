/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.PiecewiseConstantReconstruction
import ComputationalMathematics.Source.LeVeque.Chapter04.REAAlgorithm
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearCharacteristicEvolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRectangleRiemannInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLipschitzTrace
import Mathlib.Algebra.Order.Floor.Ring
import Mathlib.Data.Real.Archimedean
import Mathlib.MeasureTheory.Function.Floor

/-!
# Uniform-grid piecewise-constant REA reconstruction

The ceiling index chooses the cell to the left at an interface. This
representative is needed when a characteristic has zero speed.
-/

namespace NumStability

open MeasureTheory

/-- Interfaces of an affine uniform grid. -/
def leveque04_uniformInterface (origin width : ℝ) (j : ℤ) : ℝ :=
  origin + (j : ℝ) * width

/-- The left-continuous piecewise-constant field attached to arbitrary
integer-indexed cell data. -/
noncomputable def leveque04_uniformReconstruction
    {E : Type*} (origin width : ℝ) (old : ℤ → E) (x : ℝ) : E :=
  old ⌈(x - origin) / width⌉

/-- On each open cell, the ceiling index recovers that cell's stored value. -/
theorem leveque04_uniformReconstruction_cell
    {E : Type*} (origin width : ℝ) (hwidth : 0 < width)
    (old : ℤ → E) (j : ℤ) (x : ℝ)
    (hx : x ∈ leveque04_cell (leveque04_uniformInterface origin width) j) :
    leveque04_uniformReconstruction origin width old x = old j := by
  have hleft : origin + ((j : ℝ) - 1) * width < x := by
    simpa only [leveque04_cell, Set.mem_Ioo, leveque04_uniformInterface,
      Int.cast_sub, Int.cast_one] using hx.1
  have hright : x < origin + (j : ℝ) * width := hx.2
  have hscaled : (j : ℝ) - 1 < (x - origin) / width ∧
      (x - origin) / width ≤ (j : ℝ) := by
    constructor
    · apply (lt_div_iff₀ hwidth).2
      nlinarith
    · apply (div_le_iff₀ hwidth).2
      nlinarith
  exact congrArg old (Int.ceil_eq_iff.mpr hscaled)

/-- The grid face takes the value from its left cell. -/
theorem leveque04_uniformReconstruction_face
    {E : Type*} (origin width : ℝ) (hwidth : 0 < width)
    (old : ℤ → E) (j : ℤ) :
    leveque04_uniformReconstruction origin width old
      (leveque04_uniformInterface origin width j) = old j := by
  have hwidth0 : width ≠ 0 := ne_of_gt hwidth
  simp [leveque04_uniformReconstruction, leveque04_uniformInterface,
    hwidth0, Int.ceil_intCast]

/-- The reconstruction has the prescribed average on every uniform cell. -/
theorem leveque04_uniformReconstruction_cellAverage
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    (origin width : ℝ) (hwidth : 0 < width)
    (old : ℤ → E) (j : ℤ) :
    oneDimensionalCellAverage
      (leveque04_uniformReconstruction origin width old)
      (leveque04_uniformInterface origin width (j - 1))
      (leveque04_uniformInterface origin width j) = old j := by
  let left := leveque04_uniformInterface origin width (j - 1)
  let right := leveque04_uniformInterface origin width j
  have hlt : left < right := by
    dsimp [left, right, leveque04_uniformInterface]
    push_cast
    nlinarith
  have hint : (∫ x in left..right,
      leveque04_uniformReconstruction origin width old x) =
      ∫ _x in left..right, old j := by
    apply intervalIntegral.integral_congr_ae
    filter_upwards [Measure.ae_ne volume right] with x hx hmem
    have hle : left < x ∧ x ≤ right := by
      simpa only [Set.uIoc_of_le hlt.le, Set.mem_Ioc] using hmem
    exact leveque04_uniformReconstruction_cell origin width hwidth old j x
      ⟨hle.1, lt_of_le_of_ne hle.2 hx⟩
  calc
    oneDimensionalCellAverage
        (leveque04_uniformReconstruction origin width old) left right =
        oneDimensionalCellAverage (fun _ : ℝ => old j) left right := by
          simp only [oneDimensionalCellAverage, hint]
    _ = old j := oneDimensionalCellAverage_const (old j) left right
      (ne_of_lt hlt)

/-- The affine interfaces determine an adjacent, positive-width grid. -/
def leveque04_uniformGrid (origin width : ℝ) (hwidth : 0 < width) :
    OneDimensionalFiniteVolumeGrid where
  cellLeft := fun j => leveque04_uniformInterface origin width (j - 1)
  cellRight := leveque04_uniformInterface origin width
  cell_nonempty := by
    intro j
    dsimp [leveque04_uniformInterface]
    push_cast
    nlinarith
  adjacent := by
    intro j
    rfl

/-- With the half-width origin, cell `j` is centered at `j * width`. -/
theorem leveque04_centeredUniformGrid_endpoints
    (width : ℝ) (hwidth : 0 < width) (j : ℤ) :
    (leveque04_uniformGrid (width / 2) width hwidth).cellLeft j =
        (j : ℝ) * width - width / 2 ∧
      (leveque04_uniformGrid (width / 2) width hwidth).cellRight j =
        (j : ℝ) * width + width / 2 := by
  constructor <;>
    dsimp [leveque04_uniformGrid, leveque04_uniformInterface] <;>
    push_cast <;>
    ring

/-- A uniform reconstruction is constant, hence polynomial, on each cell. -/
theorem leveque04_uniformReconstruction_piecewisePolynomial
    {m : ℕ} (origin width : ℝ) (hwidth : 0 < width)
    (old : ℤ → Fin m → ℝ) :
    ∀ i k, ∃ polynomial : Polynomial ℝ,
      ∀ x ∈ Set.Ioo
          ((leveque04_uniformGrid origin width hwidth).cellLeft i)
          ((leveque04_uniformGrid origin width hwidth).cellRight i),
        leveque04_uniformReconstruction origin width old x k =
          polynomial.eval x := by
  intro i k
  refine ⟨Polynomial.C (old i k), ?_⟩
  intro x hx
  have hcell : x ∈ leveque04_cell
      (leveque04_uniformInterface origin width) i := hx
  rw [leveque04_uniformReconstruction_cell origin width hwidth old i x hcell]
  simp

/-- Arbitrary integer-indexed cell data give locally integrable uniform
reconstructions: only finitely many cell indices occur in a bounded interval. -/
theorem leveque04_uniformReconstruction_intervalIntegrable
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [MeasurableSpace E] [BorelSpace E] [SecondCountableTopology E]
    (origin width : ℝ) (hwidth : 0 < width) (old : ℤ → E)
    (a b : ℝ) :
    IntervalIntegrable (leveque04_uniformReconstruction origin width old)
      volume a b := by
  let lower : ℤ := ⌈(min a b - origin) / width⌉
  let upper : ℤ := ⌈(max a b - origin) / width⌉
  let indices : Set ℤ := Set.Icc lower upper
  have hindex (x : ℝ) (hx : x ∈ Set.uIoc a b) :
      ⌈(x - origin) / width⌉ ∈ indices := by
    have hbetween : min a b ≤ x ∧ x ≤ max a b := by
      exact Set.uIoc_subset_uIcc hx
    constructor
    · apply Int.ceil_mono
      exact div_le_div_of_nonneg_right
        (sub_le_sub_right hbetween.1 origin) hwidth.le
    · apply Int.ceil_mono
      exact div_le_div_of_nonneg_right
        (sub_le_sub_right hbetween.2 origin) hwidth.le
  have hfinite : indices.Finite := Set.finite_Icc lower upper
  letI : Finite indices := hfinite.to_subtype
  obtain ⟨M, hM⟩ := Finite.exists_le (fun z : indices => ‖old z.1‖)
  have hmeas : Measurable (leveque04_uniformReconstruction origin width old) := by
    unfold leveque04_uniformReconstruction
    exact (measurable_of_countable old).comp
      ((measurable_id.sub_const origin).div_const width).ceil
  rw [intervalIntegrable_iff]
  have hmeasure : volume (Set.uIoc a b) ≠ ⊤ := by
    rcases le_total a b with hab | hba
    · rw [Set.uIoc_of_le hab]
      exact measure_Ioc_lt_top.ne
    · rw [Set.uIoc_of_ge hba]
      exact measure_Ioc_lt_top.ne
  apply Measure.integrableOn_of_bounded hmeasure
    hmeas.aestronglyMeasurable
  filter_upwards [ae_restrict_mem measurableSet_uIoc] with x hx
  exact hM ⟨⌈(x - origin) / width⌉, hindex x hx⟩

/-- The characteristic evolution of a uniform reconstruction is integrable
on every bounded spatial interval at each fixed time, even for arbitrary
integer-indexed old cell data. -/
theorem leveque04_linearUniformEvolution_intervalIntegrable
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (origin width : ℝ) (hwidth : 0 < width)
    (old : ℤ → Fin m → ℝ) (time a b : ℝ) :
    IntervalIntegrable
      (fun x => linearCharacteristicEvolution basis speeds
        (leveque04_uniformReconstruction origin width old) x time)
      volume a b := by
  classical
  simp only [linearCharacteristicEvolution]
  have hterm (p : Fin m) : IntervalIntegrable
      (fun x => basis.equivFun
        (leveque04_uniformReconstruction origin width old (x - speeds p * time)) p •
        basis p) volume a b := by
    have hmodal : IntervalIntegrable
        (fun x => basis.equivFun
          (leveque04_uniformReconstruction origin width old x) p)
        volume (a - speeds p * time) (b - speeds p * time) := by
      exact leveque04_uniformReconstruction_intervalIntegrable
        origin width hwidth (fun j => basis.equivFun (old j) p) _ _
    have hshift : IntervalIntegrable
        (fun x => basis.equivFun
          (leveque04_uniformReconstruction origin width old (x - speeds p * time)) p)
        volume a b := by
      simpa only [sub_add_cancel] using
        (hmodal.comp_sub_right (speeds p * time))
    exact hshift.smul_continuousOn continuousOn_const
  simpa only [Finset.sum_fn] using
    (IntervalIntegrable.sum Finset.univ (fun p _ => hterm p))

/-- Arbitrary cell arrays admit an actual exact linear REA stage on an
affine uniform grid. The characteristic evolution satisfies rectangle
conservation on every bounded space-time rectangle. -/
noncomputable def leveque04_linearUniformStage
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (origin width : ℝ) (hwidth : 0 < width)
    (old : ℤ → Fin m → ℝ) :
    Leveque04REAStage
      (linearHyperbolicConservationLaw coefficient hcoefficient)
      (leveque04_uniformGrid origin width hwidth) old
      (fun q => IsRectangleConservationLawSolution q coefficient.mulVec) where
  reconstructed := leveque04_uniformReconstruction origin width old
  piecewise_polynomial :=
    leveque04_uniformReconstruction_piecewisePolynomial origin width hwidth old
  old_averages := by
    intro i
    exact leveque04_uniformReconstruction_cellAverage origin width hwidth old i
  evolved := linearCharacteristicEvolution basis speeds
    (leveque04_uniformReconstruction origin width old)
  initial_trace := by
    intro x
    exact linearCharacteristicEvolution_initial basis speeds _ x
  evolution_valid := by
    apply linearCharacteristicEvolution_isRectangleSolution
      coefficient basis speeds heigen
    intro p a b
    exact leveque04_uniformReconstruction_intervalIntegrable
      origin width hwidth (fun i => basis.equivFun (old i) p) a b

end NumStability
