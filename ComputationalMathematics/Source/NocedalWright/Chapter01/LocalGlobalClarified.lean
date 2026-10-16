import ComputationalMathematics.Optimization.Convex.Euclidean

/-!
# Clarified local-to-global convexity

This companion states an explicit objective domain and requires the feasible set
to lie inside it. The book's Chapter 1 sentence leaves that relationship implicit;
this theorem does not claim an accepted exact translation of that sentence.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- A feasible local minimizer is global when the objective is convex on a domain
containing the convex feasible set. -/
theorem localGlobalOfConvexObjectiveOnDomain
    {n : ℕ} {D s : Set (Fin n → ℝ)} {f : (Fin n → ℝ) → ℝ}
    {x : Fin n → ℝ}
    (hobj : ConvexOn ℝ D f) (hfeas : Convex ℝ s) (hsubset : s ⊆ D)
    (hx : x ∈ s) (hloc : IsLocalMinOn f s x) :
    ∀ y ∈ s, f x ≤ f y := by
  have hobjOnFeasible : ConvexOn ℝ s f := hobj.subset hsubset hfeas
  exact IsMinOn.of_isLocalMinOn_of_convexOn hx hloc hobjOnFeasible


end ComputationalMathematics.Source.NocedalWright.Chapter01
