"""Freeze reviewed helper artifacts; never execute a candidate operation."""
import hashlib,json
from pathlib import Path
P=Path(__file__).resolve().parent;S=P.parents[1];R=P.parents[5];W=R.parent
def h(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def put(p,v):
    assert not p.exists(),p
    p.write_text(json.dumps(v,indent=2)+'\n',encoding='utf-8',newline='\n')
def pin(p):return {'path':p.relative_to(R).as_posix() if p.is_relative_to(R) else p.as_posix(),'sha256':h(p)}
old={
    S/'build-reconciliation-asset-inventory.py':'cac604fcf2afd2898e344aae6517c09171bdad0bba75222e402152c60ad027b8',
    S/'final-epoch-asset-helper-draft/prepare_asset_bundle.py':'9f4effac0ee75b5477cdc5f7d5f97b156be8e885247d913db692861ab782eb67',
    S/'final-epoch-asset-helper-draft/mapping.schema.json':'b460ab34b86a147db9aa00186394861c525a6108558774a72fa2eb51e3376d8d',
}
assert all(h(p)==sha for p,sha in old.items())
schema=json.loads((S/'final-epoch-asset-helper-draft/mapping.schema.json').read_bytes())
schema['title']='Explicit reviewed two-lane candidate asset mapping'
schema['properties']['schema_version']['const']=2
ih=schema['properties']['input_sha256'];ih['required'].remove('preview');ih['required'].append('previews')
del ih['properties']['preview']
ih['properties']['previews']={'type':'object','minProperties':2,'maxProperties':2,'additionalProperties':{'$ref':'#/$defs/hash'}}
entry=schema['properties']['assets']['items'];entry['required']+=['lane_id','disposition']
entry['properties']['lane_id']={'$ref':'#/$defs/id'}
entry['properties']['disposition']={'enum':['selected','retained-unresolved']}
put(P/'mapping.schema.json',schema)

prefix=['C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe','-B',
        (W/'workflow-v5.0.1-local/run_workflow_posix.py').as_posix()]
top=(R/'.formalization/library-topology.json').as_posix()
helper=lambda name:prefix+[(P/name).as_posix()]
base='gates/leveque-finite-volume/artifacts/session-20260908/'
commands={
    'status':'REVIEWED COMMAND TEMPLATES ONLY; root supplies final exact pins/paths and runs after final gate commitment',
    'preconditions':['Fresh exact final topology and actual recorded CANDIDATE; no retained checkpoint conversion.',
        'Final merge gate committed and fully closed; own exact committed fingerprints supplied per lane.',
        'Reviewed concept and origin-specific producer/policy payloads committed in candidate before construction.',
        'Mapping hash-binds both previews, current topology/request/status and released schema; output paths new.'],
    'inspection_inventory':helper('build_lane_inventory.py')+['--topology',top,'--lane','reorganization-baseline-inspection',
        '--fingerprints',base+'baseline-equation03-expression-fingerprints.json',
        '--fingerprints',base+'chapter01-current-expression-fingerprints-24b3.json','--output','NEW_INSPECTION_PREVIEW.json'],
    'final_merge_inventory':helper('build_lane_inventory.py')+['--topology',top,'--lane','leveque-ch01-work',
        '--fingerprints',base+'baseline-equation03-expression-fingerprints.json','--fingerprints','FINAL_COMMITTED_NATIVE_FINGERPRINTS.json',
        '--require-closed','--output','NEW_MERGE_PREVIEW.json'],
    'candidate_converter':helper('prepare_two_lane_bundle.py')+['--preview','NEW_MERGE_PREVIEW.json','--preview','NEW_INSPECTION_PREVIEW.json',
        '--topology',top,'--request','EXACT_FINAL_REQUEST.json','--status','EXACT_RECORDED_CANDIDATE_STATUS.json',
        '--mapping','REVIEWED_TWO_LANE_MAPPING.json','--epoch-schema',
        (W/'formalization-collaboration-v5.0.1/skills/book-formalization-migration/references/schemas/reconciliation-epoch.schema.json').as_posix(),
        '--output','NEW_CANDIDATE_ASSET_BUNDLE.json'],
    'notes':['The inspection fingerprint choice above was actually validated at origin/main 5e3, not inferred from filenames.',
             'Use repeated --fingerprints for additional final native inventories; exact duplicate records are checked for full equality.',
             'Final declaration-level completeness beyond selected gate names remains the root reviewed input inventory responsibility.',
             'The new output parent must already exist. Actual review execution wrote only this helper folder, not runtime.']}
put(P/'ready-invocations.json',commands)

review='''# Two-lane reconciliation inventory and converter

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
'''
assert not (P/'REVIEW.md').exists()
(P/'REVIEW.md').write_text(review,encoding='utf-8',newline='\n')

checks={}
for label in ('fixtures-02','actual-refs-01','actual-inventories-01'):
    receipt=json.loads((P/(label+'-receipt.json')).read_bytes())
    assert receipt['exit_code']==0 and h(P/(label+'-output.txt'))==receipt['output_sha256']
    checks[label]={'receipt':pin(P/(label+'-receipt.json')),'output':pin(P/(label+'-output.txt'))}
assert json.loads((P/'fixtures-02-output.txt').read_bytes())['count']==18
real=json.loads((P/'actual-inventories-01-output.txt').read_bytes())
assert len(real['lanes'])==2 and real['disjoint_origin_ids'] and real['equal_heads_compared_bytewise']
for p in P.glob('*.py'):compile(p.read_bytes(),str(p),'exec')
derivation={'basis':[pin(p) for p in old],'new_format':'lane inventory schema2 and mapping schema2; epoch fragments still released schema2/workflow3',
    'reused_exact_functions':'Hash-pinned local schema checker/JSON/Git object reader; new wrapper limits Git command classes.',
    'implementation':'Additive parameterized per-origin inventory and independently recomputed two-origin conversion.',
    'released_schema':pin(W/'formalization-collaboration-v5.0.1/skills/book-formalization-migration/references/schemas/reconciliation-epoch.schema.json'),
    'preserved_old_bytes':True,'candidate_or_epoch_created':False}
put(P/'derivation.json',derivation)
manifest={'scope':'Bounded two-lane preparation extension; no final epoch/admission',
    'files':[pin(p) for p in sorted(P.iterdir()) if p.is_file()], 'checks':checks,'old_helpers':[pin(p) for p in old]}
put(P/'manifest.json',manifest)
receipt={'status':'COMPLETE','manifest':pin(P/'manifest.json'),'ready_invocations':pin(P/'ready-invocations.json'),
    'checks':checks,'actual_fixture_cases':18,'actual_changed_blobs_per_lane':[v['changed_file_count'] for v in real['lanes']],
    'old_helpers_unchanged':True,'candidate_created':False,'epoch_validated':False,'runtime_or_ref_mutations':False,
    'helper_files':[pin(P/n) for n in ('common.py','build_lane_inventory.py','prepare_two_lane_bundle.py','mapping.schema.json')]}
put(P/'final-receipt.json',receipt)
print(json.dumps({'receipt':pin(P/'final-receipt.json'),'manifest':pin(P/'manifest.json'),'helpers':receipt['helper_files']}))
