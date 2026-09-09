"""Write null final-data templates and bind already existing reusable input bytes."""
from pathlib import Path
import hashlib
import json
import candidate_checks as c
from capture_checks import commands

P = Path(__file__).resolve().parent
R = P.parents[5]
W = R.parent
S = P.parents[1]


def write(name, value):
    with (P / name).open('x', encoding='utf-8', newline='\n') as stream:
        stream.write(json.dumps(value, indent=2, ensure_ascii=True) + '\n')


def pin(path, external=False):
    path = Path(path)
    display = path.as_posix()
    if external:
        if display.startswith('C:/'):
            display = '/c/' + display[3:]
    else:
        display = path.relative_to(R).as_posix()
    return {'path': display, 'sha256': hashlib.sha256(path.read_bytes()).hexdigest()}


schema = W / 'formalization-collaboration-v5.0.1/skills/book-formalization-migration/references/schemas/reconciliation-epoch.schema.json'
checker = S / 'final-epoch-asset-helper-draft/prepare_asset_bundle.py'
write('candidate-replay-inputs.template.json', {
    'schema_version': 1, 'kind': 'candidate-replay-inputs', 'gate': None,
    'complete_audit_execution': {'receipt': None, 'output': None, 'command': None},
    'final_gate_execution': {'receipt': None, 'output': None, 'command': None},
    'declaration_manifest': None, 'architecture_baseline_name': None,
    'graph_json': None, 'graph_markdown': None,
    'tools': {name: pin(R / path) for name, path in c.TOOLS.items()},
    'immutable_inputs': [], 'evidence_closure_review': None,
    'organization_measurement': None, 'ratchet_baseline': None})
write('assembly-inputs.template.json', {
    'schema_version': 1, 'epoch_id': None, 'topology': None, 'request': None, 'status': None,
    'bundle': None, 'epoch_schema': pin(schema, True), 'schema_checker': pin(checker, True),
    'replay_inputs': None, 'collision_transport_review': None,
    'check_receipts': None, 'book_evidence': None, 'organization_evidence': None})
write('required-commands.template.json', {'status': 'UNEXECUTED TEMPLATES: substitute actual values',
    'commands': commands('ACTUAL_COMMITTED_REPLAY_INPUT_PATH', 'ACTUAL_REPLAY_INPUT_SHA256', 'ACTUAL_CANDIDATE_TREE')})
write('organization-measurement.template.json', {'unit_scope': {name: None for name in
    ('unexpected_changes', 'unclassified_modules', 'mixed_pending_split', 'duplicate_wrappers',
     'placeholder_findings', 'canonical_placement_pending')}, 'repository_ratchet': []})
write('book-evidence.template.json', {'candidate_tree': None, 'affected_books': [], 'evidence': []})
write('organization-evidence.template.json', {'candidate_tree': None, 'organization': None})
write('collision-transport-review.template.json', {'status': None, 'bundle_sha256': None, 'plan': [],
    'concept_decisions': [], 'collisions': [], 'transports': [], 'additional_transport_evidence': []})
write('review-shapes.json', {
    'status': 'FIELD SHAPES ONLY; not decisions or evidence',
    'concept_decision': {'concept_id': None, 'resolution': None, 'evidence': [], 'collision_id': None, 'transport_ids': []},
    'additional_transport_evidence': {'transport_id': None, 'evidence': []},
    'evidence_closure_review': {'status': None, 'gate_sha256': None, 'immutable_inputs_sha256': None,
        'root_review': None, 'observed_binding_sources': [], 'excluded_runtime_inputs_and_replay_replacements': []},
    'book_record': {'book_id': None, 'status': None, 'rows': [], 'tree': None, 'stored_verdict': None,
        'current_verdict': None, 'certificate_disposition': None},
    'ratchet_entry': {'category': None, 'owner': None, 'baseline_items': None, 'current_items': None},
    'note': 'Transport/collision exact shape comes from the pinned released epoch schema; never add annotations to its closed objects.'})
python = 'C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe'
launcher = str(W / 'workflow-v5.0.1-local/run_workflow_posix.py')
prefix = [python, '-B', launcher]
release = str(W / 'formalization-collaboration-v5.0.1/skills/book-formalization-migration/scripts/reconciliation_launcher.py')
write('ready-invocations.template.json', {
    'status': 'UNEXECUTED: root supplies actual final paths and hashes; no candidate values inferred',
    'capture': prefix + [str(P / 'capture_checks.py'), '--candidate', 'ACTUAL_STATUS_SCRATCH_REPOSITORY',
        '--commit', 'ACTUAL_CANDIDATE_COMMIT', '--tree', 'ACTUAL_CANDIDATE_TREE', '--inputs',
        'ACTUAL_COMMITTED_REPLAY_INPUT_PATH', '--inputs-sha256', 'ACTUAL_REPLAY_INPUT_SHA256', '--output',
        'NEW_ABSOLUTE_CAPTURE_DIRECTORY_OUTSIDE_CANDIDATE'],
    'assemble': prefix + [str(P / 'assemble_epoch.py'), '--inputs', 'ACTUAL_ASSEMBLY_INPUTS_JSON',
        '--inputs-sha256', 'ACTUAL_ASSEMBLY_INPUT_SHA256', '--output', 'NEW_CANDIDATE_EPOCH_JSON'],
    'validate': prefix + [release, 'validate', '--request', 'ACTUAL_FINAL_REQUEST_JSON', '--epoch', 'ACTUAL_CANDIDATE_EPOCH_JSON'],
    'next': 'Only after actual validation succeeds: one exact matching PASS checkpoint, check-latest, verify-latest, campaign preflight using the previously reviewed scope commands.'})
reviewed = [
    W / 'formalization-collaboration-v5.0.1/skills/book-formalization-migration/scripts/reconciliation.py',
    W / 'formalization-collaboration-v5.0.1/skills/book-formalization-migration/scripts/reconciliation_launcher.py',
    W / 'formalization-collaboration-v5.0.1/skills/book-formalization-migration/references/reconciliation.md',
    schema, checker,
    P.parent / 'linear-review/pass-checkpoint-review/REVIEW.md',
    P.parent / 'linear-review/pass-checkpoint-review/commands.review-only.json',
    P.parent / 'reconciliation-helpers/REVIEW.md',
    P.parent / 'reconciliation-helpers/prepare_two_lane_bundle.py',
    P.parent / 'reconciliation-concept-mapping/REVIEW.md',
    S / 'baseline-equation03-transport-draft/REVIEW.md',
    S / 'validate-candidate-architecture.py',
    S / 'unblock-nine-local-complete-declarations-02-output.txt']
write('reviewed-inputs.json', {'status': 'Read-only derivation and test inputs; no operational verdict',
    'files': [pin(p, not p.is_relative_to(R)) for p in reviewed]})
print('Prepared null templates and exact existing-tool/reference pins. No candidate, epoch, or receipt populated.')
