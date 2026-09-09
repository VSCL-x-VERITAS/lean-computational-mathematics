import ComputationalMathematics.Source.LeVeque.Chapter01.FiniteVolumeLocalFluxUpdate

set_option pp.universes false
set_option pp.proofs false

-- These commands expose definitions and theorem types, never theorem proof bodies.
#print Pi.seminormedAddGroup
#check @Pi.norm_def
#check @Pi.nnnorm_def
#check @pi_norm_le_iff_of_nonneg
#check @pi_norm_le_iff_of_nonempty
#check @norm_le_pi_norm
#check @Real.norm_eq_abs

section ActualTargetSpace
variable (m : ℕ)
#synth NormedAddCommGroup (Fin m → ℝ)
#synth NormedSpace ℝ (Fin m → ℝ)
#synth CompleteSpace (Fin m → ℝ)
#check fun (v : Fin m → ℝ) => Pi.norm_def v
#check fun (v : Fin m → ℝ) (r : ℝ) (hr : 0 ≤ r) =>
  (pi_norm_le_iff_of_nonneg (x := v) hr)
#check fun {α : Type*} [MeasurableSpace α] (μ : MeasureTheory.Measure α)
    (f : α → Fin m → ℝ) (hf : MeasureTheory.Integrable f μ) =>
  MeasureTheory.integral_eq f hf
end ActualTargetSpace

#print ENNReal.toNNReal
#print ENNReal.toReal
#check @ENNReal.coe_toReal
#check @ENNReal.toReal_ofReal
#check @ENNReal.toReal_top

#print axioms Pi.norm_def
#print axioms Pi.nnnorm_def
#print axioms pi_norm_le_iff_of_nonneg
#print axioms pi_norm_le_iff_of_nonempty
#print axioms norm_le_pi_norm
#print axioms Real.norm_eq_abs
#print axioms MeasureTheory.integral_eq
#print axioms ENNReal.coe_toReal
#print axioms ENNReal.toReal_ofReal
#print axioms ENNReal.toReal_top
