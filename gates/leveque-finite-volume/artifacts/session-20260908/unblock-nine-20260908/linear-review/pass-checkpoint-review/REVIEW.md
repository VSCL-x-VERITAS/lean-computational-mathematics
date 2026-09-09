# Chapter 1 PASS checkpoint: released operational route

This is a read-only code/contract review, not a candidate, epoch, gate verdict,
receipt, or publication. Only this review directory was written; only CLI help
was executed. No Git operation, runtime transition, audit role, or external
authority request was performed. Snapshot files identify the observed state;
root may legitimately advance the live state after this observation.

## Conclusion

A Chapter 1 PASS checkpoint cannot legitimately end QUEUED/retained. The current
prepare/forbid/none configuration can end locally VALIDATED with a real candidate
and a fully replayed candidate-status epoch, without admission or external
receipts. This establishes local preparation completion only. It does not
integrate Chapter 1, authorize dependent units, promote stable main, or establish
that a remote publication complied with the protected reconciliation route.

The literal checks are in reconciliation_launcher.py: command_checkpoint
(1041-1081) rejects a retained PASS; derived_status_defects (1530-1564) reserves
terminal QUEUED for ACTIVE/BLOCKED retained work; command_check (1567-1677)
repeats the PASS/retained rejection. For task=prepare, its accepted terminal
states are NO_CHANGE, VALIDATED, QUEUED, AWAITING_RECEIPT, subject to those derived
evidence requirements. NO_CHANGE requires actual ancestry evidence; published
origin/main equality is not evidence that the protected campaign contains the
work. Backend none produces VALIDATED; a configured external backend produces
AWAITING_RECEIPT only after actual candidate validation and queue creation.

## Required local sequence

1. Close all 41 formalizable rows through their fresh accepted evidence, finish
   the final unit checks and organization scans, run the released gate with
   --require-pass, and commit the exact source/gate/evidence state. Freeze the
   final lane and inspection refs in the reviewed topology. Retain the current
   protected campaign/stable pins unless their separate admission actually ran.
2. Refresh the stopping-checkpoint request with the exact final PASS gate bytes.
   The exact command arrays are in commands.review-only.json. They preserve the
   operational scope aa1ff96998802d9fbd48e728b3573cff7c4272480d66a397699f8a050cf29560
   while the changed gate/head/topology hashes produce a new immutable request.
   Use the returned request path, not a guessed ID.
3. Run prepare on that fresh request before making an ACTIVE/BLOCKED retained
   checkpoint on it. The launcher creates a no-hardlink scratch workspace,
   preserves the destination first-parent chain, and merges exactly selected
   merge inputs. Inspection lanes are inventoried but not merged. Resolve any
   actual conflict only in the request workspace, then use finalize. Record the
   actual candidate commit/tree from status; never substitute the lane HEAD.
4. Build a complete candidate-status epoch and actual deterministic receipts
   bound to that candidate tree. Run launcher validate --request ... --epoch ...
   without integration/stable receipts. It invokes the released verifier,
   recreates the pristine candidate, executes all eight recorded commands,
   compares output hashes, and records immutable provisional evidence.
5. After validation succeeds, issue exactly one matching PASS checkpoint, then
   check-latest, verify-latest and campaign preflight. Keep gate, refs, topology,
   epoch and candidate unchanged throughout this final sequence. The state is
   VALIDATED/result_kind=candidate for the observed none backend.

This ordering avoids an expected nonzero PASS-checkpoint call. The released
alternative is to issue PASS first on a fresh request: it records the checkpoint
and prepares the candidate, then reports that epoch validation is still needed.
One can then validate and check without repeating that PASS checkpoint. Do not
label that first nonzero call as success. The older route notes describe this
alternative; they are not a reason to loop checkpoints.

The existing QUEUED/retained request cannot be upgraded in place: prepare_candidate
(816-824) returns immediately for QUEUED, and ALLOWED_TRANSITIONS has no
QUEUED-to-CANDIDATE transition. A genuine final gate/head refresh is required.
Do not change a reason, policy or status just to bypass this guard. Reason and
policy also enter the scope hash, so changing them silently breaks the hook's
current scope binding.

## Full epoch prerequisites

Schema version 2/workflow schema 3, status=candidate, exact topology hash, shared
anchor, actual candidate commit/tree and campaign ID. lane_heads and branch
ledger cover exactly formalization/reorganization instances (not canonical).
Every selected or unique retained asset needs actual content/proof/source
identity, explicit semantic concept and producer/policy metadata, lawful route,
and branch disposition. Supersession must remain acyclic and end in a selected
same-concept successor; no unresolved collision may remain. Source/policy/type/
producer changes require full re-audit or explicit reopening, never move reuse.

The baseline Eq1.3 producer transport remains a useful frozen input, with its
five controlled hashes and full-reaudit evidence. Revalidate it against the final
candidate; retain the three old declarations/proofs and historical raw audits.
Its normalization is alpha-canonical structure, not full definitional normal
form. Do not infer semantic equality from a common PDF or unchanged owner file.

Every configured/affected book needs a current candidate-tree verdict or named
reopening rejecting its stale certificate. Unit organization requires six empty
measured item lists: unexpected_changes, unclassified_modules,
mixed_pending_split, duplicate_wrappers, placeholder_findings,
canonical_placement_pending. Repository ratchets need actual baseline/current
sets and owners, with any increase explicitly reviewed.

The eight required validation keys, in execution order, are source_coverage,
import_graph, signature_graph, body_graph, declaration_resolution, focused_build,
full_build, pristine_replay. Each needs PASS, actual candidate tree, token-array
command, output SHA-256 and actual elapsed milliseconds. Only candidate-local
checked-in Python/Lean checks, permitted Lake commands and read-only Git commands
are allowed. Python -c/-m/stdin, shell strings, external workspace paths and
{repository} are rejected. The candidate replay uses a scrubbed environment and
rejects tracked/untracked changes. The script validate-candidate-architecture.py
already builds the libraries before graph comparison, addressing cold-checkout
ordering; its final graph name and dependent compiled environment still require
actual candidate verification. No cold-environment failure is presumed.

## Concrete preparation gap under the observed topology

The old inventory helper asserts the inspection head equals the shared anchor
(build-reconciliation-asset-inventory.py, lines 30-31). The reviewed asset
converter explicitly rejects a nonempty inspection lane
(prepare_asset_bundle.py, line 180). The observed topology has both work and
origin/main inspection at 5e3f63594aa964263469ada134aee2809559d50d, while the anchor
and protected campaign remain 9e2225705fed906b1120d55105d607baabef57c9.
Those helpers therefore cannot simply be rerun as final inventory/converter.
An additive reviewed inventory of the nonempty inspection lane and explicit
cross-lane occurrence/concept/producer mapping are needed. Identical commits
permit actual byte/identity comparison; they do not justify omitting that lane.
This is actionable local preparation, not an external blocker.

## What truly requires external evidence

Protected integration and stable promotion remain separate actions. The current
request forbids writes and selects no admission backend. A later authorized
admit request can import the already reviewed exact candidate, validate its
provisional epoch, and await the configured external receipt. The accepted
epoch must bind the exact externally supplied advance-campaign-head receipt,
issued by project-owner, outside every configured repository, with matching
topology hash and candidate commit. The agent must not create this receipt.
admit-exact additionally requires exact-ref, authorized policy and
--authorize-ref-update, then replays accepted evidence and uses compare-and-swap;
it refuses a checked-out destination branch. Tests and a broad earlier request
to publish are not themselves a candidate-specific receipt.

After actual admission, preserve its old topology evidence and deploy a newly
named validated topology with the accepted campaign head and unit=integrated.
Only then request promote with no merge input and the stable destination. The
candidate is the exact protected campaign head, fast-forward from the pinned
stable base; promotion needs full replay and both external receipts.

Literal verifier detail to resolve at that later handoff: verify_approval_receipt
compares BOTH receipt topology hashes with the current epoch's topology hash
(reconciliation.py, lines 726-729, 882-894 and 897-919). A prior integration
receipt bound to the pre-admission topology will not automatically validate
under the newly rolled-forward promotion topology, despite the reference's
shorthand about supplying the prior receipt. Preserve the old receipt; obtain
authority-compatible exact evidence rather than rewriting it or weakening the
validator. This is a genuine external receipt-binding condition only if that
later promotion is being executed; it does not prevent local VALIDATED PASS.

This review supplies neither acceptance nor promotion and leaves all protected,
working and remote refs untouched. The root can complete the local work through
the candidate and pristine replay before any external receipt is required.
