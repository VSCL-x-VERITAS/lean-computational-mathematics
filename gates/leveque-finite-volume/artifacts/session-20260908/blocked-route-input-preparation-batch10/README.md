# Request-only preparation for root review

`construct_request.py` is an additive input constructor for the frozen `blocked-gate-binding-transcript-order-v2/blocked_gate_binding.py`. It has not been run on operational inputs. It writes only a new immutable `runs/<label>/request.json` and `construction.json` beneath this directory. It does not assign row statuses, write blocker narratives, complete routes, generate native receipts, run `prepare` or `verify-installed`, install a gate, call Git, query `current_context`, run an audit, or establish source acceptance or local-work exhaustion.

The source schema remains the existing V2 `input.schema.json`, SHA `9daddcd180355375a4822206fa3056fb71d5b0abc84ca10606e9ea08870c12fd`. The helper pin remains `dbfb374e263b7b0a2f25e9d1b8815a3e65d4e4e0e693581c24a881299fa017a9`. No released script or earlier artifact changed. This is an optional process aid, not a replacement for root review or the frozen preparer.

## Parameter file

Root supplies one JSON parameter file and its SHA. Its exact keys are:

| Field | Required value |
|---|---|
| `schema_version` | Integer `1` |
| `kind` | `root-reviewed-blocked-request-inputs` |
| `base_gate` | Exact `{path, sha256}` reference to a separate immutable ACTIVE gate snapshot; the operational gate path is rejected |
| `proposed_rows` | Exact reference to root-authored existing V2 `proposedRows`: an object containing only `rows` |
| `check_inputs` | Exact reference to the final unchanged `prepare-closed-row-checks.py` input manifest |
| `source_manifest` | Exact reference to the final V2 `sourceManifest` |
| `question_projection` | Exact reference to the latest root-reviewed V2 `questionProjection` |
| `route_manifest` | Exact reference to the root completion dossier in the existing V2 `routeManifest` shape |
| `context` | Exact reference to a root-captured context JSON containing `lean_current_head` and `bindings`; any additional captured context fields remain hash bound |
| `receipt_labels` | Exact mapping of the nine categories below to nine distinct actual final receipt labels |

References use safe repository-relative POSIX paths and lowercase SHA-256 hashes. The parameter file itself may be passed by absolute path; all referenced inputs must resolve to regular files under the repository. Duplicate JSON keys, symlink inputs, missing files, changed bytes and malformed references are rejected by the frozen Reader/parser. The constructor never creates missing inputs or supplies default labels.

The context's `lean_current_head` is the actual 40-character current commit supplied by root. `bindings` must contain exactly these existing fields: `module_profile_sha256`, `unit_index_sha256`, `unit_record_sha256`, `unit_audit_epoch`, `gate_policy_sha256`, `lean_git_head`, and `lean_worktree_sha256`. The baseline binding `lean_git_head` is distinct from the current HEAD. The other digests retain their existing meanings. Context/base/check-input/route equality is checked against this snapshot, but the constructor deliberately does not assert that it independently refreshed current context or compared the operational gate. The later frozen `prepare` performs those actual comparisons.

## Root completion dossier

The constructor consumes the exact frozen `routeManifest` directly; it never converts the existing bounded review into a completion finding. All of these fields are required and the frozen helper rejects extra fields:

```text
schema_version: 1
kind: reviewed-local-work-exhaustion
input_commit: actual current HEAD
bindings: exact current context bindings
source_manifest_sha256: exact selected source manifest hash
question_projection_sha256: exact current projection hash
reviewer: meaningful actual reviewer identity/description
reviewed_at_utc: actual complete UTC timestamp ending in Z
rows: exactly the nine pinned choice-row records
```

Every row has exactly `row_id`, `question_id`, `all_local_work_complete`, `remaining_local_actions`, `obstruction`, `attempted_routes`, `resume_condition`, and `routes`. Root must explicitly supply Boolean `all_local_work_complete: true` and `remaining_local_actions: []` only when warranted by the reviewed actual work. Pending, missing or string-valued completion flags are rejected. Each selected question must be pending in the actual current projection and mapped to that row.

Every route item has exactly `kind`, `description`, `outcome`, and `evidence`. Its outcome must be `completed`, its description meaningful, and its evidence a nonempty list of exact existing file references. The set of kinds must be exactly:

* `source-review`
* `canonical-reuse`
* `mathematical-alternatives`
* `native-checks`
* `organization`
* `consumer-checks`
* `review`

Multiple evidence-bearing items in a category are allowed; all seven categories are mandatory. The constructor does not decide that an evidence file proves its narrative. It verifies the existing input conditions and hashes; root retains substantive responsibility.

Root also supplies the proposed-row object. The constructor copies its reference unchanged and reruns `check_transition`: the exact ordered 57-row set and accepted/skipped content must be preserved, and only the frozen conditional nine-row transition is permitted. It does not synthesize `HARD_BLOCKED`, clear local-action fields, or insert narratives. The root-authored rows must already match the completion dossier, including the exact provenance-manifest string required for `blocking_evidence`. If the final scenario differs from the frozen 32 closed / 9 choice / 16 skipped scenario, use a separately reviewed workflow instead of this constructor.

## Final actual execution inputs

For each category, the label selects existing `S/<label>-exit.json` and `S/<label>-output.txt`. Labels need not share a prefix, allowing truthful final successful retry labels. All nine labels must be distinct and contain only lowercase letters, digits and hyphens, beginning with a letter or digit.

| Category | Frozen required producer/check |
|---|---|
| `source-inventory` | `verify-reviewed-source-coverage.py`, no argument tail |
| `layout` | `tools/architecture/check_layout.py`, no argument tail; all existing clean-layout markers |
| `tiers` | `tools/architecture/check_tiers.py`, no argument tail |
| `compatibility` | `tools/architecture/check_compatibility.py`, no argument tail |
| `hygiene` | `tools/architecture/check_placeholders.py`, no argument tail |
| `audits` | Pinned `validate-closed-row-audits-v3.py --validate` exactly; complete validation of all 32 closed rows |
| `declarations` | Actual `lake env lean <check_file>` argv from the final check-input manifest |
| `focused-build` | Actual `lake --quiet --log-level=error build ComputationalMathematics.Source.LeVeque.Chapter01` argv |
| `full-build` | Actual `lake --quiet --log-level=error build` argv; existing two default roots |

`consume_receipts` is reused unchanged. It checks actual integer zero exits, exact raw-output hashes and command tails, native commit/duration fields, closed audit coverage and decision hashes, exact 32 declaration/axiom reports, the allowed axiom set, and existing native error guards. Check-input source/check-file hashes, row order, declarations, contract hashes, audit tasks, base row subject, base gate hash and context must all agree. The constructor does not run any of those commands or improve an incomplete receipt. Their substantive meaning remains the existing producer's responsibility.

The constructor also reuses `check_provenance`, including the live original-thread prefix/suffix watcher. This is a read-only check when root later runs the constructor; it is not an audit launch. A later question, structured reply or ordinary user message invalidates the earlier projection. The frozen original event timestamps remain literal. No question is treated as answered or adopted from elapsed time. Source/route/projection references and all route evidence are checked again before output completion.

## Future invocation and review order

After root has actually completed and reviewed the necessary placement, aggregate/tier exposure, organization, rebind/checkpoint and final global checks, it supplies the exact inputs above. From the workspace use the existing launcher:

```text
nativePython -B workflow-v5.0.1-local/run_workflow_posix.py <absolute path to construct_request.py> --inputs <absolute parameter JSON> --sha256 <actual parameter SHA> --label <new label>
```

Use ordinary Python, never `-O`. The output directory must be fresh and contained under this helper's `runs/`. Files are exclusively created; interrupted attempts are retained, and any retry uses a new label. The constructor's `REQUEST_ONLY` record reports supplied context and checked input hashes, not a prepared gate or terminal verdict.

Root must inspect the exact request and construction record before separately deciding whether to run the frozen V2 `prepare`. That later mode must independently validate actual current context, the operational ACTIVE base, cross-gate evidence and complete proposed artifacts. Installation and released terminal/campaign/reconciliation checks remain separate later actions. This packet supplies no authority for them.

## Bounded review and checks

The inspected current `nine-row-local-route-review-batch10/local-route-review.json` has kind `bounded-nine-row-local-route-review`, SHA `a1f573c281e28f67b42bc22cf01a3209a659eea74c8cf92a86efe401d23ad2cd`. It identifies no further necessary mathematical producer for the inspected alternatives but explicitly leaves DIM placement and root integration/organization/global work open. The constructor rejects that actual packet as a completion dossier. Its statements are historical bounded review findings; this constructor neither updates them nor concludes that the later work has finished.

The inspected source-boundary v2 dossier is SHA `99fb785787ccfe7906b95ff0dc1d4d774bcd664673cc3c7c9323e9d29ae2c0c3`; the inspected projection is SHA `15f55c43d5d3c50134b1861d82231e953c6644db4cd30561d0644640b3e11acc`. They are recorded as preparation provenance, not hardcoded forever-current operational choices. Root passes their final reviewed references explicitly. No new PDF interpretation or source judgment was made.

Seventeen static/rejection-only checks passed through the POSIX launcher with actual exit zero (`checks-02.exit.json`). They check the existing schema keys/categories, safe labels, missing/duplicate/traversal inputs, rejection of the actual bounded review, pending/missing/string completion flags, and absence of operational calls or synthesized blocked status in the constructor. The tests created no complete route dossier, successful request, native receipt fixture or assertion of real completeness. There is no full real-input execution test because those inputs remain root-owned future work.

The original harness had one unmatched closing parenthesis and exited one. Its source/output/receipt remain unchanged. `derive-checks-v2.py` makes only that additive test repair; the constructor bytes did not change. The successful raw output SHA is `dd96a89b1bad12fd807aa9ec6dfdfffc159a80b3788e8cedc750331d5268ef14`; the results JSON SHA is `09983b1ee4e210a342639f643c89324ce6217006b4fa2dbc19f342714e58d26b`.

Scoped searches inspected the frozen V2 schema/helper, `prepare-closed-row-checks.py`, `bind-final-gate-evidence-v3.py`, the nine-row review, source-boundary v2 and projection. Terms included `context`, `manifest`, `receipts`, `label`, `prefix`, and `check-inputs`. Existing transition/provenance/receipt producers were reused rather than replaced. Schema fields are checked through those existing runtime guards; no new schema package, released edit, Git action or model role was introduced.
