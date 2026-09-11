import ComputationalMathematics.Source.Vershynin.Chapter02.Section01.Theorem03.Signature
import ComputationalMathematics.Source.Vershynin.Chapter01.Section03.Theorem02.Contract

/-!
# Source-facing weakened contract for Theorem 2.1.3

Vershynin's printed theorem has coefficient one.  The declaration below proves
the same one-sided Berry--Esseen estimate with the larger, explicit constant
certified by the library's maximal-cutoff Prawitz route.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set
open scoped ENNReal NNReal BigOperators

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.LimitTheorems
open NumStability.HDP.Scalar.BerryEsseen

/-- Weakened Theorem 2.1.3, printed page 14: the source coefficient one is
replaced by `prawitzMaximalSharpBerryEsseenConstant`. -/
theorem hdp_02_hthm_h2_d1_d3_weakened
    {Omega : Type*} [MeasurableSpace Omega]
    (mu : Measure Omega) [IsProbabilityMeasure mu]
    (X : ℕ → Omega → ℝ) (m sigma : ℝ) (hsigma : 0 < sigma)
    (hX : ∀ i, MemLp (X i) 3 mu)
    (hIndep : iIndepFun X mu)
    (hIdent : ∀ i, IdentDistrib (X i) (X 0) mu mu)
    (hMean : ∫ omega, X 0 omega ∂mu = m)
    (hVariance : Var[X 0; mu] = sigma ^ 2)
    {N : ℕ} (hN : 1 ≤ N) (t : ℝ) :
    |(probabilityLaw
          (hdp_01_hdef_hzn X m sigma N)
          (hdp_01_hdef_hzn_aemeasurable mu X m sigma N
            (fun i => (hX i).aemeasurable)) : Measure ℝ).real (Ici t) -
      standardNormalLaw.real (Ici t)| ≤
      prawitzMaximalSharpBerryEsseenConstant *
        ((∫ omega, |X 0 omega - m| ^ 3 ∂mu) / sigma ^ 3) /
          Real.sqrt (N : ℝ) := by
  rcases hN.eq_or_lt with rfl | hNgt
  · let Y : Omega → ℝ := fun omega => sigma⁻¹ * (X 0 omega - m)
    have hY : MemLp Y 3 mu :=
      ((hX 0).sub (memLp_const m)).const_mul sigma⁻¹
    have hX2 : MemLp (X 0) 2 mu := (hX 0).mono_exponent (by norm_num)
    have hSecondY : ∫ omega, (Y omega) ^ 2 ∂mu = 1 := by
      have hc : (∫ omega, (X 0 omega - m) ^ 2 ∂mu) = sigma ^ 2 := by
        calc
          (∫ omega, (X 0 omega - m) ^ 2 ∂mu) = Var[X 0; mu] := by
            rw [variance_eq_integral hX2.aemeasurable, hMean]
          _ = sigma ^ 2 := hVariance
      dsimp [Y]
      calc
        (∫ omega, (sigma⁻¹ * (X 0 omega - m)) ^ 2 ∂mu) =
            ∫ omega, sigma⁻¹ ^ 2 * (X 0 omega - m) ^ 2 ∂mu := by
          congr 1
          funext omega
          ring
        _ = sigma⁻¹ ^ 2 * ∫ omega, (X 0 omega - m) ^ 2 ∂mu :=
          integral_const_mul _ _
        _ = 1 := by
          rw [hc]
          field_simp [hsigma.ne']
    have hRhoY : 1 ≤ ∫ omega, |Y omega| ^ 3 ∂mu :=
      one_le_thirdAbsoluteMoment_of_secondMoment_eq_one hY hSecondY
    have hThirdY :
        (∫ omega, |Y omega| ^ 3 ∂mu) =
          (∫ omega, |X 0 omega - m| ^ 3 ∂mu) / sigma ^ 3 := by
      have hfun : (fun omega => |Y omega| ^ 3) =
          fun omega => sigma⁻¹ ^ 3 * |X 0 omega - m| ^ 3 := by
        funext omega
        dsimp [Y]
        rw [abs_mul, abs_of_pos (inv_pos.mpr hsigma)]
        ring
      rw [hfun, integral_const_mul]
      field_simp [hsigma.ne']
    have hgap :
        |(probabilityLaw
              (hdp_01_hdef_hzn X m sigma 1)
              (hdp_01_hdef_hzn_aemeasurable mu X m sigma 1
                (fun i => (hX i).aemeasurable)) : Measure ℝ).real (Ici t) -
            standardNormalLaw.real (Ici t)| ≤ 1 :=
      (measureReal_Ici_gap_le_kolmogorovDistance _ _ t).trans
        (kolmogorovDistance_le_one _ _)
    rw [← hThirdY]
    have hmul :
        1 ≤ prawitzMaximalSharpBerryEsseenConstant *
          ∫ omega, |Y omega| ^ 3 ∂mu := by
      simpa only [one_mul] using mul_le_mul
        (one_lt_prawitzMaximalSharpBerryEsseenConstant.le)
        hRhoY (by norm_num) prawitzMaximalSharpBerryEsseenConstant_nonneg
    simpa using hgap.trans hmul
  · have hPred : 1 ≤ N - 1 := by omega
    have htail :=
      measureReal_Ici_normalizedIidSum_gap_le_prawitzMaximalSharpBerryEsseenConstant
        X m sigma hsigma hX hIndep hIdent hMean hVariance hPred t
    have hNorm : normalizedIidSum X m sigma (N - 1) =
        hdp_01_hdef_hzn X m sigma N := by
      rw [normalizedIidSum_eq_hdp_01_hdef_hzn]
      congr
      omega
    have hLaw :
        (probabilityLaw
            (normalizedIidSum X m sigma (N - 1))
            (normalizedIidSum_memLp X m sigma
              (fun i => (hX i).mono_exponent (by norm_num))
              (N - 1)).aemeasurable : Measure ℝ) =
          (probabilityLaw
            (hdp_01_hdef_hzn X m sigma N)
            (hdp_01_hdef_hzn_aemeasurable mu X m sigma N
              (fun i => (hX i).aemeasurable)) : Measure ℝ) := by
      change Measure.map (normalizedIidSum X m sigma (N - 1)) mu =
        Measure.map (hdp_01_hdef_hzn X m sigma N) mu
      rw [hNorm]
    rw [hLaw] at htail
    norm_num [Nat.cast_sub hN] at htail
    exact htail

/-- The weakened implementation inhabits its frozen source-facing signature. -/
theorem hdp_02_hthm_h2_d1_d3_weakened__contract :
    hdp_02_hthm_h2_d1_d3_weakened__contract_type := by
  intro Omega _ mu _ X m sigma hsigma hX hIndep hIdent hMean hVariance N hN t
  exact hdp_02_hthm_h2_d1_d3_weakened
    mu X m sigma hsigma hX hIndep hIdent hMean hVariance hN t

end NumStability.HDP.Contract
