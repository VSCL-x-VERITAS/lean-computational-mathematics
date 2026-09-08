import ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw

open MeasureTheory

namespace NumStability.Chapter01Scratch

/-- A classical balance equation with a specified internal production vector. -/
def IsBalanceLawSolutionAt {m : ℕ}
    (q : ℝ → ℝ → (Fin m → ℝ)) (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (production : Fin m → ℝ) (x t : ℝ) : Prop :=
  ∃ qt fluxx : Fin m → ℝ,
    HasDerivAt (fun τ => q x τ) qt t ∧
      HasDerivAt (fun ξ => flux (q ξ t)) fluxx x ∧ qt + fluxx = production

theorem balanceLaw_source_eq_zero_of_conservationLaw {m : ℕ}
    {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    {production : Fin m → ℝ} {x t : ℝ}
    (hbalance : IsBalanceLawSolutionAt q flux production x t)
    (hconservation : IsConservationLawSolutionAt q flux x t) : production = 0 := by
  rcases hbalance with ⟨qt, fx, ht, hx, hsource⟩
  rcases hconservation with ⟨qt', fx', ht', hx', hzero⟩
  rw [ht.unique ht', hx.unique hx'] at hsource
  exact hsource.symm.trans hzero

theorem integral_internalProduction_eq_massDefect {m : ℕ}
    (q : ℝ → ℝ → (Fin m → ℝ)) (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (qt fluxx : ℝ → (Fin m → ℝ)) (a b t : ℝ) (massRate : Fin m → ℝ)
    (hfluxx : ∀ x, HasDerivAt (fun ξ => flux (q ξ t)) (fluxx x) x)
    (hqtIntegrable : IntervalIntegrable qt volume a b)
    (hfluxxIntegrable : IntervalIntegrable fluxx volume a b)
    (hmassRate : HasDerivAt (fun τ => ∫ x in a..b, q x τ) massRate t)
    (hinterchange : HasDerivAt (fun τ => ∫ x in a..b, q x τ) (∫ x in a..b, qt x) t) :
    (∫ x in a..b, qt x + fluxx x) = massRate - (flux (q a t) - flux (q b t)) := by
  rw [intervalIntegral.integral_add hqtIntegrable hfluxxIntegrable,
    hinterchange.unique hmassRate,
    intervalIntegral.integral_eq_sub_of_hasDerivAt (fun x _ => hfluxx x) hfluxxIntegrable]
  abel

/-- When the mass rate differs from net boundary inflow, the classical balance
requires nonzero internal production. Boundary transport is explicitly removed
before identifying production. -/
theorem nonconservation_requires_nonzero_source {m : ℕ}
    (q : ℝ → ℝ → (Fin m → ℝ)) (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (qt fluxx : ℝ → (Fin m → ℝ)) (a b t : ℝ) (massRate : Fin m → ℝ)
    (hqt : ∀ x, HasDerivAt (fun τ => q x τ) (qt x) t)
    (hfluxx : ∀ x, HasDerivAt (fun ξ => flux (q ξ t)) (fluxx x) x)
    (hqtIntegrable : IntervalIntegrable qt volume a b)
    (hfluxxIntegrable : IntervalIntegrable fluxx volume a b)
    (hmassRate : HasDerivAt (fun τ => ∫ x in a..b, q x τ) massRate t)
    (hinterchange : HasDerivAt (fun τ => ∫ x in a..b, q x τ) (∫ x in a..b, qt x) t)
    (hdefect : massRate ≠ flux (q a t) - flux (q b t)) :
    ∃ production : ℝ → (Fin m → ℝ),
      (∀ x, IsBalanceLawSolutionAt q flux (production x) x t) ∧
      IntervalIntegrable production volume a b ∧
      (∫ x in a..b, production x) = massRate - (flux (q a t) - flux (q b t)) ∧
      production ≠ 0 ∧ ¬ (∀ x, IsConservationLawSolutionAt q flux x t) := by
  let production := fun x => qt x + fluxx x
  have hbalance := integral_internalProduction_eq_massDefect q flux qt fluxx a b t massRate
    hfluxx hqtIntegrable hfluxxIntegrable hmassRate hinterchange
  have hpoint (x : ℝ) : IsBalanceLawSolutionAt q flux (production x) x t :=
    ⟨qt x, fluxx x, hqt x, hfluxx x, rfl⟩
  have hnonzero : production ≠ 0 := by
    intro hzero
    have hintegral : (∫ x in a..b, production x) = 0 := by rw [hzero]; simp
    exact hdefect (sub_eq_zero.mp (hbalance.symm.trans hintegral))
  refine ⟨production, hpoint, hqtIntegrable.add hfluxxIntegrable, hbalance, hnonzero, ?_⟩
  intro hconservation
  apply hnonzero
  funext x
  exact balanceLaw_source_eq_zero_of_conservationLaw (hpoint x) (hconservation x)

/-- Every source field giving the same actual balance equation has the same
net production, measured by the mass rate minus endpoint transport. -/
theorem integral_any_source_eq_massDefect {m : ℕ}
    (q : ℝ → ℝ → (Fin m → ℝ)) (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (qt fluxx source : ℝ → (Fin m → ℝ)) (a b t : ℝ) (massRate : Fin m → ℝ)
    (hqt : ∀ x, HasDerivAt (fun τ => q x τ) (qt x) t)
    (hfluxx : ∀ x, HasDerivAt (fun ξ => flux (q ξ t)) (fluxx x) x)
    (hqtIntegrable : IntervalIntegrable qt volume a b)
    (hfluxxIntegrable : IntervalIntegrable fluxx volume a b)
    (hmassRate : HasDerivAt (fun τ => ∫ x in a..b, q x τ) massRate t)
    (hinterchange : HasDerivAt (fun τ => ∫ x in a..b, q x τ) (∫ x in a..b, qt x) t)
    (hsource : ∀ x, IsBalanceLawSolutionAt q flux (source x) x t) :
    IntervalIntegrable source volume a b ∧
      (∫ x in a..b, source x) = massRate - (flux (q a t) - flux (q b t)) := by
  have heq : source = fun x => qt x + fluxx x := by
    funext x
    rcases hsource x with ⟨qt', fx', ht', hx', hs⟩
    rw [(hqt x).unique ht', (hfluxx x).unique hx']
    exact hs.symm
  rw [heq]
  exact ⟨hqtIntegrable.add hfluxxIntegrable,
    integral_internalProduction_eq_massDefect q flux qt fluxx a b t massRate
      hfluxx hqtIntegrable hfluxxIntegrable hmassRate hinterchange⟩

/-- Uniform production at unit rate is an explicit nonvacuous instance. The
transport velocity is zero, the mass in a unit cell grows at unit rate, and
the source is the actual PDE residual rather than an assumed certificate. -/
theorem uniform_unit_production_nonvacuity (t : ℝ) :
    (∀ x, IsBalanceLawSolutionAt
      (fun (_x : ℝ) (τ : ℝ) (_i : Fin 1) => τ)
      (fun (_state : Fin 1 → ℝ) => 0) (fun _ => 1) x t) ∧
    HasDerivAt (fun τ => ∫ _x in (0 : ℝ)..1, (fun _i : Fin 1 => τ))
      (fun _ => 1) t ∧
    (∫ _x in (0 : ℝ)..1, (fun _i : Fin 1 => (1 : ℝ))) ≠ 0 := by
  have htime : HasDerivAt (fun τ : ℝ => fun _i : Fin 1 => τ) (fun _ => 1) t :=
    hasDerivAt_pi.mpr fun _ => hasDerivAt_id t
  refine ⟨?_, ?_, ?_⟩
  · intro x
    refine ⟨fun _ => 1, 0, htime, hasDerivAt_const x 0, ?_⟩
    simp
  · simpa using htime
  · have hne : (fun _i : Fin 1 => (1 : ℝ)) ≠ 0 := by
      intro hzero
      exact one_ne_zero (congrFun hzero 0)
    simpa using hne

#print axioms integral_any_source_eq_massDefect
#print axioms uniform_unit_production_nonvacuity
#print axioms integral_internalProduction_eq_massDefect
#print axioms balanceLaw_source_eq_zero_of_conservationLaw
#print axioms nonconservation_requires_nonzero_source

end NumStability.Chapter01Scratch
