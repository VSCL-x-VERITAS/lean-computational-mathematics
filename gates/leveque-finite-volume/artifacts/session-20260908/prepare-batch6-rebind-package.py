"""Add exact scoped dispatch for the 31 reviewed closed rows; no gate mutation."""
from pathlib import Path
from datetime import datetime,timezone
import ast,copy,hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3];G=R/'gates/leveque-finite-volume/chapter-01.json'
parent=S/'definition-rebind-preparation';P=S/'batch6-rebind-preparation'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
def bind(p):return {'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def write(p,v):
 with p.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(v,indent=2,ensure_ascii=True)+'\n')
assert sha(parent/'rebind-closed-rows.py')=='78654a31a8662143deeef5d2805e2e8dcf5409110c7a396311d6835c31589a71'
assert sha(parent/'reviewed-inputs.json')=='60388276c5a9b1b24a08701b5215e0bc020c873cb0ab59addf8dcf0496bb7e8d'
inputs=copy.deepcopy(read(parent/'reviewed-inputs.json'));before=G.read_bytes();gate=json.loads(before)
oldpins={p['id']:p for p in inputs['closed_rows']};rows=[]
scope=['adjudicated_scope_note','strengthening_evidence','applicability_audit','nonvacuity_witness','source_ambiguity_note']
for row in gate['rows']:
 if row['status'] not in ('PROVED','REUSED','DISCREPANCY'):continue
 taskpath=R/row['faithfulness_task'];task=read(taskpath);out=R/task['audit_output'];contract=G.parent/row['source_contract_artifact']
 assert sha(contract)==row['source_contract_sha256']
 rec={'id':row['id'],'status':row['status'],'task':bind(taskpath),'target':task['target'],'manifest':bind(out/'manifest.json'),'decision':bind(out/'decision.json'),'source_extraction':bind(out/'agent_outputs/source_contract.json'),'contract_hash':row['contract_hash'],'contract':read(contract)['payload']['contract'],'classification':row['classification'],'scope_fields':{k:row[k] for k in scope if k in row}}
 if row['id'] in oldpins:assert rec==oldpins[row['id']],'Earlier reviewed meaning changed'
 rows.append(rec)
assert len(rows)==31 and set(oldpins)<={r['id'] for r in rows}
for name,expected in [('bind-audited-stronger-production-rows.py','2b6e6d26931f831970479cfdae30f066d3712586363ef08e6ce0b830306782d6'),('bind-equation10-interpreted-proved-row.py','f30c1703dc968d8aacff63c4c152202c164e46c867ba494058095f797435b594')]:
 assert sha(S/name)==expected;inputs['adapters'][name]=bind(S/name)
catalogs=[('stronger-production','stronger-production-proof-inputs.json','stronger-production-witnesses-v2.lean','stronger-production-witnesses-v2-output.txt','stronger-production-witnesses-v2-exit.json'),('definition-repairs','definition-repairs-production-inputs.json','definition-repairs-production-checks.lean','definition-repairs-production-declarations-output.txt','definition-repairs-production-declarations-exit.json')]
extra=[]
for key,m,c,l,e in catalogs:
 rec={'key':key,**{k:bind(S/n) for k,n in [('manifest',m),('check_file',c),('resolution_log',l),('resolution_exit',e)]}}
 receipt=read(S/e);assert type(receipt['exit_code']) is int and receipt['exit_code']==0
 assert receipt['command']=='lake env lean '+rec['check_file']['path'] and receipt['output_sha256']==sha(S/l)
 assert read(S/m)['check_file_sha256']==sha(S/c);extra.append(rec)
inputs['proof_catalog']=extra+inputs['proof_catalog']
newpins=read(S/'stronger-production-binding-pins.json')
inputs['extra_evidence'] += [bind(S/'stronger-production-binding-pins.json')]+[p['evidence'] for p in newpins['rows']]
inputs.update({'created_at_utc':datetime.now(timezone.utc).isoformat(),'gate_at_preparation':bind(G),'closed_count_at_preparation':31,'closed_rows':rows})
P.mkdir(exist_ok=False);write(P/'reviewed-inputs.json',inputs)
code=(parent/'rebind-closed-rows.py').read_text(encoding='utf-8')
def replace(old,new):
 global code
 assert code.count(old)==1,old
 code=code.replace(old,new)
replace("INPUT_SHA='60388276c5a9b1b24a08701b5215e0bc020c873cb0ab59addf8dcf0496bb7e8d'","INPUT_SHA='"+sha(P/'reviewed-inputs.json')+"'")
replace("SMOOTH='LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH'","SMOOTH='LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH'\nEQ10='LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION'\nPRODUCTION_STRONGER={'LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION','LEV-CH01-NONLINEAR-SHOCK-FORMATION'}")
replace(" if row['id']==DISCONTINUITY:return 'bind-discontinuity-interpreted-proved-row.py'"," if row['id']==DISCONTINUITY:return 'bind-discontinuity-interpreted-proved-row.py'\n if row['id']==EQ10:return 'bind-equation10-interpreted-proved-row.py'")
replace(" if row['classification']=='faithful-stronger':\n  require(row['id']==SMOOTH", " if row['classification']=='faithful-stronger':\n  if row['id'] in PRODUCTION_STRONGER:\n   require(row['status']=='PROVED','Pinned production stronger status changed')\n   return 'bind-audited-stronger-production-rows.py'\n  require(row['id']==SMOOTH")
replace("'--row',row['id'],'--resolution-log',str(bound(proof['resolution_log']))]", "'--row',row['id']]\n  if row['id'] not in PRODUCTION_STRONGER:cmd+=['--resolution-log',str(bound(proof['resolution_log']))]")
replace("  if row['status']=='PROVED':", "  if row['status']=='PROVED' and row['id'] not in PRODUCTION_STRONGER:")
replace("  if row['id'] in TRANSPORT or row['id']==DISCONTINUITY:","  if row['id'] in TRANSPORT or row['id'] in {DISCONTINUITY,EQ10}:")
replace("   stronger.validate_strengthening_evidence(R,taskpath,task,manifest,decision,evidence,row=row)","   selected=import_module('production_stronger_rebind_checks',adapters['bind-audited-stronger-production-rows.py']) if row['id'] in PRODUCTION_STRONGER else stronger\n   selected.validate_strengthening_evidence(R,taskpath,task,manifest,decision,evidence,row=row)")
ast.parse(code)
with (P/'rebind-closed-rows.py').open('x',encoding='utf-8',newline='') as f:f.write(code)
assert G.read_bytes()==before
write(P/'derivation.json',{'schema':1,'generator':bind(Path(__file__)),'parent_driver':bind(parent/'rebind-closed-rows.py'),'parent_inputs':bind(parent/'reviewed-inputs.json'),'driver':bind(P/'rebind-closed-rows.py'),'inputs':bind(P/'reviewed-inputs.json'),'changes':['Preserve every one of the earlier 28 semantic pins and scoped adapters','Add the interpreted equation (1.10) receipt-bound adapter and native definition proof catalog','Add only the two pinned stronger production tasks, their native nonvacuity catalog and exact evidence checks','Keep status, task, target, classification, source contract and qualifications invariant on rebind'],'production_or_gate_mutation':False})
print(json.dumps({'closed_count':31,'driver':bind(P/'rebind-closed-rows.py'),'inputs':bind(P/'reviewed-inputs.json'),'gate_unchanged':True}))
