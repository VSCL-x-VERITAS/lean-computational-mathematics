"""Static and rejection-only tests; no complete route fixture or operational request."""
from pathlib import Path
import ast,hashlib,importlib.util,json,os,types
H=Path(__file__).resolve().parent
S=H.parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
spec=importlib.util.spec_from_file_location('request_constructor_under_test',H/'construct_request.py')
c=importlib.util.module_from_spec(spec);spec.loader.exec_module(c)
assert os.name=='posix'
b=c.load_binding_helper()
PINS={
 'blocked-gate-binding-transcript-order-v2/blocked_gate_binding.py':c.B_SHA,
 'blocked-gate-binding-transcript-order-v2/input.schema.json':c.SCHEMA_SHA,
 'nine-row-local-route-review-batch10/local-route-review.json':'a1f573c281e28f67b42bc22cf01a3209a659eea74c8cf92a86efe401d23ad2cd',
 'nine-row-local-route-review-batch10/REVIEW.md':'724a74391654e8b6dbd6307954730742e5cb21c118de0cc01267e076021e68b0',
 'prospective-source-choice-boundaries-batch10-v2.json':'99fb785787ccfe7906b95ff0dc1d4d774bcd664673cc3c7c9323e9d29ae2c0c3',
 'current-thread-question-provenance-v2-batch10/projection.json':'15f55c43d5d3c50134b1861d82231e953c6644db4cd30561d0644640b3e11acc'}
for name,pin in PINS.items():assert sha(S/name)==pin,name
results=[]
def test(name,run):run();results.append({'name':name,'status':'PASS'})
def rejects(run):
 try:run()
 except (ValueError,KeyError,TypeError):return
 raise AssertionError('expected rejection')
source=(H/'construct_request.py').read_text(encoding='utf-8')
tree=ast.parse(source)
test('Constructor syntax compiles without invoking construct or main',lambda:compile(source,'construct_request.py','exec'))
schema=json.loads(c.SCHEMA.read_bytes())
def schema_match():
 assert set(schema['$defs']['request']['required'])=={'schema_version','kind',*c.REF_KEYS,'receipts'}
 assert set(schema['$defs']['request']['properties']['receipts']['required'])==set(c.SUFFIXES)
 assert set(schema['$defs']['route']['properties']['kind']['enum'])==b.ROUTE_KINDS
test('Existing V2 request fields, nine receipt categories and seven route categories reused',schema_match)
labels={key:'synthetic-label-only-'+key for key in c.SUFFIXES}
test('Nine safe distinct labels accepted as labels only; no receipts created',lambda:c.validate_labels(labels))
test('Missing label rejected',lambda:rejects(lambda:c.validate_labels({k:v for k,v in labels.items() if k!='audits'})))
test('Duplicate label rejected',lambda:rejects(lambda:c.validate_labels({k:'duplicate' for k in c.SUFFIXES})))
test('Traversal label rejected',lambda:rejects(lambda:c.validate_labels(labels|{'audits':'../outside'})))
test('Additional receipt category rejected',lambda:rejects(lambda:c.validate_labels(labels|{'extra':'label'})))
review=json.loads((S/'nine-row-local-route-review-batch10/local-route-review.json').read_bytes())
test('Actual frozen bounded route review is rejected as a completion dossier',lambda:rejects(lambda:c.completion_kind(review)))
test('Absent completion dossier rejected',lambda:rejects(lambda:c.completion_kind(None)))
partial={'schema_version':1,'kind':'reviewed-local-work-exhaustion','rows':[{'all_local_work_complete':False,'remaining_local_actions':['synthetic unfinished work']} for _ in range(9)]}
test('Negative-only dummy rows with pending work rejected',lambda:rejects(lambda:c.completion_kind(partial)))
test('Incomplete row count rejected',lambda:rejects(lambda:c.completion_kind(partial|{'rows':partial['rows'][:8]})))
test('Missing completion flag rejected',lambda:rejects(lambda:c.completion_kind(partial|{'rows':[{} for _ in range(9)]})))
test('String completion flag is not a Boolean',lambda:rejects(lambda:c.completion_kind(partial|{'rows':[{'all_local_work_complete':'true','remaining_local_actions':[]} for _ in range(9)]})))
test('Claimed completion with a pending action rejected',lambda:rejects(lambda:c.completion_kind(partial|{'rows':[{'all_local_work_complete':True,'remaining_local_actions':['synthetic unfinished work']} for _ in range(9)]})))
test('Missing explicit context rejected',lambda:rejects(lambda:c.validate_context({},types.SimpleNamespace(BINDING_FIELDS=set())))))
def no_operational_calls():
 calls=[ast.unparse(n.func) for n in ast.walk(tree) if isinstance(n,ast.Call)]
 assert not any(name.endswith(('.prepare','.verify_installed','.current_context','.run','.Popen','.system','.replace')) for name in calls)
 assert 'b.check_transition' in calls and 'b.check_provenance' in calls and 'b.consume_receipts' in calls
 assert 'validate_native_inputs' in calls and 'reader.unchanged' in calls
 assert not any(isinstance(n,(ast.Import,ast.ImportFrom)) and 'subprocess' in ast.unparse(n) for n in ast.walk(tree))
 assert not any(isinstance(n,ast.Constant) and n.value=='HARD_BLOCKED' for n in ast.walk(tree))
test('No prepare/install/Git/process/current-context calls or synthesized HARD_BLOCKED literal',no_operational_calls)
def copies_refs():
 assert "**{k:params[k] for k in REF_KEYS}" in source
 assert "request['proposed_rows']" in source and "request['route_manifest']" in source
 assert "(out/'request.json').open('xb')" in source and "(out/'construction.json').open('xb')" in source
test('Request copies reviewed refs; only two exclusive local output files',copies_refs)
for name,pin in PINS.items():assert sha(S/name)==pin,name
result={'schema':1,'count':len(results),'results':results,
 'inputs':[{'path':str(S/name),'sha256':pin} for name,pin in PINS.items()],
 'constructor_sha256':sha(H/'construct_request.py'),
 'scope':'Static and negative-only validation. No complete route dossier, successful request, fabricated native receipt or real completeness fixture created. No construct/main or binder operational mode invoked.',
 'source_acceptance':False,'route_completion_asserted':False,'operational_request_created':False}
with (H/'checks.json').open('xb') as out:out.write((json.dumps(result,indent=2)+'\n').encode())
print(json.dumps({'checks':len(results),'results_sha256':sha(H/'checks.json'),'operational_request_created':False}))
