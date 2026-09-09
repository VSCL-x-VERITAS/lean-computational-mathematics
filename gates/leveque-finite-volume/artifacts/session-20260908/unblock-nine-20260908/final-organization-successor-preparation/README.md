# Configurable organization capture and draft preparation

These additive successors preserve the earlier helpers. They make no organization measurement, acceptance, gate, source, index, or reference change. Every emitted assessment remains `root-review-required`. This packet has synthetic guard tests only; it has not captured the operational repository.

`capture_current_v2.py` derives the full production census, complete Chapter01 and native-owner import closure, actual changed-source coverage, native target checks, four actual checker receipts, protected-anchor policy bytes, and current exposure delta. `prepare_draft_v2.py` verifies that exact capture again and assembles review-required organization inputs. Both use `support.py` and POSIX Git only through the established unchanged launcher.

## Inputs

Start from `config.template.json`. Its null values and nonempty `pending_inputs` intentionally make it invalid for execution. Root must supply the final Info/DIM inputs and clear `pending_inputs` only after reviewing the actual evidence.

All FileRefs are exact `{path, sha256}` objects: normalized repository-relative POSIX paths and lowercase SHA-256. The configuration itself is passed with its exact SHA-256. Required fields are:

- `expected_head`, `anchor`, `campaign_id`, and current `source_tree_sha256`.
- Exact `topology`, `gate`, and current `organization_template` FileRefs. The latter must contain current tool and policy pins; an old template whose policy bytes changed will be rejected.
- `graph` with exactly `json` and `markdown` FileRefs for the reviewed current graph pair.
- Explicit `expected_counts`: production modules, merged native constants and owners, total rows, formalizable rows, and skipped rows. No old counts or receipt labels are defaults.
- Every native fingerprint input with `inventory`, exact per-file `expected_records`/`expected_files`, and nonempty hash-pinned native `provenance`. Owner source bytes must still match current production; duplicate merged constant records must agree exactly. Provenance references are byte bindings, not a new native re-execution or semantic certification.
- Exactly four `checker_executions`: layout, tiers, compatibility, hygiene. Each supplies actual receipt/output FileRefs, exact recorded `expected_command`, a concrete applicability rationale, and supporting evidence FileRefs. Actual exit must be integer zero, recorded HEAD current, elapsed time present, and output hash exact.
- `complete_declaration_manifest` and `complete_native` with the same execution shape. The manifest must cover every nonskipped row and bind exact check input and target owner bytes. Target checks and allowed axiom reports are verified against the pinned policy and native fingerprint closure.
- `placement_reviews`, each with a pinned `evidence`, explicit `rationale`, and `covered_source_paths`. Their combined paths must cover every actual changed production path.
- `scope_assessment` with an explicit root-reviewable rationale and six separate lists: unexpected changes, unclassified modules, mixed files pending split, duplicate wrappers, placeholder findings, and canonical placement pending. The helper does not invent empty assessments from successful checker exits.
- `aggregate_boundaries` remains exactly the reviewed Analysis exposure owner. Expanding that policy requires a separately reviewed helper successor.

## Future execution sequence

Use native Python with `-X utf8 -B` to invoke the unchanged `workflow-v5.0.1-local/run_workflow_posix.py`, giving it the selected successor script and these arguments:

1. Capture: `capture_current_v2.py --repo R --config CONFIG --config-sha256 HASH --out FRESH_CAPTURE_DIRECTORY`.
2. Read the actual capture output and freeze its returned manifest hash. No guessed manifest is accepted.
3. Draft: `prepare_draft_v2.py --repo R --config CONFIG --config-sha256 HASH --capture-manifest CAPTURE_MANIFEST --capture-sha256 HASH --out FRESH_DRAFT_DIRECTORY`.
4. Root reviews the full source census, placement rationale, ratchet baseline, checker applicability and source-scope lists. Only root may adopt a separately reviewed operational input for the existing organization preparation workflow.

`R` is the actual Lean repository, not the workspace parent. Config, output and capture paths are repository-relative; output directories must be new beneath the session evidence directory, with an existing parent. Outputs use exclusive writes. Interrupted or failed attempts remain evidence and must not be overwritten. Sources, all observed inputs, complete source census, actual changed-source set, topology and HEAD are checked again around output assembly. These are optimistic concurrency guards, not a repository lock; operational callers must also maintain the established single-writer coordination.

## Validation and limits

`tests-01-exit.json` records the actual POSIX test invocation: 18 synthetic guard tests passed, including syntax parsing of all three helpers, null future input rejection, exact four-checker shape, counts, native provenance references, required review rationale, safe FileRef paths, missing files and mutations. Tests never invoke Git, scanning, capture, draft preparation or certification. No final source totals, final HEAD, source-scope acceptance, or completed organization measurement are asserted here.

The graph Markdown is exactly pinned as part of the explicit reviewed pair; this helper does not regenerate it. Native provenance files are pinned rather than rerun. A future actual execution can still fail on a real schema or evidence inconsistency; retain that attempt and repair additively. Full source semantics and whether the supplied six-list assessment is justified remain root review responsibilities.
