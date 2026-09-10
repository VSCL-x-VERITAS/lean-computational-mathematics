# Evidence retirement, 2026-09

This repository tracked 41,651 files and 1.72 GB, of which 91% was audit
evidence: `gates/` 1.26 GB and `audits/` 297 MB against 88 MB for the three
Lean roots. A single agent session directory,
`gates/leveque-finite-volume/artifacts/session-20260908/`, was 17,125 files and
1.17 GB on its own, and 346 MB of the tree was byte-identical duplicate files.

This retirement removed the material that no gate document, tool, document or
CI step references, and that git history retains anyway.

| | Files | Size |
|---|---:|---:|
| Before (`d36b2c42d`) | 41,651 | 1,764.0 MB |
| After | 23,451 | 461.1 MB |
| Removed | 18,205 | 1,303.9 MB |

Nothing under `ComputationalMathematics/`, `NumStability/` or
`NumStabilityTest/` changed. No Lean statement, proof, import, build target or
diagnostic baseline changed.

## What was removed

| Phase | Commit | Files | Size | Content |
|---|---|---:|---:|---|
| B | `3f8e85970` | 12,872 | 1,073.7 MB | Unreferenced 2026-09-08 session artifacts |
| C | `64674247f` | 5,332 | 229.5 MB | Superseded faithfulness reruns, checkpoint-archive fragments |
| E | `628e5dcb8` | 1 | 1.3 MB | `examples/LibraryLookup.lean`, built by nothing |
| F | this commit | 11 | 4.0 MB | Rendered source pages retained by manifest hash |

Phase B removed, inside the session directory: expression-fingerprint
generations including two 77 MB files differing by 1.6 KB, twelve 5.8 MB
snapshots of `tiers.json`, 214 raw `git index` and `git status` stdout dumps,
194 file snapshots, 3,679 captured stdout and stderr files of which 1,073 were
empty, 2,746 agent transcript and image files under `faithfulness/orchestration/`,
and the third-party source documents.

Phase C removed 370 superseded `faithfulness/history/<timestamp>/` runs across
121 packages, up to 14 for one claim, each of which had re-copied its unchanged
inputs. It also removed the `checkpoint-archives/b496496bfd2c/` fragments,
whose own README recorded that the complete packages remain in git history.

## What was kept, and why

7,151 evidence files (219 MB) remain. The retained set was computed, not
chosen, by `tools/retirement/compute_referenced_evidence.py`, whose rules are
documented in its header: a path is retained if a gate document names it
(repository-relative or gate-relative, including inside prose), if a tracked
file outside the evidence trees names it, if it belongs to an audit evidence
package, if a retained faithfulness manifest or decision hashes it, or if it is
a gate's own scaffolding. The reference set is committed at
`2026-09-evidence-retirement-referenced.txt`.

Two consequences of those rules are worth stating. A directory mentioned by the
README layout table, the audit-kit glob or a gate scope line is navigational and
retains nothing by itself, otherwise a single README pointer would retain
18,000 files. And every path a retained manifest hashes is retained, because a
package whose manifest cannot be checked is not evidence; that rule alone
retained 325 files that no other rule reached.

Verified after every removal: all 108 file paths named by the three gate
documents resolve, and all 7,151 files in the reference set are present.

Nothing was collapsed under `docs/architecture/`. The 56 duplicate groups there
are one TSV frozen into separate immutable records, each copy pinned by a
checker, named by a planning tool, or described by its own packet's prose. The
evidence is in `2026-09-duplicate-record-analysis.md`.

## Third-party source material

The removal of the book PDF, two synthetic PDF fixtures and 11 rendered page
images is on rights grounds, not size. Retained audit manifests hash these
files as their source input, so they were "referenced" under the rules above
and their sha256 provenance survives in the manifests. A public MIT-licensed
repository should not carry a copyrighted book or its scanned pages, so they
are the one class removed against a live reference. The pages were 963x1600
renderings; 285 copies existed of 29 distinct images.

## Recovering anything removed

Every removed file is addressable at the pre-retirement commit:

```bash
git show d36b2c42d:<path>
git restore --source d36b2c42d -- <path>
```

Retired rerun timestamps are indexed per package in
`audits/vershynin-hdp/HISTORY_INDEX.md`.

## Keeping the tree this way

`tools/architecture/check_layout.py` now rejects newly tracked session working
artifacts under `gates/` and `audits/`: the suffixes `.bin`, `.pstats`,
`.jsonl`, `.gz`, `.png` and `.pdf`, and any path through an `orchestration` or
`history` directory. Verified by probe: a tracked `dump.bin` under the session
directory makes the check exit 1. `.gitignore` carries the same patterns, the
retention rows P03 and P04 of the migration `rename-map.md` are amended to say
that a session working tree is not gate-bound evidence, and `AGENTS.md` states
the rule for agents that produce audit packages.
