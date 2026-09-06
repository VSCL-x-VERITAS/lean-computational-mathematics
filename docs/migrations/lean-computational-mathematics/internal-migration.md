# Stage B: approved internal interface migration

**Status: implementation and complete clean CI/comparison passed for source commit `51c55409...`; final documentation/main publication is recorded separately.** The original Stage A-only
proposal is superseded by the owner's authorization to execute Stages B and C.
Final validation status is recorded separately in [validation](validation.md).

## Exact contract

| Interface | Before | Approved result |
|---|---|---|
| Lake package | `numStability` | Retained |
| Canonical library/module root | `NumStability` | `ComputationalMathematics` |
| Original library/import root | `NumStability` | Retained forwarding surface |
| Implementation/aggregate cohort | 2,401 modules | One canonical copy under `ComputationalMathematics` |
| Existing compatibility cohort | 797 modules | Preserve old module names, retarget imports to canonical owners |
| Total retained old imports | 3,198 modules | All retained; no removal release introduced |
| Test library/root | `NumStabilityTest` | Retained, with canonical/legacy/mixed import fixtures |
| Authored declaration namespaces | `NumStability` and existing subnamespaces | Retained unchanged |
| Lean / Mathlib | `4.29.0-rc3` / `e8ea1afc32790ce1d4e1a4e45cc412ba9388716b` | Retained; no dependency upgrade |
| Machine identities | Source IDs, schema keys, benchmark scenario/result identities | Retained |

The map is bound to base `718beac641a8094611dc249c3508a2f5415381a3` and
SHA-256 `cbd53b282d8832245bb58b4c0d56958b6f15fb4810fd5da9cf748f24948429d5`.
The checked-in [module map](module-map.json) is the exact field-level record.
No path is inferred merely by replacing the word “stability.” Compatibility
modules may forward to several canonical owners and external imports; their
reviewed export behavior must be preserved.

## Downstream usage

For reproducing validated source commit `51c55409...`, including the preserved
public-instance name and all canonical/old/mixed compatibility checks:

```toml
[[require]]
name = "numStability"
git = "https://github.com/VSCL-x-VERITAS/lean-computational-mathematics"
rev = "51c5540984780b0011f41739b9ddaf8e505b7c93"
```

The canonical repository URL was verified after the GitHub rename. Exact
`51c55409...` Git acquisition and guarded Lake resolution passed at 08:38:45 UTC;
postchecks verified its tree, nine pins, 13 fixture hashes and ten checkouts.
That acquisition did not compile the consumer. The separately authenticated
Linux local-path consumer build passed in complete CI run 34021942176 by
12:45:08 UTC, with exact source/fixture/pin identity matching the Git result.
This establishes the covered downstream behavior; it is not a claim about all
possible clients. [Validation](validation.md) preserves the separate Windows
scope and earlier failed-attempt records.

Consumers pinning the inherited `v0.1.0` release must use that release's old
imports; a new module root is not retroactively added to a historical tag.

```lean
import ComputationalMathematics.FloatingPoint.Model

open NumStability

#check FPModel
#check FPModel.exactWithUnitRoundoff
```

Canonical imports and authored declaration namespaces are separate. This
migration deliberately does not create a second declaration namespace,
duplicate instances, or claim that a module forwarder aliases declaration
names. Existing `NumStability.*` declarations remain the declarations.

## Required implementation and validation

1. Relocate each mapped canonical implementation exactly once; preserve
   subject-specific suffixes and bodies. Retarget only reviewed module/path
   references, including live source scanners and test imports.
2. Retain every old module as a forwarding surface, preserving existing
   multi-target forwarding semantics and avoiding cycles.
3. Adjust the Lake/CI target inventory and live tooling/metadata to include
   the canonical implementation, legacy interface and test coverage without
   relaxing warnings, lint, placeholders, provenance or source-tier rules.
4. Compare every canonical source with its exact baseline mapping. Review any
   difference beyond mapped imports/project paths individually; preserve
   theorem statements, proofs, attributes, instances, options and licensing.
5. Exercise canonical and legacy leaf imports independently, mixed imports,
   actual mathematical applications, notation/instance behavior and an isolated
   downstream consumer pinned to this migration snapshot.
6. Run the complete configured build, test and diagnostic matrix. Separate
   environmental failures from regressions; a source-only pass is insufficient.

The old dirty checkout is not merged or overwritten as part of these steps.
Frozen gate/faithfulness/phase/source-audit evidence remains unchanged; any
current audit-target navigation is recorded separately.

The current [source-preservation report](source-preservation.json) passed with
the exact module map, [14-import ordering adjustment](import-order-adjustments.json),
[forwarder-header adjustment](forwarder-header-adjustments.json),
[private-name fixture adapters](live-private-name-adjustments.json) and
[explicit original public-instance name](public-instance-name-adjustments.json).
The instance insertion changes no type/proof; priority 1000, inference and
old/canonical imports passed the focused regression and complete test library.
All 27 adversarial checks passed. All 18 source gates passed locally and in CI.

Validated source commit `51c5540984780b0011f41739b9ddaf8e505b7c93`, tree
`20298c7b62a6e75c6b4beba46c8b517d7d86f4fb`, passed
[complete clean CI](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics/actions/runs/34021942176)
at 12:45:10 UTC. The strict mapped compiled comparison then passed with zero
removed, added or changed declarations/signature/body edges; no exception
normalizes away the public-instance name. All seven representative axiom sets
match. See [current evidence](validation.md#validated-source-commit-and-current-ci-evidence)
for exact commands, cache provenance and the cached-baseline qualification.
The [fixture inventory](fixture-inventory.json) distinguishes generated coverage
from mathematical results; the full in-repository fixture library and separate
13-fixture consumer both compiled successfully. Earlier snapshots, including
the historical 04:31 source-only result and failed comparison, remain in the
[validation history](validation.md#strict-graph-failure-and-explicit-public-instance-repair).

## Internal recovery

If rollback becomes necessary, use the hash-bound old/new module map and the
recorded inverse import permutation to restore the canonical implementation.
Reverse the exact forwarder-header and live private-name insertions through
their adjustment manifests, and reverse the exact public-instance name insertion
through [its manifest](public-instance-name-adjustments.json), preserving any
later edits and the original type/proof.
Restore the 797 pre-existing forwarding bodies from exact baseline `718beac...`;
their flattened imports cannot be inverted by changing a prefix. Remove only
unchanged migration-generated fixtures identified by the fixture inventory,
and reverse mapped live configuration through the reviewed diff. Preserve later
and owner changes and all dependency pins, then rerun the same source, build,
compatibility and consumer validation. This is a recovery procedure, not an
executed rollback. Reversing Stage B does not undo the GitHub rename or require
reusing the former repository slug.
