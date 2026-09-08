import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface
import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.LinearAlgebra.Matrix.ToLin

namespace NumStability.Chapter01Scratch

/-- Pointwise hyperbolicity of a differentiable flux, using the matrix of its
actual Fréchet derivative in the standard component coordinates. -/
def IsHyperbolicFluxAt {m : ℕ}
    (flux : (Fin m → ℝ) → (Fin m → ℝ)) (state : Fin m → ℝ) : Prop :=
  ∃ derivative : (Fin m → ℝ) →L[ℝ] (Fin m → ℝ),
    HasFDerivAt flux derivative state ∧
      IsRealHyperbolicMatrix (LinearMap.toMatrix' derivative.toLinearMap)

/-- For an independently supplied actual flux derivative, the pointwise
criterion is exactly a complete independent real eigenvector family. No
distinctness of eigenvalues or well-posedness conclusion is asserted. -/
theorem isHyperbolicFluxAt_iff_independent_real_eigenvectors {m : ℕ}
    (flux : (Fin m → ℝ) → (Fin m → ℝ)) (state : Fin m → ℝ)
    (derivative : (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (hderivative : HasFDerivAt flux derivative state) :
    IsHyperbolicFluxAt flux state ↔
      ∃ (eigenvalues : Fin m → ℝ) (eigenvectors : Fin m → (Fin m → ℝ)),
        LinearIndependent ℝ eigenvectors ∧
          ∀ p, derivative (eigenvectors p) = eigenvalues p • eigenvectors p := by
  have hmatrix : IsHyperbolicFluxAt flux state ↔
      IsRealHyperbolicMatrix (LinearMap.toMatrix' derivative.toLinearMap) := by
    constructor
    · rintro ⟨D, hD, hhyperbolic⟩
      simpa only [hD.unique hderivative] using hhyperbolic
    · intro h
      exact ⟨derivative, hderivative, h⟩
  rw [hmatrix, isRealHyperbolicMatrix_iff_independent_real_eigenvectors]
  simp only [LinearMap.toMatrix'_mulVec, ContinuousLinearMap.coe_coe]

/-- The same criterion can be required on an explicitly supplied state domain;
it is a pointwise classification at each admissible state. -/
def IsHyperbolicFluxOn {m : ℕ}
    (flux : (Fin m → ℝ) → (Fin m → ℝ)) (states : Set (Fin m → ℝ)) : Prop :=
  ∀ state ∈ states, IsHyperbolicFluxAt flux state

theorem isHyperbolicFluxOn_iff_independent_real_eigenvectors {m : ℕ}
    (flux : (Fin m → ℝ) → (Fin m → ℝ)) (states : Set (Fin m → ℝ))
    (derivative : (Fin m → ℝ) → ((Fin m → ℝ) →L[ℝ] (Fin m → ℝ)))
    (hderivative : ∀ state ∈ states, HasFDerivAt flux (derivative state) state) :
    IsHyperbolicFluxOn flux states ↔
      ∀ state ∈ states,
        ∃ (eigenvalues : Fin m → ℝ) (eigenvectors : Fin m → (Fin m → ℝ)),
          LinearIndependent ℝ eigenvectors ∧
            ∀ p, derivative state (eigenvectors p) = eigenvalues p • eigenvectors p := by
  unfold IsHyperbolicFluxOn
  exact forall_congr' fun state => forall_congr' fun hstate =>
    isHyperbolicFluxAt_iff_independent_real_eigenvectors flux state (derivative state)
      (hderivative state hstate)

/-- The existing global hyperbolic-law structure supplies this local criterion;
its genuine flux derivative and matrix representation are reused unchanged. -/
theorem hyperbolicConservationLaw_isHyperbolicFluxAt {m : ℕ}
    (law : OneDimensionalHyperbolicConservationLaw (Fin m)) (state : Fin m → ℝ) :
    IsHyperbolicFluxAt law.physicalFlux state := by
  refine ⟨law.fluxDerivative state, law.hasFDerivAt_physicalFlux state, ?_⟩
  have hmatrix : LinearMap.toMatrix' (law.fluxDerivative state).toLinearMap =
      law.fluxJacobian state := by
    apply Matrix.ext_iff_mulVec.mpr
    intro direction
    simpa only [LinearMap.toMatrix'_mulVec, ContinuousLinearMap.coe_coe] using
      law.fluxDerivative_eq_jacobian_mulVec state direction
  rw [hmatrix]
  exact law.jacobian_hyperbolic state

#print axioms hyperbolicConservationLaw_isHyperbolicFluxAt
#print axioms isHyperbolicFluxAt_iff_independent_real_eigenvectors
#print axioms isHyperbolicFluxOn_iff_independent_real_eigenvectors

end NumStability.Chapter01Scratch
