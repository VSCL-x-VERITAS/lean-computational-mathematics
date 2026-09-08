"""Map the complete source-row inventory to exact current canonical producers.

This records compilation candidates only and never confers audit acceptance.
Historical nonaccepted audit inputs remain unchanged.
"""
from pathlib import Path
import hashlib, json, re, subprocess
S = Path(__file__).resolve().parent
R = S.parents[3]
sha = lambda b: hashlib.sha256(b).hexdigest()
gate = json.loads((R / 'gates/leveque-finite-volume/chapter-01.json').read_text())
rows = {r['id']: r for r in gate['rows'] if r['status'] != 'SKIPPED'}
excluded = {
    'LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908',
    'LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908',
    'LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908'}
aliases = {
    'LEV-CH01-EQ-1.1-DEFINITION': 'LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM',
    'LEV-CH01-EQ-1.8-DEFINITION': 'LEV-CH01-EQ-1.8-CONSERVATION-LAW',
    'LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT': 'LEV-CH01-EQ-1.2-ADVECTION',
    'LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL': 'LEV-CH01-EQ-1.3-ADVECTED-PROFILE',
    'LEV-CH01-EQ-1.4-ACOUSTIC-MODEL': 'LEV-CH01-EQ-1.4-ONE-WAY-WAVE',
    'LEV-CH01-RIEMANN-RECTANGLE-INTERFACE': 'LEV-CH01-RIEMANN-INTERFACE-FLUX'}
records = {}
for path in sorted((S / 'audits').glob('*/audit-task.json')):
    task = json.loads(path.read_text())
    ident = task['task_id']
    if ident in excluded:
        continue
    stem = re.sub(r'-(CANONICAL|PRODUCTION)-20260908$', '', ident)
    row = aliases.get(stem, stem)
    assert row in rows, (ident, row)
    assert row not in records, row
    target = task['target']
    contents = (R / target['path']).read_bytes()
    records[row] = {'row': row, 'task_id': ident, 'task': path.relative_to(R).as_posix(),
        'task_sha256': sha(path.read_bytes()), 'path': target['path'],
        'sha256': sha(contents), 'declarations': [target['declaration']],
        'gate_status_at_inventory': rows[row]['status'],
        'audit_status': 'Acceptance is determined only by the sealed complete decision and row binding.'}
assert set(records) == set(rows), sorted(set(rows) - set(records))
assert len(records) == 41
files = [records[k] for k in sorted(records)]
names = [f['declarations'][0] for f in files]
assert len(names) == len(set(names)) == 41
checks = S / 'chapter01-current-producer-checks.lean'
manifest = S / 'chapter01-current-producer-inputs.json'
assert not checks.exists() and not manifest.exists()
content = 'import ComputationalMathematics.Source.LeVeque.Chapter01\nimport NumStability.Source.LeVeque.Chapter01\n\n'
content += ''.join('#check ' + n + '\n#print axioms ' + n + '\n' for n in names)
checks.write_text(content, encoding='utf-8', newline='\n')
snapshot = {'schema': 1, 'head': subprocess.check_output(['git','-c','core.longpaths=true','rev-parse','HEAD'], cwd=R, text=True).strip(),
    'files': files, 'check_file_sha256': sha(checks.read_bytes()),
    'historical_nonaccepted_tasks_retained': sorted(excluded),
    'coverage': {'source_rows': len(gate['rows']), 'formalizable_rows': 41, 'skipped': 16, 'distinct_producers': 41},
    'status': 'Exact current source producer inventory; native check and independent audit acceptance remain separate.'}
manifest.write_text(json.dumps(snapshot, indent=2, ensure_ascii=False)+'\n', encoding='utf-8')
print(json.dumps(snapshot['coverage']))

