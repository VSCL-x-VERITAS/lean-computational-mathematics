"""Complete the preserved partial preparation with the actual architecture tiers path."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,subprocess
F=Path(__file__).resolve().parent;D=F.parent;S=D.parent
R=next(p for p in F.parents if (p/'lean-toolchain').exists())
assert os.name=='posix'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(p.read_bytes())
def write(name,value):
    with (F/name).open('x',encoding='utf-8',newline='\n') as out:json.dump(value,out,indent=2);out.write('\n')
    return ref(F/name)
manifest=read(F/'manifest.json')
assert len(manifest['rows'])==len(manifest['declarations'])==41
assert manifest['current_gate_statuses']=={'PROVED':22,'REUSED':17,'IN_PROGRESS':2,'SKIPPED':16}
assert sha(F/'selection-gate.snapshot.json')==manifest['selection_gate_sha256']
assert sha(R/'gates/leveque-finite-volume/chapter-01.json')==manifest['selection_gate_sha256']
assert sha(R/manifest['check_file'])==manifest['check_file_sha256']
for pin in manifest['files']+manifest['replacement_specifications']+[manifest['prior_manifest']]:assert sha(R/pin['path'])==pin['sha256']
paths=sorted(set([p for root in ('ComputationalMathematics','NumStability') for p in (R/root).rglob('*.lean')]+[R/'ComputationalMathematics.lean',R/'NumStability.lean']))
sources=[]
for path in paths:
    assert path.is_file() and not path.is_symlink();sources.append(ref(path))
configs=[ref(R/name) for name in ('lean-toolchain','lake-manifest.json','lakefile.toml','docs/architecture/tiers.json')]
capture=D/'capture-check.py';assert sha(capture)=='db1280f152c591b72d6e8542c64f7f814ed5ab6a8dda8a88736e19227ace29a8'
command=['git','--no-optional-locks','--no-replace-objects','rev-parse','HEAD']
p=subprocess.run(command,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE);assert p.returncode==0
head=p.stdout.decode().strip();assert head=='5e3f63594aa964263469ada134aee2809559d50d'
snapshot=write('source-pre.json',dict(schema=1,at_utc=datetime.now(timezone.utc).isoformat(),files=sources,configs=configs,source_count=len(sources),
    scope='Actual filesystem Lean source-stability snapshot, not tracked-layout census.',input_commit=head,
    head_observation=dict(command=command,exit_code=0,stdout=p.stdout.decode(),stderr=p.stderr.decode()),capture=ref(capture),
    manifest=ref(F/'manifest.json'),check=dict(path=manifest['check_file'],sha256=manifest['check_file_sha256']),gate_selection_snapshot=ref(F/'selection-gate.snapshot.json')))
execution=write('execution-plan.json',dict(schema=1,manifest=ref(F/'manifest.json'),source_pre=snapshot,capture=ref(capture),input_commit=head,
    runs=[{'kind':'full_build','label':'unblock-nine-physical-final41-full-build','argv':['build','ComputationalMathematics','NumStability']},
          {'kind':'focused_build','label':'unblock-nine-physical-final41-chapter01-build','argv':['build','ComputationalMathematics.Source.LeVeque.Chapter01']},
          {'kind':'complete_native','label':'unblock-nine-physical-final41-declarations','argv':['env','lean',manifest['check_file']]}],
    native_execution_pending=True,source_acceptance=False))
for pin in sources+configs:assert sha(R/pin['path'])==pin['sha256']
recovery=write('preparation-recovery.json',dict(prior_failure=ref(F/'prepare-01-failure.json'),original_script=ref(F/'prepare.py'),recovery_script=ref(Path(__file__)),
    preserved_manifest=ref(F/'manifest.json'),source_pre=snapshot,execution_plan=execution,actual_source_count=len(sources),
    changed_configuration_path_only='docs/architecture/tiers.json',production_mutation=False,source_acceptance=False))
print(json.dumps({'manifest':ref(F/'manifest.json'),'source_pre':snapshot,'execution_plan':execution,'recovery':recovery},indent=2))
