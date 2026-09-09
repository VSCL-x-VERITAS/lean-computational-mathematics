# Conditional preparation plan — exact Mathlib package command

Status: diagnostic pending. This is a read-only source inspection/proposal, not
an implemented adapter, successful preparation, new task, or source verdict.
The failed `LEV-CH01-PHYSICAL-HIGH-RESOLUTION-COORDINATE-SWEEP-PRODUCTION-20260908`
directory remains unchanged, including its actual failed prepare output.

## Supported released entry

The pinned `.faithfulness-audit/scripts/common.py` config loader accepts a
nonempty string list `lean.command` (lines 109–117). The unchanged
`prepare_audit.py` invokes that list followed by exactly:

```text
--root BUILD_ROOT -o OUTPUT SOURCE
```

for every staged module and `AuditTarget.lean` (compile_module, lines 160–178).
The dossier then uses the same command followed by:

```text
--run DOSSIER_HELPER AuditTarget DECLARATION LOCAL_MODULES_FILE
```

(lines 288–297). Commands run at the actual repository root, with the prepared
build root prepended to LEAN_PATH. No released script change is needed to choose
a command adapter through this documented configuration field.

## Smallest conditional adapter

After an actual successful isolated diagnostic, configure a fresh task with:

```text
["python3", "-B", "REPOSITORY_RELATIVE_NEW_ADAPTER.py"]
```

The POSIX adapter must preserve cwd, environment (including LEAN_PATH), stdout,
stderr and exit status. It must recognize the exact five-argument compile form,
resolve SOURCE inside BUILD_ROOT, and compare its relative module path and exact
source bytes with the two pinned upstream mirrors. Only those two module paths
with the exact expected hashes receive the three tested package options. A
recognized mirrored module with a changed hash must fail closed, not silently
use defaults. Other staged modules and AuditTarget run the unchanged
`lake env lean` plus the original arguments. The dossier --run form receives no
Mathlib-only options. No proof source rewriting, implicit injection into the
dossier, kernel option changes, or general Mathlib-prefix dispatch is proposed.

The package file `.lake/packages/mathlib/lakefile.lean`, SHA
`25966b1899a1aab3fa530abf39360189eb48ccc6e048f0bf9a1725f4c38346c4`,
defines `mathlibLeanOptions` with these actual ordinary options:

```text
-DautoImplicit=false
-DmaxSynthPendingDepth=3
-Dpp.unicode.fun=true
```

The package separately appends weak linter options. The present diagnostic tests
the three ordinary package options, not arbitrary defaults, backward-defeq
overrides, or source changes. The comment mentioning a transparency feature is
not an active option and is not authorization to add one.

Dispatch sources remain the exact two in the already adopted module-root plan:
`Mathlib.Analysis.Calculus.ContDiff.Defs` SHA
`793a1ca70881ed469c78feeb0724766b6a2d933e51a8fad5b9c87e67228c5711`
and `Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries` SHA
`a507aab3122399fda58585255b66e44094ce06494ecec66dd279a7769e9740aa`.

## Fresh preparation and consistent lineage

The existing module-root v2 preparer permits a fresh task ID matching its
`LEV-CH01-...-PRODUCTION-20260908` pattern, but the exact target, Q10, source
context, module-root plan and preparer lineage are pinned. Keep the original
accepted predecessor configuration/task used by the old spec; do not use the
failed task as if it had a successful manifest. Choose a new unused task ID and
spec/config, retaining the same primary target and current native supplement.

The additive preparer should add one explicit compiler-command-extension
FileRef to the spec, verify its exact adapter/package/diagnostic/module pins,
require the original command exactly `["lake","env","lean"]`, then set the
new command. It must add the extension, adapter, package config and frozen actual
diagnostic inputs/receipts to `lean.environment_files`, and record the extension
and exact command in preparation-lineage.json. Module source roots and mirrors
stay unchanged. The runtime protocol data is not source interpretation evidence.

An additive support/helper suite is needed because SOURCE_CONTEXT_PREPARERS
only recognizes pinned preparer SHAs. The new support must retain the old v2
branch, recognize the new preparer, and require its exact command extension,
config command, manifested environment hashes and task/row/target scope. It
must not return an empty module-root provenance list for the new branch. Carry
the new support pin consistently through qualified binder, closed validator,
rebind validator, batch binder, final global binder and their dependency
manifest. Reuse the existing tested derivation style; never edit released kits.
The just-frozen final-evidence assembler remains valid for its old v2 suite and
must get a separately reviewed successor if this new suite is adopted.

## Staged role wrappers

The adopted guard's sole task identity constant is its old TID. Its other fixed
scope is the unchanged page list `25,26,27,28,125,126`. The staged orchestrator
imports same-folder guard.py and derives TID/config/paths from it. A new folder
can therefore contain a guard copied with only the fresh TID substitution, plus
byte-identical staged.py. Rerun their focused fixtures against the new copies
and pin the originals, diffs and new hashes. Do not use old plans/role receipts.

After root's official successful prepare and prepared validation, measure the
new exact generated messages with the copied guard. There is no basis yet to
claim a full role fits below 1,048,576 UTF-8 bytes. If a role exceeds the limit,
preserve its exact message and use a separately reviewed lossless transport;
do not omit effective-domain definitions or add unauthorized blind context.

## Required diagnostic and guard evidence

Before adapter implementation: actual isolated FTaylor compile output/exit,
unchanged exact source bytes, package-file hash and exact option command. Before
official prepare: both mirrored modules compile in dependency order through the
adapter; a normal local compile and dossier-style --run retain exact unmodified
argv; malformed/changed mirrored inputs reject; equal non-Mathlib source bytes
do not trigger module-only flags; stdout/exit pass through. Freeze all failed
attempts and actual receipts. No semantic role or final status is part of this
runtime repair.
