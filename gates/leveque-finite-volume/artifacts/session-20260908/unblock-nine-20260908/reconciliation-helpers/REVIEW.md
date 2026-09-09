# Two-lane reconciliation inventory and converter

This additive local extension preserves both old helpers byte-for-byte. It does
not run a candidate construction, alter a request/status/topology, change a ref
or commit, close a gate, or issue semantic/epoch/acceptance/promotion evidence.
Root must run the released launcher and final verifier after this preparation.

## API and supported scope

`build_lane_inventory.py --topology FILE --lane ID --fingerprints COMMITTED-PATH
[--fingerprints COMMITTED-PATH ...] [--require-closed] --output NEW.json` reads that
lane's exact configured ref/head and shared anchor. It reads actual Git blobs,
checks all configured refs before and after, and covers every changed tracked
blob exactly once. Both added and changed files retain mode, Git object ID,
SHA-256 and covering asset ID. Deletions and changed existing declaration owners
still require separately reviewed transport inventory; this extension does not
silently drop the prior restrictions.

Run independently for the final merge lane and the nonempty inspection lane.
Use `--require-closed` for the final merge input. Inspection may have open rows;
its gate, declaration and audit records describe that origin's historical
selection. They do not become current candidate acceptance. The current real
probe found 32 closed rows and nine open rows at both configured 5e3 heads.

The origin inventory records lane/ref/head/tree on each asset and uses distinct
lane-bound asset IDs even when commits and bytes coincide. `unique` conservatively
tracks changed/new obligations relative to the shared anchor, as the old helper
did; it is not an assertion of uniqueness across lanes. All such obligations
are retained, so this conservative classification cannot discard shared work.
Every supplied native declaration record is retained. Selected gate declarations
must all occur in those records. Exact record overlaps are allowed only after
full record and source-pin equality checks, with each fingerprint origin listed.
The root must supply complete final native inventories for the desired
declaration-level scope; the helper does not infer missing declaration types
from source text. Every changed module's complete bytes remain inventoried even
if its declarations are not in a supplied native inventory.

`prepare_two_lane_bundle.py` takes two `--preview` paths plus `--topology`,
`--request`, `--status`, `--mapping`, `--epoch-schema`, `--output`. It supports
exactly two work lanes, one merge and one inspection, prepare/forbid/none,
recorded CANDIDATE, and Chapter 1 as the selected unit. It verifies actual
candidate commit/tree/parents, first-parent preservation and merge ancestry;
candidate tree must equal the closed merge-lane preview tree. Request-selected
gate SHA must equal the committed merge gate. It reconstructs both complete
inventories from their original Git heads before conversion, catching omitted
files, forged coverage and changed identities. It rechecks all input bytes and
configured refs at completion.

Inspection assets are verified against the inspection origin, not against the
candidate's same-named files. Thus an older gate projection can differ in the
candidate while its original bytes remain evidence in the retained origin ref.
The caller explicitly maps each occurrence to `retained-unresolved`; conversion
preserves `origin_disposition` and `origin_current_source_certificate`, while
`current_source_certificate` is false for inspection. Merge-origin dispositions
stay unchanged. The converter does not permit invented supersession, rejection,
or inspection acceptance. Branches retain every unique occurrence separately.

## Explicit mapping

`mapping.schema.json` is the additive version-2 input schema. Input hashes bind
both lane previews (a map keyed by lane ID), topology, exact request, CANDIDATE
status and released epoch schema. Every `(lane_id, preview_asset_id)` needs an
explicit reviewed concept ID and permitted disposition. No concept identity is
inferred from a common name, commit, type hash or timestamp. The inventories'
`unreviewed-*` keys are navigation placeholders, not a semantic decision.

The review evidence and every declaration's producer/policy payload must be
regular candidate-relative Git blobs with exact SHA-256. Producer payloads use
the existing canonical-producer-identity-v1 object and must match that origin's
actual native record. Policy payloads must be explicit nonempty reviewed objects;
the helper does not invent a generic policy or adjudicate their content. The old
Eq1.3 source contract, assumptions, actual profile and distinct adopted convention
must remain correctly represented in its origin-specific policy payload. Old
and new meanings must not be overwritten by a shared current policy hash.

Each resulting occurrence keeps its origin, original disposition and explicit
review identity. Same-concept groups are reported, not resolved. Equal native
records or producer hashes across lanes do not manufacture an equivalent-source
judgment. The output has only candidate, lane_heads, assets and branches under
epoch_fields; it still needs collision/transport decisions, affected books,
actual organization/ratchets and all eight candidate-bound replay receipts.

## Invocation and actual validation

`ready-invocations.json` supplies complete native-Python/POSIX-wrapper arrays.
Run these preparation helpers through that wrapper so Git object queries use
the prepared POSIX runtime. All paths/heads come from final supplied metadata,
not a guessed future commit. The frozen old structural helper is imported only
after its exact SHA is checked; no released workflow code is copied or patched.

Actual read-only probe and inventory exercise succeeded at the real configured
5e3 work and origin/main refs versus anchor 9e222. Each independent inventory
covered all 8,955 changed blobs with 791 assets and 697 conservative retention
obligations. Their contents were compared bytewise while origin IDs remained
disjoint. Actual output/exit receipts are preserved. This was an open-origin
exercise, not a final all-closed candidate preview.

The final fixture suite has 18 passing cases. Its Git object graph is entirely
in memory: no Git process, repository, ref or commit is created. It exercises
the real inventory/converter code with explicitly synthetic fingerprints. Cases
include distinct nonempty origins, older gate bytes, retained inspection
certificates, coverage, unique-asset preservation, and refusal of stale/forged
inputs, open merge input, missing/duplicate mappings, inspection promotion,
invented supersession, wrong producer or declaration identity and ref drift.
These fixtures prove structural behavior, not Lean/source validity. Earlier
17-case output is preserved as historical validation; the 18-case run is the
final check after adding committed-gate binding.

Remaining final responsibilities are concrete local work: capture the final
native fingerprints; review the per-origin concept/policy mapping; freeze the
final gate and refs; construct the actual candidate; run this conversion and
the released full epoch verifier. No external receipt is needed to finish the
existing local prepare task as VALIDATED. External protected admission and stable
promotion remain separate and cannot be inferred from this bundle.
