# Supported command-adapter design, pending diagnostic review

This is a preparation design, not an official prepare, successful audit or
accepted source interpretation. The failed original task and released scripts
remain unchanged. The diagnostic uses a small theorem only to exercise exact
definition import; it is not a replacement for the production source contract.

## Runtime mechanism

Use the released `lean.command` string-list configuration hook. A new exact
adapter can capture the canonical Lake environment once per temporary build
root, resolve the pinned native Lean executable there, then invoke that executable
directly. It must not re-enter `lake env lean` after prepending the overlay,
because the observed Lake behavior puts its caches before caller LEAN_PATH.

The direct child receives the actual captured environment with only LEAN_PATH
changed: native Windows temporary overlay root first, then the unmodified Lake
path list. The original input arguments remain intact. Only the exact two
Mathlib sources, checked by canonical module path and source hash, receive the
three actual package options. Other project sources and the dossier receive no
additional Mathlib options. The unchanged dossier's own `initSearchPath` will
then observe the same path; no --setup assumption is needed for its inner
`withImportModules` call.

Do not publish raw captured environments. Only resolved Lean, necessary runtime
path variables and hashes belong in public evidence. The current raw diagnostic
capture is an exact private publication exclusion known to root.

## Complete package prefix without altering caches

The actual production compiled module header closure contains 4,730 modules,
of which 2,377 are Mathlib modules. It selects 9,508 existing compiled artifacts
(.olean, .olean.private, .olean.server, .ir), totaling 1,723,574,976 bytes. This is
the actual loaded closure, not an inferred import-parser graph. Retain its native
inventory, original artifact hashes and current target/native provenance.

Create a complete temporary Mathlib package prefix for that closure. Cached
artifacts may be copied or hardlinked. Every requested compilation output and
all of its artifact siblings must be new unlinked paths: remove only the
temporary hardlink directory entries before invoking Lean. Never truncate or
overwrite a file still linked to an original cache artifact. Check resolved
temporary containment and cache/source pins before and after the operation.
The diagnostic puts these temporary binaries under the ignored `.lake` tree;
publication contains source/probes/receipts, not binaries.

The released parser's actual order is Defs then FTaylor. Preserve that order in
the diagnostic and eventual adapter rather than silently changing it to the
source's public-import order. Positive consumer and unchanged-dossier tests after
both compilations are required to verify that the newly generated artifacts
remain compatible. Removing one selected overlay .olean at a time and observing
its exact missing-file failure is required to demonstrate actual dossier import
selection; --deps and zero compile exits alone are insufficient.

The current test proves only the Mathlib package mechanism with a small consumer.
Before official use, the command adapter must also preserve all selected project
snapshot imports. The actual released 41-module list is hash pinned. Its ordinary
project import graph is ordered, but any missing project-package snapshot import
must fail explicitly or be completed by an exact compiled-closure overlay; it
must not quietly read a stale project cache while claiming fresh isolation.

## Minimal new immutable protocol data

A fresh command extension should pin the adapter, captured environment recipe,
native Lean binary/toolchain, actual Mathlib package configuration, both exact
source mirrors/upstream sources, compiled-closure inventory and real successful
diagnostic receipts. The adapter validates the artifact inventory and must bind
its own actual copy/link/output records in the temporary build root. Inventory
files may be bound as files; do not inline thousands of compiled artifacts into
semantic role prompts or invent a source meaning for runtime provenance.

The new preparer/config must use a fresh task ID and preserve the earlier
successful Q10 predecessor, exact source/context/target and native proof-free
supplement. The failed task is retained as failure history. The new command
extension belongs to `lean.environment_files` and preparation lineage, not to
the user interpretation packet. The generic support branch must validate the
exact command and extension, preserving old task branches; all dependent
qualified/closed/rebind/batch/global helpers need coherent successor pins. The
previous final-evidence assembler remains frozen for its adopted v2 suite until
an additive current-suite successor is reviewed.

The existing role-size guard can be copied to a fresh directory with only the
new task ID; staged.py can remain byte-identical there. No old role plans,
receipts or judgments may be reused. After actual prepare and prepared validation,
measure the new generated stdin byte lengths before any semantic role launch.
