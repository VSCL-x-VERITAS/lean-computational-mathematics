# Exact Info retry-lineage transport successor

This is an additive successor to frozen V3. It supports only the exact Info Routine
task, the reviewed malformed-roundtrip handoff plan, first adjudicator stem `a`,
and fresh recovery stem `a2`. It has not prepared a real transport plan or launched
a role. A future failure is not inferred from a large anticipated prompt.

All 20 existing functions other than `prepare` and `execute` are AST-identical to
V3, including native input-limit verification, JSON token-preserving compaction,
same-prompt dossier references, exact full prompt reconstruction, runtime append,
and finalizer manifest-transition guards. The existing unchanged collector and
released finalizer/complete-validator commands remain unchanged.

The additional guard requires the exact frozen handoff helper, plan and preparation
receipt, then the actual handoff execution receipt with exactly two steps: successful
fresh r2 collection and failed unchanged q continuation. It checks the new
continuation stdout/stderr receipts and q argv, all four successful canonical-role
validation boundaries, and the actual required-adjudication boundary. The original
schema-failure wrapper receipt and logs remain pinned separately. It cannot use that
old schema failure as evidence for a native input-limit failure.

The five current runtime entries must equal the four original actual entries plus
exactly the reviewed fresh r2 entry. The invalid original output must equal its
preserved archive and original r_final bytes. The new canonical roundtrip must equal
fresh r2 bytes. No history entry is removed or rewritten. All handoff input pins,
the fresh r2 runtime, actual collection/continuation evidence, and original prepared
manifest are rechecked both when preparing and before executing a transport plan.

In addition, the original V3 guard still requires a nonzero actual `a_transport`,
exactly one `thread.started` event with no role turn, explicit `input_too_large`
stderr with exact native limit and input character count, unchanged complete inputs
and images, and exact lossless reconstruction below the native limit. A malformed
adjudicator answer or a started role does not qualify. Fifteen synthetic lineage
tests passed, including rejection of substituting the original failure, missing or
failed collection, passing continuation, changed original logs, wrong task, later
failure, rewritten history, missing/extra retries, reused agent and wrong role.

Only after a genuine qualifying continuation failure, prepare with native Python
`-X utf8 -B`:

```
recovery-v4.py prepare <unchanged Info Routine spec.json> --failed-stem a --new-stem a2 --destination <this-directory>/info-a2
```

Preparation is append-only and returns the actual plan SHA and reconstructed input
size for review. Execution remains a separate `execute <plan.json> --plan-sha256
<reviewed-SHA>` action. No source, gate, canonical audit output, role protocol,
classification or interpretation is changed by this preparation.
