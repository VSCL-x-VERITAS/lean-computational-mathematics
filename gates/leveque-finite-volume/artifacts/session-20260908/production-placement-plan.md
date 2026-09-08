# Placement decisions for checked Chapter 1 prerequisites

Production files have not yet changed. The checked candidates are retained as
scratch evidence. The initial whole-library build is still running against
the unchanged production tree, and sealed audits of existing owners remain
bound to those exact files. The following additions can preserve those owners
and their existing public imports.

| Mathematical content | Intended canonical placement |
| --- | --- |
| Generic oriented rectangle conservation and translated profiles | `ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaw/Rectangle.lean` |
| Locally integrable Riemann profiles and explicit finite eigenmode solution | `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LinearRiemannSolution.lean` |
| Eigenbasis coordinate matrix action and arbitrary-field PDE equivalence | `ComputationalMathematics/Analysis/PartialDifferentialEquations/Hyperbolicity/EigenbasisCoordinates.lean` |
| Actual balance equation, arbitrary-source mass defect and homogeneous-law exclusion | `ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaw/BalanceLaw.lean` |
| Fixed-density transport-flux representation and coefficient constancy | `ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaw/VariableCoefficient.lean` |
| Pointwise/domain classification of actual flux derivatives | `ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaw/Hyperbolicity.lean` |
| Second-order principal part and positive wave discriminant | `ComputationalMathematics/Analysis/PartialDifferentialEquations/SecondOrder/Classification.lean` |
| Generic equation-plus-Riemann-data predicate and product data | `ComputationalMathematics/Analysis/PartialDifferentialEquations/InitialValue/Riemann.lean` |
| Positive-time similarity profile and selected ray values | `ComputationalMathematics/Analysis/PartialDifferentialEquations/InitialValue/SelfSimilarity.lean` |
| Moving-step mass derivative counterexample | A reusable conservation-law example leaf, with a distinct source witness/correction wrapper after adjudication |
| Explicit Huber-flux smooth-data shock | Separate generic flux/solution leaves once the complete continuation is checked; source wrapper and independent audit remain necessary |

Source correspondence and constructed source witnesses belong in thin
`ComputationalMathematics/Source/LeVeque/Chapter01/` leaves. In particular,
equation (1.5) and (1.10) definition iff statements can use new `Equation05Definition`
and `Equation10Definition` leaves importing their existing owners, instead of
altering those owners and invalidating prepared dependency manifests.
The one-step statement directly reuses `Function.FactorsThrough` and
`Function.factorsThrough_iff`; it needs only a source wrapper.

The positive smooth variable-coefficient existential witness should stay in
its source leaf while the generic obstruction lemmas live in Analysis. Its
scalar hyperbolicity producer currently belongs to the existing
`Source/LeVeque/Chapter01/ScalarHyperbolicity.lean`; an Analysis leaf must not
import that Source owner. This placement reuses the integrated theorem without
copying its proof or changing its accepted audit's exact owner bytes.

Copied rectangle preludes in the Riemann, moving-step, and Huber scratch files
must be replaced by imports of a single canonical owner. The two source-term
scratch versions likewise consolidate into one producer. Scratch namespaces
are removed at placement, authored `NumStability` names remain the project
convention, and new source wrappers retain the `leveque01` prefix. Existing
NumStability compatibility forwarders and the checked migration map remain
unchanged; no invented historical import paths are needed for new leaves.

After production additions: build the actual new leaves and source wrappers,
resolve every new declaration and inspect its axiom closure, update the
reviewed tier manifest with honest introduction/reviewer evidence, scan the
whole production layout and compatibility graph, and rerun the relevant
public import checks. Add source leaves to the real Chapter01 umbrella in
sorted order only after their imports resolve. Do not copy the generator's
historical primary-human approval metadata into new tier rules.

New production files change the global tree binding. Existing accepted audits
whose target/dependency/environment bytes remain exact can be revalidated and
given new context-addressed gate bindings; that is not a new semantic role
run. `rebind-reused-row.py` is a narrowly scoped pending adapter for the three
already reused, unchanged integrated targets. It retains their exact task,
declaration, classification and prior bindings and reruns the sealed complete
validator. Its help/argument path has been exercised; actual rebinding remains
to be tested after a real tree change. The inherited profile row needs its
fresh canonical global successor audit before comparable closure.
