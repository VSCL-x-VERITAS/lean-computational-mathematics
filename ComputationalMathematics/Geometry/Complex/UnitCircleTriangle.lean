/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.Convex.Triangle.Coordinates
import Mathlib.Algebra.Ring.CharZero
import Mathlib.Analysis.Complex.Basic
import Mathlib.Data.Fin.VecNotation
import Mathlib.Geometry.Euclidean.Sphere.Basic
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum

/-!
# Completing unit-circle triangles

Arbitrary unit triples, including repeated vertices, extend to unit triangles
with nonzero signed area while preserving range inclusion.
-/

set_option autoImplicit false

namespace NumStability.ContractionAffineConstruction

noncomputable section

private theorem unit_ne_zero (u : ℂ) (hu : ‖u‖ = 1) : u ≠ 0 := by
  intro h
  simpa [h] using hu

private theorem unit_ne_neg (u : ℂ) (hu : ‖u‖ = 1) : u ≠ -u := by
  intro h
  exact unit_ne_zero u hu (CharZero.eq_neg_self_iff.mp h)

/-- A third unit point avoiding two prescribed distinct unit points. -/
theorem exists_unit_third (u v : ℂ) (hu : ‖u‖ = 1) (hv : ‖v‖ = 1)
    (huv : u ≠ v) : ∃ t : ℂ, ‖t‖ = 1 ∧ t ≠ u ∧ t ≠ v := by
  have hu0 := unit_ne_zero u hu
  by_cases hnegv : -u = v
  · refine ⟨Complex.I * u, by simp [norm_mul, hu], ?_, ?_⟩
    · intro h
      have hI : (Complex.I : ℂ) = 1 :=
        mul_right_cancel₀ hu0 (by simpa using h)
      have hfalse := congrArg Complex.im hI
      norm_num at hfalse
    · intro h
      have hI : (Complex.I : ℂ) = -1 :=
        mul_right_cancel₀ hu0 (by simpa [← hnegv] using h)
      have hfalse := congrArg Complex.im hI
      norm_num at hfalse
  · exact ⟨-u, by simpa using hu, (unit_ne_neg u hu).symm, hnegv⟩

private theorem triple_injective (u v t : ℂ)
    (huv : u ≠ v) (hut : u ≠ t) (hvt : v ≠ t) :
    Function.Injective (![u, v, t] : Fin 3 → ℂ) := by
  intro i j hij
  fin_cases i <;> fin_cases j <;> simp_all

/-- Complete a unit pair, including an equal pair, to three distinct unit points. -/
theorem unit_pair_completion (u v : ℂ) (hu : ‖u‖ = 1) (hv : ‖v‖ = 1) :
    ∃ w : Fin 3 → ℂ, (∀ j, ‖w j‖ = 1) ∧ Function.Injective w ∧
      u ∈ Set.range w ∧ v ∈ Set.range w := by
  by_cases huv : u = v
  · obtain ⟨t, ht, htu, htn⟩ :=
      exists_unit_third u (-u) hu (by simpa using hu) (unit_ne_neg u hu)
    refine ⟨![u, -u, t], ?_,
      triple_injective u (-u) t (unit_ne_neg u hu) htu.symm htn.symm,
      ⟨0, rfl⟩, ?_⟩
    · intro j
      fin_cases j <;> simp [hu, ht]
    · exact ⟨0, huv⟩
  · obtain ⟨t, ht, htu, htv⟩ := exists_unit_third u v hu hv huv
    refine ⟨![u, v, t], ?_,
      triple_injective u v t huv htu.symm htv.symm, ⟨0, rfl⟩, ⟨1, rfl⟩⟩
    intro j
    fin_cases j <;> simp [hu, hv, ht]

/-- Every original unit triple is contained in a distinct unit triple.
There is no distinctness or nondegeneracy assumption on the original triple. -/
theorem unit_triple_completion (z : Fin 3 → ℂ) (hz : ∀ j, ‖z j‖ = 1) :
    ∃ w : Fin 3 → ℂ, (∀ j, ‖w j‖ = 1) ∧ Function.Injective w ∧
      Set.range z ⊆ Set.range w := by
  by_cases h01 : z 0 = z 1
  · obtain ⟨w, hw, hwi, hw0, hw2⟩ :=
      unit_pair_completion (z 0) (z 2) (hz 0) (hz 2)
    refine ⟨w, hw, hwi, ?_⟩
    rintro _ ⟨j, rfl⟩
    fin_cases j
    · exact hw0
    · change z 1 ∈ Set.range w
      rw [← h01]
      exact hw0
    · exact hw2
  · by_cases h02 : z 0 = z 2
    · obtain ⟨w, hw, hwi, hw0, hw1⟩ :=
        unit_pair_completion (z 0) (z 1) (hz 0) (hz 1)
      refine ⟨w, hw, hwi, ?_⟩
      rintro _ ⟨j, rfl⟩
      fin_cases j
      · exact hw0
      · exact hw1
      · change z 2 ∈ Set.range w
        rw [← h02]
        exact hw0
    · by_cases h12 : z 1 = z 2
      · obtain ⟨w, hw, hwi, hw0, hw1⟩ :=
          unit_pair_completion (z 0) (z 1) (hz 0) (hz 1)
        refine ⟨w, hw, hwi, ?_⟩
        rintro _ ⟨j, rfl⟩
        fin_cases j
        · exact hw0
        · exact hw1
        · change z 2 ∈ Set.range w
          rw [← h12]
          exact hw1
      · refine ⟨z, hz, ?_, Set.Subset.rfl⟩
        intro i j hij
        fin_cases i <;> fin_cases j <;> simp_all

/-- A distinct unit triple is affinely independent over the reals. -/
theorem unit_triple_affineIndependent (w : Fin 3 → ℂ)
    (hw : ∀ j, ‖w j‖ = 1) (hwi : Function.Injective w) :
    AffineIndependent ℝ w := by
  have hc : EuclideanGeometry.Cospherical (Set.range w) := by
    refine ⟨0, 1, ?_⟩
    rintro _ ⟨j, rfl⟩
    simpa using hw j
  exact hc.affineIndependent Set.Subset.rfl hwi

/-- Zero determinant makes the third point lie on the line of two distinct points. -/
theorem third_eq_real_smul_of_signedArea_zero (u v t : ℂ) (huv : u ≠ v)
    (hD : signedArea u.re u.im v.re v.im t.re t.im = 0) :
    ∃ r : ℝ, t = r • (v - u) + u := by
  have hD' : (v.re - u.re) * (t.im - u.im) -
      (v.im - u.im) * (t.re - u.re) = 0 := by
    simpa only [signedArea_eq] using hD
  by_cases hx : v.re - u.re = 0
  · have hy : v.im - u.im ≠ 0 := by
      intro hy
      apply huv
      apply Complex.ext <;> linarith
    have htx : t.re = u.re := by
      have hprod : (v.im - u.im) * (t.re - u.re) = 0 := by
        rw [hx] at hD'
        linarith
      have := (mul_eq_zero.mp hprod).resolve_left hy
      linarith
    refine ⟨(t.im - u.im) / (v.im - u.im), ?_⟩
    apply Complex.ext
    · simp only [Complex.add_re, Complex.smul_re, Complex.sub_re, smul_eq_mul]
      rw [hx, mul_zero, zero_add, htx]
    · simp only [Complex.add_im, Complex.smul_im, Complex.sub_im, smul_eq_mul]
      rw [div_mul_cancel₀ _ hy]
      ring
  · refine ⟨(t.re - u.re) / (v.re - u.re), ?_⟩
    apply Complex.ext
    · simp only [Complex.add_re, Complex.smul_re, Complex.sub_re, smul_eq_mul]
      rw [div_mul_cancel₀ _ hx]
      ring
    · simp only [Complex.add_im, Complex.smul_im, Complex.sub_im, smul_eq_mul]
      apply mul_right_cancel₀ hx
      calc
        t.im * (v.re - u.re) =
            (t.re - u.re) * (v.im - u.im) + u.im * (v.re - u.re) := by
          nlinarith [hD']
        _ = ((t.re - u.re) / (v.re - u.re) * (v.im - u.im) + u.im) *
            (v.re - u.re) := by
          field_simp [hx]
          <;> ring

/-- A distinct unit triple has nonzero signed area, with either orientation allowed. -/
theorem unit_triple_signedArea_ne_zero (w : Fin 3 → ℂ)
    (hw : ∀ j, ‖w j‖ = 1) (hwi : Function.Injective w) :
    signedArea (w 0).re (w 0).im (w 1).re (w 1).im (w 2).re (w 2).im ≠ 0 := by
  intro hD
  have huv : w 0 ≠ w 1 := fun h => (by decide : (0 : Fin 3) ≠ 1) (hwi h)
  obtain ⟨r, hr⟩ := third_eq_real_smul_of_signedArea_zero (w 0) (w 1) (w 2) huv hD
  have hc : Collinear ℝ (Set.range w) := by
    rw [collinear_iff_of_mem (Set.mem_range_self (0 : Fin 3))]
    refine ⟨w 1 - w 0, ?_⟩
    rintro _ ⟨j, rfl⟩
    fin_cases j
    · exact ⟨0, by simp⟩
    · exact ⟨1, by simp⟩
    · exact ⟨r, hr⟩
  exact (affineIndependent_iff_not_collinear.mp
    (unit_triple_affineIndependent w hw hwi)) hc

/-- A unit triple, including every repeated or collinear case, is contained
in a unit triangle with nonzero signed area. -/
theorem unit_triple_nondegenerate_completion (z : Fin 3 → ℂ)
    (hz : ∀ j, ‖z j‖ = 1) :
    ∃ w : Fin 3 → ℂ, (∀ j, ‖w j‖ = 1) ∧ Function.Injective w ∧
      Set.range z ⊆ Set.range w ∧
      signedArea (w 0).re (w 0).im (w 1).re (w 1).im (w 2).re (w 2).im ≠ 0 := by
  obtain ⟨w, hw, hwi, hzw⟩ := unit_triple_completion z hz
  exact ⟨w, hw, hwi, hzw, unit_triple_signedArea_ne_zero w hw hwi⟩

end
end NumStability.ContractionAffineConstruction
