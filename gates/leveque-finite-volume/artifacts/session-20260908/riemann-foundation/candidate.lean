import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.EigenmodeWaves

open MeasureTheory

namespace NumStability.Chapter01Scratch

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- Time-integrated balance over every oriented space-time rectangle. -/
def IsRectangleConservationLawSolution
    (q : ℝ → ℝ → E) (flux : E → E) : Prop :=
  (∀ a b t, IntervalIntegrable (fun x => q x t) volume a b) ∧
  (∀ x s t, IntervalIntegrable (fun τ => flux (q x τ)) volume s t) ∧
  ∀ a b s t,
    (∫ x in a..b, q x t) - (∫ x in a..b, q x s) =
      ∫ τ in s..t, (flux (q a τ) - flux (q b τ))

/-- Change of variables and interval additivity give transport balance even
for discontinuous locally integrable profiles. -/
theorem travelingWave_intervalBalance (profile : ℝ → E)
    (hprofile : ∀ a b, IntervalIntegrable profile volume a b)
    (speed a b s t : ℝ) :
    (∫ x in a..b, travelingWave profile speed x t) -
        (∫ x in a..b, travelingWave profile speed x s) =
      speed • (∫ τ in s..t, travelingWave profile speed a τ) -
        speed • (∫ τ in s..t, travelingWave profile speed b τ) := by
  simp only [travelingWave, intervalIntegral.integral_comp_sub_right,
    intervalIntegral.smul_integral_comp_sub_mul]
  exact intervalIntegral.integral_interval_sub_interval_comm
    (hprofile _ _) (hprofile _ _) (hprofile _ _)

omit [NormedSpace ℝ E] in
theorem travelingWave_intervalIntegrable_space (profile : ℝ → E)
    (hprofile : ∀ a b, IntervalIntegrable profile volume a b)
    (speed a b t : ℝ) :
    IntervalIntegrable (fun x => travelingWave profile speed x t) volume a b := by
  simpa only [travelingWave, sub_add_cancel] using
    (hprofile (a - speed * t) (b - speed * t)).comp_sub_right (speed * t)

omit [NormedSpace ℝ E] in
theorem travelingWave_intervalIntegrable_time (profile : ℝ → E)
    (hprofile : ∀ a b, IntervalIntegrable profile volume a b)
    (speed x s t : ℝ) :
    IntervalIntegrable (fun τ => travelingWave profile speed x τ) volume s t := by
  by_cases hc : speed = 0
  · simp only [travelingWave, hc, zero_mul, sub_zero]
    exact intervalIntegrable_const
  have hsub := (hprofile (x - speed * s) (x - speed * t)).comp_sub_left x
  have hmul := hsub.comp_mul_left (c := speed)
  simpa only [travelingWave, sub_sub_cancel, mul_div_cancel_left₀ _ hc] using hmul

theorem travelingWave_isRectangleConservationLawSolution (profile : ℝ → E)
    (hprofile : ∀ a b, IntervalIntegrable profile volume a b) (speed : ℝ) :
    IsRectangleConservationLawSolution (travelingWave profile speed)
      (fun state => speed • state) := by
  refine ⟨travelingWave_intervalIntegrable_space profile hprofile speed, ?_, ?_⟩
  · intro x s t
    exact (travelingWave_intervalIntegrable_time profile hprofile speed x s t).smul speed
  · intro a b s t
    calc
      _ = speed • (∫ τ in s..t, travelingWave profile speed a τ) -
          speed • (∫ τ in s..t, travelingWave profile speed b τ) :=
        travelingWave_intervalBalance profile hprofile speed a b s t
      _ = _ := by
        simpa only [Pi.smul_apply, intervalIntegral.integral_smul] using
          (intervalIntegral.integral_sub
            ((travelingWave_intervalIntegrable_time profile hprofile speed a s t).smul speed)
            ((travelingWave_intervalIntegrable_time profile hprofile speed b s t).smul speed)).symm

#print axioms travelingWave_isRectangleConservationLawSolution

open scoped BigOperators

omit [NormedSpace ℝ E] in
theorem riemannData_intervalIntegrable (leftState valueAtOrigin rightState : E) (a b : ℝ) :
    IntervalIntegrable (riemannData leftState valueAtOrigin rightState) volume a b := by
  rw [intervalIntegrable_iff]
  have hc (v : E) : Integrable (fun _ : ℝ => v) (volume.restrict (Set.uIoc a b)) :=
    (intervalIntegrable_const (a := a) (b := b) (c := v)).def'
  have hright := Integrable.piecewise (μ := volume.restrict (Set.uIoc a b))
    (s := Set.Ioi (0 : ℝ)) measurableSet_Ioi
    (hc rightState).integrableOn (hc valueAtOrigin).integrableOn
  have hfull := Integrable.piecewise (μ := volume.restrict (Set.uIoc a b))
    (s := Set.Iio (0 : ℝ)) measurableSet_Iio (hc leftState).integrableOn hright.integrableOn
  simpa only [Set.piecewise, Set.mem_Iio, Set.mem_Ioi, riemannData] using hfull

theorem eigenmodeTravelingWave_isRectangleSolution
    {ι : Type*} [Fintype ι] (coefficient : Matrix ι ι ℝ)
    (profile : ℝ → ℝ) (hprofile : ∀ a b, IntervalIntegrable profile volume a b)
    (speed : ℝ) (eigenvector : ι → ℝ)
    (heigen : coefficient.mulVec eigenvector = speed • eigenvector) :
    IsRectangleConservationLawSolution
      (eigenmodeTravelingWave profile speed eigenvector) coefficient.mulVec := by
  have hvector (a b : ℝ) :
      IntervalIntegrable (fun x => profile x • eigenvector) volume a b :=
    (hprofile a b).smul_continuousOn continuousOn_const
  have hbase := travelingWave_isRectangleConservationLawSolution
    (fun x => profile x • eigenvector) hvector speed
  simpa only [IsRectangleConservationLawSolution, eigenmodeTravelingWave,
    travelingWave, Matrix.mulVec_smul, heigen, smul_smul, mul_comm] using hbase

theorem finite_sum_isRectangleSolution
    {ι κ : Type*} [Fintype ι] [Fintype κ]
    (coefficient : Matrix ι ι ℝ) (q : κ → ℝ → ℝ → (ι → ℝ))
    (hq : ∀ p, IsRectangleConservationLawSolution (q p) coefficient.mulVec) :
    IsRectangleConservationLawSolution (fun x t => ∑ p, q p x t) coefficient.mulVec := by
  refine ⟨?_, ?_, ?_⟩
  · intro a b t
    simpa only [Finset.sum_fn] using
      IntervalIntegrable.sum Finset.univ (fun p _ => (hq p).1 a b t)
  · intro x s t
    simp_rw [Matrix.mulVec_sum]
    simpa only [Finset.sum_fn] using
      IntervalIntegrable.sum Finset.univ (fun p _ => (hq p).2.1 x s t)
  · intro a b s t
    rw [intervalIntegral.integral_finset_sum (fun p _ => (hq p).1 a b t),
      intervalIntegral.integral_finset_sum (fun p _ => (hq p).1 a b s),
      ← Finset.sum_sub_distrib]
    simp_rw [(hq _).2.2 a b s t, Matrix.mulVec_sum, ← Finset.sum_sub_distrib]
    exact (intervalIntegral.integral_finset_sum
      (fun p _ => ((hq p).2.1 a s t).sub ((hq p).2.1 b s t))).symm

noncomputable def linearRiemannSolution
    {ι : Type*} [Fintype ι] (eigenbasis : Module.Basis ι ℝ (ι → ℝ))
    (eigenvalues : ι → ℝ) (leftState valueAtOrigin rightState : ι → ℝ) :
    ℝ → ℝ → (ι → ℝ) :=
  fun x t => ∑ p, eigenmodeTravelingWave
    (riemannData (eigenbasis.equivFun leftState p)
      (eigenbasis.equivFun valueAtOrigin p) (eigenbasis.equivFun rightState p))
    (eigenvalues p) (eigenbasis p) x t

theorem linearRiemannSolution_isRectangleSolution
    {ι : Type*} [Fintype ι] (coefficient : Matrix ι ι ℝ)
    (eigenbasis : Module.Basis ι ℝ (ι → ℝ)) (eigenvalues : ι → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) = eigenvalues p • eigenbasis p)
    (leftState valueAtOrigin rightState : ι → ℝ) :
    IsRectangleConservationLawSolution
      (linearRiemannSolution eigenbasis eigenvalues leftState valueAtOrigin rightState)
      coefficient.mulVec := by
  exact finite_sum_isRectangleSolution coefficient _ (fun p =>
    eigenmodeTravelingWave_isRectangleSolution coefficient _
      (riemannData_intervalIntegrable _ _ _) _ _ (heigen p))

theorem linearRiemannSolution_initial
    {ι : Type*} [Fintype ι] (eigenbasis : Module.Basis ι ℝ (ι → ℝ))
    (eigenvalues : ι → ℝ) (leftState valueAtOrigin rightState : ι → ℝ) (x : ℝ) :
    linearRiemannSolution eigenbasis eigenvalues leftState valueAtOrigin rightState x 0 =
      riemannData leftState valueAtOrigin rightState x := by
  have hexpand (state : ι → ℝ) :
      ∑ p, eigenbasis.equivFun state p • eigenbasis p = state := by
    rw [← eigenbasis.equivFun_symm_apply]
    exact eigenbasis.equivFun.symm_apply_apply state
  simp only [linearRiemannSolution, eigenmodeTravelingWave, travelingWave, mul_zero, sub_zero]
  rcases lt_trichotomy x 0 with hx | hx | hx
  · simpa only [riemannData, hx, if_pos] using hexpand leftState
  · subst x
    simpa only [riemannData_zero] using hexpand valueAtOrigin
  · simpa only [riemannData, hx, not_lt_of_ge hx.le, if_pos, if_false] using hexpand rightState

theorem riemannData_mul_pos {State : Type*} (leftState valueAtOrigin rightState : State)
    (x : ℝ) {t : ℝ} (ht : 0 < t) :
    riemannData leftState valueAtOrigin rightState (x * t) =
      riemannData leftState valueAtOrigin rightState x := by
  have hneg : x * t < 0 ↔ x < 0 := by
    simpa only [zero_mul] using (mul_lt_mul_iff_left₀ ht : x * t < 0 * t ↔ x < 0)
  simp only [riemannData, hneg, mul_pos_iff_of_pos_right ht]

theorem linearRiemannSolution_selfSimilar
    {ι : Type*} [Fintype ι] (eigenbasis : Module.Basis ι ℝ (ι → ℝ))
    (eigenvalues : ι → ℝ) (leftState valueAtOrigin rightState : ι → ℝ)
    (x : ℝ) {t : ℝ} (ht : 0 < t) :
    linearRiemannSolution eigenbasis eigenvalues leftState valueAtOrigin rightState x t =
      linearRiemannSolution eigenbasis eigenvalues leftState valueAtOrigin rightState (x / t) 1 := by
  unfold linearRiemannSolution
  apply Finset.sum_congr rfl
  intro p _
  simp only [eigenmodeTravelingWave, travelingWave, mul_one]
  rw [show x - eigenvalues p * t = (x / t - eigenvalues p) * t by
    rw [sub_mul, div_mul_cancel₀ _ ht.ne']]
  rw [riemannData_mul_pos _ _ _ _ ht]

noncomputable def selectedLinearRiemannRayZeroValue
    {ι : Type*} [Fintype ι] (eigenbasis : Module.Basis ι ℝ (ι → ℝ))
    (eigenvalues : ι → ℝ) (leftState valueAtOrigin rightState : ι → ℝ) : ι → ℝ :=
  linearRiemannSolution eigenbasis eigenvalues leftState valueAtOrigin rightState 0 1

theorem linearRiemannSolution_rayZero
    {ι : Type*} [Fintype ι] (eigenbasis : Module.Basis ι ℝ (ι → ℝ))
    (eigenvalues : ι → ℝ) (leftState valueAtOrigin rightState : ι → ℝ)
    {t : ℝ} (ht : 0 < t) :
    linearRiemannSolution eigenbasis eigenvalues leftState valueAtOrigin rightState 0 t =
      selectedLinearRiemannRayZeroValue eigenbasis eigenvalues leftState valueAtOrigin rightState := by
  simpa only [zero_div, selectedLinearRiemannRayZeroValue] using
    linearRiemannSolution_selfSimilar eigenbasis eigenvalues leftState valueAtOrigin rightState 0 ht

theorem IsRealHyperbolicMatrix.exists_rectangle_riemann_solution
    {ι : Type*} [Fintype ι] {coefficient : Matrix ι ι ℝ}
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (leftState valueAtOrigin rightState : ι → ℝ) :
    ∃ q : ℝ → ℝ → (ι → ℝ),
      IsRectangleConservationLawSolution q coefficient.mulVec ∧
      (∀ x, q x 0 = riemannData leftState valueAtOrigin rightState x) ∧
      (∀ x t, 0 < t → q x t = q (x / t) 1) := by
  rcases hcoefficient with ⟨eigenvalues, eigenbasis, heigen⟩
  refine ⟨linearRiemannSolution eigenbasis eigenvalues leftState valueAtOrigin rightState,
    linearRiemannSolution_isRectangleSolution coefficient eigenbasis eigenvalues heigen
      leftState valueAtOrigin rightState,
    linearRiemannSolution_initial eigenbasis eigenvalues leftState valueAtOrigin rightState, ?_⟩
  intro x t ht
  exact linearRiemannSolution_selfSimilar eigenbasis eigenvalues leftState valueAtOrigin rightState x ht

#print axioms riemannData_intervalIntegrable
#print axioms eigenmodeTravelingWave_isRectangleSolution
#print axioms finite_sum_isRectangleSolution
#print axioms linearRiemannSolution_isRectangleSolution
#print axioms linearRiemannSolution_initial
#print axioms linearRiemannSolution_selfSimilar
#print axioms linearRiemannSolution_rayZero
#print axioms IsRealHyperbolicMatrix.exists_rectangle_riemann_solution

end NumStability.Chapter01Scratch
