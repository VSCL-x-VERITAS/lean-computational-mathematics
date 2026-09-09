# Exact plaintext adjudicator transport, prepared for root review

This additive proposal applies only to `LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908`, failed native adjudicator attempt `a`, and unused fresh attempt `a2`. No role has been invoked by this preparation. No audit, production, gate, ledger, Git, configuration, or released-kit file was changed. Historical V3 and direct recovery helpers remain unchanged.

## Actual evidence and preserved lineage

1. The original role wrapper receipt SHA256 `697c9141544f9726e7d147d440ebc693665758f53089a6d0ba491ff862492f82` remains exit **1**, caused by the original direct input capacity failure before a turn. Its output, stderr, exact q/r/c helpers and prepared transport remain pinned.
2. The reviewed direct recovery execution receipt SHA256 `ff748b4eabd174f08c839c82978233240bcd6f0eb95d951e465d15c85a2f68ad` remains exit **0**. Its exact five steps are prepared validation 0, fresh direct 0, direct collection 0, original roundtrip collection 0, and adjudication-required check 3. It explicitly did not complete the audit or invoke an adjudicator. The four canonical roles and their unique actual runtime identities are pinned separately. The two original source/blind runtime records remain exact prefixes of the four records.
3. Root's unchanged-q continuation in `../dim-original-adjudication-continuation-01/receipt.json` remains exit **1**. The unchanged q SHA256 is `cb4de37169eabf1a3ad35ed84806d1218c35c72bc67f93abf4386189a250a44f`. Its native a stderr reports `input_too_large`, maximum 1,048,576, actual 2,740,284 characters; a events contain only `thread.started`, with no turn or final. The original input is 2,789,760 UTF-8 bytes, SHA256 `095cd9d4e4fea185e53bad591727277922c544705f83ca45986d5920e356390c`. The continuation's actual output/stderr and all four unchanged canonical roles are independently pinned.

The earlier direct attempt's long duration ended in a successful actual role without intervention. It was not demonstrated to be a process-start failure; this proposal does not change or diagnose that result.

## Representation and independent reconstruction

The prepared `dim-a2-01/input.txt` is **1,018,654 Unicode characters / 1,150,924 UTF-8 bytes**, SHA256 `eabaa31418ebc24f25cb59a1f0eae2aa2119d1fd1fbecd999eeb48ded1a8f211`. It leaves **29,922 characters** below the native character limit. Byte count is explicitly separate; the bound is not a 1 MiB byte bound. Its 18 original document headers, identities, and order remain visible and unchanged. All five exact source images remain in the original native command.

The prompt begins with an explicit finite plaintext grammar. It contains 2,213 visible raw blocks, 12,872 block references, and a final table of 865 literal phrases. The transport does not contain gzip, base64, binary encoding, semantic summaries, renamed declarations, inferred definitions, new source facts, or a requested verdict.

Expansion is ordered and nonrecursive within each layer:

1. `⟦bN⟧...⟦/b⟧` displays block N. `⟦N⟧` denotes the entire displayed block. `⟦N:start:end⟧` denotes its zero-based UTF-8 byte interval, measured before phrase expansion. Blocks contain no block references. Replace references, remove block wrappers, and concatenate without inserted characters.
2. `⟪AN⟫...⟪/A⟫` in the final table displays literal phrase N; `⟪aN⟫` denotes that exact value. Phrases can include whitespace, punctuation, partial expressions and JSON-display wrappers. Phrase values contain neither phrase nor block references. They express literal equality only.
3. `[[AJ0]]text[[AJEND]]` displays an exact JSON string value whose original token uses literal Unicode; `[[AJ1]]...` uses JSON Unicode escapes. Restore original quoting/escaping. Other JSON token bytes remain exact. Only JSON formatting whitespace outside strings is removed; the native reconstructor restores it from each separately pinned original JSON document after verifying exact token equality and parsed-value equality.

`plaintext.py` reconstructs using the full explicit mapping, checking original bytes/digests, every displayed/reference span, phrase counts, block bounds, JSON tokens, and original document order. **`visible.py` is a second reconstructor that does not read the encoder mapping:** it parses the displayed grammar itself, expands its raw definitions/references, independently reconstructs JSON string tokens, checks them against pinned originals, restores formatting, and produces the exact original 2,789,760 bytes. This demonstrates that the visible prompt itself carries the reference definitions; the external mapping is provenance, not hidden information needed to identify a phrase/block.

Every source, direct/blind dossier, dependency, definition/type, judgment, interpretation, trigger and binding supplied to the original a attempt is recovered unchanged. The full direct packet is represented by exact fragments; it is **not claimed to remain contiguous verbatim**. All unique terminal content remains visible in the same prompt. The large number of short references imposes reading overhead; root should inspect the actual representation before authorizing the new attempt. Mathematical adequacy and audit classification remain entirely with the fresh adjudicator and released validators.

## Released requirement versus previous local guard

The selected sealed v1 kit at `formalization-collaboration-v5.0.1/skills/formalization-faithfulness-audit/kit` requires fresh stateless roles (METHODOLOGY.md line 93), and its SKILL.md lines 90–92 require the exact trigger reasons, primary source, **complete direct and blind dossiers**, source contract, blind translation and both judgments. METHODOLOGY.md lines 129–130 require complete primary evidence. Those requirements are preserved by exact reconstruction of the unchanged full original input, with every reference definition inline. SKILL.md lines 65–69 specifically require the blind translation packet inline and prohibit its tools; this adjudicator proposal also keeps the existing one-turn, tool-free, all-inline protocol.

The additional requirement that the direct packet appear *contiguous verbatim* was in our local earlier transport code, not the released wording above. Root explicitly authorized a new representation after inspecting that distinction. This new helper leaves that older local guard and all released kit files untouched. It neither removes evidence nor relaxes role/schema/provenance checks. There is no multipart API bypass; installed/public interface investigation showed that multiple text parts are subject to the aggregate character bound.

## Operational boundary and checks

`prepare` writes only a new child directory here. It validates the actual three-event lineage, before-turn capacity failures, four canonical outputs, four actual runtime records, exact original command and five images, original helper pins, native executable and source configuration. It encodes the entire actual a input, runs both reconstructions, enforces the character bound, snapshots the current prepared manifest and four runtime records, and pins 114 static inputs. It checks all of these again before writing the plan.

`execute` requires that exact plan hash and reruns the preparation guards and deterministic encoding. It first runs released prepared validation. It then appends only a2 input/events/stderr/final/transport/runtime files and invokes the original fresh native command, changing only the output filename from a to a2. The executable, flags, neutral working directory, configuration reference and all image arguments remain unchanged; no resume/fork/history/model override is added. It records actual Unicode/byte counts and digests, original expanded digest, start/completion transport metadata, actual exit and elapsed time.

A successful native attempt must have one fresh identity, one started/completed turn, no failed/error event or tool item. The unchanged `c.py` independently obtains actual runtime metadata, checks the one-turn/no-tools boundary, validates the output schema/hashes, and appends one adjudicator runtime. The helper verifies the four old runtimes unchanged and the new actual model equal to the old model. It next invokes the unchanged released finalizer and complete validator through the prepared POSIX launcher. It permits only the released manifest completion fields to change and checks all static originals before/after; it does not impose manifest byte immutability across legitimate finalization. The execution receipt retains all original statuses and separately records actual step outcomes, decision/manifest/report/runtime refs, and native environment pins before/after. It records whatever actual classification/acceptance results; no accepted verdict is required or assumed. A failed step stops; no automatic second retry occurs.

## Actual local validation and handoff

`tests-01/receipt.json` records actual exit 0 for 64 checks, including exact full reconstruction by both algorithms and mapping serialization; malformed/missing/overlapping references; phrase hash/count/ID/pool faults; JSON token/mode/hash faults; changed section order; stale source pins; three-event status relabeling; wrong helper/role identities; a started turn falsely claimed unstarted; changed image order/options; synthetic role reuse/tool/extra-turn events; and the valid versus invalid manifest completion transition. Synthetic event cases are explicitly marked and never used as real provenance.

`prepare-01/receipt.json` records actual exit 0. Both captures independently hash the original operational files before and after and report no new operational files. Preparation does not execute the native role, collector, finalizer, or any gate. The preparation's first two development key-name lookups were corrected before these final successful captures; no failed role or operational attempt occurred during local development.

Root's separately reviewed command, from the workspace root, is:

```powershell
& 'C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe' -X utf8 -B 'lean-computational-mathematics/gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/adjudicator-plaintext-dictionary-v1/recovery.py' execute 'lean-computational-mathematics/gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/adjudicator-plaintext-dictionary-v1/dim-a2-01/plan.json' --plan-sha256 04ef399e85d1e136585b69cea3d4a686c20d3d759bfa6cb32cc55607d83a56ab
```

The runner SHA256 is `7e1f729e600048d5cbe3878200eec24cb8c8cf20eb3178c6a825b20930cd3726`. This document is a preparation review, not a source judgment or terminal success receipt.
