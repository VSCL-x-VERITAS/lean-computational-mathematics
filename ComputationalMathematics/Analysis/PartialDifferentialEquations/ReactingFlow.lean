/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.SourceTerms
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity

/-!
# Sources that depend on the state, and systems of them

Printed page 23 of LeVeque's Chapter 2 gives two examples of source terms that
the previous section's external heat source deliberately excluded, because they
depend on the state.

Newton's law of cooling makes the source proportional to the difference between
the rod and the bath. What that buys is a source that vanishes exactly at the
bath temperature and pushes the rod towards it from either side, and what it
costs is state independence, so the difference of two solutions no longer
satisfies the law with no source.

Radioactive decay gives a system: one species decays into another at a fixed
rate, so each has an advection equation with a source, and the sources cancel.
That cancellation is the content worth having. It says the total concentration
satisfies the source-free advection equation, which is why calling this decay
rather than creation or destruction is justified.
-/

namespace NumStability

/-! ### Newton cooling -/

/-- The source density of Newton's law of cooling: proportional to the
difference between the bath temperature and the current temperature. -/
def newtonCoolingSource (conductivity bath temperature : ℝ) : ℝ :=
  conductivity * (bath - temperature)

/-- The source vanishes exactly at the bath temperature. -/
theorem newtonCoolingSource_eq_zero_iff
    {conductivity bath temperature : ℝ} (h : conductivity ≠ 0) :
    newtonCoolingSource conductivity bath temperature = 0 ↔ temperature = bath := by
  simp [newtonCoolingSource, h, sub_eq_zero, eq_comm]

/-- Below the bath the source heats. -/
theorem newtonCoolingSource_pos_of_lt
    {conductivity bath temperature : ℝ} (hD : 0 < conductivity)
    (h : temperature < bath) :
    0 < newtonCoolingSource conductivity bath temperature :=
  mul_pos hD (by linarith)

/-- Above the bath the source cools. -/
theorem newtonCoolingSource_neg_of_gt
    {conductivity bath temperature : ℝ} (hD : 0 < conductivity)
    (h : bath < temperature) :
    newtonCoolingSource conductivity bath temperature < 0 :=
  mul_neg_of_pos_of_neg hD (by linarith)

/-- Newton cooling is not a state-independent source, so it is outside the class
the external-heat-source example assumed and the difference of two solutions
does not satisfy the source-free law. -/
theorem newtonCooling_not_isStateIndependentSource
    {conductivity bath : ℝ} (h : conductivity ≠ 0) :
    ¬ IsStateIndependentSource
      (fun v _ _ => newtonCoolingSource conductivity bath v) := by
  intro hind
  have := hind bath (bath + 1) 0 0
  simp only [newtonCoolingSource, sub_self, mul_zero] at this
  have hne : bath - (bath + 1) ≠ 0 := by linarith
  exact (mul_ne_zero h hne) this.symm

/-! ### The decay system -/

/-- The source of the two-species decay system (2.29): the first species loses
what the second gains. -/
def decaySource (rate : ℝ) (first : ℝ) : ℝ × ℝ := (-(rate * first), rate * first)

/-- The two sources cancel, which is what makes this decay rather than creation
or destruction. -/
theorem decaySource_sum_eq_zero (rate first : ℝ) :
    (decaySource rate first).1 + (decaySource rate first).2 = 0 := by
  simp [decaySource]

/-- Equation (2.29): the total concentration satisfies the advection equation
with no source at all.

Each species separately has a source, and neither concentration is conserved.
Their sum is, and that is the substance of the example. -/
theorem decay_total_isSourceFree
    {q1 q1t q1x q2t q2x : ℝ → ℝ → ℝ} {speed rate : ℝ}
    (h1 : ∀ x t, q1t x t + speed * q1x x t = -(rate * q1 x t))
    (h2 : ∀ x t, q2t x t + speed * q2x x t = rate * q1 x t) (x t : ℝ) :
    (q1t x t + q2t x t) + speed * (q1x x t + q2x x t) = 0 := by
  have e1 := h1 x t
  have e2 := h2 x t
  ring_nf
  ring_nf at e1 e2
  linarith

/-- Neither species alone is source free, so the cancellation above is a
property of the pair and not of either equation. -/
theorem decay_species_not_sourceFree {rate first : ℝ}
    (hrate : rate ≠ 0) (hfirst : first ≠ 0) :
    (decaySource rate first).1 ≠ 0 ∧ (decaySource rate first).2 ≠ 0 := by
  constructor <;> simp [decaySource, hrate, hfirst]

/-! ### The coefficient matrix and the diffusion matrix -/

/-- The coefficient matrix of the decay system is the advection speed on the
diagonal, and such a matrix is hyperbolic: the standard basis is an eigenbasis
and every eigenvalue is the speed. -/
theorem isRealHyperbolicMatrix_diagonal_const {m : ℕ} (speed : ℝ) :
    IsRealHyperbolicMatrix (Matrix.diagonal (fun _ : Fin m => speed)) := by
  rw [isRealHyperbolicMatrix_iff_independent_real_eigenvectors]
  refine ⟨fun _ => speed, fun p => (Pi.basisFun ℝ (Fin m)) p, ?_, ?_⟩
  · exact (Pi.basisFun ℝ (Fin m)).linearIndependent
  · intro p
    funext i
    by_cases h : i = p
    · subst h
      simp [Matrix.mulVec, dotProduct, Matrix.diagonal, Pi.basisFun_apply]
    · simp [Matrix.mulVec, dotProduct, Matrix.diagonal, Pi.basisFun_apply,
        Finset.sum_eq_zero, h]

/-- A diagonal diffusion matrix acts as a single scalar exactly when all its
entries are that scalar, so allowing the coefficient to differ between species
is a genuine widening of the model rather than a change of notation. -/
theorem diagonalDiffusion_eq_scalar_iff {m : ℕ}
    (coefficients : Fin m → ℝ) (scalar : ℝ) :
    (∀ (v : Fin m → ℝ) (i : Fin m),
        coefficients i * v i = scalar * v i) ↔ ∀ i, coefficients i = scalar := by
  constructor
  · intro h i
    have := h (fun _ => 1) i
    simpa using this
  · intro h v i
    rw [h i]

end NumStability
