# Candidate asset preparation helper

This additive draft converts an explicit, reviewed mapping and a committed
preview into four schema-checked fragments: candidate, lane_heads, assets and
branches. It creates no epoch, candidate, source judgment, collision resolution,
transport, validation receipt, admission or promotion. The output is an asset
preparation artifact, with its fragments under `epoch_fields`; it is not valid
as a complete reconciliation epoch. Existing preview bytes are read only.

## Supported boundary

- A launcher request with task prepare, remote writes forbidden, backend none,
  and status CANDIDATE/result_kind candidate. The status must hash the exact
  supplied request, and the mapping hashes all five supplied input artifacts.
- Exactly one inventoried formalization/reorganization lane, selected for merge;
  every other work lane selected for inspection and pinned at the shared anchor.
- The recorded candidate object exists in its recorded scratch repository. Its
  commit, tree, parents, source-lane ancestry and destination first-parent
  ancestry are independently read from Git. Candidate tree must equal the
  committed preview tree. A merged-content change requires a new inventory and
  converter review, rather than inferred preservation of asset contents.
- Preview rows are all closed and there are no deleted files. Existing asset
  dispositions must be selected or retained-unresolved; all branches remain
  retained. This draft cannot manufacture rejection or supersession.

These restrictions are intentionally narrower than the released workflow. A
nonempty inspection lane, multiple inventory lanes, altered candidate tree, or
existing supersession requires a separately reviewed extension. The helper
checks relevant request/status bindings, not the full launcher state machine.
It does not authenticate a reviewer or replace the released verifier.

## Required mapping input

`mapping.schema.json` records the exact local input shape. In addition to its
JSON shape, the helper requires one mapping for every preview asset, rejects
extra/missing/duplicate mappings, and never infers concepts from names or hashes.
Each entry explicitly assigns `preview_asset_id` to a reviewed `concept_id`.
Singleton identities also need an explicit assignment. Reusing a concept ID
associates assets for later review; it does not assert equality or authorize a
successor. Every resulting concept group is retained in the output.

`review_evidence` names a candidate-relative Git blob and its exact SHA-256. It
must explain the explicit mapping and policy choices. This check binds evidence
bytes; human or independent semantic review remains the caller's responsibility.
References cannot escape the candidate or dereference external workspace files.

Each declaration entry additionally requires `declaration_identity` containing:

- `module` and `declaration`, exactly matching its preview/native identity;
- `producer_payload`, a candidate-blob reference to the reviewed JSON object
  using `canonical-producer-identity-v1` with module, declaration, kind,
  type_sha256 and level_params_sha256;
- `policy_payload`, a candidate-blob reference to an explicit nonempty reviewed
  policy JSON object. No empty or invented generic policy is supplied here.

The producer object must match the exact native fingerprint record found in
the preview's committed fingerprint inputs. Those artifacts and every source
file listed by them are checked against candidate blobs; duplicate native
records fail. The declaration content hash, module, type and proof hashes must
match. The helper writes the planner's `module`, `declaration`, `producer` and
`policy_hash` fields. Existing conflicting identity metadata fails.

Payload hashes are SHA-256 over canonical JSON using sorted keys, compact
separators, ASCII escapes and no trailing newline. Their referenced artifact
hashes independently identify exact committed file bytes. This agrees with the
root-reviewed Equation (1.3) convention; its exact policy payloads must be
supplied rather than replaced with a generic hash.

Occurrence asset IDs bind the input preview hash, origin lane/head and original
asset ID. The helper remaps module-asset references and branch unique-asset
lists, preserves original content hashes and dispositions, and records the
original preview IDs. It does not deduplicate old/new producers.

## Invocation after a candidate actually exists

Run this local helper through the prepared Windows POSIX launcher with:

```text
prepare_asset_bundle.py --preview PREVIEW.json --topology TOPOLOGY.json
  --request REQUEST.json --status STATUS.json --mapping REVIEWED-MAPPING.json
  --epoch-schema RELEASED/references/schemas/reconciliation-epoch.schema.json
  --output NEW-ASSET-BUNDLE.json
```

The output parent must exist and the output must not exist. This is an argument
outline, not an epoch validation command. The external topology/request/status
paths make this helper unsuitable as a pristine candidate validation receipt.
The helper uses only read-only Git object queries. It executes no candidate
Python or Lean code.

## Structural review and validation scope

Read the actual released epoch schema and planner. The schema requires seven
asset fields; module/declaration/producer are useful extra metadata, and the
planner groups by concept_id. The preview's name field is not the planner's
declaration field. The released verifier requires lane_heads to cover exactly
formalization/reorganization instances. Accordingly this helper filters the
preview's broader head list and validates the emitted fragments against the
supplied released schema. Its small schema-fragment checker fails on unsupported
validation vocabulary; it is not a general replacement for JSON Schema tooling.

`test_prepare_asset_bundle.py` creates only a temporary synthetic Git fixture
beneath this draft directory. Fingerprint-looking fixture values are explicitly
synthetic and never represent Lean/source evidence. Tests cover conversion,
retention, remapped references, same-concept/different-producer preservation,
and negative binding/mapping/identity cases. They do not run a final epoch or
claim production readiness. The executable test report records the actual
released schema hash.

Unchecked responsibilities remain explicit: semantic correctness/completeness
of the reviewed concept map and policy payloads; complete cross-instance asset
inventory outside the supported empty-inspection case; collision decisions and
transport lawfulness; affected books; actual organization/ratchet scans; all
eight candidate validation commands and receipts; and released pristine replay.
