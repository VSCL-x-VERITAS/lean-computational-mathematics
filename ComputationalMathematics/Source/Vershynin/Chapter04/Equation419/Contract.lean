import ComputationalMathematics.HDP.Vector.EigenvectorAlignment

/-!
# Vershynin Chapter 4, Equation (4.19)
-/

noncomputable section

namespace NumStability.HDP.Contract

/-- Vershynin, Equation (4.19): the Davis--Kahan sine bound implies
Euclidean closeness of the corresponding unit eigenvectors after choosing one
of their two possible signs.  The constant `2 * sqrt 2` is `2^(3/2)`.

The premise is precisely the conclusion of Theorem 4.5.5, with `d` standing
for `‖S - T‖` and `δ` for the spectral separation. -/
theorem hdp_04_equation_4_19
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (uS uT : E) (huS : ‖uS‖ = 1) (huT : ‖uT‖ = 1)
    (d δ : ℝ) (hδ : 0 < δ)
    (hDavisKahan :
      Real.sin (InnerProductGeometry.angle uS uT) ≤ 2 * d / δ) :
    ∃ θ : ℝ, (θ = -1 ∨ θ = 1) ∧
      ‖uS - θ • uT‖ ≤ 2 * Real.sqrt 2 * d / δ := by
  obtain ⟨θ, hθ, hbound⟩ :=
    NumStability.HDP.Vector.exists_sign_norm_sub_le_of_sin_angle_le
      uS uT huS huT (2 * d / δ) hDavisKahan
  refine ⟨θ, hθ, ?_⟩
  calc
    ‖uS - θ • uT‖ ≤ Real.sqrt 2 * (2 * d / δ) := hbound
    _ = 2 * Real.sqrt 2 * d / δ := by
      field_simp [hδ.ne']

end NumStability.HDP.Contract
