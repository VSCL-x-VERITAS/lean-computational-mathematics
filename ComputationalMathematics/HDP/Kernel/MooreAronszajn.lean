import ComputationalMathematics.HDP.Kernel.PositiveSemidefinite
import Mathlib.Analysis.InnerProductSpace.Completion
import Mathlib.Analysis.Normed.Operator.Extend
import Mathlib.LinearAlgebra.Finsupp.LinearCombination

/-!
# Moore--Aronszajn feature spaces

This module constructs a Hilbert-space feature representation from a real
positive-semidefinite kernel.  The algebraic kernel span is the finitely
supported function space on the input type.  Its possibly degenerate kernel
form supplies a pre-inner product; the separation quotient and completion
then give the required Hilbert space.
-/

noncomputable section

universe u

namespace NumStability.HDP.Kernel

open scoped RealInnerProductSpace

/-- The algebraic span of the feature vectors is dense in the ambient space. -/
def HasDenseFeatureSpan {X H : Type*} [NormedAddCommGroup H] [NormedSpace ℝ H]
    (Φ : X → H) : Prop :=
  DenseRange (Finsupp.linearCombination ℝ Φ)

/-- Evaluation of the function represented by `h` against a feature map. -/
def featureEvaluation {X H : Type*} [NormedAddCommGroup H]
    [InnerProductSpace ℝ H] (Φ : X → H) (h : H) (x : X) : ℝ :=
  inner ℝ h (Φ x)

/-- A real RKHS presentation: the kernel sections are realized by a feature
map and their algebraic span is dense.  The associated `featureEvaluation`
identifies the Hilbert space with a space of functions. -/
def IsRealReproducingKernelPresentation {X H : Type*}
    [NormedAddCommGroup H] [InnerProductSpace ℝ H]
    (K : X → X → ℝ) (Φ : X → H) : Prop :=
  IsRealFeatureMap K Φ ∧ HasDenseFeatureSpan Φ

theorem featureEvaluation_injective_of_dense {X H : Type*}
    [NormedAddCommGroup H] [InnerProductSpace ℝ H]
    {Φ : X → H} (hDense : HasDenseFeatureSpan Φ) :
    Function.Injective (featureEvaluation Φ) := by
  intro h₁ h₂ heval
  have hfeature (x : X) : inner ℝ (h₁ - h₂) (Φ x) = 0 := by
    rw [inner_sub_left]
    have hx := congrFun heval x
    change inner ℝ h₁ (Φ x) = inner ℝ h₂ (Φ x) at hx
    linarith
  have hcomb (f : X →₀ ℝ) :
      inner ℝ (h₁ - h₂) (Finsupp.linearCombination ℝ Φ f) = 0 := by
    classical
    rw [Finsupp.linearCombination_apply]
    rw [f.inner_sum]
    simp [inner_smul_right, hfeature]
  have hall (h : H) : inner ℝ (h₁ - h₂) h = 0 := by
    refine hDense.induction ?_ (isClosed_eq (by fun_prop) continuous_const) h
    rintro _ ⟨f, rfl⟩
    exact hcomb f
  have hself := hall (h₁ - h₂)
  have : h₁ - h₂ = 0 := inner_self_eq_zero.mp hself
  exact sub_eq_zero.mp this

theorem IsRealReproducingKernelPresentation.evaluation_feature
    {X H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℝ H]
    {K : X → X → ℝ} {Φ : X → H}
    (hΦ : IsRealReproducingKernelPresentation K Φ) (x y : X) :
    featureEvaluation Φ (Φ x) y = K x y :=
  hΦ.1 x y

theorem IsRealReproducingKernelPresentation.evaluation_injective
    {X H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℝ H]
    {K : X → X → ℝ} {Φ : X → H}
    (hΦ : IsRealReproducingKernelPresentation K Φ) :
    Function.Injective (featureEvaluation Φ) :=
  featureEvaluation_injective_of_dense hΦ.2

/-- The bilinear form on the algebraic span of formal kernel sections. -/
def kernelSpanInner {X : Type*} (K : X → X → ℝ)
    (f g : X →₀ ℝ) : ℝ :=
  f.sum fun x a ↦ g.sum fun y b ↦ a * K x y * b

/-- Positive-semidefinite kernels are symmetric. -/
theorem IsPositiveSemidefinite.symm {X : Type*} {K : X → X → ℝ}
    (hK : IsPositiveSemidefinite K) (x y : X) : K x y = K y x := by
  let u : Fin 2 → X := fun i ↦ if i = 0 then x else y
  have hHerm := (hK 2 u).isHermitian
  have hEntry := congrFun (congrFun hHerm (0 : Fin 2)) (1 : Fin 2)
  simpa [gramMatrix, u, Matrix.conjTranspose_apply] using hEntry.symm

theorem kernelSpanInner_symm {X : Type*} {K : X → X → ℝ}
    (hK : IsPositiveSemidefinite K) (f g : X →₀ ℝ) :
    kernelSpanInner K g f = kernelSpanInner K f g := by
  classical
  unfold kernelSpanInner
  rw [Finsupp.sum_comm]
  apply Finsupp.sum_congr
  intro x hx
  apply Finsupp.sum_congr
  intro y hy
  rw [hK.symm]
  ring

theorem kernelSpanInner_self_nonneg {X : Type*} {K : X → X → ℝ}
    (hK : IsPositiveSemidefinite K) (f : X →₀ ℝ) :
    0 ≤ kernelSpanInner K f f := by
  classical
  let p : X → Prop := fun x ↦ x ∈ f.support
  let f' : Subtype p →₀ ℝ := f.subtypeDomain p
  let e : Fin (Fintype.card (Subtype p)) ≃ Subtype p :=
    (Fintype.equivFin (Subtype p)).symm
  let u : Fin (Fintype.card (Subtype p)) → X := fun i ↦ (e i).1
  let c : Fin (Fintype.card (Subtype p)) →₀ ℝ :=
    Finsupp.equivFunOnFinite.symm fun i ↦ f (u i)
  have hnonneg :
      0 ≤ ∑ i, ∑ j, f (u i) * K (u i) (u j) * f (u j) := by
    simpa [Finsupp.sum_fintype, c, gramMatrix] using (hK _ u).2 c
  have hp : ∀ x ∈ f.support, p x := fun x hx ↦ hx
  unfold kernelSpanInner
  rw [← Finsupp.sum_subtypeDomain_index (p := p) (v := f)
    (h := fun x ax ↦ f.sum fun y ay ↦ ax * K x y * ay) hp]
  change 0 ≤ f'.sum fun x ax ↦ f.sum fun y ay ↦ ax * K x.1 y * ay
  have hrewrite (x : Subtype p) (ax : ℝ) :
      f.sum (fun y ay ↦ ax * K x.1 y * ay) =
        f'.sum (fun y ay ↦ ax * K x.1 y.1 * ay) := by
    symm
    exact Finsupp.sum_subtypeDomain_index
      (p := p) (v := f) (h := fun y ay ↦ ax * K x.1 y * ay) hp
  rw [Finsupp.sum_fintype f' _ (by intro x; simp)]
  simp only [f', Finsupp.subtypeDomain_apply]
  simp_rw [hrewrite]
  have hrewrite' (x : Subtype p) :
      f'.sum (fun y ay ↦ f x.1 * K x.1 y.1 * ay) =
        ∑ y : Subtype p, f x.1 * K x.1 y.1 * f y.1 := by
    rw [Finsupp.sum_fintype f' _ (by intro y; simp)]
    rfl
  simp_rw [hrewrite']
  rw [← e.sum_comp (fun x : Subtype p ↦
    ∑ y : Subtype p, f x.1 * K x.1 y.1 * f y.1)]
  convert hnonneg using 1
  apply Finset.sum_congr rfl
  intro i hi
  rw [← e.sum_comp (fun y : Subtype p ↦
    f (e i).1 * K (e i).1 y.1 * f y.1)]

/-- Pre-inner-product core induced by a positive-semidefinite kernel. -/
def kernelSpanCore {X : Type*} (K : X → X → ℝ)
    (hK : IsPositiveSemidefinite K) :
    PreInnerProductSpace.Core ℝ (X →₀ ℝ) where
  inner := kernelSpanInner K
  conj_inner_symm f g := by
    simpa using kernelSpanInner_symm hK f g
  re_inner_nonneg := kernelSpanInner_self_nonneg hK
  add_left f g h := by
    classical
    simp [kernelSpanInner, add_mul, Finsupp.sum_add_index]
  smul_left f g r := by
    classical
    unfold kernelSpanInner
    rw [Finsupp.sum_smul_index (h := fun x a ↦
      g.sum fun y b ↦ a * K x y * b) (by simp)]
    rw [starRingEnd_apply, star_trivial]
    change (f.sum fun x a ↦ g.sum fun y b ↦ (r * a) * K x y * b) =
      r • (f.sum fun x a ↦ g.sum fun y b ↦ a * K x y * b)
    rw [Finsupp.smul_sum]
    apply Finsupp.sum_congr
    intro x hx
    change (g.sum fun y b ↦ r * f x * K x y * b) =
      r • (g.sum fun y b ↦ f x * K x y * b)
    rw [Finsupp.smul_sum]
    apply Finsupp.sum_congr
    intro y hy
    simp only [smul_eq_mul]
    ring

/-- The seminormed algebraic kernel span. -/
abbrev KernelSpan {X : Type*} (K : X → X → ℝ)
    (hK : IsPositiveSemidefinite K) := X →₀ ℝ

namespace KernelSpan

variable {X : Type*} (K : X → X → ℝ) (hK : IsPositiveSemidefinite K)

local instance : SeminormedAddCommGroup (KernelSpan K hK) :=
  @InnerProductSpace.Core.toSeminormedAddCommGroup ℝ (KernelSpan K hK)
    inferInstance inferInstance inferInstance (kernelSpanCore K hK)

local instance : InnerProductSpace ℝ (KernelSpan K hK) :=
  InnerProductSpace.ofCore (kernelSpanCore K hK)

local instance : NormedSpace ℝ (KernelSpan K hK) :=
  InnerProductSpace.toNormedSpace

local instance : IsBoundedSMul ℝ (KernelSpan K hK) :=
  NormedSpace.toIsBoundedSMul

/-- The Hilbert completion of the nondegenerate quotient of the algebraic
kernel span. -/
abbrev Hilbert :=
  UniformSpace.Completion (SeparationQuotient (KernelSpan K hK))

/-- The canonical feature associated with a point of the kernel domain. -/
def feature (x : X) : Hilbert K hK :=
  ((SeparationQuotient.mk (Finsupp.single x 1) :
      SeparationQuotient (KernelSpan K hK)) : Hilbert K hK)

theorem feature_inner (x y : X) :
    inner ℝ (feature K hK x) (feature K hK y) = K x y := by
  simp only [feature, UniformSpace.Completion.inner_coe,
    SeparationQuotient.inner_mk_mk]
  change kernelSpanInner K (Finsupp.single x 1) (Finsupp.single y 1) = K x y
  simp [kernelSpanInner]

/-- The algebraic feature combination map into the completed kernel span. -/
def algebraicFeatureMap : KernelSpan K hK →ₗ[ℝ] Hilbert K hK :=
  Finsupp.linearCombination ℝ (feature K hK)

theorem algebraicFeatureMap_apply (f : KernelSpan K hK) :
    algebraicFeatureMap K hK f =
      ((SeparationQuotient.mk f : SeparationQuotient (KernelSpan K hK)) : Hilbert K hK) := by
  classical
  induction f using Finsupp.induction with
  | zero =>
      change (0 : Hilbert K hK) =
        ((0 : SeparationQuotient (KernelSpan K hK)) : Hilbert K hK)
      exact UniformSpace.Completion.coe_zero.symm
  | single_add x a f hxa hxf ih =>
      rw [map_add, ih]
      change (Finsupp.linearCombination ℝ (feature K hK)) (Finsupp.single x a) + _ = _
      rw [Finsupp.linearCombination_single]
      change a • ((SeparationQuotient.mk (Finsupp.single x 1) :
          SeparationQuotient (KernelSpan K hK)) : Hilbert K hK) +
          ((SeparationQuotient.mk f : SeparationQuotient (KernelSpan K hK)) :
            Hilbert K hK) = _
      have hq :
          a • (SeparationQuotient.mk (Finsupp.single x (1 : ℝ)) :
              SeparationQuotient (KernelSpan K hK)) +
              (SeparationQuotient.mk f : SeparationQuotient (KernelSpan K hK)) =
              (SeparationQuotient.mk (Finsupp.single x a + f) :
                SeparationQuotient (KernelSpan K hK)) := by
        calc
          _ = (SeparationQuotient.mk (a • Finsupp.single x (1 : ℝ)) :
                SeparationQuotient (KernelSpan K hK)) +
              (SeparationQuotient.mk f : SeparationQuotient (KernelSpan K hK)) := by
              rw [SeparationQuotient.mk_smul]
          _ = (SeparationQuotient.mk (a • Finsupp.single x (1 : ℝ) + f) :
              SeparationQuotient (KernelSpan K hK)) := by
              rw [SeparationQuotient.mk_add]
          _ = (SeparationQuotient.mk (Finsupp.single x a + f) :
              SeparationQuotient (KernelSpan K hK)) := by simp
      simpa only [UniformSpace.Completion.coe_add,
        UniformSpace.Completion.coe_smul] using
        congrArg (fun q : SeparationQuotient (KernelSpan K hK) ↦
          (q : Hilbert K hK)) hq

theorem algebraicFeatureMap_single (x : X) :
    algebraicFeatureMap K hK (Finsupp.single x 1) = feature K hK x := by
  simp [algebraicFeatureMap]

theorem denseRange_algebraicFeatureMap : DenseRange (algebraicFeatureMap K hK) := by
  have hrange : Set.range (algebraicFeatureMap K hK) =
      Set.range ((↑) : SeparationQuotient (KernelSpan K hK) → Hilbert K hK) := by
    ext z
    constructor
    · rintro ⟨f, rfl⟩
      exact ⟨SeparationQuotient.mk f, (algebraicFeatureMap_apply K hK f).symm⟩
    · rintro ⟨q, rfl⟩
      obtain ⟨f, rfl⟩ := SeparationQuotient.surjective_mk q
      exact ⟨f, algebraicFeatureMap_apply K hK f⟩
  rw [DenseRange, hrange]
  exact UniformSpace.Completion.denseRange_coe

theorem feature_dense : HasDenseFeatureSpan (feature K hK) := by
  change DenseRange (algebraicFeatureMap K hK)
  exact denseRange_algebraicFeatureMap K hK

end KernelSpan

/-- Moore--Aronszajn existence direction: every real positive-semidefinite
kernel admits a feature representation in a real Hilbert space. -/
theorem exists_hilbert_featureMap_of_isPositiveSemidefinite
    {X : Type u} {K : X → X → ℝ} (hK : IsPositiveSemidefinite K) :
    ∃ (H : Type u),
      ∃ (_ : NormedAddCommGroup H),
      ∃ (_ : InnerProductSpace ℝ H),
      ∃ (_ : CompleteSpace H),
      ∃ Φ : X → H, IsRealFeatureMap K Φ := by
  letI : SeminormedAddCommGroup (KernelSpan K hK) :=
    @InnerProductSpace.Core.toSeminormedAddCommGroup ℝ (KernelSpan K hK)
      inferInstance inferInstance inferInstance (kernelSpanCore K hK)
  letI : InnerProductSpace ℝ (KernelSpan K hK) :=
    InnerProductSpace.ofCore (kernelSpanCore K hK)
  let H := KernelSpan.Hilbert K hK
  refine ⟨H, inferInstance, inferInstance, inferInstance,
    KernelSpan.feature K hK, ?_⟩
  intro x y
  exact KernelSpan.feature_inner K hK x y

/-- Moore--Aronszajn characterization in feature-map form. -/
theorem isPositiveSemidefinite_iff_exists_hilbert_featureMap
    {X : Type u} (K : X → X → ℝ) :
    IsPositiveSemidefinite K ↔
      ∃ (H : Type u),
        ∃ (_ : NormedAddCommGroup H),
        ∃ (_ : InnerProductSpace ℝ H),
        ∃ (_ : CompleteSpace H),
        ∃ Φ : X → H, IsRealFeatureMap K Φ := by
  constructor
  · exact exists_hilbert_featureMap_of_isPositiveSemidefinite
  · rintro ⟨H, normH, innerH, completeH, Φ, hΦ⟩
    letI : NormedAddCommGroup H := normH
    letI : InnerProductSpace ℝ H := innerH
    exact hΦ.isPositiveSemidefinite

/-- The Moore--Aronszajn construction as an RKHS: the completed kernel-section
span is a Hilbert space, its sections reproduce `K`, and those sections have
dense span. -/
theorem exists_hilbert_reproducingKernel_of_isPositiveSemidefinite
    {X : Type u} {K : X → X → ℝ} (hK : IsPositiveSemidefinite K) :
    ∃ (H : Type u),
      ∃ (_ : NormedAddCommGroup H),
      ∃ (_ : InnerProductSpace ℝ H),
      ∃ (_ : CompleteSpace H),
      ∃ Φ : X → H, IsRealReproducingKernelPresentation K Φ := by
  letI : SeminormedAddCommGroup (KernelSpan K hK) :=
    @InnerProductSpace.Core.toSeminormedAddCommGroup ℝ (KernelSpan K hK)
      inferInstance inferInstance inferInstance (kernelSpanCore K hK)
  letI : InnerProductSpace ℝ (KernelSpan K hK) :=
    InnerProductSpace.ofCore (kernelSpanCore K hK)
  let H := KernelSpan.Hilbert K hK
  refine ⟨H, inferInstance, inferInstance, inferInstance,
    KernelSpan.feature K hK, ?_, KernelSpan.feature_dense K hK⟩
  intro x y
  exact KernelSpan.feature_inner K hK x y

theorem isPositiveSemidefinite_iff_exists_hilbert_reproducingKernel
    {X : Type u} (K : X → X → ℝ) :
    IsPositiveSemidefinite K ↔
      ∃ (H : Type u),
        ∃ (_ : NormedAddCommGroup H),
        ∃ (_ : InnerProductSpace ℝ H),
        ∃ (_ : CompleteSpace H),
        ∃ Φ : X → H, IsRealReproducingKernelPresentation K Φ := by
  constructor
  · exact exists_hilbert_reproducingKernel_of_isPositiveSemidefinite
  · rintro ⟨H, normH, innerH, completeH, Φ, hΦ⟩
    letI : NormedAddCommGroup H := normH
    letI : InnerProductSpace ℝ H := innerH
    exact hΦ.1.isPositiveSemidefinite

section Uniqueness

variable {X H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℝ H]
  {K : X → X → ℝ} {Φ : X → H}

theorem inner_linearCombination_eq_kernelSpanInner
    (hΦ : IsRealFeatureMap K Φ) (f g : X →₀ ℝ) :
    inner ℝ (Finsupp.linearCombination ℝ Φ f)
      (Finsupp.linearCombination ℝ Φ g) = kernelSpanInner K f g := by
  classical
  rw [Finsupp.linearCombination_apply, Finsupp.linearCombination_apply]
  rw [f.sum_inner]
  unfold kernelSpanInner
  apply Finsupp.sum_congr
  intro x hx
  rw [g.inner_sum]
  apply Finsupp.sum_congr
  intro y hy
  rw [inner_smul_left, inner_smul_right, hΦ]
  simp only [starRingEnd_apply, star_trivial]
  ring

namespace FeatureQuotient

variable (K Φ) (hK : IsPositiveSemidefinite K)

local instance : SeminormedAddCommGroup (KernelSpan K hK) :=
  @InnerProductSpace.Core.toSeminormedAddCommGroup ℝ (KernelSpan K hK)
    inferInstance inferInstance inferInstance (kernelSpanCore K hK)

local instance : InnerProductSpace ℝ (KernelSpan K hK) :=
  InnerProductSpace.ofCore (kernelSpanCore K hK)

local instance : NormedSpace ℝ (KernelSpan K hK) :=
  InnerProductSpace.toNormedSpace

local instance : IsBoundedSMul ℝ (KernelSpan K hK) :=
  NormedSpace.toIsBoundedSMul

theorem linearCombination_norm (hΦ : IsRealFeatureMap K Φ) (f : KernelSpan K hK) :
    ‖Finsupp.linearCombination ℝ Φ f‖ = ‖f‖ := by
  rw [← sq_eq_sq₀ (norm_nonneg _) (norm_nonneg _)]
  rw [@norm_sq_eq_re_inner ℝ H,
    @norm_sq_eq_re_inner ℝ (KernelSpan K hK)]
  exact inner_linearCombination_eq_kernelSpanInner hΦ f f

def algebraicCLM (hΦ : IsRealFeatureMap K Φ) : KernelSpan K hK →L[ℝ] H :=
  (Finsupp.linearCombination ℝ Φ).mkContinuous 1 fun f ↦ by
    simpa [linearCombination_norm K Φ hK hΦ f] using
      (le_refl ‖f‖)

def map (hΦ : IsRealFeatureMap K Φ) :
    SeparationQuotient (KernelSpan K hK) →L[ℝ] H :=
  SeparationQuotient.liftCLM (algebraicCLM K Φ hK hΦ)
    (fun f g hfg ↦ by
      apply eq_of_sub_eq_zero
      rw [← map_sub]
      apply norm_eq_zero.mp
      rw [show ‖algebraicCLM K Φ hK hΦ (f - g)‖ =
        ‖Finsupp.linearCombination ℝ Φ (f - g)‖ by rfl,
        linearCombination_norm K Φ hK hΦ]
      rw [← dist_eq_norm, ← Metric.inseparable_iff]
      exact hfg)

@[simp] theorem map_mk (hΦ : IsRealFeatureMap K Φ) (f : KernelSpan K hK) :
    map K Φ hK hΦ (SeparationQuotient.mk f) =
      Finsupp.linearCombination ℝ Φ f :=
  rfl

theorem map_norm (hΦ : IsRealFeatureMap K Φ)
    (q : SeparationQuotient (KernelSpan K hK)) :
    ‖map K Φ hK hΦ q‖ = ‖q‖ := by
  obtain ⟨f, rfl⟩ := SeparationQuotient.surjective_mk q
  rw [map_mk, linearCombination_norm K Φ hK hΦ,
    SeparationQuotient.norm_mk]

theorem map_denseRange (hΦ : IsRealFeatureMap K Φ)
    (hDense : HasDenseFeatureSpan Φ) :
    DenseRange (map K Φ hK hΦ) := by
  refine hDense.mono ?_
  rintro y ⟨f, rfl⟩
  exact ⟨SeparationQuotient.mk f, map_mk K Φ hK hΦ f⟩

end FeatureQuotient

/-- Uniqueness under the standard minimality assumption: two Hilbert feature
presentations with dense kernel-section spans are linearly isometric, and the
isometry identifies every kernel section. -/
theorem reproducingKernelPresentation_unique
    {H₁ H₂ : Type*}
    [NormedAddCommGroup H₁] [InnerProductSpace ℝ H₁] [CompleteSpace H₁]
    [NormedAddCommGroup H₂] [InnerProductSpace ℝ H₂] [CompleteSpace H₂]
    {Φ₁ : X → H₁} {Φ₂ : X → H₂}
    (h₁ : IsRealReproducingKernelPresentation K Φ₁)
    (h₂ : IsRealReproducingKernelPresentation K Φ₂) :
    ∃ e : H₁ ≃ₗᵢ[ℝ] H₂, ∀ x, e (Φ₁ x) = Φ₂ x := by
  let hK : IsPositiveSemidefinite K := h₁.1.isPositiveSemidefinite
  letI : SeminormedAddCommGroup (KernelSpan K hK) :=
    @InnerProductSpace.Core.toSeminormedAddCommGroup ℝ (KernelSpan K hK)
      inferInstance inferInstance inferInstance (kernelSpanCore K hK)
  letI : InnerProductSpace ℝ (KernelSpan K hK) :=
    InnerProductSpace.ofCore (kernelSpanCore K hK)
  letI : NormedSpace ℝ (KernelSpan K hK) := InnerProductSpace.toNormedSpace
  letI : IsBoundedSMul ℝ (KernelSpan K hK) := NormedSpace.toIsBoundedSMul
  let D := SeparationQuotient (KernelSpan K hK)
  let e₁ := FeatureQuotient.map K Φ₁ hK h₁.1
  let e₂ := FeatureQuotient.map K Φ₂ hK h₂.1
  have hd₁ : DenseRange e₁ :=
    FeatureQuotient.map_denseRange K Φ₁ hK h₁.1 h₁.2
  have hd₂ : DenseRange e₂ :=
    FeatureQuotient.map_denseRange K Φ₂ hK h₂.1 h₂.2
  have hn (q : D) : ‖e₂ q‖ = ‖e₁ q‖ := by
    rw [FeatureQuotient.map_norm, FeatureQuotient.map_norm]
  let e : H₁ ≃ₗᵢ[ℝ] H₂ :=
    (LinearEquiv.refl ℝ D).extendOfIsometry e₁.toLinearMap e₂.toLinearMap hd₁ hd₂ hn
  refine ⟨e, fun x ↦ ?_⟩
  have he := LinearEquiv.extendOfIsometry_eq (LinearEquiv.refl ℝ D)
    e₁.toLinearMap e₂.toLinearMap hd₁ hd₂ hn
    (SeparationQuotient.mk (Finsupp.single x 1 : KernelSpan K hK))
  have hm₁ : e₁ (SeparationQuotient.mk
      (Finsupp.single x 1 : KernelSpan K hK)) = Φ₁ x := by
    simp [e₁]
  have hm₂ : e₂ (SeparationQuotient.mk
      (Finsupp.single x 1 : KernelSpan K hK)) = Φ₂ x := by
    simp [e₂]
  change e (e₁ (SeparationQuotient.mk
      (Finsupp.single x 1 : KernelSpan K hK))) =
      e₂ (SeparationQuotient.mk
        (Finsupp.single x 1 : KernelSpan K hK)) at he
  rw [hm₁, hm₂] at he
  exact he

end Uniqueness

end NumStability.HDP.Kernel
