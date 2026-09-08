"""Prepare a non-mutating 32-row rebind package including pinned stronger consensus."""
from pathlib import Path
from datetime import datetime,timezone
import ast,copy,hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3];G=R/'gates/leveque-finite-volume/chapter-01.json'
parent=S/'batch6-rebind-preparation';P=S/'batch7-rebind-preparation'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
bind=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def write(p,v):
 with p.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(v,indent=2,ensure_ascii=True)+'\n')
assert sha(parent/'rebind-closed-rows.py')=='c60052bc6bec8c741af3019cbedfc9bf4d3202e45e9be459d32d4d6353c3b0e2'
assert sha(parent/'reviewed-inputs.json')=='7c8c3a8e88578524c12e6d6b4a48a80c688343800a6caea4d7512ed54016023a'
inputs=copy.deepcopy(read(parent/'reviewed-inputs.json'));before=G.read_bytes();gate=json.loads(before)
oldpins={p['id']:p for p in inputs['closed_rows']};rows=[]
scope=['adjudicated_scope_note','strengthening_evidence','applicability_audit','nonvacuity_witness','source_ambiguity_note','consensus_audit']
for row in gate['rows']:
 if row['status'] not in ('PROVED','REUSED','DISCREPANCY'):continue
 taskpath=R/row['faithfulness_task'];task=read(taskpath);out=R/task['audit_output'];contract=G.parent/row['source_contract_artifact']
 assert sha(contract)==row['source_contract_sha256']
 rec={'id':row['id'],'status':row['status'],'task':bind(taskpath),'target':task['target'],'manifest':bind(out/'manifest.json'),'decision':bind(out/'decision.json'),'source_extraction':bind(out/'agent_outputs/source_contract.json'),'contract_hash':row['contract_hash'],'contract':read(contract)['payload']['contract'],'classification':row['classification'],'scope_fields':{k:row[k] for k in scope if k in row}}
 if row['id'] in oldpins:assert rec==oldpins[row['id']],'Earlier reviewed meaning changed'
 rows.append(rec)
assert len(rows)==32 and set(oldpins)<={r['id'] for r in rows}
adapter=S/'bind-variable-consensus-stronger-row.py';assert sha(adapter)=='e4b0e2d242e7fc7e91e955e3c828bc43992cc4748493c2f4b0d2bea2716f8b4c'
inputs['adapters'][adapter.name]=bind(adapter)
catalog={'key':'variable-opening',**{k:bind(S/n) for k,n in [('manifest','variable-opening-proof-inputs.json'),('check_file','variable-opening-nonvacuity.lean'),('resolution_log','variable-opening-nonvacuity-output.txt'),('resolution_exit','variable-opening-nonvacuity-exit.json')]}}
receipt=read(R/catalog['resolution_exit']['path']);assert receipt['exit_code']==0 and receipt['command']=='lake env lean '+catalog['check_file']['path']
assert receipt['output_sha256']==catalog['resolution_log']['sha256']
inputs['proof_catalog']=[catalog]+inputs['proof_catalog']
pins=S/'variable-opening-binding-pins.json';assert sha(pins)=='fef802d48786322675ce9cf6170c8d5fd6cf48605a96702e03e05aa281797e60'
inputs['extra_evidence'] += [bind(pins)]+[p['evidence'] for p in read(pins)['rows']]
inputs.update({'created_at_utc':datetime.now(timezone.utc).isoformat(),'gate_at_preparation':bind(G),'closed_count_at_preparation':32,'closed_rows':rows})
P.mkdir(exist_ok=False);write(P/'reviewed-inputs.json',inputs)
code=(parent/'rebind-closed-rows.py').read_text(encoding='utf-8')
def replace(a,b,count=1):
 global code
 assert code.count(a)==count,(a,code.count(a));code=code.replace(a,b)
replace("INPUT_SHA='7c8c3a8e88578524c12e6d6b4a48a80c688343800a6caea4d7512ed54016023a'","INPUT_SHA='"+sha(P/'reviewed-inputs.json')+"'")
replace("EQ10='LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION'","EQ10='LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION'\nVARIABLE='LEV-CH01-VARIABLE-COEFFICIENT-NONCONSERVATION'")
replace(" if row['id']==EQ10:return 'bind-equation10-interpreted-proved-row.py'"," if row['id']==EQ10:return 'bind-equation10-interpreted-proved-row.py'\n if row['id']==VARIABLE:return 'bind-variable-consensus-stronger-row.py'")
replace("row['id'] not in PRODUCTION_STRONGER","row['id'] not in PRODUCTION_STRONGER|{VARIABLE}",2)
needle="   selected=import_module('production_stronger_rebind_checks',adapters['bind-audited-stronger-production-rows.py']) if row['id'] in PRODUCTION_STRONGER else stronger"
replace(needle,needle+"\n   if row['id']==VARIABLE:selected=import_module('variable_consensus_rebind_checks',adapters['bind-variable-consensus-stronger-row.py'])")
ast.parse(code)
with (P/'rebind-closed-rows.py').open('x',encoding='utf-8',newline='') as f:f.write(code)
assert G.read_bytes()==before
write(P/'derivation.json',{'schema':1,'generator':bind(Path(__file__)),'parent_driver':bind(parent/'rebind-closed-rows.py'),'parent_inputs':bind(parent/'reviewed-inputs.json'),'driver':bind(P/'rebind-closed-rows.py'),'inputs':bind(P/'reviewed-inputs.json'),'changes':['Preserve all previous 31 semantic pins, scoped proof evidence and adapters','Add exactly the agreeing-judge variable-coefficient stronger case with its native applicability and source-only ambiguities','No change to sealed complete validators or existing decisions'],'production_or_gate_mutation':False})
print(json.dumps({'closed_count':32,'driver':bind(P/'rebind-closed-rows.py'),'inputs':bind(P/'reviewed-inputs.json'),'gate_unchanged':True}))

