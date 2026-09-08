# Equation (1.4): explicit bridge from a given acoustic system

This is a bounded implementation review and source-contract draft. It does not
replace the frozen rejected audit, rerun any judge, or assert a new faithfulness
verdict. The original target and every production file remain unchanged.

## Source and finding addressed

The immutable source is LeVeque, *Finite Volume Methods for Hyperbolic Problems*,
with SHA-256 `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`.
The rendered printed pages 2 and 3 / raw PDF pages 24 and 25 were inspected.
Printed page 2 introduces equation (1.4) as a right-going acoustic model and
identifies its variable as a pressure--particle-velocity combination. The same
page explicitly gives `w¹ = p + ρ c u`, `c = sqrt(K/ρ)`, and derives its positive
speed one-way equation from the pressure--velocity system (1.5). Printed page 3
continues the two-mode interpretation and distinguishes the constant linear
model from nonlinear physical coupling.

The original frozen task is
`LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908`. Its task, decision, report,
direct judge, round-trip judge, and source contract were read. The decision is
`not-faithful-weaker`, accepted false, with matching direct and round-trip
classifications. Its principal missing item is a bridge from a given acoustic
field to the scalar variable, not a sign or calculus correction. The exact
manifest, decision and report hashes were verified against the parent-provided
pins; `input-receipt.json` records those and the source/producer bytes.

The draft retains the selected right-going paragraph, equation (1.4), and its
interpretation as the anchor. It uses the explicit acoustic connection on the
same printed page as supporting context; it does not narrow the anchor to the
abstract scalar equation or replace the given-system claim by a special wave.

## Exact coverage retained and added

`leveque01_equation04_acousticOneWayModel` has two parts.

1. For **every** real `c > 0`, the complete old scalar statement is retained:
   the scalar coefficient matrix is hyperbolic; `x + c*t` increases strictly
   with time; and every profile differentiable at the tested characteristic
   coordinate satisfies the pointwise equation and translated shape identity.
   This whole part is supplied by the unchanged
   `leveque01_equation04_scalarHyperbolicOneWayModel`, without specialization
   to a single material or loss of the local derivative premise.
2. For **every given** `LinearAcousticsSolution K ρ` with positive `K` and `ρ`,
   the theorem constructs `c` and `w`, states `c = sqrt(K/ρ)` and `c > 0`,
   explicitly identifies `w(x,t) = pressure(x,t) + ρ*c*velocity(x,t)`, and proves
   the pointwise one-way equation for that same `w` at every real `x,t`.
   The witnesses use the actual pressure and particle-velocity fields carried
   by the supplied acoustic system; neither their scalar PDE nor the desired
   acoustic combination is assumed in the theorem's premises.

The general positive-speed part applies in particular to the constructed
positive sound speed. The given-system part applies to arbitrary certified
classical acoustic fields, including ones not presented as traveling profiles.
The distinction between sound speed and particle velocity is explicit in the
types and identity.

## Reuse and implementation choice

Fresh scoped `rg` queries searched the canonical library, compatibility tree,
and pinned Mathlib before the draft was written. Raw terms, roots, results and
return codes are in `reuse-searches.json`. No match for the proposed new wrapper
name was found; this is only a scoped name-search result.

The existing source producer `leveque01_acousticsRightMode` already proves the
required sound-speed positivity and one-way PDE for the right invariant of an
actual given acoustic system. It uses the source-independent
`linearAcousticsRightInvariant_isLinearAdvectionSolutionAt`, which constructs
the needed derivatives from the acoustic system and proves their algebraic
balance under `K = ρ*c²`. Its source wrapper supplies the square-root material
identity for positive coefficients. These are reused directly; there is no
new duplicate calculus, square-root, or acoustic-system proof.

The draft's six-line proof combines the complete old scalar producer, the
existing acoustic-mode producer, and definitional identification of the actual
right invariant. A new reusable acoustics module was unnecessary. The selected
canonical draft is the single source leaf
`ComputationalMathematics/Source/LeVeque/Chapter01/Equation04AcousticModel.lean`.
Its imports are the unchanged `Equation04Model` and `AcousticsModes` source
leaves; it adds no Analysis-to-Source dependency or parent-file/directory
collision.

The existing matrix/eigenmode producers were also inspected as possible
nonvacuity support. A separate constructed traveling pressure--velocity family
would only cover special solutions and would not repair the given-system
finding. Because the required general bridge is an exact existing producer,
no duplicate traveling-wave construction is introduced in the source contract.

## Explicit mathematical limits

The given-system certificate is a global classical solution on real space and
time: its `satisfies` field supplies actual partial-derivative witnesses at every
point. The retained profile clause remains local and conditional on a genuine
profile derivative. Neither clause silently uses a totalized derivative at a
nondifferentiable point. No weak-solution or discontinuous-solution extension is
claimed here.

Positive bulk modulus and density are explicit mathematical assumptions for
the physically intended material regime and square-root/division formulas.
The printed passage names the material quantities and asserts positive
right-going speed, but does not separately spell out both inequalities; this
domain choice remains visible for the independent audit. The theorem does not
claim empirical accuracy, a bound comparing particle velocity with sound speed,
a nonlinear physical derivation, arbitrary initial-value existence, uniqueness,
or boundary-value well-posedness.

Production placement, canonical build, source auditing, gate binding, tier
metadata and chapter completion remain the root coordinator's responsibility.
The native scratch output and exact axiom checks are proof evidence only.
