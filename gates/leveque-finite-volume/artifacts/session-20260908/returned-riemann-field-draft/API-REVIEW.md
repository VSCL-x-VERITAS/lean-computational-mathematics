# Proof-free API review — returned Riemann fields

This is an implementation scope review, not an independent or blind source audit.
The final native output contains the elaborated structure fields, all 24 authored
declaration signatures and their axiom reports, plus nine selected producer checks.
The formulas below describe those contracts without presenting their proofs.

## Method and execution

`FieldFluxMethod law Result Information` is polymorphic in the dependent result
family and information type. The law uses the existing finite-vector, globally
differentiable, pointwise real-hyperbolic representation. It is not an arbitrary
flux function disguised as a hyperbolic law.

The method supplies an explicit admissible-problem predicate and a solver only
on that domain. A result projects to a field with exactly the ordered initial
Riemann data away from the origin. The origin value is free. Its physical flux at
the local interface x=0 must be interval-integrable on each supplied finite time
interval. There is no spatial integrability or conservation requirement on the
returned field after time zero. The result type may retain extra wave data or an
exact certificate. Initial-data and trace properties apply to every inhabitant
of each result type; no inhabitant is required for an inadmissible problem.

The extractor consumes that very result. The actual interface flux is
`numericalFlux (extract (solve (old[j-1], old[j]) hdomain[j]))`.
Constant problems are admitted and their selected executions yield the physical
constant-state flux. This does not imply an accuracy estimate at unequal states.

`ofExact` retains the original exact method's domain, solver, certificate result,
extractor and flux. `ofExact_interfaceFlux` and `ofExact_returnedField` identify
both observations by definitional equality; no certificate is reconstructed from
an arbitrary field, and the original exact API remains unchanged.

## Error statements

The trace-only theorem allows any complete real normed vector space E. On s<t,
let L and P be interval-integrable local and physical traces. If for each time in
the oriented half-open interval,

    norm(N - L(tau)) <= a,   norm(L(tau) - P(tau)) <= b,

then `norm(N - average(P,s,t)) <= a+b`. Neither a field nor a local PDE
certificate is needed. Bounds a,b are arbitrary real parameters; their meaningful
nonnegativity follows when their premises hold on this nonempty interval.

The field-method specialization takes an independent global rectangle-conserved
field q, positive dt, and any fixed numerical old array admitted at its interfaces.
Its local trace is the physical flux of the actual returned field. It concludes
a bound a+b against the physical time-average at the corresponding global face.
It does not infer that global q agrees with the neighboring Riemann states.

The update specialization additionally assumes old numerical cell error <= e,
and the two trace bounds at all faces. It concludes

    next cell error <= e + dt/width[i] *
      ((a[i]+b[i]) + (a[i+1]+b[i+1])).

The grid supplies positive widths and correctly adjoining left/right interfaces.
The numerical old array is independent of the exact cell averages of q. The
bound is a one-step implication; the constant rule used to instantiate the
existing update theorem is fixed only at this admitted old array. No admissibility
of other arrays, CFL property, stability, convergence, or accuracy order follows.

## Nonexact witness

`Witness.transportLaw` has identity physical flux, hence unit-speed vector
transport. `Witness.method` admits every ordered pair and returns a subtype whose
value is the actual stationary field `riemannData left left right x`. Its subtype
equality certifies this explicit construction only, not a desired PDE or error
conclusion. The extractor reads that returned field at (0,1).

For unequal left and right states the stationary return fails the original
rectangle law. A concrete one-component problem with left=0 and right=1 makes
this nonvacuous. The independent `reference` translates exactly at speed one,
has the same ordered initial data, and satisfies the original rectangle law.
For all x,t, the stationary/reference state error is at most norm(left-right).
That bound is proved from the explicit fields, not postulated.

At every positive time the stationary and exact local reference traces at x=0
agree; the selected numerical flux is exactly the physical returned trace. Thus
a nonexact field may nevertheless deliver an exact interface flux for this
particular transport problem. This is not a nonlinear approximate solver, an
arbitrary-accuracy approximation for a fixed jump, or a global finite-volume
accuracy theorem. The witness deliberately separates these claims.

## Remaining source boundary

The old frozen rejection is preserved. Printed p5/raw27 describes the ordered
solve/information/flux/update workflow and qualitative physical-flux approximation.
Printed p6/raw28 explicitly describes approximate Riemann solvers, but is additional
context beyond that rejection's p4-5 locator. This generic adapter accommodates
nonexact returned fields without selecting the source's quantitative meaning of
adequacy or the temporal interpretation of Eq1.10. No source wrapper or acceptance
claim is included.
