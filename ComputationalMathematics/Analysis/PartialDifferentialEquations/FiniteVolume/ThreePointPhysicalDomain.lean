/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CenteredStencilEvolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import Mathlib.Topology.Algebra.Order.Field
import Mathlib.Data.Int.Interval
import Mathlib.Tactic

/-!
# Physical support of three-point numerical evolution

Actual time-dependent, spatially varying updates cannot distinguish initial
fields agreeing on the complete physical input support. Exact cell averages
include the half-cell extensions; those extensions vanish at fixed mesh ratio.
-/

open Set Filter MeasureTheory
open scoped Topology
namespace NumStability

/-- Physical locations of integer offsets in a radius-`steps` grid window. -/
noncomputable def threePointPhysicalGridSites
    (X width : ℝ) (steps : ℕ) : Finset ℝ := by
  classical
  exact (Finset.Icc (-(steps : ℤ)) (steps : ℤ)).image
    (fun offset : ℤ => X + (offset : ℝ) * width)

/-- Closed physical envelope of a radius-`steps` grid window. -/
def threePointPhysicalGridEnvelope
    (X width : ℝ) (steps : ℕ) : Set ℝ :=
  Icc (X - (steps : ℝ) * width) (X + (steps : ℝ) * width)


theorem threePointEvolution_pointInitialization_eq
    {E : Type*} :
    ∀ (F : ℕ → ℤ → E → E → E → E)
    (left right : ℝ → E) (X T dt width ratio : ℝ) (steps : ℕ) (i : ℤ),
    0 < dt → 0 < width → ratio = dt/width → (steps : ℝ)*dt = T →
    EqOn left right (Icc (X-T/ratio) (X+T/ratio)) →
    centeredStencilEvolution (fun n u j => F n j (u (j-1)) (u j) (u (j+1)))
      (fun j => left (X+((j-i : ℤ) : ℝ)*width)) steps i =
    centeredStencilEvolution (fun n u j => F n j (u (j-1)) (u j) (u (j+1)))
      (fun j => right (X+((j-i : ℤ) : ℝ)*width)) steps i := by
  intro F left right X T dt width ratio steps i hdt hwidth hratio hT hagree
  have hscale : T/ratio = (steps : ℝ)*width := by
    rw [← hT, hratio]
    field_simp
  apply centeredStencilEvolution_locality
    (fun n u j => F n j (u (j-1)) (u j) (u (j+1))) 1
  · intro k a b j hlocal
    rw [hlocal (j-1) (by constructor <;> omega),
      hlocal j (by constructor <;> omega), hlocal (j+1) (by constructor <;> omega)]
  · intro j hj
    apply hagree
    simp only [Nat.cast_one,mul_one] at hj
    have hl : (i : ℝ)-(steps : ℝ) ≤ (j : ℝ) := by exact_mod_cast hj.1
    have hr : (j : ℝ) ≤ (i : ℝ)+(steps : ℝ) := by exact_mod_cast hj.2
    have hml := mul_le_mul_of_nonneg_right hl hwidth.le
    have hmr := mul_le_mul_of_nonneg_right hr hwidth.le
    simp only [mem_Icc,Int.cast_sub,hscale]
    constructor <;> nlinarith

theorem threePointEvolution_cellAverageInitialization_eq
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] :
    ∀ (F : ℕ → ℤ → E → E → E → E)
    (left right : ℝ → E) (X T dt width ratio : ℝ) (steps : ℕ) (i : ℤ),
    0 < dt → 0 < width → ratio = dt/width → (steps : ℝ)*dt = T →
    (∀ j ∈ Icc (i-(steps : ℤ)) (i+(steps : ℤ)),
      IntervalIntegrable left volume
        (X+((j-i : ℤ) : ℝ)*width-width/2) (X+((j-i : ℤ) : ℝ)*width+width/2)) →
    (∀ j ∈ Icc (i-(steps : ℤ)) (i+(steps : ℤ)),
      IntervalIntegrable right volume
        (X+((j-i : ℤ) : ℝ)*width-width/2) (X+((j-i : ℤ) : ℝ)*width+width/2)) →
    EqOn left right (Icc (X-T/ratio-width/2) (X+T/ratio+width/2)) →
    centeredStencilEvolution (fun n u j => F n j (u (j-1)) (u j) (u (j+1)))
      (fun j => oneDimensionalCellAverage left
        (X+((j-i : ℤ) : ℝ)*width-width/2) (X+((j-i : ℤ) : ℝ)*width+width/2)) steps i =
    centeredStencilEvolution (fun n u j => F n j (u (j-1)) (u j) (u (j+1)))
      (fun j => oneDimensionalCellAverage right
        (X+((j-i : ℤ) : ℝ)*width-width/2) (X+((j-i : ℤ) : ℝ)*width+width/2)) steps i := by
  intro F left right X T dt width ratio steps i hdt hwidth hratio hT _hintLeft _hintRight hagree
  have hscale : T/ratio = (steps : ℝ)*width := by
    rw [← hT,hratio]
    field_simp
  apply centeredStencilEvolution_locality
    (fun n u j => F n j (u (j-1)) (u j) (u (j+1))) 1
  · intro k a b j hlocal
    rw [hlocal (j-1) (by constructor <;> omega),
      hlocal j (by constructor <;> omega),hlocal (j+1) (by constructor <;> omega)]
  · intro j hj
    simp only [Nat.cast_one,mul_one] at hj
    have hl : (i : ℝ)-(steps : ℝ) ≤ (j : ℝ) := by exact_mod_cast hj.1
    have hr : (j : ℝ) ≤ (i : ℝ)+(steps : ℝ) := by exact_mod_cast hj.2
    have hml := mul_le_mul_of_nonneg_right hl hwidth.le
    have hmr := mul_le_mul_of_nonneg_right hr hwidth.le
    unfold oneDimensionalCellAverage
    congr 1
    apply intervalIntegral.integral_congr
    intro x hx
    rw [uIcc_of_le (by linarith :
      X+((j-i : ℤ) : ℝ)*width-width/2 ≤ X+((j-i : ℤ) : ℝ)*width+width/2)] at hx
    apply hagree
    simp only [mem_Icc,Int.cast_sub,hscale] at hx ⊢
    constructor <;> nlinarith [hx.1,hx.2]

theorem fixedRatioRefinement_cellSupport_endpoints_tendsto :
    ∀ (X T ratio : ℝ) (dt width : ℕ → ℝ) (steps : ℕ → ℕ),
    0 < ratio → (∀ k, 0 < width k) → (∀ k, dt k = ratio*width k) →
    (∀ k, (steps k : ℝ)*dt k = T) → Tendsto width atTop (nhds 0) →
    Tendsto (fun k => X-(steps k : ℝ)*width k-width k/2) atTop (nhds (X-T/ratio)) ∧
    Tendsto (fun k => X+(steps k : ℝ)*width k+width k/2) atTop (nhds (X+T/ratio)) := by
  intro X T ratio dt width steps hratio _hwidth hdt hT hw
  have hscale (k : ℕ) : (steps k : ℝ)*width k = T/ratio := by
    apply (eq_div_iff hratio.ne').mpr
    rw [← hT k,hdt k]
    ring
  constructor
  · simpa only [hscale,zero_div,sub_zero] using
      (tendsto_const_nhds (x := X-T/ratio)).sub (hw.div_const 2)
  · simpa only [hscale,zero_div,add_zero] using
      (tendsto_const_nhds (x := X+T/ratio)).add (hw.div_const 2)

end NumStability
