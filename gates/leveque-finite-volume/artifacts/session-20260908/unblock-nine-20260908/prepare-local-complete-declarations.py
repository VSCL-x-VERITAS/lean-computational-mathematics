"""Pin and check all 41 selected targets after the three substantive repairs."""
from pathlib import Path
import hashlib,json
D=Path(__file__).resolve().parent;S=D.parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
gate=json.loads((R/'gates/leveque-finite-volume/chapter-01.json').read_bytes())
rows={}
for row in gate['rows']:
 if row['status'] in ('PROVED','REUSED'):
  task=json.loads((R/row['faithfulness_task']).read_bytes())
  assert row['lean_declarations']==[task['target']['declaration']]
  rows[row['id']]=task['target']
assert len(rows)==38
for row_id,leaf,decl in [
 ('LEV-CH01-FINITE-VOLUME-FLUX-UPDATE','FiniteVolumeLocalFluxUpdate','leveque01_finiteVolumeLocalFluxUpdate_sourceContract'),
 ('LEV-CH01-RIEMANN-INTERFACE-FLUX','RiemannLocalInformationInterface','leveque01_localRiemannInformationInterface_sourceContract'),
 ('LEV-CH01-DIMENSIONAL-SPLITTING','CoordinateDirectionalMethods','leveque01_coordinateDirectionalMethods_sourceContract')]:
 assert row_id not in rows
 rows[row_id]={'path':'ComputationalMathematics/Source/LeVeque/Chapter01/'+leaf+'.lean','declaration':'NumStability.'+decl}
assert len(rows)==41 and set(rows)=={r['id'] for r in gate['rows'] if r['status'] in ('PROVED','REUSED','IN_PROGRESS')}
files={}
for target in rows.values():
 item=files.setdefault(target['path'],{'path':target['path'],'sha256':sha(R/target['path']),'declarations':[]})
 item['declarations'].append(target['declaration'])
names=sorted(t['declaration'] for t in rows.values());assert len(set(names))==41
check=D/'LocalCompleteDeclarations.lean'
content='import ComputationalMathematics.Source.LeVeque.Chapter01\n\n'+'\n'.join('#check '+n+'\n#print axioms '+n for n in names)+'\n'
with check.open('xb') as f:f.write(content.encode())
manifest={'schema':1,'files':list(files.values()),'declarations':names,'check_file':check.relative_to(R).as_posix(),'check_file_sha256':sha(check),'rows':rows,
 'scope':'41 exact current source targets. Three replacements remain candidate statements until independently accepted audits are bound.'}
with (D/'local-complete-declaration-manifest.json').open('xb') as f:f.write((json.dumps(manifest,indent=2)+'\n').encode())
print(json.dumps({'declarations':len(names),'files':len(files),'check_sha256':sha(check)}))
