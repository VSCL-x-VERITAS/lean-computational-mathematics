import ComputationalMathematics.Source.LeVeque.Chapter01.IntegralToDifferential
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.StationaryJump

/-!
Native evidence for the accepted regularity strengthening. The source theorem
is unchanged. This additional stationary jump instance checks every one of its
analytic premises while the state is spatially discontinuous. The independent
adjudicator also supplied a nonstationary two-component example with nonzero
derivative terms; this evidence does not replace that source-applicability audit.
-/

open MeasureTheory

namespace NumStability.Chapter01Evidence

noncomputable def jumpProfile : ℝ → Fin 1 → ℝ :=
  riemannData 0 0 1

theorem smoothBridge_additionalInstance :
    ∃ (q : ℝ → ℝ → Fin 1 → ℝ)
      (flux : (Fin 1 → ℝ) → Fin 1 → ℝ)
      (qt fluxx : ℝ → Fin 1 → ℝ) (t : ℝ),
      0 < t ∧
      leveque01Equation10IntegralConservation q flux ∧
      (∀ x, HasDerivAt (fun τ => q x τ) (qt x) t) ∧
      (∀ x, HasDerivAt (fun ξ => flux (q ξ t)) (fluxx x) x) ∧
      (∀ a b, IntervalIntegrable qt volume a b) ∧
      (∀ a b, IntervalIntegrable fluxx volume a b) ∧
      (∀ a b, HasDerivAt (fun τ => ∫ x in a..b, q x τ)
        (∫ x in a..b, qt x) t) ∧
      Continuous (fun x => qt x + fluxx x) ∧
      (¬ ContinuousAt (fun x => q x t) 0) ∧
      (∀ x, leveque01_equation08_conservationLawAt q flux x t) := by
  let q : ℝ → ℝ → Fin 1 → ℝ := fun x _ => jumpProfile x
  let flux : (Fin 1 → ℝ) → Fin 1 → ℝ := fun _ => 0
  have hne : (0 : Fin 1 → ℝ) ≠ 1 := by
    intro h
    exact zero_ne_one (congrFun h 0)
  have hi : leveque01Equation10IntegralConservation q flux := by
    intro a b t
    refine ⟨riemannData_intervalIntegrable 0 0 1 a b, ?_⟩
    simpa [q, flux] using hasDerivAt_const t (∫ x in a..b, jumpProfile x)
  have hqt : ∀ x, HasDerivAt (fun τ => q x τ) (0 : Fin 1 → ℝ) 1 :=
    fun x => hasDerivAt_const 1 (jumpProfile x)
  have hfx : ∀ x, HasDerivAt (fun ξ => flux (q ξ 1)) (0 : Fin 1 → ℝ) x :=
    fun x => hasDerivAt_const x 0
  have hzero : ∀ a b, IntervalIntegrable (fun _ : ℝ => (0 : Fin 1 → ℝ)) volume a b :=
    fun _ _ => intervalIntegrable_const
  have hswap : ∀ a b, HasDerivAt (fun τ => ∫ x in a..b, q x τ)
      (∫ x in a..b, (0 : Fin 1 → ℝ)) 1 := by
    intro a b
    simpa [q] using hasDerivAt_const 1 (∫ x in a..b, jumpProfile x)
  have hc : Continuous (fun _ : ℝ => (0 : Fin 1 → ℝ) + 0) := continuous_const
  have hj : ¬ ContinuousAt (fun x => q x 1) 0 :=
    (discontinuous_stationary_conservative_residual (0 : Fin 1 → ℝ) 0 1 hne).2.2
  exact ⟨q, flux, fun _ => 0, fun _ => 0, 1, by norm_num, hi,
    hqt, hfx, hzero, hzero, hswap, hc, hj,
    leveque01_integralLaw_impliesDifferentialLaw_of_smooth q flux
      (fun _ => 0) (fun _ => 0) 1 hi hqt hfx hzero hzero hswap hc⟩

#check smoothBridge_additionalInstance
#print axioms smoothBridge_additionalInstance

end NumStability.Chapter01Evidence
