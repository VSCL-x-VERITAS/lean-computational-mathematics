# Lean Computational Mathematics identity migration

The [implementation report](implementation-report.md) records the completed
implementation and validation. Source commit `51c5540984780b0011f41739b9ddaf8e505b7c93`,
tree `20298c7b62a6e75c6b4beba46c8b517d7d86f4fb`, passed
[CI run 34021942176](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics/actions/runs/34021942176)
at 12:45:10 UTC on 2026-09-06. Authenticated identity/axiom checks and strict
full-graph comparison passed. Final documentation/main publication is recorded
separately from this tested source commit in the external receipt and delivery.

## Execution scope

The original request implemented Stage A and prepared Stage B/C plans. The
owner subsequently authorized executing Stages B/C, scoped safe space recovery
and publication to `main`.

- **Stage A:** public identity and maintained documentation updated.
- **Stage B:** canonical module migration and compatibility implemented;
  complete source/build/test/diagnostic/downstream and compiled checks passed.
- **Stage C:** **POST_CUTOVER** identity; repository rename, redirects and active URL cutover verified;
  validated source published on the integration branch. Final documentation/main
  publication is verified separately in the [execution record](execution.md).

## Checkout and interface decision

The integration began clean at `718beac641a8094611dc249c3508a2f5415381a3`,
136 commits ahead of the original dirty checkout at `d602405cdd2a25915e5ba09dfd542886f4f9e2fa`.
The clean base had 11,225 tracked files and already contained newer LeVeque,
HDP, MatrixPowers, PolynomialEvaluation and Higham Chapter 2 work. The original
owner work remains separately preserved, with no HEAD/index change.

The exact map moves 2,401 implementation/aggregate modules to
`ComputationalMathematics` and retains all 3,198 old `NumStability` imports,
including 797 pre-existing compatibility modules. Package `numStability`, test
root `NumStabilityTest`, authored declaration names and all dependency pins
remain unchanged. The hash-bound source check records mapped imports, one
14-import ordering adjustment and the exact original public-instance name
insertion; mathematical bodies and attribution remain intact.

## Evidence and follow-up

| Record | Purpose |
|---|---|
| [Rename map](rename-map.md) | Semantic classification, permitted edits and residual names |
| [Source inventory](source-scope.md) | Present source surfaces, catalogue candidates and coverage limits |
| [Validation](validation.md) | Exact baseline/current commands, successful complete CI/comparisons and preserved attempt history |
| [Internal migration](internal-migration.md) | Approved package/target/module/declaration decisions |
| [Exact module map](module-map.json) | Hash-bound canonical relocation and old forwarding map |
| [Source preservation](source-preservation.json) | Passing exact-source comparison; compilation remains separate |
| [Import-order adjustment](import-order-adjustments.json) | Sole exact 14-import header permutation required by the unchanged aggregate order gate |
| [Forwarder-header adjustment](forwarder-header-adjustments.json) | Exact import relocation before the unchanged module documentation/license notice |
| [Live private-name adjustments](live-private-name-adjustments.json) | Insertion-only test adapters retaining original assertion authority |
| [Public-instance adjustment](public-instance-name-adjustments.json) | Exact insertion of the original generated public instance name, focused test and third test-root import |
| [Fixture inventory](fixture-inventory.json) | Discovered witnesses and canonical/legacy/mixed test coverage |
| [GitHub cutover](github-cutover.md) | Verified integration settings, order, checks and recovery |
| [Execution record](execution.md) | Observed validation/cutover outcomes and separate publication receipt |


The strict mapped graph comparison found zero removed, added or changed rows:
58,420 declarations, 269,218 signature edges, 386,408 body edges and zero authored
project axioms. Seven representative axiom sets match. The separate documented
Git dependency resolves at the tested commit; the authenticated Linux package
build passes all 13 canonical/old/mixed consumer fixtures with matching pins.

The [source inventory](source-scope.md) preserves actual book/catalogue scope,
mathematical stability terminology and companion discrepancies. The 08:44:16
preservation refresh confirms all 6,878 original starting files accounted for
and 2,127 frozen integration paths unchanged. Cached-baseline, scoped Windows,
external-audit and private-integration limits remain in [validation](validation.md).
Earlier failed/canceled attempts are retained there as history, not current status.
