import ComputationalMathematics.HDP.Vector.NormConcentration
import ComputationalMathematics.HDP.Vector.SubGaussian
import ComputationalMathematics.HDP.Vector.LinearMarginals
import ComputationalMathematics.HDP.Vector.SphericalSubGaussian
import ComputationalMathematics.HDP.Metric.NormDeviationNet
import ComputationalMathematics.HDP.Metric.EuclideanSphereCovering
import ComputationalMathematics.HDP.Probability.FiniteUnion
import ComputationalMathematics.Analysis.SingularValues.ExtremeValues

/-!
# Norm concentration for independent isotropic sub-Gaussian matrix rows

Uniform action-norm and extreme singular-value bounds obtained from scalar
norm concentration and an unsquared finite-net union bound. Constants are
universal and independent of the matrix dimensions, probability space and
sub-Gaussian bound.
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal BigOperators

namespace NumStability.HDP.Matrix

/-- Fixed-direction unsquared norm tail, using the rescaled Theorem3.1.1 result. -/
theorem exists_fixedDirection_normDeviation_tail :
    ∃ c : ℝ, 0 < c ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ} [Nonempty (Fin m)]
        (A : Ω → Matrix (Fin m) (Fin n) ℝ) {K : ℝ},
        0 < K →
        (∀ i j, Measurable (fun ω => A ω i j)) →
        (∀ i j, MemLp (fun ω => A ω i j) 2 μ) →
        (∀ i, NumStability.HDP.Vector.Isotropy.IsIsotropic μ
          (fun j ω => A ω i j)) →
        (∀ i, NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω => A ω i j) ≤ ENNReal.ofReal K) →
        iIndepFun (fun i ω => fun j => A ω i j) μ →
        ∀ (x : Fin n → ℝ), NumStability.vecNorm2 x = 1 →
        ∀ {u : ℝ}, 0 ≤ u →
          μ.real {ω |
            |NumStability.vecNorm2 ((A ω).mulVec x) - Real.sqrt (m : ℝ)| ≥ u} ≤
              2 * Real.exp (-(c * u ^ 2 / K ^ 4)) := by
  rcases NumStability.HDP.Vector.NormConcentration.euclideanNormDeviation_tail with
    ⟨c, hc, htail⟩
  refine ⟨c, hc, ?_⟩
  intro Ω instΩ μ instμ m n instm A K hK hMeas hLp hIso hPsi hIndep x hx u hu
  let X : Fin m → Ω → ℝ := fun i ω =>
    NumStability.HDP.Vector.linearMarginal (fun j ω' => A ω' i j) x ω
  have hXMeas : ∀ i, Measurable (X i) := by
    intro i
    dsimp [X, NumStability.HDP.Vector.linearMarginal]
    fun_prop
  have hScalarLe (i : Fin m) :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ (X i) ≤
        NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω => A ω i j) := by
    unfold NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
    exact le_iSup
      (fun v : NumStability.HDP.Vector.SubGaussian.UnitDirection n =>
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
          (NumStability.HDP.Vector.linearMarginal
            (fun j ω => A ω i j) v.1)) ⟨x, hx⟩
  have hXFinite : ∀ i,
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ (X i) < ∞ := by
    intro i
    have hle := (hScalarLe i).trans (hPsi i)
    exact hle.trans_lt ENNReal.ofReal_lt_top
  have hXSecond : ∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 1 := by
    intro i
    have hbilinear :=
      NumStability.HDP.Vector.Isotropy.integral_linearMarginal_mul_linearMarginal
        (fun j => hLp i j) (hIso i) x x
    calc
      (∫ ω, X i ω ^ 2 ∂μ) =
          ∫ ω, X i ω * X i ω ∂μ := by
            congr 1
            funext ω
            rw [pow_two]
      _ = ∑ j, x j * x j := hbilinear
      _ = NumStability.vecNorm2 x ^ 2 := by
        rw [NumStability.vecNorm2_sq]
        simp only [NumStability.vecNorm2Sq, pow_two]
      _ = 1 := by rw [hx]; norm_num
  have hXIndep : iIndepFun X μ := by
    have hcomp := hIndep.comp
      (fun _i (row : Fin n → ℝ) => ∑ j, row j * x j)
      (fun _i => by fun_prop)
    simpa [X, Function.comp_def,
      NumStability.HDP.Vector.linearMarginal] using hcomp
  let Kx : ℝ :=
    NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X
  have hKxle : Kx ≤ K := by
    dsimp [Kx, NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax]
    apply Finset.sup'_le Finset.univ_nonempty
    intro i _hi
    have hle := (hScalarLe i).trans (hPsi i)
    have hreal := ENNReal.toReal_mono ENNReal.ofReal_ne_top hle
    simpa [ENNReal.toReal_ofReal hK.le] using hreal
  have hKxnonneg : 0 ≤ Kx := by
    simpa [Kx] using
      (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax_nonneg
        (μ := μ) (X := X))
  have hKxpos : 0 < Kx := by
    have hlower :=
      NumStability.HDP.Vector.NormConcentration.one_le_scaled_psiTwoNormMax_sq
        X hXMeas hXFinite hXSecond
    by_contra hnot
    have hzero : Kx = 0 := le_antisymm (le_of_not_gt hnot) hKxnonneg
    rw [show NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X = Kx by rfl,
      hzero] at hlower
    norm_num at hlower
  have hraw := htail X hXMeas hXFinite hXSecond hXIndep hu
  have hevent :
      {ω |
        |NumStability.vecNorm2 ((A ω).mulVec x) - Real.sqrt (m : ℝ)| ≥ u} =
      {ω |
        |NumStability.vecNorm2 (fun i => X i ω) - Real.sqrt (m : ℝ)| ≥ u} := by
    ext ω
    have hv : (A ω).mulVec x = fun i => X i ω := by
      funext i
      simp [X, NumStability.HDP.Vector.linearMarginal, Matrix.mulVec, dotProduct]
    simp only [Set.mem_setOf_eq, hv]
  rw [hevent]
  refine hraw.trans ?_
  apply mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr ?_) (by norm_num)
  apply neg_le_neg
  have hpow : Kx ^ 4 ≤ K ^ 4 := pow_le_pow_left₀ hKxnonneg hKxle 4
  have hratio : u ^ 2 / K ^ 4 ≤ u ^ 2 / Kx ^ 4 :=
    div_le_div_of_nonneg_left (sq_nonneg u) (pow_pos hKxpos 4) hpow
  calc
    c * u ^ 2 / K ^ 4 = c * (u ^ 2 / K ^ 4) := by ring
    _ ≤ c * (u ^ 2 / Kx ^ 4) := mul_le_mul_of_nonneg_left hratio hc.le
    _ = c * u ^ 2 / Kx ^ 4 := by ring

/-- The displayed unsquared Exercise4.4.4 bound specialized to a quarter-net. -/
theorem unit_normDeviation_le_six_of_quarterNet_bound
    {m n : ℕ} (hn : 0 < n) (A : Matrix (Fin m) (Fin n) ℝ)
    (b u : ℝ) (N : Finset (EuclideanSpace ℝ (Fin n)))
    (hN : NumStability.HDP.Metric.IsFiniteUnitSphereNet (1 / 4 : ℝ) N)
    (hNnonempty : N.Nonempty)
    (hdev : ∀ x ∈ N, |‖Matrix.toEuclideanLin A x‖ - b| ≤ u) :
    ∀ x : EuclideanSpace ℝ (Fin n), ‖x‖ = 1 →
      |‖Matrix.toEuclideanLin A x‖ - b| ≤ 6 * u := by
  classical
  have hNset : NumStability.HDP.Metric.IsUnitSphereNet (1 / 4 : ℝ)
      (N : Set (EuclideanSpace ℝ (Fin n))) := by
    simpa [NumStability.HDP.Metric.IsUnitSphereNet,
      NumStability.HDP.Metric.IsFiniteUnitSphereNet] using hN
  have hSne :
      {a : ℝ | ∃ x ∈ (N : Set (EuclideanSpace ℝ (Fin n))),
        a = |‖Matrix.toEuclideanLin A x‖ - b|}.Nonempty := by
    obtain ⟨x, hx⟩ := hNnonempty
    exact ⟨|‖Matrix.toEuclideanLin A x‖ - b|, x, hx, rfl⟩
  have hsup :
      sSup {a : ℝ | ∃ x ∈ (N : Set (EuclideanSpace ℝ (Fin n))),
        a = |‖Matrix.toEuclideanLin A x‖ - b|} ≤ u := by
    apply csSup_le hSne
    rintro a ⟨x, hx, rfl⟩
    exact hdev x hx
  intro x hx
  have hbound :=
    NumStability.HDP.Metric.norm_deviation_le_three_mul_inv_mul_sSup_net
      hn A b (1 / 4 : ℝ) (N : Set (EuclideanSpace ℝ (Fin n)))
      (by norm_num) (by norm_num) hNset x hx
  have hfactor : (3 : ℝ) * (1 - 2 * (1 / 4 : ℝ))⁻¹ = 6 := by norm_num
  rw [hfactor] at hbound
  exact hbound.trans (mul_le_mul_of_nonneg_left hsup (by norm_num))

/-- A finite quarter-net union bound for uniform unsquared action-norm deviation. -/
theorem exists_uniformNormDeviation_quarterNet_tail :
    ∃ c : ℝ, 0 < c ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ}
        (_hm : 0 < m) (_hn : 0 < n)
        (A : Ω → Matrix (Fin m) (Fin n) ℝ) {K : ℝ},
        0 < K →
        (∀ i j, Measurable (fun ω => A ω i j)) →
        (∀ i j, MemLp (fun ω => A ω i j) 2 μ) →
        (∀ i, NumStability.HDP.Vector.Isotropy.IsIsotropic μ
          (fun j ω => A ω i j)) →
        (∀ i, NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω => A ω i j) ≤ ENNReal.ofReal K) →
        iIndepFun (fun i ω => fun j => A ω i j) μ →
        ∀ (N : Finset (EuclideanSpace ℝ (Fin n))),
          NumStability.HDP.Metric.IsFiniteUnitSphereNet (1 / 4 : ℝ) N →
          N.Nonempty →
          ∀ {u : ℝ}, 0 ≤ u →
            μ.real {ω | ∃ x : EuclideanSpace ℝ (Fin n), ‖x‖ = 1 ∧
              6 * u < |‖Matrix.toEuclideanLin (A ω) x‖ - Real.sqrt (m : ℝ)|} ≤
              N.card * (2 * Real.exp (-(c * u ^ 2 / K ^ 4))) := by
  classical
  obtain ⟨c, hc, hfixed⟩ := exists_fixedDirection_normDeviation_tail
  refine ⟨c, hc, ?_⟩
  intro Ω instΩ μ instμ m n hm hn A K hK hMeas hLp hIso hPsi hIndep
    N hN hNnonempty u hu
  letI : Nonempty (Fin m) := ⟨⟨0, hm⟩⟩
  let p : ℝ := 2 * Real.exp (-(c * u ^ 2 / K ^ 4))
  let E : EuclideanSpace ℝ (Fin n) → Set Ω := fun x =>
    {ω | |‖Matrix.toEuclideanLin (A ω) x‖ - Real.sqrt (m : ℝ)| ≥ u}
  have hsingle : ∀ x ∈ N, μ.real (E x) ≤ p := by
    intro x hxN
    have hx : NumStability.vecNorm2 (fun j => x j) = 1 := by
      rw [← NumStability.HDP.Vector.Spherical.norm_toLp_eq_vecNorm2]
      simpa using hN.1 x hxN
    have htail := hfixed A hK hMeas hLp hIso hPsi hIndep (fun j => x j) hx hu
    simpa [E, p, ← NumStability.HDP.Vector.Spherical.norm_toLp_eq_vecNorm2]
      using htail
  have hsubset :
      {ω | ∃ x : EuclideanSpace ℝ (Fin n), ‖x‖ = 1 ∧
        6 * u < |‖Matrix.toEuclideanLin (A ω) x‖ - Real.sqrt (m : ℝ)|} ⊆
        ⋃ x ∈ N, E x := by
    rintro ω ⟨x, hx, hbad⟩
    by_contra hnot
    have hdev : ∀ y ∈ N,
        |‖Matrix.toEuclideanLin (A ω) y‖ - Real.sqrt (m : ℝ)| ≤ u := by
      intro y hy
      have hnmem : ω ∉ E y := by
        intro he
        exact hnot (by simp only [Set.mem_iUnion]; exact ⟨y, hy, he⟩)
      exact (lt_of_not_ge hnmem).le
    have hbound := unit_normDeviation_le_six_of_quarterNet_bound
      hn (A ω) (Real.sqrt (m : ℝ)) u N hN hNnonempty hdev x hx
    exact (not_lt_of_ge hbound) hbad
  exact (measureReal_mono hsubset (by
    exact ne_top_of_le_ne_top
      (show μ Set.univ ≠ (⊤ : ℝ≥0∞) by simp)
      (measure_mono (Set.subset_univ _)))).trans
    (NumStability.HDP.Probability.measureReal_biUnion_le N E p (by
      dsimp [p]; positivity) hsingle)

/-- Absorb a quarter-net's cardinality at the unsquared concentration scale. -/
theorem exists_constant_absorbing_nine_pow_norm_tail {c : ℝ} (hc : 0 < c) :
    ∃ C : ℝ, 0 < C ∧ ∀ (n : ℕ) {K t : ℝ}, 0 < K → 0 ≤ t →
      (9 ^ n : ℕ) *
        (2 * Real.exp (-(c * ((C / 6) * K ^ 2 *
          (Real.sqrt (n : ℝ) + t)) ^ 2 / K ^ 4))) ≤
        2 * Real.exp (-(t ^ 2)) := by
  let B : ℝ := Real.sqrt (10 / c)
  let C : ℝ := 6 * B
  have hB : 0 < B := Real.sqrt_pos.2 (div_pos (by norm_num) hc)
  have hBsq : B ^ 2 = 10 / c := Real.sq_sqrt (by positivity)
  refine ⟨C, by dsimp [C]; positivity, ?_⟩
  intro n K t hK ht
  have hsqrt : Real.sqrt (n : ℝ) ^ 2 = (n : ℝ) :=
    Real.sq_sqrt (Nat.cast_nonneg n)
  have hscale :
      c * ((C / 6) * K ^ 2 * (Real.sqrt (n : ℝ) + t)) ^ 2 / K ^ 4 =
        10 * (Real.sqrt (n : ℝ) + t) ^ 2 := by
    have hCB : C / 6 = B := by dsimp [C]; ring
    rw [hCB, mul_pow, mul_pow, ← pow_mul, hBsq]
    field_simp [hc.ne', hK.ne']
    ring
  have hexponent : 9 * (n : ℝ) + t ^ 2 ≤
      10 * (Real.sqrt (n : ℝ) + t) ^ 2 := by
    nlinarith [sq_nonneg t, Nat.cast_nonneg (α := ℝ) n,
      mul_nonneg (Real.sqrt_nonneg (n : ℝ)) ht]
  have h9 : (9 : ℝ) ≤ Real.exp 9 := by
    linarith [Real.add_one_le_exp (9 : ℝ)]
  have hpow : ((9 ^ n : ℕ) : ℝ) ≤ Real.exp (9 * (n : ℝ)) := by
    rw [Nat.cast_pow, Nat.cast_ofNat]
    calc
      (9 : ℝ) ^ n ≤ (Real.exp 9) ^ n :=
        pow_le_pow_left₀ (by norm_num) h9 n
      _ = Real.exp ((n : ℝ) * 9) := (Real.exp_nat_mul 9 n).symm
      _ = Real.exp (9 * (n : ℝ)) := by congr 1; ring
  rw [hscale]
  calc
    ((9 ^ n : ℕ) : ℝ) *
        (2 * Real.exp (-(10 * (Real.sqrt (n : ℝ) + t) ^ 2))) ≤
      Real.exp (9 * (n : ℝ)) *
        (2 * Real.exp (-(9 * (n : ℝ) + t ^ 2))) := by
          gcongr
    _ = 2 * Real.exp (-(t ^ 2)) := by
      rw [mul_left_comm _ 2, ← Real.exp_add]
      congr 2
      ring

/-- Uniform unsquared action-norm concentration via Theorem3.1.1 and Exercise4.4.4. -/
theorem exists_uniformNormDeviation_tail_of_independent_isotropic_subGaussian_rows :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ}
        (_hm : 0 < m) (_hn : 0 < n)
        (A : Ω → Matrix (Fin m) (Fin n) ℝ) {K : ℝ},
        0 < K →
        (∀ i j, Measurable (fun ω => A ω i j)) →
        (∀ i j, MemLp (fun ω => A ω i j) 2 μ) →
        (∀ i, NumStability.HDP.Vector.Isotropy.IsIsotropic μ
          (fun j ω => A ω i j)) →
        (∀ i, NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω => A ω i j) ≤ ENNReal.ofReal K) →
        iIndepFun (fun i ω => fun j => A ω i j) μ →
        ∀ {t : ℝ}, 0 ≤ t →
          μ.real {ω | ∃ x : EuclideanSpace ℝ (Fin n), ‖x‖ = 1 ∧
            C * K ^ 2 * (Real.sqrt (n : ℝ) + t) <
              |‖Matrix.toEuclideanLin (A ω) x‖ - Real.sqrt (m : ℝ)|} ≤
              2 * Real.exp (-(t ^ 2)) := by
  obtain ⟨c, hc, htail⟩ := exists_uniformNormDeviation_quarterNet_tail
  obtain ⟨C, hC, habsorb⟩ := exists_constant_absorbing_nine_pow_norm_tail hc
  refine ⟨C, hC, ?_⟩
  intro Ω instΩ μ instμ m n hm hn A K hK hMeas hLp hIso hPsi hIndep t ht
  obtain ⟨N, hN, hNnonempty, hcard⟩ :=
    NumStability.HDP.Metric.exists_quarterNet_card_le_nine_pow n hn
  let u : ℝ := (C / 6) * K ^ 2 * (Real.sqrt (n : ℝ) + t)
  have hu : 0 ≤ u := by dsimp [u]; positivity
  have hraw := htail hm hn A hK hMeas hLp hIso hPsi hIndep N hN hNnonempty hu
  have hfactor : 6 * u = C * K ^ 2 * (Real.sqrt (n : ℝ) + t) := by
    dsimp [u]
    ring
  rw [hfactor] at hraw
  refine hraw.trans ?_
  calc
    (N.card : ℝ) * (2 * Real.exp (-(c * u ^ 2 / K ^ 4))) ≤
      (9 ^ n : ℕ) * (2 * Real.exp (-(c * u ^ 2 / K ^ 4))) := by
        exact mul_le_mul_of_nonneg_right (Nat.cast_le.mpr hcard) (by positivity)
    _ ≤ 2 * Real.exp (-(t ^ 2)) := habsorb n hK ht

/-- Extreme singular-value concentration obtained by the alternative unsquared proof. -/
theorem exists_extremeSingularValue_tail_via_normConcentration :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ}
        (_hm : 0 < m)
        (A : Ω → Matrix (Fin m) (Fin (n + 1)) ℝ) {K : ℝ},
        1 ≤ K →
        (∀ i j, Measurable (fun ω => A ω i j)) →
        (∀ i j, MemLp (fun ω => A ω i j) 2 μ) →
        (∀ i j, ∫ ω, A ω i j ∂μ = 0) →
        (∀ i, NumStability.HDP.Vector.Isotropy.IsIsotropic μ
          (fun j ω => A ω i j)) →
        (∀ i, NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω => A ω i j) ≤ ENNReal.ofReal K) →
        iIndepFun (fun i ω => fun j => A ω i j) μ →
        ∀ {t : ℝ}, 0 ≤ t →
          μ.real {ω |
            Real.sqrt (m : ℝ) -
                  C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t) >
                NumStability.rectCourantFischerSingularValue
                  (A ω) (Fin.last n) ∨
              NumStability.rectCourantFischerSingularValue
                  (A ω) (0 : Fin (n + 1)) >
                Real.sqrt (m : ℝ) +
                  C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t)} ≤
            2 * Real.exp (-(t ^ 2)) := by
  classical
  obtain ⟨C, hC, htail⟩ :=
    exists_uniformNormDeviation_tail_of_independent_isotropic_subGaussian_rows
  refine ⟨C, hC, ?_⟩
  intro Ω instΩ μ instμ m n hm A K hK hMeas hLp _hMean hIso hPsi hIndep t ht
  have hKpos : 0 < K := lt_of_lt_of_le (by norm_num) hK
  have hraw := htail hm (Nat.succ_pos n) A hKpos hMeas hLp hIso hPsi hIndep ht
  have hsubset :
      {ω | Real.sqrt (m : ℝ) -
          C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t) >
            NumStability.rectCourantFischerSingularValue (A ω) (Fin.last n) ∨
          NumStability.rectCourantFischerSingularValue (A ω) (0 : Fin (n + 1)) >
            Real.sqrt (m : ℝ) + C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t)} ⊆
      {ω | ∃ x : EuclideanSpace ℝ (Fin (n + 1)), ‖x‖ = 1 ∧
        C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t) <
          |‖Matrix.toEuclideanLin (A ω) x‖ - Real.sqrt (m : ℝ)|} := by
    intro ω hbad
    by_contra hnot
    have hunit : ∀ x : EuclideanSpace ℝ (Fin (n + 1)), ‖x‖ = 1 →
        |‖Matrix.toEuclideanLin (A ω) x‖ - Real.sqrt (m : ℝ)| ≤
          C * K ^ 2 * (Real.sqrt (n + 1 : ℝ) + t) := by
      intro x hx
      exact le_of_not_gt (fun h => hnot ⟨x, hx, h⟩)
    have hb := NumStability.optimalExtremeSingularValueBounds_of_unit_normDeviation_le (A ω)
      (NumStability.rectCourantFischer_extremeSingularValues_areOptimalBounds (A ω)) hunit
    rcases hbad with hlow | hhigh
    · exact (not_lt_of_ge hb.1) hlow
    · exact (not_lt_of_ge hb.2) hhigh
  exact (measureReal_mono hsubset (by
    exact ne_top_of_le_ne_top
      (show μ Set.univ ≠ (⊤ : ℝ≥0∞) by simp)
      (measure_mono (Set.subset_univ _)))).trans (by
        simpa only [Nat.cast_succ] using hraw)

end NumStability.HDP.Matrix
