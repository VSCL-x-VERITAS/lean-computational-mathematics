import ComputationalMathematics.Source.LeVeque.Chapter01.FiniteVolumeLocalFluxUpdate

set_option pp.universes false
set_option pp.proofs false

-- Definition bodies and theorem types only; no target proof is printed.
#print Pi.seminormedAddGroup
#print Pi.seminormedAddCommGroup
#print Pi.nonUnitalSeminormedRing
#print Pi.seminormedRing
#print Pi.normedAddGroup
#print Pi.normedAddCommGroup
#print Pi.normedRing
#print NormedAddGroup.toENormedAddMonoid
#print NormedAddCommGroup.toENormedAddCommMonoid
#print SeminormedAddGroup.toContinuousENorm
#check @Pi.norm_def
#check @Pi.nnnorm_def
#check @pi_norm_le_iff_of_nonneg
#check @pi_norm_le_iff_of_nonempty
#check @norm_le_pi_norm
#check @Real.norm_eq_abs
#check @ofReal_norm_eq_enorm
#check @norm_smul

namespace FiniteRealVectorNormEvidence

theorem ring_norm_eq_addCommGroup_norm (m : ℕ) :
    (Pi.normedRing (R := fun _ : Fin m => ℝ)).toNorm =
      (Pi.normedAddCommGroup (G := fun _ : Fin m => ℝ)).toNorm := rfl

theorem ring_norm_eq_addGroup_norm (m : ℕ) :
    (Pi.normedRing (R := fun _ : Fin m => ℝ)).toNorm =
      (Pi.normedAddGroup (G := fun _ : Fin m => ℝ)).toNorm := rfl

theorem ring_norm_eq_sup (m : ℕ) (v : Fin m → ℝ) :
    @Norm.norm _ (Pi.normedRing (R := fun _ : Fin m => ℝ)).toNorm v =
      (↑(Finset.univ.sup fun i => ‖v i‖₊) : ℝ) := Pi.norm_def v

theorem ring_norm_le_iff_abs (m : ℕ) (v : Fin m → ℝ) (r : ℝ) (hr : 0 ≤ r) :
    @Norm.norm _ (Pi.normedRing (R := fun _ : Fin m => ℝ)).toNorm v ≤ r ↔
      ∀ i, |v i| ≤ r := by
  simpa only [Real.norm_eq_abs] using pi_norm_le_iff_of_nonneg (x := v) hr

theorem ring_norm_le_iff_abs_of_pos {m : ℕ} (hm : 0 < m) (v : Fin m → ℝ) (r : ℝ) :
    @Norm.norm _ (Pi.normedRing (R := fun _ : Fin m => ℝ)).toNorm v ≤ r ↔
      ∀ i, |v i| ≤ r := by
  letI : Nonempty (Fin m) := ⟨⟨0, hm⟩⟩
  simpa only [Real.norm_eq_abs] using pi_norm_le_iff_of_nonempty v (r := r)

theorem ofReal_ring_norm_eq_enorm (m : ℕ) (v : Fin m → ℝ) :
    ENNReal.ofReal (@Norm.norm _ (Pi.normedRing (R := fun _ : Fin m => ℝ)).toNorm v) =
      ‖v‖ₑ := ofReal_norm_eq_enorm v

theorem ring_norm_smul (m : ℕ) (c : ℝ) (v : Fin m → ℝ) :
    @Norm.norm _ (Pi.normedRing (R := fun _ : Fin m => ℝ)).toNorm (c • v) =
      |c| * @Norm.norm _ (Pi.normedRing (R := fun _ : Fin m => ℝ)).toNorm v := by
  simpa only [Real.norm_eq_abs] using norm_smul c v

theorem integral_enorm_eq_ring_norm (m : ℕ) (v : Fin m → ℝ) :
    @ENorm.enorm _ (@NormedAddGroup.toENormedAddMonoid _
      (Pi.normedAddGroup (G := fun _ : Fin m => ℝ))).toENorm v =
      ENNReal.ofReal (@Norm.norm _ (Pi.normedRing (R := fun _ : Fin m => ℝ)).toNorm v) :=
  (ofReal_norm_eq_enorm v).symm

theorem generic_integral_enorm_eq_ring_norm (m : ℕ) (v : Fin m → ℝ) :
    @ENorm.enorm _ (@NormedAddCommGroup.toENormedAddCommMonoid _
      (Pi.normedAddCommGroup (G := fun _ : Fin m => ℝ))).toENorm v =
      ENNReal.ofReal (@Norm.norm _ (Pi.normedRing (R := fun _ : Fin m => ℝ)).toNorm v) :=
  (ofReal_norm_eq_enorm v).symm

#check ring_norm_eq_addCommGroup_norm
#check ring_norm_eq_addGroup_norm
#check ring_norm_eq_sup
#check ring_norm_le_iff_abs
#check ring_norm_le_iff_abs_of_pos
#check ofReal_ring_norm_eq_enorm
#check ring_norm_smul
#check integral_enorm_eq_ring_norm
#check generic_integral_enorm_eq_ring_norm

set_option pp.all true in
#check ring_norm_eq_addCommGroup_norm
set_option pp.all true in
#check ring_norm_eq_addGroup_norm
set_option pp.all true in
#check ofReal_ring_norm_eq_enorm
set_option pp.all true in
#check integral_enorm_eq_ring_norm
set_option pp.all true in
#check generic_integral_enorm_eq_ring_norm

#print axioms ring_norm_eq_addCommGroup_norm
#print axioms ring_norm_eq_addGroup_norm
#print axioms ring_norm_eq_sup
#print axioms ring_norm_le_iff_abs
#print axioms ring_norm_le_iff_abs_of_pos
#print axioms ofReal_ring_norm_eq_enorm
#print axioms ring_norm_smul
#print axioms integral_enorm_eq_ring_norm
#print axioms generic_integral_enorm_eq_ring_norm
#print axioms Pi.norm_def
#print axioms Pi.nnnorm_def
#print axioms pi_norm_le_iff_of_nonneg
#print axioms pi_norm_le_iff_of_nonempty
#print axioms norm_le_pi_norm
#print axioms Real.norm_eq_abs
#print axioms ofReal_norm_eq_enorm
#print axioms norm_smul

end FiniteRealVectorNormEvidence
