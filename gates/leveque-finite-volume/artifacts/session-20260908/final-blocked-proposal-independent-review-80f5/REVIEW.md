# Actual prepared proposal: independent mechanical review

The bounded mechanical review passed with actual POSIX Python exit zero. No mechanical defect was found in the inspected proposal, preserved rows, provenance bindings, current native receipts, or installer V3 data prerequisites. This is not a source-faithfulness decision, substantive exhaustion finding, installation authorization, or terminal certificate. The separate substantive reviewer owns the row-exhaustion assessment.

Exact reviewed objects:

* Preparation SHA `c12dc8ca1662acd5a024188a1124e58d9f4a8f7c6882d6520c4d42254461f41e`, at `blocked-gate-binding-transcript-order-v2/runs/final-80f5/preparation.json`.
* Proposed gate SHA `e264dd1cea8cdc57b0389876aad410092df72c1ad48ca1fb73d14049374659c0`.
* Still-ACTIVE operational gate SHA `b5538b8881e3a3e58e6cc43aa03344072f4bb9d692516599144820f049599d2e`.
* Independently observed current HEAD `80f5d4340d507dbc347a806717ff31c5a9aace72`.
* Installer V3 SHA `6e2fb502fbd341eaedee506710e5a49067bfbaa3f153bd34ee5f44638b389dad` and frozen binding helper SHA `dbfb374e263b7b0a2f25e9d1b8815a3e65d4e4e0e693581c24a881299fa017a9`.

## Row and provenance checks

All 32 accepted and 16 skipped row objects retain exactly identical serialized JSON bytes, including their types, fields and key order. `verification.json` lists every preserved row and its encoded-object SHA. This is object preservation, not an assertion that arbitrary original JSON whitespace survives a whole-file re-encoding. The separate immutable ACTIVE snapshot equals the operational gate bytes exactly.

The nine changed rows are precisely the pinned choice-row set. They have `HARD_BLOCKED` with `blocker_kind: material-user-choice`, match the root-authored `proposed-rows.json` exactly, retain all fields outside the frozen transition whitelist, and have no remaining actionable fields allowed by that contract. The complete ordered 57-row identity set is unchanged. Only `rows`, `chapter_gate`, and `verification_evidence` differ at the top level.

The source manifest (`99fb785787ccfe7906b95ff0dc1d4d774bcd664673cc3c7c9323e9d29ae2c0c3`), current projection (`15f55c43d5d3c50134b1861d82231e953c6644db4cd30561d0644640b3e11acc`) and route manifest (`968a467fb9554e1bb464c7e753af19f72fdef86a1198127c6e525a5c66dff3c4`) were checked through the frozen provenance validator. All nine selected question associations are pending, map to the relevant rows, and bind the actual original records. Each route record includes all seven required evidence-bearing categories and explicit completion/no-pending-action fields. Their narratives and blocking-evidence strings agree exactly with the proposed rows.

Those completion fields were checked as supplied records; this mechanical review does not establish their substantive truth. The independent exhaustion review remains separate. The source meanings, omitted alternative choices, and future audit dispositions were not adjudicated here.

## Actual receipts and global artifacts

All nine request receipt pairs were read and checked against their actual output hashes and zero exits: source inventory, layout retry, tiers, compatibility, hygiene, complete closed-row audit validation, declaration retry, focused build and full build. The constructor and V2 preparation themselves also have actual zero-exit command/output receipts bound to the exact request and preparation reviewed here.

The final native input manifest is SHA `843d39a9cbe09dee437b1cdb61d4f480c31dcd1033da1e579b227c467749cc8b`. Its source hashes, exact ordered 32-row/native declaration metadata, check-file hash, ACTIVE base-row subject and base-gate hash match. The check file contains exactly the requested 32 `#check` and 32 `#print axioms` lines. All 32 actual axiom reports resolve to the expected names and only allowed axioms; no native error, warning or `sorryAx` marker appears. Declaration, focused-build and full-build receipts all name actual current HEAD `80f5...ce72` and the exact required argv. No new Lean build or semantic audit was launched by this review.

All eight proposed evidence artifacts were independently read, hash-checked and compared to recomputed expected bindings, payloads, counts and the corresponding actual receipt commands:

| Artifact | Count |
|---|---:|
| Source inventory | 57 |
| Organization scan | 1 gate |
| Faithfulness audit | 32 accepted rows |
| Declaration resolution | 32 |
| Axiom check | 32 |
| Focused build | 1 root |
| Full build | 2 roots |
| Hygiene | 0 findings |

The gate subject is `4bc10ccf583900daeeac10bbb067dcf2a163a25acb9c5379bd66bd717bdc027e`. The released proposed-record validators report all eight evidence checks complete with no defects, and both process loops satisfy their checked contract. All organization counters are actual integer zero. The current cross-gate set contains only `gates/leveque-finite-volume/chapter-01.json` and no counter mismatch.

## Current-context and installer boundary

The released `current_context` was independently queried read-only before and after validation. Its complete results agree, including actual current HEAD and all proposal/preparation bindings. All 338 observed input files were rehashed at the final boundary, and the exact live transcript prefix/suffix watcher was rechecked. The cross-gate set/counters were captured before proposed-evidence validation and compared afterward and again at completion. The operational gate remains exactly the original ACTIVE bytes.

These checks cover the data prerequisites used by installer V3: pinned helper/installer, exact reviewed preparation and proposal, unchanged operational base and request inputs, accepted/skipped preservation, typed transitions, current source/question/route provenance, complete proposed evidence, repeated context/input/projection and cross-gate consistency. The lock path is not a symlink. No lock was acquired, output label chosen, temporary gate written or installer executed here. Root must choose a fresh label, maintain cooperative ownership of all relevant writers, acquire the installer lock, and repeat the same checks at the actual write boundaries after the separate substantive review. Any later relevant user message, changed input or changed context invalidates relying on this earlier observation alone.

The proposed `BLOCKED` value remains uninstalled in this review. The released installed-gate command, retained checkpoint handling and any terminal/campaign verification remain later distinct actions. No source acceptance, reconciliation acceptance or terminal verdict follows from this packet.

## Reproduction and retained evidence

The exact read-only check is `check.py`, invoked through the existing `run_workflow_posix.py` launcher with the native capture wrapper `run-check.py`. `check-01.exit.json` contains actual exit zero and all invocation/input hashes. Its raw output SHA is `40076e770da90d969a18ca0c988beaf0deed095a217df9c0b7f78852befc46c4`. `verification.json` SHA is `b960ff858e451be8341bfd8109b29c0079755296b71d59ee3be1cf56be3f64c2` and contains all 338 input bindings, preserved/changed rows, native receipt/axiom records and eight artifact comparisons.

The check reuses the frozen Reader/parser, header, transition, provenance, receipt, payload and proposed-record validation producers. It adds independent per-row serialized hashes, explicit root proposed-row equality, top-level change checks, source `#check`/axiom request coverage, exact artifact-to-receipt command mapping and the repeated independently queried current context. It does not call `prepare`, an installer, `verify-installed`, a new audit, a native build, or any Git mutation. Only this new review directory was written. The final freeze rechecks the recorded file bytes; it does not rerun or relabel the historical native checks.
