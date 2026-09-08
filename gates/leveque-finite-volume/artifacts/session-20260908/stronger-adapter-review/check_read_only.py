"""Syntax and evidence-helper checks only; never call either mutation/CLI entry point."""
from pathlib import Path
import ast
import copy
import hashlib
import importlib.util
import json

HERE = Path(__file__).resolve().parent
SESSION = HERE.parent
ROOT = SESSION.parents[3]
FILES = [SESSION / 'bind-audited-stronger-reused-row.py', SESSION / 'validate-closed-row-audits.py']
for path in FILES:
    ast.parse(path.read_text(encoding='utf-8'), filename=str(path))
spec = importlib.util.spec_from_file_location('checked_stronger_adapter', FILES[0])
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)

def forbidden(*args, **kwargs):
    raise RuntimeError('A CLI entry point or subprocess must never run in this check')

module.main = forbidden
module.subprocess.run = forbidden
task_path = ROOT / module.SESSION / 'audits' / module.TASK_ID / 'audit-task.json'
task = module.read(task_path)
output = ROOT / task['audit_output']
manifest = module.read(output / 'manifest.json')
decision = module.read(output / 'decision.json')
evidence_path = ROOT / module.EVIDENCE_PATH
fields = module.validate_strengthening_evidence(ROOT, task_path, task, manifest, decision, evidence_path)
config = module.exact_manifest_config(ROOT, manifest)
row = {'id': module.ROW_ID, **fields}
module.validate_strengthening_evidence(ROOT, task_path, task, manifest, decision, evidence_path, row=row)
negative_checks = []

def rejected(label, action):
    try:
        action()
    except ValueError as error:
        negative_checks.append({'check': label, 'rejected': True, 'reason': str(error)})
    else:
        raise RuntimeError('Negative control was accepted: ' + label)

wrong_task = copy.deepcopy(task)
wrong_task['task_id'] = 'ANOTHER-STRONGER-TASK'
rejected('different task', lambda: module.validate_strengthening_evidence(
    ROOT, task_path, wrong_task, manifest, decision, evidence_path))
wrong_decision = copy.deepcopy(decision)
wrong_decision['implications']['source_implies_lean']['verdict'] = 'yes'
rejected('unsealed yes/yes replacement', lambda: module.validate_strengthening_evidence(
    ROOT, task_path, task, manifest, wrong_decision, evidence_path))
rejected('missing strengthening row fields', lambda: module.validate_strengthening_evidence(
    ROOT, task_path, task, manifest, decision, evidence_path, row={'id': module.ROW_ID}))
wrong_row = copy.deepcopy(row)
wrong_row['strengthening_evidence']['sha256'] = '0' * 64
rejected('wrong row evidence hash', lambda: module.validate_strengthening_evidence(
    ROOT, task_path, task, manifest, decision, evidence_path, row=wrong_row))
wrong_file = {'path': module.EVIDENCE_PATH, 'sha256': '0' * 64}
rejected('wrong actual file hash', lambda: module.bound_file(ROOT, wrong_file))
rejected('repository escape', lambda: module.repository_path(ROOT, '../outside.json'))
rejected('unexpected axiom', lambda: module.declaration_axioms(
    "X : True\n'X' depends on axioms: [sorryAx]\n", 'X'))
rejected('unresolved declaration', lambda: module.declaration_axioms(
    "'X' depends on axioms: [propext]\n", 'X'))

result = {
    'syntax_files': [{'path': str(path), 'sha256': hashlib.sha256(path.read_bytes()).hexdigest()}
                     for path in FILES],
    'exact_strengthening_evidence_validated': True,
    'all_manifest_setup_hashes_and_exact_config_validated': str(config),
    'valid_stronger_row_fields_checked_in_memory': True,
    'negative_controls': negative_checks,
    'adapter_main_invoked': False,
    'closed_row_validator_main_invoked': False,
    'subprocesses_invoked': False,
    'gate_or_audit_writes': False,
}
(HERE / 'read-only-check-result.json').write_bytes((json.dumps(result, indent=2) + '\n').encode('utf-8'))
print(json.dumps(result, indent=2))
