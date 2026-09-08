# General Chapter 1 prerequisites and correspondences

The current placement search is recorded in `general-propagation-discontinuity-placement-search.json`; the two frozen draft reviews record selected project and pinned Mathlib producers. The native focused build and twelve declaration/axiom checks passed, with exact inputs and outputs recorded in `general-propagation-discontinuity-verification.json`.

`Transport/ClassicalCharacteristics` supplies the characteristic derivative and converse from a jointly differentiable solution of the scalar PDE. `LinearSystems/CharacteristicPropagation` composes the existing eigenbasis coordinate equivalence with that converse and reconstructs the state. These statements are independent of the book's numbering.

`ConservationLaws/Discontinuity` provides the general comparison between rectangle conservation, almost-everywhere mass differentiation for each fixed interval, and the obstruction to spatially differentiable classical solutions. The existing conservative residual predicate is retained: a discontinuous state can still have differentiable composed flux. Its stronger obstruction therefore expressly requires flux discontinuity.

`Examples/MovingRiemannJump` collects reusable finite-vector translated jump examples; `Examples/StationaryJump` records the constant-flux counterexample. Both depend only on reusable APIs. The examples are mathematical results, not proof scaffolding or source correspondence.

The two modules under `Source/LeVeque/Chapter01` state the selected source correspondences and import reusable mathematics. Their independent statement audits are separate from the proof checks. The discontinuity correspondence explicitly uses the user-adopted interpretation; the propagation target states its joint differentiability hypothesis explicitly.

The existing `Analysis` and `Source/LeVeque/Chapter01` aggregates expose these leaves with casefold-sorted imports. No public compatibility names are removed. The current tier scan reports five unclassified reusable modules until the actual addition commit exists; five exact rules will then cite that real commit, and the existing source-prefix rule covers the two source leaves. This review does not claim a completed organization scan or source acceptance.
