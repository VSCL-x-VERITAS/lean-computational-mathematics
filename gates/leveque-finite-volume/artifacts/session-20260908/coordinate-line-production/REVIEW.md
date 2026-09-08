# Coordinate-line canonical placement

The three new files extract the exact reviewed scratch candidate, SHA `527aa742c248431fb1b73c93d1efc8f602e160c9a83d2d9c880bd17768e1150f`. Root's independent verification and placement authorization are bound by `root-batch8-logical-line-verification.json`, SHA `72138928eae1c038a6f86a81ce4ef8c71acf6b911c7cbcc685f54d369dd27579`.

## Ownership and preserved behavior

`FiniteVolume/CoordinateLineBalance.lean` contains eight declarations: the shared normal face flux, net outward difference, actual cell-average update, weighted mass identity, line-locality, finite-line balance, equal-boundary conservation, and adjacent-cell cancellation. It imports the existing lower `LocalFluxBalance` and `FluxDifference` owners.

`FiniteVolume/CoordinateLineSweep.lean` contains the four sweep declarations. Only this leaf adds `OperatorSplitting`, using the existing ordered executor and two-operator producer. Each next stage consumes the actual preceding numerical state.

`FiniteVolume/Examples/CoordinateLineBalance.lean` contains the four unequal-volume witness declarations and imports only the balance leaf. Its volumes one and two produce different nonzero average changes while preserving total weighted mass.

The generic namespace is `NumStability.CoordinateLineBalance`, with examples below `.Witness`. No unqualified top-level `advance` or `sweep` is introduced. All 16 draft names have a one-to-one canonical mapping in the manifest. No declaration is removed or replaced by an assumption. The malformed scratch module-doc header is corrected only in new production copies; missing sweep/witness docstrings and scope-specific module descriptions are added. The frozen scratch bytes remain unchanged.

## Reuse and architecture

Recorded current-tree searches found no proposed name or file collisions. The selected Mathlib lookup confirms `Function.update_self` and `Function.update_idem`. Existing cell-total multiplication, finite-line telescoping, and ordered-sweep producers remain the owners of their general mathematics; the new files are coordinate-indexed specializations. The checked copy preserves every proof body, apart from its enclosing namespace/import context and comments.

This is an additive generic placement. There are no historical public imports to forward from the scratch namespace. No aggregate, tier, gate, ledger, source target, audit, topology, released helper, or Git mutation is performed here. Concurrent new leaves owned by other workers are outside this placement's write set.

## Scope retained

Cell volumes are supplied positive reals, and the shared oriented normal-flux values include any face-area factor. The code does not derive geometry or a physical flux model from coordinate indices. Numerical states remain independent data. The line result uses finite integer-indexed contiguous blocks and retains both exterior faces; arbitrary supplied volumes need not factor as tensor widths. Stage durations are arbitrary reals in the algebra, including positive physical durations. No directional commutation, constant-state preservation, high-resolution property, accuracy estimate, or source interpretation is added.

## Verification

The focused native build and exact declaration checks both exited zero; their actual receipts and source snapshots are preserved. Lean verified all 16 canonical declaration types against the original frozen types after transparent namespace expansion. It also verified the values of all six definitions, ensuring that the executed numerical operations and witness data are unchanged. All 16 canonical declarations received `#check`, `#print axioms`, and an enforced allowed-axiom check. Every type and value comparison passed definitionally, so no normalization bridge was needed.

The final receipt binds the production hashes, declaration map, source/compiled imports, raw outputs, initial frozen source, independent approval, searches and this review. Full-library builds, aggregate/tier changes and later source decisions remain with root.
