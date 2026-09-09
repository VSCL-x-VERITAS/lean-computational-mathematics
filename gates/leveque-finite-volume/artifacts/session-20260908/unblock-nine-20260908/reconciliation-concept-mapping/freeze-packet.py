"""Freeze this owned draft directory and input references only."""
from pathlib import Path
from datetime import datetime, timezone
import json
import prepare_mapping_catalogue as p

HERE = Path(__file__).resolve().parent
D = HERE.parent
R = D.parents[4]
W = R.parent


def main():
    test = p.read(HERE/'mapping-tests-02/receipt.json')
    assert test['exit_code'] == 0 and test['input_hashes_before'] == test['input_hashes_after']
    for name, digest in test['input_hashes_after'].items(): assert p.sha((HERE/name).read_bytes()) == digest
    data = p.read(HERE/'mapping-tests-02/stdout.txt')
    assert data['status'] == 'PASS_LOCAL_GUARDS_ONLY'
    history = {'schema': 1, 'failed_context_capture': [],
               'runner_v2_failure': {'observed_runner_exit_code': 1,
                 'provenance': 'Actual exec_command results for both lane invocations; helper command stderr persisted, but runner failed while hashing a nonexistent duplicated-suffix filename before writing a receipt.',
                 'missing_receipts_are_not_reconstructed': True}}
    for lane in ('leveque-ch01-work', 'reorganization-baseline-inspection'):
        directory = HERE/lane
        original = p.read(directory/'context-receipt.json')
        assert original['exit_code'] == 1
        final = p.read(directory/'context-v3-receipt.json')
        assert final['exit_code'] == 0
        assert final['output_sha256'] == p.sha((directory/'origin-context-v3.json').read_bytes())
        history['failed_context_capture'].append(p.reference(R, directory/'context-receipt.json'))
    p.create(HERE/'historical-attempts.json', history)
    owned = sorted(path for path in HERE.rglob('*') if path.is_file() and '__pycache__' not in path.parts)
    local_inputs = [D/'reconciliation-helpers'/name for name in ('build_lane_inventory.py', 'prepare_two_lane_bundle.py', 'common.py', 'mapping.schema.json', 'REVIEW.md')]
    local_inputs += [D/'linear-review/pass-checkpoint-review'/name for name in ('REVIEW.md', 'topology.observed.json', 'final-receipt.json')]
    local_inputs += [D.parent/'baseline-equation03-transport-draft'/name for name in ('old-producer-identity.json', 'new-producer-identity.json', 'old-policy-domain.json', 'new-policy-domain.json', 'transport-entry.draft.json')]
    released = [W/'formalization-collaboration-v5.0.1/skills/book-formalization-migration'/rel for rel in (
        'references/reconciliation.md', 'references/schemas/reconciliation-epoch.schema.json', 'scripts/reconciliation.py', 'scripts/reconciliation_launcher.py')]
    manifest = {'schema': 1, 'status': 'FROZEN_BASELINE_MAPPING_DRAFT_FINAL_INPUTS_PENDING',
                'frozen_at_utc': datetime.now(timezone.utc).isoformat(),
                'files': [p.reference(R, path) for path in owned],
                'reused_local_inputs': [p.reference(R, path) for path in local_inputs],
                'released_inputs': [{'workspace_relative_path': path.relative_to(W).as_posix(), 'sha256': p.sha(path.read_bytes())} for path in released],
                'final_committed_head': None, 'candidate': None, 'source_acceptance': False,
                'coverage': {'lanes': 2, 'assets_per_lane': 791, 'retained_obligations_per_lane': 697,
                             'changed_blobs_per_lane': 8955, 'declaration_records_per_lane': 559,
                             'source_wrapper_occurrences': 198, 'origin_selected_contracts_per_lane': 32},
                'actual_final_test_exit_code': 0, 'local_guard_tests': data['count']}
    p.create(HERE/'manifest.json', manifest)
    receipt = {'schema': 1, 'status': manifest['status'], 'manifest': p.reference(R, HERE/'manifest.json'),
               'catalogue': p.reference(R, HERE/'baseline-catalogue.json'),
               'review_surface': p.reference(R, HERE/'mapping-review-surface.json'),
               'prospective_source_associations': p.reference(R, HERE/'prospective-current-source-associations.json'),
               'helpers': [p.reference(R, HERE/name) for name in ('prepare_mapping_catalogue.py', 'emit_reviewed_mapping.py')],
               'test_receipt': p.reference(R, HERE/'mapping-tests-02/receipt.json'),
               'actual_test_exit_code': 0, 'local_guard_tests': data['count'],
               'candidate_epoch_gate_or_ref_mutations': 0, 'source_acceptance': False}
    p.create(HERE/'final-receipt.json', receipt)
    print(json.dumps({'receipt': p.reference(R, HERE/'final-receipt.json'), **receipt}, indent=2))


if __name__ == '__main__': main()
