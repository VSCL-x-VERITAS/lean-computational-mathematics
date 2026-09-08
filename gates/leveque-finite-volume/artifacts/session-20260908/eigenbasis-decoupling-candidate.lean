import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection
import Mathlib.Analysis.Calculus.FDeriv.Linear
import Mathlib.Analysis.Normed.Module.FiniteDimension

namespace NumStability.Chapter01Scratch

theorem eigenbasis_coordinates_mulVec {m : ℕ}
    (A : Matrix (Fin m) (Fin m) ℝ) (b : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (heigen : ∀ i, A.mulVec (b i) = speeds i • b i)
    (v : Fin m → ℝ) :
    b.equivFun (A.mulVec v) = fun i => speeds i * b.equivFun v i := by
  apply b.equivFun.symm.injective
  rw [b.equivFun.symm_apply_apply, b.equivFun_symm_apply]
  conv_lhs => rw [← b.sum_equivFun v]
  rw [Matrix.mulVec_sum]
  apply Finset.sum_congr rfl
  intro i _
  rw [Matrix.mulVec_smul, heigen i, smul_smul, mul_comm]

theorem constantCoefficientSystem_iff_eigenbasisAdvection {m : ℕ}
    (A : Matrix (Fin m) (Fin m) ℝ) (b : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (heigen : ∀ i, A.mulVec (b i) = speeds i • b i)
    (q : ℝ → ℝ → (Fin m → ℝ)) (x t : ℝ) :
    IsConstantCoefficientLinearSystemSolutionAt q A x t ↔
      ∀ i, IsLinearAdvectionSolutionAt
        (fun ξ τ => b.equivFun (q ξ τ) i) (speeds i) x t := by
  let coordinates := b.equivFun.toContinuousLinearEquiv
  constructor
  · rintro ⟨qt, qx, ht, hx, hzero⟩ i
    have ht' := coordinates.toContinuousLinearMap.hasFDerivAt.comp_hasDerivAt t ht
    have hx' := coordinates.toContinuousLinearMap.hasFDerivAt.comp_hasDerivAt x hx
    refine ⟨coordinates qt i, coordinates qx i, ?_, ?_, ?_⟩
    · exact hasDerivAt_pi.mp ht' i
    · exact hasDerivAt_pi.mp hx' i
    · have h := congrArg (fun v => b.equivFun v i) hzero
      simpa only [map_add, eigenbasis_coordinates_mulVec A b speeds heigen,
        Pi.add_apply, map_zero, Pi.zero_apply, smul_eq_mul] using h
  · intro h
    choose wt wx ht hx hzero using h
    have ht' : HasDerivAt (fun τ => coordinates (q x τ)) wt t := hasDerivAt_pi.mpr ht
    have hx' : HasDerivAt (fun ξ => coordinates (q ξ t)) wx x := hasDerivAt_pi.mpr hx
    have ht'' := coordinates.symm.toContinuousLinearMap.hasFDerivAt.comp_hasDerivAt t ht'
    have hx'' := coordinates.symm.toContinuousLinearMap.hasFDerivAt.comp_hasDerivAt x hx'
    refine ⟨coordinates.symm wt, coordinates.symm wx, ?_, ?_, ?_⟩
    · change HasDerivAt (fun τ => coordinates.symm (coordinates (q x τ)))
        (coordinates.symm wt) t at ht''
      simpa only [ContinuousLinearEquiv.symm_apply_apply] using ht''
    · change HasDerivAt (fun ξ => coordinates.symm (coordinates (q ξ t)))
        (coordinates.symm wx) x at hx''
      simpa only [ContinuousLinearEquiv.symm_apply_apply] using hx''
    · apply coordinates.injective
      rw [map_add, map_zero]
      funext i
      change b.equivFun (coordinates.symm wt) i +
        b.equivFun (A.mulVec (coordinates.symm wx)) i = 0
      rw [eigenbasis_coordinates_mulVec A b speeds heigen]
      change coordinates (coordinates.symm wt) i + speeds i *
        coordinates (coordinates.symm wx) i = 0
      simpa only [ContinuousLinearEquiv.apply_symm_apply, smul_eq_mul] using hzero i

/-- Candidate for the general scalar-equation decomposition on printed page 3.
One eigenbasis is fixed for all fields and all points; the equivalence includes
the reverse reconstruction of a system solution from its scalar equations. -/
theorem leveque01_hyperbolicSystem_scalarWaveDecomposition {m : ℕ}
    (A : Matrix (Fin m) (Fin m) ℝ) (hA : IsRealHyperbolicMatrix A) :
    ∃ (speeds : Fin m → ℝ) (b : Module.Basis (Fin m) ℝ (Fin m → ℝ)),
      (∀ i, A.mulVec (b i) = speeds i • b i) ∧
      ∀ (q : ℝ → ℝ → (Fin m → ℝ)) (x t : ℝ),
        IsConstantCoefficientLinearSystemSolutionAt q A x t ↔
          ∀ i, IsLinearAdvectionSolutionAt
            (fun ξ τ => b.equivFun (q ξ τ) i) (speeds i) x t := by
  rcases hA with ⟨speeds, b, heigen⟩
  exact ⟨speeds, b, heigen, constantCoefficientSystem_iff_eigenbasisAdvection A b speeds heigen⟩

#print axioms eigenbasis_coordinates_mulVec
#print axioms constantCoefficientSystem_iff_eigenbasisAdvection
#print axioms leveque01_hyperbolicSystem_scalarWaveDecomposition

end NumStability.Chapter01Scratch
