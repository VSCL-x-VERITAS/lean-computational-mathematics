"""Bind actual production checks and exact draft-to-canonical comparisons."""
from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent;S=P.parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
bind=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
inputs=read(P/'placement-inputs.json')
for key in ['source','production','comparison']:
 data=inputs[key];assert sha(R/data['path'])==data['sha256']
receipts=[]
for label in ['rectangle-riemann-flux-production-build','rectangle-riemann-flux-production-declarations']:
 recpath=S/(label+'-exit.json');out=S/(label+'-output.txt');rec=read(recpath)
 assert rec['exit_code']==0 and rec['output_sha256']==sha(out)
 assert rec['input_commit']=='1039d1b103f71c63052002803e46e779776b067d'
 assert not re.search(r'\b(?:warning|error):|sorryAx',out.read_text(encoding='utf-8-sig'))
 receipts.append({'receipt':bind(recpath),'output':bind(out),'actual':rec})
out=(S/'rectangle-riemann-flux-production-declarations-output.txt').read_text(encoding='utf-8-sig')
assert out.count('TYPE_PRESERVED ')==3 and 'CHECKED_CANONICAL_DECLARATIONS 3' in out
for old,new in inputs['pairs']:
 assert 'TYPE_PRESERVED NumStability.RectangleFluxErrorDraft.'+old+' => NumStability.'+new in out
 matches=re.findall(re.escape("'NumStability."+new+"' depends on axioms:")+r'\s*\[([^\]]*)\]',out)
 assert len(matches)==1 and {x.strip() for x in matches[0].split(',') if x.strip()}<={'propext','Classical.choice','Quot.sound'}
production=R/inputs['production']['path'];module=inputs['production']['path'][:-5].replace('/','.')
record={'schema':1,'placement_inputs':bind(P/'placement-inputs.json'),'candidate_manifest':bind(S/'rectangle-riemann-flux-error-draft/manifest.json'),'canonical_files':[{'module':module,**bind(production),'compiled':bind(R/('.lake/build/lib/lean/'+inputs['production']['path'][:-5]+'.olean'))}],'native_receipts':receipts,'canonical_declarations':['NumStability.'+b for a,b in inputs['pairs']],'definitional_type_comparisons':3,'all_actual_exits_zero':True,'source_acceptance':False,'root_review':'The independently reviewed arbitrary admitted-method estimates retain both pointwise errors, the actual returned solver and fixed-old-domain restriction. Existing averaging, norm triangle and finite-volume cell/block error producers are reused. Production extraction changes only names, documentation and scratch commands; three native metaprogram checks establish type equality.'}
dest=P/'final-receipt.json'
with dest.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({'receipt':bind(dest),'production':bind(production),'declarations':3,'type_comparisons':3}))
