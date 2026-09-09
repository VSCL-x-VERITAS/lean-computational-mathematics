"""Prepare one exact syntax-only owner refresh after the supplied actual successful build."""
from pathlib import Path
import argparse, copy, hashlib, json, os, re, subprocess

F=Path(__file__).resolve().parent
D=F.parent
S=D.parent
R=next(p for p in F.parents if (p/'lean-toolchain').exists())
P=D/'physical-current-fingerprints'
assert os.name=='posix'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(p.read_bytes())
def write(name,value):
    with (F/name).open('x',encoding='utf-8',newline='\n') as out:
        if isinstance(value,str):out.write(value)
        else:json.dump(value,out,indent=2,ensure_ascii=False);out.write('\n')
    return ref(F/name)

ap=argparse.ArgumentParser()
ap.add_argument('--build-receipt',required=True)
ap.add_argument('--build-sha256',required=True)
args=ap.parse_args()
build_path=R/args.build_receipt
assert sha(build_path)==args.build_sha256
build=read(build_path)
assert build['actual_exit_code']==0 and build['sources_unchanged']
assert sha(R/build['output']['path'])==build['output']['sha256']
for pin in build['input_sources']:assert sha(R/pin['path'])==pin['sha256']
old_path=P/'current-expression-fingerprints.json'
assert sha(old_path)=='fdb58496155e0c7b5513fba5d4d660716ef82d7cb86d809c183462528861354b'
assert sha(P/'final-receipt.json')=='8242a8f924430da58a1befef9b45a7249742e7193a77b9682f55ccef4362135d'
assert sha(P/'inputs.json')=='b95116235e67e1ad61c3c15d1799a7662082aaf3a628867ea44d9eddaca76bd8'
old=read(old_path);prior=read(P/'inputs.json')
assert len(old['files'])==183 and len(old['records'])==1688
owner='ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/PhysicalRefinementQuality.lean'
module=owner[:-5].replace('/','.')
assert module in build['command']
repair_path=D/'physical-production-promotion/layout-rhs-parentheses-01/receipt.json'
assert sha(repair_path)=='43f3b06844b9d3c79f5189015c839575f4dcb5b15fc47f796f6f183574c09ab9'
repair=read(repair_path)
for pin in repair['snapshots']:assert sha(R/pin['path'])==pin['sha256']
before=(R/repair['snapshots'][0]['path']).read_bytes()
after=(R/repair['snapshots'][1]['path']).read_bytes()
old_line=b'      constant * dt * family.mesh n ^ p\n'
assert before.count(old_line)==1
assert before.replace(old_line,b'      (constant * dt * family.mesh n ^ p)\n',1)==after
assert (R/owner).read_bytes()==after
assert repair['repair']['path']==owner
assert sha(R/owner)=='7709b11ae26a2ce26f3f6e620eaf768d82167db4a5a0769e1f9bc1a67914a310'
stale=[pin for pin in old['files'] if sha(R/pin['path'])!=pin['sha256']]
assert len(stale)==1 and stale[0]['path']==owner
assert stale[0]['sha256']==repair['repair']['before_sha256']
current=copy.deepcopy(stale[0]);current['sha256']=sha(R/owner)
current['lines']=len(after.decode().splitlines())
retained=[pin for pin in old['files'] if pin['path']!=owner]
closure={pin['path']:pin for pin in prior['project_import_closure']}
affected={owner}
while True:
    expanded=affected|{path for path,pin in closure.items() if any(m.replace('.','/')+'.lean' in affected for m in pin['imports'])}
    if expanded==affected:break
    affected=expanded
allowed_compiled={'.lake/build/lib/lean/'+str(Path(p).with_suffix('.olean')).replace('\\','/') for p in affected}
env=[];deltas=[]
for pin in prior['lean_environment']:
    now=ref(R/pin['path']);env.append(now)
    if now['sha256']!=pin['sha256']:
        assert pin['path']==owner or pin['path'] in allowed_compiled, pin['path']
        deltas.append({'before':pin,'after':now,'scope':'Only formatting owner or its canonical import successors may have changed compiled bytes.'})
old_selected_compiled=[]
for pin in prior['files']:
    cp='.lake/build/lib/lean/'+str(Path(pin['path']).with_suffix('.olean')).replace('\\','/')
    prior_pin=next(e for e in prior['lean_environment'] if e['path']==cp)
    old_selected_compiled.append({'module':pin['module'],'before':prior_pin,'current':ref(R/cp),'changed':sha(R/cp)!=prior_pin['sha256'],'allowed_dependency_successor':cp in allowed_compiled})
git=lambda *args:subprocess.check_output(['git','--no-optional-locks','--no-replace-objects',*args],cwd=R).decode().strip()
head=git('rev-parse','HEAD');tree=git('rev-parse',head+'^{tree}')
assert (head,tree)==(prior['input_commit'],prior['input_commit_tree'])
template=R/prior['prior_exporter']['path'];parser=R/prior['parser']['path']
assert ref(template)==prior['prior_exporter'] and ref(parser)==prior['parser']
text=template.read_text().replace('import ComputationalMathematics\nimport NumStability\n','import '+module+'\n',1)
start=text.index('private def selectedModules : Array String := #[')
end=text.index('\n]\n',start)+3
text=text[:start]+'private def selectedModules : Array String := #[\n  '+json.dumps(module)+'\n]\n'+text[end:]
raw=(F/'native-expression-stream.jsonl').relative_to(R).as_posix()
assert text.count('.lake/chapter01-one-step-expressions.jsonl')==1
text=text.replace('.lake/chapter01-one-step-expressions.jsonl',raw)
exporter=write('ExportCurrentDeclarations.lean',text)
expected=[r for r in old['records'] if r['module']==module]
scope=write('current-scope.json',{'schema':1,'source_changes':[{'before':stale[0],'after':current}],
    'all_other182_owner_sources_unchanged':True,'compiled_environment_changes':deltas,
    'allowed_canonical_dependency_successors':sorted(affected),'all_prior29_compiled_checks':old_selected_compiled,
    'normalization_equality_pending':True,'build_receipt':ref(build_path),'build_output':build['output'],
    'repair':ref(repair_path),'prior_inventory':ref(old_path),'expected_owner_records':len(expected)})
manifests=[scope,ref(build_path),build['output'],ref(repair_path),ref(P/'inputs.json'),ref(P/'final-receipt.json'),
    ref(P/'fresh-owner-expression-fingerprints.json'),ref(P/'owner-provenance.json')]
inputs=dict(schema=1,input_commit=head,input_commit_tree=tree,files=[current],selected_modules=[module],
    expected_authored_declarations=current['declarations'],expected_constant_count=len(expected),
    prior_owners=retained,prior_fingerprints=[ref(old_path)],input_manifests=manifests,lean_environment=env,
    project_import_closure=[dict(pin,sha256=sha(R/pin['path'])) for pin in closure.values()],
    normalization=old['normalization'],hash_encoding=old['hash_encoding'],counting_note=old['counting_note'],
    prior_exporter=ref(template),parser=ref(parser),exporter_path=exporter['path'],exporter_sha256=exporter['sha256'],
    raw_stream_path=raw,source_scope='Only the exact RHS parenthesis insertion; all other183-owner source bindings unchanged.',
    compiled_scope='Current source/compiled pins re-observed for previous60-owner closure; only chosen owner is freshly exported. No other compiled hash change is silently ignored.',
    replacement_policy='Require exact entire owner record equality, then update source binding and native provenance without changing any of the1688 records.')
result=write('inputs.json',inputs)
runner=P/'run-native.py'
assert sha(runner)=='6f3a996a41b02ed209349808e38af1ddbb01037edce9bcd9e743f18bad6f1450'
runner_text=runner.read_text()
assert runner_text.count(prior_sha:='b95116235e67e1ad61c3c15d1799a7662082aaf3a628867ea44d9eddaca76bd8')==1
new_runner=write('run-native.py',runner_text.replace(prior_sha,result['sha256']))
assert sha(P/'head.py')=='d2f7040dcd8ffbc719b434f7d84924c959992c8c1fa9dcd0399e1f2befba0ede'
head_script=write('head.py',(P/'head.py').read_text())
assert head_script['sha256']==sha(P/'head.py')
write('runner-derivation.json',{'parent':ref(runner),'derived':new_runner,'only_change':'Exact input manifest SHA replacement; source/compiled/native-tool/HEAD guard behavior unchanged.','head_script':head_script})
for pin in [current]+retained+env+manifests:assert sha(R/pin['path'])==pin['sha256']
assert git('rev-parse','HEAD')==head
print(json.dumps({'inputs':result,'scope':scope,'expected_constant_count':len(expected),'explicit_authors':len(current['declarations']),'compiled_deltas':len(deltas)},indent=2))
