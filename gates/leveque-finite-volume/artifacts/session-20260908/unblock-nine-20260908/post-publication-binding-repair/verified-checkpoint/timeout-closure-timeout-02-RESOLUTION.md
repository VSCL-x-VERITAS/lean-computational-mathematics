# Git metadata timeout diagnosis and repair

The unchanged chapter checker completed without interruption in **17.3978317 seconds** after a POSIX Git stat-cache refresh. This is below the installed hook's unchanged 20-second subprocess limit. It returned **exit 1**, so this resolves the observed runtime timeout, not chapter closure.

## Evidence and cause

- Before repair, the standalone baseline binary diff took 28.1839087 seconds, exit 0. Its index contained 41,430 entries. Trace2 located a 23.23-second gap between tree traversal and rename processing; the pinned Git source explains that stat-only mismatches require file-content comparisons there. The earlier five-minute interrupted run cannot be assigned wholly to that phase.
- The cached `lakefile.toml` record had device, inode, user, and group values all zero. POSIX `os.stat` returned device 942518307, inode 3377699720963782, and user/group 197609, with identical size and timestamps. This establishes a current native/POSIX metadata mismatch, rather than relying only on historical findings.
- An empty `.git/index.lock` remained from the interrupted owned diagnostic. Its exact timestamp and size were checked; no active Git process naming this repository was present. It was removed. Git's pinned `builtin/diff.c` shows that a failed index lock skips automatic refresh, allowing repeated expensive comparisons.
- A single `git update-index --refresh` completed in 178.0406816 seconds. Exit 1 reported only the previously known `.faithfulness-audit/VERSION: needs update`; no attempt was made to change that file. There was no remaining lock.
- The before/after staged manifests are identical: SHA-256 `9e597561edbbbd40e4c1323b2bcca6a1bc2a548ef7ad446823cbd0d41e7f6af4`, covering all 41,430 paths, modes, object IDs, and stages. Only Git's cached metadata changed.
- The subsequent exact gate command completed in 17.3978317 seconds. Gate, checker, and refreshed index hashes stayed unchanged during that command. Trace2 shows the later name-only diff taking about 1.97 seconds and its metadata refresh scanning only one entry.

## Preserved status and limits

Commit `b8ccf0d8bd610b599b13708e8c8518771bcf71ab` was already pushed to `origin/main`. This repair did not alter source files, staged content, Git configuration, hook definitions, deadlines, released validators, or audit decisions. No build or audit was rerun.

The gate still reports 39/41 objects (95.12%), two actionable rows, 16 skipped and zero deferred. It derives FAIL because current bindings are stale; chapter closure is not claimed. The retained ACTIVE reconciliation checkpoint remains QUEUED, not campaign integration. Native Git can recreate the metadata mismatch, and a single successful timing is not a guarantee against future load-related timeouts.

Receipts: `receipt.json`, `posix-stat.json`, `stale-lock-cleanup.json`, `../metadata-refresh-01/receipt.json`, and `../closure-post-refresh-01/receipt.json`. The final unchanged-checker output is `../closure-post-refresh-01/output.txt`.
