from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent;D=P.parent;S=D.parent
R=next(p for p in P.parents if (p/'lean-toolchain').exists())
xp=lambda p:Path('\\\\?\\'+str(p)) if not str(p).startswith('\\\\?\\') else p
raw=lambda p:xp(p).read_bytes()
sha=lambda p:hashlib.sha256(raw(p)).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(raw(p))
helper=D/'prepare-successor-audit-with-source-context-long-paths.py'
assert sha(helper)=='fc1afd7578e69927edca25788423334f3947b8d58e348b176ae0a1cd3d64318e'
spec=read(P/'audit-spec.json');preflight=read(P/'schema02-preflight.json')
assert not preflight['prepare_invoked'] and not preflight['audit_roles_invoked']
assert preflight['native_spans_verified']==47 and len(preflight['prior_environment_pins_verified'])==69
assert preflight['helper']==ref(helper) and not preflight['operational_helper_longpath_review_required']
for x in preflight['additional_environment_pins']+preflight['source_context_pins']+preflight['prior_environment_pins_verified']+[preflight['source_target'],preflight['compiled_target']]:
 assert sha(R/x['path'])==x['sha256'],x
taskpath=S/'audits'/spec['task_id']/'audit-task.json'
observed=read(taskpath)
assert observed['target']==spec['target']
context=read(P/'source-context.json')
assert observed['source']['locations']==context['primary_locations']+context['inherited_locations']
concurrent=dict(owner='root',confirmation='Root message confirms actual route exit0 and session67537 at17:55:36 UTC after this worker preflight; this worker did not launch preparation.',observed_task=ref(taskpath),scope='Later concurrent coordinator action; not an output or invocation by this preparation-only worker.')
manifest=dict(format='dim-audit-spec-preparation-1',status='FROZEN-SPEC-PREFLIGHT-ROOT-PREPARATION-STARTED-SEPARATELY',task_id=spec['task_id'],spec=ref(P/'audit-spec.json'),helper=ref(helper),preflight=ref(P/'schema02-preflight.json'),native_packet=ref(P/'native-packet.json'),source_context=ref(P/'source-context.json'),source_target=preflight['source_target'],authority_boundary=ref(P/'authority-boundary.json'),concurrent_root_action=concurrent,all_artifacts=[ref(P/p.name) for p in xp(P).iterdir() if p.is_file() and p.name not in ('manifest.json','final-receipt.json')],source_judgment_supplied=False,prepare_invoked_by_this_worker=False,roles_invoked_by_this_worker=False)
def write(name,value):
 p=P/name
 with xp(p).open('x',encoding='utf-8',newline='\n') as f:json.dump(value,f,indent=2,ensure_ascii=False);f.write('\n')
 return ref(p)
m=write('manifest.json',manifest)
receipt=write('final-receipt.json',dict(format='dim-audit-spec-preparation-receipt-1',manifest=m,spec=ref(P/'audit-spec.json'),preflight=ref(P/'schema02-preflight.json'),helper=ref(helper),ready=True,prepare_invoked_by_this_worker=False,roles_invoked_by_this_worker=False,concurrent_root_action=concurrent))
print(json.dumps(dict(receipt=receipt,manifest=m,spec=ref(P/'audit-spec.json')),indent=2))
