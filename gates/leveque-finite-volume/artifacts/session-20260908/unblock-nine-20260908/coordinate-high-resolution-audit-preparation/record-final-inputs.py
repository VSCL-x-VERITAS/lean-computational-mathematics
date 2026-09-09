"""Record explicitly received frozen production inputs; no source changes."""
from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent;D=P.parent;G=D/'directional-high-resolution-production'
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
inventory=G/'production-files-frozen.json'
assert sha(inventory)=='cb7623870ad874124148177f971a30c9e18e6b0172d2e21e59c6ae135f9c4538'
data=json.loads(inventory.read_bytes());assert data['authored_declaration_count']==150 and len(data['files'])==16
evidence=[ref(inventory)]
for item in data['files']:
 assert sha(R/item['path'])==item['sha256']
 assert {x['name'] for x in item['declaration_kinds']}==set(item['declarations'])
for item in data['native_receipts']:
 p=R/item['path'];assert sha(p)==item['sha256'];receipt=json.loads(p.read_bytes())
 assert receipt['actual_exit_code']==0 and receipt['dependencies_unchanged']
 evidence.append(item)
 for value in [receipt['source'],receipt['output'],receipt['runner'],*receipt['dependencies']]:
  assert sha(R/value['path'])==value['sha256'],value
  evidence.append(value)
joint=R/data['joint_application']['path'];assert sha(joint)==data['joint_application']['sha256']
source=R/'ComputationalMathematics/Source/LeVeque/Chapter01/CoordinateHighResolutionMethods.lean'
assert sha(source)=='e7d3da45027462919030380de761642cb5013f00a451df12bdebbc0a4a8efc54'
target='NumStability.leveque01_coordinateHighResolutionMethods_sourceContract'
names=re.findall(r'^#check\s+(\S+)\s*$',joint.read_text(),re.M)
names=[n for n in names if n!=target]
assert len(names)==41 and len(set(names))==41
context=D/'directional-complete-repair-review/source-context-with-user-high-resolution-v2.json'
assert sha(context).startswith('71bd398')
unique={}
for value in evidence:
 assert value['path'] not in unique or unique[value['path']]==value['sha256']
 unique[value['path']]=value['sha256']
config={'schema':1,'status':'frozen-inputs-native-probe-required','inventory':ref(inventory),
 'evidence':[{'path':p,'sha256':h} for p,h in sorted(unique.items())],
 'source_target':{**ref(source),'declaration':target,'module':'ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateHighResolutionMethods'},
 'joint_input':ref(joint),'joint_declarations':names,
 'expected_production_declarations':150,'expected_joint_declarations':41,
 'source_context_sha256':sha(context),'source_acceptance':False}
with (P/'final-inputs.json').open('x',encoding='utf-8',newline='\n') as stream:stream.write(json.dumps(config,indent=2)+'\n')
print(json.dumps({'config':ref(P/'final-inputs.json'),'evidence_count':len(unique),'source':ref(source)},indent=2))
