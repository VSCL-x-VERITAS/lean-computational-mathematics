# Duplicate record analysis, 2026-09

Phase D of the 2026-09 evidence retirement. The retirement plan proposed
collapsing the byte-identical TSV copies under `docs/architecture/` and
removing several superseded prose documents. The plan required each candidate
to be checked against the tooling before removal, and to keep any copy that a
checker pins.

Applying that check, **no file is removed.** Every duplicate is a deliberate
record, not accidental duplication. This note records the evidence so the
question does not have to be reopened.

## What the duplication is

56 groups of byte-identical files under `docs/`, 64 extra copies, 10.7 MB.
The large groups are all the same shape: one TSV of migration data frozen into
three separate immutable records - the delivery packet that produced it, the
phase branch sidecar that consumed it, and the review that adjudicated it.

| Bytes | Copies | Example group |
|---:|---:|---|
| 2.6 MB | 2 | `deliveries/R06/PRIVATE_CLOSURE.tsv`, `phases/…-completion/branches/B0007-private-closure.tsv` |
| 939 KB | 2 | `deliveries/R05/PRIVATE_CLOSURE.tsv`, `branches/B0006-private-closure.tsv` |
| 271 KB | 3 | `deliveries/R07/TEST_MATRIX.tsv`, `branches/B0010-test-plan.tsv`, `reviews/R07-test-plan.tsv` |
| 185 KB | 3 | `branches/B0010-R0011-import-manifest.tsv`, `requests/R0011-import-manifest.tsv`, `reviews/R07-R0011-import-manifest.tsv` |
| 319 KB | 3 | `phases/2026-08-repository-reorganization/{checkpoints/C0000-inventory.tsv, checkpoints/C0001-inventory.tsv, scope.tsv}` |

## Why each copy is retained

**`phases/**` copies are hash-pinned.** `check_completion_phase.py` records the
sha256, row count and header of these sidecars (for example
`branches/B0008-private-closure.tsv` at line 1286) and builds others through a
path template over branch and sidecar name (line 937), so a static search
cannot enumerate them. Verified empirically: moving
`branches/B0008-private-closure.tsv` aside makes `check_completion_phase.py`
exit 1, and restoring it returns exit 0. CI runs that checker on every push.

**`reviews/R07-*.tsv` are referenced.** All 17 are named by
`tools/architecture/generate_c0006_planning_controls.py` and by the phase record
`branches/B0010.json`. The plan's proposal to remove them in favour of the
branch copies is withdrawn on this evidence.

**`requests/R0011-import-manifest.tsv` is read directly** by
`check_completion_phase.py` (line 7510).

**`deliveries/R*/*.tsv` are described by their own packet.** No tool or CI step
reads them, but the sibling prose of each packet does: `PRIVATE_CLOSURE.tsv` is
named by 41 tracked Markdown files, `DECLARATION_ROUTES.tsv` by 44,
`TEST_MATRIX.tsv` by 38, almost all of them the packet's own `DELIVERY.md`,
`PRIVATE_CLOSURE.md` and `ROUTING.md`. Removing the data would leave each
delivery packet's documentation pointing at nothing, which is the opposite of
what a frozen delivery record is for.

**The superseded phase is immutable.** The three-way group inside
`phases/2026-08-repository-reorganization/` sits in a closed phase, which
`phases/README.md:39-41` retains as immutable evidence and which CI validates
through `check_phase.py --all-phases`.

## Prose documents examined, and retained

- The six superseded `docs/source_coverage/AUDIT_ch01-28_*` reports and
  `docs/SPLIT4_FORMALIZATION_REPORT.md` are retained. `docs/README.md` states
  that documents with a dated broad-audit label "record how the formalization
  was produced… Keep them for provenance, but do not use them as current import
  guidance." Removing them requires an explicit amendment to that policy and an
  owner decision, so they are left in place.
- `docs/source_coverage/higham_ch14_claude.md` is **not** a duplicate of
  `higham_ch14.md`: 69 lines against 150, only 17 lines in common, and it
  documents a different agent's coverage of a distinct module namespace.

## Two findings recorded, not fixed

**`docs/architecture/compatibility.json` does not regenerate byte-identically.**
Running `tools/architecture/generate_compatibility_manifest.py` produces
3,157,566 bytes against the committed 8,192,690, and the generator exits 1 with
one problem:
`NumStability.Source.Higham.Chapter11.BunchKaufman.Rounded.GrowthSolve is
documented as forwarding but declares content`.

That problem is a false positive of the generator's own heuristic. The module is
a pure forwarder: a licence header, a module docstring, one
`import ComputationalMathematics.Source.…GrowthSolve`, and a compatibility note.
Its docstring discusses a growth estimate in prose, which the heuristic appears
to read as content. Independently re-verified for the whole layer: **0 of 3,334
`NumStability` modules contain any declaration keyword** outside comments.

Both the drift and the false positive predate this retirement and are unrelated
to it; nothing here reads or writes that manifest. CI is unaffected because it
runs `check_compatibility.py`, which passes. The committed manifest was left
untouched.

Co-authored record of Phase D. No files changed under `docs/architecture/`
other than the addition of this note.
