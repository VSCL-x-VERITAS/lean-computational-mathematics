"""Add null organization input shapes; do not measure or assert current zeros."""
from pathlib import Path
import json

P = Path(__file__).resolve().parent
replay = json.loads((P / 'candidate-replay-inputs.template.json').read_bytes())
keys = ('unexpected_changes', 'unclassified_modules', 'mixed_pending_split',
        'duplicate_wrappers', 'placeholder_findings', 'canonical_placement_pending')
outputs = {
 'organization-inputs.template.json': {
    'schema_version': 1, 'kind': 'organization-measurement-inputs', 'topology': None,
    'campaign_id': 'leveque-finite-volume-main-2026q3', 'ratchet_owner': None,
    'unit_scope_review': None, 'ratchet_baseline': None, 'approved_exceptions': {},
    'pending_asset_ids': [], 'tools': replay['tools'],
    'supporting_executions': {k: {'receipt': None, 'output': None, 'command': None,
        'applicability_review': None} for k in ('layout', 'tiers', 'compatibility', 'hygiene')}},
 'organization-review-shapes.json': {
    'status': 'UNPOPULATED FIELD SHAPES; not measured current evidence',
    'unit_scope_review': {'status': None, 'anchor': None, 'production_source_tree_sha256': None,
        'source_files': [], 'review_evidence': [], 'reviewed_changed_source_paths': [],
        'unit_scope': {k: None for k in keys}},
    'applicability_review': {'status': None, 'receipt_sha256': None, 'production_source_tree_sha256': None,
        'source_files_sha256': None, 'review_rationale': None},
    'approved_exception': {'review_evidence': None, 'rationale': None},
    'invocation_suffix': ['prepare_organization.py', '--root', 'ACTUAL_REPOSITORY', '--inputs',
        'ACTUAL_INPUTS_JSON', '--inputs-sha256', 'ACTUAL_INPUTS_SHA256', '--output', 'NEW_OUTPUT_DIRECTORY'],
    'invocation_prefix': 'Use Windows Python -B run_workflow_posix.py as documented for other helpers.'}}
for name, value in outputs.items():
    with (P / name).open('x', encoding='utf-8', newline='\n') as stream:
        stream.write(json.dumps(value, indent=2) + '\n')
print('Added organization preparation shapes; no measurement or gate verdict populated.')
