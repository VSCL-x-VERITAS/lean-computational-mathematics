"""Freeze read-only adapter/evidence inputs and derive a scoped rebind entry."""
from pathlib import Path
from datetime import datetime,timezone
import ast,hashlib,json
def xp(p):
 p=str(p);prefix=chr(92)*2+'?'+chr(92)
 return Path(p if p.startswith(prefix) else prefix+str(Path(p).resolve()))
P=xp(Path(__file__).resolve().parent);S=P.parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(xp(p).read_bytes()).hexdigest()
read=lambda p:json.loads(xp(p).read_bytes())
def bind(p):
 p=xp(p);return {'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def write(p,v):
 assert not p.exists(),p
 p.write_text(json.dumps(v,indent=2,ensure_ascii=True)+'\n',encoding='utf-8',newline='')
G=R/'gates/leveque-finite-volume/chapter-01.json';g=read(G)
names=['rebind-reused-row.py','rebind-audited-proved-row.py','bind-interpreted-proved-row.py','bind-discontinuity-interpreted-proved-row.py','bind-audited-stronger-reused-row.py','bind-second-order-classification-proved-row-v2.py']
parents={n:bind(S/n) for n in names}
second=next(r for r in g['rows'] if r['id']=='LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY')
task=read(R/second['faithfulness_task']);out=R/task['audit_output']
assert sha(out/'decision.json')=='ec1f5ba91a50a7a6f18e3ff7065a9354ca62d628b572560ccadedb307423b439'
assert sha(out/'agent_outputs/source_contract.json')=='d226eed74a63211672f1046b713ab936ea0ff08bef79d271e1a4717c4b80ecb5'
code=(S/names[-1]).read_text(encoding='utf-8')
def replace_once(old,new):
 global code
 assert code.count(old)==1,(old,code.count(old))
 code=code.replace(old,new)
replace_once("    args = parser.parse_args()", "    parser.add_argument('--rebind', action='store_true', required=True,\n                        help='Retain the exact already-PROVED classification-only row')\n    args = parser.parse_args()")
replace_once("    output = root / task['audit_output']", "    output = root / task['audit_output']\n    if task != "+repr(task)+":\n        raise ValueError('The exact reviewed classification task changed.')\n    if hashlib.sha256(task_path.read_bytes()).hexdigest() != "+repr(sha(R/second['faithfulness_task']))+":\n        raise ValueError('Classification task bytes changed.')\n    if hashlib.sha256((output / 'manifest.json').read_bytes()).hexdigest() != "+repr(sha(out/'manifest.json'))+":\n        raise ValueError('Classification manifest changed.')")
replace_once("    if row['status'] not in ('READY', 'IN_PROGRESS'):\n        raise ValueError('row is not an open audited-proof candidate')", "    if (not args.rebind or row['status'] != 'PROVED'\n        or row.get('faithfulness_task') != task_path.relative_to(root).as_posix()\n        or row.get('faithfulness_decision') != (output / 'decision.json').relative_to(root).as_posix()\n        or row.get('lean_declarations') != [declaration]\n        or row.get('classification') != 'faithful-equivalent'\n        or row.get('lean_implies_source') != 'yes' or row.get('source_implies_lean') != 'yes'):\n        raise ValueError('Rebind requires the unchanged already-PROVED scoped classification row')\n    original_scope_note = copy.deepcopy(row.get('adjudicated_scope_note'))")
replace_once("    derivation = next(r for r in gate['rows']", "    if row.get('contract_hash') != checker.canonical_sha256(contract):\n        raise ValueError('Rebind would alter the classification-only source contract')\n    prior_contract_path = gate_path.parent / row['source_contract_artifact']\n    if hashlib.sha256(prior_contract_path.read_bytes()).hexdigest() != row['source_contract_sha256']:\n        raise ValueError('Prior scoped contract artifact hash mismatch')\n    if read(prior_contract_path)['payload']['contract'] != contract:\n        raise ValueError('Prior contract is not the exact reviewed classification scope')\n    derivation = next(r for r in gate['rows']")
replace_once("    for field in ('next_foundation', 'next_action', 'current_target', 'open_reason'):", "    if row['adjudicated_scope_note'] != original_scope_note:\n        raise ValueError('Rebind would alter scope findings, material context, or preserved limitations')\n    for field in ('next_foundation', 'next_action', 'current_target', 'open_reason'):")
replace_once("    prior = binding_dir / ('prior-gate-'", "    if gate_path.read_bytes() != original_bytes:\n        raise ValueError('Gate changed during validation; refusing stale write')\n    if checker.current_context(gate_path, 1)['bindings'] != context['bindings']:\n        raise ValueError('Source/environment bindings changed during validation')\n    prior = binding_dir / ('prior-gate-'")
code=code.replace('Bind an independently accepted audit to an exact newly proved producer.', 'Rebind only the exact already-PROVED second-order classification scope.')
ast.parse(code)
derived=P/'rebind-second-order-scoped-row.py';assert not derived.exists();derived.write_text(code,encoding='utf-8',newline='')
parents['rebind-second-order-scoped-row.py']=bind(derived)
catalog=[]
for key,manifest,check,log,exitname,verification in [
 ('current','chapter01-current-producer-inputs.json','chapter01-current-producer-checks.lean','chapter01-current-producer-checks-output.txt','chapter01-current-producer-checks-exit.json','chapter01-current-producer-verification.json'),
 ('interpreted','interpreted-transport-production-inputs.json','interpreted-transport-production-checks.lean','interpreted-transport-production-checks-output.txt','interpreted-transport-production-checks-exit.json','interpreted-transport-production-verification.json'),
 ('right','right-domain-production-inputs.json','right-domain-production-checks.lean','right-domain-production-checks-output.txt','right-domain-production-checks-exit.json',None),
 ('general','general-propagation-discontinuity-production-inputs.json','general-propagation-discontinuity-checks.lean','general-propagation-discontinuity-checks-output.txt','general-propagation-discontinuity-checks-exit.json','general-propagation-discontinuity-verification.json')]:
  m=read(S/manifest);e=read(S/exitname)
  assert type(e['exit_code']) is int and e['exit_code']==0
  assert e['command']=='lake env lean '+(S/check).relative_to(R).as_posix()
  assert m['check_file_sha256']==sha(S/check)
  if 'output_sha256' in e:assert e['output_sha256']==sha(S/log)
  item={'key':key,'manifest':bind(S/manifest),'check_file':bind(S/check),'resolution_log':bind(S/log),'resolution_exit':bind(S/exitname)}
  if verification:item['verification']=bind(S/verification)
  catalog.append(item)
closed=[r for r in g['rows'] if r['status'] in ('REUSED','PROVED','DISCREPANCY')]
rows=[]
for row in closed:
 t=read(R/row['faithfulness_task']);o=R/t['audit_output'];a=read(G.parent/row['source_contract_artifact'])
 assert sha(G.parent/row['source_contract_artifact'])==row['source_contract_sha256']
 rows.append({'id':row['id'],'status':row['status'],'task':bind(R/row['faithfulness_task']),'target':t['target'],'manifest':bind(o/'manifest.json'),'decision':bind(o/'decision.json'),'source_extraction':bind(o/'agent_outputs/source_contract.json'),'contract_hash':row['contract_hash'],'contract':a['payload']['contract'],'classification':row['classification'],'scope_fields':{k:row[k] for k in ['adjudicated_scope_note','strengthening_evidence','applicability_audit','nonvacuity_witness'] if k in row}})
extras=[bind(S/n) for n in ['user-transport-interpretation-20260908.json','user-discontinuity-interpretation-20260908.json','smooth-bridge-strengthening-evidence.json']]
checker=R.parent/'formalization-collaboration-v5.0.1/books/candidates/leveque-finite-volume/module/scripts/gate.py'
assert sha(checker)=='3e9cc58beb58f9f63f2736c4d50125ca6c42116104b64982f3dfc2d3f8afb104'
write(P/'reviewed-inputs.json',{'schema':1,'created_at_utc':datetime.now(timezone.utc).isoformat(),'gate_at_preparation':bind(G),'closed_count_at_preparation':len(rows),'closed_rows':rows,'adapters':parents,'proof_catalog':catalog,'extra_evidence':extras,'gate_checker_sha256':sha(checker),'rule':'Discover all current closed rows at invocation. Existing reviewed rows must remain pinned. Additional ordinary equivalent rows are eligible only with matching full source contracts and exact catalog proof evidence; scope changes fail closed.'})
write(P/'second-order-derivation.json',{'parent':parents[names[-1]],'derived':bind(derived),'generator':bind(Path(__file__)),'mutation_entry_invoked':False,'changes':['Require explicit --rebind and an already PROVED unchanged task, decision, declaration, classification, and both implications','Pin exact task bytes/object and manifest in addition to retained source-extraction and decision hashes','Compare prior source artifact and reconstructed scoped contract before binding','Preserve exact adjudicated scope note and independently closed derivation row','Reject stale gate/context writes'],'preserved':'Unchanged sealed complete validator, actual proof manifest/check/exit/declaration/axiom requirements, source locator/classification-only slice, inherited acoustic qualifications, immutable binding artifacts.'})
print(json.dumps({'closed_rows':len(rows),'reviewed_inputs_sha256':sha(P/'reviewed-inputs.json'),'second_order_adapter_sha256':sha(derived),'derivation_sha256':sha(P/'second-order-derivation.json')}))
