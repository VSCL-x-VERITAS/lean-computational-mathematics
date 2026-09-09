"""Bind received immutable canonical and joint-application evidence."""
from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent;G=P.parent/'riemann-certified-production'
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(p.read_bytes())
for name,digest in {
 'receipt.json':'6d60dbcaede51de0977f67d33f95e4da7c4717af52e8adac5c9aeba051e03fcd',
 'production-files-frozen.json':'034d23abd186f3084cc06e7f11150f5cf29ad5f3e32e9c0d456fce2bce90cb41',
 'manifest.json':'ea3aea0ff19c73bc47235ff975028eb1c035dbcc49a905cfb34e52d61c3f26b3',
 'DeclarationsAndApplication.lean':'bdaaf17555d5bd6fdc5451a1a3094306fe3205b99c058651129faee16096118d',
 'declarations-exit.json':'7f222a0580a6fb110fbce2d5a7ce66452dd5b003c60117bbf53186fadf43eba0',
}.items():assert sha(G/name)==digest,name
manifest=read(G/'manifest.json')
for item in manifest['files']+manifest['production_files']+manifest['production_compiled']+manifest['unchanged_old_producers']:
 assert sha(R/item['path'])==item['sha256'],item
for label in ('build','declarations'):
 native=read(G/(label+'-exit.json'));assert native['exit_code']==0
 for key in ('stdout','stderr'):
  item=native[key];assert sha(R/item['path'])==item['sha256'],item
 assert not (R/native['stderr']['path']).read_bytes()
 if label=='declarations':assert not re.search(rb'\b(?:error|warning):|sorryAx',(R/native['stdout']['path']).read_bytes())
inventory=read(G/'production-files-frozen.json')
target=next(x for x in inventory['files'] if x['path'].startswith('ComputationalMathematics/Source/'))
joint=G/'DeclarationsAndApplication.lean'
names=re.findall(r'^#check @([^\s]+)',joint.read_text(),re.M)
production={name for x in inventory['files'] for name in x['declarations']}
joint_names=[name for name in names if name not in production]
assert len(production)==7 and len(joint_names)==7 and len(names)==14
data={'schema':1,'status':'frozen-inputs-native-probe-required',
 'inventory':ref(G/'production-files-frozen.json'),
 'placement_receipt':ref(G/'receipt.json'),'placement_manifest':ref(G/'manifest.json'),
 'source_target':{**{k:target[k] for k in ('path','module','sha256')},'declaration':target['declarations'][0]},
 'joint_input':ref(joint),'joint_declarations':joint_names,
 'evidence':[ref(G/name) for name in ('receipt.json','manifest.json','build-exit.json','build-output.txt','build-stderr.txt',
    'declarations-exit.json','declarations-output.txt','declarations-stderr.txt')],
 'source_context_sha256':'36e26235c8260508a4e1c04ff3df5e6d7fdfa20f581bebb66452b27f4d761e95'}
with (P/'final-inputs.json').open('x',encoding='utf-8',newline='\n') as out:out.write(json.dumps(data,indent=2)+'\n')
print(json.dumps(ref(P/'final-inputs.json'),indent=2))
