"""Project one pinned agreeing stronger decision with native nonvacuity evidence.

No semantic role or released validator is changed. The sealed complete audit
must pass; applicability and genuine extra conclusions remain explicit.
"""
from pathlib import Path
import argparse,copy,hashlib,importlib.util,json,os,re,subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3]
PINS_SHA='fef802d48786322675ce9cf6170c8d5fd6cf48605a96702e03e05aa281797e60'
CHECKER_SHA='3e9cc58beb58f9f63f2736c4d50125ca6c42116104b64982f3dfc2d3f8afb104'
HELPER_SHA='286f9932e8e0e2242bfaa663498e0ac97abea60e0af6fa8cd6b1cdbacfb63694'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def require(ok,msg):
 if not ok:raise ValueError(msg)
def loadmod(name,path):
 spec=importlib.util.spec_from_file_location(name,path);mod=importlib.util.module_from_spec(spec)
 require(spec.loader is not None,'Missing module loader');spec.loader.exec_module(mod);return mod
require(sha(S/'bind-audited-stronger-reused-row.py')==HELPER_SHA,'Generic read-only utility changed')
base=loadmod('pinned_stronger_utilities',S/'bind-audited-stronger-reused-row.py')
read=base.read;bound_file=base.bound_file;repository_path=base.repository_path
exact_manifest_config=base.exact_manifest_config;declaration_axioms=base.declaration_axioms
def pins():
 p=S/'variable-opening-binding-pins.json';require(sha(p)==PINS_SHA,'Production pins changed');return read(p)
def validate_strengthening_evidence(root,task_path,task,manifest,decision,evidence_path,row=None):
 root=root.resolve();require(root==R.resolve(),'Wrong repository')
 data=pins();matches=[p for p in data['rows'] if p['task_id']==task['task_id']]
 require(len(matches)==1,'Only the pinned variable-coefficient opening-claim task is supported');pin=matches[0]
 require(task['target']==pin['target'],'Pinned target changed')
 out=repository_path(root,task['audit_output'])
 require(task_path.resolve()==S/'audits'/pin['task_id']/'audit-task.json','Task path changed')
 require(manifest==read(out/'manifest.json') and decision==read(out/'decision.json'),'Audit objects changed')
 require(sha(out/'manifest.json')==pin['manifest_sha256'] and sha(out/'decision.json')==pin['decision_sha256'],'Pinned audit hashes changed')
 require(bound_file(root,manifest['task_metadata'])==task_path.resolve(),'Manifest task mismatch')
 require(bound_file(root,manifest['target'])==repository_path(root,task['target']['path']),'Manifest target mismatch')
 require(decision['accepted'] is True and decision['adjudicated'] is False and decision['classification']=='faithful-stronger','Pinned consensus decision changed')
 require(decision['adjudication_reasons']==[] and decision['judge_classifications']=={'direct':'faithful-stronger','roundtrip':'faithful-stronger'},'Independent judges do not agree without an adjudication trigger')
 require(tuple(decision['implications'][d]['verdict'] for d in ('lean_implies_source','source_implies_lean'))==('yes','no'),'Stronger directions changed')
 require(bound_file(root,pin['evidence'])==evidence_path.resolve(),'Exact stronger evidence required')
 evidence=read(evidence_path)
 require(evidence['row']==pin['row'] and evidence['task_id']==task['task_id'],'Evidence identity mismatch')
 for key,path in [('task',task_path),('manifest',out/'manifest.json'),('decision',out/'decision.json')]:
  require(bound_file(root,evidence[key])==path.resolve(),'Evidence '+key+' mismatch')
 require(evidence['applicability_audit']==decision['implications']['lean_implies_source']['reasoning'],'Applicability differs from independent decision')
 require(evidence['genuine_strengthening']==decision['implications']['source_implies_lean']['reasoning'],'Extra conclusions differ from independent decision')
 require(evidence['remaining_source_uncertainties']==decision['remaining_uncertainties'],'Final uncertainties changed')
 source_path=bound_file(root,evidence['source_contract'])
 require(source_path==out/'agent_outputs/source_contract.json','Source-only record changed')
 require(evidence['source_only_ambiguities']==read(source_path)['ambiguities'],'Source-only ambiguities were lost')
 paths={k:bound_file(root,data[k]) for k in ('proof_manifest','native_check','native_output','native_exit')}
 for key in ('native_check','native_output','native_exit'):
  require(bound_file(root,evidence[key])==paths[key],'Witness binding mismatch')
 native=read(paths['native_exit']);proof=read(paths['proof_manifest'])
 require(type(native['exit_code']) is int and native['exit_code']==0,'Native check did not actually pass')
 require(native==evidence['native_receipt'],'Native receipt changed')
 require(native['command']=='lake env lean '+paths['native_check'].relative_to(root).as_posix(),'Wrong native command')
 require(native['argv']==['lake','env','lean',paths['native_check'].relative_to(root).as_posix()],'Wrong native argument vector')
 require(native['output_sha256']==sha(paths['native_output']),'Native output hash mismatch')
 require(re.fullmatch(r'[0-9a-f]{40}',native['input_commit']) is not None and native['native_lake'].lower().endswith('lake.exe'),'Native provenance missing')
 require(proof['check_file_sha256']==sha(paths['native_check']),'Proof check input mismatch')
 targets=[f for f in proof['files'] if f['path']==task['target']['path']]
 require(len(targets)==1 and bound_file(root,targets[0])==root/task['target']['path'],'Native proof target mismatch')
 require(task['target']['declaration'] in targets[0]['declarations'],'Native target declaration omitted')
 text=paths['native_output'].read_text(encoding='utf-8-sig');checks=paths['native_check'].read_text(encoding='utf-8-sig').splitlines()
 require(re.search(r'\b(?:error|warning):|sorryAx',text) is None,'Native witness has diagnostics or sorry axiom')
 for decl in (task['target']['declaration'],evidence['formal_nonvacuity_declaration']):
  require('#check '+decl in checks and '#print axioms '+decl in checks,'Witness/check declaration missing')
  declaration_axioms(text,decl)
 for search in evidence['reuse_searches']:
  require(type(search['exit_code']) is int and search['exit_code'] in (0,1),'Invalid search exit')
  bound_file(root,search['stdout']);require(not bound_file(root,search['stderr']).read_bytes(),'Search error')
 provenance=f"Decision SHA-256 {pin['decision_sha256']}; evidence SHA-256 {pin['evidence']['sha256']}."
 fields={'strengthening_evidence':pin['evidence'],
  'applicability_audit':evidence['applicability_audit']+' '+provenance,
  'nonvacuity_witness':evidence['formal_nonvacuity_declaration']+': '+evidence['formal_nonvacuity_scope']+' Native Lean exited 0; source, output, exit receipt and allowed axioms are hash-bound in the evidence. '+evidence['genuine_strengthening']+' '+provenance,
  'source_ambiguity_note':json.dumps({'source_only_ambiguities':evidence['source_only_ambiguities'],'remaining_decision_uncertainties':evidence['remaining_source_uncertainties']},ensure_ascii=True),
  'consensus_audit':'Both independent judges agree on faithful-stronger yes/no; the unchanged sealed decision records no adjudication trigger. No adjudicator was invoked or represented. '+provenance}
 if row is not None:
  require(row['id']==pin['row'],'Wrong row')
  for key,val in fields.items():require(row.get(key)==val,'Row stronger evidence changed: '+key)
 return fields
def immutable(p,v):
 payload=(json.dumps(v,indent=2,ensure_ascii=False)+'\n').encode()
 if p.exists():require(p.read_bytes()==payload,'Immutable artifact collision: '+str(p))
 else:p.parent.mkdir(parents=True,exist_ok=True);p.write_bytes(payload)
def main():
 p=argparse.ArgumentParser(description=__doc__)
 for key in ('gate-checker','gate','task','strengthening-evidence'):p.add_argument('--'+key,type=Path,required=True)
 p.add_argument('--row',required=True);p.add_argument('--rebind',action='store_true')
 a=p.parse_args();require(os.name!='nt','Run via the required POSIX launcher')
 require(sha(a.gate_checker)==CHECKER_SHA,'Released checker changed')
 checker=loadmod('stronger_production_gate',a.gate_checker);G=a.gate.resolve()
 require(G==R/'gates/leveque-finite-volume/chapter-01.json','Wrong gate')
 original=G.read_bytes();gate=json.loads(original);context=checker.current_context(G,1)
 taskpath=a.task.resolve();task=read(taskpath);out=R/task['audit_output'];manifest=read(out/'manifest.json');decision=read(out/'decision.json')
 fields=validate_strengthening_evidence(R,taskpath,task,manifest,decision,a.strengthening_evidence)
 pin=next(x for x in pins()['rows'] if x['task_id']==task['task_id']);require(a.row==pin['row'],'Wrong row/task pair')
 config=exact_manifest_config(R,manifest)
 require(os.environ.get('FAITHFULNESS_AUDIT_CONFIG') and Path(os.environ['FAITHFULNESS_AUDIT_CONFIG']).resolve()==config,'Select exact sealed configuration')
 subprocess.run([sys.executable,'-B',str(R/'.faithfulness-audit/scripts/validate_audit.py'),str(taskpath),'--phase','complete'],cwd=R,check=True)
 require(sha(R/task['source']['path'])==checker.PINNED_SOURCE_SHA256,'Pinned source mismatch')
 subprocess.run(['git','-c','core.longpaths=true','merge-base','--is-ancestor',context['bindings']['lean_git_head'],'HEAD'],cwd=R,check=True)
 target=task['target'];require(subprocess.check_output(['git','-c','core.longpaths=true','show',':'+target['path']],cwd=R)==(R/target['path']).read_bytes(),'Target staged bytes differ')
 rows=[r for r in gate['rows'] if r['id']==a.row];require(len(rows)==1,'Missing or duplicate row');row=rows[0];old=copy.deepcopy(row)
 if a.rebind:
  require(row['status']=='PROVED' and row['faithfulness_task']==taskpath.relative_to(R).as_posix() and row['lean_declarations']==[target['declaration']],'Rebind requires same closed task/target')
  validate_strengthening_evidence(R,taskpath,task,manifest,decision,a.strengthening_evidence,row)
 else:require(row['status'] in ('READY','IN_PROGRESS'),'Row is not open')
 source=read(out/'agent_outputs/source_contract.json')
 contract={'statement':source['contract_plain_english'],'assumptions':source['statement']['hypotheses']+source['statement']['implicit_context'],'quantifiers':source['statement']['binders']}
 for key in ('next_foundation','next_action','current_target','open_reason','adjudication_status','adjudication_audit'):row.pop(key,None)
 row.update({'status':'PROVED','lean_declarations':[target['declaration']],
  'contract_hash':checker.canonical_sha256(contract),'blind_pass':'PASS','direct_pass':'PASS','round_trip_pass':'PASS',
  'lean_implies_source':'yes','source_implies_lean':'no','classification':'faithful-stronger',
  'faithfulness_task':taskpath.relative_to(R).as_posix(),'faithfulness_decision':(out/'decision.json').relative_to(R).as_posix(),
  'adjudication_required':False,**fields})
 require(not checker.faithfulness_defects(row,'PROVED',a.row),'Released faithfulness requirements failed')
 binding=checker.row_artifact_bindings(row,1,context);directory=taskpath.parent/'gate-bindings'/checker.canonical_sha256(binding)
 common={k:row[k] for k in ('contract_hash','classification','lean_implies_source','source_implies_lean')}
 roles={'blind':'blind_translation','direct':'direct_judge','round-trip':'roundtrip_judge'}
 for check,(pathkey,hashkey) in checker.ROW_ARTIFACT_REFS.items():
  if check=='source-contract':payload={k:row[k] for k in ('contract_hash','source_label','printed_page','pdf_page')};payload['contract']=contract
  else:payload={**common,'decision':'PASS','analysis':f"Original {roles[check]} SHA-256 {sha(out/'agent_outputs'/(roles[check]+'.json'))}; final independent decision SHA-256 {pin['decision_sha256']}; exact native proof and nonvacuity evidence SHA-256 {pin['evidence']['sha256']}. PASS projects the agreeing independent faithful-stronger result; original role outcomes and absence of adjudication are retained. "+decision['rationale']}
  artifact={'schema_version':1,'check':check,'bindings':binding,'procedure':'Project the independently extracted full source contract or the complete validated role and agreeing independent decision. Preserve genuine strengthening, source applicability, nonvacuity and source ambiguity; generate no semantic judgment.','exit_code':0,'payload':payload}
  path=directory/('gate-'+check+'.json');immutable(path,artifact);row[pathkey]=path.relative_to(G.parent).as_posix();row[hashkey]=sha(path)
 require(not checker.row_artifact_defects(row,1,context,G.parent,set(),location=a.row),'Released row artifact check failed')
 if a.rebind:
  artifactkeys={k for pair in checker.ROW_ARTIFACT_REFS.values() for k in pair}
  require({k:v for k,v in old.items() if k not in artifactkeys}=={k:v for k,v in row.items() if k not in artifactkeys},'Rebind changed row meaning')
 closed=[r for r in gate['rows'] if r['status'] in checker.CLOSED_LEAN_STATUSES];semantic=gate['verification_loops']['semantic_equivalence'];semantic['rows_requiring_check']=len(closed)
 for field,pf in [('blind_recorded','blind_pass'),('direct_recorded','direct_pass'),('round_trip_recorded','round_trip_pass')]:semantic[field]=sum(r.get(pf)=='PASS' for r in closed)
 semantic['unresolved_adjudications']=sum(r.get('adjudication_required',False) and r.get('adjudication_status')!='resolved' for r in closed)
 for key in gate['verification_evidence']:gate['verification_evidence'][key]={'command':'','artifact':'','artifact_sha256':'','exit_code':None,'count':0}
 gate['bindings']=copy.deepcopy(context['bindings'])
 require(G.read_bytes()==original and checker.current_context(G,1)['bindings']==context['bindings'],'Concurrent gate/context change')
 prior=directory/('prior-gate-'+hashlib.sha256(original).hexdigest()+'.json')
 if prior.exists():require(prior.read_bytes()==original,'Prior snapshot collision')
 else:prior.write_bytes(original)
 G.write_bytes((json.dumps(gate,indent=2,ensure_ascii=False)+'\n').encode())
 print(json.dumps({'row':a.row,'status':'PROVED','classification':'faithful-stronger','decision_sha256':pin['decision_sha256'],'gate_sha256':sha(G),'global_verification':'OPEN'}))
 return 0
if __name__=='__main__':raise SystemExit(main())
