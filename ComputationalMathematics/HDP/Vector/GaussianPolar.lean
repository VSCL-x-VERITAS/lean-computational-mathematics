import ComputationalMathematics.Analysis.TestMatrices.Orthogonal.OrthogonalCoordinates
import ComputationalMathematics.Analysis.Probability.Haar.HomogeneousSpaceIndependence
import ComputationalMathematics.HDP.Vector.Gaussian
import ComputationalMathematics.HDP.Vector.Spherical

/-!
# Polar direction of a finite standard Gaussian vector

This module identifies the existing normalized standard-Gaussian direction
law with the canonical normalized surface measure used by the HDP vector API.
It also transports that canonical equality to arbitrary standard-Gaussian
random vectors.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped RealInnerProductSpace

namespace NumStability.HDP.Vector.Gaussian

/-- The direction of a positive-dimensional standard Gaussian vector has the
canonical normalized surface law on the Euclidean unit sphere. -/
theorem standardGaussianDirectionMeasure_eq_uniformUnitSphereMeasure (d : ℕ) :
    NumStability.standardGaussianDirectionMeasure d =
      @NumStability.HDP.Vector.Spherical.uniformUnitSphereMeasure (d + 1) := by
  letI : IsProbabilityMeasure
      (@NumStability.HDP.Vector.Spherical.uniformUnitSphereMeasure (d + 1)) :=
    NumStability.HDP.Vector.Spherical.uniformUnitSphereMeasure_isProbabilityMeasure
      (by omega)
  apply MeasureTheory.measure_eq_of_invariant_probability_of_pretransitive
    (NumStability.orthogonalGroup_action_pretransitive (d + 1))
    (NumStability.normalizedOrthogonalHaar (d + 1))
  · exact NumStability.standardGaussianDirectionMeasure_invariant d
  · intro Q
    simpa [NumStability.HDP.Vector.Spherical.unitSphereMap,
      NumStability.orthogonalGroupSMulOrthogonalSphere] using
      (NumStability.HDP.Vector.Spherical.map_uniformUnitSphereMeasure_unitSphereMap
        (NumStability.orthogonalGroupEuclideanLinearIsometryEquiv (d + 1) Q))

/-- A random vector with the canonical finite standard-Gaussian law has a
uniform direction. The total direction map chooses a fixed sphere point at
zero; that exceptional branch is null under the Gaussian law. -/
theorem hasLaw_gaussianUnitDirection_of_isStandardNormal
    {Omega : Type*} [MeasurableSpace Omega] {mu : Measure Omega}
    (d : ℕ) {X : Fin (d + 1) → Omega → ℝ}
    (hX : IsStandardNormal mu X) :
    HasLaw (fun omega =>
        NumStability.gaussianUnitDirection d (fun i => X i omega))
      (@NumStability.HDP.Vector.Spherical.uniformUnitSphereMeasure (d + 1)) mu := by
  have hCanonical : HasLaw (NumStability.gaussianUnitDirection d)
      (NumStability.standardGaussianDirectionMeasure d)
      (NumStability.standardGaussianVectorMeasure (d + 1)) := by
    refine ⟨(NumStability.measurable_gaussianUnitDirection d).aemeasurable, ?_⟩
    rfl
  have h := hCanonical.fun_comp hX
  rw [standardGaussianDirectionMeasure_eq_uniformUnitSphereMeasure d] at h
  simpa using h

/-- The Euclidean radius of a positive-dimensional vector. -/
noncomputable def gaussianRadius (d : ℕ) (x : Fin (d + 1) → ℝ) : ℝ :=
  ‖WithLp.toLp 2 x‖

theorem measurable_gaussianRadius (d : ℕ) : Measurable (gaussianRadius d) := by
  exact (PiLp.continuous_toLp 2 (fun _ : Fin (d + 1) => ℝ)).measurable.norm

/-- Under the canonical standard-Gaussian vector law, Euclidean radius and
radially normalized direction are independent. -/
theorem indepFun_gaussianRadius_gaussianUnitDirection (d : ℕ) :
    IndepFun (gaussianRadius d) (NumStability.gaussianUnitDirection d)
      (NumStability.standardGaussianVectorMeasure (d + 1)) := by
  let pair : (Fin (d + 1) → ℝ) →
      ℝ × NumStability.OrthogonalSphere (d + 1) :=
    fun x => (gaussianRadius d x, NumStability.gaussianUnitDirection d x)
  have hpair : Measurable pair :=
    (measurable_gaussianRadius d).prodMk
      (NumStability.measurable_gaussianUnitDirection d)
  let joint : Measure (ℝ × NumStability.OrthogonalSphere (d + 1)) :=
    Measure.map pair (NumStability.standardGaussianVectorMeasure (d + 1))
  letI : IsProbabilityMeasure joint :=
    Measure.isProbabilityMeasure_map hpair.aemeasurable
  have hinv (Q : Matrix.orthogonalGroup (Fin (d + 1)) ℝ) :
      Measure.map
          (fun p : ℝ × NumStability.OrthogonalSphere (d + 1) =>
            (p.1, Q • p.2)) joint = joint := by
    let T : (Fin (d + 1) → ℝ) → (Fin (d + 1) → ℝ) :=
      fun x => Matrix.mulVec
        (Q : Matrix (Fin (d + 1)) (Fin (d + 1)) ℝ) x
    have hT : Measurable T := by fun_prop
    have hact : Measurable
        (fun p : ℝ × NumStability.OrthogonalSphere (d + 1) =>
          (p.1, Q • p.2)) := by fun_prop
    simp only [joint, Measure.map_map hact hpair]
    have hne : ∀ᵐ x ∂NumStability.standardGaussianVectorMeasure (d + 1), x ≠ 0 := by
      rw [ae_iff]
      simpa only [not_ne_iff, Set.setOf_eq_eq_singleton] using
        NumStability.standardGaussianVectorMeasure_singleton_zero d
    have hae :
        (fun p : ℝ × NumStability.OrthogonalSphere (d + 1) =>
          (p.1, Q • p.2)) ∘ pair =ᵐ[
            NumStability.standardGaussianVectorMeasure (d + 1)] pair ∘ T := by
      filter_upwards [hne] with x hx
      apply Prod.ext
      · change gaussianRadius d x = gaussianRadius d (T x)
        unfold gaussianRadius T
        symm
        exact
          (NumStability.orthogonalGroupEuclideanLinearIsometryEquiv (d + 1) Q).norm_map
            (WithLp.toLp 2 x)
      · exact
          (NumStability.gaussianUnitDirection_equivariant_of_ne_zero d Q x hx).symm
    rw [Measure.map_congr hae]
    rw [← Measure.map_map hpair hT]
    rw [NumStability.standardGaussianVectorMeasure_map_orthogonalGroup (d + 1) Q]
  have hjoint : IndepFun Prod.fst Prod.snd joint :=
    MeasureTheory.indepFun_fst_snd_of_invariant_probability_of_pretransitive
      (NumStability.orthogonalGroup_action_pretransitive (d + 1))
      (NumStability.normalizedOrthogonalHaar (d + 1)) joint hinv
  have hfactor :=
    (indepFun_iff_map_prod_eq_prod_map_map
      (μ := joint) measurable_fst.aemeasurable measurable_snd.aemeasurable).mp hjoint
  have hleft : Measure.map (fun p : ℝ × NumStability.OrthogonalSphere (d + 1) =>
      (p.1, p.2)) joint = joint := by
    simpa only [Prod.eta] using (Measure.map_id : Measure.map id joint = joint)
  rw [hleft] at hfactor
  apply (indepFun_iff_map_prod_eq_prod_map_map
    (measurable_gaussianRadius d).aemeasurable
    (NumStability.measurable_gaussianUnitDirection d).aemeasurable).2
  rw [show Measure.map (gaussianRadius d)
        (NumStability.standardGaussianVectorMeasure (d + 1)) =
      Measure.map Prod.fst joint by
        simp only [joint, Measure.map_map measurable_fst hpair]
        rfl]
  rw [show Measure.map (NumStability.gaussianUnitDirection d)
        (NumStability.standardGaussianVectorMeasure (d + 1)) =
      Measure.map Prod.snd joint by
        simp only [joint, Measure.map_map measurable_snd hpair]
        rfl]
  change joint = (Measure.map Prod.fst joint).prod (Measure.map Prod.snd joint)
  exact hfactor

/-- Radius and direction are independent for any random vector with the
canonical finite standard-Gaussian law. -/
theorem indepFun_radius_direction_of_isStandardNormal
    {Omega : Type*} [MeasurableSpace Omega] {mu : Measure Omega}
    (d : ℕ) {X : Fin (d + 1) → Omega → ℝ}
    (hX : IsStandardNormal mu X) :
    IndepFun
      (fun omega => gaussianRadius d (fun i => X i omega))
      (fun omega => NumStability.gaussianUnitDirection d (fun i => X i omega)) mu := by
  let Y : Omega → (Fin (d + 1) → ℝ) := fun omega i => X i omega
  have hY : HasLaw Y (NumStability.standardGaussianVectorMeasure (d + 1)) mu := hX
  have hr : AEMeasurable (fun omega => gaussianRadius d (Y omega)) mu :=
    (measurable_gaussianRadius d).comp_aemeasurable hY.aemeasurable
  have htheta : AEMeasurable
      (fun omega => NumStability.gaussianUnitDirection d (Y omega)) mu :=
    (NumStability.measurable_gaussianUnitDirection d).comp_aemeasurable hY.aemeasurable
  letI : IsProbabilityMeasure mu := hY.isProbabilityMeasure
  apply (indepFun_iff_map_prod_eq_prod_map_map hr htheta).2
  have hcanonical :=
    (indepFun_iff_map_prod_eq_prod_map_map
      (μ := NumStability.standardGaussianVectorMeasure (d + 1))
      (measurable_gaussianRadius d).aemeasurable
      (NumStability.measurable_gaussianUnitDirection d).aemeasurable).1
        (indepFun_gaussianRadius_gaussianUnitDirection d)
  let pair : (Fin (d + 1) → ℝ) →
      ℝ × NumStability.OrthogonalSphere (d + 1) :=
    fun x => (gaussianRadius d x, NumStability.gaussianUnitDirection d x)
  have hpair : Measurable pair :=
    (measurable_gaussianRadius d).prodMk
      (NumStability.measurable_gaussianUnitDirection d)
  have hpairCanonical : HasLaw pair
      (Measure.map pair (NumStability.standardGaussianVectorMeasure (d + 1)))
      (NumStability.standardGaussianVectorMeasure (d + 1)) :=
    ⟨hpair.aemeasurable, rfl⟩
  have hpairLaw : HasLaw (pair ∘ Y)
      (Measure.map pair (NumStability.standardGaussianVectorMeasure (d + 1))) mu :=
    hpairCanonical.fun_comp hY
  have hradiusCanonical : HasLaw (gaussianRadius d)
      (Measure.map (gaussianRadius d)
        (NumStability.standardGaussianVectorMeasure (d + 1)))
      (NumStability.standardGaussianVectorMeasure (d + 1)) :=
    ⟨(measurable_gaussianRadius d).aemeasurable, rfl⟩
  have hradiusLaw : HasLaw (gaussianRadius d ∘ Y)
      (Measure.map (gaussianRadius d)
        (NumStability.standardGaussianVectorMeasure (d + 1))) mu :=
    hradiusCanonical.fun_comp hY
  have hdirectionCanonical : HasLaw (NumStability.gaussianUnitDirection d)
      (Measure.map (NumStability.gaussianUnitDirection d)
        (NumStability.standardGaussianVectorMeasure (d + 1)))
      (NumStability.standardGaussianVectorMeasure (d + 1)) :=
    ⟨(NumStability.measurable_gaussianUnitDirection d).aemeasurable, rfl⟩
  have hdirectionLaw : HasLaw (NumStability.gaussianUnitDirection d ∘ Y)
      (Measure.map (NumStability.gaussianUnitDirection d)
        (NumStability.standardGaussianVectorMeasure (d + 1))) mu :=
    hdirectionCanonical.fun_comp hY
  change Measure.map (pair ∘ Y) mu =
    (Measure.map (gaussianRadius d ∘ Y) mu).prod
      (Measure.map (NumStability.gaussianUnitDirection d ∘ Y) mu)
  rw [hpairLaw.map_eq, hradiusLaw.map_eq, hdirectionLaw.map_eq]
  simpa [pair] using hcanonical

end NumStability.HDP.Vector.Gaussian
