"""Freeze tested additive helpers and historical resolutions; no operational validation."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib
import json
import os
H0 = Path(__file__).resolve().parent
H = Path('\\\\?\\'+str(H0.resolve())) if os.name == 'nt' else H0.resolve()
R = H.parents[5]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
def read(p): return json.loads(p.read_text(encoding='utf-8'))
def write(name, value):
    with (H/name).open('xb') as handle: handle.write((json.dumps(value, indent=2)+'\n').encode())
def ref(path): return {'path': path.relative_to(R).as_posix(), 'sha256': sha(path)}

history = read(H/'source-context-helper-derivation.json')
for item in history['derivations']:
    parent = H/item['source']['path']
    assert sha(parent) == item['source']['sha256']
    source = parent.read_text()
    for change in item['exact_replacements']:
        assert source.count(change['before']) == 1
        source = source.replace(change['before'], change['after'])
    actual = H/item['output']['path']
    if actual.name == 'qualified_row_support_v3.py':
        actual = H/'source-context-initial-helper-snapshots/qualified_row_support_v3.py.snapshot'
    assert source.encode() == actual.read_bytes() and sha(actual) == item['output']['sha256']
extension = read(H/'source-context-preparer-successor-derivation.json')
for item in extension['files']:
    saved = H/item['initial_snapshot']; assert sha(saved) == item['before_sha256']
    source = saved.read_text()
    for change in extension['exact_replacements']:
        assert source.count(change['before']) == 1
        source = source.replace(change['before'], change['after'])
    assert source.encode() == (H/item['path']).read_bytes() and sha(H/item['path']) == item['after_sha256']
for name in ('qualified_row_support_v3.py', 'bind-qualified-row-v3.py', 'validate-closed-row-audits-v6.py'):
    compile((H/name).read_text(), name, 'exec')
for number in range(1, 5):
    attempt = H/f'source-context-tests-{number:02d}'
    receipt = read(attempt/'receipt.json')
    assert sha(attempt/'output.txt') == receipt['output_sha256']
    assert sha(attempt/'test-input.py.snapshot') == receipt['input_sha256_before'] == receipt['input_sha256_after']
    helper = H/'qualified_row_support_v3.py' if number >= 3 else H/'source-context-initial-helper-snapshots/qualified_row_support_v3.py.snapshot'
    assert sha(helper) == receipt['helper_sha256']
    assert receipt['exit_code'] == (1 if number == 1 else 0)
assert 'Ran 14 tests' in (H/'source-context-tests-04/output.txt').read_text()
assert not list(H.glob('ctx-*')), 'Synthetic fixture directories remain'
prior_dependencies = read(H/'qualified-refinement-v2-validator-dependencies.json')
dependencies = dict(prior_dependencies)
dependencies['status'] = 'DEPENDENCIES_ONLY_NO_OPERATIONAL_VALIDATION'
dependencies.pop('frozen_helper_receipt', None)
dependencies['audit_validator'] = ref(H/'validate-closed-row-audits-v6.py')
dependencies['validator_dependencies'] = [ref(H/'qualified_row_support_v3.py'),
    *[item for item in prior_dependencies['validator_dependencies'] if not item['path'].endswith('/qualified_row_support_v2.py')]]
dependencies['source_context_protocol_inputs'] = [ref(H.parent/'prepare-successor-audit-with-source-context.py'),
    ref(H.parent/'prepare-successor-audit-with-source-context-long-paths.py'),
    ref(H.parents[1]/'user-discontinuity-interpretation-20260908.json'),
    ref(H.parent/'fv-local-domain-review/fv-partial-preparation-recovery.json')]
dependencies['producer'] = ref(Path(__file__).resolve()) if os.name != 'nt' else ref(H/Path(__file__).name)
dependencies['limits'] = ('Direct dynamic helper/protocol dependencies are pinned. Each accepted row must independently bind its actual '
    'source extension, inherited packet, lineage, source/images, literal receipt, target/native evidence and exact sealed configuration. '
    'This receipt is not complete validation or source acceptance.')
write('source-context-v3-validator-dependencies.json', dependencies)
names = ['qualified_row_support_v3.py', 'bind-qualified-row-v3.py', 'validate-closed-row-audits-v6.py',
    'source-context-validation.fragment.py', 'derive-source-context-helpers.py', 'source-context-helper-derivation.json',
    'add-source-context-preparer-successor.py', 'recover-source-context-preparer-successor.py',
    'source-context-preparer-successor-derivation.json', 'test-source-context-helpers.py',
    'run-source-context-helper-tests.py', 'cleanup-source-context-fixtures.py', 'cleanup-source-context-fixtures-v2.py',
    'cleanup-context-v2-failed.py.snapshot', 'source-context-fixture-cleanup-v2-inputs.json',
    'source-context-fixture-cleanup-v2-receipt.json', 'SOURCE-CONTEXT-QUALIFICATION-USAGE.md',
    'freeze-source-context-helpers.py', 'source-context-v3-validator-dependencies.json']
paths = [H/name for name in names]
for folder in ['source-context-initial-helper-snapshots', *[f'source-context-tests-{i:02d}' for i in range(1,5)]]:
    paths += [p for p in (H/folder).rglob('*') if p.is_file() and '__pycache__' not in p.parts]
write('source-context-helper-manifest.json', {'schema': 1, 'source_acceptance': False,
    'files': [{'path': p.relative_to(H).as_posix(), 'sha256': sha(p)} for p in sorted(paths)],
    'historical_resolutions': [
      {'meaning': 'Initial q-v3 derivation and test-01/02 helper digest', 'path': 'source-context-initial-helper-snapshots/qualified_row_support_v3.py.snapshot'},
      {'meaning': 'Original fragment used by initial generator', 'path': 'source-context-initial-helper-snapshots/source-context-validation.fragment.py.snapshot'}]})
final = {'schema': 1, 'status': 'PASS_HELPER_PREPARATION_ONLY', 'source_acceptance': False,
    'completed_at_utc': datetime.now(timezone.utc).isoformat(),
    'helpers': {name: sha(H/name) for name in names[:3]},
    'manifest_sha256': sha(H/'source-context-helper-manifest.json'),
    'dependencies_sha256': sha(H/'source-context-v3-validator-dependencies.json'),
    'actual_final_test_exit': read(H/'source-context-tests-04/receipt.json')['exit_code'],
    'synthetic_tests': 14, 'test_receipt_sha256': sha(H/'source-context-tests-04/receipt.json'),
    'failed_test_attempt_preserved': 'source-context-tests-01',
    'operational_validations': 0, 'gate_mutations': 0, 'model_roles': 0,
    'limit': 'Root must run actual complete validation of genuinely sealed accepted audits before binding.'}
write('source-context-helper-final-receipt.json', final)
print(json.dumps({'final_receipt_sha256': sha(H/'source-context-helper-final-receipt.json'), **final}, indent=2))
