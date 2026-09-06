# Stage B: approved internal interface migration

**Status: authorized and being implemented.** The original Stage A-only
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

For the migrated development revision:

```toml
[[require]]
name = "numStability"
git = "https://github.com/VSCL-x-VERITAS/lean-computational-mathematics"
rev = "main"
```

The canonical repository URL was verified after the GitHub rename on
2026-09-06. The former organization URL redirects to it.
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

The [source-preservation check](source-preservation.json) passed on
2026-09-06 at 01:23:21 UTC. It checked 2,401 canonical modules, 3,198 old
forwarders and 797 preserved prior wrapper comment bodies. Besides mapped
initial import-module tokens, the sole permitted canonical-byte change is
the exact [14-import header permutation](import-order-adjustments.json)
needed to keep Chapter 14 Problem 14 in the existing aggregate sort order.
All mathematical bodies and authored names are unchanged. The
[fixture inventory](fixture-inventory.json) records 2,401 canonical import
fixtures, 429 additional old-import fixtures, six focused old/canonical pairs,
one mixed-import fixture and 20,757 discovered canonical witness checks.
Those are generated test coverage, not successful compilation results.
The measured migrated inventory is recorded in [validation](validation.md).
Full-build, consumer and warning/lint outcomes remain pending.
