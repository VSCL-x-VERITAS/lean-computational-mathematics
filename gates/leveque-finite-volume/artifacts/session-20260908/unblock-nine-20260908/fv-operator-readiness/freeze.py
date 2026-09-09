"""Freeze preparation artifacts without touching any audit directory."""
from datetime import datetime, timezone
from pathlib import Path
import hashlib
import json
import os
D=Path(__file__).resolve().parent
R=next(p for p in D.parents if (p/'lean-toolchain').is_file())
exec(compile((D.parent/'fv-local-domain-review/native-long-path-io.py').read_bytes(),
             'native-long-path-io','exec'),globals())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def write(p,v):
    with p.open('xb') as h:h.write((json.dumps(v,indent=2)+'\n').encode())
native=json.loads((D/'native-01/receipt.json').read_bytes())
assert native['exit_code']==0 and native['inputs_unchanged']
assert sha(D/'native-01/output.txt')==native['output_sha256']
preflight=json.loads((D/'successor-preflight.json').read_bytes())
for key in ['spec','helper','prior_spec','immediate_completed_manifest','unchanged_primary_target',
            'unchanged_source_context_extension','unchanged_selection_receipt','native_receipt']:
    pin=preflight[key];assert sha(R/pin['path'])==pin['sha256'],key
files=sorted((p for p in D.rglob('*') if p.is_file()),key=lambda p:p.as_posix())
assert all(p.name not in ('manifest.json','final-receipt.json') for p in files)
manifest={'schema':1,'kind':'FV operator readiness and spec-only successor preparation',
    'observed_at_utc':datetime.now(timezone.utc).isoformat(),
    'artifacts':[ref(p) for p in files],
    'spec':preflight['spec'],'helper':preflight['helper'],
    'reused_operator_packet':ref(D.parent/'measure-operator-evidence/dependency-packet.json'),
    'source_or_production_changes':False,'operational_audit_changes':False,
    'gate_or_git_changes':False,'audit_roles_invoked':False,'source_acceptance':False}
write(D/'manifest.json',manifest)
receipt={'schema':1,'status':'FROZEN_READY_SPEC_AND_PROOF_FREE_EVIDENCE',
    'manifest':ref(D/'manifest.json'),'spec':preflight['spec'],
    'preflight':ref(D/'successor-preflight.json'),'native_receipt':ref(D/'native-01/receipt.json'),
    'actual_native_exit':0,'actual_native_seconds':native['elapsed_seconds'],
    'actual_native_output_sha256':native['output_sha256'],
    'supplied_current_spans_preserved':preflight['unchanged_current_native_spans'],
    'added_reused_operator_spans':4,'added_concrete_bridge_spans':1,
    'new_native_axiom_reports':10,'released_prepare_invoked':False,
    'audit_roles_invoked':False,'source_acceptance':False}
write(D/'final-receipt.json',receipt)
print(json.dumps({'manifest':ref(D/'manifest.json'),'receipt':ref(D/'final-receipt.json'),
    'spec':preflight['spec'],'files':len(files)},indent=2))
