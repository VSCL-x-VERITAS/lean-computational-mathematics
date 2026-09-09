"""Freeze only owned helper evidence. No operational binder/validator execution."""
from datetime import datetime, timezone
import difflib
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def create(path, payload):
    with path.open('xb') as stream:
        stream.write(payload)


def encode(value):
    return (json.dumps(value, indent=2, ensure_ascii=False) + '\n').encode()


def main():
    import qualified_row_support_v2 as q
    pairs = [('qualified_row_support.py', 'qualified_row_support_v2.py'),
             ('bind-qualified-row.py', 'bind-qualified-row-v2.py'),
             ('validate-closed-row-audits-v4.py', 'validate-closed-row-audits-v5.py')]
    derivation = q.read(HERE/'qualified-refinement-v2-derivation.json')
    for name, digest in derivation['inputs'].items():
        assert sha(HERE/name) == digest
    diff = ''
    for old, new in pairs:
        diff += ''.join(difflib.unified_diff((HERE/old).read_text().splitlines(True),
                    (HERE/new).read_text().splitlines(True), fromfile=old, tofile=new))
    create(HERE/'qualified-refinement-v2-final.diff', diff.encode())
    receipts = []
    for label, expected in [('qualified-refinement-tests-01', 1), ('qualified-refinement-tests-02', 0)]:
        path = HERE/label/'receipt.json'
        receipt = q.read(path)
        assert receipt['exit_code'] == expected and receipt['inputs_before'] == receipt['inputs_after']
        assert receipt['stdout_sha256'] == sha(HERE/label/'stdout.txt')
        assert receipt['stderr_sha256'] == sha(HERE/label/'stderr.txt')
        snapshots = sorted((HERE/label).glob('*.snapshot'))
        assert len(snapshots) == len(receipt['inputs_before'])
        for snapshot, (input_path, digest) in zip(snapshots, receipt['inputs_before'].items()):
            assert snapshot.name.endswith(Path(input_path).name + '.snapshot')
            assert sha(snapshot) == digest
        receipts.append(q.reference(path))
    final = q.read(HERE/'qualified-refinement-tests-02/receipt.json')
    for name in [new for _, new in pairs] + ['test-qualified-refinement-v2.py', 'run-qualified-refinement-tests.py']:
        assert final['inputs_after'][str(HERE/name)] == sha(HERE/name)
    names = ['derive-qualified-refinement-v2.py', 'qualified-refinement-v2-derivation.json',
             'qualified-refinement-v2-final.diff', 'qualified-refinement-v2-README.md',
             'test-qualified-refinement-v2.py', 'run-qualified-refinement-tests.py', 'freeze-qualified-refinement-v2.py']
    names += [new for _, new in pairs] + [new + '.derivation.diff' for _, new in pairs]
    files = [HERE/name for name in names]
    for label in ('qualified-refinement-tests-01', 'qualified-refinement-tests-02'):
        files += sorted(path for path in (HERE/label).iterdir() if path.is_file())
    assert not any('__pycache__' in str(path) for path in files)
    manifest = {'schema': 1, 'status': 'FROZEN_LOCAL_HELPERS_ONLY', 'recorded_at_utc': datetime.now(timezone.utc).isoformat(),
                'files': [q.reference(path) for path in files], 'original_helpers': derivation['inputs'],
                'pins': [q.reference(q.SELECTION)] + [{key: pin[key] for key in ('path', 'sha256')}
                         for pin in q.REFINEMENTS.values()],
                'completed_regression_decision': q.reference(q.SESSION/'audits/LEV-CH01-MATERIAL-INTERFACE-TOPOLOGY-INTERPRETED-PRODUCTION-20260908/faithfulness/decision.json'),
                'actual_test_receipts': receipts, 'final_exit_code': 0, 'successor_checks': 84, 'original_checks': 28,
                'operational_gate_or_audit_commands': 0, 'source_acceptance': False,
                'historical_initial_derivation_is_not_final_hash_authority': True}
    create(HERE/'qualified-refinement-v2-final-manifest.json', encode(manifest))
    receipt = {'schema': 1, 'status': 'FROZEN_LOCAL_HELPERS_ONLY',
               'manifest': q.reference(HERE/'qualified-refinement-v2-final-manifest.json'),
               'helpers': [q.reference(HERE/new) for _, new in pairs],
               'test_receipt': q.reference(HERE/'qualified-refinement-tests-02/receipt.json'),
               'test_stdout': q.reference(HERE/'qualified-refinement-tests-02/stdout.txt'),
               'actual_exit_code': 0, 'tests': {'successor': 84, 'original': 28},
               'gate_mutations': 0, 'operational_validations': 0, 'source_acceptance': False}
    create(HERE/'qualified-refinement-v2-final-receipt.json', encode(receipt))
    print(json.dumps({'receipt': q.reference(HERE/'qualified-refinement-v2-final-receipt.json'), **receipt}, indent=2))


if __name__ == '__main__':
    main()
