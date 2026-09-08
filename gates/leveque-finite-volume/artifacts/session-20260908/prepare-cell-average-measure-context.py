"""Preparation only: fresh sealed v1 task, immutable native environment evidence."""
from pathlib import Path
from datetime import datetime, timezone
import ast, hashlib, json, os, subprocess, sys

def xp(p):
    p = str(p)
    prefix = chr(92)*2+'?'+chr(92)
    return Path(p if p.startswith(prefix) else prefix+str(Path(p).resolve()))

R = xp(Path(__file__).resolve().parents[4])
S = R/'gates/leveque-finite-volume/artifacts/session-20260908'
SR = 'gates/leveque-finite-volume/artifacts/session-20260908'
OLD = 'LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908'
CONTEXT = 'LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908'
TASK = 'LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908'
CONFIG = 'audit-cell-average-measure-context.config.json'
T = S/'audits'/TASK
sha = lambda p: hashlib.sha256(xp(p).read_bytes()).hexdigest()
def writej(p, data):
    p = xp(p)
    assert not p.exists(), p
    p.write_text(json.dumps(data, indent=2, ensure_ascii=True)+'\n', encoding='utf-8', newline='')
old_hashes = {'manifest.json':'ec4853918b6f85788e5dd7881b1509821783e9d6ecb2418b12d211a821ba408f', 'decision.json':'d1c97d14be0ffaaf83897b80df8759ebeb4f7167c597a84cddd2a95efb54d843', 'report.md':'f622d4cf078d59e7ab9f8d0b43a028745ead9019d9f17393e915629d39b50ee3'}
for name,h in old_hashes.items(): assert sha(S/'audits'/OLD/'faithfulness'/name)==h
task = json.loads((S/'audits'/OLD/'audit-task.json').read_bytes())
assert sha(R/task['target']['path'])=='4c9e8eee7c8cfce7fa381cf1de2892d5b2326b46aacbbf3a2bff4efad1eca816'
assert sha(R/task['source']['path'])==task['source']['sha256']
assert not T.exists()
T.mkdir()
task['task_id'] = TASK
task['audit_output'] = SR+'/audits/'+TASK+'/faithfulness'
writej(T/'audit-task.json', task)

cfgpath = S/'audit-transport-context.config.json'
assert sha(cfgpath)=='cb5476fce5bda03f5491c7c0e359ee6c17830db784d16002bdd5cc77931ac8f9'
cfg = json.loads(cfgpath.read_bytes())
prior = S/'audits'/CONTEXT
manifest = json.loads((prior/'faithfulness/manifest.json').read_bytes())
recorded = {x['path']:x['sha256'] for x in manifest['lean_environment']}
verified = []
for p in cfg['lean']['environment_files']:
    assert p in recorded, p
    assert sha(R/p)==recorded[p], p
    verified.append({'path':p,'sha256':recorded[p]})
packet = prior/'dependency-environment-packet.json'
assert sha(packet)=='c4502161b4182fc98d4b89eeb2f8e08b5ae688cdc7f99ba63671f5a511f196e2'
data = json.loads(packet.read_bytes())
spans = data.get('native_output_spans', data.get('declaration_output_spans', data.get('exact_native_output_spans')))
if spans is None:
    spans = next(v for v in data.values() if isinstance(v,list) and v and isinstance(v[0],dict) and 'exact_text' in v[0])
for span in spans:
    raw = (R/span['source_path']).read_bytes()
    assert hashlib.sha256(raw).hexdigest()==span['source_sha256']
    exact = raw[span['start_byte']:span['end_byte_exclusive']]
    assert exact == span['exact_text'].encode('utf-8')
    assert hashlib.sha256(exact).hexdigest()==span['span_sha256']
(T/'dependency-environment-packet.json').write_bytes(packet.read_bytes())
cfg['task_metadata_glob'] = SR+'/audits/'+TASK+'/audit-task.json'
cfg['lean']['environment_files'] = [p.replace('/'+CONTEXT+'/dependency-environment-packet.json','/'+TASK+'/dependency-environment-packet.json') for p in cfg['lean']['environment_files']]
# Keep the original probe's exact compiled import as provenance; add the actual new target.
cfg['lean']['environment_files'] += [task['target']['path'], '.lake/build/lib/lean/'+task['target']['path'].removesuffix('.lean')+'.olean']
for p in cfg['lean']['environment_files']: assert (R/p).is_file(), p
assert len(cfg['lean']['environment_files'])==len(set(cfg['lean']['environment_files']))
writej(S/CONFIG, cfg)
writej(T/'environment-reuse-verification.json', {'recorded_at_utc':datetime.now(timezone.utc).isoformat(),'scope':'Exact environment bytes and native output spans only; no semantic judgment reused.','parent_manifest_sha256':sha(prior/'faithfulness/manifest.json'),'verified_previous_environment':verified,'exact_native_spans_checked':len(spans),'packet_sha256':sha(T/'dependency-environment-packet.json')})

helpers = T/'role-helpers'; helpers.mkdir()
expected = {'r.py':'f46124b1d53e7cc45c94860eb991fd12fdf01b7298dc63e91dc500536e3cfbe1','c.py':'256a743ee7e693d146323b401e6a0f7316ef22ad345912225177dee03e5140e0','q.py':'4c9d73114aa5932b719679767e2589c0a8feb43bdafdbc2dd06e48bb1c087cb7'}
lineage = []
for name,h in expected.items():
    src = prior/'faithfulness/orchestration'/name
    assert sha(src)==h
    code = src.read_text(encoding='utf-8').replace(CONTEXT,TASK).replace('audit-transport-context.config.json',CONFIG)
    if name=='q.py': code=code.replace('assert workers in (1,2)','assert workers == 1')
    if name=='c.py':
        anchor="assert not any(e.get('type') in ('error','turn.failed') for e in events)"
        code=code.replace(anchor,anchor+"\nassert all(e['item']['type']=='agent_message' for e in events if e.get('type')=='item.completed'), 'Unexpected completed tool or other item'")
    ast.parse(code)
    (helpers/name).write_text(code,encoding='utf-8',newline='')
    lineage.append({'name':name,'parent_path':str(src),'parent_sha256':h,'new_sha256':sha(helpers/name)})
writej(T/'helper-lineage.json',{'helpers':lineage,'changes':['Exact task/config substitution','q enforces workers=1','c also rejects any completed event item other than agent_message'],'roles_invoked':False,'user_interpretation_supplied':False,'role_supplement_scope':['direct-judge','adjudicator']})

wrapper = r'C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/workflow-v5.0.1-local/run_workflow_posix.py'
env = dict(os.environ,FAITHFULNESS_AUDIT_CONFIG='/c/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/lean-computational-mathematics/'+SR+'/'+CONFIG)
def call(label,script,args,cwd):
    command=[sys.executable,'-B',wrapper,script,*args]
    stdout=T/(label+'-output.txt'); stderr=T/(label+'-stderr.txt')
    assert not stdout.exists() and not stderr.exists()
    start=datetime.now(timezone.utc).isoformat()
    with stdout.open('wb') as of,stderr.open('wb') as ef:
        result=subprocess.run(command,cwd=cwd,env=env,stdout=of,stderr=ef)
    receipt={'command':command,'cwd':str(cwd),'config':env['FAITHFULNESS_AUDIT_CONFIG'],'started_at_utc':start,'completed_at_utc':datetime.now(timezone.utc).isoformat(),'exit_code':result.returncode,'stdout_sha256':sha(stdout),'stderr_sha256':sha(stderr)}
    writej(T/(label+'-exit.json'),receipt)
    print(json.dumps({'stage':label,**receipt}),flush=True)
    if result.returncode:
        sys.stdout.buffer.write(stdout.read_bytes()+stderr.read_bytes())
        raise SystemExit(result.returncode)
call('route','formalization-collaboration-v5.0.1/skills/formalization-faithfulness-audit/scripts/route_audit.py',['/c/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/lean-computational-mathematics/'+SR+'/audits/'+TASK+'/audit-task.json'],R.parent)
call('prepare','.faithfulness-audit/scripts/prepare_audit.py',[TASK],R)
call('prepared-validation','.faithfulness-audit/scripts/validate_audit.py',[TASK,'--phase','prepared'],R)
out=T/'faithfulness'; tr=out/'orchestration'; tr.mkdir()
for name in expected: (tr/name).write_bytes((helpers/name).read_bytes())
image_hashes={'23':'c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316','26':'c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d','27':'846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7'}
for page,h in image_hashes.items():
    src=R.parent/'workflow-v5.0.1-local/chapter01-source-review'/('page-'+page.zfill(3)+'.png')
    assert sha(src)==h
    (tr/src.name).write_bytes(src.read_bytes())
prefix=(tr/'r.py').read_text(encoding='utf-8').split("inp=tr/(stem+'_input.txt')")[0]
assert 'subprocess.run' not in prefix
previous=sys.argv; sys.argv=['r.py',TASK,'blind-translation','b','']; ns={'__name__':'blind_packet_preflight'}
try: exec(compile(prefix,'blind_packet_preflight','exec'),ns)
finally: sys.argv=previous
message=ns['message']; blind=(out/'inputs/blind_review_packet.md').read_bytes()
assert message.endswith(blind) and message.count(blind)==1 and not ns['images']
assert TASK.encode() not in message and b'LeVeque' not in message
assert b'user-interpretation' not in message and b'dependency-environment-packet' not in message
assert not (tr/'b_input.txt').exists()
assert not any((out/'agent_outputs').iterdir())
writej(T/'blind-preflight.json',{'packet_sha256':hashlib.sha256(blind).hexdigest(),'packet_bytes':len(blind),'stdin_sha256':hashlib.sha256(message).hexdigest(),'stdin_bytes':len(message),'images':0,'packet_exact_and_single':True,'supplement_absent':True,'task_and_source_identity_absent':True,'role_transport_invoked':False})
for name,h in old_hashes.items(): assert sha(S/'audits'/OLD/'faithfulness'/name)==h
writej(T/'prepared-handoff-base.json',{'task_id':TASK,'task_sha256':sha(T/'audit-task.json'),'config_path':str(S/CONFIG),'config_sha256':sha(S/CONFIG),'target':task['target'],'target_source_sha256':sha(R/task['target']['path']),'source_sha256':task['source']['sha256'],'pages_argument':'23,26,27','native_packet_sha256':sha(T/'dependency-environment-packet.json'),'manifest_sha256':sha(out/'manifest.json'),'blind_preflight_sha256':sha(T/'blind-preflight.json'),'helper_hashes':{name:sha(tr/name) for name in expected},'old_audit_preserved':old_hashes,'semantic_roles_invoked':False,'prepared_validation_exit_code':0})
print(json.dumps({'status':'prepared-only','task':TASK,'manifest_sha256':sha(out/'manifest.json'),'config_sha256':sha(S/CONFIG),'task_sha256':sha(T/'audit-task.json')}),flush=True)
