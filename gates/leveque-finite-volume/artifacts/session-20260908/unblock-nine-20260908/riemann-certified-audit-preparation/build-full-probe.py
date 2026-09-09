"""Assemble a proof-free native output probe from frozen canonical inputs only."""
from pathlib import Path
import hashlib, json, re
P=Path(__file__).resolve().parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
config=json.loads((P/'final-inputs.json').read_bytes());pins=[]
assert config['schema']==1 and config['status']=='frozen-inputs-native-probe-required'
def pin(item):
    assert set(item)=={'path','sha256'} and '\\' not in item['path'] and '..' not in item['path'].split('/')
    path=R/item['path'];assert path.is_file() and sha(path)==item['sha256'],item
    pins.append(item);return path
inventory=json.loads(pin(config['inventory']).read_bytes())
for value in config['evidence']:pin(value)
pin({k:config['source_target'][k] for k in ('path','sha256')})
joint=pin(config['joint_input']);entries=inventory['files'];names=[];commands=[]
assert sum(len(x['declarations']) for x in entries)==7
for entry in entries:
    path=pin({k:entry[k] for k in ('path','sha256')})
    declared=re.findall(r'^(?:noncomputable\s+)?(?:protected\s+)?(?:private\s+)?(?:unsafe\s+)?(def|abbrev|structure|class|theorem|lemma)\s+([A-Za-z0-9_\u0080-\uffff.]+)',path.read_text(encoding='utf-8'),re.M)
    for name in entry['declarations']:
        assert name not in names;names.append(name)
        kinds={kind for kind,short in declared if name==short or name.endswith('.'+short)}
        assert len(kinds)==1,(name,kinds)
        commands.append('#check @'+name)
        if next(iter(kinds)) in {'def','abbrev','structure','class'}:commands.append('#print '+name)
        commands.append('#print axioms '+name)
assert config['source_target']['declaration'] in names
definitions=[
 'NumStability.LocalRiemannInformation.Law','NumStability.LocalRiemannInformation.Problem',
 'NumStability.LocalRiemannInformation.Reference','NumStability.LocalRiemannInformation.Reference.meanFlux',
 'NumStability.LocalRiemannInformation.Routine','NumStability.LocalRiemannInformation.Routine.flux',
 'NumStability.LocalRiemannInformation.Routine.Consistent','NumStability.LocalRiemannInformation.Method',
 'NumStability.LocalRiemannInformation.Method.toRoutine','NumStability.LocalRiemannInformation.biasedRoutine',
 'NumStability.IsRiemannData','NumStability.riemannData',
 'NumStability.oneDimensionalCellAverage','NumStability.IsOneDimensionalCellAverage',
 'NumStability.cellVolumeAverage','NumStability.IsCellVolumeAverage','NumStability.finiteVolumeCellAverageUpdate',
 'NumStability.BiasedLocalRiemannRoutine.law','NumStability.BiasedLocalRiemannRoutine.reference',
 'NumStability.BiasedLocalRiemannRoutine.equalProblem','NumStability.StationaryRiemannField.transportLaw',
 'NumStability.StationaryRiemannField.reference']
for name in definitions:commands.extend(['#check @'+name,'#print '+name,'#print axioms '+name])
joint_names=config['joint_declarations'];assert len(joint_names)==len(set(joint_names))
for name in joint_names:
    commands.extend(['#check @'+name,'#print axioms '+name])
    if name.rsplit('.',1)[-1] in {'leftProblem','rightProblem'}:commands.append('#print '+name)
jt=joint.read_text(encoding='utf-8')
imports=sorted(set(re.findall(r'^import\s+(\S+)',jt,re.M)+[x['module'] for x in entries]))
body=re.sub(r'^(?:import|#check|#print)\s+.*\n','',jt,flags=re.M)
header='\n'.join('import '+m for m in imports)+'\n'
header+='set_option pp.maxSteps 10000000\nset_option pp.deepTerms true\nset_option pp.proofs false\nset_option pp.universes false\nset_option maxRecDepth 10000\nset_option maxHeartbeats 1600000\n'
out=P/'CompleteTypesFull.lean'
with out.open('x',encoding='utf-8',newline='\n') as stream:stream.write(header+body+'\n'+'\n'.join(commands)+'\n')
with (P/'full-probe-inputs.json').open('x',encoding='utf-8',newline='\n') as stream:
    stream.write(json.dumps({'schema':1,'input':ref(out),'config':ref(P/'final-inputs.json'),'pins':pins,
        'production_and_source_declarations':names,'definition_declarations':definitions,
        'joint_declarations':joint_names,'commands':commands,
        'definitions_printed_proof_bodies_hidden':True},indent=2)+'\n')
print(json.dumps({'input':ref(out),'production':len(names),'definitions':len(definitions),'joint':len(joint_names)},indent=2))
