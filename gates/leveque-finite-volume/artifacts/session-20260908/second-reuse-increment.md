# Scalar hyperbolicity reuse and chapter checks

`NumStability.leveque01_scalarEquation_isHyperbolic` is now recorded as REUSED
from the unchanged canonical owner at the integrated baseline. Fresh successor
`LEV-CH01-SCALAR-HYPERBOLICITY-CANONICAL-20260908` completed all four isolated
roles, all 34 semantic dependencies and 18 checks, and complete-phase validation.
Its accepted classification is faithful-equivalent, both implications are yes,
and there are no findings or adjudication triggers.

| Audit artifact | SHA-256 |
| --- | --- |
| manifest.json | 893c8181a15cbfa5caaceda82fe35bc6d0b8845a534ae444487dc4ad2c75c7da |
| decision.json | 9719d0aeae305ae229a3f366424912f29349bc68d457e982aee268707b1e36c3 |
| report.md | 71c681a2f5ae07d7d118bf5841c0c07cbba99208f54c80282537dba7faccb33b |

The row adapter reran complete validation and bound the actual accepted
artifacts. The authoritative gate check exited 0 and derived ACTIVE:
PROVED=1, REUSED=2, READY=30, UNCLASSIFIED=4, SKIPPED=17; formalized=3,
remaining=34, denominator=37, percentage=8.11%, deferred=0.
All global gate evidence remains OPEN.

The native Chapter 1 canonical and compatibility build completed with exit 0
(2761 jobs). Three existing canonical/legacy import test targets completed with
exit 0 (2766 jobs). All 47 current public source theorems resolved, and exact
per-theorem axiom-output parsing found only propext, Classical.choice and
Quot.sound (or no axioms). The generated check input is reconciled against the
current owner files, not just a hardcoded count. These results and their raw
input/output/owner hashes are preserved in receipt
`verification-receipts/3b4a217d380de1ab6df7174ee98fd4f23fba8eab28817af79aca636719a01015.json`.
The separate full ComputationalMathematics/NumStability build is still running.

Before the successful chapter build, the initial broader build was deliberately
interrupted after a verified read-only cache download. Native
`lake exe cache get-` fetched 6095 missing pinned Mathlib cache archives with
exit 0; `lake exe cache unpack` decompressed 5797 archives, with 2236 already
decompressed, and exited 0. Only the exact owned Chapter 1 Lake process tree
was stopped before unpacking. No interrupted build is reported as passed.
Mathlib remains clean at e8ea1afc32790ce1d4e1a4e45cc412ba9388716b.

The second-order wave-classification and variable-coefficient state-only-flux
scratch candidates now elaborate with only allowed axioms. Their source
correspondence is pending, and no production mathematics was added.
The two unsuccessful second-order scratch outputs remain explicitly preserved:
an initial mistaken Sqrt import path and a subsequent simplification failure.
The final output has no proof error or unexpected axiom.

The session-local no-text-conversion rule also exposes the original CRLF
`installed-version-before.bin` as different from the earlier normalized Git
blob. The current raw backup is retained exactly in this checkpoint; the
installed audit VERSION continues to match the sealed LF bytes. The
whitespace check is run with command-local `core.whitespace=cr-at-eol` so
preserved CRLF is recognized as line termination without rewriting audit bytes.
