# Fresh malformed-roundtrip retry and proposed canonical handoff

The original Info Routine orchestration completed with actual exit 1 at
2026-09-08T19:26:10.827816+00:00. The released roundtrip validator rejected the
63-character `source_sha256` and its mismatch with the immutable source PDF.
The original output has not been corrected or reinterpreted. Its canonical copy,
all `r_*` bytes, runtime entry, and original wrapper receipt are preserved.

The sealed v1 skill, lines 47–49, requires: “Retry malformed output with a new
stateless agent, never by continuing the invalid role's conversation.” The
unchanged `orchestration/r.py` was therefore invoked with role `roundtrip-judge`,
fresh stem `r2`, and the same images `26,27,28`. Before launch and after completion,
the entire input was byte-equal to `r_input.txt`; inline documents and image pins
were identical. Neither the invalid answer nor retry feedback was supplied.
The new actual agent ID is `01a0827e-e647-7b40-8a3c-8ebdd968f44c`.

Fresh r2 completed with actual native/inner transport exit 0 at
2026-09-08T19:31:07.718534+00:00. The unchanged released schema validator plus the
exact AST-extracted roundtrip validation branch passed through the prepared POSIX
launcher with exit 0. The original answer fails the same guards with exit 2.
The unchanged collector's prefix independently verified the actual fresh session,
one turn, one final JSON, input provenance, and zero tool calls without writing a
canonical output. These are protocol/transport checks, not an audit decision.

`handoff-plan/plan.json` is prepared only. Its native preparation exited 0 and
captured released prepared validation, the three valid canonical-role validations,
expected invalid-roundtrip rejection, and fresh r2 validation. Fifteen guard tests
passed, covering changed pins, false passing-wrapper claims, repaired old output,
rewritten runtime history, reused agent IDs, extra/wrong-role appends, and forbidden
manifest changes. Exact source, target, setup, task inputs, q/r/c, retry files,
original wrapper logs, fresh runtime session, and immutable snapshots are pinned.

After root review, the exact `execute` command below will:

1. Recheck every pin and the unchanged prepared manifest, four-entry runtime
   history, invalid canonical bytes, absence of adjudication/completion, and fresh
   actual session. Create an exclusive execution marker.
2. Atomically move only the invalid canonical roundtrip file to the new handoff
   archive after exact byte guards. The already preserved snapshot remains too.
3. Invoke unchanged `c.py` to collect r2, append its actual runtime with unchanged
   `record_agent_run.py`, and run the released role validator. Require all original
   runtime entries to remain exactly equal and only the new fresh entry to append.
4. Invoke unchanged `q.py`, which validates the four current outputs and performs
   its ordinary adjudication check, any required fresh adjudicator, finalization,
   and complete validation. Capture this as `continuation-exit.json`, separate from
   the original wrapper failure. Independently run released complete validation
   again and allow only the released finalizer's manifest completion fields.

The released runtime schema and complete validator permit multiple actual runs of
one role: the original malformed invocation remains truthful historical evidence.
No malformed result is supplied to adjudication; the canonical result will be r2.
No classification, acceptance flag, source statement, or interpretation is edited
by this helper. A failed continuation leaves actual receipts and partial state for
review; it does not produce a fabricated successful receipt.

If the continuation's first adjudicator actually fails before a turn with an input
limit, its new continuation/transport/events receipts must ground any transport
recovery. The original q receipt records a schema failure and must never be recast
as an input-limit failure. Existing V3 assumes four role runtime entries and the
original wrapper receipt; it therefore needs a narrowly reviewed additive variant
for this exact retry lineage before that later use.

Run with native Python `-X utf8 -B`, from the repository:

```
python -X utf8 -B gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/riemann-routine-roundtrip-retry/recover.py execute gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/riemann-routine-roundtrip-retry/handoff-plan/plan.json --plan-sha256 <exact frozen plan SHA from receipt.json>
```

This command has not been executed by the preparer. Root owns the operational
handoff. No gate, source, production, audit judgment, Git ref, or stage was changed.
