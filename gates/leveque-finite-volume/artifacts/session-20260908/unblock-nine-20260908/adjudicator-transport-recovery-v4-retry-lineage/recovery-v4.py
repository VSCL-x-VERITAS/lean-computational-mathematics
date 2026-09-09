"""Append-only recovery of a recorded input-limit failure before an adjudicator turn.

prepare writes a reviewable plan and lossless transport in a NEW local directory.
execute is separately explicit and uses the existing collector and released finalizer/validator.
"""
from __future__ import annotations
from datetime import datetime, timezone
from pathlib import Path
import argparse
import difflib
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

def compact_json(raw):
    """Remove only JSON whitespace outside strings; preserve every token byte."""
    value=decode(raw)
    result=bytearray();quoted=False;escaped=False
    for char in raw:
        if quoted:
            result.append(char)
            if escaped:escaped=False
            elif char==92:escaped=True
            elif char==34:quoted=False
        elif char==34:
            quoted=True;result.append(char)
        elif char not in b' \t\r\n':result.append(char)
    assert not quoted and not escaped
    result=bytes(result)
    assert decode(result)==value
    return result

def document_header(item):
    return ('\n\n'+item['label']+' SHA256 '+item['sha256']+'\n').encode()

def expand_blind(body,spans,canonical):
    """Resolve references only to the verbatim same-prompt canonical dossier."""
    previous_end=0
    for span in spans:
        start=span['canonical_start_byte'];end=span['canonical_end_byte_exclusive']
        assert type(start) is int and type(end) is int and 0<=start<end<=len(canonical)
        assert span['blind_start_byte']>=previous_end
        assert span['blind_end_byte_exclusive']-span['blind_start_byte']==end-start
        previous_end=span['blind_end_byte_exclusive']
        exact=canonical[start:end]
        assert digest(exact)==span['sha256']
        marker=span['marker_utf8'].encode()
        assert body.count(marker)==1,'Missing or repeated internal reference'
        body=body.replace(marker,exact,1)
    return body

def reconstruct(compact,mapping,inputs):
    """Independently restore reference bytes and original pinned JSON formatting."""
    by_name={Path(x['path']).name:x for x in inputs}
    canonical_item=by_name['declaration_dossier.md']
    canonical=Path(canonical_item['path']).read_bytes()
    assert digest(canonical)==canonical_item['sha256']
    assert compact.count(document_header(canonical_item)+canonical)==1
    previous_end=0
    for item in mapping['transformed_documents']:
        start=item['rendered_start_byte'];end=item['rendered_end_byte_exclusive']
        assert type(start) is int and type(end) is int and previous_end<=start<end<=len(compact)
        previous_end=end
    expanded=compact
    for item in reversed(mapping['transformed_documents']):
        pin=item['input'];raw=Path(pin['path']).read_bytes()
        assert digest(raw)==pin['sha256'] and len(raw)==pin['bytes']
        start=item['rendered_start_byte'];end=item['rendered_end_byte_exclusive']
        body=compact[start:end]
        assert digest(body)==item['rendered_sha256']
        if item['representation']=='exact same-prompt canonical document span':
            assert body==item['marker_utf8'].encode()
            restored=canonical[item['canonical_start_byte']:item['canonical_end_byte_exclusive']]
        elif item['representation']=='exact same-prompt canonical line spans':
            restored=expand_blind(body,item['spans'],canonical)
        elif item['representation']=='JSON whitespace only':
            assert compact_json(raw)==body and decode(raw)==decode(body)
            restored=raw
        else:raise AssertionError('Unknown reconstruction operation')
        assert restored==raw,'Reconstructed document differs from original bytes'
        expanded=expanded[:start]+restored+expanded[end:]
    assert digest(expanded)==mapping['original_prompt_sha256']
    return expanded

def deduplicate(prompt,inputs):
    """Exact duplicate spans plus JSON formatting only; no semantic projection."""
    names=[Path(x['path']).name for x in inputs]
    assert len(names)==len(set(names)),'Duplicate input document names'
    by_name={Path(x['path']).name:x for x in inputs}
    target=by_name['direct_review_packet.md'];container=by_name['declaration_dossier.md']
    blind_item=by_name['blind_dossier.md']
    bodies={}
    for item in inputs:
        path=Path(item['path']);raw=path.read_bytes()
        assert len(raw)==item['bytes'] and digest(raw)==item['sha256']
        if path.suffix in ('.md','.json'):
            assert prompt.count(document_header(item)+raw)==1,'Input document is not exact and unique'
            bodies[path.name]=raw
            if path.suffix=='.json':decode(raw)
    whole=bodies['declaration_dossier.md'];body=bodies['direct_review_packet.md']
    blind=bodies['blind_dossier.md']
    assert whole.count(body)==1,'Direct packet is not one exact contiguous dossier span'
    start=whole.index(body);end=start+len(body)
    assert prompt.index(document_header(target)+body)<prompt.index(document_header(container)+whole)
    assert prompt.index(document_header(container)+whole)<prompt.index(document_header(blind_item)+blind)
    assert b'[INTERNAL DD ' not in prompt and b'[LOSSLESS TRANSPORT NOTICE' not in prompt
    marker=("\n[LOSSLESS TRANSPORT NOTICE — SAME-PROMPT REFERENCES, NO TOOLS]\n"
        "DD denotes the complete direct declaration dossier supplied verbatim below, beginning "
        "at its first document byte (not at its prompt header). Its original SHA256 is "
        f"{container['sha256']}. This complete direct review packet is its exact UTF-8 byte "
        f"range [{start},{end}), original SHA256 {target['sha256']}. Read that same supplied "
        "content for this packet. In the later blind dossier, [INTERNAL DD start:end SHA256 hash] "
        "means the exact indicated DD bytes also occur at that location; read them as part of "
        "the blind dossier. Every unique Markdown byte is retained, and each referenced byte "
        "is present verbatim in DD in this same prompt. Native reconstruction verifies both "
        "complete original dossiers and the entire expanded prompt byte-for-byte. JSON documents "
        "may have formatting whitespace outside strings removed; every token, value, string "
        "escape and number byte is unchanged, duplicate keys are rejected, and parsed values "
        "are verified equal. Original header hashes identify the original documents, before "
        "these transport substitutions. All source images and other evidence are unchanged. "
        "The native role remains one turn and tool-free. Inspect the full evidence independently; "
        "these references supply no judgment or desired verdict.\n"
        "[END LOSSLESS TRANSPORT NOTICE]\n").encode()
    assert marker not in prompt
    compact=prompt.replace(document_header(target)+body,document_header(target)+marker,1)
    changes=[{'input':target,'representation':'exact same-prompt canonical document span',
        'canonical_start_byte':start,'canonical_end_byte_exclusive':end,'marker_utf8':marker.decode()}]
    rendered={target['path']:marker}
    # Match only byte-identical complete lines. No anonymized-name or semantic matching.
    aa=whole.splitlines(keepends=True);bb=blind.splitlines(keepends=True)
    ao=[0];bo=[0]
    for line in aa:ao.append(ao[-1]+len(line))
    for line in bb:bo.append(bo[-1]+len(line))
    spans=[];parts=[];cursor=0
    for block in difflib.SequenceMatcher(None,aa,bb,autojunk=False).get_matching_blocks():
        if not block.size:continue
        a,z=ao[block.a],ao[block.a+block.size];b,y=bo[block.b],bo[block.b+block.size]
        exact=whole[a:z]
        assert exact==blind[b:y]
        token=('\n[INTERNAL DD '+str(a)+':'+str(z)+' SHA256 '+digest(exact)+']\n').encode()
        if len(exact.decode())<=len(token.decode()):continue
        assert token not in prompt and all(x['marker_utf8']!=token.decode() for x in spans)
        parts.extend([blind[cursor:b],token]);cursor=y
        spans.append({'blind_start_byte':b,'blind_end_byte_exclusive':y,
            'canonical_start_byte':a,'canonical_end_byte_exclusive':z,
            'sha256':digest(exact),'marker_utf8':token.decode()})
    parts.append(blind[cursor:]);represented_blind=b''.join(parts)
    assert expand_blind(represented_blind,spans,whole)==blind
    if spans:
        compact=compact.replace(document_header(blind_item)+blind,
            document_header(blind_item)+represented_blind,1)
        changes.append({'input':blind_item,'representation':'exact same-prompt canonical line spans','spans':spans})
        rendered[blind_item['path']]=represented_blind
    json_checks=[]
    for item in inputs:
        if Path(item['path']).suffix!='.json':continue
        raw=bodies[Path(item['path']).name];small=compact_json(raw)
        assert compact.count(document_header(item)+raw)==1
        compact=compact.replace(document_header(item)+raw,document_header(item)+small,1)
        changes.append({'input':item,'representation':'JSON whitespace only'})
        rendered[item['path']]=small
        json_checks.append({'input':item,'compact_sha256':digest(small),'parsed_equal':True,
            'all_nonformatting_bytes_unchanged':True,'duplicate_keys_rejected':True})
    for change in changes:
        raw=rendered[change['input']['path']];header=document_header(change['input'])
        assert compact.count(header+raw)==1
        begin=compact.index(header+raw)+len(header)
        change.update(rendered_start_byte=begin,rendered_end_byte_exclusive=begin+len(raw),
            rendered_sha256=digest(raw))
    changes.sort(key=lambda x:x['rendered_start_byte'])
    mapping={'format':'exact-duplicate-spans-and-json-whitespace-3','container':container,
        'original_prompt_sha256':digest(prompt),'compact_prompt_sha256':digest(compact),
        'original_characters':len(prompt.decode()),'compact_characters':len(compact.decode()),
        'character_limit':LIMIT,'transformed_documents':changes,'json_checks':json_checks,
        'blind_reference_count':len(spans),'blind_referenced_bytes':sum(
            x['canonical_end_byte_exclusive']-x['canonical_start_byte'] for x in spans),
        'every_unique_markdown_byte_retained':True,'canonical_dossier_verbatim':True,
        'reconstruction_byte_equal':True}
    assert reconstruct(compact,mapping,inputs)==prompt
    for item in inputs:
        name=Path(item['path']).name
        if Path(item['path']).suffix=='.md' and name not in ('direct_review_packet.md','blind_dossier.md'):
            assert compact.count(document_header(item)+bodies[name])==1
    return compact,mapping


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

RETRY_TASK='LEV-CH01-LOCAL-RIEMANN-ROUTINE-INTERFACE-PRODUCTION-20260908'
RETRY_PLAN_SHA='ac548be03bbd75ea7d4666d05f24b0f1204f109216a7581e1ee0defb7fb90a4d'
RETRY_PREPARATION_SHA='f9455150ed1454b9412f6988f38e0d0ffb122477b9b55b32ce241d78e3b3b539'
RETRY_HELPER_SHA='8873eeca945581e221d473174aecc0149554698cb44e0068dd5e8f1dfe61759e'

def retry_history(before,after,failed_uid,new_uid):
    assert len(before['runs'])==4 and len({x['agent_id'] for x in before['runs']})==4
    assert [x['role'] for x in before['runs']]==['source-contract','blind-translation','direct-judge','roundtrip-judge']
    assert before['runs'][-1]['agent_id']==failed_uid
    assert {k:v for k,v in before.items() if k!='runs'}=={k:v for k,v in after.items() if k!='runs'}
    assert after['runs'][:-1]==before['runs'] and len(after['runs'])==5
    added=after['runs'][-1]
    assert added['role']=='roundtrip-judge' and added['agent_id']==new_uid
    assert new_uid not in {x['agent_id'] for x in before['runs']}

def continuation_contract(execution,continuation,original):
    assert execution['format']=='malformed-roundtrip-recovery-execution-1'
    assert execution['task_id']==RETRY_TASK
    assert execution['original_wrapper_exit_code']==original['exit_code']==1
    assert execution['canonical_collection_performed'] is True
    assert type(execution['exit_code']) is int and execution['exit_code']!=0
    assert [x['name'] for x in execution['steps']]==['collect-r2','continuation']
    assert execution['steps'][0]['exit_code']==0
    assert execution['steps'][1]==continuation
    assert execution['exit_code']==continuation['exit_code']!=0
    assert isinstance(execution['guard_error'],str) and execution['guard_error']
    assert original['stdout_sha256']=='50a2105fdfba5e3e1219e08d79325bdaf2526f0b3c1068b5351396b726d9089e'
    assert original['stderr_sha256']=='f296ccb7e8a28efa15248ff685134d75f89043f78670fc4541668154a3943c1a'

def retry_lineage(tid,runs):
    """Require the exact completed malformed-output handoff and its NEW failure.

    This never relabels the original schema failure as an input-limit failure.
    The separate ordinary unstarted_failure guard checks the actual a_* evidence.
    """
    assert tid==RETRY_TASK
    F=S/'unblock-nine-20260908/riemann-routine-roundtrip-retry'
    E=F/'handoff-plan';T=S/'audits'/tid;O=T/'faithfulness';P=O/'orchestration'
    assert sha(F/'receipt.json')==RETRY_PREPARATION_SHA
    assert sha(E/'plan.json')==RETRY_PLAN_SHA
    assert sha(F/'recover.py')==RETRY_HELPER_SHA
    plan=read(E/'plan.json');execution=read(E/'execution-receipt.json')
    continuation=read(E/'continuation-exit.json');original=read(T/'role-run-receipt.json')
    continuation_contract(execution,continuation,original)
    assert execution['plan']==ref(E/'plan.json')
    assert execution['original_role_run_receipt']==ref(T/'role-run-receipt.json')
    assert execution['new_runtime']==ref(P/'r2_runtime.json')
    assert execution['new_canonical']==ref(O/'agent_outputs/roundtrip_judge.json')
    assert execution['agent_runs_after_retry']==ref(E/'agent-runs-after-r2.json')
    assert execution['invalid_canonical_archive']==ref(E/'invalid-canonical-archived.json')
    assert (E/'invalid-canonical-archived.json').read_bytes()==verify(plan['invalid_canonical_before']).read_bytes()==(P/'r_final.json').read_bytes()
    assert sha(P/'r_final.json')=='9a7140d20fa162a9a00d71127fb5c9c64822c8e7dee432e3cf90f75dbf0cf7e4'
    assert (O/'agent_outputs/roundtrip_judge.json').read_bytes()==verify(plan['new_output']).read_bytes()
    assert (O/'manifest.json').read_bytes()==verify(plan['manifest_before']).read_bytes()
    before=read(verify(plan['agent_runs_before']));after=read(E/'agent-runs-after-r2.json')
    assert (O/'agent_outputs/agent_runs.json').read_bytes()==(E/'agent-runs-after-r2.json').read_bytes()
    assert runs==after
    retry_history(before,after,plan['prior_invalid_agent_id'],plan['new_agent_id'])
    assert read(P/'r2_runtime.json')['agent_id']==plan['new_agent_id']
    for pin in plan['static_inputs']:verify(pin)
    for key in ('manifest_before','agent_runs_before','invalid_canonical_before','new_output'):verify(plan[key])
    for step in execution['steps']:
        verify(step['stdout']);verify(step['stderr'])
    command=continuation['command']
    assert len(command)==8 and command[1:4]==['-X','utf8','-B']
    assert Path(command[4]).resolve()==(P/'q.py').resolve()
    assert command[5:]==[tid,'26,27,28','2']
    assert read(E/'collect-r2-exit.json')==execution['steps'][0]
    # The unchanged q must have validated all current canonical roles and reached
    # its real adjudication boundary before the failed a_* attempt.
    boundaries=[]
    for line in verify(continuation['stdout']).read_bytes().splitlines():
        try:value=decode(line)
        except (ValueError,UnicodeError):continue
        if isinstance(value,dict) and 'boundary' in value:boundaries.append(value)
    assert [x['role'] for x in boundaries if x['boundary']=='role_validated']==['source-contract','blind-translation','direct-judge','roundtrip-judge']
    checks=[x for x in boundaries if x['boundary']=='adjudication_check']
    assert len(checks)==1 and checks[0]['task']==tid
    assert checks[0]['triggers']==read(P/'adjudication_triggers.json')
    assert checks[0]['triggers']['required'] is True
    pins=list(plan['static_inputs'])
    paths=[F/'receipt.json',F/'recover.py',E/'plan.json',E/'execution-receipt.json',
        E/'execution-started.json',E/'continuation-exit.json',E/'collect-r2-exit.json',
        E/'agent-runs-after-r2.json',E/'invalid-canonical-archived.json',P/'r2_runtime.json',
        O/'agent_outputs/roundtrip_judge.json',P/'adjudication_triggers.json']
    paths += [verify(plan[key]) for key in ('manifest_before','agent_runs_before','invalid_canonical_before','new_output')]
    paths += [verify(step[key]) for step in execution['steps'] for key in ('stdout','stderr')]
    pins += [ref(path) for path in paths]
    return {'format':'exact-info-roundtrip-retry-lineage-1',
        'original_schema_failure_receipt':ref(T/'role-run-receipt.json'),
        'actual_continuation_failure_receipt':ref(E/'continuation-exit.json'),
        'handoff_execution_receipt':ref(E/'execution-receipt.json'),
        'prior_invalid_roundtrip_agent_id':plan['prior_invalid_agent_id'],
        'valid_roundtrip_retry_agent_id':plan['new_agent_id'],
        'original_schema_failure_preserved':True,
        'pins':list({x['path']:x for x in pins}.values())}


def prepare(spec_path,failed_stem,new_stem,destination):
    assert re.fullmatch(r'a(?:[2-9][0-9]*)?',failed_stem)
    assert re.fullmatch(r'a[2-9][0-9]*',new_stem) and failed_stem!=new_stem
    assert int(new_stem[1:])>int(failed_stem[1:] or 1)
    spec=read(spec_path);tid=spec['task_id']
    assert tid==RETRY_TASK and failed_stem=='a' and new_stem=='a2'
    assert re.fullmatch(r'LEV-CH01-[A-Z0-9.-]+-20260908',tid)
    T=S/'audits'/tid;O=T/'faithfulness';P=O/'orchestration'
    assert not (O/'decision.json').exists() and not (O/'agent_outputs/adjudicator.json').exists()
    assert not (P/(failed_stem+'_final.json')).exists()
    assert not [p for p in P.iterdir() if p.name.startswith(new_stem+'_')],'Attempt ID already used'
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
    assert manifest['status']=='prepared'
    assert runs['task_id']==tid
    assert {x['role'] for x in runs['runs']}=={'source-contract','blind-translation','direct-judge','roundtrip-judge'}
    lineage=retry_lineage(tid,runs)
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
    static += [verify(pin) for pin in lineage['pins']]
    dedup={str(p.resolve()):ref(p) for p in static}
    destination=destination.resolve()
    assert destination.is_relative_to(D.resolve()) and destination!=D.resolve()
    destination.mkdir()
    create(destination/'input.txt',compact)
    snapshot(O/'manifest.json',destination,'manifest-before.json')
    snapshot(O/'agent_outputs/agent_runs.json',destination,'agent-runs-before.json')
    plan={'format':'lossless-adjudicator-retry-lineage-plan-1','task_id':tid,'pages':spec['pages'],
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
        'role_protocol_changed':False,'roles_invoked':False,'retry_lineage':lineage}
    write(destination/'plan.json',plan)
    print(json.dumps({'plan':ref(destination/'plan.json'),'characters':mapping['compact_characters'],
        'original_characters':mapping['original_characters'],'reconstructed_exactly':True,
        'roles_invoked':False},indent=2))

def execute(plan_path,expected_sha):
    assert sha(plan_path)==expected_sha
    plan=read(plan_path);assert plan['format']=='lossless-adjudicator-retry-lineage-plan-1'
    assert sha(Path(__file__))==plan['runner']['sha256']
    E=plan_path.parent;tid=plan['task_id'];stem=plan['new_stem']
    T=S/'audits'/tid;O=T/'faithfulness';P=O/'orchestration'
    assert not (E/'execution-receipt.json').exists()
    for pin in plan['static_inputs']:verify(pin)
    for key in ['input','manifest_before','agent_runs_before']:verify(plan[key])
    assert (O/'manifest.json').read_bytes()==verify(plan['manifest_before']).read_bytes()
    assert (O/'agent_outputs/agent_runs.json').read_bytes()==verify(plan['agent_runs_before']).read_bytes()
    assert not (O/'decision.json').exists() and not (O/'agent_outputs/adjudicator.json').exists()
    assert not [p for p in P.iterdir() if p.name.startswith(stem+'_')]
    assert retry_lineage(tid,read(O/'agent_outputs/agent_runs.json'))==plan['retry_lineage']
    original=read(verify(plan['original_transport']))
    expanded=verify(plan['original_input']).read_bytes()
    rebuilt,mapping=deduplicate(expanded,original['inputs'])
    assert rebuilt==verify(plan['input']).read_bytes() and mapping==plan['mapping']
    assert len(rebuilt.decode())<=LIMIT
    wrapper=R.parent/'workflow-v5.0.1-local/run_workflow_posix.py'
    config=verify(plan['source_config'])
    assert config.drive.lower()=='c:'
    env=dict(os.environ,FAITHFULNESS_AUDIT_CONFIG='/c/'+config.as_posix()[3:])
    receipt={'format':'lossless-adjudicator-retry-lineage-execution-1','task_id':tid,'started_at_utc':now(),
        'plan':ref(plan_path),'original_role_run_receipt':ref(T/'role-run-receipt.json'),
        'original_role_run_exit_code':plan['original_role_run_exit_code'],'steps':[],
        'original_attempt_retained':True,'exit_code':2,'guard_error':None,
        'actual_continuation_failure_receipt':plan['retry_lineage']['actual_continuation_failure_receipt'],
        'retry_lineage':plan['retry_lineage']}
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
