"""Assemble an exact native probe only after explicit final production pins exist."""
from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
config=json.loads((P/'final-inputs.json').read_bytes())
assert config['schema']==1 and config['status']=='frozen-inputs-native-probe-required'
pins=[]
def pin(item):
 assert set(item)=={'path','sha256'} and '\\' not in item['path'] and '..' not in item['path'].split('/')
 p=R/item['path'];assert p.is_file() and sha(p)==item['sha256'],item
 pins.append(item);return p
inventory=json.loads(pin(config['inventory']).read_bytes())
for value in config['evidence']:pin(value)
source=pin({'path':config['source_target']['path'],'sha256':config['source_target']['sha256']})
joint=pin(config['joint_input'])
entries=inventory['files']
assert sum(len(x['declarations']) for x in entries)==config['expected_production_declarations']
names=[];commands=[]
for entry in entries:
 path=pin({'path':entry['path'],'sha256':entry['sha256']})
 text=path.read_text(encoding='utf-8')
 declared=re.findall(r'^(?:noncomputable\s+)?(?:protected\s+)?(?:private\s+)?(?:unsafe\s+)?(def|abbrev|structure|class|theorem|lemma)\s+([A-Za-z0-9_\u0080-\uffff.]+)',text,re.M)
 for name in entry['declarations']:
  assert name not in names;names.append(name)
  candidates={kind for kind,short in declared if name==short or name.endswith('.'+short)}
  assert len(candidates)==1,(name,candidates)
  kind=next(iter(candidates))
  commands.append('#check @'+name)
  if kind in {'def','abbrev','structure','class'}:commands.append('#print '+name)
  commands.append('#print axioms '+name)
target=config['source_target']['declaration']
if target not in names:
 names.append(target);commands.extend(['#check @'+target,'#print axioms '+target])
joint_names=config['joint_declarations']
assert len(joint_names)==config['expected_joint_declarations'] and len(set(joint_names))==len(joint_names)
jt=joint.read_text(encoding='utf-8')
for name in joint_names:
 commands.extend(['#check @'+name,'#print axioms '+name])
 # Definition bodies are printed only for the physical data/coordinate/method inputs.
 # The complete primary/fixture applications are proofs and are checked by type only.
 if name.rsplit('.',1)[-1] in {'position','active','cellAt','axes','physical','coord','families','method','initial','reference','amplification'}:
  commands.append('#print '+name)
imports=sorted(set(re.findall(r'^import\s+(\S+)',jt,re.M)+[config['source_target']['module']]+[x['module'] for x in entries]))
body=re.sub(r'^(?:import|#check|#print)\s+.*\n','',jt,flags=re.M)
header='\n'.join('import '+module for module in imports)+'\n'
header+='set_option pp.maxSteps 10000000\nset_option pp.deepTerms true\nset_option pp.proofs false\nset_option pp.universes false\nset_option maxRecDepth 4000\nset_option maxHeartbeats 1600000\n'
out=P/'CompleteTypesFull.lean'
with out.open('x',encoding='utf-8',newline='\n') as stream:stream.write(header+body+'\n'+'\n'.join(commands)+'\n')
with (P/'full-probe-inputs.json').open('x',encoding='utf-8',newline='\n') as stream:
 stream.write(json.dumps({'schema':1,'input':ref(out),'config':ref(P/'final-inputs.json'),'pins':pins,
 'production_and_source_declarations':names,'joint_declarations':joint_names,'commands':commands,
 'definitions_printed_proof_bodies_hidden':True},indent=2)+'\n')
print(json.dumps({'input':ref(out),'production_and_source_declarations':len(names),'joint_declarations':len(joint_names)},indent=2))
