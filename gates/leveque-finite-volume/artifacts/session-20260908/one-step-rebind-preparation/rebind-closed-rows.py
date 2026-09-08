"""Preflight or sequentially rebind closed Chapter 1 rows without changing their meaning.

Default is a read-only gate preflight. Root must explicitly pass --execute after
review. Run through run_workflow_posix.py so unchanged adapters and released
validators execute in the required POSIX runtime. This driver never runs Lean,
semantic roles, Git mutations, organization scans, or completion gates.
"""
from pathlib import Path
from datetime import datetime,timezone
import argparse,copy,hashlib,importlib.util,json,os,re,subprocess,sys

P=Path(__file__).resolve().parent;S=P.parent;R=S.parents[3]
G=R/'gates/leveque-finite-volume/chapter-01.json'
INPUT_SHA='fb72ea20035b7a4ef90ecefe6d0db204c5f841524ed1bd765d1a6005c2b11629'
CLOSED={'PROVED','REUSED','DISCREPANCY'}
TRANSPORT={'LEV-CH01-EQ-1.2-ADVECTION','LEV-CH01-EQ-1.3-ADVECTED-PROFILE'}
DISCONTINUITY='LEV-CH01-DISCONTINUITY-INTEGRAL-LAW'
SECOND='LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY'
SMOOTH='LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH'
DIRECTIONS=('lean_implies_source','source_implies_lean')
ARTIFACT_PAIRS={'source-contract':('source_contract_artifact','source_contract_sha256'),'blind':('blind_artifact','blind_sha256'),'direct':('direct_artifact','direct_sha256'),'round-trip':('round_trip_artifact','round_trip_sha256')}
MUTABLE_ROW_FIELDS={v for pair in ARTIFACT_PAIRS.values() for v in pair}|{'reuse_source','reuse_audit'}
def require(ok,message):
 if not ok:raise ValueError(message)
def read(p):return json.loads(Path(p).read_bytes())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def canonical(v):return hashlib.sha256(json.dumps(v,ensure_ascii=False,sort_keys=True,separators=(',',':')).encode()).hexdigest()
def now():return datetime.now(timezone.utc).isoformat()
def relative(p):return Path(p).resolve().relative_to(R.resolve()).as_posix()
def under(relative_path):
 require(isinstance(relative_path,str) and bool(relative_path) and not Path(relative_path).is_absolute(),'Expected relative repository path')
 p=(R/relative_path).resolve();require(p.is_relative_to(R.resolve()),'Path escapes repository');return p
def bound(rec):
 p=under(rec['path']);require(sha(p)==rec['sha256'],'Hash mismatch: '+rec['path']);return p
def import_module(name,p):
 spec=importlib.util.spec_from_file_location(name,p);mod=importlib.util.module_from_spec(spec)
 require(spec.loader is not None,'Missing module loader');spec.loader.exec_module(mod);return mod
def immutable_json(p,value):
 with p.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(value,indent=2,ensure_ascii=True)+'\n')
def row_semantics(row):return {k:v for k,v in row.items() if k not in MUTABLE_ROW_FIELDS}
def source_contract(row):
 p=(G.parent/row['source_contract_artifact']).resolve()
 require(p.is_relative_to(R.resolve()),'Source contract escapes repository')
 require(sha(p)==row['source_contract_sha256'],'Source contract artifact hash mismatch')
 payload=read(p)['payload'];require(payload['contract_hash']==row['contract_hash'],'Contract payload hash differs from row')
 return payload['contract']
def assert_preserved(before,after,contracts):
 require([r['id'] for r in before['rows']]==[r['id'] for r in after['rows']],'Inventory row identity or order changed')
 for old,new in zip(before['rows'],after['rows']):
  if old['status'] in CLOSED:
   require(row_semantics(old)==row_semantics(new),'Closed row semantic fields changed: '+old['id'])
   require(source_contract(new)==contracts[old['id']],'Source contract or scope changed: '+old['id'])
  else:require(old==new,'Open/skipped row changed: '+old['id'])
 require(sum(r['status'] in CLOSED for r in before['rows'])==sum(r['status'] in CLOSED for r in after['rows']),'Closed count changed')

def select_adapter(row,decision,contract,source):
 """Pure dispatch; unknown qualifiers never fall through to ordinary adapters."""
 require(row['status'] in {'REUSED','PROVED'},'DISCREPANCY needs its separate witness protocol')
 if row['id'] in TRANSPORT:return 'bind-interpreted-proved-row.py'
 if row['id']==DISCONTINUITY:return 'bind-discontinuity-interpreted-proved-row.py'
 if row['id']==SECOND:return 'rebind-second-order-scoped-row.py'
 if row['classification']=='faithful-stronger':
  require(row['id']==SMOOTH and row['status']=='REUSED','Only the pinned stronger smooth bridge is supported')
  return 'bind-audited-stronger-reused-row.py'
 require(row['classification']=='faithful-equivalent','Unsupported classification')
 require(not any('interpretation-qualified' in f.get('category','').replace(' ','-') for f in decision.get('findings',[])),'Unknown interpreted row requires a scoped adapter')
 require(not any(k in row for k in ['adjudicated_scope_note','strengthening_evidence','applicability_audit','nonvacuity_witness']),'Unknown special scope/evidence cannot use a generic adapter')
 full={'statement':source['contract_plain_english'],'assumptions':source['statement']['hypotheses']+source['statement']['implicit_context'],'quantifiers':source['statement']['binders']}
 require(contract==full,'Generic adapter would change an existing scoped source contract')
 return 'rebind-reused-row.py' if row['status']=='REUSED' else 'rebind-audited-proved-row.py'

def proof_evidence(task,catalog,stronger):
 for item in catalog:
  m=read(bound(item['manifest']))
  candidates=[f for f in m['files'] if f['path']==task['target']['path'] and task['target']['declaration'] in f['declarations']]
  if not candidates:continue
  require(len(candidates)==1,'Duplicate proof-manifest target')
  require(sha(under(task['target']['path']))==candidates[0]['sha256'],'Native evidence target changed')
  check=bound(item['check_file']);log=bound(item['resolution_log']);exitpath=bound(item['resolution_exit'])
  require(sha(check)==m['check_file_sha256'],'Native check file mismatch')
  text=check.read_text(encoding='utf-8-sig');decl=task['target']['declaration']
  require(all(line in text.splitlines() for line in ['#check '+decl,'#print axioms '+decl]),'Exact declaration absent from native check input')
  receipt=read(exitpath)
  require(type(receipt.get('exit_code')) is int and receipt['exit_code']==0,'Native check did not actually exit 0')
  require(receipt['command']=='lake env lean '+relative(check),'Native receipt checked a different input')
  if 'output_sha256' in receipt:require(receipt['output_sha256']==sha(log),'Native output hash mismatch')
  if 'verification' in item:
   v=read(bound(item['verification']))
   if 'input_manifest_sha256' in v:require(v['input_manifest_sha256']==sha(bound(item['manifest'])),'Native verification manifest mismatch')
   if 'native_output_sha256' in v:require(v['native_output_sha256']==sha(log),'Native verification output mismatch')
   if 'native_exit_receipt_sha256' in v:require(v['native_exit_receipt_sha256']==sha(exitpath),'Native verification exit mismatch')
  native=log.read_text(encoding='utf-8-sig')
  require(re.search(r'\berror:|sorryAx',native) is None,'Error or sorry axiom in native output')
  stronger.declaration_axioms(native,decl)
  return item
 raise ValueError('No exact frozen native proof evidence for '+task['target']['declaration'])

def make_plan(gate,inputs,checker_path,stronger,checker):
 rows=[r for r in gate['rows'] if r['status'] in CLOSED]
 require(bool(rows),'No closed rows')
 require(len({r['id'] for r in gate['rows']})==len(gate['rows']),'Duplicate inventory ID')
 pins={p['id']:p for p in inputs['closed_rows']}
 require(set(pins)<=set(r['id'] for r in rows),'A previously reviewed closed row is absent or reopened')
 adapters={n:bound(rec) for n,rec in inputs['adapters'].items()}
 for rec in inputs['extra_evidence']:bound(rec)
 records=[]
 for row in rows:
  taskpath=under(row['faithfulness_task']);task=read(taskpath);out=under(task['audit_output'])
  manifest=read(out/'manifest.json');decision=read(out/'decision.json');source=read(out/'agent_outputs/source_contract.json')
  require(bound(manifest['task_metadata'])==taskpath and manifest['task_id']==task['task_id'],'Sealed task identity mismatch')
  require(bound(manifest['target'])==under(task['target']['path']),'Sealed target path mismatch')
  require(bound(manifest['source'])==under(task['source']['path']),'Sealed source mismatch')
  for rec in manifest['lean_environment']:bound(rec)
  require(row['lean_declarations']==[task['target']['declaration']]==[manifest['target']['declaration']],'Declaration changed')
  require(under(row['faithfulness_decision'])==out/'decision.json','Row decision path changed')
  require(decision.get('task_id')==task['task_id'] and decision.get('accepted') is True,'Closed row lacks an accepted exact decision')
  require(decision['classification']==row['classification'],'Classification differs from sealed decision')
  pair=tuple(decision['implications'][k]['verdict'] for k in DIRECTIONS)
  require(pair==tuple(row[k] for k in DIRECTIONS),'Implications differ from sealed decision')
  require(pair==({'faithful-equivalent':('yes','yes'),'faithful-stronger':('yes','no')}.get(row['classification'])),'Unsupported implication/classification pair')
  contract=source_contract(row)
  require(checker.canonical_sha256(contract)==row['contract_hash'],'Source contract canonical hash mismatch')
  if row['id'] in pins:
   pin=pins[row['id']]
   for name,path in [('task',taskpath),('manifest',out/'manifest.json'),('decision',out/'decision.json'),('source_extraction',out/'agent_outputs/source_contract.json')]:
    require(bound(pin[name])==path,'Reviewed '+name+' identity changed')
   require(row['status']==pin['status'] and task['target']==pin['target'] and row['classification']==pin['classification'],'Reviewed status, target or classification changed')
   require(contract==pin['contract'] and row['contract_hash']==pin['contract_hash'],'Reviewed source scope changed')
   require({k:row.get(k) for k in pin['scope_fields']}==pin['scope_fields'],'Reviewed qualifications changed')
  adapter=select_adapter(row,decision,contract,source)
  config=stronger.exact_manifest_config(R,manifest)
  proof=proof_evidence(task,inputs['proof_catalog'],stronger)
  cmd=[sys.executable,'-B',str(adapters[adapter]),'--gate-checker',str(checker_path),'--gate',str(G),'--task',str(taskpath),'--row',row['id'],'--resolution-log',str(bound(proof['resolution_log']))]
  if row['status']=='PROVED':
   cmd+=['--resolution-exit',str(bound(proof['resolution_exit'])),'--resolution-manifest',str(bound(proof['manifest'])),'--check-file',str(bound(proof['check_file']))]
  if row['id'] in TRANSPORT or row['id']==DISCONTINUITY:
   receipt=S/('user-transport-interpretation-20260908.json' if row['id'] in TRANSPORT else 'user-discontinuity-interpretation-20260908.json')
   expected='26f16aeef42a0c7de4865c4c00e9ba223a9ae53604abf55da427171f6bf8e16b' if row['id'] in TRANSPORT else 'b27e7d260e93edcd5408daa8c5d291ba8bfefd9e66a079480ae6b940aa869030'
   require(sha(receipt)==expected,'User receipt changed')
   require(relative(receipt) in read(config)['lean']['environment_files'],'User receipt is not environment-bound')
   cmd+=['--interpretation',str(receipt),'--interpretation-sha256',expected,'--rebind']
  if row['id']==SECOND:cmd+=['--rebind']
  if row['classification']=='faithful-stronger':
   evidence=bound(row['strengthening_evidence'])
   stronger.validate_strengthening_evidence(R,taskpath,task,manifest,decision,evidence,row=row)
   cmd+=['--strengthening-evidence',str(evidence),'--rebind']
  records.append({'row':row['id'],'status':row['status'],'task':relative(taskpath),'task_sha256':sha(taskpath),'declaration':task['target']['declaration'],'classification':row['classification'],'contract_hash':row['contract_hash'],'source_contract':contract,'decision_sha256':sha(out/'decision.json'),'manifest_sha256':sha(out/'manifest.json'),'config':{'path':relative(config),'sha256':sha(config)},'adapter':inputs['adapters'][adapter],'native_evidence':proof,'command':cmd})
 return records

def main():
 parser=argparse.ArgumentParser(description=__doc__)
 parser.add_argument('--label',required=True);parser.add_argument('--gate-checker',type=Path,required=True)
 parser.add_argument('--execute',action='store_true',help='Run the reviewed mutation adapters sequentially; otherwise only preflight')
 args=parser.parse_args();require(re.fullmatch(r'[A-Za-z0-9][A-Za-z0-9-]{0,79}',args.label) is not None,'Invalid unique label')
 require(os.name!='nt','Use the required Windows Python -> run_workflow_posix.py entry')
 require(sha(P/'reviewed-inputs.json')==INPUT_SHA,'Reviewed input package changed')
 inputs=read(P/'reviewed-inputs.json');checker_path=args.gate_checker.resolve()
 require(sha(checker_path)==inputs['gate_checker_sha256'],'Selected released gate checker changed')
 checker=import_module('one_step_gate_checker',checker_path)
 require(checker.ROW_ARTIFACT_REFS==ARTIFACT_PAIRS,'Released row artifact fields changed')
 stronger=import_module('one_step_stronger_checks',bound(inputs['adapters']['bind-audited-stronger-reused-row.py']))
 directory=P/args.label;directory.mkdir(exist_ok=False)
 summary={'schema':1,'started_at_utc':now(),'mode':'execute' if args.execute else 'preflight-only','mutation_driver_executed':args.execute,'input_package_sha256':INPUT_SHA,'driver_sha256':sha(Path(__file__)),'gate_checker_sha256':sha(checker_path),'steps':[]}
 try:
  original=G.read_bytes();before=json.loads(original);summary['gate_before_sha256']=hashlib.sha256(original).hexdigest()
  plan=make_plan(before,inputs,checker_path,stronger,checker)
  immutable_json(directory/'plan.json',{'schema':1,'mode':summary['mode'],'gate_sha256':summary['gate_before_sha256'],'records':plan})
  summary['closed_count']=len(plan);summary['plan_sha256']=sha(directory/'plan.json')
  contracts={x['row']:x['source_contract'] for x in plan}
  require(G.read_bytes()==original,'Gate changed during preflight; use a fresh label after the concurrent write')
  if args.execute:
   (directory/'gate-before.json').write_bytes(original)
   context=checker.current_context(G,1);expected_gate_sha=sha(G)
   for index,record in enumerate(plan,1):
    require(sha(G)==expected_gate_sha,'Concurrent gate write detected')
    require(checker.current_context(G,1)['bindings']==context['bindings'],'Source/environment changed during batch')
    stem=f'{index:02d}-{record["row"]}';stdout=directory/(stem+'-stdout.txt');stderr=directory/(stem+'-stderr.txt')
    step={'row':record['row'],'command':record['command'],'config':record['config'],'adapter':record['adapter'],'started_at_utc':now(),'gate_before_sha256':expected_gate_sha}
    config=bound(record['config']);bound(record['adapter'])
    with stdout.open('xb') as of,stderr.open('xb') as ef:
     result=subprocess.run(record['command'],cwd=R,env=dict(os.environ,FAITHFULNESS_AUDIT_CONFIG=str(config)),stdout=of,stderr=ef)
    step.update({'completed_at_utc':now(),'exit_code':result.returncode,'stdout_sha256':sha(stdout),'stderr_sha256':sha(stderr),'gate_after_sha256':sha(G)})
    immutable_json(directory/(stem+'-exit.json'),step);summary['steps'].append(step)
    require(result.returncode==0,'Adapter failed: '+record['row']+'; preserved actual output and receipt, no rollback or subsequent adapter')
    assert_preserved(before,read(G),contracts)
    expected_gate_sha=sha(G)
   current=read(G)
   for row in current['rows']:
    if row['status'] in CLOSED:
     defects=checker.row_artifact_defects(row,1,context,G.parent,set(),location=row['id'])
     require(not defects,'Rebound row artifacts fail: '+str(defects))
   require(checker.current_context(G,1)['bindings']==context['bindings'],'Context changed before completion')
   summary['all_closed_artifacts_current']=True
  else:require(G.read_bytes()==original,'Preflight changed or raced with gate bytes')
  assert_preserved(before,read(G),contracts)
  summary.update({'exit_code':0,'completed_at_utc':now(),'gate_after_sha256':sha(G),'closed_status_task_declaration_classification_contract_and_scope_preserved':True,'global_verification':'OPEN after execution; authoritative refresh/checkpoint remains root work' if args.execute else 'not modified'})
 except Exception as error:
  summary.update({'exit_code':1,'completed_at_utc':now(),'error':str(error),'gate_after_sha256':sha(G)})
  immutable_json(directory/'summary.json',summary)
  print(json.dumps(summary,ensure_ascii=True),flush=True);return 1
 immutable_json(directory/'summary.json',summary)
 print(json.dumps({'mode':summary['mode'],'exit_code':0,'closed_count':len(plan),'summary_path':str(directory/'summary.json'),'summary_sha256':sha(directory/'summary.json'),'gate_before_sha256':summary['gate_before_sha256'],'gate_after_sha256':summary['gate_after_sha256']},ensure_ascii=True),flush=True)
 return 0

if __name__=='__main__':raise SystemExit(main())
