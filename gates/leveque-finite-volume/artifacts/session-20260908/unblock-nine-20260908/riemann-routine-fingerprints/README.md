# Info Routine structural expression fingerprints

The native export completed with actual exit 0 in 36,328 ms on input HEAD `5e3f63594aa964263469ada134aee2809559d50d`, tree `a093b2329df44be4afaad524ec58ab0a1b3f386a`. The four frozen worktree source owners and their compiled files are separately pinned. Every source, compiled owner, tool, prior inventory and HEAD pin remained unchanged across the export. Git identity and origin checks used only the prepared POSIX launcher.

`additional-expression-fingerprints.json` contains **37 eligible environment constants in four owners**, including all **22 authored declarations** from `riemann-routine-production/files.json`. Owner counts are 25 for `LocalRiemannRoutine`, 1 for `LocalRiemannRoutineUpdate`, 10 for `Examples.BiasedLocalRiemannRoutine`, and 1 for `RiemannLocalRoutineInterface`. `declaration-mapping.json` records each name's exact owner path/hash, module, kind, authored status, and type/body/universe/recursor token hashes.

All four prior inventories remain unchanged and disjoint: 1,089 constants across 147 owners. Adding this inventory yields **1,126 constants across 151 owners**. The complete 29-owner project import closure is covered by those prior owners and the four new owners; no un-fingerprinted project dependency was omitted or added implicitly. Mathlib dependencies retain their existing external-library status, with direct imported Mathlib source/compiled pins and the toolchain/package manifest captured in `inputs.json`.

The existing native exporter serializer and generated-name filter are unchanged after removing only imports, selected owner list and output path. Its expression normalization removes metadata and bound-variable display names while preserving structural expressions, indices, universes and binder kinds. It is alpha-canonical structural serialization, not full definitional normalization. The unchanged v3 streaming token parser SHA256 is `fe089bb896ff20a624d9f34efbf957fea3c168a591ea9bfbd4235481dc595702`. The existing filter includes eligible public constructors, recursors and projections while excluding reserved/private/internal compiler details. Environment-constant counts are not authored theorem or source-row counts.

The raw native stream is 282,482,918 bytes, SHA256 `f2c9ce3f6b99414083bfdc1463ad4ec7c492691d4d93f94d41466c1357c7d18d`. Its deterministic gzip archive is 4,795,525 bytes, SHA256 `8436265ce5d19feeee243acea2e6ad9703a96fc2df17e73ec7601c6894543bd7`. Exact decompressed length and SHA256 were verified. The parser/archive execution also returned actual exit 0. **Retain and stage the gzip archive; exclude `native-expression-stream.jsonl` from staging.** `stage-files.json` supplies the explicit list. No staging or Git mutation was performed here, and the large raw file remains local.

The four owners are absent from both actual input HEAD and the shared anchor `9e2225705fed906b1120d55105d607baabef57c9`. The first read-only presence probe stopped on an overly narrow expected Git stderr spelling, without writing a result; that actual exit 1 is preserved in `origin-probe-first-attempt.json`. Additive `check-origin-presence-v2.py` accepts both exact absent-blob messages and records all eight actual exit-128 probes in `origin-presence.json`. The valid-revision and ancestry guards are retained. Native export and fingerprints were unaffected.

For a real lane after these exact bytes are committed, append:

```text
--fingerprints gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/riemann-routine-fingerprints/additional-expression-fingerprints.json
```

Retain all four previous fingerprint arguments: `chapter01-current-expression-fingerprints-24b3.json`, `baseline-equation03-expression-fingerprints.json`, `unblock-nine-20260908/final-fingerprints/additional-expression-fingerprints.json`, and `unblock-nine-20260908/local-replacement-fingerprints/additional-expression-fingerprints.json`. The existing `reconciliation-helpers/build_lane_inventory.py` reads `normalization`, `files` and `records` for each repeated `--fingerprints` argument, binds them to actual lane blobs, and rejects conflicting records or changed existing owners without reviewed transport. No lane inventory or candidate was constructed here.

Root may later run the optional committed-blob verifier through `workflow-v5.0.1-local/run_workflow_posix.py`:

```text
gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/riemann-routine-fingerprints/verify-at-commit.py --commit EXACT_40_HEX_COMMIT --label FRESH_LABEL
```

It verifies actual committed source/inventory/archive bytes and ancestry, then writes one additive local receipt. It has not been executed because the later commit does not yet identify the native input. The native input commit must remain `5e3...`; a later root receipt may establish the same source bytes at a later commit without rewriting provenance.

The separate `BINDING-PREPARERS-REVIEW.md` records the requested read-only helper review. No production, aggregate, tier, source, audit, gate or runtime file was changed. Structural fingerprints and kernel execution provide no source-faithfulness acceptance or reconciliation verdict.
