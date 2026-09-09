"""Isolated provenance-guard fixtures; never validate or mutate an operational gate."""
from pathlib import Path
from datetime import datetime,timezone
from types import SimpleNamespace
import ast,copy,hashlib,importlib.util,json,os
H=Path(__file__).resolve().parent;S=H.parents[1];R=S.parents[3]
exec(compile((H.parent/'fv-local-domain-review/native-long-path-io.py').read_text(),'native-long-path-test-io','exec'),globals())
path=H/'bind-final-global-evidence-v2.py';spec=importlib.util.spec_from_file_location('global_v2_fixture',path)
b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
checks=[]
def test(name,fn,reject=False):
 try:fn()
 except (ValueError,AssertionError,KeyError,TypeError):
  assert reject, name
 else:assert not reject,name
 checks.append({'name':name,'expected':'reject' if reject else 'pass'})
parent=ast.parse((H/'bind-final-global-evidence.py').read_text());current=ast.parse(path.read_text())
def function(tree,name):return next(n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name==name)
for name in ('verify_receipt','python_command','native_command','read_axioms','execute','unchanged'):
 test('unchanged '+name,lambda name=name: b.require(ast.dump(function(parent,name))==ast.dump(function(current,name)),name))
pins=json.loads((H/'final-global-v2-validator-dependencies.json').read_bytes())
test('actual exact v6 dependency loader',lambda:b.load_final_validator_support(R,pins,{}))
wrong=copy.deepcopy(pins);wrong['audit_validator']['sha256']='0'*64
test('changed validator digest',lambda:b.load_final_validator_support(R,wrong,{}),True)
missing=copy.deepcopy(pins);missing['validator_dependencies'].pop()
test('missing validator dependency',lambda:b.load_final_validator_support(R,missing,{}),True)
duplicate=copy.deepcopy(pins);duplicate['validator_dependencies'][-1]=duplicate['validator_dependencies'][0]
test('duplicate validator dependency',lambda:b.load_final_validator_support(R,duplicate,{}),True)
changed=copy.deepcopy(pins);changed['validator_dependencies'][0]['sha256']='0'*64
test('changed support digest',lambda:b.load_final_validator_support(R,changed,{}),True)
fixture=H/'final-global-v2-synthetic-fixtures';fixture.mkdir()
serial=0
def make(mode='argv'):
 global serial
 serial+=1;directory=fixture/str(serial);directory.mkdir()
 def put(name,value):
  raw=value if isinstance(value,bytes) else (json.dumps(value,indent=2)+'\n').encode()
  p=directory/name
  with p.open('xb') as f:f.write(raw)
  return {'path':p.relative_to(R).as_posix(),'sha256':hashlib.sha256(raw).hexdigest()}
 config=put('config.json',{'fixture':True});target=put('target.lean',b'SYNTHETIC INPUT - NOT PRODUCTION')
 proof=put('proof.json',{'files':[target]});report=put('report.txt',b'SYNTHETIC REPORT - NOT AUDIT ACCEPTANCE')
 check=put('check.lean',b'SYNTHETIC CHECK - NOT EXECUTED');output=put('native.txt',b'SYNTHETIC OUTPUT')
 snapshot=put('target.snapshot',b'SYNTHETIC INPUT - NOT PRODUCTION')
 receipt=put('receipt.json',{'inputs':[{'path':str(R/target['path']),'snapshot':str(R/snapshot['path']),
  'sha256_before':target['sha256'],'sha256_after':target['sha256'],'snapshot_sha256':snapshot['sha256']}]})
 native={'receipt_kind':mode,'check':check,'output':output,'receipt':receipt,'proof_manifest':proof,'declarations':['Fixture.target']}
 context_keys=('source_context_extension','inherited_source_interpretation_packet','source_context_lineage')
 context={key:put(key+'.json',{'fixture':key}) for key in context_keys}
 authority=put('authority.json',{'fixture':'authority'})
 manifest=put('manifest.json',{'target':target,'lean_environment':[config,authority,*context.values()]})
 task=put('task.json',{'fixture':'task'});decision=put('decision.json',{'fixture':'not a semantic decision'})
 bindings={'fixture':'current'}
 request={'schema':1,'row':'LEV-CH01-FINITE-VOLUME-FLUX-UPDATE','status':'PROVED','task':task,
  'manifest':manifest,'decision':decision,'interpretation_packet':authority,'current_bindings':bindings,
  'native':native,**context}
 request_ref=put('request.json',request)
 row={'id':request['row'],'qualified_binding_request':request_ref,'native_evidence':native,
  'coordinator_selected_interpretation':authority,**context}
 record=copy.deepcopy(row);record.pop('id');record.update(row=request['row'],native_axioms={'Fixture.target':[]},manifest_sha256=manifest['sha256'],config=config)
 checked={'request':request,'config':R/config['path'],'manifest':json.loads((R/manifest['path']).read_bytes()),
  'axioms':{'Fixture.target':[]},'audit_hashes':{str(R/report['path']):report['sha256']},
  'source_context':{'refs':context,'provenance':list(context.values())}}
 def validate(candidate,complete=False):
  assert not complete
  assert all(candidate.get(key)==value for key,value in context.items())
  return copy.deepcopy(checked)
 q=SimpleNamespace(choices=lambda:({}, {request['row']:{'choice_id':'Q7'}}),validate_bound_row=validate,runtime_path=lambda value:Path(value).resolve())
 return SimpleNamespace(directory=directory,row=row,record=record,checked=checked,qualified=q,bindings=bindings,
  request=request_ref,context=context,target=target,snapshot=snapshot,report=report)
case=make();observed={}
test('matching qualified references and provenance',lambda:b.observe_qualified_record(R,case.record,case.row,case.qualified,case.bindings,observed))
for name in ('qualified_binding_request','native_evidence','source_context_extension','inherited_source_interpretation_packet','source_context_lineage'):
 bad=copy.deepcopy(case.record);bad.pop(name)
 test('missing record '+name,lambda bad=bad:b.observe_qualified_record(R,bad,case.row,case.qualified,case.bindings,{}),True)
 bad=copy.deepcopy(case.record);bad[name]={'path':'fixture-changed','sha256':'0'*64}
 test('stale record '+name,lambda bad=bad:b.observe_qualified_record(R,bad,case.row,case.qualified,case.bindings,{}),True)
test('stale current request bindings',lambda:b.observe_qualified_record(R,case.record,case.row,case.qualified,{'fixture':'different'},{}),True)
bad=copy.deepcopy(case.record);bad['native_axioms']={'Fixture.target':['forbidden']}
test('stale native axiom record',lambda:b.observe_qualified_record(R,bad,case.row,case.qualified,case.bindings,{}),True)
bad=copy.deepcopy(case.record);bad['manifest_sha256']='0'*64
test('stale manifest record',lambda:b.observe_qualified_record(R,bad,case.row,case.qualified,case.bindings,{}),True)
test('proof input observed',lambda:b.require((R/case.target['path']).resolve() in observed,'target not observed'))
test('audit report observed',lambda:b.require((R/case.report['path']).resolve() in observed,'report not observed'))
for name,reference in case.context.items():
 test(name+' observed',lambda reference=reference:b.require((R/reference['path']).resolve() in observed,'context not observed'))
snapshot_case=make('snapshots');snapshot_observed={}
test('snapshot provenance supported',lambda:b.observe_qualified_record(R,snapshot_case.record,snapshot_case.row,snapshot_case.qualified,snapshot_case.bindings,snapshot_observed))
test('snapshot bytes observed',lambda:b.require((R/snapshot_case.snapshot['path']).resolve() in snapshot_observed,'snapshot not observed'))
gate=case.directory/'synthetic-gate.json';gate.write_bytes(b'SYNTHETIC GATE BYTES')
state={'observed':observed,'gate_path':gate,'original':gate.read_bytes(),
 'checker':SimpleNamespace(current_context=lambda p,u:{'bindings':case.bindings}),
 'context':{'bindings':case.bindings}}
test('unchanged fixture boundary',lambda:b.unchanged(state))
changed_path=R/case.context['source_context_lineage']['path'];changed_path.write_bytes(b'SYNTHETIC CONCURRENT CHANGE')
test('changed provenance rejected at final boundary',lambda:b.unchanged(state),True)
changed_ref={'path':changed_path.relative_to(R).as_posix(),'sha256':b.sha(changed_path)}
test('conflicting observed hash rejected',lambda:b.bound_file(R,changed_ref,observed),True)
case2=make();(R/case2.request['path']).write_bytes(b'SYNTHETIC CHANGED REQUEST')
test('changed request file rejected',lambda:b.observe_qualified_record(R,case2.record,case2.row,case2.qualified,case2.bindings,{}),True)
validator=R/pins['audit_validator']['path'];command=['python3','-B',str(validator),'--validate','--require-all-closed']
test('exact final validator command',lambda:b.python_command(R,command,validator,['--validate','--require-all-closed']))
test('inventory command rejected',lambda:b.python_command(R,command[:-2],validator,['--validate','--require-all-closed']),True)
test('missing all-closed command rejected',lambda:b.python_command(R,command[:-1],validator,['--validate','--require-all-closed']),True)
receipt={'schema':1,'completed_at_utc':datetime.now(timezone.utc).isoformat(),'helper_sha256':b.sha(path),
 'script_sha256':b.sha(Path(__file__)),'checks':checks,'check_count':len(checks),
 'fixture_success_is_not_audit_success':True,'operational_gate_read_or_written':False,
 'audit_roles_or_complete_validator_run':False,'full_native_checks_rerun':False}
with (H/'final-global-v2-tests.json').open('x',encoding='utf-8',newline='\n') as f:json.dump(receipt,f,indent=2);f.write('\n')
print(json.dumps({'checks':len(checks),'helper_sha256':receipt['helper_sha256'],'operational_gate_written':False}))
