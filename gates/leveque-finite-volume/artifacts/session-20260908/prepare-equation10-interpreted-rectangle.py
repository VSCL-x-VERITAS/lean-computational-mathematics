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
OLD = 'LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908'
CONTEXT = 'LEV-CH01-EQ-1.3-TRANSPORT-CONTEXT-PRODUCTION-20260908'
TASK = 'LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908'
CONFIG = 'audit-equation10-interpreted-rectangle.config.json'
T = S/'audits'/TASK
sha = lambda p: hashlib.sha256(xp(p).read_bytes()).hexdigest()
def writej(p, data):
    p = xp(p)
    assert not p.exists(), p
    p.write_text(json.dumps(data, indent=2, ensure_ascii=True)+'\n', encoding='utf-8', newline='')
old_hashes = {'manifest.json': 'ef3c6ce50c0a202acce5a2daa6b54b26f03c6c907227a0b962f86518dd29ab5d', 'decision.json': 'be89b5bf7e066c64e3b24292d96d997d879ddb5c5342de79936263cf9ce9a052', 'report.md': '70377c3770d33f792acbac049541d8b7812f798822888eba2a89f7de0c47f302'}
for name,h in old_hashes.items(): assert sha(S/'audits'/OLD/'faithfulness'/name)==h
task = json.loads((S/'audits'/OLD/'audit-task.json').read_bytes())
assert sha(R/task['target']['path'])=='5dcc799b4e236870500f1c0d38dbe8ce5ae1a5a10be12e65a7e7320b1a3b4d13'
assert sha(S/'definition-repairs-production-verification.json')=='53b710615834dfb6522713c9c3b7489b56eeb55d8138497e1b130cb0314a86d5'
task['target']={'path':'ComputationalMathematics/Source/LeVeque/Chapter01/Equation10RectangleConservation.lean','declaration':'NumStability.leveque01_equation10_rectangleConservation_iff_integrated_and_ae_rate'}
assert sha(R/task['target']['path'])=='b714622cdbb1ba1b36a8f64b7dc96199a82805043f8256728a4b1298257593e2'
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

user_receipt=S/'user-discontinuity-interpretation-20260908.json'
assert sha(user_receipt)=='b27e7d260e93edcd5408daa8c5d291ba8bfefd9e66a079480ae6b940aa869030'
user=json.loads(user_receipt.read_bytes())
assert user['scope']=='Chapter 1 discontinuity discussion around equation (1.10), particularly LEV-CH01-DISCONTINUITY-INTEGRAL-LAW.'
writej(T/'user-interpretation-packet.json',{
 'format':'user-adopted-source-interpretation-1',
 'authority':'Existing explicit user instruction for the discontinuity discussion around equation (1.10). This selected task audits (1.10) under that recorded scope, not a new convention or a printed-source assertion.',
 'receipt':{'path':SR+'/user-discontinuity-interpretation-20260908.json','sha256':sha(user_receipt)},
 'exact_receipt_fields':user,
 'exact_source_preservation':'Keep the original printed source wording and ambiguity unchanged.',
 'comparison_rule':'Independently compare the exact selected equation (1.10) target and both implications under the recorded rectangle and intervalwise almost-everywhere mass-rate convention. Any acceptance must be qualified by that interpretation. Do not infer a requested verdict or silently extend this task to unrelated source rows.',
 'selection_provenance':'The complete exact user receipt is supplied by JSON value. No prior audit outcomes or review conclusions are supplied.'})
cfg['lean']['environment_files'] += [SR+'/user-discontinuity-interpretation-20260908.json',SR+'/audits/'+TASK+'/user-interpretation-packet.json']

for p in cfg['lean']['environment_files']: assert (R/p).is_file(), p
assert len(cfg['lean']['environment_files'])==len(set(cfg['lean']['environment_files']))
writej(S/CONFIG, cfg)
writej(T/'environment-reuse-verification.json', {'recorded_at_utc':datetime.now(timezone.utc).isoformat(),'scope':'Exact environment bytes and native output spans only; no semantic judgment reused.','parent_manifest_sha256':sha(prior/'faithfulness/manifest.json'),'verified_previous_environment':verified,'exact_native_spans_checked':len(spans),'packet_sha256':sha(T/'dependency-environment-packet.json')})

helpers = T/'role-helpers'; helpers.mkdir()
ROLE_PARENT='LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908'
expected = {'r.py':'a1733ffb068317d8748a807a153e6de19e721ca75ccd2773d61e8f4556b56d9d','c.py':'a45b3653a4683e12f4620759c86a586967fcc6d136691473e67b9c02ba9f9344','q.py':'902bd45dcaaa7262e23de6f63f1bd7407f0372c82b05e10d45d78d965f98863d'}
lineage = []
for name,h in expected.items():
    src = S/'audits'/ROLE_PARENT/'faithfulness/orchestration'/name
    assert sha(src)==h
    code = src.read_text(encoding='utf-8').replace(ROLE_PARENT,TASK).replace('audit-discontinuity-interpreted-general.config.json',CONFIG)
    if name=='q.py': code=code.replace('assert workers in (1,2)','assert workers == 1')
    if name=='c.py':
        anchor="assert not any(e.get('type') in ('error','turn.failed') for e in events)"
        code=code.replace(anchor,anchor+"\nassert all(e['item']['type']=='agent_message' for e in events if e.get('type')=='item.completed'), 'Unexpected completed tool or other item'")
    ast.parse(code)
    (helpers/name).write_text(code,encoding='utf-8',newline='')
    lineage.append({'name':name,'parent_path':str(src),'parent_sha256':h,'new_sha256':sha(helpers/name)})
writej(T/'helper-lineage.json',{'helpers':lineage,'changes':['Exact task/config substitution','q enforces workers=1','c also rejects any completed event item other than agent_message'],'roles_invoked':False,'user_interpretation_supplied':True,'role_supplement_scope':['direct-judge','adjudicator']})

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
image_hashes={'23': 'c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316', '25': 'ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8', '27': '846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7', '26': 'c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d'}
for page,h in image_hashes.items():
    src=S/'audits'/OLD/'faithfulness/orchestration'/('page-'+page.zfill(3)+'.png')
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
writej(T/'prepared-handoff-base.json',{'task_id':TASK,'task_sha256':sha(T/'audit-task.json'),'config_path':str(S/CONFIG),'config_sha256':sha(S/CONFIG),'target':task['target'],'target_source_sha256':sha(R/task['target']['path']),'source_sha256':task['source']['sha256'],'pages_argument':'23,25,26,27','native_packet_sha256':sha(T/'dependency-environment-packet.json'),'manifest_sha256':sha(out/'manifest.json'),'blind_preflight_sha256':sha(T/'blind-preflight.json'),'helper_hashes':{name:sha(tr/name) for name in expected},'old_audit_preserved':old_hashes,'semantic_roles_invoked':False,'prepared_validation_exit_code':0})
print(json.dumps({'status':'prepared-only','task':TASK,'manifest_sha256':sha(out/'manifest.json'),'config_sha256':sha(S/CONFIG),'task_sha256':sha(T/'audit-task.json')}),flush=True)
