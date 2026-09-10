# Working-record retirement, 2026-09-10

A second retirement pass, after the evidence retirement recorded in
`2026-09-evidence-retirement.md` and release 0.2.0. Where that pass removed the
material no gate or tool referenced, this one removes material that is
referenced but finished: the record of completed campaigns, kept as narrative
and retired as data.

The distinction throughout is **keep the outcome, retire the workings**.

| | Files | Size |
|---|---:|---:|
| Before (`afb25bab1`) | 13,739 | 439.1 MB |
| After | ~3,500 | ~90 MB |

Nothing under `ComputationalMathematics/` changed. No Lean statement, proof,
import or build target changed, and the lint baseline is untouched.

## What was retired, and why

### The rename import witnesses

2,401 files under `NumStabilityTest/Import/ProjectIdentity/Canonical/`, each
importing `ComputationalMathematics` and `#check`ing one declaration under the
`NumStability` namespace. They proved the 2026-09-06 identity migration
preserved declaration names. That migration is complete and merged, and the
library build already establishes that those declarations exist.

This was the only item retired for a reason other than size. At 87 lines each
they are 2,401 extra modules elaborated on every CI run, and `lakefile.toml`
sets `weakLeanArgs = ["-j", "1"]`, so they were elaborated single-threaded
against the workflow's 360-minute timeout. Retained: the six named
`ProjectIdentity` family fixtures the clean-project consumer step copies, and
the 144 other canonical import tests.

### The faithfulness audit working record

254 per-claim audit packages and their three chapter gate documents, 7,140
files and 215.2 MB, which was 49% of the tracked tree. The owner confirms this
was a working record rather than a published artifact.

Outcomes are preserved in `2026-09-faithfulness-outcomes.md`: each chapter gate
and its verdict, per-row outcome counts, package and sealed-decision totals,
and the method's citation. Nothing mechanical read these trees; the tier
manifest cites 125 paths under them, but `check_tiers.py:40` treats
`review.evidence` as a required free-text field and never resolves it as a
path, so those citations remain valid records of who reviewed what.

`.faithfulness-audit/` is retained. It is the executable protocol for auditing
future chapters at 204 KB, and its scripts refuse any root outside the
repository, so it cannot be relocated without being disabled.

### The completed reorganization campaign's data

713 files and 118.7 MB of TSV inventories, JSON manifests, patches, compressed
projections and the one-off Python tools that produced them, across
`docs/architecture/phases/`, `deliveries/`, `declaration-ownership/`,
`lane-proposals/` and `docs/migrations/`.

The 259 narrative Markdown documents in those directories are **kept**, at
2.2 MB. That was the deciding measurement: the prose is 2% of the weight and
carries every link the repository's own documentation depends on. Removing it
to save 2.2 MB would have left fourteen broken links in `README.md`,
`ARCHITECTURE.md`, `AGENTS.md`, `CHANGELOG.md` and `docs/README.md`. Each
affected directory now carries an `ARCHIVED-DATA.md` note so a reader who
follows a link and finds no sibling data knows why.

With the data gone, four CI checkers had nothing left to validate and were
retired with it: `check_phase.py`, `check_completion_phase.py`,
`check_phase_projection.py` and `check_completion_phase_projection.py`,
together with thirteen one-off ownership and planning tools that read the same
records and that CI never invoked. `tools/architecture/` goes from 30 scripts
to 13, and CI from 21 Python invocations to 15.

## What this means for history

Deleting tracked files does not shrink a clone. Every file retired here and in
the previous pass remains reachable in the pack, which is how the recovery
commands below work. These passes buy checkout size, comprehension and CI
minutes, not download size. Shrinking the pack would require rewriting history,
which is not recommended: the retired phase records pinned 4,639 object ids and
`check_completion_phase.py` hardcoded 70 more, and while both are now gone,
any rewrite would also invalidate every sha256 recorded in the audit manifests
that remain recoverable.

## Recovering anything

```bash
git show afb25bab1:<path>
git restore --source afb25bab1 -- <directory>
```

`afb25bab1` is release 0.2.0, the last commit before this pass. The evidence
trees, the migration data and the import witnesses are all complete there.
