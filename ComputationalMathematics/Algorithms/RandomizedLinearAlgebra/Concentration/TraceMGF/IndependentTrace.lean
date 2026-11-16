import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.IndependentTrace
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Concentration.TraceMGF.UniformRows

/-! # Matrix trace-MGF adapters for a supplied finite iid law -/
namespace NumStability.FiniteProbability
open scoped BigOperators ComplexOrder

/-- Appending one iid draw factors its probability. -/
theorem iid_prob_snoc {Ω : Type*} [Fintype Ω] (P : FiniteProbability Ω)
    {steps : ℕ} (pref : Fin steps → Ω) (lastSample : Ω) :
    (P.iid (steps + 1)).prob (Fin.snoc pref lastSample) =
      (P.iid steps).prob pref * P.prob lastSample := by
  classical
  change (∏ t : Fin (steps + 1), P.prob ((Fin.snoc pref lastSample : Fin (steps + 1) → Ω) t)) = _
  rw [Fin.prod_univ_castSucc]
  simp [iid, Fin.snoc_castSucc, Fin.snoc_last]

/-- Conditioning an iid trace on its last draw. -/
theorem iid_expectationReal_succ_last_eq
    {Ω : Type*} [Fintype Ω] (P : FiniteProbability Ω) {steps : ℕ}
    (F : (Fin steps → Ω) → Ω → ℝ) :
    (P.iid (steps + 1)).expectationReal
      (fun samples =>
        F (Fin.init samples) (samples (Fin.last steps))) =
    (P.iid steps).expectationReal
      (fun pref =>
        P.expectationReal
          (fun lastSample => F pref lastSample)) := by
  classical
  let e :
      Ω × (Fin steps → Ω) ≃
        (Fin (steps + 1) → Ω) :=
    Fin.snocEquiv (fun _ : Fin (steps + 1) => Ω)
  unfold FiniteProbability.expectationReal iid
  calc
    ∑ samples : (Fin (steps + 1) → Ω),
        (P.iid (steps + 1)).prob samples *
          F (Fin.init samples) (samples (Fin.last steps))
        = ∑ p : Ω × (Fin steps → Ω),
            (P.iid (steps + 1)).prob (Fin.snoc p.2 p.1) *
              F p.2 p.1 := by
            symm
            refine Fintype.sum_equiv e
              (fun p : Ω × (Fin steps → Ω) =>
                (P.iid (steps + 1)).prob (Fin.snoc p.2 p.1) * F p.2 p.1)
              (fun samples : (Fin (steps + 1) → Ω) =>
                (P.iid (steps + 1)).prob samples *
                  F (Fin.init samples) (samples (Fin.last steps))) ?_
            intro p
            have hp :
                ((Fin.snocEquiv
                    (fun _ : Fin (steps + 1) => Ω)) p) =
                  Fin.snoc p.2 p.1 := by
              rfl
            rw [hp]
            simp [Fin.init_snoc, Fin.snoc_last]
    _ = ∑ p : Ω × (Fin steps → Ω),
          ((P.iid steps).prob p.2 * P.prob p.1) *
            F p.2 p.1 := by
            apply Finset.sum_congr rfl
            intro p _
            rw [iid_prob_snoc]
    _ = ∑ pref : (Fin steps → Ω),
          (P.iid steps).prob pref *
            (∑ lastSample : Ω,
              P.prob lastSample * F pref lastSample) := by
            rw [Fintype.sum_prod_type_right]
            apply Finset.sum_congr rfl
            intro pref _
            rw [Finset.mul_sum]
            apply Finset.sum_congr rfl
            intro lastSample _
            ring

theorem iid_expectationReal_trace_normed_exp_add_sum_le
    {Ω : Type*} [Fintype Ω] (P : FiniteProbability Ω) {steps : ℕ}
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    {H : CStarMatrix ι ι ℂ} (hH : IsSelfAdjoint H)
    {X : Ω → CStarMatrix ι ι ℂ}
    (hX : ∀ i, IsSelfAdjoint (X i)) :
    (P.iid steps).expectationReal
      (fun samples =>
        (cstarMatrixTrace
          (NormedSpace.exp
            (H + ∑ t : Fin steps, X (samples t)))).re) ≤
    (cstarMatrixTrace
      (NormedSpace.exp
        (H + ∑ _t : Fin steps,
          CFC.log
            (P.expectationCStarMatrix
              (fun i => NormedSpace.exp (X i)))))).re := by
  classical
  induction steps generalizing H with
  | zero =>
      exact le_of_eq (by
        simpa using
          (FiniteProbability.expectationReal_const
            (P.iid 0)
            ((cstarMatrixTrace (NormedSpace.exp H)).re)))
  | succ steps ih =>
      let K : CStarMatrix ι ι ℂ :=
        CFC.log
          (P.expectationCStarMatrix
            (fun i => NormedSpace.exp (X i)))
      have hsplit :
          (P.iid (steps + 1)).expectationReal
            (fun samples =>
              (cstarMatrixTrace
                (NormedSpace.exp
                  (H + ∑ t : Fin (steps + 1), X (samples t)))).re) =
          (P.iid steps).expectationReal
            (fun pref =>
              P.expectationReal
                (fun lastSample =>
                  (cstarMatrixTrace
                    (NormedSpace.exp
                      (H + (∑ t : Fin steps, X (pref t) + X lastSample)))).re)) := by
        calc
          (P.iid (steps + 1)).expectationReal
              (fun samples =>
                (cstarMatrixTrace
                  (NormedSpace.exp
                    (H + ∑ t : Fin (steps + 1), X (samples t)))).re)
              =
            (P.iid (steps + 1)).expectationReal
              (fun samples =>
                (cstarMatrixTrace
                  (NormedSpace.exp
                    (H + (∑ t : Fin steps, X (Fin.init samples t) +
                      X (samples (Fin.last steps)))))).re) := by
                apply congrArg
                funext samples
                congr 3
                rw [Fin.sum_univ_castSucc]
                simp [Fin.init]
          _ =
            (P.iid steps).expectationReal
              (fun pref =>
                P.expectationReal
                  (fun lastSample =>
                    (cstarMatrixTrace
                      (NormedSpace.exp
                        (H + (∑ t : Fin steps, X (pref t) + X lastSample)))).re)) := by
              simpa using
                iid_expectationReal_succ_last_eq
                  P
                  (fun pref lastSample =>
                    (cstarMatrixTrace
                      (NormedSpace.exp
                        (H + (∑ t : Fin steps, X (pref t) + X lastSample)))).re)
      have hstep :
          ∀ pref : (Fin steps → Ω),
            P.expectationReal
              (fun lastSample =>
                (cstarMatrixTrace
                  (NormedSpace.exp
                    (H + (∑ t : Fin steps, X (pref t) + X lastSample)))).re) ≤
            (cstarMatrixTrace
              (NormedSpace.exp
                (H + ∑ t : Fin steps, X (pref t) + K))).re := by
        intro pref
        let Hpref : CStarMatrix ι ι ℂ :=
          H + ∑ t : Fin steps, X (pref t)
        have hHpref : IsSelfAdjoint Hpref := by
          exact hH.add
            (cstarMatrix_finset_sum_isSelfAdjoint
              (s := (Finset.univ : Finset (Fin steps)))
              (F := fun t : Fin steps => X (pref t))
              (fun t _ => hX (pref t)))
        have hbase :=
          FiniteProbability.expectationReal_trace_normed_exp_add_le
            P hHpref hX
        simpa [Hpref, K, add_assoc] using hbase
      have hmono :
          (P.iid steps).expectationReal
            (fun pref =>
              P.expectationReal
                (fun lastSample =>
                  (cstarMatrixTrace
                    (NormedSpace.exp
                      (H + (∑ t : Fin steps, X (pref t) + X lastSample)))).re)) ≤
          (P.iid steps).expectationReal
            (fun pref =>
              (cstarMatrixTrace
                (NormedSpace.exp
                  (H + ∑ t : Fin steps, X (pref t) + K))).re) := by
        apply FiniteProbability.expectationReal_mono
        intro pref
        exact hstep pref
      have hih :
          (P.iid steps).expectationReal
            (fun pref =>
              (cstarMatrixTrace
                (NormedSpace.exp
                  ((H + K) + ∑ t : Fin steps, X (pref t)))).re) ≤
          (cstarMatrixTrace
            (NormedSpace.exp
              ((H + K) + ∑ _t : Fin steps, K))).re := by
        have hHK : IsSelfAdjoint (H + K) :=
          hH.add (cstarMatrix_log_isSelfAdjoint _)
        exact ih hHK
      have hrewrite_left :
          (P.iid steps).expectationReal
            (fun pref =>
              (cstarMatrixTrace
                (NormedSpace.exp
                  (H + ∑ t : Fin steps, X (pref t) + K))).re) =
          (P.iid steps).expectationReal
            (fun pref =>
              (cstarMatrixTrace
                (NormedSpace.exp
                  ((H + K) + ∑ t : Fin steps, X (pref t)))).re) := by
        apply congrArg
        funext pref
        congr 3
        ac_rfl
      have hrewrite_right :
          (cstarMatrixTrace
            (NormedSpace.exp
              ((H + K) + ∑ _t : Fin steps, K))).re =
          (cstarMatrixTrace
            (NormedSpace.exp
              (H + ∑ _t : Fin (steps + 1), K))).re := by
        dsimp [K]
        congr 3
        rw [Fin.sum_univ_castSucc]
        ac_rfl
      calc
        (P.iid (steps + 1)).expectationReal
          (fun samples =>
            (cstarMatrixTrace
              (NormedSpace.exp
                (H + ∑ t : Fin (steps + 1), X (samples t)))).re)
            =
          (P.iid steps).expectationReal
            (fun pref =>
              P.expectationReal
                (fun lastSample =>
                  (cstarMatrixTrace
                    (NormedSpace.exp
                      (H + (∑ t : Fin steps, X (pref t) + X lastSample)))).re)) := hsplit
        _ ≤
          (P.iid steps).expectationReal
            (fun pref =>
              (cstarMatrixTrace
                (NormedSpace.exp
                  (H + ∑ t : Fin steps, X (pref t) + K))).re) := hmono
        _ =
          (P.iid steps).expectationReal
            (fun pref =>
              (cstarMatrixTrace
                (NormedSpace.exp
                  ((H + K) + ∑ t : Fin steps, X (pref t)))).re) := hrewrite_left
        _ ≤
          (cstarMatrixTrace
            (NormedSpace.exp
              ((H + K) + ∑ _t : Fin steps, K))).re := hih
        _ =
          (cstarMatrixTrace
            (NormedSpace.exp
              (H + ∑ _t : Fin (steps + 1), K))).re := hrewrite_right

/-- Real finite-trace version of the iid finite trace-MGF adapter. -/
theorem iid_expectationReal_finiteTrace_finiteMatrixExp_add_sum_le
    {Ω : Type*} [Fintype Ω] (P : FiniteProbability Ω) {steps : ℕ}
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    {H : ι → ι → ℝ} (hH : IsSymmetricFiniteMatrix H)
    {X : Ω → ι → ι → ℝ}
    (hX : ∀ i, IsSymmetricFiniteMatrix (X i)) :
    (P.iid steps).expectationReal
      (fun samples =>
        finiteTrace
          (finiteMatrixExp
            (fun a b : ι => H a b + ∑ t : Fin steps, X (samples t) a b))) ≤
    (cstarMatrixTrace
      (NormedSpace.exp
        (finiteComplexCStarMatrix H + ∑ _t : Fin steps,
          CFC.log
            (P.expectationCStarMatrix
              (fun i =>
                NormedSpace.exp (finiteComplexCStarMatrix (X i))))))).re := by
  classical
  let Q := P.iid steps
  let Hc : CStarMatrix ι ι ℂ := finiteComplexCStarMatrix H
  let Xc : Ω → CStarMatrix ι ι ℂ :=
    fun i => finiteComplexCStarMatrix (X i)
  have hembed :
      ∀ samples : (Fin steps → Ω),
        finiteComplexCStarMatrix
          (fun a b : ι => H a b + ∑ t : Fin steps, X (samples t) a b) =
        Hc + ∑ t : Fin steps, Xc (samples t) := by
    intro samples
    calc
      finiteComplexCStarMatrix
          (fun a b : ι => H a b + ∑ t : Fin steps, X (samples t) a b)
          =
        finiteComplexCStarMatrix H +
          finiteComplexCStarMatrix
            (fun a b : ι => ∑ t : Fin steps, X (samples t) a b) := by
            rw [finiteComplexCStarMatrix_add]
      _ = Hc + ∑ t : Fin steps, Xc (samples t) := by
            dsimp [Hc, Xc]
            rw [show
                finiteComplexCStarMatrix
                    (fun a b : ι => ∑ t : Fin steps, X (samples t) a b) =
                  ∑ t : Fin steps,
                    finiteComplexCStarMatrix (X (samples t)) by
              simpa using
                (finiteComplexCStarMatrix_finset_sum
                  (s := (Finset.univ : Finset (Fin steps)))
                  (F := fun t : Fin steps => X (samples t)))]
  have htrace_eq :
      Q.expectationReal
        (fun samples =>
          finiteTrace
            (finiteMatrixExp
              (fun a b : ι => H a b + ∑ t : Fin steps, X (samples t) a b))) =
      Q.expectationReal
        (fun samples =>
          (cstarMatrixTrace
            (NormedSpace.exp
              (Hc + ∑ t : Fin steps, Xc (samples t)))).re) := by
    unfold Q FiniteProbability.expectationReal
    apply Finset.sum_congr rfl
    intro samples _
    have hsample :
        finiteTrace
            (finiteMatrixExp
              (fun a b : ι => H a b + ∑ t : Fin steps, X (samples t) a b)) =
          (cstarMatrixTrace
            (NormedSpace.exp
              (Hc + ∑ t : Fin steps, Xc (samples t)))).re := by
      rw [← cstarMatrixTrace_normed_exp_finiteComplexCStarMatrix_re
        (fun a b : ι => H a b + ∑ t : Fin steps, X (samples t) a b)]
      rw [hembed samples]
    simpa using
      congrArg (fun z => (P.iid steps).prob samples * z) hsample
  rw [htrace_eq]
  have hHc : IsSelfAdjoint Hc := by
    dsimp [Hc]
    exact finiteComplexCStarMatrix_isSelfAdjoint_of_symmetric H hH
  have hXc : ∀ i, IsSelfAdjoint (Xc i) := by
    intro i
    dsimp [Xc]
    exact finiteComplexCStarMatrix_isSelfAdjoint_of_symmetric (X i) (hX i)
  simpa [Hc, Xc, Q] using
    (iid_expectationReal_trace_normed_exp_add_sum_le
      (steps := steps) P (H := Hc) hHc (X := Xc) hXc)

/-- Scalar trace-MGF log-bound functional for iid finite row sampling. -/
noncomputable def iidFiniteRealTraceMGFLogBound
    {Ω : Type*} [Fintype Ω] (P : FiniteProbability Ω) {steps : ℕ}
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (H : ι → ι → ℝ)
    (X : Ω → ι → ι → ℝ) : ℝ :=
  (cstarMatrixTrace
    (NormedSpace.exp
      (finiteComplexCStarMatrix H + ∑ _t : Fin steps,
          CFC.log
            (P.expectationCStarMatrix
              (fun i =>
                NormedSpace.exp (finiteComplexCStarMatrix (X i))))))).re

/-- Scalar trace-MGF bound from a one-step logarithmic-CGF Loewner bound for
iid finite row sampling. -/
theorem iidFiniteRealTraceMGFLogBound_zero_le_card_mul_exp_of_log_le_real_smul_one
    {Ω : Type*} [Fintype Ω] (P : FiniteProbability Ω) {steps : ℕ}
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (X : Ω → ι → ι → ℝ) {c : ℝ}
    (hK :
      CFC.log
          (P.expectationCStarMatrix
            (fun i =>
              NormedSpace.exp (finiteComplexCStarMatrix (X i)))) ≤
        (c : ℂ) • (1 : CStarMatrix ι ι ℂ)) :
    iidFiniteRealTraceMGFLogBound
      (steps := steps) P
      (fun _a _b : ι => 0) X ≤
      (Fintype.card ι : ℝ) * Real.exp ((steps : ℝ) * c) := by
  classical
  let K : CStarMatrix ι ι ℂ :=
    CFC.log
      (P.expectationCStarMatrix
        (fun i =>
          NormedSpace.exp (finiteComplexCStarMatrix (X i))))
  have hKsa : IsSelfAdjoint K := by
    dsimp [K]
    exact cstarMatrix_log_isSelfAdjoint _
  have hsumsa :
      IsSelfAdjoint
        (finiteComplexCStarMatrix (fun _a _b : ι => 0) +
          ∑ _t : Fin steps, K) := by
    have hzero : IsSelfAdjoint (finiteComplexCStarMatrix (fun _a _b : ι => 0)) := by
      rw [finiteComplexCStarMatrix_zero]
      simp
    exact hzero.add
      (cstarMatrix_finset_sum_isSelfAdjoint
        (s := (Finset.univ : Finset (Fin steps)))
        (F := fun _t : Fin steps => K)
        (fun _t _ht => hKsa))
  have hsumLe :
      finiteComplexCStarMatrix (fun _a _b : ι => 0) + ∑ _t : Fin steps, K ≤
        (((steps : ℝ) * c : ℝ) : ℂ) • (1 : CStarMatrix ι ι ℂ) := by
    rw [finiteComplexCStarMatrix_zero, zero_add]
    have hsum :
        (∑ _t : Fin steps, K) ≤
          ∑ _t : Fin steps, ((c : ℂ) • (1 : CStarMatrix ι ι ℂ)) := by
      exact Finset.sum_le_sum (fun _t _ht => by simpa [K] using hK)
    refine hsum.trans ?_
    rw [cstarMatrix_fin_sum_const_complex_smul_one]
    simp [mul_comm]
  simpa [iidFiniteRealTraceMGFLogBound, K] using
    cstarMatrixTrace_normedSpace_exp_re_le_card_mul_exp_of_le_real_smul_one
      hsumsa hsumLe


end NumStability.FiniteProbability
