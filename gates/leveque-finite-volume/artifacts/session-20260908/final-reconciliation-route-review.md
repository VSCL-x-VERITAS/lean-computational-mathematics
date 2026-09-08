# Local route to a candidate-bound reconciliation epoch

This preparation records the released workflow route. It creates no candidate,
epoch, acceptance receipt, or protected-ref update.

The configured task is prepare, with remote writes forbidden and admission
backend none. After all Chapter 1 obligations and all eight global checks pass,
commit the exact material result, advance the current lane pin, and refresh
the request with the generated arguments. Invoke exactly one PASS checkpoint.
The released checkpoint prepares a scratch candidate. Its first invocation
may report that candidate epoch validation is still required after recording
the candidate; that message is not permission to repeat the PASS checkpoint.
Continue from the recorded candidate with a complete epoch and the launcher's
validate command. The configured prepare route can finish locally VALIDATED.
No external integration or stable-promotion receipt is needed for that local
pre-admission route; those receipts are required for the separate protected-ref
admission and promotion routes, which are outside this task's authorization.

A final epoch has schema_version 2 and workflow_schema_version 3. It must use
the exact refreshed topology, shared anchor, every configured lane head,
and the candidate commit/tree actually recorded by the launcher. The assets
must account for all selected declarations, proofs, source rows, modules,
audits, gate and retained unique branch evidence. The existing preview builder
is a reuse candidate, but the final run must use the final committed head,
updated native fingerprints and all-closed requirement. Rejected, ambiguous,
and abandoned historical audit records remain retained evidence, never current
acceptance. Equation (1.3) requires the explicit producer/full-reaudit transport;
the root-reviewed controlled-hash convention must also be used in its assets.
Every affected book needs a current-tree verdict or an honest reopening.
Scoped organization findings and repository ratchets must come from actual
current scans, with no invented empty sets. Every unique lane asset must be
retained or have an acyclic selected successor.

The eight validation fields occur in the released order:
source_coverage, import_graph, signature_graph, body_graph,
declaration_resolution, focused_build, full_build, pristine_replay.
Each contains actual PASS status, candidate tree, token-array command,
output SHA-256 and elapsed milliseconds from a successful run. Placeholders,
booleans, fabricated empty output, or receipts from the pre-candidate worktree
cannot supply these fields. The verifier recreates a no-hardlink checkout,
executes each command in that order with a scrubbed environment, compares
actual output hashes, and rejects tracked or untracked checkout changes.

Commands must be permitted checked-in Python/Lean checks, Lake commands or
the read-only Git allowlist. Python script position, path confinement and
allowed Lake output flags matter. The Windows launcher is required for
released Python, and the pinned native Lean/Lake toolchain must remain usable
from the replay environment. Any cold-cache bootstrap must happen through
permitted checked-in commands and preserve the pinned dependency bytes; no
external workspace reads or relaxed validator checks are acceptable.
The existing candidate-architecture helper and deterministic quiet build
commands should be reused after their final input names and graphs are bound.

After an actual candidate epoch validates, run check-latest and the campaign
preflight. Report local validation/checkpoint/queue status exactly. Do not
describe the candidate as integrated or promoted without separately supplied,
verified external authority and an authorized admission action.

