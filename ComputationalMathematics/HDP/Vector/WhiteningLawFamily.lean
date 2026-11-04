import ComputationalMathematics.HDP.Vector.WhiteningLawRealization

/-!
# Finite families from a principal law whitening

The product of the constructed single-law pairs gives independent population
and whitening vectors. Every member has the same laws and the same principal
raw-second-moment root, including singular and zero-dimensional cases.
-/

noncomputable section

set_option backward.isDefEq.respectTransparency false

open MeasureTheory ProbabilityTheory Matrix
open scoped BigOperators ENNReal NNReal MatrixOrder

namespace NumStability.HDP.Vector.Whitening

universe u

private theorem scalar_subGaussian_of_identDistrib_family
    {Ω Ω' : Type*} [MeasurableSpace Ω] [MeasurableSpace Ω']
    {μ : Measure Ω} {ν : Measure Ω'} [IsProbabilityMeasure μ] [IsProbabilityMeasure ν]
    {X : Ω → ℝ} {Y : Ω' → ℝ} (hX : Measurable X) (hY : Measurable Y)
    (hLaw : IdentDistrib X Y μ ν)
    (hSG : NumStability.HDP.Scalar.SubGaussian.IsSubGaussian ν Y) :
    NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ X := by
  apply NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite.mpr
  have hXLaw : HasLaw X (μ.map X) μ := ⟨hX.aemeasurable, rfl⟩
  rw [NumStability.HDP.Scalar.SubGaussian.psiTwoNorm_eq_of_sameLaw
    hX hY hXLaw (hLaw.hasLaw hXLaw)]
  exact NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite.mp hSG

/-- A finite family of independent constructed pairs for any law with
sub-Gaussian coordinates. The whitening vectors are raw-isotropic and
qualitatively sub-Gaussian. Reconstruction uses the same principal root at
every index and holds at every point of the explicit product sample space. -/
theorem exists_principal_lawWhitening_family {ι : Type u} [Fintype ι] {n : ℕ}
    (ν : Measure (Fin n → ℝ)) [IsProbabilityMeasure ν]
    (hSG : ∀ j, NumStability.HDP.Scalar.SubGaussian.IsSubGaussian ν
      (fun y : Fin n → ℝ ↦ y j)) :
    let S := CFC.sqrt (Covariance.secondMomentMatrix ν (fun j (y : Fin n → ℝ) ↦ y j))
    ∃ T P Q : Matrix (Fin n) (Fin n) ℝ,
      SymmetricPartialInverseData S T P Q ∧
      ∃ (Ω : Type u) (mΩ : MeasurableSpace Ω),
        letI : MeasurableSpace Ω := mΩ
        ∃ μ : Measure Ω, IsProbabilityMeasure μ ∧
          ∃ F Z : ι → Ω → Fin n → ℝ,
            (∀ i, Measurable (F i) ∧ Measurable (Z i)) ∧
            (∀ i j, MemLp (fun ω ↦ F i ω j) 2 μ ∧
              MemLp (fun ω ↦ Z i ω j) 2 μ) ∧
            (∀ i, HasLaw (F i) ν μ) ∧
            iIndepFun F μ ∧ iIndepFun Z μ ∧
            iIndepFun (fun i ω ↦ (F i ω, Z i ω)) μ ∧
            (∀ i, IdentDistrib (Z i) (lawWhitenedVector T Q) μ
              (lawWhiteningMeasure ν)) ∧
            (∀ i j, IdentDistrib (Z i) (Z j) μ μ) ∧
            (∀ i, Isotropy.IsIsotropic μ (fun j ω ↦ Z i ω j)) ∧
            (∀ i, SubGaussian.IsSubGaussian μ (fun j ω ↦ Z i ω j)) ∧
            (∀ i ω, F i ω = S.mulVec (Z i ω)) := by
  dsimp only
  obtain ⟨T, P, Q, hData, hZBaseMeas, hZBaseLp, hFBaseMeas, hFBaseLp,
    hZBaseIso, hZBaseSG, hFBaseLaw, _, _⟩ :=
    exists_principal_lawWhitening_realization ν hSG
  let S := CFC.sqrt (Covariance.secondMomentMatrix ν (fun j (y : Fin n → ℝ) ↦ y j))
  let Ω := ι → ((Fin n → ℝ) × (Fin n → ℝ))
  let μ : Measure Ω := Measure.pi (fun _ : ι ↦ lawWhiteningMeasure ν)
  letI : IsProbabilityMeasure μ := inferInstance
  let F : ι → Ω → Fin n → ℝ := fun i ω ↦ lawRealizedVector S T Q (ω i)
  let Z : ι → Ω → Fin n → ℝ := fun i ω ↦ lawWhitenedVector T Q (ω i)
  have hLp : ∀ j, MemLp (fun y : Fin n → ℝ ↦ y j) 2 ν :=
    coordinate_memLp_of_subGaussian (SubGaussian.coordinates_vectorSubGaussian hSG)
  have hPSD : (Covariance.secondMomentMatrix ν
      (fun j (y : Fin n → ℝ) ↦ y j)).PosSemidef :=
    Covariance.secondMomentMatrix_posSemidef _ hLp
  have hSecond : Covariance.secondMomentMatrix ν
      (fun j (y : Fin n → ℝ) ↦ y j) = S * S :=
    (CFC.sqrt_mul_sqrt_self _ hPSD.nonneg).symm
  obtain ⟨hFLaw, hZIdent, hPairIndep, hPoint⟩ :=
    lawWhitening_independent_copies (ι := ι) ν S T P Q hData hLp hSecond
  have hMeas : ∀ i, Measurable (F i) ∧ Measurable (Z i) := by
    intro i
    exact ⟨hFBaseMeas.comp (measurable_pi_apply i),
      hZBaseMeas.comp (measurable_pi_apply i)⟩
  have hCoordLp : ∀ i j, MemLp (fun ω ↦ F i ω j) 2 μ ∧
      MemLp (fun ω ↦ Z i ω j) 2 μ := by
    intro i j
    have hFIdent : IdentDistrib (F i) (lawRealizedVector S T Q) μ
        (lawWhiteningMeasure ν) := (hFLaw i).identDistrib hFBaseLaw
    constructor
    · simpa only [F, Function.comp_def] using
        ((hFIdent.symm.comp (measurable_pi_apply j)).memLp_snd (hFBaseLp j))
    · simpa only [Z, Function.comp_def] using
        (((hZIdent i).symm.comp (measurable_pi_apply j)).memLp_snd (hZBaseLp j))
  have hFIndep : iIndepFun F μ := by
    simpa only [F, Function.comp_def] using
      hPairIndep.comp (fun _ ↦
        (Prod.fst : (Fin n → ℝ) × (Fin n → ℝ) → (Fin n → ℝ)))
        (fun _ ↦ measurable_fst)
  have hZIndep : iIndepFun Z μ := by
    simpa only [Z, Function.comp_def] using
      hPairIndep.comp (fun _ ↦
        (Prod.snd : (Fin n → ℝ) × (Fin n → ℝ) → (Fin n → ℝ)))
        (fun _ ↦ measurable_snd)
  have hZPairLaw : ∀ i j, IdentDistrib (Z i) (Z j) μ μ := by
    intro i j
    exact (hZIdent i).trans (hZIdent j).symm
  have hZIso : ∀ i, Isotropy.IsIsotropic μ (fun j ω ↦ Z i ω j) := by
    intro i
    change Covariance.secondMomentMatrix μ (fun j ω ↦ Z i ω j) = 1
    have hMoments : Covariance.secondMomentMatrix μ (fun j ω ↦ Z i ω j) =
        Covariance.secondMomentMatrix (lawWhiteningMeasure ν)
          (fun j ω ↦ lawWhitenedVector T Q ω j) := by
      ext j k
      have hProd := (hZIdent i).comp
        ((measurable_pi_apply j).mul (measurable_pi_apply k))
      simpa only [Covariance.secondMomentMatrix, Function.comp_def, Z]
        using hProd.integral_eq
    exact hMoments.trans hZBaseIso
  have hZSG : ∀ i, SubGaussian.IsSubGaussian μ (fun j ω ↦ Z i ω j) := by
    intro i u
    letI : IsProbabilityMeasure (lawWhiteningMeasure ν) := inferInstance
    let g : (Fin n → ℝ) → ℝ := fun x ↦ ∑ j, x j * u j
    have hg : Measurable g := by fun_prop
    have hMargLaw := (hZIdent i).comp hg
    have hMargMeas : Measurable (linearMarginal (fun j ω ↦ Z i ω j) u) := by
      change Measurable (fun ω ↦ ∑ j, Z i ω j * u j)
      fun_prop
    have hBaseMargMeas : Measurable
        (linearMarginal (fun j ω ↦ lawWhitenedVector T Q ω j) u) := by
      change Measurable (fun ω ↦ ∑ j, lawWhitenedVector T Q ω j * u j)
      fun_prop
    exact scalar_subGaussian_of_identDistrib_family hMargMeas hBaseMargMeas
      (by simpa only [g, linearMarginal, Function.comp_def, Z] using hMargLaw)
      (hZBaseSG u)
  exact ⟨T, P, Q, hData, Ω, inferInstance, μ, inferInstance, F, Z,
    hMeas, hCoordLp, hFLaw, hFIndep, hZIndep, hPairIndep,
    hZIdent, hZPairLaw, hZIso, hZSG, hPoint⟩

end NumStability.HDP.Vector.Whitening
