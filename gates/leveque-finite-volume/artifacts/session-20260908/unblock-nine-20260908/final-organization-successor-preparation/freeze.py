"""Freeze this preparation packet only; no operational helper invocation."""
from pathlib import Path
import hashlib
import json
P=Path(__file__).resolve().parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
def ref(p): return {'path':p.relative_to(R).as_posix(),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()}
def write(name, data):
    with (P/name).open('x',encoding='utf-8',newline='\n') as stream:
        stream.write(json.dumps(data,indent=2)+'\n')
parents=[P.parent/'final-current-organization-review'/n for n in ('capture_current.py','prepare_draft.py')]
write('derivation.json',{'schema':1,'parents':[ref(p) for p in parents],
    'successors':[ref(P/n) for n in ('support.py','capture_current_v2.py','prepare_draft_v2.py')],
    'changes':['Explicit hash-pinned configuration and actual counts/receipt labels',
               'Complete native-owner import closure during capture',
               'Explicit reviewed changed-path coverage and source-scope rationales',
               'Full census and observed input/HEAD/concurrency rechecks',
               'Current complete declaration/native support and future-null template'],
    'originals_modified':False,'operational_capture_run':False})
files=[ref(p) for p in sorted(P.iterdir()) if p.is_file() and p.name not in ('manifest.json','receipt.json')]
write('manifest.json',{'schema':1,'status':'root-review-required','files':files,'operational_capture_run':False})
write('receipt.json',{'schema':1,'status':'preparation-frozen-root-review-required',
    'manifest':ref(P/'manifest.json'),'test_receipt':ref(P/'tests-01-exit.json'),
    'tests':18,'actual_test_exit':json.loads((P/'tests-01-exit.json').read_bytes())['exit_code'],
    'operational_capture_run':False,'source_acceptance':False})
print(json.dumps({'receipt':ref(P/'receipt.json'),'manifest':ref(P/'manifest.json'),
                  'helpers':[ref(P/n) for n in ('support.py','capture_current_v2.py','prepare_draft_v2.py')]},indent=2))
