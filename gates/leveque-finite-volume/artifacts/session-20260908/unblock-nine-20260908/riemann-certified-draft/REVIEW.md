# Certified information routine repair — coordinator review

This scratch packet adds a Riemann-solving relation to the existing information
routine. It preserves every existing production definition and source wrapper.
It is implementation preparation, not a fresh source-faithfulness judgment. This
review includes repair rationale and should not be supplied to isolated audit roles.

The exact new property is:

```lean
def Routine.HasRiemannAccuracy (routine : Routine law Result Information)
    (errorBound : Problem law → ℝ) : Prop :=
  ∀ problem admitted, ∃ reference : Reference problem,
    ‖routine.flux problem admitted - reference.meanFlux‖ ≤ errorBound problem
```

The quantified `Reference problem` retains the same law, ordered initial states
and positive finite horizon. Its existing fields record initial data, admissible
positive-time states, spatial and face integrability, and rectangle conservation
within that horizon. Accuracy is a property of a supplied routine on its explicit
execution domain. It does not require the numerical result to return a field,
exact equal-state consistency, universal solution availability for arbitrary laws,
an entropy/uniqueness theorem, convergence, or a prescribed tolerance.

Reuse is direct. `Method.toRoutine_hasRiemannAccuracy` reuses `Method.accurate`
after forgetting the old method's consistency certificate. The new comparison
lemma reuses `Routine.reference_comparison`. The new local interface theorem
reuses `routine_local_interface_contract` for every existing normalization,
physical conservation sign, weighted error identity and direct physical error
bound. Its added conclusion supplies actual left and right references from the
new property and exposes both initial-data facts, both finite-slab rectangle
identities, mean-flux normalization, nonnegative tolerances, certified flux errors
and reference-to-physical error propagation.

The prospective primary
`NumStability.leveque01_certifiedRiemannRoutineInterface_sourceContract`
specializes the same general theorem to actual `q(·,s)`, `q(·,t)`,
`law.flux(q(a,·))`, and `law.flux(q(b,·))`. It requires only the selected cell's two
slice integrabilities, two face integrabilities, and rectangle identity, together
with the two actual execution-domain admissions. It contains no unconditional
arbitrary-law biased-routine existence clause. The supplied certification directly
links each selected solve/extract/numerical-flux execution to its reference.

The scalar fixture uses the existing proper state set [0,1], unit transport flux,
and existing genuine Riemann reference. For every admitted problem, every bias
has certified flux error exactly its norm, by `BiasedLocalRiemannRoutine.actual_error`.
The 1/2-biased routine is therefore certified while still violating exact
equal-state consistency. The whole new primary is actually applied to the same
routine at both nonconstant neighboring problems, with states 0,1,0 and horizon
1−0. The physical density is constant 1 on the selected cell/slab, with its actual
physical flux. All physical premises are discharged. A consumer extracts both
references directly from that primary application; this is not a collection of
separate inhabitants. Additional checks show both reference errors equal 1/2 and
the actual update error equals 1.

Source boundaries remain unchanged: the primary selection is the interface
Riemann/information/flux/update workflow on raw pages 26–27, with explicitly
inherited equation (1.10) context on raw page 26. Existing renderings 26,27,28 were
inspected; neighboring assertions are not added to the selected claim. Q7 remains
the coordinator's recorded conditional old-average/physical-flux error convention,
distinct from the user's literal rectangle-conservation interpretation. No receipt
is enlarged and no fresh audit result is anticipated. The previous completed audit
remains unchanged; its unresolved Riemann-process finding motivates this explicit
certificate rather than a reinterpretation of unrestricted routines.

The four fragments are prospective additive owners:

| Fragment | Proposed owner | New declarations |
|---|---|---:|
| Accuracy | `Analysis/PartialDifferentialEquations/FiniteVolume/LocalRiemannRoutineAccuracy.lean` | 3 |
| Update | `Analysis/PartialDifferentialEquations/FiniteVolume/CertifiedRiemannRoutineUpdate.lean` | 1 |
| Source | `Source/LeVeque/Chapter01/RiemannCertifiedRoutineInterface.lean` | 1 |
| First namespace of Examples | `Analysis/PartialDifferentialEquations/FiniteVolume/Examples/BiasedCertifiedRiemannRoutine.lean` | 2 |

The seven `CertifiedRiemannRoutineDraft` declarations remain separate applicability
evidence. Production placement, imports, tiers, stage, gate and new audits remain
root-owned. `receipt.json` identifies the sole final passing native run and exact
input/output hashes. Earlier failed scratch runs are retained and are not proof
receipts for the final artifacts.
