# Exact syntax-only fingerprint successor

This packet updates the current fingerprint binding after one parenthesis pair was added around the `AccuracyCertificate.bound` RHS in `PhysicalRefinementQuality.lean`. The preparation verifies the exact before/after source bytes and the successful build04 receipt. It finds exactly one changed source among all 183 fingerprinted owners. Across the prior 60-owner source/compiled closure, the only changed pins are that source and its `.olean`; every other one of the prior 29 selected compiled-owner hashes is identical. Actual HEAD remains `5e3f63594aa964263469ada134aee2809559d50d`. There is no future commit or candidate claim.

Native `lake env lean` exited **0** in 38,875 ms and exported **83 eligible constants**, including all **12 explicitly authored declarations**. Source, compiled, native-tool and POSIX HEAD hashes were rechecked before and after. The same serializer, generated-name filter, and pinned v3 streaming parser are used. All 83 complete record objects exactly equal their slice of the frozen previous 560-record export: names, modules, kinds, normalized types, values, universes and recursor bodies. `structural-equality.json` records this all-field comparison. This is structural alpha-canonical equality, not a source-faithfulness verdict or a general definitional-equivalence checker.

The resulting consolidated inventory retains **all 1,688 records exactly unchanged across 183 owners**. Only the one owner source binding and its current native provenance are replaced. The other 182 owner provenance objects are copied exactly from the previous packet; their historical native executions are not relabeled as fresh. The earlier 29-owner package, all seven older inventories and their actual failed/successful attempts remain untouched. The actual current compiled-pin observations are in `current-scope.json`; unchanged source/dependency scope is checked again at freeze.

The parser/equality/archive run exited **0** in 16,203 ms. The raw stream has 58,741,131 bytes, SHA256 `4504d6a18661b4fd0d3ec710d46159bf133f5f07b6eeab677295a5a8e8aad99e`. Its deterministic gzip (empty filename, mtime 0) has 1,094,387 bytes, SHA256 `d040e03cd61a6514c80d0047322afc2f2647293d6d584f4de12c7d4f97320778`; exact decompressed bytes were verified. Keep the raw JSONL locally, publish the checked gzip, and exclude generated caches. `stage-files.json` is an artifact allowlist only; no staging occurred.

Use this single current inventory in place of the previous consolidated inventory or seven historical arguments:

```text
--fingerprints gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/physical-syntax-fingerprints/current-expression-fingerprints.json
```

Do not append these inventories together. `fresh-owner-expression-fingerprints.json` is supporting evidence and is not another consolidated input. The actual later committed tree must independently match all 183 source hashes before lane/candidate use. Root owns organization, source audits, gate evidence and publication. This packet changes no production, index, Git reference, gate or ledger. Preparation, native export and freeze passed on their first runs in this successor folder; historical failures remain in the previous packet.
