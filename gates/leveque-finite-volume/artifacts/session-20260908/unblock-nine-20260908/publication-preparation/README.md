# Publication allowlist preparation — live snapshot only

This packet prepares a deterministic path-selection policy and a read-only check. It does not stage files, alter the index, create a commit, change a ref, run an audit, edit the gate, or certify publication completeness. Root owns the final policy review, frozen-input scan, staged-byte verification, commit and publication. Audit evidence was still being produced when these snapshots were taken.

Use `check-publication-allowlist-v2.py` with the exact reviewed `policy.json`. The policy contains 22 explicit Lean paths: nine new reusable leaves, three new local source wrappers, eight earlier source wrappers, and the two aggregate files. It also enumerates the tier manifest, Chapter 1 gate, two current issue ledgers and 101 observed session-level receipts. Evidence prefixes cover the current `unblock-nine-20260908/` work and 16 exact current-goal audit directories. There is no blanket allowance for the entire session, repository, ledger tree or audit tree. All failed and superseded attempts inside the allowed evidence roots remain included as history; no proof repair or deletion is performed by selection.

The exact exclusions are the two raw expression streams, the old `blocked-gate-installation.lock`, the old `root-final-blocked-80f5-pathspec.bin`, `.faithfulness-audit/VERSION`, and the unrelated `codex-start-1-prepare-v5-0-1-20260908` ledger directory. Original bytes remain on disk. Actual generated `.olean`, `.ilean`, `.pyc`, `.pyo` files and `__pycache__` paths are held for review. Inert historical files such as `.olean.snapshot.bin` are distinguished from active generated caches. Symlinks, gitlinks, nonregular files, path escapes, conflicts, deletions, renames, unexpected staged exclusions and included files or index blobs of at least **90,000,000 bytes** are flagged. No flagged path is automatically repaired or removed.

Both required gzip archives are pinned through their existing receipts. Every invocation checks archive bytes and fully decompresses each archive to the exact recorded raw SHA-256 and byte count. It checks the retained raw stream's size; it does not redundantly rehash the 926 MB of raw streams. The compressed evidence is complete for the recorded raw bytes, and the two raw paths are excluded from the proposed pathspec.

## Actual snapshot

`snapshot-current-02/inventory.json` records HEAD `5e3f63594aa964263469ada134aee2809559d50d`, identical before/after HEAD and index hashes, 2,459 selected paths, 14 excluded paths, zero held paths and zero reported issues. It found no oversized index blobs. The only files at or above 90 MB were the two intentionally excluded streams:

| Raw file | Raw bytes | Selected gzip bytes |
|---|---:|---:|
| `final-fingerprints/native-expression-stream.jsonl` | 232,131,831 | 4,411,820 |
| `local-replacement-fingerprints/native-expression-stream13.jsonl` | 694,376,010 | 12,206,796 |

The policy correctly excluded one receipt that appeared after discovery: `unblock-nine-local-organization-layout-02-exit.json` at the session root. It belongs to the current goal but requires an explicit addition to the final successor policy. Later receipts and new audit directories require the same review. Earlier and failed audit directories are retained even when a successor exists. No live judgment was read or evaluated during this task.

The lexical placeholder scan found zero hits among selected files ending in `.lean`, `.lean.fragment`, `.lean.snapshot` or `.lean.txt`. This is not an exhaustive proof check: comments can match, other snapshot formats are not searched, and only production hits would be held. A historical match remains explicitly classified as evidence rather than a production theorem.

## Invocation and output

Run from the workspace through the unchanged native-Python → POSIX launcher; use actual absolute paths for the placeholders:

```text
<native-python> -B <W>/workflow-v5.0.1-local/run_workflow_posix.py <D>/publication-preparation/check-publication-allowlist-v2.py --policy <D>/publication-preparation/policy.json --policy-sha256 b48a272999d6fa83d2eeeb08115237d5988760e8d58a780e0c11cd89785fb91d --label <fresh-label>
```

Only `rev-parse`, `status`, `ls-files --stage` and `cat-file --batch-check` are invoked. Every Git command disables optional locks and index refresh. The helper records commands, actual exits and raw output hashes; it checks HEAD/index before and after. The invocation writes only a fresh `snapshot-<label>/` in this preparation folder. The snapshot includes an inventory plus sorted text and NUL-delimited **proposed** path lists. Exit zero means the inventory was produced successfully; root must also review `issues`, `hold` counts, unknown exclusions and current freshness. There is deliberately no install/stage option or final-completeness flag.

The discovery and both actual screening runs remain append-only. The discovery script's printed `audit_dirs` summary used the wrong path component; its raw `paths.json` records were correct. The policy derives directory names from those exact paths and explicitly checks all 16 names. The first policy attempt failed on a too-narrow `INTERPRETED` naming heuristic; the additive successor enumerates the three actual `REFINED`/`OPERATORS` names. The first synthetic test failed on a malformed non-ASCII byte literal; a test-only successor fixes it. All original scripts, failed outputs and real exits are retained.

Seven synthetic tests passed against the final checker, covering exact scope, deny precedence, compressed/raw selection, cache-versus-inert-history handling, path safety, NUL status parsing including rename and Unicode, the 22-file source scope, and the static read-only Git command set. No additional build, audit or semantic check was run.

Final staging must occur after root has reviewed the completed audits and receipts. Root should preserve the original policy, produce a successor adding the exact new owned receipt/audit paths, rerun the checker against the final worktree, and independently verify staged bytes and the final diff. Snapshot outputs themselves are created during the scan and future files are intentionally outside that snapshot; this packet makes no fixed-point completeness claim.
