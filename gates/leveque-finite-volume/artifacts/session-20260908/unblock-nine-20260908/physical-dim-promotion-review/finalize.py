"""Seal only the proposal review files; do not build or mutate reviewed inputs."""
from pathlib import Path
import json,hashlib
P=Path(__file__).resolve().parent;R=P.parents[5]
def raw(p):
 with open('\\\\?\\'+str(p),'rb') as f:return f.read()
def ref(p):
 b=raw(p);return {'path':p.relative_to(R).as_posix(),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def put(name,obj):
 with open('\\\\?\\'+str(P/name),'xb') as f:f.write((json.dumps(obj,indent=2)+'\n').encode())
inputs=json.loads(raw(P/'inputs.json'))['inputs'];unchanged=[];advanced=[]
for item in inputs:
 p=Path(item['path']);p=p if p.is_absolute() else R/p
 now=hashlib.sha256(raw(p)).hexdigest()
 if now==item['sha256']:unchanged.append(item['path'])
 else:
  assert 'physical-high-resolution-sweep-draft/' in item['path'],item['path']
  advanced.append({'path':item['path'],'view_sha256':item['sha256'],'current_sha256':now,
     'note':'Parent-owned admitted-source revision; original read view retained. Final promotion requires native-success successor.'})
put('write-attempt01.json',{'actual_status':'tool process creation rejected before Python start','system_error':'Windows error 206: filename or extension too long',
 'cause':'Combined documentation payload exceeded Windows command-line limit','recovery':'Three smaller exclusive-create native Python commands, each actual exit 0.',
 'production_effect':False})
put('verification.json',{'schema':1,'status':'proposal-inputs-verified','unchanged_inputs':unchanged,'parent_advancing_views':advanced,
 'actual_native_builds_run':0,'git_commands_run':0,'source_acceptance':False,'new_leaf_collisions':0,
 'final_admitted_sweep_validation':'pending final frozen input; not assessed by this snapshot'})
files=[ref(q) for q in sorted(P.iterdir()) if q.is_file()]
put('manifest.json',{'schema':1,'files':files,'authority':'proposal-only','source_acceptance':False})
put('receipt.json',{'schema':1,'status':'root-review-required','manifest':ref(P/'manifest.json'),
 'mapping':ref(P/'mapping.json'),'review':ref(P/'REVIEW.md'),'inputs':ref(P/'inputs.json'),
 'verification':ref(P/'verification.json'),'new_leaves_proposed':12,'changed_mathematical_owners_proposed':3,
 'changed_source_owners_proposed':1,'separate_regularization_owners':5,'source_acceptance':False,
 'production_mutation':False,'gate_mutation':False,'git_mutation':False})
print(json.dumps({'receipt':ref(P/'receipt.json'),'mapping':ref(P/'mapping.json'),'review':ref(P/'REVIEW.md'),
 'manifest':ref(P/'manifest.json'),'advancing_views':advanced},indent=2))
