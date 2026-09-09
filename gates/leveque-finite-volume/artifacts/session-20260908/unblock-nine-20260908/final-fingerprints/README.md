# Additional native expression fingerprints

The bounded native export completed with actual exit 0 in 42,172 ms. Its actual input commit was `5e3f63594aa964263469ada134aee2809559d50d`, tree `a093b2329df44be4afaad524ec58ab0a1b3f386a`. POSIX Git independently read this identity before and after native Lean execution; native Windows Git was not invoked. The eight new source files were staged worktree inputs, pinned separately from that existing commit. No future commit identity is claimed.

`additional-expression-fingerprints.json` contains 382 constants from 21 disjoint owner modules: ten authored declarations in eight new source modules and 372 constants in thirteen unchanged reusable dependency modules absent from current24b3. Constructor/recursor/generated environment constants are not authored theorem counts. All 111 previous owner source hashes remain exact. The local project import closure contains 45 modules; 24 already had fingerprints, and the remaining 21 were freshly exported. The thirteen reusable source files equal both the shared anchor `9e2225705fed906b1120d55105d607baabef57c9` and the actual input commit.

The new source owners are:

| Owner file under `ComputationalMathematics/Source/LeVeque/Chapter01/` | Authored declarations |
| --- | ---: |
| AcousticsLeftSolutionDomains.lean | 1 |
| RiemannProblemDataClassification.lean | 1 |
| SourceTermsRectangleBalance.lean | 1 |
| MaterialInterfaceLocalRiemannData.lean | 1 |
| MaterialCellVolumeAveraging.lean | 1 |
| FiniteVolumeUpdateError.lean | 1 |
| RiemannInformationInterfaceFlux.lean | 1 |
| CoordinateSplittingBalance.lean | 3 |

`declaration-mapping.json` records every exact declaration, owner path/source hash, type/proof/universe/recursor hash, and source-row association. DIM's `_information` and `_cartesian` declarations remain companion dependency evidence; this inventory creates no extra source row or semantic acceptance. Combining current24b3 with the new inventory covers all 41 declarations in the current complete native target manifest.

## Exact normalization and retained evidence

The exporter reuses the prior `export-one-step-declaration-expressions.lean` implementation. A byte comparison confirms the filtering, alpha-canonical expression transformation, ConstantInfo handling and structural JSON serialization are unchanged; only imports, selected modules and output destination differ. Metadata and binder display names are erased. De Bruijn indices, universe levels, constants, binder kinds and expression shape are preserved. This is structural identity, not full definitional normalization or a source-faithfulness judgment.

The frozen existing v3 streaming parser is imported without edits (SHA256 `fe089bb896ff20a624d9f34efbf957fea3c168a591ea9bfbd4235481dc595702`). Hashes are SHA256 of exact compact JSON tokens, including string-token escaping. Bodies are streamed without retaining their expanded strings in the fingerprint JSON. The old current24b3 inventory (`c27b9c4b5b0bf1c6fa6f26300045423512118a24c0b24eff2b57f65d77f09400`) is unchanged, and none of its 556 records is rewritten or overlapped.

The native raw stream is 232,131,831 bytes, SHA256 `ea2bfee0ab1ea796fc25afbba11a13e056964ad3a92eadceb34765ff2d8edcbc`. Its deterministic gzip archive is 4,411,820 bytes, SHA256 `c9180a1cc73092ce44bb7a58d536654c4370c750ba50734039877407d21b1a0b`; decompression was checked for exact bytes and hash. Commit the `.jsonl.gz` archive, **not the large generated `.jsonl` file**. Raw local retention/ignore handling belongs to the coordinator; no ignore or Git configuration was changed here. The archive permits exact reconstruction of the stream in the pinned input manifest.

## Lane-inventory use after the actual commit

The existing `reconciliation-helpers/build_lane_inventory.py` directly reads `normalization`, `files` and `records` (lines 69–85), binds each source and fingerprint to the selected lane's committed blobs, and rejects overlapping unequal records. Its repeated `--fingerprints` option accepts this standalone additional inventory. It also refuses an existing owner changed relative to the shared anchor without reviewed transport (line 98); all thirteen freshly exported reusable owners were verified unchanged at that anchor.

For a lane that actually contains the new committed files, retain the existing inventory arguments and append:

```text
--fingerprints gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/final-fingerprints/additional-expression-fingerprints.json
```

The relevant complete list for that lane includes these three disjoint inventories:

```text
--fingerprints gates/leveque-finite-volume/artifacts/session-20260908/chapter01-current-expression-fingerprints-24b3.json
--fingerprints gates/leveque-finite-volume/artifacts/session-20260908/baseline-equation03-expression-fingerprints.json
--fingerprints gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/final-fingerprints/additional-expression-fingerprints.json
```

The first and new inventory together contain 938 constants / 132 owners. The retained Equation03 baseline producer inventory adds three constants / two owners, giving 941 / 134. Its existing SHA256 is `e29b3e71a3bffdba15b88e5e2ef5f45907e16aa982c40bb93da828c91aafd720`. It is neither replaced nor reinterpreted by this packet.

Run the unchanged inventory helper separately for each real configured work/inspection lane via the prepared POSIX launcher, preserving its `--topology`, `--lane`, `--output`, and applicable `--require-closed` settings. A lane without the new committed files must use its own existing committed inventories. Merely having the new inventory in another worktree cannot establish lane provenance.

`verify-at-commit.py --commit EXACT_FINAL_COMMIT --label FRESH_LABEL`, also through the prepared POSIX launcher, provides an optional additive receipt verifying the old current24b3 and new inventories, their 132 owner source blobs, native provenance files and compressed raw archive at the actual later commit. It checks ancestry from the native input commit and preserves that original identity. The other retained baseline inputs are checked by the lane inventory command itself. The verifier does not rerun native Lean, construct a candidate, change refs, stage files, or assert source acceptance. Its output is confined to a new `committed-source-verification-<label>.json` in this directory.

## Execution and limits

The actual preparation ran `prepare-inputs.py` under the existing POSIX launcher, `run-native-export.py` under native Python, then `freeze-additional-fingerprints.py` under the POSIX launcher. The native command is exactly `lake env lean gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/final-fingerprints/ExportFinalDeclarations.lean`. Only already compiled modules were imported; no full graph or Mathlib rebuild was run. Python syntax checks passed for every new helper. All new records are unique, disjoint from current24b3, owned by the exact selected modules, free of axiom declarations, and include exactly the expected ten new authored names.

Final committed-blob verification and real per-lane inventory execution remain coordinator work because the final commit does not yet exist. No gate, source/proof, audit, staging, ref, runtime or configuration mutation was performed.
