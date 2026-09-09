# Exact Mathlib package-options replay

The isolated native replay of the unchanged pinned `Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries` source succeeded: exit 0, 58,578 ms, empty stdout and stderr. The source copy has SHA-256 `a507aab3122399fda58585255b66e44094ce06494ecec66dd279a7769e9740aa`. It was compiled as that exact module under the short sibling scratch root `../ftaylor-options-03`.

The command used exactly `-DautoImplicit=false -DmaxSynthPendingDepth=3 -Dpp.unicode.fun=true`, which occur in `mathlibLeanOptions` in the pinned Mathlib `lakefile.lean` (SHA-256 `25966b1899a1aab3fa530abf39360189eb48ccc6e048f0bf9a1725f4c38346c4`). No source modification, extra backward-definitional-equality setting, or production compiled-output replacement was made. The comments in the package file are not additional option settings.

`../ftaylor-options-03/receipt.json` (SHA-256 `f194559a364e2e48dd06c7d82298515ce4a41ca5c8abff3e75cf35e6d3716624`) binds the source, exact copy, package/toolchain files, existing FTaylorSeries compiled artifacts, four direct import source/compiled artifacts, and actual version/dependency/compile commands. All captured original pins were equal before and after. `compile-exit.json` has SHA-256 `56befc4f258040c83f429fbf003aa016df88ffaa81a6823fe4709f70cfab3105`. This is a direct-import pin set, not a complete transitive package closure.

The earlier released preparation failure remains unchanged in the physical DIM audit task. This experiment establishes successful package-faithful replay, not the individual causal contribution of each flag, equivalence of cached binary bytes, audit acceptance, or permission to alter released code. The configured weak linter options were not tested; they are not among the three requested elaboration/printing options.

Two preparation failures remain here. `run.py` failed while Python opened an overlong copied source path, before invoking Lean. `run-v2.py` used the existing process-local Python long-path I/O shim; Lean's dependency probe still rejected that overlong path, actual exit 1 with raw stderr and exit receipt under `native-02`. `run-v3.py` changed only the scratch root to a shorter sibling, after which dependency inspection and compilation succeeded. No failed artifact was overwritten.

Compiled `.olean` files are scratch caches and should not be added to the publication allowlist. The exact copied source, scripts, command/output/exit files, and hash receipts are the replay evidence.
