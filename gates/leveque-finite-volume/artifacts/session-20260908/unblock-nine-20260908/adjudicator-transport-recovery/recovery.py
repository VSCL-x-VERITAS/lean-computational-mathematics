"""Append-only recovery of a recorded input-limit failure before an adjudicator turn.

prepare writes a reviewable plan and lossless transport in a NEW local directory.
execute is separately explicit and uses the existing collector and released finalizer/validator.
"""
from __future__ import annotations
from datetime import datetime, timezone
from pathlib import Path
import argparse
import hashlib
import json
import os
import re
import subprocess
import sys
import time

D=Path(__file__).resolve().parent
R=next(p for p in D.parents if (p/'lean-toolchain').is_file())
S=R/'gates/leveque-finite-volume/artifacts/session-20260908'
SHIM=S/'unblock-nine-20260908/fv-local-domain-review/native-long-path-io.py'
exec(compile(SHIM.read_bytes(),str(SHIM),'exec'),globals())
LIMIT=1048576
def digest(data):return hashlib.sha256(data).hexdigest()
def sha(path):return digest(path.read_bytes())
def unique(pairs):
    result={}
    for key,value in pairs:
        assert key not in result,'Duplicate JSON key'
        result[key]=value
    return result
def decode(raw):
    return json.loads(raw,object_pairs_hook=unique,parse_constant=lambda x:(_ for _ in ()).throw(ValueError(x)))
def read(path):return decode(path.read_bytes())
def ref(path):return {'path':str(path.resolve()),'sha256':sha(path)}
def verify(pin):
    path=Path(pin['path'])
    assert set(pin)=={'path','sha256'} and sha(path)==pin['sha256'],pin['path']
    return path
def create(path,data):
    with path.open('xb') as handle:handle.write(data)
def write(path,value):create(path,(json.dumps(value,indent=2,ensure_ascii=False)+'\n').encode())
def now():return datetime.now(timezone.utc).isoformat()
def snapshot(path,directory,name):
    destination=directory/name;create(destination,path.read_bytes());return ref(destination)

def unstarted_failure(events,stderr,transport,prompt):
    assert type(transport.get('exit_code')) is int and transport['exit_code']!=0
    assert [e.get('type') for e in events]==['thread.started'],'Not an unstarted single-thread attempt'
    uid=events[0].get('thread_id');assert isinstance(uid,str) and uid
    assert 'input_too_large' in stderr
    match=re.search(r'"max_chars"\s*:\s*(\d+)\s*,\s*"actual_chars"\s*:\s*(\d+)',stderr)
    assert match and int(match[1])==LIMIT
    assert len(prompt.decode())==int(match[2])>LIMIT
    assert len(prompt)==transport['stdin_bytes'] and digest(prompt)==transport['stdin_sha256']
    return uid

def deduplicate(prompt,inputs):
    """Only substitute a whole exact Markdown document found in another supplied full dossier."""
    by_name={Path(x['path']).name:x for x in inputs}
    target=by_name['direct_review_packet.md'];container=by_name['declaration_dossier.md']
    body=Path(target['path']).read_bytes();whole=Path(container['path']).read_bytes()
    assert digest(body)==target['sha256'] and digest(whole)==container['sha256']
    assert whole.count(body)==1,'Direct packet is not one exact contiguous dossier span'
    start=whole.index(body);end=start+len(body)
    header=('\n\n'+target['label']+' SHA256 '+target['sha256']+'\n').encode()
    segment=header+body
    assert prompt.count(segment)==1
    full_header=('\n\n'+container['label']+' SHA256 '+container['sha256']+'\n').encode()
    assert prompt.count(full_header+whole)==1,'Complete containing dossier is not supplied exactly once'
    marker=("\n[LOSSLESS INTERNAL DOCUMENT REFERENCE — NO EXTERNAL READ REQUIRED]\n"
        "This complete direct review packet is exactly the contiguous UTF-8 byte range "
        f"[{start},{end}) of the full 'Complete direct declaration dossier' included below. "
        f"That full dossier has original SHA256 {container['sha256']}; this exact span has "
        f"original SHA256 {target['sha256']}. Treat those identical bytes as the complete "
        "direct review packet here as well. Only the second copy of identical bytes is replaced; "
        "every unique byte remains included, both complete required dossiers remain verbatim, "
        "and all JSON remains verbatim. The original expanded prompt has been reconstructed "
        "and verified byte-for-byte by the orchestrator. Independently inspect the supplied "
        "evidence; this transport reference supplies no judgment or requested verdict.\n"
        "[END LOSSLESS INTERNAL DOCUMENT REFERENCE]\n").encode()
    assert marker not in prompt
    compact=prompt.replace(segment,header+marker,1)
    assert compact.count(marker)==1 and compact.replace(marker,whole[start:end],1)==prompt
    assert compact.count(full_header+whole)==1
    comparisons=[]
    for item in inputs:
        p=Path(item['path']);raw=p.read_bytes()
        assert len(raw)==item['bytes'] and digest(raw)==item['sha256']
        if p.suffix in ('.md','.json'):
            if p.suffix=='.json':
                value=decode(raw);assert decode(raw)==value
            if p.name!='direct_review_packet.md':
                h=('\n\n'+item['label']+' SHA256 '+item['sha256']+'\n').encode()
                assert h+raw in compact,'Input document is not retained verbatim'
            comparisons.append({'path':str(p),'sha256':digest(raw),'kind':p.suffix,
                'representation':'exact internal span' if p.name=='direct_review_packet.md' else 'verbatim'})
    return compact,{'target':target,'container':container,'start_byte':start,'end_byte_exclusive':end,
        'marker_utf8':marker.decode(),'original_prompt_sha256':digest(prompt),
        'compact_prompt_sha256':digest(compact),'original_characters':len(prompt.decode()),
        'compact_characters':len(compact.decode()),'character_limit':LIMIT,
        'reconstruction_byte_equal':True,'documents':comparisons}

def manifest_transition(before,after):
    allowed={'status','completed_at_utc','outputs'}
    assert {k:v for k,v in before.items() if k not in allowed}=={
        k:v for k,v in after.items() if k not in allowed},'Unexpected immutable manifest change'
    assert after.get('status')=='completed'
    assert isinstance(after.get('completed_at_utc'),str) and after['completed_at_utc']
    assert isinstance(after.get('outputs'),dict) and after['outputs']

def run_append(before,after,uid,failed_uid):
    assert {k:v for k,v in before.items() if k!='runs'}=={k:v for k,v in after.items() if k!='runs'}
    assert after['runs'][:-1]==before['runs'] and len(after['runs'])==len(before['runs'])+1
    added=after['runs'][-1]
    assert added['role']=='adjudicator' and added['agent_id']==uid
    assert uid!=failed_uid and uid not in {x['agent_id'] for x in before['runs']}

def prepare(spec_path,failed_stem,new_stem,destination):
    assert re.fullmatch(r'a(?:[2-9][0-9]*)?',failed_stem)
    assert re.fullmatch(r'a[2-9][0-9]*',new_stem) and failed_stem!=new_stem
    assert int(new_stem[1:])>int(failed_stem[1:] or 1)
    spec=read(spec_path);tid=spec['task_id']
    assert re.fullmatch(r'LEV-CH01-[A-Z0-9.-]+-20260908',tid)
    T=S/'audits'/tid;O=T/'faithfulness';P=O/'orchestration'
    assert not (O/'decision.json').exists() and not (O/'agent_outputs/adjudicator.json').exists()
    assert not (P/(failed_stem+'_final.json')).exists()
    assert not list(P.glob(new_stem+'_*')),'Attempt ID already used'
    original_receipt=read(T/'role-run-receipt.json')
    assert type(original_receipt['exit_code']) is int and original_receipt['exit_code']!=0
    assert sha(T/'role-run-output.txt')==original_receipt['stdout_sha256']
    assert sha(T/'role-run-stderr.txt')==original_receipt['stderr_sha256']
    transport_path=P/(failed_stem+'_transport.json');transport=read(transport_path)
    prompt_path=P/(failed_stem+'_input.txt');prompt=prompt_path.read_bytes()
    events_path=P/(failed_stem+'_events.jsonl')
    events=[decode(line) for line in events_path.read_bytes().splitlines()]
    failed_uid=unstarted_failure(events,(P/(failed_stem+'_stderr.txt')).read_text(),transport,prompt)
    for item in transport['inputs']:
        assert sha(Path(item['path']))==item['sha256']
    images=[Path(x['path']) for x in transport['inputs'] if Path(x['path']).suffix=='.png']
    assert images and [p.name for p in images]==['page-'+p.zfill(3)+'.png' for p in spec['pages'].split(',')]
    exe=Path(transport['command'][0])
    expected=[str(exe),'exec','--ignore-user-config','--skip-git-repo-check','--json','--color','never',
        '-C','C:/Windows/Temp','-s','read-only','-o',str(P/(failed_stem+'_final.json'))]
    # Logical/extended path spellings are allowed only where they resolve to the identical file.
    command=transport['command'];assert command[1:12]==expected[1:12]
    assert Path(command[0]).resolve()==exe.resolve()
    assert Path(command[12]).resolve()==(P/(failed_stem+'_final.json')).resolve()
    tail=command[13:];assert len(tail)==2*len(images)+1 and tail[-1]=='-'
    for index,image in enumerate(images):
        assert tail[2*index]=='-i' and Path(tail[2*index+1]).resolve()==image.resolve()
    prepared=read(T/'role-transport-preflight.json')
    assert prepared['blind_isolation_verified']
    assert sha(T/'role-transport-preflight.json')==original_receipt['prepared_transport_sha256']
    for helper in prepared['helpers']:
        assert sha(P/helper['file'])==helper['successor_sha256']
    manifest=read(O/'manifest.json');runs=read(O/'agent_outputs/agent_runs.json')
    assert runs['task_id']==tid
    assert {x['role'] for x in runs['runs']}=={'source-contract','blind-translation','direct-judge','roundtrip-judge'}
    assert len(runs['runs'])==4 and len({x['agent_id'] for x in runs['runs']})==4
    compact,mapping=deduplicate(prompt,transport['inputs'])
    assert mapping['compact_characters']<=LIMIT,'Lossless transport still exceeds native input limit'
    static=[spec_path,T/'audit-task.json',T/'role-run-receipt.json',T/'role-run-output.txt',
        T/'role-run-stderr.txt',T/'role-transport-preflight.json',transport_path,prompt_path,
        events_path,P/(failed_stem+'_stderr.txt'),P/'q.py',P/'r.py',P/'c.py',exe,
        S/'unblock-nine-20260908'/(tid+'.config.json'),SHIM,Path(__file__),
        R.parent/'workflow-v5.0.1-local/run_workflow_posix.py']
    static += [Path(item['path']) for item in transport['inputs']]
    static += list((R/'.faithfulness-audit/scripts').glob('*.py'))
    static += list((R/'.faithfulness-audit/schemas').glob('*.json'))
    static += [p for p in (R/'.faithfulness-audit/templates').rglob('*') if p.is_file()]
    dedup={str(p.resolve()):ref(p) for p in static}
    destination=destination.resolve()
    assert destination.is_relative_to(D.resolve()) and destination!=D.resolve()
    destination.mkdir()
    create(destination/'input.txt',compact)
    snapshot(O/'manifest.json',destination,'manifest-before.json')
    snapshot(O/'agent_outputs/agent_runs.json',destination,'agent-runs-before.json')
    plan={'format':'lossless-adjudicator-recovery-plan-1','task_id':tid,'pages':spec['pages'],
        'failed_stem':failed_stem,'new_stem':new_stem,'failed_thread_id':failed_uid,
        'original_role_run_exit_code':original_receipt['exit_code'],
        'prepared_at_utc':now(),'static_inputs':list(dedup.values()),
        'original_transport':ref(transport_path),'original_input':ref(prompt_path),
        'input':ref(destination/'input.txt'),'mapping':mapping,
        'manifest_before':ref(destination/'manifest-before.json'),
        'agent_runs_before':ref(destination/'agent-runs-before.json'),
        'collector':ref(P/'c.py'),'runner':ref(Path(__file__)),
        'source_config':ref(S/'unblock-nine-20260908'/(tid+'.config.json')),
        'native_executable':ref(exe),'source_images':[ref(p) for p in images],
        'role_protocol_changed':False,'roles_invoked':False}
    write(destination/'plan.json',plan)
    print(json.dumps({'plan':ref(destination/'plan.json'),'characters':mapping['compact_characters'],
        'original_characters':mapping['original_characters'],'reconstructed_exactly':True,
        'roles_invoked':False},indent=2))

def execute(plan_path,expected_sha):
    assert sha(plan_path)==expected_sha
    plan=read(plan_path);assert plan['format']=='lossless-adjudicator-recovery-plan-1'
    assert sha(Path(__file__))==plan['runner']['sha256']
    E=plan_path.parent;tid=plan['task_id'];stem=plan['new_stem']
    T=S/'audits'/tid;O=T/'faithfulness';P=O/'orchestration'
    assert not (E/'execution-receipt.json').exists()
    for pin in plan['static_inputs']:verify(pin)
    for key in ['input','manifest_before','agent_runs_before']:verify(plan[key])
    assert (O/'manifest.json').read_bytes()==verify(plan['manifest_before']).read_bytes()
    assert (O/'agent_outputs/agent_runs.json').read_bytes()==verify(plan['agent_runs_before']).read_bytes()
    assert not (O/'decision.json').exists() and not (O/'agent_outputs/adjudicator.json').exists()
    assert not list(P.glob(stem+'_*'))
    original=read(verify(plan['original_transport']))
    expanded=verify(plan['original_input']).read_bytes()
    rebuilt,mapping=deduplicate(expanded,original['inputs'])
    assert rebuilt==verify(plan['input']).read_bytes() and mapping==plan['mapping']
    assert len(rebuilt.decode())<=LIMIT
    wrapper=R.parent/'workflow-v5.0.1-local/run_workflow_posix.py'
    config=verify(plan['source_config'])
    assert config.drive.lower()=='c:'
    env=dict(os.environ,FAITHFULNESS_AUDIT_CONFIG='/c/'+config.as_posix()[3:])
    receipt={'format':'lossless-adjudicator-recovery-execution-1','task_id':tid,'started_at_utc':now(),
        'plan':ref(plan_path),'original_role_run_receipt':ref(T/'role-run-receipt.json'),
        'original_role_run_exit_code':plan['original_role_run_exit_code'],'steps':[],
        'original_attempt_retained':True,'exit_code':2,'guard_error':None}
    before_manifest=read(verify(plan['manifest_before']));before_runs=read(verify(plan['agent_runs_before']))
    def stable():
        for pin in plan['static_inputs']:verify(pin)
    def step(name,command):
        stdout=E/(name+'-output.txt');stderr=E/(name+'-stderr.txt')
        started=now();clock=time.monotonic()
        with stdout.open('xb') as out,stderr.open('xb') as err:
            result=subprocess.run(command,cwd=R,env=env,stdout=out,stderr=err)
        record={'name':name,'command':command,'started_at_utc':started,'completed_at_utc':now(),
            'elapsed_seconds':time.monotonic()-clock,'exit_code':result.returncode,
            'stdout':ref(stdout),'stderr':ref(stderr)}
        write(E/(name+'-exit.json'),record);receipt['steps'].append(record)
        if result.returncode:raise subprocess.CalledProcessError(result.returncode,command)
    try:
        inp=P/(stem+'_input.txt');create(inp,rebuilt)
        command=list(original['command']);command[12]=str(P/(stem+'_final.json'))
        assert command[0]==str(verify(plan['native_executable'])) or Path(command[0]).resolve()==verify(plan['native_executable'])
        meta={k:original[k] for k in ['transport','fork','cwd']}
        meta.update(command=command,stdin_sha256=digest(rebuilt),stdin_bytes=len(rebuilt),
            inputs=original['inputs'],started_at=now(),lossless_recovery_plan=ref(plan_path),
            original_expanded_stdin_sha256=digest(expanded),internal_reference=mapping)
        # Keep the attempt's start and completion metadata separately; never overwrite a prior attempt.
        write(P/(stem+'_transport-start.json'),meta)
        started=now();clock=time.monotonic()
        with (P/(stem+'_events.jsonl')).open('xb') as ev,(P/(stem+'_stderr.txt')).open('xb') as err:
            result=subprocess.run(command,input=rebuilt,stdout=ev,stderr=err,cwd=R,env=env)
        meta.update(completed_at=now(),exit_code=result.returncode)
        write(P/(stem+'_transport.json'),meta)
        receipt['steps'].append({'name':'native-adjudicator','command':command,
            'started_at_utc':started,'completed_at_utc':now(),'elapsed_seconds':time.monotonic()-clock,
            'exit_code':result.returncode,'events':ref(P/(stem+'_events.jsonl')),
            'stderr':ref(P/(stem+'_stderr.txt')),'transport':ref(P/(stem+'_transport.json'))})
        if result.returncode:raise subprocess.CalledProcessError(result.returncode,command)
        events=[decode(x) for x in (P/(stem+'_events.jsonl')).read_bytes().splitlines()]
        threads=[x for x in events if x.get('type')=='thread.started'];assert len(threads)==1
        uid=threads[0]['thread_id']
        assert uid!=plan['failed_thread_id'] and uid not in {x['agent_id'] for x in before_runs['runs']}
        assert sum(x.get('type')=='turn.started' for x in events)==1
        assert sum(x.get('type')=='turn.completed' for x in events)==1
        assert not any(x.get('type') in {'error','turn.failed'} for x in events)
        stable();assert (O/'manifest.json').read_bytes()==verify(plan['manifest_before']).read_bytes()
        step('collect',[sys.executable,'-X','utf8','-B',str(verify(plan['collector'])),tid,stem,'adjudicator','adjudicator.json'])
        stable();run_append(before_runs,read(O/'agent_outputs/agent_runs.json'),uid,plan['failed_thread_id'])
        assert (O/'manifest.json').read_bytes()==verify(plan['manifest_before']).read_bytes()
        completed_roles={str(p):sha(p) for p in [O/'agent_outputs/adjudicator.json',O/'agent_outputs/agent_runs.json']}
        step('finalize',[sys.executable,'-X','utf8','-B',str(wrapper),'.faithfulness-audit/scripts/finalize_audit.py',tid])
        stable();manifest_transition(before_manifest,read(O/'manifest.json'))
        final_manifest=sha(O/'manifest.json')
        step('complete-validation',[sys.executable,'-X','utf8','-B',str(wrapper),'.faithfulness-audit/scripts/validate_audit.py',tid,'--phase','complete'])
        stable();assert sha(O/'manifest.json')==final_manifest
        assert all(sha(Path(p))==h for p,h in completed_roles.items())
        decision=read(O/'decision.json')
        receipt.update(exit_code=0,new_agent_id=uid,decision=ref(O/'decision.json'),
            completed_manifest=ref(O/'manifest.json'),report=ref(O/'report.md'),
            classification=decision['classification'],accepted=decision['accepted'],
            released_complete_validation_exit_code=0,manifest_transition_verified=True)
    except Exception as error:
        receipt['guard_error']=repr(error)
        if isinstance(error,subprocess.CalledProcessError):receipt['exit_code']=error.returncode
    finally:
        receipt['completed_at_utc']=now()
        receipt['actual_steps_completed']=len(receipt['steps'])
        write(E/'execution-receipt.json',receipt)
        print(json.dumps(receipt,indent=2),flush=True)
    return receipt['exit_code']

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    sub=parser.add_subparsers(dest='mode',required=True)
    p=sub.add_parser('prepare');p.add_argument('spec',type=Path);p.add_argument('--failed-stem',default='a')
    p.add_argument('--new-stem',required=True);p.add_argument('--destination',type=Path,required=True)
    p=sub.add_parser('execute');p.add_argument('plan',type=Path);p.add_argument('--plan-sha256',required=True)
    args=parser.parse_args()
    if args.mode=='prepare':prepare(args.spec.resolve(),args.failed_stem,args.new_stem,args.destination);return 0
    return execute(args.plan.resolve(),args.plan_sha256)
if __name__=='__main__':raise SystemExit(main())
