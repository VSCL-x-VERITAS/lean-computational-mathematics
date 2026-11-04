import ComputationalMathematics.HDP.Graph.FinStochasticBlockExpectedAdjacency
import ComputationalMathematics.HDP.Matrix.SymmetricOperatorNormBounded
import Mathlib.MeasureTheory.Integral.Pi
import Mathlib.Probability.ProbabilityMassFunction.Integrals

/-!
# Loopless stochastic-block model on `Fin n`

This module realizes the balanced two-community stochastic-block law as a
product of independent Bernoulli upper-triangular entries.  The diagonal is
forced to zero, the lower triangle is reflected from the upper triangle, and
the resulting centered noise satisfies the standard `O(√n)` operator-norm
tail used by spectral clustering.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Graph.FinStochasticBlock

/-- Canonical upper-triangular coordinates, including the diagonal. -/
abbrev UpperPair (n : ℕ) := {ij : Fin n × Fin n // ij.fst ≤ ij.snd}

/-- Bernoulli probability at an upper-triangular coordinate.  Diagonal
coordinates are deterministically zero. -/
def upperProbability {n : ℕ} (community : Fin n → Fin 2)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters)
    (ij : UpperPair n) : NNReal :=
  if ij.val.1 = ij.val.2 then 0
  else if community ij.val.1 = community ij.val.2 then θ.p else θ.q

theorem upperProbability_le_one {n : ℕ} (community : Fin n → Fin 2)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (ij : UpperPair n) :
    upperProbability community θ ij ≤ 1 := by
  unfold upperProbability
  by_cases hdiag : ij.val.1 = ij.val.2
  · simp [hdiag]
  · by_cases hcomm : community ij.val.1 = community ij.val.2
    · simpa [hdiag, hcomm] using θ.hp
    · simpa [hdiag, hcomm] using θ.hq

/-- Product law of the independent upper-triangular Bernoulli coordinates. -/
def measure {n : ℕ} (community : Fin n → Fin 2)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) :
    Measure (UpperPair n → Bool) :=
  Measure.pi fun ij : UpperPair n ↦
    (PMF.bernoulli (upperProbability community θ ij)
      (upperProbability_le_one community θ ij)).toMeasure

instance measure_isProbabilityMeasure {n : ℕ} (community : Fin n → Fin 2)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) :
    IsProbabilityMeasure (measure community θ) := by
  unfold measure
  infer_instance

/-- Loopless symmetric adjacency matrix decoded from upper-triangular edge
coordinates. -/
def adjacency {n : ℕ} (ω : UpperPair n → Bool) : Matrix (Fin n) (Fin n) ℝ :=
  fun i j ↦
    if h : i ≤ j then
      if i = j then 0 else cond (ω ⟨(i, j), h⟩) 1 0
    else
      cond (ω ⟨(j, i), le_of_not_ge h⟩) 1 0

theorem adjacency_symmetric {n : ℕ} (ω : UpperPair n → Bool) (i j : Fin n) :
    adjacency ω i j = adjacency ω j i := by
  by_cases hij : i = j
  · subst j
    rfl
  · by_cases hle : i ≤ j
    · have hnle : ¬j ≤ i := fun hji ↦ hij (le_antisymm hle hji)
      simp [adjacency, hle, hnle, hij]
    · have hjle : j ≤ i := le_of_not_ge hle
      simp [adjacency, hle, hjle, Ne.symm hij]

theorem adjacency_hermitian {n : ℕ} (ω : UpperPair n → Bool) :
    (adjacency ω).IsHermitian := by
  ext i j
  simp only [Matrix.conjTranspose_apply, star_trivial]
  exact adjacency_symmetric ω j i

theorem adjacency_zero_or_one {n : ℕ} (ω : UpperPair n → Bool)
    (i j : Fin n) : adjacency ω i j = 0 ∨ adjacency ω i j = 1 := by
  unfold adjacency
  split
  · split
    · exact Or.inl rfl
    · cases hω : ω _ <;> simp
  · cases hω : ω _ <;> simp

private theorem coordinateExpectation {n : ℕ}
    (community : Fin n → Fin 2)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters)
    (ij : UpperPair n) :
    ∫ ω, cond (ω ij) (1 : ℝ) 0 ∂measure community θ =
      (upperProbability community θ ij).toReal := by
  unfold measure
  calc
    ∫ ω, cond (ω ij) (1 : ℝ) 0 ∂Measure.pi (fun ij : UpperPair n ↦
        (PMF.bernoulli (upperProbability community θ ij)
          (upperProbability_le_one community θ ij)).toMeasure) =
      ∫ b, cond b (1 : ℝ) 0 ∂(PMF.bernoulli
        (upperProbability community θ ij)
        (upperProbability_le_one community θ ij)).toMeasure :=
          integral_comp_eval
            (μ := fun ij : UpperPair n ↦
              (PMF.bernoulli (upperProbability community θ ij)
                (upperProbability_le_one community θ ij)).toMeasure)
            (i := ij) (f := fun b : Bool ↦ cond b (1 : ℝ) 0)
            (measurable_of_finite _).aestronglyMeasurable
    _ = (upperProbability community θ ij).toReal :=
      PMF.bernoulli_expectation (upperProbability_le_one community θ ij)

/-- Entrywise expectation is the loopless population adjacency matrix. -/
theorem adjacency_expectation {n : ℕ} (community : Fin n → Fin 2)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (i j : Fin n) :
    ∫ ω, adjacency ω i j ∂measure community θ =
      expectedAdjacency community θ.p θ.q i j := by
  by_cases hij : i = j
  · subst j
    simp [adjacency, expectedAdjacency]
  · by_cases hle : i ≤ j
    · rw [show (∫ ω, adjacency ω i j ∂measure community θ) =
          ∫ ω, cond (ω ⟨(i, j), hle⟩) (1 : ℝ) 0 ∂measure community θ by
            simp [adjacency, hle, hij]]
      rw [coordinateExpectation]
      simp [upperProbability, expectedAdjacency, hij]
      split <;> rfl
    · have hjle : j ≤ i := le_of_not_ge hle
      rw [show (∫ ω, adjacency ω i j ∂measure community θ) =
          ∫ ω, cond (ω ⟨(j, i), hjle⟩) (1 : ℝ) 0 ∂measure community θ by
            simp [adjacency, hle]]
      rw [coordinateExpectation]
      simp [upperProbability, expectedAdjacency, hij, Ne.symm hij, eq_comm]
      split <;> rfl

theorem adjacency_abs_le_one {n : ℕ} (ω : UpperPair n → Bool) (i j : Fin n) :
    |adjacency ω i j| ≤ 1 := by
  unfold adjacency
  split
  · split
    · norm_num
    · cases hω : ω _ <;> norm_num
  · cases hω : ω _ <;> norm_num

theorem noise_symmetric {n : ℕ} (community : Fin n → Fin 2)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters)
    (ω : UpperPair n → Bool) (i j : Fin n) :
    (expectedAdjacency community θ.p θ.q - adjacency ω) i j =
      (expectedAdjacency community θ.p θ.q - adjacency ω) j i := by
  rw [Matrix.sub_apply, Matrix.sub_apply, adjacency_symmetric ω]
  simp only [expectedAdjacency]
  by_cases hij : i = j <;> simp [hij, eq_comm]

theorem noise_measurable {n : ℕ} (community : Fin n → Fin 2)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (i j : Fin n) :
    Measurable (fun ω : UpperPair n → Bool ↦
      (expectedAdjacency community θ.p θ.q - adjacency ω) i j) :=
  measurable_of_finite _

theorem noise_abs_le_one {n : ℕ} (community : Fin n → Fin 2)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters)
    (ω : UpperPair n → Bool) (i j : Fin n) :
    |(expectedAdjacency community θ.p θ.q - adjacency ω) i j| ≤ 1 := by
  have hp0 : (0 : ℝ) ≤ θ.p := by positivity
  have hq0 : (0 : ℝ) ≤ θ.q := by positivity
  have hp1 : (θ.p : ℝ) ≤ 1 := by exact_mod_cast θ.hp
  have hq1 : (θ.q : ℝ) ≤ 1 := by exact_mod_cast θ.hq
  have hA : adjacency ω i j = 0 ∨ adjacency ω i j = 1 := by
    unfold adjacency
    split
    · split
      · exact Or.inl rfl
      · cases hω : ω _ <;> simp
    · cases hω : ω _ <;> simp
  have hD0 : 0 ≤ expectedAdjacency community θ.p θ.q i j := by
    unfold expectedAdjacency
    split
    · norm_num
    · split
      · exact hp0
      · exact hq0
  have hD1 : expectedAdjacency community θ.p θ.q i j ≤ 1 := by
    unfold expectedAdjacency
    split
    · norm_num
    · split
      · exact hp1
      · exact hq1
  rw [Matrix.sub_apply]
  rcases hA with hA | hA <;> rw [hA]
  · simp only [sub_zero]
    rw [abs_of_nonneg hD0]
    exact hD1
  · rw [abs_of_nonpos (sub_nonpos.mpr hD1)]
    linarith

theorem noise_mean_zero {n : ℕ} (community : Fin n → Fin 2)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (ij : UpperPair n) :
    (∫ ω, (expectedAdjacency community θ.p θ.q - adjacency ω)
        ij.val.1 ij.val.2 ∂measure community θ) = 0 := by
  simp only [Matrix.sub_apply]
  rw [MeasureTheory.integral_sub]
  · rw [MeasureTheory.integral_const, adjacency_expectation]
    simp
  · exact MeasureTheory.integrable_const _
  · exact MeasureTheory.Integrable.of_bound
      (measurable_of_finite _).aestronglyMeasurable 1
      (Filter.Eventually.of_forall fun ω ↦ by
        simpa only [Real.norm_eq_abs] using
          adjacency_abs_le_one ω ij.val.1 ij.val.2)

theorem noise_iIndepFun {n : ℕ} (community : Fin n → Fin 2)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) :
    iIndepFun
      (fun ij : UpperPair n => fun ω : UpperPair n → Bool =>
        (expectedAdjacency community θ.p θ.q - adjacency ω) ij.val.1 ij.val.2)
      (measure community θ) := by
  let g : UpperPair n → Bool → ℝ := fun ij b ↦
    expectedAdjacency community θ.p θ.q ij.val.1 ij.val.2 -
      if ij.val.1 = ij.val.2 then 0 else cond b 1 0
  have hcoord : iIndepFun
      (fun ij : UpperPair n => fun ω : UpperPair n → Bool => ω ij)
      (measure community θ) := by
    unfold measure
    exact iIndepFun_pi (X := fun _ : UpperPair n ↦ id)
      (fun _ ↦ measurable_id.aemeasurable)
  have hg : ∀ ij, Measurable (g ij) := fun _ ↦ measurable_of_finite _
  have hcomp := hcoord.comp g hg
  apply hcomp.congr
  intro ij
  filter_upwards [] with ω
  simp only [Function.comp_apply]
  dsimp [g]
  unfold adjacency
  simp [ij.2]

/-- Exact independent-Bernoulli loopless stochastic-block noise obeys the
standard symmetric operator-norm tail. -/
theorem exists_operatorNorm_noise_sqrt_tail :
    ∃ C : ℝ, 0 < C ∧
      ∀ {n : ℕ} (_hn : 0 < n) (community : Fin n → Fin 2)
        (θ : NumStability.HDP.Graph.StochasticBlock.Parameters),
        (measure community θ).real {ω |
          C * Real.sqrt n < NumStability.realMatrixOperatorNorm
            (expectedAdjacency community θ.p θ.q - adjacency ω)} ≤
          4 * Real.exp (-(n : ℝ)) := by
  rcases
      NumStability.HDP.Matrix.exists_symmetric_operatorNorm_sqrt_tail_of_independent_centered_bounded_entries with
    ⟨C, hC, htail⟩
  refine ⟨C, hC, ?_⟩
  intro n hn community θ
  letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
  exact htail hn
    (fun ω ↦ expectedAdjacency community θ.p θ.q - adjacency ω)
    (noise_symmetric community θ) (noise_measurable community θ)
    (noise_abs_le_one community θ) (noise_mean_zero community θ)
    (noise_iIndepFun community θ)

end NumStability.HDP.Graph.FinStochasticBlock
