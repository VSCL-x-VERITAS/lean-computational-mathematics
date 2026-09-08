"""Generate exact declaration/axiom inputs from the current closed gate rows."""
from pathlib import Path
import argparse,hashlib,importlib.util,json
S=Path(__file__).resolve().parent;R=S.parents[3]
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--label',required=True);p.add_argument('--gate-checker',type=Path,required=True)
p.add_argument('--inventory-only',action='store_true');p.add_argument('--require-all-closed',action='store_true')
a=p.parse_args();assert a.label.replace('-','').isalnum()
read=lambda p:json.loads(p.read_text(encoding='utf-8'));sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
G=R/'gates/leveque-finite-volume/chapter-01.json';g=read(G)
if a.require_all_closed:assert all(r['status'] in {'PROVED','REUSED','DISCREPANCY','SKIPPED'} for r in g['rows'])
spec=importlib.util.spec_from_file_location('gate_check',a.gate_checker);checker=importlib.util.module_from_spec(spec);spec.loader.exec_module(checker)
context=checker.current_context(G,1);assert g['bindings']==context['bindings']
rows=sorted([r for r in g['rows'] if r['status'] in checker.CLOSED_LEAN_STATUSES],key=lambda r:r['id'])
files=[];names=[]
for row in rows:
 task=read(R/row['faithfulness_task']);manifest=read(R/task['audit_output']/'manifest.json')
 assert task['target']['declaration'] in row['lean_declarations']
 assert manifest['target']['sha256']==sha(R/task['target']['path'])
 files.append({'row':row['id'],'path':task['target']['path'],'sha256':sha(R/task['target']['path']),
  'declarations':row['lean_declarations'],'contract_hash':row['contract_hash'],'audit_task':row['faithfulness_task']})
 names+=row['lean_declarations']
names=sorted(set(names));assert names
lines=['import ComputationalMathematics.Source.LeVeque.Chapter01','']
for name in names:lines+=['#check '+name,'#print axioms '+name]
data=('\n'.join(lines)+'\n').encode();path=S/(a.label+'-checks.lean')
result={'schema':1,'bindings':context['bindings'],'rows_sha256':checker.canonical_sha256(g['rows']),
 'source_gate_sha256':sha(G),'input_commit':context['lean_current_head'],'files':files,
 'declarations':names,'count':len(names),'check_file':path.relative_to(R).as_posix(),
 'check_file_sha256':hashlib.sha256(data).hexdigest(),
 'scope':'Generated inputs only; successful native Lean execution and independent source-audit validation are separate obligations.'}
if not a.inventory_only:
 destination=S/(a.label+'-inputs.json');assert not path.exists() and not destination.exists()
 path.write_bytes(data);destination.write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'mode':'inventory-only' if a.inventory_only else 'generated-inputs','closed_rows':len(rows),'declarations':len(names),'row_subject_sha256':result['rows_sha256'],'check_file_sha256':result['check_file_sha256']}))
