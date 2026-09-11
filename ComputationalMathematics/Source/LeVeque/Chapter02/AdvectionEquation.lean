/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.AdvectionClassification
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation02
import ComputationalMathematics.Source.LeVeque.Chapter01.ScalarHyperbolicity

/-!
# LeVeque Chapter 2, printed page 17: the advection equation

Section 2.1 opens by specialising the conservation law just derived to the flux
`f(q) = ū q` of (2.5) and classifying what comes out.

Both rows here reuse Chapter 1 rather than restating it. The advection equation
itself is the Chapter 1 solution predicate, and the hyperbolicity of the
one-by-one coefficient matrix is the Chapter 1 scalar hyperbolicity
declaration; the Chapter 2 contribution is the derivation of that equation from
the conservation law and the evidence for the three remaining words of the
classification sentence.

The general classification mathematics lives in
`ComputationalMathematics.Analysis.PartialDifferentialEquations.AdvectionClassification`.
-/

namespace NumStability

/-- Equation (2.12): with the flux (2.5), the conservation law becomes the
advection equation.

The first conjunct is the printed step. It is stated as an equivalence because
"becomes" is a two-way claim: with the derivative families fixed, neither form
says more than the other, and a one-way implication would silently record the
specialisation as a weakening. The second writes the right-hand side in the
subscript notation of (2.11), which is the form the source actually prints:
`q_t + ū q_x = 0`. The third supplies, as one existential outside every binder, a
solution whose spatial derivative vanishes nowhere and which is therefore not
constant, so the equation is not satisfied only by densities that do not move. -/
theorem leveque02_equation12_advectionEquation
    {q qt qx : ℝ → ℝ → ℝ} {speed : ℝ}
    (hqt : ∀ x t, HasDerivAt (fun τ => q x τ) (qt x t) t)
    (hqx : ∀ x t, HasDerivAt (fun y => q y t) (qx x t) x) :
    (∀ x t,
        (deriv (fun τ => q x τ) t
            + deriv (fun y => uniformAdvectiveFlux speed (q y t) y t) x = 0)
          ↔ leveque01_equation02_scalarAdvectionAt q speed x t) ∧
      (∀ x t, leveque01_equation02_scalarAdvectionAt q speed x t ↔
          qt x t + speed * qx x t = 0) ∧
      (∃ r rt rx : ℝ → ℝ → ℝ,
        (∀ y s, HasDerivAt (fun τ => r y τ) (rt y s) s) ∧
          (∀ y s, HasDerivAt (fun ξ => r ξ s) (rx y s) y) ∧
          (∀ y s, leveque01_equation02_scalarAdvectionAt r speed y s) ∧
          (∀ y s, rx y s ≠ 0) ∧
          ¬ ∃ c : ℝ, ∀ y s, r y s = c) :=
  ⟨fun x t => by
     rw [(hqt x t).deriv]
     exact advectionEquation_iff_uniformFluxLaw hqt hqx x t,
   fun x t => advectionSolution_iff_residual hqt hqx x t,
   exists_isLinearAdvectionSolution_nonconstant speed⟩

/-- Equation (2.12) is a scalar, linear, constant-coefficient partial
differential equation of hyperbolic type.

The sentence names four properties, and each is a separate conjunct here rather
than a word in a comment. The first conjunct says which equation is being
classified, in the subscript form the source prints it in: once the two
derivative families are fixed, the solution predicate used throughout this
statement holds exactly when `q_t + ū q_x = 0`.

*Scalar* is the next: the equation is exactly the one-component case of the
constant-coefficient linear system of Chapter 1, with the one-by-one coefficient
matrix `[ū]`.

*Linear* is the next group: solutions at a point are closed under addition and
under scaling, and the class contains a solution whose spatial derivative
vanishes nowhere, so the closure is a statement about a subspace that is not
exhausted by the constants. A witness that is merely somewhere nonzero would be
satisfied by a nonzero constant, which solves the equation for every speed and
so certifies nothing.

*Constant-coefficient* is the third group, and it is the one that cannot be
carried by a name. The equation is the constant case of the general advection
equation with a coefficient that may vary in space and time; its solution set is
invariant under translation in space and in time; and the last witness shows that
invariance is a restriction and not a triviality, by exhibiting a
variable-coefficient advection equation whose solutions are *not* translation
invariant.

*Hyperbolic type* is the last, reused from Chapter 1. For one component this is
the weakest of the four claims: a one-by-one real matrix always has a real
eigenvalue and a corresponding basis, so the property holds of every scalar
constant-coefficient equation. That is also true of the printed sentence, which
asserts a classification rather than a discovery, and the row records the fact
at the strength the source has it.

"Partial differential equation" is not a fifth conjunct: it is carried by the
solution predicate itself, which constrains a derivative in `t` and a derivative
in `x` of the same two-variable function. -/
theorem leveque02_advection_isScalarLinearConstantCoefficientHyperbolic
    (speed : ℝ) :
    (∀ (q qt qx : ℝ → ℝ → ℝ) (x t : ℝ),
        (∀ y s, HasDerivAt (fun τ => q y τ) (qt y s) s) →
        (∀ y s, HasDerivAt (fun ξ => q ξ s) (qx y s) y) →
          (leveque01_equation02_scalarAdvectionAt q speed x t ↔
            qt x t + speed * qx x t = 0)) ∧
      (∀ (q : ℝ → ℝ → ℝ) (x t : ℝ),
        leveque01_equation01_constantLinearSystemAt
            (scalarAsOneComponentSystem q)
            (constantCoefficientScalarMatrix speed) x t
          ↔ leveque01_equation02_scalarAdvectionAt q speed x t) ∧
      ((∀ (q r : ℝ → ℝ → ℝ) (x t : ℝ),
          leveque01_equation02_scalarAdvectionAt q speed x t →
          leveque01_equation02_scalarAdvectionAt r speed x t →
            leveque01_equation02_scalarAdvectionAt
              (fun ξ τ => q ξ τ + r ξ τ) speed x t) ∧
        (∀ (q : ℝ → ℝ → ℝ) (c x t : ℝ),
          leveque01_equation02_scalarAdvectionAt q speed x t →
            leveque01_equation02_scalarAdvectionAt
              (fun ξ τ => c * q ξ τ) speed x t) ∧
        (∃ r rt rx : ℝ → ℝ → ℝ,
          (∀ y s, HasDerivAt (fun τ => r y τ) (rt y s) s) ∧
            (∀ y s, HasDerivAt (fun ξ => r ξ s) (rx y s) y) ∧
            (∀ y s, leveque01_equation02_scalarAdvectionAt r speed y s) ∧
            (∀ y s, rx y s ≠ 0) ∧
            ¬ ∃ c : ℝ, ∀ y s, r y s = c)) ∧
      ((∀ (q : ℝ → ℝ → ℝ) (x t : ℝ),
          leveque01_equation02_scalarAdvectionAt q speed x t ↔
            IsAdvectionSolutionWithCoefficientAt q (fun _ _ => speed) x t) ∧
        (∀ (q : ℝ → ℝ → ℝ) (x t a b : ℝ),
          leveque01_equation02_scalarAdvectionAt q speed (x + a) (t + b) →
            leveque01_equation02_scalarAdvectionAt
              (fun ξ τ => q (ξ + a) (τ + b)) speed x t) ∧
        (∃ (q : ℝ → ℝ → ℝ) (c : ℝ → ℝ → ℝ) (a : ℝ),
          IsAdvectionSolutionWithCoefficientAt q c 1 0 ∧
            ¬ IsAdvectionSolutionWithCoefficientAt
                (fun ξ τ => q (ξ + a) τ) c 0 0)) ∧
      leveque01IsHyperbolicMatrix (constantCoefficientScalarMatrix speed) := by
  refine ⟨fun _ _ _ x t hqt hqx => advectionSolution_iff_residual hqt hqx x t,
    fun q x t => leveque01_equation02_isOneDimensionalSpecialization q speed x t,
    ⟨fun _ _ _ _ hq hr => isLinearAdvectionSolutionAt_add hq hr,
      fun _ c _ _ hq => ?_,
      exists_isLinearAdvectionSolution_nonconstant speed⟩,
    ⟨fun q x t => isLinearAdvectionSolutionAt_iff_constantCoefficient q speed x t,
      fun _ _ _ _ _ h => isLinearAdvectionSolutionAt_translate h,
      variableCoefficient_not_translationInvariant⟩,
    leveque01_scalarEquation_isHyperbolic speed⟩
  simpa [smul_eq_mul] using isLinearAdvectionSolutionAt_smul c hq

end NumStability
