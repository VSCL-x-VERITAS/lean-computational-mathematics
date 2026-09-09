"""Freeze additive binder preparation without creating final gate/audit evidence."""
from pathlib import Path
import hashlib
import importlib.util
import difflib
import json

HERE = Path(__file__).resolve().parent
S = HERE.parents[1]
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
def ref(path):
    return {'path': path.relative_to(R).as_posix(), 'sha256': sha(path)}
def new_json(name, value):
    p = HERE / name
    with p.open('x', encoding='utf-8', newline='\n') as f:
        f.write(json.dumps(value, indent=2, ensure_ascii=False) + '\n')
    return ref(p)

spec = importlib.util.spec_from_file_location('prepared_final_global_binder', HERE / 'bind-final-global-evidence.py')
b = importlib.util.module_from_spec(spec)
spec.loader.exec_module(b)
execution = b.read(HERE / 'final-global-evidence-fixtures-execution-02.json')
assert type(execution['exit_code']) is int and execution['exit_code'] == 0
fixture = json.loads(execution['output'])
assert fixture['status'] == 'PASS' and fixture['fixture_checks'] == 46 and fixture['gate_written'] is False
labels = {'source-inventory': 'unblock-nine-final-source-inventory',
          **{n: 'unblock-nine-organization-' + n for n in ('layout', 'tiers', 'compatibility', 'hygiene')},
          'declarations': 'unblock-nine-complete-declarations',
          'focused-build': 'unblock-nine-final-focused-build',
          'full-build': 'unblock-nine-initial-full-build'}
commit = '5e3f63594aa964263469ada134aee2809559d50d'
evidence = {}
for name, label in labels.items():
    receipt_path, output_path = S / (label + '-exit.json'), S / (label + '-output.txt')
    b.verify_receipt(b.read(receipt_path), output_path.read_bytes(), commit, name)
    evidence[name] = {'receipt': ref(receipt_path), 'output': ref(output_path)}
evidence['audits'] = None
checker = R.parent / 'formalization-collaboration-v5.0.1/books/candidates/leveque-finite-volume/module/scripts/gate.py'
template = new_json('final-global-evidence-input-template.json', {
    'format': b.FORMAT,
    '_incomplete_preparation': 'Not executable. Root must supply final all-41 audit receipt/validator pins and exact current gate/rows/bindings. No gate PASS is claimed.',
    'input_commit': commit,
    'gate_checker': {'path': '../formalization-collaboration-v5.0.1/books/candidates/leveque-finite-volume/module/scripts/gate.py', 'sha256': sha(checker)},
    'gate_sha256': None, 'rows_sha256': None, 'bindings': None,
    'declaration_manifest': ref(S / 'unblock-nine-20260908/complete-declaration-manifest.json'),
    'source_inventory_snapshot': ref(S / 'chapter01-source-inventory-coverage-v2.json'),
    'capture_script': ref(S / 'unblock-nine-20260908/capture-check.py'),
    'check_scripts': {'source-inventory': ref(S / 'verify-reviewed-source-coverage.py'),
        'layout': ref(R / 'tools/architecture/check_layout.py'),
        'tiers': ref(R / 'tools/architecture/check_tiers.py'),
        'compatibility': ref(R / 'tools/architecture/check_compatibility.py'),
        'hygiene': ref(R / 'tools/architecture/check_placeholders.py')},
    'audit_validator': None, 'validator_dependencies': None,
    'lakefile': ref(R / 'lakefile.toml'), 'evidence': evidence,
})
old, new = S / 'bind-final-gate-evidence-v3.py', HERE / 'bind-final-global-evidence.py'
diff = ''.join(difflib.unified_diff(old.read_text(encoding='utf-8').splitlines(True),
                                 new.read_text(encoding='utf-8').splitlines(True),
                                 fromfile=old.relative_to(R).as_posix(), tofile=new.relative_to(R).as_posix()))
with (HERE / 'final-global-evidence-derivation.diff').open('x', encoding='utf-8', newline='\n') as f:
    f.write(diff)
files = [ref(HERE / name) for name in (
    'bind-final-global-evidence.py', 'final-global-evidence-fixtures.py',
    'final-global-evidence-fixtures-execution-01.json', 'final-global-evidence-fixtures-execution-02.json',
    'final-global-evidence-review.md', 'final-global-evidence-input-template.json',
    'final-global-evidence-derivation.diff', 'prepare-final-global-binder-packet.py')]
manifest = new_json('final-global-evidence-preparation-manifest.json', {
    'format': 'final-global-evidence-binder-preparation-1', 'derivation_source': ref(old),
    'files': files, 'template': template, 'available_evidence': evidence,
    'projection_comparison': 'all eight payloads, counts and receipt roles equal to v3 under marked fixture inputs',
    'fixture_checks': 46, 'all_41_operational_audit_validation': 'pending, not run or invented',
    'current_gate_context_and_rows': 'root supplies after actual final acceptance',
    'gate_mutation': False, 'production_or_audit_mutation': False,
})
receipt = new_json('final-global-evidence-preparation-receipt.json', {
    'status': 'PREPARED-NOT-EXECUTED', 'helper': ref(new), 'manifest': manifest,
    'review': ref(HERE / 'final-global-evidence-review.md'),
    'fixture_execution': ref(HERE / 'final-global-evidence-fixtures-execution-02.json'),
    'actual_fixture_exit': execution['exit_code'], 'fixture_checks': fixture['fixture_checks'],
    'actual_available_check_receipts': 8, 'actual_native_declaration_reports': 41,
    'operational_gate_validation_or_apply': False, 'chapter_completion_claim': False,
})
print(json.dumps({'helper': ref(new), 'manifest': manifest, 'receipt': receipt}, indent=2))
