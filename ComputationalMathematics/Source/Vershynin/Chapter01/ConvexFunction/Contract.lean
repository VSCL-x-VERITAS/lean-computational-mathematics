import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-! Stable source-facing contract for the convex-function definition in
Section 1.2, footnote 3. -/

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.Preliminaries

/-- Original sublevel-set consequence exported for the convex-function row. -/
theorem hdp_01_hdef_hconvex_hfunction
    {φ : ℝ → ℝ} (hφ : convexFunctionInterface φ) (r : ℝ) :
    Convex ℝ {x : ℝ | x ∈ (Set.univ : Set ℝ) ∧ φ x ≤ r} :=
  convexFunction_sublevel_convex hφ r

/-- A real function is convex exactly when it satisfies the book's displayed
two-point inequality for every interpolation parameter in `[0,1]`. -/
theorem hdp_01_hdef_hconvex_hfunction_spec (φ : ℝ → ℝ) :
    convexFunctionInterface φ ↔
      ∀ (t : ℝ), 0 ≤ t → t ≤ 1 → ∀ x y : ℝ,
        φ (t * x + (1 - t) * y) ≤
          t * φ x + (1 - t) * φ y := by
  constructor
  · rintro ⟨_, hφ⟩ t ht0 ht1 x y
    simpa [smul_eq_mul] using
      hφ (Set.mem_univ x) (Set.mem_univ y) ht0
        (sub_nonneg.mpr ht1) (by ring)
  · intro h
    refine ⟨convex_univ, ?_⟩
    intro x _ y _ a b ha hb hab
    have hb_eq : b = 1 - a := by linarith
    subst b
    simpa [smul_eq_mul] using h a ha (by linarith) x y

end NumStability.HDP.Contract
