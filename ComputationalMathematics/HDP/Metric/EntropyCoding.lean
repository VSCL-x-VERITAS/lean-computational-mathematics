import ComputationalMathematics.HDP.Metric.Entropy
import Mathlib.Data.Fintype.EquivFin

/-!
# Metric codes and covering numbers

The two finite-cardinality implications underlying Vershynin's metric-entropy
and coding comparison.  They are stated before taking least bit lengths and
base-two logarithms, so the boundary cases at infinity remain explicit.
-/

noncomputable section

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Metric

/-- An `N`-bit metric code whose fibers have diameter at most `ε` produces
an internal `ε`-cover with at most `2^N` centers. -/
theorem coveringNumber_le_two_pow_of_isMetricCode
    {T : Type*} [PseudoEMetricSpace T] {K : Set T} {ε : ℝ≥0} {N : ℕ}
    (hcode : IsMetricCode K ε N) :
    Metric.coveringNumber ε K ≤ (2 ^ N : ℕ) := by
  classical
  rcases hcode with ⟨encode, hencode⟩
  rcases K.eq_empty_or_nonempty with rfl | hK
  · simp
  let x₀ : K := ⟨hK.choose, hK.choose_spec⟩
  let center : Fin (2 ^ N) → K := fun b ↦
    if h : ∃ x : K, encode x = b then Classical.choose h else x₀
  let C : Set T := Set.range fun b ↦ (center b : T)
  have hcenter_mem (b : Fin (2 ^ N)) : (center b : T) ∈ K := (center b).2
  have hCsubset : C ⊆ K := by
    rintro y ⟨b, rfl⟩
    exact hcenter_mem b
  have hcenter_code (x : K) : encode (center (encode x)) = encode x := by
    have hfound : ∃ y : K, encode y = encode x := ⟨x, rfl⟩
    dsimp [center]
    rw [dif_pos hfound]
    exact Classical.choose_spec hfound
  have hcover : Metric.IsCover ε K C := by
    intro x hx
    let xK : K := ⟨x, hx⟩
    refine ⟨(center (encode xK) : T), ⟨encode xK, rfl⟩, ?_⟩
    exact hencode xK (center (encode xK)) (hcenter_code xK).symm
  apply (hcover.coveringNumber_le_encard hCsubset).trans
  calc
    C.encard ≤ (Set.univ : Set (Fin (2 ^ N))).encard := by
      simpa [C, Set.image_univ] using
        (Set.encard_image_le (fun b : Fin (2 ^ N) ↦ (center b : T)) Set.univ)
    _ = (2 ^ N : ℕ) := by simp

/-- An internal `ε/2`-cover with at most `2^N` centers gives an `N`-bit code
whose fibers have diameter at most `ε`. -/
theorem isMetricCode_of_coveringNumber_half_le_two_pow
    {T : Type*} [PseudoEMetricSpace T] {K : Set T} {ε : ℝ≥0} {N : ℕ}
    (hcovering : Metric.coveringNumber (ε / 2) K ≤ (2 ^ N : ℕ)) :
    IsMetricCode K ε N := by
  classical
  have hfinite : Metric.coveringNumber (ε / 2) K ≠ ⊤ :=
    ne_top_of_le_ne_top (by simp) hcovering
  let C : Set T := Metric.minimalCover (ε / 2) K
  have hCfin : C.Finite := Metric.finite_minimalCover
  letI : Fintype C := hCfin.fintype
  have hCcard : Fintype.card C ≤ 2 ^ N := by
    have hencard : C.encard ≤ (2 ^ N : ℕ∞) := by
      rw [Metric.encard_minimalCover hfinite]
      exact hcovering
    rw [hCfin.encard_eq_coe_toFinset_card] at hencard
    have hnat : hCfin.toFinset.card ≤ 2 ^ N := ENat.coe_le_coe.mp hencard
    simpa [← Nat.card_coe_set_eq, Nat.card_eq_fintype_card] using hnat
  let embed : C → Fin (2 ^ N) := fun c ↦
    Fin.castLE hCcard (Fintype.equivFin C c)
  have hembed : Function.Injective embed :=
    (Fin.castLE_injective hCcard).comp (Fintype.equivFin C).injective
  have hcover : Metric.IsCover (ε / 2) K C :=
    Metric.isCover_minimalCover hfinite
  let center : K → C := fun x ↦
    ⟨(Classical.choose (hcover x.2)),
      (Classical.choose_spec (hcover x.2)).1⟩
  have hcenter_dist (x : K) :
      edist (x : T) (center x : T) ≤ (ε / 2 : ℝ≥0) :=
    (Classical.choose_spec (hcover x.2)).2
  refine ⟨fun x ↦ embed (center x), ?_⟩
  intro x y hxy
  have hcenters : center x = center y := hembed hxy
  calc
    edist (x : T) y ≤ edist (x : T) (center x : T) +
        edist (center x : T) y := edist_triangle _ _ _
    _ ≤ (ε / 2 : ℝ≥0) + (ε / 2 : ℝ≥0) := by
      gcongr
      · exact hcenter_dist x
      · rw [hcenters]
        simpa [edist_comm] using hcenter_dist y
    _ = ε := by simp

end NumStability.HDP.Metric
