"""Extend the reviewed rebind catalog for the 28-row definition increment.

Run in the prepared POSIX runtime. No gate or production mutation occurs.
"""
from pathlib import Path
from datetime import datetime, timezone
import ast, copy, hashlib, json

S = Path(__file__).resolve().parent
R = S.parents[3]
P = S / 'definition-rebind-preparation'
G = R / 'gates/leveque-finite-volume/chapter-01.json'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
def bind(p):
    return {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
def write(p, value):
    with p.open('x', encoding='utf-8', newline='') as f:
        f.write(json.dumps(value, indent=2, ensure_ascii=True) + '\n')

parent = S / 'one-step-rebind-preparation'
assert sha(parent / 'rebind-closed-rows.py') == '73a53c472fa5f27e6fd5cee0b6be6d0644ecfcb1a18329df8aff235dda720dca'
assert sha(parent / 'reviewed-inputs.json') == 'fb72ea20035b7a4ef90ecefe6d0db204c5f841524ed1bd765d1a6005c2b11629'
inputs = copy.deepcopy(read(parent / 'reviewed-inputs.json'))
before = G.read_bytes()
gate = json.loads(before)
rows = []
scope_keys = ['adjudicated_scope_note', 'strengthening_evidence', 'applicability_audit', 'nonvacuity_witness']
old_pins = {r['id']: r for r in inputs['closed_rows']}
for row in gate['rows']:
    if row['status'] not in ('PROVED', 'REUSED', 'DISCREPANCY'):
        continue
    t = read(R / row['faithfulness_task'])
    o = R / t['audit_output']
    contract = G.parent / row['source_contract_artifact']
    assert sha(contract) == row['source_contract_sha256']
    rec = {'id': row['id'], 'status': row['status'], 'task': bind(R / row['faithfulness_task']),
           'target': t['target'], 'manifest': bind(o / 'manifest.json'),
           'decision': bind(o / 'decision.json'), 'source_extraction': bind(o / 'agent_outputs/source_contract.json'),
           'contract_hash': row['contract_hash'], 'contract': read(contract)['payload']['contract'],
           'classification': row['classification'], 'scope_fields': {k: row[k] for k in scope_keys if k in row}}
    if row['id'] in old_pins:
        assert rec == old_pins[row['id']], 'Previously reviewed semantic input changed: ' + row['id']
    rows.append(rec)
assert len(rows) == 28 and set(old_pins) <= {r['id'] for r in rows}
names = {'manifest': 'one-step-general-production-inputs.json',
         'check_file': 'one-step-general-production-checks.lean',
         'resolution_log': 'one-step-production-declarations-relative-output.txt',
         'resolution_exit': 'one-step-production-declarations-relative-exit.json'}
extra = {'key': 'one-step-general', **{key: bind(S / name) for key, name in names.items()}}
m = read(S / names['manifest'])
e = read(S / names['resolution_exit'])
assert type(e['exit_code']) is int and e['exit_code'] == 0
assert e['command'] == 'lake env lean ' + extra['check_file']['path']
assert e['output_sha256'] == extra['resolution_log']['sha256']
assert m['check_file_sha256'] == extra['check_file']['sha256']
inputs['proof_catalog'].append(extra)
inputs.update({'created_at_utc': datetime.now(timezone.utc).isoformat(),
               'gate_at_preparation': bind(G), 'closed_count_at_preparation': len(rows), 'closed_rows': rows})
assert G.read_bytes() == before
P.mkdir(exist_ok=False)
write(P / 'reviewed-inputs.json', inputs)
code = (parent / 'rebind-closed-rows.py').read_text(encoding='utf-8')
old = "INPUT_SHA='fb72ea20035b7a4ef90ecefe6d0db204c5f841524ed1bd765d1a6005c2b11629'"
assert code.count(old) == 1
code = code.replace(old, "INPUT_SHA='" + sha(P / 'reviewed-inputs.json') + "'")
ast.parse(code)
with (P / 'rebind-closed-rows.py').open('x', encoding='utf-8', newline='') as f:
    f.write(code)
write(P / 'derivation.json', {'schema': 1, 'generator': bind(Path(__file__)),
    'parent_driver': bind(parent / 'rebind-closed-rows.py'), 'parent_inputs': bind(parent / 'reviewed-inputs.json'),
    'driver': bind(P / 'rebind-closed-rows.py'), 'inputs': bind(P / 'reviewed-inputs.json'),
    'changes': ['Add exact relative-command native proof catalog for the accepted general one-step theorem',
                'Pin all 28 current closed semantic inputs; all 23 earlier pins remain byte/value identical',
                'Change only the driver input-package hash; dispatch and validation logic are unchanged'],
    'production_or_gate_mutation': False})
print(json.dumps({'closed_count': len(rows), 'driver': bind(P / 'rebind-closed-rows.py'),
                  'inputs': bind(P / 'reviewed-inputs.json'), 'gate_unchanged': G.read_bytes() == before}))
