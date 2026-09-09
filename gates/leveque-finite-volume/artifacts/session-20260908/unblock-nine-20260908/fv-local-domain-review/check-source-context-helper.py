"""Fixture-only guard tests and read-only real extension validation. Never launch audit roles."""
from pathlib import Path
from datetime import datetime,timezone
import ast, copy, hashlib, json, sys
F=Path(__file__).resolve().parent;D=F.parent;R=F.parents[5];S=D.parent
helper=D/'prepare-successor-audit-with-source-context.py'
tree=ast.parse(helper.read_text(encoding='utf-8'))
functions=[node for node in tree.body if isinstance(node,ast.FunctionDef) and node.name in ('load_source_context','bind_source_context_role')]
assert len(functions)==2
ns={'Path':Path,'hashlib':hashlib,'json':json}
exec(compile(ast.Module(body=functions,type_ignores=[]),str(helper),'exec'),ns)
sha=lambda raw:hashlib.sha256(raw).hexdigest()
J=lambda obj:(json.dumps(obj,indent=2,ensure_ascii=False)+'\n').encode()
fixture=Path(chr(92)*2+'?'+chr(92)+str(F/'source-context-synthetic-fixtures02'));fixture.mkdir()
(fixture/'render').mkdir()
def put(name,raw):
 p=fixture/name
 with p.open('xb') as f:f.write(raw)
 return {'path':name,'sha256':sha(raw)}
source=put('source.pdf',b'SYNTHETIC SOURCE FIXTURE - NOT BOOK EVIDENCE')
image=put('page.png',b'\x89PNG\r\n\x1a\nSYNTHETIC IMAGE BYTES')
(fixture/'render/page-026.png').write_bytes((fixture/'page.png').read_bytes())
receipt={'kind':'explicit user-adopted source interpretation','source_sha256':source['sha256'],
 'question':'SYNTHETIC QUESTION','answer':'SYNTHETIC ANSWER','scope':'SYNTHETIC SCOPE',
 'authority_limit':'Fixture only','adopted_interpretation':['Fixture only'],'preservation':['Fixture only'],
 'question_item_id':['request_user_input_async','call_fixture',0]}
receipt_ref=put('receipt.json',J(receipt))
primary=[{'location':'fixture primary','anchor':'fixture primary anchor'}]
prior_source={**source,'locations':primary}
extension={'format':'pinned-source-context-extension-1','source':source,'primary_locations':primary,
 'inherited_locations':[{'location':'fixture inherited','anchor':'fixture inherited anchor'}],
 'pages':[26],'images':[{'page':26,**image}],'interpretation_receipts':[receipt_ref]}
tests=[]
def run(name,obj,accepted=False,pages='26',ref_edit=None):
 ref=put(name+'.json',J(obj));ref=ref_edit(ref) if ref_edit else ref
 try:
  result=ns['load_source_context'](fixture,ref,prior_source,pages,fixture/'render')
 except (AssertionError,KeyError,ValueError,TypeError):
  assert not accepted,(name,'unexpected rejection');tests.append({'test':name,'result':'rejected'});return
 assert accepted,(name,'unexpected acceptance')
 assert result['packet']['interpretation_receipts'][0]['exact_receipt_bytes_utf8']==(fixture/'receipt.json').read_text()
 tests.append({'test':name,'result':'accepted'})
 return result
context=run('valid',extension,True)
def changed(key,value):
 obj=copy.deepcopy(extension);obj[key]=value;return obj
run('extra-field',{**extension,'verdict':'PASS'})
run('primary-replaced',changed('primary_locations',[{'location':'replacement','anchor':'replacement'}]))
run('wrong-source',changed('source',{**source,'sha256':'0'*64}))
run('wrong-pages',extension,pages='27')
run('duplicate-pages',changed('pages',[26,26]))
run('wrong-image-hash',changed('images',[{'page':26,**image,'sha256':'0'*64}]))
run('extension-hash-changed',extension,ref_edit=lambda ref:{**ref,'sha256':'0'*64})
run('path-escape',extension,ref_edit=lambda ref:{**ref,'path':'../'+ref['path']})
wrong_receipt=put('wrong-receipt.json',J({**receipt,'kind':'coordinator-selected convention'}))
run('wrong-authority',changed('interpretation_receipts',[wrong_receipt]))
wrong_receipt=put('wrong-source-receipt.json',J({**receipt,'source_sha256':'0'*64}))
run('receipt-source-mismatch',changed('interpretation_receipts',[wrong_receipt]))
dup_ref=put('duplicate-key-extension.json',J(extension).replace(b'"format":',b'"pages": [26], "format":',1))
try:ns['load_source_context'](fixture,dup_ref,prior_source,'26',fixture/'render')
except AssertionError:tests.append({'test':'duplicate-json-key','result':'rejected'})
else:raise AssertionError('duplicate JSON key accepted')
parent=S/'audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration/r.py'
role=ns['bind_source_context_role'](parent.read_text(encoding='utf-8'),context)
ast.parse(role)
# Execute only the actual blind prefix in a synthetic local tree, never subprocess code.
role_root=fixture/'role-root';kit=role_root/'.faithfulness-audit'
for sub in ('prompts','schemas'):(kit/sub).mkdir(parents=True)
(kit/'prompts/blind_translation.md').write_text('SYNTHETIC BLIND PROMPT')
(kit/'schemas/blind_translation.schema.json').write_text('{}')
task='LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908'
out=role_root/'gates/leveque-finite-volume/artifacts/session-20260908/audits'/task/'faithfulness'
(out/'inputs').mkdir(parents=True)
sealed=b'SYNTHETIC SEALED BLIND PACKET'
(out/'inputs/blind_review_packet.md').write_bytes(sealed)
role=role.replace("root=Path(r'C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/lean-computational-mathematics')",'root=Path('+repr(str(role_root))+')')
role=role.replace("out=Path(chr(92)*2+'?'+chr(92)+str(out))",'out=out  # fixture root already uses extended path')
prefix=role.split("inp=tr/(stem+'_input.txt')")[0]
assert 'subprocess.run' not in prefix
saved=sys.argv;sys.argv=['r.py',task,'blind-translation','fixture',''];scope={}
try:exec(compile(prefix,'fixture-blind-prefix','exec'),scope)
finally:sys.argv=saved
assert scope['message'].endswith(sealed) and scope['message'].count(sealed)==1 and scope['images']==[]
assert b'inherited-source' not in scope['message'] and b'SYNTHETIC ANSWER' not in scope['message']
tests.append({'test':'blind-prefix-isolation','result':'accepted strict blind packet only'})
# Check the exact injected receipt code is nested beneath the existing non-source-contract judge branch.
role_ast=ast.parse(role)
containers=[]
def visit(node,ancestors):
 if isinstance(node,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='inherited' for t in node.targets):containers.append(ancestors)
 for child in ast.iter_child_nodes(node):visit(child,ancestors+[node])
visit(role_ast,[])
assert len(containers)==1 and any(isinstance(n,ast.If) and ast.unparse(n.test)=="role != 'source-contract'" for n in containers[0])
tests.append({'test':'source-extractor-receipt-isolation','result':'accepted source-only branch excludes receipt'})
real_spec=json.loads((D/'finite-volume-local-flux-update-audit-spec.json').read_bytes())
old_task=json.loads((S/'audits'/real_spec['prior_task']/'audit-task.json').read_bytes())
real=ns['load_source_context'](R,real_spec['source_context_extension'],old_task['source'],real_spec['pages'],R.parent/'workflow-v5.0.1-local/chapter01-source-review')
tests.append({'test':'real-extension-read-only','result':'accepted exact pins, primary locator, images, original receipt'})
record={'schema':1,'completed_at_utc':datetime.now(timezone.utc).isoformat(),'helper_sha256':sha(helper.read_bytes()),
 'test_script_sha256':sha(Path(__file__).read_bytes()),'tests':tests,'roles_invoked':False,'released_prepare_invoked':False,
 'real_extension':real_spec['source_context_extension'],'real_source_receipt_count':len(real['packet']['interpretation_receipts'])}
with (F/'source-context-helper-checks.json').open('x',encoding='utf-8',newline='\n') as f:json.dump(record,f,indent=2);f.write('\n')
print(json.dumps(record))
