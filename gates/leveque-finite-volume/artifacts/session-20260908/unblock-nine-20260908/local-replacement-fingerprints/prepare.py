"""Read-only POSIX Git and exact twelve-owner native export preparation."""
from pathlib import Path
import hashlib,json,os,re,subprocess
F=Path(__file__).resolve().parent;D=F.parent;S=D.parent;R=S.parents[3]
assert os.name!='nt','Run through the POSIX launcher; no native Git.'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(p.read_text(encoding='utf-8'))
def write(name,data):
 with (F/name).open('x',encoding='utf-8',newline='\n') as f:json.dump(data,f,indent=2,ensure_ascii=False);f.write('\n')
priors=[(S/'chapter01-current-expression-fingerprints-24b3.json','c27b9c4b5b0bf1c6fa6f26300045423512118a24c0b24eff2b57f65d77f09400'),(S/'baseline-equation03-expression-fingerprints.json','e29b3e71a3bffdba15b88e5e2ef5f45907e16aa982c40bb93da828c91aafd720'),(D/'final-fingerprints/additional-expression-fingerprints.json','15009d6f8a15ce539ed0e24603bf006abc2dbdb5975212f3c6446bf94d85a1e4')]
known={};oldnames=set();oldmodules=set()
for p,h in priors:
 assert sha(p)==h,p
 obj=read(p)
 for row in obj['files']:
  assert row['path'] not in known,row['path'];known[row['path']]=row
  assert sha(R/row['path'])==row['sha256'],row['path']
 for row in obj['records']:
  assert row['name'] not in oldnames,row['name'];oldnames.add(row['name']);oldmodules.add(row['module'])
assert len(known)==134 and len(oldnames)==941
files=read(D/'dimensional-method-production/placement-inventory.json')['files']
fv=read(D/'fv-local-domain-review/local-law-production-freeze.json')
files += [x for x in fv['source_inputs'] if x['path'].startswith('ComputationalMathematics/')]
core=read(D/'local-riemann-core-placement.json')['placed']
core['declarations']=['NumStability.LocalRiemannInformation.'+s for s in ('Law','Problem','Reference','Reference.meanFlux','Method','Method.flux','Method.reference_comparison')]
files.append(core)
update=read(D/'local-riemann-update-placement.json')['placed']
update[0]['declarations']=['NumStability.LocalRiemannInformation.adjacentProblem','NumStability.LocalRiemannInformation.local_interface_contract']
update[1]['declarations']=['NumStability.leveque01_localRiemannInformationInterface_sourceContract']
files+=update
assert len(files)==12 and sum(len(f['declarations']) for f in files)==44
for f in files:
 assert f['path'] not in known,f['path'];assert sha(R/f['path'])==f['sha256'],f
 f['module']=f['path'][:-5].replace('/','.');f['lines']=len((R/f['path']).read_text().splitlines())
 assert f['module'] not in oldmodules
assert not set(n for f in files for n in f['declarations'])&oldnames
files=sorted(files,key=lambda f:f['path']);selected=[f['module'] for f in files]
closure={};queue=[f['path'] for f in files];environment={}
while queue:
 p=queue.pop()
 if p in closure:continue
 owner=R/p;imports=re.findall(r'^import\s+(\S+)',owner.read_text(encoding='utf-8'),re.M)
 closure[p]=dict(**ref(owner),imports=imports)
 ole=R/'.lake/build/lib/lean'/Path(p).with_suffix('.olean');assert ole.is_file(),ole
 environment[ole.relative_to(R).as_posix()]=ref(ole)
 for mod in imports:
  if mod.startswith('ComputationalMathematics.'):queue.append(mod.replace('.','/')+'.lean')
  elif mod.startswith('Mathlib.'):
   for q in [R/'.lake/packages/mathlib'/(mod.replace('.','/')+'.lean'),R/'.lake/packages/mathlib/.lake/build/lib/lean'/(mod.replace('.','/')+'.olean')]:
    assert q.is_file(),q;environment[q.relative_to(R).as_posix()]=ref(q)
missing=sorted(set(closure)-set(known)-{f['path'] for f in files})
for row in closure.values():environment[row['path']]={k:row[k] for k in ('path','sha256')}
for p in ('lean-toolchain','lake-manifest.json','lakefile.toml'):environment[p]=ref(R/p)
git=lambda *args:subprocess.check_output(['git','--no-replace-objects','-c','core.longpaths=true',*args],cwd=R)
head=git('rev-parse','HEAD').decode().strip();tree=git('rev-parse',head+'^{tree}').decode().strip()
assert head=='5e3f63594aa964263469ada134aee2809559d50d',head
template=S/'export-one-step-declaration-expressions.lean';parser=S/'freeze-chapter01-expression-fingerprints-v3.py'
assert sha(template)=='7558eecccba14ecfa22874b8eb6bee3438146a5578bb21a34cf0ae9a7becb063'
assert sha(parser)=='fe089bb896ff20a624d9f34efbf957fea3c168a591ea9bfbd4235481dc595702'
text=template.read_text().replace('import ComputationalMathematics\nimport NumStability\n',''.join('import '+m+'\n' for m in selected),1)
a=text.index('private def selectedModules : Array String := #[');b=text.index('\n]\n',a)+3
text=text[:a]+'private def selectedModules : Array String := #[\n'+',\n'.join('  '+json.dumps(m) for m in selected)+'\n]\n'+text[b:]
raw=(F/'native-expression-stream.jsonl').relative_to(R).as_posix();assert text.count('.lake/chapter01-one-step-expressions.jsonl')==1
text=text.replace('.lake/chapter01-one-step-expressions.jsonl',raw)
exporter=F/'ExportLocalDeclarations.lean'
with exporter.open('x',encoding='utf-8',newline='\n') as f:f.write(text)
base=read(priors[0][0])
inputs=dict(schema=1,input_commit=head,input_commit_tree=tree,scope='Exactly twelve new production owners, including their public generated constructor/recursor/projection constants under the unchanged prior filter.',files=files,selected_modules=selected,expected_authored_new_declarations=sorted(n for f in files for n in f['declarations']),prior_fingerprints=[ref(p) for p,h in priors],prior_owner_count=134,prior_constant_count=941,prior_owners=sorted(known.values(),key=lambda x:x['path']),project_import_closure=list(closure.values()),unfingerprinted_dependency_owners_outside_requested_scope=missing,lean_environment=list(environment.values()),normalization=base['normalization'],counting_note=base['counting_note'],hash_encoding=base['hash_encoding'],prior_exporter=ref(template),parser=ref(parser),exporter_path=exporter.relative_to(R).as_posix(),exporter_sha256=sha(exporter),raw_stream_path=raw,commit_scope='Actual current input HEAD, with twelve separately pinned new worktree owners. No future commit, candidate, promotion or source acceptance is asserted.',input_manifests=[ref(D/'dimensional-method-production/placement-inventory.json'),ref(D/'fv-local-domain-review/local-law-production-freeze.json'),ref(D/'local-riemann-core-placement.json'),ref(D/'local-riemann-update-placement.json')])
assert git('rev-parse','HEAD').decode().strip()==head
write('inputs.json',inputs)
print(json.dumps(dict(input_manifest=ref(F/'inputs.json'),owners=12,authored_declarations=44,prior_constants=941,prior_owners=134,project_closure=len(closure),unfingerprinted_dependency_owners=missing,exporter=ref(exporter))))
