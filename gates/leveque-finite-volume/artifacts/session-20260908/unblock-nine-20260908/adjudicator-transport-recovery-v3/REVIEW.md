# Lossless DIM adjudicator transport preparation

This additive V3 prepares recovery only after the recorded original adjudicator failed before a role turn because its input exceeded the native 1,048,576-character limit. It does not alter a source, target, judgment, released protocol, original role wrapper, or original attempt. Root owns the separate execution command below.

The actual DIM attempt `a` has only one `thread.started` event, no `turn.started`, exit 1, and the native `input_too_large` error reports 1,579,214 characters. Its original input hash is `299f1c015d7845a8e9224cb859531ae5f3d243e74604264d989d7c4335149f43`. The original wrapper receipt remains an actual failure; a later recovery result has separate provenance.

V2's exact whole-document substitution still leaves 1,265,980 characters. V3 keeps the entire direct declaration dossier verbatim as a same-prompt canonical document. It references the identical complete direct review packet already inside that dossier, then substitutes only exact common whole-line spans of the blind dossier with explicit references to canonical UTF-8 byte ranges and SHA256 values. Every unique Markdown byte remains in the prompt. Each omitted duplicate is present verbatim in the complete canonical dossier in the same prompt. There is no name normalization, approximate matching, external read, summary, or semantic omission.

JSON compaction removes only space, tab, CR, and LF outside quoted strings. It preserves every other original byte, including string escapes, number spellings, and Unicode escapes; duplicate keys and nonfinite JSON constants are rejected. All parsed JSON values are checked equal. Original header hashes continue to identify original documents; the in-prompt notice explains the transport representation. Original JSON formatting is restored from its pinned file for exact native reconstruction. Images remain byte-identical and in the same native command order.

The actual prepared input is 1,042,463 characters, leaving 6,113 below the observed native limit. Native reconstruction restores both original dossiers and the entire 1,579,214-character input exactly. The pure transformation and reconstruction are repeated at execution, with exact plan/input/pin equality. The transport provides no preferred judgment. The role remains fresh, one turn, and tool-free.

`derivation.json` records that every original V2 operational function is AST-identical in V3. Only `deduplicate`, new pure transport helpers, and the `difflib` import differ. The existing genuine-unstarted-failure, image/argv, pinned-input, unique-new-attempt, native event, unchanged collector, append-only role metadata, released manifest transition, finalization, and complete-validation checks are retained. The successful released finalizer may update only its documented completion fields; V3 preserves the separate finalizer and validator actual exits and outputs.

Thirty synthetic tests passed with actual exit 0. They include the original failure/provenance/manifest guards and rejection of changed JSON values, changed unique Markdown, missing references, incorrect reference hashes/ranges, altered canonical content, marker collisions, duplicate input names, and prompt framing changes. No role, collector, finalizer, or audit validator was invoked by these tests. Actual DIM plan preparation then passed with exit 0. The preparation inspected and pinned the failed task without mutating it.

Ready files:

- `recovery-v3.py`: `a2dddf4c3d7ca324f44fe9034b76964514d4c1e4eee96ea72bb5e48f90ff9887`
- `dim-a2/plan.json`: `a3b1171226078de931417271f072a100f42eb246588340a6ae8d3e98e9c50eb8`

From the Lean repository, root may use the actual native Python executable with:

```text
-X utf8 -B gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/adjudicator-transport-recovery-v3/recovery-v3.py execute gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/adjudicator-transport-recovery-v3/dim-a2/plan.json --plan-sha256 a3b1171226078de931417271f072a100f42eb246588340a6ae8d3e98e9c50eb8
```

The plan selects fresh attempt `a2`; old `a` and all original q/r/c files remain unchanged. If the current task gains a decision, an `a2` file, changed input bytes, or changed original role metadata before execution, the existing guards reject it. This packet records preparation success only. Actual adjudication, collection, finalization, and complete validation remain future root execution results.
