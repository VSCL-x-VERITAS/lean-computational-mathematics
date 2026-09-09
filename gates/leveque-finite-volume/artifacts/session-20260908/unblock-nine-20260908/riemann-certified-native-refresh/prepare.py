"""Prepare identical InfoCERT native declarations with freshly observed dependency pins."""
from pathlib import Path
import hashlib,json,os,re
F=Path(__file__).resolve().parent;D=F.parent
R=next(p for p in F.parents if (p/'lean-toolchain').exists())
OLD=D/'riemann-certified-audit-preparation'
assert os.name=='posix'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(p.read_bytes())
def write(name,value):
    with (F/name).open('x',encoding='utf-8',newline='\n') as out:
        if isinstance(value,str):out.write(value)
        else:json.dump(value,out,indent=2,ensure_ascii=False);out.write('\n')
    return ref(F/name)
for name,expected in {
    'CompleteTypesReadable.lean':'5262c093cf4715c766788cb38f0784f95dc7a497e7229b294c80235fc487c117',
    'run-native.py':'50ed6a654098a9fb9150ae6e6aa3d84a983f269f0528fb52dec0ed389cddcfec',
    'full-02/receipt.json':'579043169ee1265554afd4e4a041d783a836bcdf67d7cf520df528ec559e1755',
    'spec-01/native-packet.json':'e7c22d1fc55b91ef9ff1d91312c65fe8b9b1f5cd661457a2f61b6eb87aa2f175',
    'spec-01/native-environment.json':'a0884c03401865209fab1f0deef01f8a8fbb95db7b595bc38a04dc2ae2dcae02'}.items():
    assert sha(OLD/name)==expected
for name in ('CompleteTypesReadable.lean','run-native.py'):
    with (F/name).open('xb') as out:out.write((OLD/name).read_bytes())
    assert sha(F/name)==sha(OLD/name)
probe=read(OLD/'full-probe-readable-inputs.json')
expected=probe['production_and_source_declarations']+probe['definition_declarations']+probe['joint_declarations']
assert len(expected)==len(set(expected))==36
source='ComputationalMathematics/Source/LeVeque/Chapter01/RiemannCertifiedRoutineInterface.lean'
assert sha(R/source)=='3ea14df37c089e35fb4a7e780ad927c4ca838630484764017833d06bd5ade027'
queue=re.findall(r'^(?:public\s+)?import\s+(\S+)',(F/'CompleteTypesReadable.lean').read_text(),re.M)
closure={}
while queue:
    module=queue.pop()
    if not module.startswith(('ComputationalMathematics.','NumStability.')) or module in closure:continue
    path=R/(module.replace('.','/')+'.lean')
    imports=re.findall(r'^(?:public\s+)?import\s+(\S+)',path.read_text(),re.M)
    closure[module]={'source':ref(path),'imports':imports};queue.extend(imports)
old_env=read(OLD/'spec-01/native-environment.json')
current=[];changed=[]
for pin in old_env['environment_files']:
    now=ref(R/pin['path']);current.append(now)
    if now!=pin:
        if pin['path'].endswith('.lean'):
            assert pin['path']=='ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Hyperbolicity.lean'
            assert now['sha256']=='85f7b3259f5eb5b07440b6d5f4e06a642b8380ec3f2d2770732ed6775136cb96'
        else:
            prefix='.lake/build/lib/lean/'
            assert pin['path'].startswith(prefix)
            module=pin['path'][len(prefix):].split('.olean')[0].replace('/','.')
            assert module in closure,pin['path']
        changed.append({'prior':pin,'current':now})
assert len(current)==283
io=D/'fv-local-domain-review/native-long-path-io.py'
wrapper='''from pathlib import Path
import hashlib,os,runpy,sys
F=Path(__file__).resolve().parent
helper=F.parent/'fv-local-domain-review/native-long-path-io.py'
assert hashlib.sha256(helper.read_bytes()).hexdigest()==IO_SHA
exec(compile(helper.read_bytes(),str(helper),'exec'),globals())
sys.argv=[str(F/'run-native.py'),'CompleteTypesReadable.lean','native-01']
runpy.run_path(str(F/'run-native.py'),run_name='__main__')
'''.replace('IO_SHA',repr(sha(io)))
launcher=write('run-refresh.py',wrapper)
metadata=write('inputs.json',dict(schema=1,status='IDENTICAL PROBE CURRENT NATIVE REFRESH REQUIRED',
    prior_packet=ref(OLD/'spec-01/native-packet.json'),prior_environment=ref(OLD/'spec-01/native-environment.json'),
    prior_native_receipt=ref(OLD/'full-02/receipt.json'),prior_probe_manifest=ref(OLD/'full-probe-readable-inputs.json'),
    probe=ref(F/'CompleteTypesReadable.lean'),probe_bytes_identical_to=ref(OLD/'CompleteTypesReadable.lean'),
    runner=ref(F/'run-native.py'),runner_bytes_identical_to=ref(OLD/'run-native.py'),launcher=launcher,io_helper=ref(io),
    expected_declarations=expected,expected_axiom_reports=36,source_target=ref(R/source),
    current_project_import_closure=closure,current_environment_from_prior=current,dependency_changes=changed,
    completed_current41=ref(D/'physical-current-complete-declarations/final-receipt.json'),
    context_templates_unchanged=ref(D/'riemann-certified-context-successor-preparation/receipt.json'),
    scope='Only current native proof-free output and dependency binding. No source-context construction, literal reply/adoption, task specification, or role invocation.'))
print(json.dumps({'inputs':metadata,'changed_environment_files':len(changed),'changed_paths':[c['current']['path'] for c in changed],
    'expected_reports':36,'project_import_closure':len(closure),'probe':ref(F/'CompleteTypesReadable.lean')},indent=2))
