import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearSystems.EigenbasisCoordinates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.UniformAdvection
import Mathlib.Analysis.Calculus.Deriv.Prod
import Mathlib.Analysis.Calculus.MeanValue

/-! Scratch source-independent characteristic converse with explicit joint differentiability. -/

namespace NumStability

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

theorem linearAdvection_hasDerivAt_characteristic
    {q : ℝ → ℝ → E} {speed x t : ℝ}
    (hq : DifferentiableAt ℝ (Function.uncurry q) (x + speed * t, t))
    (hpde : IsLinearAdvectionSolutionAt q speed (x + speed * t) t) :
    HasDerivAt (fun τ => q (x + speed * τ) τ) 0 t := by
  let F := fderiv ℝ (Function.uncurry q) (x + speed * t, t)
  have hF : HasFDerivAt (Function.uncurry q) F (x + speed * t, t) := hq.hasFDerivAt
  rcases hpde with ⟨qt, qx, ht, hx, hzero⟩
  have hx' : HasDerivAt (fun ξ => q ξ t) (F (1, 0)) (x + speed * t) := by
    simpa only [Function.comp_def, Function.uncurry_apply_pair] using
      hF.comp_hasDerivAt (x + speed * t)
        ((hasDerivAt_id (x + speed * t)).prodMk (hasDerivAt_const _ t))
  have ht' : HasDerivAt (fun τ => q (x + speed * t) τ) (F (0, 1)) t := by
    simpa only [Function.comp_def, Function.uncurry_apply_pair] using
      hF.comp_hasDerivAt t
        ((hasDerivAt_const t (x + speed * t)).prodMk (hasDerivAt_id t))
  have hpair : (speed, (1 : ℝ)) = speed • ((1 : ℝ), 0) + (0, 1) := by
    ext <;> simp
  have hvalue : F (speed, 1) = 0 := by
    rw [hpair, map_add, map_smul, hx'.unique hx, ht'.unique ht]
    simpa only [add_comm] using hzero
  have hcurve : HasDerivAt (fun τ : ℝ => (x + speed * τ, τ)) (speed, 1) t := by
    convert ((hasDerivAt_const t x).add ((hasDerivAt_id t).const_mul speed)).prodMk
      (hasDerivAt_id t) using 1 <;> simp
  simpa only [Function.comp_def, Function.uncurry_apply_pair, hvalue] using
    hF.comp_hasDerivAt (f := fun τ : ℝ => (x + speed * τ, τ)) t hcurve

theorem linearAdvection_eq_travelingWave_of_differentiable
    {q : ℝ → ℝ → E} {speed : ℝ}
    (hq : Differentiable ℝ (Function.uncurry q))
    (hpde : IsLinearAdvectionSolution q speed) :
    q = travelingWave (fun x => q x 0) speed := by
  have hchar (x t : ℝ) : q (x + speed * t) t = q x 0 := by
    have hd (τ : ℝ) : HasDerivAt (fun r => q (x + speed * r) r) 0 τ :=
      linearAdvection_hasDerivAt_characteristic (hq _) (hpde _ _)
    simpa using is_const_of_deriv_eq_zero (fun τ => (hd τ).differentiableAt)
      (fun τ => (hd τ).deriv) t 0
  funext x t
  simpa [travelingWave] using hchar (x - speed * t) t


theorem constantCoefficientSystem_characteristicPropagation {m : ℕ}
    (A : Matrix (Fin m) (Fin m) ℝ) (b : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (heigen : ∀ i, A.mulVec (b i) = speeds i • b i)
    (q : ℝ → ℝ → (Fin m → ℝ))
    (hq : Differentiable ℝ (Function.uncurry q))
    (hpde : ∀ x t, IsConstantCoefficientLinearSystemSolutionAt q A x t) :
    (∀ i x t, b.equivFun (q x t) i =
      b.equivFun (q (x - speeds i * t) 0) i) ∧
    ∀ x t, q x t =
      ∑ i, (b.equivFun (q (x - speeds i * t) 0) i) • b i := by
  have hcoordinates (i : Fin m) (x t : ℝ) :
      b.equivFun (q x t) i = b.equivFun (q (x - speeds i * t) 0) i := by
    let L : (Fin m → ℝ) →L[ℝ] ℝ :=
      (ContinuousLinearMap.proj (R := ℝ) i).comp
        b.equivFun.toContinuousLinearEquiv.toContinuousLinearMap
    have hcoord : Differentiable ℝ
        (Function.uncurry (fun ξ τ => b.equivFun (q ξ τ) i)) := by
      exact L.differentiable.comp hq
    have heq := linearAdvection_eq_travelingWave_of_differentiable hcoord
      (fun ξ τ => (constantCoefficientSystem_iff_eigenbasisAdvection
        A b speeds heigen q ξ τ).mp (hpde ξ τ) i)
    exact congrFun (congrFun heq x) t
  refine ⟨hcoordinates, ?_⟩
  intro x t
  rw [← b.sum_equivFun (q x t)]
  apply Finset.sum_congr rfl
  intro i _
  rw [hcoordinates i x t]

theorem leveque01_eigenvalues_completeWavePropagation {m : ℕ}
    (A : Matrix (Fin m) (Fin m) ℝ) (hA : IsRealHyperbolicMatrix A) :
    ∃ (speeds : Fin m → ℝ) (b : Module.Basis (Fin m) ℝ (Fin m → ℝ)),
      (∀ i, b i ≠ 0 ∧ A.mulVec (b i) = speeds i • b i) ∧
      (∀ (q : ℝ → ℝ → (Fin m → ℝ)) (x t : ℝ),
        IsConstantCoefficientLinearSystemSolutionAt q A x t ↔
          ∀ i, IsLinearAdvectionSolutionAt
            (fun ξ τ => b.equivFun (q ξ τ) i) (speeds i) x t) ∧
      ∀ (q : ℝ → ℝ → (Fin m → ℝ)),
        Differentiable ℝ (Function.uncurry q) →
        (∀ x t, IsConstantCoefficientLinearSystemSolutionAt q A x t) →
        (∀ i x t, b.equivFun (q x t) i =
          b.equivFun (q (x - speeds i * t) 0) i) ∧
        ∀ x t, q x t =
          ∑ i, (b.equivFun (q (x - speeds i * t) 0) i) • b i := by
  obtain ⟨speeds, b, heigen⟩ := hA
  refine ⟨speeds, b, fun i => ⟨b.ne_zero i, heigen i⟩,
    constantCoefficientSystem_iff_eigenbasisAdvection A b speeds heigen, ?_⟩
  exact constantCoefficientSystem_characteristicPropagation A b speeds heigen


end NumStability

#check NumStability.linearAdvection_hasDerivAt_characteristic
#print axioms NumStability.linearAdvection_hasDerivAt_characteristic

#check NumStability.linearAdvection_eq_travelingWave_of_differentiable
#print axioms NumStability.linearAdvection_eq_travelingWave_of_differentiable

#check NumStability.constantCoefficientSystem_characteristicPropagation
#print axioms NumStability.constantCoefficientSystem_characteristicPropagation

#check NumStability.leveque01_eigenvalues_completeWavePropagation
#print axioms NumStability.leveque01_eigenvalues_completeWavePropagation
