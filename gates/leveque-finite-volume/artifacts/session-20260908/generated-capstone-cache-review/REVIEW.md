# Generated capstone cache review

The two generated files can be removed from tracking while preserving their exact historical evidence as `.olean.snapshot.bin` files. The new preservation map and narrow restore helper address the resulting fresh-checkout path gap. No frozen native receipt, evidence manifest, source file or audit input needs editing for this change. This review does not certify a terminal gate or candidate.

| Historical output | Size | Exact SHA-256 |
|---|---:|---|
| `capstones-final-03.olean` | 175312 | `d6a8c14d6038264ab8a236f193f508f9fc09dfb2ef0d5f4cb6603806cd2132e0` |
| `measure-final-02.olean` | 31840 | `5101907f71445fb07bf6d83741f4a2d89ea708d260972db5e424f6b430f351df` |

Both are actual native `lake env lean -o ...` **outputs**, bound by successful historical receipts. They are not the canonical imported dependency owners listed elsewhere in those packets. The capstone receipt binds `Capstones.lean`, its native output and 11 axiom reports; the measure receipt binds `MeasureSupplement.lean`, its native output and eight reports. Both retain actual exit zero and the pinned native Lean version. The present review rechecks output/source/compiled hashes; it does not rerun Lean or extend the earlier semantic review.

The immutable `evidence-manifest.json` at SHA `02cba5390c9248dd8888cae8c931969d88cd73217c33caf24437b80e51aae939` names these generated artifacts at lines 466 and 506. The later `batch9-capstone-independent-review/verify.py` resolves and hashes them through `pairs` and `check_prospective`. `nine-row-local-route-review-batch10/verify_evidence_v3.py` similarly collects the receipts' `compiled`/`compiled_sha256` pairs and checks the original paths. Its generic output labels every `.olean` a `compiled-import`; that label does not change these two files' actual role as `-o` outputs. Later verification and checkpoint-selection records retain the historical references.

The exact-basename search over canonical source roots and all current sealed audit JSON/Python/Lean/Markdown inputs returned no match (actual `rg` exit 1). The broader session search found the frozen native/evidence/review/checkpoint references and new preservation tools. The captured search roots, argv and raw outputs are in `verification.json`. This is a scoped reference result, not an exhaustive absence claim about future consumers or encoded paths. No source-faithfulness audit was rerun, altered, or judged.

## Preservation and replay

The root's `generated-capstone-cache-preservation/preservation.json`, SHA `3bd9a4893d9713259398d5ead7e9cadc4fd7b4792a51c2c5253f125e76837b4c`, binds the original and snapshot paths, identical SHA/size, exact native receipts, original evidence manifest, historical commit/blob metadata and exact two local-exclusion additions. Independent byte inspection confirms all these content relations. The historical Git blob SHA1s were recomputed from `blob <length>\0` plus content without calling Git. The historical commit association and staged deletion state were not independently queried; the root's recovery code/actual zero-exit receipt supply those observations.

The original files remain locally present. The recorded `.git/info/exclude` change is exactly its preserved prior bytes plus the two anchored paths. The failed original attempt's incorrect already-ignored assumption is documented by root and was not used to rewrite any old evidence. Root's recovery output and actual zero exit were checked against their raw-output hash.

**Additional mapping was necessary for fresh-checkout replay, and the new map supplies it.** A `.bin` snapshot preserves content but does not satisfy an unchanged verifier opening an `.olean` path. Before such replay, restore only the two missing original cache paths from their exact snapshots, with their SHA/size checked and with local exclusions established. Do not recompile under the old receipt labels or substitute newly produced `.olean` bytes for a historical hash. A new Lean run has its own source/output/exit provenance.

The reviewed `restore-generated-capstone-caches.py`, SHA `564494c9dcf1946006d99b44e081cadb4c5754a764d66866a2a8cac6959c44e1`, implements this bounded step. It pins the preservation map, checks the exact two original paths and contained snapshots, rejects mismatching existing cache bytes, requires explicit `--restore` for missing files, and exclusively creates only missing caches. It checks the paths are untracked, establishes exact local exclusions for restoration, verifies final hashes and ignored status, and writes a new replay report. Default mode verifies existing cache paths and writes only that new report; it is not literally a zero-output filesystem operation. Neither mode runs the old verifiers or changes a gate/source/audit.

The root's default-mode report `root-existing-replay.json`, SHA `c759110be86ea628cd00202462095c91c2b6892b3e9adf60348e2f28546a9f64`, records `verify-existing-only` and `restored: []`. Root reports its actual exit zero. This reviewer only checks that report's bytes/fields and the helper source; no restore/default helper execution was performed here. Run through the normal prepared POSIX launcher without Python optimization (`-O` would disable its assertion guards). Concurrent cache/exclude writers are outside this bounded restoration procedure.

`.git/info/exclude` is not transported by Git. The same two exclusions must therefore be established on a fresh checkout before restoring/re-staging evidence. The helper covers this with `--restore`. Earlier native receipts and old verifiers also contain absolute Windows paths; their relocation to another checkout is a pre-existing replay limitation, explicitly retained in the map and helper report. Restoring the two relative cache paths does not by itself claim a fully portable replay of those packets.

## Terminal and asset scope

`check_layout.py:199–218` inspects **tracked** paths and rejects their `.olean` suffix. It does not require deleting local generated bytes, and `.snapshot.bin` does not have that forbidden suffix. No local layout run was performed by this reviewer.

For the current requested terminal **BLOCKED** route, the released reconciliation launcher distinguishes retained checkpoints from candidate PASS: `command_checkpoint` records exact ACTIVE/BLOCKED gate evidence and permits retained QUEUED handling, while its PASS branch invokes candidate preparation and requires subsequent candidate-epoch validation (`reconciliation_launcher.py:1045–1081`). `derived_status_defects` requires selected-unit ACTIVE/BLOCKED checkpoint evidence for retained QUEUED (`:1543–1555`). The cache representation change does not by itself introduce a candidate epoch or eight-command candidate-validation obligation into that retained path. Actual final gate/checkpoint/organization requirements remain root's work.

The snapshots, preservation map and restore helper should remain retained evidence on the working branch; they preserve the generated-output asset rather than rejecting its content. A future candidate inventory must explicitly account for the original path removal and its same-content snapshot/replay mapping. The current optional `final-epoch-asset-helper-draft` explicitly rejects deleted files and assumes a committed preview with no deletion; it would require a separately reviewed input/adapter decision if reused on such a future preview. That is a disclosed future candidate-helper limit, not a request to manufacture a candidate epoch, weaken released asset checks, or amend released code now.

The current frozen audit bindings remain unchanged, and this review makes no new source decision. It also does not infer exhaustive local completion from preserved bytes. Root still owns the actual layout repair/checkpoint, latest gate evidence, route review and terminal check.

## Verification

`check-01.exit.json` records the review's actual native Python exit zero. `verification.json`, SHA `ace82992d4a31c4f7914c1b61b361e4104004cc9ef90b19164d62ffa4c209cfd`, records 27 bound input occurrences, the two exact content relations and both scoped reference searches. The raw check output SHA is `c7be622f60692843a5e48dd5dd827bd4851c6f523a9657cb62be2f8039717af6`. Inputs were reread at the end. This reviewer ran no Git, layout, rebind, gate, Lean, audit, restoration or released workflow operation.
