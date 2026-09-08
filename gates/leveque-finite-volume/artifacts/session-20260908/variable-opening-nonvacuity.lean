import ComputationalMathematics.Source.LeVeque.Chapter01.VariableCoefficientConservationForm

namespace NumStability.Chapter01Evidence

/-- The flux-representation predicate has the expected nonempty constant case. -/
theorem constantScalarTransportFlux_represents (c : ℝ) :
    RepresentsScalarTransportFlux (fun _ => c) (fun _ state => c * state) := by
  intro profile x slope h
  exact h.const_mul c

/-- The existing existential witness really has a variable coefficient. -/
theorem variableCoefficient_nonvacuous_instance :
    ∃ coefficient : ℝ → ℝ,
      ContDiff ℝ (⊤ : ℕ∞) coefficient ∧
      (∀ x, 0 < coefficient x) ∧
      (∀ x, IsRealHyperbolicMatrix (constantCoefficientScalarMatrix (coefficient x))) ∧
      (¬ ∃ flux : ℝ → ℝ → ℝ, RepresentsScalarTransportFlux coefficient flux) ∧
      (∀ c : ℝ, coefficient ≠ fun _ => c) := by
  obtain ⟨coefficient, hsmooth, hpositive, hhyperbolic, hflux⟩ :=
    leveque01_exists_hyperbolic_variableCoefficient_without_localFlux
  refine ⟨coefficient, hsmooth, hpositive, hhyperbolic, hflux, ?_⟩
  intro c hc
  apply hflux
  refine ⟨fun _ state => c * state, ?_⟩
  rw [hc]
  exact constantScalarTransportFlux_represents c

end NumStability.Chapter01Evidence

#check NumStability.leveque01_exists_hyperbolic_variableCoefficient_without_localFlux
#print axioms NumStability.leveque01_exists_hyperbolic_variableCoefficient_without_localFlux
#check NumStability.Chapter01Evidence.constantScalarTransportFlux_represents
#print axioms NumStability.Chapter01Evidence.constantScalarTransportFlux_represents
#check NumStability.Chapter01Evidence.variableCoefficient_nonvacuous_instance
#print axioms NumStability.Chapter01Evidence.variableCoefficient_nonvacuous_instance

