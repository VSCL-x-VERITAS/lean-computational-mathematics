# Prospective left-mode contract and separate applicability evidence

This is a prospective alternative, not an adopted source target or an independent
faithfulness verdict. The user interpretation request
call_ctzCZ7YK8zbx2yUzmX59YBdC remains unanswered. Conventions adopted for other
transport rows are not adopted here by implication.

## General mathematical contract already checked

The retained formal declaration is
NumStability.LeftModeDomainsDraft.leftMode_solutionDomains from the frozen
left-mode-domain-draft/candidate.lean, SHA256
6084110138b1c51ef783797a1dfe442ef9dbd5985daaa5919610e665cd9de92e.
Its complete bytes, including its original checks, are included unchanged in the
new candidate. The composition adds only imports and separate witness declarations.
There is no new proof of a general domain characterization.

For an actual LinearAcousticsSolution K rho and K>0, rho>0, let c=sqrt(K/rho).
The contract gives c>0 and the classical transport equation at speed -c for the
actual left invariant p-rho*c*u. Separately, for every real scalar profile f:

- f(x+ct) is the chosen translated field;
- the value initially at x remains at x-ct;
- the translated field is a global classical advection solution exactly when
  f is differentiable everywhere;
- it is a rectangle conservation-law solution exactly when f is integrable on
  every bounded interval.

The given acoustic system and the independently quantified profile are distinct
binders. The statement does not identify every arbitrary profile with that given
system's invariant. Rectangle conservation includes the existing spatial and
temporal slice-integrability requirements; it is not silently identified with
the pointwise-in-time derivative in printed Eq1.10.

## Acoustic-system applicability witness

The new fixture has K=rho=1, pressure p(x,t)=x+t and velocity u(x,t)=-(x+t).
It carries actual derivatives pt=px=1 and ut=ux=-1, hence both acoustic residuals
vanish everywhere. Both fields are jointly C-infinity on the full plane and
nonconstant. Its principal sound speed is exactly 1, and its actual left invariant
is the equality of functions

    p - rho*c*u = travelingWave (fun x => 2*x) (-1).

The invariant's classical PDE is obtained from the retained given-system producer.
acoustic_nonvacuity supplies an existential actual acoustic solution with these
explicit fields, smoothness, nonconstancy, and invariant identity.
This is applicability/nonvacuity evidence, not a claim that this particular
unbounded example is a source-imposed physical experiment or approximation model.

Precisely, the native fixture proves ContDiff with order
(top : WithTop ENat). In this pinned Mathlib this is the analytic order omega,
stronger than C-infinity. Both affine fields meet that stronger fixture property.
This is concrete example evidence, not an additional regularity hypothesis on
the prospective general source statement. regularity-note.json binds the inspected
Mathlib definition and notation.

## Independent nonsmooth-profile evidence

For f(x)=abs(x), continuous_abs and the existing interval-integrability producer
establish integrability on every bounded interval. The canonical rectangle-domain
characterization gives conservation of abs(x+t) with physical scalar flux -q.
The canonical classical-domain characterization and Mathlib's
not_differentiableAt_abs_zero show that it is not a global classical solution.
A direct specialization of the actual derivative predicate also shows failure at
(x,t)=(0,0). This profile is continuous with a corner, not a discontinuous step.

Its value still follows the left-going characteristic, and its restriction to
each characteristic has derivative zero. The existing arbitrary-profile
characteristic theorem supplies that fact; it is not mistaken for existence
of separate partial derivatives.

The additional theorem abs_not_classical_acoustic_leftInvariant makes the role
separation precise: no system in the existing globally classical
LinearAcousticsSolution 1 1 class has abs(x+t) as this left invariant. It does not
exclude weak acoustic fields in a different solution class.

## Source boundary retained

The actual pinned rendering printed p2/raw24 defines w2=p-rho*c*u and its equation
w2_t-c*w2_x=0, then writes q2(x,t)=qtilde(x+ct) in the following profile sentence.
The symbol change is retained as an explicit q2/w2 ambiguity; this evidence
does not silently correct it or identify the two symbols.

The old sealed audit LEV-CH01-ACOUSTICS-LEFT-MODE-CANONICAL-20260908 remains
undetermined, accepted=false. Its principal unresolved finding was exhaustive
profile/solution-domain interpretation. It also retained the difference between
positive material parameters and the algebraically larger positive-ratio domain.
This prospective alternative preserves the frozen draft's individual positive
K and rho assumptions; it does not resolve that interpretation either.

The mathematical benefit is concrete: there is an actual smooth acoustic fixture
and an inhabited strict difference between the classical and rectangle profile
classes. Whether these are the intended exhaustive meanings of the printed
sentence is still a source/interpretation question for the coordinator and user.
