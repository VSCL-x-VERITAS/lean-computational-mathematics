import Mathlib.Analysis.Asymptotics.Theta

/-!
# Constant-factor asymptotic comparisons

Reusable names for the two-sided and one-sided constant-factor comparisons
used throughout high-dimensional probability.  The primary definitions use
Mathlib's eventual, norm-based relations at `Filter.atTop`.  The explicit
`...Everywhere` predicates record the stronger all-index reading that authors
sometimes use when introducing the notation; on nonnegative functions it
implies the corresponding eventual relation.
-/

noncomputable section

open Filter
open scoped Asymptotics

namespace NumStability.HDP.Scalar.AsymptoticComparisons

/-- `f` and `g` agree up to constant factors eventually at infinity. -/
abbrev IsComparableAtTop (f g : ℕ → ℝ) : Prop :=
  Asymptotics.IsTheta atTop f g

/-- `f` is eventually bounded above by a constant multiple of `g`. -/
abbrev IsLessSimAtTop (f g : ℕ → ℝ) : Prop :=
  Asymptotics.IsBigO atTop f g

/-- `f` is eventually bounded below by a constant multiple of `g`. -/
abbrev IsGreaterSimAtTop (f g : ℕ → ℝ) : Prop :=
  Asymptotics.IsBigO atTop g f

/-- Strong all-index reading of two-sided positive constant-factor comparison. -/
def IsComparableEverywhere (f g : ℕ → ℝ) : Prop :=
  ∃ c C : ℝ, 0 < c ∧ 0 < C ∧ ∀ n, c * f n ≤ g n ∧ g n ≤ C * f n

/-- Strong all-index reading of an upper constant-factor comparison. -/
def IsLessSimEverywhere (f g : ℕ → ℝ) : Prop :=
  ∃ C : ℝ, 0 < C ∧ ∀ n, f n ≤ C * g n

/-- Strong all-index reading of a lower constant-factor comparison. -/
def IsGreaterSimEverywhere (f g : ℕ → ℝ) : Prop :=
  IsLessSimEverywhere g f

/-- Ordered two-sided comparison for all sufficiently large indices.  This is
the literal eventual reading of the source's positive-constant inequalities. -/
def IsComparableEventually (f g : ℕ → ℝ) : Prop :=
  ∃ c C : ℝ, 0 < c ∧ 0 < C ∧
    ∀ᶠ n in Filter.atTop, c * f n ≤ g n ∧ g n ≤ C * f n

/-- Ordered upper comparison for all sufficiently large indices. -/
def IsLessSimEventually (f g : ℕ → ℝ) : Prop :=
  ∃ C : ℝ, 0 < C ∧ ∀ᶠ n in Filter.atTop, f n ≤ C * g n

/-- Ordered lower comparison for all sufficiently large indices. -/
def IsGreaterSimEventually (f g : ℕ → ℝ) : Prop :=
  IsLessSimEventually g f

/-- An all-index two-sided comparison also holds eventually with the same
positive constants. -/
theorem isComparableEventually_of_everywhere {f g : ℕ → ℝ}
    (h : IsComparableEverywhere f g) :
    IsComparableEventually f g := by
  obtain ⟨c, C, hc, hC, hbounds⟩ := h
  exact ⟨c, C, hc, hC, Filter.Eventually.of_forall hbounds⟩

/-- An all-index upper comparison also holds eventually. -/
theorem isLessSimEventually_of_everywhere {f g : ℕ → ℝ}
    (h : IsLessSimEverywhere f g) :
    IsLessSimEventually f g := by
  obtain ⟨C, hC, hbounds⟩ := h
  exact ⟨C, hC, Filter.Eventually.of_forall hbounds⟩

/-- An all-index lower comparison also holds eventually. -/
theorem isGreaterSimEventually_of_everywhere {f g : ℕ → ℝ}
    (h : IsGreaterSimEverywhere f g) :
    IsGreaterSimEventually f g :=
  isLessSimEventually_of_everywhere h

/-- For nonnegative quantities, the all-index upper comparison implies the
usual eventual `IsBigO` comparison at infinity. -/
theorem isLessSimAtTop_of_everywhere {f g : ℕ → ℝ}
    (hf : ∀ n, 0 ≤ f n) (hg : ∀ n, 0 ≤ g n)
    (h : IsLessSimEverywhere f g) :
    IsLessSimAtTop f g := by
  obtain ⟨C, _hC, hC⟩ := h
  refine Asymptotics.IsBigO.of_bound C (Filter.Eventually.of_forall fun n => ?_)
  simpa [Real.norm_eq_abs, abs_of_nonneg (hf n), abs_of_nonneg (hg n)] using hC n

/-- For nonnegative quantities, the all-index lower comparison implies the
corresponding eventual lower comparison at infinity. -/
theorem isGreaterSimAtTop_of_everywhere {f g : ℕ → ℝ}
    (hf : ∀ n, 0 ≤ f n) (hg : ∀ n, 0 ≤ g n)
    (h : IsGreaterSimEverywhere f g) :
    IsGreaterSimAtTop f g :=
  isLessSimAtTop_of_everywhere hg hf h

/-- For nonnegative quantities, a two-sided all-index comparison implies
Mathlib's eventual `IsTheta` relation at infinity. -/
theorem isComparableAtTop_of_everywhere {f g : ℕ → ℝ}
    (hf : ∀ n, 0 ≤ f n) (hg : ∀ n, 0 ≤ g n)
    (h : IsComparableEverywhere f g) :
    IsComparableAtTop f g := by
  obtain ⟨c, C, hc, hC, hbounds⟩ := h
  constructor
  · refine Asymptotics.IsBigO.of_bound c⁻¹ (Filter.Eventually.of_forall fun n => ?_)
    have hc0 : c ≠ 0 := ne_of_gt hc
    simp only [Real.norm_eq_abs, abs_of_nonneg (hg n), abs_of_nonneg (hf n)]
    have hn := mul_le_mul_of_nonneg_left (hbounds n).1 (le_of_lt (inv_pos.mpr hc))
    simpa [mul_assoc, hc0] using hn
  · exact isLessSimAtTop_of_everywhere hg hf ⟨C, hC, fun n => (hbounds n).2⟩

end NumStability.HDP.Scalar.AsymptoticComparisons
