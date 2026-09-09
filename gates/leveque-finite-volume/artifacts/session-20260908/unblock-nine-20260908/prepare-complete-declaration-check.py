"""Prepare actual declaration checks for the 32 closed and nine candidate source rows."""
from pathlib import Path
import hashlib,json
D=Path(__file__).resolve().parent
S=D.parent
R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
g=json.loads((R/'gates/leveque-finite-volume/chapter-01.json').read_bytes())
rows={}
for row in g['rows']:
 if row['status'] in ('PROVED','REUSED'):
  task=json.loads((R/row['faithfulness_task']).read_bytes())
  assert row['lean_declarations']==[task['target']['declaration']]
  rows[row['id']]=task['target']
assert len(rows)==32
for name in ['eigen','left-mode','riemann-definition','source-terms','material-interface','material-average']:
 spec=json.loads((D/(name+'-audit-spec.json')).read_bytes())
 task=json.loads((S/'audits'/spec['task_id']/'audit-task.json').read_bytes())
 assert spec['row_id'] not in rows
 rows[spec['row_id']]=task['target']
numeric=json.loads((D/'numerics-review/declaration-map.json').read_bytes())
for target in numeric['targets']:
 assert target['row_id'] not in rows
 primary=[v['name'] for v in target['declarations'] if v['role']=='primary']
 assert len(primary)==1 and sha(R/target['path'])==target['sha256']
 rows[target['row_id']]={'path':target['path'],'declaration':primary[0]}
assert len(rows)==41 and set(rows)=={r['id'] for r in g['rows'] if r['status'] in ('PROVED','REUSED','IN_PROGRESS')}
files={}
for target in rows.values():
 item=files.setdefault(target['path'],{'path':target['path'],'sha256':sha(R/target['path']),'declarations':[]})
 item['declarations'].append(target['declaration'])
names=sorted(t['declaration'] for t in rows.values())
assert len(set(names))==41
check=D/'CompleteDeclarations.lean'
content='import ComputationalMathematics.Source.LeVeque.Chapter01\n\n'
content+='\n'.join('#check '+n+'\n#print axioms '+n for n in names)+'\n'
with check.open('xb') as f:f.write(content.encode())
manifest={'schema':1,'files':list(files.values()),'declarations':names,
 'check_file':check.relative_to(R).as_posix(),'check_file_sha256':sha(check),
 'rows':rows,'scope':'41 exact current source targets. Nine remain candidate statements until their independently accepted audits are bound.'}
with (D/'complete-declaration-manifest.json').open('xb') as f:f.write((json.dumps(manifest,indent=2)+'\n').encode())
print(json.dumps({'declarations':len(names),'files':len(files),'check_sha256':sha(check)}))
