# First validated reuse increment

Session `codex-start-1-v5-0-1-20260908`. The unchanged integrated declaration
`NumStability.leveque01_hyperbolicMatrixDefinition`, owned by
`ComputationalMathematics/Source/LeVeque/Chapter01/Hyperbolicity.lean`, is now
recorded as REUSED.

The fresh v1 successor
`LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION-CANONICAL-20260908` completed independent
source extraction, blind translation, direct judging, and round-trip judging.
The sealed deterministic adjudication check required no adjudication. Both
implication directions are yes and the accepted classification is
`faithful-equivalent`. Dimension zero is an explicitly recorded valid algebraic
extension; it is not attributed to the source as a discussion of empty PDEs.
The source's wave-speed interpretation remains context for this definition and
has a separate open gate row.

| Artifact | SHA-256 |
| --- | --- |
| decision.json | 0f5cd7898d4df556d7846bae42196ac05345bea41672a1b1b6bc570de495fb2d |
| report.md | 5f97d7338dd6859358e9990ba1b8134b8c377d17368d16b2d5d94851e0da6395 |
| manifest.json | 7168d41fca106ab62ffd6c4bb73037778c3c7c5ebf29ded5c647a169e9cb7795 |

The row adapter reran the unchanged complete-phase validator, checked source
identity, resolved the declaration and its allowed axioms, and verified that
the target file is unchanged from integrated baseline
`9e2225705fed906b1120d55105d607baabef57c9`. It retained the prior gate and wrote
new row-bound wrappers over the actual raw audit. It generates no semantic
decision. The authoritative gate check then exited 0 and derived ACTIVE:
54 total rows; PROVED=1, REUSED=1, READY=31, UNCLASSIFIED=4, SKIPPED=17;
formalized=2, remaining=35, denominator=37, percentage=5.41%, deferred=0.

All eight global evidence fields remain OPEN. Inherited zero organization
counters and the two recorded semantic rows are not asserted to close global
verification. The broader Chapter 1 build and subsequent audits are ongoing.
The new one-step scratch candidate elaborated with exit 0 by directly reusing
Mathlib's factorization theorem; it is not a production declaration or closed
row.

Released Python commands were executed through the prepared native-to-POSIX
launcher with the exact session FAITHFULNESS_AUDIT_CONFIG:

- `.faithfulness-audit/scripts/validate_audit.py TASK --phase complete`
- `session-20260908/close-reused-row.py --gate-checker MODULE/scripts/gate.py --gate gates/leveque-finite-volume/chapter-01.json --task TASK_PATH --row LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION --resolution-log session-20260908/hyperbolicity-declaration-checks.txt`
- `MODULE/scripts/gate.py check GATE --unit 1 --mode default`

Here MODULE, GATE, TASK_PATH and the resolution-log argument are resolved to
the absolute current-worktree paths in the execution record; these short forms
are documentation only. Reconciliation remains a separate durable checkpoint
process and does not confer campaign integration.

Before committing, session-local Git attributes disabled text conversion for
hash-bound artifacts. The POSIX staged-byte verifier compared all 22 selected
files (the complete successor task and its gate bindings plus the Lean output)
against their Git index blobs and passed. This preserved the exact recorded
manifest, role-output, and gate-wrapper hashes, including CRLF where present.
