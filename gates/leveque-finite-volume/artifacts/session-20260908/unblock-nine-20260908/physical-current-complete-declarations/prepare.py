"""Select all41 current targets without treating selection as audit acceptance."""
from pathlib import Path
from datetime import datetime,timezone
import collections,copy,hashlib,json,os,subprocess
F=Path(__file__).resolve().parent
D=F.parent;S=D.parent
R=next(p for p in F.parents if (p/'lean-toolchain').exists())
assert os.name=='posix'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(p.read_bytes())
def write(name,value):
    with (F/name).open('x',encoding='utf-8',newline='\n') as out:
        if isinstance(value,str):out.write(value)
        else:json.dump(value,out,indent=2,ensure_ascii=False);out.write('\n')
    return ref(F/name)
old_path=D/'final-certified-complete-declarations/manifest.json'
assert sha(old_path)=='55f80b2eb6dadf90a68c6a5857db326882954b24d908b5b13524bb8228e69f59'
old=read(old_path)
gate_path=R/'gates/leveque-finite-volume/chapter-01.json';gate_raw=gate_path.read_bytes();gate=json.loads(gate_raw)
formal={r['id']:r for r in gate['rows'] if r['status']!='SKIPPED'}
assert len(formal)==41 and set(formal)==set(old['rows'])
counts=dict(collections.Counter(r['status'] for r in gate['rows']))
assert counts=={'PROVED':22,'REUSED':17,'IN_PROGRESS':2,'SKIPPED':16}
rows=copy.deepcopy(old['rows'])
for row_id,row in formal.items():
    if row['status'] in {'PROVED','REUSED'}:assert rows[row_id]['declaration'] in row['lean_declarations'],row_id
dim_path=D/'physical-dim-audit-preparation/spec-01/audit-spec.json'
assert sha(dim_path)=='3210def614922a0d3afa8a5d382be6bf7a7d2b42ac0465f6cd160ee52f872dc2'
dim=read(dim_path);assert dim['target']==rows[dim['row_id']]
info_pin=next(p for p in old['replacement_specifications'] if 'riemann-certified-audit-preparation' in p['path'])
assert sha(R/info_pin['path'])==info_pin['sha256']
info=read(R/info_pin['path']);assert info['target']==rows[info['row_id']]
assert {dim['row_id'],info['row_id']}=={k for k,v in formal.items() if v['status']=='IN_PROGRESS'}
gate_snapshot=F/'selection-gate.snapshot.json'
with gate_snapshot.open('xb') as out:out.write(gate_raw)
names=sorted(t['declaration'] for t in rows.values());assert len(names)==len(set(names))==41
groups=collections.defaultdict(list)
for target in rows.values():groups[target['path']].append(target['declaration'])
files=[dict(**ref(R/path),declarations=sorted(decls)) for path,decls in sorted(groups.items())]
old_filepins={p['path']:p for p in old['files']}
changed=[dict(before=old_filepins[p['path']],current=p) for p in files if p['sha256']!=old_filepins[p['path']]['sha256']]
assert len(changed)==1 and changed[0]['current']['path']==dim['target']['path']
assert len(names)==len(old['declarations']) and set(names)==set(old['declarations'])
text='import ComputationalMathematics.Source.LeVeque.Chapter01\n\n'+''.join('#check '+n+'\n#print axioms '+n+'\n' for n in names)
check=write('CompleteDeclarations.lean',text)
specs=[ref(dim_path),info_pin]
manifest=write('manifest.json',dict(schema=1,files=files,declarations=names,check_file=check['path'],check_file_sha256=check['sha256'],rows=rows,
    selection_gate_sha256=hashlib.sha256(gate_raw).hexdigest(),selection_gate_snapshot=ref(gate_snapshot),replacement_specifications=specs,
    prior_manifest=ref(old_path),prior_replacement_specifications=old['replacement_specifications'],changed_owner_pins=changed,
    current_gate_statuses=counts,selection_status={row_id:{'gate_status':r['status'],'selected_target':rows[row_id],
        'selection_is_acceptance':False,'closed_status_observed':r['status'] in {'PROVED','REUSED'}} for row_id,r in formal.items()},
    scope='Current complete41 compile/axiom targets:39 observed closed,2 selected prospective targets. Info prior certified target remains selected with unresolved accepted-context question; fresh physical DIM specification selects the current changed type. No target selection is an acceptance claim.'))
paths=sorted(set([p for root in ('ComputationalMathematics','NumStability') for p in (R/root).rglob('*.lean')]+[R/'ComputationalMathematics.lean',R/'NumStability.lean']))
sources=[]
for path in paths:
    assert path.is_file() and not path.is_symlink()
    sources.append(ref(path))
configs=[ref(R/name) for name in ('lean-toolchain','lake-manifest.json','lakefile.toml','tiers.json')]
capture=D/'capture-check.py';assert sha(capture)=='db1280f152c591b72d6e8542c64f7f814ed5ab6a8dda8a88736e19227ace29a8'
command=['git','--no-optional-locks','--no-replace-objects','rev-parse','HEAD']
p=subprocess.run(command,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE);assert p.returncode==0
head=p.stdout.decode().strip();assert head=='5e3f63594aa964263469ada134aee2809559d50d'
snapshot=write('source-pre.json',dict(schema=1,at_utc=datetime.now(timezone.utc).isoformat(),files=sources,configs=configs,
    source_count=len(sources),scope='Actual filesystem Lean sources in both production trees plus both public roots; this is a source-stability snapshot, not a new tracked-layout census.',
    input_commit=head,head_observation=dict(command=command,exit_code=p.returncode,stdout=p.stdout.decode(),stderr=p.stderr.decode()),
    capture=ref(capture),manifest=manifest,check=check,gate_selection_snapshot=ref(gate_snapshot)))
execution=write('execution-plan.json',dict(schema=1,manifest=manifest,source_pre=snapshot,capture=ref(capture),input_commit=head,
    runs=[{'kind':'full_build','label':'unblock-nine-physical-final41-full-build','argv':['build','ComputationalMathematics','NumStability']},
          {'kind':'focused_build','label':'unblock-nine-physical-final41-chapter01-build','argv':['build','ComputationalMathematics.Source.LeVeque.Chapter01']},
          {'kind':'complete_native','label':'unblock-nine-physical-final41-declarations','argv':['env','lean',check['path']]}],
    native_execution_pending=True,source_acceptance=False))
for pin in files+sources+configs:assert sha(R/pin['path'])==pin['sha256']
assert gate_path.read_bytes()==gate_raw
print(json.dumps({'manifest':manifest,'check_file':check,'source_pre':snapshot,'execution_plan':execution,'rows':41,'gate_statuses':counts,'source_count':len(sources)},indent=2))
