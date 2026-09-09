# Obsolete tooling and duplicate import tests

This batch retires four historical architecture writers and 390 redundant
single-import tests from base commit
`b8ccf0d8bd610b599b13708e8c8518771bcf71ab`. It implements the remote-main
retirement audit without removing formalized mathematics.

## Tool retirement

The old `implement_chapter11.py` and `generate_tier_manifest.py` are completed
one-time migrations. `generate_c0005_planning_controls.py` and
`prepare_blocklu_phase12_source.py` are tied to historical inputs and trees.
All four move out of active tooling into the
[dated archive](../retired-tools/2026-09-09/README.md), with their exact original
bytes, hashes, immutable Git pins, and replay prerequisites. Current references
link to that archive. The R07 generator and renderer retain their live paths
because current checks still consume them.

The archive does not claim complete historical replay: the original BlockLU
`.ilean` was already missing from its old checkout. Its expected hash remains
recorded. Available original graphs and replay inputs were separately preserved
in the local evidence ledger; none was removed.

## Duplicate-test consolidation

Exactly 390 comment-and-single-import files are retired. They duplicate 372
retained standalone probes, each importing the same exact module in isolation.
Ten aggregators replace the retired imports with their retained counterparts;
their other bytes remain unchanged. The complete test-root import closure
retains every other node. No declaration-bearing test or old/canonical identity
fixture is retired.

The [test archive](../retired-tests/2026-09-09/README.md) contains every removed
file with its original relative path and complete original bytes. Its manifest
records each original hash, Git blob, imported module, and retained replacement.
`check_retired_tests.py --verify-history` verifies this evidence, the current
isolated replacements, and the absence of live imports of retired modules.
Its self-tests exercise corruption and loss-of-coverage failures. Both checks
run in CI.

## Mathematical and historical preservation

All 6,024 production Lean files, including the canonical modules and compatibility
forwarders, retain their exact base bytes. No theorem statement, definition,
proof, namespace, public production import, package target, toolchain pin, or
Mathlib revision changes. Consequently this batch cannot remove a source-book
result from a production file. Source ledgers and faithfulness-audit artifacts
remain unchanged.

Historical phase/delivery records keep their original paths and hashes. The
existing checkers validate those records from pinned Git trees. Independent
inspection found no phase artifact requiring a retired live path; the three
affected R10 materialization hashes match their immutable delivery revision.
The phase and completion checkers remain unchanged.

## Validation and publication

The local evidence ledger records the user's approval, exact source/archive
comparisons, isolated-import closure comparison, historical-reference analysis,
and command logs. The required architecture, build, test, warning, and lint gates
remain enabled. Publication requires green CI on the exact candidate commit and
an ordinary fast-forward of `main`.

The base commit's CI run
[34296186921](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics/actions/runs/34296186921)
passed architecture checks, library/test builds, `lake test`, and the warning
contract, but failed the lint contract. All 3,680 reviewed lint fingerprints
remain; 225 additional findings come from 46 production files added after the
lint baseline capture. They comprise 204 `docBlame`, 20 `unusedArguments`, and
one `simpNF` finding. None is in `NumStabilityTest`, and this retirement batch
does not change or relax the lint baseline.
