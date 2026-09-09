import Mathlib.Analysis.Calculus.ContDiff.Defs

theorem auditOverlayFixture (f : ℝ → ℝ) (s : Set ℝ)
    (h : ContDiffOn ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) f s) :
    ContDiffOn ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) f s := h
