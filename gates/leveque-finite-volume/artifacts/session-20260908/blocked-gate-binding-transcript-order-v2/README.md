This additive V2 proposal replaces V1's timestamp-based question chronology with exact original transcript line order. Frozen V1, final-PASS binderV3, validatorV3, released scripts, operational gate, ledgers, production sources and Git state remain unchanged. Only this new scratch directory was written. Root must review before any operationally relevant use. No all-local-work exhaustion or HARD_BLOCKED finding exists here.

`blocked_gate_binding.py` retains three separate CLI modes:

- `verify-projection --input <absolute-projection> --sha256 <reviewed-sha256>` reads provenance only. It checks the pinned original own-thread transcript and frozen original records, then checks freshness again. It does not read or evaluate the operational gate, perform preparation, run a native build/audit, assess exhaustion or assert a terminal state. Its JSON output includes the actual host verification time and explicit non-assessments.
- `prepare --input <absolute-request> --sha256 <reviewed-sha256> --label <new-lowercase-label>` retains V1's immutable new `runs/<label>/` proposal with only `PREPARED_UNVERIFIED`. It never installs a gate. Its repeated `Reader.unchanged()` boundaries now also recheck the original transcript's fixed prefix and relevant suffix.
- `verify-installed --input <absolute-preparation> --sha256 <reviewed-sha256> --label <new-verification-label> --current-question-projection <absolute-projection> --current-question-sha256 <reviewed-sha256>` requires independently installed exact proposal bytes and exactly the preparation's question-projection bytes. It validates original transcript provenance again, retains all current context/input/released checks, and rechecks freshness after the released checker and immediately before the terminal receipt. There is no installation mode.

All modes run through the unchanged prepared POSIX launcher. From the workspace root, the actually executed provenance-only command is:

```powershell
python workflow-v5.0.1-local/run_workflow_posix.py lean-computational-mathematics/gates/leveque-finite-volume/artifacts/session-20260908/blocked-gate-binding-transcript-order-v2/blocked_gate_binding.py verify-projection --input C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/lean-computational-mathematics/gates/leveque-finite-volume/artifacts/session-20260908/current-thread-question-provenance-v2-batch10/projection.json --sha256 15f55c43d5d3c50134b1861d82231e953c6644db4cd30561d0644640b3e11acc
```

The future prepare/verify-installed modes use the same launcher and helper path with the exact arguments listed above. Neither was invoked. Run the synthetic suite by passing this directory's `test_blocked_gate_binding.py` to the same launcher. Temporary fixtures remain inside this directory.

`input.schema.json` is the closed transport schema. The request, source manifest, reviewed route manifest, proposed-row schema and all other non-projection definitions are identical to frozen V1. Only the following three definitions change. Every listed field is required and extra fields are rejected:

```text
questionProjection:
  schema_version: 2
  kind: "current-material-choice-projection"
  thread_id: "01a07fae-4a67-7770-98b0-b95c4e393705"
  source_path: "/c/Users/qed_s/.codex/sessions/2026/09/08/rollout-2026-09-08T02-22-04-01a07fae-4a67-7770-98b0-b95c4e393705.jsonl"
  scanned_line_count: positive integer
  snapshot_prefix_sha256: lowercase SHA256
  extracted_at_utc: actual host UTC ending in Z
  chronology: "transcript-line-order"
  projection_review: meaningful reviewed string
  provenance: {path, sha256}
  timestamp_regressions: [{earlier_line, later_line, earlier_timestamp, later_timestamp}]
  questions: [question]
  replies: [reply]
question:
  question_id, call_id, question_index, line, row_ids, exact_text,
  record, record_sha256, timestamp, status, mapping_review
reply:
  question_id, line, exact_text, record, record_sha256, timestamp
```

All record/provenance references are exact `{path, sha256}` objects with safe Lean-repository-relative POSIX regular-file paths. Record timestamps are literal original UTC strings; line numbers are positive integers and question indices are nonnegative integers. `question_id` is exactly compact JSON `["request_user_input_async", call_id, question_index]`. Questions may have empty reviewed `row_ids`; multiple rows can share one actual question. Nonempty mappings must contain distinct identities from the pinned nine-row set. The helper never invents a source mapping.

The source path and own-thread ID are pinned to the actual thread. At each boundary the scanner hashes the exact original bytes through `scanned_line_count`, including line endings, and confirms the original `session_meta.payload.id`. Original event ordinals, when present, must equal the one-based line number minus one. It extracts only native `response_item` question tool calls and explicit user reply records. Question text must equal the selected native `arguments.questions[index].title`. Reply text must equal the original answer associated through its exact native `questionItemId`, and that reply must occur at a later original line than its exact question. Every projected event's raw `.jsonl` bytes, hash, line, ID/index, literal text and timestamp must match the original. All native questions and structured replies through the snapshot must be represented; no omissions or fabricated answers are accepted.

The bound extraction provenance must have kind `exact-own-thread-record-extraction`, match the projection's thread/source/count/prefix/extracted-time fields, and contain precisely its original-record references in line order under `selected_original_records`. Its complete bytes are hash bound, including root's additional extraction metadata. V2 does not relabel a synthesized extract as an original record or infer completeness from a hash alone.

Freshness is conservative: any later question, structured reply, or ordinary user message requires a fresh reviewed projection. Ordinary user messages are not interpreted as answers automatically. Later unrelated assistant/tool records are permitted. Prior ordinary user messages remain unexported; root's substantive projection review must account for their meaning before use. The live transcript is deliberately excluded from the whole-file `Reader.observed` map because legitimate records keep appending. Its exact prefix and suffix rules are watched separately and rechecked; frozen record/provenance files remain normal immutable Reader inputs. No reasoning or unrelated message text is emitted.

`timestamp_regressions` must be exactly the list of strict decreases between adjacent selected question/reply events in original line order. It preserves both literal timestamps and both line positions. Record timestamps are never compared to host extraction/review times or used to reject a reply occurring later in the transcript. Actual host `reviewed_at_utc` on an exhaustion manifest must be at least actual host `extracted_at_utc`; no future host date is invented to exceed a regressed source timestamp. The CLI reports its actual host `verified_at_utc` separately.

The actual checked projection contains 11 questions and two structured replies across 13 original records. The first two answered questions have empty row mappings. Q7 maps both FV-update and interface-flux; the other necessary pending choices collectively cover the nine current READY rows. Q11 has no mapped blocker row and remains pending. These are facts about the pinned projection, not hard-coded forever-pending statuses. The helper derives pending/answered from actual structured replies and requires each future selected blocker question to be pending, unmixed with an actual reply, and explicitly mapped to that row. A newly typed answer or scope change in the live suffix forces root review even without a structured reply.

All V1 endpoint constraints remain in force: the exact ordered 57-row set; immutable accepted/skipped content and JSON types; 15 PROVED, 17 REUSED, 9 typed material-user-choice HARD_BLOCKED, 16 SKIPPED only in a reviewed hypothetical proposal; meaningful obstruction/attempted_routes/blocking_evidence/resume_condition strings; exact source/question/route pins; all seven completed local-route categories; literal `all_local_work_complete: true`, `remaining_local_actions: []`; no actionable fields; exact current controlled context and native inputs. This is a fixed conditional scenario, not a classification of the nine rows. If any row is accepted, any selected question answered, or any local action remains, do not use that scenario.

The source inventory, layout, tier, compatibility, hygiene, full validator, declaration/axiom, focused-build and full-build receipts remain required with their actual zero exits, raw output hashes, exact command tails, native input commit and all V1 validation checks. Audit argv is strictly the pinned validatorV3 with `--validate` only; inventory-only output and `--require-all-closed` in this blocked-specific path are rejected. Final-PASS binderV3 retains its unchanged separate audit arguments. All eight unchanged released evidence payloads and `evidence_defects` checks remain mandatory. Accepted audit decisions and stronger-result semantics remain the pinned validator's responsibility; no blocked row gains successful audit evidence.

Installed verification still runs the exact released checker `check <actual-gate> --unit 1 --mode default`, with no `--require-pass`. Its actual output must derive BLOCKED, show zero actionable rows, nine blockers, exact 32/9/16 counts and 32/41 progress, closed organization/semantic loops and all eight verified evidence records. Exit zero alone is insufficient. No integration, reconciliation or campaign closure follows automatically.

The remaining real evidence is unchanged: substantive row-specific source-boundary and local-route exhaustion findings; latest truthfully reviewed question/reply provenance; refreshed immutable ACTIVE snapshot with current accepted artifacts; final declaration-input manifest; all nine real final receipt pairs; root's independent reviewed atomic installation/concurrency procedure; and separate campaign/organization/reconciliation obligations. The existing source-only manifest asserts no exhaustion. This helper verifies records, declared associations and required evidence structure; it cannot prove source meaning or exhaust mathematics from narrative strings.

The final 90 synthetic tests passed with actual exit 0 in `fixture-tests-03-exit.json`; that receipt binds helper/test/schema bytes. The suite retains all 53 V1 guards and tests exact line/ID/hash/association/completeness failures, clock regression in proper sequence, new ordinary user-message rejection, unrelated suffix acceptance and boundary rechecks. It also compares eight unchanged V1 core function ASTs and all non-projection schema definitions. The unchanged released `evidence_defects` validates all eight synthetic payloads. Fixtures provide no real build, audit, exhaustion or terminal certificate.

`actual-projection-02-exit.json` records the final real provenance-only execution: actual exit 0, host verification `2026-09-08T14:02:07.290913Z`, snapshot 14462 and no later relevant records/user messages at the checked boundaries. Its exact disclosed regression is line 11422 (`2026-09-08T15:24:38.286Z`) to line 13693 (`2026-09-08T13:14:54.978Z`). This freshness statement is bounded to that execution. Earlier fixture/projection outputs remain historical. No separate JSON Schema meta-validation was performed; no package was installed. Direct runtime guards and released pure evidence checks run without that dependency.
