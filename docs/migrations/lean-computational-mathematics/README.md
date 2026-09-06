# Lean Computational Mathematics identity migration

## Execution scope

The original request implemented Stage A and prepared Stage B/C plans. The
owner subsequently authorized: “Safely free space if you have to. Continue
with executing Stage B and C. When you are done push to the main branch.”
This record describes that authorized continuation against current remote
`main`; it does not treat the older dirty checkout as the integration base.

- **Stage A:** public branding reapplied to the newer repository documentation.
- **Stage B:** approved module-root migration in progress; compilation and
  compatibility validation are pending unless recorded in [validation](validation.md).
- **Stage C:** repository renamed and active links updated; candidate CI and
  publication to `main` remain pending in the [execution record](execution.md).
- **Current cutover state:** `POST_RENAME_PENDING_PUBLICATION`. The canonical
  repository is [`VSCL-x-VERITAS/lean-computational-mathematics`](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics),
  verified on 2026-09-06 at 01:25:22 UTC with unchanged repository ID `1327134933`.

## Checkout and integration decision

The original checkout was at `d602405cdd2a25915e5ba09dfd542886f4f9e2fa`, with
substantial pre-existing tracked and untracked work. Remote `main` was already
136 commits ahead, with no local-only committed changes. The preserved original
checkout remains separate from the isolated integration checkout, which began
clean at `718beac641a8094611dc249c3508a2f5415381a3` on 2026-09-06 UTC.

The integration base has 11,225 tracked files, 3,198 production Lean modules
and 5,790 test modules. It already contains the newer reorganization,
LeVeque, HDP, MatrixPowers, PolynomialEvaluation and Higham Chapter 2 work.
Copying the older dirty tree over it would discard or regress later work.
The Stage A prose was therefore reapplied to the current README and policies.

The exact module map is bound to that integration base, with SHA-256
`cbd53b282d8832245bb58b4c0d56958b6f15fb4810fd5da9cf748f24948429d5`.
It moves 2,401 implementation/aggregate modules to `ComputationalMathematics`
and retains all 3,198 previous `NumStability` imports, including the 797
pre-existing compatibility modules. The package `numStability`, test root
`NumStabilityTest` and authored declaration namespaces are retained.

## Changes and preservation boundary

Current project branding uses **Lean Computational Mathematics**. Current
module guidance uses the approved canonical root while explaining retained
imports and declaration names. Candidate-source breadth is grounded in the
[verified source inventory](source-scope.md), not inferred completion claims.

Numerical stability, conditioning, perturbation bounds and source-specific
mathematical names retain their meanings. Book titles, source IDs, theorem
numbers, historical audit decisions and published references are preserved.
Lean/Mathlib pins and the existing proof and CI enforcement policies remain
part of the validation contract. Compatibility modules do not count as new
mathematical results.

## Evidence and follow-up

| Record | Purpose |
|---|---|
| [Rename map](rename-map.md) | Semantic classification, permitted edits and residual names |
| [Source inventory](source-scope.md) | Present source surfaces, catalogue candidates and coverage limits |
| [Validation](validation.md) | Seventeen passing baseline and eighteen passing migrated source checks; pending full build/consumer matrix |
| [Internal migration](internal-migration.md) | Approved package/target/module/declaration decisions |
| [Exact module map](module-map.json) | Hash-bound canonical relocation and old forwarding map |
| [Source preservation](source-preservation.json) | Passing exact-source comparison; compilation remains separate |
| [Import-order adjustment](import-order-adjustments.json) | Sole exact 14-import header permutation required by the unchanged aggregate order gate |
| [Fixture inventory](fixture-inventory.json) | Discovered witnesses and canonical/legacy/mixed test coverage |
| [GitHub cutover](github-cutover.md) | Verified integration settings, order, checks and recovery |
| [Execution record](execution.md) | Actual publication/cutover outcomes; pending work stays explicit |

The full build, runtime diagnostics, canonical/legacy consumer checks,
post-cutover CI and deployed/external observations must have recorded outcomes
before their respective stages can be marked complete. A green historical
remote commit or a passing source-only baseline does not certify this patch.

The source-preservation gate passed at 2026-09-06 01:23:21 UTC: 2,401
canonical modules matched the approved transformation, all 3,198 historical
forwarders were checked, and all 797 prior wrapper comment bodies were
preserved. The permitted canonical-byte differences are exact initial
import-module token changes and one recorded permutation of the same 14
header imports in the Chapter 14 Problem 14 aggregate. Its body and old
forwarder are unchanged; the revised source check verifies this exception. Six
representative canonical targets passed a clean local build at 01:15:32 UTC.
The full build and consumer results remain separate requirements.

The migrated source capture at 01:24:30 UTC contains 5,599 production modules:
2,401 canonical implementation/aggregate modules and 3,198 retained old
forwarders. It records 1,503,619 nonblank source lines, 47,223 imports,
complete classification and module documentation, no import cycles or
unresolved project imports, and no forbidden reusable-to-source paths. The
[README](../../../README.md#current-repository-status) separates the unchanged
mathematical cohort from compatibility-file growth.
