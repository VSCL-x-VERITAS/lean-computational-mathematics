"""Read-only checks of real prospective inputs, with no preparation/main execution."""
from pathlib import Path
import ast,hashlib,json,sys
P=Path(__file__).resolve().parent;D=P.parent;S=D.parent
R=next(p for p in P.parents if (p/'lean-toolchain').exists());W=R.parent
xp=lambda p:Path('\\\\?\\'+str(p)) if not str(p).startswith('\\\\?\\') else p
raw=lambda p:xp(p).read_bytes()
sha=lambda p:hashlib.sha256(raw(p)).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
load=lambda p:json.loads(raw(p))
helper=R/sys.argv[1] if len(sys.argv)>1 else D/'prepare-successor-audit-with-source-context.py'
label=sys.argv[2] if len(sys.argv)>2 else 'schema01'
assert label.isalnum(),label
spec=load(P/'audit-spec.json');prior=S/'audits'/spec['prior_task'];task=load(prior/'audit-task.json')
source=raw(helper).decode('utf-8')
tree=ast.parse(source);wanted={'load_additional_supplement','load_source_context'}
nodes=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in wanted]
assert {n.name for n in nodes}==wanted
namespace={'Path':Path,'hashlib':hashlib,'json':json}
exec(compile(ast.Module(body=nodes,type_ignores=[]),str(helper)+'[pure-loaders-only]','exec'),namespace)
extra=namespace['load_additional_supplement'](xp(R),spec['additional_supplement'])
context=namespace['load_source_context'](xp(R),spec['source_context_extension'],task['source'],spec['pages'],xp(W/'workflow-v5.0.1-local/chapter01-source-review'))
manifest=load(prior/'faithfulness/manifest.json');oldpins={x['path']:x['sha256'] for x in manifest['lean_environment']}
cfg=S/spec['prior_config'];verified=[]
for path in load(cfg)['lean']['environment_files']:
 assert oldpins[path]==sha(R/path),path
 verified.append(dict(path=path,sha256=oldpins[path]))
assert len(extra[0]['native_output_spans'])==47
assert context['locations'][:len(task['source']['locations'])]==task['source']['locations']
assert context['pages_arg']=='26,27,28'
assert context['packet']['interpretation_receipts'][0]['exact_receipt_bytes_utf8']==raw(S/'user-discontinuity-interpretation-20260908.json').decode('utf-8')
assert sha(D/'selected-interpretations.json')=='cfde240a9dda9a58be99f85369b43e99003b0024c7147a33ffa8b071ca7dcf34'
choice=next(x for x in load(D/'selected-interpretations.json')['choices'] if x['choice_id']==spec['choice_id'])
assert spec['choice_id']=='Q10' and spec['row_id'] in choice['rows']
assert not xp(S/'audits'/spec['task_id']).exists(),'Preparation must not run in this task'
receipt=dict(format='prospective-dim-audit-input-preflight-1',helper=ref(helper),helper_functions_executed=sorted(wanted),module_main_executed=False,
 spec=ref(P/'audit-spec.json'),prior_task=ref(prior/'audit-task.json'),prior_manifest=ref(prior/'faithfulness/manifest.json'),prior_config=ref(cfg),
 native_spans_verified=47,additional_environment_pins=extra[2],source_context_pins=context['pins'],prior_environment_pins_verified=verified,
 original_primary_locator_preserved=True,exact_original_user_receipt_preserved=True,source_image_pages=[26,27,28],
 prepare_invoked=False,audit_roles_invoked=False,generated_blind_packet_exists=False,operational_helper_longpath_review_required='long-path' not in helper.name,
 source_target=ref(R/spec['target']['path']),compiled_target=ref(R/'.lake/build/lib/lean'/Path(spec['target']['path']).with_suffix('.olean')))
out=P/(label+'-preflight.json')
with xp(out).open('x',encoding='utf-8',newline='\n') as f:json.dump(receipt,f,indent=2,ensure_ascii=False);f.write('\n')
print(json.dumps(dict(receipt=ref(out),native_spans=47,prior_environment_pins=len(verified),context_pins=len(context['pins']),actual_result='PASS-NO-PREPARATION')))
