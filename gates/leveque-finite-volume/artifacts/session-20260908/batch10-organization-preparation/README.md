# Batch10 organization preparation (not executed)

`prepare-v2.py` derives three batch10 helpers and their input/derivation records from the pinned batch9 helpers. It does not invoke Git, Lean, classification, expression export, graph capture, fingerprint merging, or gate operations. The final nine-file inventory, introduction commit, and entry-point receipt remain root-supplied operational inputs. No generated operational helper or fingerprint exists as a result of this preparation.

## Inputs

Use repository-relative POSIX paths in inventory entries. The helper requires these exact two session filenames and caller-supplied SHA-256 hashes:

* `root-batch10-production-placement-verification.json`
* `batch10-analysis-imports.json`

The inventory schema is:

```json
{
  "schema": 1,
  "status": "PASS",
  "source_acceptance": false,
  "files": [
    {
      "path": "ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannInformationFluxMethod.lean",
      "module": "ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod",
      "sha256": "actual lowercase SHA-256",
      "declarations": ["NumStability.actualAuthoredName"],
      "lines": 65
    }
  ]
}
```

The illustrated declaration/hash are schema examples, not factual values. All nine approved entries are required. Additional review metadata is allowed. `declaration_count` is optional; if present it must be an integer equal to the declaration-list length. `lines` is a positive integer checked against actual `bytes.splitlines()`. Source bytes must be LF and match the supplied SHA. A bounded lexical inventory checks exact authored names, namespaces, and duplicate names; it is not a Lean parser or elaboration check. Root's frozen native declaration/axiom and placement verification supplies that separate evidence.

The entry-point receipt has the existing batch9 shape: `schema`, `path` equal to `ComputationalMathematics/Analysis.lean`, `before_sha256`, `after_sha256`, `added_imports`, and root's `all_new_files` review metadata. This helper verifies the receipt hash, current aggregate after-hash, exact nine added module names, and one actual import occurrence per module. It does not independently recreate the pre-edit aggregate; root's receipt supplies that provenance.

The approved leaves are the four information-method files and five coordinate files named in `EXPECTED_PATHS`. The anticipated total is 65 authored declarations; the helper derives the total from validated lists instead of hardcoding 65. The unchanged tier baseline has 5959 modules and 654 reusable modules. Nine new reusable exact rules yield 5968 and 663. The previous expression fingerprint has 102 exact owner sources and 82 added production paths; the combined set has 111 owners and 91 added production paths.

## Root execution sequence

These are future commands and prerequisite descriptions, not execution receipts. Use the prepared native Python with `-B`. Let `R` be the repository, `S` its `gates/leveque-finite-volume/artifacts/session-20260908`, `H=S/batch10-organization-preparation`, and `D=H/derived`. `D` must be a fresh direct child of `H`; generated helpers resolve the session root at precisely that depth. Use actual absolute paths where the host requires them.

1. Root freezes all nine reviewed leaves, writes the exact normalized inventory and entry-point receipt, adds/exposes the nine imports, and captures its full both-root native build under label `batch10-foundations-full-build`. Root makes the actual introduction commit and records its full 40-character SHA. It writes `S/batch10-foundations-organization-review.md`. No placeholder commit is an admissible operational input.
2. Run the preparation helper with the actual values:

   ```text
   nativePython -B H/prepare-v2.py --inventory S/root-batch10-production-placement-verification.json --inventory-sha256 INVENTORY_SHA --introduction-commit INTRO --entry-point-receipt S/batch10-analysis-imports.json --entry-point-sha256 ENTRY_SHA --output-dir D
   ```

   Inspect `D/derivations.json` and all three generated helpers before executing them. Preparation validates commit syntax only; the classifier subsequently resolves actual HEAD and each file's introduction commit. It rejects changed pinned parents, prior owners, or tier baseline, and any existing fingerprint destination.
3. Execute `D/classify-batch10-foundations.py` through the prepared POSIX launcher so Git/path behavior matches the established organization environment. This is root's first classification mutation. It checks actual HEAD, each source hash, each introduction commit, no previous exact/prefix classification, the organization review path, exact counts, and the unchanged prefix policies. It writes the normal before snapshot and `batch10-tier-update.json`.
4. Run the unchanged exporter with the native Lake capture helper, from `R`:

   ```text
   nativePython -B S/run-native-lake-check.py batch10-expression-export env lean gates/leveque-finite-volume/artifacts/session-20260908/batch10-organization-preparation/derived/export-batch10-declaration-expressions.lean
   ```

   The actual command must equal `lake env lean ` plus the generated input record's repository-relative `exporter_path`; the receipt input commit must equal INTRO. The exporter emits `.lake/chapter01-batch10-expressions.jsonl`. Its existing structural serializer and filters are unchanged. The normalization is alpha-canonical expression serialization, not full definitional-equality normalization.
5. Capture the graph using the existing repository tool in the POSIX environment, with the root's ordinary actual command/output/exit capture, label `batch10-graph-capture`:

   ```text
   python R/tools/architecture/generate_baseline.py --no-build --strict-source --output-dir gates/leveque-finite-volume/artifacts/session-20260908/architecture-graphs --name checkpoint-INTRO_FIRST8-foundations
   ```

   Repeat with `--check`, label `batch10-graph-check`. Preserve actual raw outputs and exit records in the established schema. The preparation helper neither manufactures these receipts nor runs the graph tool. Released workflow Python, when needed, must continue through the existing POSIX launcher without edits to released code.
6. After the four required execution labels exist with actual exit zero, run `D/merge-batch10-expression-fingerprints.py` through the prepared POSIX launcher. The required labels are `batch10-expression-export`, `batch10-foundations-full-build`, `batch10-graph-capture`, and `batch10-graph-check`. The merger verifies their output hashes and the exporter command/commit, parser pin, all old/new source bytes, disjoint selected modules, exact authored-name coverage, graph module count, exact production diff and clean production worktree. It writes a fresh `S/chapter01-current-expression-fingerprints-INTRO_FIRST4.json` using exclusive creation.

Full-build receipts can legitimately precede the introduction commit, as in batch9; graph receipts do not carry `input_commit`. The existing schema/checks are preserved instead of inventing new commit fields. Root must maintain exclusive ownership of these operations, inspect resulting provenance, and perform its own integration, current-graph and gate work afterward. None of those actions is authorized or certified by this preparation artifact.

## Preservation, tests, and limits

`tests-02.receipt.json` records an actual native Python exit of zero; `tests.json` records 17 synthetic/read-only checks. They cover the input schema, optional counts, wrong names/hashes/lines/modules, exact nine-file set, scoped namespace/comment parsing, four frozen owner inventories, generated syntax, retained guards, unchanged exporter serialization, parser pin, and checked replacement anchors. They do not execute derived operational helpers or test real final inputs. All original helpers and pins remain unchanged.

`tests-01.receipt.json` and its raw output preserve the first actual failure: Windows MAX_PATH while creating a deep synthetic fixture. `repair-long-paths.py` derived the authoritative `prepare-v2.py` and test-v2 files; only native IO path wrapping changed. Both fixture directories are synthetic and excluded from production. No failed evidence was rewritten.

Future changed tier/FP/helper baselines require a new reviewed additive derivation. Assertions require ordinary Python (never `-O`). Name extraction is deliberately bounded to the reviewed nine-file syntax. Hash checks are preparation-time observations; the runtime helpers retain their own source and HEAD checks. A concurrently changing repository is not a supported execution setting. These artifacts do not establish source acceptance, integration authority, a final reconciliation epoch, or final closure.
