# Semantic rename map and retained names

The immutable map is based on `718beac641a8094611dc249c3508a2f5415381a3`.
The owner approved the internal module migration after the initial Stage A
report. This table distinguishes that authority from unrelated mathematical,
source and historical material.

| Entry | Locations / spelling | Class | Approved action | Dependency and validation |
|---|---|---|---|---|
| A01 | README, architecture/contribution headings, maintained documentation, current citation title | `PROJECT_BRANDING` | Use Lean Computational Mathematics | Review current prose; preserve narrower mathematical subjects |
| A02 | README and current navigation/benchmark documentation | `PROJECT_BRANDING` / `PROJECT_INTERFACE` | Explain the canonical import root and retained declaration/package identities | Resolve every changed current path against the exact map |
| B01 | Lake package `numStability` | `PROJECT_INTERFACE` | Retain | Existing dependency `name` and package-qualified interfaces remain usable |
| B02 | 2,401 implementation/aggregate modules rooted at `NumStability` | `PROJECT_INTERFACE` | Relocate once under `ComputationalMathematics` with exact imported-module mapping | Compare canonical source against baseline after exact imported-module tokens and the sole recorded 14-import header permutation |
| B03 | 797 existing compatibility modules plus newly forwarded old implementation paths | `COMPATIBILITY` | Retain all 3,198 old imports as forwarding modules | Independently test legacy leaves, canonical leaves and mixed imports; avoid implementation duplication |
| B04 | Authored `NumStability` namespaces and declaration names | `PROJECT_INTERFACE` / `MATHEMATICS` | Retain | `import ComputationalMathematics.FloatingPoint.Model` still exposes `NumStability.FPModel` |
| B05 | `NumStabilityTest`, source IDs, CLI/schema/result keys | `PROJECT_INTERFACE` | Retain; update only their mapped module references | Preserve test inclusion, benchmark scenarios and machine-readable keys |
| B06 | Live tier/compatibility/layout and diagnostic metadata, CI and tooling | `PROJECT_INTERFACE` | Adjust exact canonical module/path consumers without reducing enforcement | Re-run original gates, build/consumer matrix and diagnostic contracts |
| C01 | Current org repository/badge/clone/citation/compare URLs | `CURRENT_REMOTE_REFERENCE` | Canonical rename observed at 01:25:22 UTC; current URLs activated under the new org slug | Verify repository ID `1327134933`, current branch and observed redirects |
| C02 | `AlexGeorgantzas/lean-numerical-stability` historical releases, audit origins and old CI runs | `HISTORY` | Preserve | This is a distinct upstream repository, ID `1171530090` |
| P01 | Stability-related mathematical suffixes, predicates, comments, assumptions and results | `MATHEMATICS` | Preserve | No synonym replacement or weakening of statements |
| P02 | Book/paper titles, `higham-*`, `leveque-finite-volume`, `vershynin-hdp`, `RandNLA2016`, theorem/section IDs | `SOURCE_PROVENANCE` | Preserve | Compare catalogue/coverage fields; retain original source wording |
| P03 | `gates/**`, `ledgers/**`, `docs/source_coverage/AUDIT_*.md`, dated phase/baseline/review/audit records | `HISTORY` / `GENERATED` | Preserve the original bytes of gate-bound evidence | These bind hashes, revisions, declarations and earlier source paths. Amended 2026-09-09: a session working tree is not gate-bound evidence. Command dumps, agent transcripts, superseded fingerprint or rerun generations and rendered source pages are not retained; see `docs/architecture/reviews/2026-09-evidence-retirement.md` |
| P04 | Completed `gates/**/audit-task.json` and the current faithfulness inputs/outputs | `HISTORY` | Preserve; use separate future target mappings for a new audit | All 26 latest completed manifests hash-bind their task metadata. Amended 2026-09-09: the current run of each package is preserved with everything its manifest hashes; superseded `faithfulness/history/<timestamp>/` runs are indexed in `audits/vershynin-hdp/HISTORY_INDEX.md` rather than kept as bytes |
| P05 | Per-chapter Higham coverage ledgers | `SOURCE_PROVENANCE` / current navigation | Add current navigation only; preserve append-only and dated audit text | Do not rewrite recorded build commands or completion decisions |

## Residual-name rules

Remaining `NumStability` occurrences are expected in authored declaration
names, the old import tree, existing test-root names, historical evidence and
recorded pre-cutover observations and redirect checks. `stability`, `stable`, `numerical` and book titles
are not forbidden words. Existing compatibility paths are retained on purpose;
a disappearance-based grep gate would reject correct behavior.

The migration does not rewrite pinned history to manufacture a current audit.
A moved implementation and its old forwarding module have different file
hashes; historical faithfulness results continue to identify their original
snapshot. The preservation and compatibility checks establish the new mapping
without relabeling historical results as fresh tests.
