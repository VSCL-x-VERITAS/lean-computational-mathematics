# Additive runtime findings; no preparation approval

The initial conditional PLAN remains historical. The package-option diagnostic
did succeed for exact FTaylor source, but that does not resolve the complete
snapshot-import path. No fresh preparer, support suite, task or config is ready
for official execution on the strength of this result alone.

## Actual adapter attempt

`test_adapter.py native01`, actual POSIX process session 85098, completed with
overall exit **1**. Four child commands individually exited 0: Defs compilation,
FTaylorSeries compilation, ordinary implicit-variable compilation, and a small
dossier-shaped --run. All four actual child receipts and raw outputs are retained
under native01. The final harness assertion compared the printed native path to
the original POSIX string and failed; it was not a Lean compilation failure.
The process traceback was:

```text
File ".../test_adapter.py", line 95, in <module>
  assert (O / 'dossier-stdout.txt').read_text().strip() == ','.join(run_args[2:])
AssertionError
```

Actual --run output contained:
`AuditTarget,Sample.target,C:/Users/qed_s/AppData/Local/Temp/dim-package-command-kmca_6ob/local-modules.txt`.
No successful aggregate test receipt was produced and none is substituted for
the failed harness. Original `test_adapter.py` and `lean_command.py` stay intact.

This attempt compiled Defs before FTaylor, while the actual public source import
is Defs → FTaylor. It therefore cannot certify an order-correct pair using fresh
FTaylor. Root is independently checking the unchanged released source import
parser; the parser's actual order is separate from Lean's actual public imports.

## Actual POSIX/native environment observation

`inspect_runtime.py runtime01` completed 0. Executable resolution found the real
Elan native launcher at `/c/Users/qed_s/.elan/bin/lake` (5,842,944 bytes, SHA
`175089915efc623126a1560ed517cd52ec2d4d09f2adc1c10f22f56568fed5ad`),
not a task-local shell wrapper. The probe supplied LEAN_PATH equal to the harmless
nonexistent `/tmp/REVIEW_ONLY_LEAN_PATH_SENTINEL` and ran exactly
`lake env printenv LEAN_PATH` at the repository root.

Actual output put all Lake dependency roots, Mathlib cached compiled root,
project cached compiled root and Lean stdlib **before** the sentinel. The output
SHA is `cfe3cb47907970c44162cd552cb475b46b52021a90977858d61a48cc5c811891`.
This establishes that an externally supplied build root is appended behind Lake
package roots in this runtime. It does not establish that a particular import
used freshly generated artifacts. The flags-only child successes must not be
described as proof of fresh snapshot dependency selection.

## Dossier --setup boundary

Pinned `declaration_dossier.lean` lines 115–116 call `initSearchPath` then
`withImportModules #[{ module := targetModule }] {}`. The installed Lean source
`Lean/Environment.lean` lines 2329–2331 defines `importModules` with default
`arts : NameMap ImportArtifacts := {}`; lines 2348–2351 show `withImportModules`
calls it without an artifact mapping. `Lean/Elab/Frontend.lean` passes setup
importArts into the source frontend, and `Lean/Shell.lean` subsequently executes
main for --run. Thus a --setup file used to elaborate the dossier runner does not
automatically pass its mapping to the runner's later inner import operation.

Euler reports a separate overlay-first native test fails on an absent Mathlib
Within artifact because Lean chooses a package-prefix root. That finding and his
new explicit importArts diagnostic are independent of this packet; no successful
result is inferred before his actual receipt.

The remaining preparation decision is how to bind the unchanged dossier's actual
dependency resolution reproducibly. A complete exact compiled package overlay
or another supported process-level arrangement may be needed if fresh imports
are required. Merely applying --setup to the runner, reversing two compile calls,
or quoting a --deps listing does not by itself discharge this issue. No released
helper, production source, Mathlib source or native option outside the actual
package configuration has been changed here.
